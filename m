Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaIXOfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:35:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:62939 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaIXOfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:35:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,589,1406617200"; 
   d="scan'208";a="578247591"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] perf, x86: Disallow flags for most Core2/Atom/Nehalem/Westmere events
Date: Wed, 24 Sep 2014 07:34:48 -0700
Message-Id: <1411569288-5627-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411569288-5627-1-git-send-email-andi@firstfloor.org>
References: <1411569288-5627-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Disallow setting inv/cmask/etc. flags for all PEBS events
on these CPUs, except for the UOPS_RETIRED.* events on Nehalem/Westmere,
which are needed for cycles:p. This avoids an undefined situation
strongly discouraged by the Intle SDM. The PLD_* events were already
covered. This follows the earlier changes for Sandy Bridge and alter.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 52 +++++++++++++++----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index e578c66..8058b30 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -552,18 +552,18 @@ int intel_pmu_drain_bts_buffer(void)
  * PEBS
  */
 struct event_constraint intel_core2_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
-	INTEL_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_atom_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
@@ -577,31 +577,31 @@ struct event_constraint intel_slm_pebs_event_constraints[] = {
 
 struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INST_RETIRED.ANY */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc0, 0xf),    /* INST_RETIRED.ANY */
 	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_westmere_pebs_event_constraints[] = {
 	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INSTR_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc0, 0xf),    /* INSTR_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	EVENT_CONSTRAINT_END
 };
 
-- 
1.9.3

