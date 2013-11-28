Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab3K1Sgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:36:37 -0500
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:10001
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603Ab3K1Sgd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:36:33 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h906i1155h)
Date: Thu, 28 Nov 2013 10:36:16 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 4/9] clocksource/cadence_ttc: Use enable/disable_irq
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
 <1385514296-26702-5-git-send-email-soren.brinkmann@xilinx.com>
 <52972F3A.9090103@linaro.org>
 <alpine.DEB.2.02.1311281507280.30673@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311281507280.30673@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <b2ed3cbc-c9df-4235-8137-93514c05bffa@DB8EHSMHS031.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thu, Nov 28, 2013 at 03:18:50PM +0100, Thomas Gleixner wrote:
> On Thu, 28 Nov 2013, Daniel Lezcano wrote:
> 
> > On 11/27/2013 02:04 AM, Soren Brinkmann wrote:
> > > To ensure that the timer interrupt is properly enabled/disabled across
> > > the whole CPU cluster use enable/disable_irq() instead of
> > > local_irq_disable().
> > > 
> > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > ---
> > >   drivers/clocksource/cadence_ttc_timer.c | 6 ++----
> > >   1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/clocksource/cadence_ttc_timer.c
> > > b/drivers/clocksource/cadence_ttc_timer.c
> > > index a92350b55d32..246d018d1e63 100644
> > > --- a/drivers/clocksource/cadence_ttc_timer.c
> > > +++ b/drivers/clocksource/cadence_ttc_timer.c
> > > @@ -322,18 +322,16 @@ static int ttc_rate_change_clockevent_cb(struct
> > > notifier_block *nb,
> > >   	switch (event) {
> > >   	case POST_RATE_CHANGE:
> > >   	{
> > > -		unsigned long flags;
> > > -
> > >   		/*
> > >   		 * clockevents_update_freq should be called with IRQ disabled
> > > on
> > >   		 * the CPU the timer provides events for. The timer we use is
> > >   		 * common to both CPUs, not sure if we need to run on both
> > >   		 * cores.
> 
> Can we adjust that bogus comment as well, please?
I can remove that comment. I'll see if including it in one of the
existing patches or adding another patch for it makes sense.

> 
> > >   		 */
> > > -		local_irq_save(flags);
> > > +		disable_irq(ttcce->ce.irq);
> > >   		clockevents_update_freq(&ttcce->ce,
> > >   				ndata->new_rate / PRESCALE);
> > > -		local_irq_restore(flags);
> > > +		enable_irq(ttcce->ce.irq);
> > > 
> > >   		/* update cached frequency */
> > >   		ttc->freq = ndata->new_rate;
> > > 
> > 
> > I am worried about the 'disable_irq' function calling 'synchronize_irq'. Isn't
> > possible to deadlock with the ondemand cpufreq governor ? I added Viresh in
> > Cc, he knows better than me the code path.
> 
> disable_irq() will only deadlock if called from the interrupt handler
> of the device interrupt itself or when the calling code is holding
> locks which prevent the function to proceed.
> 
> But what's more important is, that the patch violates the calling
> convention of clockevents_update_freq(). It must be called with
> interrupts disabled. 
> 
> Now the problem with this device is that it is not a per cpu
> device. It's a global device, so this update can conflict with a
> parallel access on the other CPU. Now the disable_irq() only prevents
> that the other CPU can handle a device interrupt from that timer. But
> it does not prevent any parallel access from e.g. the idle code path
> which will try to reprogram it.
Does that mean interrupts need to be disabled globally? Also, does the
cpuidle path depend on interrupts or can it interfere no matter what?

> 
> Soren, is that timer used as the broadcast device ?
Yes, this is the only broadcast capable timer on Zynq, AFAIK. Other than
the TTC we only have the arm_global_timer and smp_twd timers, which both
are per_cpu devices and thus not broadcast capable.

	Sören


