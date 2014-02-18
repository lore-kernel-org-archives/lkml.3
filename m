Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaBRGJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:09:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:43042 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbaBRGH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:07:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,500,1389772800"; 
   d="scan'208";a="483239691"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v3 09/14] perf, x86: Save/resotre LBR stack during context switch
Date: Tue, 18 Feb 2014 14:07:36 +0800
Message-Id: <1392703661-15104-10-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
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
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 79 ++++++++++++++++++++++++------
 1 file changed, 65 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 2e80727..aa726af 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -187,18 +187,81 @@ void intel_pmu_lbr_reset(void)
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
+	struct x86_perf_task_context *task_ctx;
+
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	task_ctx = ctx ? ctx->task_ctx_data : NULL;
+
 	/*
 	 * It is necessary to flush the stack on context switch. This happens
 	 * when the branch stack does not tag its entries with the pid of the
 	 * current task.
 	 */
-	if (sched_in)
-		intel_pmu_lbr_reset();
+	if (sched_in) {
+		if (!task_ctx ||
+		    !task_ctx->lbr_callstack_users ||
+		    task_ctx->lbr_stack_state != LBR_VALID)
+			intel_pmu_lbr_reset();
+		else
+			__intel_pmu_lbr_restore(task_ctx);
+		return;
+	}
+
+	/* schedule out */
+	if (task_ctx) {
+		if (task_ctx->lbr_callstack_users)
+			__intel_pmu_lbr_save(task_ctx);
+		else
+			task_ctx->lbr_stack_state = LBR_NONE;
+	}
 }
 
 static inline bool branch_user_callstack(unsigned br_sel)
@@ -267,18 +330,6 @@ void intel_pmu_lbr_disable_all(void)
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
1.8.5.3

