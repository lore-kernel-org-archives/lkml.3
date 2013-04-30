Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab3D3Hna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:43:30 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:56412 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017Ab3D3Hn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:43:28 -0400
Date: Tue, 30 Apr 2013 09:43:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v3.10
Message-ID: <20130430074322.GA20110@gmail.com>
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

   HEAD: 6f7a05d7018de222e40ca003721037a530979974 clockevents: Set dummy handler on CPU_DEAD shutdown

The main changes in this cycle's merge are:

 - Implement shadow timekeeper to shorten in kernel reader side blocking, 
   by Thomas Gleixner.

 - Posix timers enhancements by Pavel Emelyanov:

     - allocate timer ID per process, so that exact timer ID allocations 
       can be re-created be checkpoint/restore code.

     - debuggability and tooling (/proc/PID/timers, etc.) improvements.

 - suspend/resume enhancements by Feng Tang: on certain new Intel Atom 
   processors (Penwell and Cloverview), there is a feature that the TSC 
   won't stop in S3 state, so the TSC value won't be reset to 0 after
   resume. This can be taken advantage of by the generic via the
   CLOCK_SOURCE_SUSPEND_NONSTOP flag: instead of using the RTC to 
   recover/approximate sleep time, the main (and precise) clocksource can
   be used.

 - Fix /proc/timer_list for 4096 CPUs by Nathan Zimmer: on so many CPUs 
   the file goes beyond 4MB of size and thus the current simplistic 
   seqfile approach fails. Convert /proc/timer_list to a proper seq_file 
   with its own iterator.

 - Cleanups and refactorings of the core timekeeping code by John Stultz.

 - International Atomic Clock time is managed by the NTP code internally 
   currently but not exposed externally. Separate the TAI code out and add
   CLOCK_TAI support and TAI support to the hrtimer and posix-timer code,
   by John Stultz.

 - Add deep idle support enhacement to the broadcast clockevents core 
   timer code, by Daniel Lezcano: add an opt-in CLOCK_EVT_FEAT_DYNIRQ 
   clockevents feature (which will be utilized by future clockevents 
   driver updates), which allows the use of IRQ affinities to avoid 
   spurious wakeups of idle CPUs - the right CPU with an expiring timer 
   will be woken.

 - Add new ARM bcm281xx clocksource driver, by Christian Daudt

 - ... various other fixes and cleanups

 Thanks,

	Ingo

------------------>
Christian Daudt (1):
      ARM: bcm281xx: Add timer driver (driver portion)

Daniel Lezcano (2):
      tick: Pass broadcast device to tick_broadcast_set_event()
      tick: Dynamically set broadcast irq affinity

David Daney (1):
      hrtimer/trivial: Fix comment text in hrtimer.c

David Engraf (1):
      hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

Dong Zhu (1):
      timekeeping: Avoid adjust kernel time once hwclock kept in UTC time

Feng Tang (4):
      x86: Add cpu capability flag X86_FEATURE_NONSTOP_TSC_S3
      clocksource: Add new feature flag CLOCK_SOURCE_SUSPEND_NONSTOP
      x86: tsc: Add support for new S3_NONSTOP feature
      timekeeping: utilize the suspend-nonstop clocksource to count suspended time

Fengguang Wu (1):
      timekeeping: __timekeeping_set_tai_offset can be static

John Stultz (13):
      timekeeping: Use inject_offset in warp_clock
      timekeeping: Move TAI managment into timekeeping core from ntp
      timekeeping: Add CLOCK_TAI clockid
      hrtimer: Add hrtimer support for CLOCK_TAI
      ntp: Split out timex validation from do_adjtimex
      ntp: Move do_adjtimex() and hardpps() functions to timekeeping.c
      ntp: Move timex validation to timekeeping do_adjtimex call.
      ntp: Rework do_adjtimex to take timespec and tai arguments
      timekeeping: Move ADJ_SETOFFSET to top level do_adjtimex()
      timekeeping: Hold timekeepering locks in do_adjtimex and hardpps
      timekeeping: Simplify tai updating from do_adjtimex
      ntp: Remove ntp_lock, using the timekeeping locks to protect ntp state
      timekeeping: Make sure to notify hrtimers when TAI offset changes

Nathan Zimmer (2):
      timer_list: Split timer_list_show_tickdevices
      timer_list: Convert timer list to be a proper seq_file

Pavel Emelyanov (3):
      posix timers: Allocate timer id per process (v2)
      posix-timers: Introduce /proc/PID/timers file
      posix-timers: Show sigevent info in proc file

Prarit Bhargava (2):
      x86: Do full rtc synchronization with ntp
      hrtimer: Add expiry time overflow check in hrtimer_interrupt

Rado Vrbovsky (1):
      tick: Change log level of NOHZ: local_softirq_pending message

Stephen Boyd (1):
      clockevents: Switch into oneshot mode even if broadcast registered late

Thomas Gleixner (19):
      tick: Call tick_init late
      tick: Convert broadcast cpu bitmaps to cpumask_var_t
      tick: Avoid programming the local cpu timer if broadcast pending
      tick: Handle broadcast wakeup of multiple cpus
      tick: Provide a check for a forced broadcast pending
      arm: Use tick broadcast expired check
      x86: Use tick broadcast expired check
      clockevents: Add missing tick_check_broadcast_expired() for CLOCKEVENTS=n
      timekeeping: Calc stuff once
      timekeeping: Make jiffies_lock internal
      timekeeping: Move lock out of timekeeper struct
      timekeeping: Split timekeeper_lock into lock and seqcount
      timekeeping: Store cycle_last value in timekeeper struct as well
      timekeeping: Delay update of clock->cycle_last
      timekeeping: Implement a shadow timekeeper
      timekeeping: Shorten seq_count region
      posix-timers: Remove unused variable
      timekeeping: Update tk->cycle_last in resume
      clockevents: Set dummy handler on CPU_DEAD shutdown


 arch/arm/kernel/process.c            |  11 +-
 arch/arm/mach-bcm/Kconfig            |   1 +
 arch/arm/mach-bcm/board_bcm.c        |   7 +-
 arch/x86/Kconfig                     |   1 +
 arch/x86/include/asm/cpufeature.h    |   1 +
 arch/x86/kernel/cpu/intel.c          |  12 ++
 arch/x86/kernel/process.c            |  12 ++
 arch/x86/kernel/rtc.c                |  69 ++----
 arch/x86/kernel/tsc.c                |   6 +-
 arch/x86/platform/efi/efi.c          |  24 ++-
 arch/x86/platform/mrst/vrtc.c        |  44 ++--
 drivers/clocksource/Makefile         |   1 +
 drivers/clocksource/bcm_kona_timer.c | 211 +++++++++++++++++++
 fs/proc/base.c                       | 100 +++++++++
 include/linux/clockchips.h           |  12 ++
 include/linux/clocksource.h          |   1 +
 include/linux/hrtimer.h              |   5 +-
 include/linux/jiffies.h              |   1 -
 include/linux/posix-timers.h         |   1 +
 include/linux/sched.h                |   3 +-
 include/linux/time.h                 |   3 +
 include/linux/timekeeper_internal.h  |   9 +-
 include/linux/timex.h                |   7 -
 include/uapi/linux/time.h            |   6 +-
 init/main.c                          |   2 +-
 kernel/hrtimer.c                     |  26 ++-
 kernel/posix-timers.c                | 121 +++++++----
 kernel/time.c                        |  11 +-
 kernel/time/ntp.c                    | 105 +++-------
 kernel/time/ntp_internal.h           |  12 ++
 kernel/time/tick-broadcast.c         | 239 ++++++++++++++++-----
 kernel/time/tick-common.c            |   2 +
 kernel/time/tick-internal.h          |   5 +-
 kernel/time/tick-sched.c             |   4 +-
 kernel/time/timekeeping.c            | 396 ++++++++++++++++++++++++++++-------
 kernel/time/timer_list.c             | 104 +++++++--
 36 files changed, 1190 insertions(+), 385 deletions(-)
 create mode 100644 drivers/clocksource/bcm_kona_timer.c
 create mode 100644 kernel/time/ntp_internal.h

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..db4ffd0 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -199,7 +199,16 @@ void cpu_idle(void)
 #ifdef CONFIG_PL310_ERRATA_769419
 			wmb();
 #endif
-			if (hlt_counter) {
+			/*
+			 * In poll mode we reenable interrupts and spin.
+			 *
+			 * Also if we detected in the wakeup from idle
+			 * path that the tick broadcast device expired
+			 * for us, we don't want to go deep idle as we
+			 * know that the IPI is going to arrive right
+			 * away
+			 */
+			if (hlt_counter || tick_check_broadcast_expired()) {
 				local_irq_enable();
 				cpu_relax();
 			} else if (!need_resched()) {
diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index bf02471..f112895 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -6,6 +6,7 @@ config ARCH_BCM
 	select ARM_ERRATA_764369 if SMP
 	select ARM_GIC
 	select CPU_V7
+	select CLKSRC_OF
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_TIME
 	select GPIO_BCM
diff --git a/arch/arm/mach-bcm/board_bcm.c b/arch/arm/mach-bcm/board_bcm.c
index f0f9aba..2595935 100644
--- a/arch/arm/mach-bcm/board_bcm.c
+++ b/arch/arm/mach-bcm/board_bcm.c
@@ -16,14 +16,11 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/irqchip.h>
+#include <linux/clocksource.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
 
-static void timer_init(void)
-{
-}
-
 
 static void __init board_init(void)
 {
@@ -35,7 +32,7 @@ static const char * const bcm11351_dt_compat[] = { "bcm,bcm11351", NULL, };
 
 DT_MACHINE_START(BCM11351_DT, "Broadcom Application Processor")
 	.init_irq = irqchip_init,
-	.init_time = timer_init,
+	.init_time = clocksource_of_init,
 	.init_machine = board_init,
 	.dt_compat = bcm11351_dt_compat,
 MACHINE_END
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15b5cef..9f74f52 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -120,6 +120,7 @@ config X86
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
+	select RTC_LIB
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 93fe929..a8466f2 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -100,6 +100,7 @@
 #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
 #define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU restore */
+#define X86_FEATURE_NONSTOP_TSC_S3 (3*32+30) /* TSC doesn't stop in S3 state */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1905ce9..e7ae0d8 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -96,6 +96,18 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 			sched_clock_stable = 1;
 	}
 
+	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
+	if (c->x86 == 6) {
+		switch (c->x86_model) {
+		case 0x27:	/* Penwell */
+		case 0x35:	/* Cloverview */
+			set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC_S3);
+			break;
+		default:
+			break;
+		}
+	}
+
 	/*
 	 * There is a known erratum on Pentium III and Core Solo
 	 * and Core Duo CPUs.
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14ae100..aa524da 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -336,6 +336,18 @@ void cpu_idle(void)
 			local_touch_nmi();
 			local_irq_disable();
 
+			/*
+			 * We detected in the wakeup path that the
+			 * tick broadcast device expired for us, but
+			 * we raced with the other CPU and came back
+			 * here before it was able to fire the IPI.
+			 * No point in going idle.
+			 */
+			if (tick_check_broadcast_expired()) {
+				local_irq_enable();
+				continue;
+			}
+
 			enter_idle();
 
 			/* Don't trace irqs off for idle */
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 2e8f3d3..198eb20 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -13,6 +13,7 @@
 #include <asm/x86_init.h>
 #include <asm/time.h>
 #include <asm/mrst.h>
+#include <asm/rtc.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -36,70 +37,24 @@ EXPORT_SYMBOL(rtc_lock);
  * nowtime is written into the registers of the CMOS clock, it will
  * jump to the next second precisely 500 ms later. Check the Motorola
  * MC146818A or Dallas DS12887 data sheet for details.
- *
- * BUG: This routine does not handle hour overflow properly; it just
- *      sets the minutes. Usually you'll only notice that after reboot!
  */
 int mach_set_rtc_mmss(unsigned long nowtime)
 {
-	int real_seconds, real_minutes, cmos_minutes;
-	unsigned char save_control, save_freq_select;
-	unsigned long flags;
+	struct rtc_time tm;
 	int retval = 0;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-
-	 /* tell the clock it's being set */
-	save_control = CMOS_READ(RTC_CONTROL);
-	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
-
-	/* stop and reset prescaler */
-	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
-	CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
-
-	cmos_minutes = CMOS_READ(RTC_MINUTES);
-	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		cmos_minutes = bcd2bin(cmos_minutes);
-
-	/*
-	 * since we're only adjusting minutes and seconds,
-	 * don't interfere with hour overflow. This avoids
-	 * messing with unknown time zones but requires your
-	 * RTC not to be off by more than 15 minutes
-	 */
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	/* correct for half hour time zone */
-	if (((abs(real_minutes - cmos_minutes) + 15)/30) & 1)
-		real_minutes += 30;
-	real_minutes %= 60;
-
-	if (abs(real_minutes - cmos_minutes) < 30) {
-		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			real_seconds = bin2bcd(real_seconds);
-			real_minutes = bin2bcd(real_minutes);
-		}
-		CMOS_WRITE(real_seconds, RTC_SECONDS);
-		CMOS_WRITE(real_minutes, RTC_MINUTES);
+	rtc_time_to_tm(nowtime, &tm);
+	if (!rtc_valid_tm(&tm)) {
+		retval = set_rtc_time(&tm);
+		if (retval)
+			printk(KERN_ERR "%s: RTC write failed with error %d\n",
+			       __FUNCTION__, retval);
 	} else {
-		printk_once(KERN_NOTICE
-		       "set_rtc_mmss: can't update from %d to %d\n",
-		       cmos_minutes, real_minutes);
-		retval = -1;
+		printk(KERN_ERR
+		       "%s: Invalid RTC value: write of %lx to RTC failed\n",
+			__FUNCTION__, nowtime);
+		retval = -EINVAL;
 	}
-
-	/* The following flags have to be released exactly in this order,
-	 * otherwise the DS12887 (popular MC146818A clone with integrated
-	 * battery and quartz) will not reset the oscillator and will not
-	 * update precisely 500 ms later. You won't find this mentioned in
-	 * the Dallas Semiconductor data sheets, but who believes data
-	 * sheets anyway ...                           -- Markus Kuhn
-	 */
-	CMOS_WRITE(save_control, RTC_CONTROL);
-	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
-
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
 	return retval;
 }
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 4b9ea10..098b3cf 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -768,7 +768,8 @@ static cycle_t read_tsc(struct clocksource *cs)
 
 static void resume_tsc(struct clocksource *cs)
 {
-	clocksource_tsc.cycle_last = 0;
+	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3))
+		clocksource_tsc.cycle_last = 0;
 }
 
 static struct clocksource clocksource_tsc = {
@@ -939,6 +940,9 @@ static int __init init_tsc_clocksource(void)
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3))
+		clocksource_tsc.flags |= CLOCK_SOURCE_SUSPEND_NONSTOP;
+
 	/*
 	 * Trust the results of the earlier calibration on systems
 	 * exporting a reliable TSC.
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e4a86a6..b55d174 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -49,6 +49,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
+#include <asm/rtc.h>
 
 #define EFI_DEBUG	1
 
@@ -352,10 +353,10 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 
 int efi_set_rtc_mmss(unsigned long nowtime)
 {
-	int real_seconds, real_minutes;
 	efi_status_t 	status;
 	efi_time_t 	eft;
 	efi_time_cap_t 	cap;
+	struct rtc_time	tm;
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS) {
@@ -363,13 +364,20 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 		return -1;
 	}
 
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	if (((abs(real_minutes - eft.minute) + 15)/30) & 1)
-		real_minutes += 30;
-	real_minutes %= 60;
-	eft.minute = real_minutes;
-	eft.second = real_seconds;
+	rtc_time_to_tm(nowtime, &tm);
+	if (!rtc_valid_tm(&tm)) {
+		eft.year = tm.tm_year + 1900;
+		eft.month = tm.tm_mon + 1;
+		eft.day = tm.tm_mday;
+		eft.minute = tm.tm_min;
+		eft.second = tm.tm_sec;
+		eft.nanosecond = 0;
+	} else {
+		printk(KERN_ERR
+		       "%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
+		       __FUNCTION__, nowtime);
+		return -1;
+	}
 
 	status = efi.set_time(&eft);
 	if (status != EFI_SUCCESS) {
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 225bd0f..d62b0a3 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -85,27 +85,35 @@ unsigned long vrtc_get_time(void)
 	return mktime(year, mon, mday, hour, min, sec);
 }
 
-/* Only care about the minutes and seconds */
 int vrtc_set_mmss(unsigned long nowtime)
 {
-	int real_sec, real_min;
 	unsigned long flags;
-	int vrtc_min;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	vrtc_min = vrtc_cmos_read(RTC_MINUTES);
-
-	real_sec = nowtime % 60;
-	real_min = nowtime / 60;
-	if (((abs(real_min - vrtc_min) + 15)/30) & 1)
-		real_min += 30;
-	real_min %= 60;
-
-	vrtc_cmos_write(real_sec, RTC_SECONDS);
-	vrtc_cmos_write(real_min, RTC_MINUTES);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
-	return 0;
+	struct rtc_time tm;
+	int year;
+	int retval = 0;
+
+	rtc_time_to_tm(nowtime, &tm);
+	if (!rtc_valid_tm(&tm) && tm.tm_year >= 72) {
+		/*
+		 * tm.year is the number of years since 1900, and the
+		 * vrtc need the years since 1972.
+		 */
+		year = tm.tm_year - 72;
+		spin_lock_irqsave(&rtc_lock, flags);
+		vrtc_cmos_write(year, RTC_YEAR);
+		vrtc_cmos_write(tm.tm_mon, RTC_MONTH);
+		vrtc_cmos_write(tm.tm_mday, RTC_DAY_OF_MONTH);
+		vrtc_cmos_write(tm.tm_hour, RTC_HOURS);
+		vrtc_cmos_write(tm.tm_min, RTC_MINUTES);
+		vrtc_cmos_write(tm.tm_sec, RTC_SECONDS);
+		spin_unlock_irqrestore(&rtc_lock, flags);
+	} else {
+		printk(KERN_ERR
+		       "%s: Invalid vRTC value: write of %lx to vRTC failed\n",
+			__FUNCTION__, nowtime);
+		retval = -EINVAL;
+	}
+	return retval;
 }
 
 void __init mrst_rtc_init(void)
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 4d8283a..96e2531 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_SUNXI_TIMER)	+= sunxi_timer.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
+obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
new file mode 100644
index 0000000..350f493
--- /dev/null
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -0,0 +1,211 @@
+/*
+ * Copyright (C) 2012 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/jiffies.h>
+#include <linux/clockchips.h>
+#include <linux/types.h>
+
+#include <linux/io.h>
+#include <asm/mach/time.h>
+
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+
+#define KONA_GPTIMER_STCS_OFFSET			0x00000000
+#define KONA_GPTIMER_STCLO_OFFSET			0x00000004
+#define KONA_GPTIMER_STCHI_OFFSET			0x00000008
+#define KONA_GPTIMER_STCM0_OFFSET			0x0000000C
+
+#define KONA_GPTIMER_STCS_TIMER_MATCH_SHIFT		0
+#define KONA_GPTIMER_STCS_COMPARE_ENABLE_SHIFT		4
+
+struct kona_bcm_timers {
+	int tmr_irq;
+	void __iomem *tmr_regs;
+};
+
+static struct kona_bcm_timers timers;
+
+static u32 arch_timer_rate;
+
+/*
+ * We use the peripheral timers for system tick, the cpu global timer for
+ * profile tick
+ */
+static void kona_timer_disable_and_clear(void __iomem *base)
+{
+	uint32_t reg;
+
+	/*
+	 * clear and disable interrupts
+	 * We are using compare/match register 0 for our system interrupts
+	 */
+	reg = readl(base + KONA_GPTIMER_STCS_OFFSET);
+
+	/* Clear compare (0) interrupt */
+	reg |= 1 << KONA_GPTIMER_STCS_TIMER_MATCH_SHIFT;
+	/* disable compare */
+	reg &= ~(1 << KONA_GPTIMER_STCS_COMPARE_ENABLE_SHIFT);
+
+	writel(reg, base + KONA_GPTIMER_STCS_OFFSET);
+
+}
+
+static void
+kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
+{
+	void __iomem *base = IOMEM(timer_base);
+	int loop_limit = 4;
+
+	/*
+	 * Read 64-bit free running counter
+	 * 1. Read hi-word
+	 * 2. Read low-word
+	 * 3. Read hi-word again
+	 * 4.1
+	 *      if new hi-word is not equal to previously read hi-word, then
+	 *      start from #1
+	 * 4.2
+	 *      if new hi-word is equal to previously read hi-word then stop.
+	 */
+
+	while (--loop_limit) {
+		*msw = readl(base + KONA_GPTIMER_STCHI_OFFSET);
+		*lsw = readl(base + KONA_GPTIMER_STCLO_OFFSET);
+		if (*msw == readl(base + KONA_GPTIMER_STCHI_OFFSET))
+			break;
+	}
+	if (!loop_limit) {
+		pr_err("bcm_kona_timer: getting counter failed.\n");
+		pr_err(" Timer will be impacted\n");
+	}
+
+	return;
+}
+
+static const struct of_device_id bcm_timer_ids[] __initconst = {
+	{.compatible = "bcm,kona-timer"},
+	{},
+};
+
+static void __init kona_timers_init(void)
+{
+	struct device_node *node;
+	u32 freq;
+
+	node = of_find_matching_node(NULL, bcm_timer_ids);
+
+	if (!node)
+		panic("No timer");
+
+	if (!of_property_read_u32(node, "clock-frequency", &freq))
+		arch_timer_rate = freq;
+	else
+		panic("clock-frequency not set in the .dts file");
+
+	/* Setup IRQ numbers */
+	timers.tmr_irq = irq_of_parse_and_map(node, 0);
+
+	/* Setup IO addresses */
+	timers.tmr_regs = of_iomap(node, 0);
+
+	kona_timer_disable_and_clear(timers.tmr_regs);
+}
+
+static int kona_timer_set_next_event(unsigned long clc,
+				  struct clock_event_device *unused)
+{
+	/*
+	 * timer (0) is disabled by the timer interrupt already
+	 * so, here we reload the next event value and re-enable
+	 * the timer.
+	 *
+	 * This way, we are potentially losing the time between
+	 * timer-interrupt->set_next_event. CPU local timers, when
+	 * they come in should get rid of skew.
+	 */
+
+	uint32_t lsw, msw;
+	uint32_t reg;
+
+	kona_timer_get_counter(timers.tmr_regs, &msw, &lsw);
+
+	/* Load the "next" event tick value */
+	writel(lsw + clc, timers.tmr_regs + KONA_GPTIMER_STCM0_OFFSET);
+
+	/* Enable compare */
+	reg = readl(timers.tmr_regs + KONA_GPTIMER_STCS_OFFSET);
+	reg |= (1 << KONA_GPTIMER_STCS_COMPARE_ENABLE_SHIFT);
+	writel(reg, timers.tmr_regs + KONA_GPTIMER_STCS_OFFSET);
+
+	return 0;
+}
+
+static void kona_timer_set_mode(enum clock_event_mode mode,
+			     struct clock_event_device *unused)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* by default mode is one shot don't do any thing */
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		kona_timer_disable_and_clear(timers.tmr_regs);
+	}
+}
+
+static struct clock_event_device kona_clockevent_timer = {
+	.name = "timer 1",
+	.features = CLOCK_EVT_FEAT_ONESHOT,
+	.set_next_event = kona_timer_set_next_event,
+	.set_mode = kona_timer_set_mode
+};
+
+static void __init kona_timer_clockevents_init(void)
+{
+	kona_clockevent_timer.cpumask = cpumask_of(0);
+	clockevents_config_and_register(&kona_clockevent_timer,
+		arch_timer_rate, 6, 0xffffffff);
+}
+
+static irqreturn_t kona_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = &kona_clockevent_timer;
+
+	kona_timer_disable_and_clear(timers.tmr_regs);
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction kona_timer_irq = {
+	.name = "Kona Timer Tick",
+	.flags = IRQF_TIMER,
+	.handler = kona_timer_interrupt,
+};
+
+static void __init kona_timer_init(void)
+{
+	kona_timers_init();
+	kona_timer_clockevents_init();
+	setup_irq(timers.tmr_irq, &kona_timer_irq);
+	kona_timer_set_next_event((arch_timer_rate / HZ), NULL);
+}
+
+CLOCKSOURCE_OF_DECLARE(bcm_kona, "bcm,kona-timer",
+	kona_timer_init);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 69078c7..a193086 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -86,6 +86,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/flex_array.h>
+#include <linux/posix-timers.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -2013,6 +2014,102 @@ static const struct file_operations proc_map_files_operations = {
 	.llseek		= default_llseek,
 };
 
+struct timers_private {
+	struct pid *pid;
+	struct task_struct *task;
+	struct sighand_struct *sighand;
+	struct pid_namespace *ns;
+	unsigned long flags;
+};
+
+static void *timers_start(struct seq_file *m, loff_t *pos)
+{
+	struct timers_private *tp = m->private;
+
+	tp->task = get_pid_task(tp->pid, PIDTYPE_PID);
+	if (!tp->task)
+		return ERR_PTR(-ESRCH);
+
+	tp->sighand = lock_task_sighand(tp->task, &tp->flags);
+	if (!tp->sighand)
+		return ERR_PTR(-ESRCH);
+
+	return seq_list_start(&tp->task->signal->posix_timers, *pos);
+}
+
+static void *timers_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct timers_private *tp = m->private;
+	return seq_list_next(v, &tp->task->signal->posix_timers, pos);
+}
+
+static void timers_stop(struct seq_file *m, void *v)
+{
+	struct timers_private *tp = m->private;
+
+	if (tp->sighand) {
+		unlock_task_sighand(tp->task, &tp->flags);
+		tp->sighand = NULL;
+	}
+
+	if (tp->task) {
+		put_task_struct(tp->task);
+		tp->task = NULL;
+	}
+}
+
+static int show_timer(struct seq_file *m, void *v)
+{
+	struct k_itimer *timer;
+	struct timers_private *tp = m->private;
+	int notify;
+	static char *nstr[] = {
+		[SIGEV_SIGNAL] = "signal",
+		[SIGEV_NONE] = "none",
+		[SIGEV_THREAD] = "thread",
+	};
+
+	timer = list_entry((struct list_head *)v, struct k_itimer, list);
+	notify = timer->it_sigev_notify;
+
+	seq_printf(m, "ID: %d\n", timer->it_id);
+	seq_printf(m, "signal: %d/%p\n", timer->sigq->info.si_signo,
+			timer->sigq->info.si_value.sival_ptr);
+	seq_printf(m, "notify: %s/%s.%d\n",
+		nstr[notify & ~SIGEV_THREAD_ID],
+		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
+		pid_nr_ns(timer->it_pid, tp->ns));
+
+	return 0;
+}
+
+static const struct seq_operations proc_timers_seq_ops = {
+	.start	= timers_start,
+	.next	= timers_next,
+	.stop	= timers_stop,
+	.show	= show_timer,
+};
+
+static int proc_timers_open(struct inode *inode, struct file *file)
+{
+	struct timers_private *tp;
+
+	tp = __seq_open_private(file, &proc_timers_seq_ops,
+			sizeof(struct timers_private));
+	if (!tp)
+		return -ENOMEM;
+
+	tp->pid = proc_pid(inode);
+	tp->ns = inode->i_sb->s_fs_info;
+	return 0;
+}
+
+static const struct file_operations proc_timers_operations = {
+	.open		= proc_timers_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
 #endif /* CONFIG_CHECKPOINT_RESTORE */
 
 static struct dentry *proc_pident_instantiate(struct inode *dir,
@@ -2583,6 +2680,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 #endif
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	REG("timers",	  S_IRUGO, proc_timers_operations),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 6634652..464e229 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -55,6 +55,11 @@ enum clock_event_nofitiers {
 #define CLOCK_EVT_FEAT_C3STOP		0x000008
 #define CLOCK_EVT_FEAT_DUMMY		0x000010
 
+/*
+ * Core shall set the interrupt affinity dynamically in broadcast mode
+ */
+#define CLOCK_EVT_FEAT_DYNIRQ		0x000020
+
 /**
  * struct clock_event_device - clock event device descriptor
  * @event_handler:	Assigned by the framework to be called by the low
@@ -170,6 +175,12 @@ extern void tick_broadcast(const struct cpumask *mask);
 extern int tick_receive_broadcast(void);
 #endif
 
+#if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
+extern int tick_check_broadcast_expired(void);
+#else
+static inline int tick_check_broadcast_expired(void) { return 0; }
+#endif
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
@@ -182,6 +193,7 @@ static inline void clockevents_suspend(void) {}
 static inline void clockevents_resume(void) {}
 
 #define clockevents_notify(reason, arg) do { } while (0)
+static inline int tick_check_broadcast_expired(void) { return 0; }
 
 #endif
 
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 27cfda4..aa7032c 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -206,6 +206,7 @@ struct clocksource {
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
 #define CLOCK_SOURCE_UNSTABLE			0x40
+#define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index cc07d27..d19a5c2 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -157,6 +157,7 @@ enum  hrtimer_base_type {
 	HRTIMER_BASE_MONOTONIC,
 	HRTIMER_BASE_REALTIME,
 	HRTIMER_BASE_BOOTTIME,
+	HRTIMER_BASE_TAI,
 	HRTIMER_MAX_CLOCK_BASES,
 };
 
@@ -327,7 +328,9 @@ extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
 extern ktime_t ktime_get_boottime(void);
 extern ktime_t ktime_get_monotonic_offset(void);
-extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot);
+extern ktime_t ktime_get_clocktai(void);
+extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
+					 ktime_t *offs_tai);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 82ed068..8fb8edf 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -75,7 +75,6 @@ extern int register_refined_jiffies(long clock_tick_rate);
  */
 extern u64 __jiffy_data jiffies_64;
 extern unsigned long volatile __jiffy_data jiffies;
-extern seqlock_t jiffies_lock;
 
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void);
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 042058f..60bac69 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -55,6 +55,7 @@ struct cpu_timer_list {
 /* POSIX.1b interval timer structure. */
 struct k_itimer {
 	struct list_head list;		/* free/ allocate list */
+	struct hlist_node t_hash;
 	spinlock_t it_lock;
 	clockid_t it_clock;		/* which timer type */
 	timer_t it_id;			/* timer id */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e692a02..7869431 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -527,7 +527,8 @@ struct signal_struct {
 	unsigned int		has_child_subreaper:1;
 
 	/* POSIX.1b Interval Timers */
-	struct list_head posix_timers;
+	int			posix_timer_id;
+	struct list_head	posix_timers;
 
 	/* ITIMER_REAL timer for the process */
 	struct hrtimer real_timer;
diff --git a/include/linux/time.h b/include/linux/time.h
index d4835df..22d81b3 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -181,6 +181,9 @@ extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern int timekeeping_inject_offset(struct timespec *ts);
+extern s32 timekeeping_get_tai_offset(void);
+extern void timekeeping_set_tai_offset(s32 tai_offset);
+extern void timekeeping_clocktai(struct timespec *ts);
 
 struct tms;
 extern void do_sys_times(struct tms *);
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index e1d558e..c1825eb 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -20,6 +20,8 @@ struct timekeeper {
 	u32			shift;
 	/* Number of clock cycles in one NTP interval. */
 	cycle_t			cycle_interval;
+	/* Last cycle value (also stored in clock->cycle_last) */
+	cycle_t			cycle_last;
 	/* Number of clock shifted nano seconds in one NTP interval. */
 	u64			xtime_interval;
 	/* shifted nano seconds left over when rounding cycle_interval */
@@ -62,8 +64,11 @@ struct timekeeper {
 	ktime_t			offs_boot;
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec		raw_time;
-	/* Seqlock for all timekeeper values */
-	seqlock_t		lock;
+	/* The current UTC to TAI offset in seconds */
+	s32			tai_offset;
+	/* Offset clock monotonic -> clock tai */
+	ktime_t			offs_tai;
+
 };
 
 static inline struct timespec tk_xtime(struct timekeeper *tk)
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 5ec87c6..b3726e6 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -125,9 +125,6 @@
 extern unsigned long tick_usec;		/* USER_HZ period (usec) */
 extern unsigned long tick_nsec;		/* SHIFTED_HZ period (nsec) */
 
-extern void ntp_init(void);
-extern void ntp_clear(void);
-
 /* Required to safely shift negative values */
 #define shift_right(x, s) ({	\
 	__typeof__(x) __x = (x);	\
@@ -140,10 +137,6 @@ extern void ntp_clear(void);
 #define NTP_INTERVAL_FREQ  (HZ)
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
-/* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
-extern u64 ntp_tick_length(void);
-
-extern int second_overflow(unsigned long secs);
 extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index 0d3c0ed..e75e1b6 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -54,11 +54,9 @@ struct itimerval {
 #define CLOCK_BOOTTIME			7
 #define CLOCK_REALTIME_ALARM		8
 #define CLOCK_BOOTTIME_ALARM		9
+#define CLOCK_SGI_CYCLE			10	/* Hardware specific */
+#define CLOCK_TAI			11
 
-/*
- * The IDs of various hardware clocks:
- */
-#define CLOCK_SGI_CYCLE			10
 #define MAX_CLOCKS			16
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
 #define CLOCKS_MONO			CLOCK_MONOTONIC
diff --git a/init/main.c b/init/main.c
index 63534a1..b3e0614 100644
--- a/init/main.c
+++ b/init/main.c
@@ -494,7 +494,6 @@ asmlinkage void __init start_kernel(void)
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
  */
-	tick_init();
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE "%s", linux_banner);
@@ -551,6 +550,7 @@ asmlinkage void __init start_kernel(void)
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
+	tick_init();
 	init_timers();
 	hrtimers_init();
 	softirq_init();
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 14be27f..609d8ff 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -84,6 +84,12 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 			.get_time = &ktime_get_boottime,
 			.resolution = KTIME_LOW_RES,
 		},
+		{
+			.index = HRTIMER_BASE_TAI,
+			.clockid = CLOCK_TAI,
+			.get_time = &ktime_get_clocktai,
+			.resolution = KTIME_LOW_RES,
+		},
 	}
 };
 
@@ -91,6 +97,7 @@ static const int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
 	[CLOCK_REALTIME]	= HRTIMER_BASE_REALTIME,
 	[CLOCK_MONOTONIC]	= HRTIMER_BASE_MONOTONIC,
 	[CLOCK_BOOTTIME]	= HRTIMER_BASE_BOOTTIME,
+	[CLOCK_TAI]		= HRTIMER_BASE_TAI,
 };
 
 static inline int hrtimer_clockid_to_base(clockid_t clock_id)
@@ -107,8 +114,10 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
 	ktime_t xtim, mono, boot;
 	struct timespec xts, tom, slp;
+	s32 tai_offset;
 
 	get_xtime_and_monotonic_and_sleep_offset(&xts, &tom, &slp);
+	tai_offset = timekeeping_get_tai_offset();
 
 	xtim = timespec_to_ktime(xts);
 	mono = ktime_add(xtim, timespec_to_ktime(tom));
@@ -116,6 +125,8 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 	base->clock_base[HRTIMER_BASE_REALTIME].softirq_time = xtim;
 	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time = mono;
 	base->clock_base[HRTIMER_BASE_BOOTTIME].softirq_time = boot;
+	base->clock_base[HRTIMER_BASE_TAI].softirq_time =
+				ktime_add(xtim,	ktime_set(tai_offset, 0));
 }
 
 /*
@@ -276,6 +287,10 @@ ktime_t ktime_add_ns(const ktime_t kt, u64 nsec)
 	} else {
 		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
 
+		/* Make sure nsec fits into long */
+		if (unlikely(nsec > KTIME_SEC_MAX))
+			return (ktime_t){ .tv64 = KTIME_MAX };
+
 		tmp = ktime_set((long)nsec, rem);
 	}
 
@@ -652,8 +667,9 @@ static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
 {
 	ktime_t *offs_real = &base->clock_base[HRTIMER_BASE_REALTIME].offset;
 	ktime_t *offs_boot = &base->clock_base[HRTIMER_BASE_BOOTTIME].offset;
+	ktime_t *offs_tai = &base->clock_base[HRTIMER_BASE_TAI].offset;
 
-	return ktime_get_update_offsets(offs_real, offs_boot);
+	return ktime_get_update_offsets(offs_real, offs_boot, offs_tai);
 }
 
 /*
@@ -1011,7 +1027,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
  * @timer:	the timer to be added
  * @tim:	expiry time
  * @delta_ns:	"slack" range for the timer
- * @mode:	expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
+ * @mode:	expiry mode: absolute (HRTIMER_MODE_ABS) or
+ *		relative (HRTIMER_MODE_REL)
  *
  * Returns:
  *  0 on success
@@ -1028,7 +1045,8 @@ EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
  * hrtimer_start - (re)start an hrtimer on the current CPU
  * @timer:	the timer to be added
  * @tim:	expiry time
- * @mode:	expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
+ * @mode:	expiry mode: absolute (HRTIMER_MODE_ABS) or
+ *		relative (HRTIMER_MODE_REL)
  *
  * Returns:
  *  0 on success
@@ -1310,6 +1328,8 @@ retry:
 
 				expires = ktime_sub(hrtimer_get_expires(timer),
 						    base->offset);
+				if (expires.tv64 < 0)
+					expires.tv64 = KTIME_MAX;
 				if (expires.tv64 < expires_next.tv64)
 					expires_next = expires;
 				break;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 6edbb2c..424c2d4 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -40,38 +40,31 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/compiler.h>
-#include <linux/idr.h>
+#include <linux/hash.h>
 #include <linux/posix-clock.h>
 #include <linux/posix-timers.h>
 #include <linux/syscalls.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/export.h>
+#include <linux/hashtable.h>
 
 /*
- * Management arrays for POSIX timers.	 Timers are kept in slab memory
- * Timer ids are allocated by an external routine that keeps track of the
- * id and the timer.  The external interface is:
- *
- * void *idr_find(struct idr *idp, int id);           to find timer_id <id>
- * int idr_get_new(struct idr *idp, void *ptr);       to get a new id and
- *                                                    related it to <ptr>
- * void idr_remove(struct idr *idp, int id);          to release <id>
- * void idr_init(struct idr *idp);                    to initialize <idp>
- *                                                    which we supply.
- * The idr_get_new *may* call slab for more memory so it must not be
- * called under a spin lock.  Likewise idr_remore may release memory
- * (but it may be ok to do this under a lock...).
- * idr_find is just a memory look up and is quite fast.  A -1 return
- * indicates that the requested id does not exist.
+ * Management arrays for POSIX timers. Timers are now kept in static hash table
+ * with 512 entries.
+ * Timer ids are allocated by local routine, which selects proper hash head by
+ * key, constructed from current->signal address and per signal struct counter.
+ * This keeps timer ids unique per process, but now they can intersect between
+ * processes.
  */
 
 /*
  * Lets keep our timers in a slab cache :-)
  */
 static struct kmem_cache *posix_timers_cache;
-static struct idr posix_timers_id;
-static DEFINE_SPINLOCK(idr_lock);
+
+static DEFINE_HASHTABLE(posix_timers_hashtable, 9);
+static DEFINE_SPINLOCK(hash_lock);
 
 /*
  * we assume that the new SIGEV_THREAD_ID shares no bits with the other
@@ -152,6 +145,56 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags);
 	__timr;								   \
 })
 
+static int hash(struct signal_struct *sig, unsigned int nr)
+{
+	return hash_32(hash32_ptr(sig) ^ nr, HASH_BITS(posix_timers_hashtable));
+}
+
+static struct k_itimer *__posix_timers_find(struct hlist_head *head,
+					    struct signal_struct *sig,
+					    timer_t id)
+{
+	struct k_itimer *timer;
+
+	hlist_for_each_entry_rcu(timer, head, t_hash) {
+		if ((timer->it_signal == sig) && (timer->it_id == id))
+			return timer;
+	}
+	return NULL;
+}
+
+static struct k_itimer *posix_timer_by_id(timer_t id)
+{
+	struct signal_struct *sig = current->signal;
+	struct hlist_head *head = &posix_timers_hashtable[hash(sig, id)];
+
+	return __posix_timers_find(head, sig, id);
+}
+
+static int posix_timer_add(struct k_itimer *timer)
+{
+	struct signal_struct *sig = current->signal;
+	int first_free_id = sig->posix_timer_id;
+	struct hlist_head *head;
+	int ret = -ENOENT;
+
+	do {
+		spin_lock(&hash_lock);
+		head = &posix_timers_hashtable[hash(sig, sig->posix_timer_id)];
+		if (!__posix_timers_find(head, sig, sig->posix_timer_id)) {
+			hlist_add_head_rcu(&timer->t_hash, head);
+			ret = sig->posix_timer_id;
+		}
+		if (++sig->posix_timer_id < 0)
+			sig->posix_timer_id = 0;
+		if ((sig->posix_timer_id == first_free_id) && (ret == -ENOENT))
+			/* Loop over all possible ids completed */
+			ret = -EAGAIN;
+		spin_unlock(&hash_lock);
+	} while (ret == -ENOENT);
+	return ret;
+}
+
 static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 {
 	spin_unlock_irqrestore(&timr->it_lock, flags);
@@ -221,6 +264,11 @@ static int posix_get_boottime(const clockid_t which_clock, struct timespec *tp)
 	return 0;
 }
 
+static int posix_get_tai(clockid_t which_clock, struct timespec *tp)
+{
+	timekeeping_clocktai(tp);
+	return 0;
+}
 
 /*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
@@ -261,6 +309,16 @@ static __init int init_posix_timers(void)
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_monotonic_coarse,
 	};
+	struct k_clock clock_tai = {
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_get_tai,
+		.nsleep		= common_nsleep,
+		.nsleep_restart	= hrtimer_nanosleep_restart,
+		.timer_create	= common_timer_create,
+		.timer_set	= common_timer_set,
+		.timer_get	= common_timer_get,
+		.timer_del	= common_timer_del,
+	};
 	struct k_clock clock_boottime = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_get_boottime,
@@ -278,11 +336,11 @@ static __init int init_posix_timers(void)
 	posix_timers_register_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
 	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
 	posix_timers_register_clock(CLOCK_BOOTTIME, &clock_boottime);
+	posix_timers_register_clock(CLOCK_TAI, &clock_tai);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
 					NULL);
-	idr_init(&posix_timers_id);
 	return 0;
 }
 
@@ -504,9 +562,9 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
 	if (it_id_set) {
 		unsigned long flags;
-		spin_lock_irqsave(&idr_lock, flags);
-		idr_remove(&posix_timers_id, tmr->it_id);
-		spin_unlock_irqrestore(&idr_lock, flags);
+		spin_lock_irqsave(&hash_lock, flags);
+		hlist_del_rcu(&tmr->t_hash);
+		spin_unlock_irqrestore(&hash_lock, flags);
 	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
@@ -552,22 +610,11 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		return -EAGAIN;
 
 	spin_lock_init(&new_timer->it_lock);
-
-	idr_preload(GFP_KERNEL);
-	spin_lock_irq(&idr_lock);
-	error = idr_alloc(&posix_timers_id, new_timer, 0, 0, GFP_NOWAIT);
-	spin_unlock_irq(&idr_lock);
-	idr_preload_end();
-	if (error < 0) {
-		/*
-		 * Weird looking, but we return EAGAIN if the IDR is
-		 * full (proper POSIX return value for this)
-		 */
-		if (error == -ENOSPC)
-			error = -EAGAIN;
+	new_timer_id = posix_timer_add(new_timer);
+	if (new_timer_id < 0) {
+		error = new_timer_id;
 		goto out;
 	}
-	new_timer_id = error;
 
 	it_id_set = IT_ID_SET;
 	new_timer->it_id = (timer_t) new_timer_id;
@@ -645,7 +692,7 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 		return NULL;
 
 	rcu_read_lock();
-	timr = idr_find(&posix_timers_id, (int)timer_id);
+	timr = posix_timer_by_id(timer_id);
 	if (timr) {
 		spin_lock_irqsave(&timr->it_lock, *flags);
 		if (timr->it_signal == current->signal) {
diff --git a/kernel/time.c b/kernel/time.c
index f8342a4..d3617db 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -138,13 +138,14 @@ int persistent_clock_is_local;
  */
 static inline void warp_clock(void)
 {
-	struct timespec adjust;
+	if (sys_tz.tz_minuteswest != 0) {
+		struct timespec adjust;
 
-	adjust = current_kernel_time();
-	if (sys_tz.tz_minuteswest != 0)
 		persistent_clock_is_local = 1;
-	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
-	do_settimeofday(&adjust);
+		adjust.tv_sec = sys_tz.tz_minuteswest * 60;
+		adjust.tv_nsec = 0;
+		timekeeping_inject_offset(&adjust);
+	}
 }
 
 /*
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 072bb06..12ff13a 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -18,13 +18,14 @@
 #include <linux/rtc.h>
 
 #include "tick-internal.h"
+#include "ntp_internal.h"
 
 /*
  * NTP timekeeping variables:
+ *
+ * Note: All of the NTP state is protected by the timekeeping locks.
  */
 
-DEFINE_RAW_SPINLOCK(ntp_lock);
-
 
 /* USER_HZ period (usecs): */
 unsigned long			tick_usec = TICK_USEC;
@@ -53,9 +54,6 @@ static int			time_state = TIME_OK;
 /* clock status bits:							*/
 static int			time_status = STA_UNSYNC;
 
-/* TAI offset (secs):							*/
-static long			time_tai;
-
 /* time adjustment (nsecs):						*/
 static s64			time_offset;
 
@@ -134,8 +132,6 @@ static inline void pps_reset_freq_interval(void)
 
 /**
  * pps_clear - Clears the PPS state variables
- *
- * Must be called while holding a write on the ntp_lock
  */
 static inline void pps_clear(void)
 {
@@ -150,8 +146,6 @@ static inline void pps_clear(void)
 /* Decrease pps_valid to indicate that another second has passed since
  * the last PPS signal. When it reaches 0, indicate that PPS signal is
  * missing.
- *
- * Must be called while holding a write on the ntp_lock
  */
 static inline void pps_dec_valid(void)
 {
@@ -346,10 +340,6 @@ static void ntp_update_offset(long offset)
  */
 void ntp_clear(void)
 {
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ntp_lock, flags);
-
 	time_adjust	= 0;		/* stop active adjtime() */
 	time_status	|= STA_UNSYNC;
 	time_maxerror	= NTP_PHASE_LIMIT;
@@ -362,20 +352,12 @@ void ntp_clear(void)
 
 	/* Clear PPS state variables */
 	pps_clear();
-	raw_spin_unlock_irqrestore(&ntp_lock, flags);
-
 }
 
 
 u64 ntp_tick_length(void)
 {
-	unsigned long flags;
-	s64 ret;
-
-	raw_spin_lock_irqsave(&ntp_lock, flags);
-	ret = tick_length;
-	raw_spin_unlock_irqrestore(&ntp_lock, flags);
-	return ret;
+	return tick_length;
 }
 
 
@@ -393,9 +375,6 @@ int second_overflow(unsigned long secs)
 {
 	s64 delta;
 	int leap = 0;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ntp_lock, flags);
 
 	/*
 	 * Leap second processing. If in leap-insert state at the end of the
@@ -415,7 +394,6 @@ int second_overflow(unsigned long secs)
 		else if (secs % 86400 == 0) {
 			leap = -1;
 			time_state = TIME_OOP;
-			time_tai++;
 			printk(KERN_NOTICE
 				"Clock: inserting leap second 23:59:60 UTC\n");
 		}
@@ -425,7 +403,6 @@ int second_overflow(unsigned long secs)
 			time_state = TIME_OK;
 		else if ((secs + 1) % 86400 == 0) {
 			leap = 1;
-			time_tai--;
 			time_state = TIME_WAIT;
 			printk(KERN_NOTICE
 				"Clock: deleting leap second 23:59:59 UTC\n");
@@ -479,8 +456,6 @@ int second_overflow(unsigned long secs)
 	time_adjust = 0;
 
 out:
-	raw_spin_unlock_irqrestore(&ntp_lock, flags);
-
 	return leap;
 }
 
@@ -575,11 +550,10 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	time_status |= txc->status & ~STA_RONLY;
 }
 
-/*
- * Called with ntp_lock held, so we can access and modify
- * all the global NTP state:
- */
-static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts)
+
+static inline void process_adjtimex_modes(struct timex *txc,
+						struct timespec *ts,
+						s32 *time_tai)
 {
 	if (txc->modes & ADJ_STATUS)
 		process_adj_status(txc, ts);
@@ -613,7 +587,7 @@ static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts
 	}
 
 	if (txc->modes & ADJ_TAI && txc->constant > 0)
-		time_tai = txc->constant;
+		*time_tai = txc->constant;
 
 	if (txc->modes & ADJ_OFFSET)
 		ntp_update_offset(txc->offset);
@@ -625,16 +599,13 @@ static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts
 		ntp_update_frequency();
 }
 
-/*
- * adjtimex mainly allows reading (and writing, if superuser) of
- * kernel time-keeping variables. used by xntpd.
+
+
+/**
+ * ntp_validate_timex - Ensures the timex is ok for use in do_adjtimex
  */
-int do_adjtimex(struct timex *txc)
+int ntp_validate_timex(struct timex *txc)
 {
-	struct timespec ts;
-	int result;
-
-	/* Validate the data before disabling interrupts */
 	if (txc->modes & ADJ_ADJTIME) {
 		/* singleshot must not be used with any other mode bits */
 		if (!(txc->modes & ADJ_OFFSET_SINGLESHOT))
@@ -646,7 +617,6 @@ int do_adjtimex(struct timex *txc)
 		/* In order to modify anything, you gotta be super-user! */
 		 if (txc->modes && !capable(CAP_SYS_TIME))
 			return -EPERM;
-
 		/*
 		 * if the quartz is off by more than 10% then
 		 * something is VERY wrong!
@@ -657,22 +627,20 @@ int do_adjtimex(struct timex *txc)
 			return -EINVAL;
 	}
 
-	if (txc->modes & ADJ_SETOFFSET) {
-		struct timespec delta;
-		delta.tv_sec  = txc->time.tv_sec;
-		delta.tv_nsec = txc->time.tv_usec;
-		if (!capable(CAP_SYS_TIME))
-			return -EPERM;
-		if (!(txc->modes & ADJ_NANO))
-			delta.tv_nsec *= 1000;
-		result = timekeeping_inject_offset(&delta);
-		if (result)
-			return result;
-	}
+	if ((txc->modes & ADJ_SETOFFSET) && (!capable(CAP_SYS_TIME)))
+		return -EPERM;
 
-	getnstimeofday(&ts);
+	return 0;
+}
 
-	raw_spin_lock_irq(&ntp_lock);
+
+/*
+ * adjtimex mainly allows reading (and writing, if superuser) of
+ * kernel time-keeping variables. used by xntpd.
+ */
+int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
+{
+	int result;
 
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
@@ -687,7 +655,7 @@ int do_adjtimex(struct timex *txc)
 
 		/* If there are input parameters, then process them: */
 		if (txc->modes)
-			process_adjtimex_modes(txc, &ts);
+			process_adjtimex_modes(txc, ts, time_tai);
 
 		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
@@ -709,15 +677,13 @@ int do_adjtimex(struct timex *txc)
 	txc->precision	   = 1;
 	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
 	txc->tick	   = tick_usec;
-	txc->tai	   = time_tai;
+	txc->tai	   = *time_tai;
 
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	raw_spin_unlock_irq(&ntp_lock);
-
-	txc->time.tv_sec = ts.tv_sec;
-	txc->time.tv_usec = ts.tv_nsec;
+	txc->time.tv_sec = ts->tv_sec;
+	txc->time.tv_usec = ts->tv_nsec;
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
 
@@ -894,7 +860,7 @@ static void hardpps_update_phase(long error)
 }
 
 /*
- * hardpps() - discipline CPU clock oscillator to external PPS signal
+ * __hardpps() - discipline CPU clock oscillator to external PPS signal
  *
  * This routine is called at each PPS signal arrival in order to
  * discipline the CPU clock oscillator to the PPS signal. It takes two
@@ -905,15 +871,13 @@ static void hardpps_update_phase(long error)
  * This code is based on David Mills's reference nanokernel
  * implementation. It was mostly rewritten but keeps the same idea.
  */
-void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
+void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
 	struct pps_normtime pts_norm, freq_norm;
 	unsigned long flags;
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-	raw_spin_lock_irqsave(&ntp_lock, flags);
-
 	/* clear the error bits, they will be set again if needed */
 	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
 
@@ -925,7 +889,6 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec == 0)) {
 		pps_fbase = *raw_ts;
-		raw_spin_unlock_irqrestore(&ntp_lock, flags);
 		return;
 	}
 
@@ -940,7 +903,6 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		raw_spin_unlock_irqrestore(&ntp_lock, flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -957,10 +919,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	hardpps_update_phase(pts_norm.nsec);
 
-	raw_spin_unlock_irqrestore(&ntp_lock, flags);
 }
-EXPORT_SYMBOL(hardpps);
-
 #endif	/* CONFIG_NTP_PPS */
 
 static int __init ntp_tick_adj_setup(char *str)
diff --git a/kernel/time/ntp_internal.h b/kernel/time/ntp_internal.h
new file mode 100644
index 0000000..1950cb4
--- /dev/null
+++ b/kernel/time/ntp_internal.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_NTP_INTERNAL_H
+#define _LINUX_NTP_INTERNAL_H
+
+extern void ntp_init(void);
+extern void ntp_clear(void);
+/* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
+extern u64 ntp_tick_length(void);
+extern int second_overflow(unsigned long secs);
+extern int ntp_validate_timex(struct timex *);
+extern int __do_adjtimex(struct timex *, struct timespec *, s32 *);
+extern void __hardpps(const struct timespec *, const struct timespec *);
+#endif /* _LINUX_NTP_INTERNAL_H */
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 7f32fe0..61d00a8 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -28,9 +28,8 @@
  */
 
 static struct tick_device tick_broadcast_device;
-/* FIXME: Use cpumask_var_t. */
-static DECLARE_BITMAP(tick_broadcast_mask, NR_CPUS);
-static DECLARE_BITMAP(tmpmask, NR_CPUS);
+static cpumask_var_t tick_broadcast_mask;
+static cpumask_var_t tmpmask;
 static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
 
@@ -50,7 +49,7 @@ struct tick_device *tick_get_broadcast_device(void)
 
 struct cpumask *tick_get_broadcast_mask(void)
 {
-	return to_cpumask(tick_broadcast_mask);
+	return tick_broadcast_mask;
 }
 
 /*
@@ -67,6 +66,8 @@ static void tick_broadcast_start_periodic(struct clock_event_device *bc)
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
+	struct clock_event_device *cur = tick_broadcast_device.evtdev;
+
 	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
 	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
@@ -74,9 +75,21 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 		return 0;
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
+	if (cur)
+		cur->event_handler = clockevents_handle_noop;
 	tick_broadcast_device.evtdev = dev;
-	if (!cpumask_empty(tick_get_broadcast_mask()))
+	if (!cpumask_empty(tick_broadcast_mask))
 		tick_broadcast_start_periodic(dev);
+	/*
+	 * Inform all cpus about this. We might be in a situation
+	 * where we did not switch to oneshot mode because the per cpu
+	 * devices are affected by CLOCK_EVT_FEAT_C3STOP and the lack
+	 * of a oneshot capable broadcast device. Without that
+	 * notification the systems stays stuck in periodic mode
+	 * forever.
+	 */
+	if (dev->features & CLOCK_EVT_FEAT_ONESHOT)
+		tick_clock_notify();
 	return 1;
 }
 
@@ -124,7 +137,7 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 	if (!tick_device_is_functional(dev)) {
 		dev->event_handler = tick_handle_periodic;
 		tick_device_setup_broadcast_func(dev);
-		cpumask_set_cpu(cpu, tick_get_broadcast_mask());
+		cpumask_set_cpu(cpu, tick_broadcast_mask);
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
 	} else {
@@ -135,7 +148,7 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 		 */
 		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
 			int cpu = smp_processor_id();
-			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
+			cpumask_clear_cpu(cpu, tick_broadcast_mask);
 			tick_broadcast_clear_oneshot(cpu);
 		} else {
 			tick_device_setup_broadcast_func(dev);
@@ -199,9 +212,8 @@ static void tick_do_periodic_broadcast(void)
 {
 	raw_spin_lock(&tick_broadcast_lock);
 
-	cpumask_and(to_cpumask(tmpmask),
-		    cpu_online_mask, tick_get_broadcast_mask());
-	tick_do_broadcast(to_cpumask(tmpmask));
+	cpumask_and(tmpmask, cpu_online_mask, tick_broadcast_mask);
+	tick_do_broadcast(tmpmask);
 
 	raw_spin_unlock(&tick_broadcast_lock);
 }
@@ -264,13 +276,12 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	if (!tick_device_is_functional(dev))
 		goto out;
 
-	bc_stopped = cpumask_empty(tick_get_broadcast_mask());
+	bc_stopped = cpumask_empty(tick_broadcast_mask);
 
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
-		if (!cpumask_test_cpu(cpu, tick_get_broadcast_mask())) {
-			cpumask_set_cpu(cpu, tick_get_broadcast_mask());
+		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
@@ -280,8 +291,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 		break;
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
 		if (!tick_broadcast_force &&
-		    cpumask_test_cpu(cpu, tick_get_broadcast_mask())) {
-			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
+		    cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
@@ -289,7 +299,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 		break;
 	}
 
-	if (cpumask_empty(tick_get_broadcast_mask())) {
+	if (cpumask_empty(tick_broadcast_mask)) {
 		if (!bc_stopped)
 			clockevents_shutdown(bc);
 	} else if (bc_stopped) {
@@ -338,10 +348,10 @@ void tick_shutdown_broadcast(unsigned int *cpup)
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
+	cpumask_clear_cpu(cpu, tick_broadcast_mask);
 
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC) {
-		if (bc && cpumask_empty(tick_get_broadcast_mask()))
+		if (bc && cpumask_empty(tick_broadcast_mask))
 			clockevents_shutdown(bc);
 	}
 
@@ -377,13 +387,13 @@ int tick_resume_broadcast(void)
 
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
-			if (!cpumask_empty(tick_get_broadcast_mask()))
+			if (!cpumask_empty(tick_broadcast_mask))
 				tick_broadcast_start_periodic(bc);
 			broadcast = cpumask_test_cpu(smp_processor_id(),
-						     tick_get_broadcast_mask());
+						     tick_broadcast_mask);
 			break;
 		case TICKDEV_MODE_ONESHOT:
-			if (!cpumask_empty(tick_get_broadcast_mask()))
+			if (!cpumask_empty(tick_broadcast_mask))
 				broadcast = tick_resume_broadcast_oneshot(bc);
 			break;
 		}
@@ -396,25 +406,58 @@ int tick_resume_broadcast(void)
 
 #ifdef CONFIG_TICK_ONESHOT
 
-/* FIXME: use cpumask_var_t. */
-static DECLARE_BITMAP(tick_broadcast_oneshot_mask, NR_CPUS);
+static cpumask_var_t tick_broadcast_oneshot_mask;
+static cpumask_var_t tick_broadcast_pending_mask;
+static cpumask_var_t tick_broadcast_force_mask;
 
 /*
  * Exposed for debugging: see timer_list.c
  */
 struct cpumask *tick_get_broadcast_oneshot_mask(void)
 {
-	return to_cpumask(tick_broadcast_oneshot_mask);
+	return tick_broadcast_oneshot_mask;
 }
 
-static int tick_broadcast_set_event(ktime_t expires, int force)
+/*
+ * Called before going idle with interrupts disabled. Checks whether a
+ * broadcast event from the other core is about to happen. We detected
+ * that in tick_broadcast_oneshot_control(). The callsite can use this
+ * to avoid a deep idle transition as we are about to get the
+ * broadcast IPI right away.
+ */
+int tick_check_broadcast_expired(void)
 {
-	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+	return cpumask_test_cpu(smp_processor_id(), tick_broadcast_force_mask);
+}
+
+/*
+ * Set broadcast interrupt affinity
+ */
+static void tick_broadcast_set_affinity(struct clock_event_device *bc,
+					const struct cpumask *cpumask)
+{
+	if (!(bc->features & CLOCK_EVT_FEAT_DYNIRQ))
+		return;
+
+	if (cpumask_equal(bc->cpumask, cpumask))
+		return;
+
+	bc->cpumask = cpumask;
+	irq_set_affinity(bc->irq, bc->cpumask);
+}
+
+static int tick_broadcast_set_event(struct clock_event_device *bc, int cpu,
+				    ktime_t expires, int force)
+{
+	int ret;
 
 	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
-	return clockevents_program_event(bc, expires, force);
+	ret = clockevents_program_event(bc, expires, force);
+	if (!ret)
+		tick_broadcast_set_affinity(bc, cpumask_of(cpu));
+	return ret;
 }
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
@@ -429,7 +472,7 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
  */
 void tick_check_oneshot_broadcast(int cpu)
 {
-	if (cpumask_test_cpu(cpu, to_cpumask(tick_broadcast_oneshot_mask))) {
+	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
 		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
@@ -443,27 +486,39 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 {
 	struct tick_device *td;
 	ktime_t now, next_event;
-	int cpu;
+	int cpu, next_cpu = 0;
 
 	raw_spin_lock(&tick_broadcast_lock);
 again:
 	dev->next_event.tv64 = KTIME_MAX;
 	next_event.tv64 = KTIME_MAX;
-	cpumask_clear(to_cpumask(tmpmask));
+	cpumask_clear(tmpmask);
 	now = ktime_get();
 	/* Find all expired events */
-	for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
+	for_each_cpu(cpu, tick_broadcast_oneshot_mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
-		if (td->evtdev->next_event.tv64 <= now.tv64)
-			cpumask_set_cpu(cpu, to_cpumask(tmpmask));
-		else if (td->evtdev->next_event.tv64 < next_event.tv64)
+		if (td->evtdev->next_event.tv64 <= now.tv64) {
+			cpumask_set_cpu(cpu, tmpmask);
+			/*
+			 * Mark the remote cpu in the pending mask, so
+			 * it can avoid reprogramming the cpu local
+			 * timer in tick_broadcast_oneshot_control().
+			 */
+			cpumask_set_cpu(cpu, tick_broadcast_pending_mask);
+		} else if (td->evtdev->next_event.tv64 < next_event.tv64) {
 			next_event.tv64 = td->evtdev->next_event.tv64;
+			next_cpu = cpu;
+		}
 	}
 
+	/* Take care of enforced broadcast requests */
+	cpumask_or(tmpmask, tmpmask, tick_broadcast_force_mask);
+	cpumask_clear(tick_broadcast_force_mask);
+
 	/*
 	 * Wakeup the cpus which have an expired event.
 	 */
-	tick_do_broadcast(to_cpumask(tmpmask));
+	tick_do_broadcast(tmpmask);
 
 	/*
 	 * Two reasons for reprogram:
@@ -480,7 +535,7 @@ again:
 		 * Rearm the broadcast device. If event expired,
 		 * repeat the above
 		 */
-		if (tick_broadcast_set_event(next_event, 0))
+		if (tick_broadcast_set_event(dev, next_cpu, next_event, 0))
 			goto again;
 	}
 	raw_spin_unlock(&tick_broadcast_lock);
@@ -495,6 +550,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags;
+	ktime_t now;
 	int cpu;
 
 	/*
@@ -519,21 +575,84 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
-		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
-			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
+		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
+		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
-			if (dev->next_event.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(dev->next_event, 1);
+			/*
+			 * We only reprogram the broadcast timer if we
+			 * did not mark ourself in the force mask and
+			 * if the cpu local event is earlier than the
+			 * broadcast event. If the current CPU is in
+			 * the force mask, then we are going to be
+			 * woken by the IPI right away.
+			 */
+			if (!cpumask_test_cpu(cpu, tick_broadcast_force_mask) &&
+			    dev->next_event.tv64 < bc->next_event.tv64)
+				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
 		}
 	} else {
-		if (cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
-			cpumask_clear_cpu(cpu,
-					  tick_get_broadcast_oneshot_mask());
+		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-			if (dev->next_event.tv64 != KTIME_MAX)
-				tick_program_event(dev->next_event, 1);
+			if (dev->next_event.tv64 == KTIME_MAX)
+				goto out;
+			/*
+			 * The cpu which was handling the broadcast
+			 * timer marked this cpu in the broadcast
+			 * pending mask and fired the broadcast
+			 * IPI. So we are going to handle the expired
+			 * event anyway via the broadcast IPI
+			 * handler. No need to reprogram the timer
+			 * with an already expired event.
+			 */
+			if (cpumask_test_and_clear_cpu(cpu,
+				       tick_broadcast_pending_mask))
+				goto out;
+
+			/*
+			 * If the pending bit is not set, then we are
+			 * either the CPU handling the broadcast
+			 * interrupt or we got woken by something else.
+			 *
+			 * We are not longer in the broadcast mask, so
+			 * if the cpu local expiry time is already
+			 * reached, we would reprogram the cpu local
+			 * timer with an already expired event.
+			 *
+			 * This can lead to a ping-pong when we return
+			 * to idle and therefor rearm the broadcast
+			 * timer before the cpu local timer was able
+			 * to fire. This happens because the forced
+			 * reprogramming makes sure that the event
+			 * will happen in the future and depending on
+			 * the min_delta setting this might be far
+			 * enough out that the ping-pong starts.
+			 *
+			 * If the cpu local next_event has expired
+			 * then we know that the broadcast timer
+			 * next_event has expired as well and
+			 * broadcast is about to be handled. So we
+			 * avoid reprogramming and enforce that the
+			 * broadcast handler, which did not run yet,
+			 * will invoke the cpu local handler.
+			 *
+			 * We cannot call the handler directly from
+			 * here, because we might be in a NOHZ phase
+			 * and we did not go through the irq_enter()
+			 * nohz fixups.
+			 */
+			now = ktime_get();
+			if (dev->next_event.tv64 <= now.tv64) {
+				cpumask_set_cpu(cpu, tick_broadcast_force_mask);
+				goto out;
+			}
+			/*
+			 * We got woken by something else. Reprogram
+			 * the cpu local timer device.
+			 */
+			tick_program_event(dev->next_event, 1);
 		}
 	}
+out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
@@ -544,7 +663,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
  */
 static void tick_broadcast_clear_oneshot(int cpu)
 {
-	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
+	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
 }
 
 static void tick_broadcast_init_next_event(struct cpumask *mask,
@@ -582,17 +701,16 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		 * oneshot_mask bits for those and program the
 		 * broadcast device to fire.
 		 */
-		cpumask_copy(to_cpumask(tmpmask), tick_get_broadcast_mask());
-		cpumask_clear_cpu(cpu, to_cpumask(tmpmask));
-		cpumask_or(tick_get_broadcast_oneshot_mask(),
-			   tick_get_broadcast_oneshot_mask(),
-			   to_cpumask(tmpmask));
+		cpumask_copy(tmpmask, tick_broadcast_mask);
+		cpumask_clear_cpu(cpu, tmpmask);
+		cpumask_or(tick_broadcast_oneshot_mask,
+			   tick_broadcast_oneshot_mask, tmpmask);
 
-		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
+		if (was_periodic && !cpumask_empty(tmpmask)) {
 			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-			tick_broadcast_init_next_event(to_cpumask(tmpmask),
+			tick_broadcast_init_next_event(tmpmask,
 						       tick_next_period);
-			tick_broadcast_set_event(tick_next_period, 1);
+			tick_broadcast_set_event(bc, cpu, tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
 	} else {
@@ -640,7 +758,7 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 	 * Clear the broadcast mask flag for the dead cpu, but do not
 	 * stop the broadcast device!
 	 */
-	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
+	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
 
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
@@ -664,3 +782,14 @@ bool tick_broadcast_oneshot_available(void)
 }
 
 #endif
+
+void __init tick_broadcast_init(void)
+{
+	alloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&tmpmask, GFP_NOWAIT);
+#ifdef CONFIG_TICK_ONESHOT
+	alloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);
+#endif
+}
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b1600a6..6176a3e 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -323,6 +323,7 @@ static void tick_shutdown(unsigned int *cpup)
 		 */
 		dev->mode = CLOCK_EVT_MODE_UNUSED;
 		clockevents_exchange_device(dev, NULL);
+		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
 	}
 	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
@@ -416,4 +417,5 @@ static struct notifier_block tick_notifier = {
 void __init tick_init(void)
 {
 	clockevents_register_notifier(&tick_notifier);
+	tick_broadcast_init();
 }
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index cf3e59e..f0299ea 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -4,6 +4,8 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 
+extern seqlock_t jiffies_lock;
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BUILD
 
 #define TICK_DO_TIMER_NONE	-1
@@ -94,7 +96,7 @@ extern void tick_broadcast_on_off(unsigned long reason, int *oncpu);
 extern void tick_shutdown_broadcast(unsigned int *cpup);
 extern void tick_suspend_broadcast(void);
 extern int tick_resume_broadcast(void);
-
+extern void tick_broadcast_init(void);
 extern void
 tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
 
@@ -119,6 +121,7 @@ static inline void tick_broadcast_on_off(unsigned long reason, int *oncpu) { }
 static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
 static inline void tick_suspend_broadcast(void) { }
 static inline int tick_resume_broadcast(void) { return 0; }
+static inline void tick_broadcast_init(void) { }
 
 /*
  * Set the periodic handler in non broadcast mode
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a19a399..225f8bf 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -482,8 +482,8 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 
 		if (ratelimit < 10 &&
 		    (local_softirq_pending() & SOFTIRQ_STOP_IDLE_MASK)) {
-			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-			       (unsigned int) local_softirq_pending());
+			pr_warn("NOHZ: local_softirq_pending %02x\n",
+				(unsigned int) local_softirq_pending());
 			ratelimit++;
 		}
 		return false;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 9a0bc98..98cd470 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -23,8 +23,13 @@
 #include <linux/stop_machine.h>
 #include <linux/pvclock_gtod.h>
 
+#include "tick-internal.h"
+#include "ntp_internal.h"
 
 static struct timekeeper timekeeper;
+static DEFINE_RAW_SPINLOCK(timekeeper_lock);
+static seqcount_t timekeeper_seq;
+static struct timekeeper shadow_timekeeper;
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
@@ -67,6 +72,7 @@ static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
 	tk->wall_to_monotonic = wtm;
 	set_normalized_timespec(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
 	tk->offs_real = timespec_to_ktime(tmp);
+	tk->offs_tai = ktime_sub(tk->offs_real, ktime_set(tk->tai_offset, 0));
 }
 
 static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
@@ -96,7 +102,7 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 
 	old_clock = tk->clock;
 	tk->clock = clock;
-	clock->cycle_last = clock->read(clock);
+	tk->cycle_last = clock->cycle_last = clock->read(clock);
 
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
@@ -201,8 +207,6 @@ static void update_pvclock_gtod(struct timekeeper *tk)
 
 /**
  * pvclock_gtod_register_notifier - register a pvclock timedata update listener
- *
- * Must hold write on timekeeper.lock
  */
 int pvclock_gtod_register_notifier(struct notifier_block *nb)
 {
@@ -210,11 +214,10 @@ int pvclock_gtod_register_notifier(struct notifier_block *nb)
 	unsigned long flags;
 	int ret;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	ret = raw_notifier_chain_register(&pvclock_gtod_chain, nb);
-	/* update timekeeping data */
 	update_pvclock_gtod(tk);
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
 }
@@ -223,25 +226,22 @@ EXPORT_SYMBOL_GPL(pvclock_gtod_register_notifier);
 /**
  * pvclock_gtod_unregister_notifier - unregister a pvclock
  * timedata update listener
- *
- * Must hold write on timekeeper.lock
  */
 int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
 {
-	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
 	int ret;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	ret = raw_notifier_chain_unregister(&pvclock_gtod_chain, nb);
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 
-/* must hold write on timekeeper.lock */
-static void timekeeping_update(struct timekeeper *tk, bool clearntp)
+/* must hold timekeeper_lock */
+static void timekeeping_update(struct timekeeper *tk, bool clearntp, bool mirror)
 {
 	if (clearntp) {
 		tk->ntp_error = 0;
@@ -249,6 +249,9 @@ static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 	}
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk);
+
+	if (mirror)
+		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
 }
 
 /**
@@ -267,7 +270,7 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 	clock = tk->clock;
 	cycle_now = clock->read(clock);
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-	clock->cycle_last = cycle_now;
+	tk->cycle_last = clock->cycle_last = cycle_now;
 
 	tk->xtime_nsec += cycle_delta * tk->mult;
 
@@ -294,12 +297,12 @@ int __getnstimeofday(struct timespec *ts)
 	s64 nsecs = 0;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 
 		ts->tv_sec = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
@@ -335,11 +338,11 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 		secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -366,12 +369,12 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	ts->tv_sec += tomono.tv_sec;
 	ts->tv_nsec = 0;
@@ -379,6 +382,50 @@ void ktime_get_ts(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
+
+/**
+ * timekeeping_clocktai - Returns the TAI time of day in a timespec
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec.
+ */
+void timekeeping_clocktai(struct timespec *ts)
+{
+	struct timekeeper *tk = &timekeeper;
+	unsigned long seq;
+	u64 nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqcount_begin(&timekeeper_seq);
+
+		ts->tv_sec = tk->xtime_sec + tk->tai_offset;
+		nsecs = timekeeping_get_ns(tk);
+
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
+
+	ts->tv_nsec = 0;
+	timespec_add_ns(ts, nsecs);
+
+}
+EXPORT_SYMBOL(timekeeping_clocktai);
+
+
+/**
+ * ktime_get_clocktai - Returns the TAI time of day in a ktime
+ *
+ * Returns the time of day in a ktime.
+ */
+ktime_t ktime_get_clocktai(void)
+{
+	struct timespec ts;
+
+	timekeeping_clocktai(&ts);
+	return timespec_to_ktime(ts);
+}
+EXPORT_SYMBOL(ktime_get_clocktai);
+
 #ifdef CONFIG_NTP_PPS
 
 /**
@@ -399,7 +446,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 	WARN_ON_ONCE(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 
 		*ts_raw = tk->raw_time;
 		ts_real->tv_sec = tk->xtime_sec;
@@ -408,7 +455,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw = timekeeping_get_ns_raw(tk);
 		nsecs_real = timekeeping_get_ns(tk);
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -448,7 +495,8 @@ int do_settimeofday(const struct timespec *tv)
 	if (!timespec_valid_strict(tv))
 		return -EINVAL;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
 
 	timekeeping_forward_now(tk);
 
@@ -460,9 +508,10 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, true);
+	timekeeping_update(tk, true, true);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -487,7 +536,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
 
 	timekeeping_forward_now(tk);
 
@@ -502,9 +552,10 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, true);
+	timekeeping_update(tk, true, true);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -513,6 +564,52 @@ error: /* even if we error out, we forwarded the time, so call update */
 }
 EXPORT_SYMBOL(timekeeping_inject_offset);
 
+
+/**
+ * timekeeping_get_tai_offset - Returns current TAI offset from UTC
+ *
+ */
+s32 timekeeping_get_tai_offset(void)
+{
+	struct timekeeper *tk = &timekeeper;
+	unsigned int seq;
+	s32 ret;
+
+	do {
+		seq = read_seqcount_begin(&timekeeper_seq);
+		ret = tk->tai_offset;
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
+
+	return ret;
+}
+
+/**
+ * __timekeeping_set_tai_offset - Lock free worker function
+ *
+ */
+static void __timekeeping_set_tai_offset(struct timekeeper *tk, s32 tai_offset)
+{
+	tk->tai_offset = tai_offset;
+	tk->offs_tai = ktime_sub(tk->offs_real, ktime_set(tai_offset, 0));
+}
+
+/**
+ * timekeeping_set_tai_offset - Sets the current TAI offset from UTC
+ *
+ */
+void timekeeping_set_tai_offset(s32 tai_offset)
+{
+	struct timekeeper *tk = &timekeeper;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
+	__timekeeping_set_tai_offset(tk, tai_offset);
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+	clock_was_set();
+}
+
 /**
  * change_clocksource - Swaps clocksources if a new one is available
  *
@@ -526,7 +623,8 @@ static int change_clocksource(void *data)
 
 	new = (struct clocksource *) data;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
 
 	timekeeping_forward_now(tk);
 	if (!new->enable || new->enable(new) == 0) {
@@ -535,9 +633,10 @@ static int change_clocksource(void *data)
 		if (old->disable)
 			old->disable(old);
 	}
-	timekeeping_update(tk, true);
+	timekeeping_update(tk, true, true);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return 0;
 }
@@ -587,11 +686,11 @@ void getrawmonotonic(struct timespec *ts)
 	s64 nsecs;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 		nsecs = timekeeping_get_ns_raw(tk);
 		*ts = tk->raw_time;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -607,11 +706,11 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 
 		ret = tk->clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	return ret;
 }
@@ -626,11 +725,11 @@ u64 timekeeping_max_deferment(void)
 	u64 ret;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 
 		ret = tk->clock->max_idle_ns;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	return ret;
 }
@@ -693,11 +792,10 @@ void __init timekeeping_init(void)
 		boot.tv_nsec = 0;
 	}
 
-	seqlock_init(&tk->lock);
-
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
 	ntp_init();
 
-	write_seqlock_irqsave(&tk->lock, flags);
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
@@ -716,7 +814,10 @@ void __init timekeeping_init(void)
 	tmp.tv_nsec = 0;
 	tk_set_sleep_time(tk, tmp);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
+
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
 /* time in seconds when suspend began */
@@ -764,15 +865,17 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	if (has_persistent_clock())
 		return;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
 
 	timekeeping_forward_now(tk);
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, true);
+	timekeeping_update(tk, true, true);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -788,26 +891,72 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 static void timekeeping_resume(void)
 {
 	struct timekeeper *tk = &timekeeper;
+	struct clocksource *clock = tk->clock;
 	unsigned long flags;
-	struct timespec ts;
+	struct timespec ts_new, ts_delta;
+	cycle_t cycle_now, cycle_delta;
+	bool suspendtime_found = false;
 
-	read_persistent_clock(&ts);
+	read_persistent_clock(&ts_new);
 
 	clockevents_resume();
 	clocksource_resume();
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
+
+	/*
+	 * After system resumes, we need to calculate the suspended time and
+	 * compensate it for the OS time. There are 3 sources that could be
+	 * used: Nonstop clocksource during suspend, persistent clock and rtc
+	 * device.
+	 *
+	 * One specific platform may have 1 or 2 or all of them, and the
+	 * preference will be:
+	 *	suspend-nonstop clocksource -> persistent clock -> rtc
+	 * The less preferred source will only be tried if there is no better
+	 * usable source. The rtc part is handled separately in rtc core code.
+	 */
+	cycle_now = clock->read(clock);
+	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NONSTOP) &&
+		cycle_now > clock->cycle_last) {
+		u64 num, max = ULLONG_MAX;
+		u32 mult = clock->mult;
+		u32 shift = clock->shift;
+		s64 nsec = 0;
+
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
-		ts = timespec_sub(ts, timekeeping_suspend_time);
-		__timekeeping_inject_sleeptime(tk, &ts);
+		/*
+		 * "cycle_delta * mutl" may cause 64 bits overflow, if the
+		 * suspended time is too long. In that case we need do the
+		 * 64 bits math carefully
+		 */
+		do_div(max, mult);
+		if (cycle_delta > max) {
+			num = div64_u64(cycle_delta, max);
+			nsec = (((u64) max * mult) >> shift) * num;
+			cycle_delta -= num * max;
+		}
+		nsec += ((u64) cycle_delta * mult) >> shift;
+
+		ts_delta = ns_to_timespec(nsec);
+		suspendtime_found = true;
+	} else if (timespec_compare(&ts_new, &timekeeping_suspend_time) > 0) {
+		ts_delta = timespec_sub(ts_new, timekeeping_suspend_time);
+		suspendtime_found = true;
 	}
-	/* re-base the last cycle value */
-	tk->clock->cycle_last = tk->clock->read(tk->clock);
+
+	if (suspendtime_found)
+		__timekeeping_inject_sleeptime(tk, &ts_delta);
+
+	/* Re-base the last cycle value */
+	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, false);
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	timekeeping_update(tk, false, true);
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -826,7 +975,8 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
 	timekeeping_forward_now(tk);
 	timekeeping_suspended = 1;
 
@@ -849,7 +999,8 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -1099,6 +1250,8 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 			tk_set_wall_to_mono(tk,
 				timespec_sub(tk->wall_to_monotonic, ts));
 
+			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
+
 			clock_was_set_delayed();
 		}
 	}
@@ -1116,15 +1269,16 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 						u32 shift)
 {
+	cycle_t interval = tk->cycle_interval << shift;
 	u64 raw_nsecs;
 
 	/* If the offset is smaller then a shifted interval, do nothing */
-	if (offset < tk->cycle_interval<<shift)
+	if (offset < interval)
 		return offset;
 
 	/* Accumulate one shifted interval */
-	offset -= tk->cycle_interval << shift;
-	tk->clock->cycle_last += tk->cycle_interval << shift;
+	offset -= interval;
+	tk->cycle_last += interval;
 
 	tk->xtime_nsec += tk->xtime_interval << shift;
 	accumulate_nsecs_to_secs(tk);
@@ -1181,27 +1335,28 @@ static inline void old_vsyscall_fixup(struct timekeeper *tk)
 static void update_wall_time(void)
 {
 	struct clocksource *clock;
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *real_tk = &timekeeper;
+	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned long flags;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-	clock = tk->clock;
+	clock = real_tk->clock;
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	offset = tk->cycle_interval;
+	offset = real_tk->cycle_interval;
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 
 	/* Check if there's really nothing to do */
-	if (offset < tk->cycle_interval)
+	if (offset < real_tk->cycle_interval)
 		goto out;
 
 	/*
@@ -1238,11 +1393,24 @@ static void update_wall_time(void)
 	 */
 	accumulate_nsecs_to_secs(tk);
 
-	timekeeping_update(tk, false);
-
+	write_seqcount_begin(&timekeeper_seq);
+	/* Update clock->cycle_last with the new value */
+	clock->cycle_last = tk->cycle_last;
+	/*
+	 * Update the real timekeeper.
+	 *
+	 * We could avoid this memcpy by switching pointers, but that
+	 * requires changes to all other timekeeper usage sites as
+	 * well, i.e. move the timekeeper pointer getter into the
+	 * spinlocked/seqcount protected sections. And we trade this
+	 * memcpy under the timekeeper_seq against one before we start
+	 * updating.
+	 */
+	memcpy(real_tk, tk, sizeof(*tk));
+	timekeeping_update(real_tk, false, false);
+	write_seqcount_end(&timekeeper_seq);
 out:
-	write_sequnlock_irqrestore(&tk->lock, flags);
-
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
 /**
@@ -1289,13 +1457,13 @@ void get_monotonic_boottime(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 		sleep = tk->total_sleep_time;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
 	ts->tv_nsec = 0;
@@ -1354,10 +1522,10 @@ struct timespec current_kernel_time(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 
 		now = tk_xtime(tk);
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	return now;
 }
@@ -1370,11 +1538,11 @@ struct timespec get_monotonic_coarse(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 
 		now = tk_xtime(tk);
 		mono = tk->wall_to_monotonic;
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1405,11 +1573,11 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 		*xtim = tk_xtime(tk);
 		*wtom = tk->wall_to_monotonic;
 		*sleep = tk->total_sleep_time;
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
@@ -1421,7 +1589,8 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
  * Returns current monotonic time and updates the offsets
  * Called from hrtimer_interupt() or retrigger_next_event()
  */
-ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot)
+ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
+							ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &timekeeper;
 	ktime_t now;
@@ -1429,14 +1598,15 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot)
 	u64 secs, nsecs;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 
 		secs = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
 
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
-	} while (read_seqretry(&tk->lock, seq));
+		*offs_tai = tk->offs_tai;
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
 	now = ktime_sub(now, *offs_real);
@@ -1454,15 +1624,79 @@ ktime_t ktime_get_monotonic_offset(void)
 	struct timespec wtom;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqcount_begin(&timekeeper_seq);
 		wtom = tk->wall_to_monotonic;
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	return timespec_to_ktime(wtom);
 }
 EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
 
 /**
+ * do_adjtimex() - Accessor function to NTP __do_adjtimex function
+ */
+int do_adjtimex(struct timex *txc)
+{
+	struct timekeeper *tk = &timekeeper;
+	unsigned long flags;
+	struct timespec ts;
+	s32 orig_tai, tai;
+	int ret;
+
+	/* Validate the data before disabling interrupts */
+	ret = ntp_validate_timex(txc);
+	if (ret)
+		return ret;
+
+	if (txc->modes & ADJ_SETOFFSET) {
+		struct timespec delta;
+		delta.tv_sec  = txc->time.tv_sec;
+		delta.tv_nsec = txc->time.tv_usec;
+		if (!(txc->modes & ADJ_NANO))
+			delta.tv_nsec *= 1000;
+		ret = timekeeping_inject_offset(&delta);
+		if (ret)
+			return ret;
+	}
+
+	getnstimeofday(&ts);
+
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
+
+	orig_tai = tai = tk->tai_offset;
+	ret = __do_adjtimex(txc, &ts, &tai);
+
+	if (tai != orig_tai) {
+		__timekeeping_set_tai_offset(tk, tai);
+		clock_was_set_delayed();
+	}
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+
+	return ret;
+}
+
+#ifdef CONFIG_NTP_PPS
+/**
+ * hardpps() - Accessor function to NTP __hardpps function
+ */
+void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
+
+	__hardpps(phase_ts, raw_ts);
+
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+}
+EXPORT_SYMBOL(hardpps);
+#endif
+
+/**
  * xtime_update() - advances the timekeeping infrastructure
  * @ticks:	number of ticks, that have elapsed since the last call.
  *
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index af5a7e9..3bdf283 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -20,6 +20,13 @@
 
 #include <asm/uaccess.h>
 
+
+struct timer_list_iter {
+	int cpu;
+	bool second_pass;
+	u64 now;
+};
+
 typedef void (*print_fn_t)(struct seq_file *m, unsigned int *classes);
 
 DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
@@ -133,7 +140,6 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	SEQ_printf(m, "\n");
 	SEQ_printf(m, "cpu: %d\n", cpu);
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		SEQ_printf(m, " clock %d:\n", i);
@@ -187,6 +193,7 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 
 #undef P
 #undef P_ns
+	SEQ_printf(m, "\n");
 }
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
@@ -195,7 +202,6 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 {
 	struct clock_event_device *dev = td->evtdev;
 
-	SEQ_printf(m, "\n");
 	SEQ_printf(m, "Tick Device: mode:     %d\n", td->mode);
 	if (cpu < 0)
 		SEQ_printf(m, "Broadcast device\n");
@@ -230,12 +236,11 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 	print_name_offset(m, dev->event_handler);
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, " retries:        %lu\n", dev->retries);
+	SEQ_printf(m, "\n");
 }
 
-static void timer_list_show_tickdevices(struct seq_file *m)
+static void timer_list_show_tickdevices_header(struct seq_file *m)
 {
-	int cpu;
-
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 	print_tickdevice(m, tick_get_broadcast_device(), -1);
 	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
@@ -246,47 +251,104 @@ static void timer_list_show_tickdevices(struct seq_file *m)
 #endif
 	SEQ_printf(m, "\n");
 #endif
-	for_each_online_cpu(cpu)
-		print_tickdevice(m, tick_get_device(cpu), cpu);
-	SEQ_printf(m, "\n");
 }
-#else
-static void timer_list_show_tickdevices(struct seq_file *m) { }
 #endif
 
+static inline void timer_list_header(struct seq_file *m, u64 now)
+{
+	SEQ_printf(m, "Timer List Version: v0.7\n");
+	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
+	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+	SEQ_printf(m, "\n");
+}
+
 static int timer_list_show(struct seq_file *m, void *v)
 {
+	struct timer_list_iter *iter = v;
+	u64 now = ktime_to_ns(ktime_get());
+
+	if (iter->cpu == -1 && !iter->second_pass)
+		timer_list_header(m, now);
+	else if (!iter->second_pass)
+		print_cpu(m, iter->cpu, iter->now);
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	else if (iter->cpu == -1 && iter->second_pass)
+		timer_list_show_tickdevices_header(m);
+	else
+		print_tickdevice(m, tick_get_device(iter->cpu), iter->cpu);
+#endif
+	return 0;
+}
+
+void sysrq_timer_list_show(void)
+{
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.7\n");
-	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
-	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+	timer_list_header(NULL, now);
 
 	for_each_online_cpu(cpu)
-		print_cpu(m, cpu, now);
+		print_cpu(NULL, cpu, now);
 
-	SEQ_printf(m, "\n");
-	timer_list_show_tickdevices(m);
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	timer_list_show_tickdevices_header(NULL);
+	for_each_online_cpu(cpu)
+		print_tickdevice(NULL, tick_get_device(cpu), cpu);
+#endif
+	return;
+}
 
-	return 0;
+static void *timer_list_start(struct seq_file *file, loff_t *offset)
+{
+	struct timer_list_iter *iter = file->private;
+
+	if (!*offset) {
+		iter->cpu = -1;
+		iter->now = ktime_to_ns(ktime_get());
+	} else if (iter->cpu >= nr_cpu_ids) {
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+		if (!iter->second_pass) {
+			iter->cpu = -1;
+			iter->second_pass = true;
+		} else
+			return NULL;
+#else
+		return NULL;
+#endif
+	}
+	return iter;
 }
 
-void sysrq_timer_list_show(void)
+static void *timer_list_next(struct seq_file *file, void *v, loff_t *offset)
+{
+	struct timer_list_iter *iter = file->private;
+	iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
+	++*offset;
+	return timer_list_start(file, offset);
+}
+
+static void timer_list_stop(struct seq_file *seq, void *v)
 {
-	timer_list_show(NULL, NULL);
 }
 
+static const struct seq_operations timer_list_sops = {
+	.start = timer_list_start,
+	.next = timer_list_next,
+	.stop = timer_list_stop,
+	.show = timer_list_show,
+};
+
 static int timer_list_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, timer_list_show, NULL);
+	return seq_open_private(filp, &timer_list_sops,
+			sizeof(struct timer_list_iter));
 }
 
 static const struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_release_private,
 };
 
 static int __init init_timer_list_procfs(void)
