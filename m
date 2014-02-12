Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaBLSUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:20:05 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:54682 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaBLSUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:20:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140212163916.GA27965@twins.programming.kicks-ass.net>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
 <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
 <CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com>
 <20140212101324.GC3545@laptop.programming.kicks-ass.net> <CALCETrW-GCNuqSTO=p==0gPE2c8wZKSe98Gi4PP2NRdgk5iKag@mail.gmail.com>
 <20140212163916.GA27965@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Feb 2014 10:19:42 -0800
Message-ID: <CALCETrWx39_xLZAEGA8_nnGGhbpaSXqY4haLqbU1wavJM6wenQ@mail.gmail.com>
Subject: Re: Too many rescheduling interrupts (still!)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 8:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Feb 12, 2014 at 07:49:07AM -0800, Andy Lutomirski wrote:
>> On Wed, Feb 12, 2014 at 2:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> Exactly.  AFAICT the only reason that any of this code holds rq->lock
>> (especially ttwu_queue_remote, which I seem to call a few thousand
>> times per second) is because the only way to make a cpu reschedule
>> involves playing with per-task flags.  If the flags were per-rq or
>> per-cpu instead, then rq->lock wouldn't be needed.  If this were all
>> done locklessly, then I think either a full cmpxchg or some fairly
>> careful use of full barriers would be needed, but I bet that cmpxchg
>> is still considerably faster than a spinlock plus a set_bit.
>
> Ahh, that's what you're saying. Yes we should be able to do something
> clever there.
>
> Something like the below is I think as close as we can come without
> major surgery and moving TIF_NEED_RESCHED and POLLING into a per-cpu
> variable.
>
> I might have messed it up though; brain seems to have given out for the
> day :/
>
> ---
>  kernel/sched/core.c  | 17 +++++++++++++----
>  kernel/sched/idle.c  | 21 +++++++++++++--------
>  kernel/sched/sched.h |  5 ++++-
>  3 files changed, 30 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fb9764fbc537..a5b64040c21d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -529,7 +529,7 @@ void resched_task(struct task_struct *p)
>         }
>
>         /* NEED_RESCHED must be visible before we test polling */
> -       smp_mb();
> +       smp_mb__after_clear_bit();
>         if (!tsk_is_polling(p))
>                 smp_send_reschedule(cpu);
>  }
> @@ -1476,12 +1476,15 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
>  }
>
>  #ifdef CONFIG_SMP
> -static void sched_ttwu_pending(void)
> +void sched_ttwu_pending(void)
>  {
>         struct rq *rq = this_rq();
>         struct llist_node *llist = llist_del_all(&rq->wake_list);
>         struct task_struct *p;
>
> +       if (!llist)
> +               return;
> +
>         raw_spin_lock(&rq->lock);
>
>         while (llist) {
> @@ -1536,8 +1539,14 @@ void scheduler_ipi(void)
>
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
>  {
> -       if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
> -               smp_send_reschedule(cpu);
> +       struct rq *rq = cpu_rq(cpu);
> +
> +       if (llist_add(&p->wake_entry, &rq->wake_list)) {
> +               set_tsk_need_resched(rq->idle);
> +               smp_mb__after_clear_bit();
> +               if (!tsk_is_polling(rq->idle) || rq->curr != rq->idle)
> +                       smp_send_reschedule(cpu);
> +       }

At the very least this needs a comment pointing out that rq->lock is
intentionally not taken.  This makes my brain hurt a little :)

>  }
>
>  bool cpus_share_cache(int this_cpu, int that_cpu)
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 14ca43430aee..bd8ed2d2f2f7 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -105,19 +105,24 @@ static void cpu_idle_loop(void)
>                                 } else {
>                                         local_irq_enable();
>                                 }
> -                               __current_set_polling();
>                         }
>                         arch_cpu_idle_exit();
> -                       /*
> -                        * We need to test and propagate the TIF_NEED_RESCHED
> -                        * bit here because we might not have send the
> -                        * reschedule IPI to idle tasks.
> -                        */
> -                       if (tif_need_resched())
> -                               set_preempt_need_resched();
>                 }
> +
> +               /*
> +                * We must clear polling before running sched_ttwu_pending().
> +                * Otherwise it becomes possible to have entries added in
> +                * ttwu_queue_remote() and still not get an IPI to process
> +                * them.
> +                */
> +               __current_clr_polling();
> +
> +               set_preempt_need_resched();
> +               sched_ttwu_pending();
> +
>                 tick_nohz_idle_exit();
>                 schedule_preempt_disabled();
> +               __current_set_polling();

I wonder if this side has enough barriers to make this work.


I'll see if I have a few free minutes (yeah right!) to try out the
major surgery approach.  I think I can do it without even cmpxchg.
Basically, there would be a percpu variable idlepoll_state with three
values: IDLEPOLL_NOT_POLLING, IDLEPOLL_WOKEN, and IDLEPOLL_POLLING.

The polling idle code does:

idlepoll_state = IDLEPOLL_POLLING;
smp_mb();
check for ttwu and need_resched;
mwait, poll, or whatever until idlepoll_state != IDLEPOLL_POLLING;
idlepoll_state = IDLEPOLL_NOT_POLLING;
smp_mb();
check for ttwu and need_resched;

The idle non-polling code does:


idlepoll_state = IDLEPOLL_NOT_POLLING;
smp_mb();
check for ttwu and need_resched;
wait for interrupt;
idlepoll_state = IDLEPOLL_NOT_POLLING;
smp_mb();
check for ttwu and need_resched;

The IPI handler does:
if (xchg(&idlepoll_state, IDLEPOLL_NOT_POLLING) == IDLEPOLL_WOKEN))
  set need_resched;

The wakeup code does:

if (xchg(&idlepoll_state, IDLEPOLL_WOKEN) == IDLEPOLL_NOT_POLLING))
  smp_send_reschedule(cpu);

or even:

if (idlepoll_state == IDLEPOLL_NOT_POLLING || xchg(&idlepoll_state,
IDLEPOLL_WOKEN) == IDLEPOLL_NOT_POLLING))
  smp_send_reschedule(cpu);

I'll mull on this.  If I'm right, this should be faster than the
current code for !x86, too -- waking up a CPU becomes a read of a
single shared cacheline + smp_send_reschedule.

I don't know how the !dynticks case works well enough to know whether
this will hurt performance.  I assume the reason that TIF_NEED_RESCHED
exists in the first place is so that the kernel exit code can check a
single thing for all slow-path work including rescheduling.

--Andy
