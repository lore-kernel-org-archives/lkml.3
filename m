Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaGKNrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:47:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:56320 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaGKNpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:45:21 -0400
Message-Id: <20140711133709.835700036@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:45:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-nmi-safe-access-to-mono-raw.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracers want a correlated time between the kernel instrumentation and
user space. We really do not want to export sched_clock() to user
space, so we need to provide something sensible for this.

Using separate data structures with an non blocking sequence count
based update mechanism allows us to do that. The data structure
required for the readout has a sequence counter and two copies of the
timekeeping data.

On the update side:

  tkf->seq++;
  smp_wmb();
  update(tkf->base[0], tk;
  tkf->seq++;
  smp_wmb();
  update(tkf->base[1], tk;

On the reader side:

  do {
     seq = tkf->seq;
     smp_rmb();
     idx = seq & 0x01;
     now = now(tkf->base[idx]);
     smp_rmb();
  } while (seq != tkf->seq)

So if NMI hits the update of base[0] it will use base[1] which is
still consistent. In case of CLOCK_MONOTONIC this can result in
slightly wrong timestamps (a few nanoseconds) accross an update. Not a
big issue for the intended use case.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/timekeeping.h |    2 
 kernel/time/timekeeping.c   |  208 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 183 insertions(+), 27 deletions(-)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -164,6 +164,8 @@ static inline u64 ktime_get_raw_ns(void)
 	return ktime_to_ns(ktime_get_raw());
 }
 
+extern u64 ktime_get_mono_fast_ns(void);
+
 /*
  * Timespec interfaces utilizing the ktime based ones
  */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -50,6 +50,42 @@ int __read_mostly timekeeping_suspended;
 /* Flag for if there is a persistent clock on this platform */
 bool __read_mostly persistent_clock_exist = false;
 
+/**
+ * struct tk_fast_base - timekeeper data for NMI safe fast access
+ * @clock:	Pointer to the clocksource
+ * @cycle_last:	The reference cycles for delta calculation
+ * @base:	The base value for the readout
+ * @shift:	Shift factor for scaled math
+ * @mult:	Mult factor for scaled math
+ *
+ * Note: We store cycle_last independent from clock->cycle_last so the
+ * update of the real timekeeper does not disturb the fast ones.
+ */
+struct tk_fast_base {
+	struct clocksource	*clock;
+	cycle_t			cycle_last;
+	u64			base;
+	u32			shift;
+	u32			mult;
+};
+
+/**
+ * struct tk_fast - NMI safe timekeeper
+ * @seq:	Sequence counter for protecting updates. The lowest bit
+ *		is the index for the tk_fast_base array
+ * @base:	tk_fast_base array. Access is indexed by the lowest bit of
+ *		@seq.
+ *
+ * See @update_fast_timekeeper() below.
+ */
+struct tk_fast {
+	seqcount_t		seq;
+	struct tk_fast_base	base[2];
+};
+
+static struct tk_fast tk_fast_raw  ____cacheline_aligned;
+static struct tk_fast tk_fast_mono ____cacheline_aligned;
+
 /*
  * The xtime based monotonic readout is:
  *	nsec = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec + now();
@@ -215,7 +251,7 @@ static inline s64 timekeeping_get_ns(str
 	return nsec + arch_gettimeoffset();
 }
 
-static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
+static inline s64 notrace timekeeping_get_ns_raw(struct tk_fast_base *tk)
 {
 	cycle_t cycle_now, delta;
 	struct clocksource *clock;
@@ -226,7 +262,7 @@ static inline s64 timekeeping_get_ns_raw
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, clock->cycle_last, clock->mask);
+	delta = clocksource_delta(cycle_now, tk->cycle_last, clock->mask);
 
 	/* convert delta to nanoseconds. */
 	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
@@ -235,6 +271,136 @@ static inline s64 timekeeping_get_ns_raw
 	return nsec + arch_gettimeoffset();
 }
 
+/**
+ * update_fast_timekeeper - Update the fast and NMI safe monotonic timekeeper.
+ * @tk:		The timekeeper from which we take the update
+ * @tkf:	The fast timekeeper to update
+ * @tbase:	The time base for the fast timekeeper (mono/raw)
+ *
+ * We want to use this from any context including NMI and tracing /
+ * instrumenting the timekeeping code itself.
+ *
+ * So we handle this differently than the other timekeeping accessor
+ * functions which retry when the sequence count has changed. The
+ * update side does:
+ *
+ * tkf->seq++;
+ * smp_wmb();
+ * update(tkf->base[0], tk;
+ * tkf->seq++;
+ * smp_wmb();
+ * update(tkf->base[1], tk;
+ *
+ * The reader side does:
+ *
+ * do {
+ *	seq = tkf->seq;
+ *	smp_rmb();
+ *	idx = seq & 0x01;
+ *	now = now(tkf->base[idx]);
+ *	smp_rmb();
+ * } while (seq != tkf->seq)
+ *
+ * As long as we update base[0] readers are forced off to
+ * base[1]. Once base[0] is updated readers are redirected to base[0]
+ * and the base[1] update takes place.
+ *
+ * Soif NMI hits the update of base[0] then it will use base[1] which
+ * is still consistent. In the worst case this can result is a
+ * slightly wrong timestamp (a few nanoseconds) for CLOCK_MONOTONIC
+ * only. Tracing and instrumentation is blury anyway, so this is not
+ * really an issue.
+ */
+static void update_fast_timekeeper(struct clocksource *clk, struct tk_fast *tkf,
+				   s64 tbase, u32 mult, u32 shift)
+{
+	struct tk_fast_base *base = tkf->base;
+
+	/* Force readers off to base[1] */
+	raw_write_seqcount_begin(&tkf->seq);
+
+	/* Update base[0] */
+	base->clock = clk;
+	base->cycle_last = clk->cycle_last;
+	base->base = tbase;
+	base->shift = shift;
+	base->mult = mult;
+
+	/* Force readers back to base[0] */
+	raw_write_seqcount_end(&tkf->seq);
+
+	/* Update base[1] */
+	base++;
+	base->clock = clk;
+	base->cycle_last = clk->cycle_last;
+	base->base = tbase;
+	base->shift = shift;
+	base->mult = mult;
+}
+
+static void update_fast_timekeepers(struct timekeeper *tk)
+{
+	struct clocksource *clk = tk->clock;
+	s64 base;
+
+	/*
+	 * Calulate the monotonic base in nano seconds. That's less
+	 * accurate than the real monotonic time as we drop the
+	 * fractial nsecs of xtime_nsec with the shift. But good
+	 * enough for the fast stuff we want.
+	 */
+	base = ktime_to_ns(tk->base_mono) + (tk->xtime_nsec >> tk->shift);
+	update_fast_timekeeper(clk, &tk_fast_mono, base, tk->mult, tk->shift);
+	/* Update the raw timekeeper */
+	base = ktime_to_ns(tk->base_raw);
+	update_fast_timekeeper(clk, &tk_fast_raw, base, clk->mult, clk->shift);
+}
+
+/*
+ * The reader function for the fast NMI safe timekeepers.
+ */
+static u64 notrace ktime_get_fast_ns(struct tk_fast *tkf)
+{
+	struct tk_fast_base *b;
+	unsigned int seq;
+	u64 now;
+
+	do {
+		seq = raw_read_seqcount(&tkf->seq);
+		b = tkf->base + (seq & 0x01);
+		now = b->base + timekeeping_get_ns_raw(b);
+
+	} while (read_seqcount_retry(&tkf->seq, seq));
+	return now;
+}
+
+/**
+ * ktime_get_raw - Returns the raw monotonic time in ktime_t format
+ *
+ * Can be called from any context including NMI
+ */
+ktime_t notrace ktime_get_raw(void)
+{
+	return ns_to_ktime(ktime_get_fast_ns(&tk_fast_raw));
+}
+EXPORT_SYMBOL_GPL(ktime_get_raw);
+
+/**
+ * ktime_get_mono_fast_ns - Fast NMI safe access to clock monotonic
+ *
+ * This timestamp is not guaranteed to be monotonic because the
+ * nanoseconds reminder of the base time is not accounted. So accross
+ * an update time can go slighty backwards in the single digit
+ * nanoseconds range, if the mult/shift factors are adjusted by the
+ * update. So don't use this for code which might be sensitive about
+ * that. For the intended use case of tracing and instrumentation its
+ * a non issue.
+ */
+u64 notrace ktime_get_mono_fast_ns(void)
+{
+	return ktime_get_fast_ns(&tk_fast_mono);
+}
+
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
 
 static inline void update_vsyscall(struct timekeeper *tk)
@@ -324,6 +490,8 @@ static void timekeeping_update(struct ti
 	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &tk_core.timekeeper,
 		       sizeof(tk_core.timekeeper));
+
+	update_fast_timekeepers(tk);
 }
 
 /**
@@ -470,27 +638,6 @@ ktime_t ktime_mono_to_any(ktime_t tmono,
 EXPORT_SYMBOL_GPL(ktime_mono_to_any);
 
 /**
- * ktime_get_raw - Returns the raw monotonic time in ktime_t format
- */
-ktime_t ktime_get_raw(void)
-{
-	struct timekeeper *tk = &tk_core.timekeeper;
-	unsigned int seq;
-	ktime_t base;
-	s64 nsecs;
-
-	do {
-		seq = read_seqcount_begin(&tk_core.seq);
-		base = tk->base_raw;
-		nsecs = timekeeping_get_ns_raw(tk);
-
-	} while (read_seqcount_retry(&tk_core.seq, seq));
-
-	return ktime_add_ns(base, nsecs);
-}
-EXPORT_SYMBOL_GPL(ktime_get_raw);
-
-/**
  * ktime_get_ts64 - get the monotonic clock in timespec64 format
  * @ts:		pointer to timespec variable
  *
@@ -574,13 +721,19 @@ void getnstime_raw_and_real(struct times
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 
-		*ts_raw = timespec64_to_timespec(tk->raw_time);
 		ts_real->tv_sec = tk->xtime_sec;
 		ts_real->tv_nsec = 0;
-
-		nsecs_raw = timekeeping_get_ns_raw(tk);
 		nsecs_real = timekeeping_get_ns(tk);
 
+		/*
+		 * base[0] of tk_fast_raw is valid here as we are
+		 * protected by the tk_core.seq counter. The raw_base
+		 * has it's own sequence counter, but that is updated
+		 * under tk_core.seq.
+		 */
+		*ts_raw = timespec64_to_timespec(tk->raw_time);
+		nsecs_raw = timekeeping_get_ns_raw(tk_fast_raw.base);
+
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
@@ -813,7 +966,7 @@ void getrawmonotonic(struct timespec *ts
 
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
-		nsecs = timekeeping_get_ns_raw(tk);
+		nsecs = timekeeping_get_ns_raw(tk_fast_raw.base);
 		ts64 = tk->raw_time;
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
@@ -946,6 +1099,7 @@ void __init timekeeping_init(void)
 
 	memcpy(&shadow_timekeeper, &tk_core.timekeeper,
 	       sizeof(tk_core.timekeeper));
+	update_fast_timekeepers(tk);
 
 	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);


