Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaJSWH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:07:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:9411 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbaJSWFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644492"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 09/17] perf, x86: Save/resotre LBR stack during context switch
Date: Sun, 19 Oct 2014 17:55:04 -0400
Message-Id: <1413755712-8259-10-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
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
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 89 ++++++++++++++++++++++++++----
 1 file changed, 77 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index f9b9f2b..1908875 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -180,13 +180,90 @@ void intel_pmu_lbr_reset(void)
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
+	unsigned lbr_idx, mask;
+	u64 tos;
+
+	if (task_ctx->lbr_callstack_users == 0 ||
+	    task_ctx->lbr_stack_state == LBR_NONE) {
+		intel_pmu_lbr_reset();
+		return;
+	}
+
+	mask = x86_pmu.lbr_nr - 1;
+	tos = intel_pmu_lbr_tos();
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
+	unsigned lbr_idx, mask;
+	u64 tos;
+
+	if (task_ctx->lbr_callstack_users == 0) {
+		task_ctx->lbr_stack_state = LBR_NONE;
+		return;
+	}
+
+	mask = x86_pmu.lbr_nr - 1;
+	tos = intel_pmu_lbr_tos();
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
+	 * If LBR callstack feature is enabled and the stack was saved when
+	 * the task was scheduled out, restore the stack. Otherwise flush
+	 * the LBR stack.
+	 */
+	task_ctx = ctx ? ctx->task_ctx_data : NULL;
+	if (task_ctx) {
+		if (sched_in) {
+			__intel_pmu_lbr_restore(task_ctx);
+			cpuc->lbr_context = ctx;
+		} else {
+			__intel_pmu_lbr_save(task_ctx);
+		}
+		return;
+	}
+
+	/*
 	 * When sampling the branck stack in system-wide, it may be
 	 * necessary to flush the stack on context switch. This happens
 	 * when the branch stack does not tag its entries with the pid
@@ -277,18 +354,6 @@ void intel_pmu_lbr_disable_all(void)
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
1.8.3.2

