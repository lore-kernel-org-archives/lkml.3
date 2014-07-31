Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaGaGpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:45:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:8726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbaGaGpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:45:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="578059825"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 3/9] perf, x86: use the PEBS auto reload mechanism when possible
Date: Thu, 31 Jul 2014 14:44:58 +0800
Message-Id: <1406789104-25863-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a fixed period is specified, this patch make perf use the PEBS
auto reload mechanism. This makes normal profiling faster, because
it avoids one costly MSR write in the PMI handler.

Signef-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c          | 15 +++++++++------
 arch/x86/kernel/cpu/perf_event.h          |  1 +
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  9 +++++++++
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 46f98f2..3311981 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -982,13 +982,16 @@ int x86_perf_event_set_period(struct perf_event *event)
 
 	per_cpu(pmc_prev_left[idx], smp_processor_id()) = left;
 
-	/*
-	 * The hw event starts counting from this event offset,
-	 * mark it to be able to extra future deltas:
-	 */
-	local64_set(&hwc->prev_count, (u64)-left);
+	if (!(hwc->flags & PERF_X86_EVENT_AUTO_RELOAD) ||
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
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d93a16b..3035930 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -69,6 +69,7 @@ struct event_constraint {
 #define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
 #define PERF_X86_EVENT_PEBS_ST_HSW	0x4 /* haswell style st data sampling */
 #define PERF_X86_EVENT_COMMITTED	0x8 /* event passed commit_txn */
+#define PERF_X86_EVENT_AUTO_RELOAD	0x10 /* use PEBS auto-reload */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 696ade3..ecf8b5d6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -716,6 +716,8 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
+	if (!event->attr.freq)
+		hwc->flags |= PERF_X86_EVENT_AUTO_RELOAD;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
 
@@ -723,6 +725,12 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
 	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
 		cpuc->pebs_enabled |= 1ULL << 63;
+
+	/* Use auto-reload if possible to save a MSR write in the PMI */
+	if (hwc->flags &PERF_X86_EVENT_AUTO_RELOAD) {
+		ds->pebs_event_reset[hwc->idx] =
+			(u64)-hwc->sample_period & x86_pmu.cntval_mask;
+	}
 }
 
 void intel_pmu_pebs_disable(struct perf_event *event)
@@ -741,6 +749,7 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
 	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
+	hwc->flags &= ~PERF_X86_EVENT_AUTO_RELOAD;
 }
 
 void intel_pmu_pebs_enable_all(void)
-- 
1.9.3

