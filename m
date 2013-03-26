Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416Ab3CZPfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:35:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54080 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965215Ab3CZPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 118/150] drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR
Date: Tue, 26 Mar 2013 15:20:17 +0000
Message-Id: <1364311249-14454-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 0ef1594c017521ea89278e80fe3f80dafb17abde upstream.

On some revisions of AT91 SoCs, the RTC IMR register is not working.
Instead of elaborating a workaround for that specific SoC or IP version,
we simply use a software variable to store the Interrupt Mask Register
and modify it for each enabling/disabling of an interrupt.  The overhead
of this is negligible anyway.

The interrupt mask register (IMR) for the RTC is broken on the AT91SAM9x5
sub-family of SoCs (good overview of the members here:
http://www.eewiki.net/display/linuxonarm/AT91SAM9x5 ).  The "user visible
effect" is the RTC doesn't work.

That sub-family is less than two years old and only has devicetree (DT)
support and came online circa lk 3.7 .  The dust is yet to settle on the
DT stuff at least for AT91 SoCs (translation: lots of stuff is still
broken, so much that it is hard to know where to start).

The fix in the patch is pretty simple: just shadow the silicon IMR
register with a variable in the driver.  Some older SoCs (pre-DT) use the
the rtc-at91rm9200 driver (e.g.  obviously the AT91RM9200) and they should
not be impacted by the change.  There shouldn't be a large volume of
interrupts associated with a RTC.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.5: handle file rename ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-at91/include/mach/at91_rtc.h |  1 -
 drivers/rtc/rtc-at91rm9200.c               | 50 ++++++++++++++++++------------
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/at91_rtc.h b/arch/arm/mach-at91/include/mach/at91_rtc.h
index da1945e..5f940b6 100644
--- a/arch/arm/mach-at91/include/mach/at91_rtc.h
+++ b/arch/arm/mach-at91/include/mach/at91_rtc.h
@@ -64,7 +64,6 @@
 #define	AT91_RTC_SCCR		0x1c			/* Status Clear Command Register */
 #define	AT91_RTC_IER		0x20			/* Interrupt Enable Register */
 #define	AT91_RTC_IDR		0x24			/* Interrupt Disable Register */
-#define	AT91_RTC_IMR		0x28			/* Interrupt Mask Register */
 
 #define	AT91_RTC_VER		0x2c			/* Valid Entry Register */
 #define		AT91_RTC_NVTIM		(1 <<  0)		/* Non valid Time */
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index dc474bc..129f49d 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -43,6 +43,7 @@ static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
+static u32 at91_rtc_imr;
 
 /*
  * Decode time/date into rtc_time structure
@@ -107,9 +108,11 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
 
+	at91_rtc_imr |= AT91_RTC_ACKUPD;
 	at91_rtc_write(AT91_RTC_IER, AT91_RTC_ACKUPD);
 	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD interrupt */
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD);
+	at91_rtc_imr &= ~AT91_RTC_ACKUPD;
 
 	at91_rtc_write(AT91_RTC_TIMR,
 			  bin2bcd(tm->tm_sec) << 0
@@ -141,7 +144,7 @@ static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = at91_alarm_year - 1900;
 
-	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
+	alrm->enabled = (at91_rtc_imr & AT91_RTC_ALARM)
 			? 1 : 0;
 
 	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -167,6 +170,7 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm.tm_sec = alrm->time.tm_sec;
 
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
+	at91_rtc_imr &= ~AT91_RTC_ALARM;
 	at91_rtc_write(AT91_RTC_TIMALR,
 		  bin2bcd(tm.tm_sec) << 0
 		| bin2bcd(tm.tm_min) << 8
@@ -179,6 +183,7 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	if (alrm->enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
+		at91_rtc_imr |= AT91_RTC_ALARM;
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
 	}
 
@@ -195,9 +200,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 
 	if (enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
+		at91_rtc_imr |= AT91_RTC_ALARM;
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
-	} else
+	} else {
 		at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
+		at91_rtc_imr &= ~AT91_RTC_ALARM;
+	}
 
 	return 0;
 }
@@ -206,12 +214,10 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
  */
 static int at91_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-	unsigned long imr = at91_rtc_read(AT91_RTC_IMR);
-
 	seq_printf(seq, "update_IRQ\t: %s\n",
-			(imr & AT91_RTC_ACKUPD) ? "yes" : "no");
+			(at91_rtc_imr & AT91_RTC_ACKUPD) ? "yes" : "no");
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
-			(imr & AT91_RTC_SECEV) ? "yes" : "no");
+			(at91_rtc_imr & AT91_RTC_SECEV) ? "yes" : "no");
 
 	return 0;
 }
@@ -226,7 +232,7 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	unsigned int rtsr;
 	unsigned long events = 0;
 
-	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read(AT91_RTC_IMR);
+	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_imr;
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
@@ -290,6 +296,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
+	at91_rtc_imr = 0;
 
 	ret = request_irq(irq, at91_rtc_interrupt,
 				IRQF_SHARED,
@@ -329,6 +336,7 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
+	at91_rtc_imr = 0;
 	free_irq(irq, pdev);
 
 	rtc_device_unregister(rtc);
@@ -341,31 +349,35 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 
 /* AT91RM9200 RTC Power management control */
 
-static u32 at91_rtc_imr;
+static u32 at91_rtc_bkpimr;
+
 
 static int at91_rtc_suspend(struct device *dev)
 {
 	/* this IRQ is shared with DBGU and other hardware which isn't
 	 * necessarily doing PM like we are...
 	 */
-	at91_rtc_imr = at91_rtc_read(AT91_RTC_IMR)
-			& (AT91_RTC_ALARM|AT91_RTC_SECEV);
-	if (at91_rtc_imr) {
-		if (device_may_wakeup(dev))
+	at91_rtc_bkpimr = at91_rtc_imr & (AT91_RTC_ALARM|AT91_RTC_SECEV);
+	if (at91_rtc_bkpimr) {
+		if (device_may_wakeup(dev)) {
 			enable_irq_wake(irq);
-		else
-			at91_rtc_write(AT91_RTC_IDR, at91_rtc_imr);
-	}
+		} else {
+			at91_rtc_write(AT91_RTC_IDR, at91_rtc_bkpimr);
+			at91_rtc_imr &= ~at91_rtc_bkpimr;
+		}
+}
 	return 0;
 }
 
 static int at91_rtc_resume(struct device *dev)
 {
-	if (at91_rtc_imr) {
-		if (device_may_wakeup(dev))
+	if (at91_rtc_bkpimr) {
+		if (device_may_wakeup(dev)) {
 			disable_irq_wake(irq);
-		else
-			at91_rtc_write(AT91_RTC_IER, at91_rtc_imr);
+		} else {
+			at91_rtc_imr |= at91_rtc_bkpimr;
+			at91_rtc_write(AT91_RTC_IER, at91_rtc_bkpimr);
+		}
 	}
 	return 0;
 }
-- 
1.8.1.2

