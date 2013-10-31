Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3JaS3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:29:39 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:58419 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751390Ab3JaS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:29:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3872:4250:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12296:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cows52_1986256019552
X-Filterd-Recvd-Size: 3330
Message-ID: <1383244173.8740.9.camel@joe-AO722>
Subject: [PATCH V3] printk/cache: Mark printk_once test variable
 __read_mostly
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-metag@vger.kernel.org
Date: Thu, 31 Oct 2013 11:29:33 -0700
In-Reply-To: <20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
	 <20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add #include <linux/cache.h> to define __read_mostly.

Convert cache.h to use uapi/linux/kernel.h instead
of linux/kernel.h to avoid recursive #includes.

Convert the ALIGN macro to __ALIGN_KERNEL.

printk_once only sets the bool variable tested
once so mark it __read_mostly.

Neaten the alignment so it matches the rest of the
pr_<level>_once #defines too.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
---
V3: Fix cache.h conversion and actually
    compiled/built defconfig x86.
V2: Add cache.h which was nearly always used
    indirectly via #include <some_other_file.h>,
    generally module.h
    Update cache.h to avoid recursive #include

 include/linux/cache.h  |  4 ++--
 include/linux/printk.h | 19 ++++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/cache.h b/include/linux/cache.h
index 4c57065..17e7e82 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -1,11 +1,11 @@
 #ifndef __LINUX_CACHE_H
 #define __LINUX_CACHE_H
 
-#include <linux/kernel.h>
+#include <uapi/linux/kernel.h>
 #include <asm/cache.h>
 
 #ifndef L1_CACHE_ALIGN
-#define L1_CACHE_ALIGN(x) ALIGN(x, L1_CACHE_BYTES)
+#define L1_CACHE_ALIGN(x) __ALIGN_KERNEL(x, L1_CACHE_BYTES)
 #endif
 
 #ifndef SMP_CACHE_BYTES
diff --git a/include/linux/printk.h b/include/linux/printk.h
index e6131a78..2449da9 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -5,6 +5,7 @@
 #include <linux/init.h>
 #include <linux/kern_levels.h>
 #include <linux/linkage.h>
+#include <linux/cache.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -251,17 +252,17 @@ extern asmlinkage void dump_stack(void) __cold;
  */
 
 #ifdef CONFIG_PRINTK
-#define printk_once(fmt, ...)			\
-({						\
-	static bool __print_once;		\
-						\
-	if (!__print_once) {			\
-		__print_once = true;		\
-		printk(fmt, ##__VA_ARGS__);	\
-	}					\
+#define printk_once(fmt, ...)					\
+({								\
+	static bool __print_once __read_mostly;			\
+								\
+	if (!__print_once) {					\
+		__print_once = true;				\
+		printk(fmt, ##__VA_ARGS__);			\
+	}							\
 })
 #else
-#define printk_once(fmt, ...)			\
+#define printk_once(fmt, ...)					\
 	no_printk(fmt, ##__VA_ARGS__)
 #endif
 


