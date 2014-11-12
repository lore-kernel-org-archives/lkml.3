Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbaKLEcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:32:23 -0500
Received: from mail.eperm.de ([89.247.134.16]:54380 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbaKLEcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:32:18 -0500
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
Subject: [PATCH v3 09/13] crypto: Documentation - ABLKCIPHER API documentation
Date: Wed, 12 Nov 2014 05:28:22 +0100
Message-ID: <1842066.f4Zl9njFFH@tachyon.chronox.de>
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
asynchronous block ciphers to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/crypto.h | 206 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 752360e..39c8fc6 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -821,6 +821,50 @@ static inline u32 crypto_skcipher_mask(u32 mask)
 	return mask;
 }
 
+/**
+ * DOC: Asynchronous Block Cipher API
+ *
+ * Asynchronous block cipher API is used with the ciphers of type
+ * CRYPTO_ALG_TYPE_ABLKCIPHER (listed as type "ablkcipher" in /proc/crypto).
+ *
+ * Asynchronous cipher operations imply that the function invocation for a
+ * cipher request returns immediately before the completion of the operation.
+ * The cipher request is scheduled as a separate kernel thread and therefore
+ * load-balanced on the different CPUs via the process scheduler. To allow
+ * the kernel crypto API to inform the caller about the completion of a cipher
+ * request, the caller must provide a callback function. That function is
+ * invoked with the cipher handle when the request completes.
+ *
+ * To support the asynchronous operation, additional information than just the
+ * cipher handle must be supplied to the kernel crypto API. That additional
+ * information is given by filling in the ablkcipher_request data structure.
+ *
+ * For the asynchronous block cipher API, the state is maintained with the tfm
+ * cipher handle. A single tfm can be used across multiple calls and in
+ * parallel. For asynchronous block cipher calls, context data supplied and
+ * only used by the caller can be referenced the request data structure in
+ * addition to the IV used for the cipher request. The maintenance of such
+ * state information would be important for a crypto driver implementer to
+ * have, because when calling the callback function upon completion of the
+ * cipher operation, that callback function may need some information about
+ * which operation just finished if it invoked multiple in parallel. This
+ * state information is unused by the kernel crypto API.
+ */
+
+/**
+ * crypto_alloc_ablkcipher() - allocate asynchronous block cipher handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      ablkcipher cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for an ablkcipher. The returned struct
+ * crypto_ablkcipher is the cipher handle that is required for any subsequent
+ * API invocation for that ablkcipher.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
 struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
 						  u32 type, u32 mask);
 
@@ -830,11 +874,25 @@ static inline struct crypto_tfm *crypto_ablkcipher_tfm(
 	return &tfm->base;
 }
 
+/**
+ * crypto_free_ablkcipher() - zeroize and free cipher handle
+ * @tfm: cipher handle to be freed
+ */
 static inline void crypto_free_ablkcipher(struct crypto_ablkcipher *tfm)
 {
 	crypto_free_tfm(crypto_ablkcipher_tfm(tfm));
 }
 
+/**
+ * crypto_has_ablkcipher() - Search for the availability of an ablkcipher.
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      ablkcipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Return: true when the ablkcipher is known to the kernel crypto API; false
+ *	   otherwise
+ */
 static inline int crypto_has_ablkcipher(const char *alg_name, u32 type,
 					u32 mask)
 {
@@ -848,12 +906,31 @@ static inline struct ablkcipher_tfm *crypto_ablkcipher_crt(
 	return &crypto_ablkcipher_tfm(tfm)->crt_ablkcipher;
 }
 
+/**
+ * crypto_ablkcipher_ivsize() - obtain IV size
+ * @tfm: cipher handle
+ *
+ * The size of the IV for the ablkcipher referenced by the cipher handle is
+ * returned. This IV size may be zero if the cipher does not need an IV.
+ *
+ * Return: IV size in bytes
+ */
 static inline unsigned int crypto_ablkcipher_ivsize(
 	struct crypto_ablkcipher *tfm)
 {
 	return crypto_ablkcipher_crt(tfm)->ivsize;
 }
 
+/**
+ * crypto_ablkcipher_blocksize() - obtain block size of cipher
+ * @tfm: cipher handle
+ *
+ * The block size for the ablkcipher referenced with the cipher handle is
+ * returned. The caller may use that information to allocate appropriate
+ * memory for the data returned by the encryption or decryption operation
+ *
+ * Return: block size of cipher
+ */
 static inline unsigned int crypto_ablkcipher_blocksize(
 	struct crypto_ablkcipher *tfm)
 {
@@ -883,6 +960,22 @@ static inline void crypto_ablkcipher_clear_flags(struct crypto_ablkcipher *tfm,
 	crypto_tfm_clear_flags(crypto_ablkcipher_tfm(tfm), flags);
 }
 
+/**
+ * crypto_ablkcipher_setkey() - set key for cipher
+ * @tfm: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the ablkcipher referenced by the cipher
+ * handle.
+ *
+ * Note, the key length determines the cipher type. Many block ciphers implement
+ * different cipher modes depending on the key size, such as AES-128 vs AES-192
+ * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
+ * is performed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
 static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
@@ -891,12 +984,32 @@ static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 	return crt->setkey(crt->base, key, keylen);
 }
 
+/**
+ * crypto_ablkcipher_reqtfm() - obtain cipher handle from request
+ * @req: ablkcipher_request out of which the cipher handle is to be obtained
+ *
+ * Return the crypto_ablkcipher handle when furnishing an ablkcipher_request
+ * data structure.
+ *
+ * Return: crypto_ablkcipher handle
+ */
 static inline struct crypto_ablkcipher *crypto_ablkcipher_reqtfm(
 	struct ablkcipher_request *req)
 {
 	return __crypto_ablkcipher_cast(req->base.tfm);
 }
 
+/**
+ * crypto_ablkcipher_encrypt() - encrypt plaintext
+ * @req: reference to the ablkcipher_request handle that holds all information
+ *	 needed to perform the cipher operation
+ *
+ * Encrypt plaintext data using the ablkcipher_request handle. That data
+ * structure and how it is filled with data is discussed with the
+ * ablkcipher_request_* functions.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
 static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
@@ -904,6 +1017,17 @@ static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 	return crt->encrypt(req);
 }
 
+/**
+ * crypto_ablkcipher_decrypt() - decrypt ciphertext
+ * @req: reference to the ablkcipher_request handle that holds all information
+ *	 needed to perform the cipher operation
+ *
+ * Decrypt ciphertext data using the ablkcipher_request handle. That data
+ * structure and how it is filled with data is discussed with the
+ * ablkcipher_request_* functions.
+ *
+ * Return: 0 if the cipher operation was successful; < 0 if an error occurred
+ */
 static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
@@ -911,12 +1035,37 @@ static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 	return crt->decrypt(req);
 }
 
+/**
+ * DOC: Asynchronous Cipher Request Handle
+ *
+ * The ablkcipher_request data structure contains all pointers to data
+ * required for the asynchronous cipher operation. This includes the cipher
+ * handle (which can be used by multiple ablkcipher_request instances), pointer
+ * to plaintext and ciphertext, asynchronous callback function, etc. It acts
+ * as a handle to the ablkcipher_request_* API calls in a similar way as
+ * ablkcipher handle to the crypto_ablkcipher_* API calls.
+ */
+
+/**
+ * crypto_ablkcipher_reqsize() - obtain size of the request data structure
+ * @tfm: cipher handle
+ *
+ * Return: number of bytes
+ */
 static inline unsigned int crypto_ablkcipher_reqsize(
 	struct crypto_ablkcipher *tfm)
 {
 	return crypto_ablkcipher_crt(tfm)->reqsize;
 }
 
+/**
+ * ablkcipher_request_set_tfm() - update cipher handle reference in request
+ * @req: request handle to be modified
+ * @tfm: cipher handle that shall be added to the request handle
+ *
+ * Allow the caller to replace the existing ablkcipher handle in the request
+ * data structure with a different one.
+ */
 static inline void ablkcipher_request_set_tfm(
 	struct ablkcipher_request *req, struct crypto_ablkcipher *tfm)
 {
@@ -929,6 +1078,18 @@ static inline struct ablkcipher_request *ablkcipher_request_cast(
 	return container_of(req, struct ablkcipher_request, base);
 }
 
+/**
+ * ablkcipher_request_alloc() - allocate request data structure
+ * @tfm: cipher handle to be registered with the request
+ * @gfp: memory allocation flag that is handed to kmalloc by the API call.
+ *
+ * Allocate the request data structure that must be used with the ablkcipher
+ * encrypt and decrypt API calls. During the allocation, the provided ablkcipher
+ * handle is registered in the request data structure.
+ *
+ * Return: allocated request handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
 static inline struct ablkcipher_request *ablkcipher_request_alloc(
 	struct crypto_ablkcipher *tfm, gfp_t gfp)
 {
@@ -943,11 +1104,40 @@ static inline struct ablkcipher_request *ablkcipher_request_alloc(
 	return req;
 }
 
+/**
+ * ablkcipher_request_free() - zeroize and free request data structure
+ * @req: request data structure cipher handle to be freed
+ */
 static inline void ablkcipher_request_free(struct ablkcipher_request *req)
 {
 	kzfree(req);
 }
 
+/**
+ * ablkcipher_request_set_callback() - set asynchronous callback function
+ * @req: request handle
+ * @flags: specify zero or an ORing of the flags
+ *         CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
+ *	   increase the wait queue beyond the initial maximum size;
+ *	   CRYPTO_TFM_REQ_MAY_SLEEP the request processing may sleep
+ * @compl: callback function pointer to be registered with the request handle
+ * @data: The data pointer refers to memory that is not used by the kernel
+ *	  crypto API, but provided to the callback function for it to use. Here,
+ *	  the caller can provide a reference to memory the callback function can
+ *	  operate on. As the callback function is invoked asynchronously to the
+ *	  related functionality, it may need to access data structures of the
+ *	  related functionality which can be referenced using this pointer. The
+ *	  callback function can access the memory via the "data" field in the
+ *	  crypto_async_request data structure provided to the callback function.
+ *
+ * This function allows setting the callback function that is triggered once the
+ * cipher operation completes.
+ *
+ * The callback function is registered with the ablkcipher_request handle and
+ * must comply with the following template:
+ *
+ *	void callback_function(struct crypto_async_request *req, int error)
+ */
 static inline void ablkcipher_request_set_callback(
 	struct ablkcipher_request *req,
 	u32 flags, crypto_completion_t compl, void *data)
@@ -957,6 +1147,22 @@ static inline void ablkcipher_request_set_callback(
 	req->base.flags = flags;
 }
 
+/**
+ * ablkcipher_request_set_crypt() - set data buffers
+ * @req: request handle
+ * @src: source scatter / gather list
+ * @dst: destination scatter / gather list
+ * @nbytes: number of bytes to process from @src
+ * @iv: IV for the cipher operation which must comply with the IV size defined
+ *      by crypto_ablkcipher_ivsize
+ *
+ * This function allows setting of the source data and destination data
+ * scatter / gather lists.
+ *
+ * For encryption, the source is treated as the plaintext and the
+ * destination is the ciphertext. For a decryption operation, the use is
+ * reversed: the source is the ciphertext and the destination is the plaintext.
+ */
 static inline void ablkcipher_request_set_crypt(
 	struct ablkcipher_request *req,
 	struct scatterlist *src, struct scatterlist *dst,
-- 
2.1.0


