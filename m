Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3C1Pmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:42:39 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60025 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab3C1Pmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:42:38 -0400
Message-ID: <51546452.3090408@linux.vnet.ibm.com>
Date: Thu, 28 Mar 2013 21:10:02 +0530
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
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [patch 26/34] powerpc: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130321215235.026838003@linutronix.de>
In-Reply-To: <20130321215235.026838003@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032815-8256-0000-0000-000006D7EA8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 03:23 AM, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
[...]
> Index: linux-2.6/arch/powerpc/kernel/idle.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/idle.c
> +++ linux-2.6/arch/powerpc/kernel/idle.c
> @@ -50,64 +50,30 @@ static int __init powersave_off(char *ar
>  }
>  __setup("powersave=off", powersave_off);
> 
> -/*
> - * The body of the idle task.
> - */
> -void cpu_idle(void)
> +void arch_cpu_idle(void)
>  {
> -	set_thread_flag(TIF_POLLING_NRFLAG);
> -	while (1) {
> -		tick_nohz_idle_enter();
> -		rcu_idle_enter();
> -
> -		while (!need_resched() && !cpu_should_die()) {
> -			ppc64_runlatch_off();
> -
> -			if (ppc_md.power_save) {
> -				clear_thread_flag(TIF_POLLING_NRFLAG);
> -				/*
> -				 * smp_mb is so clearing of TIF_POLLING_NRFLAG
> -				 * is ordered w.r.t. need_resched() test.
> -				 */
> -				smp_mb();
> -				local_irq_disable();
> -
> -				/* Don't trace irqs off for idle */
> -				stop_critical_timings();
> -
> -				/* check again after disabling irqs */
> -				if (!need_resched() && !cpu_should_die())
> -					ppc_md.power_save();
> -
> -				start_critical_timings();
> -
> -				/* Some power_save functions return with
> -				 * interrupts enabled, some don't.
> -				 */
> -				if (irqs_disabled())
> -					local_irq_enable();
> -				set_thread_flag(TIF_POLLING_NRFLAG);
> -
> -			} else {
> -				/*
> -				 * Go into low thread priority and possibly
> -				 * low power mode.
> -				 */
> -				HMT_low();
> -				HMT_very_low();
> -			}
> -		}
> -
> -		HMT_medium();
> -		ppc64_runlatch_on();
> -		rcu_idle_exit();
> -		tick_nohz_idle_exit();
> -		if (cpu_should_die()) {
> -			sched_preempt_enable_no_resched();
> -			cpu_die();
> -		}
> -		schedule_preempt_disabled();
> +	ppc64_runlatch_off();
> +
> +	if (ppc_md.power_save) {
> +		ppc_md.power_save();
> +		/*
> +		 * Some power_save functions return with
> +		 * interrupts enabled, some don't.
> +		 */
> +		if (irqs_disabled())
> +			local_irq_enable();
> +	} else {
> +		local_irq_enable();
> +		/*
> +		 * Go into low thread priority and possibly
> +		 * low power mode.
> +		 */
> +		HMT_low();
> +		HMT_very_low();
>  	}
> +
> +	HMT_medium();
> +	ppc64_runlatch_on();
>  }
> 


The call to cpu_die() seems to be missing. And considering this commit,

commit a7c2bb8279d20d853e43c34584eaf2b039de8026
Author: Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Date:   Wed Aug 4 18:28:33 2010 +0000

    powerpc: Re-enable preemption before cpu_die()

we need to call it with preempt enabled. So how about folding the
following diff with this patch?


diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index b751baa..e434fb9 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -33,11 +33,6 @@
 #include <asm/runlatch.h>
 #include <asm/smp.h>
 
-#ifdef CONFIG_HOTPLUG_CPU
-#define cpu_should_die()	cpu_is_offline(smp_processor_id())
-#else
-#define cpu_should_die()	0
-#endif
 
 unsigned long cpuidle_disable = IDLE_NO_OVERRIDE;
 EXPORT_SYMBOL(cpuidle_disable);
@@ -50,6 +45,12 @@ static int __init powersave_off(char *arg)
 }
 __setup("powersave=off", powersave_off);
 
+void arch_cpu_idle_dead(void)
+{
+	sched_preempt_enable_no_resched();
+	cpu_die();
+}
+
 void arch_cpu_idle(void)
 {
 	ppc64_runlatch_off();

 
Regards,
Srivatsa S. Bhat

