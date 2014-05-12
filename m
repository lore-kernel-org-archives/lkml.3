Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaELQVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:21:44 -0400
Received: from ns.horizon.com ([71.41.210.147]:31312 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752026AbaELQVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:21:43 -0400
Date: 12 May 2014 12:21:41 -0400
Message-ID: <20140512162141.22331.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: john.stultz@linaro.org, linux@horizon.com
Subject: [rough draft PATCH] avoid stalls on the timekeeping seqlock
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20140506213306.17674.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a non-working rough draft of that idea I suggested to make
reading the time non-blocking, even if an update is in progress.

Basically, it uses the idea proposed in a comment in update_wall_time,
switching pointers so there's always one valid structure.

This is non-working because last year the NTP variables lost their
own locking and inherited the timekeeping locks I am redesigning.
I haven't updated NTP yet.

One interesting possibility is that the write side of the locking
is identical to a standard seqlock.  It would be possible to
divide the timekeeping variables into non-blocking variables which
are mirrored, and ones that require stalling during write
seqlock updates.

But that's somewhat deeper magic than I've attempted so far.
This is a demonstration of the idea.

Does it seem worth pursuing?

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f7df8ea217..0dfa4aa6fb 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -29,15 +29,15 @@
 #include "timekeeping_internal.h"
 
 #define TK_CLEAR_NTP		(1 << 0)
-#define TK_MIRROR		(1 << 1)
 #define TK_CLOCK_WAS_SET	(1 << 2)
 
-static struct timekeeper timekeeper;
+static struct timekeeper timekeeper[2];
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
+/* The following is NOT used as a standard seqlock */
 static seqcount_t timekeeper_seq;
-static struct timekeeper shadow_timekeeper;
 
 /* flag for if timekeeping is suspended */
+/* Q: What are the locking rules for this variable? */
 int __read_mostly timekeeping_suspended;
 
 /* Flag for if there is a persistent clock on this platform */
@@ -165,7 +165,7 @@ u32 get_arch_timeoffset(void)
 static inline u32 get_arch_timeoffset(void) { return 0; }
 #endif
 
-static inline s64 timekeeping_get_ns(struct timekeeper *tk)
+static inline s64 timekeeping_get_ns(struct timekeeper const *tk)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
@@ -185,7 +185,7 @@ static inline s64 timekeeping_get_ns(struct timekeeper *tk)
 	return nsec + get_arch_timeoffset();
 }
 
-static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
+static inline s64 timekeeping_get_ns_raw(struct timekeeper const *tk)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
@@ -217,12 +217,13 @@ static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
  */
 int pvclock_gtod_register_notifier(struct notifier_block *nb)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 	int ret;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	ret = raw_notifier_chain_register(&pvclock_gtod_chain, nb);
+	tk = timekeeper_current();
 	update_pvclock_gtod(tk, true);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
@@ -256,9 +257,6 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 	}
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
-
-	if (action & TK_MIRROR)
-		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
 }
 
 /**
@@ -291,6 +289,89 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 }
 
 /**
+ * timekeeper_write_begin: Return a timekeeper that can be updated.
+ *
+ * Must be called with the timekeeper_lock held.
+ */
+static inline struct timekeeper *timekeeper_write_begin(void)
+{
+	bool b;
+
+	write_seqcount_begin(&timekeeper_seq);
+	b = (timekeeper_seq.sequence >> 1) & 1;
+	timekeeper[!b] = timekeeper[b];
+	return timekeeper + !b;
+}
+
+/**
+ * timekeeper_write_end: Finish write, mark the modified timekeeper as current.
+ *
+ * Must be called with the timekeeper_lock held.
+ */
+static inline void timekeeper_write_end(void)
+{
+	write_seqcount_end(&timekeeper_seq);
+}
+
+/**
+ * __timekeeper_current: Return the current (for reading) timekeeper
+ * @seq: The current sequence number
+ *
+ * Return the timekeeper corresponding to the given sequence number.
+ */
+static inline struct timekeeper const *__timekeeper_current(unsigned seq)
+{
+	return timekeeper + ((seq >> 1) & 1);
+}
+
+/**
+ * timekeeper_current: Return the current (for reading) timekeeper
+ *
+ * On rare occasions, we want the current timekeeper without obtaining
+ * the seqlock.  For example, if we hold the timekeeper_loc but don't
+ * intend to write it.
+ */
+static inline struct timekeeper const *timekeeper_current(void)
+{
+	return __timekeeper_current(timekeeper_seq.sequence);
+}
+
+/**
+ * timekeeper_read_begin: Begin reading a timekeeper.
+ * @seqp: Pointer to variable to receive sequence number.
+ *	(Because this is inline, the compiler can optimize out
+ *	the memory access.)
+ *
+ * Returns a pointer to a readable timekeeper structure.
+ *
+ * Because we have two timekeeper structures that we ping-pong
+ * between, this never blocks.  Only if there are two calls
+ * to timekeeper_write_begin between read_begin and read_retry
+ * will a retry be forced.
+ */
+static inline struct timekeeper const *timekeeper_read_begin(unsigned *seqp)
+{
+	unsigned seq = ACCESS_ONCE(timekeeper_seq.sequence);
+	smp_rmb();
+	*seqp = seq &= ~1u;
+	return __timekeeper_current(seq);
+}
+
+/**
+ * timekeeper_read_retry: Return true if read was inconsistent, must retry
+ * @seq: The return value from timekeeper_read_begin
+ *
+ * Because we ping-pong between two timekeeper structures, the window
+ * of validity is wider than a normal seqlock, and a retry is very
+ * unlikely.
+ */
+static inline bool timekeeper_read_retry(unsigned seq)
+{
+	unsigned delta = timekeeper_seq.sequence - seq;
+	return unlikely(delta > 2);
+}
+
+/**
  * __getnstimeofday - Returns the time of day in a timespec.
  * @ts:		pointer to the timespec to be set
  *
@@ -299,17 +380,16 @@ static void timekeeping_forward_now(struct timekeeper *tk)
  */
 int __getnstimeofday(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned seq;
 	s64 nsecs = 0;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
 
 		ts->tv_sec = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
@@ -338,18 +418,18 @@ EXPORT_SYMBOL(getnstimeofday);
 
 ktime_t ktime_get(void)
 {
-	struct timekeeper *tk = &timekeeper;
 	unsigned int seq;
 	s64 secs, nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
+
 		secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -368,7 +448,6 @@ EXPORT_SYMBOL_GPL(ktime_get);
  */
 void ktime_get_ts(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
 	struct timespec tomono;
 	s64 nsec;
 	unsigned int seq;
@@ -376,12 +455,13 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
+
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	ts->tv_sec += tomono.tv_sec;
 	ts->tv_nsec = 0;
@@ -398,19 +478,18 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
  */
 void timekeeping_clocktai(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned seq;
 	u64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
 
 		ts->tv_sec = tk->xtime_sec + tk->tai_offset;
 		nsecs = timekeeping_get_ns(tk);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
@@ -446,14 +525,13 @@ EXPORT_SYMBOL(ktime_get_clocktai);
  */
 void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned seq;
 	s64 nsecs_raw, nsecs_real;
 
 	WARN_ON_ONCE(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
 
 		*ts_raw = tk->raw_time;
 		ts_real->tv_sec = tk->xtime_sec;
@@ -462,7 +540,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw = timekeeping_get_ns_raw(tk);
 		nsecs_real = timekeeping_get_ns(tk);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -495,7 +573,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(const struct timespec *tv)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec ts_delta, xt;
 	unsigned long flags;
 
@@ -503,7 +581,7 @@ int do_settimeofday(const struct timespec *tv)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	tk = timekeeper_write_begin();
 
 	timekeeping_forward_now(tk);
 
@@ -515,9 +593,9 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end();
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -535,7 +613,7 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 int timekeeping_inject_offset(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 	struct timespec tmp;
 	int ret = 0;
@@ -544,7 +622,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	tk = timekeeper_write_begin();
 
 	timekeeping_forward_now(tk);
 
@@ -559,9 +637,9 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end();
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -578,14 +656,14 @@ EXPORT_SYMBOL(timekeeping_inject_offset);
  */
 s32 timekeeping_get_tai_offset(void)
 {
-	struct timekeeper *tk = &timekeeper;
 	unsigned int seq;
 	s32 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
+
 		ret = tk->tai_offset;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	return ret;
 }
@@ -606,14 +684,14 @@ static void __timekeeping_set_tai_offset(struct timekeeper *tk, s32 tai_offset)
  */
 void timekeeping_set_tai_offset(s32 tai_offset)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	tk = timekeeper_write_begin();
 	__timekeeping_set_tai_offset(tk, tai_offset);
-	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
-	write_seqcount_end(&timekeeper_seq);
+	timekeeping_update(tk, TK_CLOCK_WAS_SET);
+	timekeeper_write_end();
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	clock_was_set();
 }
@@ -625,14 +703,14 @@ void timekeeping_set_tai_offset(s32 tai_offset)
  */
 static int change_clocksource(void *data)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct clocksource *new, *old;
 	unsigned long flags;
 
 	new = (struct clocksource *) data;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	tk = timekeeper_write_begin();
 
 	timekeeping_forward_now(tk);
 	/*
@@ -650,9 +728,9 @@ static int change_clocksource(void *data)
 			module_put(new->owner);
 		}
 	}
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end();
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return 0;
@@ -667,12 +745,20 @@ static int change_clocksource(void *data)
  */
 int timekeeping_notify(struct clocksource *clock)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper const *tk = timekeeper_current();
 
+	/*
+	 * Since the clock source can't change outside the clocksource_mutex,
+	 * and a write update just copies the same current value over top
+	 * of itself, even if the write is non-atomic a read should still
+	 * return the correct value for tk->clock without locking.
+	 */
 	if (tk->clock == clock)
 		return 0;
 	stop_machine(change_clocksource, clock, NULL);
 	tick_clock_notify();
+
+	tk = timekeeper_current();
 	return tk->clock == clock ? 0 : -1;
 }
 
@@ -699,16 +785,16 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
  */
 void getrawmonotonic(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned seq;
 	s64 nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
+
 		nsecs = timekeeping_get_ns_raw(tk);
 		*ts = tk->raw_time;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -719,16 +805,15 @@ EXPORT_SYMBOL(getrawmonotonic);
  */
 int timekeeping_valid_for_hres(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned seq;
 	int ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
 
 		ret = tk->clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	return ret;
 }
@@ -738,16 +823,15 @@ int timekeeping_valid_for_hres(void)
  */
 u64 timekeeping_max_deferment(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned seq;
 	u64 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
 
 		ret = tk->clock->max_idle_ns;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	return ret;
 }
@@ -787,7 +871,7 @@ void __weak read_boot_clock(struct timespec *ts)
  */
 void __init timekeeping_init(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct clocksource *clock;
 	unsigned long flags;
 	struct timespec now, boot, tmp;
@@ -811,7 +895,7 @@ void __init timekeeping_init(void)
 	}
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	tk = timekeeper_write_begin();
 	ntp_init();
 
 	clock = clocksource_default_clock();
@@ -832,9 +916,11 @@ void __init timekeeping_init(void)
 	tmp.tv_nsec = 0;
 	tk_set_sleep_time(tk, tmp);
 
-	memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
+	timekeeper_write_end();
 
-	write_seqcount_end(&timekeeper_seq);
+	/* Set up the second copy, too */
+	(void)timekeeper_write_begin();
+	timekeeper_write_end();
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
@@ -874,7 +960,7 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
  */
 void timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 
 	/*
@@ -885,15 +971,15 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 		return;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	tk = timekeeper_write_begin();
 
 	timekeeping_forward_now(tk);
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end();
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -909,8 +995,8 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
  */
 static void timekeeping_resume(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct clocksource *clock = tk->clock;
+	struct timekeeper *tk;
+	struct clocksource *clock;
 	unsigned long flags;
 	struct timespec ts_new, ts_delta;
 	cycle_t cycle_now, cycle_delta;
@@ -922,7 +1008,6 @@ static void timekeeping_resume(void)
 	clocksource_resume();
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
 
 	/*
 	 * After system resumes, we need to calculate the suspended time and
@@ -936,6 +1021,7 @@ static void timekeeping_resume(void)
 	 * The less preferred source will only be tried if there is no better
 	 * usable source. The rtc part is handled separately in rtc core code.
 	 */
+	clock = timekeeper_current()->clock;
 	cycle_now = clock->read(clock);
 	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NONSTOP) &&
 		cycle_now > clock->cycle_last) {
@@ -947,14 +1033,14 @@ static void timekeeping_resume(void)
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/*
-		 * "cycle_delta * mutl" may cause 64 bits overflow, if the
+		 * "cycle_delta * mult" may cause 64 bits overflow, if the
 		 * suspended time is too long. In that case we need do the
 		 * 64 bits math carefully
 		 */
 		do_div(max, mult);
 		if (cycle_delta > max) {
 			num = div64_u64(cycle_delta, max);
-			nsec = (((u64) max * mult) >> shift) * num;
+			nsec = (max * mult >> shift) * num;
 			cycle_delta -= num * max;
 		}
 		nsec += ((u64) cycle_delta * mult) >> shift;
@@ -966,6 +1052,8 @@ static void timekeeping_resume(void)
 		suspendtime_found = true;
 	}
 
+	tk = timekeeper_write_begin();	/* Now we start making changes */
+
 	if (suspendtime_found)
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
 
@@ -973,8 +1061,9 @@ static void timekeeping_resume(void)
 	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
-	write_seqcount_end(&timekeeper_seq);
+
+	timekeeper_write_end();
+	timekeeping_update(tk, TK_CLOCK_WAS_SET);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	touch_softlockup_watchdog();
@@ -987,7 +1076,7 @@ static void timekeeping_resume(void)
 
 static int timekeeping_suspend(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 	struct timespec		delta, delta_delta;
 	static struct timespec	old_delta;
@@ -1003,7 +1092,7 @@ static int timekeeping_suspend(void)
 		persistent_clock_exist = true;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	tk = timekeeper_write_begin();
 	timekeeping_forward_now(tk);
 	timekeeping_suspended = 1;
 
@@ -1027,8 +1116,8 @@ static int timekeeping_suspend(void)
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
 
-	timekeeping_update(tk, TK_MIRROR);
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end();
+	timekeeping_update(tk, 0);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
@@ -1056,7 +1145,7 @@ device_initcall(timekeeping_init_ops);
  * If the error is already larger, we look ahead even further
  * to compensate for late or lost adjustments.
  */
-static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
+static __always_inline int timekeeping_bigadjust(struct timekeeper const *tk,
 						 s64 error, s64 *interval,
 						 s64 *offset)
 {
@@ -1129,7 +1218,7 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	error = tk->ntp_error >> (tk->ntp_error_shift - 1);
 	if (error > interval) {
 		/*
-		 * We now divide error by 4(via shift), which checks if
+		 * We now divide error by 4 (via shift), which checks if
 		 * the error is greater than twice the interval.
 		 * If it is greater, we need a bigadjust, if its smaller,
 		 * we can adjust by 1.
@@ -1139,8 +1228,7 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 			adj = 1;
 		else
 			adj = timekeeping_bigadjust(tk, error, &interval, &offset);
-	} else {
-		if (error < -interval) {
+	} else if (error < -interval) {
 			/* See comment above, this is just switched for the negative */
 			error >>= 2;
 			if (likely(error >= -interval)) {
@@ -1236,7 +1324,6 @@ out_adjust:
 		tk->xtime_nsec = 0;
 		tk->ntp_error += neg << tk->ntp_error_shift;
 	}
-
 }
 
 /**
@@ -1245,7 +1332,6 @@ out_adjust:
  * Helper function that accumulates a the nsecs greater then a second
  * from the xtime_nsec field to the xtime_secs field.
  * It also calls into the NTP code to handle leapsecond processing.
- *
  */
 static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 {
@@ -1357,8 +1443,8 @@ static inline void old_vsyscall_fixup(struct timekeeper *tk)
 void update_wall_time(void)
 {
 	struct clocksource *clock;
-	struct timekeeper *real_tk = &timekeeper;
-	struct timekeeper *tk = &shadow_timekeeper;
+	struct timekeeper *tk;
+	struct timekeeper const *tk_old;
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned int clock_set = 0;
@@ -1370,17 +1456,18 @@ void update_wall_time(void)
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-	clock = real_tk->clock;
+	tk_old = timekeeper_current();
+	clock = tk_old->clock;
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	offset = real_tk->cycle_interval;
+	offset = tk_old->cycle_interval;
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
-#endif
 
 	/* Check if there's really nothing to do */
-	if (offset < real_tk->cycle_interval)
+	if (offset < tk_old->cycle_interval)
 		goto out;
+#endif
 
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
@@ -1402,6 +1489,9 @@ void update_wall_time(void)
 			shift--;
 	}
 
+	/* Now begin the updates */
+	tk = timekeeper_write_begin();
+
 	/* correct the clock when NTP error is too big */
 	timekeeping_adjust(tk, offset);
 
@@ -1417,22 +1507,17 @@ void update_wall_time(void)
 	 */
 	clock_set |= accumulate_nsecs_to_secs(tk);
 
-	write_seqcount_begin(&timekeeper_seq);
+	/* We are done updating tk; from here on it's read only */
+	timekeeper_write_end();
+
 	/* Update clock->cycle_last with the new value */
 	clock->cycle_last = tk->cycle_last;
 	/*
-	 * Update the real timekeeper.
-	 *
-	 * We could avoid this memcpy by switching pointers, but that
-	 * requires changes to all other timekeeper usage sites as
-	 * well, i.e. move the timekeeper pointer getter into the
-	 * spinlocked/seqcount protected sections. And we trade this
-	 * memcpy under the timekeeper_seq against one before we start
-	 * updating.
+	 * Notify users of updates.
+	 * (timekeeping_update writes *tk if clock_set & TK_CLEAR_NTP,
+	 * but that's never the case here.)
 	 */
-	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, clock_set);
-	write_seqcount_end(&timekeeper_seq);
+	timekeeping_update(tk, clock_set);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	if (clock_set)
@@ -1453,13 +1538,16 @@ out:
  */
 void getboottime(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct timespec boottime = {
-		.tv_sec = tk->wall_to_monotonic.tv_sec +
-				tk->total_sleep_time.tv_sec,
-		.tv_nsec = tk->wall_to_monotonic.tv_nsec +
-				tk->total_sleep_time.tv_nsec
-	};
+	unsigned seq;
+	struct timespec boottime;
+
+	do {
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
+		boottime.tv_sec = tk->wall_to_monotonic.tv_sec +
+				tk->total_sleep_time.tv_sec;
+		boottime.tv_nsec = tk->wall_to_monotonic.tv_nsec +
+				tk->total_sleep_time.tv_nsec;
+	} while (timekeeper_read_retry(seq));
 
 	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
 }
@@ -1476,7 +1564,6 @@ EXPORT_SYMBOL_GPL(getboottime);
  */
 void get_monotonic_boottime(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
 	struct timespec tomono, sleep;
 	s64 nsec;
 	unsigned int seq;
@@ -1484,13 +1571,14 @@ void get_monotonic_boottime(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
+
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 		sleep = tk->total_sleep_time;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
 	ts->tv_nsec = 0;
@@ -1521,38 +1609,31 @@ EXPORT_SYMBOL_GPL(ktime_get_boottime);
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
-
-	*ts = timespec_add(*ts, tk->total_sleep_time);
+	*ts = timespec_add(*ts, timekeeper_current()->total_sleep_time);
 }
 EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	struct timekeeper *tk = &timekeeper;
-
-	return tk->xtime_sec;
+	return timekeeper_current()->xtime_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
-
-	return tk_xtime(tk);
+	return tk_xtime(timekeeper_current());
 }
 
 struct timespec current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
 	struct timespec now;
-	unsigned long seq;
+	unsigned seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
 
 		now = tk_xtime(tk);
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	return now;
 }
@@ -1560,20 +1641,17 @@ EXPORT_SYMBOL(current_kernel_time);
 
 struct timespec get_monotonic_coarse(void)
 {
-	struct timekeeper *tk = &timekeeper;
 	struct timespec now, mono;
-	unsigned long seq;
+	unsigned seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
 
 		now = tk_xtime(tk);
 		mono = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
-	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
-				now.tv_nsec + mono.tv_nsec);
-	return now;
+	return timespec_add(now, mono);
 }
 
 /*
@@ -1595,15 +1673,15 @@ void do_timer(unsigned long ticks)
 void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 				struct timespec *wtom, struct timespec *sleep)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
+
 		*xtim = tk_xtime(tk);
 		*wtom = tk->wall_to_monotonic;
 		*sleep = tk->total_sleep_time;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
@@ -1619,13 +1697,12 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 							ktime_t *offs_tai)
 {
-	struct timekeeper *tk = &timekeeper;
 	ktime_t now;
 	unsigned int seq;
 	u64 secs, nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
 
 		secs = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
@@ -1633,7 +1710,7 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
 		*offs_tai = tk->offs_tai;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
 	now = ktime_sub(now, *offs_real);
@@ -1646,14 +1723,13 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
  */
 ktime_t ktime_get_monotonic_offset(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	unsigned seq;
 	struct timespec wtom;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		struct timekeeper const *tk = timekeeper_read_begin(&seq);
 		wtom = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(seq));
 
 	return timespec_to_ktime(wtom);
 }
@@ -1664,7 +1740,6 @@ EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
  */
 int do_adjtimex(struct timex *txc)
 {
-	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
 	struct timespec ts;
 	s32 orig_tai, tai;
@@ -1691,14 +1766,15 @@ int do_adjtimex(struct timex *txc)
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 
-	orig_tai = tai = tk->tai_offset;
+	orig_tai = tai = timekeeper_current()->tai_offset;
 	ret = __do_adjtimex(txc, &ts, &tai);
 
 	if (tai != orig_tai) {
+		struct timekeeper *tk = timekeeper_write_begin();
 		__timekeeping_set_tai_offset(tk, tai);
-		timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
+		timekeeper_write_end();
+		timekeeping_update(tk, TK_CLOCK_WAS_SET);
 	}
-	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	if (tai != orig_tai)
@@ -1712,17 +1788,23 @@ int do_adjtimex(struct timex *txc)
 #ifdef CONFIG_NTP_PPS
 /**
  * hardpps() - Accessor function to NTP __hardpps function
+ * FIXME: The NTP variables need to be duplicated in the same
+ * manner as struct timekeeper; the "locking" here doesn't actually
+ * do anything.  Unless... the write-locking part of
+ * timekeeper_write_begin is identical to regular seqlock.
+ * I could have the non-ntp timing use the duplicated info, but
+ * reads of the ntp variables use standard seqlocks.  Needs thought...
  */
 void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	(void)timekeeper_write_begin();
 
 	__hardpps(phase_ts, raw_ts);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end();
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
!e
