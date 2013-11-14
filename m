Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3KNM1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:27:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56290 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630Ab3KNM1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:27:46 -0500
Date: Thu, 14 Nov 2013 12:27:33 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Neil Zhang <zhangwm@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2 v2] irqchip: mmp: add dt support for wakeup
Message-ID: <20131114122733.GJ16396@e106331-lin.cambridge.arm.com>
References: <1381479838-7794-1-git-send-email-zhangwm@marvell.com>
 <1381479838-7794-3-git-send-email-zhangwm@marvell.com>
 <CAN1soZwPVCNO5V33mP4yn-n=fye2LX-3XCYYG+Z1zw0Q6VVm4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZwPVCNO5V33mP4yn-n=fye2LX-3XCYYG+Z1zw0Q6VVm4g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 10:28:53AM +0000, Haojian Zhuang wrote:
> On Fri, Oct 11, 2013 at 4:23 PM, Neil Zhang <zhangwm@marvell.com> wrote:
> > Some of the Marvell SoCs use GIC as its interrupt controller,and ICU
> > only used as wakeup logic. When AP subsystem is powered off, GIC will
> > lose its context, the PMU will need ICU to wakeup the AP subsystem.
> > So add wakeup entry for such kind of usage.
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  .../devicetree/bindings/arm/mrvl/intc.txt          |   14 ++-
> >  drivers/irqchip/irq-mmp.c                          |  124 ++++++++++++++++++++
> >  include/linux/irqchip/mmp.h                        |   13 ++
> >  3 files changed, 150 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/arm/mrvl/intc.txt b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > index 8b53273..4180928 100644
> > --- a/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > +++ b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > @@ -2,7 +2,7 @@
> >
> >  Required properties:
> >  - compatible : Should be "mrvl,mmp-intc", "mrvl,mmp2-intc" or
> > -  "mrvl,mmp2-mux-intc"
> > +  "mrvl,mmp2-mux-intc", "mrvl,mmp-intc-wakeupgen"

Why do we need a new compatible string?

> >  - reg : Address and length of the register set of the interrupt controller.
> >    If the interrupt controller is intc, address and length means the range
> >    of the whold interrupt controller. If the interrupt controller is mux-intc,
> > @@ -15,6 +15,9 @@ Required properties:
> >  - interrupt-controller : Identifies the node as an interrupt controller.
> >  - #interrupt-cells : Specifies the number of cells needed to encode an
> >    interrupt source.
> > +- mrvl,intc-gbl-mask : Specifies the address and value for global mask in the
> > +  interrupt controller.
> 
> As my understanding, we should avoid to write register settings in DTS file.

In general, yes. We should describe the hardware and let Linux choose
how to configure it as far as possible.

What is this global mask? What is it used for? Why do there seem to be
multiple global masks (judging by the example)?

> 
> Loop devicetree guys.
> 
> > +- mrvl,intc-for-cp : Specifies the irqs that will be routed to cp

cp?

_why_ do we need this, and what exactly does routing the irqs to the cp
imply?

> >  - mrvl,intc-nr-irqs : Specifies the number of interrupts in the interrupt
> >    controller.
> >  - mrvl,clr-mfp-irq : Specifies the interrupt that needs to clear MFP edge
> > @@ -39,6 +42,15 @@ Example:
> >                 mrvl,intc-nr-irqs = <2>;
> >         };
> >
> > +     intc: wakeupgen@d4282000 {
> > +               compatible = "mrvl,mmp-intc-wakeupgen";
> > +               reg = <0xd4282000 0x1000>;
> > +               mrvl,intc-nr-irqs = <64>;
> > +               mrvl,intc-gbl-mask = <0x114 0x3
> > +                                     0x144 0x3>;

Are these multiple entries? The binding text implied there was only
one entry. What is this?

[...]

> > +void __init mmp_of_wakeup_init(void)
> > +{
> > +       struct device_node *node;
> > +       const __be32 *wakeup_reg;
> > +       const __be32 *cp_irq_reg;
> > +       int ret, nr_irqs;
> > +       int size, i = 0;
> > +       int irq;
> > +
> > +       node = of_find_compatible_node(NULL, NULL, "mrvl,mmp-intc-wakeupgen");
> > +       if (!node) {
> > +               pr_err("Failed to find interrupt controller in arch-mmp\n");
> > +               return;
> > +       }

Why can this not be done in the standard probe path, using the node
you'll have been handed by the core code?

> > +
> > +       mmp_icu_base = of_iomap(node, 0);
> > +       if (!mmp_icu_base) {
> > +               pr_err("Failed to get interrupt controller register\n");
> > +               return;
> > +       }
> > +
> > +       ret = of_property_read_u32(node, "mrvl,intc-nr-irqs", &nr_irqs);
> > +       if (ret) {
> > +               pr_err("Not found mrvl,intc-nr-irqs property\n");
> > +               return;
> > +       }
> > +
> > +       /*
> > +        * Config all the interrupt source be able to interrupt the cpu 0,
> > +        * in IRQ mode, with priority 0 as masked by default.
> > +        */
> > +       for (irq = 0; irq < nr_irqs; irq++)
> > +               __raw_writel(ICU_IRQ_CPU0_MASKED, mmp_icu_base + (irq << 2));
> > +
> > +       /* ICU is only used as wake up logic
> > +         * disable the global irq/fiq in icu for all cores.
> > +         */
> > +       wakeup_reg = of_get_property(node, "mrvl,intc-gbl-mask", &size);
> > +       if (!wakeup_reg) {
> > +               pr_err("Not found mrvl,intc-gbl-mask property\n");
> > +               return;
> > +       }
> > +
> > +       size /= sizeof(*wakeup_reg);
> > +       while (i < size) {
> > +               unsigned offset, val;
> > +
> > +               offset = be32_to_cpup(wakeup_reg + i++);
> > +               val = be32_to_cpup(wakeup_reg + i++);

Use of_property_read_u32_index. You don't need to deal with the raw dtb.

> > +               writel_relaxed(val, mmp_icu_base + offset);
> > +       }
> > +
> > +       /* Get the irq lines and ignore irqs */
> > +       cp_irq_reg = of_get_property(node, "mrvl,intc-for-cp", &size);
> > +       if (!cp_irq_reg)
> > +               return;
> > +
> > +       irq_for_cp_nr = size / sizeof(*cp_irq_reg);
> > +       for (i = 0; i < irq_for_cp_nr; i++) {
> > +               irq_for_cp[i] = be32_to_cpup(cp_irq_reg + i);

Use of_property_read_u32_index.

Thanks,
Mark.
