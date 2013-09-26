Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3IZIay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:30:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:31130 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab3IZI2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:28:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,983,1371106800"; 
   d="scan'208";a="401278456"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH 3/7] perf, core: replace flush_branch_stack with ctxsw callback
Date: Thu, 26 Sep 2013 16:28:09 +0800
Message-Id: <1380184093-8838-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380184093-8838-1-git-send-email-zheng.z.yan@intel.com>
References: <1380184093-8838-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Replace the flush_branch_stack pmu callback with generic context
switch callback. x86 specific perf codes use the callback to
flush branch stack.

To avoid unnecessary overhead, the context switch callback can be
enabled/disabled.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c           |   8 +-
 arch/x86/kernel/cpu/perf_event.h           |   6 +-
 arch/x86/kernel/cpu/perf_event_intel.c     |  14 +--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  32 ++++---
 include/linux/perf_event.h                 |   7 +-
 kernel/events/core.c                       | 135 ++++++++++++++---------------
 6 files changed, 97 insertions(+), 105 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8355c84..b96aea8 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1846,10 +1846,10 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
 	NULL,
 };
 
-static void x86_pmu_flush_branch_stack(void)
+static void x86_pmu_sched_task(struct perf_event_context *ctx, bool sched_in)
 {
-	if (x86_pmu.flush_branch_stack)
-		x86_pmu.flush_branch_stack();
+	if (x86_pmu.sched_task)
+		x86_pmu.sched_task(ctx, sched_in);
 }
 
 void perf_check_microcode(void)
@@ -1878,7 +1878,7 @@ static struct pmu pmu = {
 	.commit_txn		= x86_pmu_commit_txn,
 
 	.event_idx		= x86_pmu_event_idx,
-	.flush_branch_stack	= x86_pmu_flush_branch_stack,
+	.sched_task		= x86_pmu_sched_task,
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 9be984d..62f6ee8 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -150,7 +150,6 @@ struct cpu_hw_events {
 	 * Intel LBR bits
 	 */
 	int				lbr_users;
-	void				*lbr_context;
 	struct perf_branch_stack	lbr_stack;
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 	struct er_account		*lbr_sel;
@@ -416,7 +415,8 @@ struct x86_pmu {
 	void		(*cpu_dead)(int cpu);
 
 	void		(*check_microcode)(void);
-	void		(*flush_branch_stack)(void);
+	void		(*sched_task)(struct perf_event_context *ctx,
+				     bool sched_in);
 
 	/*
 	 * Intel Arch Perfmon v2+
@@ -677,6 +677,8 @@ void intel_pmu_pebs_disable_all(void);
 
 void intel_ds_init(void);
 
+void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in);
+
 void intel_pmu_lbr_reset(void);
 
 void intel_pmu_lbr_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index b300594..92b132e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2038,18 +2038,6 @@ static void intel_pmu_cpu_dying(int cpu)
 	fini_debug_store_on_cpu(cpu);
 }
 
-static void intel_pmu_flush_branch_stack(void)
-{
-	/*
-	 * Intel LBR does not tag entries with the
-	 * PID of the current task, then we need to
-	 * flush it on ctxsw
-	 * For now, we simply reset it
-	 */
-	if (x86_pmu.lbr_nr)
-		intel_pmu_lbr_reset();
-}
-
 PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
 
 PMU_FORMAT_ATTR(ldlat, "config1:0-15");
@@ -2101,7 +2089,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
 	.guest_get_msrs		= intel_guest_get_msrs,
-	.flush_branch_stack	= intel_pmu_flush_branch_stack,
+	.sched_task		= intel_pmu_lbr_sched_task,
 };
 
 static __init void intel_clovertown_quirk(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 11911db..468ac1d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -187,24 +187,32 @@ void intel_pmu_lbr_reset(void)
 		intel_pmu_lbr_reset_64();
 }
 
-void intel_pmu_lbr_enable(struct perf_event *event)
+void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-
 	if (!x86_pmu.lbr_nr)
 		return;
 
 	/*
-	 * Reset the LBR stack if we changed task context to
-	 * avoid data leaks.
+	 * It is necessary to flush the stack on context switch. This happens
+	 * when the branch stack does not tag its entries with the pid of the
+	 * current task.
 	 */
-	if (event->ctx->task && cpuc->lbr_context != event->ctx) {
+	if (sched_in)
 		intel_pmu_lbr_reset();
-		cpuc->lbr_context = event->ctx;
-	}
+}
+
+void intel_pmu_lbr_enable(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!x86_pmu.lbr_nr)
+		return;
+
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	cpuc->lbr_users++;
+	if (cpuc->lbr_users == 1)
+		perf_sched_cb_enable(event->ctx->pmu);
 }
 
 void intel_pmu_lbr_disable(struct perf_event *event)
@@ -217,10 +225,10 @@ void intel_pmu_lbr_disable(struct perf_event *event)
 	cpuc->lbr_users--;
 	WARN_ON_ONCE(cpuc->lbr_users < 0);
 
-	if (cpuc->enabled && !cpuc->lbr_users) {
-		__intel_pmu_lbr_disable();
-		/* avoid stale pointer */
-		cpuc->lbr_context = NULL;
+	if (!cpuc->lbr_users) {
+		perf_sched_cb_disable(event->ctx->pmu);
+		if (cpuc->enabled)
+			__intel_pmu_lbr_disable();
 	}
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 866e85c..991bcf5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -248,9 +248,10 @@ struct pmu {
 	int (*event_idx)		(struct perf_event *event); /*optional */
 
 	/*
-	 * flush branch stack on context-switches (needed in cpu-wide mode)
+	 * PMU callback for context-switches. optional
 	 */
-	void (*flush_branch_stack)	(void);
+	void (*sched_task)		(struct perf_event_context *ctx,
+					 bool sched_in); /*optional */
 };
 
 /**
@@ -521,6 +522,8 @@ extern void perf_event_delayed_put(struct task_struct *task);
 extern void perf_event_print_debug(void);
 extern void perf_pmu_disable(struct pmu *pmu);
 extern void perf_pmu_enable(struct pmu *pmu);
+extern void perf_sched_cb_disable(struct pmu *pmu);
+extern void perf_sched_cb_enable(struct pmu *pmu);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
 extern int perf_event_refresh(struct perf_event *event, int refresh);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd236b6..a6e11fd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -140,7 +140,7 @@ enum event_type_t {
  */
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
-static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
+static DEFINE_PER_CPU(int, perf_sched_cb_usages);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -2297,6 +2297,62 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	}
 }
 
+void perf_sched_cb_disable(struct pmu *pmu)
+{
+	__get_cpu_var(perf_sched_cb_usages)--;
+}
+
+void perf_sched_cb_enable(struct pmu *pmu)
+{
+	__get_cpu_var(perf_sched_cb_usages)++;
+}
+
+/*
+ * This function provides the context switch callback to the lower code
+ * layer. It is invoked ONLY when the context switch callback is enabled.
+ */
+static void perf_pmu_sched_task(struct task_struct *prev,
+				struct task_struct *next,
+				bool sched_in)
+{
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	unsigned long flags;
+	int count = 0;
+
+	if (prev == next)
+		return;
+
+	local_irq_save(flags);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		if (!pmu->sched_task)
+			continue;
+
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		pmu = cpuctx->ctx.pmu;
+
+		perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+		perf_pmu_disable(pmu);
+
+		pmu->sched_task(cpuctx->task_ctx, sched_in);
+
+		perf_pmu_enable(pmu);
+
+		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+
+		if (++count >= __get_cpu_var(perf_sched_cb_usages))
+			break;
+	}
+
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
 #define for_each_task_context_nr(ctxn)					\
 	for ((ctxn) = 0; (ctxn) < perf_nr_task_contexts; (ctxn)++)
 
@@ -2316,6 +2372,9 @@ void __perf_event_task_sched_out(struct task_struct *task,
 {
 	int ctxn;
 
+	if (__get_cpu_var(perf_sched_cb_usages))
+		perf_pmu_sched_task(task, next, false);
+
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
 
@@ -2480,65 +2539,6 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	perf_pmu_rotate_start(ctx->pmu);
 }
 
-/*
- * When sampling the branck stack in system-wide, it may be necessary
- * to flush the stack on context switch. This happens when the branch
- * stack does not tag its entries with the pid of the current task.
- * Otherwise it becomes impossible to associate a branch entry with a
- * task. This ambiguity is more likely to appear when the branch stack
- * supports priv level filtering and the user sets it to monitor only
- * at the user level (which could be a useful measurement in system-wide
- * mode). In that case, the risk is high of having a branch stack with
- * branch from multiple tasks. Flushing may mean dropping the existing
- * entries or stashing them somewhere in the PMU specific code layer.
- *
- * This function provides the context switch callback to the lower code
- * layer. It is invoked ONLY when there is at least one system-wide context
- * with at least one active event using taken branch sampling.
- */
-static void perf_branch_stack_sched_in(struct task_struct *prev,
-				       struct task_struct *task)
-{
-	struct perf_cpu_context *cpuctx;
-	struct pmu *pmu;
-	unsigned long flags;
-
-	/* no need to flush branch stack if not changing task */
-	if (prev == task)
-		return;
-
-	local_irq_save(flags);
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-
-		/*
-		 * check if the context has at least one
-		 * event using PERF_SAMPLE_BRANCH_STACK
-		 */
-		if (cpuctx->ctx.nr_branch_stack > 0
-		    && pmu->flush_branch_stack) {
-
-			pmu = cpuctx->ctx.pmu;
-
-			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
-
-			perf_pmu_disable(pmu);
-
-			pmu->flush_branch_stack();
-
-			perf_pmu_enable(pmu);
-
-			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
-		}
-	}
-
-	rcu_read_unlock();
-
-	local_irq_restore(flags);
-}
 
 /*
  * Called from scheduler to add the events of the current task
@@ -2572,9 +2572,8 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
 		perf_cgroup_sched_in(prev, task);
 
-	/* check for system-wide branch_stack events */
-	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
-		perf_branch_stack_sched_in(prev, task);
+	if (__get_cpu_var(perf_sched_cb_usages))
+		perf_pmu_sched_task(prev, task, true);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
@@ -3137,10 +3136,6 @@ static void unaccount_event_cpu(struct perf_event *event, int cpu)
 	if (event->parent)
 		return;
 
-	if (has_branch_stack(event)) {
-		if (!(event->attach_state & PERF_ATTACH_TASK))
-			atomic_dec(&per_cpu(perf_branch_stack_events, cpu));
-	}
 	if (is_cgroup_event(event))
 		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
 }
@@ -6447,7 +6442,7 @@ got_cpu_context:
 	if (!pmu->event_idx)
 		pmu->event_idx = perf_event_idx_default;
 
-	list_add_rcu(&pmu->entry, &pmus);
+	list_add_tail_rcu(&pmu->entry, &pmus);
 	ret = 0;
 unlock:
 	mutex_unlock(&pmus_lock);
@@ -6530,10 +6525,6 @@ static void account_event_cpu(struct perf_event *event, int cpu)
 	if (event->parent)
 		return;
 
-	if (has_branch_stack(event)) {
-		if (!(event->attach_state & PERF_ATTACH_TASK))
-			atomic_inc(&per_cpu(perf_branch_stack_events, cpu));
-	}
 	if (is_cgroup_event(event))
 		atomic_inc(&per_cpu(perf_cgroup_events, cpu));
 }
-- 
1.8.1.4

