Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab3K1OTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:19:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:57678 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab3K1OTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:19:05 -0500
Date: Thu, 28 Nov 2013 15:18:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/9] clocksource/cadence_ttc: Use enable/disable_irq
In-Reply-To: <52972F3A.9090103@linaro.org>
Message-ID: <alpine.DEB.2.02.1311281507280.30673@ionos.tec.linutronix.de>
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com> <1385514296-26702-5-git-send-email-soren.brinkmann@xilinx.com> <52972F3A.9090103@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013, Daniel Lezcano wrote:

> On 11/27/2013 02:04 AM, Soren Brinkmann wrote:
> > To ensure that the timer interrupt is properly enabled/disabled across
> > the whole CPU cluster use enable/disable_irq() instead of
> > local_irq_disable().
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >   drivers/clocksource/cadence_ttc_timer.c | 6 ++----
> >   1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/clocksource/cadence_ttc_timer.c
> > b/drivers/clocksource/cadence_ttc_timer.c
> > index a92350b55d32..246d018d1e63 100644
> > --- a/drivers/clocksource/cadence_ttc_timer.c
> > +++ b/drivers/clocksource/cadence_ttc_timer.c
> > @@ -322,18 +322,16 @@ static int ttc_rate_change_clockevent_cb(struct
> > notifier_block *nb,
> >   	switch (event) {
> >   	case POST_RATE_CHANGE:
> >   	{
> > -		unsigned long flags;
> > -
> >   		/*
> >   		 * clockevents_update_freq should be called with IRQ disabled
> > on
> >   		 * the CPU the timer provides events for. The timer we use is
> >   		 * common to both CPUs, not sure if we need to run on both
> >   		 * cores.

Can we adjust that bogus comment as well, please?

> >   		 */
> > -		local_irq_save(flags);
> > +		disable_irq(ttcce->ce.irq);
> >   		clockevents_update_freq(&ttcce->ce,
> >   				ndata->new_rate / PRESCALE);
> > -		local_irq_restore(flags);
> > +		enable_irq(ttcce->ce.irq);
> > 
> >   		/* update cached frequency */
> >   		ttc->freq = ndata->new_rate;
> > 
> 
> I am worried about the 'disable_irq' function calling 'synchronize_irq'. Isn't
> possible to deadlock with the ondemand cpufreq governor ? I added Viresh in
> Cc, he knows better than me the code path.

disable_irq() will only deadlock if called from the interrupt handler
of the device interrupt itself or when the calling code is holding
locks which prevent the function to proceed.

But what's more important is, that the patch violates the calling
convention of clockevents_update_freq(). It must be called with
interrupts disabled. 

Now the problem with this device is that it is not a per cpu
device. It's a global device, so this update can conflict with a
parallel access on the other CPU. Now the disable_irq() only prevents
that the other CPU can handle a device interrupt from that timer. But
it does not prevent any parallel access from e.g. the idle code path
which will try to reprogram it.

Soren, is that timer used as the broadcast device ?

Thanks,

	tglx



