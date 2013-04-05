Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162008Ab3DEQQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:16:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:53883 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161938Ab3DEQQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:16:42 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <torvalds@linux-foundation.org>
CC: <akpm@linux-foundation.org>, <jhovold@gmail.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <dgilbert@interlog.com>, <linux-arm-kernel@lists.infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] Revert "drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR"
Date: Fri, 5 Apr 2013 18:16:34 +0200
Message-ID: <1365178594-8468-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <20130405153547.GA515@kroah.com>
References: <20130405153547.GA515@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

This reverts commit 0ef1594.

This patch introduced a few races which cannot be easily fixed with a
small follow-up patch. Furthermore, the SoC with the broken hardware
register, which this patch intended to add support for, can only be used
with device trees, which this driver currently does not support.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Linus,

As suggested by Greg, I send you directly this "revert" patch. I hope it will
join your tree before 3.9-final.

Here is the discussion that led to this "revert" patch.
https://lkml.org/lkml/2013/4/3/176

Thanks a lot, best regards,

 drivers/rtc/rtc-at91rm9200.c | 50 +++++++++++++++++---------------------------
 drivers/rtc/rtc-at91rm9200.h |  1 +
 2 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 0a9f27e..434ebc3 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -44,7 +44,6 @@ static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
-static u32 at91_rtc_imr;
 
 /*
  * Decode time/date into rtc_time structure
@@ -109,11 +108,9 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
 
-	at91_rtc_imr |= AT91_RTC_ACKUPD;
 	at91_rtc_write(AT91_RTC_IER, AT91_RTC_ACKUPD);
 	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD interrupt */
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD);
-	at91_rtc_imr &= ~AT91_RTC_ACKUPD;
 
 	at91_rtc_write(AT91_RTC_TIMR,
 			  bin2bcd(tm->tm_sec) << 0
@@ -145,7 +142,7 @@ static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = at91_alarm_year - 1900;
 
-	alrm->enabled = (at91_rtc_imr & AT91_RTC_ALARM)
+	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
 			? 1 : 0;
 
 	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -171,7 +168,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm.tm_sec = alrm->time.tm_sec;
 
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
-	at91_rtc_imr &= ~AT91_RTC_ALARM;
 	at91_rtc_write(AT91_RTC_TIMALR,
 		  bin2bcd(tm.tm_sec) << 0
 		| bin2bcd(tm.tm_min) << 8
@@ -184,7 +180,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	if (alrm->enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_imr |= AT91_RTC_ALARM;
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
 	}
 
@@ -201,12 +196,9 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 
 	if (enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_imr |= AT91_RTC_ALARM;
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
-	} else {
+	} else
 		at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
-		at91_rtc_imr &= ~AT91_RTC_ALARM;
-	}
 
 	return 0;
 }
@@ -215,10 +207,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
  */
 static int at91_rtc_proc(struct device *dev, struct seq_file *seq)
 {
+	unsigned long imr = at91_rtc_read(AT91_RTC_IMR);
+
 	seq_printf(seq, "update_IRQ\t: %s\n",
-			(at91_rtc_imr & AT91_RTC_ACKUPD) ? "yes" : "no");
+			(imr & AT91_RTC_ACKUPD) ? "yes" : "no");
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
-			(at91_rtc_imr & AT91_RTC_SECEV) ? "yes" : "no");
+			(imr & AT91_RTC_SECEV) ? "yes" : "no");
 
 	return 0;
 }
@@ -233,7 +227,7 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	unsigned int rtsr;
 	unsigned long events = 0;
 
-	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_imr;
+	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read(AT91_RTC_IMR);
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
@@ -297,7 +291,6 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
-	at91_rtc_imr = 0;
 
 	ret = request_irq(irq, at91_rtc_interrupt,
 				IRQF_SHARED,
@@ -336,7 +329,6 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
-	at91_rtc_imr = 0;
 	free_irq(irq, pdev);
 
 	rtc_device_unregister(rtc);
@@ -349,35 +341,31 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 
 /* AT91RM9200 RTC Power management control */
 
-static u32 at91_rtc_bkpimr;
-
+static u32 at91_rtc_imr;
 
 static int at91_rtc_suspend(struct device *dev)
 {
 	/* this IRQ is shared with DBGU and other hardware which isn't
 	 * necessarily doing PM like we are...
 	 */
-	at91_rtc_bkpimr = at91_rtc_imr & (AT91_RTC_ALARM|AT91_RTC_SECEV);
-	if (at91_rtc_bkpimr) {
-		if (device_may_wakeup(dev)) {
+	at91_rtc_imr = at91_rtc_read(AT91_RTC_IMR)
+			& (AT91_RTC_ALARM|AT91_RTC_SECEV);
+	if (at91_rtc_imr) {
+		if (device_may_wakeup(dev))
 			enable_irq_wake(irq);
-		} else {
-			at91_rtc_write(AT91_RTC_IDR, at91_rtc_bkpimr);
-			at91_rtc_imr &= ~at91_rtc_bkpimr;
-		}
-}
+		else
+			at91_rtc_write(AT91_RTC_IDR, at91_rtc_imr);
+	}
 	return 0;
 }
 
 static int at91_rtc_resume(struct device *dev)
 {
-	if (at91_rtc_bkpimr) {
-		if (device_may_wakeup(dev)) {
+	if (at91_rtc_imr) {
+		if (device_may_wakeup(dev))
 			disable_irq_wake(irq);
-		} else {
-			at91_rtc_imr |= at91_rtc_bkpimr;
-			at91_rtc_write(AT91_RTC_IER, at91_rtc_bkpimr);
-		}
+		else
+			at91_rtc_write(AT91_RTC_IER, at91_rtc_imr);
 	}
 	return 0;
 }
diff --git a/drivers/rtc/rtc-at91rm9200.h b/drivers/rtc/rtc-at91rm9200.h
index 5f940b6..da1945e 100644
--- a/drivers/rtc/rtc-at91rm9200.h
+++ b/drivers/rtc/rtc-at91rm9200.h
@@ -64,6 +64,7 @@
 #define	AT91_RTC_SCCR		0x1c			/* Status Clear Command Register */
 #define	AT91_RTC_IER		0x20			/* Interrupt Enable Register */
 #define	AT91_RTC_IDR		0x24			/* Interrupt Disable Register */
+#define	AT91_RTC_IMR		0x28			/* Interrupt Mask Register */
 
 #define	AT91_RTC_VER		0x2c			/* Valid Entry Register */
 #define		AT91_RTC_NVTIM		(1 <<  0)		/* Non valid Time */
-- 
1.8.0

