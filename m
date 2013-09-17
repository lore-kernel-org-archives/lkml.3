Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3IQL1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:27:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:52538 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3IQL1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:27:09 -0400
Date: Tue, 17 Sep 2013 13:26:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, Marc Pignat <marc.pignat@hevs.ch>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Ronald Wahl <ronald.wahl@raritan.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [PATCH] clocksource: tcb: fix min_delta calculation
In-Reply-To: <20130917100417.GQ12758@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de>
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de> <20130917095600.GJ26819@ludovic.desroches@atmel.com> <20130917100417.GQ12758@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013, Russell King - ARM Linux wrote:

> On Tue, Sep 17, 2013 at 11:56:00AM +0200, Ludovic Desroches wrote:
> > Any reason to not do this:
> > 
> > --- a/drivers/clocksource/tcb_clksrc.c
> > +++ b/drivers/clocksource/tcb_clksrc.c
> > @@ -144,6 +144,9 @@ static void tc_mode(enum clock_event_mode m, struct
> > clock_event_device *d)
> >  
> >  static int tc_next_event(unsigned long delta, struct clock_event_device
> > *d)
> >  {
> > +       if (delta < d->min_delta_ticks)
> > +               delta = d->min_delta_ticks;
> > +
> >         __raw_writel(delta, tcaddr + ATMEL_TC_REG(2, RC));
> >  
> >         /* go go gadget! */
> > 
> > Then we can keep the same min_delta.
> 
> You really should not play such games in your set_next_event() code - if
> the interval is not supported, you should return -ETIME so that the core
> code knows about it and can adjust things to suit.  If you're getting
> deltas which are too small for the hardware, that'll either be because
> the bounds are wrong, or there's a bug in the core code.

The core code does:

int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
                              bool force)
{
....

        delta = min(delta, (int64_t) dev->max_delta_ns);
        delta = max(delta, (int64_t) dev->min_delta_ns);

        clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
        rc = dev->set_next_event((unsigned long) clc, dev);

} 

So, the min_delta in timer ticks is set to 1 and converted by the core
to nsecs for various reasons. This is where the rounding problem comes
into play.

The patch below should fix that.

Thanks,

	tglx
----
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 38959c8..41b7a30 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -42,7 +42,7 @@ struct ce_unbind {
  */
 u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
 {
-	u64 clc = (u64) latch << evt->shift;
+	u64 tmp, clc = (u64) latch << evt->shift;
 
 	if (unlikely(!evt->mult)) {
 		evt->mult = 1;
@@ -52,6 +52,14 @@ u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
 	do_div(clc, evt->mult);
 	if (clc < 1000)
 		clc = 1000;
+
+	/* Avoid rounding artifacts */
+	tmp = (clc * dev->mult) >> dev->shift;
+	while (tmp < (u64) dev->min_delta_ticks) {
+		clc += 1000;
+		tmp = (clc * dev->mult) >> dev->shift;
+	}
+
 	if (clc > KTIME_MAX)
 		clc = KTIME_MAX;
 
