Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaKBUqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:46:23 -0500
Received: from mail.eperm.de ([89.247.134.16]:54191 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbaKBUnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:43:43 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 08/11] crypto: Documentation - AEAD API documentation
Date: Sun, 02 Nov 2014 21:40:07 +0100
Message-ID: <1883672.3CPmHykk4r@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <6375771.bx7QqLJLuR@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API function calls exported by the kernel crypto API for AEAD
ciphers to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
CC: Marek Vasut <marex@denx.de>
---
 include/linux/crypto.h | 259 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 259 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 67acda4..12c8a7a 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -1194,11 +1194,53 @@ static inline void ablkcipher_request_set_crypt(
 	req->info = iv;
 }
 
+/**
+ * Authenticated Encryption with Associated Data (AEAD) cipher API to use the
+ * ciphers of type CRYPTO_ALG_TYPE_AEAD (listed as type "aead" in /proc/crypto)
+ *
+ * The most prominent examples for this type of encryption is GCM and CCM.
+ * However, the kernel supports other types of AEAD ciphers which are defined
+ * with the following cipher string:
+ *
+ *	authenc(<keyed message digest>, <block cipher>)
+ *
+ * For example: authenc(hmac(sha256), cbc(aes))
+ *
+ * The example code provided for the asynchronous block cipher operation
+ * applies here as well. Naturally all *ablkcipher* symbols must be exchanged
+ * the *aead* pendants discussed in the following. In addtion, for the AEAD
+ * operation, the aead_request_set_assoc function must be used to set the
+ * pointer to the associated data memory location before performing the
+ * encryption or decryption operation. In case of an encryption, the associated
+ * data memory is filled during the encryption operation. For decryption, the
+ * associated data memory must contain data that is used to verify the integrity
+ * of the decrypted data. Another deviation from the asynchronous block cipher
+ * operation is that the caller should explicitly check for -EBADMSG of the
+ * crypto_aead_decrypt. That error indicates an authentication error, i.e.
+ * a breach in the integrity of the message. In essence, that -EBADMSG error
+ * code is the key bonus an AEAD cipher has over "standard" block chaining
+ * modes.
+ */
+
 static inline struct crypto_aead *__crypto_aead_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_aead *)tfm;
 }
 
+/**
+ * Allocate a cipher handle for an AEAD. The returned struct
+ * crypto_aead is the cipher handle that is required for any subsequent
+ * API invocation for that AEAD.
+ *
+ * @alg_name is the cra_name / name or cra_driver_name / driver name of the
+ *	     AEAD cipher
+ * @type specifies the type of the cipher (see Documentation/crypto/)
+ * @mask specifies the mask for the cipher (see Documentation/crypto/)
+ *
+ * return value:
+ *	allocated cipher handle in case of success
+ *	IS_ERR() is true in case of an error, PTR_ERR() returns the error code.
+ */
 struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask);
 
 static inline struct crypto_tfm *crypto_aead_tfm(struct crypto_aead *tfm)
@@ -1206,6 +1248,11 @@ static inline struct crypto_tfm *crypto_aead_tfm(struct crypto_aead *tfm)
 	return &tfm->base;
 }
 
+/**
+ * The referenced aead handle is zeroized and subsequently freed.
+ *
+ * @tfm cipher handle to be freed
+ */
 static inline void crypto_free_aead(struct crypto_aead *tfm)
 {
 	crypto_free_tfm(crypto_aead_tfm(tfm));
@@ -1216,16 +1263,47 @@ static inline struct aead_tfm *crypto_aead_crt(struct crypto_aead *tfm)
 	return &crypto_aead_tfm(tfm)->crt_aead;
 }
 
+/**
+ * The size of the IV for the aead referenced by the cipher handle is
+ * returned. This IV size may be zero if the cipher does not need an IV.
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ *	IV size in bytes
+ */
 static inline unsigned int crypto_aead_ivsize(struct crypto_aead *tfm)
 {
 	return crypto_aead_crt(tfm)->ivsize;
 }
 
+/**
+ * The maximum size of the authentication data for the AEAD cipher referenced
+ * by the AEAD cipher handle is returned. The authentication data size may be
+ * zero if the cipher implements a hard-coded maximum.
+ *
+ * The authentication data may also be known as "tag value".
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ *	authentication data size / tag size in bytes
+ */
 static inline unsigned int crypto_aead_authsize(struct crypto_aead *tfm)
 {
 	return crypto_aead_crt(tfm)->authsize;
 }
 
+/**
+ * The block size for the AEAD referenced with the cipher handle is returned.
+ * The caller may use that information to allocate appropriate memory for the
+ * data returned by the encryption or decryption operation
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ * 	block size of cipher
+ */
 static inline unsigned int crypto_aead_blocksize(struct crypto_aead *tfm)
 {
 	return crypto_tfm_alg_blocksize(crypto_aead_tfm(tfm));
@@ -1251,6 +1329,23 @@ static inline void crypto_aead_clear_flags(struct crypto_aead *tfm, u32 flags)
 	crypto_tfm_clear_flags(crypto_aead_tfm(tfm), flags);
 }
 
+/**
+ * The caller provided key is set for the AEAD referenced by the cipher
+ * handle.
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
 static inline int crypto_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 				     unsigned int keylen)
 {
@@ -1259,6 +1354,17 @@ static inline int crypto_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	return crt->setkey(crt->base, key, keylen);
 }
 
+/**
+ * Set the authentication data size / tag size. AEAD requires an authentication
+ * tag (or MAC) in addition to the associated data.
+ *
+ * @tfm cipher handle
+ * @authsize size of the authentication data / tag in bytes
+ *
+ * return value:
+ *	0 if the setting of the key was successful
+ *	< 0 if an error occurred
+ */
 int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize);
 
 static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
@@ -1266,27 +1372,105 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
 	return __crypto_aead_cast(req->base.tfm);
 }
 
+/**
+ * Encrypt plaintext data using the aead_request handle. That data structure
+ * and how it is filled with data is discussed with the aead_request_*
+ * functions.
+ *
+ * IMPORTANT NOTE: The encryption operation creates the authentication data /
+ *		   tag. That data is concatenated with the created ciphertext.
+ *		   The ciphertext memory size is therefore the given number of
+ *		   block cipher blocks + the size defined by the
+ *		   crypto_aead_setauthsize invocation. The caller must ensure
+ *		   that sufficient memory is available for the ciphertext and
+ *		   the authentication tag.
+ *
+ * @req reference to the aead_request handle that holds all information
+ *	needed to perform the cipher operation
+ *
+ * return value:
+ *	0 if the cipher operation was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_aead_encrypt(struct aead_request *req)
 {
 	return crypto_aead_crt(crypto_aead_reqtfm(req))->encrypt(req);
 }
 
+/**
+ * Decrypt ciphertext data using the aead_request handle. That data structure
+ * and how it is filled with data is discussed with the aead_request_*
+ * functions.
+ *
+ * IMPORTANT NOTE: The caller must concatenate the ciphertext followed by the
+ *		   authentication data / tag. That authentication data / tag
+ *		   must have the size defined by the crypto_aead_setauthsize
+ *		   invocation.
+ *
+ * @req reference to the ablkcipher_request handle that holds all information
+ *	needed to perform the cipher operation
+ *
+ * return value:
+ *	0 if the cipher operation was successful
+ *	-EBADMSG The AEAD cipher operation performs the authentication of the
+ *		 data during the decryption operation. Therefore, the function
+ *		 returns this error if the authentication of the ciphertext was
+ *		 unsuccessful (i.e. the integrity of the ciphertext or the
+ *		 associated data was violated).
+ *	< 0 if an error occurred
+ */
 static inline int crypto_aead_decrypt(struct aead_request *req)
 {
 	return crypto_aead_crt(crypto_aead_reqtfm(req))->decrypt(req);
 }
 
+/**
+ * The aead_request data structure contains all pointers to data required for
+ * the AEAD cipher operation. This includes the cipher handle (which can be
+ * used by multiple aead_request instances), pointer to plaintext and
+ * ciphertext, asynchronous callback function, etc. It acts as a handle to the
+ * aead_request_* API calls in a similar way as AEAD handle to the
+ * crypto_aead_* API calls.
+ */
+
+/**
+ * Return the size of the aead_request data structure to the caller.
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ *	number of bytes
+ */
 static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
 {
 	return crypto_aead_crt(tfm)->reqsize;
 }
 
+/**
+ * Allow the caller to replace the existing aead handle in the request
+ * data structure with a different one.
+ *
+ * @req request handle to be modified
+ * @tfm cipher handle that shall be added to the request handle
+ */
 static inline void aead_request_set_tfm(struct aead_request *req,
 					struct crypto_aead *tfm)
 {
 	req->base.tfm = crypto_aead_tfm(crypto_aead_crt(tfm)->base);
 }
 
+/**
+ * Allocate the request data structure that must be used with the AEAD
+ * encrypt and decrypt API calls. During the allocation, the provided aead
+ * handle is registered in the request data structure.
+ *
+ * @tfm cipher handle to be registered with the request
+ * @gfp memory allocation flag that is handed to kmalloc by the API call.
+ *
+ * return value:
+ *	allocated request handle in case of success
+ *	IS_ERR() is true in case of an error, PTR_ERR() returns the error code.
+ */
 static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
 						      gfp_t gfp)
 {
@@ -1300,11 +1484,40 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
 	return req;
 }
 
+/**
+ * The referenced request data structure is zeroized and subsequently freed.
+ *
+ * @req request data structure cipher handle to be freed
+ */
 static inline void aead_request_free(struct aead_request *req)
 {
 	kzfree(req);
 }
 
+/**
+ * Setting the callback function that is triggered once the cipher operation
+ * completes
+ *
+ * The callback function is registered with the aead_request handle and
+ * must comply with the following template:
+ *
+ *	void callback_function(struct crypto_async_request *req, int error)
+ *
+ * @req request handle
+ * @flags specify zero or an ORing of the following flags:
+ *	* CRYPTO_TFM_REQ_MAY_BACKLOG: the request queue may back log and
+ *	  increase the wait queue beyond the initial maximum size
+ *	* CRYPTO_TFM_REQ_MAY_SLEEP: the request processing may sleep
+ * @compl callback function pointer to be registered with the request handle
+ * @data The data pointer refers to memory that is not used by the kernel
+ *	 crypto API, but provided to the callback function for it to use. Here,
+ *	 the caller can provide a reference to memory the callback function can
+ *	 operate on. As the callback function is invoked asynchronously to the
+ *	 related functionality, it may need to access data structures of the
+ *	 related functionality which can be referenced using this pointer. The
+ *	 callback function can access the memory via the "data" field in the
+ *	 crypto_async_request data structure provided to the callback function.
+ */
 static inline void aead_request_set_callback(struct aead_request *req,
 					     u32 flags,
 					     crypto_completion_t compl,
@@ -1315,6 +1528,42 @@ static inline void aead_request_set_callback(struct aead_request *req,
 	req->base.flags = flags;
 }
 
+/**
+ * Setting the source data and destination data scatter / gather lists.
+ *
+ * For encryption, the source is treated as the plaintext and the
+ * destination is the ciphertext. For a decryption operation, the use is
+ * reversed: the source is the ciphertext and the destination is the plaintext.
+ *
+ * IMPORTANT NOTE: AEAD requires an authentication tag (MAC). For decryption,
+ *		   the caller must concatenate the ciphertext followed by the
+ *		   authentication tag and provide the entire data stream to the
+ *		   decryption operation (i.e. the data length used for the
+ *		   initialization of the scatterlist and the data length for the
+ *		   decryption operation is identical). For encryption, however,
+ *		   the authentication tag is created while encrypting the data.
+ *		   The destination buffer must hold sufficient space for the
+ *		   ciphertext and the authentication tag while the encryption
+ *		   invocation must only point to the plaintext data size. The
+ *		   following code snippet illustrates the memory usage:
+ *
+ * //sg is the pointer to plaintext and will hold the cipher text
+ * //authsize is the size of the authentication tag
+ * //enc is 1 for encryption, 0 for decryption
+ * //ptbuf is the buffer with the plaintext
+ * //ptbuflen is the plaintext buffer size
+ * buffer = kmalloc(ptbuflen + (enc ? authsize : 0));
+ * memcpy(buffer, ptbuf, ptbuflen);
+ * sg_init_one(&sg, buffer, ptbuflen + (enc ? authsize : 0));
+ * aead_request_set_crypt(req, &sg, &sg, ptbuflen, iv);
+ *
+ * @req request handle
+ * @src source scatter / gather list
+ * @dst destination scatter / gather list
+ * @cryptlen number of bytes to process from @src
+ * @iv IV for the cipher operation which must comply with the IV size defined
+ *     by crypto_aead_ivsize
+ */
 static inline void aead_request_set_crypt(struct aead_request *req,
 					  struct scatterlist *src,
 					  struct scatterlist *dst,
@@ -1326,6 +1575,16 @@ static inline void aead_request_set_crypt(struct aead_request *req,
 	req->iv = iv;
 }
 
+/**
+ * Setting the associated data scatter / gather list.
+ *
+ * For encryption, the memory is filled with the associated data. For
+ * decryption, the memory must point to the associated data.
+ *
+ * @req request handle
+ * @assoc associated data scatter / gather list
+ * @assoclen number of bytes to process from @assoc
+ */
 static inline void aead_request_set_assoc(struct aead_request *req,
 					  struct scatterlist *assoc,
 					  unsigned int assoclen)
-- 
2.1.0


