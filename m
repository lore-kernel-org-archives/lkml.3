Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbbAZSqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:46:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43466 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbbAZSqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:46:20 -0500
Date: Mon, 26 Jan 2015 18:45:54 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [perf] WARNING: CPU: 0 PID: 1457 at kernel/events/core.c:890
 add_event_to_ctx()
Message-ID: <20150126184554.GM23313@leverpostej>
References: <20150125043428.GA6109@wfg-t540p.sh.intel.com>
 <20150125155633.GA22257@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125155633.GA22257@leverpostej>
Thread-Topic: [perf] WARNING: CPU: 0 PID: 1457 at kernel/events/core.c:890
 add_event_to_ctx()
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 03:56:33PM +0000, Mark Rutland wrote:
> On Sun, Jan 25, 2015 at 04:34:28AM +0000, Fengguang Wu wrote:
> > Greetings,
> 
> Hi Fengguang,
> 
> Thanks very much for the report.
> 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git perf/core
> > 
> > commit d26bb7f73a2881f2412c340a27438b185f0cc3dc
> > Author:     Mark Rutland <mark.rutland@arm.com>
> > AuthorDate: Wed Jan 7 15:01:54 2015 +0000
> > Commit:     Peter Zijlstra <peterz@infradead.org>
> > CommitDate: Fri Jan 23 15:17:56 2015 +0100
> > 
> >     perf: decouple unthrottling and rotating
> 
> [...]
> 
> What seems to be happening is:
> 
> * An event is created in the context of task A on CPU0. As the task's hw
>   context is empty of events, we call perf_pmu_ctx_activate. This adds
>   the cpuctx of the relevant HW PMU to the active_ctx_list. Note that we
>   checked the task's ctx for emptiness, then added the PMU's hw context.
> 
> * An event is created (as a result of a clone()) in the context of task
>   B on CPU0, and we do the same thing, finding the ctx empty of events
>   we add the HW PMU's cpuctx to the active_ctx_list. As it's already in
>   there, the WARN_ON(!list_empty(&cpuctx->active_ctx_list)) explodes.
> 
> So I guess what we actually want to do is to turn the active_ctx list
> into a list of perf_event_contexts rather than perf_event_cpu_contexts,
> and add/remove from the list when a context is scheduled in/out (or
> updated empty<->nonempty). That way we remove chances for erroneous
> add/remove, and we don't need to treat task and CPU contexts separately
> in perf_event_task_tick.
> 
> I managed to get the reproducer running on a box at home, so I'll spin a
> potential fix against that for a while, and send that out if I don't see
> explosions.

The below patch is a fix up to the broken patch above. I've given it
some testing with Fengguang's reproducer and some custom tests, and as
far as I can tell everything is working as expected.

With Fengguang's reproducer I see some failures in netlink, but I
believe that's an unrelated issue that trinity is tickling.

Peter, does the below patch look OK to you?

Thanks,
Mark.

---->8----
>From c88d36594f956666ea1936abde7a05414bf56032 Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Mon, 26 Jan 2015 18:01:41 +0000
Subject: [PATCH] Perf: fix broken rotation/unthrolling fix

Commit d26bb7f73a2881f2 ("perf: decouple unthrottling and rotating")
bodged its attempted cleanup of the rotation_list usage. The PMU cpu
contexts were added to the active_ctx_list whenever an event was added
to any context, and hence could be added repeatedly, corrupting the list.

Additionally, as contexts were added to the active_ctx_list whevener the
first event was added to them in list_add_event, they could be accounted
for on the wrong CPU (if they were not active at the time). Thus a
context could be accounted as active on one CPU while it ran on another.

This patch fixes the issue by updating the active_ctx_list when events
are scheduled in/out, ensuring that the active_ctx_list stays in sync
with the HW state. By maintaining a list of perf_event_contexts rather
than perf_event_cpu_contexts, we don't need separate paths to handle the
cpu and task contexts, which makes the code a little simpler.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
---
 include/linux/perf_event.h |  2 +-
 kernel/events/core.c       | 51 ++++++++++++++++------------------------------
 2 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b21e2a1..4eb5f9c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -489,6 +489,7 @@ struct perf_event_context {
 	 */
 	struct mutex			mutex;
 
+	struct list_head		active_ctx_list;
 	struct list_head		pinned_groups;
 	struct list_head		flexible_groups;
 	struct list_head		event_list;
@@ -539,7 +540,6 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct hrtimer			hrtimer;
 	ktime_t				hrtimer_interval;
-	struct list_head		active_ctx_list;
 	struct pmu			*unique_pmu;
 	struct perf_cgroup		*cgrp;
 };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1d02140..05a8da5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -875,30 +875,29 @@ void perf_pmu_enable(struct pmu *pmu)
 static DEFINE_PER_CPU(struct list_head, active_ctx_list);
 
 /*
- * perf_pmu_ctx_activate(), perf_pmu_ctx_deactivate(), and
- * perf_even_task_tick() are fully serialized because they're strictly cpu
- * affine and perf_pmu_ctx{activate,deactivate} are called with IRQs disabled,
- * while perf_event_task_tick is called from IRQ context.
+ * perf_event_ctx_activate(), perf_event_ctx_deactivate(), and
+ * perf_event_task_tick() are fully serialized because they're strictly cpu
+ * affine and perf_event_ctx{activate,deactivate} are called with IRQs
+ * disabled, while perf_event_task_tick is called from IRQ context.
  */
-static void perf_pmu_ctx_activate(struct pmu *pmu)
+static void perf_event_ctx_activate(struct perf_event_context *ctx)
 {
-	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 	struct list_head *head = this_cpu_ptr(&active_ctx_list);
 
 	WARN_ON(!irqs_disabled());
 
-	WARN_ON(!list_empty(&cpuctx->active_ctx_list));
+	WARN_ON(!list_empty(&ctx->active_ctx_list));
 
-	list_add(&cpuctx->active_ctx_list, head);
+	list_add(&ctx->active_ctx_list, head);
 }
 
-static void perf_pmu_ctx_deactivate(struct pmu *pmu)
+static void perf_event_ctx_deactivate(struct perf_event_context *ctx)
 {
-	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-
 	WARN_ON(!irqs_disabled());
 
-	list_del_init(&cpuctx->active_ctx_list);
+	WARN_ON(list_empty(&ctx->active_ctx_list));
+
+	list_del_init(&ctx->active_ctx_list);
 }
 
 static void get_ctx(struct perf_event_context *ctx)
@@ -1243,8 +1242,6 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		ctx->nr_cgroups++;
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
-	if (!ctx->nr_events)
-		perf_pmu_ctx_activate(ctx->pmu);
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
@@ -1415,8 +1412,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 		ctx->nr_stat--;
 
 	list_del_rcu(&event->event_entry);
-	if (!ctx->nr_events)
-		perf_pmu_ctx_deactivate(ctx->pmu);
 
 	if (event->group_leader == event)
 		list_del_init(&event->group_entry);
@@ -1570,7 +1565,8 @@ event_sched_out(struct perf_event *event,
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu--;
-	ctx->nr_active--;
+	if (!--ctx->nr_active)
+		perf_event_ctx_deactivate(ctx);
 	if (event->attr.freq && event->attr.sample_freq)
 		ctx->nr_freq--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
@@ -1894,7 +1890,8 @@ event_sched_in(struct perf_event *event,
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
-	ctx->nr_active++;
+	if (!ctx->nr_active++)
+		perf_event_ctx_activate(ctx);
 	if (event->attr.freq && event->attr.sample_freq)
 		ctx->nr_freq++;
 
@@ -3035,11 +3032,6 @@ static void rotate_ctx(struct perf_event_context *ctx)
 		list_rotate_left(&ctx->flexible_groups);
 }
 
-/*
- * perf_pmu_ctx_activate() and perf_rotate_context() are fully serialized
- * because they're strictly cpu affine and rotate_start is called with IRQs
- * disabled, while rotate_context is called from IRQ context.
- */
 static int perf_rotate_context(struct perf_cpu_context *cpuctx)
 {
 	struct perf_event_context *ctx = NULL;
@@ -3093,8 +3085,7 @@ bool perf_event_can_stop_tick(void)
 void perf_event_task_tick(void)
 {
 	struct list_head *head = this_cpu_ptr(&active_ctx_list);
-	struct perf_cpu_context *cpuctx, *tmp;
-	struct perf_event_context *ctx;
+	struct perf_event_context *ctx, *tmp;
 	int throttled;
 
 	WARN_ON(!irqs_disabled());
@@ -3102,14 +3093,8 @@ void perf_event_task_tick(void)
 	__this_cpu_inc(perf_throttled_seq);
 	throttled = __this_cpu_xchg(perf_throttled_count, 0);
 
-	list_for_each_entry_safe(cpuctx, tmp, head, active_ctx_list) {
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
@@ -3268,6 +3253,7 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
 {
 	raw_spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
+	INIT_LIST_HEAD(&ctx->active_ctx_list);
 	INIT_LIST_HEAD(&ctx->pinned_groups);
 	INIT_LIST_HEAD(&ctx->flexible_groups);
 	INIT_LIST_HEAD(&ctx->event_list);
@@ -6980,7 +6966,6 @@ skip_type:
 
 		__perf_cpu_hrtimer_init(cpuctx, cpu);
 
-		INIT_LIST_HEAD(&cpuctx->active_ctx_list);
 		cpuctx->unique_pmu = pmu;
 	}
 
-- 
1.9.1

