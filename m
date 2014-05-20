Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaETJ3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:29:34 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53652 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaETJ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:29:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140520090258.GR2485@laptop.programming.kicks-ass.net>
References: <20140520090258.GR2485@laptop.programming.kicks-ass.net>
Date: Tue, 20 May 2014 11:29:31 +0200
Message-ID: <CABPqkBRQWiP9yER9hmtYurtqWbqAPfDA=6=z0_Da60vxXDt6Zg@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix mux_interval hrtimer wreckage
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:02 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Subject: perf: Fix mux_interval hrtimer wreckage
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue May 20 10:09:32 CEST 2014
>
> Thomas stumbled over the hrtimer_forward_now() in
> perf_event_mux_interval_ms_store() and noticed its broken-ness.
>
> You cannot just change the expiry time of an active timer, it will
> destroy the red-black tree order and cause havoc.
>
> Change it to (re)start the timer instead, (re)starting a timer will
> dequeue and enqueue a timer and therefore preserve rb-tree order.
>
> Since we cannot enqueue remotely, wrap the thing in
> cpu_function_call(), this however mandates that we restrict ourselves
> to online cpus. Also serialize the entire setting so we don't get
> multiple concurrent threads trying to update to different values.
>
> Also fix a problem in perf_mux_hrtimer_restart(), checking against
> hrtimer_active() can actually loose us the timer when timer->state ==
> HRTIMER_STATE_CALLBACK and the callback has already decided NORESTART.
>
> Furthermore it doesn't make any sense to test
> hrtimer_callback_running() when we already tested hrtimer_active(),
> but with the above change, we explicitly must call it when
> callback_running.
>
> Lastly, rename a few functions:
>
>   s/perf_cpu_hrtimer_/perf_mux_hrtimer_/ -- because I could not find
>                                             the mux timer function
>
>   s/\<hr\>/timer/ -- because that's the normal way of calling things.
>
Ok, thanks for fixing all of this.

> Fixes: 62b856397927 ("perf: Add sysfs entry to adjust multiplexing interval per PMU")
> Cc: Stephane Eranian <eranian@google.com>
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-ife5kqgnt7mviatc9fakz8wk@git.kernel.org
> ---
>  kernel/events/core.c |   67 ++++++++++++++++++++++++++++-----------------------
>  1 file changed, 38 insertions(+), 29 deletions(-)
>
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -45,9 +45,11 @@
>
>  #include <asm/irq_regs.h>
>
> +typedef int (*remote_function_f)(void *);
> +
>  struct remote_function_call {
>         struct task_struct      *p;
> -       int                     (*func)(void *info);
> +       remote_function_f       func;
>         void                    *info;
>         int                     ret;
>  };
> @@ -80,7 +82,7 @@ static void remote_function(void *data)
>   *         -EAGAIN - when the process moved away
>   */
>  static int
> -task_function_call(struct task_struct *p, int (*func) (void *info), void *info)
> +task_function_call(struct task_struct *p, remote_function_f func, void *info)
>  {
>         struct remote_function_call data = {
>                 .p      = p,
> @@ -104,7 +106,7 @@ task_function_call(struct task_struct *p
>   *
>   * returns: @func return value or -ENXIO when the cpu is offline
>   */
> -static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
> +static int cpu_function_call(int cpu, remote_function_f func, void *info)
>  {
>         struct remote_function_call data = {
>                 .p      = NULL,
> @@ -759,7 +761,7 @@ perf_cgroup_mark_enabled(struct perf_eve
>  /*
>   * function must be called with interrupts disbled
>   */
> -static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer *hr)
> +static enum hrtimer_restart perf_mux_hrtimer_handler(struct hrtimer *hr)
>  {
>         struct perf_cpu_context *cpuctx;
>         enum hrtimer_restart ret = HRTIMER_NORESTART;
> @@ -783,7 +785,7 @@ static enum hrtimer_restart perf_cpu_hrt
>  }
>
>  /* CPU is going down */
> -void perf_cpu_hrtimer_cancel(int cpu)
> +void perf_mux_hrtimer_cancel(int cpu)
>  {
>         struct perf_cpu_context *cpuctx;
>         struct pmu *pmu;
> @@ -810,11 +812,11 @@ void perf_cpu_hrtimer_cancel(int cpu)
>         local_irq_restore(flags);
>  }
>
> -static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
> +static void __perf_mux_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
>  {
> -       struct hrtimer *hr = &cpuctx->hrtimer;
> +       struct hrtimer *timer = &cpuctx->hrtimer;
>         struct pmu *pmu = cpuctx->ctx.pmu;
> -       int timer;
> +       u64 interval;
>
>         /* no multiplexing needed for SW PMU */
>         if (pmu->task_ctx_nr == perf_sw_context)
> @@ -824,31 +826,32 @@ static void __perf_cpu_hrtimer_init(stru
>          * check default is sane, if not set then force to
>          * default interval (1/tick)
>          */
> -       timer = pmu->hrtimer_interval_ms;
> -       if (timer < 1)
> -               timer = pmu->hrtimer_interval_ms = PERF_CPU_HRTIMER;
> +       interval = pmu->hrtimer_interval_ms;
> +       if (interval < 1)
> +               interval = pmu->hrtimer_interval_ms = PERF_CPU_HRTIMER;
>
> -       cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
> +       cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * interval);
>
> -       hrtimer_init(hr, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
> -       hr->function = perf_cpu_hrtimer_handler;
> +       hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
> +       timer->function = perf_mux_hrtimer_handler;
>  }
>
> -static void perf_cpu_hrtimer_restart(struct perf_cpu_context *cpuctx)
> +static int perf_mux_hrtimer_restart(struct perf_cpu_context *cpuctx)
>  {
> -       struct hrtimer *hr = &cpuctx->hrtimer;
> +       struct hrtimer *timer = &cpuctx->hrtimer;
>         struct pmu *pmu = cpuctx->ctx.pmu;
>
>         /* not for SW PMU */
>         if (pmu->task_ctx_nr == perf_sw_context)
> -               return;
> +               return 0;
>
> -       if (hrtimer_active(hr))
> -               return;
> +       if (hrtimer_is_queued(timer))
> +               return 0;
>
> -       if (!hrtimer_callback_running(hr))
> -               __hrtimer_start_range_ns(hr, cpuctx->hrtimer_interval,
> -                                        0, HRTIMER_MODE_REL_PINNED, 0);
> +       __hrtimer_start_range_ns(timer, cpuctx->hrtimer_interval,
> +                       0, HRTIMER_MODE_REL_PINNED, 0);
> +
> +       return 0;
>  }
>
>  void perf_pmu_disable(struct pmu *pmu)
> @@ -1746,7 +1749,7 @@ group_sched_in(struct perf_event *group_
>
>         if (event_sched_in(group_event, cpuctx, ctx)) {
>                 pmu->cancel_txn(pmu);
> -               perf_cpu_hrtimer_restart(cpuctx);
> +               perf_mux_hrtimer_restart(cpuctx);
>                 return -EAGAIN;
>         }
>
> @@ -1793,7 +1796,7 @@ group_sched_in(struct perf_event *group_
>
>         pmu->cancel_txn(pmu);
>
> -       perf_cpu_hrtimer_restart(cpuctx);
> +       perf_mux_hrtimer_restart(cpuctx);
>
>         return -EAGAIN;
>  }
> @@ -2061,7 +2064,7 @@ static int __perf_event_enable(void *inf
>                  */
>                 if (leader != event) {
>                         group_sched_out(leader, cpuctx, ctx);
> -                       perf_cpu_hrtimer_restart(cpuctx);
> +                       perf_mux_hrtimer_restart(cpuctx);
>                 }
>                 if (leader->attr.pinned) {
>                         update_group_times(leader);
> @@ -6396,6 +6399,8 @@ perf_event_mux_interval_ms_show(struct d
>         return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->hrtimer_interval_ms);
>  }
>
> +static DEFINE_MUTEX(mux_interval_mutex);
> +
>  static ssize_t
>  perf_event_mux_interval_ms_store(struct device *dev,
>                                  struct device_attribute *attr,
> @@ -6415,17 +6420,21 @@ perf_event_mux_interval_ms_store(struct
>         if (timer == pmu->hrtimer_interval_ms)
>                 return count;
>
> +       mutex_lock(&mux_interval_mutex);
>         pmu->hrtimer_interval_ms = timer;
>
>         /* update all cpuctx for this PMU */
> -       for_each_possible_cpu(cpu) {
> +       get_online_cpus();
> +       for_each_online_cpu(cpu) {
>                 struct perf_cpu_context *cpuctx;
>                 cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
>                 cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
>
> -               if (hrtimer_active(&cpuctx->hrtimer))
> -                       hrtimer_forward_now(&cpuctx->hrtimer, cpuctx->hrtimer_interval);
> +               cpu_function_call(cpu,
> +                       (remote_function_f)perf_mux_hrtimer_restart, cpuctx);
>         }
> +       put_online_cpus();
> +       mutex_unlock(&mux_interval_mutex);
>
>         return count;
>  }
> @@ -6531,7 +6540,7 @@ int perf_pmu_register(struct pmu *pmu, c
>                 cpuctx->ctx.type = cpu_context;
>                 cpuctx->ctx.pmu = pmu;
>
> -               __perf_cpu_hrtimer_init(cpuctx, cpu);
> +               __perf_mux_hrtimer_init(cpuctx, cpu);
>
>                 INIT_LIST_HEAD(&cpuctx->rotation_list);
>                 cpuctx->unique_pmu = pmu;
