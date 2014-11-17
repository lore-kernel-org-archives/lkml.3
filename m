Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaKQTIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:08:32 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60588 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaKQTIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:24 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v3 07/13] perf/x86: enforce HT bug workaround for SNB/IVB/HSW
Date: Mon, 17 Nov 2014 20:06:59 +0100
Message-Id: <1416251225-17721-8-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416251225-17721-1-git-send-email-eranian@google.com>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
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
index 92c1692..1e01584 100644
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
 
@@ -2637,6 +2646,27 @@ static __init void intel_nehalem_quirk(void)
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
 
@@ -2850,6 +2880,7 @@ __init int intel_pmu_init(void)
 	case 42: /* 32nm SandyBridge         */
 	case 45: /* 32nm SandyBridge-E/EN/EP */
 		x86_add_quirk(intel_sandybridge_quirk);
+		x86_add_quirk(intel_ht_bug);
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
@@ -2864,6 +2895,8 @@ __init int intel_pmu_init(void)
 			x86_pmu.extra_regs = intel_snbep_extra_regs;
 		else
 			x86_pmu.extra_regs = intel_snb_extra_regs;
+
+
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
@@ -2882,6 +2915,7 @@ __init int intel_pmu_init(void)
 
 	case 58: /* 22nm IvyBridge       */
 	case 62: /* 22nm IvyBridge-EP/EX */
+		x86_add_quirk(intel_ht_bug);
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		/* dTLB-load-misses on IVB is different than SNB */
@@ -2917,6 +2951,7 @@ __init int intel_pmu_init(void)
 	case 63: /* 22nm Haswell Server */
 	case 69: /* 22nm Haswell ULT */
 	case 70: /* 22nm Haswell + GT3e (Intel Iris Pro graphics) */
+		x86_add_quirk(intel_ht_bug);
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
-- 
1.9.1

