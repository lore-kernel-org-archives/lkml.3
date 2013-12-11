Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3LKHNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:13:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:40037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab3LKHLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="450352526"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 10/15] perf, x86: Save/resotre LBR stack during context switch
Date: Wed, 11 Dec 2013 15:10:55 +0800
Message-Id: <1386745860-21143-11-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
References: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

When the LBR call stack is enabled, it is necessary to save/restore
the LBR stack on context switch. The solution is saving/restoring
the LBR stack to/from task's perf event context.

Don't save/restore the LBR stack if task has no perf event context
or there are system-wide users of LBR stack. Flush the LBR stack
instead.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 83 +++++++++++++++++++++++++-----
 1 file changed, 69 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index f57960d..80bb097 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -187,18 +187,85 @@ void intel_pmu_lbr_reset(void)
 		intel_pmu_lbr_reset_64();
 }
 
+/*
+ * TOS = most recently recorded branch
+ */
+static inline u64 intel_pmu_lbr_tos(void)
+{
+	u64 tos;
+
+	rdmsrl(x86_pmu.lbr_tos, tos);
+
+	return tos;
+}
+
+enum {
+	LBR_UNINIT,
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
+	struct cpu_hw_events *cpuc;
+	struct x86_perf_task_context *task_ctx;
+
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	cpuc = &__get_cpu_var(cpu_hw_events);
+	task_ctx = ctx ? ctx->task_ctx_data : NULL;
+
+
 	/*
 	 * It is necessary to flush the stack on context switch. This happens
 	 * when the branch stack does not tag its entries with the pid of the
 	 * current task.
 	 */
-	if (sched_in)
-		intel_pmu_lbr_reset();
+	if (sched_in) {
+		if (cpuc->lbr_sys_users > 0 ||
+		    !task_ctx ||
+		    !task_ctx->lbr_callstack_users ||
+		    task_ctx->lbr_stack_state != LBR_VALID)
+			intel_pmu_lbr_reset();
+		else
+			__intel_pmu_lbr_restore(task_ctx);
+	} else if (task_ctx) {
+		if (task_ctx->lbr_callstack_users &&
+		    task_ctx->lbr_stack_state != LBR_UNINIT)
+			__intel_pmu_lbr_save(task_ctx);
+		else
+			task_ctx->lbr_stack_state = LBR_NONE;
+	}
 }
 
 static inline bool branch_user_callstack(unsigned br_sel)
@@ -271,18 +338,6 @@ void intel_pmu_lbr_disable_all(void)
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
1.8.1.4

