Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3KSMyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:54:10 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53881 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751890Ab3KSMyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:54:07 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        shaohua.li@intel.com, rui.zhang@intel.com, arjan@linux.intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        hpa@zytor.com
Subject: Re: [PATCH] x86, acpi, idle: Restructure the mwait idle routines
Date: Tue, 19 Nov 2013 14:06:44 +0100
Message-ID: <1459315.yzPGm1niKE@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131119113153.GD3694@twins.programming.kicks-ass.net>
References: <20131119090019.GJ3866@twins.programming.kicks-ass.net> <20131119090859.GC3694@twins.programming.kicks-ass.net> <20131119113153.GD3694@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 19, 2013 12:31:53 PM Peter Zijlstra wrote:
> People seem to delight in writing wrong and broken mwait idle routines;
> collapse the lot.
> 
> This leaves mwait_play_dead() the sole remaining user of __mwait() and
> new __mwait() users are probably doing it wrong.
> 
> Also remove __sti_mwait() as its unused.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

For the ACPI part:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
> 
> Mike, does this cure your core2?
> 
>  arch/x86/include/asm/mwait.h       | 42 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/processor.h   | 23 ---------------------
>  arch/x86/kernel/acpi/cstate.c      | 23 ---------------------
>  drivers/acpi/acpi_pad.c            |  5 +----
>  drivers/acpi/processor_idle.c      | 15 --------------
>  drivers/idle/intel_idle.c          |  8 +-------
>  drivers/thermal/intel_powerclamp.c |  4 +---
>  7 files changed, 45 insertions(+), 75 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
> index 2f366d0ac6b4..80014dade987 100644
> --- a/arch/x86/include/asm/mwait.h
> +++ b/arch/x86/include/asm/mwait.h
> @@ -1,6 +1,8 @@
>  #ifndef _ASM_X86_MWAIT_H
>  #define _ASM_X86_MWAIT_H
>  
> +#include <linux/sched.h>
> +
>  #define MWAIT_SUBSTATE_MASK		0xf
>  #define MWAIT_CSTATE_MASK		0xf
>  #define MWAIT_SUBSTATE_SIZE		4
> @@ -13,4 +15,44 @@
>  
>  #define MWAIT_ECX_INTERRUPT_BREAK	0x1
>  
> +static inline void __monitor(const void *eax, unsigned long ecx,
> +			     unsigned long edx)
> +{
> +	/* "monitor %eax, %ecx, %edx;" */
> +	asm volatile(".byte 0x0f, 0x01, 0xc8;"
> +		     :: "a" (eax), "c" (ecx), "d"(edx));
> +}
> +
> +static inline void __mwait(unsigned long eax, unsigned long ecx)
> +{
> +	/* "mwait %eax, %ecx;" */
> +	asm volatile(".byte 0x0f, 0x01, 0xc9;"
> +		     :: "a" (eax), "c" (ecx));
> +}
> +
> +/*
> + * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
> + * which can obviate IPI to trigger checking of need_resched.
> + * We execute MONITOR against need_resched and enter optimized wait state
> + * through MWAIT. Whenever someone changes need_resched, we would be woken
> + * up from MWAIT (without an IPI).
> + *
> + * New with Core Duo processors, MWAIT can take some hints based on CPU
> + * capability.
> + */
> +static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
> +{
> +	if (need_resched())
> +		return;
> +
> +	if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> +		clflush((void *)&current_thread_info()->flags);
> +
> +	__monitor((void *)&current_thread_info()->flags, 0, 0);
> +	if (!current_set_polling_and_test())
> +		__mwait(eax, ecx);
> +
> +	__current_clr_polling();
> +}
> +
>  #endif /* _ASM_X86_MWAIT_H */
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 7b034a4057f9..24821f5768bc 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -700,29 +700,6 @@ static inline void sync_core(void)
>  #endif
>  }
>  
> -static inline void __monitor(const void *eax, unsigned long ecx,
> -			     unsigned long edx)
> -{
> -	/* "monitor %eax, %ecx, %edx;" */
> -	asm volatile(".byte 0x0f, 0x01, 0xc8;"
> -		     :: "a" (eax), "c" (ecx), "d"(edx));
> -}
> -
> -static inline void __mwait(unsigned long eax, unsigned long ecx)
> -{
> -	/* "mwait %eax, %ecx;" */
> -	asm volatile(".byte 0x0f, 0x01, 0xc9;"
> -		     :: "a" (eax), "c" (ecx));
> -}
> -
> -static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
> -{
> -	trace_hardirqs_on();
> -	/* "mwait %eax, %ecx;" */
> -	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
> -		     :: "a" (eax), "c" (ecx));
> -}
> -
>  extern void select_idle_routine(const struct cpuinfo_x86 *c);
>  extern void init_amd_e400_c1e_mask(void);
>  
> diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
> index d2b7f27781bc..e69182fd01cf 100644
> --- a/arch/x86/kernel/acpi/cstate.c
> +++ b/arch/x86/kernel/acpi/cstate.c
> @@ -150,29 +150,6 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
>  }
>  EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
>  
> -/*
> - * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
> - * which can obviate IPI to trigger checking of need_resched.
> - * We execute MONITOR against need_resched and enter optimized wait state
> - * through MWAIT. Whenever someone changes need_resched, we would be woken
> - * up from MWAIT (without an IPI).
> - *
> - * New with Core Duo processors, MWAIT can take some hints based on CPU
> - * capability.
> - */
> -void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
> -{
> -	if (!need_resched()) {
> -		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> -			clflush((void *)&current_thread_info()->flags);
> -
> -		__monitor((void *)&current_thread_info()->flags, 0, 0);
> -		smp_mb();
> -		if (!need_resched())
> -			__mwait(ax, cx);
> -	}
> -}
> -
>  void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
>  {
>  	unsigned int cpu = smp_processor_id();
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index fc6008fbce35..509452a62f96 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -193,10 +193,7 @@ static int power_saving_thread(void *data)
>  					CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
>  			stop_critical_timings();
>  
> -			__monitor((void *)&current_thread_info()->flags, 0, 0);
> -			smp_mb();
> -			if (!need_resched())
> -				__mwait(power_saving_mwait_eax, 1);
> +			mwait_idle_with_hints(power_saving_mwait_eax, 1);
>  
>  			start_critical_timings();
>  			if (lapic_marked_unstable)
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 644516d9bde6..f90c56c8379e 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -727,11 +727,6 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
>  	if (unlikely(!pr))
>  		return -EINVAL;
>  
> -	if (cx->entry_method == ACPI_CSTATE_FFH) {
> -		if (current_set_polling_and_test())
> -			return -EINVAL;
> -	}
> -
>  	lapic_timer_state_broadcast(pr, cx, 1);
>  	acpi_idle_do_entry(cx);
>  
> @@ -785,11 +780,6 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
>  	if (unlikely(!pr))
>  		return -EINVAL;
>  
> -	if (cx->entry_method == ACPI_CSTATE_FFH) {
> -		if (current_set_polling_and_test())
> -			return -EINVAL;
> -	}
> -
>  	/*
>  	 * Must be done before busmaster disable as we might need to
>  	 * access HPET !
> @@ -841,11 +831,6 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>  		}
>  	}
>  
> -	if (cx->entry_method == ACPI_CSTATE_FFH) {
> -		if (current_set_polling_and_test())
> -			return -EINVAL;
> -	}
> -
>  	acpi_unlazy_tlb(smp_processor_id());
>  
>  	/* Tell the scheduler that we are going deep-idle: */
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 3226ce98fb18..3b56d76a5bca 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -359,13 +359,7 @@ static int intel_idle(struct cpuidle_device *dev,
>  	if (!(lapic_timer_reliable_states & (1 << (cstate))))
>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
>  
> -	if (!current_set_polling_and_test()) {
> -
> -		__monitor((void *)&current_thread_info()->flags, 0, 0);
> -		smp_mb();
> -		if (!need_resched())
> -			__mwait(eax, ecx);
> -	}
> +	mwait_idle_with_hints(eax, ecx);
>  
>  	if (!(lapic_timer_reliable_states & (1 << (cstate))))
>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
> index 8f181b3f842b..e8275f2df9af 100644
> --- a/drivers/thermal/intel_powerclamp.c
> +++ b/drivers/thermal/intel_powerclamp.c
> @@ -438,9 +438,7 @@ static int clamp_thread(void *arg)
>  			 */
>  			local_touch_nmi();
>  			stop_critical_timings();
> -			__monitor((void *)&current_thread_info()->flags, 0, 0);
> -			cpu_relax(); /* allow HT sibling to run */
> -			__mwait(eax, ecx);
> +			mwait_idle_with_hints(eax, ecx);
>  			start_critical_timings();
>  			atomic_inc(&idle_wakeup_counter);
>  		}
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
