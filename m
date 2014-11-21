Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaKUKlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:41:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:56019 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaKUKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:41:15 -0500
Date: Fri, 21 Nov 2014 11:41:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, patches@linaro.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] arm: imx: Workaround i.MX6 PMU interrupts muxed to
 one SPI
In-Reply-To: <546F0ACA.7010007@linaro.org>
Message-ID: <alpine.DEB.2.11.1411211138050.6439@nanos>
References: <1416483757-24165-1-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1411210016360.6439@nanos> <546F0ACA.7010007@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Daniel Thompson wrote:
> On 20/11/14 23:30, Thomas Gleixner wrote:
> > On Thu, 20 Nov 2014, Daniel Thompson wrote:
> >> +/*
> >> + * The PMU IRQ lines of all cores are muxed onto a single interrupt.
> >> + * Rotate the interrupt around the cores if the current CPU cannot
> >> + * figure out why the interrupt has been triggered.
> >> + */
> >> +static irqreturn_t imx6q_pmu_handler(int irq, void *dev, irq_handler_t handler)
> >> +{
> >> +	irqreturn_t ret = handler(irq, dev);
> >> +	int next;
> >> +
> >> +	if (ret == IRQ_NONE && num_online_cpus() > 1) {
> > 
> > What guarantees that ret == IRQ_HANDLED is a sign for 'this is only
> > for this particular core' interrupt ?
> 
> It isn't guaranteed. We rely on re-entering the interrupt handler if
> more than one PMU is raising the interrupt simultaneously.
> 
> > 
> >> +		next = cpumask_next(smp_processor_id(), cpu_online_mask);
> >> +		if (next > nr_cpu_ids)
> >> +			next = cpumask_next(-1, cpu_online_mask);
> >> +		irq_set_affinity(irq, cpumask_of(next));
> >> +	}
> > 
> > Aside of the fact, that the hardware designers who came up with such a
> > brainfart should be put on sane drugs, this is just silly.
> > 
> > Rotating that thing around will introduce arbitrary latencies and
> > dependencies on other interrupts to be handled.
> 
> To be honest I viewed the only real merits of the rotation workaround to
> be that it is simple and minimally invasive. I am in total agreement
> that there are profiling use cases that it will handle badly (although
> there are a useful set which this workaround is sufficient to support).
> 
> > So if there is really no way to figure out which of the cores is the
> > actual target of the PMU interrupt
> 
> PMU is only accessible via the bus if you are a external debugger
> (signals external to the cluster control the register windowing). From
> the kernel we have to use the co-processor interface and can only see
> our own PMU.
> 
> > then you should simply broadcast
> > that interrupt to a designated per cpu vector async from the one which
> > handles it in the first place and be done with it. That's the only
> > sane option you have.
> 
> As it happens I was planning to do some work on rebroadcasting next
> anyway regardless of this discussion because I can't call
> irq_set_affinity() from a FIQ handler...
> 
> Options I considered to rebroadcast are either direct use of an (new and
> ARM specific?) IPI or use of smp_call_function() from a tasklet. I was

> inclined to rule out the tasklet because it has the potential for far
> greater timing jitter than rotating the affinity (doesn't it?).

You cannot schedule a tasklet from FIQ. The only options you have are:

    - Async IPI (direct call into the architecture code). I have no
      idea whether thats possible on ARm

    - irq_work

Thanks,

	tglx

 
