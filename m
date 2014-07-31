Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaGaGpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:45:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:8726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193AbaGaGpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:45:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="578059842"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 5/9] perf, x86: large PEBS interrupt threshold
Date: Thu, 31 Jul 2014 14:45:00 +0800
Message-Id: <1406789104-25863-6-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
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
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 40 +++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 06b4884..7df9092 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
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
 
@@ -710,15 +707,35 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
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
+static inline bool pebs_is_enabled(struct cpu_hw_events *cpuc)
+{
+	return (cpuc->pebs_enabled & ((1ULL << MAX_PEBS_EVENTS) - 1));
+}
+
 void intel_pmu_pebs_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
+	struct debug_store *ds = cpuc->ds;
+	bool first_pebs;
+	u64 threshold;
 
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 	if (!event->attr.freq)
 		hwc->flags |= PERF_X86_EVENT_AUTO_RELOAD;
 
+	first_pebs = !pebs_is_enabled(cpuc);
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
 
 	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT)
@@ -726,6 +743,21 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
 		cpuc->pebs_enabled |= 1ULL << 63;
 
+	/*
+	 * When the event is constrained enough we can use a larger
+	 * threshold and run the event with less frequent PMI.
+	 */
+	if (0 && /* disable this temporarily */
+	    (hwc->flags & PERF_X86_EVENT_AUTO_RELOAD) &&
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
 	if (hwc->flags &PERF_X86_EVENT_AUTO_RELOAD) {
 		ds->pebs_event_reset[hwc->idx] =
-- 
1.9.3

