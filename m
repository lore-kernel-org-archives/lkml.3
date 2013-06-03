Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3FCBNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 21:13:23 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:37817 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3FCBNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 21:13:17 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH] rtc: cmos: Workaround bios clearing rtc control
Date: Sun,  2 Jun 2013 18:13:00 -0700
Message-Id: <1370221980-16122-1-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <20130529122707.997236928e9f87dc6ba2eaa7@linux-foundation.org>
References: <20130529122707.997236928e9f87dc6ba2eaa7@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bios may clear the rtc control register when resuming the system. Since the
cmos interrupt handler may now be run before the rtc_cmos is resumed, this can
cause the interrupt handler to ignore an alarm since the alarm bit is not set in
the rtc control register. To work around this, check if the rtc_cmos is
suspended and use the stored value for the rtc control register.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Sameer Nanda <snanda@chromium.org>
---
 drivers/rtc/rtc-cmos.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index ee0bc69..22803fe 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -556,17 +556,24 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 	rtc_control = CMOS_READ(RTC_CONTROL);
 	if (is_hpet_enabled())
 		irqstat = (unsigned long)irq & 0xF0;
-	irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+
+	/* If we were suspended, RTC_CONTROL may not be accurate since the
+	 * bios may have cleared it.
+	 */
+	if (!cmos_rtc.suspend_ctrl)
+		irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	else
+		irqstat &= (cmos_rtc.suspend_ctrl & RTC_IRQMASK) | RTC_IRQF;
 
 	/* All Linux RTC alarms should be treated as if they were oneshot.
 	 * Similar code may be needed in system wakeup paths, in case the
 	 * alarm woke the system.
 	 */
 	if (irqstat & RTC_AIE) {
+		cmos_rtc.suspend_ctrl &= ~RTC_AIE;
 		rtc_control &= ~RTC_AIE;
 		CMOS_WRITE(rtc_control, RTC_CONTROL);
 		hpet_mask_rtc_irq_bit(RTC_AIE);
-
 		CMOS_READ(RTC_INTR_FLAGS);
 	}
 	spin_unlock(&rtc_lock);
@@ -839,21 +846,23 @@ static inline int cmos_poweroff(struct device *dev)
 static int cmos_resume(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned char	tmp = cmos->suspend_ctrl;
+	unsigned char	tmp;
 
+	if (cmos->enabled_wake) {
+		if (cmos->wake_off)
+			cmos->wake_off(dev);
+		else
+			disable_irq_wake(cmos->irq);
+		cmos->enabled_wake = 0;
+	}
+
+	spin_lock_irq(&rtc_lock);
+	tmp = cmos->suspend_ctrl;
+	cmos->suspend_ctrl = 0;
 	/* re-enable any irqs previously active */
 	if (tmp & RTC_IRQMASK) {
 		unsigned char	mask;
 
-		if (cmos->enabled_wake) {
-			if (cmos->wake_off)
-				cmos->wake_off(dev);
-			else
-				disable_irq_wake(cmos->irq);
-			cmos->enabled_wake = 0;
-		}
-
-		spin_lock_irq(&rtc_lock);
 		if (device_may_wakeup(dev)) {
 			hpet_rtc_timer_init();
 		}
@@ -874,8 +883,8 @@ static int cmos_resume(struct device *dev)
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
 		} while (mask & RTC_AIE);
-		spin_unlock_irq(&rtc_lock);
 	}
+	spin_unlock_irq(&rtc_lock);
 
 	dev_dbg(dev, "resume, ctrl %02x\n", tmp);
 
-- 
1.8.2.1

