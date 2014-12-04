Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaLDADX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:03:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:56235 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaLDADV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:03:21 -0500
Date: Thu, 4 Dec 2014 01:03:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Stefan Agner <stefan@agner.ch>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "olof@lixom.net" <olof@lixom.net>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 03/12] irqchip: gic: define register_routable_domain_ops
 conditional
In-Reply-To: <547F5EBD.6040705@arm.com>
Message-ID: <alpine.DEB.2.11.1412040057090.16275@nanos>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-4-git-send-email-stefan@agner.ch> <5174649.NxPq80uDz8@wuerfel> <alpine.DEB.2.11.1412031303000.16275@nanos> <8eccedc781df2636a132dae449cbe774@agner.ch>
 <547F5EBD.6040705@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Marc Zyngier wrote:
> On 03/12/14 17:28, Stefan Agner wrote:
> > On 2014-12-03 14:04, Thomas Gleixner wrote:
> >> The shared interrupts are allocated through the router domain which
> >> decides whether the interrupt can be assigned to a particular core or
> >> not. If it can be assigned it allocates the corresponding interrupt in
> >> the parent domain, sets up the routing and everything just works.
> > 
> > What do you mean by the shared state in the drawing above? Currently, I
> > check whether a interrupt is already used by the other core by reading
> > the register (do this configuration register reflect the "shared state"
> > in your drawing?).
> 
> I think that is basically it. It should only be the register that
> decides on the actual routing. BTW, how do you arbitrate between
> concurrent accesses to this register? Or is only the A5 allowed to
> change it?

What I meant with 'shared state' is basically the configuration
register space. Plus depending on the mechanism you want to use for
correlating the routing between the A5 and the M4 some shared memory
state, locking, IPC or whatever you need for this.
 
> >> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=irq/irqdomain-arm
> >>
> > 
> > Thanks for the link. So my work would involve to support domain
> > hierarchy for NVIC (proper irq_domain_ops, introduce arm,routable-irqs
> > property, anything else?) and then make use of the hierarchy code in my
> > MSCM driver like for instance the mtk-sysirq driver...?
> 
> I don't think we need the arm,routable-irq property at all, and I'm
> looking at refactoring the crossbar thingy to remove most of its
> entanglement with the GIC.
> 
> All you need to know is the range of interrupts you're allowed to
> request through the "routable" domain. The inner-most irqchip shouldn't
> even know about it (after all, they are just wires coming in). It should
> be the duty of the outer-most irqchip (the "router") to generate the
> correct request to the GIC/NVIC. So all the knowledge should be at the
> router level.
> 
> The mtk-sysrq code is indeed a good example of what you can do.

The gic-v2m MSI stuff is probably helpful as well.
 
> > What is the state of the IRQ domain hierarchy, when will it go upstream?
> 
> Scheduled for 3.19, if everything goes according to plan. Don't think we
> can go back anyway... ;-)

Indeed. That would be a major headache...

Thanks,

	tglx

