Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbaKLEb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:31:56 -0500
Received: from mail.eperm.de ([89.247.134.16]:54359 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685AbaKLEby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:31:54 -0500
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
Subject: [PATCH v3 11/13] crypto: Documentation - BLKCIPHER API documentation
Date: Wed, 12 Nov 2014 05:29:36 +0100
Message-ID: <6409592.Z4CGXIjJk1@tachyon.chronox.de>
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
synchronous block ciphers to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/crypto.h | 188 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 4704e71..c9ebe45 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -1565,6 +1565,36 @@ static inline void aead_request_set_assoc(struct aead_request *req,
 	req->assoclen = assoclen;
 }
 
+/**
+ * DOC: Synchronous Block Cipher API
+ *
+ * The synchronous block cipher API is used with the ciphers of type
+ * CRYPTO_ALG_TYPE_BLKCIPHER (listed as type "blkcipher" in /proc/crypto)
+ *
+ * Synchronous calls, have a context in the tfm. But since a single tfm can be
+ * used in multiple calls and in parallel, this info should not be changeable
+ * (unless a lock is used). This applies, for example, to the symmetric key.
+ * However, the IV is changeable, so there is an iv field in blkcipher_tfm
+ * structure for synchronous blkcipher api. So, its the only state info that can
+ * be kept for synchronous calls without using a big lock across a tfm.
+ *
+ * The block cipher API allows the use of a complete cipher, i.e. a cipher
+ * consisting of a template (a block chaining mode) and a single block cipher
+ * primitive (e.g. AES).
+ *
+ * The plaintext data buffer and the ciphertext data buffer are pointed to
+ * by using scatter/gather lists. The cipher operation is performed
+ * on all segments of the provided scatter/gather lists.
+ *
+ * The kernel crypto API supports a cipher operation "in-place" which means that
+ * the caller may provide the same scatter/gather list for the plaintext and
+ * cipher text. After the completion of the cipher operation, the plaintext
+ * data is replaced with the ciphertext data in case of an encryption and vice
+ * versa for a decryption. The caller must ensure that the scatter/gather lists
+ * for the output data point to sufficiently large buffers, i.e. multiples of
+ * the block size of the cipher.
+ */
+
 static inline struct crypto_blkcipher *__crypto_blkcipher_cast(
 	struct crypto_tfm *tfm)
 {
@@ -1578,6 +1608,20 @@ static inline struct crypto_blkcipher *crypto_blkcipher_cast(
 	return __crypto_blkcipher_cast(tfm);
 }
 
+/**
+ * crypto_alloc_blkcipher() - allocate synchronous block cipher handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      blkcipher cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for a block cipher. The returned struct
+ * crypto_blkcipher is the cipher handle that is required for any subsequent
+ * API invocation for that block cipher.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
 static inline struct crypto_blkcipher *crypto_alloc_blkcipher(
 	const char *alg_name, u32 type, u32 mask)
 {
@@ -1594,11 +1638,25 @@ static inline struct crypto_tfm *crypto_blkcipher_tfm(
 	return &tfm->base;
 }
 
+/**
+ * crypto_free_blkcipher() - zeroize and free the block cipher handle
+ * @tfm: cipher handle to be freed
+ */
 static inline void crypto_free_blkcipher(struct crypto_blkcipher *tfm)
 {
 	crypto_free_tfm(crypto_blkcipher_tfm(tfm));
 }
 
+/**
+ * crypto_has_blkcipher() - Search for the availability of a block cipher
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      block cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Return: true when the block cipher is known to the kernel crypto API; false
+ *	   otherwise
+ */
 static inline int crypto_has_blkcipher(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
@@ -1608,6 +1666,12 @@ static inline int crypto_has_blkcipher(const char *alg_name, u32 type, u32 mask)
 	return crypto_has_alg(alg_name, type, mask);
 }
 
+/**
+ * crypto_blkcipher_name() - return the name / cra_name from the cipher handle
+ * @tfm: cipher handle
+ *
+ * Return: The character string holding the name of the cipher
+ */
 static inline const char *crypto_blkcipher_name(struct crypto_blkcipher *tfm)
 {
 	return crypto_tfm_alg_name(crypto_blkcipher_tfm(tfm));
@@ -1625,11 +1689,30 @@ static inline struct blkcipher_alg *crypto_blkcipher_alg(
 	return &crypto_blkcipher_tfm(tfm)->__crt_alg->cra_blkcipher;
 }
 
+/**
+ * crypto_blkcipher_ivsize() - obtain IV size
+ * @tfm: cipher handle
+ *
+ * The size of the IV for the block cipher referenced by the cipher handle is
+ * returned. This IV size may be zero if the cipher does not need an IV.
+ *
+ * Return: IV size in bytes
+ */
 static inline unsigned int crypto_blkcipher_ivsize(struct crypto_blkcipher *tfm)
 {
 	return crypto_blkcipher_alg(tfm)->ivsize;
 }
 
+/**
+ * crypto_blkcipher_blocksize() - obtain block size of cipher
+ * @tfm: cipher handle
+ *
+ * The block size for the block cipher referenced with the cipher handle is
+ * returned. The caller may use that information to allocate appropriate
+ * memory for the data returned by the encryption or decryption operation.
+ *
+ * Return: block size of cipher
+ */
 static inline unsigned int crypto_blkcipher_blocksize(
 	struct crypto_blkcipher *tfm)
 {
@@ -1659,6 +1742,22 @@ static inline void crypto_blkcipher_clear_flags(struct crypto_blkcipher *tfm,
 	crypto_tfm_clear_flags(crypto_blkcipher_tfm(tfm), flags);
 }
 
+/**
+ * crypto_blkcipher_setkey() - set key for cipher
+ * @tfm: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the block cipher referenced by the cipher
+ * handle.
+ *
+ * Note, the key length determines the cipher type. Many block ciphers implement
+ * different cipher modes depending on the key size, such as AES-128 vs AES-192
+ * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
+ * is performed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
 static inline int crypto_blkcipher_setkey(struct crypto_blkcipher *tfm,
 					  const u8 *key, unsigned int keylen)
 {
@@ -1666,6 +1765,24 @@ static inline int crypto_blkcipher_setkey(struct crypto_blkcipher *tfm,
 						 key, keylen);
 }
 
+/**
+ * crypto_blkcipher_encrypt() - encrypt plaintext
+ * @desc: reference to the block cipher handle with meta data
+ * @dst: scatter/gather list that is filled by the cipher operation with the
+ *	ciphertext
+ * @src: scatter/gather list that holds the plaintext
+ * @nbytes: number of bytes of the plaintext to encrypt.
+ *
+ * Encrypt plaintext data using the IV set by the caller with a preceding
+ * call of crypto_blkcipher_set_iv.
+ *
+ * The blkcipher_desc data structure must be filled by the caller and can
+ * reside on the stack. The caller must fill desc as follows: desc.tfm is filled
+ * with the block cipher handle; desc.flags is filled with either
+ * CRYPTO_TFM_REQ_MAY_SLEEP or 0.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
 static inline int crypto_blkcipher_encrypt(struct blkcipher_desc *desc,
 					   struct scatterlist *dst,
 					   struct scatterlist *src,
@@ -1675,6 +1792,25 @@ static inline int crypto_blkcipher_encrypt(struct blkcipher_desc *desc,
 	return crypto_blkcipher_crt(desc->tfm)->encrypt(desc, dst, src, nbytes);
 }
 
+/**
+ * crypto_blkcipher_encrypt_iv() - encrypt plaintext with dedicated IV
+ * @desc: reference to the block cipher handle with meta data
+ * @dst: scatter/gather list that is filled by the cipher operation with the
+ *	ciphertext
+ * @src: scatter/gather list that holds the plaintext
+ * @nbytes: number of bytes of the plaintext to encrypt.
+ *
+ * Encrypt plaintext data with the use of an IV that is solely used for this
+ * cipher operation. Any previously set IV is not used.
+ *
+ * The blkcipher_desc data structure must be filled by the caller and can
+ * reside on the stack. The caller must fill desc as follows: desc.tfm is filled
+ * with the block cipher handle; desc.info is filled with the IV to be used for
+ * the current operation; desc.flags is filled with either
+ * CRYPTO_TFM_REQ_MAY_SLEEP or 0.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
 static inline int crypto_blkcipher_encrypt_iv(struct blkcipher_desc *desc,
 					      struct scatterlist *dst,
 					      struct scatterlist *src,
@@ -1683,6 +1819,23 @@ static inline int crypto_blkcipher_encrypt_iv(struct blkcipher_desc *desc,
 	return crypto_blkcipher_crt(desc->tfm)->encrypt(desc, dst, src, nbytes);
 }
 
+/**
+ * crypto_blkcipher_decrypt() - decrypt ciphertext
+ * @desc: reference to the block cipher handle with meta data
+ * @dst: scatter/gather list that is filled by the cipher operation with the
+ *	plaintext
+ * @src: scatter/gather list that holds the ciphertext
+ * @nbytes: number of bytes of the ciphertext to decrypt.
+ *
+ * Decrypt ciphertext data using the IV set by the caller with a preceding
+ * call of crypto_blkcipher_set_iv.
+ *
+ * The blkcipher_desc data structure must be filled by the caller as documented
+ * for the crypto_blkcipher_encrypt call above.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ *
+ */
 static inline int crypto_blkcipher_decrypt(struct blkcipher_desc *desc,
 					   struct scatterlist *dst,
 					   struct scatterlist *src,
@@ -1692,6 +1845,22 @@ static inline int crypto_blkcipher_decrypt(struct blkcipher_desc *desc,
 	return crypto_blkcipher_crt(desc->tfm)->decrypt(desc, dst, src, nbytes);
 }
 
+/**
+ * crypto_blkcipher_decrypt_iv() - decrypt ciphertext with dedicated IV
+ * @desc: reference to the block cipher handle with meta data
+ * @dst: scatter/gather list that is filled by the cipher operation with the
+ *	plaintext
+ * @src: scatter/gather list that holds the ciphertext
+ * @nbytes: number of bytes of the ciphertext to decrypt.
+ *
+ * Decrypt ciphertext data with the use of an IV that is solely used for this
+ * cipher operation. Any previously set IV is not used.
+ *
+ * The blkcipher_desc data structure must be filled by the caller as documented
+ * for the crypto_blkcipher_encrypt_iv call above.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
 static inline int crypto_blkcipher_decrypt_iv(struct blkcipher_desc *desc,
 					      struct scatterlist *dst,
 					      struct scatterlist *src,
@@ -1700,12 +1869,31 @@ static inline int crypto_blkcipher_decrypt_iv(struct blkcipher_desc *desc,
 	return crypto_blkcipher_crt(desc->tfm)->decrypt(desc, dst, src, nbytes);
 }
 
+/**
+ * crypto_blkcipher_set_iv() - set IV for cipher
+ * @tfm: cipher handle
+ * @src: buffer holding the IV
+ * @len: length of the IV in bytes
+ *
+ * The caller provided IV is set for the block cipher referenced by the cipher
+ * handle.
+ */
 static inline void crypto_blkcipher_set_iv(struct crypto_blkcipher *tfm,
 					   const u8 *src, unsigned int len)
 {
 	memcpy(crypto_blkcipher_crt(tfm)->iv, src, len);
 }
 
+/**
+ * crypto_blkcipher_get_iv() - obtain IV from cipher
+ * @tfm: cipher handle
+ * @dst: buffer filled with the IV
+ * @len: length of the buffer dst
+ *
+ * The caller can obtain the IV set for the block cipher referenced by the
+ * cipher handle and store it into the user-provided buffer. If the buffer
+ * has an insufficient space, the IV is truncated to fit the buffer.
+ */
 static inline void crypto_blkcipher_get_iv(struct crypto_blkcipher *tfm,
 					   u8 *dst, unsigned int len)
 {
-- 
2.1.0


