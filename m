Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaIBSo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:44:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:52192 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaIBSo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,450,1406617200"; 
   d="scan'208";a="567311056"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/5] perf, x86: Add Broadwell core support
Date: Tue,  2 Sep 2014 11:44:13 -0700
Message-Id: <1409683455-29168-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
References: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add Broadwell support for Broadwell Client to perf.
This is very similar to Haswell.  It uses a new cache event table,
because there were various changes there.

The constraint list has one new event that needs to be handled over Haswell.

The PEBS event list is the same, so we reuse Haswell's.

v2: Remove unnamed model numbers.
v3: Rename cache event list to hsw_*. Change names.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 150 +++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 7c9f78e..61b5404 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -220,6 +220,15 @@ static struct event_constraint intel_hsw_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
+struct event_constraint intel_bdw_event_constraints[] = {
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0),	/* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1),	/* CPU_CLK_UNHALTED.CORE */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2),	/* CPU_CLK_UNHALTED.REF */
+	INTEL_UEVENT_CONSTRAINT(0x148, 0x4),	/* L1D_PEND_MISS.PENDING */
+	INTEL_EVENT_CONSTRAINT(0xa3, 0x4),	/* CYCLE_ACTIVITY.* */
+	EVENT_CONSTRAINT_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -415,6 +424,126 @@ static __initconst const u64 snb_hw_cache_event_ids
 
 };
 
+static __initconst const u64 hsw_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x81d0, 	/* MEM_UOPS_RETIRED.ALL_LOADS */
+		[ C(RESULT_MISS)   ] = 0x151, 	/* L1D.REPLACEMENT */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x82d0, 	/* MEM_UOPS_RETIRED.ALL_STORES */
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x280, 	/* ICACHE.MISSES */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD */
+		[ C(RESULT_ACCESS) ] = 0x1b7,
+		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD|SUPPLIER_NONE|
+                   L3_MISS|ANY_SNOOP */
+		[ C(RESULT_MISS)   ] = 0x1b7,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x1b7, 	/* OFFCORE_RESPONSE:ALL_RFO */
+		/* OFFCORE_RESPONSE:ALL_RFO|SUPPLIER_NONE|L3_MISS|ANY_SNOOP */
+		[ C(RESULT_MISS)   ] = 0x1b7,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x81d0, 	/* MEM_UOPS_RETIRED.ALL_LOADS */
+		[ C(RESULT_MISS)   ] = 0x108, 	/* DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x82d0, 	/* MEM_UOPS_RETIRED.ALL_STORES */
+		[ C(RESULT_MISS)   ] = 0x149, 	/* DTLB_STORE_MISSES.MISS_CAUSES_A_WALK */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x6085, 	/* ITLB_MISSES.STLB_HIT */
+		[ C(RESULT_MISS)   ] = 0x185, 	/* ITLB_MISSES.MISS_CAUSES_A_WALK */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+ [ C(BPU ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0xc4, 	/* BR_INST_RETIRED.ALL_BRANCHES */
+		[ C(RESULT_MISS)   ] = 0xc5, 	/* BR_MISP_RETIRED.ALL_BRANCHES */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+};
+
+static __initconst const u64 hsw_hw_cache_extra_regs
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD */
+		[ C(RESULT_ACCESS) ] = 0x2d5,
+		/* OFFCORE_RESPONSE:ALL_DATA_RD|ALL_CODE_RD|SUPPLIER_NONE|
+                   L3_MISS|ANY_SNOOP */
+		[ C(RESULT_MISS)   ] = 0x3fbc0202d5,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x122, 	/* OFFCORE_RESPONSE:ALL_RFO */
+		/* OFFCORE_RESPONSE:ALL_RFO|SUPPLIER_NONE|L3_MISS|ANY_SNOOP */
+		[ C(RESULT_MISS)   ] = 0x3fbc020122,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+};
+
 static __initconst const u64 westmere_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -2565,6 +2694,27 @@ __init int intel_pmu_init(void)
 		pr_cont("Haswell events, ");
 		break;
 
+	case 61: /* 14nm Broadwell Core-M */
+		x86_pmu.late_ack = true;
+		memcpy(hw_cache_event_ids, hsw_hw_cache_event_ids, sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, hsw_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
+
+		intel_pmu_lbr_init_snb();
+
+		x86_pmu.event_constraints = intel_bdw_event_constraints;
+		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
+		x86_pmu.extra_regs = intel_snbep_extra_regs;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+
+		x86_pmu.hw_config = hsw_hw_config;
+		x86_pmu.get_event_constraints = hsw_get_event_constraints;
+		x86_pmu.cpu_events = hsw_events_attrs;
+		pr_cont("Broadwell events, ");
+		break;
+
 	default:
 		switch (x86_pmu.version) {
 		case 1:
-- 
1.9.3

