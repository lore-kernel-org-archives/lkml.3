Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3BSKLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:11:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:60117 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab3BSKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:11:44 -0500
Date: Tue, 19 Feb 2013 11:11:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
In-Reply-To: <20130218142834.28739.39417.sendpatchset@w520>
Message-ID: <alpine.LFD.2.02.1302191029510.22263@ionos>
References: <20130218142834.28739.39417.sendpatchset@w520>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus,

On Mon, 18 Feb 2013, Magnus Damm wrote:

> +static inline unsigned long intc_irqpin_read(struct intc_irqpin_priv *p,
> +					     int reg)
> +{
> +	struct intc_irqpin_iomem *i = &p->iomem[reg];

Newline between variable and code please.

> +	return i->read(i->iomem);
> +}
> +
> +static inline void intc_irqpin_write(struct intc_irqpin_priv *p,
> +				     int reg, unsigned long data)
> +{
> +	struct intc_irqpin_iomem *i = &p->iomem[reg];
> +	i->write(i->iomem, data);
> +}
> +
> +static inline unsigned long intc_irqpin_hwirq_mask(struct intc_irqpin_priv *p,
> +						   int reg, int hw_irq)
> +{
> +	return BIT((p->iomem[reg].width - 1) - hw_irq);
> +}
> +
> +static inline void intc_irqpin_irq_write_hwirq(struct intc_irqpin_priv *p,
> +					       int reg, int hw_irq)
> +{
> +	intc_irqpin_write(p, reg, intc_irqpin_hwirq_mask(p, reg, hw_irq));
> +}
> +
> +static DEFINE_RAW_SPINLOCK(intc_irqpin_lock); /* only used by slow path */

Shouldn't the lock be part of struct intc_irqpin_priv ?

> +static void intc_irqpin_read_modify_write(struct intc_irqpin_priv *p,
> +					  int reg, int shift,
> +					  int width, int value)
> +{
> +	unsigned long flags;
> +	unsigned long tmp;
> +
> +	raw_spin_lock_irqsave(&intc_irqpin_lock, flags);
> +static void intc_irqpin_dbg(struct intc_irqpin_irq *i, char *str)
> +{
> +	dev_dbg(&i->p->pdev->dev, "%s (%d:%d:%d)\n",
> +		str, i->irq, i->hw_irq,
> +		irq_find_mapping(i->p->irq_domain, i->hw_irq));

Do you really want to do a lookup for each debug invocation?

> +}
> +
> +static void intc_irqpin_irq_enable(struct irq_data *d)
> +{
> +	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
> +	int hw_irq = irqd_to_hwirq(d);
> +
> +	intc_irqpin_dbg(&p->irq[hw_irq], "enable");
> +	intc_irqpin_irq_write_hwirq(p, INTC_IRQPIN_REG_CLEAR, hw_irq);
> +}
> +
> +static void intc_irqpin_irq_disable(struct irq_data *d)
> +{
> +	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
> +	int hw_irq = irqd_to_hwirq(d);
> +
> +	intc_irqpin_dbg(&p->irq[hw_irq], "disable");
> +	intc_irqpin_irq_write_hwirq(p, INTC_IRQPIN_REG_MASK, hw_irq);
> +}
> +
> +static void intc_irqpin_irq_enable_force(struct irq_data *d)
> +{
> +	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
> +	int irq = p->irq[irqd_to_hwirq(d)].irq;
> +
> +	intc_irqpin_irq_enable(d);
> +	irq_get_chip(irq)->irq_unmask(irq_get_irq_data(irq));
> +}
> +
> +static void intc_irqpin_irq_disable_force(struct irq_data *d)
> +{
> +	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
> +	int irq = p->irq[irqd_to_hwirq(d)].irq;
> +
> +	irq_get_chip(irq)->irq_mask(irq_get_irq_data(irq));
> +	intc_irqpin_irq_disable(d);

Hmm. If I understand that code correctly, then the _force functions
are (un)masking another interrupt line. But this happens without
holding irq_desc[irq]->lock. Looks unsafe at least and if correct
wants a big fat comment.

> +}
> +
> +#define INTC_IRQ_SENSE_VALID 0x10
> +#define INTC_IRQ_SENSE(x) (x + INTC_IRQ_SENSE_VALID)
> +
> +static unsigned char intc_irqpin_sense[IRQ_TYPE_SENSE_MASK + 1] = {
> +	[IRQ_TYPE_EDGE_FALLING] = INTC_IRQ_SENSE(0x00),
> +	[IRQ_TYPE_EDGE_RISING] = INTC_IRQ_SENSE(0x01),
> +	[IRQ_TYPE_LEVEL_LOW] = INTC_IRQ_SENSE(0x02),
> +	[IRQ_TYPE_LEVEL_HIGH] = INTC_IRQ_SENSE(0x03),
> +	[IRQ_TYPE_EDGE_BOTH] = INTC_IRQ_SENSE(0x04),
> +};
> +
> +static int intc_irqpin_irq_set_type(struct irq_data *d, unsigned int type)
> +{
> +	unsigned char value = intc_irqpin_sense[type & IRQ_TYPE_SENSE_MASK];
> +	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
> +
> +	if (!(value & INTC_IRQ_SENSE_VALID))
> +		return -EINVAL;
> +
> +	return intc_irqpin_set_sense(p, irqd_to_hwirq(d),
> +				     value ^ INTC_IRQ_SENSE_VALID);
> +}
> +
> +static irqreturn_t intc_irqpin_irq_handler(int irq, void *dev_id)
> +{
> +	struct intc_irqpin_irq *i = dev_id;
> +	struct intc_irqpin_priv *p = i->p;
> +	unsigned long bit;
> +
> +	intc_irqpin_dbg(i, "demux1");
> +	bit = intc_irqpin_hwirq_mask(p, INTC_IRQPIN_REG_SOURCE, i->hw_irq);
> +
> +	if (intc_irqpin_read(p, INTC_IRQPIN_REG_SOURCE) & bit) {
> +		intc_irqpin_write(p, INTC_IRQPIN_REG_SOURCE, ~bit);
> +		intc_irqpin_dbg(i, "demux2");
> +		generic_handle_irq(irq_find_mapping(p->irq_domain, i->hw_irq));

Shouldn't you cache that mapping value somewhere ?

> +		return IRQ_HANDLED;
> +	}
> +	return IRQ_NONE;
> +}
> +
> +static int intc_irqpin_irq_domain_map(struct irq_domain *h, unsigned int virq,
> +				      irq_hw_number_t hw)
> +{
> +	struct intc_irqpin_priv *p = h->host_data;
> +
> +	intc_irqpin_dbg(&p->irq[hw], "map");
> +	irq_set_chip_data(virq, h->host_data);
> +	irq_set_chip_and_handler(virq, &p->irq_chip, handle_level_irq);
> +	set_irq_flags(virq, IRQF_VALID); /* kill me now */

What needs to be killed? -ENOPARSE

Thanks,

	tglx
