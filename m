Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaBKKRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:17:07 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53403 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaBKKQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:16:58 -0500
Message-ID: <52F9F896.4020402@linaro.org>
Date: Tue, 11 Feb 2014 11:16:54 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>, linux-pm@vger.kernel.org,
        peterz@infradead.org, benh@kernel.crashing.org,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linuxppc-dev@lists.ozlabs.org, mingo@kernel.org
CC: deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        paulus@samba.org, srivatsa.bhat@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V4 2/3] tick/cpuidle: Initialize hrtimer mode of broadcast
References: <20140207075618.17187.20149.stgit@preeti.in.ibm.com> <20140207080632.17187.80532.stgit@preeti.in.ibm.com>
In-Reply-To: <20140207080632.17187.80532.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 09:06 AM, Preeti U Murthy wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> On some architectures, in certain CPU deep idle states the local timers stop.
> An external clock device is used to wakeup these CPUs. The kernel support for the
> wakeup of these CPUs is provided by the tick broadcast framework by using the
> external clock device as the wakeup source.
>
> However not all implementations of architectures provide such an external
> clock device. This patch includes support in the broadcast framework to handle
> the wakeup of the CPUs in deep idle states on such systems by queuing a hrtimer
> on one of the CPUs, which is meant to handle the wakeup of CPUs in deep idle states.
>
> This patchset introduces a pseudo clock device which can be registered by the
> archs as tick_broadcast_device in the absence of a real external clock
> device. Once registered, the broadcast framework will work as is for these
> architectures as long as the archs take care of the BROADCAST_ENTER
> notification failing for one of the CPUs. This CPU is made the stand by CPU to
> handle wakeup of the CPUs in deep idle and it *must not enter deep idle states*.
>
> The CPU with the earliest wakeup is chosen to be this CPU. Hence this way the
> stand by CPU dynamically moves around and so does the hrtimer which is queued
> to trigger at the next earliest wakeup time. This is consistent with the case where
> an external clock device is present. The smp affinity of this clock device is
> set to the CPU with the earliest wakeup.

Hi Preeti,

jumping a bit late in the thread...

Setting the smp affinity on the earliest timer should be handled 
automatically with the CLOCK_EVT_FEAT_DYNIRQ flag. Did you look at using 
this flag ?

Another comment is the overall approach. We enter the cpuidle idle 
framework with a specific state to go to and it is the tick framework 
telling us we mustn't go to this state. IMO the logic is wrong, the 
decision to not enter this state should be moved somewhere else.

Why don't you create a cpuidle driver with the shallow idle states 
assigned to a cpu (let's say cpu0) and another one with all the deeper 
idle states for the rest of the cpus ? Using the multiple cpuidle driver 
support makes it possible. The timer won't be moving around and a cpu 
will be dedicated to act as the broadcast timer.

Wouldn't make sense and be less intrusive than the patchset you proposed ?


> This patchset handles the hotplug of
> the stand by CPU as well by moving the hrtimer on to the CPU handling the CPU_DEAD
> notification.
>
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> [Added Changelog and code to handle reprogramming of hrtimer]
> ---
>
>   include/linux/clockchips.h           |    9 +++
>   kernel/time/Makefile                 |    2 -
>   kernel/time/tick-broadcast-hrtimer.c |  105 ++++++++++++++++++++++++++++++++++
>   kernel/time/tick-broadcast.c         |   54 +++++++++++++++++
>   4 files changed, 166 insertions(+), 4 deletions(-)
>   create mode 100644 kernel/time/tick-broadcast-hrtimer.c
>
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index e0c5a6c..dbe9e14 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -62,6 +62,11 @@ enum clock_event_mode {
>   #define CLOCK_EVT_FEAT_DYNIRQ		0x000020
>   #define CLOCK_EVT_FEAT_PERCPU		0x000040
>
> +/*
> + * Clockevent device is based on a hrtimer for broadcast
> + */
> +#define CLOCK_EVT_FEAT_HRTIMER		0x000080
> +
>   /**
>    * struct clock_event_device - clock event device descriptor
>    * @event_handler:	Assigned by the framework to be called by the low
> @@ -83,6 +88,7 @@ enum clock_event_mode {
>    * @name:		ptr to clock event name
>    * @rating:		variable to rate clock event devices
>    * @irq:		IRQ number (only for non CPU local devices)
> + * @bound_on:		Bound on CPU
>    * @cpumask:		cpumask to indicate for which CPUs this device works
>    * @list:		list head for the management code
>    * @owner:		module reference
> @@ -113,6 +119,7 @@ struct clock_event_device {
>   	const char		*name;
>   	int			rating;
>   	int			irq;
> +	int			bound_on;
>   	const struct cpumask	*cpumask;
>   	struct list_head	list;
>   	struct module		*owner;
> @@ -180,9 +187,11 @@ extern int tick_receive_broadcast(void);
>   #endif
>
>   #if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
> +extern void tick_setup_hrtimer_broadcast(void);
>   extern int tick_check_broadcast_expired(void);
>   #else
>   static inline int tick_check_broadcast_expired(void) { return 0; }
> +static void tick_setup_hrtimer_broadcast(void) {};
>   #endif
>
>   #ifdef CONFIG_GENERIC_CLOCKEVENTS
> diff --git a/kernel/time/Makefile b/kernel/time/Makefile
> index 9250130..06151ef 100644
> --- a/kernel/time/Makefile
> +++ b/kernel/time/Makefile
> @@ -3,7 +3,7 @@ obj-y += timeconv.o posix-clock.o alarmtimer.o
>
>   obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
>   obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
> -obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
> +obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o tick-broadcast-hrtimer.o
>   obj-$(CONFIG_GENERIC_SCHED_CLOCK)		+= sched_clock.o
>   obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
>   obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
> diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
> new file mode 100644
> index 0000000..af1e119
> --- /dev/null
> +++ b/kernel/time/tick-broadcast-hrtimer.c
> @@ -0,0 +1,105 @@
> +/*
> + * linux/kernel/time/tick-broadcast-hrtimer.c
> + * This file emulates a local clock event device
> + * via a pseudo clock device.
> + */
> +#include <linux/cpu.h>
> +#include <linux/err.h>
> +#include <linux/hrtimer.h>
> +#include <linux/interrupt.h>
> +#include <linux/percpu.h>
> +#include <linux/profile.h>
> +#include <linux/clockchips.h>
> +#include <linux/sched.h>
> +#include <linux/smp.h>
> +#include <linux/module.h>
> +
> +#include "tick-internal.h"
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
> +	 *
> +	 * However we can also be called from the event handler of
> +	 * ce_broadcast_hrtimer itself when it expires. We cannot therefore
> +	 * restart the timer since it is on flight on the same CPU. But
> +	 * due to the same reason we can reset it.
> +	 */
> +	if (hrtimer_try_to_cancel(&bctimer) >= 0) {
> +		hrtimer_start(&bctimer, expires, HRTIMER_MODE_ABS_PINNED);
> +		/* Bind the "device" to the cpu */
> +		bc->bound_on = smp_processor_id();
> +	} else if (bc->bound_on == smp_processor_id()) {
> +		hrtimer_set_expires(&bctimer, expires);
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
> +
> +	if (ce_broadcast_hrtimer.next_event.tv64 == KTIME_MAX)
> +		return HRTIMER_NORESTART;
> +
> +	return HRTIMER_RESTART;
> +}
> +
> +void tick_setup_hrtimer_broadcast(void)
> +{
> +	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
> +	bctimer.function = bc_handler;
> +	clockevents_register_device(&ce_broadcast_hrtimer);
> +}
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index ddf2ac2..2f013c3 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -630,6 +630,42 @@ again:
>   	raw_spin_unlock(&tick_broadcast_lock);
>   }
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
> +		if (broadcast_needs_cpu(bc, smp_processor_id()))
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
>   /*
>    * Powerstate information: The system enters/leaves a state, where
>    * affected devices might stop
> @@ -648,7 +684,7 @@ int tick_broadcast_oneshot_control(unsigned long reason)
>   	 * states
>   	 */
>   	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
> -		return;
> +		return 0;
>
>   	/*
>   	 * We are called with preemtion disabled from the depth of the
> @@ -659,7 +695,7 @@ int tick_broadcast_oneshot_control(unsigned long reason)
>   	dev = td->evtdev;
>
>   	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
> -		return;
> +		return 0;
>
>   	bc = tick_broadcast_device.evtdev;
>
> @@ -667,7 +703,7 @@ int tick_broadcast_oneshot_control(unsigned long reason)
>   	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
>   		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
>   			WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
> -			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> +			broadcast_shutdown_local(bc, dev);
>   			/*
>   			 * We only reprogram the broadcast timer if we
>   			 * did not mark ourself in the force mask and
> @@ -680,6 +716,16 @@ int tick_broadcast_oneshot_control(unsigned long reason)
>   			    dev->next_event.tv64 < bc->next_event.tv64)
>   				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
>   		}
> +		/*
> +		 * If the current CPU owns the hrtimer broadcast
> +		 * mechanism, it cannot go deep idle and we remove the
> +		 * CPU from the broadcast mask. We don't have to go
> +		 * through the EXIT path as the local timer is not
> +		 * shutdown.
> +		 */
> +		ret = broadcast_needs_cpu(bc, cpu);
> +		if (ret)
> +			cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
>   	} else {
>   		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
>   			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
> @@ -853,6 +899,8 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
>   	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
>   	cpumask_clear_cpu(cpu, tick_broadcast_force_mask);
>
> +	broadcast_move_bc(cpu);
> +
>   	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

