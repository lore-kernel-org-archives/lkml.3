Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaKBUpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:45:34 -0500
Received: from mail.eperm.de ([89.247.134.16]:54228 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaKBUn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:43:56 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 04/11] crypto: Documentation - AHASH API documentation
Date: Sun, 02 Nov 2014 21:37:35 +0100
Message-ID: <3031970.r1C4nyeuS1@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <6375771.bx7QqLJLuR@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API function calls exported by the kernel crypto API for AHASHes
to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
CC: Marek Vasut <marex@denx.de>
---
 include/crypto/hash.h | 224 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 224 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 74b13ec..0d43dbc 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -107,11 +107,39 @@ struct crypto_shash {
 	struct crypto_tfm base;
 };
 
+/**
+ * Asynchronous message digest API to use the ciphers of type
+ * CRYPTO_ALG_TYPE_AHASH (listed as type "ahash" in /proc/crypto)
+ *
+ * The asynchronous cipher operation discussion provided for the
+ * CRYPTO_ALG_TYPE_ABLKCIPHER API applies here as well.
+ *
+ * Example code:
+ *
+ * The example code given for the asynchronous block cipher operation can be
+ * used as a template where the ablkcipher function calls are swapped with ahash
+ * function calls.
+ */
+
 static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
 {
 	return container_of(tfm, struct crypto_ahash, base);
 }
 
+/**
+ * Allocate a cipher handle for an ahash. The returned struct
+ * crypto_ahash is the cipher handle that is required for any subsequent
+ * API invocation for that ahash.
+ *
+ * @alg_name is the cra_name / name or cra_driver_name / driver name of the
+ *	     ahash cipher
+ * @type specifies the type of the cipher (see Documentation/crypto/)
+ * @mask specifies the mask for the cipher (see Documentation/crypto/)
+ *
+ * return value:
+ *	allocated cipher handle in case of success
+ *	IS_ERR() is true in case of an error, PTR_ERR() returns the error code.
+ */
 struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 					u32 mask);
 
@@ -120,6 +148,11 @@ static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 	return &tfm->base;
 }
 
+/**
+ * The referenced ahash handle is zeroized and subsequently freed.
+ *
+ * @tfm cipher handle to be freed
+ */
 static inline void crypto_free_ahash(struct crypto_ahash *tfm)
 {
 	crypto_destroy_tfm(tfm, crypto_ahash_tfm(tfm));
@@ -143,6 +176,15 @@ static inline struct hash_alg_common *crypto_hash_alg_common(
 	return __crypto_hash_alg_common(crypto_ahash_tfm(tfm)->__crt_alg);
 }
 
+/**
+ * The size for the message digest created by the message digest cipher
+ * referenced with the cipher handle is returned.
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ * 	block size of cipher
+ */
 static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
 {
 	return crypto_hash_alg_common(tfm)->digestsize;
@@ -168,12 +210,32 @@ static inline void crypto_ahash_clear_flags(struct crypto_ahash *tfm, u32 flags)
 	crypto_tfm_clear_flags(crypto_ahash_tfm(tfm), flags);
 }
 
+/**
+ * Return the ahash cipher handle that is registered with the asynchronous
+ * request handle ahash_request.
+ *
+ * @req asynchronous request handle that contains the reference to the ahash
+ *	cipher handle
+ *
+ * return value:
+ *	ahash cipher handle
+ */
 static inline struct crypto_ahash *crypto_ahash_reqtfm(
 	struct ahash_request *req)
 {
 	return __crypto_ahash_cast(req->base.tfm);
 }
 
+/**
+ * Return the size of the ahash state size. With the crypto_ahash_export
+ * function, the caller can export the state into a buffer whose size is
+ * defined with this function.
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ *	size of the ahash state
+ */
 static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash *tfm)
 {
 	return tfm->reqsize;
@@ -184,38 +246,159 @@ static inline void *ahash_request_ctx(struct ahash_request *req)
 	return req->__ctx;
 }
 
+/**
+ * The caller provided key is set for the ahash cipher. The cipher
+ * handle must point to a keyed hash in order for this function to succeed.
+ *
+ * @tfm cipher handle
+ * @key buffer holding the key
+ * @keylen length of the key in bytes
+ *
+ * return value:
+ *	0 if the setting of the key was successful
+ *	< 0 if an error occurred
+ */
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen);
+
+/**
+ * This function is a "short-hand" for the function calls of
+ * crypto_ahash_update and crypto_shash_final. The parameters have the same
+ * meaning as discussed for those separate functions.
+ *
+ * return value:
+ *	0 if the message digest creation was successful
+ *	< 0 if an error occurred
+ */
 int crypto_ahash_finup(struct ahash_request *req);
+
+/**
+ * Finalize the message digest operation and create the message digest
+ * based on all data added to the cipher handle. The message digest is placed
+ * into the output buffer registered with the ahash_request handle.
+ *
+ * @req reference to the ahash_request handle that holds all information
+ *	needed to perform the cipher operation
+ *
+ * return value:
+ *	0 if the message digest creation was successful
+ *	< 0 if an error occurred
+ */
 int crypto_ahash_final(struct ahash_request *req);
+
+/**
+ * This function is a "short-hand" for the function calls of crypto_ahash_init,
+ * crypto_ahash_update and crypto_ahash_final. The parameters have the same
+ * meaning as discussed for those separate three functions.
+ *
+ * return value:
+ *	0 if the message digest creation was successful
+ *	< 0 if an error occurred
+ */
 int crypto_ahash_digest(struct ahash_request *req);
 
+/**
+ * This function exports the hash state of the ahash_request handle into the
+ * caller-allocated output buffer out which must have sufficient size (e.g. by
+ * calling crypto_ahash_reqsize).
+ *
+ * @req reference to the ahash_request handle whose state is exported
+ * @out output buffer of sufficient size that can hold the hash state
+ *
+ * return value:
+ *	0 if the export was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_ahash_export(struct ahash_request *req, void *out)
 {
 	return crypto_ahash_reqtfm(req)->export(req, out);
 }
 
+/**
+ * This function imports the hash state into the ahash_request handle from the
+ * input buffer. That buffer should have been generated with the
+ * crypto_ahash_export function.
+ *
+ * @req reference to ahash_request handle the state is imported into
+ * @in buffer holding the state
+ *
+ * return value:
+ *	0 if the import was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_ahash_import(struct ahash_request *req, const void *in)
 {
 	return crypto_ahash_reqtfm(req)->import(req, in);
 }
 
+/**
+ * The call (re-)initializes the message digest referenced by the ahash_request
+ * handle. Any potentially existing state created by previous operations is
+ * discarded.
+ *
+ * @req ahash_request handle that already is initialized with all necessary
+ *	data using the ahash_request_* API functions
+ *
+ * return value:
+ *	0 if the message digest initialization was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_ahash_init(struct ahash_request *req)
 {
 	return crypto_ahash_reqtfm(req)->init(req);
 }
 
+/**
+ * Updates the message digest state of the ahash_request handle. The input data
+ * is pointed to by the scatter/gather list registered in the ahash_request
+ * handle
+ *
+ * @req ahash_request handle that was previously initialized with the
+ *	crypto_ahash_init call.
+ *
+ * return value:
+ *	0 if the message digest update was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_ahash_update(struct ahash_request *req)
 {
 	return crypto_ahash_reqtfm(req)->update(req);
 }
 
+/**
+ * Allow the caller to replace the existing ahash handle in the request
+ * data structure with a different one.
+ *
+ * @req request handle to be modified
+ * @tfm cipher handle that shall be added to the request handle
+ */
 static inline void ahash_request_set_tfm(struct ahash_request *req,
 					 struct crypto_ahash *tfm)
 {
 	req->base.tfm = crypto_ahash_tfm(tfm);
 }
 
+/**
+ * The hash_request data structure contains all pointers to data
+ * required for the asynchronous cipher operation. This includes the cipher
+ * handle (which can be used by multiple ahash_request instances), pointer
+ * to plaintext and the message digest output buffer, asynchronous callback
+ * function, etc. It acts as a handle to the ahash_request_* API calls in a
+ * similar way as ahash handle to the crypto_ahash_* API calls.
+ */
+
+/**
+ * Allocate the request data structure that must be used with the ahash
+ * message digest API calls. During the allocation, the provided ahash handle
+ * is registered in the request data structure.
+ *
+ * @tfm cipher handle to be registered with the request
+ * @gfp memory allocation flag that is handed to kmalloc by the API call.
+ *
+ * return value:
+ *	allocated request handle in case of success
+ *	IS_ERR() is true in case of an error, PTR_ERR() returns the error code.
+ */
 static inline struct ahash_request *ahash_request_alloc(
 	struct crypto_ahash *tfm, gfp_t gfp)
 {
@@ -230,6 +413,11 @@ static inline struct ahash_request *ahash_request_alloc(
 	return req;
 }
 
+/**
+ * The referenced request data structure is zeroized and subsequently freed.
+ *
+ * @req request data structure cipher handle to be freed
+ */
 static inline void ahash_request_free(struct ahash_request *req)
 {
 	kzfree(req);
@@ -241,6 +429,30 @@ static inline struct ahash_request *ahash_request_cast(
 	return container_of(req, struct ahash_request, base);
 }
 
+/**
+ * Setting the callback function that is triggered once the cipher operation
+ * completes
+ *
+ * The callback function is registered with the ahash_request handle and
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
 static inline void ahash_request_set_callback(struct ahash_request *req,
 					      u32 flags,
 					      crypto_completion_t compl,
@@ -251,6 +463,18 @@ static inline void ahash_request_set_callback(struct ahash_request *req,
 	req->base.flags = flags;
 }
 
+/**
+ * By using this call, the caller references the source scatter/gather list.
+ * The source scatter/gather list points to the data the message digest is to
+ * be calculated for.
+ *
+ * @req ahash_request handle to be updated
+ * @src source scatter/gather list
+ * @result buffer that is filled with the message digest -- the caller must
+ *	   ensure that the buffer has sufficient space by, for example, calling
+ *	   crypto_ahash_digestsize
+ * @nbytes number of bytes to process from the source scatter/gather list
+ */
 static inline void ahash_request_set_crypt(struct ahash_request *req,
 					   struct scatterlist *src, u8 *result,
 					   unsigned int nbytes)
-- 
2.1.0


