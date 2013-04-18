Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3DRJRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:17:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab3DRJR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 11/72] Revert "drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR"
Date: Thu, 18 Apr 2013 10:15:56 +0100
Message-Id: <1366276617-3553-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e24b0bfa2f0446ffaad2661040be23668133aef8 upstream.

This reverts commit 0ef1594c017521ea89278e80fe3f80dafb17abde.

This patch introduced a few races which cannot be easily fixed with a
small follow-up patch. Furthermore, the SoC with the broken hardware
register, which this patch intended to add support for, can only be used
with device trees, which this driver currently does not support.

[ Here is the discussion that led to this "revert" patch:
  https://lkml.org/lkml/2013/4/3/176 ]

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-at91/include/mach/at91_rtc.h |  1 +
 drivers/rtc/rtc-at91rm9200.c               | 50 ++++++++++++------------------
 2 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/at91_rtc.h b/arch/arm/mach-at91/include/mach/at91_rtc.h
index 5f940b6..da1945e 100644
--- a/arch/arm/mach-at91/include/mach/at91_rtc.h
+++ b/arch/arm/mach-at91/include/mach/at91_rtc.h
@@ -64,6 +64,7 @@
 #define	AT91_RTC_SCCR		0x1c			/* Status Clear Command Register */
 #define	AT91_RTC_IER		0x20			/* Interrupt Enable Register */
 #define	AT91_RTC_IDR		0x24			/* Interrupt Disable Register */
+#define	AT91_RTC_IMR		0x28			/* Interrupt Mask Register */
 
 #define	AT91_RTC_VER		0x2c			/* Valid Entry Register */
 #define		AT91_RTC_NVTIM		(1 <<  0)		/* Non valid Time */
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 129f49d..dc474bc 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -43,7 +43,6 @@ static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
-static u32 at91_rtc_imr;
 
 /*
  * Decode time/date into rtc_time structure
@@ -108,11 +107,9 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
 
-	at91_rtc_imr |= AT91_RTC_ACKUPD;
 	at91_rtc_write(AT91_RTC_IER, AT91_RTC_ACKUPD);
 	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD interrupt */
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD);
-	at91_rtc_imr &= ~AT91_RTC_ACKUPD;
 
 	at91_rtc_write(AT91_RTC_TIMR,
 			  bin2bcd(tm->tm_sec) << 0
@@ -144,7 +141,7 @@ static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = at91_alarm_year - 1900;
 
-	alrm->enabled = (at91_rtc_imr & AT91_RTC_ALARM)
+	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
 			? 1 : 0;
 
 	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -170,7 +167,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm.tm_sec = alrm->time.tm_sec;
 
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
-	at91_rtc_imr &= ~AT91_RTC_ALARM;
 	at91_rtc_write(AT91_RTC_TIMALR,
 		  bin2bcd(tm.tm_sec) << 0
 		| bin2bcd(tm.tm_min) << 8
@@ -183,7 +179,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	if (alrm->enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_imr |= AT91_RTC_ALARM;
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
 	}
 
@@ -200,12 +195,9 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 
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
@@ -214,10 +206,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
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
@@ -232,7 +226,7 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	unsigned int rtsr;
 	unsigned long events = 0;
 
-	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_imr;
+	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read(AT91_RTC_IMR);
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
@@ -296,7 +290,6 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
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
-- 
1.8.1.2

