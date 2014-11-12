Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672AbaKLEbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:31:50 -0500
Received: from mail.eperm.de ([89.247.134.16]:54351 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaKLEbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:31:48 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marek Vasut <marex@denx.de>, "David S. Miller" <davem@davemloft.net>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "Joy M. Latten" <jmlatten@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 12/13] crypto: Documentation - CIPHER API documentation
Date: Wed, 12 Nov 2014 05:30:06 +0100
Message-ID: <2142029.lWC3fkng5E@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1800066.efQ8hkST4U@tachyon.chronox.de>
References: <1800066.efQ8hkST4U@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API function calls exported by the kernel crypto API for
signle block ciphers to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/crypto.h | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index c9ebe45..0f95a07 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -1900,6 +1900,23 @@ static inline void crypto_blkcipher_get_iv(struct crypto_blkcipher *tfm,
 	memcpy(dst, crypto_blkcipher_crt(tfm)->iv, len);
 }
 
+/**
+ * DOC: Single Block Cipher API
+ *
+ * The single block cipher API is used with the ciphers of type
+ * CRYPTO_ALG_TYPE_CIPHER (listed as type "cipher" in /proc/crypto).
+ *
+ * Using the single block cipher API calls, operations with the basic cipher
+ * primitive can be implemented. These cipher primitives exclude any block
+ * chaining operations including IV handling.
+ *
+ * The purpose of this single block cipher API is to support the implementation
+ * of templates or other concepts that only need to perform the cipher operation
+ * on one block at a time. Templates invoke the underlying cipher primitive
+ * block-wise and process either the input or the output data of these cipher
+ * operations.
+ */
+
 static inline struct crypto_cipher *__crypto_cipher_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_cipher *)tfm;
@@ -1911,6 +1928,20 @@ static inline struct crypto_cipher *crypto_cipher_cast(struct crypto_tfm *tfm)
 	return __crypto_cipher_cast(tfm);
 }
 
+/**
+ * crypto_alloc_cipher() - allocate single block cipher handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	     single block cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for a single block cipher. The returned struct
+ * crypto_cipher is the cipher handle that is required for any subsequent API
+ * invocation for that single block cipher.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
 static inline struct crypto_cipher *crypto_alloc_cipher(const char *alg_name,
 							u32 type, u32 mask)
 {
@@ -1926,11 +1957,25 @@ static inline struct crypto_tfm *crypto_cipher_tfm(struct crypto_cipher *tfm)
 	return &tfm->base;
 }
 
+/**
+ * crypto_free_cipher() - zeroize and free the single block cipher handle
+ * @tfm: cipher handle to be freed
+ */
 static inline void crypto_free_cipher(struct crypto_cipher *tfm)
 {
 	crypto_free_tfm(crypto_cipher_tfm(tfm));
 }
 
+/**
+ * crypto_has_cipher() - Search for the availability of a single block cipher
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	     single block cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Return: true when the single block cipher is known to the kernel crypto API;
+ *	   false otherwise
+ */
 static inline int crypto_has_cipher(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
@@ -1945,6 +1990,16 @@ static inline struct cipher_tfm *crypto_cipher_crt(struct crypto_cipher *tfm)
 	return &crypto_cipher_tfm(tfm)->crt_cipher;
 }
 
+/**
+ * crypto_cipher_blocksize() - obtain block size for cipher
+ * @tfm: cipher handle
+ *
+ * The block size for the single block cipher referenced with the cipher handle
+ * tfm is returned. The caller may use that information to allocate appropriate
+ * memory for the data returned by the encryption or decryption operation
+ *
+ * Return: block size of cipher
+ */
 static inline unsigned int crypto_cipher_blocksize(struct crypto_cipher *tfm)
 {
 	return crypto_tfm_alg_blocksize(crypto_cipher_tfm(tfm));
@@ -1972,6 +2027,22 @@ static inline void crypto_cipher_clear_flags(struct crypto_cipher *tfm,
 	crypto_tfm_clear_flags(crypto_cipher_tfm(tfm), flags);
 }
 
+/**
+ * crypto_cipher_setkey() - set key for cipher
+ * @tfm: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the single block cipher referenced by the
+ * cipher handle.
+ *
+ * Note, the key length determines the cipher type. Many block ciphers implement
+ * different cipher modes depending on the key size, such as AES-128 vs AES-192
+ * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
+ * is performed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
 static inline int crypto_cipher_setkey(struct crypto_cipher *tfm,
                                        const u8 *key, unsigned int keylen)
 {
@@ -1979,6 +2050,15 @@ static inline int crypto_cipher_setkey(struct crypto_cipher *tfm,
 						  key, keylen);
 }
 
+/**
+ * crypto_cipher_encrypt_one() - encrypt one block of plaintext
+ * @tfm: cipher handle
+ * @dst: points to the buffer that will be filled with the ciphertext
+ * @src: buffer holding the plaintext to be encrypted
+ *
+ * Invoke the encryption operation of one block. The caller must ensure that
+ * the plaintext and ciphertext buffers are at least one block in size.
+ */
 static inline void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
 					     u8 *dst, const u8 *src)
 {
@@ -1986,6 +2066,15 @@ static inline void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
 						dst, src);
 }
 
+/**
+ * crypto_cipher_decrypt_one() - decrypt one block of ciphertext
+ * @tfm: cipher handle
+ * @dst: points to the buffer that will be filled with the plaintext
+ * @src: buffer holding the ciphertext to be decrypted
+ *
+ * Invoke the decryption operation of one block. The caller must ensure that
+ * the plaintext and ciphertext buffers are at least one block in size.
+ */
 static inline void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 					     u8 *dst, const u8 *src)
 {
-- 
2.1.0


