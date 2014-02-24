Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaBXRDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:03:12 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:42143 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaBXRDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:03:11 -0500
Message-ID: <530B7B4E.50306@linaro.org>
Date: Mon, 24 Feb 2014 18:03:10 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main
 function
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org> <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org> <20140224145912.GW27965@twins.programming.kicks-ass.net> <530B679C.6070204@linaro.org> <20140224160543.GZ9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140224160543.GZ9987@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 05:05 PM, Peter Zijlstra wrote:
> On Mon, Feb 24, 2014 at 04:39:08PM +0100, Daniel Lezcano wrote:
>
>>> And when you do that; you can also push down the
>>> current_clr_polling_and_test() muck so it doesn't cover the actual
>>> cpuidle policy code.
>>
>> I am not getting it. Where do you suggest to move it ?
>
> A little something like so I suppose;

Thanks for taking the time to send me this patch.

> only call
> current_clr_polling_and_test() right before calling the actual idle
> function. Although I suppose cpuidle_enter() can still do all sorts of
> weird.

Well there is the polling idle state for the x86 and ppc cpuidle 
drivers. Except that, I think we have something more or less clean.

> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -78,37 +78,35 @@ static int cpuidle_idle_call(void)
>   	stop_critical_timings();
>   	rcu_idle_enter();
>
> -	next_state = cpuidle_enabled(drv, dev);
> -	if (next_state < 0) {
> -		arch_cpu_idle();
> -		goto out;
> -	}
> -
> -	/*
> -	 * Ask the governor for the next state, this call can fail for
> -	 * different reasons: cpuidle is not enabled or an idle state
> -	 * fulfilling the constraints was not found. In this case, we
> -	 * fall back to the default idle function
> -	 */
> -	next_state = cpuidle_select(drv, dev);
> +	if (cpuidle_enabled(drv, dev) == 0) {
> +		/*
> +		 * Ask the governor for the next state, this call can fail for
> +		 * different reasons: cpuidle is not enabled or an idle state
> +		 * fulfilling the constraints was not found. In this case, we
> +		 * fall back to the default idle function
> +		 */
> +		next_state = cpuidle_select(drv, dev);
> +
> +		if (current_clr_polling_and_test()) {
> +			dev->last_residency = 0;
> +			entered_state = next_state;
> +			local_irq_enable();
> +		} else {
> +			trace_cpu_idle_rcuidle(next_state, dev->cpu);
> +			entered_state = cpuidle_enter(drv, dev, next_state);
> +			trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
> +		}
>
> -	if (need_resched()) {

Ok. The need_resched is now replaced by 'current_clr_polling_and_test', 
with a call to '__current_set_polling()' to set the flag back, right ?

For my personal information, what is the subtlety with:

if (tif_need_resched())
	set_preempt_need_resched();

?

> -		dev->last_residency = 0;
>   		/* give the governor an opportunity to reflect on the outcome */
> -		cpuidle_reflect(dev, next_state);
> -		local_irq_enable();
> -		goto out;
> +		cpuidle_reflect(dev, entered_state);
> +	} else {
> +		if (current_clr_polling_and_test())
> +			local_irq_enable();
> +		else
> +			arch_cpu_idle();
>   	}
> +	__current_set_polling();
>
> -	trace_cpu_idle_rcuidle(next_state, dev->cpu);
> -
> -	entered_state = cpuidle_enter(drv, dev, next_state);
> -
> -	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
> -
> -	/* give the governor an opportunity to reflect on the outcome */
> -	cpuidle_reflect(dev, entered_state);
> -out:
>   	if (WARN_ON_ONCE(irqs_disabled()))
>   		local_irq_enable();
>
> @@ -145,16 +143,11 @@ static void cpu_idle_loop(void)
>   			 * know that the IPI is going to arrive right
>   			 * away
>   			 */
> -			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
> +			if (cpu_idle_force_poll || tick_check_broadcast_expired())
>   				cpu_idle_poll();
> -			} else {
> -				if (!current_clr_polling_and_test()) {
> -					cpuidle_idle_call();
> -				} else {
> -					local_irq_enable();
> -				}
> -				__current_set_polling();
> -			}
> +			else
> +				cpu_idle_call();
> +
>   			arch_cpu_idle_exit();
>   			/*
>   			 * We need to test and propagate the TIF_NEED_RESCHED
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

