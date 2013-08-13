Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3HMQju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:39:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab3HMQjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:39:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf: Move throtling flag to perf_event_context
Date: Tue, 13 Aug 2013 18:39:12 +0200
Message-Id: <1376411952-16718-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
References: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current throttling code triggers WARN below via following
workload (only hit on AMD machine with 48 CPUs):

  # while [ 1 ]; do perf record perf bench sched messaging; done

  WARNING: at arch/x86/kernel/cpu/perf_event.c:1054 x86_pmu_start+0xc6/0x100()
  SNIP
  Call Trace:
   <IRQ>  [<ffffffff815f62d6>] dump_stack+0x19/0x1b
   [<ffffffff8105f531>] warn_slowpath_common+0x61/0x80
   [<ffffffff8105f60a>] warn_slowpath_null+0x1a/0x20
   [<ffffffff810213a6>] x86_pmu_start+0xc6/0x100
   [<ffffffff81129dd2>] perf_adjust_freq_unthr_context.part.75+0x182/0x1a0
   [<ffffffff8112a058>] perf_event_task_tick+0xc8/0xf0
   [<ffffffff81093221>] scheduler_tick+0xd1/0x140
   [<ffffffff81070176>] update_process_times+0x66/0x80
   [<ffffffff810b9565>] tick_sched_handle.isra.15+0x25/0x60
   [<ffffffff810b95e1>] tick_sched_timer+0x41/0x60
   [<ffffffff81087c24>] __run_hrtimer+0x74/0x1d0
   [<ffffffff810b95a0>] ? tick_sched_handle.isra.15+0x60/0x60
   [<ffffffff81088407>] hrtimer_interrupt+0xf7/0x240
   [<ffffffff81606829>] smp_apic_timer_interrupt+0x69/0x9c
   [<ffffffff8160569d>] apic_timer_interrupt+0x6d/0x80
   <EOI>  [<ffffffff81129f74>] ? __perf_event_task_sched_in+0x184/0x1a0
   [<ffffffff814dd937>] ? kfree_skbmem+0x37/0x90
   [<ffffffff815f2c47>] ? __slab_free+0x1ac/0x30f
   [<ffffffff8118143d>] ? kfree+0xfd/0x130
   [<ffffffff81181622>] kmem_cache_free+0x1b2/0x1d0
   [<ffffffff814dd937>] kfree_skbmem+0x37/0x90
   [<ffffffff814e03c4>] consume_skb+0x34/0x80
   [<ffffffff8158b057>] unix_stream_recvmsg+0x4e7/0x820
   [<ffffffff814d5546>] sock_aio_read.part.7+0x116/0x130
   [<ffffffff8112c10c>] ? __perf_sw_event+0x19c/0x1e0
   [<ffffffff814d5581>] sock_aio_read+0x21/0x30
   [<ffffffff8119a5d0>] do_sync_read+0x80/0xb0
   [<ffffffff8119ac85>] vfs_read+0x145/0x170
   [<ffffffff8119b699>] SyS_read+0x49/0xa0
   [<ffffffff810df516>] ? __audit_syscall_exit+0x1f6/0x2a0
   [<ffffffff81604a19>] system_call_fastpath+0x16/0x1b
  ---[ end trace 622b7e226c4a766a ]---

The reason is race in perf_event_task_tick throttling code.
The race flow (simplified code):

  - perf_throttled_count is per cpu variable and is
    CPU throttling flag, here starting with 0
  - perf_throttled_seq is sequence/domain for allowed
    count of interrupts within the tick, gets increased
    each tick

    on single CPU (CPU bounded event):

      ... workload

    perf_event_task_tick:
    |
    | T0    inc(perf_throttled_seq)
    | T1    throttled = xchg(perf_throttled_count, 0) == 0
     tick gets interrupted:

            ... event gets throttled under new seq ...

      T2    last NMI comes, event is throttled - inc(perf_throttled_count)

     back to tick:
    | perf_adjust_freq_unthr_context:
    |
    | T3    unthrottling is skiped for event (throttled == 0)
    | T4    event is stop and started via freq adjustment
    |
    tick ends

      ... workload
      ... no sample is hit for event ...

    perf_event_task_tick:
    |
    | T5    throttled = xchg(perf_throttled_count, 0) != 0 (from T2)
    | T6    unthrottling is done on event (interrupts == MAX_INTERRUPTS)
    |       event is already started (from T4) -> WARN

Fixing this by:
  - moving the per cpu 'throttle' flag into the event's ctx so the flag
    is context specific and thus not disturbed (changed) by others
  - checking the 'throttled' under pmu disabled code again
  - removing perf_throttled_seq as it's no longer needed
  - keeping perf_throttled_count as perf_event_can_stop_tick flag

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reported-by: Jan Stancek <jstancek@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |  2 +-
 kernel/events/core.c       | 67 +++++++++++++++++++++++++++-------------------
 2 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c43f6ea..d0c04fb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -167,7 +167,6 @@ struct hw_perf_event {
 	u64				sample_period;
 	u64				last_period;
 	local64_t			period_left;
-	u64                             interrupts_seq;
 	u64				interrupts;
 
 	u64				freq_time_stamp;
@@ -494,6 +493,7 @@ struct perf_event_context {
 	int				nr_cgroups;	 /* cgroup evts */
 	int				nr_branch_stack; /* branch_stack evt */
 	struct rcu_head			rcu_head;
+	int * __percpu			throttled;
 };
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e82e700..40d7127 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -886,6 +886,7 @@ static void put_ctx(struct perf_event_context *ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task)
 			put_task_struct(ctx->task);
+		free_percpu(ctx->throttled);
 		kfree_rcu(ctx, rcu_head);
 	}
 }
@@ -2433,6 +2434,13 @@ ctx_sched_in(struct perf_event_context *ctx,
 	/* Then walk through the lower prio flexible groups */
 	if (!(is_active & EVENT_FLEXIBLE) && (event_type & EVENT_FLEXIBLE))
 		ctx_flexible_sched_in(ctx, cpuctx);
+
+	/*
+	 * If we missed the tick before last unscheduling we could
+	 * have some events in throttled state. They get unthrottled
+	 * in event_sched_in and we can clear the flag for context.
+	 */
+	*this_cpu_ptr(ctx->throttled) = 0;
 }
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
@@ -2648,7 +2656,6 @@ do {					\
 }
 
 static DEFINE_PER_CPU(int, perf_throttled_count);
-static DEFINE_PER_CPU(u64, perf_throttled_seq);
 
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count, bool disable)
 {
@@ -2684,9 +2691,9 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count, bo
  * events. At the same time, make sure, having freq events does not change
  * the rate of unthrottling as that would introduce bias.
  */
-static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
-					   int needs_unthr)
+static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx)
 {
+	int *throttled = this_cpu_ptr(ctx->throttled);
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	u64 now, period = TICK_NSEC;
@@ -2697,7 +2704,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 	 * - context have events in frequency mode (needs freq adjust)
 	 * - there are events to unthrottle on this cpu
 	 */
-	if (!(ctx->nr_freq || needs_unthr))
+	if (!(ctx->nr_freq || *throttled))
 		return;
 
 	raw_spin_lock(&ctx->lock);
@@ -2712,7 +2719,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 
 		hwc = &event->hw;
 
-		if (needs_unthr && hwc->interrupts == MAX_INTERRUPTS) {
+		if (*throttled && hwc->interrupts == MAX_INTERRUPTS) {
 			hwc->interrupts = 0;
 			perf_log_throttle(event, 1);
 			event->pmu->start(event, 0);
@@ -2743,6 +2750,8 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		event->pmu->start(event, delta > 0 ? PERF_EF_RELOAD : 0);
 	}
 
+	*throttled = 0;
+
 	perf_pmu_enable(ctx->pmu);
 	raw_spin_unlock(&ctx->lock);
 }
@@ -2824,20 +2833,19 @@ void perf_event_task_tick(void)
 	struct list_head *head = &__get_cpu_var(rotation_list);
 	struct perf_cpu_context *cpuctx, *tmp;
 	struct perf_event_context *ctx;
-	int throttled;
 
 	WARN_ON(!irqs_disabled());
 
-	__this_cpu_inc(perf_throttled_seq);
-	throttled = __this_cpu_xchg(perf_throttled_count, 0);
+	/* perf_event_can_stop_tick global throtlling flag */
+	__this_cpu_write(perf_throttled_count, 0);
 
 	list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
 		ctx = &cpuctx->ctx;
-		perf_adjust_freq_unthr_context(ctx, throttled);
+		perf_adjust_freq_unthr_context(ctx);
 
 		ctx = cpuctx->task_ctx;
 		if (ctx)
-			perf_adjust_freq_unthr_context(ctx, throttled);
+			perf_adjust_freq_unthr_context(ctx);
 	}
 }
 
@@ -2973,7 +2981,7 @@ static u64 perf_event_read(struct perf_event *event)
 /*
  * Initialize the perf_event context in a task_struct:
  */
-static void __perf_event_init_context(struct perf_event_context *ctx)
+static int __perf_event_init_context(struct perf_event_context *ctx)
 {
 	raw_spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
@@ -2981,6 +2989,8 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
 	INIT_LIST_HEAD(&ctx->flexible_groups);
 	INIT_LIST_HEAD(&ctx->event_list);
 	atomic_set(&ctx->refcount, 1);
+	ctx->throttled = alloc_percpu(int);
+	return ctx->throttled ? 0 : -1;
 }
 
 static struct perf_event_context *
@@ -2992,7 +3002,11 @@ alloc_perf_context(struct pmu *pmu, struct task_struct *task)
 	if (!ctx)
 		return NULL;
 
-	__perf_event_init_context(ctx);
+	if (__perf_event_init_context(ctx)) {
+		kfree(ctx);
+		return NULL;
+	}
+
 	if (task) {
 		ctx->task = task;
 		get_task_struct(task);
@@ -5191,7 +5205,6 @@ static int __perf_event_overflow(struct perf_event *event,
 {
 	int events = atomic_read(&event->event_limit);
 	struct hw_perf_event *hwc = &event->hw;
-	u64 seq;
 	int ret = 0;
 
 	/*
@@ -5201,20 +5214,15 @@ static int __perf_event_overflow(struct perf_event *event,
 	if (unlikely(!is_sampling_event(event)))
 		return 0;
 
-	seq = __this_cpu_read(perf_throttled_seq);
-	if (seq != hwc->interrupts_seq) {
-		hwc->interrupts_seq = seq;
-		hwc->interrupts = 1;
-	} else {
-		hwc->interrupts++;
-		if (unlikely(throttle
-			     && hwc->interrupts >= max_samples_per_tick)) {
-			__this_cpu_inc(perf_throttled_count);
-			hwc->interrupts = MAX_INTERRUPTS;
-			perf_log_throttle(event, 0);
-			tick_nohz_full_kick();
-			ret = 1;
-		}
+	hwc->interrupts++;
+	if (unlikely(throttle
+		     && hwc->interrupts >= max_samples_per_tick)) {
+		(*this_cpu_ptr(event->ctx->throttled))++;
+		__this_cpu_inc(perf_throttled_count);
+		hwc->interrupts = MAX_INTERRUPTS;
+		perf_log_throttle(event, 0);
+		tick_nohz_full_kick();
+		ret = 1;
 	}
 
 	if (event->attr.freq) {
@@ -6362,7 +6370,8 @@ skip_type:
 		struct perf_cpu_context *cpuctx;
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
-		__perf_event_init_context(&cpuctx->ctx);
+		if (__perf_event_init_context(&cpuctx->ctx))
+			goto free_context;
 		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
 		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
 		cpuctx->ctx.type = cpu_context;
@@ -6407,6 +6416,8 @@ unlock:
 
 	return ret;
 
+free_context:
+	free_percpu(pmu->pmu_cpu_context);
 free_dev:
 	device_del(pmu->dev);
 	put_device(pmu->dev);
-- 
1.7.11.7

