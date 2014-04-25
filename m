Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaDYJgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:36:00 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24930 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752398AbaDYJbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:31:24 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 2/7] rtc-cmos: abstract locking primitives
Date: Fri, 25 Apr 2014 10:31:10 +0100
Message-Id: <1398418275-9671-3-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
References: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to allow some architecture not to provide
the dreaded rtc_lock, define a couple of wrappers for taking/releasing
the lock.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/rtc/rtc-cmos.c    | 55 ++++++++++++++++++++++++++++-------------------
 include/asm-generic/rtc.h | 27 +++++++++++++++++------
 2 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index ae895e8..be2dd17 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -209,6 +209,7 @@ static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	rtc_control;
+	unsigned long flags;
 
 	if (!is_valid_irq(cmos->irq))
 		return -EIO;
@@ -220,7 +221,7 @@ static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	t->time.tm_mday = -1;
 	t->time.tm_mon = -1;
 
-	spin_lock_irq(&rtc_lock);
+	flags = rtc_cmos_lock();
 	t->time.tm_sec = do_cmos_read(RTC_SECONDS_ALARM);
 	t->time.tm_min = do_cmos_read(RTC_MINUTES_ALARM);
 	t->time.tm_hour = do_cmos_read(RTC_HOURS_ALARM);
@@ -239,7 +240,7 @@ static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	}
 
 	rtc_control = do_cmos_read(RTC_CONTROL);
-	spin_unlock_irq(&rtc_lock);
+	rtc_cmos_unlock(flags);
 
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		if (((unsigned)t->time.tm_sec) < 0x60)
@@ -327,6 +328,7 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char mon, mday, hrs, min, sec, rtc_control;
+	unsigned long flags;
 
 	if (!is_valid_irq(cmos->irq))
 		return -EIO;
@@ -347,7 +349,7 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 		sec = (sec < 60) ? bin2bcd(sec) : 0xff;
 	}
 
-	spin_lock_irq(&rtc_lock);
+	flags = rtc_cmos_lock();
 
 	/* next rtc irq must not be from previous alarm setting */
 	cmos_irq_disable(cmos, RTC_AIE);
@@ -372,7 +374,7 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (t->enabled)
 		cmos_irq_enable(cmos, RTC_AIE);
 
-	spin_unlock_irq(&rtc_lock);
+	rtc_cmos_unlock(flags);
 
 	return 0;
 }
@@ -433,14 +435,14 @@ static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	if (alarm_disable_quirk)
 		return 0;
 
-	spin_lock_irqsave(&rtc_lock, flags);
+	flags = rtc_cmos_lock();
 
 	if (enabled)
 		cmos_irq_enable(cmos, RTC_AIE);
 	else
 		cmos_irq_disable(cmos, RTC_AIE);
 
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	rtc_cmos_unlock(flags);
 	return 0;
 }
 
@@ -450,11 +452,12 @@ static int cmos_procfs(struct device *dev, struct seq_file *seq)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	rtc_control, valid;
+	unsigned long flags;
 
-	spin_lock_irq(&rtc_lock);
+	flags = rtc_cmos_lock();
 	rtc_control = do_cmos_read(RTC_CONTROL);
 	valid = do_cmos_read(RTC_VALID);
-	spin_unlock_irq(&rtc_lock);
+	rtc_cmos_unlock(flags);
 
 	/* NOTE:  at least ICH6 reports battery status using a different
 	 * (non-RTC) bit; and SQWE is ignored on many current systems.
@@ -507,6 +510,7 @@ cmos_nvram_read(struct file *filp, struct kobject *kobj,
 		char *buf, loff_t off, size_t count)
 {
 	int	retval;
+	unsigned long flags;
 
 	if (unlikely(off >= attr->size))
 		return 0;
@@ -516,7 +520,7 @@ cmos_nvram_read(struct file *filp, struct kobject *kobj,
 		count = attr->size - off;
 
 	off += NVRAM_OFFSET;
-	spin_lock_irq(&rtc_lock);
+	flags = rtc_cmos_lock();
 	for (retval = 0; count; count--, off++, retval++) {
 		if (off < 128)
 			*buf++ = do_cmos_read(off);
@@ -525,7 +529,7 @@ cmos_nvram_read(struct file *filp, struct kobject *kobj,
 		else
 			break;
 	}
-	spin_unlock_irq(&rtc_lock);
+	rtc_cmos_unlock(flags);
 
 	return retval;
 }
@@ -537,6 +541,7 @@ cmos_nvram_write(struct file *filp, struct kobject *kobj,
 {
 	struct cmos_rtc	*cmos;
 	int		retval;
+	unsigned long flags;
 
 	cmos = dev_get_drvdata(container_of(kobj, struct device, kobj));
 	if (unlikely(off >= attr->size))
@@ -552,7 +557,7 @@ cmos_nvram_write(struct file *filp, struct kobject *kobj,
 	 * NVRAM to update, updating checksums is also part of its job.
 	 */
 	off += NVRAM_OFFSET;
-	spin_lock_irq(&rtc_lock);
+	flags = rtc_cmos_lock();
 	for (retval = 0; count; count--, off++, retval++) {
 		/* don't trash RTC registers */
 		if (off == cmos->day_alrm
@@ -566,7 +571,7 @@ cmos_nvram_write(struct file *filp, struct kobject *kobj,
 		else
 			break;
 	}
-	spin_unlock_irq(&rtc_lock);
+	rtc_cmos_unlock(flags);
 
 	return retval;
 }
@@ -590,8 +595,9 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 {
 	u8		irqstat;
 	u8		rtc_control;
+	unsigned long	flags;
 
-	spin_lock(&rtc_lock);
+	flags = rtc_cmos_lock();
 
 	/* When the HPET interrupt handler calls us, the interrupt
 	 * status is passed as arg1 instead of the irq number.  But
@@ -624,7 +630,7 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 		hpet_mask_rtc_irq_bit(RTC_AIE);
 		do_cmos_read(RTC_INTR_FLAGS);
 	}
-	spin_unlock(&rtc_lock);
+	rtc_cmos_unlock(flags);
 
 	if (is_intr(irqstat)) {
 		rtc_update_irq(p, 1, irqstat);
@@ -647,6 +653,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	int				retval = 0;
 	unsigned char			rtc_control;
 	unsigned			address_space;
+	unsigned long			flags;
 
 	/* there can be only one ... */
 	if (cmos_rtc.dev)
@@ -724,7 +731,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 
 	rename_region(ports, dev_name(&cmos_rtc.rtc->dev));
 
-	spin_lock_irq(&rtc_lock);
+	flags = rtc_cmos_lock();
 
 	/* force periodic irq to CMOS reset default of 1024Hz;
 	 *
@@ -741,7 +748,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 
 	rtc_control = do_cmos_read(RTC_CONTROL);
 
-	spin_unlock_irq(&rtc_lock);
+	rtc_cmos_unlock(flags);
 
 	/* FIXME:
 	 * <asm-generic/rtc.h> doesn't know 12-hour mode either.
@@ -808,9 +815,11 @@ cleanup0:
 
 static void cmos_do_shutdown(void)
 {
-	spin_lock_irq(&rtc_lock);
+	unsigned long flags;
+
+	flags = rtc_cmos_lock();
 	cmos_irq_disable(&cmos_rtc, RTC_IRQMASK);
-	spin_unlock_irq(&rtc_lock);
+	rtc_cmos_unlock(flags);
 }
 
 static void __exit cmos_do_remove(struct device *dev)
@@ -843,9 +852,10 @@ static int cmos_suspend(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	tmp;
+	unsigned long flags;
 
 	/* only the alarm might be a wakeup event source */
-	spin_lock_irq(&rtc_lock);
+	flags = rtc_cmos_lock();
 	cmos->suspend_ctrl = tmp = do_cmos_read(RTC_CONTROL);
 	if (tmp & (RTC_PIE|RTC_AIE|RTC_UIE)) {
 		unsigned char	mask;
@@ -860,7 +870,7 @@ static int cmos_suspend(struct device *dev)
 
 		cmos_checkintr(cmos, tmp);
 	}
-	spin_unlock_irq(&rtc_lock);
+	rtc_cmos_unlock(flags);
 
 	if (tmp & RTC_AIE) {
 		cmos->enabled_wake = 1;
@@ -892,6 +902,7 @@ static int cmos_resume(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char tmp;
+	unsigned long flags;
 
 	if (cmos->enabled_wake) {
 		if (cmos->wake_off)
@@ -901,7 +912,7 @@ static int cmos_resume(struct device *dev)
 		cmos->enabled_wake = 0;
 	}
 
-	spin_lock_irq(&rtc_lock);
+	flags = rtc_cmos_lock();
 	tmp = cmos->suspend_ctrl;
 	cmos->suspend_ctrl = 0;
 	/* re-enable any irqs previously active */
@@ -928,7 +939,7 @@ static int cmos_resume(struct device *dev)
 			hpet_mask_rtc_irq_bit(RTC_AIE);
 		} while (mask & RTC_AIE);
 	}
-	spin_unlock_irq(&rtc_lock);
+	rtc_cmos_unlock(flags);
 
 	dev_dbg(dev, "resume, ctrl %02x\n", tmp);
 
diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index 313438a..1ad3e78 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -37,6 +37,19 @@ static inline void do_cmos_write(u8 val, u8 reg)
 {
 	CMOS_WRITE(val, reg);
 }
+
+static inline unsigned long rtc_cmos_lock(void)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&rtc_lock, flags);
+	return flags;
+}
+
+static inline void rtc_cmos_unlock(unsigned long flags)
+{
+	spin_unlock_irqrestore(&rtc_lock, flags);
+}
+
 /*
  * Returns true if a clock update is in progress
  */
@@ -45,9 +58,9 @@ static inline unsigned char rtc_is_updating(void)
 	unsigned char uip;
 	unsigned long flags;
 
-	spin_lock_irqsave(&rtc_lock, flags);
+	flags = rtc_cmos_lock();
 	uip = (do_cmos_read(RTC_FREQ_SELECT) & RTC_UIP);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	rtc_cmos_unlock(flags);
 	return uip;
 }
 
@@ -78,7 +91,7 @@ static inline unsigned int __get_rtc_time(struct rtc_time *time)
 	 * RTC has RTC_DAY_OF_WEEK, we ignore it, as it is only updated
 	 * by the RTC when initially set to a non-zero value.
 	 */
-	spin_lock_irqsave(&rtc_lock, flags);
+	flags = rtc_cmos_lock();
 	time->tm_sec = do_cmos_read(RTC_SECONDS);
 	time->tm_min = do_cmos_read(RTC_MINUTES);
 	time->tm_hour = do_cmos_read(RTC_HOURS);
@@ -89,7 +102,7 @@ static inline unsigned int __get_rtc_time(struct rtc_time *time)
 	real_year = do_cmos_read(RTC_DEC_YEAR);
 #endif
 	ctrl = do_cmos_read(RTC_CONTROL);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	rtc_cmos_unlock(flags);
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
 	{
@@ -142,7 +155,7 @@ static inline int __set_rtc_time(struct rtc_time *time)
 	if (yrs > 255)	/* They are unsigned */
 		return -EINVAL;
 
-	spin_lock_irqsave(&rtc_lock, flags);
+	flags = rtc_cmos_lock();
 #ifdef CONFIG_MACH_DECSTATION
 	real_yrs = yrs;
 	leap_yr = ((!((yrs + 1900) % 4) && ((yrs + 1900) % 100)) ||
@@ -163,7 +176,7 @@ static inline int __set_rtc_time(struct rtc_time *time)
 	 * whether the chip is in binary mode or not.
 	 */
 	if (yrs > 169) {
-		spin_unlock_irqrestore(&rtc_lock, flags);
+		rtc_cmos_unlock(flags);
 		return -EINVAL;
 	}
 
@@ -198,7 +211,7 @@ static inline int __set_rtc_time(struct rtc_time *time)
 	do_cmos_write(save_control, RTC_CONTROL);
 	do_cmos_write(save_freq_select, RTC_FREQ_SELECT);
 
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	rtc_cmos_unlock(flags);
 
 	return 0;
 }
-- 
1.8.3.4

