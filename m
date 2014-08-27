Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaH0MYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:24:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:60827 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbaH0MY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:24:29 -0400
Date: Wed, 27 Aug 2014 14:23:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: =?ISO-8859-15?Q?Jan_L=FCbbe?= <jlu@pengutronix.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "Joe.C" <srv_yingjoe.chen@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [RESEND PATCH v2 1/4] irqchip: gic: Change irq type check when
 extension is present
In-Reply-To: <53FDB4B3.6000400@arm.com>
Message-ID: <alpine.DEB.2.10.1408271347210.3323@nanos>
References: <1407895884-18131-1-git-send-email-srv_yingjoe.chen@mediatek.com> <1407895884-18131-2-git-send-email-srv_yingjoe.chen@mediatek.com> <53F724F5.3040004@arm.com> <1409133344.25382.37.camel@coredoba.hi.pengutronix.de> <53FDB4B3.6000400@arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Marc Zyngier wrote:
> > As in the DT the actual IRQ polarity should be used, simply configuring
> > the HW IRQ polarity in the bootloader is not enough without telling the
> > GIC driver which polarity is supported on which IRQ, right?
> 
> Looking a bit closer at things, what you describe in DT is the IRQ
> polarity the interrupt controller sees. Nothing else should interpret
> that field.
> 
> So it is legal (IMO) to have a device with an interrupt specifier
> describing a rising edge interrupt, and yet have the device generating a
> falling edge, with Mediatek's special sauce doing the conversion in between.
> 
> Something will have to configure the polarity widget though, but that
> can be left outside of the GIC.

This seems to become a popular topic and it looks like the whole GIC
extension thing is going to explode sooner than later.

We are currently discussing hierarchical irq domains to solve a
different issue in x86 land. See the related discussion here:

	  https://lkml.org/lkml/2014/8/1/67

Now looking at these GIC plus extra sauce problems, I wonder whether
this wouldn't be solvable in a similar way. If you look at it from the
HW perspective you have:

   ---------      ---------
---| MAGIC |------|ARM GIC|
---|       |------|       |
---|       |------|       |
---|       |------|       |
---|       |------|       |
   ---------      ---------

The MAGIC interrupt controller only provides functionality which is
not available from the ARM architected GIC but maps 1:1 to the ARM GIC
interrupt lines. So it looks like a variation to the more dynamic
mapping of MSI -> Remap -> CPU-Vector problem we need to solve on x86.

The idea is to have two irq domains: magic_domain and armgic_domain.

The magic_domain is the frontend facing the devices and the
armgic_domain is the parent domain. This is also reflected in
hierarchical data structures, i.e. irq_desc->irq_data will get a new
field parent_data, which points to the irq_data of the parent
interrupt controller, which is allocated separately when the interrupt
line is instantiated.

So in the above case the hotpath ack/eoi functions of the irq chip
associated to the device interrupt, i.e. magic_chip, would do:

irq_ack(struct irq_data *d)
{
	struct irq_data *pd = d->parent_data;

	pd->chip->irq_ack(pd);
}

Granted, that's another level of indirection, but this is going to be
more efficient than a boatload of conditional hooks in the GIC code
proper. Not to talk about the maintainability of the whole maze.

The irq_set_type() function would do:

irq_set_type(struct irq_data *d, int type)
{
	struct irq_data *pd = d->parent_data;

	gic_type = set_magic_chip_type(d, type);

	return pd->chip->irq_set_type(d, gic_type);
}

Switching to this allows to completely avoid the gazillion of hooks in
the gic code and should work nicely with multiplatform kernels by
simpling hooking up the domain parent relation ship to the proper
magic domain or leave the armgic as the direct device interface in
case the SoC does not have the magic chip in front of the arm gic.

Thoughts?

Thanks,

	tglx
