Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab3CLUrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:47:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50302 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933527Ab3CLUrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:47:03 -0400
Date: Tue, 12 Mar 2013 21:47:01 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] irqchip: Add support for ARMv7-M's NVIC
Message-ID: <20130312204701.GS15375@pengutronix.de>
References: <1363103673-24720-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <alpine.LFD.2.02.1303121923280.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1303121923280.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Tue, Mar 12, 2013 at 08:57:34PM +0100, Thomas Gleixner wrote:
> On Tue, 12 Mar 2013, Uwe Kleine-König wrote:
> > +static struct nvic_chip_data nvic_data __read_mostly;
> 
> What the heck is this? You have a static struct which you set in
> irqdata.chip_data?
I copied that idea from the gic driver and didn't question it because I
thought it's too early to allocate memory when it's needed. Or do you
just wonder about the usage of this static variable?

> > +static inline void __iomem *nvic_dist_base(struct irq_data *d)
> > +{
> > +	struct nvic_chip_data *nvic_data = irq_data_get_irq_chip_data(d);
> 
> And then you do the dance of reading the pointer to that static struct
> out of irq_data and dereferencing it?
> 
> What's the point of this? 
The idea was to keep the functions generic anyhow.
 
> > +	return nvic_data->dist_base;
> > +}
> > +
> > +static void nvic_mask_irq(struct irq_data *d)
> > +{
> > +	u32 mask = 1 << (d->hwirq % 32);
> > +
> > +	writel_relaxed(mask, nvic_dist_base(d) + NVIC_ICER + d->irq / 32 * 4);
> 
> You're really missing the point of irq_data.chip_data 
> 
> If you set proper irq chip data per bank then this whole stuff is
> reduced to:
> 
>    struct mydata *md = irq_data_get_irq_chip_data(d);
>    u32 mask = 1 << (d->irq - md->irq_base);
> 
>    writel_relaxed(mask, md->iobase + NVIC_ICER);
> 
> Can you spot the difference and what that means in terms of
> instruction cycles?
Yeah I see. The cost is increased memory usage. You'd probably say that
the amount needed here is too small to care about. Still many decisions
like this sum up and make the 4 MiB of RAM I have a tight fit.
 
> > +}
> > +
> > +static void nvic_unmask_irq(struct irq_data *d)
> > +{
> > +	u32 mask = 1 << (d->hwirq % 32);
> > +
> > +	writel_relaxed(mask, nvic_dist_base(d) + NVIC_ISER + d->hwirq / 32 * 4);
> > +}
> > +
> > +void nvic_eoi(struct irq_data *d)
> 
> static ?
yes.

> > +{
> > +	/*
> > +	 * This is a no-op as end of interrupt is signaled by the exception
> > +	 * return sequence.
> > +	 */
> > +}
> > +
> > +static struct irq_chip nvic_chip = {
> > +	.name = "NVIC",
> > +	.irq_mask = nvic_mask_irq,
> > +	.irq_unmask = nvic_unmask_irq,
> > +	.irq_eoi = nvic_eoi,
> > +};
> > +
> > +static void __init nvic_init_bases(struct device_node *node,
> > +		void __iomem *dist_base)
> 
> Please make this
> 
> static void __init nvic_init_bases(struct device_node *node,
>                                    void __iomem *dist_base)
> 
> That's way easier to parse. Applies to all other multiline stuff as
> well.
My version is like vim does the layout for me. It's the first time
someone opposes to it. The reason I prefer using a fixed indention is
that I don't need to touch the latter lines when for example the
function name or the function's type change.

Hmm, I can fix that if you insist.

> > +{
> > +	unsigned int irqs, i, irq_base;
> > +
> > +	nvic_data.dist_base = dist_base;
> > +
> > +	irqs = ((readl_relaxed(dist_base + NVIC_INTR_CTRL) & 0x0f) + 1) * 32;
> > +	if (irqs > 496)
> > +		irqs = 496;
> 
> Magic constants. Please use proper defines. 
> 
> Aside of that without a proper comment the logic looks ass backwards.
Ok.

> > +	irqs = ((readl_relaxed(dist_base + NVIC_INTR_CTRL) & 0x0f) + 1) * 32;
> 
> Without looking at the datasheet I assume that the chip tells you the
> number of interrupt banks where a result of 0 means 1 bank and so
> forth.
> 
> How should a reviewer understand why the number of banks is limited to
> 31 without a comment? Do you really expect that a reviewer who
> stumbles over that goes to search for the datasheet and verify what
> you hacked up?
Will add a comment.

> > +	irq_base = irq_alloc_descs(-1, 16, irqs - 16, numa_node_id());
> 
>   irq_alloc_desc_from(16, irqs - 16, ...)
> 
> Also why are you allocating irqs-16 instead of the full number of
> irqs?
I already have a comment there in my tree.

> > +	if (IS_ERR_VALUE(irq_base)) {
> 
> See Russells reply
> 
> > +		WARN(1, "Cannot allocate irq_descs\n");
> 
> What's the point of that warn? The call path is always the same. So
> you are spamming dmesg with a pointless backtrace. And on top of that
> you do:
There is one warning per call to nvic_init_bases. So I don't expect more
than one message in dmesg.

> 
> > +		irq_base = 16;
> 
> So you cannot allocate irq_descs and then you set base to 16 and pray
> that everything works?
If something goes wrong here the machine is probably silent about it. So
continuing after a prayer might (or might not?) be an option.

> > +	}
> > +	nvic_data.domain = irq_domain_add_legacy(node, irqs - 16, irq_base, 0,
> > +			&irq_domain_simple_ops, NULL);
> > +	if (WARN_ON(!nvic_data.domain))
> > +		return;
> 
> See above. Also you are leaking irqdescs though it's questionable
> whether the machine can continue at all. And of course the init call
> itself will return sucess.
> 
> > +	/*
> > +	 * Set priority on all interrupts.
> > +	 */
> > +	for (i = 0; i < irqs; i += 4)
> > +		writel_relaxed(0, dist_base + NVIC_IPRI + i);
> > +
> > +	/*
> > +	 * Disable all interrupts
> > +	 */
> > +	for (i = 0; i < irqs; i += 32)
> > +		writel_relaxed(~0, dist_base + NVIC_ICER + i * 4 / 32);
> > +
> > +	/*
> > +	 * Setup the Linux IRQ subsystem.
> > +	 */
> > +	for (i = 0; i < irqs; i++) {
> > +		irq_set_chip_and_handler(irq_base + i, &nvic_chip,
> > +				handle_fasteoi_irq);
> 
> Above you do:
> 	irq_base = irq_alloc_descs(-1, 16, irqs - 16, numa_node_id());
> 
> So you allocate irqs-16 interrupt descriptors and then you initialize
> 16 more than you allocated.
right.

> Brilliant stuff that.
> 
> > +		irq_set_chip_data(irq_base + i, &nvic_data);
> > +		set_irq_flags(irq_base + i, IRQF_VALID | IRQF_PROBE);
> > +	}
> > +}
> > +
> > +static int __init nvic_of_init(struct device_node *node,
> > +		struct device_node *parent)
> > +{
> > +	void __iomem *dist_base;
> > +
> > +	if (WARN_ON(!node))
> 
> Sigh.
> 
> Though the real question is: can this actually happen?
It didn't happen for me. What do you suggest? dropping WARN_ON?

> > +		return -ENODEV;
> > +
> > +	dist_base = of_iomap(node, 0);
> > +	WARN(!dist_base, "unable to map nvic dist registers\n");
> 
> Brilliant. You can't map stuff and then you continue just for fun or
> what?
What do you suggest? returning -ESOMETHING?
> 
> > +	nvic_init_bases(node, dist_base);
> 
> Great. You have failure pathes in nvic_init_bases() and then you
> return unconditionally success:
Most of your critics also apply to irq-gic.c. I will follow up with a
patch for that when you are happy with my work for the nvic.

Best regards and thanks for your feed-back,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
