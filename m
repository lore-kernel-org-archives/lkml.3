Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3FXNSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:18:41 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55679 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3FXNSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:18:38 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] irqchip: add support for MOXA ART SoCs
To: Jonas Jensen <jonas.jensen@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de,
        Jonas Jensen <jonas.jensen@gmail.com>
In-Reply-To: <1371718732-12680-1-git-send-email-jonas.jensen@gmail.com>
References: <20130618154104.7f8115c7@skate> <1371718732-12680-1-git-send-email-jonas.jensen@gmail.com>
Date: Mon, 24 Jun 2013 14:18:33 +0100
Message-Id: <20130624131833.DA9D33E0A89@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013 10:58:52 +0200, Jonas Jensen <jonas.jensen@gmail.com> wrote:
> This patch adds an irqchip driver for the main interrupt controller found
> on MOXA ART SoCs.
> 
> v2:
> * use irq_chip_generic
> * remove macro duplicates
> 
> Applies to next-20130619
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
>  drivers/irqchip/Makefile     |    1 +
>  drivers/irqchip/irq-moxart.c |  109 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 110 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/irqchip/irq-moxart.c
> 
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index cda4cb5..956d129 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -16,3 +16,4 @@ obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
>  obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
>  obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
>  obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
> +obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
> diff --git a/drivers/irqchip/irq-moxart.c b/drivers/irqchip/irq-moxart.c
> new file mode 100644
> index 0000000..25c0ff7
> --- /dev/null
> +++ b/drivers/irqchip/irq-moxart.c
> @@ -0,0 +1,109 @@
> +/*
> + * MOXA ART SoCs IRQ chip driver.
> + *
> + * Copyright (C) 2013 Jonas Jensen
> + *
> + * Jonas Jensen <jonas.jensen@gmail.com>
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
> +#include <linux/irqdomain.h>
> +
> +#include <asm/exception.h>
> +
> +#include "irqchip.h"
> +
> +#define IRQ_SOURCE_REG      0
> +#define IRQ_MASK_REG        0x04
> +#define IRQ_CLEAR_REG       0x08
> +#define IRQ_MODE_REG        0x0c
> +#define IRQ_LEVEL_REG       0x10
> +#define IRQ_STATUS_REG      0x14
> +
> +#define FIQ_SOURCE_REG      0x20
> +#define FIQ_MASK_REG        0x24
> +#define FIQ_CLEAR_REG       0x28
> +#define FIQ_MODE_REG        0x2c
> +#define FIQ_LEVEL_REG       0x30
> +#define FIQ_STATUS_REG      0x34
> +
> +static void __iomem *moxart_irq_base;
> +static struct irq_domain *moxart_irq_domain;
> +static unsigned int interrupt_mask;
> +
> +asmlinkage void __exception_irq_entry moxart_handle_irq(struct pt_regs *regs)
> +{
> +	u32 irqstat;
> +	int hwirq;
> +
> +	irqstat = readl(moxart_irq_base + IRQ_STATUS_REG);
> +
> +	while (irqstat) {
> +		hwirq = ffs(irqstat) - 1;
> +		handle_IRQ(irq_find_mapping(moxart_irq_domain, hwirq), regs);
> +		irqstat &= ~(1 << hwirq);
> +	}
> +}
> +
> +static __init void moxart_alloc_gc(void __iomem *base,
> +	unsigned int irq_start, unsigned int num)
> +{
> +	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
> +	int ret;
> +	struct irq_chip_generic *gc;
> +
> +	ret = irq_alloc_domain_generic_chips(moxart_irq_domain, 32, 1,
> +		"MOXARTINTC", handle_edge_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
> +
> +	if (ret)
> +		pr_err("%s: could not alloc generic chip\n", __func__);

If this failure point is hit, the code following it will segfault. Need
to bail at this point.

> +
> +	gc = irq_get_domain_generic_chip(moxart_irq_domain, 0);
> +
> +	gc->reg_base = base;
> +	gc->chip_types[0].regs.mask = IRQ_MASK_REG;
> +	gc->chip_types[0].regs.ack = IRQ_CLEAR_REG;
> +	gc->chip_types[0].chip.irq_ack = irq_gc_ack_set_bit;
> +	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
> +	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
> +}

Why is this split into a separate function? There really isn't any need
to.

> +
> +static int __init moxart_of_init(struct device_node *node,
> +	struct device_node *parent)
> +{
> +	interrupt_mask = be32_to_cpup(of_get_property(node,
> +		"interrupt-mask", NULL));
> +	pr_debug("%s: interrupt-mask=%x\n", node->full_name, interrupt_mask);
> +
> +	moxart_irq_base = of_iomap(node, 0);
> +	if (!moxart_irq_base)
> +		panic("%s: unable to map INTC CPU registers\n",
> +			node->full_name);

Is in necessary to panic here? Often even if the interrupt controller
setup fails, it is valueable to print an error, exit gracefully and let
the kernel try to continue. There is a greater chance of getting some
form output useful for debug that way.

> +
> +	moxart_irq_domain = irq_domain_add_linear(node,
> +		32, &irq_generic_chip_ops, moxart_irq_base);
> +
> +	moxart_alloc_gc(moxart_irq_base, 0, 32);
> +
> +	writel(0, moxart_irq_base + IRQ_MASK_REG);
> +	writel(0xffffffff, moxart_irq_base + IRQ_CLEAR_REG);
> +
> +	writel(interrupt_mask, moxart_irq_base + IRQ_MODE_REG);
> +	writel(interrupt_mask, moxart_irq_base + IRQ_LEVEL_REG);
> +
> +	set_handle_irq(moxart_handle_irq);
> +
> +	pr_info("%s: %s finished\n", node->full_name, __func__);
> +
> +	return 0;
> +}
> +IRQCHIP_DECLARE(moxa_moxart_ic, "moxa,moxart-interrupt-controller",
> +	moxart_of_init);
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
email sent from notmuch.vim plugin
