Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3BUNsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:48:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:48749 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3BUNsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:48:23 -0500
Date: Thu, 21 Feb 2013 14:48:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Liu <liu.h.jason@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
In-Reply-To: <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302211436300.22263@ionos>
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com> <alpine.LFD.2.02.1302201400400.22263@ionos> <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com> <alpine.LFD.2.02.1302211015270.22263@ionos>
 <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

On Thu, 21 Feb 2013, Jason Liu wrote:
> 2013/2/21 Thomas Gleixner <tglx@linutronix.de>:
> > Now your explanation makes sense.
> >
> > I have no fast solution for this, but I think that I have an idea how
> > to fix it. Stay tuned.
> 
> Thanks Thomas, wait for your fix. :)

find below a completely untested patch, which should address that issue.

Sigh. Stopping the cpu local timer in deep idle is known to be an
idiotic design decision for 10+ years. I'll never understand why ARM
vendors insist on implementing the same stupidity over and over.

Thanks,

	tglx

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -397,6 +397,8 @@ int tick_resume_broadcast(void)
 
 /* FIXME: use cpumask_var_t. */
 static DECLARE_BITMAP(tick_broadcast_oneshot_mask, NR_CPUS);
+static DECLARE_BITMAP(tick_broadcast_pending, NR_CPUS);
+static DECLARE_BITMAP(tick_force_broadcast_mask, NR_CPUS);
 
 /*
  * Exposed for debugging: see timer_list.c
@@ -453,12 +455,24 @@ again:
 	/* Find all expired events */
 	for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
 		td = &per_cpu(tick_cpu_device, cpu);
-		if (td->evtdev->next_event.tv64 <= now.tv64)
+		if (td->evtdev->next_event.tv64 <= now.tv64) {
 			cpumask_set_cpu(cpu, to_cpumask(tmpmask));
-		else if (td->evtdev->next_event.tv64 < next_event.tv64)
+			/*
+			 * Mark the remote cpu in the pending mask, so
+			 * it can avoid reprogramming the cpu local
+			 * timer in tick_broadcast_oneshot_control().
+			 */
+			set_bit(cpu, tick_broadcast_pending);
+		} else if (td->evtdev->next_event.tv64 < next_event.tv64)
 			next_event.tv64 = td->evtdev->next_event.tv64;
 	}
 
+	/* Take care of enforced broadcast requests */
+	for_each_cpu(cpu, to_cpumask(tick_force_broadcast_mask)) {
+		set_bit(cpu, tmpmask);
+		clear_bit(cpu, tick_force_broadcast_mask);
+	}
+
 	/*
 	 * Wakeup the cpus which have an expired event.
 	 */
@@ -494,6 +508,7 @@ void tick_broadcast_oneshot_control(unsi
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags;
+	ktime_t now;
 	int cpu;
 
 	/*
@@ -518,6 +533,8 @@ void tick_broadcast_oneshot_control(unsi
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
+		WARN_ON_ONCE(test_bit(cpu, tick_broadcast_pending));
+		WARN_ON_ONCE(test_bit(cpu, tick_force_broadcast_mask));
 		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
 			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
@@ -529,10 +546,63 @@ void tick_broadcast_oneshot_control(unsi
 			cpumask_clear_cpu(cpu,
 					  tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-			if (dev->next_event.tv64 != KTIME_MAX)
-				tick_program_event(dev->next_event, 1);
+			if (dev->next_event.tv64 == KTIME_MAX)
+				goto out;
+			/*
+			 * The cpu handling the broadcast timer marked
+			 * this cpu in the broadcast pending mask and
+			 * fired the broadcast IPI. So we are going to
+			 * handle the expired event anyway via the
+			 * broadcast IPI handler. No need to reprogram
+			 * the timer with an already expired event.
+			 */
+			if (test_and_clear_bit(cpu, tick_broadcast_pending))
+				goto out;
+			/*
+			 * If the pending bit is not set, then we are
+			 * either the CPU handling the broadcast
+			 * interrupt or we got woken by something else.
+			 *
+			 * We are not longer in the broadcast mask, so
+			 * if the cpu local expiry time is already
+			 * reached, we would reprogram the cpu local
+			 * timer with an already expired event.
+			 *
+			 * This can lead to a ping-pong when we return
+			 * to idle and therefor rearm the broadcast
+			 * timer before the cpu local timer was able
+			 * to fire. This happens because the forced
+			 * reprogramming makes sure that the event
+			 * will happen in the future and depending on
+			 * the min_delta setting this might be far
+			 * enough out that the ping-pong starts.
+			 *
+			 * If the cpu local next_event has expired
+			 * then we know that the broadcast timer
+			 * next_event has expired as well and
+			 * broadcast is about to be handled. So we
+			 * avoid reprogramming and enforce that the
+			 * broadcast handler, which did not run yet,
+			 * will invoke the cpu local handler.
+			 *
+			 * We cannot call the handler directly from
+			 * here, because we might be in a NOHZ phase
+			 * and we did not go through the irq_enter()
+			 * nohz fixups.
+			 */
+			now = ktime_get();
+			if (dev->next_event.tv64 <= now.tv64) {
+				set_bit(cpu, tick_force_broadcast_mask);
+				goto out;
+			}
+			/*
+			 * We got woken by something else. Reprogram
+			 * the cpu local timer device.
+			 */
+			tick_program_event(dev->next_event, 1);
 		}
 	}
+out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
