Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaBMUfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:35:48 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35739 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBMUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:35:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140213201618.GD14089@laptop.programming.kicks-ass.net>
References: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
 <218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net>
 <20140213145016.GA15586@twins.programming.kicks-ass.net> <CALCETrWpDxt1xhBx=CWq-fwSBoCpbC_stoouY2mPX8u4u8XNhQ@mail.gmail.com>
 <20140213201618.GD14089@laptop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Feb 2014 12:35:25 -0800
Message-ID: <CALCETrXgrrStOesqWzgUfYp+qf-FZHRDi-y6oG0s0_TmPE5MTA@mail.gmail.com>
Subject: Re: [RFC] sched: Add a new lockless wake-from-idle implementation
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 12:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Feb 13, 2014 at 09:07:10AM -0800, Andy Lutomirski wrote:
>> > I also don't really like how the polling state is an atomic; its a cpu
>> > local property.
>>
>> Your patch also makes polling state be an atomic (albeit one that
>> isn't changed remotely).
>
> Yah, sorry for that, changed the email (and code about) a number of
> times before posting :/
>
>> On the subject of major surgery, though: there are very few places in
>> the kernel where TIF_NEED_RESCHED gets set.  With something like my
>> patch applied, I think that there is no code at all that sets any
>> other task's TIF_NEED_RESCHED.  That suggests that all
>> set_tsk_need_resched callers could just call into the scheduler
>> directly.
>
> One of the main callers would be the timer tick for local preemption;
> that's from interrupt context, can't call schedule() there, really needs
> to be the interrupt return path.
>
>> If so, the change could probably delete a whole lot of
>> assembly code, and every kernel exit would get faster.
>
> We already need to load that word for all kinds of other things; like
> delivering signals, so testing the one bit in the return path is
> basically free.
>
> Anyway; after all this mucking about I finally remembered Venki once
> attempted something similar:
>
>   https://lkml.org/lkml/2012/2/6/357
>
> How about something like this?

This looks remarkably similar to my version, except that it's just for
mwait.  Hmm.

My updated patch is currently completely broken.  I'll fix it up and
send it out for comparison.

--Andy

>
> ---
>  arch/x86/include/asm/mwait.h | 33 ++++++++++++++++--------
>  arch/x86/kernel/process.c    |  2 ++
>  arch/x86/kernel/smp.c        | 61 ++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 83 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
> index 1da25a5f96f9..cb7bb8bb6617 100644
> --- a/arch/x86/include/asm/mwait.h
> +++ b/arch/x86/include/asm/mwait.h
> @@ -1,6 +1,7 @@
>  #ifndef _ASM_X86_MWAIT_H
>  #define _ASM_X86_MWAIT_H
>
> +#include <linux/percpu.h>
>  #include <linux/sched.h>
>
>  #define MWAIT_SUBSTATE_MASK            0xf
> @@ -15,6 +16,14 @@
>
>  #define MWAIT_ECX_INTERRUPT_BREAK      0x1
>
> +#define MWAIT_IPI_ENABLED              0x01
> +#define MWAIT_IPI_RESCHED              0x02
> +#define MWAIT_IPI_SINGLE               0x04
> +
> +extern void mwait_intercept_handler(void);
> +
> +DECLARE_PER_CPU_ALIGNED(unsigned int, mwait_ipi);
> +
>  static inline void __monitor(const void *eax, unsigned long ecx,
>                              unsigned long edx)
>  {
> @@ -42,18 +51,20 @@ static inline void __mwait(unsigned long eax, unsigned long ecx)
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
> +       unsigned int *ptr = this_cpu_ptr(&mwait_ipi);
> +       unsigned int old = xchg(ptr, MWAIT_IPI_ENABLED);
> +
> +       WARN_ON_ONCE(old);
> +
> +       if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
> +               mb();
> +               clflush((void *)ptr);
> +               mb();
>         }
> -       current_clr_polling();
> +
> +       __monitor((void *)ptr, 0, 0);
> +       if (!(*ptr & ~MWAIT_IPI_ENABLED))
> +               __mwait(eax, ecx);
>  }
>
>  #endif /* _ASM_X86_MWAIT_H */
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 4505e2a950d8..00afb2b676b8 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -28,6 +28,7 @@
>  #include <asm/fpu-internal.h>
>  #include <asm/debugreg.h>
>  #include <asm/nmi.h>
> +#include <asm/mwait.h>
>
>  /*
>   * per-CPU TSS segments. Threads are completely 'soft' on Linux,
> @@ -286,6 +287,7 @@ void arch_cpu_idle_enter(void)
>  void arch_cpu_idle_exit(void)
>  {
>         __exit_idle();
> +       mwait_intercept_handler();
>  }
>
>  void arch_cpu_idle_dead(void)
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 7c3a5a61f2e4..4b078a8d6b83 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -23,6 +23,8 @@
>  #include <linux/interrupt.h>
>  #include <linux/cpu.h>
>  #include <linux/gfp.h>
> +#include <linux/sched.h>
> +#include <linux/smp.h>
>
>  #include <asm/mtrr.h>
>  #include <asm/tlbflush.h>
> @@ -31,6 +33,8 @@
>  #include <asm/apic.h>
>  #include <asm/nmi.h>
>  #include <asm/trace/irq_vectors.h>
> +#include <asm/mwait.h>
> +
>  /*
>   *     Some notes on x86 processor bugs affecting SMP operation:
>   *
> @@ -113,6 +117,56 @@
>  static atomic_t stopping_cpu = ATOMIC_INIT(-1);
>  static bool smp_no_nmi_ipi = false;
>
> +DEFINE_PER_CPU_ALIGNED(unsigned int, mwait_ipi);
> +EXPORT_PER_CPU_SYMBOL_GPL(mwait_ipi);
> +
> +static bool mwait_intercept(int cpu, int ipi)
> +{
> +       u32 *ptr = &per_cpu(mwait_ipi, cpu);
> +       u32 val, new, old;
> +
> +       if (!static_cpu_has(X86_FEATURE_MWAIT))
> +               return false;
> +
> +       val = *ptr;
> +       if (!(val & MWAIT_IPI_ENABLED))
> +               return false;
> +
> +       for (;;) {
> +               new = val | ipi;
> +               old = cmpxchg(ptr, val, new);
> +               if (old == val)
> +                       break;
> +               val = old;
> +       }
> +
> +       if (!(old & MWAIT_IPI_ENABLED))
> +               return false;
> +
> +       return true;
> +}
> +
> +void mwait_intercept_handler(void)
> +{
> +       unsigned int val, *ptr;
> +
> +       if (!static_cpu_has(X86_FEATURE_MWAIT))
> +               return;
> +
> +       ptr = this_cpu_ptr(&mwait_ipi);
> +       val = xchg(ptr, 0);
> +
> +       if (!(val & ~MWAIT_IPI_ENABLED))
> +               return;
> +
> +       local_irq_disable();
> +       if (val & MWAIT_IPI_RESCHED)
> +               scheduler_ipi();
> +       if (val & MWAIT_IPI_SINGLE)
> +               generic_smp_call_function_single_interrupt();
> +       local_irq_enable();
> +}
> +
>  /*
>   * this function sends a 'reschedule' IPI to another CPU.
>   * it goes straight through and wastes no time serializing
> @@ -124,12 +178,15 @@ static void native_smp_send_reschedule(int cpu)
>                 WARN_ON(1);
>                 return;
>         }
> -       apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
> +
> +       if (!mwait_intercept(cpu, MWAIT_IPI_RESCHED))
> +               apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
>  }
>
>  void native_send_call_func_single_ipi(int cpu)
>  {
> -       apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
> +       if (!mwait_intercept(cpu, MWAIT_IPI_SINGLE))
> +               apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
>  }
>
>  void native_send_call_func_ipi(const struct cpumask *mask)



-- 
Andy Lutomirski
AMA Capital Management, LLC
