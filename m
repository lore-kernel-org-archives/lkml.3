Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab3BSK6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:58:24 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:54331 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab3BSK6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:58:22 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302191029510.22263@ionos>
References: <20130218142834.28739.39417.sendpatchset@w520>
	<alpine.LFD.2.02.1302191029510.22263@ionos>
Date: Tue, 19 Feb 2013 19:58:21 +0900
Message-ID: <CANqRtoSPmDkCF8fuxMrwr9AyU5vr10dhnEmbKwyE4A3MXZ0KUg@mail.gmail.com>
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for your help with the review!

On Tue, Feb 19, 2013 at 7:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Magnus,
>
> On Mon, 18 Feb 2013, Magnus Damm wrote:
>
>> +static inline unsigned long intc_irqpin_read(struct intc_irqpin_priv *p,
>> +                                          int reg)
>> +{
>> +     struct intc_irqpin_iomem *i = &p->iomem[reg];
>
> Newline between variable and code please.

Yes, I agree, will fix. I have been criticized for adding too many
newlines in the past, so I guess this is a good sign that I can flip
the other way now!

>> +     return i->read(i->iomem);
>> +}
>> +
>> +static inline void intc_irqpin_write(struct intc_irqpin_priv *p,
>> +                                  int reg, unsigned long data)
>> +{
>> +     struct intc_irqpin_iomem *i = &p->iomem[reg];
>> +     i->write(i->iomem, data);
>> +}
>> +
>> +static inline unsigned long intc_irqpin_hwirq_mask(struct intc_irqpin_priv *p,
>> +                                                int reg, int hw_irq)
>> +{
>> +     return BIT((p->iomem[reg].width - 1) - hw_irq);
>> +}
>> +
>> +static inline void intc_irqpin_irq_write_hwirq(struct intc_irqpin_priv *p,
>> +                                            int reg, int hw_irq)
>> +{
>> +     intc_irqpin_write(p, reg, intc_irqpin_hwirq_mask(p, reg, hw_irq));
>> +}
>> +
>> +static DEFINE_RAW_SPINLOCK(intc_irqpin_lock); /* only used by slow path */
>
> Shouldn't the lock be part of struct intc_irqpin_priv ?

Good idea, but I need to lock access to the SENSE register against
multiple driver instances. This is not the case for PRIO. But because
both PRIO and SENSE are accessed in the slow path I decided to be lazy
and use the same way of locking to reduce the code size.

>> +static void intc_irqpin_read_modify_write(struct intc_irqpin_priv *p,
>> +                                       int reg, int shift,
>> +                                       int width, int value)
>> +{
>> +     unsigned long flags;
>> +     unsigned long tmp;
>> +
>> +     raw_spin_lock_irqsave(&intc_irqpin_lock, flags);
>> +static void intc_irqpin_dbg(struct intc_irqpin_irq *i, char *str)
>> +{
>> +     dev_dbg(&i->p->pdev->dev, "%s (%d:%d:%d)\n",
>> +             str, i->irq, i->hw_irq,
>> +             irq_find_mapping(i->p->irq_domain, i->hw_irq));
>
> Do you really want to do a lookup for each debug invocation?

Uhm, maybe no. I need to check if this compiles out in case of DEBUG=n.

>> +}
>> +
>> +static void intc_irqpin_irq_enable(struct irq_data *d)
>> +{
>> +     struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
>> +     int hw_irq = irqd_to_hwirq(d);
>> +
>> +     intc_irqpin_dbg(&p->irq[hw_irq], "enable");
>> +     intc_irqpin_irq_write_hwirq(p, INTC_IRQPIN_REG_CLEAR, hw_irq);
>> +}
>> +
>> +static void intc_irqpin_irq_disable(struct irq_data *d)
>> +{
>> +     struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
>> +     int hw_irq = irqd_to_hwirq(d);
>> +
>> +     intc_irqpin_dbg(&p->irq[hw_irq], "disable");
>> +     intc_irqpin_irq_write_hwirq(p, INTC_IRQPIN_REG_MASK, hw_irq);
>> +}
>> +
>> +static void intc_irqpin_irq_enable_force(struct irq_data *d)
>> +{
>> +     struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
>> +     int irq = p->irq[irqd_to_hwirq(d)].irq;
>> +
>> +     intc_irqpin_irq_enable(d);
>> +     irq_get_chip(irq)->irq_unmask(irq_get_irq_data(irq));
>> +}
>> +
>> +static void intc_irqpin_irq_disable_force(struct irq_data *d)
>> +{
>> +     struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
>> +     int irq = p->irq[irqd_to_hwirq(d)].irq;
>> +
>> +     irq_get_chip(irq)->irq_mask(irq_get_irq_data(irq));
>> +     intc_irqpin_irq_disable(d);
>
> Hmm. If I understand that code correctly, then the _force functions
> are (un)masking another interrupt line. But this happens without
> holding irq_desc[irq]->lock. Looks unsafe at least and if correct
> wants a big fat comment.

On some SoCs the masking for some IRQs seems busted, and the only sane
way to work around that is to (un)mask the parent interrupt. The
parent happens to be the GIC. I will look into how to add locking.

>> +}
>> +
>> +#define INTC_IRQ_SENSE_VALID 0x10
>> +#define INTC_IRQ_SENSE(x) (x + INTC_IRQ_SENSE_VALID)
>> +
>> +static unsigned char intc_irqpin_sense[IRQ_TYPE_SENSE_MASK + 1] = {
>> +     [IRQ_TYPE_EDGE_FALLING] = INTC_IRQ_SENSE(0x00),
>> +     [IRQ_TYPE_EDGE_RISING] = INTC_IRQ_SENSE(0x01),
>> +     [IRQ_TYPE_LEVEL_LOW] = INTC_IRQ_SENSE(0x02),
>> +     [IRQ_TYPE_LEVEL_HIGH] = INTC_IRQ_SENSE(0x03),
>> +     [IRQ_TYPE_EDGE_BOTH] = INTC_IRQ_SENSE(0x04),
>> +};
>> +
>> +static int intc_irqpin_irq_set_type(struct irq_data *d, unsigned int type)
>> +{
>> +     unsigned char value = intc_irqpin_sense[type & IRQ_TYPE_SENSE_MASK];
>> +     struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
>> +
>> +     if (!(value & INTC_IRQ_SENSE_VALID))
>> +             return -EINVAL;
>> +
>> +     return intc_irqpin_set_sense(p, irqd_to_hwirq(d),
>> +                                  value ^ INTC_IRQ_SENSE_VALID);
>> +}
>> +
>> +static irqreturn_t intc_irqpin_irq_handler(int irq, void *dev_id)
>> +{
>> +     struct intc_irqpin_irq *i = dev_id;
>> +     struct intc_irqpin_priv *p = i->p;
>> +     unsigned long bit;
>> +
>> +     intc_irqpin_dbg(i, "demux1");
>> +     bit = intc_irqpin_hwirq_mask(p, INTC_IRQPIN_REG_SOURCE, i->hw_irq);
>> +
>> +     if (intc_irqpin_read(p, INTC_IRQPIN_REG_SOURCE) & bit) {
>> +             intc_irqpin_write(p, INTC_IRQPIN_REG_SOURCE, ~bit);
>> +             intc_irqpin_dbg(i, "demux2");
>> +             generic_handle_irq(irq_find_mapping(p->irq_domain, i->hw_irq));
>
> Shouldn't you cache that mapping value somewhere ?

That may speed things up, yes. Will do.

>> +             return IRQ_HANDLED;
>> +     }
>> +     return IRQ_NONE;
>> +}
>> +
>> +static int intc_irqpin_irq_domain_map(struct irq_domain *h, unsigned int virq,
>> +                                   irq_hw_number_t hw)
>> +{
>> +     struct intc_irqpin_priv *p = h->host_data;
>> +
>> +     intc_irqpin_dbg(&p->irq[hw], "map");
>> +     irq_set_chip_data(virq, h->host_data);
>> +     irq_set_chip_and_handler(virq, &p->irq_chip, handle_level_irq);
>> +     set_irq_flags(virq, IRQF_VALID); /* kill me now */
>
> What needs to be killed? -ENOPARSE

I'd like to not have to set this flag in my interrupt code.

I've written interrupt code on other architectures before, and from my
experience only ARM requires the IRQF_VALID flag to be set because the
ARM architecture software believes it is a special case. I may be
behind times - I have to admit that I've not checked the latest state
- this flag may not be needed anymore, hurray if so - but at least a
couple of years ago it was needed in case of ARM for our shared INTC
code (shared between sh and ARM).

What is your opinion about this matter?

Thanks,

/ magnus
