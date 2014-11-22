Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaKVAvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 19:51:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:60092 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaKVAvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 19:51:10 -0500
Date: Sat, 22 Nov 2014 01:50:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Emmanuel Berthier <emmanuel.berthier@intel.com>
cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, robert.jarzmik@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [LBR] Dump LBRs on Oops
In-Reply-To: <1416589419-9952-1-git-send-email-emmanuel.berthier@intel.com>
Message-ID: <alpine.DEB.2.11.1411212240390.6439@nanos>
References: <1416589419-9952-1-git-send-email-emmanuel.berthier@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Emmanuel Berthier wrote:

> The purpose of this patch is to stop LBR at the early stage of
> Exception Handling, and dump its content later in the dumpstack
> process.

And that's useful in what way? The changelog should not tell WHAT the
patch does. It should tell WHY it is useful and what are the
usecases/benefits. Neither does it tell how that feature can be
used/enabled/disabled and how it provides useful information.

Where is that sample output which demonstrates that this is something
which adds debugging value rather than another level of pointless
featuritis?

> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -4,7 +4,9 @@
>  #include <asm/perf_event.h>
>  #include <asm/msr.h>
>  #include <asm/insn.h>
> -
> +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> +#include <asm/processor.h>
> +#endif

We just can include that file unconditionally.

>  #include "perf_event.h"
>  
>  enum {
> @@ -135,6 +137,9 @@ static void __intel_pmu_lbr_enable(void)
>  	u64 debugctl;
>  	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>  
> +	if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION))
> +		lbr_dump_on_exception = 0;

With certain compilers you might get a surprise here, because they are
too stupid to remove that 'lbr_dump_on_exception = 0;' right
away. They kill it in the optimization phase. So they complain about
lbr_dump_on_exception not being defined.

So you need something like this:

static inline void lbr_set_dump_on_oops(bool enable)
{
#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
       ....
#endif
}

and make that

     if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION))
             lbr_set_dump_on_oops(false);

which is completely pointless as you can just call

      lbr_set_dump_on_oops(false);

unconditionally and be done with it.

IS_ENABLED(CONFIG_XXX) is not a proper solution for all problems. It
can avoid #ifdefs, but it also can introduce interesting nonsense.

>  	if (cpuc->lbr_sel)
>  		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
>  
> @@ -147,6 +152,9 @@ static void __intel_pmu_lbr_disable(void)
>  {
>  	u64 debugctl;
>  
> +	if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION))
> +		lbr_dump_on_exception = 1;

Now the even more interesting question is, WHY is
lbr_dump_on_exception enabled in __intel_pmu_lbr_disable and disabled
in __intel_pmu_lbr_enable?

This obviously lacks a understandable comment, but before you
elaborate on this see the next comment.

> +void show_lbrs(void)
> +{
> +	if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION)) {
> +		u64 debugctl;
> +		int i, lbr_on;
> +
> +		rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +		lbr_on = debugctl & DEBUGCTLMSR_LBR;
> +
> +		pr_info("Last Branch Records:");
> +		if (!lbr_dump_on_exception) {
> +			pr_cont(" (Disabled by perf_event)\n");

So, if perf uses LBR we do not print it? What a weird design
decision. If the machine crashes, we want that information no matter
whether perf is active or not. What kind of twisted logic is that?

> +		} else if (x86_pmu.lbr_nr == 0) {
> +			pr_cont(" (x86_model unknown, check intel_pmu_init())\n");

Huch? Why we get here if the pmu does not support it at all? Why
should we bother to print it? If it's not printed it's not
available. It's that simple.

> +		} else if (lbr_on) {
> +			pr_cont(" (not halted)\n");

Why would it be not halted? Code comments are optional, right?

> +		} else {
> +			struct cpu_hw_events *cpuc =
> +						this_cpu_ptr(&cpu_hw_events);

A simple #ifdef would have saved you an indentation level and actually
made that code readable. IS_ENABLED() is a proper hammer for some
things but not everything is a nail.

> +			intel_pmu_lbr_read_64(cpuc);
> +
> +			pr_cont("\n");
> +			for (i = 0; i < cpuc->lbr_stack.nr; i++) {
> +				pr_info("   to: [<%016llx>] ",
> +						cpuc->lbr_entries[i].to);
> +				print_symbol("%s\n", cpuc->lbr_entries[i].to);
> +				pr_info(" from: [<%016llx>] ",
> +						cpuc->lbr_entries[i].from);
> +				print_symbol("%s\n", cpuc->lbr_entries[i].from);
> +			}
> +		}
> +	}
> +}
> +
>  void show_regs(struct pt_regs *regs)
>  {
>  	int i;
> @@ -314,10 +352,15 @@ void show_regs(struct pt_regs *regs)
>  		unsigned char c;
>  		u8 *ip;
>  
> +		/*
> +		 * Called before show_stack_log_lvl() as it could trig
> +		 * page_fault and reenable LBR

Huch? The kernel stack dump is going to page fault? If that happens
then you are in deep shit anyway. I doubt that anything useful gets
out of the machine at this point, LBR or not.

Aside of that if we want to debug with the LBR then we better freeze
that whole thing across a dump and be done with it.

> +		 */
> +		show_lbrs();

> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index df088bb..120e989 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1035,6 +1035,42 @@ apicinterrupt IRQ_WORK_VECTOR \
>  	irq_work_interrupt smp_irq_work_interrupt
>  #endif
>  
> +.macro STOP_LBR
> +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> +	testl $1, lbr_dump_on_exception
> +	jz 1f
> +	push %rax
> +	push %rcx
> +	push %rdx
> +	movl $MSR_IA32_DEBUGCTLMSR, %ecx
> +	rdmsr
> +	and $~1, %eax	/* Disable LBR recording */
> +	wrmsr
> +	pop %rdx
> +	pop %rcx
> +	pop %rax
> +1:
> +#endif
> +.endm
> +
> +.macro START_LBR
> +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> +	testl $1, lbr_dump_on_exception
> +	jz 1f
> +	push %rax
> +	push %rcx
> +	push %rdx
> +	movl $MSR_IA32_DEBUGCTLMSR, %ecx
> +	rdmsr
> +	or $1, %eax		/* Enable LBR recording */

This is really brilliant. So the logic here is:

Perf uses LBR  	LBR state at 	 LBR state at	Dump
     	  	exception entry	 exception exit	  

Yes		No change	 No change	No

No		off -> off or	 off -> on	empty
		on  -> off 	 off -> on    	perhaps useful

So how does LBR get magically enabled?

   By producing fault #1 and then on the exception exit enabling
   LBR so that fault #2 can provide data?
   
   That's the only way I can see how to do that if you are not
   magically tweaking MSR_IA32_DEBUGCTLMSR from user space.

   Now that magically works, because you add that stuff into all
   exception entry/exit stubs.

   So it will be enabled magically no matter what and it will also be
   enabled unconditonally on any machine whether it supports that
   feature or not. That's the whole reason why you have no 32bit
   support for this yet.

How is that thing useful when perf uses LBR?

   Not at all. We do not gain anything. We explode and have no value
   at all.

Aside of that what is setting the proper options for LBR recording in
MSR_LBR_SELECT, if available?

   Nothing, which is useless as well, as the dump might just conatin
   completely useless crap. There is a reason why haswell introduced
   LBR filtering.

So what's the point of this?

Thanks,

	tglx
