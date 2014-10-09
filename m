Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbaJIQgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:36:14 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50302 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbaJIQgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:36:04 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v2 07/12] perf/x86: enforce HT bug workaround for SNB/IVB/HSW
Date: Thu,  9 Oct 2014 18:34:41 +0200
Message-Id: <1412872486-2930-8-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412872486-2930-1-git-send-email-eranian@google.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

This patches activates the HT bug workaround for the
SNB/IVB/HSW processors. This covers non-PEBS mode.
Activation is done thru the constraint tables.

Both client and server processors needs this workaround.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 53 ++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d7df7b3..041dec7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -113,6 +113,12 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_DISPATCH */
 	INTEL_UEVENT_CONSTRAINT(0x02a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
+
+	INTEL_EXCLEVT_CONSTRAINT(0xd0, 0xf), /* MEM_UOPS_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd1, 0xf), /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd3, 0xf), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+
 	EVENT_CONSTRAINT_END
 };
 
@@ -131,15 +137,12 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
 	INTEL_UEVENT_CONSTRAINT(0x08a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x0ca3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
-	/*
-	 * Errata BV98 -- MEM_*_RETIRED events can leak between counters of SMT
-	 * siblings; disable these events because they can corrupt unrelated
-	 * counters.
-	 */
-	INTEL_EVENT_CONSTRAINT(0xd0, 0x0), /* MEM_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd1, 0x0), /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd2, 0x0), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd3, 0x0), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+
+	INTEL_EXCLEVT_CONSTRAINT(0xd0, 0xf), /* MEM_UOPS_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd1, 0xf), /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd3, 0xf), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+
 	EVENT_CONSTRAINT_END
 };
 
@@ -217,6 +220,12 @@ static struct event_constraint intel_hsw_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0x0ca3, 0x4),
 	/* CYCLE_ACTIVITY.CYCLES_NO_EXECUTE */
 	INTEL_EVENT_CONSTRAINT(0x04a3, 0xf),
+
+	INTEL_EXCLEVT_CONSTRAINT(0xd0, 0xf), /* MEM_UOPS_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd1, 0xf), /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EXCLEVT_CONSTRAINT(0xd3, 0xf), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+
 	EVENT_CONSTRAINT_END
 };
 
@@ -2784,6 +2793,27 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
+/*
+ * enable software workaround for errata:
+ * SNB: BJ122
+ * IVB: BV98
+ * HSW: HSD29
+ *
+ * Only needed when HT is enabled. However detecting
+ * this is too difficult and model specific so we enable
+ * it even with HT off for now.
+ */
+static __init void intel_ht_bug(void)
+{
+	x86_pmu.flags |= PMU_FL_EXCL_CNTRS;
+
+	x86_pmu.commit_scheduling = intel_commit_scheduling;
+	x86_pmu.start_scheduling = intel_start_scheduling;
+	x86_pmu.stop_scheduling = intel_stop_scheduling;
+
+	pr_info("CPU erratum BJ122, BV98, HSD29 worked around\n");
+}
+
 EVENT_ATTR_STR(mem-loads,	mem_ld_hsw,	"event=0xcd,umask=0x1,ldlat=3");
 EVENT_ATTR_STR(mem-stores,	mem_st_hsw,	"event=0xd0,umask=0x82")
 
@@ -2997,6 +3027,7 @@ __init int intel_pmu_init(void)
 	case 42: /* 32nm SandyBridge         */
 	case 45: /* 32nm SandyBridge-E/EN/EP */
 		x86_add_quirk(intel_sandybridge_quirk);
+		x86_add_quirk(intel_ht_bug);
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
@@ -3011,6 +3042,8 @@ __init int intel_pmu_init(void)
 			x86_pmu.extra_regs = intel_snbep_extra_regs;
 		else
 			x86_pmu.extra_regs = intel_snb_extra_regs;
+
+
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
@@ -3029,6 +3062,7 @@ __init int intel_pmu_init(void)
 
 	case 58: /* 22nm IvyBridge       */
 	case 62: /* 22nm IvyBridge-EP/EX */
+		x86_add_quirk(intel_ht_bug);
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		/* dTLB-load-misses on IVB is different than SNB */
@@ -3064,6 +3098,7 @@ __init int intel_pmu_init(void)
 	case 63: /* 22nm Haswell Server */
 	case 69: /* 22nm Haswell ULT */
 	case 70: /* 22nm Haswell + GT3e (Intel Iris Pro graphics) */
+		x86_add_quirk(intel_ht_bug);
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, hsw_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, hsw_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
-- 
1.9.1

