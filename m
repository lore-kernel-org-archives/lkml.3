Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3J0DmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 23:42:03 -0400
Received: from smtprelay0119.hostedemail.com ([216.40.44.119]:55425 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753769Ab3J0DmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 23:42:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3871:3872:3873:4321:4605:5007:7652:8784:10004:10400:10471:10848:11026:11232:11233:11473:11658:11914:12043:12050:12114:12296:12438:12517:12519:12555:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frame04_2e51cb747b110
X-Filterd-Recvd-Size: 3480
Message-ID: <1382845313.3238.28.camel@joe-AO722>
Subject: [PATCH V2] printk: pr_debug_ratelimited: check state first to
 reduce "callbacks suppressed" messages
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Baron <jbaron@akamai.com>, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Sat, 26 Oct 2013 20:41:53 -0700
In-Reply-To: <20131026190151.GA26389@kroah.com>
References: <20131026132955.GA9251@shrek.podlesie.net>
	 <20131026173730.GA18320@kroah.com> <1382813522.3238.4.camel@joe-AO722>
	 <20131026190151.GA26389@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_debug_ratelimited should be coded similarly to dev_dbg_ratelimited
to reduce the "callbacks suppressed" messages.

Add #include <linux/dynamic_debug.h> to printk.h. Unfortunately, this
new #include must be after the prototype/declaration of function printk.

It may be better to split out these _ratelimited declarations into
a separate file one day.

Any use of these pr_<foo>_ratelimited functions must also have another
specific #include <ratelimited.h>.  Most users have this done indirectly
via #include <linux/kernel.h>

printk.h may not #include <linux/ratelimit.h> as it causes circular
dependencies and compilation failures.

Signed-off-by: Joe Perches <joe@perches.com>
---
V2: Fix #include dependencies and typos.

Compile tested with and without CONFIG_DYNAMIC_DEBUG

It looks to me as if device.h should also have #include <dynamic_debug.h>
It currently gets the #include indirectly via kobject.h -> kernel.h.

 include/linux/printk.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index e6131a78..6949258 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -233,6 +233,8 @@ extern asmlinkage void dump_stack(void) __cold;
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+#include <linux/dynamic_debug.h>
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
@@ -343,7 +345,19 @@ extern asmlinkage void dump_stack(void) __cold;
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
+/* descriptor check is first to prevent flooding with "callbacks suppressed" */
+#define pr_debug_ratelimited(fmt, ...)					\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
+	    __ratelimit(&_rs))						\
+		__dynamic_pr_debug(&descriptor, fmt, ##__VA_ARGS__);	\
+} while (0)
+#elif defined(DEBUG)
 #define pr_debug_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else


