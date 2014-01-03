Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaACFtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:49:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:23246 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaACFse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:48:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,595,1384329600"; 
   d="scan'208";a="459449385"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 10/14] perf, core: simplify need branch stack check
Date: Fri,  3 Jan 2014 13:48:07 +0800
Message-Id: <1388728091-18564-11-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

event->attr.branch_sample_type is non-zero no matter branch stack
is enabled explicitly or is enabled implicitly. So we can use it
toreplace intel_pmu_needs_lbr_smpl(). This avoids duplicating code
that implicitly enables the LBR.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 20 +++-----------------
 include/linux/perf_event.h             |  5 +++++
 kernel/events/core.c                   | 11 +++++++----
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 84a1c09..722171c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1030,20 +1030,6 @@ static __initconst const u64 slm_hw_cache_event_ids
  },
 };
 
-static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
-{
-	/* user explicitly requested branch sampling */
-	if (has_branch_stack(event))
-		return true;
-
-	/* implicit branch sampling to correct PEBS skid */
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
-	    x86_pmu.intel_cap.pebs_format < 2)
-		return true;
-
-	return false;
-}
-
 static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1208,7 +1194,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 	 * must disable before any actual event
 	 * because any event may be combined with LBR
 	 */
-	if (intel_pmu_needs_lbr_smpl(event))
+	if (needs_branch_stack(event))
 		intel_pmu_lbr_disable(event);
 
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
@@ -1269,7 +1255,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	 * must enabled before any actual event
 	 * because any event may be combined with LBR
 	 */
-	if (intel_pmu_needs_lbr_smpl(event))
+	if (needs_branch_stack(event))
 		intel_pmu_lbr_enable(event);
 
 	if (event->attr.exclude_host)
@@ -1741,7 +1727,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
 		x86_pmu.pebs_aliases(event);
 
-	if (intel_pmu_needs_lbr_smpl(event)) {
+	if (needs_branch_stack(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
 		if (ret)
 			return ret;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 147f9d3..0d88eb8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -766,6 +766,11 @@ static inline bool has_branch_stack(struct perf_event *event)
 	return event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK;
 }
 
+static inline bool needs_branch_stack(struct perf_event *event)
+{
+	return event->attr.branch_sample_type != 0;
+}
+
 extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size);
 extern void perf_output_end(struct perf_output_handle *handle);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d6d8dea..7dd4d58 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1138,7 +1138,7 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (is_cgroup_event(event))
 		ctx->nr_cgroups++;
 
-	if (has_branch_stack(event))
+	if (needs_branch_stack(event))
 		ctx->nr_branch_stack++;
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
@@ -1303,7 +1303,7 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 			cpuctx->cgrp = NULL;
 	}
 
-	if (has_branch_stack(event))
+	if (needs_branch_stack(event))
 		ctx->nr_branch_stack--;
 
 	ctx->nr_events--;
@@ -3202,7 +3202,7 @@ static void unaccount_event(struct perf_event *event)
 		atomic_dec(&nr_freq_events);
 	if (is_cgroup_event(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
-	if (has_branch_stack(event))
+	if (needs_branch_stack(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
 
 	unaccount_event_cpu(event, event->cpu);
@@ -6627,7 +6627,7 @@ static void account_event(struct perf_event *event)
 		if (atomic_inc_return(&nr_freq_events) == 1)
 			tick_nohz_full_kick_all();
 	}
-	if (has_branch_stack(event))
+	if (needs_branch_stack(event))
 		static_key_slow_inc(&perf_sched_events.key);
 	if (is_cgroup_event(event))
 		static_key_slow_inc(&perf_sched_events.key);
@@ -6735,6 +6735,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto err_ns;
 
+	if (!has_branch_stack(event))
+		event->attr.branch_sample_type = 0;
+
 	pmu = perf_init_event(event);
 	if (!pmu)
 		goto err_ns;
-- 
1.8.4.2

