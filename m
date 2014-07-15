Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbaGOI7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:59:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:44594 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758297AbaGOI7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:59:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,664,1400050800"; 
   d="scan'208";a="457092189"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v2 3/7] perf, x86: use the PEBS auto reload mechanism when possible
Date: Tue, 15 Jul 2014 16:58:55 +0800
Message-Id: <1405414739-31455-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a fixed period is specified, this patch make perf use the PEBS
auto reload mechanism. This makes normal profiling faster, because
it avoids one costly MSR write in the PMI handler.

Signef-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c          | 15 +++++++++------
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  7 +++++++
 include/linux/perf_event.h                |  1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8868e9b..ae723c8 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -979,13 +979,16 @@ int x86_perf_event_set_period(struct perf_event *event)
 
 	per_cpu(pmc_prev_left[idx], smp_processor_id()) = left;
 
-	/*
-	 * The hw event starts counting from this event offset,
-	 * mark it to be able to extra future deltas:
-	 */
-	local64_set(&hwc->prev_count, (u64)-left);
+	if (!hwc->autoreload ||
+	    local64_read(&hwc->prev_count) != (u64)-left) {
+		/*
+		 * The hw event starts counting from this event offset,
+		 * mark it to be able to extra future deltas:
+		 */
+		local64_set(&hwc->prev_count, (u64)-left);
 
-	wrmsrl(hwc->event_base, (u64)(-left) & x86_pmu.cntval_mask);
+		wrmsrl(hwc->event_base, (u64)(-left) & x86_pmu.cntval_mask);
+	}
 
 	/*
 	 * Due to erratum on certan cpu we need
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 980970c..1db4ce5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -714,6 +714,7 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
+	hwc->autoreload = !event->attr.freq;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
 
@@ -721,6 +722,11 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
 	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
 		cpuc->pebs_enabled |= 1ULL << 63;
+
+	/* Use auto-reload if possible to save a MSR write in the PMI */
+	if (hwc->autoreload)
+		ds->pebs_event_reset[hwc->idx] =
+			(u64)-hwc->sample_period & x86_pmu.cntval_mask;
 }
 
 void intel_pmu_pebs_disable(struct perf_event *event)
@@ -739,6 +745,7 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
 	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
+	hwc->autoreload = false;
 }
 
 void intel_pmu_pebs_enable_all(void)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5d665e8..37a2b70 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -149,6 +149,7 @@ struct hw_perf_event {
 
 	u64				freq_time_stamp;
 	u64				freq_count_stamp;
+	bool				autoreload;
 #endif
 };
 
-- 
1.9.3

