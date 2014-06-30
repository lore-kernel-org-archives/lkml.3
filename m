Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaF3IvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:51:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:53396 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbaF3IvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:51:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="536450984"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V4 04/16] perf, x86: Basic Haswell LBR call stack support
Date: Mon, 30 Jun 2014 16:50:41 +0800
Message-Id: <1404118253-19532-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haswell has a new feature that utilizes the existing LBR facility to
record call chains. To enable this feature, bits (JCC, NEAR_IND_JMP,
NEAR_REL_JMP, FAR_BRANCH, EN_CALLSTACK) in LBR_SELECT must be set to 1,
bits (NEAR_REL_CALL, NEAR-IND_CALL, NEAR_RET) must be cleared. Due to
a hardware bug of Haswell, this feature doesn't work well with
FREEZE_LBRS_ON_PMI.

When the call stack feature is enabled, the LBR stack will capture
unfiltered call data normally, but as return instructions are executed,
the last captured branch record is flushed from the on-chip registers
in a last-in first-out (LIFO) manner. Thus, branch information relative
to leaf functions will not be captured, while preserving the call stack
information of the main line execution path.

This patch defines a separate lbr_sel map for Haswell. The map contains
a new entry for the call stack feature.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           | 13 ++++-
 arch/x86/kernel/cpu/perf_event_intel.c     |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 90 ++++++++++++++++++++++--------
 3 files changed, 81 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8821f9e..cc25819 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -473,7 +473,10 @@ struct x86_pmu {
 };
 
 enum {
-	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE = PERF_SAMPLE_BRANCH_MAX_SHIFT,
+	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = PERF_SAMPLE_BRANCH_MAX_SHIFT,
+	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
+
+	PERF_SAMPLE_BRANCH_CALL_STACK = 1U << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
 };
 
 #define x86_add_quirk(func_)						\
@@ -507,6 +510,12 @@ static struct perf_pmu_events_attr event_attr_##v = {			\
 
 extern struct x86_pmu x86_pmu __read_mostly;
 
+static inline bool x86_pmu_has_lbr_callstack(void)
+{
+	return  x86_pmu.lbr_sel_map &&
+		x86_pmu.lbr_sel_map[PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT] > 0;
+}
+
 DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 
 int x86_perf_event_set_period(struct perf_event *event);
@@ -710,6 +719,8 @@ void intel_pmu_lbr_init_atom(void);
 
 void intel_pmu_lbr_init_snb(void);
 
+void intel_pmu_lbr_init_hsw(void);
+
 int intel_pmu_setup_lbr_filter(struct perf_event *event);
 
 int p4_pmu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ef926ee..af91bfd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2488,7 +2488,7 @@ __init int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
 
-		intel_pmu_lbr_init_snb();
+		intel_pmu_lbr_init_hsw();
 
 		x86_pmu.event_constraints = intel_hsw_event_constraints;
 		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index f1acc10..9a94fff 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -39,6 +39,7 @@ static enum {
 #define LBR_IND_JMP_BIT		6 /* do not capture indirect jumps */
 #define LBR_REL_JMP_BIT		7 /* do not capture relative jumps */
 #define LBR_FAR_BIT		8 /* do not capture far branches */
+#define LBR_CALL_STACK_BIT	9 /* enable call stack */
 
 #define LBR_KERNEL	(1 << LBR_KERNEL_BIT)
 #define LBR_USER	(1 << LBR_USER_BIT)
@@ -49,6 +50,7 @@ static enum {
 #define LBR_REL_JMP	(1 << LBR_REL_JMP_BIT)
 #define LBR_IND_JMP	(1 << LBR_IND_JMP_BIT)
 #define LBR_FAR		(1 << LBR_FAR_BIT)
+#define LBR_CALL_STACK	(1 << LBR_CALL_STACK_BIT)
 
 #define LBR_PLM (LBR_KERNEL | LBR_USER)
 
@@ -74,24 +76,25 @@ static enum {
  * x86control flow changes include branches, interrupts, traps, faults
  */
 enum {
-	X86_BR_NONE     = 0,      /* unknown */
-
-	X86_BR_USER     = 1 << 0, /* branch target is user */
-	X86_BR_KERNEL   = 1 << 1, /* branch target is kernel */
-
-	X86_BR_CALL     = 1 << 2, /* call */
-	X86_BR_RET      = 1 << 3, /* return */
-	X86_BR_SYSCALL  = 1 << 4, /* syscall */
-	X86_BR_SYSRET   = 1 << 5, /* syscall return */
-	X86_BR_INT      = 1 << 6, /* sw interrupt */
-	X86_BR_IRET     = 1 << 7, /* return from interrupt */
-	X86_BR_JCC      = 1 << 8, /* conditional */
-	X86_BR_JMP      = 1 << 9, /* jump */
-	X86_BR_IRQ      = 1 << 10,/* hw interrupt or trap or fault */
-	X86_BR_IND_CALL = 1 << 11,/* indirect calls */
-	X86_BR_ABORT    = 1 << 12,/* transaction abort */
-	X86_BR_IN_TX    = 1 << 13,/* in transaction */
-	X86_BR_NO_TX    = 1 << 14,/* not in transaction */
+	X86_BR_NONE		= 0,      /* unknown */
+
+	X86_BR_USER		= 1 << 0, /* branch target is user */
+	X86_BR_KERNEL		= 1 << 1, /* branch target is kernel */
+
+	X86_BR_CALL		= 1 << 2, /* call */
+	X86_BR_RET		= 1 << 3, /* return */
+	X86_BR_SYSCALL		= 1 << 4, /* syscall */
+	X86_BR_SYSRET		= 1 << 5, /* syscall return */
+	X86_BR_INT		= 1 << 6, /* sw interrupt */
+	X86_BR_IRET		= 1 << 7, /* return from interrupt */
+	X86_BR_JCC		= 1 << 8, /* conditional */
+	X86_BR_JMP		= 1 << 9, /* jump */
+	X86_BR_IRQ		= 1 << 10,/* hw interrupt or trap or fault */
+	X86_BR_IND_CALL		= 1 << 11,/* indirect calls */
+	X86_BR_ABORT		= 1 << 12,/* transaction abort */
+	X86_BR_IN_TX		= 1 << 13,/* in transaction */
+	X86_BR_NO_TX		= 1 << 14,/* not in transaction */
+	X86_BR_CALL_STACK	= 1 << 15,/* call stack */
 };
 
 #define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
@@ -368,7 +371,7 @@ void intel_pmu_lbr_read(void)
  * - in case there is no HW filter
  * - in case the HW filter has errata or limitations
  */
-static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
+static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 {
 	u64 br_type = event->attr.branch_sample_type;
 	int mask = 0;
@@ -405,11 +408,21 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_COND)
 		mask |= X86_BR_JCC;
 
+	if (br_type & PERF_SAMPLE_BRANCH_CALL_STACK) {
+		if (!x86_pmu_has_lbr_callstack())
+			return -EOPNOTSUPP;
+		if (mask & ~(X86_BR_USER | X86_BR_KERNEL))
+			return -EINVAL;
+		mask |= X86_BR_CALL | X86_BR_IND_CALL | X86_BR_RET |
+			X86_BR_CALL_STACK;
+	}
+
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
 	 */
 	event->hw.branch_reg.reg = mask;
+	return 0;
 }
 
 /*
@@ -438,8 +451,11 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
 	reg = &event->hw.branch_reg;
 	reg->idx = EXTRA_REG_LBR;
 
-	/* LBR_SELECT operates in suppress mode so invert mask */
-	reg->config = ~mask & x86_pmu.lbr_sel_mask;
+	/*
+	 * the first 8 bits (LBR_SEL_MASK) in LBR_SELECT operates
+	 * in suppress mode so invert mask
+	 */
+	reg->config = mask ^ x86_pmu.lbr_sel_mask;
 
 	return 0;
 }
@@ -457,7 +473,9 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * setup SW LBR filter
 	 */
-	intel_pmu_setup_sw_lbr_filter(event);
+	ret = intel_pmu_setup_sw_lbr_filter(event);
+	if (ret)
+		return ret;
 
 	/*
 	 * setup HW LBR filter, if any
@@ -714,6 +732,20 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
 	[PERF_SAMPLE_BRANCH_COND_SHIFT]		= LBR_JCC,
 };
 
+static const int hsw_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
+	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
+	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
+	[PERF_SAMPLE_BRANCH_HV_SHIFT]		= LBR_IGN,
+	[PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT]	= LBR_RETURN | LBR_FAR,
+	[PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT]	= LBR_REL_CALL | LBR_IND_CALL
+						| LBR_FAR,
+	[PERF_SAMPLE_BRANCH_IND_CALL_SHIFT]	= LBR_IND_CALL,
+	[PERF_SAMPLE_BRANCH_COND_SHIFT]		= LBR_JCC,
+	[PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT]	= LBR_REL_CALL | LBR_IND_CALL
+						| LBR_RETURN | LBR_CALL_STACK,
+};
+
 /* core */
 void intel_pmu_lbr_init_core(void)
 {
@@ -770,6 +802,20 @@ void intel_pmu_lbr_init_snb(void)
 	pr_cont("16-deep LBR, ");
 }
 
+/* haswell */
+void intel_pmu_lbr_init_hsw(void)
+{
+	x86_pmu.lbr_nr	 = 16;
+	x86_pmu.lbr_tos	 = MSR_LBR_TOS;
+	x86_pmu.lbr_from = MSR_LBR_NHM_FROM;
+	x86_pmu.lbr_to   = MSR_LBR_NHM_TO;
+
+	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
+	x86_pmu.lbr_sel_map  = hsw_lbr_sel_map;
+
+	pr_cont("16-deep LBR, ");
+}
+
 /* atom */
 void intel_pmu_lbr_init_atom(void)
 {
-- 
1.9.0

