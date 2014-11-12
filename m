Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841AbaKLEce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:32:34 -0500
Received: from mail.eperm.de ([89.247.134.16]:54401 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662AbaKLEc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:32:28 -0500
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
Subject: [PATCH v3 07/13] crypto: Documentation - SHASH API documentation
Date: Wed, 12 Nov 2014 05:27:16 +0100
Message-ID: <1532314.JEsKM3iTVa@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1800066.efQ8hkST4U@tachyon.chronox.de>
References: <1800066.efQ8hkST4U@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API function calls exported by the kernel crypto API for SHASHes
to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/hash.h | 164 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index b2c193a..3d66e8b 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -583,6 +583,33 @@ static inline void ahash_request_set_crypt(struct ahash_request *req,
 	req->result = result;
 }
 
+/**
+ * DOC: Synchronous Message Digest API
+ *
+ * The synchronous message digest API is used with the ciphers of type
+ * CRYPTO_ALG_TYPE_SHASH (listed as type "shash" in /proc/crypto)
+ *
+ * The message digest API is able to maintain state information for the
+ * caller.
+ *
+ * The synchronous message digest API can store user-related context in in its
+ * shash_desc request data structure.
+ */
+
+/**
+ * crypto_alloc_shash() - allocate message digest handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      message digest cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for a message digest. The returned &struct
+ * crypto_shash is the cipher handle that is required for any subsequent
+ * API invocation for that message digest.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
 struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
 					u32 mask);
 
@@ -591,6 +618,10 @@ static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
 	return &tfm->base;
 }
 
+/**
+ * crypto_free_shash() - zeroize and free the message digest handle
+ * @tfm: cipher handle to be freed
+ */
 static inline void crypto_free_shash(struct crypto_shash *tfm)
 {
 	crypto_destroy_tfm(tfm, crypto_shash_tfm(tfm));
@@ -602,6 +633,15 @@ static inline unsigned int crypto_shash_alignmask(
 	return crypto_tfm_alg_alignmask(crypto_shash_tfm(tfm));
 }
 
+/**
+ * crypto_shash_blocksize() - obtain block size for cipher
+ * @tfm: cipher handle
+ *
+ * The block size for the message digest cipher referenced with the cipher
+ * handle is returned.
+ *
+ * Return: block size of cipher
+ */
 static inline unsigned int crypto_shash_blocksize(struct crypto_shash *tfm)
 {
 	return crypto_tfm_alg_blocksize(crypto_shash_tfm(tfm));
@@ -617,6 +657,15 @@ static inline struct shash_alg *crypto_shash_alg(struct crypto_shash *tfm)
 	return __crypto_shash_alg(crypto_shash_tfm(tfm)->__crt_alg);
 }
 
+/**
+ * crypto_shash_digestsize() - obtain message digest size
+ * @tfm: cipher handle
+ *
+ * The size for the message digest created by the message digest cipher
+ * referenced with the cipher handle is returned.
+ *
+ * Return: digest size of cipher
+ */
 static inline unsigned int crypto_shash_digestsize(struct crypto_shash *tfm)
 {
 	return crypto_shash_alg(tfm)->digestsize;
@@ -642,6 +691,21 @@ static inline void crypto_shash_clear_flags(struct crypto_shash *tfm, u32 flags)
 	crypto_tfm_clear_flags(crypto_shash_tfm(tfm), flags);
 }
 
+/**
+ * crypto_shash_descsize() - obtain the operational state size
+ * @tfm: cipher handle
+ *
+ * The size of the operational state the cipher needs during operation is
+ * returned for the hash referenced with the cipher handle. This size is
+ * required to calculate the memory requirements to allow the caller allocating
+ * sufficient memory for operational state.
+ *
+ * The operational state is defined with struct shash_desc where the size of
+ * that data structure is to be calculated as
+ * sizeof(struct shash_desc) + crypto_shash_descsize(alg)
+ *
+ * Return: size of the operational state
+ */
 static inline unsigned int crypto_shash_descsize(struct crypto_shash *tfm)
 {
 	return tfm->descsize;
@@ -652,29 +716,129 @@ static inline void *shash_desc_ctx(struct shash_desc *desc)
 	return desc->__ctx;
 }
 
+/**
+ * crypto_shash_setkey() - set key for message digest
+ * @tfm: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the keyed message digest cipher. The
+ * cipher handle must point to a keyed message digest cipher in order for this
+ * function to succeed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
 int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 			unsigned int keylen);
+
+/**
+ * crypto_shash_digest() - calculate message digest for buffer
+ * @desc: see crypto_shash_final()
+ * @data: see crypto_shash_update()
+ * @len: see crypto_shash_update()
+ * @out: see crypto_shash_final()
+ *
+ * This function is a "short-hand" for the function calls of crypto_shash_init,
+ * crypto_shash_update and crypto_shash_final. The parameters have the same
+ * meaning as discussed for those separate three functions.
+ *
+ * Return: 0 if the message digest creation was successful; < 0 if an error
+ *	   occurred
+ */
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out);
 
+/**
+ * crypto_shash_export() - extract operational state for message digest
+ * @desc: reference to the operational state handle whose state is exported
+ * @out: output buffer of sufficient size that can hold the hash state
+ *
+ * This function exports the hash state of the operational state handle into the
+ * caller-allocated output buffer out which must have sufficient size (e.g. by
+ * calling crypto_shash_descsize).
+ *
+ * Return: 0 if the export creation was successful; < 0 if an error occurred
+ */
 static inline int crypto_shash_export(struct shash_desc *desc, void *out)
 {
 	return crypto_shash_alg(desc->tfm)->export(desc, out);
 }
 
+/**
+ * crypto_shash_import() - import operational state
+ * @desc: reference to the operational state handle the state imported into
+ * @in: buffer holding the state
+ *
+ * This function imports the hash state into the operational state handle from
+ * the input buffer. That buffer should have been generated with the
+ * crypto_ahash_export function.
+ *
+ * Return: 0 if the import was successful; < 0 if an error occurred
+ */
 static inline int crypto_shash_import(struct shash_desc *desc, const void *in)
 {
 	return crypto_shash_alg(desc->tfm)->import(desc, in);
 }
 
+/**
+ * crypto_shash_init() - (re)initialize message digest
+ * @desc: operational state handle that is already filled
+ *
+ * The call (re-)initializes the message digest referenced by the
+ * operational state handle. Any potentially existing state created by
+ * previous operations is discarded.
+ *
+ * Return: 0 if the message digest initialization was successful; < 0 if an
+ *	   error occurred
+ */
 static inline int crypto_shash_init(struct shash_desc *desc)
 {
 	return crypto_shash_alg(desc->tfm)->init(desc);
 }
 
+/**
+ * crypto_shash_update() - add data to message digest for processing
+ * @desc: operational state handle that is already initialized
+ * @data: input data to be added to the message digest
+ * @len: length of the input data
+ *
+ * Updates the message digest state of the operational state handle.
+ *
+ * Return: 0 if the message digest update was successful; < 0 if an error
+ *	   occurred
+ */
 int crypto_shash_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len);
+
+/**
+ * crypto_shash_final() - calculate message digest
+ * @desc: operational state handle that is already filled with data
+ * @out: output buffer filled with the message digest
+ *
+ * Finalize the message digest operation and create the message digest
+ * based on all data added to the cipher handle. The message digest is placed
+ * into the output buffer. The caller must ensure that the output buffer is
+ * large enough by using crypto_shash_digestsize.
+ *
+ * Return: 0 if the message digest creation was successful; < 0 if an error
+ *	   occurred
+ */
 int crypto_shash_final(struct shash_desc *desc, u8 *out);
+
+/**
+ * crypto_shash_finup() - calculate message digest of buffer
+ * @desc: see crypto_shash_final()
+ * @data: see crypto_shash_update()
+ * @len: see crypto_shash_update()
+ * @out: see crypto_shash_final()
+ *
+ * This function is a "short-hand" for the function calls of
+ * crypto_shash_update and crypto_shash_final. The parameters have the same
+ * meaning as discussed for those separate functions.
+ *
+ * Return: 0 if the message digest creation was successful; < 0 if an error
+ *	   occurred
+ */
 int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len, u8 *out);
 
-- 
2.1.0


