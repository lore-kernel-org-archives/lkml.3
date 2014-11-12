Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaKLVKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:10:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:43331 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:10:06 -0500
Date: Wed, 12 Nov 2014 22:09:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] PM / Sleep: Timer quiesce in freeze state
In-Reply-To: <5451A94F.1090200@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411121558280.3935@nanos>
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net> <544DE5CF.9040501@linux.intel.com> <20141027074419.GE10501@worktop.programming.kicks-ass.net> <544F4B31.7050308@linux.intel.com>
 <20141028082503.GN3337@twins.programming.kicks-ass.net> <5450253B.5020802@linux.intel.com> <20141029082432.GV3337@twins.programming.kicks-ass.net> <5451A94F.1090200@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Li, Aubrey wrote:

> Freeze is a general power saving state that processes are frozen, devices
> are suspended and CPUs are in idle state. However, when the system enters
> freeze state, there are a few timers keep ticking and hence consumes more
> power unnecessarily. The observed timer events in freeze state are:
> - tick_sched_timer
> - watchdog lockup detector
> - realtime scheduler period timer
> 
> The system power consumption in freeze state will be reduced significantly
> if we quiesce these timers.

So the obvious question is why dont we quiesce these timers by telling
the subsystems which manage these timers to shut them down?

I really want a proper answer for this in the first place, but let me
look at the proposed "solution" as well.

> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 6776027..f2bb645 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -917,6 +917,14 @@ static void local_apic_timer_interrupt(void)
>  	 */
>  	inc_irq_stat(apic_timer_irqs);
>  
> +	/*
> +	 * if timekeeping is suspended, the clock event device will be
> +	 * suspended as well, so we are not supposed to invoke the event
> +	 * handler of clock event device.
> +	 */
> +	if (unlikely(timekeeping_suspended))
> +		return;

Why do you need that if you already suspended the clock event device?
The above comment does not explain that at all.

So if there is a proper reason to do so, we rather do the following in
tick_suspend():

	td->evtdev.real_handler = td->evtdev.event_handler;
	td->evtdev.event_handler = clockevents_handle_noop;

and restore that on resume instead of sprinkling if (tk_suspended)
checks all over the place. x86/apic is probably not the only one which
wants that treatment.

But before we do that we want a proper explanation why the interrupt
fires at all. The lack of explanation cleary documents that this is a
'hacked it into submission' approach.

> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 4ca9a33..660fd15 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -28,16 +28,20 @@
>  #include <linux/ftrace.h>
>  #include <trace/events/power.h>
>  #include <linux/compiler.h>
> +#include <linux/stop_machine.h>
> +#include <linux/clockchips.h>
> +#include <linux/hrtimer.h>
>  
>  #include "power.h"
> +#include "../time/tick-internal.h"
> +#include "../time/timekeeping_internal.h"

Eew.
  
> +static void freezer_pick_tk(int cpu)
> +{
> +	if (tick_do_timer_cpu == TICK_DO_TIMER_NONE) {
> +		static DEFINE_SPINLOCK(lock);
> +
> +		spin_lock(&lock);
> +		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
> +			tick_do_timer_cpu = cpu;
> +		spin_unlock(&lock);
> +	}
> +}
> +static void freezer_suspend_clkevt(int cpu)
> +{
> +	if (tick_do_timer_cpu == cpu)
> +		return;
> +
> +	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
> +}
> +
> +static void freezer_suspend_tk(int cpu)
> +{
> +	if (tick_do_timer_cpu != cpu)
> +		return;
> +
> +	timekeeping_suspend();
> +
> +}

So you export the world and some more from timekeeping and the tick
code and fiddle with it randomly just to do:

1) Suspend clock event devices
2) Suspend timekeeping
3) Resume timekeeping
4) Resume clock event devices

And for that you kick the frozen cpus out of idle into the
stomp_machine task and let them enter deep idle from there.

stomp_machine() is in 99% of all use cases a clear indicator for a
complete design failure.

It's not that hard to solve that problem, w/o stomp_machine and w/o
all the tick_do_timer_cpu mess.

1) Run the freeze code until freeze_enter()

2) Prevent CPU hotplug and switch state.

   That tells the cpu idle code to enter the deepest idle state and
   also tells the clock events code about the desire to freeze
   everything.

   clock_events_set_freeze_state(true);

   And let that be:

   clock_events_set_freeze_state(bool on)
   {
	raw_spin_lock_irq(&clockevents_lock);
	if (on)
		tobefrozen_cpus = num_online_cpus();
	idle_freeze = on;
	raw_spin_unlock_irq(&clockevents_lock);
   }

   So the generic idle task needs a check like this:

   if (idle_should_freeze())
      	frozen_idle();

   with the implementation:

   bool idle_should_freeze()
   {
	return clock_events_get_freeze_state();
   }

   which resolves to:

   bool clock_events_get_freeze_state()
   {
        /*
	 * Lockfree access because it does not matter.
	 *
	 * See below at CLOCK_EVT_NOTIFY_FREEZE
	 */
	return idle_freeze;
   }

4) Kick all cpus out of idle, so they enter the deep idle state via
   frozen_idle()

   frozen_idle()
   {
   	if (clock_events_notify(CLOCK_EVT_NOTIFY_FREEZE))
	      return;

	while (idle_should_freeze())
	      magic_frozen_idle();

	clock_events_notify(CLOCK_EVT_NOTIFY_UNFREEZE);
   }

   Let clock_events_notify() have these new cases:

   CLOCK_EVT_NOTIFY_FREEZE:
	ret = tick_freeze();
	break;

   CLOCK_EVT_NOTIFY_UNFREEZE:
	tick_unfreeze();
	break;

   and

   tick_freeze()
   {
	/*
	 * This is serialized against a concurrent wakeup
	 * via clockevents_lock!
	 */
	if (!idle_freeze)
	   return -EBUSY;

	if (--tobefrozen_cpus) {
	   tick_suspend();
	} else
	   /*
	    * Needs to be a seperate interface due to
	    * clockevents_lock being held in clock_events_notify()
	    */
	   timekeeping_freeze();
        }
   }

   and

   tick_unfreeze()
   {
	if (!timekeeping_frozen)
	   tick_resume();
	else
	   timekeeping_unfreeze();
   }

   and the wakeup notification wants to have a proper interface as
   well:

   wakeup_the_whole_thing()
   {
	do_whatever_unfreeze_needs();

	clock_events_set_freeze_state(false);
   }

5) Reenable cpu hotplug when the freezer task returns.

No stomp_machine, no tick_do_timer_cpu() abuse. All nicely serialized
via clockevents_lock.

All abortable at any given point in time and not dependend on running
through another state machine nested into the stomp_machine() state
machine.

Thoughts?

Thanks,

	tglx



