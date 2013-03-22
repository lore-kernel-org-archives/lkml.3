Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab3CVKQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:16:47 -0400
Received: from multi.imgtec.com ([194.200.65.239]:46415 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510Ab3CVKQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:16:44 -0400
Message-ID: <514C2F88.2030904@imgtec.com>
Date: Fri, 22 Mar 2013 10:16:40 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Arnd <arnd@arndb.de>
Subject: Re: [patch 20/34] metag: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130321215234.606480852@linutronix.de>
In-Reply-To: <20130321215234.606480852@linutronix.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_22_10_16_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/13 21:53, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: James Hogan <james.hogan@imgtec.com>
> ---
>  arch/metag/Kconfig          |    1 +
>  arch/metag/kernel/process.c |   32 +++-----------------------------
>  arch/metag/kernel/smp.c     |    2 +-
>  3 files changed, 5 insertions(+), 30 deletions(-)
> 
> Index: linux-2.6/arch/metag/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/metag/Kconfig
> +++ linux-2.6/arch/metag/Kconfig
> @@ -9,6 +9,7 @@ config METAG
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_IRQ_SHOW
>  	select GENERIC_SMP_IDLE_THREAD
> +	select GENERIC_IDLE_LOOP

Please preserve alphabetical ordering

>  	select HAVE_64BIT_ALIGNED_ACCESS
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_C_RECORDMCOUNT
> Index: linux-2.6/arch/metag/kernel/process.c
> ===================================================================
> --- linux-2.6.orig/arch/metag/kernel/process.c
> +++ linux-2.6/arch/metag/kernel/process.c
> @@ -31,7 +31,7 @@
>  /*
>   * Wait for the next interrupt and enable local interrupts
>   */
> -static inline void arch_idle(void)
> +void arch_cpu_idle(void)
>  {
>  	int tmp;
>  
> @@ -59,35 +59,9 @@ static inline void arch_idle(void)
>  		      : "r" (get_trigger_mask()));
>  }
>  
> -void cpu_idle(void)
> +void arch_cpu_idle_dead(void)
>  {
> -	set_thread_flag(TIF_POLLING_NRFLAG);
> -
> -	while (1) {
> -		tick_nohz_idle_enter();
> -		rcu_idle_enter();
> -
> -		while (!need_resched()) {
> -			/*
> -			 * We need to disable interrupts here to ensure we don't
> -			 * miss a wakeup call.
> -			 */
> -			local_irq_disable();
> -			if (!need_resched()) {
> -#ifdef CONFIG_HOTPLUG_CPU
> -				if (cpu_is_offline(smp_processor_id()))
> -					cpu_die();
> -#endif
> -				arch_idle();
> -			} else {
> -				local_irq_enable();
> -			}
> -		}
> -
> -		rcu_idle_exit();
> -		tick_nohz_idle_exit();
> -		schedule_preempt_disabled();
> -	 }
> +	cpu_die();

This requires #include <linux/smp.h> and even then the definition of
cpu_die() is guarded by #ifdef CONFIG_HOTPLUG_CPU, like blackfin & s390.

>  }
>  
>  void (*pm_power_off)(void);
> Index: linux-2.6/arch/metag/kernel/smp.c
> ===================================================================
> --- linux-2.6.orig/arch/metag/kernel/smp.c
> +++ linux-2.6/arch/metag/kernel/smp.c
> @@ -297,7 +297,7 @@ asmlinkage void secondary_start_kernel(v
>  	/*
>  	 * OK, it's off to the idle thread for us
>  	 */
> -	cpu_idle();
> +	cpu_startup_entry(CPUHP_ONLINE);
>  }
>  
>  void __init smp_cpus_done(unsigned int max_cpus)
> 
> 

I also hit the same problems Tony Breeds hit.

After hacking around them, and enabling SMP and HOTPLUG_CPU, I hit the
WARN_ON_ONCE(!irqs_disabled()) after arch_cpu_idle() in cpu_idle_loop():

> META213-Thread1 DSP [LogF] WARNING: at kernel/cpu/idle.c:94 _cpu_startup_entry+0x1cc/0x1e0()

arch_cpu_idle() enables interrupts. See Arnd's comment in
https://patchwork.kernel.org/patch/2002571/:

> To avoid that, you need to disable interrupts around
> the inner loop. The sleep instruction should return with
> interrupts implicitly enabled if ARC behaves like most
> other architectures doing this.

Cheers
James

