Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3JJOp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:45:27 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56123 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3JJOpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <20131010082739.1e78e1c4@gandalf.local.home>
References: <20131010082739.1e78e1c4@gandalf.local.home>
Date: Thu, 10 Oct 2013 20:15:23 +0530
Message-ID: <CAK7N6vr-yctE+hTM2wtbNGpaV_UcJwq6xqGAf4jD5k3ffGVigg@mail.gmail.com>
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
From: anish singh <anish198519851985@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Clark Williams <williams@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 5:57 PM, Steven Rostedt <rostedt@goodmis.org>
(by way of Steven Rostedt <rostedt@goodmis.org>) (by way of Steven
Rostedt <rostedt@goodmis.org> wrote:
>
> [ Resending, as somehow Claws email, removed the quotes from "H. Peter
>   Anvin", and that prevented LKML from receiving this ]
>
> *** NOT FOR INCLUSION ***
>
> What this does
> --------------
>
> There's several locations in the kernel that disable interrupts and
> enable them rather quickly. Most likely an interrupt will not happen
> during this time frame. Instead of actually disabling interrupts, set
> a flag instead, and if an interrupt were to come in, it would see
> the flag set and return (keeping interrupts disabled for real). When
> the flag is cleared, it checks if an interrupt came in and if it did
> it simulates that interrupt.
I think the concept is similar to the linux core interrupt code handling
where it does the lazy disabling of interrupt.

I was just wondering if we can do the same concept for ARM arch
and if some part of your code can be shared.It would be nice academic
exercise.
>
> Rational
> --------
> I noticed in function tracing that disabling interrupts is quite
> expensive. To measure this, I ran the stack tracer and several runs of
> hackbench:
>
>   trace-cmd stack --start
>   for i in `seq 10` ; do time ./hackbench 100; done &> output
>
> The stack tracer uses function tracing to examine every function's stack
> as the function is executed. If it finds a stack larger than the last
> max stack, it records it. But most of the time it just does the check
> and returns. To do this safely (using per cpu variables), it disables
> preemption:
>
> kernel/trace/trace_stack.c: stack_trace_call()
>
>         preempt_disable_notrace();
>         [...]
>         check_stack(ip, &stack);
>         [...]
>         preempt_enable_notrace();
>
> Most of the time, check_stack() just returns without doing anything
> as it is unlikely to hit a new max (it does very seldom), and shouldn't
> be an issue in the benchmarks.
>
> Then I changed this code do be:
>
>
> kernel/trace/trace_stack.c: stack_trace_call()
>
>         local_irq_save(flags);
>         [...]
>         check_stack(ip, &stack);
>         [...]
>         local_irq_restore(flags);
>
> And ran the test again. This caused a very large performance hit.
>
> Running on: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
>   (4 cores HT enabled)
>
> Here's the differences:
>
>         With preempt disable (10 runs):
>
>                 Time from hackbench:
>                         avg=2.0462
>                         std=0.181487189630563
>
>                 System time (from time):
>                         avg=10.5879
>                         std=0.862181477416443
>
>         With irq disable (10 runs):
>
>                 Time from hackbench:
>                         avg=2.7082
>                         std=0.12304308188598
>
>                 System time (from time):
>                         avg=14.6807
>                         std=0.313856814487116
>
> A 32% performance hit when using irq disabling told me that this is
> something we could improve on in normal activities. That is, avoid
> disabling interrupts when possible. For the last couple of weeks I
> decided to implement a "lazy irq disable" to do this.
>
>
> The Setup
> ---------
>
> I only had to touch four functions that deal with interrupts:
>
>    o native_irq_enable()
>    o native_irq_disable()
>    o native_save_fl()
>    o native_restore_fl()
>
> As these are the basis for all other C functions that disable interrupts
>  (ie. local_irq_save(), local_irq_disable(), spin_lock_irq(), etc)
> just modifying them made it much easier to implement.
>
> I added raw_* versions of each that do the real enabling and disabling.
> Basically, the raw_* versions are what they currently do today.
>
> Per CPU
> -------
>
> I added a couple of per cpu variables:
>
>    o lazy_irq_disabled_flags
>    o lazy_irq_func
>    o lazy_irq_vector
>    o lazy_irq_on
>
> The lazy_irq_disabled_flags holds the state of the system. The flags
> are:
>
>  DISABLED - When set, irqs are considered disabled (whether they are for
>         real or not).
>
>  TEMP_DISABLE - Set when coming from a trap or other assembly that
>  disables interrupts to let the native_irq_enable() know that interrupts
>         are really disabled, and enable them as well.
>
>  IDLE - Used to tell the native_* functions that we are going idle and
>  to continue to do real interrupt disabling/enabling.
>
>  REAL_DISABLE - Set by interrupts themselves. When interrupts are
>  running, (this includes softirqs), we enable and disable interrupts
>  normally. No lazy disabling is done from interrupt context.
>
> The lazy_irq_func holds the interrupt function that was to trigger when
> we were in lazy irq disabled mode with interrupts enabled. Explained
> below.
>
> The lazy_irq_vector holds the orig_rax, which is the vector that the
> interrupt handler needs to know what interrupt vector was triggered.
> Saved for the same use as lazy_irq_func is.
>
> Because preempt_disable is currently a task flag, we need a per_cpu
> version of it for the lazy irq disabling. When irqs are disabled, the
> process requires that preemption is also disabled, and we need to do
> this with a per_cpu flag. For now, lazy_irq_on is used, and acts just
> like preempt_count for preventing scheduling from taking place.
>
>
> The Process
> -----------
>
> Here's the basic idea of what happens.
>
> When native_irq_disable() is called, if any flag but DISABLED is set,
> then real interrupts are disabled. Otherwise, if DISABLED is already
> set, then nothing needs to be done. The DISABLED flag gets set, and at
> that moment if an interrupt comes in, it wont call the handler.
>
> If an interrupt comes in when DISABLED is set, it updates the
> lazy_irq_func and lazy_irq_vector and returns. But before calling
> iretq, it clears the X86_EFLAGS_IF bit in the flags location of the
> stack to keep interrupts disabled when returning. This prevents any
> other interrupt from coming in. At this moment, interrupts are disabled
> like they would be on a non lazy irq disabled system.
>
> When native_irq_enable() is called, if a flag other than DISABLED is set
> then it checks if lazy_irq_func is set, if it is, it will simulate the
> irq, otherwise it just enables interrupts. If DISABLED is set then
> it clears the DISABLED flag, then checks if lazy_irq_func is set.
> If lazy_irq_func is set, then we know that an interrupt came in and
> disabled interrupts for real. We don't need to worry about a race with
> new interrupts as interrupts are disabled. Just clearing the flag and
> then doing the check is safe. If an interrupt came in after we cleared
> the flag (assuming no interrupt came in before, because that would have
> disabled interrupts), it would run the interrupt handler normally, and
> not set lazy_irq_func.
>
> When lazy_irq_func is set, interrupts must have been disabled (bug if
> not). Then we simulate the interrupt. This is done by software creating
> the interrupt stack frame, changing the flags to re-enable interrupts,
> and then calling the interrupt handler that was saved by lazy_irq_func
> (adding the saved vector to the stack as well). When the interrupt
> handler returns, a jmp to ret_from_intr is called, which will do the
> same processing as a normal interrupt would do. As EFLAGS was updated
> to re-enable interrupt when it does the iretq, interrupts would then be
> atomically enabled.
>
>
> Specialty Processing
> -------------------
>
> Mostly this works well, but there were a few areas that needed some
> extra work.
>
> Switch To
> ---------
>
> The switch_to code was a bit problematic, as for some reason (I don't
> know why), flags are saved on the prev stack, and restored from the
> next stack. I would assume that gcc would not be depending on flags
> after as asm() call, which switch_to does.  But this causes problems as
> we don't disable interrupts unless a interrupt comes in. One could come
> in just before the switch, and then after the switch interrupts can be
> enabled again.
>
> To avoid issues, the flags for next are changed to always disable
> interrupts and sets the TEMP flag to let the next native_enable_irq()
> know interrupts are really disabled.
>
>
> Return From Fork
> ----------------
>
> Return from fork does a popf with interrupts disabled. Just to be
> safe, we keep interrupts disabled and set the TEMP flag when calling
> schedule_tail().
>
>
> Traps
> -----
>
> This was also a pain. As a trap can happen in interrupt context, kernel
> context, or user context. Basically, it can happen in any context.
> Here we use the TEMP flag again, and just keep interrupts disabled when
> entering the trap. But if the trap may not enable interrupts so we need
> to check if the TEMP flag is still set when exiting the trap.
>
> We also need to update the regs->eflags to show interrupts disabled if
> the DISABLED flag is set. That's because traps may check this as well
> and we need to make sure traps do the right decisions based on these
> flags. Instead of changing all locations that check these flags, just
> update them.
>
> I found it best to just keep the TEMP flag set if the DISABLED flag is
> set and return with interrupts disabled (no need to touch flags, as
> they already) were set on entry of the trap. If the trap enabled
> interrupts when the interrupts were disabled on entry, that would be
> bad normally, so I don't check for that case.
>
>
> Idle
> ----
>
> Idle was also a bit of a pain, as it disables interrupts when calling
> into the hardware, and the hardware will allow an interrupt to happen
> and return. To solve this, I added some functions that would check the
> state of the lazy_irq_disable and if a pending interrupt was there,
> just call the interrupt and not do the idle. Otherwise, set the IDLE
> flag and remove all other flags, as well as disable interrupts for
> real. When the IDLE flag is set, the native_irq_enable/disable()
> functions will just do the raw_ versions, until the IDLE flag gets
> cleared.
>
>
> Results
> -------
>
> Actually this was quite disappointing. After spending several days
> hacking this, and finally getting it running stable on bare metal, I
> was able to do some bench marks.
>
> Doing the same thing with the stack tracer, the patched code for
> interrupts disabled was:
>
>         With irq disable (10 runs):
>
>                 Time from hackbench:
>                         avg=2.3455
>                         std=0.106322622240049
>
>                 System time (from time):
>                         avg=12.306
>                         std=0.568022886862844
>
>
> Which is just a 14% slowdown compared to a 32% slowdown that the normal
> irq disabling had. This looks good right?
>
> Well, unfortunately, not so much :-(  The problem here is that we
> improved an unrealistic case. The stack tracer with interrupts disabling
> stresses the irqs disabled for ever single function called in the
> kernel. That's not normal operation.
>
> Disabling stack tracer and running hackbench normally again, we have:
>
> Unpatched:
>
>         Time from hackbench:
>                 avg=1.0657
>                 std=0.0533488519089212
>
>         System time (from time):
>                 avg=4.2248
>                 std=0.150524416624015
>
> Patched:
>
>         Time from hackbench:
>                 avg=1.0523
>                 std=0.046519888219986
>
>         System time (from time):
>                 avg=4.21
>                 std=0.214256855199548
>
> Yeah, it improved a little, but as we can see from the standard
> deviation, the difference is within the noise.
>
> Now maybe hackbench isn't the best benchmark to be testing this with.
> Other benchmarks should be used. But I've already spent too much time
> on this, and even though I got it working, it needs a lot of clean up
> if it is even worth doing. Unless there's real world benchmarks out
> there that shows us that this makes a huge difference, this work may be
> just chalked up as an academic exercise, which actually wasn't a waste
> of time as I now understand x86 infrastructure a little bit more.
>
> Hey, when you learn from code you wrote, even if it's never used by
> anyone, it is still worth doing just for that extra bit of knowledge
> you received. Knowledge does not come cheap.
>
>
> Summary
> -------
>
> Although the extreme case shows a nice improvement, I'm skeptical if it
> is worth doing for real world applications. But that said, I'm posting
> the code here as well as in my git repo. I'll give my SOB thus that
> anyone that wants to take it can build on it as long as they give me
> credit for what I've done.
>
> My git repo is here: But note, the commits in the repo are not stages
> of patches. It's a hodgepodge of states the code went through. The good,
> the bad, the ugly (mostly the ugly). Thus, you can see where I screwed
> up and had to rewrite the code. Every time I got something working (or
> thought I got something working), I committed it. The end result here
> had a little clean up so those reading the patch wont be so confused.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-rt.git
>
>   Branch: x86/irq-soft-disable-v4
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b32ebf9..789f691 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -17,6 +17,10 @@ config X86_64
>         depends on 64BIT
>         select X86_DEV_DMA_OPS
>
> +config LAZY_IRQ_DISABLE
> +       def_bool y
> +       depends on 64BIT
> +
>  ### Arch settings
>  config X86
>         def_bool y
> diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
> index bba3cf8..9d089f4 100644
> --- a/arch/x86/include/asm/irqflags.h
> +++ b/arch/x86/include/asm/irqflags.h
> @@ -3,12 +3,42 @@
>
>  #include <asm/processor-flags.h>
>
> +#undef CONFIG_LAZY_IRQ_DEBUG
> +
> +#define LAZY_IRQ_DISABLED_BIT          0
> +#define LAZY_IRQ_TEMP_DISABLE_BIT      1
> +#define LAZY_IRQ_IDLE_BIT              2
> +#define LAZY_IRQ_REAL_DISABLE_BIT      3
> +
> +#define LAZY_IRQ_FL_DISABLED           (1 << LAZY_IRQ_DISABLED_BIT)
> +#define LAZY_IRQ_FL_TEMP_DISABLE       (1 << LAZY_IRQ_TEMP_DISABLE_BIT)
> +#define LAZY_IRQ_FL_IDLE               (1 << LAZY_IRQ_IDLE_BIT)
> +#define LAZY_IRQ_FL_REAL_DISABLE       (1 << LAZY_IRQ_REAL_DISABLE_BIT)
> +
>  #ifndef __ASSEMBLY__
> +#include <linux/kernel.h>
> +
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +void update_last_hard_enable(unsigned long addr);
> +void update_last_soft_enable(unsigned long addr);
> +void update_last_hard_disable(unsigned long addr);
> +void update_last_soft_disable(unsigned long addr);
> +void update_last_preempt_disable(unsigned long addr);
> +void update_last_preempt_enable(unsigned long addr);
> +#else
> +static inline void update_last_hard_enable(unsigned long addr) { }
> +static inline void update_last_soft_enable(unsigned long addr) { }
> +static inline void update_last_hard_disable(unsigned long addr) { }
> +static inline void update_last_soft_disable(unsigned long addr) { }
> +static inline void update_last_preempt_disable(unsigned long addr) { }
> +static inline void update_last_preempt_enable(unsigned long addr) { }
> +#endif
> +
>  /*
>   * Interrupt control:
>   */
>
> -static inline unsigned long native_save_fl(void)
> +static inline unsigned long raw_native_save_fl(void)
>  {
>         unsigned long flags;
>
> @@ -26,21 +56,32 @@ static inline unsigned long native_save_fl(void)
>         return flags;
>  }
>
> -static inline void native_restore_fl(unsigned long flags)
> +static inline void raw_native_restore_fl(unsigned long flags)
>  {
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +       if ((raw_native_save_fl() ^ flags) & X86_EFLAGS_IF) {
> +               if (flags & X86_EFLAGS_IF)
> +                       update_last_hard_enable((long)__builtin_return_address(0));
> +               else
> +                       update_last_hard_disable((long)__builtin_return_address(0));
> +       }
> +#endif
> +
>         asm volatile("push %0 ; popf"
>                      : /* no output */
>                      :"g" (flags)
>                      :"memory", "cc");
>  }
>
> -static inline void native_irq_disable(void)
> +static inline void raw_native_irq_disable(void)
>  {
>         asm volatile("cli": : :"memory");
> +       update_last_hard_disable((long)__builtin_return_address(0));
>  }
>
> -static inline void native_irq_enable(void)
> +static inline void raw_native_irq_enable(void)
>  {
> +       update_last_hard_enable((long)__builtin_return_address(0));
>         asm volatile("sti": : :"memory");
>  }
>
> @@ -54,8 +95,294 @@ static inline void native_halt(void)
>         asm volatile("hlt": : :"memory");
>  }
>
> +#ifndef CONFIG_LAZY_IRQ_DISABLE
> +#define native_save_fl() raw_native_save_fl()
> +#define native_restore_fl(flags) raw_native_restore_fl(flags)
> +#define native_irq_disable() raw_native_irq_disable()
> +#define native_irq_enable() raw_native_irq_enable()
> +static inline lazy_irq_idle_enter(void)
> +{
> +       return 1;
> +}
> +static inline void lazy_irq_idle_exit(void) { }
> +static inline void print_lazy_debug(void) { }
> +static inline void print_lazy_irq(int line) { }
> +static inline void lazy_test_idle(void) { }
> +#else
> +#include <linux/bug.h>
> +
> +extern int lazy_irq_idle_enter(void);
> +extern void lazy_irq_idle_exit(void);
> +
> +void lazy_irq_bug(const char *file, int line, unsigned long flags, unsigned long raw);
> +
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +static inline void do_preempt_disable(void)
> +{
> +       unsigned long val;
> +
> +       asm volatile ("addq $1,%%gs:lazy_irq_on\n"
> +                     "movq %%gs:lazy_irq_on,%0\n" : "=r"(val) : : "memory");
> +       update_last_preempt_disable((long)__builtin_return_address(0));
> +}
> +
> +static inline void do_preempt_enable(void)
> +{
> +       unsigned long val;
> +       static int once;
> +
> +       asm volatile ("movq %%gs:lazy_irq_on,%0\n"
> +                     "subq $1,%%gs:lazy_irq_on" : "=r"(val) : : "memory");
> +       if (!once && !val) {
> +               once++;
> +               lazy_irq_bug(__func__, __LINE__, val, val);
> +       }
> +       if (!once)
> +               update_last_preempt_enable((long)__builtin_return_address(0));
> +}
> +
> +void print_lazy_debug(void);
> +void print_lazy_irq(int line);
> +void lazy_test_idle(void);
> +
> +#else
> +/*
> + * As preempt_disable is still a task variable, we need to make
> + * it a per_cpu variable for our own purposes. This can be fixed
> + * when preempt_count becomes a per cpu variable.
> + */
> +static inline void do_preempt_disable(void)
> +{
> +       asm volatile ("addq $1,%%gs:lazy_irq_on\n" : : : "memory");
> +}
> +
> +static inline void do_preempt_enable(void)
> +{
> +       asm volatile ("subq $1,%%gs:lazy_irq_on" : : : "memory");
> +}
> +
> +static inline void print_lazy_debug(void) { }
> +static inline void print_lazy_irq(int line) { }
> +static inline void lazy_test_idle(void) { }
> +
> +#endif /* CONFIG_LAZY_IRQ_DEBUG */
> +
> +void lazy_irq_simulate(void *func);
> +
> +/*
> + * Unfortunatetly, due to include hell, we can't include percpu.h.
> + * Thus, we open code our fetching and changing of per cpu variables.
> + */
> +static inline unsigned long get_lazy_irq_flags(void)
> +{
> +       unsigned long flags;
> +
> +       asm volatile ("movq %%gs:lazy_irq_disabled_flags, %0" : "=r"(flags) :: );
> +       return flags;
> +}
> +
> +static inline void * get_lazy_irq_func(void)
> +{
> +       void *func;
> +
> +       asm volatile ("movq %%gs:lazy_irq_func, %0" : "=r"(func) :: );
> +       return func;
> +}
> +
> +static inline unsigned long native_save_fl(void)
> +{
> +       unsigned long flags;
> +
> +       /*
> +        * It might be possible that if irqs are fully enabled
> +        * we could migrate. But the result of this operation
> +        * will be the same regardless if we move from one
> +        * CPU to another. That is, if flags is not zero, we
> +        * wont schedule, and we can only migrate if flags is
> +        * zero, which means it will be zero after the migrate
> +        * or scheduled back in.
> +        */
> +       flags = get_lazy_irq_flags();
> +
> +       if (flags >> LAZY_IRQ_TEMP_DISABLE_BIT)
> +               return raw_native_save_fl();
> +
> +       return flags & LAZY_IRQ_FL_DISABLED ? 0 : X86_EFLAGS_IF;
> +}
> +
> +/*
> + * Again, because of include hell, we can't include local.h, and
> + * we need to make sure we use a true "add" and "sub" that is
> + * atomic for the CPU. We can't have a load modify store, and
> + * I don't trust gcc enough to think it will do that for us.
> + */
> +static inline void lazy_irq_sub(unsigned long val)
> +{
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +       if (val > get_lazy_irq_flags())
> +               lazy_irq_bug(__func__, __LINE__,
> +                            get_lazy_irq_flags(), raw_native_save_fl());
>  #endif
>
> +       asm volatile ("subq %0, %%gs:lazy_irq_disabled_flags" : : "r"(val) : "memory");
> +}
> +
> +static inline void lazy_irq_add(unsigned long val)
> +{
> +       asm volatile ("addq %0, %%gs:lazy_irq_disabled_flags" : : "r"(val) : "memory");
> +}
> +
> +static inline void lazy_irq_sub_temp(void)
> +{
> +       lazy_irq_sub(LAZY_IRQ_FL_TEMP_DISABLE);
> +}
> +
> +static inline void lazy_irq_add_temp(void)
> +{
> +       lazy_irq_add(LAZY_IRQ_FL_TEMP_DISABLE);
> +}
> +
> +static inline void lazy_irq_sub_disable(void)
> +{
> +       update_last_soft_enable((long)__builtin_return_address(0));
> +       lazy_irq_sub(LAZY_IRQ_FL_DISABLED);
> +}
> +
> +static inline void lazy_irq_add_disable(void)
> +{
> +       update_last_soft_disable((long)__builtin_return_address(0));
> +       lazy_irq_add(LAZY_IRQ_FL_DISABLED);
> +}
> +
> +static inline void native_irq_disable(void)
> +{
> +       unsigned long flags;
> +       unsigned long raw;
> +
> +       do_preempt_disable();
> +       flags = get_lazy_irq_flags();
> +       raw = raw_native_save_fl();
> +
> +       if (flags) {
> +               /* Always disable for real not in lazy mode */
> +               if (flags >> LAZY_IRQ_TEMP_DISABLE_BIT)
> +                       raw_native_irq_disable();
> +               /* If flags is set, we already disabled preemption */
> +               do_preempt_enable();
> +               return;
> +       }
> +
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +       if (!(raw & X86_EFLAGS_IF))
> +               lazy_irq_bug(__func__, __LINE__, flags, raw);
> +#endif
> +
> +       lazy_irq_add_disable();
> +       /* Leave with preemption disabled */
> +}
> +
> +static inline void native_irq_enable(void)
> +{
> +       unsigned long flags;
> +       unsigned long raw;
> +       void *func = NULL;
> +
> +       flags = get_lazy_irq_flags();
> +       raw = raw_native_save_fl();
> +
> +       /* Do nothing if already enabled */
> +       if (!flags)
> +               goto out;
> +
> +       if (flags >> LAZY_IRQ_TEMP_DISABLE_BIT) {
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +               WARN_ON((flags & LAZY_IRQ_FL_IDLE) && (flags & LAZY_IRQ_FL_DISABLED));
> +               if ((flags & ~LAZY_IRQ_FL_IDLE) && raw_native_save_fl() & X86_EFLAGS_IF)
> +                       lazy_irq_bug(__func__, __LINE__, flags, raw);
> +#endif
> +               /*
> +                * If we temporary disabled interrupts, that means
> +                * we did so from assembly, and we want to go back
> +                * to lazy irq disable mode.
> +                */
> +               if (flags & LAZY_IRQ_FL_TEMP_DISABLE) {
> +                       lazy_irq_sub_temp();
> +                       /*
> +                        * If we are not in interrupt context, we need
> +                        * to enable irqs in lazy mode too when temp flag was set.
> +                        */
> +                       if ((flags & ~LAZY_IRQ_FL_TEMP_DISABLE) == LAZY_IRQ_FL_DISABLED)
> +                               lazy_irq_sub_disable();
> +               }
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +               if (get_lazy_irq_flags() & LAZY_IRQ_FL_DISABLED)
> +                       lazy_irq_bug(__func__, __LINE__, flags, raw);
> +#endif
> +               /*
> +                * If func is set, then interrupts was disabled when coming
> +                * in, or up to the point that we had the DISABLED flag set.
> +                * We cleared it, so it is safe to read the func, as it only
> +                * will be set when DISABLED flag set, and if that does happen
> +                * interrupts will be disabled to prevent another interrupt
> +                * coming in now.
> +                */
> +               func = get_lazy_irq_func();
> +               if (func)
> +                       lazy_irq_simulate(func); /* enables interrupts */
> +               else
> +                       raw_native_irq_enable();
> +               goto out;
> +       }
> +
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +       if (LAZY_IRQ_FL_DISABLED > get_lazy_irq_flags())
> +               lazy_irq_bug(__func__, __LINE__, flags, raw);
> +#endif
> +       lazy_irq_sub_disable();
> +       /*
> +        * Grab func *after* enabling lazy irqs, this prevents the race
> +        * where we enable the lazy irq but a interrupt comes in when
> +        * we do it and sets func. If an interrupt comes in after we
> +        * clear the DISABLED flag, it will just run the interrupt normally.
> +        */
> +       func = get_lazy_irq_func();
> +
> +       /*
> +        * If func is set, then an interrupt came in when the DISABLED
> +        * flag was set (it's no longer set), and interrupts will be
> +        * really disabled because of that. In that case, we need to
> +        * simulate the interrupt (which will enable interrupts too).
> +        */
> +       if (func) {
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +               if (raw_native_save_fl() & X86_EFLAGS_IF)
> +                       lazy_irq_bug(__func__, __LINE__, flags, raw);
> +#endif
> +               lazy_irq_simulate(func);
> +       }
> +
> +       do_preempt_enable();
> +out:
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +       if (!(raw_native_save_fl() & X86_EFLAGS_IF)) {
> +               printk("func=%pS flags=%lx\n", func, get_lazy_irq_flags());
> +               lazy_irq_bug(__func__, __LINE__, flags, raw);
> +       }
> +#endif
> +       return;
> +}
> +
> +static inline void native_restore_fl(unsigned long flags)
> +{
> +       if (flags & X86_EFLAGS_IF)
> +               native_irq_enable();
> +       else
> +               native_irq_disable();
> +}
> +#endif /* CONFIG_LAZY_IRQ_DISABLE */
> +
> +#endif /* !__ASSEMBLY__ */
> +
>  #ifdef CONFIG_PARAVIRT
>  #include <asm/paravirt.h>
>  #else
> @@ -206,4 +533,5 @@ static inline int arch_irqs_disabled(void)
>  # endif
>
>  #endif /* __ASSEMBLY__ */
> +
>  #endif
> diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
> index 4ec45b3..d981812 100644
> --- a/arch/x86/include/asm/switch_to.h
> +++ b/arch/x86/include/asm/switch_to.h
> @@ -1,6 +1,8 @@
>  #ifndef _ASM_X86_SWITCH_TO_H
>  #define _ASM_X86_SWITCH_TO_H
>
> +#include <asm/irqflags.h>
> +
>  struct task_struct; /* one of the stranger aspects of C forward declarations */
>  struct task_struct *__switch_to(struct task_struct *prev,
>                                 struct task_struct *next);
> @@ -80,7 +82,25 @@ do {                                                                 \
>
>  /* frame pointer must be last for get_wchan */
>  #define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
> -#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
> +#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; " LAZY_CONTEXT "popf\t"
> +
> +#ifdef CONFIG_LAZY_IRQ_DISABLE
> +/*
> + * When doing the context switch, the DISABLED flag should be set.
> + * But interrupts may not be disabled, and we may switch to having them
> + * disabled. Worse yet, they may be disabled and we are switching to having
> + * them enabled, and if we do that, a pending interrupt may be lost.
> + * The safest thing to do (for now) is to just set the TEMP flag and
> + * disable interrupts in the switch. This will cause the enabling to
> + * do the check for any interrupts that came in during the switch that
> + * we don't want to miss.
> + */
> +#define LAZY_CONTEXT "andq $~(1<<9),(%%rsp); orq $"    \
> +       __stringify(LAZY_IRQ_FL_TEMP_DISABLE)           \
> +       ",%%gs:lazy_irq_disabled_flags\n\t"
> +#else
> +# define LAZY_CONTEXT
> +#endif
>
>  #define __EXTRA_CLOBBER  \
>         , "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index a698d71..93e0b42 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -72,6 +72,8 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
>
>                 arch_spin_lock(&lock);
>                 printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
> +               print_lazy_irq(__LINE__);
> +               print_lazy_debug();
>                 show_regs(regs);
>                 arch_spin_unlock(&lock);
>                 cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 1b69951..8201096 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -547,6 +547,11 @@ ENTRY(ret_from_fork)
>         pushq_cfi $0x0002
>         popfq_cfi                               # reset kernel eflags
>
> +#ifdef CONFIG_LAZY_IRQ_DISABLE
> +       /* Return from fork always disables interrupts for real. */
> +       orq $LAZY_IRQ_FL_TEMP_DISABLE, PER_CPU_VAR(lazy_irq_disabled_flags)
> +#endif
> +
>         call schedule_tail                      # rdi: 'prev' task parameter
>
>         GET_THREAD_INFO(%rcx)
> @@ -973,6 +978,144 @@ END(irq_entries_start)
>  END(interrupt)
>  .previous
>
> +#ifdef CONFIG_LAZY_IRQ_DISABLE
> +
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +       .macro LAZY_DEBUG int func=0
> +       pushq %rdi
> +       pushq %rsi
> +       movq 16(%rsp), %rsi
> +       pushq %rdx
> +       pushq %rcx
> +       pushq %rax
> +       pushq %r8
> +       pushq %r9
> +       pushq %r10
> +       pushq %r11
> +       pushq %rbx
> +       pushq %rbp
> +       pushq %r12
> +       pushq %r13
> +       pushq %r14
> +       pushq %r15
> +       movq $\int, %rdi
> +       movq $\func, %rdx
> +       call lazy_irq_debug
> +       popq %r15
> +       popq %r14
> +       popq %r13
> +       popq %r12
> +       popq %rbp
> +       popq %rbx
> +       popq %r11
> +       popq %r10
> +       popq %r9
> +       popq %r8
> +       popq %rax
> +       popq %rcx
> +       popq %rdx
> +       popq %rsi
> +       popq %rdi
> +       jmp 1f
> +1:
> +       .endm
> +#if 0
> +       LAZY_DEBUG 0
> +#endif
> +#endif /* CONFIG_LAZY_IRQ_DEBUG */
> +
> +       .macro LAZY_DISABLED_CHECK func
> +       /* If in userspace, interrupts are always enabled */
> +       testl $3, 16(%rsp) /* CS is at offset 16 */
> +       jne 1f
> +       bt $LAZY_IRQ_DISABLED_BIT, PER_CPU_VAR(lazy_irq_disabled_flags)
> +       jnc 1f
> +       pushq $\func
> +       jmp irq_is_disabled
> +1:
> +       .endm
> +
> +       .macro LAZY_DISABLED_START
> +       addq  $LAZY_IRQ_FL_REAL_DISABLE, PER_CPU_VAR(lazy_irq_disabled_flags)
> +       .endm
> +
> +       .macro LAZY_DISABLED_DONE
> +       subq  $LAZY_IRQ_FL_REAL_DISABLE, PER_CPU_VAR(lazy_irq_disabled_flags)
> +       .endm
> +
> +       /*
> +        * The lazy soft disabling of interrupts is for
> +        * performance reasons, as enabling interrupts can
> +        * have a cost. But when the hardware disables
> +        * interrupts, it's rather pointless to use the soft
> +        * disabling feature.
> +        *
> +        * When a trap is hit, interrupts are disabled.
> +        * We set the TEMP flag to let the native_irq_enable()
> +        * know to really enable interrupts.
> +        */
> +       .macro LAZY_DISABLE_TRAP_ENTRY
> +       testl $(~(LAZY_IRQ_FL_TEMP_DISABLE-1)), PER_CPU_VAR(lazy_irq_disabled_flags)
> +       jne 1f
> +       addq  $LAZY_IRQ_FL_TEMP_DISABLE, PER_CPU_VAR(lazy_irq_disabled_flags)
> +
> +       /*
> +        * If interrupts are soft disabled, then make eflags disabled too.
> +        * This is required because there's lots of places that read the
> +        * regs->eflags to make decisions. Ideally, we should change all these
> +        * places to test for the soft disable flag, but for now this is
> +        * easier to do. But unfortunately, this is also the page fault handler
> +        * which is going to kill all our efforts with the lazy irq disabling :(
> +        */
> +       bt  $LAZY_IRQ_DISABLED_BIT, PER_CPU_VAR(lazy_irq_disabled_flags)
> +       jnc 1f
> +       andq $~(1<<9), EFLAGS(%rsp)
> +1:
> +       .endm
> +
> +       .macro LAZY_DISABLE_TRAP_EXIT
> +       /*
> +        * If interrupts we soft disabled or really disabled, then we
> +        * don't need to do anything. The TEMP flag will be set telling
> +        * the next native_irq_enable() to enable interrupts for real.
> +        * No need to enable them now.
> +        *
> +        * The trap really should not have cleared the TEMP flag, because
> +        * that means it enabled interrupts when trapping from a interrupt
> +        * disabled context, which would be really bad to do.
> +        */
> +       bt $9, EFLAGS(%rsp)
> +       jnc 1f
> +
> +       /*
> +        * EFLAGS has IRQs enabled, interrupts should be enabled both real
> +        * and in lazy mode, just clear the TEMP flag if it is set
> +        */
> +       bt  $LAZY_IRQ_TEMP_DISABLE_BIT, PER_CPU_VAR(lazy_irq_disabled_flags)
> +       jnc 1f
> +       subq  $LAZY_IRQ_FL_TEMP_DISABLE, PER_CPU_VAR(lazy_irq_disabled_flags)
> +
> +1:
> +       .endm
> +
> +irq_is_disabled:
> +       /* function is saved in stack */
> +       popq PER_CPU_VAR(lazy_irq_func)
> +       /* Get the vector */
> +       popq PER_CPU_VAR(lazy_irq_vector)
> +
> +
> +       andq $~(1 << 9), 16(%rsp)       /* keep irqs disabled */
> +       jmp irq_return
> +#else
> +       .macro LAZY_DISABLED_CHECK func
> +       .endm
> +#define LAZY_DISABLED_START
> +#define LAZY_DISABLED_DONE
> +#define LAZY_DISABLE_TRAP_ENTRY
> +#define LAZY_DISABLE_TRAP_EXIT
> +#endif
> +
>  /*
>   * Interrupt entry/exit.
>   *
> @@ -983,11 +1126,14 @@ END(interrupt)
>
>  /* 0(%rsp): ~(interrupt number) */
>         .macro interrupt func
> +       LAZY_DISABLED_CHECK \func
>         /* reserve pt_regs for scratch regs and rbp */
>         subq $ORIG_RAX-RBP, %rsp
>         CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
>         SAVE_ARGS_IRQ
> +       LAZY_DISABLED_START
>         call \func
> +       LAZY_DISABLED_DONE
>         .endm
>
>  /*
> @@ -1124,6 +1270,12 @@ ENTRY(retint_kernel)
>         jnc  retint_restore_args
>         bt   $9,EFLAGS-ARGOFFSET(%rsp)  /* interrupts off? */
>         jnc  retint_restore_args
> +#ifdef CONFIG_LAZY_IRQ_DISABLE
> +       /* Need to check our own preempt disabled variable */
> +       cmpl $0,PER_CPU_VAR(lazy_irq_on)
> +       jnz  retint_restore_args
> +       orq $LAZY_IRQ_FL_TEMP_DISABLE, PER_CPU_VAR(lazy_irq_disabled_flags)
> +#endif
>         call preempt_schedule_irq
>         jmp exit_intr
>  #endif
> @@ -1232,7 +1384,9 @@ ENTRY(\sym)
>         DEFAULT_FRAME 0
>         movq %rsp,%rdi          /* pt_regs pointer */
>         xorl %esi,%esi          /* no error code */
> +       LAZY_DISABLE_TRAP_ENTRY
>         call \do_sym
> +       LAZY_DISABLE_TRAP_EXIT
>         jmp error_exit          /* %ebx: no swapgs flag */
>         CFI_ENDPROC
>  END(\sym)
> @@ -1250,7 +1404,9 @@ ENTRY(\sym)
>         TRACE_IRQS_OFF
>         movq %rsp,%rdi          /* pt_regs pointer */
>         xorl %esi,%esi          /* no error code */
> +       LAZY_DISABLE_TRAP_ENTRY
>         call \do_sym
> +       LAZY_DISABLE_TRAP_EXIT
>         jmp paranoid_exit       /* %ebx: no swapgs flag */
>         CFI_ENDPROC
>  END(\sym)
> @@ -1270,7 +1426,9 @@ ENTRY(\sym)
>         movq %rsp,%rdi          /* pt_regs pointer */
>         xorl %esi,%esi          /* no error code */
>         subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
> +       LAZY_DISABLE_TRAP_ENTRY
>         call \do_sym
> +       LAZY_DISABLE_TRAP_EXIT
>         addq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
>         jmp paranoid_exit       /* %ebx: no swapgs flag */
>         CFI_ENDPROC
> @@ -1289,7 +1447,9 @@ ENTRY(\sym)
>         movq %rsp,%rdi                  /* pt_regs pointer */
>         movq ORIG_RAX(%rsp),%rsi        /* get error code */
>         movq $-1,ORIG_RAX(%rsp)         /* no syscall to restart */
> +       LAZY_DISABLE_TRAP_ENTRY
>         call \do_sym
> +       LAZY_DISABLE_TRAP_EXIT
>         jmp error_exit                  /* %ebx: no swapgs flag */
>         CFI_ENDPROC
>  END(\sym)
> @@ -1309,7 +1469,9 @@ ENTRY(\sym)
>         movq %rsp,%rdi                  /* pt_regs pointer */
>         movq ORIG_RAX(%rsp),%rsi        /* get error code */
>         movq $-1,ORIG_RAX(%rsp)         /* no syscall to restart */
> +       LAZY_DISABLE_TRAP_ENTRY
>         call \do_sym
> +       LAZY_DISABLE_TRAP_EXIT
>         jmp paranoid_exit               /* %ebx: no swapgs flag */
>         CFI_ENDPROC
>  END(\sym)
> @@ -1644,6 +1806,62 @@ ENTRY(error_exit)
>         CFI_ENDPROC
>  END(error_exit)
>
> +#ifdef CONFIG_LAZY_IRQ_DISABLE
> +/*
> + * Called with interrupts disabled.
> + * Returns enabling interrupts
> + * The calling function was kind enough to pass
> + * us the irq function and irq vector to use.
> + *
> + * This creates its own interrupt stack frame and
> + * then calls the interrupt as if the interrupt was
> + * called by hardware. It then returns via the normal
> + * interrupt return path which will enable interrupts
> + * with an iretq.
> + */
> +ENTRY(native_simulate_irq)
> +       CFI_STARTPROC
> +       /* Save the current stack pointer */
> +       movq %rsp, %rcx
> +       /* Save the stack frame as if we came from an interrupt */
> +       pushq_cfi $__KERNEL_DS
> +       pushq_cfi %rcx
> +       /* pop off the return addr for the return stack */
> +       subq $8, (%rsp)
> +       pushfq_cfi
> +       /* We want to return with interrupts enabled */
> +       addq $X86_EFLAGS_IF, (%rsp)
> +       pushq_cfi $__KERNEL_CS
> +       pushq_cfi (%rcx)
> +
> +       ASM_CLAC
> +
> +       /* Add the saved vector */
> +       pushq_cfi %rsi
> +
> +       /* Function to call is in %rdi, but that will be clobbered */
> +       movq %rdi, %rcx
> +
> +       /* Copied from interrupt macro */
> +       subq $ORIG_RAX-RBP, %rsp
> +       CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
> +       SAVE_ARGS_IRQ
> +
> +       addq  $LAZY_IRQ_FL_REAL_DISABLE, PER_CPU_VAR(lazy_irq_disabled_flags)
> +
> +       /* Call the triggered function */
> +       call *%rcx
> +
> +       subq  $LAZY_IRQ_FL_REAL_DISABLE, PER_CPU_VAR(lazy_irq_disabled_flags)
> +       /*
> +        * This will read our stack, and return
> +        * enabling interrupts.
> +        */
> +       jmp ret_from_intr
> +       CFI_ENDPROC
> +END(native_simulate_irq)
> +#endif /* CONFIG_LAZY_IRQ_DISABLE */
> +
>  /*
>   * Test if a given stack is an NMI stack or not.
>   */
> @@ -1874,7 +2092,9 @@ end_repeat_nmi:
>         /* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
>         movq %rsp,%rdi
>         movq $-1,%rsi
> +       LAZY_DISABLED_START
>         call do_nmi
> +       LAZY_DISABLED_DONE
>
>         /* Did the NMI take a page fault? Restore cr2 if it did */
>         movq %cr2, %rcx
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 3a8185c..00ba667 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -363,3 +363,311 @@ void fixup_irqs(void)
>         }
>  }
>  #endif
> +
> +#ifdef CONFIG_LAZY_IRQ_DISABLE
> +#include <linux/percpu.h>
> +#include <asm/local.h>
> +
> +/* Start out with real hard irqs disabled */
> +DEFINE_PER_CPU(local_t, lazy_irq_disabled_flags) = LOCAL_INIT(LAZY_IRQ_FL_TEMP_DISABLE);
> +DEFINE_PER_CPU(void *, lazy_irq_func);
> +DEFINE_PER_CPU(unsigned long, lazy_irq_vector);
> +EXPORT_SYMBOL(lazy_irq_disabled_flags);
> +EXPORT_SYMBOL(lazy_irq_func);
> +EXPORT_SYMBOL(lazy_irq_vector);
> +
> +DEFINE_PER_CPU(unsigned long, lazy_irq_on);
> +EXPORT_SYMBOL(lazy_irq_on);
> +
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +
> +static int update_data = 1;
> +
> +static DEFINE_PER_CPU(unsigned long, last_hard_enable);
> +static DEFINE_PER_CPU(unsigned long, last_soft_enable);
> +static DEFINE_PER_CPU(unsigned long, last_hard_disable);
> +static DEFINE_PER_CPU(unsigned long, last_soft_disable);
> +static DEFINE_PER_CPU(unsigned long, last_func);
> +
> +static DEFINE_PER_CPU(unsigned long, last_hard_enable_cnt);
> +static DEFINE_PER_CPU(unsigned long, last_soft_enable_cnt);
> +static DEFINE_PER_CPU(unsigned long, last_hard_disable_cnt);
> +static DEFINE_PER_CPU(unsigned long, last_soft_disable_cnt);
> +static DEFINE_PER_CPU(unsigned long, last_func_cnt);
> +
> +static DEFINE_PER_CPU(unsigned long, last_preempt_enable);
> +static DEFINE_PER_CPU(unsigned long, last_preempt_disable);
> +static DEFINE_PER_CPU(unsigned long, last_preempt_enable_cnt);
> +static DEFINE_PER_CPU(unsigned long, last_preempt_disable_cnt);
> +
> +atomic_t last_count = ATOMIC_INIT(0);
> +
> +#define UPDATE_LAST(type)                                              \
> +       do {                                                            \
> +               if (update_data) {                                      \
> +                       this_cpu_write(last_##type, addr);              \
> +                       this_cpu_write(last_##type##_cnt,               \
> +                                      atomic_inc_return(&last_count)); \
> +               }                                                       \
> +       } while (0)
> +
> +void notrace update_last_hard_enable(unsigned long addr)
> +{
> +       UPDATE_LAST(hard_enable);
> +}
> +EXPORT_SYMBOL(update_last_hard_enable);
> +
> +void notrace update_last_soft_enable(unsigned long addr)
> +{
> +       UPDATE_LAST(soft_enable);
> +}
> +EXPORT_SYMBOL(update_last_soft_enable);
> +
> +void notrace update_last_hard_disable(unsigned long addr)
> +{
> +       UPDATE_LAST(hard_disable);
> +}
> +EXPORT_SYMBOL(update_last_hard_disable);
> +
> +void notrace update_last_soft_disable(unsigned long addr)
> +{
> +       UPDATE_LAST(soft_disable);
> +}
> +EXPORT_SYMBOL(update_last_soft_disable);
> +
> +
> +void notrace update_last_preempt_disable(unsigned long addr)
> +{
> +       UPDATE_LAST(preempt_disable);
> +}
> +EXPORT_SYMBOL(update_last_preempt_disable);
> +
> +void notrace update_last_preempt_enable(unsigned long addr)
> +{
> +       UPDATE_LAST(preempt_enable);
> +}
> +EXPORT_SYMBOL(update_last_preempt_enable);
> +
> +void notrace update_last_func(unsigned long addr)
> +{
> +//     UPDATE_LAST(func);
> +       if (update_data) {
> +               this_cpu_write(last_func, addr);
> +               this_cpu_write(last_func_cnt, atomic_read(&last_count));
> +#if 0
> +                              atomic_inc_return(&last_count));
> +#endif
> +       }
> +}
> +
> +void notrace print_lazy_debug(void)
> +{
> +       update_data = 0;
> +       printk("Last hard enable:     (%ld) %pS\n",
> +              this_cpu_read(last_hard_enable_cnt),
> +              (void *)this_cpu_read(last_hard_enable));
> +       printk("Last soft enable:     (%ld) %pS\n",
> +              this_cpu_read(last_soft_enable_cnt),
> +              (void *)this_cpu_read(last_soft_enable));
> +       printk("Last hard disable:    (%ld) %pS\n",
> +              this_cpu_read(last_hard_disable_cnt),
> +              (void *)this_cpu_read(last_hard_disable));
> +       printk("Last soft disable:    (%ld) %pS\n",
> +              this_cpu_read(last_soft_disable_cnt),
> +              (void *)this_cpu_read(last_soft_disable));
> +       printk("Last func:            (%ld) %pS\n",
> +              this_cpu_read(last_func_cnt),
> +              (void *)this_cpu_read(last_func));
> +       printk("Last preempt enable:  (%ld) %pS\n",
> +              this_cpu_read(last_preempt_enable_cnt),
> +              (void *)this_cpu_read(last_preempt_enable));
> +       printk("Last preempt disable: (%ld) %pS\n",
> +              this_cpu_read(last_preempt_disable_cnt),
> +              (void *)this_cpu_read(last_preempt_disable));
> +       update_data = 1;
> +}
> +
> +void notrace print_lazy_irq(int line)
> +{
> +       update_data = 0;
> +       printk("[%pS:%d] raw:%lx current:%lx flags:%lx\n",
> +              __builtin_return_address(0), line,
> +              raw_native_save_fl(), native_save_fl(), get_lazy_irq_flags());
> +       update_data = 1;
> +}
> +
> +asmlinkage void notrace lazy_irq_debug(long id, long err, void *func)
> +{
> +       update_data = 0;
> +       printk("(%ld err=%lx f=%pS) flags=%lx vect=%lx func=%pS\n", id, ~err, func,
> +              get_lazy_irq_flags(),
> +              this_cpu_read(lazy_irq_vector),
> +              this_cpu_read(lazy_irq_func));
> +       update_data = 1;
> +}
> +
> +void notrace
> +lazy_irq_bug(const char *file, int line, unsigned long flags, unsigned long raw)
> +{
> +       static int once;
> +
> +       once = 1;
> +       update_data = 0;
> +       lazy_irq_add_temp();
> +       printk("FAILED HERE %s %d\n", file, line);
> +       printk("flags=%lx init_raw=%lx\n", flags, raw);
> +       printk("raw=%lx\n", raw_native_save_fl());
> +       print_lazy_debug();
> +       raw_native_irq_enable();
> +       update_data = 1;
> +       BUG();
> +}
> +EXPORT_SYMBOL(lazy_irq_bug);
> +
> +void notrace lazy_test_idle(void)
> +{
> +       unsigned long flags;
> +
> +       flags = get_lazy_irq_flags();
> +       WARN_ON(!(flags & LAZY_IRQ_FL_IDLE));
> +       WARN_ON(flags & LAZY_IRQ_FL_DISABLED);
> +}
> +
> +#else
> +static inline void update_last_func(unsigned long addr) { }
> +#endif /* CONFIG_LAZY_IRQ_DEBUG */
> +
> +#define BUG_ON_IRQS_ENABLED()                                  \
> +       do {                                                    \
> +               BUG_ON(raw_native_save_fl() & X86_EFLAGS_IF);   \
> +       } while (0)
> +
> +__init static int init_lazy_irqs(void)
> +{
> +       int cpu;
> +
> +       return 0;
> +       /* Only boot CPU needs irqs disabled */
> +       for_each_possible_cpu(cpu) {
> +               if (cpu == smp_processor_id())
> +                       continue;
> +               local_set(&per_cpu(lazy_irq_disabled_flags, cpu), 0);
> +       }
> +       return 0;
> +}
> +early_initcall(init_lazy_irqs);
> +
> +unsigned long notrace lazy_irq_flags(void)
> +{
> +       return get_lazy_irq_flags();
> +}
> +
> +/**
> + * native_simulate_irq - simulate an interrupt that triggered during lazy disable
> + * @func: The interrupt function to call.
> + * @orig_ax: The saved interrupt vector
> + *
> + * Defined in assembly, this function is used to simulate an interrupt
> + * that happened while the irq lazy disabling was in effect.
> + */
> +extern void native_simulate_irq(void *func, unsigned long orig_ax);
> +
> +void notrace lazy_irq_simulate(void *func)
> +{
> +       this_cpu_write(lazy_irq_func, NULL);
> +
> +       BUG_ON_IRQS_ENABLED();
> +
> +       update_last_func((unsigned long)func);
> +
> +       native_simulate_irq(func, this_cpu_read(lazy_irq_vector));
> +}
> +EXPORT_SYMBOL(lazy_irq_simulate);
> +
> +static inline void lazy_irq_sub_idle(void)
> +{
> +       lazy_irq_sub(LAZY_IRQ_FL_IDLE);
> +}
> +
> +static inline void lazy_irq_add_idle(void)
> +{
> +       lazy_irq_add(LAZY_IRQ_FL_IDLE);
> +}
> +
> +/**
> + * lazy_irq_idle_enter - handle lazy irq disabling entering idle
> + *
> + * When entering idle, we need to check if an interrupt came in, and
> + * if it did, then we should not go into the idle code.
> + * If no interrupt came in, we need to switch to a mode that
> + * we enable and disable interrupts for real, and turn off any
> + * lazy irq disable flags. The idle code is special as it can
> + * enter with interrupts disabled and leave with interrupts enabled
> + * via assembly.
> + */
> +int notrace lazy_irq_idle_enter(void)
> +{
> +       unsigned long flags;
> +
> +       flags = get_lazy_irq_flags();
> +
> +       /*
> +        * If interrupts are hard coded off, then simply let the
> +        * CPU do the work.
> +        */
> +       if (flags >> LAZY_IRQ_REAL_DISABLE_BIT) {
> +#ifdef CONFIG_LAZY_IRQ_DEBUG
> +               if (raw_native_save_fl() & X86_EFLAGS_IF)
> +                       lazy_irq_bug(__func__, __LINE__, flags, raw_native_save_fl());
> +               if (flags & LAZY_IRQ_FL_DISABLED)
> +                       lazy_irq_bug(__func__, __LINE__, flags, raw_native_save_fl());
> +#endif
> +               lazy_irq_add_idle();
> +               return 1;
> +       }
> +
> +       /*
> +        * Note, if there's a pending interrupt, then on real hardware
> +        * when the x86_idle() is called, it would trigger immediately.
> +        * We need to imitate that.
> +        *
> +        * Disable interrupts for real, need this anyway, as interrupts
> +        * would be enabled by the cpu idle.
> +        */
> +       if (this_cpu_read(lazy_irq_func))
> +               BUG_ON_IRQS_ENABLED();
> +
> +       /* Disable for real to prevent any races */
> +       raw_native_irq_disable();
> +
> +       if (this_cpu_read(lazy_irq_func)) {
> +               /* Process the interrupt and do not go idle */
> +               local_irq_enable();
> +               return 0;
> +       }
> +
> +       lazy_irq_add_idle();
> +
> +       flags = get_lazy_irq_flags();
> +       if (flags & LAZY_IRQ_FL_TEMP_DISABLE)
> +               lazy_irq_sub_temp();
> +       /* Interrupts will be enabled exiting x86_idle() */
> +       BUG_ON(!(flags & LAZY_IRQ_FL_DISABLED));
> +       lazy_irq_sub_disable();
> +       return 1;
> +}
> +
> +void notrace lazy_irq_idle_exit(void)
> +{
> +       lazy_irq_sub_idle();
> +       BUG_ON(get_lazy_irq_flags() || get_lazy_irq_func());
> +}
> +
> +#if 0
> +EXPORT_SYMBOL(do_preempt_disable);
> +EXPORT_SYMBOL(do_preempt_enable);
> +EXPORT_SYMBOL(native_irq_disable);
> +EXPORT_SYMBOL(native_irq_enable);
> +#endif
> +#endif /* CONFIG_LAZY_IRQ_DISABLE */
> +
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 83369e5..67c7ede 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -298,10 +298,13 @@ void arch_cpu_idle_dead(void)
>   */
>  void arch_cpu_idle(void)
>  {
> -       if (cpuidle_idle_call())
> -               x86_idle();
> -       else
> -               local_irq_enable();
> +       if (lazy_irq_idle_enter()) {
> +               if (cpuidle_idle_call())
> +                       x86_idle();
> +               else
> +                       local_irq_enable();
> +               lazy_irq_idle_exit();
> +       }
>  }
>
>  /*
> diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
> index a63efd6..7ab19e9 100644
> --- a/arch/x86/lib/thunk_64.S
> +++ b/arch/x86/lib/thunk_64.S
> @@ -8,6 +8,20 @@
>  #include <linux/linkage.h>
>  #include <asm/dwarf2.h>
>  #include <asm/calling.h>
> +#include <asm/irqflags.h>
> +
> +#ifdef CONFIG_LAZY_IRQ_DISABLE
> +       .macro LAZY_IRQ_ENTER
> +       addq  $LAZY_IRQ_FL_REAL_DISABLE, %gs:lazy_irq_disabled_flags
> +       .endm
> +
> +       .macro LAZY_IRQ_EXIT
> +       subq  $LAZY_IRQ_FL_REAL_DISABLE, %gs:lazy_irq_disabled_flags
> +       .endm
> +#else
> +# define LAZY_IRQ_ENTER
> +# define LAZY_IRQ_EXIT
> +#endif
>
>         /* rdi: arg1 ... normal C conventions. rax is saved/restored. */
>         .macro THUNK name, func, put_ret_addr_in_rdi=0
> @@ -22,7 +36,9 @@
>         movq_cfi_restore 9*8, rdi
>         .endif
>
> +       LAZY_IRQ_ENTER
>         call \func
> +       LAZY_IRQ_EXIT
>         jmp  restore
>         CFI_ENDPROC
>         .endm
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index fa6964d..da2f074 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -347,6 +347,7 @@ static int intel_idle(struct cpuidle_device *dev,
>         unsigned int cstate;
>         int cpu = smp_processor_id();
>
> +       lazy_test_idle();
>         cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
>
>         /*
> @@ -366,6 +367,7 @@ static int intel_idle(struct cpuidle_device *dev,
>                 if (!need_resched())
>                         __mwait(eax, ecx);
>         }
> +       lazy_test_idle();
>
>         if (!(lapic_timer_reliable_states & (1 << (cstate))))
>                 clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
> index 822c135..f883a74 100644
> --- a/include/linux/debug_locks.h
> +++ b/include/linux/debug_locks.h
> @@ -26,8 +26,11 @@ extern int debug_locks_off(void);
>         int __ret = 0;                                                  \
>                                                                         \
>         if (!oops_in_progress && unlikely(c)) {                         \
> -               if (debug_locks_off() && !debug_locks_silent)           \
> +               if (debug_locks_off() && !debug_locks_silent) {         \
> +                       print_lazy_irq(__LINE__);                       \
> +                       print_lazy_debug();                             \
>                         WARN(1, "DEBUG_LOCKS_WARN_ON(%s)", #c);         \
> +               }                                                       \
>                 __ret = 1;                                              \
>         }                                                               \
>         __ret;                                                          \
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 1241d8c..712672a 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -301,6 +301,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>          */
>         duration = is_softlockup(touch_ts);
>         if (unlikely(duration)) {
> +               static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
> +
>                 /*
>                  * If a virtual machine is stopped by the host it can look to
>                  * the watchdog like a soft lockup, check to see if the host
> @@ -313,6 +315,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>                 if (__this_cpu_read(soft_watchdog_warn) == true)
>                         return HRTIMER_RESTART;
>
> +               arch_spin_lock(&lock);
>                 printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
>                         smp_processor_id(), duration,
>                         current->comm, task_pid_nr(current));
> @@ -322,6 +325,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>                         show_regs(regs);
>                 else
>                         dump_stack();
> +               arch_spin_unlock(&lock);
> +
> +               trigger_all_cpu_backtrace();
>
>                 if (softlockup_panic)
>                         panic("softlockup: hung tasks");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
