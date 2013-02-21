Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3BUGQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:16:53 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56705 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3BUGQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302201400400.22263@ionos>
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com>
	<alpine.LFD.2.02.1302201400400.22263@ionos>
Date: Thu, 21 Feb 2013 14:16:51 +0800
Message-ID: <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
From: Jason Liu <liu.h.jason@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/20 Thomas Gleixner <tglx@linutronix.de>:
> On Wed, 20 Feb 2013, Jason Liu wrote:
>> void arch_idle(void)
>> {
>> ....
>> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
>>
>> enter_the_wait_mode();
>>
>> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
>> }
>>
>> when the broadcast timer interrupt arrives(this interrupt just wakeup
>> the ARM, and ARM has no chance
>> to handle it since local irq is disabled. In fact it's disabled in
>> cpu_idle() of arch/arm/kernel/process.c)
>>
>> the broadcast timer interrupt will wake up the CPU and run:
>>
>> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);    ->
>> tick_broadcast_oneshot_control(...);
>> ->
>> tick_program_event(dev->next_event, 1);
>> ->
>> tick_dev_program_event(dev, expires, force);
>> ->
>> for (i = 0;;) {
>>                 int ret = clockevents_program_event(dev, expires, now);
>>                 if (!ret || !force)
>>                         return ret;
>>
>>                 dev->retries++;
>>                 ....
>>                 now = ktime_get();
>>                 expires = ktime_add_ns(now, dev->min_delta_ns);
>> }
>> clockevents_program_event(dev, expires, now);
>>
>>         delta = ktime_to_ns(ktime_sub(expires, now));
>>
>>         if (delta <= 0)
>>                 return -ETIME;
>>
>> when the bc timer interrupt arrives,  which means the last local timer
>> expires too. so,
>> clockevents_program_event will return -ETIME, which will cause the
>> dev->retries++
>> when retry to program the expired timer.
>>
>> Even under the worst case, after the re-program the expired timer,
>> then CPU enter idle
>> quickly before the re-progam timer expired, it will make system
>> ping-pang forever,
>
> That's nonsense.

I don't think so.

>
> The timer IPI brings the core out of the deep idle state.
>
> So after returning from enter_wait_mode() and after calling
> clockevents_notify() it returns from arch_idle() to cpu_idle().
>
> In cpu_idle() interrupts are reenabled, so the timer IPI handler is
> invoked. That calls the event_handler of the per cpu local clockevent
> device (the one which stops in C3). That ends up in the generic timer
> code which expires timers and reprograms the local clock event device
> with the next pending timer.
>
> So you cannot go idle again, before the expired timers of this event
> are handled and their callbacks invoked.

That's true for the CPUs which not response to the global timer interrupt.
Take our platform as example: we have 4CPUs(CPU0, CPU1,CPU2,CPU3)
The global timer device will keep running even in the deep idle mode, so, it
can be used as the broadcast timer device, and the interrupt of this device
just raised to CPU0 when the timer expired, then, CPU0 will broadcast the
IPI timer to other CPUs which is in deep idle mode.

So for CPU1, CPU2, CPU3, you are right, the IPI timer will bring it out of idle
state, after running clockevents_notify() it returns from arch_idle()
to cpu_idle(),
then local_irq_enable(), the IPI handler will be invoked and handle
the expires times
and re-program the next pending timer.

But, that's not true for the CPU0. The flow for CPU0 is:
the global timer interrupt wakes up CPU0 and then call:
clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);

which will cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
in the function tick_broadcast_oneshot_control(),

After return from clockevents_notify(), it will return to cpu_idle
from arch_idle,
then local_irq_enable(), the CPU0 will response to the global timer
interrupt, and
call the interrupt handler: tick_handle_oneshot_broadcast()

static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
{
        struct tick_device *td;
        ktime_t now, next_event;
        int cpu;

        raw_spin_lock(&tick_broadcast_lock);
again:
        dev->next_event.tv64 = KTIME_MAX;
        next_event.tv64 = KTIME_MAX;
        cpumask_clear(to_cpumask(tmpmask));
        now = ktime_get();
        /* Find all expired events */
        for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
                td = &per_cpu(tick_cpu_device, cpu);
                if (td->evtdev->next_event.tv64 <= now.tv64)
                        cpumask_set_cpu(cpu, to_cpumask(tmpmask));
                else if (td->evtdev->next_event.tv64 < next_event.tv64)
                        next_event.tv64 = td->evtdev->next_event.tv64;
        }

        /*
         * Wakeup the cpus which have an expired event.
         */
        tick_do_broadcast(to_cpumask(tmpmask));
        ...
}

since cpu0 has been removed from the tick_get_broadcast_oneshot_mask(), and if
all the other cpu1/2/3 state in idle, and no expired timers, then the
tmpmask will be 0,
when call tick_do_broadcast().

static void tick_do_broadcast(struct cpumask *mask)
{
        int cpu = smp_processor_id();
        struct tick_device *td;

        /*
         * Check, if the current cpu is in the mask
         */
        if (cpumask_test_cpu(cpu, mask)) {
                cpumask_clear_cpu(cpu, mask);
                td = &per_cpu(tick_cpu_device, cpu);
                td->evtdev->event_handler(td->evtdev);
        }

        if (!cpumask_empty(mask)) {
                /*
                 * It might be necessary to actually check whether the devices
                 * have different broadcast functions. For now, just use the
                 * one of the first device. This works as long as we have this
                 * misfeature only on x86 (lapic)
                 */
                td = &per_cpu(tick_cpu_device, cpumask_first(mask));
                td->evtdev->broadcast(mask);
        }
}

If the mask is empty, then tick_do_broadcast will do nothing and return, which
will make cpu0 enter idle quickly, and then system will ping-pang there.

switch to bc timer->wait->bc timer expires->wakeup->switch to loc timer->  |
 ^
 |------<-enter idle <- reprogram the expired loc timer ---<


We did see such things happen on the system which will make system
stuck there and
no any sched-tick handler running on the CPU0.

And the easy way to reproduce it is:

/* hack code: just for experiment */
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..d142802 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -493,8 +493,12 @@ void tick_broadcast_oneshot_control(unsigned long reason)
                        cpumask_clear_cpu(cpu,
                                          tick_get_broadcast_oneshot_mask());
                        clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-                       if (dev->next_event.tv64 != KTIME_MAX)
-                               tick_program_event(dev->next_event, 1);
+                       if (dev->next_event.tv64 != KTIME_MAX) {
+                               if (cpu)
+                                       tick_program_event(dev->next_event, 1);
+                               else
+
tick_program_event(ktime_add_ns(dev->next_event, 100000), 1);
+                       }
                }
        }

We need fix this common issue. Do you have good idea about how to fix it?

>
>
> Now the reprogramming itself is a different issue.
>
> It's necessary as we have no information whether the wakeup was caused
> by the timer IPI or by something else.
>
> We might try to be clever and store the pending IPI in
> tick_handle_oneshot_broadcast() and avoid the reprogramming in that
> case. Completely untested patch below.

Thanks for the patch.

>
> Thanks,
>
>         tglx
>
> Index: linux-2.6/kernel/time/tick-broadcast.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/tick-broadcast.c
> +++ linux-2.6/kernel/time/tick-broadcast.c
> @@ -29,6 +29,7 @@
>  static struct tick_device tick_broadcast_device;
>  /* FIXME: Use cpumask_var_t. */
>  static DECLARE_BITMAP(tick_broadcast_mask, NR_CPUS);
> +static DECLARE_BITMAP(tick_broadcast_pending, NR_CPUS);
>  static DECLARE_BITMAP(tmpmask, NR_CPUS);
>  static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
>  static int tick_broadcast_force;
> @@ -417,9 +418,10 @@ again:
>         /* Find all expired events */
>         for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
>                 td = &per_cpu(tick_cpu_device, cpu);
> -               if (td->evtdev->next_event.tv64 <= now.tv64)
> +               if (td->evtdev->next_event.tv64 <= now.tv64) {
>                         cpumask_set_cpu(cpu, to_cpumask(tmpmask));
> -               else if (td->evtdev->next_event.tv64 < next_event.tv64)
> +                       set_bit(cpu, tick_broadcast_pending);
> +               } else if (td->evtdev->next_event.tv64 < next_event.tv64)
>                         next_event.tv64 = td->evtdev->next_event.tv64;
>         }
>
> @@ -493,7 +495,8 @@ void tick_broadcast_oneshot_control(unsi
>                         cpumask_clear_cpu(cpu,
>                                           tick_get_broadcast_oneshot_mask());
>                         clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
> -                       if (dev->next_event.tv64 != KTIME_MAX)
> +                       if (dev->next_event.tv64 != KTIME_MAX &&
> +                           !test_and_clear_bit(cpu, tick_broadcast_pending))
>                                 tick_program_event(dev->next_event, 1);
>                 }
>         }
>

I have tested the patch, it can fix the retries on the CPU1/2/3, but
not on CPU0.
see, cpu0:  retries:        39042

root@~$ cat /proc/timer_list
Timer List Version: v0.6
HRTIMER_MAX_CLOCK_BASES: 3
[...]

Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: local_timer
 max_delta_ns:   8624432320
 min_delta_ns:   1000
 mult:           2138893713
 shift:          32
 mode:           3
 next_event:     3295010000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        39042

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: local_timer
 max_delta_ns:   8624432320
 min_delta_ns:   1000
 mult:           2138893713
 shift:          32
 mode:           1
 next_event:     3295050000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        1

Tick Device: mode:     1
Per CPU device: 2
Clock Event Device: local_timer
 max_delta_ns:   8624432320
 min_delta_ns:   1000
 mult:           2138893713
 shift:          32
 mode:           1
 next_event:     10740407770000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0

Tick Device: mode:     1
Per CPU device: 3
Clock Event Device: local_timer
 max_delta_ns:   8624432320
 min_delta_ns:   1000
 mult:           2138893713
 shift:          32
 mode:           1
 next_event:     10737578200000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0


Jason Liu
>
>
>
>
>
