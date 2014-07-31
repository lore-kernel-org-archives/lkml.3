Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaGaGqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:46:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:8726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbaGaGpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:45:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="578059873"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 7/9] perf, x86: drain PEBS buffer during context switch
Date: Thu, 31 Jul 2014 14:45:02 +0800
Message-Id: <1406789104-25863-8-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flush the PEBS buffer during context switch if PEBS interrupt threshold
is larger than one. This allows perf to supply TID for sample outputs.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           |  3 +++
 arch/x86/kernel/cpu/perf_event_intel.c     | 11 +++++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c  | 32 ++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 --
 4 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3035930..c0ece8d 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -148,6 +148,7 @@ struct cpu_hw_events {
 	 */
 	struct debug_store	*ds;
 	u64			pebs_enabled;
+	bool			pebs_sched_cb_enabled;
 
 	/*
 	 * Intel LBR bits
@@ -685,6 +686,8 @@ void intel_pmu_pebs_enable_all(void);
 
 void intel_pmu_pebs_disable_all(void);
 
+void intel_pmu_pebs_sched_task(struct perf_event_context *ctx, bool sched_in);
+
 void intel_ds_init(void);
 
 void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d1f36ca..7a7013d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2044,6 +2044,15 @@ static void intel_pmu_cpu_dying(int cpu)
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
@@ -2095,7 +2104,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
 	.guest_get_msrs		= intel_guest_get_msrs,
-	.sched_task		= intel_pmu_lbr_sched_task,
+	.sched_task		= intel_pmu_sched_task,
 };
 
 static __init void intel_clovertown_quirk(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ec7b725..65457ca 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -707,6 +707,18 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 	return &emptyconstraint;
 }
 
+static inline void intel_pmu_drain_pebs_buffer(void)
+{
+	struct pt_regs regs;
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
@@ -747,13 +759,20 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	 * When the event is constrained enough we can use a larger
 	 * threshold and run the event with less frequent PMI.
 	 */
-	if (0 && /* disable this temporarily */
-	    (hwc->flags & PERF_X86_EVENT_AUTO_RELOAD) &&
+	if ((hwc->flags & PERF_X86_EVENT_AUTO_RELOAD) &&
 	    !(event->attr.sample_type & ~PEBS_FREERUNNING_FLAGS)) {
 		threshold = ds->pebs_absolute_maximum -
 			x86_pmu.max_pebs_events * x86_pmu.pebs_record_size;
+		if (first_pebs) {
+			perf_sched_cb_user_inc(event->ctx->pmu);
+			cpuc->pebs_sched_cb_enabled = true;
+		}
 	} else {
 		threshold = ds->pebs_buffer_base + x86_pmu.pebs_record_size;
+		if (cpuc->pebs_sched_cb_enabled) {
+			perf_sched_cb_user_dec(event->ctx->pmu);
+			cpuc->pebs_sched_cb_enabled = false;
+		}
 	}
 	if (first_pebs || ds->pebs_interrupt_threshold > threshold)
 		ds->pebs_interrupt_threshold = threshold;
@@ -769,8 +788,17 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
+	struct debug_store *ds = cpuc->ds;
+
+	if (ds->pebs_interrupt_threshold >
+	    ds->pebs_buffer_base + x86_pmu.pebs_record_size)
+		intel_pmu_drain_pebs_buffer();
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
+	if (cpuc->pebs_sched_cb_enabled && !pebs_is_enabled(cpuc)) {
+		perf_sched_cb_user_dec(event->ctx->pmu);
+		cpuc->pebs_sched_cb_enabled = false;
+	}
 
 	if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
 		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index a30bfab..e4f3a09 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -185,8 +185,6 @@ void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (!x86_pmu.lbr_nr)
-		return;
 	/*
 	 * When sampling the branck stack in system-wide, it may be
 	 * necessary to flush the stack on context switch. This happens
-- 
1.9.3

