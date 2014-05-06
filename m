Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbaEFO2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:28:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51849 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755633AbaEFO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:28:05 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH] rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
Date: Tue,  6 May 2014 16:28:01 +0200
Message-Id: <1399386481-18643-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <94c06375c1b44c8eb5233b0ccf2e4b13@BY2PR05MB048.namprd05.prod.outlook.com>
References: <94c06375c1b44c8eb5233b0ccf2e4b13@BY2PR05MB048.namprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc user must wait at least 1 sec between each time/calandar update
(see atmel's datasheet chapter "Updating Time/Calendar").

Use the 1Hz interrupt to update the at91_rtc_upd_rdy flag and wait for
the at91_rtc_wait_upd_rdy event if the rtc is not ready.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
---
Hello Bryan,

I reproduced your bug (using your script) and this patch seems to fix the
problem.

Could you try it and let me know if it works for you ?

Best Regards,

Boris

 drivers/rtc/rtc-at91rm9200.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 3281c90..e3fe54c 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -48,11 +48,13 @@ struct at91_rtc_config {
 
 static const struct at91_rtc_config *at91_rtc_config;
 static DECLARE_COMPLETION(at91_rtc_updated);
+static DECLARE_COMPLETION(at91_rtc_wait_upd_rdy);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
 static DEFINE_SPINLOCK(at91_rtc_lock);
 static u32 at91_rtc_shadow_imr;
+static bool at91_rtc_upd_rdy;
 
 static void at91_rtc_write_ier(u32 mask)
 {
@@ -161,6 +163,8 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
+	wait_for_completion(&at91_rtc_wait_upd_rdy);
+
 	/* Stop Time/Calendar from counting */
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
@@ -183,6 +187,7 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 
 	/* Restart Time/Calendar */
 	cr = at91_rtc_read(AT91_RTC_CR);
+	at91_rtc_upd_rdy = 0;
 	at91_rtc_write(AT91_RTC_CR, cr & ~(AT91_RTC_UPDCAL | AT91_RTC_UPDTIM));
 
 	return 0;
@@ -290,8 +295,13 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
-		if (rtsr & AT91_RTC_SECEV)
+		if (rtsr & AT91_RTC_SECEV) {
 			events |= (RTC_UF | RTC_IRQF);
+			if (!at91_rtc_upd_rdy) {
+				at91_rtc_upd_rdy = 1;
+				complete(&at91_rtc_wait_upd_rdy);
+			}
+		}
 		if (rtsr & AT91_RTC_ACKUPD)
 			complete(&at91_rtc_updated);
 
@@ -413,6 +423,8 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 		return PTR_ERR(rtc);
 	platform_set_drvdata(pdev, rtc);
 
+	/* Enable 1Hz events */
+	at91_rtc_write_ier(AT91_RTC_SECEV);
 	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
 }
-- 
1.8.3.2

