Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaBSSDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:03:16 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:62631 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaBSSDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:03:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140219162819.GP15586@twins.programming.kicks-ass.net>
References: <20140210221758.GB11542@dreric01-Precision-T1600>
	<20140218101831.GB4178@mudshark.cambridge.arm.com>
	<20140219162819.GP15586@twins.programming.kicks-ass.net>
Date: Wed, 19 Feb 2014 19:03:13 +0100
Message-ID: <CABPqkBQS355_XW-2KthkdZkzQnApRvOpANkB3SnfFyac-qsJaw@mail.gmail.com>
Subject: Re: Perf Oops on 3.14-rc2
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Drew Richardson <drew.richardson@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo <acme@redhat.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Wade Cherry <Wade.Cherry@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Wed, Feb 19, 2014 at 5:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Feb 18, 2014 at 10:18:31AM +0000, Will Deacon wrote:
>> On Mon, Feb 10, 2014 at 10:17:59PM +0000, Drew Richardson wrote:
>> > While adding CPU on/offlining support during perf captures I get an
>> > Oops both on ARM as well as my desktop x86_64. Below is a small
>> > program that duplicates the issue.
>>
>> [...]
>>
>> FWIW I can reproduce this easily with -rc3 on my x86 laptop running
>> hackbench in parallel with a tweaked version of your test (using
>> _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF and hotplugging off
>> both CPU2 and CPU3).
>>
>
> OK; found it, or at least, I stopped being able to make my box explode.
>
> Drew, can you try the below and confirm? Its still got all the debug goo
> in too, but *shees* took me long enough.
>
> Stephane, there's two task_function_call()s in the CGROUP_PERF code that
> don't check return codes; can you please audit those?
>
I am trying to understand the context here.
Are you saying, we may call an offline CPU?
I saw that sometimes you retry, sometimes you don't.

For perf_cgroup_attach(), we invoke task_function_call()
to force a PMU context switch on the task which is now monitored in cgroup mode.
If the CPU is offline then, the task is switched out and monitoring
has been stoppe,
 no need to retry or do anything more.

For perf_cgroup_exit(), this is pretty much the same logic.

am I missing anything else?

> ---
>  kernel/events/core.c | 128 ++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 101 insertions(+), 27 deletions(-)
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 2067cbb378eb..7c378fc21bff 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -78,7 +78,7 @@ static void remote_function(void *data)
>   *         -ESRCH  - when the process isn't running
>   *         -EAGAIN - when the process moved away
>   */
> -static int
> +static int __must_check
>  task_function_call(struct task_struct *p, int (*func) (void *info), void *info)
>  {
>         struct remote_function_call data = {
> @@ -103,7 +103,8 @@ task_function_call(struct task_struct *p, int (*func) (void *info), void *info)
>   *
>   * returns: @func return value or -ENXIO when the cpu is offline
>   */
> -static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
> +static int __must_check
> +cpu_function_call(int cpu, int (*func) (void *info), void *info)
>  {
>         struct remote_function_call data = {
>                 .p      = NULL,
> @@ -1500,14 +1501,23 @@ static void perf_remove_from_context(struct perf_event *event)
>
>         if (!task) {
>                 /*
> -                * Per cpu events are removed via an smp call and
> -                * the removal is always successful.
> +                * Per cpu events are removed via an smp call.
>                  */
> -               cpu_function_call(event->cpu, __perf_remove_from_context, event);
> +retry1:
> +               if (!cpu_function_call(event->cpu, __perf_remove_from_context, event))
> +                       return;
> +
> +               raw_spin_lock_irq(&ctx->lock);
> +               if (ctx->is_active) {
> +                       raw_spin_unlock_irq(&ctx->lock);
> +                       goto retry1;
> +               }
> +               list_del_event(event, ctx);
> +               raw_spin_unlock_irq(&ctx->lock);
>                 return;
>         }
>
> -retry:
> +retry2:
>         if (!task_function_call(task, __perf_remove_from_context, event))
>                 return;
>
> @@ -1518,7 +1528,7 @@ static void perf_remove_from_context(struct perf_event *event)
>          */
>         if (ctx->is_active) {
>                 raw_spin_unlock_irq(&ctx->lock);
> -               goto retry;
> +               goto retry2;
>         }
>
>         /*
> @@ -1592,11 +1602,24 @@ void perf_event_disable(struct perf_event *event)
>                 /*
>                  * Disable the event on the cpu that it's on
>                  */
> -               cpu_function_call(event->cpu, __perf_event_disable, event);
> +retry1:
> +               if (!cpu_function_call(event->cpu, __perf_event_disable, event))
> +                       return;
> +
> +               raw_spin_lock_irq(&ctx->lock);
> +               if (event->state == PERF_EVENT_STATE_ACTIVE) {
> +                       raw_spin_unlock_irq(&ctx->lock);
> +                       goto retry1;
> +               }
> +               if (event->state == PERF_EVENT_STATE_INACTIVE) {
> +                       update_group_times(event);
> +                       event->state = PERF_EVENT_STATE_OFF;
> +               }
> +               raw_spin_unlock_irq(&ctx->lock);
>                 return;
>         }
>
> -retry:
> +retry2:
>         if (!task_function_call(task, __perf_event_disable, event))
>                 return;
>
> @@ -1611,7 +1634,7 @@ void perf_event_disable(struct perf_event *event)
>                  * a concurrent perf_event_context_sched_out().
>                  */
>                 task = ctx->task;
> -               goto retry;
> +               goto retry2;
>         }
>
>         /*
> @@ -1939,14 +1962,22 @@ perf_install_in_context(struct perf_event_context *ctx,
>
>         if (!task) {
>                 /*
> -                * Per cpu events are installed via an smp call and
> -                * the install is always successful.
> +                * Per cpu events are installed via an smp call.
>                  */
> -               cpu_function_call(cpu, __perf_install_in_context, event);
> +retry1:
> +               if (!cpu_function_call(cpu, __perf_install_in_context, event))
> +                       return;
> +               raw_spin_lock_irq(&ctx->lock);
> +               if (ctx->is_active) {
> +                       raw_spin_unlock_irq(&ctx->lock);
> +                       goto retry1;
> +               }
> +               add_event_to_ctx(event, ctx);
> +               raw_spin_unlock_irq(&ctx->lock);
>                 return;
>         }
>
> -retry:
> +retry2:
>         if (!task_function_call(task, __perf_install_in_context, event))
>                 return;
>
> @@ -1957,7 +1988,7 @@ perf_install_in_context(struct perf_event_context *ctx,
>          */
>         if (ctx->is_active) {
>                 raw_spin_unlock_irq(&ctx->lock);
> -               goto retry;
> +               goto retry2;
>         }
>
>         /*
> @@ -2086,7 +2117,15 @@ void perf_event_enable(struct perf_event *event)
>                 /*
>                  * Enable the event on the cpu that it's on
>                  */
> -               cpu_function_call(event->cpu, __perf_event_enable, event);
> +retry1:
> +               if (!cpu_function_call(event->cpu, __perf_event_enable, event))
> +                       return;
> +               raw_spin_lock_irq(&ctx->lock);
> +               if (ctx->is_active && event->state == PERF_EVENT_STATE_OFF) {
> +                       raw_spin_unlock_irq(&ctx->lock);
> +                       goto retry1;
> +               }
> +               raw_spin_unlock_irq(&ctx->lock);
>                 return;
>         }
>
> @@ -2104,7 +2143,7 @@ void perf_event_enable(struct perf_event *event)
>         if (event->state == PERF_EVENT_STATE_ERROR)
>                 event->state = PERF_EVENT_STATE_OFF;
>
> -retry:
> +retry2:
>         if (!ctx->is_active) {
>                 __perf_event_mark_enabled(event);
>                 goto out;
> @@ -2127,7 +2166,7 @@ void perf_event_enable(struct perf_event *event)
>                  * perf_event_context_sched_out()
>                  */
>                 task = ctx->task;
> -               goto retry;
> +               goto retry2;
>         }
>
>  out:
> @@ -3243,6 +3282,7 @@ static void __free_event(struct perf_event *event)
>
>         call_rcu(&event->rcu_head, free_event_rcu);
>  }
> +
>  static void free_event(struct perf_event *event)
>  {
>         irq_work_sync(&event->pending);
> @@ -3271,6 +3311,8 @@ static void free_event(struct perf_event *event)
>         if (is_cgroup_event(event))
>                 perf_detach_cgroup(event);
>
> +       printk("destroying event (%p) : %d:%lx for cpu: %d\n",
> +                       event, event->attr.type, event->attr.config, event->cpu);
>
>         __free_event(event);
>  }
> @@ -4831,6 +4873,28 @@ perf_event_aux_ctx(struct perf_event_context *ctx,
>         struct perf_event *event;
>
>         list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
> +               if (!event) {
> +                       struct perf_event *tmp;
> +                       printk("on cpu: %d, %p:(%p,%p)\n", smp_processor_id(),
> +                                       &ctx->event_list,
> +                                       ctx->event_list.prev,
> +                                       ctx->event_list.next);
> +
> +                       tmp = ctx->event_list.next;
> +                       while (tmp) {
> +                               printk("%02d: event(%p): %d:%lx %d %d\n",
> +                                               smp_processor_id(), tmp,
> +                                               tmp ? tmp->attr.type : -1,
> +                                               tmp ? tmp->attr.config : 0,
> +                                               tmp ? tmp->state : 0,
> +                                               tmp ? tmp->cpu : 0);
> +                               printk("%02d:  ->next (%p)\n",
> +                                               smp_processor_id(),
> +                                               tmp->event_entry.next);
> +                               tmp = tmp->event_entry.next;
> +                       }
> +               }
> +
>                 if (event->state < PERF_EVENT_STATE_INACTIVE)
>                         continue;
>                 if (!event_filter_match(event))
> @@ -6722,6 +6786,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>
>         event->state            = PERF_EVENT_STATE_INACTIVE;
>
> +       printk("creating event (%p) : %d:%lx for cpu: %d\n",
> +                       event, attr->type, attr->config, cpu);
> +
>         if (task) {
>                 event->attach_state = PERF_ATTACH_TASK;
>
> @@ -7869,29 +7936,35 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
>
>  static void __perf_event_exit_context(void *__info)
>  {
> -       struct perf_event_context *ctx = __info;
> -       struct perf_event *event, *tmp;
> +       struct perf_cpu_context *cpuctx = __info;
> +       struct perf_event_context *ctx = &cpuctx->ctx;
> +       struct perf_event *event;
>
>         perf_pmu_rotate_stop(ctx->pmu);
>
> -       list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
> -               __perf_remove_from_context(event);
> -       list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
> -               __perf_remove_from_context(event);
> +       raw_spin_lock(&ctx->lock);
> +       ctx_sched_out(ctx, cpuctx, EVENT_ALL);
> +
> +       list_for_each_entry(event, &ctx->event_list, event_entry)
> +               event->state = PERF_EVENT_STATE_off;
> +
> +       raw_spin_unlock(&ctx->lock);
>  }
>
>  static void perf_event_exit_cpu_context(int cpu)
>  {
> +       struct perf_cpu_context *cpuctx;
>         struct perf_event_context *ctx;
>         struct pmu *pmu;
>         int idx;
>
>         idx = srcu_read_lock(&pmus_srcu);
>         list_for_each_entry_rcu(pmu, &pmus, entry) {
> -               ctx = &per_cpu_ptr(pmu->pmu_cpu_context, cpu)->ctx;
> +               cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
> +               ctx = &cpuctx->ctx;
>
>                 mutex_lock(&ctx->mutex);
> -               smp_call_function_single(cpu, __perf_event_exit_context, ctx, 1);
> +               smp_call_function_single(cpu, __perf_event_exit_context, cpuctx, 1);
>                 mutex_unlock(&ctx->mutex);
>         }
>         srcu_read_unlock(&pmus_srcu, idx);
> @@ -7901,11 +7974,12 @@ static void perf_event_exit_cpu(int cpu)
>  {
>         struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
>
> +       perf_event_exit_cpu_context(cpu);
> +
>         mutex_lock(&swhash->hlist_mutex);
>         swevent_hlist_release(swhash);
>         mutex_unlock(&swhash->hlist_mutex);
>
> -       perf_event_exit_cpu_context(cpu);
>  }
>  #else
>  static inline void perf_event_exit_cpu(int cpu) { }
