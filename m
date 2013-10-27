Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3J0Dt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 23:49:29 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:44541 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753605Ab3J0Dt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 23:49:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3866:3867:3870:4321:5007:7652:7903:9592:10004:10400:10848:11026:11232:11658:11914:12296:12438:12517:12519:12555:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fish70_6f7d1cbc36f5d
X-Filterd-Recvd-Size: 2453
Message-ID: <1382845764.3238.34.camel@joe-AO722>
Subject: [PATCH V2] usbatm: Fix dynamic_debug / ratelimited atm_dbg and
 atm_rldbg macros
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Sat, 26 Oct 2013 20:49:24 -0700
In-Reply-To: <1382815736.3238.10.camel@joe-AO722>
References: <20131026132955.GA9251@shrek.podlesie.net>
	 <20131026173730.GA18320@kroah.com> <1382813729.3238.8.camel@joe-AO722>
	 <1382815736.3238.10.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix atm_dbg to use normal pr_debug not dynamic_pr_debug
because dynamic_pr_debug may not be compiled in at all.

Signed-off-by: Joe Perches <joe@perches.com>
---
V2: Fix macro use of arg... vs ... typo
    Fix usbatm vs atmusb typo (thanks Krzysiek)

 drivers/usb/atm/usbatm.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
index 5651231..f3eecd9 100644
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -34,6 +34,7 @@
 #include <linux/stringify.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
+#include <linux/ratelimit.h>
 
 /*
 #define VERBOSE_DEBUG
@@ -59,13 +60,12 @@
 	atm_printk(KERN_INFO, instance , format , ## arg)
 #define atm_warn(instance, format, arg...)	\
 	atm_printk(KERN_WARNING, instance , format , ## arg)
-#define atm_dbg(instance, format, arg...)		\
-	dynamic_pr_debug("ATM dev %d: " format ,	\
-	(instance)->atm_dev->number , ## arg)
-#define atm_rldbg(instance, format, arg...)		\
-	if (printk_ratelimit())				\
-		atm_dbg(instance , format , ## arg)
-
+#define atm_dbg(instance, format, ...)					\
+	pr_debug("ATM dev %d: " format,					\
+		 (instance)->atm_dev->number, ##__VA_ARGS__)
+#define atm_rldbg(instance, format, ...)				\
+	pr_debug_ratelimited("ATM dev %d: " format,			\
+			     (instance)->atm_dev->number, ##__VA_ARGS__)
 
 /* flags, set by mini-driver in bind() */
 



