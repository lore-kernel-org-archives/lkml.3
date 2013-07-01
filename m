Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3GARtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:49:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:56456 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3GARtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:49:39 -0400
Date: Mon, 1 Jul 2013 19:49:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stehle Vincent-B46079 <B46079@freescale.com>
cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: next-20130627 breaks i.MX6 sabre sd UART console
In-Reply-To: <F7C43F8B2814514CA05F3436BC68046EF2F708@039-SN2MPN1-011.039d.mgd.msft.net>
Message-ID: <alpine.DEB.2.02.1307011531210.4013@ionos.tec.linutronix.de>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de> <51CDB26A.9060500@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
 <51CDC2B3.1030907@codeaurora.org> <20130629020738.GG11625@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2EF29@039-SN2MPN1-011.039d.mgd.msft.net> <alpine.DEB.2.02.1307011425500.4013@ionos.tec.linutronix.de>
 <F7C43F8B2814514CA05F3436BC68046EF2F708@039-SN2MPN1-011.039d.mgd.msft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Stehle Vincent-B46079 wrote:

> From: Thomas Gleixner [mailto:tglx@linutronix.de] 
> > (..) Can you please apply the patch below and provide the output?
> 
> Sure; thanks for the patch. The kernel seems to be in a loop, as it prints many messages and never stops. I copy only the first ones:
> 
> ...
> Switched to clocksource mxc_timer1
> next 800000000098967f nevt 7fffffffffffffff per 989680 nxtp 1c03a180 now 1c553a59

Yuck. nevt (dev->next_event) is KTIME_MAX. No surprise, that we end up
in an endless loop.

Now the question is how we did end up with that and how is that
related to the dummy timer.

>From your debug output we see that the dummy timer is installed before
the local timer. The dummytimer is disfunctional, so it requires
broadcast in the first place.

Now when we install the local timer the broadcast is not disabled,
because the local timer is affected by C3STOP. Now the CPU is not in a
power state which makes the broadcasting necessary, but the broadcast
code has no way to distinguish whether the broadcast bit is set due to
power state or due to a dummy timer.

That's clearly wrong as we end up with two periodic events for that
cpu (broadcast and local timer) as long as nothing calls into the
broadcast control code. That's fixable with some surgery.

Though that does not explain why dev->next_event is set to KTIME_MAX
after we installed the mxc_timer1 as the system clocksource. And we
really need to know why that happens. 

Here is some more debugging which should shine some light on that.

Thanks,

	tglx

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e86827e..b94aaf9 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -717,6 +717,7 @@ static int hrtimer_switch_to_hres(void)
 	tick_setup_sched_timer();
 	/* "Retrigger" the interrupt to get things going */
 	retrigger_next_event(NULL);
+	pr_err("Switched to highres mode %d\n", cpu);
 	local_irq_restore(flags);
 	return 1;
 }
@@ -1290,6 +1291,8 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
 
+	pr_err("hrtimer_interrupt %d %p\n", smp_processor_id(), dev);
+
 	raw_spin_lock(&cpu_base->lock);
 	entry_time = now = hrtimer_update_base(cpu_base);
 retry:
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 38959c8..331a30f 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -94,6 +94,8 @@ void clockevents_shutdown(struct clock_event_device *dev)
 {
 	clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 	dev->next_event.tv64 = KTIME_MAX;
+	pr_err("clockevents_shutdown %d %p\n", smp_processor_id(), dev);
+	WARN_ON(1);
 }
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 9d96a54..e3456d3 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -508,6 +508,7 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 	raw_spin_lock(&tick_broadcast_lock);
 again:
 	dev->next_event.tv64 = KTIME_MAX;
+	pr_err("oneshot_broadcast %d %p\n", smp_processor_id(), dev);
 	next_event.tv64 = KTIME_MAX;
 	cpumask_clear(tmpmask);
 	now = ktime_get();
@@ -736,6 +737,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			tick_broadcast_set_event(bc, cpu, tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
+		pr_err("bc_setup_oneshot %d %p\n", smp_processor_id(), bc);
 	} else {
 		/*
 		 * The first cpu which switches to oneshot mode sets
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index edd45f6..9606abb 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -28,6 +28,7 @@
  * Tick devices
  */
 DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
+static DEFINE_PER_CPU(int, ticks_handled);
 /*
  * Tick next event: keeps track of the tick time
  */
@@ -82,8 +83,10 @@ static void tick_periodic(int cpu)
 void tick_handle_periodic(struct clock_event_device *dev)
 {
 	int cpu = smp_processor_id();
+	int handled = __this_cpu_read(ticks_handled);
 	ktime_t next;
 
+	__this_cpu_inc(ticks_handled);
 	tick_periodic(cpu);
 
 	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
@@ -94,6 +97,13 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	 */
 	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
+		if (next.tv64 < 0) {
+			pr_err("next %llx nevt %llx per %llx nxtp %llx now %llx %d %p %d\n",
+			       next.tv64, dev->next_event.tv64,
+			       tick_period.tv64, tick_next_period.tv64,
+			       ktime_get().tv64, cpu, dev, handled);
+		}
+
 		if (!clockevents_program_event(dev, next, false))
 			return;
 		/*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0cf1c14..1531837 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -969,6 +969,7 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	ktime_t now = ktime_get();
 
 	dev->next_event.tv64 = KTIME_MAX;
+	pr_err("nohz_handler %d %p\n", smp_processor_id(), dev);
 
 	tick_sched_do_timer(now);
 	tick_sched_handle(ts, regs);
@@ -1012,6 +1013,7 @@ static void tick_nohz_switch_to_nohz(void)
 			break;
 		next = ktime_add(next, tick_period);
 	}
+	pr_err("Switched to nohz mode %d\n", smp_processor_id());
 	local_irq_enable();
 }
 
@@ -1180,6 +1182,8 @@ void tick_clock_notify(void)
 {
 	int cpu;
 
+	pr_err("tick_clock_notify\n");
+
 	for_each_possible_cpu(cpu)
 		set_bit(0, &per_cpu(tick_cpu_sched, cpu).check_clocks);
 }
