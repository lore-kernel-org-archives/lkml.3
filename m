Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3JZSwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 14:52:09 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:36211 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018Ab3JZSwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 14:52:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3871:3872:3873:3874:4184:4321:4605:5007:7652:7903:8660:10004:10400:10848:11026:11232:11233:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555:12663:12740:13148:13230:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dress54_4c4b1f3b5f658
X-Filterd-Recvd-Size: 3218
Message-ID: <1382813522.3238.4.camel@joe-AO722>
Subject: [PATCH] printk: pr_debug_ratelimited: check state first to reduce
 "callbacks suppressed" messages
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Sat, 26 Oct 2013 11:52:02 -0700
In-Reply-To: <20131026173730.GA18320@kroah.com>
References: <20131026132955.GA9251@shrek.podlesie.net>
	 <20131026173730.GA18320@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_debug_ratelimited should be coded similar to dev_dbg_ratelimited
to reduce the "callbacks suppressed" messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Sat, 2013-10-26 at 18:37 +0100, Greg Kroah-Hartman wrote:
> On Sat, Oct 26, 2013 at 03:29:56PM +0200, Krzysztof Mazur wrote:
> > Hi,
> > 
> > commit 2d6401cf4ca3861692a4779745e0049cac769d10
> > ("USB: usbatm: move the atm_dbg() call to use dynamic debug")
> > changed the atm_rldbg() to:
> > 
> > #define atm_rldbg(instance, format, arg...)		\
> > 	if (printk_ratelimit())				\
> > 		atm_dbg(instance , format , ## arg)
> > 
> > and now printk_ratelimit() is always called even when debugging is
> > disabled and a lot of "callbacks suppressed" messages are printed
> > by the printk_ratelimit():
> > 
> > [...]
> > usbatm_rx_process: 4977 callbacks suppressed
> > usbatm_extract_one_cell: 2920 callbacks suppressed
> > [...]
> > 
> > 
> > I'm not sure how to fix that, maybe we need dynamic_pr_debug_ratelimit()?
> 
> How about just deleting the use of that macro entirely?  Odds are it's
> not really needed anymore, right?

 include/linux/printk.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index e6131a78..449d924 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -343,7 +343,19 @@ extern asmlinkage void dump_stack(void) __cold;
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
+/* descriptor check is first to prevent flooding with "callbacks suppressed" */
+#define pr_debug_ratelimited(dev, fmt, ...)				\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
+	    __ratelimit(&_rs))						\
+		__dynamic_pr_debug(fmt, ##__VA_ARGS__);			\
+} while (0)
+#elif defined(DEBUG)
 #define pr_debug_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else


