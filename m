Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaBNUBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:01:41 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:51157 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBNUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:01:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140213145016.GA15586@twins.programming.kicks-ass.net>
References: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
 <218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net> <20140213145016.GA15586@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Feb 2014 12:01:18 -0800
Message-ID: <CALCETrUOm7uRb1eUctPS5WCQkZDRZjOxyGyYb0BkGu+W-J0zpg@mail.gmail.com>
Subject: Re: [RFC] sched: Add a new lockless wake-from-idle implementation
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 6:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Feb 12, 2014 at 05:40:12PM -0800, Andy Lutomirski wrote:
>> This is a strawman proposal to simplify the idle implementation, eliminate
>> a race
>>
>> Benefits over current code:
>>  - ttwu_queue_remote doesn't use an IPI unless needed
>>  - The diffstat should speak for itself :)
>>  - Less racy.  Spurious IPIs are possible, but only in narrow windows or
>>    when two wakeups occur in rapid succession.
>>  - Seems to work (?)
>>
>> Issues:
>>  - Am I doing the percpu stuff right?
>>  - Needs work on non-x86 architectures
>>  - The !CONFIG_SMP case needs to be checked
>>  - Is "idlepoll" a good name for the new code?  It doesn't have *that*
>>    much to do with the idle state.  Maybe cpukick?
>>
>> If this turns out okay, TIF_NEED_RESCHED could possibly be deleted as well.
>
> No, we can't do away with that; its used in some fairly critical paths
> (return to userspace) and adding a second cacheline load there would be
> unfortunate.
>
> I also don't really like how the polling state is an atomic; its a cpu
> local property.
>
> Now given we can't get rid of TIF_NEED_RESCHED, and we need an atomic op
> on a remote cacheline anyhow; the simplest solution would be to convert
> all TS_POLLING users to TIF_POLLING_NRFLAG and use an atomic_or_return()
> like construct to do:
>
>   atomic_or_return(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG
>
> and avoid the IPI if that is false.
>
> Something a little like this; it does require a lot of auditing; but it
> boots on my x86_64.

On further consideration, I think I like this approach.  It's a
simpler change than mine and it appears to work (unlike mine, and I
still haven't figured out what I'm doing wrong).  If anyone wants to
get rid of the cmpxchg loop, a trick like would likely work well built
on top of this.

That being said, I can't really test this, because I can't seem to
boot any recent 3.14-based kernel on real hardware, and they die
before they produce any output.  They work fine in QEMU.

--Andy

>
> ---
>  arch/x86/include/asm/mwait.h       | 19 ++++----
>  arch/x86/include/asm/thread_info.h |  4 +-
>  arch/x86/kernel/process.c          |  8 ++--
>  include/linux/sched.h              | 90 +++-----------------------------------
>  kernel/sched/core.c                | 70 ++++++++++++++++++-----------
>  kernel/sched/idle.c                | 40 ++++++++---------
>  kernel/sched/sched.h               |  3 ++
>  7 files changed, 88 insertions(+), 146 deletions(-)
>
> diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
> index 1da25a5f96f9..d6a7b7cdc478 100644
> --- a/arch/x86/include/asm/mwait.h
> +++ b/arch/x86/include/asm/mwait.h
> @@ -42,18 +42,15 @@ static inline void __mwait(unsigned long eax, unsigned long ecx)
>   */
>  static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
>  {
> -       if (!current_set_polling_and_test()) {
> -               if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
> -                       mb();
> -                       clflush((void *)&current_thread_info()->flags);
> -                       mb();
> -               }
> -
> -               __monitor((void *)&current_thread_info()->flags, 0, 0);
> -               if (!need_resched())
> -                       __mwait(eax, ecx);
> +       if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
> +               mb();
> +               clflush((void *)&current_thread_info()->flags);
> +               mb();
>         }
> -       current_clr_polling();
> +
> +       __monitor((void *)&current_thread_info()->flags, 0, 0);
> +       if (!need_resched())
> +               __mwait(eax, ecx);
>  }
>
>  #endif /* _ASM_X86_MWAIT_H */
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> index e1940c06ed02..1f2fe575cfca 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -88,6 +88,7 @@ struct thread_info {
>  #define TIF_FORK               18      /* ret_from_fork */
>  #define TIF_NOHZ               19      /* in adaptive nohz mode */
>  #define TIF_MEMDIE             20      /* is terminating due to OOM killer */
> +#define TIF_POLLING_NRFLAG     21
>  #define TIF_IO_BITMAP          22      /* uses I/O bitmap */
>  #define TIF_FORCED_TF          24      /* true if TF in eflags artificially */
>  #define TIF_BLOCKSTEP          25      /* set when we want DEBUGCTLMSR_BTF */
> @@ -111,6 +112,7 @@ struct thread_info {
>  #define _TIF_IA32              (1 << TIF_IA32)
>  #define _TIF_FORK              (1 << TIF_FORK)
>  #define _TIF_NOHZ              (1 << TIF_NOHZ)
> +#define _TIF_POLLING_NRFLAG    (1 << TIF_POLLING_NRFLAG)
>  #define _TIF_IO_BITMAP         (1 << TIF_IO_BITMAP)
>  #define _TIF_FORCED_TF         (1 << TIF_FORCED_TF)
>  #define _TIF_BLOCKSTEP         (1 << TIF_BLOCKSTEP)
> @@ -234,8 +236,6 @@ static inline struct thread_info *current_thread_info(void)
>   * have to worry about atomic accesses.
>   */
>  #define TS_COMPAT              0x0002  /* 32bit syscall active (64BIT)*/
> -#define TS_POLLING             0x0004  /* idle task polling need_resched,
> -                                          skip sending interrupt */
>  #define TS_RESTORE_SIGMASK     0x0008  /* restore signal mask in do_signal() */
>
>  #ifndef __ASSEMBLY__
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 4505e2a950d8..298c002629c6 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -306,9 +306,11 @@ void arch_cpu_idle(void)
>   */
>  void default_idle(void)
>  {
> -       trace_cpu_idle_rcuidle(1, smp_processor_id());
> -       safe_halt();
> -       trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
> +       if (!current_clr_polling_and_test()) {
> +               trace_cpu_idle_rcuidle(1, smp_processor_id());
> +               safe_halt();
> +               trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
> +       }
>  }
>  #ifdef CONFIG_APM_MODULE
>  EXPORT_SYMBOL(default_idle);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c49a2585ff7d..b326abe95978 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2692,85 +2692,26 @@ static inline int spin_needbreak(spinlock_t *lock)
>   * thread_info.status and one based on TIF_POLLING_NRFLAG in
>   * thread_info.flags
>   */
> -#ifdef TS_POLLING
> -static inline int tsk_is_polling(struct task_struct *p)
> -{
> -       return task_thread_info(p)->status & TS_POLLING;
> -}
> -static inline void __current_set_polling(void)
> -{
> -       current_thread_info()->status |= TS_POLLING;
> -}
> -
> -static inline bool __must_check current_set_polling_and_test(void)
> -{
> -       __current_set_polling();
> -
> -       /*
> -        * Polling state must be visible before we test NEED_RESCHED,
> -        * paired by resched_task()
> -        */
> -       smp_mb();
> -
> -       return unlikely(tif_need_resched());
> -}
> -
> -static inline void __current_clr_polling(void)
> -{
> -       current_thread_info()->status &= ~TS_POLLING;
> -}
> -
> -static inline bool __must_check current_clr_polling_and_test(void)
> -{
> -       __current_clr_polling();
> -
> -       /*
> -        * Polling state must be visible before we test NEED_RESCHED,
> -        * paired by resched_task()
> -        */
> -       smp_mb();
> -
> -       return unlikely(tif_need_resched());
> -}
> -#elif defined(TIF_POLLING_NRFLAG)
> +#ifdef CONFIG_SMP
>  static inline int tsk_is_polling(struct task_struct *p)
>  {
>         return test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
>  }
>
> -static inline void __current_set_polling(void)
> +static inline void current_set_polling(void)
>  {
>         set_thread_flag(TIF_POLLING_NRFLAG);
>  }
>
> -static inline bool __must_check current_set_polling_and_test(void)
> -{
> -       __current_set_polling();
> -
> -       /*
> -        * Polling state must be visible before we test NEED_RESCHED,
> -        * paired by resched_task()
> -        *
> -        * XXX: assumes set/clear bit are identical barrier wise.
> -        */
> -       smp_mb__after_clear_bit();
> -
> -       return unlikely(tif_need_resched());
> -}
> -
> -static inline void __current_clr_polling(void)
> +static inline void current_clr_polling(void)
>  {
>         clear_thread_flag(TIF_POLLING_NRFLAG);
>  }
>
>  static inline bool __must_check current_clr_polling_and_test(void)
>  {
> -       __current_clr_polling();
> +       current_clr_polling();
>
> -       /*
> -        * Polling state must be visible before we test NEED_RESCHED,
> -        * paired by resched_task()
> -        */
>         smp_mb__after_clear_bit();
>
>         return unlikely(tif_need_resched());
> @@ -2778,34 +2719,15 @@ static inline bool __must_check current_clr_polling_and_test(void)
>
>  #else
>  static inline int tsk_is_polling(struct task_struct *p) { return 0; }
> -static inline void __current_set_polling(void) { }
> -static inline void __current_clr_polling(void) { }
> +static inline void current_set_polling(void) { }
> +static inline void current_clr_polling(void) { }
>
> -static inline bool __must_check current_set_polling_and_test(void)
> -{
> -       return unlikely(tif_need_resched());
> -}
>  static inline bool __must_check current_clr_polling_and_test(void)
>  {
>         return unlikely(tif_need_resched());
>  }
>  #endif
>
> -static inline void current_clr_polling(void)
> -{
> -       __current_clr_polling();
> -
> -       /*
> -        * Ensure we check TIF_NEED_RESCHED after we clear the polling bit.
> -        * Once the bit is cleared, we'll get IPIs with every new
> -        * TIF_NEED_RESCHED and the IPI handler, scheduler_ipi(), will also
> -        * fold.
> -        */
> -       smp_mb(); /* paired with resched_task() */
> -
> -       preempt_fold_need_resched();
> -}
> -
>  static __always_inline bool need_resched(void)
>  {
>         return unlikely(tif_need_resched());
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fb9764fbc537..19de9a1cc96c 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -504,45 +504,63 @@ static inline void init_hrtick(void)
>  }
>  #endif /* CONFIG_SCHED_HRTICK */
>
> -/*
> - * resched_task - mark a task 'to be rescheduled now'.
> - *
> - * On UP this means the setting of the need_resched flag, on SMP it
> - * might also involve a cross-CPU call to trigger the scheduler on
> - * the target CPU.
> - */
> -void resched_task(struct task_struct *p)
> +static void __resched_cpu(int cpu)
>  {
> -       int cpu;
> +       struct rq *rq = cpu_rq(cpu);
> +       struct task_struct *p;
> +       struct thread_info *ti;
> +       unsigned long val, old, new;
> +       bool ipi;
>
> -       lockdep_assert_held(&task_rq(p)->lock);
> +       rcu_read_lock();
> +       do {
> +               p = ACCESS_ONCE(rq->curr);
> +               ti = task_thread_info(p);
> +
> +               val = ti->flags;
> +               for (;;) {
> +                       new = val | _TIF_NEED_RESCHED;
> +                       old = cmpxchg(&ti->flags, val, new);
> +                       if (old == val)
> +                               break;
> +                       val = old;
> +               }
>
> -       if (test_tsk_need_resched(p))
> -               return;
> +               ipi = !(old & _TIF_POLLING_NRFLAG);
>
> -       set_tsk_need_resched(p);
> +       } while (p != ACCESS_ONCE(rq->curr));
> +       rcu_read_unlock();
>
> -       cpu = task_cpu(p);
> +       if (ipi)
> +               smp_send_reschedule(cpu);
> +}
> +
> +void resched_cpu(int cpu)
> +{
>         if (cpu == smp_processor_id()) {
> +               set_tsk_need_resched(current);
>                 set_preempt_need_resched();
>                 return;
>         }
>
> -       /* NEED_RESCHED must be visible before we test polling */
> -       smp_mb();
> -       if (!tsk_is_polling(p))
> -               smp_send_reschedule(cpu);
> +       __resched_cpu(cpu);
>  }
>
> -void resched_cpu(int cpu)
> +/*
> + * resched_task - mark a task 'to be rescheduled now'.
> + *
> + * On UP this means the setting of the need_resched flag, on SMP it
> + * might also involve a cross-CPU call to trigger the scheduler on
> + * the target CPU.
> + */
> +void resched_task(struct task_struct *p)
>  {
> -       struct rq *rq = cpu_rq(cpu);
> -       unsigned long flags;
> +       lockdep_assert_held(&task_rq(p)->lock);
>
> -       if (!raw_spin_trylock_irqsave(&rq->lock, flags))
> +       if (test_tsk_need_resched(p))
>                 return;
> -       resched_task(cpu_curr(cpu));
> -       raw_spin_unlock_irqrestore(&rq->lock, flags);
> +
> +       resched_cpu(task_cpu(p));
>  }
>
>  #ifdef CONFIG_SMP
> @@ -1476,7 +1494,7 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
>  }
>
>  #ifdef CONFIG_SMP
> -static void sched_ttwu_pending(void)
> +void sched_ttwu_pending(void)
>  {
>         struct rq *rq = this_rq();
>         struct llist_node *llist = llist_del_all(&rq->wake_list);
> @@ -2689,7 +2707,7 @@ static void __sched __schedule(void)
>                 update_rq_clock(rq);
>
>         next = pick_next_task(rq, prev);
> -       clear_tsk_need_resched(prev);
> +       clear_tsk_need_resched(next);
>         clear_preempt_need_resched();
>         rq->skip_clock_update = 0;
>
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 14ca43430aee..03748737473e 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -11,6 +11,7 @@
>  #include <asm/tlb.h>
>
>  #include <trace/events/power.h>
> +#include "sched.h"
>
>  static int __read_mostly cpu_idle_force_poll;
>
> @@ -71,6 +72,8 @@ static void cpu_idle_loop(void)
>         while (1) {
>                 tick_nohz_idle_enter();
>
> +               current_set_polling();
> +
>                 while (!need_resched()) {
>                         check_pgt_cache();
>                         rmb();
> @@ -93,29 +96,27 @@ static void cpu_idle_loop(void)
>                         if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
>                                 cpu_idle_poll();
>                         } else {
> -                               if (!current_clr_polling_and_test()) {
> -                                       stop_critical_timings();
> -                                       rcu_idle_enter();
> -                                       if (cpuidle_idle_call())
> -                                               arch_cpu_idle();
> -                                       if (WARN_ON_ONCE(irqs_disabled()))
> -                                               local_irq_enable();
> -                                       rcu_idle_exit();
> -                                       start_critical_timings();
> -                               } else {
> +                               stop_critical_timings();
> +                               rcu_idle_enter();
> +                               if (cpuidle_idle_call())
> +                                       arch_cpu_idle();
> +                               if (WARN_ON_ONCE(irqs_disabled()))
>                                         local_irq_enable();
> -                               }
> -                               __current_set_polling();
> +                               rcu_idle_exit();
> +                               start_critical_timings();
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
> +               current_clr_polling();
> +
> +               /*
> +                * We need to test and propagate the TIF_NEED_RESCHED bit here
> +                * because we might not have send the reschedule IPI to idle
> +                * tasks.
> +                */
> +               set_preempt_need_resched();
> +               sched_ttwu_pending();
>                 tick_nohz_idle_exit();
>                 schedule_preempt_disabled();
>         }
> @@ -138,7 +139,6 @@ void cpu_startup_entry(enum cpuhp_state state)
>          */
>         boot_init_stack_canary();
>  #endif
> -       __current_set_polling();
>         arch_cpu_idle_prepare();
>         cpu_idle_loop();
>  }
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 1bf34c257d3b..269b1a4e0bdf 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1160,6 +1160,7 @@ extern const struct sched_class idle_sched_class;
>
>  #ifdef CONFIG_SMP
>
> +extern void sched_ttwu_pending(void);
>  extern void update_group_power(struct sched_domain *sd, int cpu);
>
>  extern void trigger_load_balance(struct rq *rq);
> @@ -1170,6 +1171,8 @@ extern void idle_exit_fair(struct rq *this_rq);
>
>  #else  /* CONFIG_SMP */
>
> +static inline void sched_ttwu_pending(void) { }
> +
>  static inline void idle_balance(int cpu, struct rq *rq)
>  {
>  }
>
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
