Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab3EWIkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:40:09 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:41193 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3EWIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:39:31 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Nelson <Robert.Nelson@digikey.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 3/5] rtc-at91rm9200: refactor interrupt-register handling
Date: Thu, 23 May 2013 10:38:53 +0200
Message-Id: <1369298335-24597-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1369298335-24597-1-git-send-email-jhovold@gmail.com>
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
 <1369298335-24597-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add accessors for the interrupt register.

This will allow us to easily add a shadow interrupt-mask register to
use on SoCs where the interrupt-mask register cannot be used.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/rtc/rtc-at91rm9200.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index ab2024b..9592d08 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -51,6 +51,21 @@ static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
 
+static void at91_rtc_write_ier(u32 mask)
+{
+	at91_rtc_write(AT91_RTC_IER, mask);
+}
+
+static void at91_rtc_write_idr(u32 mask)
+{
+	at91_rtc_write(AT91_RTC_IDR, mask);
+}
+
+static u32 at91_rtc_read_imr(void)
+{
+	return at91_rtc_read(AT91_RTC_IMR);
+}
+
 /*
  * Decode time/date into rtc_time structure
  */
@@ -114,9 +129,9 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
 
-	at91_rtc_write(AT91_RTC_IER, AT91_RTC_ACKUPD);
+	at91_rtc_write_ier(AT91_RTC_ACKUPD);
 	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD interrupt */
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD);
+	at91_rtc_write_idr(AT91_RTC_ACKUPD);
 
 	at91_rtc_write(AT91_RTC_TIMR,
 			  bin2bcd(tm->tm_sec) << 0
@@ -148,7 +163,7 @@ static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = at91_alarm_year - 1900;
 
-	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
+	alrm->enabled = (at91_rtc_read_imr() & AT91_RTC_ALARM)
 			? 1 : 0;
 
 	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -173,7 +188,7 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm.tm_min = alrm->time.tm_min;
 	tm.tm_sec = alrm->time.tm_sec;
 
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
+	at91_rtc_write_idr(AT91_RTC_ALARM);
 	at91_rtc_write(AT91_RTC_TIMALR,
 		  bin2bcd(tm.tm_sec) << 0
 		| bin2bcd(tm.tm_min) << 8
@@ -186,7 +201,7 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	if (alrm->enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
+		at91_rtc_write_ier(AT91_RTC_ALARM);
 	}
 
 	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -202,9 +217,9 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 
 	if (enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
+		at91_rtc_write_ier(AT91_RTC_ALARM);
 	} else
-		at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
+		at91_rtc_write_idr(AT91_RTC_ALARM);
 
 	return 0;
 }
@@ -213,7 +228,7 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
  */
 static int at91_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-	unsigned long imr = at91_rtc_read(AT91_RTC_IMR);
+	unsigned long imr = at91_rtc_read_imr();
 
 	seq_printf(seq, "update_IRQ\t: %s\n",
 			(imr & AT91_RTC_ACKUPD) ? "yes" : "no");
@@ -233,7 +248,7 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	unsigned int rtsr;
 	unsigned long events = 0;
 
-	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read(AT91_RTC_IMR);
+	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read_imr();
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
@@ -328,7 +343,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	at91_rtc_write(AT91_RTC_MR, 0);		/* 24 hour mode */
 
 	/* Disable all interrupts */
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
+	at91_rtc_write_idr(AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
 
@@ -373,7 +388,7 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
 	/* Disable all interrupts */
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
+	at91_rtc_write_idr(AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
 	free_irq(irq, pdev);
@@ -396,13 +411,13 @@ static int at91_rtc_suspend(struct device *dev)
 	/* this IRQ is shared with DBGU and other hardware which isn't
 	 * necessarily doing PM like we are...
 	 */
-	at91_rtc_imr = at91_rtc_read(AT91_RTC_IMR)
+	at91_rtc_imr = at91_rtc_read_imr()
 			& (AT91_RTC_ALARM|AT91_RTC_SECEV);
 	if (at91_rtc_imr) {
 		if (device_may_wakeup(dev))
 			enable_irq_wake(irq);
 		else
-			at91_rtc_write(AT91_RTC_IDR, at91_rtc_imr);
+			at91_rtc_write_idr(at91_rtc_imr);
 	}
 	return 0;
 }
@@ -413,7 +428,7 @@ static int at91_rtc_resume(struct device *dev)
 		if (device_may_wakeup(dev))
 			disable_irq_wake(irq);
 		else
-			at91_rtc_write(AT91_RTC_IER, at91_rtc_imr);
+			at91_rtc_write_ier(at91_rtc_imr);
 	}
 	return 0;
 }
-- 
1.8.2.1

