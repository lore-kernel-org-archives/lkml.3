Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaGPVUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:20:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:59642 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaGPVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:09 -0400
Message-Id: <20140716205053.264227935@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 13/64] timekeeping: Cache optimize struct timekeeper
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-optimize-cache-layout.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct timekeeper is quite badly sorted for the hot readout path. Most
time access functions need to load two cache lines.

Rearrange it so ktime_get() and getnstimeofday() are happy with a
single cache line.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |   84 ++++++++--------
 kernel/time/timekeeping.c           |  185 ++++++++++++++++++------------------
 2 files changed, 143 insertions(+), 126 deletions(-)

Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -10,7 +10,22 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 
-/* Structure holding internal timekeeping values. */
+/*
+ * Structure holding internal timekeeping values.
+ *
+ * Note: wall_to_monotonic is what we need to add to xtime (or xtime
+ * corrected for sub jiffie times) to get to monotonic time.
+ * Monotonic is pegged at zero at system boot time, so
+ * wall_to_monotonic will be negative, however, we will ALWAYS keep
+ * the tv_nsec part positive so we can use the usual normalization.
+ *
+ * wall_to_monotonic is moved after resume from suspend for the
+ * monotonic time not to jump. We need to add total_sleep_time to
+ * wall_to_monotonic to get the real boot based time offset.
+ *
+ * - wall_to_monotonic is no longer the boot time, getboottime must be
+ * used instead.
+ */
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
 	struct clocksource	*clock;
@@ -18,6 +33,29 @@ struct timekeeper {
 	u32			mult;
 	/* The shift value of the current clocksource. */
 	u32			shift;
+	/* Clock shifted nano seconds */
+	u64			xtime_nsec;
+
+	/* Current CLOCK_REALTIME time in seconds */
+	u64			xtime_sec;
+	/* CLOCK_REALTIME to CLOCK_MONOTONIC offset */
+	struct timespec64	wall_to_monotonic;
+
+	/* Offset clock monotonic -> clock realtime */
+	ktime_t			offs_real;
+	/* Offset clock monotonic -> clock boottime */
+	ktime_t			offs_boot;
+	/* Offset clock monotonic -> clock tai */
+	ktime_t			offs_tai;
+
+	/* time spent in suspend */
+	struct timespec64	total_sleep_time;
+	/* The current UTC to TAI offset in seconds */
+	s32			tai_offset;
+
+	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
+	struct timespec64	raw_time;
+
 	/* Number of clock cycles in one NTP interval. */
 	cycle_t			cycle_interval;
 	/* Last cycle value (also stored in clock->cycle_last) */
@@ -29,46 +67,16 @@ struct timekeeper {
 	/* Raw nano seconds accumulated per NTP interval. */
 	u32			raw_interval;
 
-	/* Current CLOCK_REALTIME time in seconds */
-	u64			xtime_sec;
-	/* Clock shifted nano seconds */
-	u64			xtime_nsec;
-
-	/* Difference between accumulated time and NTP time in ntp
-	 * shifted nano seconds. */
+	/*
+	 * Difference between accumulated time and NTP time in ntp
+	 * shifted nano seconds.
+	 */
 	s64			ntp_error;
-	/* Shift conversion between clock shifted nano seconds and
-	 * ntp shifted nano seconds. */
-	u32			ntp_error_shift;
-
 	/*
-	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
-	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
-	 * at zero at system boot time, so wall_to_monotonic will be negative,
-	 * however, we will ALWAYS keep the tv_nsec part positive so we can use
-	 * the usual normalization.
-	 *
-	 * wall_to_monotonic is moved after resume from suspend for the
-	 * monotonic time not to jump. We need to add total_sleep_time to
-	 * wall_to_monotonic to get the real boot based time offset.
-	 *
-	 * - wall_to_monotonic is no longer the boot time, getboottime must be
-	 * used instead.
+	 * Shift conversion between clock shifted nano seconds and
+	 * ntp shifted nano seconds.
 	 */
-	struct timespec64	wall_to_monotonic;
-	/* Offset clock monotonic -> clock realtime */
-	ktime_t			offs_real;
-	/* time spent in suspend */
-	struct timespec64	total_sleep_time;
-	/* Offset clock monotonic -> clock boottime */
-	ktime_t			offs_boot;
-	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
-	struct timespec64	raw_time;
-	/* The current UTC to TAI offset in seconds */
-	s32			tai_offset;
-	/* Offset clock monotonic -> clock tai */
-	ktime_t			offs_tai;
-
+	u32			ntp_error_shift;
 };
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -32,9 +32,16 @@
 #define TK_MIRROR		(1 << 1)
 #define TK_CLOCK_WAS_SET	(1 << 2)
 
-static struct timekeeper timekeeper;
+/*
+ * The most important data for readout fits into a single 64 byte
+ * cache line.
+ */
+static struct {
+	seqcount_t		seq;
+	struct timekeeper	timekeeper;
+} tk_core ____cacheline_aligned;
+
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
-static seqcount_t timekeeper_seq;
 static struct timekeeper shadow_timekeeper;
 
 /* flag for if timekeeping is suspended */
@@ -254,7 +261,7 @@ static void update_pvclock_gtod(struct t
  */
 int pvclock_gtod_register_notifier(struct notifier_block *nb)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
 	int ret;
 
@@ -295,7 +302,8 @@ static void timekeeping_update(struct ti
 	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
 
 	if (action & TK_MIRROR)
-		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
+		memcpy(&shadow_timekeeper, &tk_core.timekeeper,
+		       sizeof(tk_core.timekeeper));
 }
 
 /**
@@ -336,17 +344,17 @@ static void timekeeping_forward_now(stru
  */
 int __getnstimeofday64(struct timespec64 *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long seq;
 	s64 nsecs = 0;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		ts->tv_sec = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	ts->tv_nsec = 0;
 	timespec64_add_ns(ts, nsecs);
@@ -375,18 +383,18 @@ EXPORT_SYMBOL(getnstimeofday64);
 
 ktime_t ktime_get(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned int seq;
 	s64 secs, nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 		secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	return ktime_set(secs, nsecs);
 }
@@ -402,7 +410,7 @@ EXPORT_SYMBOL_GPL(ktime_get);
  */
 void ktime_get_ts64(struct timespec64 *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 tomono;
 	s64 nsec;
 	unsigned int seq;
@@ -410,12 +418,12 @@ void ktime_get_ts64(struct timespec64 *t
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	ts->tv_sec += tomono.tv_sec;
 	ts->tv_nsec = 0;
@@ -432,7 +440,7 @@ EXPORT_SYMBOL_GPL(ktime_get_ts64);
  */
 void timekeeping_clocktai(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 ts64;
 	unsigned long seq;
 	u64 nsecs;
@@ -440,12 +448,12 @@ void timekeeping_clocktai(struct timespe
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		ts64.tv_sec = tk->xtime_sec + tk->tai_offset;
 		nsecs = timekeeping_get_ns(tk);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	ts64.tv_nsec = 0;
 	timespec64_add_ns(&ts64, nsecs);
@@ -482,14 +490,14 @@ EXPORT_SYMBOL(ktime_get_clocktai);
  */
 void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long seq;
 	s64 nsecs_raw, nsecs_real;
 
 	WARN_ON_ONCE(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		*ts_raw = timespec64_to_timespec(tk->raw_time);
 		ts_real->tv_sec = tk->xtime_sec;
@@ -498,7 +506,7 @@ void getnstime_raw_and_real(struct times
 		nsecs_raw = timekeeping_get_ns_raw(tk);
 		nsecs_real = timekeeping_get_ns(tk);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -531,7 +539,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(const struct timespec *tv)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 ts_delta, xt, tmp;
 	unsigned long flags;
 
@@ -539,7 +547,7 @@ int do_settimeofday(const struct timespe
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	timekeeping_forward_now(tk);
 
@@ -554,7 +562,7 @@ int do_settimeofday(const struct timespe
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -572,7 +580,7 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 int timekeeping_inject_offset(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
 	struct timespec64 ts64, tmp;
 	int ret = 0;
@@ -583,7 +591,7 @@ int timekeeping_inject_offset(struct tim
 	ts64 = timespec_to_timespec64(*ts);
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	timekeeping_forward_now(tk);
 
@@ -600,7 +608,7 @@ int timekeeping_inject_offset(struct tim
 error: /* even if we error out, we forwarded the time, so call update */
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -617,14 +625,14 @@ EXPORT_SYMBOL(timekeeping_inject_offset)
  */
 s32 timekeeping_get_tai_offset(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned int seq;
 	s32 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 		ret = tk->tai_offset;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	return ret;
 }
@@ -645,14 +653,14 @@ static void __timekeeping_set_tai_offset
  */
 void timekeeping_set_tai_offset(s32 tai_offset)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 	__timekeeping_set_tai_offset(tk, tai_offset);
 	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	clock_was_set();
 }
@@ -664,14 +672,14 @@ void timekeeping_set_tai_offset(s32 tai_
  */
 static int change_clocksource(void *data)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct clocksource *new, *old;
 	unsigned long flags;
 
 	new = (struct clocksource *) data;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	timekeeping_forward_now(tk);
 	/*
@@ -691,7 +699,7 @@ static int change_clocksource(void *data
 	}
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return 0;
@@ -706,7 +714,7 @@ static int change_clocksource(void *data
  */
 int timekeeping_notify(struct clocksource *clock)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 
 	if (tk->clock == clock)
 		return 0;
@@ -738,17 +746,17 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
  */
 void getrawmonotonic(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 ts64;
 	unsigned long seq;
 	s64 nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 		nsecs = timekeeping_get_ns_raw(tk);
 		ts64 = tk->raw_time;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	timespec64_add_ns(&ts64, nsecs);
 	*ts = timespec64_to_timespec(ts64);
@@ -760,16 +768,16 @@ EXPORT_SYMBOL(getrawmonotonic);
  */
 int timekeeping_valid_for_hres(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long seq;
 	int ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		ret = tk->clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	return ret;
 }
@@ -779,16 +787,16 @@ int timekeeping_valid_for_hres(void)
  */
 u64 timekeeping_max_deferment(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long seq;
 	u64 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		ret = tk->clock->max_idle_ns;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	return ret;
 }
@@ -828,7 +836,7 @@ void __weak read_boot_clock(struct times
  */
 void __init timekeeping_init(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct clocksource *clock;
 	unsigned long flags;
 	struct timespec64 now, boot, tmp;
@@ -854,7 +862,7 @@ void __init timekeeping_init(void)
 	}
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 	ntp_init();
 
 	clock = clocksource_default_clock();
@@ -875,9 +883,10 @@ void __init timekeeping_init(void)
 	tmp.tv_nsec = 0;
 	tk_set_sleep_time(tk, tmp);
 
-	memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
+	memcpy(&shadow_timekeeper, &tk_core.timekeeper,
+	       sizeof(tk_core.timekeeper));
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
@@ -918,7 +927,7 @@ static void __timekeeping_inject_sleepti
  */
 void timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 tmp;
 	unsigned long flags;
 
@@ -930,7 +939,7 @@ void timekeeping_inject_sleeptime(struct
 		return;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	timekeeping_forward_now(tk);
 
@@ -939,7 +948,7 @@ void timekeeping_inject_sleeptime(struct
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -955,7 +964,7 @@ void timekeeping_inject_sleeptime(struct
  */
 static void timekeeping_resume(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct clocksource *clock = tk->clock;
 	unsigned long flags;
 	struct timespec64 ts_new, ts_delta;
@@ -970,7 +979,7 @@ static void timekeeping_resume(void)
 	clocksource_resume();
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	/*
 	 * After system resumes, we need to calculate the suspended time and
@@ -1022,7 +1031,7 @@ static void timekeeping_resume(void)
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	touch_softlockup_watchdog();
@@ -1035,7 +1044,7 @@ static void timekeeping_resume(void)
 
 static int timekeeping_suspend(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
 	struct timespec64		delta, delta_delta;
 	static struct timespec64	old_delta;
@@ -1053,7 +1062,7 @@ static int timekeeping_suspend(void)
 		persistent_clock_exist = true;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 	timekeeping_forward_now(tk);
 	timekeeping_suspended = 1;
 
@@ -1078,7 +1087,7 @@ static int timekeeping_suspend(void)
 	}
 
 	timekeeping_update(tk, TK_MIRROR);
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
@@ -1380,7 +1389,7 @@ static cycle_t logarithmic_accumulation(
 void update_wall_time(void)
 {
 	struct clocksource *clock;
-	struct timekeeper *real_tk = &timekeeper;
+	struct timekeeper *real_tk = &tk_core.timekeeper;
 	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
@@ -1440,7 +1449,7 @@ void update_wall_time(void)
 	 */
 	clock_set |= accumulate_nsecs_to_secs(tk);
 
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 	/* Update clock->cycle_last with the new value */
 	clock->cycle_last = tk->cycle_last;
 	/*
@@ -1450,12 +1459,12 @@ void update_wall_time(void)
 	 * requires changes to all other timekeeper usage sites as
 	 * well, i.e. move the timekeeper pointer getter into the
 	 * spinlocked/seqcount protected sections. And we trade this
-	 * memcpy under the timekeeper_seq against one before we start
+	 * memcpy under the tk_core.seq against one before we start
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
 	timekeeping_update(real_tk, clock_set);
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	if (clock_set)
@@ -1476,7 +1485,7 @@ out:
  */
 void getboottime(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec boottime = {
 		.tv_sec = tk->wall_to_monotonic.tv_sec +
 				tk->total_sleep_time.tv_sec,
@@ -1499,7 +1508,7 @@ EXPORT_SYMBOL_GPL(getboottime);
  */
 void get_monotonic_boottime(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 tomono, sleep, ret;
 	s64 nsec;
 	unsigned int seq;
@@ -1507,13 +1516,13 @@ void get_monotonic_boottime(struct times
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 		ret.tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 		sleep = tk->total_sleep_time;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	ret.tv_sec += tomono.tv_sec + sleep.tv_sec;
 	ret.tv_nsec = 0;
@@ -1545,7 +1554,7 @@ EXPORT_SYMBOL_GPL(ktime_get_boottime);
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 ts64;
 
 	ts64 = timespec_to_timespec64(*ts);
@@ -1556,7 +1565,7 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased
 
 unsigned long get_seconds(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 
 	return tk->xtime_sec;
 }
@@ -1564,22 +1573,22 @@ EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 
 	return timespec64_to_timespec(tk_xtime(tk));
 }
 
 struct timespec current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 now;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		now = tk_xtime(tk);
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	return timespec64_to_timespec(now);
 }
@@ -1587,16 +1596,16 @@ EXPORT_SYMBOL(current_kernel_time);
 
 struct timespec get_monotonic_coarse(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 now, mono;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		now = tk_xtime(tk);
 		mono = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	set_normalized_timespec64(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1624,19 +1633,19 @@ void do_timer(unsigned long ticks)
 ktime_t ktime_get_update_offsets_tick(ktime_t *offs_real, ktime_t *offs_boot,
 							ktime_t *offs_tai)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 ts;
 	ktime_t now;
 	unsigned int seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		ts = tk_xtime(tk);
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
 		*offs_tai = tk->offs_tai;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	now = ktime_set(ts.tv_sec, ts.tv_nsec);
 	now = ktime_sub(now, *offs_real);
@@ -1656,13 +1665,13 @@ ktime_t ktime_get_update_offsets_tick(kt
 ktime_t ktime_get_update_offsets_now(ktime_t *offs_real, ktime_t *offs_boot,
 							ktime_t *offs_tai)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	ktime_t now;
 	unsigned int seq;
 	u64 secs, nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		secs = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
@@ -1670,7 +1679,7 @@ ktime_t ktime_get_update_offsets_now(kti
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
 		*offs_tai = tk->offs_tai;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
 	now = ktime_sub(now, *offs_real);
@@ -1683,14 +1692,14 @@ ktime_t ktime_get_update_offsets_now(kti
  */
 ktime_t ktime_get_monotonic_offset(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long seq;
 	struct timespec64 wtom;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 		wtom = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	return timespec64_to_ktime(wtom);
 }
@@ -1701,7 +1710,7 @@ EXPORT_SYMBOL_GPL(ktime_get_monotonic_of
  */
 int do_adjtimex(struct timex *txc)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
 	struct timespec64 ts;
 	s32 orig_tai, tai;
@@ -1726,7 +1735,7 @@ int do_adjtimex(struct timex *txc)
 	getnstimeofday64(&ts);
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	orig_tai = tai = tk->tai_offset;
 	ret = __do_adjtimex(txc, &ts, &tai);
@@ -1735,7 +1744,7 @@ int do_adjtimex(struct timex *txc)
 		__timekeeping_set_tai_offset(tk, tai);
 		timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	}
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	if (tai != orig_tai)
@@ -1755,11 +1764,11 @@ void hardpps(const struct timespec *phas
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	__hardpps(phase_ts, raw_ts);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);


