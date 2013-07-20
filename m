Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3GTBbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 21:31:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:18993 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab3GTBbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 21:31:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,705,1367996400"; 
   d="scan'208";a="348674838"
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak <ak@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <1374277033.22432.384.camel@schen9-DESK>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
	 <2493652.fjZLqTL8IF@vostro.rjw.lan>
	 <1374257329.22432.382.camel@schen9-DESK>
	 <4295105.1txhDL4OOg@vostro.rjw.lan> <20130719231630.GC1701@kroah.com>
	 <51E9C9E5.2060602@zytor.com>  <20130719232459.GA18039@gondor.apana.org.au>
	 <1374277033.22432.384.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Jul 2013 18:31:04 -0700
Message-ID: <1374283864.22432.393.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 16:37 -0700, Tim Chen wrote:
> On Sat, 2013-07-20 at 09:24 +1000, Herbert Xu wrote:
> > On Fri, Jul 19, 2013 at 04:21:09PM -0700, H. Peter Anvin wrote:
> > >
> > > The issue here seems to be the dynamic binding nature of the crypto
> > > subsystem.  When something needs crypto, it will request the appropriate
> > > crypto module (e.g. crct10dif), which may race with detecting a specific
> > > hardware accelerator based on CPUID or device information (e.g.
> > > crct10dif_pclmul).
> > > 
> > > RAID has effectively the same issue, and we just "solved" it by
> > > compiling in all the accelerators into the top-level module.
> > 
> > I think for crypto the simplest solution is to not do CPUID-based
> > loading.  Then crypto users will simply load the module alias which
> > causes modprobe to load all modules providing that alias.
> > 
> > Cheers,
> 
> Herbert,
> 
> I've tried the module alias approach (see my earlier mail with patch) 
> but it didn't seem to load things properly.  Can you check to see if 
> there's anything I did incorrectly.
> 
> Tim

I fixed a missing request_module statement in crct10dif library.  
So now things work if I have the following config:

CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRC_T10DIF=m

However, when I have the library and generic algorithm compiled in,
I do not see the PCLMULQDQ version loaded.

CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRC_T10DIF=y

Perhaps I am initiating the crct10dif library at a really early
stage when things are compiled in, where the module is not in 
initramfs?  In that case, perhaps we should only allow 
PCLMUL version to be compiled in
and not exist as a module?

Here's the patch I tried:

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/crct10dif-pclmul_glue.c     | 8 +-------
 crypto/Makefile                             | 2 +-
 crypto/{crct10dif.c => crct10dif_generic.c} | 1 +
 lib/crc-t10dif.c                            | 1 +
 4 files changed, 4 insertions(+), 8 deletions(-)
 rename crypto/{crct10dif.c => crct10dif_generic.c} (99%)

diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 7845d7f..7ad5f09 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -121,15 +121,9 @@ static struct shash_alg alg = {
 	}
 };
 
-static const struct x86_cpu_id crct10dif_cpu_id[] = {
-	X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
-	{}
-};
-MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
-
 static int __init crct10dif_intel_mod_init(void)
 {
-	if (!x86_match_cpu(crct10dif_cpu_id))
+	if (!cpu_has_pclmulqdq)
 		return -ENODEV;
 
 	return crypto_register_shash(&alg);
diff --git a/crypto/Makefile b/crypto/Makefile
index 2d5ed08..3fd76fa 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -83,7 +83,7 @@ obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
-obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif.o
+obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_generic.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
 obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
diff --git a/crypto/crct10dif.c b/crypto/crct10dif_generic.c
similarity index 99%
rename from crypto/crct10dif.c
rename to crypto/crct10dif_generic.c
index 92aca96..c960a95 100644
--- a/crypto/crct10dif.c
+++ b/crypto/crct10dif_generic.c
@@ -176,3 +176,4 @@ module_exit(crct10dif_mod_fini);
 MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
 MODULE_DESCRIPTION("T10 DIF CRC calculation.");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("crct10dif");
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index fe3428c..d8cd353 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -38,6 +38,7 @@ EXPORT_SYMBOL(crc_t10dif);
 
 static int __init crc_t10dif_mod_init(void)
 {
+	request_module("crct10dif");
 	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
 	return PTR_RET(crct10dif_tfm);
 }
-- 
1.7.11.7



