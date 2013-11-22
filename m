Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3KVA2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:28:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:42101 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3KVA2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:28:19 -0500
Date: Fri, 22 Nov 2013 01:28:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] irqchip: versatile FPGA: support cascaded interrupts
 from DT
In-Reply-To: <1385074415-1264-1-git-send-email-linus.walleij@linaro.org>
Message-ID: <alpine.DEB.2.02.1311220127290.30673@ionos.tec.linutronix.de>
References: <1385074415-1264-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Nov 2013, Linus Walleij wrote:

> The Versatile FPGA interrupt controller supports cascading interrupts,
> i.e. that its output is connected to the input of another interrupt
> controller. This makes it possible to pass a parent interrupt from
> the device tree and print it in the boot log if applicable.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> TGLX: I can take this through ARM SoC if you're happy with it
> and prefer it that way, but it merges just as fine as it is on
> the IRQ tree.

Acked-by-me! Please ship it via ARM SoC

> ---
>  .../devicetree/bindings/arm/versatile-fpga-irq.txt        |  5 +++++
>  drivers/irqchip/irq-versatile-fpga.c                      | 15 +++++++++++++--
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/versatile-fpga-irq.txt b/Documentation/devicetree/bindings/arm/versatile-fpga-irq.txt
> index 9989eda755d9..c9cf605bb995 100644
> --- a/Documentation/devicetree/bindings/arm/versatile-fpga-irq.txt
> +++ b/Documentation/devicetree/bindings/arm/versatile-fpga-irq.txt
> @@ -29,3 +29,8 @@ pic: pic@14000000 {
>          clear-mask = <0xffffffff>;
>          valid-mask = <0x003fffff>;
>  };
> +
> +Optional properties:
> +- interrupts: if the FPGA IRQ controller is cascaded, i.e. if its IRQ
> +  output is simply connected to the input of another IRQ controller,
> +  then the parent IRQ shall be specified in this property.
> diff --git a/drivers/irqchip/irq-versatile-fpga.c b/drivers/irqchip/irq-versatile-fpga.c
> index 47a52ab580d8..3ae2bb8d9cf2 100644
> --- a/drivers/irqchip/irq-versatile-fpga.c
> +++ b/drivers/irqchip/irq-versatile-fpga.c
> @@ -9,6 +9,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/of_irq.h>
>  
>  #include <asm/exception.h>
>  #include <asm/mach/irq.h>
> @@ -167,8 +168,12 @@ void __init fpga_irq_init(void __iomem *base, const char *name, int irq_start,
>  			f->used_irqs++;
>  		}
>  
> -	pr_info("FPGA IRQ chip %d \"%s\" @ %p, %u irqs\n",
> +	pr_info("FPGA IRQ chip %d \"%s\" @ %p, %u irqs",
>  		fpga_irq_id, name, base, f->used_irqs);
> +	if (parent_irq != -1)
> +		pr_cont(", parent IRQ: %d\n", parent_irq);
> +	else
> +		pr_cont("\n");
>  
>  	fpga_irq_id++;
>  }
> @@ -180,6 +185,7 @@ int __init fpga_irq_of_init(struct device_node *node,
>  	void __iomem *base;
>  	u32 clear_mask;
>  	u32 valid_mask;
> +	int parent_irq;
>  
>  	if (WARN_ON(!node))
>  		return -ENODEV;
> @@ -193,7 +199,12 @@ int __init fpga_irq_of_init(struct device_node *node,
>  	if (of_property_read_u32(node, "valid-mask", &valid_mask))
>  		valid_mask = 0;
>  
> -	fpga_irq_init(base, node->name, 0, -1, valid_mask, node);
> +	/* Some chips are cascaded from a parent IRQ */
> +	parent_irq = irq_of_parse_and_map(node, 0);
> +	if (!parent_irq)
> +		parent_irq = -1;
> +
> +	fpga_irq_init(base, node->name, 0, parent_irq, valid_mask, node);
>  
>  	writel(clear_mask, base + IRQ_ENABLE_CLEAR);
>  	writel(clear_mask, base + FIQ_ENABLE_CLEAR);
> -- 
> 1.8.3.1
> 
> 
