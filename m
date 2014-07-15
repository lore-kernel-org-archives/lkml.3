Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbaGOJAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:00:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:44594 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758307AbaGOI7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:59:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,664,1400050800"; 
   d="scan'208";a="457092214"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v2 4/7] perf, x86: large PEBS interrupt threshold
Date: Tue, 15 Jul 2014 16:58:56 +0800
Message-Id: <1405414739-31455-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PEBS always had the capability to log samples to its buffers without
an interrupt. Traditionally perf has not used this but always set the
PEBS threshold to one.

For frequently occuring events (like cycles or branches or load/stores)
this in term requires using a relatively high sampling period to avoid
overloading the system, by only processing PMIs. This in term increases
sampling error.

For the common cases we still need to use the PMI because the PEBS
hardware has various limitations. The biggest one is that it can not
supply a callgraph. It also requires setting a fixed period, as the
hardware does not support adaptive period. Another issue is that it
cannot supply a time stamp and some other options. To supply a TID it
requires flushing on context switch. It can however supply the IP, the
load/store address, TSX information, registers, and some other things.

So we can make PEBS work for some specific cases, basically as long as
you can do without a callgraph and can set the period you can use this
new PEBS mode.

The main benefit is the ability to support much lower sampling period
(down to -c 1000) without extensive overhead.

One use cases is for example to increase the resolution of the c2c tool.
Another is double checking when you suspect the standard sampling has
too much sampling error.

Some numbers on the overhead, using cycle soak, comparing
"perf record --no-time -e cycles:p -c" to "perf record -e cycles:p -c"

period    plain  multi  delta
10003     15     5      10
20003     15.7   4      11.7
40003     8.7    2.5    6.2
80003     4.1    1.4    2.7
100003    3.6    1.2    2.4
800003    4.4    1.4    3
1000003   0.6    0.4    0.2
2000003   0.4    0.3    0.1
4000003   0.3    0.2    0.1
10000003  0.3    0.2    0.1

The interesting part is the delta between multi-pebs and normal pebs. Above
-c 1000003 it does not really matter because the basic overhead is so low.
With periods below 80003 it becomes interesting.

Note in some other workloads (e.g. kernbench) the smaller sampling periods
cause much more overhead without multi-pebs,  upto 80% (and throttling) have
been observed with -c 10003. multi pebs generally does not throttle.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           |  1 +
 arch/x86/kernel/cpu/perf_event_intel_ds.c  | 98 +++++++++++++++++++++---------
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  5 --
 3 files changed, 71 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d8165f3..cb7cda8 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -450,6 +450,7 @@ struct x86_pmu {
 	struct event_constraint *pebs_constraints;
 	void		(*pebs_aliases)(struct perf_event *event);
 	int 		max_pebs_events;
+	bool		multi_pebs;
 
 	/*
 	 * Intel LBR
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 1db4ce5..e17eb5b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -11,7 +11,7 @@
 #define BTS_RECORD_SIZE		24
 
 #define BTS_BUFFER_SIZE		(PAGE_SIZE << 4)
-#define PEBS_BUFFER_SIZE	PAGE_SIZE
+#define PEBS_BUFFER_SIZE	(PAGE_SIZE << 4)
 #define PEBS_FIXUP_SIZE		PAGE_SIZE
 
 /*
@@ -251,7 +251,7 @@ static int alloc_pebs_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
 	int node = cpu_to_node(cpu);
-	int max, thresh = 1; /* always use a single PEBS record */
+	int max;
 	void *buffer, *ibuffer;
 
 	if (!x86_pmu.pebs)
@@ -281,9 +281,6 @@ static int alloc_pebs_buffer(int cpu)
 	ds->pebs_absolute_maximum = ds->pebs_buffer_base +
 		max * x86_pmu.pebs_record_size;
 
-	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
-		thresh * x86_pmu.pebs_record_size;
-
 	return 0;
 }
 
@@ -708,14 +705,29 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 	return &emptyconstraint;
 }
 
+/*
+ * Flags PEBS can handle without an PMI.
+ *
+ * TID can only be handled by flushing at context switch.
+ */
+#define PEBS_FREERUNNING_FLAGS \
+	(PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_ADDR | \
+	 PERF_SAMPLE_ID | PERF_SAMPLE_CPU | PERF_SAMPLE_STREAM_ID | \
+	 PERF_SAMPLE_DATA_SRC | PERF_SAMPLE_IDENTIFIER | \
+	 PERF_SAMPLE_TRANSACTION)
+
 void intel_pmu_pebs_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
+	struct debug_store *ds = cpuc->ds;
+	u64 threshold;
+	bool first_pebs;
 
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 	hwc->autoreload = !event->attr.freq;
 
+	first_pebs = !(cpuc->pebs_enabled & ((1ULL << MAX_PEBS_EVENTS) - 1));
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
 
 	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT)
@@ -723,6 +735,20 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
 		cpuc->pebs_enabled |= 1ULL << 63;
 
+	/*
+	 * When the event is constrained enough we can use a larger
+	 * threshold and run the event with less frequent PMI.
+	 */
+	if (x86_pmu.multi_pebs && hwc->autoreload &&
+	    !(event->attr.sample_type & ~PEBS_FREERUNNING_FLAGS)) {
+		threshold = ds->pebs_absolute_maximum -
+			x86_pmu.max_pebs_events * x86_pmu.pebs_record_size;
+	} else {
+		threshold = ds->pebs_buffer_base + x86_pmu.pebs_record_size;
+	}
+	if (first_pebs || ds->pebs_interrupt_threshold > threshold)
+		ds->pebs_interrupt_threshold = threshold;
+
 	/* Use auto-reload if possible to save a MSR write in the PMI */
 	if (hwc->autoreload)
 		ds->pebs_event_reset[hwc->idx] =
@@ -867,7 +893,8 @@ static inline u64 intel_hsw_transaction(struct pebs_record_hsw *pebs)
 }
 
 static void __intel_pmu_pebs_event(struct perf_event *event,
-				   struct pt_regs *iregs, void *__pebs)
+				   struct pt_regs *iregs, void *__pebs,
+				   bool first_record)
 {
 	/*
 	 * We cast to the biggest pebs_record but are careful not to
@@ -880,7 +907,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	u64 sample_type;
 	int fll, fst;
 
-	if (!intel_pmu_save_and_restart(event))
+	if (first_record && !intel_pmu_save_and_restart(event))
 		return;
 
 	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
@@ -956,8 +983,22 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-	if (perf_event_overflow(event, &data, &regs))
-		x86_pmu_stop(event, 0);
+	if (first_record) {
+		if (perf_event_overflow(event, &data, &regs))
+			x86_pmu_stop(event, 0);
+	} else {
+		struct perf_output_handle handle;
+		struct perf_event_header header;
+
+		perf_prepare_sample(&header, &data, event, &regs);
+
+		if (perf_output_begin(&handle, event, header.size))
+			return;
+
+		perf_output_sample(&handle, &header, &data, event);
+
+		perf_output_end(&handle);
+	}
 }
 
 static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
@@ -998,17 +1039,18 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	WARN_ONCE(n > 1, "bad leftover pebs %d\n", n);
 	at += n - 1;
 
-	__intel_pmu_pebs_event(event, iregs, at);
+	__intel_pmu_pebs_event(event, iregs, at, true);
 }
 
 static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
-	struct perf_event *event = NULL;
+	struct perf_event *event;
 	void *at, *top;
 	u64 status = 0;
 	int bit;
+	bool multi_pebs, first_record;
 
 	if (!x86_pmu.pebs_active)
 		return;
@@ -1021,17 +1063,19 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	if (unlikely(at > top))
 		return;
 
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(top - at > x86_pmu.max_pebs_events * x86_pmu.pebs_record_size,
-		  "Unexpected number of pebs records %ld\n",
-		  (long)(top - at) / x86_pmu.pebs_record_size);
+	if (ds->pebs_interrupt_threshold >
+	    ds->pebs_buffer_base + x86_pmu.pebs_record_size)
+		multi_pebs = true;
+	else
+		multi_pebs = false;
 
 	for (; at < top; at += x86_pmu.pebs_record_size) {
 		struct pebs_record_nhm *p = at;
 
+		/*
+		 * PEBS creates only one entry if multiple counters
+		 * overflow simultaneously.
+		 */
 		for_each_set_bit(bit, (unsigned long *)&p->status,
 				 x86_pmu.max_pebs_events) {
 			event = cpuc->events[bit];
@@ -1042,17 +1086,15 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 
 			if (!event->attr.precise_ip)
 				continue;
-
-			if (__test_and_set_bit(bit, (unsigned long *)&status))
-				continue;
-
-			break;
+			if (!__test_and_set_bit(bit, (unsigned long *)&status)) {
+				first_record = true;
+			} else {
+				if (!multi_pebs)
+					continue;
+				first_record = false;
+			}
+			__intel_pmu_pebs_event(event, iregs, at, first_record);
 		}
-
-		if (!event || bit >= x86_pmu.max_pebs_events)
-			continue;
-
-		__intel_pmu_pebs_event(event, iregs, at);
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d6d5fcf..430f1ad 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -184,10 +184,6 @@ void intel_pmu_lbr_reset(void)
 void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-
-	if (!x86_pmu.lbr_nr)
-		return;
-
 	/*
 	 * It is necessary to flush the stack on context switch. This happens
 	 * when the branch stack does not tag its entries with the pid of the
@@ -408,7 +404,6 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 
 	if (br_type & PERF_SAMPLE_BRANCH_COND)
 		mask |= X86_BR_JCC;
-
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
-- 
1.9.3

