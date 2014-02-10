Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaBJRpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:45:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63613 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647AbaBJRpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:45:14 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, dave.martin@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/7] perf: Centralise context pmu disabling
Date: Mon, 10 Feb 2014 17:44:23 +0000
Message-Id: <1392054264-23570-7-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 443772776c69 (perf: Disable all pmus on unthrottling and
rescheduling) identified an issue with having multiple PMUs sharing a
perf_event_context, but only partially solved the issue.

While ctx::pmu will be disabled across all of its events being
scheduled, pmus which are not ctx::pmu will be repeatedly enabled and
disabled between events being added, possibly counting imbetween
pmu::add calls. This could be expensive and could lead to events
counting for differing periods.

Instead, this patch adds new helpers to disable/enable all pmus which
have events in a context. While perf_pmu_{dis,en}able may be called
repeatedly for a particular pmu, disabling is reference counted such
that the real pmu::{dis,en}able callbacks are only called once (were
this not the case, the current code would be broken for ctx::pmu).

Uses of perf_pmu{disable,enable}(ctx->pmu) are replaced with
perf_ctx_pmus_{disable,enable}(ctx). The now unnecessary calls to
perf_pmu_enable and perf_pmu_disable added by 443772776c69 are removed.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
---
 kernel/events/core.c | 65 ++++++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 710c3fe..55c772e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -500,7 +500,7 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 		 */
 		if (cpuctx->ctx.nr_cgroups > 0) {
 			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
-			perf_pmu_disable(cpuctx->ctx.pmu);
+			perf_ctx_pmus_disable(&cpuctx->ctx);
 
 			if (mode & PERF_CGROUP_SWOUT) {
 				cpu_ctx_sched_out(cpuctx, EVENT_ALL);
@@ -521,7 +521,7 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 				cpuctx->cgrp = perf_cgroup_from_task(task);
 				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
 			}
-			perf_pmu_enable(cpuctx->ctx.pmu);
+			perf_ctx_pmus_enable(&cpuctx->ctx);
 			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 		}
 	}
@@ -857,6 +857,26 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
+/*
+ * Must be called with ctx->lock or ctx->mutex held.
+ */
+void perf_ctx_pmus_disable(struct perf_event_context *ctx)
+{
+	struct perf_event *event;
+	list_for_each_entry(event, &ctx->event_list, event_entry)
+		perf_pmu_disable(event->pmu);
+}
+
+/*
+ * Must be called with ctx->lock or ctx->mutex held.
+ */
+void perf_ctx_pmus_enable(struct perf_event_context *ctx)
+{
+	struct perf_event *event;
+	list_for_each_entry(event, &ctx->event_list, event_entry)
+		perf_pmu_enable(event->pmu);
+}
+
 static DEFINE_PER_CPU(struct list_head, rotation_list);
 
 /*
@@ -1394,8 +1414,6 @@ event_sched_out(struct perf_event *event,
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return;
 
-	perf_pmu_disable(event->pmu);
-
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	if (event->pending_disable) {
 		event->pending_disable = 0;
@@ -1412,8 +1430,6 @@ event_sched_out(struct perf_event *event,
 		ctx->nr_freq--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
-
-	perf_pmu_enable(event->pmu);
 }
 
 static void
@@ -1654,7 +1670,6 @@ event_sched_in(struct perf_event *event,
 		 struct perf_event_context *ctx)
 {
 	u64 tstamp = perf_event_time(event);
-	int ret = 0;
 
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
@@ -1677,13 +1692,10 @@ event_sched_in(struct perf_event *event,
 	 */
 	smp_wmb();
 
-	perf_pmu_disable(event->pmu);
-
 	if (event->pmu->add(event, PERF_EF_START)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
-		ret = -EAGAIN;
-		goto out;
+		return -EAGAIN;
 	}
 
 	event->tstamp_running += tstamp - event->tstamp_stopped;
@@ -1699,10 +1711,7 @@ event_sched_in(struct perf_event *event,
 	if (event->attr.exclusive)
 		cpuctx->exclusive = 1;
 
-out:
-	perf_pmu_enable(event->pmu);
-
-	return ret;
+	return 0;
 }
 
 static int
@@ -1848,7 +1857,7 @@ static int  __perf_install_in_context(void *info)
 	struct task_struct *task = current;
 
 	perf_ctx_lock(cpuctx, task_ctx);
-	perf_pmu_disable(cpuctx->ctx.pmu);
+	perf_ctx_pmus_disable(&cpuctx->ctx);
 
 	/*
 	 * If there was an active task_ctx schedule it out.
@@ -1889,7 +1898,7 @@ static int  __perf_install_in_context(void *info)
 	 */
 	perf_event_sched_in(cpuctx, task_ctx, task);
 
-	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_ctx_pmus_enable(&cpuctx->ctx);
 	perf_ctx_unlock(cpuctx, task_ctx);
 
 	return 0;
@@ -2147,7 +2156,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (!ctx->nr_active)
 		return;
 
-	perf_pmu_disable(ctx->pmu);
+	perf_ctx_pmus_disable(ctx);
 	if ((is_active & EVENT_PINNED) && (event_type & EVENT_PINNED)) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
@@ -2157,7 +2166,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
-	perf_pmu_enable(ctx->pmu);
+	perf_ctx_pmus_enable(ctx);
 }
 
 /*
@@ -2491,7 +2500,7 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 		return;
 
 	perf_ctx_lock(cpuctx, ctx);
-	perf_pmu_disable(ctx->pmu);
+	perf_ctx_pmus_disable(ctx);
 	/*
 	 * We want to keep the following priority order:
 	 * cpu pinned (that don't need to move), task pinned,
@@ -2504,7 +2513,7 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 
 	perf_event_sched_in(cpuctx, cpuctx->task_ctx, task);
 
-	perf_pmu_enable(ctx->pmu);
+	perf_ctx_pmus_enable(ctx);
 	perf_ctx_unlock(cpuctx, ctx);
 
 	/*
@@ -2736,7 +2745,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		return;
 
 	raw_spin_lock(&ctx->lock);
-	perf_pmu_disable(ctx->pmu);
+	perf_ctx_pmus_disable(ctx);
 
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
@@ -2745,8 +2754,6 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		if (!event_filter_match(event))
 			continue;
 
-		perf_pmu_disable(event->pmu);
-
 		hwc = &event->hw;
 
 		if (hwc->interrupts == MAX_INTERRUPTS) {
@@ -2756,7 +2763,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		}
 
 		if (!event->attr.freq || !event->attr.sample_freq)
-			goto next;
+			continue;
 
 		/*
 		 * stop the event and update event->count
@@ -2778,11 +2785,9 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 			perf_adjust_period(event, period, delta, false);
 
 		event->pmu->start(event, delta > 0 ? PERF_EF_RELOAD : 0);
-	next:
-		perf_pmu_enable(event->pmu);
 	}
 
-	perf_pmu_enable(ctx->pmu);
+	perf_ctx_pmus_enable(ctx);
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -2826,7 +2831,7 @@ static int perf_rotate_context(struct perf_cpu_context *cpuctx)
 		goto done;
 
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
-	perf_pmu_disable(cpuctx->ctx.pmu);
+	perf_ctx_pmus_disable(&cpuctx->ctx);
 
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
@@ -2838,7 +2843,7 @@ static int perf_rotate_context(struct perf_cpu_context *cpuctx)
 
 	perf_event_sched_in(cpuctx, ctx, current);
 
-	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_ctx_pmus_enable(&cpuctx->ctx);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 done:
 	if (remove)
-- 
1.8.1.1

