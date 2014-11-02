Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaKBUqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:46:39 -0500
Received: from mail.eperm.de ([89.247.134.16]:54177 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbaKBUng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:43:36 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 10/11] crypto: Documentation - CIPHER API documentation
Date: Sun, 02 Nov 2014 21:41:31 +0100
Message-ID: <41618572.G207XpxMT8@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <6375771.bx7QqLJLuR@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API function calls exported by the kernel crypto API for
signle block ciphers to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
CC: Marek Vasut <marex@denx.de>
---
 include/linux/crypto.h | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ff15057..b2c3ebb 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -2008,6 +2008,21 @@ static inline void crypto_blkcipher_get_iv(struct crypto_blkcipher *tfm,
 	memcpy(dst, crypto_blkcipher_crt(tfm)->iv, len);
 }
 
+/**
+ * Single block cipher API to use the ciphers of type CRYPTO_ALG_TYPE_CIPHER
+ * (listed as type "cipher" in /proc/crypto)
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
@@ -2019,6 +2034,20 @@ static inline struct crypto_cipher *crypto_cipher_cast(struct crypto_tfm *tfm)
 	return __crypto_cipher_cast(tfm);
 }
 
+/**
+ * Allocate a cipher handle for a single block cipher. The returned struct
+ * crypto_cipher is the cipher handle that is required for any subsequent API
+ * invocation for that single block cipher.
+ *
+ * @alg_name is the cra_name / name or cra_driver_name / driver name of the
+ *	     single block cipher
+ * @type specifies the type of the cipher (see Documentation/crypto/)
+ * @mask specifies the mask for the cipher (see Documentation/crypto/)
+ *
+ * return value:
+ *	allocated cipher handle in case of success
+ *	IS_ERR() is true in case of an error, PTR_ERR() returns the error code.
+ */
 static inline struct crypto_cipher *crypto_alloc_cipher(const char *alg_name,
 							u32 type, u32 mask)
 {
@@ -2034,11 +2063,28 @@ static inline struct crypto_tfm *crypto_cipher_tfm(struct crypto_cipher *tfm)
 	return &tfm->base;
 }
 
+/**
+ * The referenced single block cipher handle is zeroized and subsequently freed.
+ *
+ * @tfm cipher handle to be freed
+ */
 static inline void crypto_free_cipher(struct crypto_cipher *tfm)
 {
 	crypto_free_tfm(crypto_cipher_tfm(tfm));
 }
 
+/**
+ * Lookup function to search for the availability of a given cipher.
+ *
+ * @alg_name is the cra_name / name or cra_driver_name / driver name of the
+ *	     single block cipher
+ * @type specifies the type of the cipher (see Documentation/crypto/)
+ * @mask specifies the mask for the cipher (see Documentation/crypto/)
+
+ * return value:
+ *	true when the single block  cipher is known to the kernel crypto API.
+ *	false otherwise
+ */
 static inline int crypto_has_cipher(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
@@ -2053,6 +2099,16 @@ static inline struct cipher_tfm *crypto_cipher_crt(struct crypto_cipher *tfm)
 	return &crypto_cipher_tfm(tfm)->crt_cipher;
 }
 
+/**
+ * The block size for the single block cipher referenced with the cipher handle
+ * tfm is returned. The caller may use that information to allocate appropriate
+ * memory for the data returned by the encryption or decryption operation
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ * 	block size of cipher
+ */
 static inline unsigned int crypto_cipher_blocksize(struct crypto_cipher *tfm)
 {
 	return crypto_tfm_alg_blocksize(crypto_cipher_tfm(tfm));
@@ -2080,6 +2136,23 @@ static inline void crypto_cipher_clear_flags(struct crypto_cipher *tfm,
 	crypto_tfm_clear_flags(crypto_cipher_tfm(tfm), flags);
 }
 
+/**
+ * The caller provided key is set for the single block cipher referenced by the
+ * cipher handle.
+ *
+ * Note, the key length determines the cipher type. Many block ciphers implement
+ * different cipher modes depending on the key size, such as AES-128 vs AES-192
+ * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
+ * is performed.
+ *
+ * @tfm cipher handle
+ * @key buffer holding the key
+ * @keylen length of the key in bytes
+ *
+ * return value:
+ *	0 if the setting of the key was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_cipher_setkey(struct crypto_cipher *tfm,
                                        const u8 *key, unsigned int keylen)
 {
@@ -2087,6 +2160,14 @@ static inline int crypto_cipher_setkey(struct crypto_cipher *tfm,
 						  key, keylen);
 }
 
+/**
+ * Invoke the encryption operation of one block. The caller must ensure that
+ * the plaintext and ciphertext buffers are at least one block in size.
+ *
+ * @tfm cipher handle
+ * @dst points to the buffer that will be filled with the ciphertext
+ * @src buffer holding the plaintext to be encrypted
+ */
 static inline void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
 					     u8 *dst, const u8 *src)
 {
@@ -2094,6 +2175,14 @@ static inline void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
 						dst, src);
 }
 
+/**
+ * Invoke the decryption operation of one block. The caller must ensure that
+ * the plaintext and ciphertext buffers are at least one block in size.
+ *
+ * @tfm cipher handle
+ * @dst points to the buffer that will be filled with the plaintext
+ * @src buffer holding the ciphertext to be decrypted
+ */
 static inline void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 					     u8 *dst, const u8 *src)
 {
-- 
2.1.0


