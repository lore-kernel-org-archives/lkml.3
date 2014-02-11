Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaBKRvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:51:45 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:52674 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaBKRvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:51:44 -0500
Date: Tue, 11 Feb 2014 12:51:41 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] idle: Add more comments to the code
In-Reply-To: <1392131491-5265-5-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.11.1402111245400.17677@knanqh.ubzr>
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org> <1392131491-5265-5-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Daniel Lezcano wrote:

> The idle main function is a complex and a critical function. Added more
> comments to the code.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Few questions below.  In any case,:

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  kernel/sched/idle.c |   37 +++++++++++++++++++++++++++++++++----
>  1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 72b5926..36ff1a7 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -86,19 +86,34 @@ static int cpuidle_idle_call(void)
>  	if (cpu_idle_force_poll || tick_check_broadcast_expired())
>  		return cpu_idle_poll();
>  
> +	/*
> +	 * Check if the idle task must rescheduled. If it is the case,

s/must/must be/

> +	 * exit the function after re-enabling the local irq and set
> +	 * again the polling flag
> +	 */
>  	if (current_clr_polling_and_test()) {
>  		local_irq_enable();
>  		__current_set_polling();
>  		return 0;
>  	}
>  
> +	/*
> +	 * During the idle period, stop measuring the disabled irqs
> +	 * critical sections latencies
> +	 */
>  	stop_critical_timings();
> +
> +	/*
> +	 * Tell the RCU framework we are entering an idle section,
> +	 * so no more rcu read side critical sections and one more
> +	 * step to the grace period
> +	 */
>  	rcu_idle_enter();
>  
> -	/* Ask the governor for the next state, this call can fail for
> -	 * different reasons: cpuidle is not enabled or an idle state
> -	 * fulfilling the constraints was not found. In this case, we fall
> -	 * back to the default idle function
> +	/*
> +	 * Ask the governor to choose an idle state it thinks it is
> +	 * convenient to go to. There is *always* a convenient idle
> +	 * state but the call could fail if cpuidle is not enabled
>  	 */
>  	next_state = cpuidle_select(drv, dev);
>  	if (next_state < 0) {
> @@ -106,6 +121,10 @@ static int cpuidle_idle_call(void)
>  		goto out;
>  	}
>  
> +	/*
> +	 * The idle task must be scheduled, it is pointless to go to idle,
> +	 * just update no idle residency and get out of this function
> +	 */
>  	if (need_resched()) {
>  		dev->last_residency = 0;
>  		/* give the governor an opportunity to reflect on the outcome */

Is this if block really necessary?  We already have need_resched() being 
monitored in the outer loop.  Are cpuidle_select() or rcu_idle_enter() 
likely to spend a significant amount of time justifying a recheck here?


Nicolas
