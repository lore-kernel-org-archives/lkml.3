Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaGPVEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:59622 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaGPVED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:03 -0400
Message-Id: <20140716205052.938439082@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 09/64] timekeeping: Convert timekeeping core to use
 timespec64s
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=jstultz-tk-480e2d6.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

Convert the core timekeeping logic to use timespec64s. This moves the
2038 issues out of the core logic and into all of the accessor
functions.

Future changes will need to push the timespec64s out to all
timekeeping users, but that can be done interface by interface.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/timekeeper_internal.h |   10 +-
 kernel/time/ntp.c                   |    8 -
 kernel/time/ntp_internal.h          |    2 
 kernel/time/timekeeping.c           |  172 ++++++++++++++++++++----------------
 kernel/time/timekeeping_debug.c     |    2 
 kernel/time/timekeeping_internal.h  |    2 
 6 files changed, 109 insertions(+), 87 deletions(-)

Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -55,15 +55,15 @@ struct timekeeper {
 	 * - wall_to_monotonic is no longer the boot time, getboottime must be
 	 * used instead.
 	 */
-	struct timespec		wall_to_monotonic;
+	struct timespec64	wall_to_monotonic;
 	/* Offset clock monotonic -> clock realtime */
 	ktime_t			offs_real;
 	/* time spent in suspend */
-	struct timespec		total_sleep_time;
+	struct timespec64	total_sleep_time;
 	/* Offset clock monotonic -> clock boottime */
 	ktime_t			offs_boot;
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
-	struct timespec		raw_time;
+	struct timespec64	raw_time;
 	/* The current UTC to TAI offset in seconds */
 	s32			tai_offset;
 	/* Offset clock monotonic -> clock tai */
@@ -71,9 +71,9 @@ struct timekeeper {
 
 };
 
-static inline struct timespec tk_xtime(struct timekeeper *tk)
+static inline struct timespec64 tk_xtime(struct timekeeper *tk)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 
 	ts.tv_sec = tk->xtime_sec;
 	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
Index: tip/kernel/time/ntp.c
===================================================================
--- tip.orig/kernel/time/ntp.c
+++ tip/kernel/time/ntp.c
@@ -531,7 +531,7 @@ void ntp_notify_cmos_timer(void) { }
 /*
  * Propagate a new txc->status value into the NTP state:
  */
-static inline void process_adj_status(struct timex *txc, struct timespec *ts)
+static inline void process_adj_status(struct timex *txc, struct timespec64 *ts)
 {
 	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
 		time_state = TIME_OK;
@@ -554,7 +554,7 @@ static inline void process_adj_status(st
 
 
 static inline void process_adjtimex_modes(struct timex *txc,
-						struct timespec *ts,
+						struct timespec64 *ts,
 						s32 *time_tai)
 {
 	if (txc->modes & ADJ_STATUS)
@@ -640,7 +640,7 @@ int ntp_validate_timex(struct timex *txc
  * adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
-int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
+int __do_adjtimex(struct timex *txc, struct timespec64 *ts, s32 *time_tai)
 {
 	int result;
 
@@ -684,7 +684,7 @@ int __do_adjtimex(struct timex *txc, str
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	txc->time.tv_sec = ts->tv_sec;
+	txc->time.tv_sec = (time_t)ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
Index: tip/kernel/time/ntp_internal.h
===================================================================
--- tip.orig/kernel/time/ntp_internal.h
+++ tip/kernel/time/ntp_internal.h
@@ -7,6 +7,6 @@ extern void ntp_clear(void);
 extern u64 ntp_tick_length(void);
 extern int second_overflow(unsigned long secs);
 extern int ntp_validate_timex(struct timex *);
-extern int __do_adjtimex(struct timex *, struct timespec *, s32 *);
+extern int __do_adjtimex(struct timex *, struct timespec64 *, s32 *);
 extern void __hardpps(const struct timespec *, const struct timespec *);
 #endif /* _LINUX_NTP_INTERNAL_H */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -51,43 +51,43 @@ static inline void tk_normalize_xtime(st
 	}
 }
 
-static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
+static void tk_set_xtime(struct timekeeper *tk, const struct timespec64 *ts)
 {
 	tk->xtime_sec = ts->tv_sec;
 	tk->xtime_nsec = (u64)ts->tv_nsec << tk->shift;
 }
 
-static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
+static void tk_xtime_add(struct timekeeper *tk, const struct timespec64 *ts)
 {
 	tk->xtime_sec += ts->tv_sec;
 	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
 	tk_normalize_xtime(tk);
 }
 
-static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
+static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec64 wtm)
 {
-	struct timespec tmp;
+	struct timespec64 tmp;
 
 	/*
 	 * Verify consistency of: offset_real = -wall_to_monotonic
 	 * before modifying anything
 	 */
-	set_normalized_timespec(&tmp, -tk->wall_to_monotonic.tv_sec,
+	set_normalized_timespec64(&tmp, -tk->wall_to_monotonic.tv_sec,
 					-tk->wall_to_monotonic.tv_nsec);
-	WARN_ON_ONCE(tk->offs_real.tv64 != timespec_to_ktime(tmp).tv64);
+	WARN_ON_ONCE(tk->offs_real.tv64 != timespec64_to_ktime(tmp).tv64);
 	tk->wall_to_monotonic = wtm;
-	set_normalized_timespec(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
-	tk->offs_real = timespec_to_ktime(tmp);
+	set_normalized_timespec64(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
+	tk->offs_real = timespec64_to_ktime(tmp);
 	tk->offs_tai = ktime_add(tk->offs_real, ktime_set(tk->tai_offset, 0));
 }
 
-static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
+static void tk_set_sleep_time(struct timekeeper *tk, struct timespec64 t)
 {
 	/* Verify consistency before modifying */
-	WARN_ON_ONCE(tk->offs_boot.tv64 != timespec_to_ktime(tk->total_sleep_time).tv64);
+	WARN_ON_ONCE(tk->offs_boot.tv64 != timespec64_to_ktime(tk->total_sleep_time).tv64);
 
 	tk->total_sleep_time	= t;
-	tk->offs_boot		= timespec_to_ktime(t);
+	tk->offs_boot		= timespec64_to_ktime(t);
 }
 
 /**
@@ -281,7 +281,7 @@ static void timekeeping_forward_now(stru
 	tk_normalize_xtime(tk);
 
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
-	timespec_add_ns(&tk->raw_time, nsec);
+	timespec64_add_ns(&tk->raw_time, nsec);
 }
 
 /**
@@ -360,7 +360,7 @@ EXPORT_SYMBOL_GPL(ktime_get);
 void ktime_get_ts(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
-	struct timespec tomono;
+	struct timespec64 ts64, tomono;
 	s64 nsec;
 	unsigned int seq;
 
@@ -368,15 +368,16 @@ void ktime_get_ts(struct timespec *ts)
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
-		ts->tv_sec = tk->xtime_sec;
+		ts64.tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
-	ts->tv_sec += tomono.tv_sec;
-	ts->tv_nsec = 0;
-	timespec_add_ns(ts, nsec + tomono.tv_nsec);
+	ts64.tv_sec += tomono.tv_sec;
+	ts64.tv_nsec = 0;
+	timespec64_add_ns(&ts64, nsec + tomono.tv_nsec);
+	*ts = timespec64_to_timespec(ts64);
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
@@ -390,6 +391,7 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
 void timekeeping_clocktai(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
+	struct timespec64 ts64;
 	unsigned long seq;
 	u64 nsecs;
 
@@ -398,13 +400,14 @@ void timekeeping_clocktai(struct timespe
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
 
-		ts->tv_sec = tk->xtime_sec + tk->tai_offset;
+		ts64.tv_sec = tk->xtime_sec + tk->tai_offset;
 		nsecs = timekeeping_get_ns(tk);
 
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
-	ts->tv_nsec = 0;
-	timespec_add_ns(ts, nsecs);
+	ts64.tv_nsec = 0;
+	timespec64_add_ns(&ts64, nsecs);
+	*ts = timespec64_to_timespec(ts64);
 
 }
 EXPORT_SYMBOL(timekeeping_clocktai);
@@ -446,7 +449,7 @@ void getnstime_raw_and_real(struct times
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
 
-		*ts_raw = tk->raw_time;
+		*ts_raw = timespec64_to_timespec(tk->raw_time);
 		ts_real->tv_sec = tk->xtime_sec;
 		ts_real->tv_nsec = 0;
 
@@ -487,7 +490,7 @@ EXPORT_SYMBOL(do_gettimeofday);
 int do_settimeofday(const struct timespec *tv)
 {
 	struct timekeeper *tk = &timekeeper;
-	struct timespec ts_delta, xt;
+	struct timespec64 ts_delta, xt, tmp;
 	unsigned long flags;
 
 	if (!timespec_valid_strict(tv))
@@ -502,9 +505,10 @@ int do_settimeofday(const struct timespe
 	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
 
-	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, ts_delta));
+	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts_delta));
 
-	tk_set_xtime(tk, tv);
+	tmp = timespec_to_timespec64(*tv);
+	tk_set_xtime(tk, &tmp);
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
@@ -528,26 +532,28 @@ int timekeeping_inject_offset(struct tim
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
-	struct timespec tmp;
+	struct timespec64 ts64, tmp;
 	int ret = 0;
 
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
+	ts64 = timespec_to_timespec64(*ts);
+
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 
 	timekeeping_forward_now(tk);
 
 	/* Make sure the proposed value is valid */
-	tmp = timespec_add(tk_xtime(tk),  *ts);
-	if (!timespec_valid_strict(&tmp)) {
+	tmp = timespec64_add(tk_xtime(tk),  ts64);
+	if (!timespec64_valid_strict(&tmp)) {
 		ret = -EINVAL;
 		goto error;
 	}
 
-	tk_xtime_add(tk, ts);
-	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
+	tk_xtime_add(tk, &ts64);
+	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts64));
 
 error: /* even if we error out, we forwarded the time, so call update */
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
@@ -691,17 +697,19 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
 void getrawmonotonic(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
+	struct timespec64 ts64;
 	unsigned long seq;
 	s64 nsecs;
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
 		nsecs = timekeeping_get_ns_raw(tk);
-		*ts = tk->raw_time;
+		ts64 = tk->raw_time;
 
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
-	timespec_add_ns(ts, nsecs);
+	timespec64_add_ns(&ts64, nsecs);
+	*ts = timespec64_to_timespec(ts64);
 }
 EXPORT_SYMBOL(getrawmonotonic);
 
@@ -781,11 +789,12 @@ void __init timekeeping_init(void)
 	struct timekeeper *tk = &timekeeper;
 	struct clocksource *clock;
 	unsigned long flags;
-	struct timespec now, boot, tmp;
-
-	read_persistent_clock(&now);
+	struct timespec64 now, boot, tmp;
+	struct timespec ts;
 
-	if (!timespec_valid_strict(&now)) {
+	read_persistent_clock(&ts);
+	now = timespec_to_timespec64(ts);
+	if (!timespec64_valid_strict(&now)) {
 		pr_warn("WARNING: Persistent clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		now.tv_sec = 0;
@@ -793,8 +802,9 @@ void __init timekeeping_init(void)
 	} else if (now.tv_sec || now.tv_nsec)
 		persistent_clock_exist = true;
 
-	read_boot_clock(&boot);
-	if (!timespec_valid_strict(&boot)) {
+	read_boot_clock(&ts);
+	boot = timespec_to_timespec64(ts);
+	if (!timespec64_valid_strict(&boot)) {
 		pr_warn("WARNING: Boot clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		boot.tv_sec = 0;
@@ -816,7 +826,7 @@ void __init timekeeping_init(void)
 	if (boot.tv_sec == 0 && boot.tv_nsec == 0)
 		boot = tk_xtime(tk);
 
-	set_normalized_timespec(&tmp, -boot.tv_sec, -boot.tv_nsec);
+	set_normalized_timespec64(&tmp, -boot.tv_sec, -boot.tv_nsec);
 	tk_set_wall_to_mono(tk, tmp);
 
 	tmp.tv_sec = 0;
@@ -830,7 +840,7 @@ void __init timekeeping_init(void)
 }
 
 /* time in seconds when suspend began */
-static struct timespec timekeeping_suspend_time;
+static struct timespec64 timekeeping_suspend_time;
 
 /**
  * __timekeeping_inject_sleeptime - Internal function to add sleep interval
@@ -840,17 +850,17 @@ static struct timespec timekeeping_suspe
  * adds the sleep offset to the timekeeping variables.
  */
 static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
-							struct timespec *delta)
+					   struct timespec64 *delta)
 {
-	if (!timespec_valid_strict(delta)) {
+	if (!timespec64_valid_strict(delta)) {
 		printk_deferred(KERN_WARNING
 				"__timekeeping_inject_sleeptime: Invalid "
 				"sleep delta value!\n");
 		return;
 	}
 	tk_xtime_add(tk, delta);
-	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *delta));
-	tk_set_sleep_time(tk, timespec_add(tk->total_sleep_time, *delta));
+	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, *delta));
+	tk_set_sleep_time(tk, timespec64_add(tk->total_sleep_time, *delta));
 	tk_debug_account_sleep_time(delta);
 }
 
@@ -867,6 +877,7 @@ static void __timekeeping_inject_sleepti
 void timekeeping_inject_sleeptime(struct timespec *delta)
 {
 	struct timekeeper *tk = &timekeeper;
+	struct timespec64 tmp;
 	unsigned long flags;
 
 	/*
@@ -881,7 +892,8 @@ void timekeeping_inject_sleeptime(struct
 
 	timekeeping_forward_now(tk);
 
-	__timekeeping_inject_sleeptime(tk, delta);
+	tmp = timespec_to_timespec64(*delta);
+	__timekeeping_inject_sleeptime(tk, &tmp);
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
@@ -904,11 +916,13 @@ static void timekeeping_resume(void)
 	struct timekeeper *tk = &timekeeper;
 	struct clocksource *clock = tk->clock;
 	unsigned long flags;
-	struct timespec ts_new, ts_delta;
+	struct timespec64 ts_new, ts_delta;
+	struct timespec tmp;
 	cycle_t cycle_now, cycle_delta;
 	bool suspendtime_found = false;
 
-	read_persistent_clock(&ts_new);
+	read_persistent_clock(&tmp);
+	ts_new = timespec_to_timespec64(tmp);
 
 	clockevents_resume();
 	clocksource_resume();
@@ -951,10 +965,10 @@ static void timekeeping_resume(void)
 		}
 		nsec += ((u64) cycle_delta * mult) >> shift;
 
-		ts_delta = ns_to_timespec(nsec);
+		ts_delta = ns_to_timespec64(nsec);
 		suspendtime_found = true;
-	} else if (timespec_compare(&ts_new, &timekeeping_suspend_time) > 0) {
-		ts_delta = timespec_sub(ts_new, timekeeping_suspend_time);
+	} else if (timespec64_compare(&ts_new, &timekeeping_suspend_time) > 0) {
+		ts_delta = timespec64_sub(ts_new, timekeeping_suspend_time);
 		suspendtime_found = true;
 	}
 
@@ -981,10 +995,12 @@ static int timekeeping_suspend(void)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
-	struct timespec		delta, delta_delta;
-	static struct timespec	old_delta;
+	struct timespec64		delta, delta_delta;
+	static struct timespec64	old_delta;
+	struct timespec tmp;
 
-	read_persistent_clock(&timekeeping_suspend_time);
+	read_persistent_clock(&tmp);
+	timekeeping_suspend_time = timespec_to_timespec64(tmp);
 
 	/*
 	 * On some systems the persistent_clock can not be detected at
@@ -1005,8 +1021,8 @@ static int timekeeping_suspend(void)
 	 * try to compensate so the difference in system time
 	 * and persistent_clock time stays close to constant.
 	 */
-	delta = timespec_sub(tk_xtime(tk), timekeeping_suspend_time);
-	delta_delta = timespec_sub(delta, old_delta);
+	delta = timespec64_sub(tk_xtime(tk), timekeeping_suspend_time);
+	delta_delta = timespec64_sub(delta, old_delta);
 	if (abs(delta_delta.tv_sec)  >= 2) {
 		/*
 		 * if delta_delta is too large, assume time correction
@@ -1016,7 +1032,7 @@ static int timekeeping_suspend(void)
 	} else {
 		/* Otherwise try to adjust old_system to compensate */
 		timekeeping_suspend_time =
-			timespec_add(timekeeping_suspend_time, delta_delta);
+			timespec64_add(timekeeping_suspend_time, delta_delta);
 	}
 
 	timekeeping_update(tk, TK_MIRROR);
@@ -1253,14 +1269,14 @@ static inline unsigned int accumulate_ns
 		/* Figure out if its a leap sec and apply if needed */
 		leap = second_overflow(tk->xtime_sec);
 		if (unlikely(leap)) {
-			struct timespec ts;
+			struct timespec64 ts;
 
 			tk->xtime_sec += leap;
 
 			ts.tv_sec = leap;
 			ts.tv_nsec = 0;
 			tk_set_wall_to_mono(tk,
-				timespec_sub(tk->wall_to_monotonic, ts));
+				timespec64_sub(tk->wall_to_monotonic, ts));
 
 			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
 
@@ -1469,7 +1485,7 @@ EXPORT_SYMBOL_GPL(getboottime);
 void get_monotonic_boottime(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
-	struct timespec tomono, sleep;
+	struct timespec64 tomono, sleep, ret;
 	s64 nsec;
 	unsigned int seq;
 
@@ -1477,16 +1493,17 @@ void get_monotonic_boottime(struct times
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
-		ts->tv_sec = tk->xtime_sec;
+		ret.tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 		sleep = tk->total_sleep_time;
 
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
-	ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
-	ts->tv_nsec = 0;
-	timespec_add_ns(ts, nsec + tomono.tv_nsec + sleep.tv_nsec);
+	ret.tv_sec += tomono.tv_sec + sleep.tv_sec;
+	ret.tv_nsec = 0;
+	timespec64_add_ns(&ret, nsec + tomono.tv_nsec + sleep.tv_nsec);
+	*ts = timespec64_to_timespec(ret);
 }
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 
@@ -1514,8 +1531,11 @@ EXPORT_SYMBOL_GPL(ktime_get_boottime);
 void monotonic_to_bootbased(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
+	struct timespec64 ts64;
 
-	*ts = timespec_add(*ts, tk->total_sleep_time);
+	ts64 = timespec_to_timespec64(*ts);
+	ts64 = timespec64_add(ts64, tk->total_sleep_time);
+	*ts = timespec64_to_timespec(ts64);
 }
 EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
@@ -1531,13 +1551,13 @@ struct timespec __current_kernel_time(vo
 {
 	struct timekeeper *tk = &timekeeper;
 
-	return tk_xtime(tk);
+	return timespec64_to_timespec(tk_xtime(tk));
 }
 
 struct timespec current_kernel_time(void)
 {
 	struct timekeeper *tk = &timekeeper;
-	struct timespec now;
+	struct timespec64 now;
 	unsigned long seq;
 
 	do {
@@ -1546,14 +1566,14 @@ struct timespec current_kernel_time(void
 		now = tk_xtime(tk);
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
-	return now;
+	return timespec64_to_timespec(now);
 }
 EXPORT_SYMBOL(current_kernel_time);
 
 struct timespec get_monotonic_coarse(void)
 {
 	struct timekeeper *tk = &timekeeper;
-	struct timespec now, mono;
+	struct timespec64 now, mono;
 	unsigned long seq;
 
 	do {
@@ -1563,9 +1583,10 @@ struct timespec get_monotonic_coarse(voi
 		mono = tk->wall_to_monotonic;
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
-	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
+	set_normalized_timespec64(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
-	return now;
+
+	return timespec64_to_timespec(now);
 }
 
 /*
@@ -1589,7 +1610,7 @@ ktime_t ktime_get_update_offsets_tick(kt
 							ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &timekeeper;
-	struct timespec ts;
+	struct timespec64 ts;
 	ktime_t now;
 	unsigned int seq;
 
@@ -1597,7 +1618,6 @@ ktime_t ktime_get_update_offsets_tick(kt
 		seq = read_seqcount_begin(&timekeeper_seq);
 
 		ts = tk_xtime(tk);
-
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
 		*offs_tai = tk->offs_tai;
@@ -1650,14 +1670,14 @@ ktime_t ktime_get_monotonic_offset(void)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long seq;
-	struct timespec wtom;
+	struct timespec64 wtom;
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
 		wtom = tk->wall_to_monotonic;
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
-	return timespec_to_ktime(wtom);
+	return timespec64_to_ktime(wtom);
 }
 EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
 
@@ -1668,7 +1688,8 @@ int do_adjtimex(struct timex *txc)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
-	struct timespec ts;
+	struct timespec64 ts;
+	struct timespec tmp;
 	s32 orig_tai, tai;
 	int ret;
 
@@ -1688,7 +1709,8 @@ int do_adjtimex(struct timex *txc)
 			return ret;
 	}
 
-	getnstimeofday(&ts);
+	getnstimeofday(&tmp);
+	ts = timespec_to_timespec64(tmp);
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
Index: tip/kernel/time/timekeeping_debug.c
===================================================================
--- tip.orig/kernel/time/timekeeping_debug.c
+++ tip/kernel/time/timekeeping_debug.c
@@ -67,7 +67,7 @@ static int __init tk_debug_sleep_time_in
 }
 late_initcall(tk_debug_sleep_time_init);
 
-void tk_debug_account_sleep_time(struct timespec *t)
+void tk_debug_account_sleep_time(struct timespec64 *t)
 {
 	sleep_time_bin[fls(t->tv_sec)]++;
 }
Index: tip/kernel/time/timekeeping_internal.h
===================================================================
--- tip.orig/kernel/time/timekeeping_internal.h
+++ tip/kernel/time/timekeeping_internal.h
@@ -6,7 +6,7 @@
 #include <linux/time.h>
 
 #ifdef CONFIG_DEBUG_FS
-extern void tk_debug_account_sleep_time(struct timespec *t);
+extern void tk_debug_account_sleep_time(struct timespec64 *t);
 #else
 #define tk_debug_account_sleep_time(x)
 #endif


