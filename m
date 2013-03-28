Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3C1Pmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:42:55 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51116 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3C1Pmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:42:52 -0400
Message-ID: <51546466.8000601@linux.vnet.ibm.com>
Date: Thu, 28 Mar 2013 21:10:22 +0530
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
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [patch 29/34] sh: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130321215235.216323644@linutronix.de>
In-Reply-To: <20130321215235.216323644@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032815-5564-0000-0000-00000746576D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 03:23 AM, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> ---
[...]

> -/*
> - * The idle thread. There's no useful work to be done, so just try to conserve
> - * power and have a low exit latency (ie sit in a loop waiting for somebody to
> - * say that they'd like to reschedule)
> - */
> -void cpu_idle(void)
> +void arch_cpu_idle(void)
>  {
> -	unsigned int cpu = smp_processor_id();
> -
> -	set_thread_flag(TIF_POLLING_NRFLAG);
> -
> -	/* endless idle loop with no priority at all */
> -	while (1) {
> -		tick_nohz_idle_enter();
> -		rcu_idle_enter();
> -
> -		while (!need_resched()) {
> -			check_pgt_cache();
> -			rmb();
> -
> -			if (cpu_is_offline(cpu))
> -				play_dead();
> -
> -			local_irq_disable();
> -			/* Don't trace irqs off for idle */
> -			stop_critical_timings();
> -			if (cpuidle_idle_call())
> -				sh_idle();
> -			/*
> -			 * Sanity check to ensure that sh_idle() returns
> -			 * with IRQs enabled
> -			 */
> -			WARN_ON(irqs_disabled());
> -			start_critical_timings();
> -		}
> -
> -		rcu_idle_exit();
> -		tick_nohz_idle_exit();
> -		schedule_preempt_disabled();
> -	}
> +	if (cpuidle_idle_call())
> +		sh_idle();
>  }
> 

Missing call to play_dead(). Perhaps you can fold the following diff:


diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 8b9d5d7..2ea4483 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -33,6 +33,11 @@ void default_idle(void)
 	clear_bl_bit();
 }
 
+void arch_cpu_idle_dead(void)
+{
+	play_dead();
+}
+
 void arch_cpu_idle(void)
 {
 	if (cpuidle_idle_call())


Regards,
Srivatsa S. Bhat

