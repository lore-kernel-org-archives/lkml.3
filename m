Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaAWDmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 22:42:24 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58206 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaAWDmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 22:42:22 -0500
Message-ID: <52E08EC2.6090204@linux.vnet.ibm.com>
Date: Thu, 23 Jan 2014 09:08:42 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        agraf@suse.de, paul.gortmaker@windriver.com, paulus@samba.org,
        mingo@kernel.org, mikey@neuling.org, shangw@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V5 6/8] time/cpuidle: Support in tick broadcast framework
 in the absence of external clock device
References: <20140115080555.20446.27238.stgit@preeti.in.ibm.com> <20140115080947.20446.30305.stgit@preeti.in.ibm.com> <alpine.DEB.2.02.1401221042130.4260@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1401221042130.4260@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012303-0928-0000-0000-000005E7CFEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thank you very much for the review.

On 01/22/2014 06:57 PM, Thomas Gleixner wrote:
> On Wed, 15 Jan 2014, Preeti U Murthy wrote:
>> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
>> index 086ad60..d61404e 100644
>> --- a/kernel/time/clockevents.c
>> +++ b/kernel/time/clockevents.c
>> @@ -524,12 +524,13 @@ void clockevents_resume(void)
>>  #ifdef CONFIG_GENERIC_CLOCKEVENTS
>>  /**
>>   * clockevents_notify - notification about relevant events
>> + * Returns non zero on error.
>>   */
>> -void clockevents_notify(unsigned long reason, void *arg)
>> +int clockevents_notify(unsigned long reason, void *arg)
>>  {
> 
> The interface change of clockevents_notify wants to be a separate
> patch.
> 
>> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
>> index 9532690..1c23912 100644
>> --- a/kernel/time/tick-broadcast.c
>> +++ b/kernel/time/tick-broadcast.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/sched.h>
>>  #include <linux/smp.h>
>>  #include <linux/module.h>
>> +#include <linux/slab.h>
>>  
>>  #include "tick-internal.h"
>>  
>> @@ -35,6 +36,15 @@ static cpumask_var_t tmpmask;
>>  static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
>>  static int tick_broadcast_force;
>>  
>> +/*
>> + * Helper variables for handling broadcast in the absence of a
>> + * tick_broadcast_device.
>> + * */
>> +static struct hrtimer *bc_hrtimer;
>> +static int bc_cpu = -1;
>> +static ktime_t bc_next_wakeup;
> 
> Why do you need another variable to store the expiry time? The
> broadcast code already knows it and the hrtimer expiry value gives you
> the same information for free.

The reason was functions like tick_handle_oneshot_broadcast() and
tick_broadcast_switch_to_oneshot() were using the
tick_broadcast_device.evtdev->next_event to set/get the next wakeups.

But since this patchset introduced an explicit hrtimer for archs which
did not have such a device, I wanted these functions to use a generic
parameter to set/get the next wakeups without having to know about the
existence of this hrtimer, if at all. And program the hrtimer/tick
broadcast device whichever was present only when the next event was to
be set. But with your below concept patch, we will not be required to do
this.
> 
>> +static int hrtimer_initialized = 0;
> 
> What's the point of this hrtimer_initialized dance? Why not simply
> making the hrtimer static and avoid that all together. Also adding the
> initialization into tick_broadcast_oneshot_available() is
> braindamaged.  Why not adding this to tick_broadcast_init() which is
> the proper place to do?

Right I agree, this hrtimer initialization should have been in
tick_broadcast_init() and a simple static declaration would have done
the job.
> 
> Aside of that you are making this hrtimer mode unconditional, which
> might break existing systems which are not aware of the hrtimer
> implications.
> 
> What you really want is a pseudo clock event device which has the
> proper functions for handling the timer and you can register it from
> your architecture code. The broadcast core code needs a few tweaks to
> avoid the shutdown of the cpu local clock event device, but aside of
> that the whole thing just falls into place. So architectures can use
> this if they want and are sure that their low level idle code knows
> about the deep idle preventing return value of
> clockevents_notify(). Once that works you can register the hrtimer
> based broadcast device and a real hardware broadcast device with a
> higher rating. It just works.

I now completely see your point. This will surely break on archs which
are not using the return value of the BROADCAST_ENTER notification.

I am not even giving them a choice about using the hrtimer mode of
broadcast framework and am expecting them to take action for the failed
return of BROADCAST_ENTER. I missed that critical point. I went through
the below patch and am able to see how you are solving this problem.
> 
> Find an incomplete and nonfunctional concept patch below. It should be
> simple to make it work for real.

Thank you very much for the valuable review. The below patch makes your
points very clear. Let me try this out.

Regards
Preeti U Murthy
> 
> Thanks,
> 
> 	tglx
> ----
> Index: linux-2.6/include/linux/clockchips.h
> ===================================================================
> --- linux-2.6.orig/include/linux/clockchips.h
> +++ linux-2.6/include/linux/clockchips.h
> @@ -62,6 +62,11 @@ enum clock_event_mode {
>  #define CLOCK_EVT_FEAT_DYNIRQ		0x000020
>  #define CLOCK_EVT_FEAT_PERCPU		0x000040
> 
> +/*
> + * Clockevent device is based on a hrtimer for broadcast
> + */
> +#define CLOCK_EVT_FEAT_HRTIMER		0x000080
> +
>  /**
>   * struct clock_event_device - clock event device descriptor
>   * @event_handler:	Assigned by the framework to be called by the low
> @@ -83,6 +88,7 @@ enum clock_event_mode {
>   * @name:		ptr to clock event name
>   * @rating:		variable to rate clock event devices
>   * @irq:		IRQ number (only for non CPU local devices)
> + * @bound_on:		Bound on CPU
>   * @cpumask:		cpumask to indicate for which CPUs this device works
>   * @list:		list head for the management code
>   * @owner:		module reference
> @@ -113,6 +119,7 @@ struct clock_event_device {
>  	const char		*name;
>  	int			rating;
>  	int			irq;
> +	int			bound_on;
>  	const struct cpumask	*cpumask;
>  	struct list_head	list;
>  	struct module		*owner;
> Index: linux-2.6/kernel/time/tick-broadcast-hrtimer.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/kernel/time/tick-broadcast-hrtimer.c
> @@ -0,0 +1,77 @@
> +
> +static struct hrtimer bctimer;
> +
> +static void bc_set_mode(enum clock_event_mode mode,
> +			struct clock_event_device *bc)
> +{
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +		/*
> +		 * Note, we cannot cancel the timer here as we might
> +		 * run into the following live lock scenario:
> +		 *
> +		 * cpu 0		cpu1
> +		 * lock(broadcast_lock);
> +		 *			hrtimer_interrupt()
> +		 *			bc_handler()
> +		 *			   tick_handle_oneshot_broadcast();
> +		 *			    lock(broadcast_lock);
> +		 * hrtimer_cancel()
> +		 *  wait_for_callback()
> +		 */
> +		hrtimer_try_to_cancel(&bctimer);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +/*
> + * This is called from the guts of the broadcast code when the cpu
> + * which is about to enter idle has the earliest broadcast timer event.
> + */
> +static int bc_set_next(ktime_t expires, struct clock_event_device *bc)
> +{
> +	/*
> +	 * We try to cancel the timer first. If the callback is on
> +	 * flight on some other cpu then we let it handle it. If we
> +	 * were able to cancel the timer nothing can rearm it as we
> +	 * own broadcast_lock.
> +	 */
> +	if (hrtimer_try_to_cancel(&bctimer) >= 0) {
> +		hrtimer_start(&bctimer, expires, HRTIMER_MODE_ABS_PINNED);
> +		/* Bind the "device" to the cpu */
> +		bc->bound_on = smp_processor_id();
> +	}
> +	return 0;
> +}
> +
> +static struct clock_event_device ce_broadcast_hrtimer = {
> +	.set_mode		= bc_set_mode,
> +	.set_next_ktime		= bc_set_next,
> +	.features		= CLOCK_EVT_FEAT_ONESHOT |
> +				  CLOCK_EVT_FEAT_KTIME |
> +				  CLOCK_EVT_FEAT_HRTIMER,
> +	.rating			= 0,
> +	.bound_on		= -1,
> +	.min_delta_ns		= 1,
> +	.max_delta_ns		= KTIME_MAX,
> +	.min_delta_ticks	= 1,
> +	.max_delta_ticks	= KTIME_MAX,
> +	.mult			= 1,
> +	.shift			= 0,
> +	.cpumask		= cpu_all_mask,
> +};
> +
> +static enum hrtimer_restart bc_handler(struct hrtimer *t)
> +{
> +	ce_broadcast_hrtimer.event_handler(&ce_broadcast_hrtimer);
> +	return HRTIMER_NORESTART;
> +}
> +
> +void tick_setup_hrtimer_broadcast(void)
> +{
> +	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
> +	bctimer.function = bc_handler;
> +	clockevents_register(&ce_broadcast_hrtimer);
> +}
> Index: linux-2.6/kernel/time/tick-broadcast.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/tick-broadcast.c
> +++ linux-2.6/kernel/time/tick-broadcast.c
> @@ -630,6 +630,42 @@ again:
>  	raw_spin_unlock(&tick_broadcast_lock);
>  }
> 
> +static int broadcast_needs_cpu(struct clock_event_device *bc, int cpu)
> +{
> +	if (!(bc->features & CLOCK_EVT_FEAT_HRTIMER))
> +		return 0;
> +	if (bc->next_event.tv64 == KTIME_MAX)
> +		return 0;
> +	return bc->bound_on == cpu ? -EBUSY : 0;
> +}
> +
> +static void broadcast_shutdown_local(struct clock_event_device *bc,
> +				     struct clock_event_device *dev)
> +{
> +	/*
> +	 * For hrtimer based broadcasting we cannot shutdown the cpu
> +	 * local device if our own event is the first one to expire or
> +	 * if we own the broadcast timer.
> +	 */
> +	if (bc->features & CLOCK_EVT_FEAT_HRTIMER) {
> +		if (broadcast_needs_cpu(bc))
> +			return;
> +		if (dev->next_event.tv64 < bc->next_event.tv64)
> +			return;
> +	}
> +	clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> +}
> +
> +static void broadcast_move_bc(int deadcpu)
> +{
> +	struct clock_event_device *bc = tick_broadcast_device.evtdev;
> +
> +	if (!bc || !broadcast_needs_cpu(bc, deadcpu))
> +		return;
> +	/* This moves the broadcast assignment to this cpu */
> +	clockevents_program_event(bc, bc->next_event, 1);
> +}
> +
>  /*
>   * Powerstate information: The system enters/leaves a state, where
>   * affected devices might stop
> @@ -639,8 +675,8 @@ void tick_broadcast_oneshot_control(unsi
>  	struct clock_event_device *bc, *dev;
>  	struct tick_device *td;
>  	unsigned long flags;
> +	int cpu, ret = 0;
>  	ktime_t now;
> -	int cpu;
> 
>  	/*
>  	 * Periodic mode does not care about the enter/exit of power
> @@ -666,7 +702,7 @@ void tick_broadcast_oneshot_control(unsi
>  	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
>  		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
>  			WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
> -			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> +			broadcast_shutdown_local(bc, dev);
>  			/*
>  			 * We only reprogram the broadcast timer if we
>  			 * did not mark ourself in the force mask and
> @@ -679,6 +715,11 @@ void tick_broadcast_oneshot_control(unsi
>  			    dev->next_event.tv64 < bc->next_event.tv64)
>  				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
>  		}
> +		/*
> +		 * If the current CPU owns the hrtimer broadcast
> +		 * mechanism, it cannot go deep idle.
> +		 */
> +		ret = broadcast_needs_cpu(bc, cpu);
>  	} else {
>  		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
>  			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
> @@ -851,6 +892,8 @@ void tick_shutdown_broadcast_oneshot(uns
>  	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
>  	cpumask_clear_cpu(cpu, tick_broadcast_force_mask);
> 
> +	broadcast_move_bc(cpu);
> +
>  	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
>  }
> 
> 

