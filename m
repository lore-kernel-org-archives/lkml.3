Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaF3Ixv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:53:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:43142 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbaF3IvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:51:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="536451094"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V4 09/16] perf, x86: Save/resotre LBR stack during context switch
Date: Mon, 30 Jun 2014 16:50:46 +0800
Message-Id: <1404118253-19532-10-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the LBR call stack is enabled, it is necessary to save/restore
the LBR stack on context switch. The solution is saving/restoring
the LBR stack to/from task's perf event context.

The LBR stack is saved/restored only when there are events that use
the LBR call stack. If no event uses LBR call stack, the LBR stack
is reset when task is scheduled in.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 81 ++++++++++++++++++++++++------
 1 file changed, 65 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 66969cb..639ab1d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -180,21 +180,82 @@ void intel_pmu_lbr_reset(void)
 		intel_pmu_lbr_reset_64();
 }
 
+/*
+ * TOS = most recently recorded branch
+ */
+static inline u64 intel_pmu_lbr_tos(void)
+{
+	u64 tos;
+	rdmsrl(x86_pmu.lbr_tos, tos);
+	return tos;
+}
+
+enum {
+	LBR_NONE,
+	LBR_VALID,
+};
+
+static void __intel_pmu_lbr_restore(struct x86_perf_task_context *task_ctx)
+{
+	int i;
+	unsigned lbr_idx, mask = x86_pmu.lbr_nr - 1;
+	u64 tos = intel_pmu_lbr_tos();
+
+	for (i = 0; i < x86_pmu.lbr_nr; i++) {
+		lbr_idx = (tos - i) & mask;
+		wrmsrl(x86_pmu.lbr_from + lbr_idx, task_ctx->lbr_from[i]);
+		wrmsrl(x86_pmu.lbr_to + lbr_idx, task_ctx->lbr_to[i]);
+	}
+	task_ctx->lbr_stack_state = LBR_NONE;
+}
+
+static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
+{
+	int i;
+	unsigned lbr_idx, mask = x86_pmu.lbr_nr - 1;
+	u64 tos = intel_pmu_lbr_tos();
+
+	for (i = 0; i < x86_pmu.lbr_nr; i++) {
+		lbr_idx = (tos - i) & mask;
+		rdmsrl(x86_pmu.lbr_from + lbr_idx, task_ctx->lbr_from[i]);
+		rdmsrl(x86_pmu.lbr_to + lbr_idx, task_ctx->lbr_to[i]);
+	}
+	task_ctx->lbr_stack_state = LBR_VALID;
+}
+
+
 void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct x86_perf_task_context *task_ctx;
 
 	if (!x86_pmu.lbr_nr)
 		return;
 
 	/*
-	 * It is necessary to flush the stack on context switch. This happens
-	 * when the branch stack does not tag its entries with the pid of the
-	 * current task.
+	 * If LBR callstack feature is enabled and the stack was saved when
+	 * the task was scheduled out, restore the stack. Otherwise flush
+	 * the LBR stack.
 	 */
+	task_ctx = ctx ? ctx->task_ctx_data : NULL;
 	if (sched_in) {
-		intel_pmu_lbr_reset();
+		if (task_ctx &&
+		    task_ctx->lbr_callstack_users > 0 &&
+		    task_ctx->lbr_stack_state == LBR_VALID)
+			__intel_pmu_lbr_restore(task_ctx);
+		else
+			intel_pmu_lbr_reset();
+
 		cpuc->lbr_context = ctx;
+		return;
+	}
+
+	/* schedule out */
+	if (task_ctx) {
+		if (task_ctx->lbr_callstack_users)
+			__intel_pmu_lbr_save(task_ctx);
+		else
+			task_ctx->lbr_stack_state = LBR_NONE;
 	}
 }
 
@@ -270,18 +331,6 @@ void intel_pmu_lbr_disable_all(void)
 		__intel_pmu_lbr_disable();
 }
 
-/*
- * TOS = most recently recorded branch
- */
-static inline u64 intel_pmu_lbr_tos(void)
-{
-	u64 tos;
-
-	rdmsrl(x86_pmu.lbr_tos, tos);
-
-	return tos;
-}
-
 static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
 {
 	unsigned long mask = x86_pmu.lbr_nr - 1;
-- 
1.9.0

