Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaIYDNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:13:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:59700 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaIYDNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:13:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,594,1406617200"; 
   d="scan'208";a="608228337"
Message-ID: <54238837.7020508@linux.intel.com>
Date: Thu, 25 Sep 2014 11:12:55 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Joe.C" <srv_yingjoe.chen@mediatek.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        yingjoe.chen@gmail.com, hc.yen@mediatek.com, eddie.huang@mediatek.com,
        nathan.chung@mediatek.com, yh.chen@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH] [RFC] Using hierarchy irqdomian to implement MTK intpol.
References: <1411574696-1881-1-git-send-email-srv_yingjoe.chen@mediatek.com>
In-Reply-To: <1411574696-1881-1-git-send-email-srv_yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/9/25 0:04, Joe.C wrote:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
> 
> Here's the first draft of using hierarchy irqdomain to implement MTK intpol
> support. I have tested it and intpol works fine. Before continue, I'd like
> to get your comments. This is based on Jiang's hierarchy irqdomian [1] and
> my mediatek SoC basic support [2].
> 
> Simplified block diagram for interrupt:
> 
>     ---------      ---------
>  ---| CIRQ  |------|ARM GIC|
>  ---|       |------|       |
>  ---|       |------|       |
>  ---|       |------|       |
>  ---|       |------|       |
>     ---------      ---------
> 
> In device tree, interrupt-parent for other devices is cirq, child of gic.
> This describe HW better and allow device to specify polarity as it is sent
> by the device. I'm using interrupt-parent to specify irq domain parent in
> cirq now. Maybe adding another name like 'interrupt-domain-parent' will be
> better.
> 
> Currently only set_type is implement in CIRQ, but I think this could extended
> to cover all function gic_arch_extn provided.
> 
> In order to use hierarchy irq domain, gic can't use legacy irq domain anymore.
> If arm,hierarchy-irq-domain property is specified, GIC will work in hierarchy
> way and all interrupt must be set by device tree.
> 
> One thing worth mention is arg in irq_domain_alloc_irqs. On x86, msi is using
> struct irq_alloc_info, to pass data between irq domain. In irq_create_of_mapping(),
> of_phandle_args is used. All allocs in irq_domain chain will need to use same
> interrupt-cells formats.
> 
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/286542.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/284553.html
> 
> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> ---
>  arch/arm/boot/dts/mt8135.dtsi     |  14 +++-
>  drivers/irqchip/Makefile          |   1 +
>  drivers/irqchip/irq-gic.c         |  53 +++++++++++--
>  drivers/irqchip/irq-mt65xx-cirq.c | 158 ++++++++++++++++++++++++++++++++++++++
>  include/linux/irq.h               |   5 ++
>  kernel/irq/chip.c                 |  28 +++++++
>  kernel/irq/irqdomain.c            |  14 ++--
>  7 files changed, 256 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/irqchip/irq-mt65xx-cirq.c
> 
> diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
> index 90a56ad..e19ab1a 100644
> --- a/arch/arm/boot/dts/mt8135.dtsi
> +++ b/arch/arm/boot/dts/mt8135.dtsi
> @@ -18,7 +18,7 @@
>  
>  / {
>  	compatible = "mediatek,mt8135";
> -	interrupt-parent = <&gic>;
> +	interrupt-parent = <&cirq>;
>  
>  	cpu-map {
>  		cluster0 {
> @@ -97,15 +97,25 @@
>  		timer: timer@10008000 {
>  			compatible = "mediatek,mt8135-timer", "mediatek,mt6577-timer";
>  			reg = <0 0x10008000 0 0x80>;
> -			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
>  			clocks = <&system_clk>, <&rtc_clk>;
>  			clock-names = "system-clk", "rtc-clk";
>  		};
>  
> +		cirq: interrupt-controller@10200030 {
> +			compatible = "mediatek,mt8135-cirq", "mediatek,mt6577-cirq";
> +			interrupt-controller;
> +			#interrupt-cells = <3>;
> +			interrupt-parent = <&gic>;
> +			reg = <0 0x10200030 0 0x1c>;
> +		};
> +
>  		gic: interrupt-controller@10211000 {
>  			compatible = "arm,cortex-a15-gic";
>  			interrupt-controller;
>  			#interrupt-cells = <3>;
> +			arm,hierarchy-irq-domain;
> +			interrupt-parent = <&gic>;
>  			reg = <0 0x10211000 0 0x1000>,
>  			      <0 0x10212000 0 0x1000>,
>  			      <0 0x10214000 0 0x2000>,
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 73052ba..0b34675 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -34,3 +34,4 @@ obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
>  obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
>  obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
>  obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
> +obj-$(CONFIG_ARCH_MEDIATEK)		+= irq-mt65xx-cirq.o
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 4b959e6..d66d707 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -767,22 +767,50 @@ void __init gic_init_physaddr(struct device_node *node)
>  static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
>  				irq_hw_number_t hw)
>  {
> +	irq_domain_set_hwirq_and_chip(d, irq, hw, &gic_chip, d->host_data);
Hi Joe,
	Seems you missed the change to enable Kconfig option
CONFIG_IRQ_DOMAIN_HIERARCHY. If CONFIG_IRQ_DOMAIN_HIERARCHY
may be off under certain conditions, above code may cause
building failure.
Regards!
Gerry

>  	if (hw < 32) {
>  		irq_set_percpu_devid(irq);
> -		irq_set_chip_and_handler(irq, &gic_chip,
> -					 handle_percpu_devid_irq);
> +		irq_set_handler(irq, handle_percpu_devid_irq);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
>  	} else {
> -		irq_set_chip_and_handler(irq, &gic_chip,
> -					 handle_fasteoi_irq);
> +		irq_set_handler(irq, handle_fasteoi_irq);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>  
>  		gic_routable_irq_domain_ops->map(d, irq, hw);
>  	}
> -	irq_set_chip_data(irq, d->host_data);
>  	return 0;
>  }
>  
> +static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +				unsigned int nr_irqs, void *arg)
> +{
> +	int i, ret;
> +	irq_hw_number_t hwirq;
> +	unsigned int type = IRQ_TYPE_NONE;
> +	struct of_phandle_args *irq_data = arg;
> +
> +	ret = domain->ops->xlate(domain, irq_data->np, irq_data->args,
> +				 irq_data->args_count, &hwirq, &type);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < nr_irqs; i++)
> +		gic_irq_domain_map(domain, virq+i, hwirq+i);
> +
> +	return 0;
> +}
> +
> +static void gic_irq_domain_free(struct irq_domain *domain, unsigned int virq,
> +				unsigned int nr_irqs)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		irq_set_handler(virq + i, NULL);
> +		irq_domain_set_hwirq_and_chip(domain, virq + i, 0, NULL, NULL);
> +	}
> +}
> +
>  static void gic_irq_domain_unmap(struct irq_domain *d, unsigned int irq)
>  {
>  	gic_routable_irq_domain_ops->unmap(d, irq);
> @@ -795,8 +823,6 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
>  {
>  	unsigned long ret = 0;
>  
> -	if (d->of_node != controller)
> -		return -EINVAL;
>  	if (intsize < 3)
>  		return -EINVAL;
>  
> @@ -839,6 +865,14 @@ static struct notifier_block gic_cpu_notifier = {
>  };
>  #endif
>  
> +static const struct irq_domain_ops gic_irq_domain_hierarchy_ops = {
> +	.alloc = gic_irq_domain_alloc,
> +	.free = gic_irq_domain_free,
> +	.map = gic_irq_domain_map,
> +	.unmap = gic_irq_domain_unmap,
> +	.xlate = gic_irq_domain_xlate,
> +};
> +
>  static const struct irq_domain_ops gic_irq_domain_ops = {
>  	.map = gic_irq_domain_map,
>  	.unmap = gic_irq_domain_unmap,
> @@ -952,7 +986,10 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  
>  	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
>  
> -	if (of_property_read_u32(node, "arm,routable-irqs",
> +	if (of_find_property(node, "arm,hierarchy-irq-domain", NULL))
> +		gic->domain = irq_domain_add_linear(node, gic_irqs,
> +					&gic_irq_domain_hierarchy_ops, gic);
> +	else if (of_property_read_u32(node, "arm,routable-irqs",
>  				 &nr_routable_irqs)) {
>  		irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
>  					   numa_node_id());
> diff --git a/drivers/irqchip/irq-mt65xx-cirq.c b/drivers/irqchip/irq-mt65xx-cirq.c
> new file mode 100644
> index 0000000..1243a7f
> --- /dev/null
> +++ b/drivers/irqchip/irq-mt65xx-cirq.c
> @@ -0,0 +1,158 @@
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
> +#define MT6577_SYS_CIRQ_NUM	(168)
> +
> +struct mt_cirq_chip_data {
> +	spinlock_t lock;
> +	void __iomem *intpol_base;
> +};
> +
> +
> +static int mt_cirq_set_type(struct irq_data *data, unsigned int type)
> +{
> +	irq_hw_number_t hwirq = data->hwirq;
> +	struct mt_cirq_chip_data *chip_data = data->chip_data;
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
> +		type = (type == IRQ_TYPE_LEVEL_LOW) ?
> +			IRQ_TYPE_LEVEL_HIGH : IRQ_TYPE_EDGE_RISING;
> +		value |= (1 << offset);
> +	} else
> +		value &= ~(1 << offset);
> +	writel(value, chip_data->intpol_base + reg_index * 4);
> +
> +	data = data->parent_data;
> +	ret = data->chip->irq_set_type(data, type);
> +	spin_unlock_irqrestore(&chip_data->lock, flags);
> +	return ret;
> +}
> +
> +static struct irq_chip mt_cirq_chip = {
> +	.name			= "MT_CIRQ",
> +	.irq_mask		= irq_chip_mask_parent,
> +	.irq_unmask		= irq_chip_unmask_parent,
> +	.irq_eoi		= irq_chip_eoi_parent,
> +	.irq_set_type		= mt_cirq_set_type,
> +	.irq_retrigger		= irq_chip_retrigger_hierarchy,
> +	.irq_set_affinity	= irq_chip_set_affinity_parent,
> +};
> +
> +static int mt_cirq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +				unsigned int nr_irqs, void *arg)
> +{
> +	int i, ret;
> +	irq_hw_number_t hwirq;
> +	struct of_phandle_args *irq_data = arg;
> +
> +	if (irq_data->args_count != 3)
> +		return -EINVAL;
> +
> +	hwirq = irq_data->args[1];
> +	if (irq_find_mapping(domain, hwirq) > 0)
> +		return -EEXIST;
> +
> +	for (i = 0; i < nr_irqs; i++)
> +		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
> +					      &mt_cirq_chip, domain->host_data);
> +
> +	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static void mt_cirq_domain_free(struct irq_domain *domain, unsigned int virq,
> +				unsigned int nr_irqs)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		irq_set_handler(virq + i, NULL);
> +		irq_domain_set_hwirq_and_chip(domain, virq + i, 0, NULL, NULL);
> +	}
> +	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
> +}
> +
> +static int mt_cirq_domain_xlate(struct irq_domain *d,
> +				struct device_node *controller,
> +				const u32 *intspec, unsigned int intsize,
> +				unsigned long *out_hwirq,
> +				unsigned int *out_type)
> +{
> +	return d->parent->ops->xlate(d->parent, controller, intspec, intsize,
> +					out_hwirq, out_type);
> +}
> +
> +static struct irq_domain_ops cirq_domain_ops = {
> +	.alloc = mt_cirq_domain_alloc,
> +	.free = mt_cirq_domain_free,
> +	.xlate = mt_cirq_domain_xlate,
> +};
I'm trying to make change to irq_create_of_mapping() in next version,
which will affect you patch in two aspects:
1) no need to implement mt_cirq_domain_xlate。
2）OF hierarchy irqdomain callbacks need to implement following logic:
        if (type != IRQ_TYPE_NONE &&
            type != irq_get_trigger_type(virq))
                irq_set_irq_type(virq, type);

Regards!
Gerry
> +
> +static int __init mtk_cirq_of_init(struct device_node *node,
> +				   struct device_node *parent)
> +{
> +	struct device_node *parent_node;
> +	struct irq_domain *domain, *domain_parent = NULL;
> +	struct mt_cirq_chip_data *chip_data;
> +	int ret = 0;
> +
> +	parent_node = of_irq_find_parent(node);
> +	if (parent_node) {
> +		domain_parent = irq_find_host(parent_node);
> +		of_node_put(parent_node);
> +	}
> +
> +	if (!domain_parent) {
> +		pr_err("mtk_cirq: interrupt-parent not found\n");
> +		return -EINVAL;
> +	}
> +
> +	chip_data = kzalloc(sizeof(*chip_data), GFP_KERNEL);
> +	if (!chip_data)
> +		return -ENOMEM;
> +
> +	chip_data->intpol_base = of_io_request_and_map(node, 0, "intpol");
> +	if (!chip_data->intpol_base) {
> +		pr_err("mtk_cirq: unable to map cirq register\n");
> +		ret = -ENOMEM;
> +		goto out_free;
> +	}
> +
> +	domain = irq_domain_add_linear(node, MT6577_SYS_CIRQ_NUM,
> +				&cirq_domain_ops, chip_data);
> +	if (!domain) {
> +		ret = -ENOMEM;
> +		goto out_unmap;
> +	}
> +	domain->parent = domain_parent;
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
> +IRQCHIP_DECLARE(mtk_cirq, "mediatek,mt6577-cirq", mtk_cirq_of_init);
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index bfa027f..a877b88 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -435,6 +435,11 @@ extern void handle_nested_irq(unsigned int irq);
>  
>  #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>  extern void irq_chip_ack_parent(struct irq_data *data);
> +extern void irq_chip_mask_parent(struct irq_data *data);
> +extern void irq_chip_unmask_parent(struct irq_data *data);
> +extern void irq_chip_eoi_parent(struct irq_data *data);
> +extern int irq_chip_set_affinity_parent(struct irq_data *data,
> +				const struct cpumask *dest, bool force);
>  extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
>  #endif
>  
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index b8ee27e..da3042b 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -830,6 +830,34 @@ void irq_chip_ack_parent(struct irq_data *data)
>  		data->chip->irq_ack(data);
>  }
>  
> +void irq_chip_mask_parent(struct irq_data *data)
> +{
> +	data = data->parent_data;
> +	data->chip->irq_mask(data);
> +}
> +
> +void irq_chip_unmask_parent(struct irq_data *data)
> +{
> +	data = data->parent_data;
> +	data->chip->irq_unmask(data);
> +}
> +
> +void irq_chip_eoi_parent(struct irq_data *data)
> +{
> +	data = data->parent_data;
> +	data->chip->irq_eoi(data);
> +}
> +
> +int irq_chip_set_affinity_parent(struct irq_data *data,
> +				 const struct cpumask *dest, bool force)
> +{
> +	data = data->parent_data;
> +	if (data->chip->irq_set_affinity)
> +		return data->chip->irq_set_affinity(data, dest, force);
> +
> +	return -ENOSYS;
> +}
> +
>  int irq_chip_retrigger_hierarchy(struct irq_data *data)
>  {
>  	for (data = data->parent_data; data; data = data->parent_data)
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index e285f3a..01e852b 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -467,7 +467,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>  	struct irq_domain *domain;
>  	irq_hw_number_t hwirq;
>  	unsigned int type = IRQ_TYPE_NONE;
> -	unsigned int virq;
> +	int virq;
>  
>  	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
>  	if (!domain) {
> @@ -493,8 +493,8 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>  	else
>  #endif
>  		virq = irq_create_mapping(domain, hwirq);
> -	if (!virq)
> -		return virq;
> +	if (virq <= 0)
> +		return 0;
>  
>  	/* Set type if specified and different than the current one */
>  	if (type != IRQ_TYPE_NONE &&
> @@ -716,20 +716,20 @@ const struct irq_domain_ops irq_domain_simple_ops = {
>  };
>  EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
>  
> -static int irq_domain_alloc_descs(int virq, unsigned int nr_irqs,
> +static int irq_domain_alloc_descs(int virq, unsigned int cnt,
>  				  irq_hw_number_t hwirq, int node)
>  {
>  	unsigned int hint;
>  
>  	if (virq >= 0) {
> -		virq = irq_alloc_descs(virq, virq, nr_irqs, node);
> +		virq = irq_alloc_descs(virq, virq, cnt, node);
>  	} else {
>  		hint = hwirq % nr_irqs;
>  		if (hint == 0)
>  			hint++;
> -		virq = irq_alloc_descs_from(hint, nr_irqs, node);
> +		virq = irq_alloc_descs_from(hint, cnt, node);
>  		if (virq <= 0 && hint > 1)
> -			virq = irq_alloc_descs_from(1, nr_irqs, node);
> +			virq = irq_alloc_descs_from(1, cnt, node);
>  	}
>  
>  	return virq;
> 
