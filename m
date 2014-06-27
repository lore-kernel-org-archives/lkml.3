Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaF0Nsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:48:37 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:55803 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaF0Nsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:48:33 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jmario@redhat.com,
        dzickus@redhat.com, jolsa@redhat.com, acme@redhat.com
Subject: [PATCH v2 1/2] perf/x86: simplify PEBS constraints
Date: Fri, 27 Jun 2014 15:48:02 +0200
Message-Id: <1403876883-3059-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403876883-3059-1-git-send-email-eranian@google.com>
References: <1403876883-3059-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches simplifies the management of PEBS constraints
for Intel processors.

It assumes using a event in PEBS (precise sampling) mode when
the event does not actually support it, is harmless and no
sample is captured. Based on that assumption, it is possible
to simplify all the PEBS constraint tables, by only listing
the events which have specific PEBS counter constraints, e.g.,
run only on one of the 4 PEBS counters. Events which have
extra registers requirements such as load latency events must
stay in the constraint tables. But every other event can be
eliminated.

The patch adds INTEL_PEBS_CONSTRAINT() to each table as a
'catch all' constraint which matches any event code.

Based on patch proposal by PeterZ on LKML.
See https://lkml.org/lkml/2014/6/19/343.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h          |    4 ++
 arch/x86/kernel/cpu/perf_event_intel.c    |   12 +++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  103 +++--------------------------
 3 files changed, 22 insertions(+), 97 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..cf48a02 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -264,6 +264,10 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
+/* catch all event code+umask */
+#define INTEL_PEBS_CONSTRAINT(n)	\
+	EVENT_CONSTRAINT(0x0000, n, 0x0000)
+
 /*
  * We define the end marker as having a weight of -1
  * to enable blacklisting of events using a counter bitmask
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..53b96c1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1735,8 +1735,16 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
-		x86_pmu.pebs_aliases(event);
+	if (event->attr.precise_ip) {
+		/*
+		 * not a valid event code and used as a PEBS code catch all
+		 */
+		if ((event->hw.config & INTEL_ARCH_EVENT_MASK) == 0x0000)
+			return -EINVAL;
+
+		if (x86_pmu.pebs_aliases)
+			x86_pmu.pebs_aliases(event);
+	}
 
 	if (intel_pmu_needs_lbr_smpl(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 980970c..fdadec0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -551,141 +551,54 @@ int intel_pmu_drain_bts_buffer(void)
  * PEBS
  */
 struct event_constraint intel_core2_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
-	INTEL_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
+	INTEL_PEBS_CONSTRAINT(0x1),	/* catch all PEBS */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_atom_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
+	INTEL_PEBS_CONSTRAINT(0x1),	/* catch all PEBS */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_slm_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x0103, 0x1), /* REHABQ.LD_BLOCK_ST_FORWARD_PS */
-	INTEL_UEVENT_CONSTRAINT(0x0803, 0x1), /* REHABQ.LD_SPLITS_PS */
-	INTEL_UEVENT_CONSTRAINT(0x0204, 0x1), /* MEM_UOPS_RETIRED.L2_HIT_LOADS_PS */
-	INTEL_UEVENT_CONSTRAINT(0x0404, 0x1), /* MEM_UOPS_RETIRED.L2_MISS_LOADS_PS */
-	INTEL_UEVENT_CONSTRAINT(0x0804, 0x1), /* MEM_UOPS_RETIRED.DTLB_MISS_LOADS_PS */
-	INTEL_UEVENT_CONSTRAINT(0x2004, 0x1), /* MEM_UOPS_RETIRED.HITM_PS */
-	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY_PS */
-	INTEL_UEVENT_CONSTRAINT(0x00c4, 0x1), /* BR_INST_RETIRED.ALL_BRANCHES_PS */
-	INTEL_UEVENT_CONSTRAINT(0x7ec4, 0x1), /* BR_INST_RETIRED.JCC_PS */
-	INTEL_UEVENT_CONSTRAINT(0xbfc4, 0x1), /* BR_INST_RETIRED.FAR_BRANCH_PS */
-	INTEL_UEVENT_CONSTRAINT(0xebc4, 0x1), /* BR_INST_RETIRED.NON_RETURN_IND_PS */
-	INTEL_UEVENT_CONSTRAINT(0xf7c4, 0x1), /* BR_INST_RETIRED.RETURN_PS */
-	INTEL_UEVENT_CONSTRAINT(0xf9c4, 0x1), /* BR_INST_RETIRED.CALL_PS */
-	INTEL_UEVENT_CONSTRAINT(0xfbc4, 0x1), /* BR_INST_RETIRED.IND_CALL_PS */
-	INTEL_UEVENT_CONSTRAINT(0xfdc4, 0x1), /* BR_INST_RETIRED.REL_CALL_PS */
-	INTEL_UEVENT_CONSTRAINT(0xfec4, 0x1), /* BR_INST_RETIRED.TAKEN_JCC_PS */
-	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_MISP_RETIRED.ALL_BRANCHES_PS */
-	INTEL_UEVENT_CONSTRAINT(0x7ec5, 0x1), /* BR_INST_MISP_RETIRED.JCC_PS */
-	INTEL_UEVENT_CONSTRAINT(0xebc5, 0x1), /* BR_INST_MISP_RETIRED.NON_RETURN_IND_PS */
-	INTEL_UEVENT_CONSTRAINT(0xf7c5, 0x1), /* BR_INST_MISP_RETIRED.RETURN_PS */
-	INTEL_UEVENT_CONSTRAINT(0xfbc5, 0x1), /* BR_INST_MISP_RETIRED.IND_CALL_PS */
-	INTEL_UEVENT_CONSTRAINT(0xfec5, 0x1), /* BR_INST_MISP_RETIRED.TAKEN_JCC_PS */
+	INTEL_PEBS_CONSTRAINT(0x1),	/* catch all PEBS */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INST_RETIRED.ANY */
-	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
+	INTEL_PEBS_CONSTRAINT(0xf),		/* catch all PEBS */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_westmere_pebs_event_constraints[] = {
 	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INSTR_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
+	INTEL_PEBS_CONSTRAINT(0xf),		/* catch all PEBS */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-	INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
-	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
+	INTEL_PEBS_CONSTRAINT(0xf),	      /* catch all PEBS */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-        INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-        INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-        INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
-        INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+	INTEL_PEBS_CONSTRAINT(0xf),	      /* catch all PEBS */
         EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PST_HSW_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
-	INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
-	INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.* */
-	/* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf),
-	/* MEM_UOPS_RETIRED.STLB_MISS_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf),
-	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
-	/* MEM_UOPS_RETIRED.SPLIT_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf),
-	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
 	INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
-	INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
-	INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
-	/* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
-	INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf),
-	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
-	INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf),
-	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
-	INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf),
-	/* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
-	INTEL_UEVENT_CONSTRAINT(0x01d3, 0xf),
-	INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
-	INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */
-
+	INTEL_PEBS_CONSTRAINT(0xf),	      /* catch all PEBS */
 	EVENT_CONSTRAINT_END
 };
 
-- 
1.7.9.5

