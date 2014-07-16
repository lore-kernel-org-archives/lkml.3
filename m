Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaGPVF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:05:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:59907 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaGPVFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:19 -0400
Message-Id: <20140716205057.213349737@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch V2 59/64] timekeeping: Create struct tk_read_base and use it
 in struct timekeeper
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-substruct-timekeeper.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The members of the new struct are the required ones for the new NMI
safe accessor to clcok monotonic. In order to reuse the existing
timekeeping code and to make the update of the fast NMI safe
timekeepers a simple memcpy use the struct for the timekeeper as well
and convert all users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 arch/arm64/kernel/vdso.c            |   10 +-
 arch/s390/kernel/time.c             |   16 ++--
 arch/tile/kernel/time.c             |   10 +-
 arch/x86/kernel/vsyscall_gtod.c     |   23 +++---
 arch/x86/kvm/x86.c                  |   14 +--
 include/linux/timekeeper_internal.h |  103 +++++++++++++++-------------
 kernel/time/timekeeping.c           |  132 ++++++++++++++++++------------------
 7 files changed, 158 insertions(+), 150 deletions(-)

Index: tip/arch/arm64/kernel/vdso.c
===================================================================
--- tip.orig/arch/arm64/kernel/vdso.c
+++ tip/arch/arm64/kernel/vdso.c
@@ -211,7 +211,7 @@ struct vm_area_struct *get_gate_vma(stru
 void update_vsyscall(struct timekeeper *tk)
 {
 	struct timespec xtime_coarse;
-	u32 use_syscall = strcmp(tk->clock->name, "arch_sys_counter");
+	u32 use_syscall = strcmp(tk->tkr.clock->name, "arch_sys_counter");
 
 	++vdso_data->tb_seq_count;
 	smp_wmb();
@@ -224,11 +224,11 @@ void update_vsyscall(struct timekeeper *
 	vdso_data->wtm_clock_nsec		= tk->wall_to_monotonic.tv_nsec;
 
 	if (!use_syscall) {
-		vdso_data->cs_cycle_last	= tk->cycle_last;
+		vdso_data->cs_cycle_last	= tk->tkr.cycle_last;
 		vdso_data->xtime_clock_sec	= tk->xtime_sec;
-		vdso_data->xtime_clock_nsec	= tk->xtime_nsec;
-		vdso_data->cs_mult		= tk->mult;
-		vdso_data->cs_shift		= tk->shift;
+		vdso_data->xtime_clock_nsec	= tk->tkr.xtime_nsec;
+		vdso_data->cs_mult		= tk->tkr.mult;
+		vdso_data->cs_shift		= tk->tkr.shift;
 	}
 
 	smp_wmb();
Index: tip/arch/s390/kernel/time.c
===================================================================
--- tip.orig/arch/s390/kernel/time.c
+++ tip/arch/s390/kernel/time.c
@@ -214,26 +214,26 @@ void update_vsyscall(struct timekeeper *
 {
 	u64 nsecps;
 
-	if (tk->clock != &clocksource_tod)
+	if (tk->tkr.clock != &clocksource_tod)
 		return;
 
 	/* Make userspace gettimeofday spin until we're done. */
 	++vdso_data->tb_update_count;
 	smp_wmb();
-	vdso_data->xtime_tod_stamp = tk->cycle_last;
+	vdso_data->xtime_tod_stamp = tk->tkr.cycle_last;
 	vdso_data->xtime_clock_sec = tk->xtime_sec;
-	vdso_data->xtime_clock_nsec = tk->xtime_nsec;
+	vdso_data->xtime_clock_nsec = tk->tkr.xtime_nsec;
 	vdso_data->wtom_clock_sec =
 		tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
-	vdso_data->wtom_clock_nsec = tk->xtime_nsec +
-		+ ((u64) tk->wall_to_monotonic.tv_nsec << tk->shift);
-	nsecps = (u64) NSEC_PER_SEC << tk->shift;
+	vdso_data->wtom_clock_nsec = tk->tkr.xtime_nsec +
+		+ ((u64) tk->wall_to_monotonic.tv_nsec << tk->tkr.shift);
+	nsecps = (u64) NSEC_PER_SEC << tk->tkr.shift;
 	while (vdso_data->wtom_clock_nsec >= nsecps) {
 		vdso_data->wtom_clock_nsec -= nsecps;
 		vdso_data->wtom_clock_sec++;
 	}
-	vdso_data->tk_mult = tk->mult;
-	vdso_data->tk_shift = tk->shift;
+	vdso_data->tk_mult = tk->tkr.mult;
+	vdso_data->tk_shift = tk->tkr.shift;
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
Index: tip/arch/tile/kernel/time.c
===================================================================
--- tip.orig/arch/tile/kernel/time.c
+++ tip/arch/tile/kernel/time.c
@@ -261,7 +261,7 @@ void update_vsyscall_tz(void)
 void update_vsyscall(struct timekeeper *tk)
 {
 	struct timespec *wtm = &tk->wall_to_monotonic;
-	struct clocksource *clock = tk->clock;
+	struct clocksource *clock = tk->tkr.clock;
 
 	if (clock != &cycle_counter_cs)
 		return;
@@ -269,13 +269,13 @@ void update_vsyscall(struct timekeeper *
 	/* Userspace gettimeofday will spin while this value is odd. */
 	++vdso_data->tb_update_count;
 	smp_wmb();
-	vdso_data->xtime_tod_stamp = tk->cycle_last;
+	vdso_data->xtime_tod_stamp = tk->tkr.cycle_last;
 	vdso_data->xtime_clock_sec = tk->xtime_sec;
-	vdso_data->xtime_clock_nsec = tk->xtime_nsec;
+	vdso_data->xtime_clock_nsec = tk->tkr.xtime_nsec;
 	vdso_data->wtom_clock_sec = wtm->tv_sec;
 	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
-	vdso_data->mult = tk->mult;
-	vdso_data->shift = tk->shift;
+	vdso_data->mult = tk->tkr.mult;
+	vdso_data->shift = tk->tkr.shift;
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
Index: tip/arch/x86/kernel/vsyscall_gtod.c
===================================================================
--- tip.orig/arch/x86/kernel/vsyscall_gtod.c
+++ tip/arch/x86/kernel/vsyscall_gtod.c
@@ -31,29 +31,30 @@ void update_vsyscall(struct timekeeper *
 	gtod_write_begin(vdata);
 
 	/* copy vsyscall data */
-	vdata->vclock_mode	= tk->clock->archdata.vclock_mode;
-	vdata->cycle_last	= tk->cycle_last;
-	vdata->mask		= tk->clock->mask;
-	vdata->mult		= tk->mult;
-	vdata->shift		= tk->shift;
+	vdata->vclock_mode	= tk->tkr.clock->archdata.vclock_mode;
+	vdata->cycle_last	= tk->tkr.cycle_last;
+	vdata->mask		= tk->tkr.mask;
+	vdata->mult		= tk->tkr.mult;
+	vdata->shift		= tk->tkr.shift;
 
 	vdata->wall_time_sec		= tk->xtime_sec;
-	vdata->wall_time_snsec		= tk->xtime_nsec;
+	vdata->wall_time_snsec		= tk->tkr.xtime_nsec;
 
 	vdata->monotonic_time_sec	= tk->xtime_sec
 					+ tk->wall_to_monotonic.tv_sec;
-	vdata->monotonic_time_snsec	= tk->xtime_nsec
+	vdata->monotonic_time_snsec	= tk->tkr.xtime_nsec
 					+ ((u64)tk->wall_to_monotonic.tv_nsec
-						<< tk->shift);
+						<< tk->tkr.shift);
 	while (vdata->monotonic_time_snsec >=
-					(((u64)NSEC_PER_SEC) << tk->shift)) {
+					(((u64)NSEC_PER_SEC) << tk->tkr.shift)) {
 		vdata->monotonic_time_snsec -=
-					((u64)NSEC_PER_SEC) << tk->shift;
+					((u64)NSEC_PER_SEC) << tk->tkr.shift;
 		vdata->monotonic_time_sec++;
 	}
 
 	vdata->wall_time_coarse_sec	= tk->xtime_sec;
-	vdata->wall_time_coarse_nsec	= (long)(tk->xtime_nsec >> tk->shift);
+	vdata->wall_time_coarse_nsec	= (long)(tk->tkr.xtime_nsec >>
+						 tk->tkr.shift);
 
 	vdata->monotonic_time_coarse_sec =
 		vdata->wall_time_coarse_sec + tk->wall_to_monotonic.tv_sec;
Index: tip/arch/x86/kvm/x86.c
===================================================================
--- tip.orig/arch/x86/kvm/x86.c
+++ tip/arch/x86/kvm/x86.c
@@ -995,19 +995,19 @@ static void update_pvclock_gtod(struct t
 	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
 	u64 boot_ns;
 
-	boot_ns = ktime_to_ns(ktime_add(tk->base_mono, tk->offs_boot));
+	boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));
 
 	write_seqcount_begin(&vdata->seq);
 
 	/* copy pvclock gtod data */
-	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
-	vdata->clock.cycle_last		= tk->cycle_last;
-	vdata->clock.mask		= tk->clock->mask;
-	vdata->clock.mult		= tk->mult;
-	vdata->clock.shift		= tk->shift;
+	vdata->clock.vclock_mode	= tk->tkr.clock->archdata.vclock_mode;
+	vdata->clock.cycle_last		= tk->tkr.cycle_last;
+	vdata->clock.mask		= tk->tkr.mask;
+	vdata->clock.mult		= tk->tkr.mult;
+	vdata->clock.shift		= tk->tkr.shift;
 
 	vdata->boot_ns			= boot_ns;
-	vdata->nsec_base		= tk->xtime_nsec;
+	vdata->nsec_base		= tk->tkr.xtime_nsec;
 
 	write_seqcount_end(&vdata->seq);
 }
Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -10,80 +10,87 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 
-/*
- * Structure holding internal timekeeping values.
+/**
+ * struct tk_read_base - base structure for timekeeping readout
+ * @clock:	Current clocksource used for timekeeping.
+ * @read:	Read function of @clock
+ * @mask:	Bitmask for two's complement subtraction of non 64bit clocks
+ * @cycle_last: @clock cycle value at last update
+ * @mult:	NTP adjusted multiplier for scaled math conversion
+ * @shift:	Shift value for scaled math conversion
+ * @xtime_nsec: Shifted (fractional) nano seconds offset for readout
+ * @base_mono:  ktime_t (nanoseconds) base time for readout
  *
- * Note: wall_to_monotonic is what we need to add to xtime (or xtime
- * corrected for sub jiffie times) to get to monotonic time.
- * Monotonic is pegged at zero at system boot time, so
- * wall_to_monotonic will be negative, however, we will ALWAYS keep
- * the tv_nsec part positive so we can use the usual normalization.
+ * This struct has size 56 byte on 64 bit. Together with a seqcount it
+ * occupies a single 64byte cache line.
  *
- * wall_to_monotonic is moved after resume from suspend for the
- * monotonic time not to jump. To calculate the real boot time offset
- * we need to do offs_real - offs_boot.
- *
- * - wall_to_monotonic is no longer the boot time, getboottime must be
- * used instead.
+ * The struct is separate from struct timekeeper as it is also used
+ * for a fast NMI safe accessor to clock monotonic.
  */
-struct timekeeper {
-	/* Current clocksource used for timekeeping. */
+struct tk_read_base {
 	struct clocksource	*clock;
-	/* Read function of @clock */
 	cycle_t			(*read)(struct clocksource *cs);
-	/* Bitmask for two's complement subtraction of non 64bit counters */
 	cycle_t			mask;
-	/* Last cycle value */
 	cycle_t			cycle_last;
-	/* NTP adjusted clock multiplier */
 	u32			mult;
-	/* The shift value of the current clocksource. */
 	u32			shift;
-	/* Clock shifted nano seconds */
 	u64			xtime_nsec;
-
-	/* Monotonic base time */
 	ktime_t			base_mono;
+};
 
-	/* Current CLOCK_REALTIME time in seconds */
+/**
+ * struct timekeeper - Structure holding internal timekeeping values.
+ * @tkr:		The readout base structure
+ * @xtime_sec:		Current CLOCK_REALTIME time in seconds
+ * @wall_to_monotonic:	CLOCK_REALTIME to CLOCK_MONOTONIC offset
+ * @offs_real:		Offset clock monotonic -> clock realtime
+ * @offs_boot:		Offset clock monotonic -> clock boottime
+ * @offs_tai:		Offset clock monotonic -> clock tai
+ * @tai_offset:		The current UTC to TAI offset in seconds
+ * @base_raw:		Monotonic raw base time in ktime_t format
+ * @raw_time:		Monotonic raw base time in timespec64 format
+ * @cycle_interval:	Number of clock cycles in one NTP interval
+ * @xtime_interval:	Number of clock shifted nano seconds in one NTP
+ *			interval.
+ * @xtime_remainder:	Shifted nano seconds left over when rounding
+ *			@cycle_interval
+ * @raw_interval:	Raw nano seconds accumulated per NTP interval.
+ * @ntp_error:		Difference between accumulated time and NTP time in ntp
+ *			shifted nano seconds.
+ * @ntp_error_shift:	Shift conversion between clock shifted nano seconds and
+ *			ntp shifted nano seconds.
+ *
+ * Note: For timespec(64) based interfaces wall_to_monotonic is what
+ * we need to add to xtime (or xtime corrected for sub jiffie times)
+ * to get to monotonic time.  Monotonic is pegged at zero at system
+ * boot time, so wall_to_monotonic will be negative, however, we will
+ * ALWAYS keep the tv_nsec part positive so we can use the usual
+ * normalization.
+ *
+ * wall_to_monotonic is moved after resume from suspend for the
+ * monotonic time not to jump. We need to add total_sleep_time to
+ * wall_to_monotonic to get the real boot based time offset.
+ *
+ * wall_to_monotonic is no longer the boot time, getboottime must be
+ * used instead.
+ */
+struct timekeeper {
+	struct tk_read_base	tkr;
 	u64			xtime_sec;
-	/* CLOCK_REALTIME to CLOCK_MONOTONIC offset */
 	struct timespec64	wall_to_monotonic;
-
-	/* Offset clock monotonic -> clock realtime */
 	ktime_t			offs_real;
-	/* Offset clock monotonic -> clock boottime */
 	ktime_t			offs_boot;
-	/* Offset clock monotonic -> clock tai */
 	ktime_t			offs_tai;
-
-	/* The current UTC to TAI offset in seconds */
 	s32			tai_offset;
-
-	/* Monotonic raw base time */
 	ktime_t			base_raw;
-
-	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec64	raw_time;
 
-	/* Number of clock cycles in one NTP interval. */
+	/* The following members are for timekeeping internal use */
 	cycle_t			cycle_interval;
-	/* Number of clock shifted nano seconds in one NTP interval. */
 	u64			xtime_interval;
-	/* shifted nano seconds left over when rounding cycle_interval */
 	s64			xtime_remainder;
-	/* Raw nano seconds accumulated per NTP interval. */
 	u32			raw_interval;
-
-	/*
-	 * Difference between accumulated time and NTP time in ntp
-	 * shifted nano seconds.
-	 */
 	s64			ntp_error;
-	/*
-	 * Shift conversion between clock shifted nano seconds and
-	 * ntp shifted nano seconds.
-	 */
 	u32			ntp_error_shift;
 };
 
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -52,8 +52,8 @@ bool __read_mostly persistent_clock_exis
 
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
-	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
-		tk->xtime_nsec -= (u64)NSEC_PER_SEC << tk->shift;
+	while (tk->tkr.xtime_nsec >= ((u64)NSEC_PER_SEC << tk->tkr.shift)) {
+		tk->tkr.xtime_nsec -= (u64)NSEC_PER_SEC << tk->tkr.shift;
 		tk->xtime_sec++;
 	}
 }
@@ -63,20 +63,20 @@ static inline struct timespec64 tk_xtime
 	struct timespec64 ts;
 
 	ts.tv_sec = tk->xtime_sec;
-	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
+	ts.tv_nsec = (long)(tk->tkr.xtime_nsec >> tk->tkr.shift);
 	return ts;
 }
 
 static void tk_set_xtime(struct timekeeper *tk, const struct timespec64 *ts)
 {
 	tk->xtime_sec = ts->tv_sec;
-	tk->xtime_nsec = (u64)ts->tv_nsec << tk->shift;
+	tk->tkr.xtime_nsec = (u64)ts->tv_nsec << tk->tkr.shift;
 }
 
 static void tk_xtime_add(struct timekeeper *tk, const struct timespec64 *ts)
 {
 	tk->xtime_sec += ts->tv_sec;
-	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
+	tk->tkr.xtime_nsec += (u64)ts->tv_nsec << tk->tkr.shift;
 	tk_normalize_xtime(tk);
 }
 
@@ -119,11 +119,11 @@ static void tk_setup_internals(struct ti
 	u64 tmp, ntpinterval;
 	struct clocksource *old_clock;
 
-	old_clock = tk->clock;
-	tk->clock = clock;
-	tk->read = clock->read;
-	tk->mask = clock->mask;
-	tk->cycle_last = tk->read(clock);
+	old_clock = tk->tkr.clock;
+	tk->tkr.clock = clock;
+	tk->tkr.read = clock->read;
+	tk->tkr.mask = clock->mask;
+	tk->tkr.cycle_last = tk->tkr.read(clock);
 
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
@@ -147,11 +147,11 @@ static void tk_setup_internals(struct ti
 	if (old_clock) {
 		int shift_change = clock->shift - old_clock->shift;
 		if (shift_change < 0)
-			tk->xtime_nsec >>= -shift_change;
+			tk->tkr.xtime_nsec >>= -shift_change;
 		else
-			tk->xtime_nsec <<= shift_change;
+			tk->tkr.xtime_nsec <<= shift_change;
 	}
-	tk->shift = clock->shift;
+	tk->tkr.shift = clock->shift;
 
 	tk->ntp_error = 0;
 	tk->ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
@@ -161,7 +161,7 @@ static void tk_setup_internals(struct ti
 	 * active clocksource. These value will be adjusted via NTP
 	 * to counteract clock drifting.
 	 */
-	tk->mult = clock->mult;
+	tk->tkr.mult = clock->mult;
 }
 
 /* Timekeeper helper functions. */
@@ -179,13 +179,13 @@ static inline s64 timekeeping_get_ns(str
 	s64 nsec;
 
 	/* read clocksource: */
-	cycle_now = tk->read(tk->clock);
+	cycle_now = tk->tkr.read(tk->tkr.clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, tk->cycle_last, tk->mask);
+	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
 
-	nsec = delta * tk->mult + tk->xtime_nsec;
-	nsec >>= tk->shift;
+	nsec = delta * tk->tkr.mult + tk->tkr.xtime_nsec;
+	nsec >>= tk->tkr.shift;
 
 	/* If arch requires, add in get_arch_timeoffset() */
 	return nsec + arch_gettimeoffset();
@@ -193,15 +193,15 @@ static inline s64 timekeeping_get_ns(str
 
 static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 {
-	struct clocksource *clock = tk->clock;
+	struct clocksource *clock = tk->tkr.clock;
 	cycle_t cycle_now, delta;
 	s64 nsec;
 
 	/* read clocksource: */
-	cycle_now = tk->read(clock);
+	cycle_now = tk->tkr.read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, tk->cycle_last, tk->mask);
+	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
 
 	/* convert delta to nanoseconds. */
 	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
@@ -217,8 +217,8 @@ static inline void update_vsyscall(struc
 	struct timespec xt;
 
 	xt = tk_xtime(tk);
-	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult,
-			    tk->cycle_last);
+	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->tkr.clock, tk->tkr.mult,
+			    tk->tkr.cycle_last);
 }
 
 static inline void old_vsyscall_fixup(struct timekeeper *tk)
@@ -235,11 +235,11 @@ static inline void old_vsyscall_fixup(st
 	* (shifted nanoseconds), and CONFIG_GENERIC_TIME_VSYSCALL_OLD
 	* users are removed, this can be killed.
 	*/
-	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
-	tk->xtime_nsec -= remainder;
-	tk->xtime_nsec += 1ULL << tk->shift;
+	remainder = tk->tkr.xtime_nsec & ((1ULL << tk->tkr.shift) - 1);
+	tk->tkr.xtime_nsec -= remainder;
+	tk->tkr.xtime_nsec += 1ULL << tk->tkr.shift;
 	tk->ntp_error += remainder << tk->ntp_error_shift;
-	tk->ntp_error -= (1ULL << tk->shift) << tk->ntp_error_shift;
+	tk->ntp_error -= (1ULL << tk->tkr.shift) << tk->ntp_error_shift;
 }
 #else
 #define old_vsyscall_fixup(tk)
@@ -304,7 +304,7 @@ static inline void tk_update_ktime_data(
 	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
 	nsec *= NSEC_PER_SEC;
 	nsec += tk->wall_to_monotonic.tv_nsec;
-	tk->base_mono = ns_to_ktime(nsec);
+	tk->tkr.base_mono = ns_to_ktime(nsec);
 
 	/* Update the monotonic raw base */
 	tk->base_raw = timespec64_to_ktime(tk->raw_time);
@@ -336,18 +336,18 @@ static void timekeeping_update(struct ti
  */
 static void timekeeping_forward_now(struct timekeeper *tk)
 {
-	struct clocksource *clock = tk->clock;
+	struct clocksource *clock = tk->tkr.clock;
 	cycle_t cycle_now, delta;
 	s64 nsec;
 
-	cycle_now = tk->read(clock);
-	delta = clocksource_delta(cycle_now, tk->cycle_last, tk->mask);
-	tk->cycle_last = cycle_now;
+	cycle_now = tk->tkr.read(clock);
+	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
+	tk->tkr.cycle_last = cycle_now;
 
-	tk->xtime_nsec += delta * tk->mult;
+	tk->tkr.xtime_nsec += delta * tk->tkr.mult;
 
 	/* If arch requires, add in get_arch_timeoffset() */
-	tk->xtime_nsec += (u64)arch_gettimeoffset() << tk->shift;
+	tk->tkr.xtime_nsec += (u64)arch_gettimeoffset() << tk->tkr.shift;
 
 	tk_normalize_xtime(tk);
 
@@ -412,7 +412,7 @@ ktime_t ktime_get(void)
 
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
-		base = tk->base_mono;
+		base = tk->tkr.base_mono;
 		nsecs = timekeeping_get_ns(tk);
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
@@ -438,7 +438,7 @@ ktime_t ktime_get_with_offset(enum tk_of
 
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
-		base = ktime_add(tk->base_mono, *offset);
+		base = ktime_add(tk->tkr.base_mono, *offset);
 		nsecs = timekeeping_get_ns(tk);
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
@@ -731,7 +731,7 @@ static int change_clocksource(void *data
 	 */
 	if (try_module_get(new->owner)) {
 		if (!new->enable || new->enable(new) == 0) {
-			old = tk->clock;
+			old = tk->tkr.clock;
 			tk_setup_internals(tk, new);
 			if (old->disable)
 				old->disable(old);
@@ -759,11 +759,11 @@ int timekeeping_notify(struct clocksourc
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 
-	if (tk->clock == clock)
+	if (tk->tkr.clock == clock)
 		return 0;
 	stop_machine(change_clocksource, clock, NULL);
 	tick_clock_notify();
-	return tk->clock == clock ? 0 : -1;
+	return tk->tkr.clock == clock ? 0 : -1;
 }
 
 /**
@@ -803,7 +803,7 @@ int timekeeping_valid_for_hres(void)
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 
-		ret = tk->clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
+		ret = tk->tkr.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
@@ -822,7 +822,7 @@ u64 timekeeping_max_deferment(void)
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 
-		ret = tk->clock->max_idle_ns;
+		ret = tk->tkr.clock->max_idle_ns;
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
@@ -989,7 +989,7 @@ void timekeeping_inject_sleeptime(struct
 static void timekeeping_resume(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	struct clocksource *clock = tk->clock;
+	struct clocksource *clock = tk->tkr.clock;
 	unsigned long flags;
 	struct timespec64 ts_new, ts_delta;
 	struct timespec tmp;
@@ -1017,16 +1017,16 @@ static void timekeeping_resume(void)
 	 * The less preferred source will only be tried if there is no better
 	 * usable source. The rtc part is handled separately in rtc core code.
 	 */
-	cycle_now = tk->read(clock);
+	cycle_now = tk->tkr.read(clock);
 	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NONSTOP) &&
-		cycle_now > tk->cycle_last) {
+		cycle_now > tk->tkr.cycle_last) {
 		u64 num, max = ULLONG_MAX;
 		u32 mult = clock->mult;
 		u32 shift = clock->shift;
 		s64 nsec = 0;
 
-		cycle_delta = clocksource_delta(cycle_now, tk->cycle_last,
-						tk->mask);
+		cycle_delta = clocksource_delta(cycle_now, tk->tkr.cycle_last,
+						tk->tkr.mask);
 
 		/*
 		 * "cycle_delta * mutl" may cause 64 bits overflow, if the
@@ -1052,7 +1052,7 @@ static void timekeeping_resume(void)
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
 
 	/* Re-base the last cycle value */
-	tk->cycle_last = cycle_now;
+	tk->tkr.cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
@@ -1239,12 +1239,12 @@ static void timekeeping_adjust(struct ti
 		}
 	}
 
-	if (unlikely(tk->clock->maxadj &&
-		(tk->mult + adj > tk->clock->mult + tk->clock->maxadj))) {
+	if (unlikely(tk->tkr.clock->maxadj &&
+		(tk->tkr.mult + adj > tk->tkr.clock->mult + tk->tkr.clock->maxadj))) {
 		printk_deferred_once(KERN_WARNING
 			"Adjusting %s more than 11%% (%ld vs %ld)\n",
-			tk->clock->name, (long)tk->mult + adj,
-			(long)tk->clock->mult + tk->clock->maxadj);
+			tk->tkr.clock->name, (long)tk->tkr.mult + adj,
+			(long)tk->tkr.clock->mult + tk->tkr.clock->maxadj);
 	}
 	/*
 	 * So the following can be confusing.
@@ -1295,9 +1295,9 @@ static void timekeeping_adjust(struct ti
 	 *
 	 * XXX - TODO: Doc ntp_error calculation.
 	 */
-	tk->mult += adj;
+	tk->tkr.mult += adj;
 	tk->xtime_interval += interval;
-	tk->xtime_nsec -= offset;
+	tk->tkr.xtime_nsec -= offset;
 	tk->ntp_error -= (interval - offset) << tk->ntp_error_shift;
 
 out_adjust:
@@ -1315,9 +1315,9 @@ out_adjust:
 	 * We'll correct this error next time through this function, when
 	 * xtime_nsec is not as small.
 	 */
-	if (unlikely((s64)tk->xtime_nsec < 0)) {
-		s64 neg = -(s64)tk->xtime_nsec;
-		tk->xtime_nsec = 0;
+	if (unlikely((s64)tk->tkr.xtime_nsec < 0)) {
+		s64 neg = -(s64)tk->tkr.xtime_nsec;
+		tk->tkr.xtime_nsec = 0;
 		tk->ntp_error += neg << tk->ntp_error_shift;
 	}
 
@@ -1333,13 +1333,13 @@ out_adjust:
  */
 static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 {
-	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
+	u64 nsecps = (u64)NSEC_PER_SEC << tk->tkr.shift;
 	unsigned int clock_set = 0;
 
-	while (tk->xtime_nsec >= nsecps) {
+	while (tk->tkr.xtime_nsec >= nsecps) {
 		int leap;
 
-		tk->xtime_nsec -= nsecps;
+		tk->tkr.xtime_nsec -= nsecps;
 		tk->xtime_sec++;
 
 		/* Figure out if its a leap sec and apply if needed */
@@ -1384,9 +1384,9 @@ static cycle_t logarithmic_accumulation(
 
 	/* Accumulate one shifted interval */
 	offset -= interval;
-	tk->cycle_last += interval;
+	tk->tkr.cycle_last += interval;
 
-	tk->xtime_nsec += tk->xtime_interval << shift;
+	tk->tkr.xtime_nsec += tk->xtime_interval << shift;
 	*clock_set |= accumulate_nsecs_to_secs(tk);
 
 	/* Accumulate raw time */
@@ -1429,8 +1429,8 @@ void update_wall_time(void)
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = real_tk->cycle_interval;
 #else
-	offset = clocksource_delta(tk->read(tk->clock), tk->cycle_last,
-				   tk->mask);
+	offset = clocksource_delta(tk->tkr.read(tk->tkr.clock),
+				   tk->tkr.cycle_last, tk->tkr.mask);
 #endif
 
 	/* Check if there's really nothing to do */
@@ -1591,8 +1591,8 @@ ktime_t ktime_get_update_offsets_tick(kt
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 
-		base = tk->base_mono;
-		nsecs = tk->xtime_nsec >> tk->shift;
+		base = tk->tkr.base_mono;
+		nsecs = tk->tkr.xtime_nsec >> tk->tkr.shift;
 
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
@@ -1623,7 +1623,7 @@ ktime_t ktime_get_update_offsets_now(kti
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 
-		base = tk->base_mono;
+		base = tk->tkr.base_mono;
 		nsecs = timekeeping_get_ns(tk);
 
 		*offs_real = tk->offs_real;


