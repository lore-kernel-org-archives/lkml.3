Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaEHLWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:22:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53773 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750942AbaEHLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:22:34 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/idle: Reflow cpuidle_idle_call()
Date: Thu, 08 May 2014 13:39:14 +0200
Message-ID: <1877683.4pfeUuvFZ2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <tip-cc6vb0snt3sr7op6rlbfeqfh@git.kernel.org>
References: <tip-cc6vb0snt3sr7op6rlbfeqfh@git.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 03:47:40 AM tip-bot for Peter Zijlstra wrote:
> Commit-ID:  37352273ad48f2d177ed1b06ced32d5536b773fb
> Gitweb:     http://git.kernel.org/tip/37352273ad48f2d177ed1b06ced32d5536b773fb
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Fri, 11 Apr 2014 13:55:48 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 8 May 2014 09:16:59 +0200
> 
> sched/idle: Reflow cpuidle_idle_call()
> 
> Apply goto to reduce lines and nesting levels.

Well, I have a couple of patches that will conflict with this.

This one in particular:

https://patchwork.kernel.org/patch/4071541/

which unfortunately already is in my linux-next branch, because I was
unaware of this work.

I wonder how we can resolve this?

> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Link: http://lkml.kernel.org/n/tip-cc6vb0snt3sr7op6rlbfeqfh@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/idle.c | 131 +++++++++++++++++++++++-----------------------------
>  1 file changed, 58 insertions(+), 73 deletions(-)
> 
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index ed67f0c..88a6bc4 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -73,7 +73,7 @@ static int cpuidle_idle_call(void)
>  {
>  	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>  	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
> -	int next_state, entered_state, ret;
> +	int next_state, entered_state;
>  	bool broadcast;
>  
>  	/*
> @@ -102,90 +102,75 @@ static int cpuidle_idle_call(void)
>  	 * Check if the cpuidle framework is ready, otherwise fallback
>  	 * to the default arch specific idle method
>  	 */
> -	ret = cpuidle_enabled(drv, dev);
> -
> -	if (!ret) {
> -		/*
> -		 * Ask the governor to choose an idle state it thinks
> -		 * it is convenient to go to. There is *always* a
> -		 * convenient idle state
> -		 */
> -		next_state = cpuidle_select(drv, dev);
> -
> +	if (cpuidle_enabled(drv, dev)) {
> +use_default:
>  		/*
> -		 * The idle task must be scheduled, it is pointless to
> -		 * go to idle, just update no idle residency and get
> -		 * out of this function
> +		 * We can't use the cpuidle framework, let's use the default
> +		 * idle routine.
>  		 */
> -		if (current_clr_polling_and_test()) {
> -			dev->last_residency = 0;
> -			entered_state = next_state;
> +		if (current_clr_polling_and_test())
>  			local_irq_enable();
> -		} else {
> -			broadcast = !!(drv->states[next_state].flags &
> -				       CPUIDLE_FLAG_TIMER_STOP);
> -
> -			if (broadcast) {
> -				/*
> -				 * Tell the time framework to switch
> -				 * to a broadcast timer because our
> -				 * local timer will be shutdown. If a
> -				 * local timer is used from another
> -				 * cpu as a broadcast timer, this call
> -				 * may fail if it is not available
> -				 */
> -				ret = clockevents_notify(
> -					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
> -					&dev->cpu);
> -			}
> -
> -			if (!ret) {
> -				trace_cpu_idle_rcuidle(next_state, dev->cpu);
> -
> -				/*
> -				 * Enter the idle state previously
> -				 * returned by the governor
> -				 * decision. This function will block
> -				 * until an interrupt occurs and will
> -				 * take care of re-enabling the local
> -				 * interrupts
> -				 */
> -				entered_state = cpuidle_enter(drv, dev,
> -							      next_state);
> -
> -				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
> -						       dev->cpu);
> -
> -				if (broadcast)
> -					clockevents_notify(
> -						CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
> -						&dev->cpu);
> -
> -				/*
> -				 * Give the governor an opportunity to reflect on the
> -				 * outcome
> -				 */
> -				cpuidle_reflect(dev, entered_state);
> -			}
> -		}
> +		else
> +			arch_cpu_idle();
> +
> +		goto exit_idle;
>  	}
>  
>  	/*
> -	 * We can't use the cpuidle framework, let's use the default
> -	 * idle routine
> +	 * Ask the governor to choose an idle state it thinks
> +	 * it is convenient to go to. There is *always* a
> +	 * convenient idle state
>  	 */
> -	if (ret) {
> -		if (!current_clr_polling_and_test())
> -			arch_cpu_idle();
> -		else
> -			local_irq_enable();
> +	next_state = cpuidle_select(drv, dev);
> +
> +	/*
> +	 * The idle task must be scheduled, it is pointless to
> +	 * go to idle, just update no idle residency and get
> +	 * out of this function
> +	 */
> +	if (current_clr_polling_and_test()) {
> +		dev->last_residency = 0;
> +		entered_state = next_state;
> +		local_irq_enable();
> +		goto exit_idle;
>  	}
>  
> +	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
> +
> +	/*
> +	 * Tell the time framework to switch to a broadcast timer
> +	 * because our local timer will be shutdown. If a local timer
> +	 * is used from another cpu as a broadcast timer, this call may
> +	 * fail if it is not available
> +	 */
> +	if (broadcast &&
> +	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
> +		goto use_default;
> +
> +	trace_cpu_idle_rcuidle(next_state, dev->cpu);
> +
> +	/*
> +	 * Enter the idle state previously returned by the governor decision.
> +	 * This function will block until an interrupt occurs and will take
> +	 * care of re-enabling the local interrupts
> +	 */
> +	entered_state = cpuidle_enter(drv, dev, next_state);
> +
> +	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
> +
> +	if (broadcast)
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
> +
> +	/*
> +	 * Give the governor an opportunity to reflect on the outcome
> +	 */
> +	cpuidle_reflect(dev, entered_state);
> +
> +exit_idle:
>  	__current_set_polling();
>  
>  	/*
> -	 * It is up to the idle functions to enable back the local
> -	 * interrupt
> +	 * It is up to the idle functions to reenable local interrupts
>  	 */
>  	if (WARN_ON_ONCE(irqs_disabled()))
>  		local_irq_enable();
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
