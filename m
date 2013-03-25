Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3CYOAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:00:16 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:39037 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab3CYOAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:00:14 -0400
Message-ID: <51505869.8010203@gmail.com>
Date: Mon, 25 Mar 2013 09:00:09 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        kevin@allwinnertech.com, sunny@allwinnertech.com
Subject: Re: [PATCH 07/10] irqchip: sunxi: Rename sunxi to sun4i
References: <1364218233-29636-1-git-send-email-maxime.ripard@free-electrons.com> <1364218233-29636-8-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1364218233-29636-8-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 08:30 AM, Maxime Ripard wrote:
> During the introduction of the Allwinner SoC platforms, sunxi was
> initially meant as a generic name for all the variants of the Allwinner
> SoC.
> 
> It was ok at the time of the support of only the A10 and A13 that
> looks pretty much the same, but it's beginning to be troublesome with
> the future addition of the Allwinner A31 (sun6i) that is quite
> different, and would introduce some weird logic, where sunxi would
> actually mean in some case sun4i and sun5i but without sun6i...
> 
> Moreover, it makes the compatible strings naming scheme not consistent
> with other architectures, where usually for this kind of compability, we
> just use the oldest SoC name that has this IP, so let's do just this.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/irqchip/Makefile    |    2 +-
>  drivers/irqchip/irq-sun4i.c |  149 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/irqchip/irq-sunxi.c |  149 -------------------------------------------
>  3 files changed, 150 insertions(+), 150 deletions(-)

You need to use the -M option for git-format-patch when sending this patch.

Rob

>  create mode 100644 drivers/irqchip/irq-sun4i.c
>  delete mode 100644 drivers/irqchip/irq-sunxi.c
> 
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 98e3b87..5416965 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -4,7 +4,7 @@ obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
>  obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
>  obj-$(CONFIG_METAG)			+= irq-metag-ext.o
>  obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
> -obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi.o
> +obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
>  obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
>  obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
>  obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
> diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
> new file mode 100644
> index 0000000..b66d4ae
> --- /dev/null
> +++ b/drivers/irqchip/irq-sun4i.c
> @@ -0,0 +1,149 @@
> +/*
> + * Allwinner A1X SoCs IRQ chip driver.
> + *
> + * Copyright (C) 2012 Maxime Ripard
> + *
> + * Maxime Ripard <maxime.ripard@free-electrons.com>
> + *
> + * Based on code from
> + * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
> + * Benn Huang <benn@allwinnertech.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +
> +#include <asm/exception.h>
> +#include <asm/mach/irq.h>
> +
> +#include "irqchip.h"
> +
> +#define SUN4I_IRQ_VECTOR_REG		0x00
> +#define SUN4I_IRQ_PROTECTION_REG	0x08
> +#define SUN4I_IRQ_NMI_CTRL_REG		0x0c
> +#define SUN4I_IRQ_PENDING_REG(x)	(0x10 + 0x4 * x)
> +#define SUN4I_IRQ_FIQ_PENDING_REG(x)	(0x20 + 0x4 * x)
> +#define SUN4I_IRQ_ENABLE_REG(x)		(0x40 + 0x4 * x)
> +#define SUN4I_IRQ_MASK_REG(x)		(0x50 + 0x4 * x)
> +
> +static void __iomem *sun4i_irq_base;
> +static struct irq_domain *sun4i_irq_domain;
> +
> +static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
> +
> +void sun4i_irq_ack(struct irq_data *irqd)
> +{
> +	unsigned int irq = irqd_to_hwirq(irqd);
> +	unsigned int irq_off = irq % 32;
> +	int reg = irq / 32;
> +	u32 val;
> +
> +	val = readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
> +	writel(val | (1 << irq_off),
> +	       sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
> +}
> +
> +static void sun4i_irq_mask(struct irq_data *irqd)
> +{
> +	unsigned int irq = irqd_to_hwirq(irqd);
> +	unsigned int irq_off = irq % 32;
> +	int reg = irq / 32;
> +	u32 val;
> +
> +	val = readl(sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
> +	writel(val & ~(1 << irq_off),
> +	       sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
> +}
> +
> +static void sun4i_irq_unmask(struct irq_data *irqd)
> +{
> +	unsigned int irq = irqd_to_hwirq(irqd);
> +	unsigned int irq_off = irq % 32;
> +	int reg = irq / 32;
> +	u32 val;
> +
> +	val = readl(sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
> +	writel(val | (1 << irq_off),
> +	       sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
> +}
> +
> +static struct irq_chip sun4i_irq_chip = {
> +	.name		= "sun4i_irq",
> +	.irq_ack	= sun4i_irq_ack,
> +	.irq_mask	= sun4i_irq_mask,
> +	.irq_unmask	= sun4i_irq_unmask,
> +};
> +
> +static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
> +			 irq_hw_number_t hw)
> +{
> +	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
> +				 handle_level_irq);
> +	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
> +
> +	return 0;
> +}
> +
> +static struct irq_domain_ops sun4i_irq_ops = {
> +	.map = sun4i_irq_map,
> +	.xlate = irq_domain_xlate_onecell,
> +};
> +
> +static int __init sun4i_of_init(struct device_node *node,
> +				struct device_node *parent)
> +{
> +	sun4i_irq_base = of_iomap(node, 0);
> +	if (!sun4i_irq_base)
> +		panic("%s: unable to map IC registers\n",
> +			node->full_name);
> +
> +	/* Disable all interrupts */
> +	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(0));
> +	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(1));
> +	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(2));
> +
> +	/* Mask all the interrupts */
> +	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(0));
> +	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(1));
> +	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(2));
> +
> +	/* Clear all the pending interrupts */
> +	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0));
> +	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(1));
> +	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(2));
> +
> +	/* Enable protection mode */
> +	writel(0x01, sun4i_irq_base + SUN4I_IRQ_PROTECTION_REG);
> +
> +	/* Configure the external interrupt source type */
> +	writel(0x00, sun4i_irq_base + SUN4I_IRQ_NMI_CTRL_REG);
> +
> +	sun4i_irq_domain = irq_domain_add_linear(node, 3 * 32,
> +						 &sun4i_irq_ops, NULL);
> +	if (!sun4i_irq_domain)
> +		panic("%s: unable to create IRQ domain\n", node->full_name);
> +
> +	set_handle_irq(sun4i_handle_irq);
> +
> +	return 0;
> +}
> +IRQCHIP_DECLARE(allwinner_sun4i_ic, "allwinner,sun4i-ic", sun4i_of_init);
> +
> +static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
> +{
> +	u32 irq, hwirq;
> +
> +	hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
> +	while (hwirq != 0) {
> +		irq = irq_find_mapping(sun4i_irq_domain, hwirq);
> +		handle_IRQ(irq, regs);
> +		hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
> +	}
> +}
> diff --git a/drivers/irqchip/irq-sunxi.c b/drivers/irqchip/irq-sunxi.c
> deleted file mode 100644
> index 0fc49c5..0000000
> --- a/drivers/irqchip/irq-sunxi.c
> +++ /dev/null
> @@ -1,149 +0,0 @@
> -/*
> - * Allwinner A1X SoCs IRQ chip driver.
> - *
> - * Copyright (C) 2012 Maxime Ripard
> - *
> - * Maxime Ripard <maxime.ripard@free-electrons.com>
> - *
> - * Based on code from
> - * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
> - * Benn Huang <benn@allwinnertech.com>
> - *
> - * This file is licensed under the terms of the GNU General Public
> - * License version 2.  This program is licensed "as is" without any
> - * warranty of any kind, whether express or implied.
> - */
> -
> -#include <linux/io.h>
> -#include <linux/irq.h>
> -#include <linux/of.h>
> -#include <linux/of_address.h>
> -#include <linux/of_irq.h>
> -
> -#include <asm/exception.h>
> -#include <asm/mach/irq.h>
> -
> -#include "irqchip.h"
> -
> -#define SUNXI_IRQ_VECTOR_REG		0x00
> -#define SUNXI_IRQ_PROTECTION_REG	0x08
> -#define SUNXI_IRQ_NMI_CTRL_REG		0x0c
> -#define SUNXI_IRQ_PENDING_REG(x)	(0x10 + 0x4 * x)
> -#define SUNXI_IRQ_FIQ_PENDING_REG(x)	(0x20 + 0x4 * x)
> -#define SUNXI_IRQ_ENABLE_REG(x)		(0x40 + 0x4 * x)
> -#define SUNXI_IRQ_MASK_REG(x)		(0x50 + 0x4 * x)
> -
> -static void __iomem *sunxi_irq_base;
> -static struct irq_domain *sunxi_irq_domain;
> -
> -static asmlinkage void __exception_irq_entry sunxi_handle_irq(struct pt_regs *regs);
> -
> -void sunxi_irq_ack(struct irq_data *irqd)
> -{
> -	unsigned int irq = irqd_to_hwirq(irqd);
> -	unsigned int irq_off = irq % 32;
> -	int reg = irq / 32;
> -	u32 val;
> -
> -	val = readl(sunxi_irq_base + SUNXI_IRQ_PENDING_REG(reg));
> -	writel(val | (1 << irq_off),
> -	       sunxi_irq_base + SUNXI_IRQ_PENDING_REG(reg));
> -}
> -
> -static void sunxi_irq_mask(struct irq_data *irqd)
> -{
> -	unsigned int irq = irqd_to_hwirq(irqd);
> -	unsigned int irq_off = irq % 32;
> -	int reg = irq / 32;
> -	u32 val;
> -
> -	val = readl(sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(reg));
> -	writel(val & ~(1 << irq_off),
> -	       sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(reg));
> -}
> -
> -static void sunxi_irq_unmask(struct irq_data *irqd)
> -{
> -	unsigned int irq = irqd_to_hwirq(irqd);
> -	unsigned int irq_off = irq % 32;
> -	int reg = irq / 32;
> -	u32 val;
> -
> -	val = readl(sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(reg));
> -	writel(val | (1 << irq_off),
> -	       sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(reg));
> -}
> -
> -static struct irq_chip sunxi_irq_chip = {
> -	.name		= "sunxi_irq",
> -	.irq_ack	= sunxi_irq_ack,
> -	.irq_mask	= sunxi_irq_mask,
> -	.irq_unmask	= sunxi_irq_unmask,
> -};
> -
> -static int sunxi_irq_map(struct irq_domain *d, unsigned int virq,
> -			 irq_hw_number_t hw)
> -{
> -	irq_set_chip_and_handler(virq, &sunxi_irq_chip,
> -				 handle_level_irq);
> -	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
> -
> -	return 0;
> -}
> -
> -static struct irq_domain_ops sunxi_irq_ops = {
> -	.map = sunxi_irq_map,
> -	.xlate = irq_domain_xlate_onecell,
> -};
> -
> -static int __init sunxi_of_init(struct device_node *node,
> -				struct device_node *parent)
> -{
> -	sunxi_irq_base = of_iomap(node, 0);
> -	if (!sunxi_irq_base)
> -		panic("%s: unable to map IC registers\n",
> -			node->full_name);
> -
> -	/* Disable all interrupts */
> -	writel(0, sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(0));
> -	writel(0, sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(1));
> -	writel(0, sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(2));
> -
> -	/* Mask all the interrupts */
> -	writel(0, sunxi_irq_base + SUNXI_IRQ_MASK_REG(0));
> -	writel(0, sunxi_irq_base + SUNXI_IRQ_MASK_REG(1));
> -	writel(0, sunxi_irq_base + SUNXI_IRQ_MASK_REG(2));
> -
> -	/* Clear all the pending interrupts */
> -	writel(0xffffffff, sunxi_irq_base + SUNXI_IRQ_PENDING_REG(0));
> -	writel(0xffffffff, sunxi_irq_base + SUNXI_IRQ_PENDING_REG(1));
> -	writel(0xffffffff, sunxi_irq_base + SUNXI_IRQ_PENDING_REG(2));
> -
> -	/* Enable protection mode */
> -	writel(0x01, sunxi_irq_base + SUNXI_IRQ_PROTECTION_REG);
> -
> -	/* Configure the external interrupt source type */
> -	writel(0x00, sunxi_irq_base + SUNXI_IRQ_NMI_CTRL_REG);
> -
> -	sunxi_irq_domain = irq_domain_add_linear(node, 3 * 32,
> -						 &sunxi_irq_ops, NULL);
> -	if (!sunxi_irq_domain)
> -		panic("%s: unable to create IRQ domain\n", node->full_name);
> -
> -	set_handle_irq(sunxi_handle_irq);
> -
> -	return 0;
> -}
> -IRQCHIP_DECLARE(allwinner_sunxi_ic, "allwinner,sunxi-ic", sunxi_of_init);
> -
> -static asmlinkage void __exception_irq_entry sunxi_handle_irq(struct pt_regs *regs)
> -{
> -	u32 irq, hwirq;
> -
> -	hwirq = readl(sunxi_irq_base + SUNXI_IRQ_VECTOR_REG) >> 2;
> -	while (hwirq != 0) {
> -		irq = irq_find_mapping(sunxi_irq_domain, hwirq);
> -		handle_IRQ(irq, regs);
> -		hwirq = readl(sunxi_irq_base + SUNXI_IRQ_VECTOR_REG) >> 2;
> -	}
> -}
> 

