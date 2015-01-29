Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbbA2Npj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:45:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45923 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbbA2Npi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:45:38 -0500
Date: Thu, 29 Jan 2015 13:45:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [perf] WARNING: CPU: 0 PID: 1457 at kernel/events/core.c:890
 add_event_to_ctx()
Message-ID: <20150129134511.GR17721@leverpostej>
References: <20150125043428.GA6109@wfg-t540p.sh.intel.com>
 <20150125155633.GA22257@leverpostej>
 <20150126184554.GM23313@leverpostej>
 <20150128123813.GE23038@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128123813.GE23038@twins.programming.kicks-ass.net>
Thread-Topic: [perf] WARNING: CPU: 0 PID: 1457 at kernel/events/core.c:890
 add_event_to_ctx()
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 12:38:13PM +0000, Peter Zijlstra wrote:
> On Mon, Jan 26, 2015 at 06:45:54PM +0000, Mark Rutland wrote:
> > Peter, does the below patch look OK to you?
> 
> More or lessish, but its failing to apply on top of the broken patch.
> Could you send me a fresh patch that's both rolled in one?

Sorry about the mess with this, Peter.

I've folded the two into the patch below. Hopefully this should apply
to your local tree.

I've given this some testing on HW and I'm not seeing any issues with
opening/closing multiple events, module add/remove, or CPU hotplug.

Thanks,
Mark.

---->8----
>From c0c27a673b23511e9f3f20e5a87cdb6bdd868eaa Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 7 Jan 2015 15:01:54 +0000
Subject: [PATCH] perf: decouple unthrottling and rotating

Currently the adjusments made as part of perf_event_task_tick use the
percpu rotation lists to iterate over any active PMU contexts, but these
are not used by the context rotation code, having been replaced by
separate (per-context) hrtimer callbacks. However, some manipulation of
the rotation lists (i.e. removal of contexts) has remained in
perf_rotate_context. This leads to the following issues:

* Contexts are not always removed from the rotation lists. Removal of
  PMUs which have been placed in rotation lists, but have not been
  removed by a hrtimer callback can result in corruption of the rotation
  lists (when memory backing the context is freed).

  This has been observed to result in hangs when PMU drivers built as
  modules are inserted and removed around the creation of events for
  said PMUs.

* Contexts which do not require rotation may be removed from the
  rotation lists as a result of a hrtimer, and will not be considered by
  the unthrottling code in perf_event_task_tick.

This patch fixes the issue by updating the rotation ist when events are
scheduled in/out, ensuring that each rotation list stays in sync with
the HW state. As each event holds a refcount on the module of its PMU,
this ensures that when a PMU module is unloaded none of its CPU contexts
can be in a rotation list. By maintaining a list of perf_event_contexts
rather than perf_event_cpu_contexts, we don't need separate paths to
handle the cpu and task contexts, which also makes the code a little
simpler.

As the rotation_list variables are not used for rotation, these are
renamed to active_ctx_list, which better matches their current function.
perf_pmu_rotate_{start,stop} are renamed to
perf_pmu_ctx_{activate,deactivate}.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Reported-by: Johannes Jensen <johannes.jensen@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 include/linux/perf_event.h |  2 +-
 kernel/events/core.c       | 81 +++++++++++++++++-----------------------------
 2 files changed, 30 insertions(+), 53 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 449636f5..724d372 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -483,6 +483,7 @@ struct perf_event_context {
 	 */
 	struct mutex			mutex;
 
+	struct list_head		active_ctx_list;
 	struct list_head		pinned_groups;
 	struct list_head		flexible_groups;
 	struct list_head		event_list;
@@ -533,7 +534,6 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct hrtimer			hrtimer;
 	ktime_t				hrtimer_interval;
-	struct list_head		rotation_list;
 	struct pmu			*unique_pmu;
 	struct perf_cgroup		*cgrp;
 };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e2c21fa..a0a8643 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -872,22 +872,32 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
-static DEFINE_PER_CPU(struct list_head, rotation_list);
+static DEFINE_PER_CPU(struct list_head, active_ctx_list);
 
 /*
- * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
- * because they're strictly cpu affine and rotate_start is called with IRQs
- * disabled, while rotate_context is called from IRQ context.
+ * perf_event_ctx_activate(), perf_event_ctx_deactivate(), and
+ * perf_event_task_tick() are fully serialized because they're strictly cpu
+ * affine and perf_event_ctx{activate,deactivate} are called with IRQs
+ * disabled, while perf_event_task_tick is called from IRQ context.
  */
-static void perf_pmu_rotate_start(struct pmu *pmu)
+static void perf_event_ctx_activate(struct perf_event_context *ctx)
 {
-	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-	struct list_head *head = this_cpu_ptr(&rotation_list);
+	struct list_head *head = this_cpu_ptr(&active_ctx_list);
 
 	WARN_ON(!irqs_disabled());
 
-	if (list_empty(&cpuctx->rotation_list))
-		list_add(&cpuctx->rotation_list, head);
+	WARN_ON(!list_empty(&ctx->active_ctx_list));
+
+	list_add(&ctx->active_ctx_list, head);
+}
+
+static void perf_event_ctx_deactivate(struct perf_event_context *ctx)
+{
+	WARN_ON(!irqs_disabled());
+
+	WARN_ON(list_empty(&ctx->active_ctx_list));
+
+	list_del_init(&ctx->active_ctx_list);
 }
 
 static void get_ctx(struct perf_event_context *ctx)
@@ -1232,8 +1242,6 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		ctx->nr_cgroups++;
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
-	if (!ctx->nr_events)
-		perf_pmu_rotate_start(ctx->pmu);
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
@@ -1557,7 +1565,8 @@ event_sched_out(struct perf_event *event,
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu--;
-	ctx->nr_active--;
+	if (!--ctx->nr_active)
+		perf_event_ctx_deactivate(ctx);
 	if (event->attr.freq && event->attr.sample_freq)
 		ctx->nr_freq--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
@@ -1881,7 +1890,8 @@ event_sched_in(struct perf_event *event,
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
-	ctx->nr_active++;
+	if (!ctx->nr_active++)
+		perf_event_ctx_activate(ctx);
 	if (event->attr.freq && event->attr.sample_freq)
 		ctx->nr_freq++;
 
@@ -2794,12 +2804,6 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);
-
-	/*
-	 * Since these rotations are per-cpu, we need to ensure the
-	 * cpu-context we got scheduled on is actually rotating.
-	 */
-	perf_pmu_rotate_start(ctx->pmu);
 }
 
 /*
@@ -3028,25 +3032,18 @@ static void rotate_ctx(struct perf_event_context *ctx)
 		list_rotate_left(&ctx->flexible_groups);
 }
 
-/*
- * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
- * because they're strictly cpu affine and rotate_start is called with IRQs
- * disabled, while rotate_context is called from IRQ context.
- */
 static int perf_rotate_context(struct perf_cpu_context *cpuctx)
 {
 	struct perf_event_context *ctx = NULL;
-	int rotate = 0, remove = 1;
+	int rotate = 0;
 
 	if (cpuctx->ctx.nr_events) {
-		remove = 0;
 		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
 			rotate = 1;
 	}
 
 	ctx = cpuctx->task_ctx;
 	if (ctx && ctx->nr_events) {
-		remove = 0;
 		if (ctx->nr_events != ctx->nr_active)
 			rotate = 1;
 	}
@@ -3070,8 +3067,6 @@ static int perf_rotate_context(struct perf_cpu_context *cpuctx)
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 done:
-	if (remove)
-		list_del_init(&cpuctx->rotation_list);
 
 	return rotate;
 }
@@ -3089,9 +3084,8 @@ bool perf_event_can_stop_tick(void)
 
 void perf_event_task_tick(void)
 {
-	struct list_head *head = this_cpu_ptr(&rotation_list);
-	struct perf_cpu_context *cpuctx, *tmp;
-	struct perf_event_context *ctx;
+	struct list_head *head = this_cpu_ptr(&active_ctx_list);
+	struct perf_event_context *ctx, *tmp;
 	int throttled;
 
 	WARN_ON(!irqs_disabled());
@@ -3099,14 +3093,8 @@ void perf_event_task_tick(void)
 	__this_cpu_inc(perf_throttled_seq);
 	throttled = __this_cpu_xchg(perf_throttled_count, 0);
 
-	list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
-		ctx = &cpuctx->ctx;
+	list_for_each_entry_safe(ctx, tmp, head, active_ctx_list)
 		perf_adjust_freq_unthr_context(ctx, throttled);
-
-		ctx = cpuctx->task_ctx;
-		if (ctx)
-			perf_adjust_freq_unthr_context(ctx, throttled);
-	}
 }
 
 static int event_enable_on_exec(struct perf_event *event,
@@ -3265,6 +3253,7 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
 {
 	raw_spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
+	INIT_LIST_HEAD(&ctx->active_ctx_list);
 	INIT_LIST_HEAD(&ctx->pinned_groups);
 	INIT_LIST_HEAD(&ctx->flexible_groups);
 	INIT_LIST_HEAD(&ctx->event_list);
@@ -6976,7 +6965,6 @@ skip_type:
 
 		__perf_cpu_hrtimer_init(cpuctx, cpu);
 
-		INIT_LIST_HEAD(&cpuctx->rotation_list);
 		cpuctx->unique_pmu = pmu;
 	}
 
@@ -8378,7 +8366,7 @@ static void __init perf_event_init_all_cpus(void)
 	for_each_possible_cpu(cpu) {
 		swhash = &per_cpu(swevent_htable, cpu);
 		mutex_init(&swhash->hlist_mutex);
-		INIT_LIST_HEAD(&per_cpu(rotation_list, cpu));
+		INIT_LIST_HEAD(&per_cpu(active_ctx_list, cpu));
 	}
 }
 
@@ -8399,22 +8387,11 @@ static void perf_event_init_cpu(int cpu)
 }
 
 #if defined CONFIG_HOTPLUG_CPU || defined CONFIG_KEXEC
-static void perf_pmu_rotate_stop(struct pmu *pmu)
-{
-	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-
-	WARN_ON(!irqs_disabled());
-
-	list_del_init(&cpuctx->rotation_list);
-}
-
 static void __perf_event_exit_context(void *__info)
 {
 	struct remove_event re = { .detach_group = true };
 	struct perf_event_context *ctx = __info;
 
-	perf_pmu_rotate_stop(ctx->pmu);
-
 	rcu_read_lock();
 	list_for_each_entry_rcu(re.event, &ctx->event_list, event_entry)
 		__perf_remove_from_context(&re);
-- 
1.9.1

