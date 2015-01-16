Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbbAPM1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:27:11 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35912 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbbAPM1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:27:09 -0500
Date: Fri, 16 Jan 2015 12:26:42 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] perf: decouple unthrottling and rotating
Message-ID: <20150116122642.GK21809@leverpostej>
References: <1420642914-22760-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420642914-22760-1-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:01:54PM +0000, Mark Rutland wrote:
> Currently the adjusments made as part of perf_event_task_tick use the
> percpu rotation lists to iterate over any active PMU contexts, but these
> are not used by the context rotation code, having been replaced by
> separate (per-context) hrtimer callbacks. However, some manipulation of
> the rotation lists (i.e. removal of contexts) has remained in
> perf_rotate_context. This leads to the following issues:
> 
> * Contexts are not always removed from the rotation lists. Removal of
>   PMUs which have been placed in rotation lists, but have not been
>   removed by a hrtimer callback can result in corruption of the rotation
>   lists (when memory backing the context is freed).
> 
>   This has been observed to result in hangs when PMU drivers built as
>   modules are inserted and removed around the creation of events for
>   said PMUs.
> 
> * Contexts which do not require rotation may be removed from the
>   rotation lists as a result of a hrtimer, and will not be considered by
>   the unthrottling code in perf_event_task_tick.
> 
> This patch solves these issues by moving any and all removal of contexts
> from rotation lists to only occur when the final event is removed from a
> context, mirroring the addition which only occurs when the first event
> is added to a context. The vestigal manipulation of the rotation lists
> is removed from perf_event_rotate_context.
> 
> As the rotation_list variables are not used for rotation, these are
> renamed to active_ctx_list, which better matches their current function.
> perf_pmu_rotate_{start,stop} are renamed to
> perf_pmu_ctx_{activate,deactivate}.

Any comments?

Thanks,
Mark.

> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Reported-by: Johannes Jensen <johannes.jensen@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> ---
>  include/linux/perf_event.h |  2 +-
>  kernel/events/core.c       | 64 ++++++++++++++++++++--------------------------
>  2 files changed, 29 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 486e84c..4ca17f1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -530,7 +530,7 @@ struct perf_cpu_context {
>  	int				exclusive;
>  	struct hrtimer			hrtimer;
>  	ktime_t				hrtimer_interval;
> -	struct list_head		rotation_list;
> +	struct list_head		active_ctx_list;
>  	struct pmu			*unique_pmu;
>  	struct perf_cgroup		*cgrp;
>  };
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4faccf3..ac0b9c8 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -872,22 +872,33 @@ void perf_pmu_enable(struct pmu *pmu)
>  		pmu->pmu_enable(pmu);
>  }
>  
> -static DEFINE_PER_CPU(struct list_head, rotation_list);
> +static DEFINE_PER_CPU(struct list_head, active_ctx_list);
>  
>  /*
> - * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
> - * because they're strictly cpu affine and rotate_start is called with IRQs
> - * disabled, while rotate_context is called from IRQ context.
> + * perf_pmu_ctx_activate(), perf_pmu_ctx_deactivate(), and
> + * perf_even_task_tick() are fully serialized because they're strictly cpu
> + * affine and perf_pmu_ctx{activate,deactiveate} are called with IRQs disabled,
> + * while perf_event_task_tick is called from IRQ context.
>   */
> -static void perf_pmu_rotate_start(struct pmu *pmu)
> +static void perf_pmu_ctx_activate(struct pmu *pmu)
>  {
>  	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> -	struct list_head *head = this_cpu_ptr(&rotation_list);
> +	struct list_head *head = this_cpu_ptr(&active_ctx_list);
>  
>  	WARN_ON(!irqs_disabled());
>  
> -	if (list_empty(&cpuctx->rotation_list))
> -		list_add(&cpuctx->rotation_list, head);
> +	WARN_ON(!list_empty(&cpuctx->active_ctx_list));
> +
> +	list_add(&cpuctx->active_ctx_list, head);
> +}
> +
> +static void perf_pmu_ctx_deactivate(struct pmu *pmu)
> +{
> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> +
> +	WARN_ON(!irqs_disabled());
> +
> +	list_del_init(&cpuctx->active_ctx_list);
>  }
>  
>  static void get_ctx(struct perf_event_context *ctx)
> @@ -1156,7 +1167,7 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
>  
>  	list_add_rcu(&event->event_entry, &ctx->event_list);
>  	if (!ctx->nr_events)
> -		perf_pmu_rotate_start(ctx->pmu);
> +		perf_pmu_ctx_activate(ctx->pmu);
>  	ctx->nr_events++;
>  	if (event->attr.inherit_stat)
>  		ctx->nr_stat++;
> @@ -1324,6 +1335,8 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
>  		ctx->nr_stat--;
>  
>  	list_del_rcu(&event->event_entry);
> +	if (!ctx->nr_events)
> +		perf_pmu_ctx_deactivate(ctx->pmu);
>  
>  	if (event->group_leader == event)
>  		list_del_init(&event->group_entry);
> @@ -2612,12 +2625,6 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
>  
>  	perf_pmu_enable(ctx->pmu);
>  	perf_ctx_unlock(cpuctx, ctx);
> -
> -	/*
> -	 * Since these rotations are per-cpu, we need to ensure the
> -	 * cpu-context we got scheduled on is actually rotating.
> -	 */
> -	perf_pmu_rotate_start(ctx->pmu);
>  }
>  
>  /*
> @@ -2906,24 +2913,22 @@ static void rotate_ctx(struct perf_event_context *ctx)
>  }
>  
>  /*
> - * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
> + * perf_pmu_ctx_activate() and perf_rotate_context() are fully serialized
>   * because they're strictly cpu affine and rotate_start is called with IRQs
>   * disabled, while rotate_context is called from IRQ context.
>   */
>  static int perf_rotate_context(struct perf_cpu_context *cpuctx)
>  {
>  	struct perf_event_context *ctx = NULL;
> -	int rotate = 0, remove = 1;
> +	int rotate = 0;
>  
>  	if (cpuctx->ctx.nr_events) {
> -		remove = 0;
>  		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
>  			rotate = 1;
>  	}
>  
>  	ctx = cpuctx->task_ctx;
>  	if (ctx && ctx->nr_events) {
> -		remove = 0;
>  		if (ctx->nr_events != ctx->nr_active)
>  			rotate = 1;
>  	}
> @@ -2947,8 +2952,6 @@ static int perf_rotate_context(struct perf_cpu_context *cpuctx)
>  	perf_pmu_enable(cpuctx->ctx.pmu);
>  	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>  done:
> -	if (remove)
> -		list_del_init(&cpuctx->rotation_list);
>  
>  	return rotate;
>  }
> @@ -2966,7 +2969,7 @@ bool perf_event_can_stop_tick(void)
>  
>  void perf_event_task_tick(void)
>  {
> -	struct list_head *head = this_cpu_ptr(&rotation_list);
> +	struct list_head *head = this_cpu_ptr(&active_ctx_list);
>  	struct perf_cpu_context *cpuctx, *tmp;
>  	struct perf_event_context *ctx;
>  	int throttled;
> @@ -2976,7 +2979,7 @@ void perf_event_task_tick(void)
>  	__this_cpu_inc(perf_throttled_seq);
>  	throttled = __this_cpu_xchg(perf_throttled_count, 0);
>  
> -	list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
> +	list_for_each_entry_safe(cpuctx, tmp, head, active_ctx_list) {
>  		ctx = &cpuctx->ctx;
>  		perf_adjust_freq_unthr_context(ctx, throttled);
>  
> @@ -6784,7 +6787,7 @@ skip_type:
>  
>  		__perf_cpu_hrtimer_init(cpuctx, cpu);
>  
> -		INIT_LIST_HEAD(&cpuctx->rotation_list);
> +		INIT_LIST_HEAD(&cpuctx->active_ctx_list);
>  		cpuctx->unique_pmu = pmu;
>  	}
>  
> @@ -8133,7 +8136,7 @@ static void __init perf_event_init_all_cpus(void)
>  	for_each_possible_cpu(cpu) {
>  		swhash = &per_cpu(swevent_htable, cpu);
>  		mutex_init(&swhash->hlist_mutex);
> -		INIT_LIST_HEAD(&per_cpu(rotation_list, cpu));
> +		INIT_LIST_HEAD(&per_cpu(active_ctx_list, cpu));
>  	}
>  }
>  
> @@ -8154,22 +8157,11 @@ static void perf_event_init_cpu(int cpu)
>  }
>  
>  #if defined CONFIG_HOTPLUG_CPU || defined CONFIG_KEXEC
> -static void perf_pmu_rotate_stop(struct pmu *pmu)
> -{
> -	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> -
> -	WARN_ON(!irqs_disabled());
> -
> -	list_del_init(&cpuctx->rotation_list);
> -}
> -
>  static void __perf_event_exit_context(void *__info)
>  {
>  	struct remove_event re = { .detach_group = true };
>  	struct perf_event_context *ctx = __info;
>  
> -	perf_pmu_rotate_stop(ctx->pmu);
> -
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(re.event, &ctx->event_list, event_entry)
>  		__perf_remove_from_context(&re);
> -- 
> 1.9.1
> 
