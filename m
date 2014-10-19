Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaJSWFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:05:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:48491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaJSWFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644461"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 03/17] perf, x86: use context switch callback to flush LBR stack
Date: Sun, 19 Oct 2014 17:54:58 -0400
Message-Id: <1413755712-8259-4-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous commit introduces context switch callback, its function
overlaps with the flush branch stack callback. So we can use the
context switch callback to flush LBR stack.

This patch adds code that uses the flush branch callback to
flush the LBR stack when task is being scheduled in. The callback
is enabled only when there are events use the LBR hardware. This
patch also removes all old flush branch stack code.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c           |  7 ---
 arch/x86/kernel/cpu/perf_event.h           |  3 +-
 arch/x86/kernel/cpu/perf_event_intel.c     | 14 +-----
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 27 ++++++++++-
 include/linux/perf_event.h                 |  6 ---
 kernel/events/core.c                       | 77 ------------------------------
 6 files changed, 29 insertions(+), 105 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b42a204..fa7a168 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1893,12 +1893,6 @@ static void x86_pmu_sched_task(struct perf_event_context *ctx, bool sched_in)
 		x86_pmu.sched_task(ctx, sched_in);
 }
 
-static void x86_pmu_flush_branch_stack(void)
-{
-	if (x86_pmu.flush_branch_stack)
-		x86_pmu.flush_branch_stack();
-}
-
 void perf_check_microcode(void)
 {
 	if (x86_pmu.check_microcode)
@@ -1925,7 +1919,6 @@ static struct pmu pmu = {
 	.commit_txn		= x86_pmu_commit_txn,
 
 	.event_idx		= x86_pmu_event_idx,
-	.flush_branch_stack	= x86_pmu_flush_branch_stack,
 	.sched_task		= x86_pmu_sched_task,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 4dafbe3..c84378b 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -467,7 +467,6 @@ struct x86_pmu {
 	void		(*cpu_dead)(int cpu);
 
 	void		(*check_microcode)(void);
-	void		(*flush_branch_stack)(void);
 	void		(*sched_task)(struct perf_event_context *ctx,
 				      bool sched_in);
 
@@ -728,6 +727,8 @@ void intel_pmu_pebs_disable_all(void);
 
 void intel_ds_init(void);
 
+void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in);
+
 void intel_pmu_lbr_reset(void);
 
 void intel_pmu_lbr_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3851def..38042e3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2191,18 +2191,6 @@ static void intel_pmu_cpu_dying(int cpu)
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
@@ -2254,7 +2242,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
 	.guest_get_msrs		= intel_guest_get_msrs,
-	.flush_branch_stack	= intel_pmu_flush_branch_stack,
+	.sched_task		= intel_pmu_lbr_sched_task,
 };
 
 static __init void intel_clovertown_quirk(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 7344f05..18d13ca 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -177,13 +177,36 @@ void intel_pmu_lbr_reset(void)
 		intel_pmu_lbr_reset_64();
 }
 
-void intel_pmu_lbr_enable(struct perf_event *event)
+void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (!x86_pmu.lbr_nr)
 		return;
+	/*
+	 * When sampling the branck stack in system-wide, it may be
+	 * necessary to flush the stack on context switch. This happens
+	 * when the branch stack does not tag its entries with the pid
+	 * of the current task. Otherwise it becomes impossible to
+	 * associate a branch entry with a task. This ambiguity is more
+	 * likely to appear when the branch stack supports priv level
+	 * filtering and the user sets it to monitor only at the user
+	 * level (which could be a useful measurement in system-wide
+	 * mode). In that case, the risk is high of having a branch
+	 * stack with branch from multiple tasks.
+	 */
+	if (sched_in) {
+		intel_pmu_lbr_reset();
+		cpuc->lbr_context = ctx;
+	}
+}
 
+void intel_pmu_lbr_enable(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!x86_pmu.lbr_nr)
+		return;
 	/*
 	 * Reset the LBR stack if we changed task context to
 	 * avoid data leaks.
@@ -195,6 +218,7 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	cpuc->lbr_users++;
+	perf_sched_cb_inc(event->ctx->pmu);
 }
 
 void intel_pmu_lbr_disable(struct perf_event *event)
@@ -206,6 +230,7 @@ void intel_pmu_lbr_disable(struct perf_event *event)
 
 	cpuc->lbr_users--;
 	WARN_ON_ONCE(cpuc->lbr_users < 0);
+	perf_sched_cb_dec(event->ctx->pmu);
 
 	if (cpuc->enabled && !cpuc->lbr_users) {
 		__intel_pmu_lbr_disable();
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 40ecad1..c392fd5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -260,11 +260,6 @@ struct pmu {
 	int (*event_idx)		(struct perf_event *event); /*optional */
 
 	/*
-	 * flush branch stack on context-switches (needed in cpu-wide mode)
-	 */
-	void (*flush_branch_stack)	(void);
-
-	/*
 	 * context-switches callback
 	 */
 	void (*sched_task)		(struct perf_event_context *ctx,
@@ -514,7 +509,6 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	int				nr_cgroups;	 /* cgroup evts */
-	int				nr_branch_stack; /* branch_stack evt */
 	struct rcu_head			rcu_head;
 
 	struct delayed_work		orphans_remove;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 362cb3a..5971e7d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -153,7 +153,6 @@ enum event_type_t {
  */
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
-static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
 static DEFINE_PER_CPU(int, perf_sched_cb_usages);
 
 static atomic_t nr_mmap_events __read_mostly;
@@ -1152,9 +1151,6 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (is_cgroup_event(event))
 		ctx->nr_cgroups++;
 
-	if (has_branch_stack(event))
-		ctx->nr_branch_stack++;
-
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
 		perf_pmu_rotate_start(ctx->pmu);
@@ -1317,9 +1313,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 			cpuctx->cgrp = NULL;
 	}
 
-	if (has_branch_stack(event))
-		ctx->nr_branch_stack--;
-
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -2673,64 +2666,6 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 }
 
 /*
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
-
-/*
  * Called from scheduler to add the events of the current task
  * with interrupts disabled.
  *
@@ -2762,10 +2697,6 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
 		perf_cgroup_sched_in(prev, task);
 
-	/* check for system-wide branch_stack events */
-	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
-		perf_branch_stack_sched_in(prev, task);
-
 	if (__this_cpu_read(perf_sched_cb_usages))
 		perf_pmu_sched_task(prev, task, true);
 }
@@ -3359,10 +3290,6 @@ static void unaccount_event_cpu(struct perf_event *event, int cpu)
 	if (event->parent)
 		return;
 
-	if (has_branch_stack(event)) {
-		if (!(event->attach_state & PERF_ATTACH_TASK))
-			atomic_dec(&per_cpu(perf_branch_stack_events, cpu));
-	}
 	if (is_cgroup_event(event))
 		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
 }
@@ -6935,10 +6862,6 @@ static void account_event_cpu(struct perf_event *event, int cpu)
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
1.8.3.2

