Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaKBUn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:43:57 -0500
Received: from mail.eperm.de ([89.247.134.16]:54219 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaKBUnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:43:52 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 05/11] crypto: Documentation - SHASH API documentation
Date: Sun, 02 Nov 2014 21:38:17 +0100
Message-ID: <4369238.HKIfZc71d8@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <6375771.bx7QqLJLuR@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API function calls exported by the kernel crypto API for SHASHes
to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
CC: Marek Vasut <marex@denx.de>
---
 include/crypto/hash.h | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 197 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 0d43dbc..7b3a621 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -484,6 +484,33 @@ static inline void ahash_request_set_crypt(struct ahash_request *req,
 	req->result = result;
 }
 
+/**
+ * Synchronous message digest API to use the ciphers of type
+ * CRYPTO_ALG_TYPE_SHASH (listed as type "shash" in /proc/crypto)
+ *
+ * Considering the discussion of the state maintenance for the synchronous
+ * block cipher API, the message digest API is also able to maintain state
+ * information for the caller. Though, the maintenance of the state is a bit
+ * different for the message digest API.
+ *
+ * The synchronous message digest API can store user-related context in in its
+ * shash_desc request data structure.
+ */
+
+/**
+ * Allocate a cipher handle for a message digest. The returned struct
+ * crypto_shash is the cipher handle that is required for any subsequent
+ * API invocation for that message digest.
+ *
+ * @alg_name is the cra_name / name or cra_driver_name / driver name of the
+ *	     message digest cipher
+ * @type specifies the type of the cipher (see Documentation/crypto/)
+ * @mask specifies the mask for the cipher (see Documentation/crypto/)
+ *
+ * return value:
+ *	allocated cipher handle in case of success
+ *	IS_ERR() is true in case of an error, PTR_ERR() returns the error code.
+ */
 struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
 					u32 mask);
 
@@ -492,6 +519,12 @@ static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
 	return &tfm->base;
 }
 
+/**
+ * The referenced message digest handle is zeroized and subsequently
+ * freed.
+ *
+ * @tfm cipher handle to be freed
+ */
 static inline void crypto_free_shash(struct crypto_shash *tfm)
 {
 	crypto_destroy_tfm(tfm, crypto_shash_tfm(tfm));
@@ -503,6 +536,15 @@ static inline unsigned int crypto_shash_alignmask(
 	return crypto_tfm_alg_alignmask(crypto_shash_tfm(tfm));
 }
 
+/**
+ * The block size for the message digest cipher referenced with the cipher
+ * handle is returned.
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ * 	block size of cipher
+ */
 static inline unsigned int crypto_shash_blocksize(struct crypto_shash *tfm)
 {
 	return crypto_tfm_alg_blocksize(crypto_shash_tfm(tfm));
@@ -518,6 +560,15 @@ static inline struct shash_alg *crypto_shash_alg(struct crypto_shash *tfm)
 	return __crypto_shash_alg(crypto_shash_tfm(tfm)->__crt_alg);
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
 static inline unsigned int crypto_shash_digestsize(struct crypto_shash *tfm)
 {
 	return crypto_shash_alg(tfm)->digestsize;
@@ -543,6 +594,60 @@ static inline void crypto_shash_clear_flags(struct crypto_shash *tfm, u32 flags)
 	crypto_tfm_clear_flags(crypto_shash_tfm(tfm), flags);
 }
 
+/**
+ * The size of the operational state the cipher needs during operation is
+ * returned for the hash referenced with the cipher handle. This size is
+ * required to calculate the memory requirements to allow the caller allocating
+ * sufficient memory for operational state.
+ *
+ * The operational state is defined with struct shash_desc where the size of
+ * that data structure is to be calculated as
+ * sizeof(struct shash_desc) + crypto_shash_descsize(alg)
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ * 	size of the operational state
+ *
+ * The following example code shall illustrate the use of the operational
+ * state memory:
+ *
+ *struct sdesc {
+ *	struct shash_desc shash;
+ *	char ctx[];
+ *};
+ *
+ *static struct sdesc *init_sdesc(struct crypto_shash *alg)
+ *{
+ *	struct sdesc *sdesc;
+ *	int size;
+ *
+ *	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
+ *	sdesc = kmalloc(size, GFP_KERNEL);
+ *	if (!sdesc)
+ *		return ERR_PTR(-ENOMEM);
+ *	sdesc->shash.tfm = alg;
+ *	sdesc->shash.flags = 0x0;
+ *	return sdesc;
+ *}
+ *
+ *static int calc_hash(struct crypto_shash *alg,
+ *		     const unsigned char *data, unsigned int datalen,
+ *		     unsigned char *digest) {
+ *	struct sdesc *sdesc;
+ *	int ret;
+ *
+ *	sdesc = init_sdesc(alg);
+ *	if (IS_ERR(sdesc)) {
+ *		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+ *		return PTR_ERR(sdesc);
+ *	}
+ *
+ *	ret = crypto_shash_digest(&sdesc->shash, data, datalen, digest);
+ *	kfree(sdesc);
+ *	return ret;
+ *}
+ */
 static inline unsigned int crypto_shash_descsize(struct crypto_shash *tfm)
 {
 	return tfm->descsize;
@@ -553,29 +658,121 @@ static inline void *shash_desc_ctx(struct shash_desc *desc)
 	return desc->__ctx;
 }
 
+/**
+ * The caller provided key is set for the message digest cipher. The cipher
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
 int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 			unsigned int keylen);
+
+/**
+ * This function is a "short-hand" for the function calls of crypto_shash_init,
+ * crypto_shash_update and crypto_shash_final. The parameters have the same
+ * meaning as discussed for those separate three functions.
+ *
+ * return value:
+ *	0 if the message digest creation was successful
+ *	< 0 if an error occurred
+ */
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out);
 
+/**
+ * This function exports the hash state of the operational state handle into the
+ * caller-allocated output buffer out which must have sufficient size (e.g. by
+ * calling crypto_shash_descsize).
+ *
+ * @desc reference to the operational state handle whose state is exported
+ * @out output buffer of sufficient size that can hold the hash state
+ *
+ * return value:
+ *	0 if the export creation was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_shash_export(struct shash_desc *desc, void *out)
 {
 	return crypto_shash_alg(desc->tfm)->export(desc, out);
 }
 
+/**
+ * This function imports the hash state into the operational state handle from
+ * the input buffer. That buffer should have been generated with the
+ * crypto_ahash_export function.
+ *
+ * @desc reference to the operational state handle the state imported into
+ * @in buffer holding the state
+ *
+ * return value:
+ *	0 if the import was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_shash_import(struct shash_desc *desc, const void *in)
 {
 	return crypto_shash_alg(desc->tfm)->import(desc, in);
 }
 
+/**
+ * The call (re-)initializes the message digest referenced by the
+ * operational state handle. Any potentially existing state created by
+ * previous operations is discarded.
+ *
+ * @desc operational state handle that is already filled
+ *
+ * return value:
+ *	0 if the message digest initialization was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_shash_init(struct shash_desc *desc)
 {
 	return crypto_shash_alg(desc->tfm)->init(desc);
 }
 
+/**
+ * Updates the message digest state of the operational state handle.
+ *
+ * @desc operational state handle that is already initialized
+ * @data input data to be added to the message digest
+ * @len length of the input data
+ *
+ * return value:
+ *	0 if the message digest update was successful
+ *	< 0 if an error occurred
+ */
 int crypto_shash_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len);
+
+/**
+ * Finalize the message digest operation and create the message digest
+ * based on all data added to the cipher handle. The message digest is placed
+ * into the output buffer. The caller must ensure that the output buffer is
+ * large enough by using crypto_shash_digestsize.
+ *
+ * @desc operational state handle that is already filled with data
+ * @out output buffer filled with the message digest
+ *
+ * return value:
+ *	0 if the message digest creation was successful
+ *	< 0 if an error occurred
+ */
 int crypto_shash_final(struct shash_desc *desc, u8 *out);
+
+/**
+ * This function is a "short-hand" for the function calls of
+ * crypto_shash_update and crypto_shash_final. The parameters have the same
+ * meaning as discussed for those separate functions.
+ *
+ * return value:
+ *	0 if the message digest creation was successful
+ *	< 0 if an error occurred
+ */
 int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len, u8 *out);
 
-- 
2.1.0


