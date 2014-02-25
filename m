Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaBYVbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:31:55 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:55155 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaBYVbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:31:52 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 16:31:51 EST
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++LBHK3HcEv/rWJQQ==
X-RZG-CLASS-ID: mo00
From: Stephan Mueller <smueller@chronox.de>
To: LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [RFC][PATCH] SP800-90A DRBG
Date: Tue, 25 Feb 2014 22:25:24 +0100
Message-ID: <3318114.8Il0YIGDM1@myon.chronox.de>
User-Agent: KMail/4.11.5 (Linux/3.12.10-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As defined in SP800-131A, the ANSI X9.31 DRNG is to be sunset by the end of 
this year for official uses, including FIPS 140-2 compliance.

I created a clean-room implementation of the DRBGs defined in SP800-90A, 
specifically the Hash DRBG, HMAC DRBG and CTR DRBG. All three DRBGs are 
implemented with a derivation function and with the support of prediction 
resistance.

The implementation is available at [1]. That implementation is functionally 
complete as it implements all aspects defined by SP800-90A. [1] is a self-
contained implementation that registers the different DRBGs with the kernel 
crypto API. In addition, a test module is provided that demonstrates the 
proper operation of all DRBGs. The provided code is ready for testing by 
simply calling make and loading the resulting kernel module into the kernel. A 
second test module is provided in tests/kernel and demonstrates how to use the 
DRBG with the kernel crypto API.

The code [1] just needs some small refactoring to turn them into a patch for 
the request for inclusion into the kernel -- and asking for an official review 
:-) . For example, the self tests need to be extracted and put into the 
testmgr.c. Also, the contents drbg-kernel.h needs to go into the drbg.c file. 
I am happy to perform the changes and offer ready-to-go patches. The current 
code, however, allows for easy development. But before making a full patch 
set, there are several issues that need to be clarified. All issues are marked 
with TODOs throughout the code. With the following list, all issues are 
extracted.

May I ask for help to clarify the following questions:

* The kernel crypto API does not offer a reseed API call. Wouldn't it make 
sense to add such a reseed API? Attached is a patch that I would propose -- 
this patch includes the reseed function for the existing ANSI X9.31 DRNG. 
Although this patch is against 3.11, it works with 3.13. If accepted, I would 
add that patch to the to-be-developed overall patch set for the DRBG and 
integrate the DRBG reseed invocation.

* The SP800-90A defines that a caller requesting the initialization of the 
DRBG may provide a so-called "personalization string" that is used as data 
concatenated with real seed. The DRBG code implements the proper handling of 
the personalization string. Though, the kernel crypto API initialization call 
cra_init does not allow the caller to provide such additional data.

* Similar to for initialization, SP800-90A allows the requestor of random bits 
to provide "additional information" which are to be mixed into the DRBG before 
generating the random bits. The DRBG code implements the proper handling of 
the additional information string. Though, the kernel crypto API call of 
cra_u.rng.rng_make_random does not allow the caller to provide such additional 
data.

* I am unsure what the reset call of the kernel crypto API mean for a DRBG. As 
the DRBG gathers its seed data automatically and not from the caller, a 
clearing of the DRBG state and reinstantiation does not seem to provide any 
logical reasons.  

[1] http://www.chronox.de/drbg.html

Ciao
Stephan
---
diff -purN linux-3.11.orig/crypto/ansi_cprng.c linux-3.11/crypto/ansi_cprng.c
--- linux-3.11.orig/crypto/ansi_cprng.c	2013-09-30 14:44:05.378128532 +0200
+++ linux-3.11/crypto/ansi_cprng.c	2013-09-30 14:51:57.726790936 +0200
@@ -53,6 +53,7 @@ struct prng_context {
 	u32 rand_data_valid;
 	struct crypto_cipher *tfm;
 	u32 flags;
+	u8 vpos;
 };
 
 static int dbg;
@@ -368,17 +369,40 @@ static int cprng_reset(struct crypto_rng
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 	u8 *key = seed + DEFAULT_BLK_SZ;
 	u8 *dt = NULL;
+	int rc = 0;
 
+	/* reseed the RNG in case we have too little data to reset */
 	if (slen < DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
-		return -EINVAL;
-
-	if (slen >= (2 * DEFAULT_BLK_SZ + DEFAULT_PRNG_KSZ))
-		dt = key + DEFAULT_PRNG_KSZ;
+		rc = cprng_reseed(prng, seed, slen);
+	else
+	{
+		if (slen >= (2 * DEFAULT_BLK_SZ + DEFAULT_PRNG_KSZ))
+			dt = key + DEFAULT_PRNG_KSZ;
+		rc = reset_prng_context(prng, key, DEFAULT_PRNG_KSZ, seed, 
dt);
+		if (prng->flags & PRNG_NEED_RESET)
+			return -EINVAL;
+	}
 
-	reset_prng_context(prng, key, DEFAULT_PRNG_KSZ, seed, dt);
+	return rc;
+}
 
-	if (prng->flags & PRNG_NEED_RESET)
+static int cprng_reseed(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+{
+	struct prng_context *prng = crypto_rng_ctx(tfm);
+	unsigned int i = 0;
+	if(!slen)
 		return -EINVAL;
+	if(!seed)
+		return -EINVAL;
+
+	spin_lock_bh(&prng->prng_lock);
+	for (i = 0; i < slen; i++)
+	{
+		prng->V[prng->vpos++] ^= seed[i];
+		if(DEFAULT_BLK_SZ == prng->vpos)
+			prng->vpos = 0;
+	}
+	spin_unlock_bh(&prng->prng_lock);
 	return 0;
 }
 
@@ -399,12 +423,13 @@ static int fips_cprng_reset(struct crypt
 
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 
-	if (slen < DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
-		return -EINVAL;
-
-	/* fips strictly requires seed != key */
-	if (!memcmp(seed, key, DEFAULT_PRNG_KSZ))
-		return -EINVAL;
+	/* Only perform FIPS test if we set the seed together with the key */
+	if (slen >= DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
+	{
+		/* fips strictly requires seed != key */
+		if (!memcmp(seed, key, DEFAULT_PRNG_KSZ))
+			return -EINVAL;
+	}
 
 	rc = cprng_reset(tfm, seed, slen);
 
@@ -434,7 +459,9 @@ static struct crypto_alg rng_algs[] = {
 		.rng = {
 			.rng_make_random	= cprng_get_random,
 			.rng_reset		= cprng_reset,
+			.rng_reseed		= cprng_reseed,
 			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
+			.reseedsize = DEFAULT_BLK_SZ,
 		}
 	}
 #ifdef CONFIG_CRYPTO_FIPS
@@ -452,7 +479,9 @@ static struct crypto_alg rng_algs[] = {
 		.rng = {
 			.rng_make_random	= fips_cprng_get_random,
 			.rng_reset		= fips_cprng_reset,
+			.rng_reseed		= cprng_reseed,
 			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
+			.reseedsize = DEFAULT_BLK_SZ,
 		}
 	}
 #endif
diff -purN linux-3.11.orig/crypto/krng.c linux-3.11/crypto/krng.c
--- linux-3.11.orig/crypto/krng.c	2013-09-30 14:44:05.285128408 +0200
+++ linux-3.11/crypto/krng.c	2013-09-30 14:45:42.692261818 +0200
@@ -22,11 +22,6 @@ static int krng_get_random(struct crypto
 	return 0;
 }
 
-static int krng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
-{
-	return 0;
-}
-
 static struct crypto_alg krng_alg = {
 	.cra_name		= "stdrng",
 	.cra_driver_name	= "krng",
@@ -38,8 +33,8 @@ static struct crypto_alg krng_alg = {
 	.cra_u			= {
 		.rng = {
 			.rng_make_random	= krng_get_random,
-			.rng_reset		= krng_reset,
 			.seedsize		= 0,
+			.reseedsize		= 0,
 		}
 	}
 };
diff -purN linux-3.11.orig/crypto/rng.c linux-3.11/crypto/rng.c
--- linux-3.11.orig/crypto/rng.c	2013-09-30 14:44:05.269128387 +0200
+++ linux-3.11/crypto/rng.c	2013-09-30 14:45:42.693261819 +0200
@@ -29,7 +29,8 @@ struct crypto_rng *crypto_default_rng;
 EXPORT_SYMBOL_GPL(crypto_default_rng);
 static int crypto_default_rng_refcnt;
 
-static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+static int rngapi_seeding(struct crypto_rng *tfm, u8 *seed, unsigned int 
slen,
+			  int (*rng_update)(struct crypto_rng *tfm, u8 *seed, 
unsigned int slen))
 {
 	u8 *buf = NULL;
 	int err;
@@ -43,12 +44,26 @@ static int rngapi_reset(struct crypto_rn
 		seed = buf;
 	}
 
-	err = crypto_rng_alg(tfm)->rng_reset(tfm, seed, slen);
+	err = rng_update(tfm, seed, slen);
 
 	kfree(buf);
 	return err;
 }
 
+static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+{
+	if(!crypto_rng_alg(tfm)->rng_reset)
+		return 0;
+	return rngapi_seeding(tfm, seed, slen, crypto_rng_alg(tfm)-
>rng_reset);
+}
+
+static int rngapi_reseed(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+{
+	if(!crypto_rng_alg(tfm)->rng_reseed)
+		return 0;
+	return rngapi_seeding(tfm, seed, slen, crypto_rng_alg(tfm)-
>rng_reseed);
+}
+
 static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	struct rng_alg *alg = &tfm->__crt_alg->cra_rng;
@@ -56,6 +71,7 @@ static int crypto_init_rng_ops(struct cr
 
 	ops->rng_gen_random = alg->rng_make_random;
 	ops->rng_reset = rngapi_reset;
+	ops->rng_reseed = rngapi_reseed;
 
 	return 0;
 }
diff -purN linux-3.11.orig/include/crypto/rng.h 
linux-3.11/include/crypto/rng.h
--- linux-3.11.orig/include/crypto/rng.h	2013-09-30 14:44:18.627146241 
+0200
+++ linux-3.11/include/crypto/rng.h	2013-09-30 14:45:42.693261819 +0200
@@ -67,9 +67,20 @@ static inline int crypto_rng_reset(struc
 	return crypto_rng_crt(tfm)->rng_reset(tfm, seed, slen);
 }
 
+static inline int crypto_rng_reseed(struct crypto_rng *tfm,
+				    u8 *seed, unsigned int slen)
+{
+	return crypto_rng_crt(tfm)->rng_reseed(tfm, seed, slen);
+}
+
 static inline int crypto_rng_seedsize(struct crypto_rng *tfm)
 {
 	return crypto_rng_alg(tfm)->seedsize;
 }
 
+static inline int crypto_rng_reseedsize(struct crypto_rng *tfm)
+{
+	return crypto_rng_alg(tfm)->reseedsize;
+}
+
 #endif
diff -purN linux-3.11.orig/include/linux/crypto.h 
linux-3.11/include/linux/crypto.h
--- linux-3.11.orig/include/linux/crypto.h	2013-09-30 14:44:22.248151116 
+0200
+++ linux-3.11/include/linux/crypto.h	2013-09-30 14:45:42.694261821 +0200
@@ -265,8 +265,10 @@ struct rng_alg {
 	int (*rng_make_random)(struct crypto_rng *tfm, u8 *rdata,
 			       unsigned int dlen);
 	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
+	int (*rng_reseed)(struct crypto_rng *tfm, u8 *seed, unsigned int 
slen);
 
 	unsigned int seedsize;
+	unsigned int reseedsize;
 };
 
 
@@ -400,6 +402,7 @@ struct rng_tfm {
 	int (*rng_gen_random)(struct crypto_rng *tfm, u8 *rdata,
 			      unsigned int dlen);
 	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
+	int (*rng_reseed)(struct crypto_rng *tfm, u8 *seed, unsigned int 
slen);
 };
 
 #define crt_ablkcipher	crt_u.ablkcipher
