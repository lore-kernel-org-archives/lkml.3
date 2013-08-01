Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3HACae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:30:34 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62253 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3HACac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:30:32 -0400
Date: Thu, 1 Aug 2013 10:18:08 +0800
From: majianpeng <majianpeng@gmail.com>
To: balajitk <balajitk@ti.com>, cjb <cjb@laptop.org>
Cc: mayuzheng <mayuzheng@kedacom.com>, linux-mmc <linux-mmc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] mmc: omap_hsmmc: Fix sleep too long in ISR context.
X-Priority: 3
X-GUID: 8C5E30D5-ECD1-4E5E-98BC-BF91E516EB29
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201308011017566117580@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r712UdNZ017178

We found a problem when we removed a working sd card that the irqaction
of omap_hsmmc can sleep to 3.6s. This cause our watchdog to work.
In func omap_hsmmc_reset_controller_fsm, it should watch a 0->1
transition.It used loops_per_jiffy as the timer.
The code is:
> while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>                && (i++ < limit))
>                        cpu_relax();
But the loops_per_jiffy is:
>  while(i++ < limit)
>	cpu_relax();
It add some codes so the time became long.
Becasue those codes in ISR context, it can't use timer_before/after.
I divived the time into 1ms and used udelay(1) to instead.
It will cause do additional udelay(1).But from my test,it looks good.

Reported-by: Yuzheng Ma <mayuzheng@kedacom.com>
Tested-by: Yuzheng Ma <mayuzheng@kedacom.com>
Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 drivers/mmc/host/omap_hsmmc.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1865321..96daca1 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -977,6 +977,8 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
 	unsigned long limit = (loops_per_jiffy *
 				msecs_to_jiffies(MMC_TIMEOUT_MS));
 
+	/*Divided time into us for unit 1,we can use udelay(1)*/
+	i = limit / (MMC_TIMEOUT_MS * 1000);
 	OMAP_HSMMC_WRITE(host->base, SYSCTL,
 			 OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
 
@@ -985,15 +987,19 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
 	 * Monitor a 0->1 transition first
 	 */
 	if (mmc_slot(host).features & HSMMC_HAS_UPDATED_RESET) {
-		while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
-					&& (i++ < limit))
-			cpu_relax();
+		while (i--) {
+			if ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
+				break;
+			udelay(1);
+		}
 	}
-	i = 0;
 
-	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit) &&
-		(i++ < limit))
-		cpu_relax();
+	i = limit / (MMC_TIMEOUT_MS * 1000);
+	while (i--) {
+		if (!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
+			break;
+		udealy(1);
+	}
 
 	if (OMAP_HSMMC_READ(host->base, SYSCTL) & bit)
 		dev_err(mmc_dev(host->mmc),
-- 
1.8.1.2


Thanks!
Jianpeng Maÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
