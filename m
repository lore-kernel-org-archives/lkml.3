Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbaGRNAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:00:03 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48457 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaGRNAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:00:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+MB/p1jqv5ynMQ0rOly00yaAWdQzIehls=
X-DKIM: OpenDKIM Filter v2.0.1 titan E111D5AF591
Date: Fri, 18 Jul 2014 08:59:53 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, santosh.shilimkar@ti.com,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        ivan.khoronzhuk@ti.com, m-karicheri2@ti.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: add keystone irq controller ip driver
Message-ID: <20140718125953.GF24496@titan.lakedaemon.net>
References: <1405351677-12108-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405351677-12108-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii,

On Mon, Jul 14, 2014 at 06:27:57PM +0300, Grygorii Strashko wrote:
> On Keystone SOCs, DSP cores can send interrupts to ARM
> host using the IRQ controller IP. It provides 28 IRQ
> signals to ARM. The IRQ handler running on HOST OS can
> identify DSP signal source by analyzing SRCCx bits in
> IPCARx registers. This is one of the component used by
> the IPC mechanism used on Keystone SOCs.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../interrupt-controller/ti,keystone-irq.txt       |   36 +++
>  drivers/irqchip/Kconfig                            |    7 +
>  drivers/irqchip/Makefile                           |    1 +
>  drivers/irqchip/irq-keystone.c                     |  235 ++++++++++++++++++++
>  4 files changed, 279 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt
>  create mode 100644 drivers/irqchip/irq-keystone.c
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt b/Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt
> new file mode 100644
> index 0000000..68d27b7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt
> @@ -0,0 +1,36 @@
> +Keystone 2 IRQ controller IP
> +
> +On Keystone SOCs, DSP cores can send interrupts to ARM
> +host using the IRQ controller IP. It provides 28 IRQ signals to ARM.
> +The IRQ handler running on HOST OS can identify DSP signal source by
> +analyzing SRCCx bits in IPCARx registers. This is one of the component
> +used by the IPC mechanism used on Keystone SOCs.
> +
> +Required Properties:
> +- compatible: should be "ti,keystone-irq"
> +- ti,syscon-dev:	phandle and offset pair. The phandle to syscon used to
> +			access device control registers and the offset inside
> +			device control registers range.
> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Specifies the number of cells needed to encode interrupt
> +					 source should be 1.
> +- interrupts: interrupt reference to primary interrupt controller
> +
> +Please refer to interrupts.txt in this directory for details of the common
> +Interrupt Controllers bindings used by client devices.
> +
> +Example:
> +	kirq0: keystone_irq0@026202a0 {
> +		compatible = "ti,keystone-irq";
> +		ti,syscon-dev = <&devctrl 0x2a0>;
> +		interrupts = <GIC_SPI 4 IRQ_TYPE_EDGE_RISING>;
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +	};
> +
> +	dsp0: dsp0 {
> +		compatible = "linux,rproc-user";
> +		...
> +		interrupt-parent = <&kirq0>;
> +		interrupts = <10 2>;
> +	};
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index bbb746e..7f413c4 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -91,3 +91,10 @@ config IRQ_CROSSBAR
>  	  The primary irqchip invokes the crossbar's callback which inturn allocates
>  	  a free irq and configures the IP. Thus the peripheral interrupts are
>  	  routed to one of the free irqchip interrupt lines.
> +
> +config KEYSTONE_IRQ
> +	tristate "Keystone 2 IRQ controller IP"
> +	depends on ARCH_KEYSTONE
> +	help
> +		Support for Texas Instruments Keystone 2 IRQ controller IP which
> +		is part of the Keystone 2 IPC mechanism
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 62a13e5..7d0636b 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
>  obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
>  obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
>  obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
> +obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
> diff --git a/drivers/irqchip/irq-keystone.c b/drivers/irqchip/irq-keystone.c
> new file mode 100644
> index 0000000..309ef74
> --- /dev/null
> +++ b/drivers/irqchip/irq-keystone.c
> @@ -0,0 +1,235 @@
> +/*
> + * Texas Instruments Keystone IRQ controller IP driver
> + *
> + * Copyright (C) 2014 Texas Instruments, Inc.
> + * Author: Sajesh Kumar Saran <sajesh@ti.com>
> + *	   Grygorii Strashko <grygorii.strashko@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/irq.h>
> +#include <linux/bitops.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/irqdomain.h>
> +#include <linux/irqchip/chained_irq.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +#include "irqchip.h"
> +
> +
> +/* The source ID bits start from 4 to 31 (total 28 bits)*/
> +#define BIT_OFS			4
> +#define KYESTONE_N_IRQ		(32 - BIT_OFS)

s/KYESTONE/KEYSTONE/g

> +
> +struct keystone_irq_device {
> +	struct device		*dev;
> +	struct irq_chip		 chip;
> +	u32			 mask;
> +	u32			 irq;
> +	struct irq_domain	*irqd;
> +	struct regmap		*devctrl_regs;
> +	u32			devctrl_offset;
> +};
> +
> +static inline u32 keystone_irq_readl(struct keystone_irq_device *kirq)
> +{
> +	int ret;
> +	u32 val = 0;
> +
> +	ret = regmap_read(kirq->devctrl_regs, kirq->devctrl_offset, &val);
> +	if (ret < 0)
> +		dev_dbg(kirq->dev, "irq read failed ret(%d)\n", ret);
> +	return val;
> +}
> +
> +static inline void
> +keystone_irq_writel(struct keystone_irq_device *kirq, u32 value)
> +{
> +	int ret;
> +
> +	ret = regmap_write(kirq->devctrl_regs, kirq->devctrl_offset, value);
> +	if (ret < 0)
> +		dev_dbg(kirq->dev, "irq write failed ret(%d)\n", ret);
> +}
> +
> +static void keystone_irq_mask(struct irq_data *d)

Perhaps keystone_irq_setmask() ?

> +{
> +	struct keystone_irq_device *kirq = irq_data_get_irq_chip_data(d);
> +
> +	kirq->mask |= BIT(d->hwirq);
> +	dev_dbg(kirq->dev, "mask %lu [%x]\n", d->hwirq, kirq->mask);
> +}
> +
> +void keystone_irq_unmask(struct irq_data *d)
> +{
> +	struct keystone_irq_device *kirq = irq_data_get_irq_chip_data(d);
> +
> +	kirq->mask &= ~BIT(d->hwirq);
> +	dev_dbg(kirq->dev, "unmask %lu [%x]\n", d->hwirq, kirq->mask);
> +}
> +
> +void keystone_irq_ack(struct irq_data *d)
> +{
> +	struct keystone_irq_device *kirq = irq_data_get_irq_chip_data(d);
> +
> +	/* nothing to do here */

I'd prefer to see this do nothing then, eg just return.

> +	dev_dbg(kirq->dev, "ack %lu [%x]\n", d->hwirq, kirq->mask);
> +}
> +
> +void keystone_irq_handler(unsigned irq, struct irq_desc *desc)
> +{
> +	struct keystone_irq_device *kirq = irq_desc_get_handler_data(desc);
> +	unsigned long pending;
> +	int src, virq;
> +
> +	dev_dbg(kirq->dev, "start irq %d\n", irq);
> +
> +	chained_irq_enter(irq_desc_get_chip(desc), desc);
> +
> +	pending = keystone_irq_readl(kirq);
> +	keystone_irq_writel(kirq, pending);
> +
> +	dev_dbg(kirq->dev, "pending 0x%lx, mask 0x%x\n", pending, kirq->mask);
> +
> +	pending = (pending >> BIT_OFS) & ~kirq->mask;
> +
> +	dev_dbg(kirq->dev, "pending after mask 0x%lx\n", pending);
> +
> +	for (src = 0; src < KYESTONE_N_IRQ; src++) {
> +		if (BIT(src) & pending) {
> +			virq = irq_find_mapping(kirq->irqd, src);
> +			dev_dbg(kirq->dev, "dispatch bit %d, virq %d\n",
> +				src, virq);
> +			if (!virq)
> +				dev_warn(kirq->dev, "sporious irq detected hwirq %d, virq %d\n",
> +					 src, virq);
> +			generic_handle_irq(virq);
> +		}
> +	}
> +
> +	chained_irq_exit(irq_desc_get_chip(desc), desc);
> +
> +	dev_dbg(kirq->dev, "end irq %d\n", irq);
> +}
> +
> +static int keystone_irq_map(struct irq_domain *h, unsigned int virq,
> +				irq_hw_number_t hw)
> +{
> +	struct keystone_irq_device *kirq = h->host_data;
> +
> +	irq_set_chip_data(virq, kirq);
> +	irq_set_chip_and_handler(virq, &kirq->chip, handle_level_irq);
> +	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
> +	return 0;
> +}
> +
> +static struct irq_domain_ops keystone_irq_ops = {
> +	.map	= keystone_irq_map,
> +	.xlate	= irq_domain_xlate_onecell,
> +};
> +
> +static int keystone_irq_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct keystone_irq_device *kirq;
> +	int ret;
> +
> +	if (np == NULL)
> +		return -EINVAL;
> +
> +	kirq = devm_kzalloc(dev, sizeof(*kirq), GFP_KERNEL);
> +	if (!kirq)
> +		return -ENOMEM;
> +
> +	kirq->devctrl_regs =
> +		syscon_regmap_lookup_by_phandle(np, "ti,syscon-dev");
> +	if (IS_ERR(kirq->devctrl_regs))
> +		return PTR_ERR(kirq->devctrl_regs);
> +
> +	ret = of_property_read_u32_index(np, "ti,syscon-dev", 1,
> +					 &kirq->devctrl_offset);
> +	if (ret) {
> +		dev_err(dev, "couldn't read the devctrl_offset offset!\n");
> +		return ret;
> +	}
> +
> +	kirq->irq = platform_get_irq(pdev, 0);
> +	if (kirq->irq < 0) {
> +		dev_err(dev, "no irq resource %d\n", kirq->irq);
> +		return kirq->irq;
> +	}
> +
> +	kirq->dev = dev;
> +	kirq->mask = ~0x0;
> +	kirq->chip.name		= "keystone-irq";
> +	kirq->chip.irq_ack	= keystone_irq_ack;
> +	kirq->chip.irq_mask	= keystone_irq_mask;
> +	kirq->chip.irq_unmask	= keystone_irq_unmask;
> +
> +	kirq->irqd = irq_domain_add_linear(np, KYESTONE_N_IRQ,
> +					   &keystone_irq_ops, kirq);
> +	if (!kirq->irqd) {
> +		dev_err(dev, "IRQ domain registration failed\n");
> +		return -ENODEV;
> +	}
> +
> +	platform_set_drvdata(pdev, kirq);
> +
> +	irq_set_chained_handler(kirq->irq, keystone_irq_handler);
> +	irq_set_handler_data(kirq->irq, kirq);
> +
> +	/* clear all source bits */
> +	keystone_irq_writel(kirq, ~0x0);
> +
> +	dev_info(dev, "irqchip registered, nr_irqs %u\n", KYESTONE_N_IRQ);
> +
> +	return 0;
> +}
> +
> +static int keystone_irq_remove(struct platform_device *pdev)
> +{
> +	struct keystone_irq_device *kirq = platform_get_drvdata(pdev);
> +	int hwirq;
> +
> +	for (hwirq = 0; hwirq < KYESTONE_N_IRQ; hwirq++)
> +		irq_dispose_mapping(irq_find_mapping(kirq->irqd, hwirq));
> +
> +	irq_domain_remove(kirq->irqd);
> +	return 0;
> +}
> +
> +static const struct of_device_id keystone_irq_dt_ids[] = {
> +	{ .compatible = "ti,keystone-irq", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, keystone_irq_dt_ids);
> +
> +static struct platform_driver keystone_irq_device_driver = {
> +	.probe		= keystone_irq_probe,
> +	.remove		= keystone_irq_remove,
> +	.driver		= {
> +		.name	= "keystone_irq",
> +		.owner	= THIS_MODULE,
> +		.of_match_table	= of_match_ptr(keystone_irq_dt_ids),
> +	}
> +};
> +
> +module_platform_driver(keystone_irq_device_driver);

My understanding of DSP use-cases is a little sparse, are there
legitimate scenarios where you might remove this driver during runtime?
Perhaps IRQCHIP_DECLARE() might be better?

thx,

Jason.
