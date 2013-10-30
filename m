Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3J3RCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:02:08 -0400
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:35964 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751330Ab3J3RCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:02:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:6120:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12296:12517:12519:12555:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mask19_4c31324edab53
X-Filterd-Recvd-Size: 2733
Message-ID: <1383152522.9435.29.camel@joe-AO722>
Subject: Re: [RFC PATCH -next] Fix printk_once build errors due to
 __read_mostly
From: Joe Perches <joe@perches.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-metag@vger.kernel.org
Date: Wed, 30 Oct 2013 10:02:02 -0700
In-Reply-To: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 10:18 +0000, James Hogan wrote:
> Commit 3e39c1ab04ba (printk: mark printk_once test variable
> __read_mostly) added __read_mostly to the __print_once bool in the
> printk_once() macro, but __read_mostly is defined in <linux/cache.h>
> which isn't included from <linux/printk.h>. This results in build errors
> like this:
> 
> arch/metag/mm/l2cache.c: In function 'meta_l2c_setup':
> arch/metag/mm/l2cache.c:56: error: '__read_mostly' undeclared
> 
> This is fixed by adding an include of <linux/cache.h> from
> <linux/printk.h> since I don't think printk_once() users should need to
> include <linux/cache.h> for it to work.
> 
> Note that this actually adds a recursive include, since <linux/cache.h>
> includes <linux/kernel.h>, which includes <linux/printk.h>. The actual
> dependencies are all in macros so it doesn't actually seem to result in
> any build failures, but it's clearly less than ideal.
[]
> I'm not too keen on this due to the recursive include. Is it better to
> just workaround the problem by including <linux/cache.h> from the .c
> file that fails to build, or should the original patch be removed
> instead?

Maybe also using this would help avoid some of the
circular dependency:
---
 include/linux/cache.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


