Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbaKLEci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:32:38 -0500
Received: from mail.eperm.de ([89.247.134.16]:54411 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812AbaKLEce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:32:34 -0500
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
Subject: [PATCH v3 06/13] crypto: Documentation - AHASH API documentation
Date: Wed, 12 Nov 2014 05:26:41 +0100
Message-ID: <3149556.vyoUx08By6@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1800066.efQ8hkST4U@tachyon.chronox.de>
References: <1800066.efQ8hkST4U@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API function calls exported by the kernel crypto API for AHASHes
to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/hash.h | 228 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 228 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index bf458fc..b2c193a 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -202,11 +202,35 @@ struct crypto_shash {
 	struct crypto_tfm base;
 };
 
+/**
+ * DOC: Asynchronous Message Digest API
+ *
+ * The asynchronous message digest API is used with the ciphers of type
+ * CRYPTO_ALG_TYPE_AHASH (listed as type "ahash" in /proc/crypto)
+ *
+ * The asynchronous cipher operation discussion provided for the
+ * CRYPTO_ALG_TYPE_ABLKCIPHER API applies here as well.
+ */
+
 static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
 {
 	return container_of(tfm, struct crypto_ahash, base);
 }
 
+/**
+ * crypto_alloc_ahash() - allocate ahash cipher handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      ahash cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for an ahash. The returned struct
+ * crypto_ahash is the cipher handle that is required for any subsequent
+ * API invocation for that ahash.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
 struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 					u32 mask);
 
@@ -215,6 +239,10 @@ static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 	return &tfm->base;
 }
 
+/**
+ * crypto_free_ahash() - zeroize and free the ahash handle
+ * @tfm: cipher handle to be freed
+ */
 static inline void crypto_free_ahash(struct crypto_ahash *tfm)
 {
 	crypto_destroy_tfm(tfm, crypto_ahash_tfm(tfm));
@@ -238,6 +266,16 @@ static inline struct hash_alg_common *crypto_hash_alg_common(
 	return __crypto_hash_alg_common(crypto_ahash_tfm(tfm)->__crt_alg);
 }
 
+/**
+ * crypto_ahash_digestsize() - obtain message digest size
+ * @tfm: cipher handle
+ *
+ * The size for the message digest created by the message digest cipher
+ * referenced with the cipher handle is returned.
+ *
+ *
+ * Return: message digest size of cipher
+ */
 static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
 {
 	return crypto_hash_alg_common(tfm)->digestsize;
@@ -263,12 +301,32 @@ static inline void crypto_ahash_clear_flags(struct crypto_ahash *tfm, u32 flags)
 	crypto_tfm_clear_flags(crypto_ahash_tfm(tfm), flags);
 }
 
+/**
+ * crypto_ahash_reqtfm() - obtain cipher handle from request
+ * @req: asynchronous request handle that contains the reference to the ahash
+ *	 cipher handle
+ *
+ * Return the ahash cipher handle that is registered with the asynchronous
+ * request handle ahash_request.
+ *
+ * Return: ahash cipher handle
+ */
 static inline struct crypto_ahash *crypto_ahash_reqtfm(
 	struct ahash_request *req)
 {
 	return __crypto_ahash_cast(req->base.tfm);
 }
 
+/**
+ * crypto_ahash_reqsize() - obtain size of the request data structure
+ * @tfm: cipher handle
+ *
+ * Return the size of the ahash state size. With the crypto_ahash_export
+ * function, the caller can export the state into a buffer whose size is
+ * defined with this function.
+ *
+ * Return: size of the ahash state
+ */
 static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash *tfm)
 {
 	return tfm->reqsize;
@@ -279,38 +337,166 @@ static inline void *ahash_request_ctx(struct ahash_request *req)
 	return req->__ctx;
 }
 
+/**
+ * crypto_ahash_setkey - set key for cipher handle
+ * @tfm: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the ahash cipher. The cipher
+ * handle must point to a keyed hash in order for this function to succeed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen);
+
+/**
+ * crypto_ahash_finup() - update and finalize message digest
+ * @req: reference to the ahash_request handle that holds all information
+ *	 needed to perform the cipher operation
+ *
+ * This function is a "short-hand" for the function calls of
+ * crypto_ahash_update and crypto_shash_final. The parameters have the same
+ * meaning as discussed for those separate functions.
+ *
+ * Return: 0 if the message digest creation was successful; < 0 if an error
+ *	   occurred
+ */
 int crypto_ahash_finup(struct ahash_request *req);
+
+/**
+ * crypto_ahash_final() - calculate message digest
+ * @req: reference to the ahash_request handle that holds all information
+ *	 needed to perform the cipher operation
+ *
+ * Finalize the message digest operation and create the message digest
+ * based on all data added to the cipher handle. The message digest is placed
+ * into the output buffer registered with the ahash_request handle.
+ *
+ * Return: 0 if the message digest creation was successful; < 0 if an error
+ *	   occurred
+ */
 int crypto_ahash_final(struct ahash_request *req);
+
+/**
+ * crypto_ahash_digest() - calculate message digest for a buffer
+ * @req: reference to the ahash_request handle that holds all information
+ *	 needed to perform the cipher operation
+ *
+ * This function is a "short-hand" for the function calls of crypto_ahash_init,
+ * crypto_ahash_update and crypto_ahash_final. The parameters have the same
+ * meaning as discussed for those separate three functions.
+ *
+ * Return: 0 if the message digest creation was successful; < 0 if an error
+ *	   occurred
+ */
 int crypto_ahash_digest(struct ahash_request *req);
 
+/**
+ * crypto_ahash_export() - extract current message digest state
+ * @req: reference to the ahash_request handle whose state is exported
+ * @out: output buffer of sufficient size that can hold the hash state
+ *
+ * This function exports the hash state of the ahash_request handle into the
+ * caller-allocated output buffer out which must have sufficient size (e.g. by
+ * calling crypto_ahash_reqsize).
+ *
+ * Return: 0 if the export was successful; < 0 if an error occurred
+ */
 static inline int crypto_ahash_export(struct ahash_request *req, void *out)
 {
 	return crypto_ahash_reqtfm(req)->export(req, out);
 }
 
+/**
+ * crypto_ahash_import() - import message digest state
+ * @req: reference to ahash_request handle the state is imported into
+ * @in: buffer holding the state
+ *
+ * This function imports the hash state into the ahash_request handle from the
+ * input buffer. That buffer should have been generated with the
+ * crypto_ahash_export function.
+ *
+ * Return: 0 if the import was successful; < 0 if an error occurred
+ */
 static inline int crypto_ahash_import(struct ahash_request *req, const void *in)
 {
 	return crypto_ahash_reqtfm(req)->import(req, in);
 }
 
+/**
+ * crypto_ahash_init() - (re)initialize message digest handle
+ * @req: ahash_request handle that already is initialized with all necessary
+ *	 data using the ahash_request_* API functions
+ *
+ * The call (re-)initializes the message digest referenced by the ahash_request
+ * handle. Any potentially existing state created by previous operations is
+ * discarded.
+ *
+ * Return: 0 if the message digest initialization was successful; < 0 if an
+ *	   error occurred
+ */
 static inline int crypto_ahash_init(struct ahash_request *req)
 {
 	return crypto_ahash_reqtfm(req)->init(req);
 }
 
+/**
+ * crypto_ahash_update() - add data to message digest for processing
+ * @req: ahash_request handle that was previously initialized with the
+ *	 crypto_ahash_init call.
+ *
+ * Updates the message digest state of the &ahash_request handle. The input data
+ * is pointed to by the scatter/gather list registered in the &ahash_request
+ * handle
+ *
+ * Return: 0 if the message digest update was successful; < 0 if an error
+ *	   occurred
+ */
 static inline int crypto_ahash_update(struct ahash_request *req)
 {
 	return crypto_ahash_reqtfm(req)->update(req);
 }
 
+/**
+ * DOC: Asynchronous Hash Request Handle
+ *
+ * The &ahash_request data structure contains all pointers to data
+ * required for the asynchronous cipher operation. This includes the cipher
+ * handle (which can be used by multiple &ahash_request instances), pointer
+ * to plaintext and the message digest output buffer, asynchronous callback
+ * function, etc. It acts as a handle to the ahash_request_* API calls in a
+ * similar way as ahash handle to the crypto_ahash_* API calls.
+ */
+
+/**
+ * ahash_request_set_tfm() - update cipher handle reference in request
+ * @req: request handle to be modified
+ * @tfm: cipher handle that shall be added to the request handle
+ *
+ * Allow the caller to replace the existing ahash handle in the request
+ * data structure with a different one.
+ */
 static inline void ahash_request_set_tfm(struct ahash_request *req,
 					 struct crypto_ahash *tfm)
 {
 	req->base.tfm = crypto_ahash_tfm(tfm);
 }
 
+/**
+ * ahash_request_alloc() - allocate request data structure
+ * @tfm: cipher handle to be registered with the request
+ * @gfp: memory allocation flag that is handed to kmalloc by the API call.
+ *
+ * Allocate the request data structure that must be used with the ahash
+ * message digest API calls. During
+ * the allocation, the provided ahash handle
+ * is registered in the request data structure.
+ *
+ * Return: allocated request handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
 static inline struct ahash_request *ahash_request_alloc(
 	struct crypto_ahash *tfm, gfp_t gfp)
 {
@@ -325,6 +511,10 @@ static inline struct ahash_request *ahash_request_alloc(
 	return req;
 }
 
+/**
+ * ahash_request_free() - zeroize and free the request data structure
+ * @req: request data structure cipher handle to be freed
+ */
 static inline void ahash_request_free(struct ahash_request *req)
 {
 	kzfree(req);
@@ -336,6 +526,31 @@ static inline struct ahash_request *ahash_request_cast(
 	return container_of(req, struct ahash_request, base);
 }
 
+/**
+ * ahash_request_set_callback() - set asynchronous callback function
+ * @req: request handle
+ * @flags: specify zero or an ORing of the flags
+ *	   CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
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
+ *	  &crypto_async_request data structure provided to the callback function.
+ *
+ * This function allows setting the callback function that is triggered once
+ * the cipher operation completes.
+ *
+ * The callback function is registered with the &ahash_request handle and
+ * must comply with the following template
+ *
+ *	void callback_function(struct crypto_async_request *req, int error)
+ */
 static inline void ahash_request_set_callback(struct ahash_request *req,
 					      u32 flags,
 					      crypto_completion_t compl,
@@ -346,6 +561,19 @@ static inline void ahash_request_set_callback(struct ahash_request *req,
 	req->base.flags = flags;
 }
 
+/**
+ * ahash_request_set_crypt() - set data buffers
+ * @req: ahash_request handle to be updated
+ * @src: source scatter/gather list
+ * @result: buffer that is filled with the message digest -- the caller must
+ *	    ensure that the buffer has sufficient space by, for example, calling
+ *	    crypto_ahash_digestsize()
+ * @nbytes: number of bytes to process from the source scatter/gather list
+ *
+ * By using this call, the caller references the source scatter/gather list.
+ * The source scatter/gather list points to the data the message digest is to
+ * be calculated for.
+ */
 static inline void ahash_request_set_crypt(struct ahash_request *req,
 					   struct scatterlist *src, u8 *result,
 					   unsigned int nbytes)
-- 
2.1.0


