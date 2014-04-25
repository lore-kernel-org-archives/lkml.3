Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaDYJhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:37:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24921 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752010AbaDYJbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:31:23 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 1/7] rtc-cmos: abstract IO accessors
Date: Fri, 25 Apr 2014 10:31:09 +0100
Message-Id: <1398418275-9671-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
References: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, rtc-cmos mandates the use of an I/O port, defined in an
architecture dependant way. This prevents the easy integration of
a platform that doesn't have the simple notion of an IO port.

Add wrappers around the CMOS_READ/CMOS_WRITE accessors, in order
to isolate the driver code from the vintage macros.

No feature is added.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/rtc/rtc-cmos.c    | 72 +++++++++++++++++++++++++----------------------
 include/asm-generic/rtc.h | 57 +++++++++++++++++++++----------------
 2 files changed, 72 insertions(+), 57 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 0963c93..ae895e8 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -221,24 +221,24 @@ static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	t->time.tm_mon = -1;
 
 	spin_lock_irq(&rtc_lock);
-	t->time.tm_sec = CMOS_READ(RTC_SECONDS_ALARM);
-	t->time.tm_min = CMOS_READ(RTC_MINUTES_ALARM);
-	t->time.tm_hour = CMOS_READ(RTC_HOURS_ALARM);
+	t->time.tm_sec = do_cmos_read(RTC_SECONDS_ALARM);
+	t->time.tm_min = do_cmos_read(RTC_MINUTES_ALARM);
+	t->time.tm_hour = do_cmos_read(RTC_HOURS_ALARM);
 
 	if (cmos->day_alrm) {
 		/* ignore upper bits on readback per ACPI spec */
-		t->time.tm_mday = CMOS_READ(cmos->day_alrm) & 0x3f;
+		t->time.tm_mday = do_cmos_read(cmos->day_alrm) & 0x3f;
 		if (!t->time.tm_mday)
 			t->time.tm_mday = -1;
 
 		if (cmos->mon_alrm) {
-			t->time.tm_mon = CMOS_READ(cmos->mon_alrm);
+			t->time.tm_mon = do_cmos_read(cmos->mon_alrm);
 			if (!t->time.tm_mon)
 				t->time.tm_mon = -1;
 		}
 	}
 
-	rtc_control = CMOS_READ(RTC_CONTROL);
+	rtc_control = do_cmos_read(RTC_CONTROL);
 	spin_unlock_irq(&rtc_lock);
 
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
@@ -284,7 +284,7 @@ static void cmos_checkintr(struct cmos_rtc *cmos, unsigned char rtc_control)
 	/* NOTE after changing RTC_xIE bits we always read INTR_FLAGS;
 	 * allegedly some older rtcs need that to handle irqs properly
 	 */
-	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
+	rtc_intr = do_cmos_read(RTC_INTR_FLAGS);
 
 	if (is_hpet_enabled())
 		return;
@@ -301,11 +301,11 @@ static void cmos_irq_enable(struct cmos_rtc *cmos, unsigned char mask)
 	/* flush any pending IRQ status, notably for update irqs,
 	 * before we enable new IRQs
 	 */
-	rtc_control = CMOS_READ(RTC_CONTROL);
+	rtc_control = do_cmos_read(RTC_CONTROL);
 	cmos_checkintr(cmos, rtc_control);
 
 	rtc_control |= mask;
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	do_cmos_write(rtc_control, RTC_CONTROL);
 	hpet_set_rtc_irq_bit(mask);
 
 	cmos_checkintr(cmos, rtc_control);
@@ -315,9 +315,9 @@ static void cmos_irq_disable(struct cmos_rtc *cmos, unsigned char mask)
 {
 	unsigned char	rtc_control;
 
-	rtc_control = CMOS_READ(RTC_CONTROL);
+	rtc_control = do_cmos_read(RTC_CONTROL);
 	rtc_control &= ~mask;
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	do_cmos_write(rtc_control, RTC_CONTROL);
 	hpet_mask_rtc_irq_bit(mask);
 
 	cmos_checkintr(cmos, rtc_control);
@@ -337,7 +337,7 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	min = t->time.tm_min;
 	sec = t->time.tm_sec;
 
-	rtc_control = CMOS_READ(RTC_CONTROL);
+	rtc_control = do_cmos_read(RTC_CONTROL);
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		/* Writing 0xff means "don't care" or "match all".  */
 		mon = (mon <= 12) ? bin2bcd(mon) : 0xff;
@@ -353,15 +353,15 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	cmos_irq_disable(cmos, RTC_AIE);
 
 	/* update alarm */
-	CMOS_WRITE(hrs, RTC_HOURS_ALARM);
-	CMOS_WRITE(min, RTC_MINUTES_ALARM);
-	CMOS_WRITE(sec, RTC_SECONDS_ALARM);
+	do_cmos_write(hrs, RTC_HOURS_ALARM);
+	do_cmos_write(min, RTC_MINUTES_ALARM);
+	do_cmos_write(sec, RTC_SECONDS_ALARM);
 
 	/* the system may support an "enhanced" alarm */
 	if (cmos->day_alrm) {
-		CMOS_WRITE(mday, cmos->day_alrm);
+		do_cmos_write(mday, cmos->day_alrm);
 		if (cmos->mon_alrm)
-			CMOS_WRITE(mon, cmos->mon_alrm);
+			do_cmos_write(mon, cmos->mon_alrm);
 	}
 
 	/* FIXME the HPET alarm glue currently ignores day_alrm
@@ -452,8 +452,8 @@ static int cmos_procfs(struct device *dev, struct seq_file *seq)
 	unsigned char	rtc_control, valid;
 
 	spin_lock_irq(&rtc_lock);
-	rtc_control = CMOS_READ(RTC_CONTROL);
-	valid = CMOS_READ(RTC_VALID);
+	rtc_control = do_cmos_read(RTC_CONTROL);
+	valid = do_cmos_read(RTC_VALID);
 	spin_unlock_irq(&rtc_lock);
 
 	/* NOTE:  at least ICH6 reports battery status using a different
@@ -519,7 +519,7 @@ cmos_nvram_read(struct file *filp, struct kobject *kobj,
 	spin_lock_irq(&rtc_lock);
 	for (retval = 0; count; count--, off++, retval++) {
 		if (off < 128)
-			*buf++ = CMOS_READ(off);
+			*buf++ = do_cmos_read(off);
 		else if (can_bank2)
 			*buf++ = cmos_read_bank2(off);
 		else
@@ -560,7 +560,7 @@ cmos_nvram_write(struct file *filp, struct kobject *kobj,
 				|| off == cmos->century)
 			buf++;
 		else if (off < 128)
-			CMOS_WRITE(*buf++, off);
+			do_cmos_write(*buf++, off);
 		else if (can_bank2)
 			cmos_write_bank2(*buf++, off);
 		else
@@ -600,8 +600,8 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 	 * Note that HPET and RTC are almost certainly out of phase,
 	 * giving different IRQ status ...
 	 */
-	irqstat = CMOS_READ(RTC_INTR_FLAGS);
-	rtc_control = CMOS_READ(RTC_CONTROL);
+	irqstat = do_cmos_read(RTC_INTR_FLAGS);
+	rtc_control = do_cmos_read(RTC_CONTROL);
 	if (is_hpet_enabled())
 		irqstat = (unsigned long)irq & 0xF0;
 
@@ -620,9 +620,9 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 	if (irqstat & RTC_AIE) {
 		cmos_rtc.suspend_ctrl &= ~RTC_AIE;
 		rtc_control &= ~RTC_AIE;
-		CMOS_WRITE(rtc_control, RTC_CONTROL);
+		do_cmos_write(rtc_control, RTC_CONTROL);
 		hpet_mask_rtc_irq_bit(RTC_AIE);
-		CMOS_READ(RTC_INTR_FLAGS);
+		do_cmos_read(RTC_INTR_FLAGS);
 	}
 	spin_unlock(&rtc_lock);
 
@@ -734,12 +734,12 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	 */
 	cmos_rtc.rtc->irq_freq = 1024;
 	hpet_set_periodic_freq(cmos_rtc.rtc->irq_freq);
-	CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
+	do_cmos_write(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
 
 	/* disable irqs */
 	cmos_irq_disable(&cmos_rtc, RTC_PIE | RTC_AIE | RTC_UIE);
 
-	rtc_control = CMOS_READ(RTC_CONTROL);
+	rtc_control = do_cmos_read(RTC_CONTROL);
 
 	spin_unlock_irq(&rtc_lock);
 
@@ -846,7 +846,7 @@ static int cmos_suspend(struct device *dev)
 
 	/* only the alarm might be a wakeup event source */
 	spin_lock_irq(&rtc_lock);
-	cmos->suspend_ctrl = tmp = CMOS_READ(RTC_CONTROL);
+	cmos->suspend_ctrl = tmp = do_cmos_read(RTC_CONTROL);
 	if (tmp & (RTC_PIE|RTC_AIE|RTC_UIE)) {
 		unsigned char	mask;
 
@@ -855,7 +855,7 @@ static int cmos_suspend(struct device *dev)
 		else
 			mask = RTC_IRQMASK;
 		tmp &= ~mask;
-		CMOS_WRITE(tmp, RTC_CONTROL);
+		do_cmos_write(tmp, RTC_CONTROL);
 		hpet_mask_rtc_irq_bit(mask);
 
 		cmos_checkintr(cmos, tmp);
@@ -912,10 +912,10 @@ static int cmos_resume(struct device *dev)
 			hpet_rtc_timer_init();
 
 		do {
-			CMOS_WRITE(tmp, RTC_CONTROL);
+			do_cmos_write(tmp, RTC_CONTROL);
 			hpet_set_rtc_irq_bit(tmp & RTC_IRQMASK);
 
-			mask = CMOS_READ(RTC_INTR_FLAGS);
+			mask = do_cmos_read(RTC_INTR_FLAGS);
 			mask &= (tmp & RTC_IRQMASK) | RTC_IRQF;
 			if (!is_hpet_enabled() || !is_intr(mask))
 				break;
@@ -1114,13 +1114,19 @@ static __init void cmos_of_init(struct platform_device *pdev)
 	if (!node)
 		return;
 
+	/*
+	 * Try to map an MMIO region first. If it fails, we'll
+	 * fallback on I/O access.
+	 */
+	rtc_cmos_set_base(of_iomap(node, 0));
+
 	val = of_get_property(node, "ctrl-reg", NULL);
 	if (val)
-		CMOS_WRITE(be32_to_cpup(val), RTC_CONTROL);
+		do_cmos_write(be32_to_cpup(val), RTC_CONTROL);
 
 	val = of_get_property(node, "freq-reg", NULL);
 	if (val)
-		CMOS_WRITE(be32_to_cpup(val), RTC_FREQ_SELECT);
+		do_cmos_write(be32_to_cpup(val), RTC_FREQ_SELECT);
 
 	get_rtc_time(&time);
 	ret = rtc_valid_tm(&time);
diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index fa86f24..313438a 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -28,6 +28,15 @@
 #define RTC_24H 0x02		/* 24 hour mode - else hours bit 7 means pm */
 #define RTC_DST_EN 0x01	        /* auto switch DST - works f. USA only */
 
+static inline u8 do_cmos_read(u8 reg)
+{
+	return CMOS_READ(reg);
+}
+
+static inline void do_cmos_write(u8 val, u8 reg)
+{
+	CMOS_WRITE(val, reg);
+}
 /*
  * Returns true if a clock update is in progress
  */
@@ -37,7 +46,7 @@ static inline unsigned char rtc_is_updating(void)
 	unsigned long flags;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	uip = (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP);
+	uip = (do_cmos_read(RTC_FREQ_SELECT) & RTC_UIP);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return uip;
 }
@@ -70,16 +79,16 @@ static inline unsigned int __get_rtc_time(struct rtc_time *time)
 	 * by the RTC when initially set to a non-zero value.
 	 */
 	spin_lock_irqsave(&rtc_lock, flags);
-	time->tm_sec = CMOS_READ(RTC_SECONDS);
-	time->tm_min = CMOS_READ(RTC_MINUTES);
-	time->tm_hour = CMOS_READ(RTC_HOURS);
-	time->tm_mday = CMOS_READ(RTC_DAY_OF_MONTH);
-	time->tm_mon = CMOS_READ(RTC_MONTH);
-	time->tm_year = CMOS_READ(RTC_YEAR);
+	time->tm_sec = do_cmos_read(RTC_SECONDS);
+	time->tm_min = do_cmos_read(RTC_MINUTES);
+	time->tm_hour = do_cmos_read(RTC_HOURS);
+	time->tm_mday = do_cmos_read(RTC_DAY_OF_MONTH);
+	time->tm_mon = do_cmos_read(RTC_MONTH);
+	time->tm_year = do_cmos_read(RTC_YEAR);
 #ifdef CONFIG_MACH_DECSTATION
-	real_year = CMOS_READ(RTC_DEC_YEAR);
+	real_year = do_cmos_read(RTC_DEC_YEAR);
 #endif
-	ctrl = CMOS_READ(RTC_CONTROL);
+	ctrl = do_cmos_read(RTC_CONTROL);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
@@ -161,7 +170,7 @@ static inline int __set_rtc_time(struct rtc_time *time)
 	if (yrs >= 100)
 		yrs -= 100;
 
-	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY)
+	if (!(do_cmos_read(RTC_CONTROL) & RTC_DM_BINARY)
 	    || RTC_ALWAYS_BCD) {
 		sec = bin2bcd(sec);
 		min = bin2bcd(min);
@@ -171,23 +180,23 @@ static inline int __set_rtc_time(struct rtc_time *time)
 		yrs = bin2bcd(yrs);
 	}
 
-	save_control = CMOS_READ(RTC_CONTROL);
-	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
-	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
-	CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
+	save_control = do_cmos_read(RTC_CONTROL);
+	do_cmos_write((save_control|RTC_SET), RTC_CONTROL);
+	save_freq_select = do_cmos_read(RTC_FREQ_SELECT);
+	do_cmos_write((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
 
 #ifdef CONFIG_MACH_DECSTATION
-	CMOS_WRITE(real_yrs, RTC_DEC_YEAR);
+	do_cmos_write(real_yrs, RTC_DEC_YEAR);
 #endif
-	CMOS_WRITE(yrs, RTC_YEAR);
-	CMOS_WRITE(mon, RTC_MONTH);
-	CMOS_WRITE(day, RTC_DAY_OF_MONTH);
-	CMOS_WRITE(hrs, RTC_HOURS);
-	CMOS_WRITE(min, RTC_MINUTES);
-	CMOS_WRITE(sec, RTC_SECONDS);
-
-	CMOS_WRITE(save_control, RTC_CONTROL);
-	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
+	do_cmos_write(yrs, RTC_YEAR);
+	do_cmos_write(mon, RTC_MONTH);
+	do_cmos_write(day, RTC_DAY_OF_MONTH);
+	do_cmos_write(hrs, RTC_HOURS);
+	do_cmos_write(min, RTC_MINUTES);
+	do_cmos_write(sec, RTC_SECONDS);
+
+	do_cmos_write(save_control, RTC_CONTROL);
+	do_cmos_write(save_freq_select, RTC_FREQ_SELECT);
 
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-- 
1.8.3.4

