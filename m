Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaDNN4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:56:24 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:51023 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaDNNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:55:36 -0400
Date: Mon, 14 Apr 2014 09:55:34 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        daniel.lezcano@linaro.org, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 8/8] sched,idle: Reflow cpuidle_idle_call()
In-Reply-To: <20140414092547.GJ13658@twins.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.11.1404140953490.980@knanqh.ubzr>
References: <20140411134243.160989490@infradead.org> <20140411135218.617896630@infradead.org> <alpine.LFD.2.11.1404131734120.980@knanqh.ubzr> <20140414085911.GB11096@twins.programming.kicks-ass.net> <20140414092547.GJ13658@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014, Peter Zijlstra wrote:

> On Mon, Apr 14, 2014 at 10:59:11AM +0200, Peter Zijlstra wrote:
> > > Why not using braces here and moving the use_default code block inside 
> > > it instead?
> > 
> > I didn't because there's two goto use_default sites, but sure, I can do
> > that.

Ah, I initially missed the second site, but still.

> ---
> Subject: sched,idle: Reflow cpuidle_idle_call()
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri Apr 11 13:55:48 CEST 2014
> 
> Apply goto to reduce lines and nesting levels.
> 
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-xt260n72av3ip7jsaef2ps3h@git.kernel.org

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  kernel/sched/idle.c |  131 +++++++++++++++++++++++-----------------------------
>  1 file changed, 58 insertions(+), 73 deletions(-)
> 
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
> 
