Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3JHNZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:25:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38301 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214Ab3JHNY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:24:59 -0400
Date: Tue, 8 Oct 2013 14:24:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] irqchip: add DesignWare APB ICTL interrupt
 controller
Message-ID: <20131008132421.GC1412@e106331-lin.cambridge.arm.com>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1381235073-17134-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381235073-17134-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 01:24:26PM +0100, Sebastian Hesselbarth wrote:
> This adds an irqchip driver and corresponding devicetree binding for the
> secondary interrupt controllers based on Synopsys DesignWare IP dw_apb_ictl.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> RFCv1->RFCv2:
> - added copyright reference
> 
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  .../interrupt-controller/snps,dw-apb-ictl.txt      |   29 ++++
>  drivers/irqchip/Kconfig                            |    4 +
>  drivers/irqchip/Makefile                           |    1 +
>  drivers/irqchip/irq-dw-apb-ictl.c                  |  142 ++++++++++++++++++++
>  4 files changed, 176 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
>  create mode 100644 drivers/irqchip/irq-dw-apb-ictl.c
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt b/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
> new file mode 100644
> index 0000000..7ccd1ba
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
> @@ -0,0 +1,29 @@
> +Synopsys DesignWare APB interrupt controller (dw_apb_ictl)
> +
> +Synopsys DesignWare provides interrupt controller IP for APB known as
> +dw_apb_ictl. The IP is used as secondary interrupt controller in some SoCs with
> +APB bus, e.g. Marvell Armada 1500.
> +
> +Required properties:
> +- compatible: shall be "snps,dw-apb-ictl"
> +- reg: base address of interrupt registers starting with ENABLE_LOW register

Is ENABLE_LOW the first register? Or are there registers before?

Is there only one bank of registers that needs to be defined?

This isn't just a base address, as it has a size too. The terminology's
rather inconsistent for reg properties in general...

> +- interrupt-controller: identifies the node as an interrupt controller
> +- #interrupt-cells: number of cells to encode an interrupt source, shall be 1

s/interrupt source/interrupt-specifier/

> +- interrupts: interrupt reference to primary interrupt controller

- interrupts: interrupts specifier for the sole interrupt fed to the
              parent interrupt controller.

Is there only a single output interrupt?

Is this required? Is it possible for this to be wired directly into a
CPU rather than another interrupt controller?

> +- interrupt-parent: (optional) reference specific primary interrupt controller
> +
> +The interrupt sources map to the corresponding bits in the interrupt
> +registers, i.e.
> +- 0 maps to bit 0 of low interrupts,
> +- 1 maps to bit 1 of low interrupts,
> +- 32 maps to bit 0 of high interrupts, and so on.

I couldn't see any public documentation for this, so I can't really
follow the "and so on", but I saw that this had optional FIQ support so
I assume there are more interrupt values that can be encoded?

> +
> +Example:
> +	aic: interrupt-controller@3000 {
> +		compatible = "snps,dw-apb-ictl";
> +		reg = <0x3000 0xc00>;
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
> +	};
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index 3792a1a..940638d 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -30,6 +30,10 @@ config ARM_VIC_NR
>  	  The maximum number of VICs available in the system, for
>  	  power management.
>  
> +config DW_APB_ICTL
> +	bool
> +	select IRQ_DOMAIN
> +
>  config IMGPDC_IRQ
>  	bool
>  	select GENERIC_IRQ_CHIP
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index c60b901..6427323 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -6,6 +6,7 @@ obj-$(CONFIG_ARCH_MMP)			+= irq-mmp.o
>  obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
>  obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
>  obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
> +obj-$(CONFIG_DW_APB_ICTL)		+= irq-dw-apb-ictl.o
>  obj-$(CONFIG_METAG)			+= irq-metag-ext.o
>  obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
>  obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
> diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
> new file mode 100644
> index 0000000..bbcacee
> --- /dev/null
> +++ b/drivers/irqchip/irq-dw-apb-ictl.c
> @@ -0,0 +1,142 @@
> +/*
> + * Synopsys DW APB ICTL irqchip driver.
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * based on GPL'ed 2.6 kernel sources
> + *  (c) Marvell International Ltd.
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/irqchip/chained_irq.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +
> +#include "irqchip.h"
> +
> +#define APB_INT_ENABLE_L	0x00
> +#define APB_INT_ENABLE_H	0x04
> +#define APB_INT_MASK_L		0x08
> +#define APB_INT_MASK_H		0x0c
> +#define APB_INT_FINALSTATUS_L	0x30
> +#define APB_INT_FINALSTATUS_H	0x34
> +
> +static void dw_apb_ictl_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct irq_chip *chip = irq_get_chip(irq);
> +	struct irq_chip_generic *gc = irq_get_handler_data(irq);
> +	struct irq_domain *d = gc->private;
> +	u32 stat;
> +	int n;
> +
> +	chained_irq_enter(chip, desc);
> +
> +	for (n = 0; n < gc->num_ct; n++) {
> +		stat = readl_relaxed(gc->reg_base +
> +				     APB_INT_FINALSTATUS_L + 4 * n);
> +		while (stat) {
> +			u32 hwirq = ffs(stat) - 1;
> +			generic_handle_irq(irq_find_mapping(d,
> +					    gc->irq_base + hwirq + 32 * n));
> +			stat &= ~(1 << hwirq);
> +		}
> +	}
> +
> +	chained_irq_exit(chip, desc);
> +}
> +
> +static int __init dw_apb_ictl_init(struct device_node *np,
> +				   struct device_node *parent)
> +{
> +	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
> +	struct resource r;
> +	struct irq_domain *domain;
> +	struct irq_chip_generic *gc;
> +	void __iomem *iobase;
> +	int ret, nrirqs, irq;
> +	u32 reg;
> +
> +	/* Map the parent interrupt for the chained handler */
> +	irq = irq_of_parse_and_map(np, 0);
> +	if (irq <= 0) {
> +		pr_err("%s: unable to parse irq\n", np->name);
> +		return -EINVAL;
> +	}
> +
> +	ret = of_address_to_resource(np, 0, &r);
> +	if (ret) {
> +		pr_err("%s: unable to get resource\n", np->name);
> +		return ret;
> +	}
> +
> +	if (!request_mem_region(r.start, resource_size(&r), np->name)) {
> +		pr_err("%s: unable to request mem region\n", np->name);
> +		return -ENOMEM;
> +	}
> +
> +	iobase = ioremap(r.start, resource_size(&r));
> +	if (!iobase) {
> +		pr_err("%s: unable to map resource\n", np->name);
> +		return -ENOMEM;
> +	}

Could you not use of_iomap?

Also, I'd recommend using np->full_name for error messages, as that
gives you the full path for the node, which is far more helpful for
debugging than just the unqualified node name.

> +
> +	/*
> +	 * DW IP can be configured to allow 2-64 irqs. We can determine
> +	 * the number of irqs supported by writing into enable register
> +	 * and look for bits not set, as corresponding flip-flops will
> +	 * have been removed by sythesis tool.
> +	 */

Is that always true?

Cheers,
Mark.
