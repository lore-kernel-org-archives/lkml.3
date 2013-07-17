Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788Ab3GQQqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:46:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:10883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870Ab3GQQqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:46:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,685,1367996400"; 
   d="scan'208";a="347149173"
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due
 tomoduledependency.
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
In-Reply-To: <201307172052.EJE32506.OFMSFJQOFHtVOL@I-love.SAKURA.ne.jp>
References: <201307162053.GBC56724.MFVOJtSLQHFOOF@I-love.SAKURA.ne.jp>
	 <20130716115527.GA1034@gondor.apana.org.au>
	 <201307162249.JEA41532.FFOLHVQJFtOOMS@I-love.SAKURA.ne.jp>
	 <1373991828.22432.274.camel@schen9-DESK>
	 <201307172052.EJE32506.OFMSFJQOFHtVOL@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Jul 2013 09:46:37 -0700
Message-ID: <1374079597.22432.314.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 20:52 +0900, Tetsuo Handa wrote:
> Tim Chen wrote:
> > Herbert, seems like modules.dep generator wants explicit
> > 
> > - 	select CRYPTO_CRCT10DIF
> > +	depends on CRYPTO_CRCT10DIF
> > 
> > But it seems to me like it should have known CRC_T10DIF needs
> > CRYPTO_CRCT10DIF when we do 
> > 	select CRYPTO_CRCT10DIF
> > 
> > Your thoughts?
> 
> "select" cannot tell /sbin/depmod that there is dependency, for /sbin/depmod
> calculates dependency by enumerating symbols in each module rather than by
> parsing Kconfig files which depends on "kernel-source_files_installed = y".
> 
> Therefore, I think possible solutions are either
> 
>   (a) built-in the dependent modules
> 
>       # grep crc /lib/modules/3.11.0-rc1+/modules.dep
>       kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko
>       kernel/lib/crc-t10dif.ko:

This approach will increase kernel size for those who are not using
t10dif so some people may object.  
BTW, The PCLMULQDQ version does not need to be build in.

> 
> or
> 
>   (b) embed explicit reference to the dependent module's symbols
> 
>       # grep crc /lib/modules/3.11.0-rc1+/modules.dep
>       kernel/arch/x86/crypto/crct10dif-pclmul.ko: kernel/crypto/crct10dif.ko
>       kernel/crypto/crct10dif.ko:
>       kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko kernel/arch/x86/crypto/crct10dif-pclmul.ko kernel/crypto/crct10dif.ko
>       kernel/lib/crc-t10dif.ko: kernel/arch/x86/crypto/crct10dif-pclmul.ko kernel/crypto/crct10dif.ko
> 

Your approach is quite complicated.  I think something simpler like the
following will work:

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index fe3428c..27d6be3 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -15,7 +15,8 @@
 #include <linux/init.h>
 #include <crypto/hash.h>
 
-static struct crypto_shash *crct10dif_tfm;
+__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len);
+static struct crypto_shash *crct10dif_tfm = crc_t10dif_generic;
 
 __u16 crc_t10dif(const unsigned char *buffer, size_t len)
 {



> .
> 
> Two patches ((a) and (b) respectively) follow, but I think patch (b) will not
> work unless additional change
> 
>   static int __init crct10dif_intel_mod_init(void)
>   {
>           if (x86_match_cpu(crct10dif_cpu_id))
>                   return crypto_register_shash(&alg);
>           return 0;
>   }
> 
>   static void __exit crct10dif_intel_mod_fini(void)
>   {
>           if (x86_match_cpu(crct10dif_cpu_id))
>                   crypto_unregister_shash(&alg);
>   }
> 
> is made, for currently crct10dif-pclmul.ko cannot be loaded on
> !X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ) systems.

crct10dif-pclmul.ko should not be loaded if 
X86_FEATURE_PCLMULQDQ is not supported.
The module needs the cpu to have support for PCLMULQDQ.

> 
> ------------------------------------------------------------
> 
> >From d8d9b7c3e5be9c5a6198dac6fe7279ca904343a8 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Wed, 17 Jul 2013 19:45:19 +0900
> Subject: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
> 
> Commit 2d31e518 "crypto: crct10dif - Wrap crc_t10dif function all to use crypto
> transform framework" was added without telling that "crc-t10dif.ko depends on
> crct10dif.ko". This resulted in boot failure because "sd_mod.ko depends on
> crc-t10dif.ko" but "crct10dif.ko is not loaded automatically".
> 
> Fix this by changing crct10dif.ko and crct10dif-pclmul.ko from "tristate" to
> "bool" so that suitable version is chosen.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  crypto/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 69ce573..dd3b79e 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -377,7 +377,7 @@ config CRYPTO_CRC32_PCLMUL
>  	  and gain better performance as compared with the table implementation.
>  
>  config CRYPTO_CRCT10DIF
> -	tristate "CRCT10DIF algorithm"
> +	bool "CRCT10DIF algorithm"
>  	select CRYPTO_HASH
>  	help
>  	  CRC T10 Data Integrity Field computation is being cast as
> @@ -385,7 +385,7 @@ config CRYPTO_CRCT10DIF
>  	  transforms to be used if they are available.
>  
>  config CRYPTO_CRCT10DIF_PCLMUL
> -	tristate "CRCT10DIF PCLMULQDQ hardware acceleration"
> +	bool "CRCT10DIF PCLMULQDQ hardware acceleration"

This is not necessary.  Keep it as tristate.

>  	depends on X86 && 64BIT && CRC_T10DIF
>  	select CRYPTO_HASH
>  	help
> -- 
> 1.7.1
> 
> ------------------------------------------------------------
> 
> >From 153e209fc9a7e1df42555829c396ee9ed53e83d0 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Wed, 17 Jul 2013 20:23:15 +0900
> Subject: [PATCH] [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
> 
> Commit 2d31e518 "crypto: crct10dif - Wrap crc_t10dif function all to use crypto
> transform framework" was added without telling that "crc-t10dif.ko depends on
> crct10dif.ko". This resulted in boot failure because "sd_mod.ko depends on
> crc-t10dif.ko" but "crct10dif.ko is not loaded automatically".
> 
> Fix this by describing "crc-t10dif.ko depends on crct10dif.ko".
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  arch/x86/crypto/crct10dif-pclmul_glue.c |    6 ++++++
>  lib/crc-t10dif.c                        |    7 +++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
> index 7845d7f..2964608 100644
> --- a/arch/x86/crypto/crct10dif-pclmul_glue.c
> +++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
> @@ -149,3 +149,9 @@ MODULE_LICENSE("GPL");
>  
>  MODULE_ALIAS("crct10dif");
>  MODULE_ALIAS("crct10dif-pclmul");
> +
> +/* Dummy for describing module dependency. */
> +#if defined(CONFIG_CRYPTO_CRCT10DIF_PCLMUL_MODULE)
> +const char crct10dif_pclmul;
> +EXPORT_SYMBOL(crct10dif_pclmul);
> +#endif
> diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
> index fe3428c..376f795 100644
> --- a/lib/crc-t10dif.c
> +++ b/lib/crc-t10dif.c
> @@ -38,6 +38,13 @@ EXPORT_SYMBOL(crc_t10dif);
>  
>  static int __init crc_t10dif_mod_init(void)
>  {
> +	/* Dummy for describing module dependency. */
> +#if defined(CONFIG_CRYPTO_CRCT10DIF_PCLMUL_MODULE)
> +	extern const char crct10dif_pclmul;
> +	crc_t10dif_generic(crct10dif_pclmul, NULL, 0);
> +#elif defined(CONFIG_CRYPTO_CRCT10DIF_MODULE)
> +	crc_t10dif_generic(0, NULL, 0);
> +#endif
>  	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
>  	return PTR_RET(crct10dif_tfm);
>  }



