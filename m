Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3GQLwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:52:41 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64530 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3GQLwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:52:39 -0400
X-Nat-Received: from [202.181.97.72]:57809 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1374061947.25778
To: tim.c.chen@linux.intel.com
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due tomoduledependency.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201307162053.GBC56724.MFVOJtSLQHFOOF@I-love.SAKURA.ne.jp>
	<20130716115527.GA1034@gondor.apana.org.au>
	<201307162249.JEA41532.FFOLHVQJFtOOMS@I-love.SAKURA.ne.jp>
	<1373991828.22432.274.camel@schen9-DESK>
In-Reply-To: <1373991828.22432.274.camel@schen9-DESK>
Message-Id: <201307172052.EJE32506.OFMSFJQOFHtVOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 17 Jul 2013 20:52:24 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17072013 #10613230, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> Herbert, seems like modules.dep generator wants explicit
> 
> - 	select CRYPTO_CRCT10DIF
> +	depends on CRYPTO_CRCT10DIF
> 
> But it seems to me like it should have known CRC_T10DIF needs
> CRYPTO_CRCT10DIF when we do 
> 	select CRYPTO_CRCT10DIF
> 
> Your thoughts?

"select" cannot tell /sbin/depmod that there is dependency, for /sbin/depmod
calculates dependency by enumerating symbols in each module rather than by
parsing Kconfig files which depends on "kernel-source_files_installed = y".

Therefore, I think possible solutions are either

  (a) built-in the dependent modules

      # grep crc /lib/modules/3.11.0-rc1+/modules.dep
      kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko
      kernel/lib/crc-t10dif.ko:

or

  (b) embed explicit reference to the dependent module's symbols

      # grep crc /lib/modules/3.11.0-rc1+/modules.dep
      kernel/arch/x86/crypto/crct10dif-pclmul.ko: kernel/crypto/crct10dif.ko
      kernel/crypto/crct10dif.ko:
      kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko kernel/arch/x86/crypto/crct10dif-pclmul.ko kernel/crypto/crct10dif.ko
      kernel/lib/crc-t10dif.ko: kernel/arch/x86/crypto/crct10dif-pclmul.ko kernel/crypto/crct10dif.ko

.

Two patches ((a) and (b) respectively) follow, but I think patch (b) will not
work unless additional change

  static int __init crct10dif_intel_mod_init(void)
  {
          if (x86_match_cpu(crct10dif_cpu_id))
                  return crypto_register_shash(&alg);
          return 0;
  }

  static void __exit crct10dif_intel_mod_fini(void)
  {
          if (x86_match_cpu(crct10dif_cpu_id))
                  crypto_unregister_shash(&alg);
  }

is made, for currently crct10dif-pclmul.ko cannot be loaded on
!X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ) systems.

------------------------------------------------------------

>From d8d9b7c3e5be9c5a6198dac6fe7279ca904343a8 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 17 Jul 2013 19:45:19 +0900
Subject: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.

Commit 2d31e518 "crypto: crct10dif - Wrap crc_t10dif function all to use crypto
transform framework" was added without telling that "crc-t10dif.ko depends on
crct10dif.ko". This resulted in boot failure because "sd_mod.ko depends on
crc-t10dif.ko" but "crct10dif.ko is not loaded automatically".

Fix this by changing crct10dif.ko and crct10dif-pclmul.ko from "tristate" to
"bool" so that suitable version is chosen.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 crypto/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 69ce573..dd3b79e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -377,7 +377,7 @@ config CRYPTO_CRC32_PCLMUL
 	  and gain better performance as compared with the table implementation.
 
 config CRYPTO_CRCT10DIF
-	tristate "CRCT10DIF algorithm"
+	bool "CRCT10DIF algorithm"
 	select CRYPTO_HASH
 	help
 	  CRC T10 Data Integrity Field computation is being cast as
@@ -385,7 +385,7 @@ config CRYPTO_CRCT10DIF
 	  transforms to be used if they are available.
 
 config CRYPTO_CRCT10DIF_PCLMUL
-	tristate "CRCT10DIF PCLMULQDQ hardware acceleration"
+	bool "CRCT10DIF PCLMULQDQ hardware acceleration"
 	depends on X86 && 64BIT && CRC_T10DIF
 	select CRYPTO_HASH
 	help
-- 
1.7.1

------------------------------------------------------------

>From 153e209fc9a7e1df42555829c396ee9ed53e83d0 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 17 Jul 2013 20:23:15 +0900
Subject: [PATCH] [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.

Commit 2d31e518 "crypto: crct10dif - Wrap crc_t10dif function all to use crypto
transform framework" was added without telling that "crc-t10dif.ko depends on
crct10dif.ko". This resulted in boot failure because "sd_mod.ko depends on
crc-t10dif.ko" but "crct10dif.ko is not loaded automatically".

Fix this by describing "crc-t10dif.ko depends on crct10dif.ko".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 arch/x86/crypto/crct10dif-pclmul_glue.c |    6 ++++++
 lib/crc-t10dif.c                        |    7 +++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 7845d7f..2964608 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -149,3 +149,9 @@ MODULE_LICENSE("GPL");
 
 MODULE_ALIAS("crct10dif");
 MODULE_ALIAS("crct10dif-pclmul");
+
+/* Dummy for describing module dependency. */
+#if defined(CONFIG_CRYPTO_CRCT10DIF_PCLMUL_MODULE)
+const char crct10dif_pclmul;
+EXPORT_SYMBOL(crct10dif_pclmul);
+#endif
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index fe3428c..376f795 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -38,6 +38,13 @@ EXPORT_SYMBOL(crc_t10dif);
 
 static int __init crc_t10dif_mod_init(void)
 {
+	/* Dummy for describing module dependency. */
+#if defined(CONFIG_CRYPTO_CRCT10DIF_PCLMUL_MODULE)
+	extern const char crct10dif_pclmul;
+	crc_t10dif_generic(crct10dif_pclmul, NULL, 0);
+#elif defined(CONFIG_CRYPTO_CRCT10DIF_MODULE)
+	crc_t10dif_generic(0, NULL, 0);
+#endif
 	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
 	return PTR_RET(crct10dif_tfm);
 }
-- 
1.7.1

------------------------------------------------------------
