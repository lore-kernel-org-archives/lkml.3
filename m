Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaKBUnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:43:50 -0500
Received: from mail.eperm.de ([89.247.134.16]:54201 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaKBUnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:43:46 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 07/11] crypto: Documentation - ABLKCIPHER API documentation
Date: Sun, 02 Nov 2014 21:39:33 +0100
Message-ID: <4671913.zoKV4j5IXE@tachyon.chronox.de>
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
asynchronous block ciphers to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
CC: Marek Vasut <marex@denx.de>
---
 include/linux/crypto.h | 349 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 349 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e1a84fd..67acda4 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -698,6 +698,190 @@ static inline u32 crypto_skcipher_mask(u32 mask)
 	return mask;
 }
 
+/**
+ * Asynchronous block cipher API to use the ciphers of type
+ * CRYPTO_ALG_TYPE_ABLKCIPHER (listed as type "ablkcipher" in /proc/crypto)
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
+ *
+ * Example code
+ *
+ *#include <linux/crypto.h>
+ *#include <linux/scatterlist.h>
+ *#include <linux/random.h>	// needed for get_random_bytes
+ *
+ *struct tcrypt_result {
+ *	struct completion completion;
+ *	int err;
+ *};
+ *
+ * // tie all data structures together
+ *struct ablkcipher_def {
+ *	struct scatterlist sg;
+ *	struct crypto_ablkcipher *tfm;
+ *	struct ablkcipher_request *req;
+ *	struct tcrypt_result result;
+ *};
+ *
+ * //Callback function
+ *static void test_ablkcipher_cb(struct crypto_async_request *req, int error)
+ *{
+ *	struct tcrypt_result *result = req->data;
+ *
+ *	if (error == -EINPROGRESS)
+ *		return;
+ *	result->err = error;
+ *	complete(&result->completion);
+ *	pr_info("Encryption finished successfully\n");
+ *}
+ *
+ * //Perform cipher operation
+ *static unsigned int test_ablkcipher_encdec(struct ablkcipher_def *ablk,
+ *					   int enc)
+ *{
+ *	int rc = 0;
+ *
+ *	if (enc)
+ *		rc = crypto_ablkcipher_encrypt(ablk->req);
+ *	else
+ *		rc = crypto_ablkcipher_decrypt(ablk->req);
+ *
+ *	switch (rc) {
+ *	case 0:
+ *		break;
+ *	case -EINPROGRESS:
+ *	case -EBUSY:
+ *		rc = wait_for_completion_interruptible(
+ *			&ablk->result.completion);
+ *		if (!rc && !ablk->result.err) {
+ *			reinit_completion(&ablk->result.completion);
+ *			break;
+ *		}
+ *	default:
+ *		pr_info("ablkcipher encrypt returned with %d result %d\n",
+ *		       rc, ablk->result.err);
+ *		break;
+ *	}
+ *	init_completion(&ablk->result.completion);
+ *
+ *	return rc;
+ *}
+ *
+ * //Initialize and trigger cipher operation
+ *static int test_ablkcipher(void)
+ *{
+ *	struct ablkcipher_def ablk;
+ *	struct crypto_ablkcipher *ablkcipher = NULL;
+ *	struct ablkcipher_request *req = NULL;
+ *	char *scratchpad = NULL;
+ *	char *ivdata = NULL;
+ *	unsigned char key[32];
+ *	int ret = -EFAULT;
+ *
+ *	ablkcipher = crypto_alloc_ablkcipher("cbc-aes-aesni", 0, 0);
+ *	if (IS_ERR(ablkcipher)) {
+ *		pr_info("could not allocate ablkcipher handle\n");
+ *		return PTR_ERR(ablkcipher);
+ *	}
+ *
+ *	req = ablkcipher_request_alloc(ablkcipher, GFP_KERNEL);
+ *	if (IS_ERR(req)) {
+ *		pr_info("could not allocate request queue\n");
+ *		ret = PTR_ERR(req);
+ *		goto out;
+ *	}
+ *
+ *	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+ *					test_ablkcipher_cb,
+ *					&ablk.result);
+ *
+ *	// AES 256 with random key
+ *	get_random_bytes(&key, 32);
+ *	if (crypto_ablkcipher_setkey(ablkcipher, key, 32)) {
+ *		pr_info("key could not be set\n");
+ *		ret = -EAGAIN;
+ *		goto out;
+ *	}
+ *
+ *	// IV will be random
+ *	ivdata = kmalloc(16, GFP_KERNEL);
+ *	if (!ivdata) {
+ *		pr_info("could not allocate ivdata\n");
+ *		goto out;
+ *	}
+ *	get_random_bytes(ivdata, 16);
+ *
+ *	// Input data will be random
+ *	scratchpad = kmalloc(16, GFP_KERNEL);
+ *	if (!scratchpad) {
+ *		pr_info("could not allocate scratchpad\n");
+ *		goto out;
+ *	}
+ *	get_random_bytes(scratchpad, 16);
+ *
+ *	ablk.tfm = ablkcipher;
+ *	ablk.req = req;
+ *
+ *	// We encrypt one block
+ *	sg_init_one(&ablk.sg, scratchpad, 16);
+ *	ablkcipher_request_set_crypt(req, &ablk.sg, &ablk.sg, 16, ivdata);
+ *	init_completion(&ablk.result.completion);
+ *
+ *	// encrypt data
+ *	ret = test_ablkcipher_encdec(&ablk, 1);
+ *	if (ret)
+ *		goto out;
+ *
+ *	pr_info("Encryption triggered successfully\n");
+ *
+ *out:
+ *	if (ablkcipher)
+ *		crypto_free_ablkcipher(ablkcipher);
+ *	if (req)
+ *		ablkcipher_request_free(req);
+ *	if (ivdata)
+ *		kfree(ivdata);
+ *	if (scratchpad)
+ *		kfree(scratchpad);
+ *	return ret;
+ *}
+ */
+
+/**
+ * Allocate a cipher handle for an ablkcipher. The returned struct
+ * crypto_ablkcipher is the cipher handle that is required for any subsequent
+ * API invocation for that ablkcipher.
+ *
+ * @alg_name is the cra_name / name or cra_driver_name / driver name of the
+ *	     ablkcipher cipher
+ * @type specifies the type of the cipher (see Documentation/crypto/)
+ * @mask specifies the mask for the cipher (see Documentation/crypto/)
+ *
+ * return value:
+ *	allocated cipher handle in case of success
+ *	IS_ERR() is true in case of an error, PTR_ERR() returns the error code.
+ */
 struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
 						  u32 type, u32 mask);
 
@@ -707,11 +891,28 @@ static inline struct crypto_tfm *crypto_ablkcipher_tfm(
 	return &tfm->base;
 }
 
+/**
+ * The referenced ablkcipher handle is zeroized and subsequently freed.
+ *
+ * @tfm cipher handle to be freed
+ */
 static inline void crypto_free_ablkcipher(struct crypto_ablkcipher *tfm)
 {
 	crypto_free_tfm(crypto_ablkcipher_tfm(tfm));
 }
 
+/**
+ * Lookup function to search for the availability of an ablkcipher.
+ *
+ * @alg_name is the cra_name / name or cra_driver_name / driver name of the
+ *	     ablkcipher
+ * @type specifies the type of the cipher (see Documentation/crypto/)
+ * @mask specifies the mask for the cipher (see Documentation/crypto/)
+ *
+ * return value:
+ *	true when the ablkcipher is known to the kernel crypto API.
+ *	false otherwise
+ */
 static inline int crypto_has_ablkcipher(const char *alg_name, u32 type,
 					u32 mask)
 {
@@ -725,12 +926,31 @@ static inline struct ablkcipher_tfm *crypto_ablkcipher_crt(
 	return &crypto_ablkcipher_tfm(tfm)->crt_ablkcipher;
 }
 
+/**
+ * The size of the IV for the ablkcipher referenced by the cipher handle is
+ * returned. This IV size may be zero if the cipher does not need an IV.
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ *	IV size in bytes
+ */
 static inline unsigned int crypto_ablkcipher_ivsize(
 	struct crypto_ablkcipher *tfm)
 {
 	return crypto_ablkcipher_crt(tfm)->ivsize;
 }
 
+/**
+ * The block size for the ablkcipher referenced with the cipher handle is
+ * returned. The caller may use that information to allocate appropriate
+ * memory for the data returned by the encryption or decryption operation
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ * 	block size of cipher
+ */
 static inline unsigned int crypto_ablkcipher_blocksize(
 	struct crypto_ablkcipher *tfm)
 {
@@ -760,6 +980,23 @@ static inline void crypto_ablkcipher_clear_flags(struct crypto_ablkcipher *tfm,
 	crypto_tfm_clear_flags(crypto_ablkcipher_tfm(tfm), flags);
 }
 
+/**
+ * The caller provided key is set for the ablkcipher referenced by the cipher
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
 static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
@@ -768,12 +1005,33 @@ static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 	return crt->setkey(crt->base, key, keylen);
 }
 
+/**
+ * Return the crypto_ablkcipher handle when furnishing an ablkcipher_request
+ * data structure.
+ *
+ * @req ablkcipher_request out of which the cipher handle is to be obtained
+ *
+ * return value:
+ *	crypto_ablkcipher handle
+ */
 static inline struct crypto_ablkcipher *crypto_ablkcipher_reqtfm(
 	struct ablkcipher_request *req)
 {
 	return __crypto_ablkcipher_cast(req->base.tfm);
 }
 
+/**
+ * Encrypt plaintext data using the ablkcipher_request handle. That data
+ * structure and how it is filled with data is discussed with the
+ * ablkcipher_request_* functions.
+ *
+ * @req reference to the ablkcipher_request handle that holds all information
+ *	needed to perform the cipher operation
+ *
+ * return value:
+ *	0 if the cipher operation was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
@@ -781,6 +1039,18 @@ static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 	return crt->encrypt(req);
 }
 
+/**
+ * Decrypt ciphertext data using the ablkcipher_request handle. That data
+ * structure and how it is filled with data is discussed with the
+ * ablkcipher_request_* functions.
+ *
+ * @req reference to the ablkcipher_request handle that holds all information
+ *	needed to perform the cipher operation
+ *
+ * return value:
+ *	0 if the cipher operation was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
@@ -788,12 +1058,36 @@ static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 	return crt->decrypt(req);
 }
 
+/**
+ * The ablkcipher_request data structure contains all pointers to data
+ * required for the asynchronous cipher operation. This includes the cipher
+ * handle (which can be used by multiple ablkcipher_request instances), pointer
+ * to plaintext and ciphertext, asynchronous callback function, etc. It acts
+ * as a handle to the ablkcipher_request_* API calls in a similar way as
+ * ablkcipher handle to the crypto_ablkcipher_* API calls.
+ */
+
+/**
+ * Return the size of the ablkcipher_request data structure to the caller.
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ *	number of bytes
+ */
 static inline unsigned int crypto_ablkcipher_reqsize(
 	struct crypto_ablkcipher *tfm)
 {
 	return crypto_ablkcipher_crt(tfm)->reqsize;
 }
 
+/**
+ * Allow the caller to replace the existing ablkcipher handle in the request
+ * data structure with a different one.
+ *
+ * @req request handle to be modified
+ * @tfm cipher handle that shall be added to the request handle
+ */
 static inline void ablkcipher_request_set_tfm(
 	struct ablkcipher_request *req, struct crypto_ablkcipher *tfm)
 {
@@ -806,6 +1100,18 @@ static inline struct ablkcipher_request *ablkcipher_request_cast(
 	return container_of(req, struct ablkcipher_request, base);
 }
 
+/**
+ * Allocate the request data structure that must be used with the ablkcipher
+ * encrypt and decrypt API calls. During the allocation, the provided ablkcipher
+ * handle is registered in the request data structure.
+ *
+ * @tfm cipher handle to be registered with the request
+ * @gfp memory allocation flag that is handed to kmalloc by the API call.
+ *
+ * return value:
+ *	allocated request handle in case of success
+ *	IS_ERR() is true in case of an error, PTR_ERR() returns the error code.
+ */
 static inline struct ablkcipher_request *ablkcipher_request_alloc(
 	struct crypto_ablkcipher *tfm, gfp_t gfp)
 {
@@ -820,11 +1126,40 @@ static inline struct ablkcipher_request *ablkcipher_request_alloc(
 	return req;
 }
 
+/**
+ * The referenced request data structure is zeroized and subsequently freed.
+ *
+ * @req request data structure cipher handle to be freed
+ */
 static inline void ablkcipher_request_free(struct ablkcipher_request *req)
 {
 	kzfree(req);
 }
 
+/**
+ * Setting the callback function that is triggered once the cipher operation
+ * completes
+ *
+ * The callback function is registered with the ablkcipher_request handle and
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
 static inline void ablkcipher_request_set_callback(
 	struct ablkcipher_request *req,
 	u32 flags, crypto_completion_t compl, void *data)
@@ -834,6 +1169,20 @@ static inline void ablkcipher_request_set_callback(
 	req->base.flags = flags;
 }
 
+/**
+ * Setting the source data and destination data scatter / gather lists.
+ *
+ * For encryption, the source is treated as the plaintext and the
+ * destination is the ciphertext. For a decryption operation, the use is
+ * reversed: the source is the ciphertext and the destination is the plaintext.
+ *
+ * @req request handle
+ * @src source scatter / gather list
+ * @dst destination scatter / gather list
+ * @nbytes number of bytes to process from @src
+ * @iv IV for the cipher operation which must comply with the IV size defined
+ *     by crypto_ablkcipher_ivsize
+ */
 static inline void ablkcipher_request_set_crypt(
 	struct ablkcipher_request *req,
 	struct scatterlist *src, struct scatterlist *dst,
-- 
2.1.0


