Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbaICMnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:43:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35199 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932437AbaICMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:43:35 -0400
Date: Wed, 3 Sep 2014 13:43:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: bcm7120-l2: Add Broadcom
 BCM7120-style L2 binding
Message-ID: <20140903124317.GB3127@leverpostej>
References: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com>
 <1409265326-7579-3-git-send-email-f.fainelli@gmail.com>
 <alpine.DEB.2.10.1409031410580.3333@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409031410580.3333@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 01:13:02PM +0100, Thomas Gleixner wrote:
> You forgot to CC the device tree dudes. We want an ack on the bindings
> before they materialize in Linus tree.

Thanks for the Cc.

Florian, in future could you please Cc for both the binding and driver?
So long as it's obvious which patch introduces the binding other can
choose to ignore the driver, but for me it's useful context.

> 
> Thanks,
> 
> 	tglx
> 
> On Thu, 28 Aug 2014, Florian Fainelli wrote:
> 
> > This patch adds the Device Tree binding document for the Broadcom
> > BCM7120-style Set-top-box Level 2 interrupt controller hardware.
> > 
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> >  .../interrupt-controller/brcm,bcm7120-l2-intc.txt  | 44 ++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
> > new file mode 100644
> > index 000000000000..3818ffed7347
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
> > @@ -0,0 +1,44 @@
> > +Broadcom BCM7120-style Level 2 interrupt controller
> > +
> > +Required properties:
> > +
> > +- compatible: should be "brcm,bcm7120-l2-intc"

Is this a custom block for the bcm7120?

Does the IP block not have a more specific name?

> > +- reg: specifies the base physical address and size of the registers
> > +- interrupt-controller: identifies the node as an interrupt controller
> > +- #interrupt-cells: specifies the number of cells needed to encode an interrupt
> > +  source, should be 1.

... and valid values are?

> > +- interrupt-parent: specifies the phandle to the parent interrupt controller
> > +  this one is cascaded from
> > +- interrupts: specifies the interrupt line(s) in the interrupt-parent domain
> > +  to be used for cascading

The domain is a software construct, so I don't think it needs to be
mentuioned in the binding doc. All that this proeprty describes is the
lines.

> > +- brcm,int-map-mask: 32-bits bit mask describing how the interrupts
> > at this level
> > +  map to their respective parents. Should match exactly the number of interrupts
> > +  specified in the 'interrupts' property.

I don't follow.

Surely this should be static, and we know the 1-1 mapping, or this is
dynamic and should be SW-configured?

> > +Optional properties:
> > +
> > +- interrupt-names: if present, the litteral names for the parent interrupts
> > +  specified in the 'interrupts' property.

If you use the interrupt-names property, it should contain the names of
the interrupts from the POV of this device. Those names must be
specified in the binding doc.

This is useless as-is.

> > +- brcm,irq-can-wake: if present, this means the L2 controller can be used as a
> > +  wakeup source for system suspend/resume.

How variable is this?

I realise have properties like this elsewhere, but it seems to be
hacking around the lack of a decent power domain interface for figuring
this out.

> > +- brcm,int-fwd-mask: if present, a 32-bits bit mask describing the interrupts
> > +  which need to be enabled in this controller to flow to the higher level
> > +  interrupt controller. This is typically needed for the UARTs interrupts to
> > +  flow through the top-level interrupt controller (e.g: ARM GIC on ARM-based
> > +  platforms).
> > +

I don't follow why this property is needed at all. Is this a mechanism
to bypass this controller entirely? Why should this be described as a
fixed HW property?

Thanks,
Mark.

> > +Example:
> > +
> > +irq0_intc: interrupt-controller@f0406800 {
> > +	compatible = "brcm,bcm7120-l2-intc";
> > +	interrupt-parent = <&intc>;
> > +	#interrupt-cells = <1>;
> > +	reg = <0xf0406800 0x8>;
> > +	interrupt-controller;
> > +	interrupts = <0x0 0x42 0x0>, <0x0 0x40 0x0>;
> > +	interrupt-names = "upg_main", "upg_bsc";
> > +	brcm,int-map-mask = <0xeb8>, <0x140>;
> > +	brcm,int-fwd-mask = <0x7>;
> > +};
> > -- 
> > 1.9.1
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
