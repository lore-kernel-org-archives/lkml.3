Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3BUKfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:35:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54251 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3BUKfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:35:16 -0500
Date: Thu, 21 Feb 2013 10:35:08 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Jason Liu <liu.h.jason@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
Message-ID: <20130221103508.GA24591@e102568-lin.cambridge.arm.com>
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com>
 <alpine.LFD.2.02.1302201400400.22263@ionos>
 <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 21 Feb 2013 10:35:11.0417 (UTC) FILETIME=[2069FA90:01CE101F]
X-MC-Unique: 113022110351302401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thu, Feb 21, 2013 at 06:16:51AM +0000, Jason Liu wrote:
> 2013/2/20 Thomas Gleixner <tglx@linutronix.de>:
> > On Wed, 20 Feb 2013, Jason Liu wrote:
> >> void arch_idle(void)
> >> {
> >> ....
> >> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
> >>
> >> enter_the_wait_mode();
> >>
> >> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> >> }
> >>
> >> when the broadcast timer interrupt arrives(this interrupt just wakeup
> >> the ARM, and ARM has no chance
> >> to handle it since local irq is disabled. In fact it's disabled in
> >> cpu_idle() of arch/arm/kernel/process.c)
> >>
> >> the broadcast timer interrupt will wake up the CPU and run:
> >>
> >> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);    ->
> >> tick_broadcast_oneshot_control(...);
> >> ->
> >> tick_program_event(dev->next_event, 1);
> >> ->
> >> tick_dev_program_event(dev, expires, force);
> >> ->
> >> for (i = 0;;) {
> >>                 int ret = clockevents_program_event(dev, expires, now);
> >>                 if (!ret || !force)
> >>                         return ret;
> >>
> >>                 dev->retries++;
> >>                 ....
> >>                 now = ktime_get();
> >>                 expires = ktime_add_ns(now, dev->min_delta_ns);
> >> }
> >> clockevents_program_event(dev, expires, now);
> >>
> >>         delta = ktime_to_ns(ktime_sub(expires, now));
> >>
> >>         if (delta <= 0)
> >>                 return -ETIME;
> >>
> >> when the bc timer interrupt arrives,  which means the last local timer
> >> expires too. so,
> >> clockevents_program_event will return -ETIME, which will cause the
> >> dev->retries++
> >> when retry to program the expired timer.
> >>
> >> Even under the worst case, after the re-program the expired timer,
> >> then CPU enter idle
> >> quickly before the re-progam timer expired, it will make system
> >> ping-pang forever,
> >
> > That's nonsense.
> 
> I don't think so.
> 
> >
> > The timer IPI brings the core out of the deep idle state.
> >
> > So after returning from enter_wait_mode() and after calling
> > clockevents_notify() it returns from arch_idle() to cpu_idle().
> >
> > In cpu_idle() interrupts are reenabled, so the timer IPI handler is
> > invoked. That calls the event_handler of the per cpu local clockevent
> > device (the one which stops in C3). That ends up in the generic timer
> > code which expires timers and reprograms the local clock event device
> > with the next pending timer.
> >
> > So you cannot go idle again, before the expired timers of this event
> > are handled and their callbacks invoked.
> 
> That's true for the CPUs which not response to the global timer interrupt.
> Take our platform as example: we have 4CPUs(CPU0, CPU1,CPU2,CPU3)
> The global timer device will keep running even in the deep idle mode, so, it
> can be used as the broadcast timer device, and the interrupt of this device
> just raised to CPU0 when the timer expired, then, CPU0 will broadcast the
> IPI timer to other CPUs which is in deep idle mode.
> 
> So for CPU1, CPU2, CPU3, you are right, the IPI timer will bring it out of idle
> state, after running clockevents_notify() it returns from arch_idle()
> to cpu_idle(),
> then local_irq_enable(), the IPI handler will be invoked and handle
> the expires times
> and re-program the next pending timer.
> 
> But, that's not true for the CPU0. The flow for CPU0 is:
> the global timer interrupt wakes up CPU0 and then call:
> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> 
> which will cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
> in the function tick_broadcast_oneshot_control(),

For my own understanding: at this point in time CPU0 local timer is
also reprogrammed, with min_delta (ie 1us) if I got your description
right.

> 
> After return from clockevents_notify(), it will return to cpu_idle
> from arch_idle,
> then local_irq_enable(), the CPU0 will response to the global timer
> interrupt, and
> call the interrupt handler: tick_handle_oneshot_broadcast()
> 
> static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
> {
>         struct tick_device *td;
>         ktime_t now, next_event;
>         int cpu;
> 
>         raw_spin_lock(&tick_broadcast_lock);
> again:
>         dev->next_event.tv64 = KTIME_MAX;
>         next_event.tv64 = KTIME_MAX;
>         cpumask_clear(to_cpumask(tmpmask));
>         now = ktime_get();
>         /* Find all expired events */
>         for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
>                 td = &per_cpu(tick_cpu_device, cpu);
>                 if (td->evtdev->next_event.tv64 <= now.tv64)
>                         cpumask_set_cpu(cpu, to_cpumask(tmpmask));
>                 else if (td->evtdev->next_event.tv64 < next_event.tv64)
>                         next_event.tv64 = td->evtdev->next_event.tv64;
>         }
> 
>         /*
>          * Wakeup the cpus which have an expired event.
>          */
>         tick_do_broadcast(to_cpumask(tmpmask));
>         ...
> }
> 
> since cpu0 has been removed from the tick_get_broadcast_oneshot_mask(), and if
> all the other cpu1/2/3 state in idle, and no expired timers, then the
> tmpmask will be 0,
> when call tick_do_broadcast().
> 
> static void tick_do_broadcast(struct cpumask *mask)
> {
>         int cpu = smp_processor_id();
>         struct tick_device *td;
> 
>         /*
>          * Check, if the current cpu is in the mask
>          */
>         if (cpumask_test_cpu(cpu, mask)) {
>                 cpumask_clear_cpu(cpu, mask);
>                 td = &per_cpu(tick_cpu_device, cpu);
>                 td->evtdev->event_handler(td->evtdev);
>         }
> 
>         if (!cpumask_empty(mask)) {
>                 /*
>                  * It might be necessary to actually check whether the devices
>                  * have different broadcast functions. For now, just use the
>                  * one of the first device. This works as long as we have this
>                  * misfeature only on x86 (lapic)
>                  */
>                 td = &per_cpu(tick_cpu_device, cpumask_first(mask));
>                 td->evtdev->broadcast(mask);
>         }
> }
> 
> If the mask is empty, then tick_do_broadcast will do nothing and return, which
> will make cpu0 enter idle quickly, and then system will ping-pang there.

This means that the local timer reprogrammed above (to actually emulate the
expired local timer on CPU0, likely to be set to min_delta == 1us) does not
have time to expire before the idle thread disables IRQs and goes idle again.

Is this a correct description of what's happening ?

Thanks a lot,
Lorenzo

