Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3GAHXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:23:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:6666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab3GAHXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:23:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,972,1363158000"; 
   d="scan'208";a="362388530"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        andi@firstfloor.org, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during context switch
Date: Mon,  1 Jul 2013 15:23:04 +0800
Message-Id: <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

When the LBR call stack is enabled, it is necessary to save/restore
the LBR stack on context switch. The solution is saving/restoring
the LBR stack to/from task's perf event context.

If there are cpu-wide events that use LBR, do not save/restore the
LBR stack on context switches, flush it instead.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c           |  18 +++--
 arch/x86/kernel/cpu/perf_event.h           |  14 +++-
 arch/x86/kernel/cpu/perf_event_intel.c     |  13 ++--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 111 ++++++++++++++++++++++++++---
 include/linux/perf_event.h                 |   7 +-
 kernel/events/core.c                       |  74 +++++++++++--------
 6 files changed, 180 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 94dbe71..2a79382 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1792,6 +1792,13 @@ static int x86_pmu_event_idx(struct perf_event *event)
 	return idx + 1;
 }
 
+static void x86_pmu_branch_stack_sched(struct perf_event_context *ctx,
+					bool sched_in, bool force_flush)
+{
+	if (x86_pmu.branch_stack_sched)
+		x86_pmu.branch_stack_sched(ctx, sched_in, force_flush);
+}
+
 static void *x86_pmu_event_context_alloc(struct perf_event_context *parent_ctx)
 {
 	struct perf_event_context *ctx;
@@ -1800,6 +1807,9 @@ static void *x86_pmu_event_context_alloc(struct perf_event_context *parent_ctx)
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
+	if (parent_ctx)
+		intel_pmu_lbr_init_context(ctx, parent_ctx);
+
 	return ctx;
 }
 
@@ -1857,12 +1867,6 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
 	NULL,
 };
 
-static void x86_pmu_flush_branch_stack(void)
-{
-	if (x86_pmu.flush_branch_stack)
-		x86_pmu.flush_branch_stack();
-}
-
 void perf_check_microcode(void)
 {
 	if (x86_pmu.check_microcode)
@@ -1889,7 +1893,7 @@ static struct pmu pmu = {
 	.commit_txn		= x86_pmu_commit_txn,
 
 	.event_idx		= x86_pmu_event_idx,
-	.flush_branch_stack	= x86_pmu_flush_branch_stack,
+	.branch_stack_sched     = x86_pmu_branch_stack_sched,
 	.event_context_alloc	= x86_pmu_event_context_alloc,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 047ddc6..9dff9fc 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -411,7 +411,6 @@ struct x86_pmu {
 	void		(*cpu_dead)(int cpu);
 
 	void		(*check_microcode)(void);
-	void		(*flush_branch_stack)(void);
 
 	/*
 	 * Intel Arch Perfmon v2+
@@ -440,6 +439,8 @@ struct x86_pmu {
 	int		lbr_nr;			   /* hardware stack size */
 	u64		lbr_sel_mask;		   /* LBR_SELECT valid bits */
 	const int	*lbr_sel_map;		   /* lbr_select mappings */
+	void		(*branch_stack_sched)(struct perf_event_context *ctx,
+					      bool sched_in, bool force_flush);
 
 	/*
 	 * Extra registers for events
@@ -462,6 +463,12 @@ enum {
 
 struct x86_perf_event_context {
 	struct perf_event_context ctx;
+
+	u64 lbr_from[MAX_LBR_ENTRIES];
+	u64 lbr_to[MAX_LBR_ENTRIES];
+	u64 lbr_stack_gen;
+	int lbr_callstack_users;
+	bool lbr_stack_saved;
 };
 
 #define x86_add_quirk(func_)						\
@@ -674,8 +681,13 @@ void intel_pmu_pebs_disable_all(void);
 
 void intel_ds_init(void);
 
+void intel_pmu_lbr_init_context(struct perf_event_context *child_ctx,
+				struct perf_event_context *parent_ctx);
 void intel_pmu_lbr_reset(void);
 
+void intel_pmu_lbr_sched(struct perf_event_context *ctx,
+			 bool sched_in, bool force_flush);
+
 void intel_pmu_lbr_enable(struct perf_event *event);
 
 void intel_pmu_lbr_disable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e163717..96c30bb 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1849,16 +1849,11 @@ static void intel_pmu_cpu_dying(int cpu)
 	fini_debug_store_on_cpu(cpu);
 }
 
-static void intel_pmu_flush_branch_stack(void)
+static void intel_pmu_branch_stack_sched(struct perf_event_context *ctx,
+					 bool sched_in, bool force_flush)
 {
-	/*
-	 * Intel LBR does not tag entries with the
-	 * PID of the current task, then we need to
-	 * flush it on ctxsw
-	 * For now, we simply reset it
-	 */
 	if (x86_pmu.lbr_nr)
-		intel_pmu_lbr_reset();
+		intel_pmu_lbr_sched(ctx, sched_in, force_flush);
 }
 
 PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
@@ -1912,7 +1907,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
 	.guest_get_msrs		= intel_guest_get_msrs,
-	.flush_branch_stack	= intel_pmu_flush_branch_stack,
+	.branch_stack_sched	= intel_pmu_branch_stack_sched,
 };
 
 static __init void intel_clovertown_quirk(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 11911db..013a9b9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -185,6 +185,13 @@ void intel_pmu_lbr_reset(void)
 		intel_pmu_lbr_reset_32();
 	else
 		intel_pmu_lbr_reset_64();
+
+	wrmsrl(x86_pmu.lbr_tos, 0);
+}
+
+static inline bool branch_user_callstack(unsigned br_sel)
+{
+	return (br_sel & X86_BR_USER) && (br_sel & X86_BR_CALL_STACK);
 }
 
 void intel_pmu_lbr_enable(struct perf_event *event)
@@ -194,17 +201,23 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
-	/*
-	 * Reset the LBR stack if we changed task context to
-	 * avoid data leaks.
-	 */
-	if (event->ctx->task && cpuc->lbr_context != event->ctx) {
-		intel_pmu_lbr_reset();
-		cpuc->lbr_context = event->ctx;
-	}
 	cpuc->br_sel = event->hw.branch_reg.reg;
-
 	cpuc->lbr_users++;
+
+	if (event->ctx->task &&
+	    branch_user_callstack(event->hw.branch_reg.reg)) {
+		struct x86_perf_event_context *task_ctx = (void *)event->ctx;
+		/*
+		 * Reset the LBR stack if the call stack is not
+		 * continuous enabled
+		 */
+		if (task_ctx->lbr_callstack_users == 0 &&
+		    task_ctx->lbr_stack_gen + 1 < event->ctx->sched_gen)
+			intel_pmu_lbr_reset();
+
+		task_ctx->lbr_callstack_users++;
+		task_ctx->lbr_stack_gen = event->ctx->sched_gen;
+	}
 }
 
 void intel_pmu_lbr_disable(struct perf_event *event)
@@ -214,6 +227,13 @@ void intel_pmu_lbr_disable(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	if (event->ctx->task &&
+	    branch_user_callstack(event->hw.branch_reg.reg)) {
+		struct x86_perf_event_context *task_ctx = (void *)event->ctx;
+
+		task_ctx->lbr_callstack_users--;
+	}
+
 	cpuc->lbr_users--;
 	WARN_ON_ONCE(cpuc->lbr_users < 0);
 
@@ -338,6 +358,79 @@ void intel_pmu_lbr_read(void)
 	intel_pmu_lbr_filter(cpuc);
 }
 
+static void __intel_pmu_lbr_restore(struct x86_perf_event_context *task_ctx)
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
+static void __intel_pmu_lbr_save(struct x86_perf_event_context *task_ctx)
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
+	task_ctx->lbr_stack_gen = task_ctx->ctx.sched_gen;
+	task_ctx->lbr_stack_saved = true;
+}
+
+void intel_pmu_lbr_init_context(struct perf_event_context *child_ctx,
+				struct perf_event_context *parent_ctx)
+{
+	struct x86_perf_event_context *task_ctx, *parent_task_ctx;
+
+	if (!x86_pmu.lbr_nr)
+		return;
+
+	task_ctx = (struct x86_perf_event_context *)child_ctx;
+	parent_task_ctx = (struct x86_perf_event_context *)parent_ctx;
+
+	if (parent_task_ctx->lbr_callstack_users)
+		__intel_pmu_lbr_save(task_ctx);
+	else
+		task_ctx->lbr_stack_saved = false;
+}
+
+void intel_pmu_lbr_sched(struct perf_event_context *ctx,
+			 bool sched_in, bool force_flush)
+{
+	struct x86_perf_event_context *task_ctx;
+
+	if (!x86_pmu.lbr_nr)
+		return;
+
+	task_ctx = (struct x86_perf_event_context *)ctx;
+	if (force_flush || !task_ctx) {
+		if (sched_in)
+			intel_pmu_lbr_reset();
+		else if (task_ctx)
+			task_ctx->lbr_stack_saved = false;
+		return;
+	}
+
+	if (sched_in) {
+		if (!task_ctx->lbr_stack_saved)
+			intel_pmu_lbr_reset();
+		else
+			__intel_pmu_lbr_restore(task_ctx);
+	} else {
+		__intel_pmu_lbr_save(task_ctx);
+	}
+}
+
 /*
  * SW filter is used:
  * - in case there is no HW filter
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f6d1d59..e9af629 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -271,9 +271,11 @@ struct pmu {
 	int (*event_idx)		(struct perf_event *event); /*optional */
 
 	/*
-	 * flush branch stack on context-switches (needed in cpu-wide mode)
+	 * On context-switches, save/restore the LBR stack or
+	 * flush the LBR stack (needed in cpu-wide mode)
 	 */
-	void (*flush_branch_stack)	(void);
+	void (*branch_stack_sched)	(struct perf_event_context *ctx,
+					 bool sched_in, bool force_flush);
 
 	/*
 	 * Allocate PMU special perf event context
@@ -495,6 +497,7 @@ struct perf_event_context {
 	struct perf_event_context	*parent_ctx;
 	u64				parent_gen;
 	u64				generation;
+	u64				sched_gen;
 	int				pin_count;
 	int				nr_cgroups;	 /* cgroup evts */
 	int				nr_branch_stack; /* branch_stack evt */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3aececc..02ed472 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -140,7 +140,7 @@ enum event_type_t {
  */
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
-static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
+static DEFINE_PER_CPU(int, perf_branch_stack_events);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -278,6 +278,9 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 			     enum event_type_t event_type,
 			     struct task_struct *task);
+static void perf_branch_stack_sched(struct task_struct *task1,
+				    struct task_struct *task2,
+				    bool sched_in);
 
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
@@ -1271,8 +1274,11 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 			cpuctx->cgrp = NULL;
 	}
 
-	if (has_branch_stack(event))
+	if (has_branch_stack(event)) {
+		if (ctx->is_active)
+			__get_cpu_var(perf_branch_stack_events)--;
 		ctx->nr_branch_stack--;
+	}
 
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
@@ -1796,8 +1802,10 @@ static void perf_event_sched_in(struct perf_cpu_context *cpuctx,
 				struct task_struct *task)
 {
 	cpu_ctx_sched_in(cpuctx, EVENT_PINNED, task);
-	if (ctx)
+	if (ctx) {
+		ctx->sched_gen++;
 		ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
+	}
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
 	if (ctx)
 		ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
@@ -2102,6 +2110,9 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		return;
 
+	if (!ctx->is_active && is_active)
+		__get_cpu_var(perf_branch_stack_events) -= ctx->nr_branch_stack;
+
 	update_context_time(ctx);
 	update_cgrp_time_from_cpuctx(cpuctx);
 	if (!ctx->nr_active)
@@ -2291,6 +2302,10 @@ void __perf_event_task_sched_out(struct task_struct *task,
 {
 	int ctxn;
 
+	/* check for branch_stack events running on this cpu */
+	if (__get_cpu_var(perf_branch_stack_events))
+		perf_branch_stack_sched(task, next, false);
+
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
 
@@ -2398,6 +2413,9 @@ ctx_sched_in(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		return;
 
+	if (ctx->is_active && !is_active)
+		__get_cpu_var(perf_branch_stack_events) += ctx->nr_branch_stack;
+
 	now = perf_clock();
 	ctx->timestamp = now;
 	perf_cgroup_set_timestamp(task, ctx);
@@ -2471,15 +2489,17 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
  * layer. It is invoked ONLY when there is at least one system-wide context
  * with at least one active event using taken branch sampling.
  */
-static void perf_branch_stack_sched_in(struct task_struct *prev,
-				       struct task_struct *task)
+static void perf_branch_stack_sched(struct task_struct *task1,
+				    struct task_struct *task2,
+				    bool sched_in)
 {
 	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *task_ctx;
 	struct pmu *pmu;
 	unsigned long flags;
 
 	/* no need to flush branch stack if not changing task */
-	if (prev == task)
+	if (task1 == task2)
 		return;
 
 	local_irq_save(flags);
@@ -2488,25 +2508,31 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		task_ctx = cpuctx->task_ctx;
 
 		/*
-		 * check if the context has at least one
-		 * event using PERF_SAMPLE_BRANCH_STACK
+		 * force flush the branch stack if there are cpu-wide events
+		 * using PERF_SAMPLE_BRANCH_STACK
+		 *
+		 * save/restore the branch stack if the task context has
+		 * at least one event using PERF_SAMPLE_BRANCH_STACK
 		 */
-		if (cpuctx->ctx.nr_branch_stack > 0
-		    && pmu->flush_branch_stack) {
-
+		bool force_flush = cpuctx->ctx.nr_branch_stack > 0;
+		if (pmu->branch_stack_sched &&
+		    (force_flush ||
+		     (task_ctx && task_ctx->nr_branch_stack > 0))) {
 			pmu = cpuctx->ctx.pmu;
 
-			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+			perf_ctx_lock(cpuctx, task_ctx);
 
 			perf_pmu_disable(pmu);
 
-			pmu->flush_branch_stack();
+			pmu->branch_stack_sched(task_ctx,
+						sched_in, force_flush);
 
 			perf_pmu_enable(pmu);
 
-			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+			perf_ctx_unlock(cpuctx, task_ctx);
 		}
 	}
 
@@ -2547,9 +2573,9 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
 		perf_cgroup_sched_in(prev, task);
 
-	/* check for system-wide branch_stack events */
-	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
-		perf_branch_stack_sched_in(prev, task);
+	/* check for branch_stack events running on this cpu */
+	if (__get_cpu_var(perf_branch_stack_events))
+		perf_branch_stack_sched(prev, task, true);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
@@ -3134,14 +3160,8 @@ static void free_event(struct perf_event *event)
 			static_key_slow_dec_deferred(&perf_sched_events);
 		}
 
-		if (has_branch_stack(event)) {
+		if (has_branch_stack(event))
 			static_key_slow_dec_deferred(&perf_sched_events);
-			/* is system-wide event */
-			if (!(event->attach_state & PERF_ATTACH_TASK)) {
-				atomic_dec(&per_cpu(perf_branch_stack_events,
-						    event->cpu));
-			}
-		}
 	}
 
 	if (event->rb) {
@@ -6562,12 +6582,8 @@ done:
 				return ERR_PTR(err);
 			}
 		}
-		if (has_branch_stack(event)) {
+		if (has_branch_stack(event))
 			static_key_slow_inc(&perf_sched_events.key);
-			if (!(event->attach_state & PERF_ATTACH_TASK))
-				atomic_inc(&per_cpu(perf_branch_stack_events,
-						    event->cpu));
-		}
 	}
 
 	return event;
-- 
1.8.1.4

