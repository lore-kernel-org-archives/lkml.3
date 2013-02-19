Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3BSOrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:47:12 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54815 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab3BSOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:47:10 -0500
Date: Tue, 19 Feb 2013 15:47:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v3.9
Message-ID: <20130219144705.GA13331@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

   HEAD: 36dfbbf136db0d645bacfd42ce7d9d6928ea532d timers/x86/hpet: Use HPET_COUNTER to specify the hpet counter in vread_hpet()


Main changes:

 * ntp: Add CONFIG_RTC_SYSTOHC: a generic RTC driver facility
   complementing the existing CONFIG_RTC_HCTOSYS, which uses NTP
   to keep the hardware clock updated.

 * posix-timers: Fix clock_adjtime to always return timex data 
   on success. This is changing the ABI, but no breakage was 
   expected and found - caution is warranted nevertheless.

 * platform persistent clock improvements/cleanups.

 * clockevents: refactor timer broadcast handling to be more 
   generic and less duplicated with matching architecture code. 
   (mostly ARM motivated.)

 * various fixes and cleanups

 Thanks,

	Ingo

------------------>
Bernd Faust (1):
      Round the calculated scale factor in set_cyc2ns_scale()

Bjorn Helgaas (1):
      x86/time/rtc: Don't print extended CMOS year when reading RTC

Feng Tang (3):
      timekeeping: Add persistent_clock_exist flag
      rtc: Skip the suspend/resume handling if persistent clock exist
      timekeeping: Add CONFIG_HAS_PERSISTENT_CLOCK option

Jason Gunthorpe (1):
      NTP: Add a CONFIG_RTC_SYSTOHC configuration

John Stultz (3):
      MAINTAINERS: Update John Stultz's email
      x86: Select HAS_PERSISTENT_CLOCK on x86
      timekeeping: Switch HAS_PERSISTENT_CLOCK to ALWAYS_USE_PERSISTENT_CLOCK

Kees Cook (1):
      time: create __getnstimeofday for WARNless calls

Leonid Shatz (1):
      hrtimer: Prevent hrtimer_enqueue_reprogram race

Mark Rutland (3):
      clockevents: Add generic timer broadcast receiver
      clockevents: Add generic timer broadcast function
      clockevents: Fix generic broadcast for FEAT_C3STOP

Miroslav Lichvar (1):
      posix-timers: Fix clock_adjtime to always return timex data on success

Prarit Bhargava (1):
      time, Fix setting of hardware clock in NTP code

Satoru Takeuchi (1):
      timers/x86/hpet: Use HPET_COUNTER to specify the hpet counter in vread_hpet()

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak


 MAINTAINERS                    |  2 +-
 arch/powerpc/kernel/time.c     |  2 +-
 arch/x86/Kconfig               |  1 +
 arch/x86/kernel/rtc.c          |  1 -
 arch/x86/kernel/tsc.c          |  3 ++-
 arch/x86/vdso/vclock_gettime.c |  2 +-
 drivers/rtc/Kconfig            | 12 ++++++++++-
 drivers/rtc/Makefile           |  1 +
 drivers/rtc/class.c            |  7 +++++++
 drivers/rtc/systohc.c          | 44 +++++++++++++++++++++++++++++++++++++++++
 fs/pstore/ram.c                | 10 +++++++---
 include/linux/clockchips.h     |  9 +++++++++
 include/linux/rtc.h            |  1 +
 include/linux/time.h           | 13 ++++++++++++
 kernel/hrtimer.c               | 36 ++++++++++++++++-----------------
 kernel/posix-cpu-timers.c      | 23 +++++++++++++++++++--
 kernel/posix-timers.c          |  2 +-
 kernel/time.c                  |  8 ++++++++
 kernel/time/Kconfig            |  9 +++++++++
 kernel/time/ntp.c              | 22 ++++++++++++++++-----
 kernel/time/tick-broadcast.c   | 38 ++++++++++++++++++++++++++++++++++-
 kernel/time/timekeeping.c      | 45 ++++++++++++++++++++++++++++++++----------
 22 files changed, 245 insertions(+), 46 deletions(-)
 create mode 100644 drivers/rtc/systohc.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 212c255..f5bda78 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6598,7 +6598,7 @@ F:	drivers/dma/dw_dmac_regs.h
 F:	drivers/dma/dw_dmac.c
 
 TIMEKEEPING, NTP
-M:	John Stultz <johnstul@us.ibm.com>
+M:	John Stultz <john.stultz@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 127361e..aaba2e0 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -668,7 +668,7 @@ int update_persistent_clock(struct timespec now)
 	struct rtc_time tm;
 
 	if (!ppc_md.set_rtc_time)
-		return 0;
+		return -ENODEV;
 
 	to_tm(now.tv_sec + 1 + timezone_offset, &tm);
 	tm.tm_year -= 1900;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 225543b..97b023f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -106,6 +106,7 @@ config X86
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
 	select GENERIC_TIME_VSYSCALL if X86_64
 	select KTIME_SCALAR if X86_32
+	select ALWAYS_USE_PERSISTENT_CLOCK
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 801602b..2e8f3d3 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -149,7 +149,6 @@ unsigned long mach_get_cmos_time(void)
 	if (century) {
 		century = bcd2bin(century);
 		year += century * 100;
-		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
 	} else
 		year += CMOS_YEARS_OFFS;
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 06ccb50..4b9ea10 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -623,7 +623,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	ns_now = __cycles_2_ns(tsc_now);
 
 	if (cpu_khz) {
-		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+		*scale = ((NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR) +
+				cpu_khz / 2) / cpu_khz;
 		*offset = ns_now - mult_frac(tsc_now, *scale,
 					     (1UL << CYC2NS_SCALE_FACTOR));
 	}
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 205ad32..c74436e 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -60,7 +60,7 @@ notrace static cycle_t vread_tsc(void)
 
 static notrace cycle_t vread_hpet(void)
 {
-	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
+	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
 }
 
 #ifdef CONFIG_PARAVIRT_CLOCK
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 923a9da..5e44eaa 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -20,14 +20,24 @@ if RTC_CLASS
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	default y
+	depends on !ALWAYS_USE_PERSISTENT_CLOCK
 	help
 	  If you say yes here, the system time (wall clock) will be set using
 	  the value read from a specified RTC device. This is useful to avoid
 	  unnecessary fsck runs at boot time, and to network better.
 
+config RTC_SYSTOHC
+	bool "Set the RTC time based on NTP synchronization"
+	default y
+	depends on !ALWAYS_USE_PERSISTENT_CLOCK
+	help
+	  If you say yes here, the system time (wall clock) will be stored
+	  in the RTC specified by RTC_HCTOSYS_DEVICE approximately every 11
+	  minutes if userspace reports synchronized NTP status.
+
 config RTC_HCTOSYS_DEVICE
 	string "RTC used to set the system time"
-	depends on RTC_HCTOSYS = y
+	depends on RTC_HCTOSYS = y || RTC_SYSTOHC = y
 	default "rtc0"
 	help
 	  The RTC device that will be used to (re)initialize the system
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 4418ef3..ec2988b 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -6,6 +6,7 @@ ccflags-$(CONFIG_RTC_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_RTC_LIB)		+= rtc-lib.o
 obj-$(CONFIG_RTC_HCTOSYS)	+= hctosys.o
+obj-$(CONFIG_RTC_SYSTOHC)	+= systohc.o
 obj-$(CONFIG_RTC_CLASS)		+= rtc-core.o
 rtc-core-y			:= class.o interface.o
 
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 5143629..26388f1 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -50,6 +50,10 @@ static int rtc_suspend(struct device *dev, pm_message_t mesg)
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
 	struct timespec		delta, delta_delta;
+
+	if (has_persistent_clock())
+		return 0;
+
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
@@ -88,6 +92,9 @@ static int rtc_resume(struct device *dev)
 	struct timespec		new_system, new_rtc;
 	struct timespec		sleep_time;
 
+	if (has_persistent_clock())
+		return 0;
+
 	rtc_hctosys_ret = -ENODEV;
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
diff --git a/drivers/rtc/systohc.c b/drivers/rtc/systohc.c
new file mode 100644
index 0000000..bf3e242
--- /dev/null
+++ b/drivers/rtc/systohc.c
@@ -0,0 +1,44 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ */
+#include <linux/rtc.h>
+#include <linux/time.h>
+
+/**
+ * rtc_set_ntp_time - Save NTP synchronized time to the RTC
+ * @now: Current time of day
+ *
+ * Replacement for the NTP platform function update_persistent_clock
+ * that stores time for later retrieval by rtc_hctosys.
+ *
+ * Returns 0 on successful RTC update, -ENODEV if a RTC update is not
+ * possible at all, and various other -errno for specific temporary failure
+ * cases.
+ *
+ * If temporary failure is indicated the caller should try again 'soon'
+ */
+int rtc_set_ntp_time(struct timespec now)
+{
+	struct rtc_device *rtc;
+	struct rtc_time tm;
+	int err = -ENODEV;
+
+	if (now.tv_nsec < (NSEC_PER_SEC >> 1))
+		rtc_time_to_tm(now.tv_sec, &tm);
+	else
+		rtc_time_to_tm(now.tv_sec + 1, &tm);
+
+	rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
+	if (rtc) {
+		/* rtc_hctosys exclusively uses UTC, so we call set_time here,
+		 * not set_mmss. */
+		if (rtc->ops && (rtc->ops->set_time || rtc->ops->set_mmss))
+			err = rtc_set_time(rtc, &tm);
+		rtc_class_close(rtc);
+	}
+
+	return err;
+}
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 7003e52..288f068 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -167,12 +167,16 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
 {
 	char *hdr;
-	struct timeval timestamp;
+	struct timespec timestamp;
 	size_t len;
 
-	do_gettimeofday(&timestamp);
+	/* Report zeroed timestamp if called before timekeeping has resumed. */
+	if (__getnstimeofday(&timestamp)) {
+		timestamp.tv_sec = 0;
+		timestamp.tv_nsec = 0;
+	}
 	hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
-		(long)timestamp.tv_sec, (long)timestamp.tv_usec);
+		(long)timestamp.tv_sec, (long)(timestamp.tv_nsec / 1000));
 	WARN_ON_ONCE(!hdr);
 	len = hdr ? strlen(hdr) : 0;
 	persistent_ram_write(prz, hdr, len);
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 8a7096f..6634652 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -161,6 +161,15 @@ clockevents_calc_mult_shift(struct clock_event_device *ce, u32 freq, u32 minsec)
 extern void clockevents_suspend(void);
 extern void clockevents_resume(void);
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+#ifdef CONFIG_ARCH_HAS_TICK_BROADCAST
+extern void tick_broadcast(const struct cpumask *mask);
+#else
+#define tick_broadcast	NULL
+#endif
+extern int tick_receive_broadcast(void);
+#endif
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 9531845..11d05f9 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -138,6 +138,7 @@ extern void rtc_device_unregister(struct rtc_device *rtc);
 extern int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs);
+extern int rtc_set_ntp_time(struct timespec now);
 int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm);
 extern int rtc_read_alarm(struct rtc_device *rtc,
 			struct rtc_wkalrm *alrm);
diff --git a/include/linux/time.h b/include/linux/time.h
index 4d358e9..a3ab6a8 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -115,8 +115,20 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 	return true;
 }
 
+extern bool persistent_clock_exist;
+
+#ifdef ALWAYS_USE_PERSISTENT_CLOCK
+#define has_persistent_clock()	true
+#else
+static inline bool has_persistent_clock(void)
+{
+	return persistent_clock_exist;
+}
+#endif
+
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
+extern int persistent_clock_is_local;
 extern int update_persistent_clock(struct timespec now);
 void timekeeping_init(void);
 extern int timekeeping_suspended;
@@ -158,6 +170,7 @@ extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
 extern unsigned int alarm_setitimer(unsigned int seconds);
 extern int do_getitimer(int which, struct itimerval *value);
+extern int __getnstimeofday(struct timespec *tv);
 extern void getnstimeofday(struct timespec *tv);
 extern void getrawmonotonic(struct timespec *ts);
 extern void getnstime_raw_and_real(struct timespec *ts_raw,
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..cdd5607 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -640,21 +640,9 @@ static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
  * and expiry check is done in the hrtimer_interrupt or in the softirq.
  */
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base,
-					    int wakeup)
+					    struct hrtimer_clock_base *base)
 {
-	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
-		if (wakeup) {
-			raw_spin_unlock(&base->cpu_base->lock);
-			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-			raw_spin_lock(&base->cpu_base->lock);
-		} else
-			__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-
-		return 1;
-	}
-
-	return 0;
+	return base->cpu_base->hres_active && hrtimer_reprogram(timer, base);
 }
 
 static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
@@ -735,8 +723,7 @@ static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base,
-					    int wakeup)
+					    struct hrtimer_clock_base *base)
 {
 	return 0;
 }
@@ -995,8 +982,21 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases))
-		hrtimer_enqueue_reprogram(timer, new_base, wakeup);
+	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
+		&& hrtimer_enqueue_reprogram(timer, new_base)) {
+		if (wakeup) {
+			/*
+			 * We need to drop cpu_base->lock to avoid a
+			 * lock ordering issue vs. rq->lock.
+			 */
+			raw_spin_unlock(&new_base->cpu_base->lock);
+			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+			local_irq_restore(flags);
+			return ret;
+		} else {
+			__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+		}
+	}
 
 	unlock_hrtimer_base(timer, &flags);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a278cad..942ca27 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1401,8 +1401,10 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		while (!signal_pending(current)) {
 			if (timer.it.cpu.expires.sched == 0) {
 				/*
-				 * Our timer fired and was reset.
+				 * Our timer fired and was reset, below
+				 * deletion can not fail.
 				 */
+				posix_cpu_timer_del(&timer);
 				spin_unlock_irq(&timer.it_lock);
 				return 0;
 			}
@@ -1420,9 +1422,26 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		 * We were interrupted by a signal.
 		 */
 		sample_to_timespec(which_clock, timer.it.cpu.expires, rqtp);
-		posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		error = posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		if (!error) {
+			/*
+			 * Timer is now unarmed, deletion can not fail.
+			 */
+			posix_cpu_timer_del(&timer);
+		}
 		spin_unlock_irq(&timer.it_lock);
 
+		while (error == TIMER_RETRY) {
+			/*
+			 * We need to handle case when timer was or is in the
+			 * middle of firing. In other cases we already freed
+			 * resources.
+			 */
+			spin_lock_irq(&timer.it_lock);
+			error = posix_cpu_timer_del(&timer);
+			spin_unlock_irq(&timer.it_lock);
+		}
+
 		if ((it->it_value.tv_sec | it->it_value.tv_nsec) == 0) {
 			/*
 			 * It actually did fire already.
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 69185ae..10349d5 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -997,7 +997,7 @@ SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
 
 	err = kc->clock_adj(which_clock, &ktx);
 
-	if (!err && copy_to_user(utx, &ktx, sizeof(ktx)))
+	if (err >= 0 && copy_to_user(utx, &ktx, sizeof(ktx)))
 		return -EFAULT;
 
 	return err;
diff --git a/kernel/time.c b/kernel/time.c
index d226c6a..c2a27dd 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -115,6 +115,12 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
 }
 
 /*
+ * Indicates if there is an offset between the system clock and the hardware
+ * clock/persistent clock/rtc.
+ */
+int persistent_clock_is_local;
+
+/*
  * Adjust the time obtained from the CMOS to be UTC time instead of
  * local time.
  *
@@ -135,6 +141,8 @@ static inline void warp_clock(void)
 	struct timespec adjust;
 
 	adjust = current_kernel_time();
+	if (sys_tz.tz_minuteswest != 0)
+		persistent_clock_is_local = 1;
 	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
 	do_settimeofday(&adjust);
 }
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 8601f0d..24510d8 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -12,6 +12,11 @@ config CLOCKSOURCE_WATCHDOG
 config ARCH_CLOCKSOURCE_DATA
 	bool
 
+# Platforms has a persistent clock
+config ALWAYS_USE_PERSISTENT_CLOCK
+	bool
+	default n
+
 # Timekeeping vsyscall support
 config GENERIC_TIME_VSYSCALL
 	bool
@@ -38,6 +43,10 @@ config GENERIC_CLOCKEVENTS_BUILD
 	default y
 	depends on GENERIC_CLOCKEVENTS
 
+# Architecture can handle broadcast in a driver-agnostic way
+config ARCH_HAS_TICK_BROADCAST
+	bool
+
 # Clockevents broadcasting infrastructure
 config GENERIC_CLOCKEVENTS_BROADCAST
 	bool
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 24174b4..b10a42b 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -15,6 +15,7 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/rtc.h>
 
 #include "tick-internal.h"
 
@@ -483,8 +484,7 @@ out:
 	return leap;
 }
 
-#ifdef CONFIG_GENERIC_CMOS_UPDATE
-
+#if defined(CONFIG_GENERIC_CMOS_UPDATE) || defined(CONFIG_RTC_SYSTOHC)
 static void sync_cmos_clock(struct work_struct *work);
 
 static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
@@ -510,14 +510,26 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
-		fail = update_persistent_clock(now);
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
+		struct timespec adjust = now;
+
+		fail = -ENODEV;
+		if (persistent_clock_is_local)
+			adjust.tv_sec -= (sys_tz.tz_minuteswest * 60);
+#ifdef CONFIG_GENERIC_CMOS_UPDATE
+		fail = update_persistent_clock(adjust);
+#endif
+#ifdef CONFIG_RTC_SYSTOHC
+		if (fail == -ENODEV)
+			fail = rtc_set_ntp_time(adjust);
+#endif
+	}
 
 	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
 	if (next.tv_nsec <= 0)
 		next.tv_nsec += NSEC_PER_SEC;
 
-	if (!fail)
+	if (!fail || fail == -ENODEV)
 		next.tv_sec = 659;
 	else
 		next.tv_sec = 0;
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..2fb8cb8 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/smp.h>
 
 #include "tick-internal.h"
 
@@ -86,6 +87,22 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
 	return (dev && tick_broadcast_device.evtdev == dev);
 }
 
+static void err_broadcast(const struct cpumask *mask)
+{
+	pr_crit_once("Failed to broadcast timer tick. Some CPUs may be unresponsive.\n");
+}
+
+static void tick_device_setup_broadcast_func(struct clock_event_device *dev)
+{
+	if (!dev->broadcast)
+		dev->broadcast = tick_broadcast;
+	if (!dev->broadcast) {
+		pr_warn_once("%s depends on broadcast, but no broadcast function available\n",
+			     dev->name);
+		dev->broadcast = err_broadcast;
+	}
+}
+
 /*
  * Check, if the device is disfunctional and a place holder, which
  * needs to be handled by the broadcast device.
@@ -105,6 +122,7 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 	 */
 	if (!tick_device_is_functional(dev)) {
 		dev->event_handler = tick_handle_periodic;
+		tick_device_setup_broadcast_func(dev);
 		cpumask_set_cpu(cpu, tick_get_broadcast_mask());
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
@@ -116,15 +134,33 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 		 */
 		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
 			int cpu = smp_processor_id();
-
 			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
 			tick_broadcast_clear_oneshot(cpu);
+		} else {
+			tick_device_setup_broadcast_func(dev);
 		}
 	}
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 	return ret;
 }
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+int tick_receive_broadcast(void)
+{
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
+	struct clock_event_device *evt = td->evtdev;
+
+	if (!evt)
+		return -ENODEV;
+
+	if (!evt->event_handler)
+		return -EINVAL;
+
+	evt->event_handler(evt);
+	return 0;
+}
+#endif
+
 /*
  * Broadcast the event to the cpus, which are set in the mask (mangled).
  */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index cbc6acb..1e35515 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -29,6 +29,9 @@ static struct timekeeper timekeeper;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
+/* Flag for if there is a persistent clock on this platform */
+bool __read_mostly persistent_clock_exist = false;
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -264,19 +267,18 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 }
 
 /**
- * getnstimeofday - Returns the time of day in a timespec
+ * __getnstimeofday - Returns the time of day in a timespec.
  * @ts:		pointer to the timespec to be set
  *
- * Returns the time of day in a timespec.
+ * Updates the time of day in the timespec.
+ * Returns 0 on success, or -ve when suspended (timespec will be undefined).
  */
-void getnstimeofday(struct timespec *ts)
+int __getnstimeofday(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long seq;
 	s64 nsecs = 0;
 
-	WARN_ON(timekeeping_suspended);
-
 	do {
 		seq = read_seqbegin(&tk->lock);
 
@@ -287,6 +289,26 @@ void getnstimeofday(struct timespec *ts)
 
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
+
+	/*
+	 * Do not bail out early, in case there were callers still using
+	 * the value, even in the face of the WARN_ON.
+	 */
+	if (unlikely(timekeeping_suspended))
+		return -EAGAIN;
+	return 0;
+}
+EXPORT_SYMBOL(__getnstimeofday);
+
+/**
+ * getnstimeofday - Returns the time of day in a timespec.
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec (WARN if suspended).
+ */
+void getnstimeofday(struct timespec *ts)
+{
+	WARN_ON(__getnstimeofday(ts));
 }
 EXPORT_SYMBOL(getnstimeofday);
 
@@ -640,12 +662,14 @@ void __init timekeeping_init(void)
 	struct timespec now, boot, tmp;
 
 	read_persistent_clock(&now);
+
 	if (!timespec_valid_strict(&now)) {
 		pr_warn("WARNING: Persistent clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		now.tv_sec = 0;
 		now.tv_nsec = 0;
-	}
+	} else if (now.tv_sec || now.tv_nsec)
+		persistent_clock_exist = true;
 
 	read_boot_clock(&boot);
 	if (!timespec_valid_strict(&boot)) {
@@ -718,11 +742,12 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
-	struct timespec ts;
 
-	/* Make sure we don't set the clock twice */
-	read_persistent_clock(&ts);
-	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
+	/*
+	 * Make sure we don't set the clock twice, as timekeeping_resume()
+	 * already did it
+	 */
+	if (has_persistent_clock())
 		return;
 
 	write_seqlock_irqsave(&tk->lock, flags);
