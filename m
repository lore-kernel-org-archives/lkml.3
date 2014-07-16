Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaGPVGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:06:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:59935 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaGPVFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:25 -0400
Message-Id: <20140716205057.569512979@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch V2 63/64] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC
References: <20140716205018.175419210@linutronix.de>
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

  smp_wmb();
  tkf->seq++;
  smp_wmb();
  update(tkf->base[0], tk);
  smp_wmb();
  tkf->seq++;
  smp_wmb();
  update(tkf->base[1], tk);

On the reader side:

  do {
     seq = tkf->seq;
     smp_rmb();
     idx = seq & 0x01;
     now = now(tkf->base[idx]);
     smp_rmb();
  } while (seq != tkf->seq)

So if a NMI hits the update of base[0] it will use base[1] which is
still consistent, but this timestamp is not guaranteed to be monotonic
across an update.

The timestamp is calculated by:

	now = base_mono + clock_delta * slope

So if the update lowers the slope, readers who are forced to the
not yet updated second array are still using the old steeper slope.

 tmono
 ^
 |    o  n
 |   o n
 |  u
 | o
 |o
 |12345678---> reader order

 o = old slope
 u = update
 n = new slope

So reader 6 will observe time going backwards versus reader 5.

While other CPUs are likely to be able observe that, the only way
for a CPU local observation is when an NMI hits in the middle of
the update. Timestamps taken from that NMI context might be ahead
of the following timestamps. Callers need to be aware of that and
deal with it.

V2: Got rid of clock monotonic raw and reorganized the data
    structures. Folded in the barrier fix from Mathieu.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/timekeeping.h |    2 
 kernel/time/timekeeping.c   |  124 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+)

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
@@ -44,6 +44,22 @@ static struct {
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
 static struct timekeeper shadow_timekeeper;
 
+/**
+ * struct tk_fast - NMI safe timekeeper
+ * @seq:	Sequence counter for protecting updates. The lowest bit
+ *		is the index for the tk_read_base array
+ * @base:	tk_read_base array. Access is indexed by the lowest bit of
+ *		@seq.
+ *
+ * See @update_fast_timekeeper() below.
+ */
+struct tk_fast {
+	seqcount_t		seq;
+	struct tk_read_base	base[2];
+};
+
+static struct tk_fast tk_fast_mono ____cacheline_aligned;
+
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
@@ -210,6 +226,112 @@ static inline s64 timekeeping_get_ns_raw
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
+ * smp_wmb();	<- Ensure that the last base[1] update is visible
+ * tkf->seq++;
+ * smp_wmb();	<- Ensure that the seqcount update is visible
+ * update(tkf->base[0], tk);
+ * smp_wmb();	<- Ensure that the base[0] update is visible
+ * tkf->seq++;
+ * smp_wmb();	<- Ensure that the seqcount update is visible
+ * update(tkf->base[1], tk);
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
+ * So if a NMI hits the update of base[0] then it will use base[1]
+ * which is still consistent. In the worst case this can result is a
+ * slightly wrong timestamp (a few nanoseconds). See
+ * @ktime_get_mono_fast_ns.
+ */
+static void update_fast_timekeeper(struct timekeeper *tk)
+{
+	struct tk_read_base *base = tk_fast_mono.base;
+
+	/* Force readers off to base[1] */
+	raw_write_seqcount_latch(&tk_fast_mono.seq);
+
+	/* Update base[0] */
+	memcpy(base, &tk->tkr, sizeof(*base));
+
+	/* Force readers back to base[0] */
+	raw_write_seqcount_latch(&tk_fast_mono.seq);
+
+	/* Update base[1] */
+	memcpy(base + 1, base, sizeof(*base));
+}
+
+/**
+ * ktime_get_mono_fast_ns - Fast NMI safe access to clock monotonic
+ *
+ * This timestamp is not guaranteed to be monotonic across an update.
+ * The timestamp is calculated by:
+ *
+ *	now = base_mono + clock_delta * slope
+ *
+ * So if the update lowers the slope, readers who are forced to the
+ * not yet updated second array are still using the old steeper slope.
+ *
+ * tmono
+ * ^
+ * |    o  n
+ * |   o n
+ * |  u
+ * | o
+ * |o
+ * |12345678---> reader order
+ *
+ * o = old slope
+ * u = update
+ * n = new slope
+ *
+ * So reader 6 will observe time going backwards versus reader 5.
+ *
+ * While other CPUs are likely to be able observe that, the only way
+ * for a CPU local observation is when an NMI hits in the middle of
+ * the update. Timestamps taken from that NMI context might be ahead
+ * of the following timestamps. Callers need to be aware of that and
+ * deal with it.
+ */
+u64 notrace ktime_get_mono_fast_ns(void)
+{
+	struct tk_read_base *tkr;
+	unsigned int seq;
+	u64 now;
+
+	do {
+		seq = raw_read_seqcount(&tk_fast_mono.seq);
+		tkr = tk_fast_mono.base + (seq & 0x01);
+		now = ktime_to_ns(tkr->base_mono) + timekeeping_get_ns(tkr);
+
+	} while (read_seqcount_retry(&tk_fast_mono.seq, seq));
+	return now;
+}
+EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);
+
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
 
 static inline void update_vsyscall(struct timekeeper *tk)
@@ -325,6 +447,8 @@ static void timekeeping_update(struct ti
 	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &tk_core.timekeeper,
 		       sizeof(tk_core.timekeeper));
+
+	update_fast_timekeeper(tk);
 }
 
 /**


