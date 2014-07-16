Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaGPVI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:08:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:59893 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaGPVFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:15 -0400
Message-Id: <20140716205057.037617649@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 57/64] clocksource: Get rid of cycle_last
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=clocksource-get-rid-of-cycle-last.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cycle_last was added to the clocksource to support the TSC
validation. We moved that to the core code, so we can get rid of the
extra copy.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm64/kernel/vdso.c            |    2 +-
 arch/ia64/kernel/time.c             |    4 ++--
 arch/powerpc/kernel/time.c          |    4 ++--
 arch/s390/kernel/time.c             |    2 +-
 arch/tile/kernel/time.c             |    2 +-
 arch/x86/kernel/vsyscall_gtod.c     |    2 +-
 arch/x86/kvm/x86.c                  |    2 +-
 include/linux/clocksource.h         |    2 --
 include/linux/timekeeper_internal.h |    7 ++++---
 kernel/time/timekeeping.c           |   23 +++++++++++------------
 10 files changed, 24 insertions(+), 26 deletions(-)

Index: tip/arch/arm64/kernel/vdso.c
===================================================================
--- tip.orig/arch/arm64/kernel/vdso.c
+++ tip/arch/arm64/kernel/vdso.c
@@ -224,7 +224,7 @@ void update_vsyscall(struct timekeeper *
 	vdso_data->wtm_clock_nsec		= tk->wall_to_monotonic.tv_nsec;
 
 	if (!use_syscall) {
-		vdso_data->cs_cycle_last	= tk->clock->cycle_last;
+		vdso_data->cs_cycle_last	= tk->cycle_last;
 		vdso_data->xtime_clock_sec	= tk->xtime_sec;
 		vdso_data->xtime_clock_nsec	= tk->xtime_nsec;
 		vdso_data->cs_mult		= tk->mult;
Index: tip/arch/ia64/kernel/time.c
===================================================================
--- tip.orig/arch/ia64/kernel/time.c
+++ tip/arch/ia64/kernel/time.c
@@ -441,7 +441,7 @@ void update_vsyscall_tz(void)
 }
 
 void update_vsyscall_old(struct timespec *wall, struct timespec *wtm,
-			struct clocksource *c, u32 mult)
+			 struct clocksource *c, u32 mult, cycles_t cycle_last)
 {
 	write_seqcount_begin(&fsyscall_gtod_data.seq);
 
@@ -450,7 +450,7 @@ void update_vsyscall_old(struct timespec
         fsyscall_gtod_data.clk_mult = mult;
         fsyscall_gtod_data.clk_shift = c->shift;
         fsyscall_gtod_data.clk_fsys_mmio = c->archdata.fsys_mmio;
-        fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
+        fsyscall_gtod_data.clk_cycle_last = cycle_last;
 
 	/* copy kernel time structures */
         fsyscall_gtod_data.wall_time.tv_sec = wall->tv_sec;
Index: tip/arch/powerpc/kernel/time.c
===================================================================
--- tip.orig/arch/powerpc/kernel/time.c
+++ tip/arch/powerpc/kernel/time.c
@@ -741,7 +741,7 @@ static cycle_t timebase_read(struct cloc
 }
 
 void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
-			struct clocksource *clock, u32 mult)
+			 struct clocksource *clock, u32 mult, cycle_t cycle_last)
 {
 	u64 new_tb_to_xs, new_stamp_xsec;
 	u32 frac_sec;
@@ -774,7 +774,7 @@ void update_vsyscall_old(struct timespec
 	 * We expect the caller to have done the first increment of
 	 * vdso_data->tb_update_count already.
 	 */
-	vdso_data->tb_orig_stamp = clock->cycle_last;
+	vdso_data->tb_orig_stamp = cycle_last;
 	vdso_data->stamp_xsec = new_stamp_xsec;
 	vdso_data->tb_to_xs = new_tb_to_xs;
 	vdso_data->wtom_clock_sec = wtm->tv_sec;
Index: tip/arch/s390/kernel/time.c
===================================================================
--- tip.orig/arch/s390/kernel/time.c
+++ tip/arch/s390/kernel/time.c
@@ -220,7 +220,7 @@ void update_vsyscall(struct timekeeper *
 	/* Make userspace gettimeofday spin until we're done. */
 	++vdso_data->tb_update_count;
 	smp_wmb();
-	vdso_data->xtime_tod_stamp = tk->clock->cycle_last;
+	vdso_data->xtime_tod_stamp = tk->cycle_last;
 	vdso_data->xtime_clock_sec = tk->xtime_sec;
 	vdso_data->xtime_clock_nsec = tk->xtime_nsec;
 	vdso_data->wtom_clock_sec =
Index: tip/arch/tile/kernel/time.c
===================================================================
--- tip.orig/arch/tile/kernel/time.c
+++ tip/arch/tile/kernel/time.c
@@ -269,7 +269,7 @@ void update_vsyscall(struct timekeeper *
 	/* Userspace gettimeofday will spin while this value is odd. */
 	++vdso_data->tb_update_count;
 	smp_wmb();
-	vdso_data->xtime_tod_stamp = clock->cycle_last;
+	vdso_data->xtime_tod_stamp = tk->cycle_last;
 	vdso_data->xtime_clock_sec = tk->xtime_sec;
 	vdso_data->xtime_clock_nsec = tk->xtime_nsec;
 	vdso_data->wtom_clock_sec = wtm->tv_sec;
Index: tip/arch/x86/kernel/vsyscall_gtod.c
===================================================================
--- tip.orig/arch/x86/kernel/vsyscall_gtod.c
+++ tip/arch/x86/kernel/vsyscall_gtod.c
@@ -32,7 +32,7 @@ void update_vsyscall(struct timekeeper *
 
 	/* copy vsyscall data */
 	vdata->vclock_mode	= tk->clock->archdata.vclock_mode;
-	vdata->cycle_last	= tk->clock->cycle_last;
+	vdata->cycle_last	= tk->cycle_last;
 	vdata->mask		= tk->clock->mask;
 	vdata->mult		= tk->mult;
 	vdata->shift		= tk->shift;
Index: tip/arch/x86/kvm/x86.c
===================================================================
--- tip.orig/arch/x86/kvm/x86.c
+++ tip/arch/x86/kvm/x86.c
@@ -1001,7 +1001,7 @@ static void update_pvclock_gtod(struct t
 
 	/* copy pvclock gtod data */
 	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
-	vdata->clock.cycle_last		= tk->clock->cycle_last;
+	vdata->clock.cycle_last		= tk->cycle_last;
 	vdata->clock.mask		= tk->clock->mask;
 	vdata->clock.mult		= tk->mult;
 	vdata->clock.shift		= tk->shift;
Index: tip/include/linux/clocksource.h
===================================================================
--- tip.orig/include/linux/clocksource.h
+++ tip/include/linux/clocksource.h
@@ -162,7 +162,6 @@ extern u64 timecounter_cyc2time(struct t
  * @archdata:		arch-specific data
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
- * @cycle_last:		most recent cycle counter value seen by ::read()
  * @owner:		module reference, must be set by clocksource in modules
  */
 struct clocksource {
@@ -171,7 +170,6 @@ struct clocksource {
 	 * clocksource itself is cacheline aligned.
 	 */
 	cycle_t (*read)(struct clocksource *cs);
-	cycle_t cycle_last;
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -29,6 +29,8 @@
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
 	struct clocksource	*clock;
+	/* Last cycle value */
+	cycle_t			cycle_last;
 	/* NTP adjusted clock multiplier */
 	u32			mult;
 	/* The shift value of the current clocksource. */
@@ -62,8 +64,6 @@ struct timekeeper {
 
 	/* Number of clock cycles in one NTP interval. */
 	cycle_t			cycle_interval;
-	/* Last cycle value (also stored in clock->cycle_last) */
-	cycle_t			cycle_last;
 	/* Number of clock shifted nano seconds in one NTP interval. */
 	u64			xtime_interval;
 	/* shifted nano seconds left over when rounding cycle_interval */
@@ -91,7 +91,8 @@ extern void update_vsyscall_tz(void);
 #elif defined(CONFIG_GENERIC_TIME_VSYSCALL_OLD)
 
 extern void update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
-				struct clocksource *c, u32 mult);
+				struct clocksource *c, u32 mult,
+				cycles_t cycle_last);
 extern void update_vsyscall_tz(void);
 
 #else
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -121,7 +121,7 @@ static void tk_setup_internals(struct ti
 
 	old_clock = tk->clock;
 	tk->clock = clock;
-	tk->cycle_last = clock->cycle_last = clock->read(clock);
+	tk->cycle_last = clock->read(clock);
 
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
@@ -182,7 +182,7 @@ static inline s64 timekeeping_get_ns(str
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, clock->cycle_last, clock->mask);
+	delta = clocksource_delta(cycle_now, tk->cycle_last, clock->mask);
 
 	nsec = delta * tk->mult + tk->xtime_nsec;
 	nsec >>= tk->shift;
@@ -202,7 +202,7 @@ static inline s64 timekeeping_get_ns_raw
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, clock->cycle_last, clock->mask);
+	delta = clocksource_delta(cycle_now, tk->cycle_last, clock->mask);
 
 	/* convert delta to nanoseconds. */
 	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
@@ -218,7 +218,8 @@ static inline void update_vsyscall(struc
 	struct timespec xt;
 
 	xt = tk_xtime(tk);
-	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
+	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult,
+			    tk->cycle_last);
 }
 
 static inline void old_vsyscall_fixup(struct timekeeper *tk)
@@ -342,8 +343,8 @@ static void timekeeping_forward_now(stru
 
 	clock = tk->clock;
 	cycle_now = clock->read(clock);
-	delta = clocksource_delta(cycle_now, clock->cycle_last, clock->mask);
-	tk->cycle_last = clock->cycle_last = cycle_now;
+	delta = clocksource_delta(cycle_now, tk->cycle_last, clock->mask);
+	tk->cycle_last = cycle_now;
 
 	tk->xtime_nsec += delta * tk->mult;
 
@@ -1020,13 +1021,13 @@ static void timekeeping_resume(void)
 	 */
 	cycle_now = clock->read(clock);
 	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NONSTOP) &&
-		cycle_now > clock->cycle_last) {
+		cycle_now > tk->cycle_last) {
 		u64 num, max = ULLONG_MAX;
 		u32 mult = clock->mult;
 		u32 shift = clock->shift;
 		s64 nsec = 0;
 
-		cycle_delta = clocksource_delta(cycle_now, clock->cycle_last,
+		cycle_delta = clocksource_delta(cycle_now, tk->cycle_last,
 						clock->mask);
 
 		/*
@@ -1053,7 +1054,7 @@ static void timekeeping_resume(void)
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
 
 	/* Re-base the last cycle value */
-	tk->cycle_last = clock->cycle_last = cycle_now;
+	tk->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
@@ -1433,7 +1434,7 @@ void update_wall_time(void)
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = real_tk->cycle_interval;
 #else
-	offset = clocksource_delta(clock->read(clock), clock->cycle_last,
+	offset = clocksource_delta(clock->read(clock), tk->cycle_last,
 				   clock->mask);
 #endif
 
@@ -1477,8 +1478,6 @@ void update_wall_time(void)
 	clock_set |= accumulate_nsecs_to_secs(tk);
 
 	write_seqcount_begin(&tk_core.seq);
-	/* Update clock->cycle_last with the new value */
-	clock->cycle_last = tk->cycle_last;
 	/*
 	 * Update the real timekeeper.
 	 *


