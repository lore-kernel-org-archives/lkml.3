Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaIJC6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:58:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:29986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbaIJC6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:58:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,495,1406617200"; 
   d="scan'208";a="597207897"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, ak@linux.intel.com, kan.liang@intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V5 10/16] perf, core: simplify need branch stack check
Date: Sun,  7 Jan 2001 21:31:57 -0500
Message-Id: <978921123-30240-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

event->attr.branch_sample_type is non-zero no matter branch stack
is enabled explicitly or is enabled implicitly. we can use it to
replace intel_pmu_needs_lbr_smpl(). This avoids duplicating code
that implicitly enables the LBR.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 20 +++-----------------
 include/linux/perf_event.h             |  5 +++++
 kernel/events/core.c                   |  3 +++
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1242314..49e7d14 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1029,20 +1029,6 @@ static __initconst const u64 slm_hw_cache_event_ids
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
@@ -1207,7 +1193,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 	 * must disable before any actual event
 	 * because any event may be combined with LBR
 	 */
-	if (intel_pmu_needs_lbr_smpl(event))
+	if (needs_branch_stack(event))
 		intel_pmu_lbr_disable(event);
 
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
@@ -1268,7 +1254,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	 * must enabled before any actual event
 	 * because any event may be combined with LBR
 	 */
-	if (intel_pmu_needs_lbr_smpl(event))
+	if (needs_branch_stack(event))
 		intel_pmu_lbr_enable(event);
 
 	if (event->attr.exclude_host)
@@ -1747,7 +1733,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
 		x86_pmu.pebs_aliases(event);
 
-	if (intel_pmu_needs_lbr_smpl(event)) {
+	if (needs_branch_stack(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
 		if (ret)
 			return ret;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5f857da..a190e91 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -792,6 +792,11 @@ static inline bool has_branch_stack(struct perf_event *event)
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
index 5f49df2..b37f2f3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7003,6 +7003,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto err_ns;
 
+	if (!has_branch_stack(event))
+		event->attr.branch_sample_type = 0;
+
 	pmu = perf_init_event(event);
 	if (!pmu)
 		goto err_ns;
-- 
1.8.3.2

