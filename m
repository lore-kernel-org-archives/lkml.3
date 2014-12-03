Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaLCNEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:04:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:53658 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaLCNE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:04:28 -0500
Date: Wed, 3 Dec 2014 14:04:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Stefan Agner <stefan@agner.ch>, shawn.guo@linaro.org,
        kernel@pengutronix.de, Russell King <linux@arm.linux.org.uk>,
        u.kleine-koenig@pengutronix.de, Jason Cooper <jason@lakedaemon.net>,
        olof@lixom.net, daniel.lezcano@linaro.org, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 03/12] irqchip: gic: define register_routable_domain_ops
 conditional
In-Reply-To: <5174649.NxPq80uDz8@wuerfel>
Message-ID: <alpine.DEB.2.11.1412031303000.16275@nanos>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-4-git-send-email-stefan@agner.ch> <5174649.NxPq80uDz8@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Arnd Bergmann wrote:

> On Wednesday 03 December 2014 01:12:02 Stefan Agner wrote:
> > The inline function register_routable_domain_ops is only usable if
> > CONFIG_ARM_GIC is set. Make it depend on this configuration. This
> > also allows other SoC interrupt controller to provide such a
> > function.
> > 
> > Signed-off-by: Stefan Agner <stefan@agner.ch>
> 
> I don't think this is a good idea: either the interface is meant
> to be generic and should work with any interrupt controller, or
> it is specific to one irqchip and another irqchip should provide
> a different interface that has a nonconflicting name.
> 
> I suppose you want the latter here, given that the declaration
> is part of the gic specific header file.

That routable_domain stuff should have never been invented. In
hindsight we should have done the stacked irq domains back then
already, but in hindsight ...

If you look at the crossbar scheme what we have now:

   GIC domain
|--------------|
|              |---------- private
| non routable |---------- peripheral
|              |---------- peripheral
|              |
|--------------|
|              |---------- peripheral
|   routable   |---------- peripheral
|    |         |---------- peripheral
|--------------|
     |               |----------------|
     |-------------->| crossbar magic |
                     |----------------|

which is not how the hardware looks. The hardware actually looks like
this:

   GIC domain
|--------------|
|              |---------- private
| non routable |---------- peripheral
|              |---------- peripheral
|              |
|--------------|           |--------------|
|              |           |              |---------- peripheral
|   routable   |-----------| crossbar     |---------- peripheral
|              |           | domain       |---------- peripheral
|--------------|           |--------------|

So it is completely obvious that the peripheral interrupts which need
to be routed through the crossbar belong to a different domain. We
really should convert crossbar to that scheme and get rid of the
routable domain stuff completely.

With vybrid thats not different according to the diagram in the
reference manual.

  GIC domain
|--------------|
|              |---------- private
| non routable |---------- peripheral
|              |---------- peripheral
|              |
|--------------|           |--------------|
|              |           |              |
|   routable   |-----------|  IRQ router  |
|              |           |  domain      |
|              |           |              |
|--------------|           |--------------|
                           | Shared state |---------- CPU to CPU 
  NVIC domain              | and hardware |---------- peripheral
|--------------|           |              |---------- peripheral
|              |           |--------------|
|              |           |              |
|   routable   |-----------|  IRQ router  |
|              |           |  domain      |
|              |           |              |
|--------------|           |--------------|
|              |
|              |---------- private
| non routable |---------- peripheral
|              |---------- peripheral
|--------------|

The routable domain stuff is just an adhoc redirector which must be
tied to a particular base irq chip implementation (i.e. GIC). With
stacked irq domains there is no dependency on the underlying irq
chip. No ifdeffery, nothing. So you can use the same router domain
implementation for both the A5 and the M4 side.

On the A5 side the router domain has the gic domain as parent and on
the M4 side the nvic domain.

The shared interrupts are allocated through the router domain which
decides whether the interrupt can be assigned to a particular core or
not. If it can be assigned it allocates the corresponding interrupt in
the parent domain, sets up the routing and everything just works.

See: http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=irq/irqdomain-arm

Thanks,

	tglx
