Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3JaS7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:59:25 -0400
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:56879 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752701Ab3JaS7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:59:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:2:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1606:1730:1747:1777:1792:2393:2559:2562:2734:2828:3138:3139:3140:3141:3142:3355:3855:3866:3867:3870:3871:4250:4321:4605:5007:6119:7652:8957:9040:9592:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: war84_8c11d02e5f42c
X-Filterd-Recvd-Size: 5780
Message-ID: <1383245961.8740.13.camel@joe-AO722>
Subject: [PATCH -next] crypto: padlock: Remove #define PFX, use pr_<level>
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org,
        linux-crypto <linux-crypto@vger.kernel.org>
Date: Thu, 31 Oct 2013 11:59:21 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using PFX in system #include files should be discouraged.
Convert to a more current logging style.

Add #define pr_fmt, use pr_<level>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/hw_random/via-rng.c | 12 ++++++------
 drivers/crypto/padlock-aes.c     | 10 ++++++----
 drivers/crypto/padlock-sha.c     | 10 ++++++----
 include/crypto/padlock.h         |  2 --
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index de5a6dc..f9e071c 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -24,6 +24,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/padlock.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -141,8 +143,7 @@ static int via_rng_init(struct hwrng *rng)
 	 * register */
 	if ((c->x86 == 6) && (c->x86_model >= 0x0f)) {
 		if (!cpu_has_xstore_enabled) {
-			printk(KERN_ERR PFX "can't enable hardware RNG "
-				"if XSTORE is not enabled\n");
+			pr_err("can't enable hardware RNG if XSTORE is not enabled\n");
 			return -ENODEV;
 		}
 		return 0;
@@ -180,7 +181,7 @@ static int via_rng_init(struct hwrng *rng)
 	   unneeded */
 	rdmsr(MSR_VIA_RNG, lo, hi);
 	if ((lo & VIA_RNG_ENABLE) == 0) {
-		printk(KERN_ERR PFX "cannot enable VIA C3 RNG, aborting\n");
+		pr_err("cannot enable VIA C3 RNG, aborting\n");
 		return -ENODEV;
 	}
 
@@ -202,11 +203,10 @@ static int __init mod_init(void)
 
 	if (!cpu_has_xstore)
 		return -ENODEV;
-	printk(KERN_INFO "VIA RNG detected\n");
+	pr_info("VIA RNG detected\n");
 	err = hwrng_register(&via_rng);
 	if (err) {
-		printk(KERN_ERR PFX "RNG registering failed (%d)\n",
-		       err);
+		pr_err("RNG registering failed (%d)\n", err);
 		goto out;
 	}
 out:
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 633ba94..7404186 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -7,6 +7,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/padlock.h>
@@ -516,7 +518,7 @@ static int __init padlock_init(void)
 		return -ENODEV;
 
 	if (!cpu_has_xcrypt_enabled) {
-		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
+		pr_notice("VIA PadLock detected, but not enabled. Hmm, strange...\n");
 		return -ENODEV;
 	}
 
@@ -529,12 +531,12 @@ static int __init padlock_init(void)
 	if ((ret = crypto_register_alg(&cbc_aes_alg)))
 		goto cbc_aes_err;
 
-	printk(KERN_NOTICE PFX "Using VIA PadLock ACE for AES algorithm.\n");
+	pr_notice("Using VIA PadLock ACE for AES algorithm\n");
 
 	if (c->x86 == 6 && c->x86_model == 15 && c->x86_mask == 2) {
 		ecb_fetch_blocks = MAX_ECB_FETCH_BLOCKS;
 		cbc_fetch_blocks = MAX_CBC_FETCH_BLOCKS;
-		printk(KERN_NOTICE PFX "VIA Nano stepping 2 detected: enabling workaround.\n");
+		pr_notice("VIA Nano stepping 2 detected: enabling workaround\n");
 	}
 
 out:
@@ -545,7 +547,7 @@ cbc_aes_err:
 ecb_aes_err:
 	crypto_unregister_alg(&aes_alg);
 aes_err:
-	printk(KERN_ERR PFX "VIA PadLock AES initialization failed.\n");
+	pr_err("VIA PadLock AES initialization failed\n");
 	goto out;
 }
 
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 9266c0e..991cdf7 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -12,6 +12,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/internal/hash.h>
 #include <crypto/padlock.h>
 #include <crypto/sha.h>
@@ -220,8 +222,8 @@ static int padlock_cra_init(struct crypto_tfm *tfm)
 	fallback_tfm = crypto_alloc_shash(fallback_driver_name, 0,
 					  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
-		printk(KERN_WARNING PFX "Fallback driver '%s' could not be loaded!\n",
-		       fallback_driver_name);
+		pr_warn("Fallback driver '%s' could not be loaded!\n",
+			fallback_driver_name);
 		err = PTR_ERR(fallback_tfm);
 		goto out;
 	}
@@ -561,7 +563,7 @@ static int __init padlock_init(void)
 	if (rc)
 		goto out_unreg1;
 
-	printk(KERN_NOTICE PFX "Using VIA PadLock ACE for SHA1/SHA256 algorithms.\n");
+	pr_notice("Using VIA PadLock ACE for SHA1/SHA256 algorithms\n");
 
 	return 0;
 
@@ -569,7 +571,7 @@ out_unreg1:
 	crypto_unregister_shash(sha1);
 
 out:
-	printk(KERN_ERR PFX "VIA PadLock SHA1/SHA256 initialization failed.\n");
+	pr_err("VIA PadLock SHA1/SHA256 initialization failed\n");
 	return rc;
 }
 
diff --git a/include/crypto/padlock.h b/include/crypto/padlock.h
index d2cfa2e..4245f86 100644
--- a/include/crypto/padlock.h
+++ b/include/crypto/padlock.h
@@ -15,8 +15,6 @@
 
 #define PADLOCK_ALIGNMENT 16
 
-#define PFX	KBUILD_MODNAME ": "
-
 #define PADLOCK_CRA_PRIORITY	300
 #define PADLOCK_COMPOSITE_PRIORITY 400
 


