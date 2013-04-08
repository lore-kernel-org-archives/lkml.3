Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935892Ab3DHMge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:36:34 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56361 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935874Ab3DHMgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:36:32 -0400
Message-ID: <5162B92E.6020703@linux.vnet.ibm.com>
Date: Mon, 08 Apr 2013 18:03:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] sparc: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130329161905.GC6201@merkur.ravnborg.org> <20130329202926.GA9484@merkur.ravnborg.org> <51592EF1.4090302@linux.vnet.ibm.com> <20130401090620.GA24861@merkur.ravnborg.org>
In-Reply-To: <20130401090620.GA24861@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040812-5140-0000-0000-000002FF485A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On 04/01/2013 02:36 PM, Sam Ravnborg wrote:
> Hi Srivatsa,
> 
> thanks for the feedback!
> 
> @davem - I need you to look at this again. I am not sure about the changes
> I do in sparc64_yield().
> 
>>> +/* the idle loop on a Sparc... ;) */
>>> +void arch_cpu_idle(void)
>>>  {
>>> +	if (sparc_idle)
>>> +		(*sparc_idle)();
>>> +	else
>>> +		cpu_relax();
>>>  }
>>
>> You need to enable interrupts when coming out in the 'else' case,
>> because we enter with interrupts disabled and expect to come out
>> of arch_cpu_idle() with interrupts enabled. (Otherwise you'll hit
>> that WARN_ON() in the generic code). Thomas has handled a similar
>> case in the mips patch.
> 
> Something like this should do it then:
> 
> /* Idle loop support */
> void arch_cpu_idle(void)
> {
>         if (sparc_idle)
>                 (*sparc_idle)();
>         else
>                 local_irq_enable();
> }
> 
> I dropped cpu_relax() as this is a simple barrier() which is
> part of the generic code (using rmb()).
> 

Yep, that sounds good.

[...] 
>> (Same is the case with the need_resched and
>> the cpu_is_offline check).
> There are some comments about race-conditions in the commit where they were added.
> I think the out-most pair can be dropped as this is done in generic code but
> that the inner ones needs to stay.
> 
> I simplified arch_cpu_idle() - former sparc64_yield() based on your comments.
> - dropped TIF_POLLING_NRFLAG handling
> - dropped smp_mb__after_clear_bit() - this is done in generic code using rmb()
> - dropped the out-most while (!need_resched() && !cpu_is_offline(cpu))
> - always enable irq on exit (but I am not sure if this is correct)
> 
> But I need davem to have a look at this - as I am fooling around in
> code that I do not know much about..
> So this is *NOT* to be applied.
> 
> 	Sam
>
[...]
>  /* XXX cli/sti -> local_irq_xxx here, check this works once SMP is fixed. */
> diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
> index cdb80b2..cecb0d6 100644
> --- a/arch/sparc/kernel/process_64.c
> +++ b/arch/sparc/kernel/process_64.c
> @@ -52,17 +52,12 @@
> 
>  #include "kstack.h"
> 
> -static void sparc64_yield(int cpu)
> +/* Idle loop support on sparc64. */
> +void arch_cpu_idle(void)
>  {
>  	if (tlb_type != hypervisor) {
>  		touch_nmi_watchdog();
> -		return;
> -	}
> -
> -	clear_thread_flag(TIF_POLLING_NRFLAG);
> -	smp_mb__after_clear_bit();
> -
> -	while (!need_resched() && !cpu_is_offline(cpu)) {
> +	} else {
>  		unsigned long pstate;
> 
>  		/* Disable interrupts. */
> @@ -73,7 +68,7 @@ static void sparc64_yield(int cpu)
>  			: "=&r" (pstate)
>  			: "i" (PSTATE_IE));
> 
> -		if (!need_resched() && !cpu_is_offline(cpu))
> +		if (!need_resched() && !cpu_is_offline(smp_processor_id()))
>  			sun4v_cpu_yield();
> 
>  		/* Re-enable interrupts. */
> @@ -84,36 +79,16 @@ static void sparc64_yield(int cpu)
>  			: "=&r" (pstate)
>  			: "i" (PSTATE_IE));
>  	}
> -
> -	set_thread_flag(TIF_POLLING_NRFLAG);
> +	local_irq_enable();
>  }

Nitpick: you can probably move the local_irq_enable() to the
'if' block, since the else block already has assembly code to enable
the interrupts. But anyway its up to you.

This version of your code looks fine to me.

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

