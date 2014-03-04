Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaCDVbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:31:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:37358 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbaCDVbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:31:33 -0500
Date: Tue, 4 Mar 2014 22:31:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V3 1/5] genirq: define flag IRQ_SRC_DST_INVERTED, and
 accessors
In-Reply-To: <5315F7DB.6000700@wwwdotorg.org>
Message-ID: <alpine.DEB.2.02.1403042203220.18573@ionos.tec.linutronix.de>
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org> <alpine.DEB.2.02.1403041018370.18573@ionos.tec.linutronix.de> <5315F7DB.6000700@wwwdotorg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Mar 2014, Stephen Warren wrote:

> On 03/04/2014 03:04 AM, Thomas Gleixner wrote:
> > On Mon, 3 Mar 2014, Stephen Warren wrote:
> > 
> >> From: Stephen Warren <swarren@nvidia.com>
> >>
> >> Some devices have configurable IRQ output polarities. Software might
> >> use IRQ_TYPE_* to determine how to configure such a device's IRQ
> >> output polarity in order to match how the IRQ controller input is
> >> configured. If the board or SoC inverts the signal between the
> >> device's IRQ output and controller's IRQ output, software must be
> >> aware of this fact, in order to program the IRQ output to the correct
> >> (i.e. opposite) polarity. This flag provides that information.
> > 
> > So what you're saying is:
> > 
> > Device IRQ output --> [Optional Inverter Logic] --> IRQ controller input.
> > 
> > And you're storing the information about the presence of the inverter
> > logic in the irq itself, but the core does not make any use of it and
> > you let the device driver deal with the outcome.
> > 
> > This sucks as all affected drivers have to implement the same sanity
> > logic for this.
> > 
> > Why don't you implement a core function which tells the driver which
> > polarity to select? That requires a few more changes, but I think it's
> > worth it for other reasons.
> > 
> > Right now the set_type logic requires the irq chip drivers to
> > implement sanity checking and default selections for TYPE_NONE. We can
> > be more clever about that and add this information to the irq chip
> > flags.
> 
> I don't see any such checking in drivers/irqchip/irq-gic.c; it rejects
> any type other than IRQ_TYPE_LEVEL_HIGH or IRQ_TYPE_EDGE_RISING, and I
> don't see any mention of TYPE_NONE in that file. Is the driver incomplete?

No. The IRQ_TYPE_NONE is a hysterical leftover.
 
> Instead of adding all this extra logic to the core, what do you think of
> simply telling each driver that has a configurable interrupt output
> polarity exactly which polarity to use. This information would come from
> device tree or platform data. This is what I implemented in V1/V2 of
> this series:
>
> http://www.spinics.net/lists/devicetree/msg23648.html
> 
> Is that any better, or do you definitely want the IRQ core to manage this?

Oh, yes.

Simply because any driver which is not aware of that inversion will
trip over the issue that it requests by the best of its knowledge
IRQ_TYPE_LEVEL_HIGH while it should actually request
IRQ_TYPE_LEVEL_LOW due to the inversion.

Are you really going to make all possibly affected drivers aware of
that? Good luck!

That's why we want to move such stuff to core code. Assume the
following scenario:

    driverX which works perfectly fine on SoCA is reused for SoCB
    where the inverter sits between the device and the SoCB irq
    controller.

With your DT scheme the whole thing falls flat on the nose simply
because neither the driverX nor the core code is aware of the
incompability.

So driverX is happily using the IRQ_TYPE_LEVEL_HIGH setting which was
used when the driver was written and the core works nicely with that
because the irq chips supports IRQ_TYPE_LEVEL_HIGH. Just the fact that
the inverter is in the hardware results in an infinite interrupt
storm. Are you going to handle the bug reports and "remote" debug
sessions for this kind of crap?

Fuck no. You don't want to deal with this and that's why it is way
better to build that kind of support into the core where everything
which trips over the issue tells the random driver user/developer
what's wrong.

Dammit. I explained you very detailed WHY this is useful aside of the
inverted logic situation. Is it that hard to understand?

This usecase clearly shows a shortcoming at the core level along with
a potential for consolidation. So why are you trying to convince me
that this can be solved with some DT/device drivers hackery?

When will you SoC folks ever understand that nothing on your
SoCs/board is special? I'm telling that you for years but you simply
refuse to get a gripe.

Thanks,

	tglx



 
