Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaF0XKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:10:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:15463 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbaF0XKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:10:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,564,1400050800"; 
   d="scan'208";a="562078298"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, x86: Revamp PEBS event selection
Date: Fri, 27 Jun 2014 16:10:11 -0700
Message-Id: <1403910612-8754-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

As already discussed earlier in email.

The basic idea is that it does not make sense to list all PEBS
events individually. The list is very long, sometimes outdated
and the hardware doesn't need it. If an event does not support
PEBS it will just not count, there is no security issue.

This vastly simplifies the PEBS event selection.

Bugs fixed:
- We do not allow setting forbidden flags with PEBS anymore
(SDM 18.9.4), except for the special cycle event.
This is done using a new constraint macro that also
matches on the event flags.
- We now allow DataLA on all Haswell events, not just
a small subset. In general all PEBS events that tag memory
accesses support DataLA on Haswell. Otherwise the reported
address is just zero. This allows address profiling
on vastly more events.
- We did not allow all PEBS events on Haswell.

This includes the changes proposed by Stephane earlier and obsoletes
his patchkit.

I only did Sandy Bridge and Silvermont and later so far, mostly because these
are the parts I could directly confirm the hardware behavior with hardware
architects.

Cc: eranian@google.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/perf_event.h         |  8 +++
 arch/x86/kernel/cpu/perf_event.h          | 18 ++++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 96 +++++++------------------------
 3 files changed, 43 insertions(+), 79 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8249df4..8dfc9fd 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -51,6 +51,14 @@
 	 ARCH_PERFMON_EVENTSEL_EDGE  |	\
 	 ARCH_PERFMON_EVENTSEL_INV   |	\
 	 ARCH_PERFMON_EVENTSEL_CMASK)
+#define X86_ALL_EVENT_FLAGS  			\
+	(ARCH_PERFMON_EVENTSEL_EDGE |  		\
+	 ARCH_PERFMON_EVENTSEL_INV | 		\
+	 ARCH_PERFMON_EVENTSEL_CMASK | 		\
+	 ARCH_PERFMON_EVENTSEL_ANY | 		\
+	 ARCH_PERFMON_EVENTSEL_PIN_CONTROL | 	\
+	 HSW_IN_TX | 				\
+	 HSW_IN_TX_CHECKPOINTED)
 #define AMD64_RAW_EVENT_MASK		\
 	(X86_RAW_EVENT_MASK          |  \
 	 AMD64_EVENTSEL_EVENT)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..9907759 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -252,16 +252,24 @@ struct cpu_hw_events {
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
 
 #define INTEL_PLD_CONSTRAINT(c, n)	\
-	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
 
 #define INTEL_PST_CONSTRAINT(c, n)	\
-	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
 
-/* DataLA version of store sampling without extra enable bit. */
-#define INTEL_PST_HSW_CONSTRAINT(c, n)	\
-	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+/* Event constraint, but match on all event flags too. */
+#define INTEL_FLAGS_EVENT_CONSTRAINT(c, n) \
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS)
+
+/* Check only flags, but allow all event/umask */
+#define INTEL_ALL_EVENT_CONSTRAINT(flags, n)	\
+	EVENT_CONSTRAINT(flags, n, X86_ALL_EVENT_FLAGS)
+
+/* Same as above, but enable DataLA */
+#define INTEL_ALL_EVENT_CONSTRAINT_DATALA(flags, n) \
+	__EVENT_CONSTRAINT(flags, n, X86_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 980970c..d50142e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -567,28 +567,10 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
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
+	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* Allow all events as PEBS with no flags */
+	INTEL_ALL_EVENT_CONSTRAINT(0xffff, 0x1),
 	EVENT_CONSTRAINT_END
 };
 
@@ -624,68 +606,34 @@ struct event_constraint intel_westmere_pebs_event_constraints[] = {
 
 struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-	INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
-	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
-	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
+	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PST_CONSTRAINT(0x02cd, 0xf),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
+	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* Allow all events as PEBS with no flags */
+	INTEL_ALL_EVENT_CONSTRAINT(0xffff, 0xf),
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-        INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-        INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-        INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-        INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
-	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
-        INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+        INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PST_CONSTRAINT(0x02cd, 0xf),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
+	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* Allow all events as PEBS with no flags */
+	INTEL_ALL_EVENT_CONSTRAINT(0xffff, 0xf),
         EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-	INTEL_PST_HSW_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
-	INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
-	INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
-	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.* */
-	/* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf),
-	/* MEM_UOPS_RETIRED.STLB_MISS_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf),
-	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
-	/* MEM_UOPS_RETIRED.SPLIT_STORES */
-	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf),
-	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
-	INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
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
+	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.* */
+	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* Allow all events as PEBS with no flags */
+	/* We allow DATALA for all PEBS events, will be 0 if not supported */
+	INTEL_ALL_EVENT_CONSTRAINT_DATALA(0, 0xf),
 	EVENT_CONSTRAINT_END
 };
 
-- 
1.9.3

