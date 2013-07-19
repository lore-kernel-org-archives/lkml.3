Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969Ab3GSSIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:08:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:25904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3GSSIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:08:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,703,1367996400"; 
   d="scan'208";a="373308679"
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
From: Tim Chen <tim.c.chen@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <2493652.fjZLqTL8IF@vostro.rjw.lan>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
	 <1374188894.22432.354.camel@schen9-DESK>
	 <3364013.pHWIsx89Eq@vostro.rjw.lan>  <2493652.fjZLqTL8IF@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Jul 2013 11:08:49 -0700
Message-ID: <1374257329.22432.382.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 16:49 +0200, Rafael J. Wysocki wrote:
> > > > > This should cause udev to load the crct10dif_pclml module when cpu
> > > > > support the PCLMULQDQ (feature code 0081).  I did my testing during
> > > > > development on 3.10 and the module was indeed loaded.
> > > > >
> > > > > However, I found that the following commit under 3.11-rc1 broke
> > > > > the mechanism after some bisection.
> > > > >
> > > > > commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
> > > > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > Date:   Fri May 3 00:26:22 2013 +0200
> > > > >
> > > > >      ACPI / processor: Use common hotplug infrastructure
> > > > >      
> > > > >      Split the ACPI processor driver into two parts, one that is
> > > > >      non-modular, resides in the ACPI core and handles the enumeration
> > > > >      and hotplug of processors and one that implements the rest of the
> > > > >      existing processor driver functionality.
> > > > >      
> > > > > Rafael, can you check and see if this can be fixed so those optimized
> > > > > crypto modules for Intel cpu that support them can be loaded?
> > > > 
> > > > I think this is an ordering issue between udev startup and the time when 
> > > > devices are registered.
> > > 
> > > Something that can be fixed?
> > 
> > I'm sure it can be fixes, but I'm not sure whether it's a udev bug or real
> > breakage in the kernel yet.  I need to figure out that part.
> 
> OK
> 
> I wonder if the appended patch makes the issue go away for you?
> 

Rafael, the patch did fix the cpu feature based module loading issue.
Thanks for your quick response.

Herbert, the patch below should fix the boot failure issue.  

I also added the change to rename crct10dif.c to crct10dif_generic.c 
and added MODULE_ALIAS(crct10dif) to  crct10dif_generic.c.  
This was according to our discussion:
https://lkml.org/lkml/2013/5/21/216  

However, when I have the

CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRC_T10DIF=y

combination, the crc-t10dif library function was still 
initialized before the crct10dif-pclmul.ko was loaded, 
leading to the generic version being used.  This
is also one of Tetsuo's concerns.  In theory, loading
the generic version should also load the pclmul version as
they have the same MODULE_ALIAS, before crc-t10dif library
try to allocate the crypto transform. 

Something else that I'm missing and need to be changed?

I will be away for a week without internet access so my
response will be slow.

Thanks.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
Fix boot failure as crc-t10dif library may not cause crct10dif.ko
containing the generic algorithm to be loaded.

Rename crct10dif.c to crct10dif_generic.c and add module alias.
This should load all the modules supporting crct10dif algorithm
at the same time.
---
 crypto/Makefile                             | 2 +-
 crypto/{crct10dif.c => crct10dif_generic.c} | 1 +
 lib/crc-t10dif.c                            | 3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)
 rename crypto/{crct10dif.c => crct10dif_generic.c} (99%)

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
index 92aca96..45a9acd 100644
--- a/crypto/crct10dif.c
+++ b/crypto/crct10dif_generic.c
@@ -176,3 +176,4 @@ module_exit(crct10dif_mod_fini);
 MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
 MODULE_DESCRIPTION("T10 DIF CRC calculation.");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS(crct10dif);
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index d102d83..37b3eb4 100644
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
-- 
1.7.11.7





