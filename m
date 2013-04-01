Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab3DAG4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:56:17 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50597 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab3DAG4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:56:14 -0400
Message-ID: <51592EF1.4090302@linux.vnet.ibm.com>
Date: Mon, 01 Apr 2013 12:23:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] sparc: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130329161905.GC6201@merkur.ravnborg.org> <20130329202926.GA9484@merkur.ravnborg.org>
In-Reply-To: <20130329202926.GA9484@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040106-2000-0000-0000-00000B901A32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 01:59 AM, Sam Ravnborg wrote:
> Add generic cpu_idle support
> 
> sparc32:
> - replace call to cpu_idle() with cpu_startup_entry()
> - add arch_cpu_idle()
> 
> sparc64:
> - smp_callin() includes cpu_startup_entry() call so we can
>   skip calling cpu_idle from assembler
> - add arch_cpu_idle_enter() and arch_cpu_idle_dead()
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: David S. Miller <davem@davemloft.net>
> 
> ---
> This patch is on top of smp/testing in the tip tree.
> It is build tested on sparc32 + sparc64
> 
> 	Sam
> 
[...]
> 
> diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
> index 62eede1..ec92959 100644
> --- a/arch/sparc/kernel/process_32.c
> +++ b/arch/sparc/kernel/process_32.c
> @@ -64,23 +64,13 @@ extern void fpsave(unsigned long *, unsigned long *, void *, unsigned long *);
>  struct task_struct *last_task_used_math = NULL;
>  struct thread_info *current_set[NR_CPUS];
> 
> -/*
> - * the idle loop on a Sparc... ;)
> - */
> -void cpu_idle(void)
> +/* the idle loop on a Sparc... ;) */
> +void arch_cpu_idle(void)
>  {
> -	set_thread_flag(TIF_POLLING_NRFLAG);
> -
> -	/* endless idle loop with no priority at all */
> -	for (;;) {
> -		while (!need_resched()) {
> -			if (sparc_idle)
> -				(*sparc_idle)();
> -			else
> -				cpu_relax();
> -		}
> -		schedule_preempt_disabled();
> -	}
> +	if (sparc_idle)
> +		(*sparc_idle)();
> +	else
> +		cpu_relax();
>  }

You need to enable interrupts when coming out in the 'else' case,
because we enter with interrupts disabled and expect to come out
of arch_cpu_idle() with interrupts enabled. (Otherwise you'll hit
that WARN_ON() in the generic code). Thomas has handled a similar
case in the mips patch.

> 
>  /* XXX cli/sti -> local_irq_xxx here, check this works once SMP is fixed. */
> diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
> index cdb80b2..5ed6b02 100644
> --- a/arch/sparc/kernel/process_64.c
> +++ b/arch/sparc/kernel/process_64.c
> @@ -52,8 +52,13 @@
> 
>  #include "kstack.h"
> 
> -static void sparc64_yield(int cpu)
> +/* The idle loop on sparc64. */
> +void arch_cpu_idle_enter()
>  {
> +	int cpu;
> +
> +	cpu = smp_processor_id();
> +
>  	if (tlb_type != hypervisor) {
>  		touch_nmi_watchdog();
>  		return;
> @@ -88,31 +93,10 @@ static void sparc64_yield(int cpu)
>  	set_thread_flag(TIF_POLLING_NRFLAG);
>  }
> 

Hmm, this looks weird. The contents of this function should have
been inside arch_cpu_idle() (not arch_cpu_idle_enter). And it is
unnecessary to set/clear POLLING flags here, since they are handled
in the generic code. (Same is the case with the need_resched and
the cpu_is_offline check).

I agree that the naming is a little subtle, but in the current
scheme of things in this patchset, arch_cpu_idle_enter() is what
you call to do initialization _before_ you perform cpu idle, whereas
arch_cpu_idle() is the function that is supposed to do the actual
arch-specific idling.

Regards,
Srivatsa S. Bhat

> -/* The idle loop on sparc64. */
> -void cpu_idle(void)
> +void arch_cpu_idle_dead()
>  {
> -	int cpu = smp_processor_id();
> -
> -	set_thread_flag(TIF_POLLING_NRFLAG);
> -
> -	while(1) {
> -		tick_nohz_idle_enter();
> -		rcu_idle_enter();
> -
> -		while (!need_resched() && !cpu_is_offline(cpu))
> -			sparc64_yield(cpu);
> -
> -		rcu_idle_exit();
> -		tick_nohz_idle_exit();
> -
> -#ifdef CONFIG_HOTPLUG_CPU
> -		if (cpu_is_offline(cpu)) {
> -			sched_preempt_enable_no_resched();
> -			cpu_play_dead();
> -		}
> -#endif
> -		schedule_preempt_disabled();
> -	}
> +	sched_preempt_enable_no_resched();
> +	cpu_play_dead();
>  }

