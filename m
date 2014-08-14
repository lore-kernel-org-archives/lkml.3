Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaHNKst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:48:49 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:59157 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaHNKsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:48:47 -0400
Message-ID: <53EC9404.5010908@linaro.org>
Date: Thu, 14 Aug 2014 11:48:36 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v8 4/4] ARM: Add KGDB/KDB FIQ debugger generic code
References: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org> <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org> <1404979427-12943-5-git-send-email-daniel.thompson@linaro.org> <20140813214525.GQ30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140813214525.GQ30401@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/14 22:45, Russell King - ARM Linux wrote:
> On Thu, Jul 10, 2014 at 09:03:47AM +0100, Daniel Thompson wrote:
>> From: Anton Vorontsov <anton.vorontsov@linaro.org>
>>
>> The FIQ debugger may be used to debug situations when the kernel stuck
>> in uninterruptable sections, e.g. the kernel infinitely loops or
>> deadlocked in an interrupt or with interrupts disabled.
>>
>> By default KGDB FIQ is disabled in runtime, but can be enabled with
>> kgdb_fiq.enable=1 kernel command line option.
> 
> I know you've been around the loop on this patch set quite a number of
> times.  However, there are two issues.  The first is a simple concern,
> the second is more a design decision...
> 
> I've recently been hitting a problem on iMX6Q with a irqs-off deadlock
> on CPU0 (somehow, it always hit CPU0 every time I tested.)  This wasn't
> particularly good as it prevented much in the way of diagnosis.
> 
> Of course, things like the spinlock lockup fired... but nothing could
> give me a trace from CPU0.
> 
> On x86, they have this fixed by using the NMI to trigger a backtrace
> on all CPUs when a RCU lockup or spinlock lockup occurs.  There's a
> generic hook for this called arch_trigger_all_cpu_backtrace().
> 
> So, I set about using the contents of some of your patches to implement
> this for ARM, and I came out with something which works.  In doing this,
> I started wondering whether the default FIQ handler should not be just
> "subs pc, lr, #4" but mostly your FIQ assembly code you have below.
> This, along with your GIC patches to move all IRQs to group 1, then
> gives us a way to send a FIQ IPI to CPUs in the system - and the FIQ
> IPI could be caught and used to dump a backtrace.
> 
> Here's the changes I did for that, which are a tad hacky:
> 
> irq-gic.c - SGI 8 gets used to trigger a backtrace.  Note it must be
> high priority too.
> 
> gic_cpu_init()
> +       /*
> +        * Set all PPI and SGI interrupts to be group 1.
> +        *
> +        * If grouping is not available (not implemented or prohibited by
> +        * security mode) these registers are read-as-zero/write-ignored.
> +        */
> +       writel_relaxed(0xfffffeff, dist_base + GIC_DIST_IGROUP + 0);
> +       writel_relaxed(0xa0a0a000, dist_base + GIC_DIST_PRI + 8);
> 
> gic_raise_softirq()
> +       softirq = map << 16 | irq;
> +       if (irq != 8)
> +               softirq |= 0x8000;
> +

Let me dig out some of my patches in this area.

I've added an IPI to be used to quiesce the CPUs for KGDB. My code is in
essence the same as yours but uses a bitmask for the IPIs that should be
delivered using FIQ (in fact I wrote that deliberately to leave space to
easily implement arch_trigger_all_cpu_backtrace() )

> arch/arm/kernel/smp.c:
> +/* For reliability, we're prepared to waste bits here. */
> +static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
> +
> ...
> +static void ipi_cpu_backtrace(struct pt_regs *regs)
> +{
> +       int cpu = smp_processor_id();
> +
> +       if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
> +               static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
> +
> +               arch_spin_lock(&lock);
> +               printk(KERN_WARNING "FIQ backtrace for cpu %d\n", cpu);
> +               show_regs(regs);
> +               arch_spin_unlock(&lock);
> +               cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
> +       }
> +}
> +
> ...
> +void arch_trigger_all_cpu_backtrace(bool include_self)
> +{
> +       static unsigned long backtrace_flag;
> +       int i, cpu = get_cpu();
> +
> +       if (test_and_set_bit(0, &backtrace_flag)) {
> +               /*
> +                * If there is already a trigger_all_cpu_backtrace() in progress
> +                * (backtrace_flag == 1), don't output double cpu dump infos.
> +                */
> +               put_cpu();
> +               return;
> +       }
> +
> +       cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
> +       if (!include_self)
> +               cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
> +
> +       if (!cpumask_empty(to_cpumask(backtrace_mask))) {
> +               pr_info("Sending FIQ to %s CPUs:\n",
> +                       (include_self ? "all" : "other"));
> +               smp_cross_call(to_cpumask(backtrace_mask), IPI_CPU_BACKTRACE);
> +       }
> +
> +       /* Wait for up to 10 seconds for all CPUs to do the backtrace */
> +       for (i = 0; i < 10 * 1000; i++) {
> +               if (cpumask_empty(to_cpumask(backtrace_mask)))
> +                       break;
> +
> +               mdelay(1);
> +       }
> +
> +       clear_bit(0, &backtrace_flag);
> +       smp_mb__after_atomic();
> +       put_cpu();
> +}
> +
> +void __fiq_handle(struct pt_regs *regs)
> +{
> +       ipi_cpu_backtrace(regs);
> +}
> 
> arch/arm/kernel/setup.c:
> +static unsigned int fiq_stack[4][1024];
> +
> ...
> cpu_init()
> -       "msr    cpsr_c, %7"
> +       "msr    cpsr_c, %7\n\t"
> +       "mov    sp, %8\n\t"
> +       "msr    cpsr_c, %9"
> ...
> +             PLC (PSR_F_BIT | PSR_I_BIT | FIQ_MODE),
> +             "r" (&fiq_stack[cpu][1024]),
> 
> The FIQ assembly code is basically the same as yours, but with:
> 
> +       .macro  fiq_handler
> +       bl      __fiq_handle
> +       .endm
> 
> and the code in svc_exit_via_fiq testing the PSR I flag and calling
> trace_hardirqs_on removed.
> 
> This does have one deficiency, and that is it doesn't EOI the FIQ
> interrupt - that's something which should be fixed, but for my
> purposes to track down where the locked CPU was, it wasn't strictly
> necessary that the system continued to work after this point.

EOIing IPIs should be pretty easy (it is safe to EOI them immediately
after the ack). This is also included in my existing IPI patches.


> This brings me to my second concern, and is the reason I decided not
> to ask for it for this merge window.
> 
> Calling the trace_* functions is a no-no from FIQ code.
> trace_hardirqs_on() can itself take locks, which can result in a
> deadlock.
> 
> I thought I'd made it clear that FIQ code can't take locks because
> there's no way of knowing what state they're in at the point that the
> FIQ fires - _irq() variants won't save you - and that's kind of the
> point of FIQ.  It's almost never masked by the kernel.

Don't worry, you certainly did make it clear!

I actually went as far as removing the trace_* calls before having a
change of heart. As a result I spent some time looking at the
trace_hardirqs_on() code and, as far as I remember, I couldn't find a
lock in the code that wasn't bypassed when in_nmi() returned true.

However the code is pretty complex and its certainly possible that I
missed something. Are you in a position to point any particular lock to
show I messed this up or are you working from memory?


> Now, You'll be forgiven if you now point out that in the code above,
> I'm taking a spinlock.  That's absolutely true.  Analyse the code
> a little closer and you'll notice it's done in a safe way.  There's
> only one time where that spinlock is taken and that's from FIQ code,
> never from any other code, and only once per CPU - notice how
> arch_trigger_all_cpu_backtrace() protects itself against multiple
> callers, and how ipi_cpu_backtrace() is careful to check that its
> CPU bit is set.  This is exactly the same method which x86 code uses
> (in fact, much of the above code was stolen from x86!)

Agreed. I also plan to use FIQ-safe locks in the GIC code to raise an
IPI. The b.L switcher code explicitly calls local_fiq_disable() so
providing the locks are contested only between the b.L switcher logic
and FIQ handlers it will be safe.

That said my original approach (again, I'll post it in a moment) was
pretty ugly which is why I'm so pleased with Stephen Boyd's recently
proposed change.


> So, how about moving the FIQ assembly code to entry-armv.S and making
> it less kgdb specific?  (Though... we do want to keep a /very/ close
> eye on users to ensure that they don't do silly stuff with locking.)

I think I can do that.

Something like this?

1. Install the current trap handler code by default (either with or
   without trace_* calls).

2. Have default trap handler call an RCU notifier chain to allow it to
   hook up with "normal" code without any hard coding (kgdb, IPI
   handling, etc)

3. Retain existing install_fiq() behaviour for people who want FIQ
   to be a fast-interrupt rather than an NMI (for example, the
   Raspberry pi USB optimizations).

4. Ensure default handler is an exported symbol to allow the meths
   drinkers from #3 to chain to logic for NMI/debug features
   if they want to.


Daniel.
