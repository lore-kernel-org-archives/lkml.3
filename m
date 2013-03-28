Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3C1Pk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:40:29 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50568 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab3C1Pk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:40:27 -0400
Message-ID: <515463D4.60501@linux.vnet.ibm.com>
Date: Thu, 28 Mar 2013 21:07:56 +0530
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
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [patch 07/34] alpha: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130321215233.766017538@linutronix.de>
In-Reply-To: <20130321215233.766017538@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032815-8878-0000-0000-0000067CD69A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 03:23 AM, Thomas Gleixner wrote:
> The core provides a generic idle poll loop.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> ---
>  arch/alpha/Kconfig          |    1 +
>  arch/alpha/kernel/process.c |   19 -------------------
>  arch/alpha/kernel/smp.c     |    3 +--
>  3 files changed, 2 insertions(+), 21 deletions(-)
> 
> Index: linux-2.6/arch/alpha/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/alpha/Kconfig
> +++ linux-2.6/arch/alpha/Kconfig
> @@ -17,6 +17,7 @@ config ALPHA
>  	select ARCH_WANT_IPC_PARSE_VERSION
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
>  	select GENERIC_SMP_IDLE_THREAD
> +	select GENERIC_IDLE_LOOP
>  	select GENERIC_CMOS_UPDATE
>  	select GENERIC_STRNCPY_FROM_USER
>  	select GENERIC_STRNLEN_USER
> Index: linux-2.6/arch/alpha/kernel/process.c
> ===================================================================
> --- linux-2.6.orig/arch/alpha/kernel/process.c
> +++ linux-2.6/arch/alpha/kernel/process.c
> @@ -46,25 +46,6 @@
>  void (*pm_power_off)(void) = machine_power_off;
>  EXPORT_SYMBOL(pm_power_off);
> 
> -void
> -cpu_idle(void)
> -{
> -	current_thread_info()->status |= TS_POLLING;
> -
> -	while (1) {
> -		/* FIXME -- EV6 and LCA45 know how to power down
> -		   the CPU.  */
> -
> -		rcu_idle_enter();
> -		while (!need_resched())
> -			cpu_relax();
> -
> -		rcu_idle_exit();
> -		schedule_preempt_disabled();
> -	}
> -}
> -
> -

(In all my replies, I'm referring to the code in your v2 on your git
tree, but replying to the corresponding patches in your v1).

So, in alpha, we poll in cpu idle. In the generic implementation in
kernel/cpu/idle.c, arch_cpu_idle() is defined as:

void __weak arch_cpu_idle(void)
{
        cpu_idle_poll();
}

Should it not have been:

void __weak arch_cpu_idle(void)
{
	current_set_polling();
        cpu_idle_poll();
	current_clr_polling();
}

instead?

Regards,
Srivatsa S. Bhat

>  struct halt_info {
>  	int mode;
>  	char *restart_cmd;
> Index: linux-2.6/arch/alpha/kernel/smp.c
> ===================================================================
> --- linux-2.6.orig/arch/alpha/kernel/smp.c
> +++ linux-2.6/arch/alpha/kernel/smp.c
> @@ -167,8 +167,7 @@ smp_callin(void)
>  	      cpuid, current, current->active_mm));
> 
>  	preempt_disable();
> -	/* Do nothing.  */
> -	cpu_idle();
> +	cpu_startup_entry(CPUHP_ONLINE);
>  }
> 
>  /* Wait until hwrpb->txrdy is clear for cpu.  Return -1 on timeout.  */
> 
> 


