Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaKLEbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:31:47 -0500
Received: from mail.eperm.de ([89.247.134.16]:54341 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaKLEbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:31:45 -0500
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
Subject: [PATCH v3 13/13] crypto: Documentation - HASH API documentation
Date: Wed, 12 Nov 2014 05:30:42 +0100
Message-ID: <2257814.zHSU59ZKgh@tachyon.chronox.de>
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
message digests to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/crypto.h | 119 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 0f95a07..208a632 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -2082,6 +2082,13 @@ static inline void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 						dst, src);
 }
 
+/**
+ * DOC: Synchronous Message Digest API
+ *
+ * The synchronous message digest API is used with the ciphers of type
+ * CRYPTO_ALG_TYPE_HASH (listed as type "hash" in /proc/crypto)
+ */
+
 static inline struct crypto_hash *__crypto_hash_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_hash *)tfm;
@@ -2094,6 +2101,20 @@ static inline struct crypto_hash *crypto_hash_cast(struct crypto_tfm *tfm)
 	return __crypto_hash_cast(tfm);
 }
 
+/**
+ * crypto_alloc_hash() - allocate synchronous message digest handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      message digest cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for a message digest. The returned struct
+ * crypto_hash is the cipher handle that is required for any subsequent
+ * API invocation for that message digest.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ * of an error, PTR_ERR() returns the error code.
+ */
 static inline struct crypto_hash *crypto_alloc_hash(const char *alg_name,
 						    u32 type, u32 mask)
 {
@@ -2110,11 +2131,25 @@ static inline struct crypto_tfm *crypto_hash_tfm(struct crypto_hash *tfm)
 	return &tfm->base;
 }
 
+/**
+ * crypto_free_hash() - zeroize and free message digest handle
+ * @tfm: cipher handle to be freed
+ */
 static inline void crypto_free_hash(struct crypto_hash *tfm)
 {
 	crypto_free_tfm(crypto_hash_tfm(tfm));
 }
 
+/**
+ * crypto_has_hash() - Search for the availability of a message digest
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      message digest cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Return: true when the message digest cipher is known to the kernel crypto
+ *	   API; false otherwise
+ */
 static inline int crypto_has_hash(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
@@ -2130,6 +2165,15 @@ static inline struct hash_tfm *crypto_hash_crt(struct crypto_hash *tfm)
 	return &crypto_hash_tfm(tfm)->crt_hash;
 }
 
+/**
+ * crypto_hash_blocksize() - obtain block size for message digest
+ * @tfm: cipher handle
+ *
+ * The block size for the message digest cipher referenced with the cipher
+ * handle is returned.
+ *
+ * Return: block size of cipher
+ */
 static inline unsigned int crypto_hash_blocksize(struct crypto_hash *tfm)
 {
 	return crypto_tfm_alg_blocksize(crypto_hash_tfm(tfm));
@@ -2140,6 +2184,15 @@ static inline unsigned int crypto_hash_alignmask(struct crypto_hash *tfm)
 	return crypto_tfm_alg_alignmask(crypto_hash_tfm(tfm));
 }
 
+/**
+ * crypto_hash_digestsize() - obtain message digest size
+ * @tfm: cipher handle
+ *
+ * The size for the message digest created by the message digest cipher
+ * referenced with the cipher handle is returned.
+ *
+ * Return: message digest size
+ */
 static inline unsigned int crypto_hash_digestsize(struct crypto_hash *tfm)
 {
 	return crypto_hash_crt(tfm)->digestsize;
@@ -2160,11 +2213,38 @@ static inline void crypto_hash_clear_flags(struct crypto_hash *tfm, u32 flags)
 	crypto_tfm_clear_flags(crypto_hash_tfm(tfm), flags);
 }
 
+/**
+ * crypto_hash_init() - (re)initialize message digest handle
+ * @desc: cipher request handle that to be filled by caller --
+ *	  desc.tfm is filled with the hash cipher handle;
+ *	  desc.flags is filled with either CRYPTO_TFM_REQ_MAY_SLEEP or 0.
+ *
+ * The call (re-)initializes the message digest referenced by the hash cipher
+ * request handle. Any potentially existing state created by previous
+ * operations is discarded.
+ *
+ * Return: 0 if the message digest initialization was successful; < 0 if an
+ *	   error occurred
+ */
 static inline int crypto_hash_init(struct hash_desc *desc)
 {
 	return crypto_hash_crt(desc->tfm)->init(desc);
 }
 
+/**
+ * crypto_hash_update() - add data to message digest for processing
+ * @desc: cipher request handle
+ * @sg: scatter / gather list pointing to the data to be added to the message
+ *      digest
+ * @nbytes: number of bytes to be processed from @sg
+ *
+ * Updates the message digest state of the cipher handle pointed to by the
+ * hash cipher request handle with the input data pointed to by the
+ * scatter/gather list.
+ *
+ * Return: 0 if the message digest update was successful; < 0 if an error
+ *	   occurred
+ */
 static inline int crypto_hash_update(struct hash_desc *desc,
 				     struct scatterlist *sg,
 				     unsigned int nbytes)
@@ -2172,11 +2252,39 @@ static inline int crypto_hash_update(struct hash_desc *desc,
 	return crypto_hash_crt(desc->tfm)->update(desc, sg, nbytes);
 }
 
+/**
+ * crypto_hash_final() - calculate message digest
+ * @desc: cipher request handle
+ * @out: message digest output buffer -- The caller must ensure that the out
+ *	 buffer has a sufficient size (e.g. by using the crypto_hash_digestsize
+ *	 function).
+ *
+ * Finalize the message digest operation and create the message digest
+ * based on all data added to the cipher handle. The message digest is placed
+ * into the output buffer.
+ *
+ * Return: 0 if the message digest creation was successful; < 0 if an error
+ *	   occurred
+ */
 static inline int crypto_hash_final(struct hash_desc *desc, u8 *out)
 {
 	return crypto_hash_crt(desc->tfm)->final(desc, out);
 }
 
+/**
+ * crypto_hash_digest() - calculate message digest for a buffer
+ * @desc: see crypto_hash_final()
+ * @sg: see crypto_hash_update()
+ * @nbytes:  see crypto_hash_update()
+ * @out: see crypto_hash_final()
+ *
+ * This function is a "short-hand" for the function calls of crypto_hash_init,
+ * crypto_hash_update and crypto_hash_final. The parameters have the same
+ * meaning as discussed for those separate three functions.
+ *
+ * Return: 0 if the message digest creation was successful; < 0 if an error
+ *	   occurred
+ */
 static inline int crypto_hash_digest(struct hash_desc *desc,
 				     struct scatterlist *sg,
 				     unsigned int nbytes, u8 *out)
@@ -2184,6 +2292,17 @@ static inline int crypto_hash_digest(struct hash_desc *desc,
 	return crypto_hash_crt(desc->tfm)->digest(desc, sg, nbytes, out);
 }
 
+/**
+ * crypto_hash_setkey() - set key for message digest
+ * @hash: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the message digest cipher. The cipher
+ * handle must point to a keyed hash in order for this function to succeed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
 static inline int crypto_hash_setkey(struct crypto_hash *hash,
 				     const u8 *key, unsigned int keylen)
 {
-- 
2.1.0


