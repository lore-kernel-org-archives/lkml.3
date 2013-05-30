Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab3E3VUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:20:01 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:55210 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665Ab3E3VTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:19:53 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2] irqchip: Add TB10x interrupt controller driver
To: Christian Ruppert <christian.ruppert@abilis.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
In-Reply-To: <1369758847-5642-1-git-send-email-christian.ruppert@abilis.com>
References: <alpine.LFD.2.02.1305271414270.4220@ionos> <1369758847-5642-1-git-send-email-christian.ruppert@abilis.com>
Date: Thu, 30 May 2013 22:19:43 +0100
Message-Id: <20130530211944.05F4D3E0A90@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013 18:34:07 +0200, Christian Ruppert <christian.ruppert@abilis.com> wrote:
> The SOC interrupt controller driver for the Abilis Systems TB10x series of
> SOCs based on ARC700 CPUs.
> 
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> ---
>  .../interrupt-controller/abilis,tb10x_ictl.txt     |   38 ++++
>  arch/arc/boot/dts/abilis_tb100.dtsi                |   32 ++--
>  arch/arc/boot/dts/abilis_tb101.dtsi                |   32 ++--
>  arch/arc/boot/dts/abilis_tb10x.dtsi                |   30 ++--
>  arch/arc/plat-tb10x/Kconfig                        |    1 +
>  drivers/irqchip/Kconfig                            |    5 +
>  drivers/irqchip/Makefile                           |    1 +
>  drivers/irqchip/irq-tb10x.c                        |  205 ++++++++++++++++++++
>  8 files changed, 291 insertions(+), 53 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt
>  create mode 100644 drivers/irqchip/irq-tb10x.c
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt
> new file mode 100644
> index 0000000..bc292cd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt
> @@ -0,0 +1,38 @@
> +TB10x Top Level Interrupt Controller
> +====================================
> +
> +The Abilis TB10x SOC contains a custom interrupt controller. It performs
> +one-to-one mapping of external interrupt sources to CPU interrupts and
> +provides support for reconfigurable trigger modes.
> +
> +Required properties
> +-------------------
> +
> +- compatible: Should be "abilis,tb10x_ictl"

Use '-' instead of underscore for compatible values. Otherwise the
binding looks fine.

> +- reg: specifies physical base address and size of register range.
> +- interrupt-congroller: Identifies the node as an interrupt controller.
> +- #interrupt cells: Specifies the number of cells used to encode an interrupt
> +  source connected to this controller. The value shall be 2.
> +- interrupt-parent: Specifies the parent interrupt controller.
> +- interrupts: Specifies the list of interrupt lines which are handled by
> +  the interrupt controller in the parent controller's notation. Interrupts
> +  are mapped one-to-one to parent interrupts.
> +
> +Example
> +-------
> +
> +intc: interrupt-controller {	/* Parent interrupt controller */
> +	interrupt-controller;
> +	#interrupt-cells = <1>;	/* For example below */
> +	/* ... */
> +};
> +
> +tb10x_ictl: pic@2000 {		/* TB10x interrupt controller */
> +	compatible = "abilis,tb10x_ictl";
> +	reg = <0x2000 0x20>;
> +	interrupt-controller;
> +	#interrupt-cells = <2>;
> +	interrupt-parent = <&intc>;
> +	interrupts = <5 6 7 8 9 10 11 12 13 14 15 16 17 18 19
> +			20 21 22 23 24 25 26 27 28 29 30 31>;
> +};

[...]
> +#define AB_IRQCTL_MAXIRQ       32
> +#define TB10X_IRQCHIP_BASE     NR_CPU_IRQS
> +
> +static inline void ab_irqctl_writereg(struct irq_chip_generic *gc, u32 reg,
> +	u32 val)
> +{
> +	irq_reg_writel(val, (u32 *)(gc->reg_base + reg));

In most cases, if you have to use a cast, then the code is unsafe.
->reg_base is a void*, so the cast should be unnecessary.

> +}
> +
> +static inline u32 ab_irqctl_readreg(struct irq_chip_generic *gc, u32 reg)
> +{
> +	return irq_reg_readl((u32 *)(gc->reg_base + reg));
> +}
> +
> +static int tb10x_irq_set_type(struct irq_data *data, unsigned int flow_type)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
> +	unsigned int irq = data->irq;

irq is used exactly once for a debug pr_err(). I'd drop it from here.

> +	unsigned int hwirq = irqd_to_hwirq(data);
> +	uint32_t im, mod, pol;
> +
> +	im = BIT(hwirq);

data->mask should work here with Thomas' branch (see below)

> +
> +	irq_gc_lock(gc);
> +
> +	mod = ab_irqctl_readreg(gc, AB_IRQCTL_SRC_MODE) | im;
> +	pol = ab_irqctl_readreg(gc, AB_IRQCTL_SRC_POLARITY) | im;
> +
> +	switch (flow_type & IRQF_TRIGGER_MASK) {
> +	case IRQ_TYPE_EDGE_FALLING:
> +		pol ^= im;
> +		break;
> +	case IRQ_TYPE_LEVEL_HIGH:
> +		mod ^= im;
> +		break;
> +	case IRQ_TYPE_NONE:
> +		flow_type = IRQ_TYPE_LEVEL_LOW;
> +	case IRQ_TYPE_LEVEL_LOW:
> +		mod ^= im;
> +		pol ^= im;
> +		break;
> +	case IRQ_TYPE_EDGE_RISING:
> +		break;
> +	default:
> +		irq_gc_unlock(gc);
> +		pr_err("%s: Cannot assign multiple trigger modes to IRQ %d.\n",
> +			__func__, irq);
> +		return -EBADR;
> +	}
> +
> +	irqd_set_trigger_type(data, flow_type);
> +	irq_setup_alt_chip(data, flow_type);
> +
> +	ab_irqctl_writereg(gc, AB_IRQCTL_SRC_MODE, mod);
> +	ab_irqctl_writereg(gc, AB_IRQCTL_SRC_POLARITY, pol);
> +	ab_irqctl_writereg(gc, AB_IRQCTL_INT_STATUS, im);
> +
> +	irq_gc_unlock(gc);
> +
> +	return IRQ_SET_MASK_OK;
> +}
> +
> +static struct irq_domain_ops irq_tb10x_domain_ops = {
> +	.xlate	= irq_domain_xlate_twocell,
> +};
> +
> +static void tb10x_irq_cascade(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct irq_domain *domain = irq_desc_get_handler_data(desc);
> +
> +	generic_handle_irq(irq_find_mapping(domain, irq));
> +}
> +
> +static int __init of_tb10x_init_irq(struct device_node *ictl,
> +					struct device_node *parent)
> +{
> +	int i, ret, nrirqs = of_irq_count(ictl);
> +	u32 mask = 0;
> +	struct resource mem;
> +	struct irq_chip_generic *gc;
> +	struct irq_domain *domain;
> +	void __iomem *reg_base;
> +
> +	if (of_address_to_resource(ictl, 0, &mem)) {
> +		pr_err("%s: No registers declared in DeviceTree.\n",
> +			ictl->name);
> +		return -EINVAL;
> +	}
> +
> +	if (!request_mem_region(mem.start, resource_size(&mem),
> +		ictl->name)) {
> +		pr_err("%s: Request mem region failed.\n", ictl->name);
> +		return -EBUSY;
> +	}
> +
> +	reg_base = ioremap(mem.start, resource_size(&mem));
> +	if (!reg_base) {
> +		ret = -EBUSY;
> +		pr_err("%s: ioremap failed.\n", ictl->name);
> +		goto ioremap_fail;
> +	}
> +
> +	gc = irq_alloc_generic_chip(ictl->name, 2, TB10X_IRQCHIP_BASE,
> +				reg_base, handle_level_irq);
> +	if (!gc) {
> +		ret = -ENOMEM;
> +		pr_err("%s: Could not allocate generic interrupt chip.\n",
> +			ictl->name);
> +		goto gc_alloc_fail;
> +	}

Thomas has merged patches to add irq_alloc_domain_generic_chips() which
you should be using here. It takes care of linking the generic chip into
the irq domain. You can find the patches in the irq/for-arm branch of
the tip tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

> +
> +	gc->chip_types[0].type               = IRQ_TYPE_LEVEL_MASK;
> +	gc->chip_types[0].chip.irq_mask      = irq_gc_mask_clr_bit;
> +	gc->chip_types[0].chip.irq_unmask    = irq_gc_mask_set_bit;
> +	gc->chip_types[0].chip.irq_set_type  = tb10x_irq_set_type;
> +	gc->chip_types[0].regs.mask          = AB_IRQCTL_INT_ENABLE;
> +
> +	gc->chip_types[1].type               = IRQ_TYPE_EDGE_BOTH;
> +	gc->chip_types[1].chip.name          = gc->chip_types[0].chip.name;
> +	gc->chip_types[1].chip.irq_ack       = irq_gc_ack_set_bit;
> +	gc->chip_types[1].chip.irq_mask      = irq_gc_mask_clr_bit;
> +	gc->chip_types[1].chip.irq_unmask    = irq_gc_mask_set_bit;
> +	gc->chip_types[1].chip.irq_set_type  = tb10x_irq_set_type;
> +	gc->chip_types[1].regs.ack           = AB_IRQCTL_INT_STATUS;
> +	gc->chip_types[1].regs.mask          = AB_IRQCTL_INT_ENABLE;
> +	gc->chip_types[1].handler            = handle_edge_irq;
> +
> +	domain = irq_domain_add_legacy(ictl, AB_IRQCTL_MAXIRQ,
> +					TB10X_IRQCHIP_BASE, 0,
> +					&irq_tb10x_domain_ops, gc);
> +	if (!domain) {
> +		ret = -ENOMEM;
> +		pr_err("%s: Could not register interrupt domain.\n",
> +			ictl->name);
> +		goto irq_domain_add_fail;
> +	}
> +
> +	for (i = 0; i < nrirqs; i++) {
> +		unsigned int irq = irq_of_parse_and_map(ictl, i);
> +
> +		irq_set_handler_data(irq, domain);
> +		irq_set_chained_handler(irq, tb10x_irq_cascade);
> +
> +		mask |= BIT(of_irq_to_resource(ictl, i, NULL));
> +	}
> +
> +	ab_irqctl_writereg(gc, AB_IRQCTL_INT_ENABLE, 0);
> +	ab_irqctl_writereg(gc, AB_IRQCTL_INT_MODE, 0);
> +	ab_irqctl_writereg(gc, AB_IRQCTL_INT_POLARITY, 0);
> +	ab_irqctl_writereg(gc, AB_IRQCTL_INT_STATUS, ~0UL);
> +
> +	irq_setup_generic_chip(gc, mask, IRQ_GC_INIT_MASK_CACHE,
> +				IRQ_NOREQUEST, IRQ_NOPROBE);
> +
> +	return 0;
> +
> +irq_domain_add_fail:
> +	kfree(gc);
> +gc_alloc_fail:
> +	iounmap(gc->reg_base);
> +ioremap_fail:
> +	release_mem_region(mem.start, resource_size(&mem));
> +	return ret;
> +}
> +IRQCHIP_DECLARE(tb10x_intc, "abilis,tb10x_ictl", of_tb10x_init_irq);
> -- 
> 1.7.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
