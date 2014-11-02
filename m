Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaKBUnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:43:37 -0500
Received: from mail.eperm.de ([89.247.134.16]:54168 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbaKBUne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:43:34 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 11/11] crypto: Documentation - HASH API documentation
Date: Sun, 02 Nov 2014 21:42:06 +0100
Message-ID: <1602710.mIQNeDGnzH@tachyon.chronox.de>
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
message digests to be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
CC: Marek Vasut <marex@denx.de>
---
 include/linux/crypto.h | 117 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b2c3ebb..de44f2d 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -2190,6 +2190,11 @@ static inline void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 						dst, src);
 }
 
+/**
+ * Synchronous message digest API to use the ciphers of type
+ * CRYPTO_ALG_TYPE_HASH (listed as type "hash" in /proc/crypto)
+ */
+
 static inline struct crypto_hash *__crypto_hash_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_hash *)tfm;
@@ -2202,6 +2207,20 @@ static inline struct crypto_hash *crypto_hash_cast(struct crypto_tfm *tfm)
 	return __crypto_hash_cast(tfm);
 }
 
+/**
+ * Allocate a cipher handle for a message digest. The returned struct
+ * crypto_hash is the cipher handle that is required for any subsequent
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
 static inline struct crypto_hash *crypto_alloc_hash(const char *alg_name,
 						    u32 type, u32 mask)
 {
@@ -2218,11 +2237,29 @@ static inline struct crypto_tfm *crypto_hash_tfm(struct crypto_hash *tfm)
 	return &tfm->base;
 }
 
+/**
+ * The referenced message digest handle is zeroized and subsequently
+ * freed.
+ *
+ * @tfm cipher handle to be freed
+ */
 static inline void crypto_free_hash(struct crypto_hash *tfm)
 {
 	crypto_free_tfm(crypto_hash_tfm(tfm));
 }
 
+/**
+ * Lookup function to search for the availability of a message digest cipher.
+ *
+ * @alg_name is the cra_name / name or cra_driver_name / driver name of the
+ *	     message digest cipher
+ * @type specifies the type of the cipher (see Documentation/crypto/)
+ * @mask specifies the mask for the cipher (see Documentation/crypto/)
+
+ * return value:
+ *	true when the message digest cipher is known to the kernel crypto API.
+ *	false otherwise
+ */
 static inline int crypto_has_hash(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
@@ -2238,6 +2275,15 @@ static inline struct hash_tfm *crypto_hash_crt(struct crypto_hash *tfm)
 	return &crypto_hash_tfm(tfm)->crt_hash;
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
 static inline unsigned int crypto_hash_blocksize(struct crypto_hash *tfm)
 {
 	return crypto_tfm_alg_blocksize(crypto_hash_tfm(tfm));
@@ -2248,6 +2294,15 @@ static inline unsigned int crypto_hash_alignmask(struct crypto_hash *tfm)
 	return crypto_tfm_alg_alignmask(crypto_hash_tfm(tfm));
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
 static inline unsigned int crypto_hash_digestsize(struct crypto_hash *tfm)
 {
 	return crypto_hash_crt(tfm)->digestsize;
@@ -2268,11 +2323,38 @@ static inline void crypto_hash_clear_flags(struct crypto_hash *tfm, u32 flags)
 	crypto_tfm_clear_flags(crypto_hash_tfm(tfm), flags);
 }
 
+/**
+ * The call (re-)initializes the message digest referenced by the hash cipher
+ * request handle. Any potentially existing state created by previous
+ * operations is discarded.
+ *
+ * @desc cipher request handle that to be filled by caller as follows:
+ *	desc.tfm is filled with the hash cipher handle
+ *	desc.flags is filled with either CRYPTO_TFM_REQ_MAY_SLEEP or 0
+ *
+ * return value:
+ *	0 if the message digest initialization was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_hash_init(struct hash_desc *desc)
 {
 	return crypto_hash_crt(desc->tfm)->init(desc);
 }
 
+/**
+ * Updates the message digest state of the cipher handle pointed to by the
+ * hash cipher request handle with the input data pointed to by the
+ * scatter/gather list.
+ *
+ * @desc cipher request handle
+ * @sg scatter / gather list pointing to the data to be added to the message
+ *     digest
+ * @nbytes number of bytes to be processed from @sg
+ *
+ * return value:
+ *	0 if the message digest update was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_hash_update(struct hash_desc *desc,
 				     struct scatterlist *sg,
 				     unsigned int nbytes)
@@ -2280,11 +2362,34 @@ static inline int crypto_hash_update(struct hash_desc *desc,
 	return crypto_hash_crt(desc->tfm)->update(desc, sg, nbytes);
 }
 
+/**
+ * Finalize the message digest operation and create the message digest
+ * based on all data added to the cipher handle. The message digest is placed
+ * into the output buffer.
+ *
+ * @desc cipher request handle
+ * @out message digest output buffer -- The caller must ensure that the out
+ *	buffer has a sufficient size (e.g. by using the crypto_hash_digestsize
+ *	function).
+ *
+ * return value:
+ *	0 if the message digest creation was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_hash_final(struct hash_desc *desc, u8 *out)
 {
 	return crypto_hash_crt(desc->tfm)->final(desc, out);
 }
 
+/**
+ * This function is a "short-hand" for the function calls of crypto_hash_init,
+ * crypto_hash_update and crypto_hash_final. The parameters have the same
+ * meaning as discussed for those separate three functions.
+ *
+ * return value:
+ *	0 if the message digest creation was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_hash_digest(struct hash_desc *desc,
 				     struct scatterlist *sg,
 				     unsigned int nbytes, u8 *out)
@@ -2292,6 +2397,18 @@ static inline int crypto_hash_digest(struct hash_desc *desc,
 	return crypto_hash_crt(desc->tfm)->digest(desc, sg, nbytes, out);
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
 static inline int crypto_hash_setkey(struct crypto_hash *hash,
 				     const u8 *key, unsigned int keylen)
 {
-- 
2.1.0


