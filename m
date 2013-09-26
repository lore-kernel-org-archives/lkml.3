Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3IZIax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:30:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:31133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab3IZI2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:28:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,983,1371106800"; 
   d="scan'208";a="401278462"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH 4/7] perf, x86: Save/resotre LBR stack during context switch
Date: Thu, 26 Sep 2013 16:28:10 +0800
Message-Id: <1380184093-8838-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380184093-8838-1-git-send-email-zheng.z.yan@intel.com>
References: <1380184093-8838-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

When the LBR call stack is enabled, it is necessary to save/restore
the LBR stack on context switch. The solution is saving/restoring
the LBR stack to/from task's perf event context.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c           |   1 +
 arch/x86/kernel/cpu/perf_event.h           |   8 +++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 101 ++++++++++++++++++++++++-----
 include/linux/perf_event.h                 |   5 ++
 kernel/events/core.c                       |  22 ++++++-
 5 files changed, 121 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b96aea8..d29d852 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1879,6 +1879,7 @@ static struct pmu pmu = {
 
 	.event_idx		= x86_pmu_event_idx,
 	.sched_task		= x86_pmu_sched_task,
+	.task_ctx_size          = sizeof(struct x86_perf_task_context),
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 62f6ee8..b1d2fa9 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -150,6 +150,7 @@ struct cpu_hw_events {
 	 * Intel LBR bits
 	 */
 	int				lbr_users;
+	int				lbr_sys_users;
 	struct perf_branch_stack	lbr_stack;
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 	struct er_account		*lbr_sel;
@@ -458,6 +459,13 @@ struct x86_pmu {
 	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
 };
 
+struct x86_perf_task_context {
+	u64 lbr_from[MAX_LBR_ENTRIES];
+	u64 lbr_to[MAX_LBR_ENTRIES];
+	int lbr_callstack_users;
+	bool lbr_stack_saved;
+};
+
 enum {
 	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = PERF_SAMPLE_BRANCH_MAX_SHIFT,
 	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 468ac1d..a160891 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -187,29 +187,103 @@ void intel_pmu_lbr_reset(void)
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
+	task_ctx->lbr_stack_saved = false;
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
+	task_ctx->lbr_stack_saved = true;
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
+	
+	cpuc = &__get_cpu_var(cpu_hw_events);
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
+		if (cpuc->lbr_sys_users > 0 ||
+		    !task_ctx ||
+		    !task_ctx->lbr_stack_saved ||
+		    !task_ctx->lbr_callstack_users)
+			intel_pmu_lbr_reset();
+		else
+			__intel_pmu_lbr_restore(task_ctx);
+	} else if (task_ctx) {
+		if (task_ctx->lbr_callstack_users)
+			__intel_pmu_lbr_save(task_ctx);
+		else
+			task_ctx->lbr_stack_saved = false;
+	}
+}
+
+static inline bool branch_user_callstack(unsigned br_sel)
+{
+	return (br_sel & X86_BR_USER) && (br_sel & X86_BR_CALL_STACK);
 }
 
 void intel_pmu_lbr_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct x86_perf_task_context *task_ctx;
 
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	cpuc = &__get_cpu_var(cpu_hw_events);
+	task_ctx = event->ctx ? event->ctx->task_ctx_data : NULL;
+
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
+	if (!(event->attach_state & PERF_ATTACH_TASK))
+		cpuc->lbr_sys_users++;
+	else if (branch_user_callstack(cpuc->br_sel))
+		task_ctx->lbr_callstack_users++;
+
 	cpuc->lbr_users++;
 	if (cpuc->lbr_users == 1)
 		perf_sched_cb_enable(event->ctx->pmu);
@@ -217,10 +291,19 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 
 void intel_pmu_lbr_disable(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc;
+	struct x86_perf_task_context *task_ctx;
 
 	if (!x86_pmu.lbr_nr)
 		return;
+	
+	cpuc = &__get_cpu_var(cpu_hw_events);
+	task_ctx = event->ctx ? event->ctx->task_ctx_data : NULL;
+
+	if (!(event->attach_state & PERF_ATTACH_TASK))
+		cpuc->lbr_sys_users--;
+	else if (branch_user_callstack(cpuc->br_sel))
+		task_ctx->lbr_callstack_users--;
 
 	cpuc->lbr_users--;
 	WARN_ON_ONCE(cpuc->lbr_users < 0);
@@ -248,18 +331,6 @@ void intel_pmu_lbr_disable_all(void)
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
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 991bcf5..23471c2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -252,6 +252,10 @@ struct pmu {
 	 */
 	void (*sched_task)		(struct perf_event_context *ctx,
 					 bool sched_in); /*optional */
+	/*
+	 * PMU specific data size
+	 */
+	size_t				task_ctx_size;
 };
 
 /**
@@ -471,6 +475,7 @@ struct perf_event_context {
 	int				pin_count;
 	int				nr_cgroups;	 /* cgroup evts */
 	int				nr_branch_stack; /* branch_stack evt */
+	void				*task_ctx_data; /* pmu specific data */
 	struct rcu_head			rcu_head;
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6e11fd..89ce4f9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -882,6 +882,16 @@ static void get_ctx(struct perf_event_context *ctx)
 	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
 }
 
+static void free_ctx(struct rcu_head *head)
+{
+	struct perf_event_context *ctx;
+
+	ctx = container_of(head, struct perf_event_context, rcu_head);
+	if (ctx->task_ctx_data)
+		kfree(ctx->task_ctx_data);
+	kfree(ctx);
+}
+
 static void put_ctx(struct perf_event_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
@@ -889,7 +899,7 @@ static void put_ctx(struct perf_event_context *ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task)
 			put_task_struct(ctx->task);
-		kfree_rcu(ctx, rcu_head);
+		call_rcu(&ctx->rcu_head, free_ctx);
 	}
 }
 
@@ -2280,6 +2290,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 			next->perf_event_ctxp[ctxn] = ctx;
 			ctx->task = next;
 			next_ctx->task = task;
+			ctx->task_ctx_data = xchg(&next_ctx->task_ctx_data,
+						  ctx->task_ctx_data);
 			do_switch = 0;
 
 			perf_event_sync_stat(ctx, next_ctx);
@@ -2994,6 +3006,14 @@ alloc_perf_context(struct pmu *pmu, struct task_struct *task)
 	if (!ctx)
 		return NULL;
 
+	if (pmu->task_ctx_size) {
+		ctx->task_ctx_data = kzalloc(pmu->task_ctx_size, GFP_KERNEL);
+		if (!ctx->task_ctx_data) {
+			kfree(ctx);
+			return NULL;
+		}
+	}
+
 	__perf_event_init_context(ctx);
 	if (task) {
 		ctx->task = task;
-- 
1.8.1.4

