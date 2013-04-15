Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3DOLLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:11:23 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:54933 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756048Ab3DOLLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:11:22 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Xie <cxie4@marvell.com>
Date: Mon, 15 Apr 2013 04:10:03 -0700
Subject: RE: [PATCH 1/4] ARM: mmp: add wakeup function for ICU
Thread-Topic: [PATCH 1/4] ARM: mmp: add wakeup function for ICU
Thread-Index: Ac44RXSr4nVOm12VRSqF9yw/U3xmIQBhEgBA
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE2D0F68CFD8@SC-VEXCH4.marvell.com>
References: <1365651463-11502-1-git-send-email-zhangwm@marvell.com>
	<1365651463-11502-2-git-send-email-zhangwm@marvell.com>
 <CAN1soZwFJybMUZgxZJyXcDdKXbpQxaVntyZd8oGnQivLF=ZNNA@mail.gmail.com>
In-Reply-To: <CAN1soZwFJybMUZgxZJyXcDdKXbpQxaVntyZd8oGnQivLF=ZNNA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3FBBRLZ027837





> -----Original Message-----
> From: Haojian Zhuang [mailto:haojian.zhuang@gmail.com]
> Sent: 2013Äê4ÔÂ13ÈÕ 20:50
> To: Neil Zhang
> Cc: Grant Likely; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Chao Xie
> Subject: Re: [PATCH 1/4] ARM: mmp: add wakeup function for ICU
> 
> On Thu, Apr 11, 2013 at 11:37 AM, Neil Zhang <zhangwm@marvell.com>
> wrote:
> > From: Chao Xie <chao.xie@marvell.com>
> >
> > PXA988 will use GIC as its interrupt controller, and ICU is used as
> > wakeup logic. When AP subsystem is powered off, GIC will lose its
> > context, the PMU will need ICU to wakeup the AP subsystem.
> > When ICU works as wakeup logic, there is no need to know intc-nr-irqs,
> > change the corresponding code.
> >
> > Signed-off-by: Chao Xie <chao.xie@marvell.com>
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  .../devicetree/bindings/arm/mrvl/intc.txt          |    9 ++++
> >  arch/arm/mach-mmp/irq.c                            |   51
> ++++++++++++++++----
> >  2 files changed, 50 insertions(+), 10 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > index 8b53273..58c0e74 100644
> > --- a/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > +++ b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > @@ -15,6 +15,8 @@ Required properties:
> >  - interrupt-controller : Identifies the node as an interrupt controller.
> >  - #interrupt-cells : Specifies the number of cells needed to encode an
> >    interrupt source.
> > +- mrvl,intc-wakeup : Specifies the address and value for global mask
> > +in the
> > +  interrupt controller.
> >  - mrvl,intc-nr-irqs : Specifies the number of interrupts in the interrupt
> >    controller.
> >  - mrvl,clr-mfp-irq : Specifies the interrupt that needs to clear MFP
> > edge @@ -39,6 +41,13 @@ Example:
> >                 mrvl,intc-nr-irqs = <2>;
> >         };
> >
> > +       intc: interrupt-controller@d4282000 {
> > +               compatible = "mrvl,mmp-intc";
> > +               reg = <0xd4282000 0x1000>;
> > +               mrvl,intc-wakeup = <0x114 0x3
> > +                                   0x144 0x3>;
> > +       };
> > +
> >  * Marvell Orion Interrupt controller
> >
> >  Required properties
> > diff --git a/arch/arm/mach-mmp/irq.c b/arch/arm/mach-mmp/irq.c index
> > 3c71246..b8df948 100644
> > --- a/arch/arm/mach-mmp/irq.c
> > +++ b/arch/arm/mach-mmp/irq.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/init.h>
> >  #include <linux/irq.h>
> >  #include <linux/irqdomain.h>
> > +#include <linux/irqchip/arm-gic.h>
> >  #include <linux/io.h>
> >  #include <linux/ioport.h>
> >  #include <linux/of_address.h>
> > @@ -57,6 +58,7 @@ struct mmp_intc_conf {  void __iomem
> *mmp_icu_base;
> > static struct icu_chip_data icu_data[MAX_ICU_NR];  static int
> > max_icu_nr;
> > +static bool mmp_icu_wakeup;
> >
> >  extern void mmp2_clear_pmic_int(void);
> >
> > @@ -91,8 +93,11 @@ static void icu_mask_irq(struct irq_data *d)
> >         int hwirq;
> >         u32 r;
> >
> > -       hwirq = d->irq - data->virq_base;
> > -       if (data == &icu_data[0]) {
> > +       if (mmp_icu_wakeup)
> > +               hwirq = d->hwirq;
> > +       else
> > +               hwirq = d->irq - data->virq_base;
> > +       if (data == &icu_data[0] || mmp_icu_wakeup) {
> >                 r = readl_relaxed(mmp_icu_base + (hwirq << 2));
> >                 r &= ~data->conf_mask;
> >                 r |= data->conf_disable; @@ -110,8 +115,11 @@
> static
> > void icu_unmask_irq(struct irq_data *d)
> >         int hwirq;
> >         u32 r;
> >
> > -       hwirq = d->irq - data->virq_base;
> > -       if (data == &icu_data[0]) {
> > +       if (mmp_icu_wakeup)
> > +               hwirq = d->hwirq;
> > +       else
> > +               hwirq = d->irq - data->virq_base;
> > +       if (data == &icu_data[0] || mmp_icu_wakeup) {
> >                 r = readl_relaxed(mmp_icu_base + (hwirq << 2));
> >                 r &= ~data->conf_mask;
> >                 r |= data->conf_enable; @@ -415,6 +423,8 @@ void
> > __init mmp_dt_irq_init(void)
> >         const struct of_device_id *of_id;
> >         struct mmp_intc_conf *conf;
> >         int nr_irqs, irq_base, ret, irq;
> > +       const __be32 *wakeup_reg;
> > +       int size, i;
> >
> >         node = of_find_matching_node(NULL, intc_ids);
> >         if (!node) {
> > @@ -424,18 +434,39 @@ void __init mmp_dt_irq_init(void)
> >         of_id = of_match_node(intc_ids, node);
> >         conf = of_id->data;
> >
> > -       ret = of_property_read_u32(node, "mrvl,intc-nr-irqs", &nr_irqs);
> > -       if (ret) {
> > -               pr_err("Not found mrvl,intc-nr-irqs property\n");
> > -               return;
> > -       }
> > -
> >         mmp_icu_base = of_iomap(node, 0);
> >         if (!mmp_icu_base) {
> >                 pr_err("Failed to get interrupt controller register\n");
> >                 return;
> >         }
> >
> > +       /* ICU is only used as wake up logic. */
> > +       wakeup_reg = of_get_property(node, "mrvl,intc-wakeup", &size);
> > +       if (wakeup_reg) {
> > +               mmp_icu_wakeup = 1;
> > +               size /= sizeof(*wakeup_reg);
> > +               i = 0;
> > +               /* disable the global irq/fiq in icu for all cores. */
> > +               while (i < size) {
> > +                       unsigned offset, val;
> > +
> > +                       offset = be32_to_cpup(wakeup_reg + i++);
> > +                       val = be32_to_cpup(wakeup_reg + i++);
> > +                       writel_relaxed(val, mmp_icu_base + offset);
> > +               }
> > +
> > +               gic_arch_extn.irq_mask = icu_mask_irq;
> > +               gic_arch_extn.irq_unmask = icu_unmask_irq;
> > +
> > +               return;
> > +       }
> 
> Since it's totally different from original ICU irq initialization, I suggest to
> create a new entry to handle this kind of wakeup event. And we could create
> a new mask/unmask function.

Ok, I'll update it.

> 
> > +
> > +       ret = of_property_read_u32(node, "mrvl,intc-nr-irqs", &nr_irqs);
> > +       if (ret) {
> > +               pr_err("Not found mrvl,intc-nr-irqs property\n");
> > +               return;
> > +       }
> > +
> >         irq_base = irq_alloc_descs(-1, 0, nr_irqs - NR_IRQS_LEGACY, 0);
> >         if (irq_base < 0) {
> >                 pr_err("Failed to allocate IRQ numbers\n");
> > --
> > 1.7.4.1
> >

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
