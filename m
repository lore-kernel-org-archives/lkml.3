Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3BVMHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:07:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:57264 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab3BVMHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:07:34 -0500
Date: Fri, 22 Feb 2013 13:07:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
In-Reply-To: <51275058.7010809@ti.com>
Message-ID: <alpine.LFD.2.02.1302221212500.22263@ionos>
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com> <alpine.LFD.2.02.1302201400400.22263@ionos> <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com> <alpine.LFD.2.02.1302211015270.22263@ionos>
 <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com> <alpine.LFD.2.02.1302211436300.22263@ionos> <51263975.20906@ti.com> <alpine.LFD.2.02.1302212214020.22263@ionos> <5127436E.4040100@ti.com> <alpine.LFD.2.02.1302221122290.22263@ionos>
 <20130222103149.GC12140@e102568-lin.cambridge.arm.com> <51275058.7010809@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Santosh Shilimkar wrote:

> On Friday 22 February 2013 04:01 PM, Lorenzo Pieralisi wrote:
> > On Fri, Feb 22, 2013 at 10:24:00AM +0000, Thomas Gleixner wrote:
> > > On Fri, 22 Feb 2013, Santosh Shilimkar wrote:
> > > > BTW, Lorenzo off-list mentioned to me about warning in boot-up
> > > > which I missed while testing your patch. It will take bit more
> > > > time for me to look into it and hence thought of reporting it.
> > > > 
> > > > [    2.186126] ------------[ cut here ]------------
> > > > [    2.190979] WARNING: at kernel/time/tick-broadcast.c:501
> > > > tick_broadcast_oneshot_control+0x1c0/0x21c()
> > > 
> > > Which one is that? tick_broadcast_pending or tick_force_broadcast_mask ?
> > 
> > It is the tick_force_broadcast_mask and I think that's because on all
> > systems we are testing, the broadcast timer IRQ is a thundering herd,
> > all CPUs get out of idle at once and try to get out of broadcast mode
> > at more or less the same time.
> > 
> So the issue comes ups only when the idle state used where CPU wakeup
> more or less at same time as Lorenzo mentioned. I have two platforms
> where I could test the patch and see the issue only with one platform.
> 
> Yesterday I didn't notice the warning because it wasn't seen on that
> platform :-) OMAP4 idle entry and exit in deep state is staggered
> between CPUs and hence the warning isn't seen. On OMAP5 though,
> there is an additional C-state where idle entry/exit for CPU
> isn't staggered and I see the issue in that case.
> 
> Actually the broad-cast code doesn't expect such a behavior
> from CPUs since only the broad-cast affine CPU should wake
> up and rest of the CPU should be woken up by the broad-cast
> IPIs.

That's what I feared. We might have the same issue on x86, depending
on the cpu model.

But thinking more about it. It's actually not a real problem, just
pointless burning of cpu cycles.

So on the CPU which gets woken along with the target CPU of the
broadcast the following happens:

  deep_idle()
			<-- spurious wakeup
  broadcast_exit()
    set forced bit
  
  enable interrupts
    
			<-- Nothing happens

  disable interrupts

  broadcast_enter()
			<-- Here we observe the forced bit is set
  deep_idle()

Now after that the target CPU of the broadcast runs the broadcast
handler and finds the other CPU in both the broadcast and the forced
mask, sends the IPI and stuff gets back to normal.

So it's not actually harmful, just more evidence for the theory, that
hardware designers have access to very special drug supplies.

Now we could make use of that and avoid going deep idle just to come
back right away via the IPI. Unfortunately the notification thingy has
no return value, but we can fix that.

To confirm that theory, could you please try the hack below and add
some instrumentation (trace_printk)?

Thanks,

	tglx

Index: linux-2.6/arch/arm/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/process.c
+++ linux-2.6/arch/arm/kernel/process.c
@@ -199,7 +199,7 @@ void cpu_idle(void)
 #ifdef CONFIG_PL310_ERRATA_769419
 			wmb();
 #endif
-			if (hlt_counter) {
+			if (hlt_counter || tick_check_broadcast_pending()) {
 				local_irq_enable();
 				cpu_relax();
 			} else if (!need_resched()) {
Index: linux-2.6/include/linux/clockchips.h
===================================================================
--- linux-2.6.orig/include/linux/clockchips.h
+++ linux-2.6/include/linux/clockchips.h
@@ -170,6 +170,12 @@ extern void tick_broadcast(const struct 
 extern int tick_receive_broadcast(void);
 #endif
 
+#if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
+extern int tick_check_broadcast_pending(void);
+#else
+static inline int tick_check_broadcast_pending(void) { return 0; }
+#endif
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -418,6 +418,15 @@ static int tick_broadcast_set_event(ktim
 	return clockevents_program_event(bc, expires, force);
 }
 
+/*
+ * Called before going idle with interrupts disabled. Checks whether a
+ * broadcast event from the other core is about to happen.
+ */
+int tick_check_broadcast_pending(void)
+{
+	return test_bit(smp_processor_id(), tick_force_broadcast_mask);
+}
+
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
 	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);




