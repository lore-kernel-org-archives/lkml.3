Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096AbaDSEHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 00:07:05 -0400
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:48222 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750709AbaDSEHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 00:07:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:152:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3868:3870:3872:4321:4384:4605:5007:7652:7903:9592:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12517:12519:12555:12740:13069:13149:13230:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: neck42_3cd365f86c05d
X-Filterd-Recvd-Size: 2770
Message-ID: <1397880413.3106.2.camel@joe-AO725>
Subject: Re: [PATCH] smc91x: fix compile error when SMC_DEBUG >= 2
From: Joe Perches <joe@perches.com>
To: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Apr 2014 21:06:53 -0700
In-Reply-To: <1397879250-32041-1-git-send-email-zlim.lnx@gmail.com>
References: <1397879250-32041-1-git-send-email-zlim.lnx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-18 at 20:47 -0700, Zi Shen Lim wrote:
> When SMC_DEBUG >= 2, we hit the following compilation error:
> 
> drivers/net/ethernet/smsc/smc91x.c:85:0:
> drivers/net/ethernet/smsc/smc91x.c: In function ‘smc_findirq’:
> drivers/net/ethernet/smsc/smc91x.c:1784:9: error: ‘dev’ undeclared (first use in this function)
>   DBG(2, dev, "%s: %s\n", CARDNAME, __func__);
>          ^
> Fix it by passing in the appropriate netdev pointer.

Perhaps verifying the format and args in all cases
would help avoid more of these in the future.
---
 drivers/net/ethernet/smsc/smc91x.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index d1b4dca..a8302f5 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -148,16 +148,19 @@ MODULE_ALIAS("platform:smc91x");
 #define MII_DELAY		1
 
 #if SMC_DEBUG > 0
-#define DBG(n, dev, args...)				\
-	do {						\
-		if (SMC_DEBUG >= (n))			\
-			netdev_dbg(dev, args);		\
-	} while (0)
-
-#define PRINTK(dev, args...)   netdev_info(dev, args)
+#define DBG(n, dev, fmt, ...)					\
+do {								\
+	if (SMC_DEBUG >= (n))					\
+		netdev_dbg(dev, fmt, ##__VA_ARGS__);		\
+} while (0)
+#define PRINTK(dev, fmt, ...)   netdev_info(dev, fmt, ##__VA_ARGS__)
 #else
-#define DBG(n, dev, args...)   do { } while (0)
-#define PRINTK(dev, args...)   netdev_dbg(dev, args)
+#define DBG(n, dev, fmt, ...)					\
+do {								\
+	if (0)					\
+		netdev_dbg(dev, fmt, ##__VA_ARGS__);		\
+} while (0)
+#define PRINTK(dev, fmt, ...)   netdev_dbg(dev, fmt, ##__VA_ARGS__)
 #endif
 
 #if SMC_DEBUG > 3
@@ -191,7 +194,9 @@ static void PRINT_PKT(u_char *buf, int length)
 	pr_cont("\n");
 }
 #else
-#define PRINT_PKT(x...)  do { } while (0)
+static inline void PRINT_PKT(u_char *buf, int length)
+{
+}
 #endif
 
 


