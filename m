Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3INTsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:48:51 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47139 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932443Ab3INTsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:48:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 7/7] Introduce timekeeper latch synchronization
Date: Sat, 14 Sep 2013 12:48:01 -0700
Message-Id: <1379188081-15613-8-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the sequence lock, this latch synchronization scheme, proposed by
Peter Zijlstra, always keeps a readable copy of the data. Therefore,
readers will never deadlock if they nest on the writer, whether this
happens because the read-side is explicitly called within the write-side
critical section, executed in a nested interrupt (e.g. NMI), or executed
in an execution context that has lock dependency with the write-side
critical section.

The only situations in which readers have to retry is if 2 updates or
more happen concurrently with the read. Therefore, the only situation
that can trigger a reader retry involves updater progress, therefore if
a reader interrupts an update, it would interrupt progress of every
updates, and therefore the reader never has to retry.

A nice side-effect of this scheme is that the reader latency in the
case readers execute concurrently with updaters should be diminished,
because readers don't have to busy-loop when executing concurrently with
updaters, unless 2 or more updates are performed concurrently with the
read.

The overhead of this scheme is that every update must perform a copy of
struct timekeeper and then modify this copy rather than to do the update
in-place.

There should not be any significant overhead added to the read-side,
given the number of memory barriers is unchanged.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/timekeeper_internal.h |   93 ++++++++-
 kernel/time/ntp.c                   |   20 +-
 kernel/time/timekeeping.c           |  375 ++++++++++++++++++++---------------
 3 files changed, 317 insertions(+), 171 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 6f0532d..af54571 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -151,7 +151,98 @@ struct timekeeper {
 	struct timekeeper_ntp	ntp;
 };
 
-extern struct timekeeper timekeeper;
+struct timekeeper_latch {
+	unsigned long head, tail;
+	struct timekeeper data[2];
+};
+
+static inline
+int timekeeper_index(struct timekeeper_latch *tl, const struct timekeeper *tk)
+{
+	return tk - &tl->data[0];
+}
+
+extern struct timekeeper_latch timekeeper_latch;
+extern raw_spinlock_t timekeeper_lock;
+
+/**
+ * timekeeper_write_begin - begin timekeeper update.
+ *
+ " @tl: struct timekeeper_latch to update.
+ * @next: pointer to next element (output parameter).
+ *
+ * The area pointed to by "next" should be considered uninitialized.
+ * The caller needs to have exclusive update access to struct timekeeper_latch.
+ */
+static inline
+void timekeeper_write_begin(struct timekeeper_latch *tl,
+		struct timekeeper **next)
+{
+	const struct timekeeper *_prev;
+	struct timekeeper *_next;
+
+	tl->head++;
+	smp_wmb();		/* Store head before storing into next entry */
+	_prev = &tl->data[tl->tail & 1];
+	_next = &tl->data[tl->head & 1];
+	*_next = *_prev;	/* Copy prev content into next */
+	if (_next->clock && _next->clock->update_latch)
+		_next->clock->update_latch(_next->clock,
+				timekeeper_index(tl, _prev),
+				timekeeper_index(tl, _next));
+	*next = _next;
+}
+
+/**
+ * timekeeper_write_end - end timekeeper update.
+ *
+ " @tl: struct timekeeper_latch.
+ *
+ * The caller needs to have exclusive update access to struct timekeeper_latch.
+ */
+static inline
+void timekeeper_write_end(struct timekeeper_latch *tl)
+{
+	smp_wmb();	/* Store into next entry before storing into tail */
+	tl->tail++;
+}
+
+/**
+ * timekeeper_read_begin - begin timekeeper read.
+ *
+ " @tl: struct timekeeper_latch to read.
+ * @tail: pointer to unsigned long containing tail position (output).
+ */
+static inline
+struct timekeeper *timekeeper_read_begin(struct timekeeper_latch *tl,
+		unsigned long *tail)
+{
+	unsigned long ret;
+
+	ret = ACCESS_ONCE(tl->tail);
+	smp_rmb();	/* Load tail before loading entry */
+	*tail = ret;
+	return &tl->data[ret & 1];
+}
+
+/**
+ * timekeeper_read_retry - end timekeeper read, trigger retry if needed.
+ *
+ " @tl: struct timekeeper_latch read.
+ * @tail: tail position returned as output by timekeeper_read_begin().
+ *
+ * If timekeeper_read_retry() returns nonzero, the content of the read should
+ * be considered invalid, and the read should be performed again to
+ * reattempt reading coherent data, starting with timekeeper_read_begin().
+ */
+static inline
+int timekeeper_read_retry(struct timekeeper_latch *tl, unsigned long tail)
+{
+	smp_rmb();	/* Load entry before loading head */
+	return (ACCESS_ONCE(tl->head) - tail >= 2);
+}
+
+extern struct timekeeper *timekeeper_get_init(void);
 
 static inline struct timespec tk_xtime(struct timekeeper *tk)
 {
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 2a1b4ef..71a5d2a 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -395,9 +395,10 @@ static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
 
 static void sync_cmos_clock(struct work_struct *work)
 {
-	struct timekeeper_ntp *ntp = &timekeeper.ntp;
+	struct timekeeper *tk;
+	unsigned long seq, local_tick_nsec;
 	struct timespec now, next;
-	int fail = 1;
+	int fail = 1, ret;
 
 	/*
 	 * If we have an externally synchronized Linux clock, then update
@@ -406,7 +407,11 @@ static void sync_cmos_clock(struct work_struct *work)
 	 * This code is run on a timer.  If the clock is set, that timer
 	 * may not expire at the correct time.  Thus, we adjust...
 	 */
-	if (!ntp_synced(ntp)) {
+	do {
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
+		ret = ntp_synced(&tk->ntp);
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
+	if (!ret) {
 		/*
 		 * Not synced, exit, do not restart a timer (if one is
 		 * running, let it run out).
@@ -415,7 +420,11 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= ntp->tick_nsec / 2) {
+	do {
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
+		local_tick_nsec = tk->ntp.tick_nsec;
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= local_tick_nsec / 2) {
 		struct timespec adjust = now;
 
 		fail = -ENODEV;
@@ -860,8 +869,9 @@ void __hardpps(struct timekeeper_ntp *ntp, const struct timespec *phase_ts,
 
 static int __init ntp_tick_adj_setup(char *str)
 {
-	struct timekeeper_ntp *ntp = &timekeeper.ntp;
+	struct timekeeper_ntp *ntp;
 
+	ntp = &timekeeper_get_init()->ntp;
 	ntp->ntp_tick_adj = simple_strtol(str, NULL, 0);
 	ntp->ntp_tick_adj <<= NTP_SCALE_SHIFT;
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2210abb..4039691 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -28,23 +28,22 @@
 #include "timekeeping_internal.h"
 
 #define TK_CLEAR_NTP		(1 << 0)
-#define TK_MIRROR		(1 << 1)
-#define TK_CLOCK_WAS_SET	(1 << 2)
-
-struct timekeeper timekeeper = {
-	.ntp = {
-		.tick_usec = TICK_USEC,
-		.time_state = TIME_OK,
-		.time_status = STA_UNSYNC,
-		.time_constant = 2,
-		.time_maxerror = NTP_PHASE_LIMIT,
-		.time_esterror = NTP_PHASE_LIMIT,
+#define TK_CLOCK_WAS_SET	(1 << 1)
+
+struct timekeeper_latch timekeeper_latch = {
+	.data[0] = {
+		.ntp = {
+			.tick_usec = TICK_USEC,
+			.time_state = TIME_OK,
+			.time_status = STA_UNSYNC,
+			.time_constant = 2,
+			.time_maxerror = NTP_PHASE_LIMIT,
+			.time_esterror = NTP_PHASE_LIMIT,
+		},
 	},
 };
 
-static DEFINE_RAW_SPINLOCK(timekeeper_lock);
-static seqcount_t timekeeper_seq;
-static struct timekeeper shadow_timekeeper;
+DEFINE_RAW_SPINLOCK(timekeeper_lock);
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
@@ -52,6 +51,16 @@ int __read_mostly timekeeping_suspended;
 /* Flag for if there is a persistent clock on this platform */
 bool __read_mostly persistent_clock_exist = false;
 
+/*
+ * timekeeper_get_init - get initial timekeeper structure (boot time init)
+ */
+struct timekeeper *timekeeper_get_init(void)
+{
+	struct timekeeper_latch *tl = &timekeeper_latch;
+
+	return &tl->data[tl->head & 1];
+}
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -114,10 +123,13 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 	cycle_t interval;
 	u64 tmp, ntpinterval;
 	struct clocksource *old_clock;
+	int tk_index = timekeeper_index(&timekeeper_latch, tk);
 
 	old_clock = tk->clock;
 	tk->clock = clock;
-	tk->cycle_last = clock->cycle_last = clock->read(clock);
+	tk->cycle_last =
+		clock->cycle_last_latch[tk_index] =
+		clock->cycle_last = clock->read(clock);
 
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
@@ -178,13 +190,22 @@ static inline s64 timekeeping_get_ns(struct timekeeper *tk)
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
 	s64 nsec;
+	int tk_index = timekeeper_index(&timekeeper_latch, tk);
 
 	/* read clocksource: */
 	clock = tk->clock;
-	cycle_now = clock->read(clock);
+	if (clock->read_latch) {
+		cycle_now = clock->read_latch(clock, tk_index);
 
-	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now -
+			clock->cycle_last_latch[tk_index]) & clock->mask;
+	} else {
+		cycle_now = clock->read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	}
 
 	nsec = cycle_delta * tk->mult + tk->xtime_nsec;
 	nsec >>= tk->shift;
@@ -198,13 +219,22 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
 	s64 nsec;
+	int tk_index = timekeeper_index(&timekeeper_latch, tk);
 
 	/* read clocksource: */
 	clock = tk->clock;
-	cycle_now = clock->read(clock);
+	if (clock->read_latch) {
+		cycle_now = clock->read_latch(clock, tk_index);
 
-	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now -
+			clock->cycle_last_latch[tk_index]) & clock->mask;
+	} else {
+		cycle_now = clock->read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	}
 
 	/* convert delta to nanoseconds. */
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
@@ -225,13 +255,15 @@ static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
  */
 int pvclock_gtod_register_notifier(struct notifier_block *nb)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 	int ret;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 	ret = raw_notifier_chain_register(&pvclock_gtod_chain, nb);
 	update_pvclock_gtod(tk, true);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
@@ -264,9 +296,6 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 	}
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
-
-	if (action & TK_MIRROR)
-		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
 }
 
 /**
@@ -281,11 +310,13 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
 	s64 nsec;
+	int tk_index = timekeeper_index(&timekeeper_latch, tk);
 
 	clock = tk->clock;
 	cycle_now = clock->read(clock);
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-	tk->cycle_last = clock->cycle_last = cycle_now;
+	tk->cycle_last = clock->cycle_last =
+		clock->cycle_last_latch[tk_index] = cycle_now;
 
 	tk->xtime_nsec += cycle_delta * tk->mult;
 
@@ -307,17 +338,15 @@ static void timekeeping_forward_now(struct timekeeper *tk)
  */
 int __getnstimeofday(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	s64 nsecs = 0;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		ts->tv_sec = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
@@ -346,18 +375,17 @@ EXPORT_SYMBOL(getnstimeofday);
 
 ktime_t ktime_get(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned int seq;
+	struct timekeeper *tk;
+	unsigned long seq;
 	s64 secs, nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -376,20 +404,19 @@ EXPORT_SYMBOL_GPL(ktime_get);
  */
 void ktime_get_ts(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec tomono;
 	s64 nsec;
-	unsigned int seq;
+	unsigned long seq;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	ts->tv_sec += tomono.tv_sec;
 	ts->tv_nsec = 0;
@@ -406,19 +433,17 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
  */
 void timekeeping_clocktai(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	u64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		ts->tv_sec = tk->xtime_sec + tk->tai_offset;
 		nsecs = timekeeping_get_ns(tk);
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
@@ -454,14 +479,14 @@ EXPORT_SYMBOL(ktime_get_clocktai);
  */
 void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	s64 nsecs_raw, nsecs_real;
 
 	WARN_ON_ONCE(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 
 		*ts_raw = tk->raw_time;
 		ts_real->tv_sec = tk->xtime_sec;
@@ -470,7 +495,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw = timekeeping_get_ns_raw(tk);
 		nsecs_real = timekeeping_get_ns(tk);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -503,7 +528,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(const struct timespec *tv)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec ts_delta, xt;
 	unsigned long flags;
 
@@ -511,7 +536,7 @@ int do_settimeofday(const struct timespec *tv)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 
 	timekeeping_forward_now(tk);
 
@@ -523,9 +548,9 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -543,7 +568,7 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 int timekeeping_inject_offset(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 	struct timespec tmp;
 	int ret = 0;
@@ -552,7 +577,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 
 	timekeeping_forward_now(tk);
 
@@ -567,9 +592,9 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -586,14 +611,14 @@ EXPORT_SYMBOL(timekeeping_inject_offset);
  */
 s32 timekeeping_get_tai_offset(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned int seq;
+	struct timekeeper *tk;
+	unsigned long seq;
 	s32 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		ret = tk->tai_offset;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	return ret;
 }
@@ -614,13 +639,13 @@ static void __timekeeping_set_tai_offset(struct timekeeper *tk, s32 tai_offset)
  */
 void timekeeping_set_tai_offset(s32 tai_offset)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 	__timekeeping_set_tai_offset(tk, tai_offset);
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	clock_was_set();
 }
@@ -632,14 +657,14 @@ void timekeeping_set_tai_offset(s32 tai_offset)
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
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 
 	timekeeping_forward_now(tk);
 	/*
@@ -657,9 +682,9 @@ static int change_clocksource(void *data)
 			module_put(new->owner);
 		}
 	}
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return 0;
@@ -674,13 +699,25 @@ static int change_clocksource(void *data)
  */
 int timekeeping_notify(struct clocksource *clock)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
+	struct clocksource *current_clock;
+	unsigned long seq;
 
-	if (tk->clock == clock)
+	do {
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
+		current_clock = tk->clock;
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
+	if (current_clock == clock)
 		return 0;
+
 	stop_machine(change_clocksource, clock, NULL);
 	tick_clock_notify();
-	return tk->clock == clock ? 0 : -1;
+
+	do {
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
+		current_clock = tk->clock;
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
+	return current_clock == clock ? 0 : -1;
 }
 
 /**
@@ -706,16 +743,15 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
  */
 void getrawmonotonic(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	s64 nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		nsecs = timekeeping_get_ns_raw(tk);
 		*ts = tk->raw_time;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -726,16 +762,14 @@ EXPORT_SYMBOL(getrawmonotonic);
  */
 int timekeeping_valid_for_hres(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	int ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		ret = tk->clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	return ret;
 }
@@ -745,16 +779,14 @@ int timekeeping_valid_for_hres(void)
  */
 u64 timekeeping_max_deferment(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	u64 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		ret = tk->clock->max_idle_ns;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	return ret;
 }
@@ -794,7 +826,7 @@ void __attribute__((weak)) read_boot_clock(struct timespec *ts)
  */
 void __init timekeeping_init(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct clocksource *clock;
 	unsigned long flags;
 	struct timespec now, boot, tmp;
@@ -818,7 +850,7 @@ void __init timekeeping_init(void)
 	}
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 	ntp_init(&tk->ntp);
 
 	clock = clocksource_default_clock();
@@ -839,9 +871,7 @@ void __init timekeeping_init(void)
 	tmp.tv_nsec = 0;
 	tk_set_sleep_time(tk, tmp);
 
-	memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
-
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
@@ -881,7 +911,7 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
  */
 void timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 
 	/*
@@ -892,15 +922,15 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 		return;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 
 	timekeeping_forward_now(tk);
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -916,12 +946,13 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
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
 	bool suspendtime_found = false;
+	int tk_index;
 
 	read_persistent_clock(&ts_new);
 
@@ -929,7 +960,9 @@ static void timekeeping_resume(void)
 	clocksource_resume();
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
+	clock = tk->clock;
+	tk_index = timekeeper_index(&timekeeper_latch, tk);
 
 	/*
 	 * After system resumes, we need to calculate the suspended time and
@@ -977,11 +1010,12 @@ static void timekeeping_resume(void)
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
 
 	/* Re-base the last cycle value */
-	tk->cycle_last = clock->cycle_last = cycle_now;
+	tk->cycle_last = clock->cycle_last =
+		clock->cycle_last_latch[tk_index] = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
-	write_seqcount_end(&timekeeper_seq);
+	timekeeping_update(tk, TK_CLOCK_WAS_SET);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	touch_softlockup_watchdog();
@@ -994,7 +1028,7 @@ static void timekeeping_resume(void)
 
 static int timekeeping_suspend(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 	struct timespec		delta, delta_delta;
 	static struct timespec	old_delta;
@@ -1010,7 +1044,7 @@ static int timekeeping_suspend(void)
 		persistent_clock_exist = true;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 	timekeeping_forward_now(tk);
 	timekeeping_suspended = 1;
 
@@ -1033,7 +1067,7 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
@@ -1372,29 +1406,31 @@ static inline void old_vsyscall_fixup(struct timekeeper *tk)
 static void update_wall_time(void)
 {
 	struct clocksource *clock;
-	struct timekeeper *real_tk = &timekeeper;
-	struct timekeeper *tk = &shadow_timekeeper;
+	struct timekeeper *tk;
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned int action;
 	unsigned long flags;
+	int tk_index;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
+	tk_index = timekeeper_index(&timekeeper_latch, tk);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-	clock = real_tk->clock;
+	clock = tk->clock;
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	offset = real_tk->cycle_interval;
+	offset = tk->cycle_interval;
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 
 	/* Check if there's really nothing to do */
-	if (offset < real_tk->cycle_interval)
+	if (offset < tk->cycle_interval)
 		goto out;
 
 	/*
@@ -1431,23 +1467,11 @@ static void update_wall_time(void)
 	 */
 	action = accumulate_nsecs_to_secs(tk);
 
-	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
-	clock->cycle_last = tk->cycle_last;
-	/*
-	 * Update the real timekeeper.
-	 *
-	 * We could avoid this memcpy by switching pointers, but that
-	 * requires changes to all other timekeeper usage sites as
-	 * well, i.e. move the timekeeper pointer getter into the
-	 * spinlocked/seqcount protected sections. And we trade this
-	 * memcpy under the timekeeper_seq against one before we start
-	 * updating.
-	 */
-	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, action);
-	write_seqcount_end(&timekeeper_seq);
+	clock->cycle_last_latch[tk_index] = clock->cycle_last = tk->cycle_last;
+	timekeeping_update(tk, action);
 out:
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
@@ -1464,13 +1488,17 @@ out:
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
+	struct timekeeper *tk;
+	struct timespec boottime;
+	unsigned long seq;
+
+	do {
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
+		boottime.tv_sec = tk->wall_to_monotonic.tv_sec +
+				tk->total_sleep_time.tv_sec;
+		boottime.tv_nsec = tk->wall_to_monotonic.tv_nsec +
+				tk->total_sleep_time.tv_nsec;
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
 }
@@ -1487,21 +1515,20 @@ EXPORT_SYMBOL_GPL(getboottime);
  */
 void get_monotonic_boottime(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec tomono, sleep;
 	s64 nsec;
-	unsigned int seq;
+	unsigned long seq;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 		sleep = tk->total_sleep_time;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
 	ts->tv_nsec = 0;
@@ -1532,38 +1559,57 @@ EXPORT_SYMBOL_GPL(ktime_get_boottime);
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
+	struct timespec ret;
+	unsigned long seq;
+
+	do {
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
+		ret = timespec_add(*ts, tk->total_sleep_time);
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
-	*ts = timespec_add(*ts, tk->total_sleep_time);
+	*ts = ret;
 }
 EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
+	unsigned long seq, ret;
+
+	do {
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
+		ret = tk->xtime_sec;
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
-	return tk->xtime_sec;
+	return ret;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
+	unsigned long seq;
+	struct timespec ret;
+
+	do {
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
+		ret = tk_xtime(tk);
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
-	return tk_xtime(tk);
+	return ret;
 }
 
 struct timespec current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec now;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		now = tk_xtime(tk);
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	return now;
 }
@@ -1571,16 +1617,15 @@ EXPORT_SYMBOL(current_kernel_time);
 
 struct timespec get_monotonic_coarse(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec now, mono;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		now = tk_xtime(tk);
 		mono = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1607,15 +1652,15 @@ void do_timer(unsigned long ticks)
 void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 				struct timespec *wtom, struct timespec *sleep)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		*xtim = tk_xtime(tk);
 		*wtom = tk->wall_to_monotonic;
 		*sleep = tk->total_sleep_time;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
@@ -1630,13 +1675,13 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 							ktime_t *offs_tai)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	ktime_t now;
-	unsigned int seq;
+	unsigned long seq;
 	u64 secs, nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 
 		secs = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
@@ -1644,7 +1689,7 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
 		*offs_tai = tk->offs_tai;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
 	now = ktime_sub(now, *offs_real);
@@ -1657,14 +1702,14 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
  */
 ktime_t ktime_get_monotonic_offset(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	struct timespec wtom;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&timekeeper_latch, &seq);
 		wtom = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&timekeeper_latch, seq));
 
 	return timespec_to_ktime(wtom);
 }
@@ -1675,7 +1720,7 @@ EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
  */
 int do_adjtimex(struct timex *txc)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 	struct timespec ts;
 	s32 orig_tai, tai;
@@ -1700,7 +1745,7 @@ int do_adjtimex(struct timex *txc)
 	getnstimeofday(&ts);
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 
 	orig_tai = tai = tk->tai_offset;
 	ret = __do_adjtimex(&tk->ntp, txc, &ts, &tai);
@@ -1710,7 +1755,7 @@ int do_adjtimex(struct timex *txc)
 		update_pvclock_gtod(tk, true);
 		clock_was_set_delayed();
 	}
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	ntp_notify_cmos_timer();
@@ -1724,15 +1769,15 @@ int do_adjtimex(struct timex *txc)
  */
 void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&timekeeper_latch, &tk);
 
 	__hardpps(&tk->ntp, phase_ts, raw_ts);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&timekeeper_latch);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
-- 
1.7.10.4

