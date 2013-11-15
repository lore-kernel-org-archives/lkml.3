Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3KOMuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:50:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51931 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab3KOMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:50:11 -0500
Date: Fri, 15 Nov 2013 12:50:04 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2 v2] irqchip: mmp: add dt support for wakeup
Message-ID: <20131115125004.GI1709@e106331-lin.cambridge.arm.com>
References: <1381479838-7794-1-git-send-email-zhangwm@marvell.com>
 <1381479838-7794-3-git-send-email-zhangwm@marvell.com>
 <CAN1soZwPVCNO5V33mP4yn-n=fye2LX-3XCYYG+Z1zw0Q6VVm4g@mail.gmail.com>
 <20131114122733.GJ16396@e106331-lin.cambridge.arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE49FD2839AB@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE49FD2839AB@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:49:20AM +0000, Neil Zhang wrote:
> 
> > -----Original Message-----
> > From: Mark Rutland [mailto:mark.rutland@arm.com]
> > Sent: 2013年11月14日 20:28
> > To: Haojian Zhuang
> > Cc: Neil Zhang; devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Thomas Gleixner
> > Subject: Re: [PATCH 2/2 v2] irqchip: mmp: add dt support for wakeup
> > 
> > On Thu, Nov 14, 2013 at 10:28:53AM +0000, Haojian Zhuang wrote:
> > > On Fri, Oct 11, 2013 at 4:23 PM, Neil Zhang <zhangwm@marvell.com> wrote:
> > > > Some of the Marvell SoCs use GIC as its interrupt controller,and ICU
> > > > only used as wakeup logic. When AP subsystem is powered off, GIC
> > > > will lose its context, the PMU will need ICU to wakeup the AP subsystem.
> > > > So add wakeup entry for such kind of usage.
> > > >
> > > > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > > > ---
> > > >  .../devicetree/bindings/arm/mrvl/intc.txt          |   14 ++-
> > > >  drivers/irqchip/irq-mmp.c                          |  124
> > ++++++++++++++++++++
> > > >  include/linux/irqchip/mmp.h                        |   13 ++
> > > >  3 files changed, 150 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > > > b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > > > index 8b53273..4180928 100644
> > > > --- a/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > > > +++ b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > > > @@ -2,7 +2,7 @@
> > > >
> > > >  Required properties:
> > > >  - compatible : Should be "mrvl,mmp-intc", "mrvl,mmp2-intc" or
> > > > -  "mrvl,mmp2-mux-intc"
> > > > +  "mrvl,mmp2-mux-intc", "mrvl,mmp-intc-wakeupgen"
> > 
> > Why do we need a new compatible string?
> 
> As the patch comments said, we don't use the ICU as an interrupt controller in some Marvell Socs,
> Just use them to wakeup CPU when GIC is powered off.

Hmm. Is it possible to use the ICU as an interrupt controller in those
SoCs?

> 
> > 
> > > >  - reg : Address and length of the register set of the interrupt controller.
> > > >    If the interrupt controller is intc, address and length means the range
> > > >    of the whold interrupt controller. If the interrupt controller is
> > > > mux-intc, @@ -15,6 +15,9 @@ Required properties:
> > > >  - interrupt-controller : Identifies the node as an interrupt controller.
> > > >  - #interrupt-cells : Specifies the number of cells needed to encode an
> > > >    interrupt source.
> > > > +- mrvl,intc-gbl-mask : Specifies the address and value for global
> > > > +mask in the
> > > > +  interrupt controller.
> > >
> > > As my understanding, we should avoid to write register settings in DTS file.
> > 
> > In general, yes. We should describe the hardware and let Linux choose how to
> > configure it as far as possible.
> > 
> > What is this global mask? What is it used for? Why do there seem to be multiple
> > global masks (judging by the example)?
> > 
> 
> Global mask will prevent distributing interrupt from ICU to GIC.
> Since we will use GIC as the interrupt controller, so we need to mask the ICU global mask.
> ICU has connection to every core in the system, so we need to mask all global mask registers for each core.

Why can the driver not figure out these masks for itself?

> 
> > >
> > > Loop devicetree guys.
> > >
> > > > +- mrvl,intc-for-cp : Specifies the irqs that will be routed to cp
> > 
> > cp?
> > 
> > _why_ do we need this, and what exactly does routing the irqs to the cp imply?
> 
> Communication processor.
> Kernel should avoid to handle the irq lines that has been routed to communication processor.

Ok. Does this just tell the kernel the set of IRQs to ignore, or does
this imply that the kernel must configure something in the hardware
based on this? If so, what specifically?

> 
> > 
> > > >  - mrvl,intc-nr-irqs : Specifies the number of interrupts in the interrupt
> > > >    controller.
> > > >  - mrvl,clr-mfp-irq : Specifies the interrupt that needs to clear
> > > > MFP edge @@ -39,6 +42,15 @@ Example:
> > > >                 mrvl,intc-nr-irqs = <2>;
> > > >         };
> > > >
> > > > +     intc: wakeupgen@d4282000 {
> > > > +               compatible = "mrvl,mmp-intc-wakeupgen";
> > > > +               reg = <0xd4282000 0x1000>;
> > > > +               mrvl,intc-nr-irqs = <64>;
> > > > +               mrvl,intc-gbl-mask = <0x114 0x3
> > > > +                                     0x144 0x3>;
> > 
> > Are these multiple entries? The binding text implied there was only one entry.
> > What is this?
> 
> This specify the register offset and value to mask for each core.

Why can the driver not have these offsets hard-coded? How variable are
they?

[...]

> > > > +       size /= sizeof(*wakeup_reg);
> > > > +       while (i < size) {
> > > > +               unsigned offset, val;
> > > > +
> > > > +               offset = be32_to_cpup(wakeup_reg + i++);
> > > > +               val = be32_to_cpup(wakeup_reg + i++);
> > 
> > Use of_property_read_u32_index. You don't need to deal with the raw dtb.
> 
> It's offset / value pair, it there convenient way to get such kind of key / value pair?
> Thanks.

Unfortunately there's no of_property_read_u32_array_index, but it's
perfectly possible to do something similar to what you have here,
without relying on the raw binary DTB:

for (;;) {
	u32 offset, val;
	if (of_property_read_u32_index(node, PROP_NAME, i++, &offset) != 0)
		break;
	if (of_property_read_u32_index(node, PROP_NAME, i++, &val) != 0)
		break;
	
	do_something(offset, val);
}

> 
> > 
> > > > +               writel_relaxed(val, mmp_icu_base + offset);
> > > > +       }
> > > > +
> > > > +       /* Get the irq lines and ignore irqs */
> > > > +       cp_irq_reg = of_get_property(node, "mrvl,intc-for-cp", &size);
> > > > +       if (!cp_irq_reg)
> > > > +               return;
> > > > +
> > > > +       irq_for_cp_nr = size / sizeof(*cp_irq_reg);
> > > > +       for (i = 0; i < irq_for_cp_nr; i++) {
> > > > +               irq_for_cp[i] = be32_to_cpup(cp_irq_reg + i);
> > 
> > Use of_property_read_u32_index.
> 
> Yes, it should be OK, thanks very much.

Cheers,
Mark.
