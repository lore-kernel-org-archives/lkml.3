Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996Ab3DBQgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:36:16 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:23778 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760954Ab3DBQgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:36:14 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <jhovold@gmail.com>,
        <dgilbert@interlog.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RFC PATCH v2] rtc: rtc-at91rm9200: manage IMR depending on revision
Date: Tue, 2 Apr 2013 18:36:06 +0200
Message-ID: <1364920566-30040-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1364908007-5150-1-git-send-email-nicolas.ferre@atmel.com>
References: <1364908007-5150-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi again,

Here is my latest revision of this fix. It depends on the patch that is already
in Andrew's patch stack: "drivers-rtc-rtc-at91rm9200c-add-dt-support.patch".

I now use a different compatibility string to figure out what is the IP
revision that has the "boggus IMR" error. I think this way to handle it
is much simpler than the "config" structure one from Johan. The small number of
line changed and the "single patch" nature of it make me think that it will be
easier to send upstream and in the "stable" trees...

Please give feedback, but moreover, I would like to know if you (Johan and Douglas)
agree to give your "Signed-off-by" line because this patch is certainly
inspired by your comments, code and reviews.

Thank you for your help. Best regards,

 .../bindings/rtc/atmel,at91rm9200-rtc.txt          |   3 +-
 drivers/rtc/rtc-at91rm9200.c                       | 126 ++++++++++++++++-----
 drivers/rtc/rtc-at91rm9200.h                       |   1 +
 3 files changed, 101 insertions(+), 29 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
index 2a3feab..9b87053 100644
--- a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
@@ -1,7 +1,8 @@
 Atmel AT91RM9200 Real Time Clock
 
 Required properties:
-- compatible: should be: "atmel,at91rm9200-rtc"
+- compatible: should be: "atmel,at91rm9200-rtc", "atmel,at91sam9x5-rtc" or
+                         "atmel,at91sam9n12-rtc".
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: rtc alarm/event interrupt
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 29b92e4..f6b2ee3 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -25,6 +25,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/ioctl.h>
 #include <linux/completion.h>
 #include <linux/io.h>
@@ -47,6 +48,69 @@ static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
 static u32 at91_rtc_imr;
+static DEFINE_SPINLOCK(lock);
+static void (*at91_rtc_set_irq)(u32 irq_mask);
+static void (*at91_rtc_clear_irq)(u32 irq_mask);
+static u32 (*at91_rtc_read_imr)(void);
+
+static void at91_rtc_set_irq_simple(u32 irq_mask)
+{
+	at91_rtc_write(AT91_RTC_IER, irq_mask);
+}
+
+static void at91_rtc_clear_irq_simple(u32 irq_mask)
+{
+	at91_rtc_write(AT91_RTC_IDR, irq_mask);
+}
+
+static u32 at91_rtc_read_imr_simple(void)
+{
+	return at91_rtc_read(AT91_RTC_IMR);
+}
+
+static void at91_rtc_set_irq_brokenimr(u32 irq_mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lock, flags);
+	at91_rtc_imr |= irq_mask;
+	at91_rtc_write(AT91_RTC_IER, irq_mask);
+	spin_unlock_irqrestore(&lock, flags);
+}
+
+static void at91_rtc_clear_irq_brokenimr(u32 irq_mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lock, flags);
+	at91_rtc_write(AT91_RTC_IDR, irq_mask);
+	/*
+	 * Register read back (of any RTC-register) needed to make sure
+	 * IDR-register write has reached the peripheral before updating
+	 * shadow mask.
+	 *
+	 * Note that there is still a possibility that the mask is updated
+	 * before interrupts have actually been disabled in hardware. The only
+	 * way to be certain would be to poll the IMR-register, which is is
+	 * the very register we are trying to emulate. The register read back
+	 * is a reasonable heuristic.
+	 */
+	at91_rtc_read(AT91_RTC_SR);
+	at91_rtc_imr &= ~irq_mask;
+	spin_unlock_irqrestore(&lock, flags);
+}
+
+static u32 at91_rtc_read_imr_brokenimr(void)
+{
+	unsigned long flags;
+	u32 shadow_imr;
+
+	spin_lock_irqsave(&lock, flags);
+	shadow_imr = at91_rtc_imr;
+	spin_unlock_irqrestore(&lock, flags);
+
+	return shadow_imr;
+}
 
 /*
  * Decode time/date into rtc_time structure
@@ -111,11 +175,9 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
 
-	at91_rtc_imr |= AT91_RTC_ACKUPD;
-	at91_rtc_write(AT91_RTC_IER, AT91_RTC_ACKUPD);
+	at91_rtc_set_irq(AT91_RTC_ACKUPD);
 	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD interrupt */
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD);
-	at91_rtc_imr &= ~AT91_RTC_ACKUPD;
+	at91_rtc_clear_irq(AT91_RTC_ACKUPD);
 
 	at91_rtc_write(AT91_RTC_TIMR,
 			  bin2bcd(tm->tm_sec) << 0
@@ -147,7 +209,7 @@ static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = at91_alarm_year - 1900;
 
-	alrm->enabled = (at91_rtc_imr & AT91_RTC_ALARM)
+	alrm->enabled = (at91_rtc_read_imr() & AT91_RTC_ALARM)
 			? 1 : 0;
 
 	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -172,8 +234,7 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm.tm_min = alrm->time.tm_min;
 	tm.tm_sec = alrm->time.tm_sec;
 
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
-	at91_rtc_imr &= ~AT91_RTC_ALARM;
+	at91_rtc_clear_irq(AT91_RTC_ALARM);
 	at91_rtc_write(AT91_RTC_TIMALR,
 		  bin2bcd(tm.tm_sec) << 0
 		| bin2bcd(tm.tm_min) << 8
@@ -186,8 +247,7 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	if (alrm->enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_imr |= AT91_RTC_ALARM;
-		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
+		at91_rtc_set_irq(AT91_RTC_ALARM);
 	}
 
 	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -203,11 +263,9 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 
 	if (enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_imr |= AT91_RTC_ALARM;
-		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
+		at91_rtc_set_irq(AT91_RTC_ALARM);
 	} else {
-		at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
-		at91_rtc_imr &= ~AT91_RTC_ALARM;
+		at91_rtc_clear_irq(AT91_RTC_ALARM);
 	}
 
 	return 0;
@@ -217,10 +275,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
  */
 static int at91_rtc_proc(struct device *dev, struct seq_file *seq)
 {
+	unsigned long imr = at91_rtc_read_imr();
+
 	seq_printf(seq, "update_IRQ\t: %s\n",
-			(at91_rtc_imr & AT91_RTC_ACKUPD) ? "yes" : "no");
+			(imr & AT91_RTC_ACKUPD) ? "yes" : "no");
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
-			(at91_rtc_imr & AT91_RTC_SECEV) ? "yes" : "no");
+			(imr & AT91_RTC_SECEV) ? "yes" : "no");
 
 	return 0;
 }
@@ -235,7 +295,7 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	unsigned int rtsr;
 	unsigned long events = 0;
 
-	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_imr;
+	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read_imr();
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
@@ -301,6 +361,18 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 					AT91_RTC_CALEV);
 	at91_rtc_imr = 0;
 
+	/* Choose IMR access functions */
+	at91_rtc_set_irq = at91_rtc_set_irq_simple;
+	at91_rtc_clear_irq = at91_rtc_clear_irq_simple;
+	at91_rtc_read_imr = at91_rtc_read_imr_simple;
+
+	if (pdev->dev.of_node
+	    && of_device_is_compatible(pdev->dev.of_node, "atmel,at91sam9x5-rtc")) {
+		at91_rtc_set_irq = at91_rtc_set_irq_brokenimr;
+		at91_rtc_clear_irq = at91_rtc_clear_irq_brokenimr;
+		at91_rtc_read_imr = at91_rtc_read_imr_brokenimr;
+	}
+
 	ret = request_irq(irq, at91_rtc_interrupt,
 				IRQF_SHARED,
 				"at91_rtc", pdev);
@@ -359,27 +431,23 @@ static int at91_rtc_suspend(struct device *dev)
 	/* this IRQ is shared with DBGU and other hardware which isn't
 	 * necessarily doing PM like we are...
 	 */
-	at91_rtc_bkpimr = at91_rtc_imr & (AT91_RTC_ALARM|AT91_RTC_SECEV);
+	at91_rtc_bkpimr = at91_rtc_read_imr() & (AT91_RTC_ALARM|AT91_RTC_SECEV);
 	if (at91_rtc_bkpimr) {
-		if (device_may_wakeup(dev)) {
+		if (device_may_wakeup(dev))
 			enable_irq_wake(irq);
-		} else {
-			at91_rtc_write(AT91_RTC_IDR, at91_rtc_bkpimr);
-			at91_rtc_imr &= ~at91_rtc_bkpimr;
-		}
-}
+		else
+			at91_rtc_clear_irq(at91_rtc_bkpimr);
+	}
 	return 0;
 }
 
 static int at91_rtc_resume(struct device *dev)
 {
 	if (at91_rtc_bkpimr) {
-		if (device_may_wakeup(dev)) {
+		if (device_may_wakeup(dev))
 			disable_irq_wake(irq);
-		} else {
-			at91_rtc_imr |= at91_rtc_bkpimr;
-			at91_rtc_write(AT91_RTC_IER, at91_rtc_bkpimr);
-		}
+		else
+			at91_rtc_set_irq(at91_rtc_bkpimr);
 	}
 	return 0;
 }
@@ -397,6 +465,8 @@ static const struct dev_pm_ops at91_rtc_pm = {
 
 static const struct of_device_id at91_rtc_dt_ids[] = {
 	{ .compatible = "atmel,at91rm9200-rtc" },
+	{ .compatible = "atmel,at91sam9x5-rtc" },
+	{ .compatible = "atmel,at91sam9n12-rtc" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
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

