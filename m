Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaEGK2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:28:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57926 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753550AbaEGK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:28:19 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] rtc: rtc-at91rm9200: fix uninterruptible wait for ACKUPD
Date: Wed,  7 May 2014 12:28:10 +0200
Message-Id: <1399458490-11870-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc user must wait at least 1 sec between each time/calandar update
(see atmel's datasheet chapter "Updating Time/Calendar").

Use the SECEV interrupt (as suggested by the datasheet) to wait for the
RTC to be ready for new updates.

Cc: <stable@vger.kernel.org> # v3.10+
Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
---
Hello,

This patch fixes a deadlock in an uninterruptible wait when the RTC is
updated more than once every second.
AFAICT the bug is here from the beginning, but I think we should at least
backport this fix to 3.10 and the following longterm and stable releases.

Best Regards,

Boris

Changes since v1:
- disable SECEV interrupt when the RTC is ready to accept new time updates

 drivers/rtc/rtc-at91rm9200.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 3281c90..44fe83e 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -48,6 +48,7 @@ struct at91_rtc_config {
 
 static const struct at91_rtc_config *at91_rtc_config;
 static DECLARE_COMPLETION(at91_rtc_updated);
+static DECLARE_COMPLETION(at91_rtc_upd_rdy);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
@@ -161,6 +162,8 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
+	wait_for_completion(&at91_rtc_upd_rdy);
+
 	/* Stop Time/Calendar from counting */
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
@@ -183,7 +186,9 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 
 	/* Restart Time/Calendar */
 	cr = at91_rtc_read(AT91_RTC_CR);
+	at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_SECEV);
 	at91_rtc_write(AT91_RTC_CR, cr & ~(AT91_RTC_UPDCAL | AT91_RTC_UPDTIM));
+	at91_rtc_write_ier(AT91_RTC_SECEV);
 
 	return 0;
 }
@@ -290,8 +295,10 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
-		if (rtsr & AT91_RTC_SECEV)
-			events |= (RTC_UF | RTC_IRQF);
+		if (rtsr & AT91_RTC_SECEV) {
+			complete(&at91_rtc_upd_rdy);
+			at91_rtc_write_idr(AT91_RTC_SECEV);
+		}
 		if (rtsr & AT91_RTC_ACKUPD)
 			complete(&at91_rtc_updated);
 
@@ -413,6 +420,11 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 		return PTR_ERR(rtc);
 	platform_set_drvdata(pdev, rtc);
 
+	/* enable SECEV interrupt in order to initialize at91_rtc_upd_rdy
+	 * completion.
+	 */
+	at91_rtc_write_ier(AT91_RTC_SECEV);
+
 	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
 }
-- 
1.8.3.2

