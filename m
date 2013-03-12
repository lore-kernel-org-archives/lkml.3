Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab3CLT5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:57:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:42691 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab3CLT5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:57:36 -0400
Date: Tue, 12 Mar 2013 20:57:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] irqchip: Add support for ARMv7-M's NVIC
In-Reply-To: <1363103673-24720-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LFD.2.02.1303121923280.22263@ionos>
References: <1363103673-24720-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-349303409-1363115234=:22263"
Content-ID: <alpine.LFD.2.02.1303122007370.22263@ionos>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-349303409-1363115234=:22263
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.02.1303122007371.22263@ionos>

On Tue, 12 Mar 2013, Uwe Kleine-König wrote:
> +static struct nvic_chip_data nvic_data __read_mostly;

What the heck is this? You have a static struct which you set in
irqdata.chip_data?

> +static inline void __iomem *nvic_dist_base(struct irq_data *d)
> +{
> +	struct nvic_chip_data *nvic_data = irq_data_get_irq_chip_data(d);

And then you do the dance of reading the pointer to that static struct
out of irq_data and dereferencing it?

What's the point of this? 

> +	return nvic_data->dist_base;
> +}
> +
> +static void nvic_mask_irq(struct irq_data *d)
> +{
> +	u32 mask = 1 << (d->hwirq % 32);
> +
> +	writel_relaxed(mask, nvic_dist_base(d) + NVIC_ICER + d->irq / 32 * 4);

You're really missing the point of irq_data.chip_data 

If you set proper irq chip data per bank then this whole stuff is
reduced to:

   struct mydata *md = irq_data_get_irq_chip_data(d);
   u32 mask = 1 << (d->irq - md->irq_base);

   writel_relaxed(mask, md->iobase + NVIC_ICER);

Can you spot the difference and what that means in terms of
instruction cycles?

> +}
> +
> +static void nvic_unmask_irq(struct irq_data *d)
> +{
> +	u32 mask = 1 << (d->hwirq % 32);
> +
> +	writel_relaxed(mask, nvic_dist_base(d) + NVIC_ISER + d->hwirq / 32 * 4);
> +}
> +
> +void nvic_eoi(struct irq_data *d)

static ?

> +{
> +	/*
> +	 * This is a no-op as end of interrupt is signaled by the exception
> +	 * return sequence.
> +	 */
> +}
> +
> +static struct irq_chip nvic_chip = {
> +	.name = "NVIC",
> +	.irq_mask = nvic_mask_irq,
> +	.irq_unmask = nvic_unmask_irq,
> +	.irq_eoi = nvic_eoi,
> +};
> +
> +static void __init nvic_init_bases(struct device_node *node,
> +		void __iomem *dist_base)

Please make this

static void __init nvic_init_bases(struct device_node *node,
                                   void __iomem *dist_base)

That's way easier to parse. Applies to all other multiline stuff as
well.

> +{
> +	unsigned int irqs, i, irq_base;
> +
> +	nvic_data.dist_base = dist_base;
> +
> +	irqs = ((readl_relaxed(dist_base + NVIC_INTR_CTRL) & 0x0f) + 1) * 32;
> +	if (irqs > 496)
> +		irqs = 496;

Magic constants. Please use proper defines. 

Aside of that without a proper comment the logic looks ass backwards.

> +	irqs = ((readl_relaxed(dist_base + NVIC_INTR_CTRL) & 0x0f) + 1) * 32;

Without looking at the datasheet I assume that the chip tells you the
number of interrupt banks where a result of 0 means 1 bank and so
forth.

How should a reviewer understand why the number of banks is limited to
31 without a comment? Do you really expect that a reviewer who
stumbles over that goes to search for the datasheet and verify what
you hacked up?

> +	irq_base = irq_alloc_descs(-1, 16, irqs - 16, numa_node_id());

  irq_alloc_desc_from(16, irqs - 16, ...)

Also why are you allocating irqs-16 instead of the full number of
irqs?

> +	if (IS_ERR_VALUE(irq_base)) {

See Russells reply

> +		WARN(1, "Cannot allocate irq_descs\n");

What's the point of that warn? The call path is always the same. So
you are spamming dmesg with a pointless backtrace. And on top of that
you do:

> +		irq_base = 16;

So you cannot allocate irq_descs and then you set base to 16 and pray
that everything works?

> +	}
> +	nvic_data.domain = irq_domain_add_legacy(node, irqs - 16, irq_base, 0,
> +			&irq_domain_simple_ops, NULL);
> +	if (WARN_ON(!nvic_data.domain))
> +		return;

See above. Also you are leaking irqdescs though it's questionable
whether the machine can continue at all. And of course the init call
itself will return sucess.

> +	/*
> +	 * Set priority on all interrupts.
> +	 */
> +	for (i = 0; i < irqs; i += 4)
> +		writel_relaxed(0, dist_base + NVIC_IPRI + i);
> +
> +	/*
> +	 * Disable all interrupts
> +	 */
> +	for (i = 0; i < irqs; i += 32)
> +		writel_relaxed(~0, dist_base + NVIC_ICER + i * 4 / 32);
> +
> +	/*
> +	 * Setup the Linux IRQ subsystem.
> +	 */
> +	for (i = 0; i < irqs; i++) {
> +		irq_set_chip_and_handler(irq_base + i, &nvic_chip,
> +				handle_fasteoi_irq);

Above you do:
	irq_base = irq_alloc_descs(-1, 16, irqs - 16, numa_node_id());

So you allocate irqs-16 interrupt descriptors and then you initialize
16 more than you allocated.

Brilliant stuff that.

> +		irq_set_chip_data(irq_base + i, &nvic_data);
> +		set_irq_flags(irq_base + i, IRQF_VALID | IRQF_PROBE);
> +	}
> +}
> +
> +static int __init nvic_of_init(struct device_node *node,
> +		struct device_node *parent)
> +{
> +	void __iomem *dist_base;
> +
> +	if (WARN_ON(!node))

Sigh.

Though the real question is: can this actually happen?

> +		return -ENODEV;
> +
> +	dist_base = of_iomap(node, 0);
> +	WARN(!dist_base, "unable to map nvic dist registers\n");

Brilliant. You can't map stuff and then you continue just for fun or
what?

> +	nvic_init_bases(node, dist_base);

Great. You have failure pathes in nvic_init_bases() and then you
return unconditionally success:

> +	return 0;
> +}

Thanks,

	tglx
--8323328-349303409-1363115234=:22263--
