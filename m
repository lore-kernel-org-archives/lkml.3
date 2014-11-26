Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaKZLL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:11:58 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46437 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbaKZLL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:11:57 -0500
Date: Wed, 26 Nov 2014 11:11:07 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: Re: [PATCH v11 1/2] irqchip: gicv2m: Add support for ARM GICv2m
 MSI(-X) doorbell
Message-ID: <20141126111107.GA4340@leverpostej>
References: <1416941243-7181-1-git-send-email-marc.zyngier@arm.com>
 <1416941243-7181-2-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416941243-7181-2-git-send-email-marc.zyngier@arm.com>
Thread-Topic: [PATCH v11 1/2] irqchip: gicv2m: Add support for ARM GICv2m
 MSI(-X) doorbell
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Tue, Nov 25, 2014 at 06:47:22PM +0000, Marc Zyngier wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> ARM GICv2m specification extends GICv2 to support MSI(-X) with
> a new register frame. This allows a GICv2 based system to support
> MSI with minimal changes.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> [maz: converted the driver to use stacked irq domains,
>       updated changelog]
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/Kconfig              |   1 +
>  drivers/irqchip/Kconfig         |   6 +
>  drivers/irqchip/Makefile        |   1 +
>  drivers/irqchip/irq-gic-v2m.c   | 333 ++++++++++++++++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic.c       |   4 +
>  include/linux/irqchip/arm-gic.h |   2 +
>  6 files changed, 347 insertions(+)
>  create mode 100644 drivers/irqchip/irq-gic-v2m.c

[...]

> +static int gicv2m_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +				   unsigned int nr_irqs, void *args)
> +{
> +	struct v2m_data *v2m = domain->host_data;
> +	int hwirq, offset, err = 0;
> +
> +	spin_lock(&v2m->msi_cnt_lock);
> +	offset = find_first_zero_bit(v2m->bm, v2m->nr_spis);
> +	if (offset < v2m->nr_spis)
> +		__set_bit(offset, v2m->bm);
> +	else
> +		err = -ENOSPC;
> +	spin_unlock(&v2m->msi_cnt_lock);
> +
> +	if (err)
> +		return err;
> +
> +	hwirq = v2m->spi_start + offset;
> +
> +	err = gicv2m_irq_gic_domain_alloc(domain, virq, hwirq);
> +	if (err) {
> +		gicv2m_unalloc_msi(v2m, hwirq);
> +		return err;
> +	}
> +
> +	irq_domain_set_hwirq_and_chip(domain, virq, hwirq,
> +				      &gicv2m_irq_chip, v2m);
> +
> +	return 0;
> +}
> +
> +static void gicv2m_irq_domain_free(struct irq_domain *domain,
> +				   unsigned int virq, unsigned int nr_irqs)
> +{
> +	struct irq_data *d = irq_domain_get_irq_data(domain, virq);
> +	struct v2m_data *v2m = irq_data_get_irq_chip_data(d);
> +
> +	BUG_ON(nr_irqs != 1);

We didn't check nr_irqs at all in gicv2m_irq_domain_alloc, which seems a
bit odd given this BUG_ON.

Is the caller responsible for checking we only allocated one irq, or is
it only valid to ask for one?

> +	gicv2m_unalloc_msi(v2m, d->hwirq);
> +	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
> +}
> +
> +static const struct irq_domain_ops gicv2m_domain_ops = {
> +	.alloc			= gicv2m_irq_domain_alloc,
> +	.free			= gicv2m_irq_domain_free,
> +};
> +
> +static bool is_msi_spi_valid(u32 base, u32 num)
> +{
> +	if (base < V2M_MIN_SPI) {
> +		pr_err("Invalid MSI base SPI (base:%u)\n", base);
> +		return false;
> +	}
> +
> +	if ((num == 0) || (base + num > V2M_MAX_SPI)) {
> +		pr_err("Number of SPIs (%u) exceed maximum (%u)\n",
> +		       num, V2M_MAX_SPI - V2M_MIN_SPI + 1);

That warning is a bit odd for the num == 0 case. Perhaps
s/exceed/invalid,/ ?

> +		return false;
> +	}
> +
> +	return true;
> +}
> +

[...]

> +static int __init gicv2m_init_one(struct device_node *node,
> +				  struct irq_domain *parent)
> +{
> +	int ret;
> +	struct v2m_data *v2m;
> +
> +	v2m = kzalloc(sizeof(struct v2m_data), GFP_KERNEL);

Minor nit: sizeof(*v2m) would be preferable.

> +	if (!v2m) {
> +		pr_err("Failed to allocate struct v2m_data.\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = of_address_to_resource(node, 0, &v2m->res);
> +	if (ret) {
> +		pr_err("Failed to allocate v2m resource.\n");
> +		goto err_free_v2m;
> +	}
> +
> +	v2m->base = ioremap(v2m->res.start, resource_size(&v2m->res));
> +	if (!v2m->base) {
> +		pr_err("Failed to map GICv2m resource\n");
> +		ret = -ENOMEM;
> +		goto err_free_v2m;
> +	}
> +
> +	if (!of_property_read_u32(node, "arm,msi-base-spi", &v2m->spi_start) &&
> +	    !of_property_read_u32(node, "arm,msi-num-spis", &v2m->nr_spis)) {
> +		pr_info("Overriding V2M MSI_TYPER (base:%u, num:%u)\n",
> +			v2m->spi_start, v2m->nr_spis);

It would be nice if we could warn if only one of these properties is
present.

Thanks,
Mark.
