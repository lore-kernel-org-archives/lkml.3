Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958AbaDMVvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 17:51:08 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50780 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaDMVvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 17:51:06 -0400
Date: Sun, 13 Apr 2014 17:51:03 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        daniel.lezcano@linaro.org, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/8] sched,idle: Delay clearing the polling bit
In-Reply-To: <20140411135218.546673774@infradead.org>
Message-ID: <alpine.LFD.2.11.1404131749430.980@knanqh.ubzr>
References: <20140411134243.160989490@infradead.org> <20140411135218.546673774@infradead.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014, Peter Zijlstra wrote:

> With the generic idle functions assuming !polling we should only clear
> the polling bit at the very last opportunity in order to avoid
> spurious IPIs.
> 
> Ideally we'd flip the default to polling, but that means auditing all
> arch idle functions.
> 
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  kernel/sched/idle.c |   17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -78,12 +78,10 @@ static int cpuidle_idle_call(void)
>  
>  	/*
>  	 * Check if the idle task must be rescheduled. If it is the
> -	 * case, exit the function after re-enabling the local irq and
> -	 * set again the polling flag
> +	 * case, exit the function after re-enabling the local irq.
>  	 */
> -	if (current_clr_polling_and_test()) {
> +	if (need_resched()) {
>  		local_irq_enable();
> -		__current_set_polling();
>  		return 0;
>  	}
>  
> @@ -127,7 +125,7 @@ static int cpuidle_idle_call(void)
>  			broadcast = !!(drv->states[next_state].flags &
>  				       CPUIDLE_FLAG_TIMER_STOP);
>  
> -			if (broadcast)
> +			if (broadcast) {
>  				/*
>  				 * Tell the time framework to switch
>  				 * to a broadcast timer because our
> @@ -139,6 +137,7 @@ static int cpuidle_idle_call(void)
>  				ret = clockevents_notify(
>  					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
>  					&dev->cpu);
> +			}
>  
>  			if (!ret) {
>  				trace_cpu_idle_rcuidle(next_state, dev->cpu);
> @@ -175,8 +174,12 @@ static int cpuidle_idle_call(void)
>  	 * We can't use the cpuidle framework, let's use the default
>  	 * idle routine
>  	 */
> -	if (ret)
> -		arch_cpu_idle();
> +	if (ret) {
> +		if (!current_clr_polling_and_test())
> +			arch_cpu_idle();
> +		else
> +			local_irq_enable();
> +	}
>  
>  	__current_set_polling();
>  
> 
> 
