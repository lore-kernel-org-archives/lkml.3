Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaKSSFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:05:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59947 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986AbaKSSFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:05:12 -0500
Date: Wed, 19 Nov 2014 18:04:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 2/4] ARM: mediatek: Add sysirq interrupt polarity
 support
Message-ID: <20141119180448.GD12851@leverpostej>
References: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
 <1416406451-4578-3-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416406451-4578-3-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 02:14:09PM +0000, Yingjoe Chen wrote:
> Mediatek SoCs have interrupt polarity support in sysirq which
> allows to invert polarity for given interrupt. Add this support
> using hierarchy irq domain.
> 
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> ---
>  drivers/irqchip/Makefile         |   1 +
>  drivers/irqchip/irq-mtk-sysirq.c | 158 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 159 insertions(+)
>  create mode 100644 drivers/irqchip/irq-mtk-sysirq.c
> 
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 173bb5f..4e0f254 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -38,3 +38,4 @@ obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
>  obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o \
>  					   irq-bcm7120-l2.o
>  obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
> +obj-$(CONFIG_ARCH_MEDIATEK)		+= irq-mtk-sysirq.o
> diff --git a/drivers/irqchip/irq-mtk-sysirq.c b/drivers/irqchip/irq-mtk-sysirq.c
> new file mode 100644
> index 0000000..93cb945
> --- /dev/null
> +++ b/drivers/irqchip/irq-mtk-sysirq.c
> @@ -0,0 +1,158 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Joe.C <yingjoe.chen@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_address.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include "irqchip.h"
> +
> +#define MT6577_SYS_INTPOL_NUM	(224)
> +
> +struct mtk_sysirq_chip_data {
> +	spinlock_t lock;
> +	void __iomem *intpol_base;
> +};
> +
> +static int mtk_sysirq_set_type(struct irq_data *data, unsigned int type)
> +{
> +	irq_hw_number_t hwirq = data->hwirq;
> +	struct mtk_sysirq_chip_data *chip_data = data->chip_data;
> +	u32 offset, reg_index, value;
> +	unsigned long flags;
> +	int ret;
> +
> +	offset = hwirq & 0x1f;
> +	reg_index = hwirq >> 5;
> +
> +	spin_lock_irqsave(&chip_data->lock, flags);
> +	value = readl_relaxed(chip_data->intpol_base + reg_index * 4);
> +	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_EDGE_FALLING) {
> +		if (type == IRQ_TYPE_LEVEL_LOW)
> +			type = IRQ_TYPE_LEVEL_HIGH;
> +		else
> +			type = IRQ_TYPE_EDGE_RISING;
> +		value |= (1 << offset);
> +	} else
> +		value &= ~(1 << offset);

Nit: if one branch of an if statements is bracketed, both branches
should be. Please bracket the else case.

> +	writel(value, chip_data->intpol_base + reg_index * 4);
> +
> +	data = data->parent_data;
> +	ret = data->chip->irq_set_type(data, type);
> +	spin_unlock_irqrestore(&chip_data->lock, flags);
> +	return ret;
> +}
> +
> +static struct irq_chip mtk_sysirq_chip = {
> +	.name			= "MT_SYSIRQ",
> +	.irq_mask		= irq_chip_mask_parent,
> +	.irq_unmask		= irq_chip_unmask_parent,
> +	.irq_eoi		= irq_chip_eoi_parent,
> +	.irq_set_type		= mtk_sysirq_set_type,
> +	.irq_retrigger		= irq_chip_retrigger_hierarchy,
> +	.irq_set_affinity	= irq_chip_set_affinity_parent,
> +};
> +
> +static int mtk_sysirq_domain_xlate(struct irq_domain *d,
> +				   struct device_node *controller,
> +				   const u32 *intspec, unsigned int intsize,
> +				   unsigned long *out_hwirq,
> +				   unsigned int *out_type)
> +{
> +	if (intsize < 3)
> +		return -EINVAL;
> +
> +	/* sysirq doesn't support PPI */
> +	if (intspec[0])
> +		return -EINVAL;
> +
> +	*out_hwirq = intspec[1];
> +	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;

All of this is very strongly tied to the GIC, but the binding made it
sound like this was more generic (it didn't specify the number of cells
or their meaning). It doesn't look like we validate that this is
attached to a GIC.

Do we expect this to only ever be attached to a GICv2?

It would be nice to either make this generic or to describe the format
in the binding.

Also, surely you expect intsize == 3 if you expect a GICv2? Likewise in
mtk_sysirq_domain_alloc.

Thanks,
Mark.

> +	return 0;
> +}
> +
> +static int mtk_sysirq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +				   unsigned int nr_irqs, void *arg)
> +{
> +	int i;
> +	irq_hw_number_t hwirq;
> +	struct of_phandle_args *irq_data = arg;
> +	struct of_phandle_args gic_data = *irq_data;
> +
> +	if (irq_data->args_count < 3)
> +		return -EINVAL;
> +
> +	hwirq = irq_data->args[1];
> +	for (i = 0; i < nr_irqs; i++)
> +		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
> +					      &mtk_sysirq_chip,
> +					      domain->host_data);
> +
> +	gic_data.np = domain->parent->of_node;
> +	return irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, &gic_data);
> +}
> +
> +static struct irq_domain_ops sysirq_domain_ops = {
> +	.xlate = mtk_sysirq_domain_xlate,
> +	.alloc = mtk_sysirq_domain_alloc,
> +	.free = irq_domain_free_irqs_common,
> +};
> +
> +static int __init mtk_sysirq_of_init(struct device_node *node,
> +				     struct device_node *parent)
> +{
> +	struct irq_domain *domain, *domain_parent;
> +	struct mtk_sysirq_chip_data *chip_data;
> +	int ret = 0;
> +
> +	domain_parent = irq_find_host(parent);
> +	if (!domain_parent) {
> +		pr_err("mtk_sysirq: interrupt-parent not found\n");
> +		return -EINVAL;
> +	}
> +
> +	chip_data = kzalloc(sizeof(*chip_data), GFP_KERNEL);
> +	if (!chip_data)
> +		return -ENOMEM;
> +
> +	chip_data->intpol_base = of_io_request_and_map(node, 0, "intpol");
> +	if (!chip_data->intpol_base) {
> +		pr_err("mtk_sysirq: unable to map sysirq register\n");
> +		ret = -ENOMEM;
> +		goto out_free;
> +	}
> +
> +	domain = irq_domain_add_hierarchy(domain_parent, 0,
> +					  MT6577_SYS_INTPOL_NUM, node,
> +					  &sysirq_domain_ops, chip_data);
> +	if (!domain) {
> +		ret = -ENOMEM;
> +		goto out_unmap;
> +	}
> +	spin_lock_init(&chip_data->lock);
> +
> +	return 0;
> +
> +out_unmap:
> +	iounmap(chip_data->intpol_base);
> +out_free:
> +	kfree(chip_data);
> +	return ret;
> +}
> +IRQCHIP_DECLARE(mtk_sysirq, "mediatek,mt6577-sysirq", mtk_sysirq_of_init);
> -- 
> 1.8.1.1.dirty
> 
> 
