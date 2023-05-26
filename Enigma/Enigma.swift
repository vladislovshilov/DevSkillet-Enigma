//
//  Enigma.swift
//  Enigma
//
//

import Foundation

enum Day: String, CaseIterable {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, Unknown
}

struct Enigma {
    
    var crypto = [String: String]()
    
    init() {} //DO NOT MODIFY THE INITIALIZER
    
    // MARK: - TASK 1
    // Get the current day name in the form of the enumeration above. Example: "Tuesday" would be Day.Tuesday
    func getCurrentDay() -> Day {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let currentDate = Date()
        let currentDay = dateFormatter.string(from: currentDate)

        return Day(rawValue: currentDay) ?? .Unknown
    }
    
    // MARK: - TASK 2
    // Load the corresponding encryption keys for the current day from the "DAY_NAME.TXT" file. For example:
    // for Wednesday you would need to load wednesday.txt.
    // Once loaded parse the keys and fill the 'crypto' dictionary with alphabet letters as the keys and their
    // encrypted representations as the values.
    
    mutating func loadEncryptionKeys(for day: Day) {
        if let fileURL = Bundle.main.url(forResource: day.rawValue, withExtension: "txt") {
            do {
                let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
                let lines = fileContents.components(separatedBy: .newlines)
                
                for line in lines {
                    let component = line.components(separatedBy: ";")
                    if component.count == 2 {
                        let letter = component[0]
                        let encodingKey = component[1]
                        crypto[letter] = encodingKey
                    } else {
                        print("Error parsing file")
                    }
                }
            } catch {
                // Error handling
                print("Error reading file: \(error)")
            }
        } else {
            print("File not found.")
        }
    }
    
    // MARK: - TASK 3
    // Fill out the encryption function below which accepts a String and returns an encrypted version of that
    // String. Each letter of the String should be encrypted using the encryption keys. Exmaple letter 'a' could be
    // encrypted as 'de4' depending on todays Day and the keys loaded.
    // Example if the method gets the word 'Hello' passed in it should return the encrypted version which could be
    // 'lzxpasbvcbvcgf3' depending on todays Day and the keys loaded.
    // Remember that letters need to be lowercase before encrypting.
    // Remember that the space character needs to be encrypted using the '-' key from crypto keys.
    // Please note that the characters that are allowed to be encrypted are only:
    // 'abcdefghijklmnopqrstuvwxyz0123456789 ' you should ignore any other characters that are passed in.
    // Example Devsk..iller should only encrypt 'devskiller' and ignore the .. in the middle.
    
    mutating func encrypt(message: String) -> String {
        let encryptedChars = message.map { character -> String in
            let letter = String(character.lowercased())
            if let encodingKey = crypto[letter] {
                return encodingKey
            }
            return letter
        }
        return encryptedChars.joined()
    }
    
    // MARK: - TASK 4
    // Fill out the decryption function below which accepts a String which is already encrypted using todays keys.
    // Every three character of the String is one letter in the decrypted String. Example: 'de4' could be the
    // letter 'a' depending on todays Day and the keys loaded.
    // Remember that the space character needs to be changed from '-' to ' '
    // Remember that letters need to be lowercase before decrypting.
    
    func decrypt(message: String) -> String {
        let decryptedChars = stride(from: 0, to: message.count, by: 3).map { index -> String in
            let startIndex = message.index(message.startIndex, offsetBy: index)
            let endIndex = message.index(startIndex, offsetBy: 3, limitedBy: message.endIndex) ?? message.endIndex
            let encryptedLetter = String(message[startIndex..<endIndex])
            
            if encryptedLetter == "---" {
                return " "
            }
            
            let decryptedLetter = crypto.getKey(for: encryptedLetter.lowercased()) ?? encryptedLetter
            return decryptedLetter
        }
        return decryptedChars.joined()
    }
    
}

