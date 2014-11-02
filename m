Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaKBUoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:44:05 -0500
Received: from mail.eperm.de ([89.247.134.16]:54235 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbaKBUn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:43:58 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 03/11] crypto: Documentation - RNG API documentation
Date: Sun, 02 Nov 2014 21:36:58 +0100
Message-ID: <5465244.OPD58DmVa6@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <6375771.bx7QqLJLuR@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API function calls exported by the kernel crypto API for RNGs to
be used by consumers are documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
CC: Marek Vasut <marex@denx.de>
---
 include/crypto/rng.h | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index c93f9b9..83c4238 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -20,11 +20,68 @@ extern struct crypto_rng *crypto_default_rng;
 int crypto_get_default_rng(void);
 void crypto_put_default_rng(void);
 
+/**
+ * Random number generator API to use the ciphers of type
+ * CRYPTO_ALG_TYPE_RNG (listed as type "rng" in /proc/crypto)
+ *
+ * Example code:
+ *
+ *static int get_random_numbers(u8 *buf, unsigned int len)
+ *{
+ *	struct crypto_rng *rng = NULL;
+ *	char *drbg = "drbg_nopr_sha256"; // Hash DRBG with SHA-256, no PR
+ *	int ret;
+ *
+ *	if (!buf || !len) {
+ *		pr_debug("No output buffer provided\n");
+ *		return -EINVAL;
+ *	}
+ *
+ *	rng = crypto_alloc_rng(drbg, 0, 0);
+ *	if (IS_ERR(rng)) {
+ *		pr_debug("could not allocate RNG handle for %s\n", drbg);
+ *		return -PTR_ERR(rng);
+ *	}
+ *
+ *	ret = crypto_rng_get_bytes(rng, buf, len);
+ *	if (ret < 0)
+ *		pr_debug("generation of random numbers failed\n");
+ *	else if (ret == 0)
+ *		pr_debug("RNG returned no data");
+ *	else
+ *		pr_debug("RNG returned %d bytes of data\n", ret);
+ *
+ *out:
+ *	crypto_free_rng(rng);
+ *	return ret;
+ *}
+ */
+
 static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_rng *)tfm;
 }
 
+/**
+ * Allocate a cipher handle for a random number generator. The returned struct
+ * crypto_rng is the cipher handle that is required for any subsequent
+ * API invocation for that random number generator.
+ *
+ * For all random number generators, this call creates a new private copy of
+ * the random number generator that does not share a state with other
+ * instances. The only exception is the "krng" random number generator which
+ * is a kernel crypto API use case for the get_random_bytes() function of the
+ * /dev/random driver.
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
 static inline struct crypto_rng *crypto_alloc_rng(const char *alg_name,
 						  u32 type, u32 mask)
 {
@@ -40,6 +97,14 @@ static inline struct crypto_tfm *crypto_rng_tfm(struct crypto_rng *tfm)
 	return &tfm->base;
 }
 
+/**
+ * Return the generic name (cra_name) of the initialized random number generator
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ *	generic name string
+ */
 static inline struct rng_alg *crypto_rng_alg(struct crypto_rng *tfm)
 {
 	return &crypto_rng_tfm(tfm)->__crt_alg->cra_rng;
@@ -50,23 +115,71 @@ static inline struct rng_tfm *crypto_rng_crt(struct crypto_rng *tfm)
 	return &crypto_rng_tfm(tfm)->crt_rng;
 }
 
+/**
+ * The referenced random number generator handle is zeroized and subsequently
+ * freed.
+ *
+ * @tfm cipher handle to be freed
+ */
 static inline void crypto_free_rng(struct crypto_rng *tfm)
 {
 	crypto_free_tfm(crypto_rng_tfm(tfm));
 }
 
+/**
+ * This function fills the caller-allocated buffer with random numbers using the
+ * random number generator referenced by the cipher handle.
+ *
+ * @tfm cipher handle
+ * @rdata output buffer holding the random numbers
+ * @dlen length of the output buffer
+ *
+ * return value:
+ *	> 0 function was successful and returns the number of generated bytes
+ *	< 0 if an error occurred
+ */
 static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
 				       u8 *rdata, unsigned int dlen)
 {
 	return crypto_rng_crt(tfm)->rng_gen_random(tfm, rdata, dlen);
 }
 
+/**
+ * The reset function completely re-initializes the random number generator
+ * referenced by the cipher handle by clearing the current state. The new state
+ * is initialized with the caller provided seed or automatically, depending
+ * on the random number generator type (the ANSI X9.31 RNG requires
+ * caller-provided seed, the SP800-90A DRBGs perform an automatic seeding).
+ * The seed is provided with the. The provided seed should have the length of
+ * the seed size defined for the random number generator as defined by
+ * crypto_rng_seedsize.
+ *
+ * @tfm cipher handle
+ * @seed seed input data
+ * @slen length of the seed input data
+ *
+ * return value:
+ *	0 if the setting of the key was successful
+ *	< 0 if an error occurred
+ */
 static inline int crypto_rng_reset(struct crypto_rng *tfm,
 				   u8 *seed, unsigned int slen)
 {
 	return crypto_rng_crt(tfm)->rng_reset(tfm, seed, slen);
 }
 
+/**
+ * The function returns the seed size for the random number generator
+ * referenced by the cipher handle. This value may be zero if the random
+ * number generator does not implement or require a reseeding. For example,
+ * the SP800-90A DRBGs implement an automated reseeding after reaching a
+ * pre-defined threshold.
+ *
+ * @tfm cipher handle
+ *
+ * return value:
+ *	seed size for the random number generator
+ */
 static inline int crypto_rng_seedsize(struct crypto_rng *tfm)
 {
 	return crypto_rng_alg(tfm)->seedsize;
-- 
2.1.0


