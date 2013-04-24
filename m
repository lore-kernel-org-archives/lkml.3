Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab3DXJOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:14:16 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39078 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab3DXJOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:14:14 -0400
Message-ID: <5177A262.1000004@imgtec.com>
Date: Wed, 24 Apr 2013 10:14:10 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, "Rob Landley" <rob@landley.net>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 3/8] irq-imgpdc: add ImgTec PDC irqchip driver
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com> <1366727607-27444-4-git-send-email-james.hogan@imgtec.com> <alpine.LFD.2.02.1304231647400.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304231647400.21884@ionos>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_24_10_14_11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review Thomas!

On 23/04/13 16:09, Thomas Gleixner wrote:
> On Tue, 23 Apr 2013, James Hogan wrote:
>> +/**
>> + * struct pdc_intc_priv - private pdc interrupt data.
>> + * @nr_perips:		Number of peripheral interrupt signals.
>> + * @nr_syswakes:	Number of syswake signals.
>> + * @perip_irqs:		List of peripheral IRQ numbers handled.
>> + * @syswake_irq:	Shared PDC syswake IRQ number.
>> + * @domain:		IRQ domain for PDC peripheral and syswake IRQs.
>> + * @pdc_base:		Base of PDC registers.
>> + * @lock:		Lock to protect the PDC syswake registers.
>> + */
>> +struct pdc_intc_priv {
>> +	unsigned int		nr_perips;
>> +	unsigned int		nr_syswakes;
>> +	unsigned int		*perip_irqs;
>> +	unsigned int		syswake_irq;
>> +	struct irq_domain	*domain;
>> +	void __iomem		*pdc_base;
>> +
>> +	spinlock_t		lock;
> 
>   raw_spinlock_t please

Okay.

If I understand right, this would be because on RT, spinlock_t becomes a
mutex and won't work correctly with irqs actually disabled for the irq
callbacks below, is that right?

>> +static void perip_irq_mask(struct irq_data *data)
>> +{
>> +	struct pdc_intc_priv *priv = irqd_to_priv(data);
>> +	unsigned int irq_route;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&priv->lock, flags);
> 
> This is always called with interrupts disabled.

Okay, I'll switch to raw_spin_lock

>> +	irq_route = pdc_read(priv, PDC_IRQ_ROUTE);
>> +	irq_route &= ~(1 << data->hwirq);
> 
> Why not cache the mask value ?

Yes, caching PDC_IRQ_ROUTE should be possible since it should only be
used by this driver (hence the driver local spinlock).

> 
>> +	pdc_write(priv, PDC_IRQ_ROUTE, irq_route);
> 
>> +	spin_unlock_irqrestore(&priv->lock, flags);
>> +}
>> +
>> +static void perip_irq_unmask(struct irq_data *data)
>> +{
>> +	struct pdc_intc_priv *priv = irqd_to_priv(data);
>> +	unsigned int irq_route;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&priv->lock, flags);
>> +	irq_route = pdc_read(priv, PDC_IRQ_ROUTE);
>> +	irq_route |= 1 << data->hwirq;
>> +	pdc_write(priv, PDC_IRQ_ROUTE, irq_route);
> 
> This code is another slightly different copy of stuff which is
> available in kernel/irq/generic-chip.c
> 
> Can we please stop the code duplication and reuse existing
> infrastructure? Don't tell me it does not work for you.  I sent out a
> patch yesterday which makes the code suitable for irq domains.

I'll look into this. kernel/irq/generic-chip.c was added after this
driver was written.

>> +static void pdc_intc_perip_isr(unsigned int irq, struct irq_desc *desc)
>> +{
>> +	struct pdc_intc_priv *priv;
>> +	unsigned int i, irq_no;
>> +
>> +	priv = (struct pdc_intc_priv *)irq_desc_get_handler_data(desc);
>> +
>> +	/* find the peripheral number */
>> +	for (i = 0; i < priv->nr_perips; ++i)
>> +		if (irq == priv->perip_irqs[i])
>> +			goto found;
> 
> Whee. Aren't these numbers linear ?

Not necessarily as they're virtual irq numbers obtained via
platform_get_irq(), which come individually from device tree. Even their
hardware irq numbers aren't linear as they're not wired to their irqchip
in the same order:
> pdc: pdc@0x02006000 {
> 	interrupt-controller;
> 	#interrupt-cells = <3>;
> 
> 	reg = <0x02006000 0x1000>;
> 	compatible = "img,pdc-intc";
> 
> 	num-perips = <3>;
> 	num-syswakes = <3>;
> 
> 	interrupts = <18 4 /* level */>, /* Syswakes */
> 	             <30 4 /* level */>, /* Perip 0 (RTC) */
> 	             <29 4 /* level */>, /* Perip 1 (IR) */
> 	             <31 4 /* level */>; /* Perip 2 (WDT) */
> };

>> +static int pdc_intc_probe(struct platform_device *pdev)
>> +{
>> +	struct pdc_intc_priv *priv;
>> +	struct device_node *node = pdev->dev.of_node;
>> +	struct resource *res_regs;
>> +	unsigned int i;
>> +	int irq, ret;
>> +	u32 val;
>> +
>> +	if (!node)
>> +		return -ENOENT;
>> +
>> +	/* Get registers */
>> +	res_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (res_regs == NULL) {
>> +		dev_err(&pdev->dev, "cannot find registers resource\n");
>> +		return -ENOENT;
>> +	}
>> +
>> +	/* Allocate driver data */
>> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>> +	if (!priv) {
>> +		dev_err(&pdev->dev, "cannot allocate device data\n");
>> +		return -ENOMEM;
>> +	}
>> +	spin_lock_init(&priv->lock);
>> +	platform_set_drvdata(pdev, priv);
>> +
>> +	/* Ioremap the registers */
>> +	priv->pdc_base = devm_ioremap(&pdev->dev, res_regs->start,
>> +				      res_regs->end - res_regs->start);
>> +	if (!priv->pdc_base)
>> +		return -EIO;
> 
> Leaks priv.
> 
>> +	/* Get number of peripherals */
>> +	ret = of_property_read_u32(node, "num-perips", &val);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "No num-perips node property found\n");
>> +		return -EINVAL;
> 
> Leaks priv and mapping
> 
>> +	}
>> +	if (val > SYS0_HWIRQ) {
>> +		dev_err(&pdev->dev, "num-perips (%u) out of range\n", val);
>> +		return -EINVAL;
> 
> Error handling is optional, right?
> 
>> +static int pdc_intc_remove(struct platform_device *pdev)
>> +{
>> +	struct pdc_intc_priv *priv = platform_get_drvdata(pdev);
>> +
>> +	irq_domain_remove(priv->domain);
> 
> And the rest of the resources is still there?

I was under the impression devm_kzalloc and devm_ioremap took care of
that in both the probe error case and the remove case:

>  * devm_kzalloc - Resource-managed kzalloc
>  * Managed kzalloc.  Memory allocated with this function is
>  * automatically freed on driver detach. 

>  * devm_ioremap - Managed ioremap()
>  * Managed ioremap().  Map is automatically unmapped on driver detach.

I may have misunderstood the whole point of their existence though?

Thanks
James

