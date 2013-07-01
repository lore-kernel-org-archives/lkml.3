Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3GAUOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:14:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:56963 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab3GAUOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:14:10 -0400
Date: Mon, 1 Jul 2013 22:14:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Stehle Vincent-B46079 <B46079@freescale.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: next-20130627 breaks i.MX6 sabre sd UART console
In-Reply-To: <51D1DD6D.8050805@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de> <51CDB26A.9060500@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
 <51CDC2B3.1030907@codeaurora.org> <20130629020738.GG11625@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2EF29@039-SN2MPN1-011.039d.mgd.msft.net> <alpine.DEB.2.02.1307011425500.4013@ionos.tec.linutronix.de> <F7C43F8B2814514CA05F3436BC68046EF2F708@039-SN2MPN1-011.039d.mgd.msft.net>
 <alpine.DEB.2.02.1307011531210.4013@ionos.tec.linutronix.de> <51D1DD6D.8050805@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Stephen Boyd wrote:
> On 07/01/13 10:49, Thomas Gleixner wrote:
> >
> > Though that does not explain why dev->next_event is set to KTIME_MAX
> > after we installed the mxc_timer1 as the system clocksource. And we
> > really need to know why that happens. 
> >
> > Here is some more debugging which should shine some light on that.
> 
> Each local_timer clockevent should have their next_event set for
> KTIME_MAX when they're registered because they get "shutdown" initially.

Yes.

> twd timers support both periodic and oneshot, so we won't emulate
> periodic mode with oneshot mode. Looking at tick_setup_periodic() it
> looks like the next_event member is ignored and we just set the mode to
> periodic. KTIME_MAX should still be there. That should be fine though as
> long as we don't switch the tick device into oneshot mode.

Correct.
 
> It seems that someone is switching the tick device into oneshot mode
> without changing the event handler away from tick_handle_periodic(). Is
> that supposed to happen? Most clockevents_set_mode(ONESHOT) calls are
> prefaced with a handler change or they're operating on the broadcast
> device. I suspect that tick_check_oneshot_broadcast() is the bad one.
> That one changes the mode and then tick_handle_periodic() probably runs
> past that if check and starts trying to emulate periodic mode when
> next_event is still KTIME_MAX.

The issue is very subtle. What happens is:

CPU0						CPU1

Switch to oneshot mode

 Copy the bits from tick_broadcast_mask to
 tick_broadcast_oneshot_mask. We need to do
 that so the other cpus reach the timer irq
 and the softirq which switches them to
 oneshot.

 Kick the broadcast device into oneshot.

						Timer interrupt fires
						
						irq_enter sees the cpu in
						tick_broadcast_oneshot_mask and
						sets the device to oneshot mode
						
						handle_periodic:
						 Sees oneshot mode and adds
						 period to
						 dev->next_event(KTIME_MAX)
						 
So we need two fixes:

1) The replacement of the dummy timer and the effect on the broadcast
   mask/device

2) tick_check_oneshot_broadcast needs a sanity check

Patch below.

Thanks,

	tglx
---
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 9d96a54..58d69eb 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -30,6 +30,7 @@
 
 static struct tick_device tick_broadcast_device;
 static cpumask_var_t tick_broadcast_mask;
+static cpumask_var_t tick_broadcast_on;
 static cpumask_var_t tmpmask;
 static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
@@ -140,8 +141,9 @@ static void tick_device_setup_broadcast_func(struct clock_event_device *dev)
  */
 int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 {
+	struct clock_event_device *bc = tick_broadcast_device.evtdev;
 	unsigned long flags;
-	int ret = 0;
+	int ret;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -155,22 +157,65 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 		dev->event_handler = tick_handle_periodic;
 		tick_device_setup_broadcast_func(dev);
 		cpumask_set_cpu(cpu, tick_broadcast_mask);
-		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
+		tick_broadcast_start_periodic(bc);
 		ret = 1;
 	} else {
+		int cpubc = cpumask_test_cpu(cpu, tick_broadcast_on);
+		int devc3 = dev->features & CLOCK_EVT_FEAT_C3STOP;
+
+		if (devc3)
+			tick_device_setup_broadcast_func(dev);
 		/*
-		 * When the new device is not affected by the stop
-		 * feature and the cpu is marked in the broadcast mask
-		 * then clear the broadcast bit.
+		 * If broadcast mode is enforced, leave the broadcast
+		 * mask alone.
 		 */
-		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
-			int cpu = smp_processor_id();
-			cpumask_clear_cpu(cpu, tick_broadcast_mask);
+		if (!tick_broadcast_force) {
+			/*
+			 * Clear the broadcast bit for this cpu if the
+			 * device is not powerstate affected or the
+			 * cpu is not in the broadcast ON mode
+			 */
+			if (!devc3 || !cpubc)
+				cpumask_clear_cpu(cpu, tick_broadcast_mask);
+		}
+
+		switch (tick_broadcast_device.mode) {
+		case TICKDEV_MODE_ONESHOT:
+			/*
+			 * If the system is in oneshot mode we can
+			 * unconditionally clear the oneshot mask,
+			 * because the CPU is running and therefor not
+			 * in an idle state which causes the C3
+			 * affected device to stop. Let the caller
+			 * initialize the device.
+			 */
 			tick_broadcast_clear_oneshot(cpu);
-		} else {
-			tick_device_setup_broadcast_func(dev);
+			ret = 0;
+			break;
+
+		case TICKDEV_MODE_PERIODIC:
+			/*
+			 * If the system is in periodic mode, check
+			 * whether the broadcast device can be
+			 * switched off now.
+			 */
+			if (cpumask_empty(tick_broadcast_mask) && bc)
+				clockevents_shutdown(bc);
+			/*
+			 * If we kept the cpu in the broadcast mask,
+			 * tell the core code to leave it alone and
+			 * leave the per cpu device in shutdown
+			 * state.
+			 */
+			ret = cpumask_test_cpu(cpu, tick_broadcast_mask);
+			break;
+		default:
+			/* Nothing to do */
+			ret = 0;
+			break;
 		}
 	}
+
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 	return ret;
 }
@@ -298,6 +343,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
+		cpumask_set_cpu(cpu, tick_broadcast_on);
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
@@ -307,8 +353,12 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 			tick_broadcast_force = 1;
 		break;
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
-		if (!tick_broadcast_force &&
-		    cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
+		if (tick_broadcast_force)
+			break;
+		cpumask_clear_cpu(cpu, tick_broadcast_on);
+		if (!tick_device_is_functional(dev))
+			break;
+		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
@@ -366,6 +416,7 @@ void tick_shutdown_broadcast(unsigned int *cpup)
 
 	bc = tick_broadcast_device.evtdev;
 	cpumask_clear_cpu(cpu, tick_broadcast_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_on);
 
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC) {
 		if (bc && cpumask_empty(tick_broadcast_mask))
@@ -492,7 +543,15 @@ void tick_check_oneshot_broadcast(int cpu)
 	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
-		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
+		/*
+		 * We might be in the middle of switching over from
+		 * periodic to oneshot. If the CPU has not yet
+		 * switched over, leave the device alone.
+		 */
+		if (td->mode == TICKDEV_MODE_ONESHOT) {
+			clockevents_set_mode(td->evtdev,
+					     CLOCK_EVT_MODE_ONESHOT);
+		}
 	}
 }
 
@@ -809,6 +868,7 @@ bool tick_broadcast_oneshot_available(void)
 void __init tick_broadcast_init(void)
 {
 	zalloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_on, GFP_NOWAIT);
 	zalloc_cpumask_var(&tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_TICK_ONESHOT
 	zalloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index edd45f6..5e3ed78 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -194,7 +194,8 @@ static void tick_setup_device(struct tick_device *td,
 	 * When global broadcasting is active, check if the current
 	 * device is registered as a placeholder for broadcast mode.
 	 * This allows us to handle this x86 misfeature in a generic
-	 * way.
+	 * way. This function also returns !=0 when we keep the
+	 * current active broadcast state.
 	 */
 	if (tick_device_uses_broadcast(newdev, cpu))
 		return;
