Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaB0AsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:48:14 -0500
Received: from smtprelay0225.hostedemail.com ([216.40.44.225]:53287 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751929AbaB0AsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:48:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:560:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2687:2828:2892:2894:2895:3138:3139:3140:3141:3142:3355:3622:3834:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6119:7652:8784:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: peace74_d4d7a87f2047
X-Filterd-Recvd-Size: 3731
Message-ID: <1393462087.24588.50.camel@joe-AO722>
Subject: Re: The sheer number of sparse warnings in the kernel
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 26 Feb 2014 16:48:07 -0800
In-Reply-To: <530E6F76.1070605@zytor.com>
References: <530E6F76.1070605@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 14:49 -0800, H. Peter Anvin wrote:
> The number of sparse errors in the current kernel is staggering, and it
> makes sparse a lot less valuable of a tool that it otherwise could be.
> On a build of x86-64 allyesconfig I'm getting 20,676 sparse messages.
> Out of those, 12,358 come from linux/err.h.  Given that the latter
> basically spams *everything*, I can only conclude that almost noone uses
> sparse unless they have a filter script.
> 
> So a lot of these are certainly nuisance problems, like the
> <linux/err.h> stuff which has to do with the handling of error values,
> but some of these look like real bugs.
> 
> What do we need to do to actually make our tools be able to do work for
> us?  Newbie projects to clean up?  Trying to get the larger Linux
> companies to put resources on it?

gcc 4.8 does annoyingly warn on all unsigned/signed
mismatches/implicit conversions too.

err.h could also return bool instead of long for the
IS_ERR and IS_ERR_OR_NULL tests.

Maybe something like this could be useful.

Shut up the unsigned<->signed pointer conversions
and implicit conversions in the Makefile.

Use bool not long for IS_ERR and IS_ERR_OR_NULL

Update the dentry description of kernel pointers
left over from 2002's move to err.h

unsigned...

---
 Makefile            | 1 +
 include/linux/err.h | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index fce2ba7..a9c11c4 100644
--- a/Makefile
+++ b/Makefile
@@ -381,6 +381,7 @@ KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
 		   -Werror-implicit-function-declaration \
+		   -Wno-sign-conversion -Wno-pointer-sign \
 		   -Wno-format-security \
 		   -fno-delete-null-pointer-checks
 KBUILD_AFLAGS_KERNEL :=
diff --git a/include/linux/err.h b/include/linux/err.h
index 15f92e0..a729120 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -2,12 +2,13 @@
 #define _LINUX_ERR_H
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 #include <asm/errno.h>
 
 /*
  * Kernel pointers have redundant information, so we can use a
- * scheme where we can return either an error code or a dentry
+ * scheme where we can return either an error code or a normal
  * pointer with the same return value.
  *
  * This should be a per-architecture thing, to allow different
@@ -29,12 +30,12 @@ static inline long __must_check PTR_ERR(__force const void *ptr)
 	return (long) ptr;
 }
 
-static inline long __must_check IS_ERR(__force const void *ptr)
+static inline bool __must_check IS_ERR(__force const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
+static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }


