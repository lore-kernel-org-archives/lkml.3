Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaE1GS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:18:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:44287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbaE1GSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:18:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,926,1392192000"; 
   d="scan'208";a="538750655"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH 7/7] perf, x86: drain PEBS buffer during context switch
Date: Wed, 28 May 2014 14:18:10 +0800
Message-Id: <1401257890-30535-8-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flush the PEBS buffer during context switch if PEBS interrupt threshold
is larger than one. This allows perf to supply TID for events.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           |  3 +++
 arch/x86/kernel/cpu/perf_event_intel.c     | 11 +++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c  | 42 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  4 ---
 4 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index cb7cda8..eafea09 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -147,6 +147,7 @@ struct cpu_hw_events {
 	 */
 	struct debug_store	*ds;
 	u64			pebs_enabled;
+	bool			pebs_sched_cb_enabled;
 
 	/*
 	 * Intel LBR bits
@@ -683,6 +684,8 @@ void intel_pmu_pebs_enable_all(void);
 
 void intel_pmu_pebs_disable_all(void);
 
+void intel_pmu_pebs_sched_task(struct perf_event_context *ctx, bool sched_in);
+
 void intel_ds_init(void);
 
 void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6c2a380..dba03b3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2035,6 +2035,15 @@ static void intel_pmu_cpu_dying(int cpu)
 	fini_debug_store_on_cpu(cpu);
 }
 
+static void intel_pmu_sched_task(struct perf_event_context *ctx,
+				 bool sched_in)
+{
+	if (x86_pmu.pebs_active)
+		intel_pmu_pebs_sched_task(ctx, sched_in);
+	if (x86_pmu.lbr_nr)
+		intel_pmu_lbr_sched_task(ctx, sched_in);
+}
+
 PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
 
 PMU_FORMAT_ATTR(ldlat, "config1:0-15");
@@ -2086,7 +2095,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
 	.guest_get_msrs		= intel_guest_get_msrs,
-	.sched_task		= intel_pmu_lbr_sched_task,
+	.sched_task		= intel_pmu_sched_task,
 };
 
 static __init void intel_clovertown_quirk(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index a0284a4..ddb5683 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -705,6 +705,26 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 	return &emptyconstraint;
 }
 
+void intel_pmu_drain_pebs_buffer(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct pt_regs regs;
+
+	if (!x86_pmu.pebs_active)
+		return;
+	if (ds->pebs_index <= ds->pebs_buffer_base)
+		return;
+
+	x86_pmu.drain_pebs(&regs);
+}
+
+void intel_pmu_pebs_sched_task(struct perf_event_context *ctx, bool sched_in)
+{
+	if (!sched_in)
+		intel_pmu_drain_pebs_buffer();
+}
+
 /*
  * Flags PEBS can handle without an PMI.
  *
@@ -743,8 +763,16 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	    !(event->attr.sample_type & ~PEBS_FREERUNNING_FLAGS)) {
 		threshold = ds->pebs_absolute_maximum -
 			x86_pmu.max_pebs_events * x86_pmu.pebs_record_size;
+		if (first_pebs) {
+			perf_sched_cb_enable(event->ctx->pmu);
+			cpuc->pebs_sched_cb_enabled = true;
+		}
 	} else {
 		threshold = ds->pebs_buffer_base + x86_pmu.pebs_record_size;
+		if (cpuc->pebs_sched_cb_enabled) {
+			perf_sched_cb_disable(event->ctx->pmu);
+			cpuc->pebs_sched_cb_enabled = false;
+		}
 	}
 	if (first_pebs || ds->pebs_interrupt_threshold > threshold)
 		ds->pebs_interrupt_threshold = threshold;
@@ -759,8 +787,19 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
+	struct debug_store *ds = cpuc->ds;
+	bool multi_pebs = false;
+
+	if (ds->pebs_interrupt_threshold >
+	    ds->pebs_buffer_base + x86_pmu.pebs_record_size)
+		multi_pebs = true;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
+	if (cpuc->pebs_sched_cb_enabled &&
+	    !(cpuc->pebs_enabled & ((1ULL << MAX_PEBS_EVENTS) - 1))) {
+		perf_sched_cb_disable(event->ctx->pmu);
+		cpuc->pebs_sched_cb_enabled = false;
+	}
 
 	if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
 		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
@@ -772,6 +811,9 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 
 	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
 	hwc->autoreload = false;
+
+	if (multi_pebs)
+		intel_pmu_drain_pebs_buffer();
 }
 
 void intel_pmu_pebs_enable_all(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index c776931..e624407 100644
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
-- 
1.9.0

