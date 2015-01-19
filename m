Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbbASOlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:41:06 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38091 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbbASOlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:41:03 -0500
Date: Mon, 19 Jan 2015 14:40:28 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Vince Weaver <vince@deater.net>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: perf fuzzer crash [PATCH] perf: Get group events reference
 before moving the group
Message-ID: <20150119144028.GF21553@leverpostej>
References: <20150116075746.GB2658@krava.brq.redhat.com>
 <20150116104644.GW23965@worktop.programming.kicks-ass.net>
 <20150116141104.GD21958@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116141104.GD21958@worktop.programming.kicks-ass.net>
Thread-Topic: perf fuzzer crash [PATCH] perf: Get group events reference
 before moving the group
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 02:11:04PM +0000, Peter Zijlstra wrote:
> On Fri, Jan 16, 2015 at 11:46:44AM +0100, Peter Zijlstra wrote:
> > Its a bandaid at best :/ The problem is (again) that we changes
> > event->ctx without any kind of serialization.
> >
> > The issue came up before:
> >
> >   https://lkml.org/lkml/2014/9/5/397

In the end neither the CCI or CCN perf drivers migrate events on
hotplug, so ARM is currently safe from the perf_pmu_migrate_context
case, but I see that you fix the move_group handling too.

I had a go at testing this by hacking migration back into the CCI PMU
driver (atop of v3.19-rc5), but I'm seeing lockups after a few minutes
with my original test case (https://lkml.org/lkml/2014/9/1/569 with
PMU_TYPE and PMU_EVENT fixed up).

I unfortunately don't have a suitable x86 box spare to run that on.
Would someone be able to give it a spin on something with an uncore PMU?

I'll go and dig a bit further. I may just be hitting another latent
issue on my board.

Thanks,
Mark.

> >
> > and I've not been able to come up with anything much saner.
>
> A little something like the below is the best I could come up with; I
> know Linus hated it, but I figure we ought to do something to stop
> crashing.
>
>
>
> ---
>  init/Kconfig         |    1 +
>  kernel/events/core.c |  126 ++++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 103 insertions(+), 24 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 9afb971..ebc8522 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1595,6 +1595,7 @@ config PERF_EVENTS
>         depends on HAVE_PERF_EVENTS
>         select ANON_INODES
>         select IRQ_WORK
> +       select PERCPU_RWSEM
>         help
>           Enable kernel support for various performance events provided
>           by software and hardware.
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index c10124b..fb3971d 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -42,6 +42,7 @@
>  #include <linux/module.h>
>  #include <linux/mman.h>
>  #include <linux/compat.h>
> +#include <linux/percpu-rwsem.h>
>
>  #include "internal.h"
>
> @@ -122,6 +123,42 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
>         return data.ret;
>  }
>
> +/*
> + * Required to migrate events between contexts.
> + *
> + * Migrating events between contexts is rather tricky; there is no real
> + * serialization around the perf_event::ctx pointer.
> + *
> + * So what we do is hold this rwsem over the remove_from_context and
> + * install_in_context. The remove_from_context ensures the event is inactive
> + * and will not be used from IRQ/NMI context anymore, and the remaining
> + * sites can acquire the rwsem read side.
> + */
> +static struct percpu_rw_semaphore perf_rwsem;
> +
> +static inline struct perf_event_context *perf_event_ctx(struct perf_event *event)
> +{
> +#ifdef CONFIG_LOCKDEP
> +       /*
> +        * Assert the locking rules outlined above; in order to dereference
> +        * event->ctx we must either be attached to the context or hold
> +        * perf_rwsem.
> +        *
> +        * XXX not usable from IPIs because the lockdep held lock context
> +        * will be wrong; maybe add trylock variants to the percpu_rw_semaphore
> +        */
> +       WARN_ON_ONCE(!(event->attach_state & PERF_ATTACH_CONTEXT) ||
> +                    (debug_locks && !lockdep_is_held(&perf_rwsem.rw_sem)));
> +#endif
> +
> +       return event->ctx;
> +}
> +
> +static inline struct perf_event_context *__perf_event_ctx(struct perf_event *event)
> +{
> +       return event->ctx;
> +}
> +
>  #define EVENT_OWNER_KERNEL ((void *) -1)
>
>  static bool is_kernel_event(struct perf_event *event)
> @@ -380,7 +417,7 @@ perf_cgroup_from_task(struct task_struct *task)
>  static inline bool
>  perf_cgroup_match(struct perf_event *event)
>  {
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx = __perf_event_ctx(event);
>         struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
>
>         /* @event doesn't care about cgroup */
> @@ -1054,7 +1091,7 @@ static void update_context_time(struct perf_event_context *ctx)
>
>  static u64 perf_event_time(struct perf_event *event)
>  {
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx = __perf_event_ctx(event);
>
>         if (is_cgroup_event(event))
>                 return perf_cgroup_event_time(event);
> @@ -1068,7 +1105,7 @@ static u64 perf_event_time(struct perf_event *event)
>   */
>  static void update_event_times(struct perf_event *event)
>  {
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx = __perf_event_ctx(event);
>         u64 run_end;
>
>         if (event->state < PERF_EVENT_STATE_INACTIVE ||
> @@ -1518,7 +1555,7 @@ static int __perf_remove_from_context(void *info)
>  {
>         struct remove_event *re = info;
>         struct perf_event *event = re->event;
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx = __perf_event_ctx(event);
>         struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
>
>         raw_spin_lock(&ctx->lock);
> @@ -1551,7 +1588,7 @@ static int __perf_remove_from_context(void *info)
>   */
>  static void perf_remove_from_context(struct perf_event *event, bool detach_group)
>  {
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx = perf_event_ctx(event);
>         struct task_struct *task = ctx->task;
>         struct remove_event re = {
>                 .event = event,
> @@ -1606,7 +1643,7 @@ retry:
>  int __perf_event_disable(void *info)
>  {
>         struct perf_event *event = info;
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx = __perf_event_ctx(event);
>         struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
>
>         /*
> @@ -1656,20 +1693,24 @@ int __perf_event_disable(void *info)
>   */
>  void perf_event_disable(struct perf_event *event)
>  {
> -       struct perf_event_context *ctx = event->ctx;
> -       struct task_struct *task = ctx->task;
> +       struct perf_event_context *ctx;
> +       struct task_struct *task;
> +
> +       percpu_down_read(&perf_rwsem);
> +       ctx = perf_event_ctx(event);
> +       task = ctx->task;
>
>         if (!task) {
>                 /*
>                  * Disable the event on the cpu that it's on
>                  */
>                 cpu_function_call(event->cpu, __perf_event_disable, event);
> -               return;
> +               goto unlock;
>         }
>
>  retry:
>         if (!task_function_call(task, __perf_event_disable, event))
> -               return;
> +               goto unlock;
>
>         raw_spin_lock_irq(&ctx->lock);
>         /*
> @@ -1694,6 +1735,8 @@ retry:
>                 event->state = PERF_EVENT_STATE_OFF;
>         }
>         raw_spin_unlock_irq(&ctx->lock);
> +unlock:
> +       percpu_up_read(&perf_rwsem);
>  }
>  EXPORT_SYMBOL_GPL(perf_event_disable);
>
> @@ -1937,7 +1980,7 @@ static void perf_event_sched_in(struct perf_cpu_context *cpuctx,
>  static int  __perf_install_in_context(void *info)
>  {
>         struct perf_event *event = info;
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx = __perf_event_ctx(event);
>         struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
>         struct perf_event_context *task_ctx = cpuctx->task_ctx;
>         struct task_struct *task = current;
> @@ -2076,7 +2119,7 @@ static void __perf_event_mark_enabled(struct perf_event *event)
>  static int __perf_event_enable(void *info)
>  {
>         struct perf_event *event = info;
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx = __perf_event_ctx(event);
>         struct perf_event *leader = event->group_leader;
>         struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
>         int err;
> @@ -2160,15 +2203,19 @@ unlock:
>   */
>  void perf_event_enable(struct perf_event *event)
>  {
> -       struct perf_event_context *ctx = event->ctx;
> -       struct task_struct *task = ctx->task;
> +       struct perf_event_context *ctx;
> +       struct task_struct *task;
> +
> +       percpu_down_read(&perf_rwsem);
> +       ctx = perf_event_ctx(event);
> +       task = ctx->task;
>
>         if (!task) {
>                 /*
>                  * Enable the event on the cpu that it's on
>                  */
>                 cpu_function_call(event->cpu, __perf_event_enable, event);
> -               return;
> +               goto unlock;
>         }
>
>         raw_spin_lock_irq(&ctx->lock);
> @@ -2194,7 +2241,7 @@ retry:
>         raw_spin_unlock_irq(&ctx->lock);
>
>         if (!task_function_call(task, __perf_event_enable, event))
> -               return;
> +               goto unlock;
>
>         raw_spin_lock_irq(&ctx->lock);
>
> @@ -2213,6 +2260,8 @@ retry:
>
>  out:
>         raw_spin_unlock_irq(&ctx->lock);
> +unlock:
> +       percpu_up_read(&perf_rwsem);
>  }
>  EXPORT_SYMBOL_GPL(perf_event_enable);
>
> @@ -3076,7 +3125,7 @@ void perf_event_exec(void)
>  static void __perf_event_read(void *info)
>  {
>         struct perf_event *event = info;
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx = __perf_event_ctx(event);
>         struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
>
>         /*
> @@ -3115,7 +3164,7 @@ static u64 perf_event_read(struct perf_event *event)
>                 smp_call_function_single(event->oncpu,
>                                          __perf_event_read, event, 1);
>         } else if (event->state == PERF_EVENT_STATE_INACTIVE) {
> -               struct perf_event_context *ctx = event->ctx;
> +               struct perf_event_context *ctx = perf_event_ctx(event);
>                 unsigned long flags;
>
>                 raw_spin_lock_irqsave(&ctx->lock, flags);
> @@ -3440,7 +3489,7 @@ static void perf_remove_from_owner(struct perf_event *event)
>   */
>  static void put_event(struct perf_event *event)
>  {
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx;
>
>         if (!atomic_long_dec_and_test(&event->refcount))
>                 return;
> @@ -3448,6 +3497,8 @@ static void put_event(struct perf_event *event)
>         if (!is_kernel_event(event))
>                 perf_remove_from_owner(event);
>
> +       percpu_down_read(&perf_rwsem);
> +       ctx = perf_event_ctx(event);
>         WARN_ON_ONCE(ctx->parent_ctx);
>         /*
>          * There are two ways this annotation is useful:
> @@ -3464,6 +3515,7 @@ static void put_event(struct perf_event *event)
>         mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
>         perf_remove_from_context(event, true);
>         mutex_unlock(&ctx->mutex);
> +       percpu_up_read(&perf_rwsem);
>
>         _free_event(event);
>  }
> @@ -3647,11 +3699,13 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
>         if (count < event->read_size)
>                 return -ENOSPC;
>
> -       WARN_ON_ONCE(event->ctx->parent_ctx);
> +       percpu_down_read(&perf_rwsem);
> +       WARN_ON_ONCE(perf_event_ctx(event)->parent_ctx);
>         if (read_format & PERF_FORMAT_GROUP)
>                 ret = perf_event_read_group(event, read_format, buf);
>         else
>                 ret = perf_event_read_one(event, read_format, buf);
> +       percpu_up_read(&perf_rwsem);
>
>         return ret;
>  }
> @@ -3689,9 +3743,11 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
>
>  static void perf_event_reset(struct perf_event *event)
>  {
> +       percpu_down_read(&perf_rwsem);
>         (void)perf_event_read(event);
>         local64_set(&event->count, 0);
>         perf_event_update_userpage(event);
> +       percpu_up_read(&perf_rwsem);
>  }
>
>  /*
> @@ -3705,7 +3761,7 @@ static void perf_event_for_each_child(struct perf_event *event,
>  {
>         struct perf_event *child;
>
> -       WARN_ON_ONCE(event->ctx->parent_ctx);
> +       WARN_ON_ONCE(__perf_event_ctx(event)->parent_ctx);
>         mutex_lock(&event->child_mutex);
>         func(event);
>         list_for_each_entry(child, &event->child_list, child_list)
> @@ -3716,6 +3772,14 @@ static void perf_event_for_each_child(struct perf_event *event,
>  static void perf_event_for_each(struct perf_event *event,
>                                   void (*func)(struct perf_event *))
>  {
> +       /*
> +        * XXX broken
> +        *
> +        * lock inversion and recursion issues; ctx->mutex must nest inside
> +        * perf_rwsem, but func() will take perf_rwsem again.
> +        *
> +        * Cure with ugly.
> +        */
>         struct perf_event_context *ctx = event->ctx;
>         struct perf_event *sibling;
>
> @@ -3731,7 +3795,7 @@ static void perf_event_for_each(struct perf_event *event,
>
>  static int perf_event_period(struct perf_event *event, u64 __user *arg)
>  {
> -       struct perf_event_context *ctx = event->ctx;
> +       struct perf_event_context *ctx;
>         int ret = 0, active;
>         u64 value;
>
> @@ -3744,6 +3808,8 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
>         if (!value)
>                 return -EINVAL;
>
> +       percpu_down_read(&perf_rwsem);
> +       ctx = perf_event_ctx(event);
>         raw_spin_lock_irq(&ctx->lock);
>         if (event->attr.freq) {
>                 if (value > sysctl_perf_event_sample_rate) {
> @@ -3772,6 +3838,7 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
>
>  unlock:
>         raw_spin_unlock_irq(&ctx->lock);
> +       percpu_up_read(&perf_rwsem);
>
>         return ret;
>  }
> @@ -7229,11 +7296,13 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
>         if (output_event->cpu != event->cpu)
>                 goto out;
>
> +       percpu_down_read(&perf_rwsem);
>         /*
>          * If its not a per-cpu rb, it must be the same task.
>          */
> -       if (output_event->cpu == -1 && output_event->ctx != event->ctx)
> -               goto out;
> +       if (output_event->cpu == -1 &&
> +           perf_event_ctx(output_event) != perf_event_ctx(event))
> +               goto unlock_rwsem;
>
>  set:
>         mutex_lock(&event->mmap_mutex);
> @@ -7253,6 +7322,8 @@ set:
>         ret = 0;
>  unlock:
>         mutex_unlock(&event->mmap_mutex);
> +unlock_rwsem:
> +       percpu_up_read(&perf_rwsem);
>
>  out:
>         return ret;
> @@ -7461,6 +7532,7 @@ SYSCALL_DEFINE5(perf_event_open,
>         if (move_group) {
>                 struct perf_event_context *gctx = group_leader->ctx;
>
> +               percpu_down_write(&perf_rwsem);
>                 mutex_lock(&gctx->mutex);
>                 perf_remove_from_context(group_leader, false);
>
> @@ -7498,6 +7570,9 @@ SYSCALL_DEFINE5(perf_event_open,
>         perf_unpin_context(ctx);
>         mutex_unlock(&ctx->mutex);
>
> +       if (move_group)
> +               percpu_up_write(&perf_rwsem);
> +
>         put_online_cpus();
>
>         event->owner = current;
> @@ -7600,6 +7675,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
>         struct perf_event *event, *tmp;
>         LIST_HEAD(events);
>
> +       percpu_down_write(&perf_rwsem);
>         src_ctx = &per_cpu_ptr(pmu->pmu_cpu_context, src_cpu)->ctx;
>         dst_ctx = &per_cpu_ptr(pmu->pmu_cpu_context, dst_cpu)->ctx;
>
> @@ -7625,6 +7701,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
>                 get_ctx(dst_ctx);
>         }
>         mutex_unlock(&dst_ctx->mutex);
> +       percpu_up_write(&perf_rwsem);
>  }
>  EXPORT_SYMBOL_GPL(perf_pmu_migrate_context);
>
> @@ -8261,6 +8338,7 @@ void __init perf_event_init(void)
>
>         idr_init(&pmu_idr);
>
> +       percpu_init_rwsem(&perf_rwsem);
>         perf_event_init_all_cpus();
>         init_srcu_struct(&pmus_srcu);
>         perf_pmu_register(&perf_swevent, "software", PERF_TYPE_SOFTWARE);
>
