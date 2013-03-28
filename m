Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3C1PpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:45:19 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:36298 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3C1PpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:45:13 -0400
Message-ID: <515464EB.1090809@linux.vnet.ibm.com>
Date: Thu, 28 Mar 2013 21:12:35 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [patch 22/34] mips: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130321215234.754954871@linutronix.de>
In-Reply-To: <20130321215234.754954871@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032815-9574-0000-0000-0000073E1831
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 03:23 AM, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> ---
>  arch/mips/Kconfig          |    1 
>  arch/mips/kernel/process.c |   46 ++++++++++++---------------------------------
>  arch/mips/kernel/smp.c     |    2 -
>  3 files changed, 15 insertions(+), 34 deletions(-)
>
[...]
 
> Index: linux-2.6/arch/mips/kernel/process.c
> ===================================================================
> --- linux-2.6.orig/arch/mips/kernel/process.c
> +++ linux-2.6/arch/mips/kernel/process.c
> @@ -41,44 +41,24 @@
>  #include <asm/inst.h>
>  #include <asm/stacktrace.h>
> 
> -/*
> - * The idle thread. There's no useful work to be done, so just try to conserve
> - * power and have a low exit latency (ie sit in a loop waiting for somebody to
> - * say that they'd like to reschedule)
> - */
> -void __noreturn cpu_idle(void)
> +void arch_cpu_idle_dead(void)
>  {
> -	int cpu;
> -
> -	/* CPU is going idle. */
> -	cpu = smp_processor_id();
> +	/* What the heck is this check doing ? */
> +	if (!cpu_isset(cpu, cpu_callin_map))
> +		play_dead();}

Extra closing brace?

> +}
> 
> -	/* endless idle loop with no priority at all */
> -	while (1) {
> -		tick_nohz_idle_enter();
> -		rcu_idle_enter();
> -		while (!need_resched() && cpu_online(cpu)) {
> +void arch__cpu_idle(void)

s/arch__cpu_idle/arch_cpu_idle (single underscore)


Regards,
Srivatsa S. Bhat

> +{
>  #ifdef CONFIG_MIPS_MT_SMTC
> -			extern void smtc_idle_loop_hook(void);
> +	extern void smtc_idle_loop_hook(void);
> 
> -			smtc_idle_loop_hook();
> +	smtc_idle_loop_hook();
>  #endif
> -
> -			if (cpu_wait) {
> -				/* Don't trace irqs off for idle */
> -				stop_critical_timings();
> -				(*cpu_wait)();
> -				start_critical_timings();
> -			}
> -		}
> -#ifdef CONFIG_HOTPLUG_CPU
> -		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
> -			play_dead();
> -#endif
> -		rcu_idle_exit();
> -		tick_nohz_idle_exit();
> -		schedule_preempt_disabled();
> -	}
> +	if (cpu_wait)
> +		(*cpu_wait)();
> +	else
> +		local_irq_enable();
>  }
> 

