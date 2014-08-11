Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaHKT0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:26:39 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38720 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaHKT0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:26:36 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com
Subject: [PATCH v2 1/4] perf/x86: Revamp PEBS event selection
Date: Mon, 11 Aug 2014 21:27:10 +0200
Message-Id: <1407785233-32193-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407785233-32193-1-git-send-email-eranian@google.com>
References: <1407785233-32193-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The basic idea is that it does not make sense to list all PEBS
events individually. The list is very long, sometimes outdated
and the hardware doesn't need it. If an event does not support
PEBS it will just not count, there is no security issue.

We need to only list events that something special, like
supporting load or store addresses.

This vastly simplifies the PEBS event selection. It also
speeds up the scheduling because the scheduler doesn't
have to walk as many constraints.

Bugs fixed:
- We do not allow setting forbidden flags with PEBS anymore
(SDM 18.9.4), except for the special cycle event.
This is done using a new constraint macro that also
matches on the event flags.
- Correct DataLA and load/store/na flags reporting on Haswell
[Requires a followon patch]
- We did not allow all PEBS events on Haswell:
We were missing some valid subevents in d1-d2 (MEM_LOAD_UOPS_RETIRED.*,
MEM_LOAD_UOPS_RETIRED_L3_HIT_RETIRED.*)

This includes the changes proposed by Stephane earlier and obsoletes
his patchkit (except for some changes on pre Sandy Bridge/Silvermont
CPUs)

I only did Sandy Bridge and Silvermont and later so far, mostly because these
are the parts I could directly confirm the hardware behavior with hardware
architects. Also I do not believe the older CPUs have any
missing events in their PEBS list, so there's no pressing
need to change them.

I did not implement the flag proposed by Peter to allow
setting forbidden flags. If really needed this could
be implemented on to of this patch.

v2: Fix broken store events on SNB/IVB (Stephane Eranian)
v3: More fixes. Rename some arguments (Stephane Eranian)
v4: List most Haswell events individually again to report
memory operation type correctly.
Add new flags to describe load/store/na for datala.
Update description.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/perf_event.h         |    8 +++
 arch/x86/kernel/cpu/perf_event.h          |   48 +++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  107 ++++++++++-------------------
 3 files changed, 85 insertions(+), 78 deletions(-)

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
index 8ade931..fc5eb39 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -67,8 +67,10 @@ struct event_constraint {
  */
 #define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
 #define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
-#define PERF_X86_EVENT_PEBS_ST_HSW	0x4 /* haswell style st data sampling */
+#define PERF_X86_EVENT_PEBS_ST_HSW	0x4 /* haswell style datala, store */
 #define PERF_X86_EVENT_COMMITTED	0x8 /* event passed commit_txn */
+#define PERF_X86_EVENT_PEBS_LD_HSW	0x10 /* haswell style datala, load */
+#define PERF_X86_EVENT_PEBS_NA_HSW	0x20 /* haswell style datala, unknown */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -252,18 +254,52 @@ struct cpu_hw_events {
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
+#define INTEL_ALL_EVENT_CONSTRAINT(code, n)	\
+	EVENT_CONSTRAINT(code, n, X86_ALL_EVENT_FLAGS)
+
+/* Check flags and event code, and set the HSW store flag */
+#define INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_ST(code, n) \
+	__EVENT_CONSTRAINT(code, n, 			\
+			  ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
+
+/* Check flags and event code, and set the HSW load flag */
+#define INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD(code, n) \
+	__EVENT_CONSTRAINT(code, n, 			\
+			  ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LD_HSW)
+
+/* Check flags and event code/umask, and set the HSW store flag */
+#define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(code, n) \
+	__EVENT_CONSTRAINT(code, n, 			\
+			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
+/* Check flags and event code/umask, and set the HSW load flag */
+#define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(code, n) \
+	__EVENT_CONSTRAINT(code, n, 			\
+			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LD_HSW)
+
+/* Check flags and event code/umask, and set the HSW N/A flag */
+#define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_NA(code, n) \
+	__EVENT_CONSTRAINT(code, n, 			\
+			  INTEL_ARCH_EVENT_MASK|INTEL_ARCH_EVENT_MASK, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_NA_HSW)
+
+
 /*
  * We define the end marker as having a weight of -1
  * to enable blacklisting of events using a counter bitmask
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 696ade3..aca77e9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -569,28 +569,10 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
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
+	INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
 	EVENT_CONSTRAINT_END
 };
 
@@ -626,68 +608,44 @@ struct event_constraint intel_westmere_pebs_event_constraints[] = {
 
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
+	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* Allow all events as PEBS with no flags */
+	INTEL_ALL_EVENT_CONSTRAINT(0, 0xf),
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
+	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* Allow all events as PEBS with no flags */
+	INTEL_ALL_EVENT_CONSTRAINT(0, 0xf),
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
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_NA(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x42d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_STORES */
+	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
+	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD(0xd2, 0xf),    /* MEM_LOAD_UOPS_L3_HIT_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD(0xd3, 0xf),    /* MEM_LOAD_UOPS_L3_MISS_RETIRED.* */
+	/* Allow all events as PEBS with no flags */
+	INTEL_ALL_EVENT_CONSTRAINT(0, 0xf),
 	EVENT_CONSTRAINT_END
 };
 
@@ -880,7 +838,9 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 
 	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
 	fst = event->hw.flags & (PERF_X86_EVENT_PEBS_ST |
-				 PERF_X86_EVENT_PEBS_ST_HSW);
+				 PERF_X86_EVENT_PEBS_ST_HSW |
+				 PERF_X86_EVENT_PEBS_LD_HSW |
+				 PERF_X86_EVENT_PEBS_NA_HSW);
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
@@ -903,7 +863,10 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		if (sample_type & PERF_SAMPLE_DATA_SRC) {
 			if (fll)
 				data.data_src.val = load_latency_data(pebs->dse);
-			else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
+			else if (event->hw.flags &
+					(PERF_X86_EVENT_PEBS_ST_HSW|
+					 PERF_X86_EVENT_PEBS_LD_HSW|
+					 PERF_X86_EVENT_PEBS_NA_HSW))
 				data.data_src.val =
 					precise_store_data_hsw(event, pebs->dse);
 			else
-- 
1.7.9.5

