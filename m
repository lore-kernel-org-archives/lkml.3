Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495Ab3BTNdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:33:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:39435 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935090Ab3BTNdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:33:07 -0500
Date: Wed, 20 Feb 2013 14:33:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Liu <liu.h.jason@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
In-Reply-To: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302201400400.22263@ionos>
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Jason Liu wrote:
> void arch_idle(void)
> {
> ....
> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
> 
> enter_the_wait_mode();
> 
> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> }
> 
> when the broadcast timer interrupt arrives(this interrupt just wakeup
> the ARM, and ARM has no chance
> to handle it since local irq is disabled. In fact it's disabled in
> cpu_idle() of arch/arm/kernel/process.c)
> 
> the broadcast timer interrupt will wake up the CPU and run:
> 
> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);    ->
> tick_broadcast_oneshot_control(...);
> ->
> tick_program_event(dev->next_event, 1);
> ->
> tick_dev_program_event(dev, expires, force);
> ->
> for (i = 0;;) {
>                 int ret = clockevents_program_event(dev, expires, now);
>                 if (!ret || !force)
>                         return ret;
> 
>                 dev->retries++;
>                 ....
>                 now = ktime_get();
>                 expires = ktime_add_ns(now, dev->min_delta_ns);
> }
> clockevents_program_event(dev, expires, now);
> 
>         delta = ktime_to_ns(ktime_sub(expires, now));
> 
>         if (delta <= 0)
>                 return -ETIME;
> 
> when the bc timer interrupt arrives,  which means the last local timer
> expires too. so,
> clockevents_program_event will return -ETIME, which will cause the
> dev->retries++
> when retry to program the expired timer.
> 
> Even under the worst case, after the re-program the expired timer,
> then CPU enter idle
> quickly before the re-progam timer expired, it will make system
> ping-pang forever,

That's nonsense.

The timer IPI brings the core out of the deep idle state.

So after returning from enter_wait_mode() and after calling
clockevents_notify() it returns from arch_idle() to cpu_idle().

In cpu_idle() interrupts are reenabled, so the timer IPI handler is
invoked. That calls the event_handler of the per cpu local clockevent
device (the one which stops in C3). That ends up in the generic timer
code which expires timers and reprograms the local clock event device
with the next pending timer.

So you cannot go idle again, before the expired timers of this event
are handled and their callbacks invoked.


Now the reprogramming itself is a different issue.

It's necessary as we have no information whether the wakeup was caused
by the timer IPI or by something else.

We might try to be clever and store the pending IPI in
tick_handle_oneshot_broadcast() and avoid the reprogramming in that
case. Completely untested patch below.

Thanks,

	tglx

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -29,6 +29,7 @@
 static struct tick_device tick_broadcast_device;
 /* FIXME: Use cpumask_var_t. */
 static DECLARE_BITMAP(tick_broadcast_mask, NR_CPUS);
+static DECLARE_BITMAP(tick_broadcast_pending, NR_CPUS);
 static DECLARE_BITMAP(tmpmask, NR_CPUS);
 static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
@@ -417,9 +418,10 @@ again:
 	/* Find all expired events */
 	for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
 		td = &per_cpu(tick_cpu_device, cpu);
-		if (td->evtdev->next_event.tv64 <= now.tv64)
+		if (td->evtdev->next_event.tv64 <= now.tv64) {
 			cpumask_set_cpu(cpu, to_cpumask(tmpmask));
-		else if (td->evtdev->next_event.tv64 < next_event.tv64)
+			set_bit(cpu, tick_broadcast_pending);
+		} else if (td->evtdev->next_event.tv64 < next_event.tv64)
 			next_event.tv64 = td->evtdev->next_event.tv64;
 	}
 
@@ -493,7 +495,8 @@ void tick_broadcast_oneshot_control(unsi
 			cpumask_clear_cpu(cpu,
 					  tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-			if (dev->next_event.tv64 != KTIME_MAX)
+			if (dev->next_event.tv64 != KTIME_MAX &&
+			    !test_and_clear_bit(cpu, tick_broadcast_pending))
 				tick_program_event(dev->next_event, 1);
 		}
 	}






