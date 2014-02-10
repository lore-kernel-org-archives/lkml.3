Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaBJRpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:45:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63605 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955AbaBJRpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:45:10 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, dave.martin@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 7/7] perf: kill perf_event_context::pmu
Date: Mon, 10 Feb 2014 17:44:24 +0000
Message-Id: <1392054264-23570-8-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently portions of the perf subsystem assume that a
perf_event_context is associated with a single pmu while in reality a
single perf_event_context may be shared by a number of pmus, as commit
443772776c69 (perf: Disable all pmus on unthrottling and rescheduling)
describes.

This patch removes perf_event_context::pmu, replacing it with a direct
pointer to the associated perf_cpu_context and a task_ctx_nr (as all
pmus sharing a context have the same task_ctx_nr). This makes the
relationship between pmus and perf_event_contexts clearer and allows us
to save on some pointer chasing.

This also fixes a potential misuse of ctx->pmu introduced in commit
bad7192b842c (perf: Fix PERF_EVENT_IOC_PERIOD to force-reset the
period), where ctx->pmu is disabled before modifying state on
event->pmu. In this case the two pmus are not guaranteed to be the same.

As perf_pmu_rotate_{start,stop} only really care about the context they
are rotating, they are renamed to perf_event_ctx_{start,stop}.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/perf_event.h |  3 ++-
 kernel/events/core.c       | 47 +++++++++++++++++++++++++---------------------
 2 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7794a39..2123882 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -445,7 +445,8 @@ struct perf_event {
  * Used as a container for task events and CPU events as well:
  */
 struct perf_event_context {
-	struct pmu			*pmu;
+	struct perf_cpu_context __percpu *cpu_ctx;
+	enum perf_event_task_context	task_ctx_nr;
 	/*
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 55c772e..541dcb5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -299,7 +299,7 @@ static inline u64 perf_clock(void)
 static inline struct perf_cpu_context *
 __get_cpu_context(struct perf_event_context *ctx)
 {
-	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
+	return this_cpu_ptr(ctx->cpu_ctx);
 }
 
 static void perf_ctx_lock(struct perf_cpu_context *cpuctx,
@@ -808,11 +808,10 @@ void perf_cpu_hrtimer_cancel(int cpu)
 static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct hrtimer *hr = &cpuctx->hrtimer;
-	struct pmu *pmu = cpuctx->ctx.pmu;
 	int timer;
 
 	/* no multiplexing needed for SW PMU */
-	if (pmu->task_ctx_nr == perf_sw_context)
+	if (cpuctx->ctx.task_ctx_nr == perf_sw_context)
 		return;
 
 	/*
@@ -829,10 +828,9 @@ static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
 static void perf_cpu_hrtimer_restart(struct perf_cpu_context *cpuctx)
 {
 	struct hrtimer *hr = &cpuctx->hrtimer;
-	struct pmu *pmu = cpuctx->ctx.pmu;
 
 	/* not for SW PMU */
-	if (pmu->task_ctx_nr == perf_sw_context)
+	if (cpuctx->ctx.task_ctx_nr == perf_sw_context)
 		return;
 
 	if (hrtimer_active(hr))
@@ -880,13 +878,13 @@ void perf_ctx_pmus_enable(struct perf_event_context *ctx)
 static DEFINE_PER_CPU(struct list_head, rotation_list);
 
 /*
- * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
+ * perf_ctx_rotate_start() and perf_rotate_context() are fully serialized
  * because they're strictly cpu affine and rotate_start is called with IRQs
  * disabled, while rotate_context is called from IRQ context.
  */
-static void perf_pmu_rotate_start(struct pmu *pmu)
+static void perf_ctx_rotate_start(struct perf_event_context *ctx)
 {
-	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(ctx->cpu_ctx);
 	struct list_head *head = &__get_cpu_var(rotation_list);
 
 	WARN_ON(!irqs_disabled());
@@ -1151,7 +1149,7 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
-		perf_pmu_rotate_start(ctx->pmu);
+		perf_ctx_rotate_start(ctx);
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
@@ -2520,7 +2518,7 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	 * Since these rotations are per-cpu, we need to ensure the
 	 * cpu-context we got scheduled on is actually rotating.
 	 */
-	perf_pmu_rotate_start(ctx->pmu);
+	perf_ctx_rotate_start(ctx);
 }
 
 /*
@@ -2805,7 +2803,7 @@ static void rotate_ctx(struct perf_event_context *ctx)
 }
 
 /*
- * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
+ * perf_ctx_rotate_start() and perf_rotate_context() are fully serialized
  * because they're strictly cpu affine and rotate_start is called with IRQs
  * disabled, while rotate_context is called from IRQ context.
  */
@@ -3028,7 +3026,9 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
 }
 
 static struct perf_event_context *
-alloc_perf_context(struct pmu *pmu, struct task_struct *task)
+alloc_perf_context(enum perf_event_task_context task_ctx_nr,
+		   struct perf_cpu_context __percpu *cpuctx,
+		   struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 
@@ -3041,7 +3041,8 @@ alloc_perf_context(struct pmu *pmu, struct task_struct *task)
 		ctx->task = task;
 		get_task_struct(task);
 	}
-	ctx->pmu = pmu;
+	ctx->task_ctx_nr = task_ctx_nr;
+	ctx->cpu_ctx = cpuctx;
 
 	return ctx;
 }
@@ -3120,7 +3121,8 @@ retry:
 		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	} else {
-		ctx = alloc_perf_context(pmu, task);
+		ctx = alloc_perf_context(pmu->task_ctx_nr,
+					 pmu->pmu_cpu_context, task);
 		err = -ENOMEM;
 		if (!ctx)
 			goto errout;
@@ -3565,7 +3567,7 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
 
 	active = (event->state == PERF_EVENT_STATE_ACTIVE);
 	if (active) {
-		perf_pmu_disable(ctx->pmu);
+		perf_pmu_disable(event->pmu);
 		event->pmu->stop(event, PERF_EF_UPDATE);
 	}
 
@@ -3573,7 +3575,7 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
 
 	if (active) {
 		event->pmu->start(event, PERF_EF_RELOAD);
-		perf_pmu_enable(ctx->pmu);
+		perf_pmu_enable(event->pmu);
 	}
 
 unlock:
@@ -6495,7 +6497,9 @@ skip_type:
 		__perf_event_init_context(&cpuctx->ctx);
 		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
 		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
-		cpuctx->ctx.pmu = pmu;
+
+		cpuctx->ctx.task_ctx_nr = pmu->task_ctx_nr;
+		cpuctx->ctx.cpu_ctx = pmu->pmu_cpu_context;
 
 		__perf_cpu_hrtimer_init(cpuctx, cpu);
 
@@ -7684,7 +7688,8 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		 * child.
 		 */
 
-		child_ctx = alloc_perf_context(parent_ctx->pmu, child);
+		child_ctx = alloc_perf_context(parent_ctx->task_ctx_nr,
+						parent_ctx->cpu_ctx, child);
 		if (!child_ctx)
 			return -ENOMEM;
 
@@ -7843,9 +7848,9 @@ static void perf_event_init_cpu(int cpu)
 }
 
 #if defined CONFIG_HOTPLUG_CPU || defined CONFIG_KEXEC
-static void perf_pmu_rotate_stop(struct pmu *pmu)
+static void perf_ctx_rotate_stop(struct perf_event_context *ctx)
 {
-	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(ctx->cpu_ctx);
 
 	WARN_ON(!irqs_disabled());
 
@@ -7857,7 +7862,7 @@ static void __perf_event_exit_context(void *__info)
 	struct perf_event_context *ctx = __info;
 	struct perf_event *event, *tmp;
 
-	perf_pmu_rotate_stop(ctx->pmu);
+	perf_ctx_rotate_stop(ctx);
 
 	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
 		__perf_remove_from_context(event);
-- 
1.8.1.1

