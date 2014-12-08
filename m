Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaLHDaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 22:30:30 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:18165 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaLHDa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 22:30:29 -0500
Message-ID: <54851ACF.2090204@huawei.com>
Date: Mon, 8 Dec 2014 11:28:15 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Jiang Liu" <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Yingjoe Chen" <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        "Catalin marinas" <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>
Subject: Re: [PATCH v3 09/13] irqchip: GICv3: ITS: MSI support
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com> <1416839720-18400-10-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1416839720-18400-10-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.54851ADC.00C8,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: fdefe6a806029858be07bed4493dd002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,
On 2014/11/24 22:35, Marc Zyngier wrote:

> Now, the bit of code that allow us to use the ITS as a MSI controller.
> Both MSI and MSI-X are supported.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   | 176 +++++++++++++++++++++++++++++++++++++
>  include/linux/irqchip/arm-gic-v3.h |   6 ++
>  2 files changed, 182 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index d687fd4..532c6df 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -587,12 +587,47 @@ static int its_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
>  	return IRQ_SET_MASK_OK_DONE;
>  }
>  
> +static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
> +{
> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +	struct its_node *its;
> +	u64 addr;
> +
> +	its = its_dev->its;
> +	addr = its->phys_base + GITS_TRANSLATER;
> +
> +	msg->address_lo		= addr & ((1UL << 32) - 1);
> +	msg->address_hi		= addr >> 32;
> +	msg->data		= its_get_event_id(d);
> +}
> +
>  static struct irq_chip its_irq_chip = {
>  	.name			= "ITS",
>  	.irq_mask		= its_mask_irq,
>  	.irq_unmask		= its_unmask_irq,
>  	.irq_eoi		= its_eoi_irq,
>  	.irq_set_affinity	= its_set_affinity,
> +	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
> +};
> +
> +static void its_mask_msi_irq(struct irq_data *d)
> +{
> +	pci_msi_mask_irq(d);
> +	irq_chip_mask_parent(d);
> +}
> +
> +static void its_unmask_msi_irq(struct irq_data *d)
> +{
> +	pci_msi_unmask_irq(d);
> +	irq_chip_unmask_parent(d);
> +}
> +
> +static struct irq_chip its_msi_irq_chip = {
> +	.name			= "ITS-MSI",
> +	.irq_unmask		= its_unmask_msi_irq,
> +	.irq_mask		= its_mask_msi_irq,
> +	.irq_eoi		= irq_chip_eoi_parent,
> +	.irq_write_msi_msg	= pci_msi_domain_write_msg,
>  };
>  
>  /*
> @@ -1055,3 +1090,144 @@ static void its_free_device(struct its_device *its_dev)
>  	kfree(its_dev->itt);
>  	kfree(its_dev);
>  }
> +
> +static int its_alloc_device_irq(struct its_device *dev, irq_hw_number_t *hwirq)
> +{
> +	int idx;
> +
> +	idx = find_first_zero_bit(dev->lpi_map, dev->nr_lpis);
> +	if (idx == dev->nr_lpis)
> +		return -ENOSPC;
> +
> +	*hwirq = dev->lpi_base + idx;
> +	set_bit(idx, dev->lpi_map);
> +
> +	/* Map the GIC irq ID to the device */
> +	its_send_mapvi(dev, *hwirq, idx);

It would be better if we do hardware-level initialization in domain.{activate,deactivate}.

> +
> +	return 0;
> +}
> +
> +static int its_msi_prepare(struct irq_domain *domain, struct device *dev,
> +			   int nvec, msi_alloc_info_t *info)
> +{
> +	struct pci_dev *pdev;
> +	struct its_node *its;
> +	u32 dev_id;
> +	struct its_device *its_dev;
> +
> +	if (!dev_is_pci(dev))
> +		return -EINVAL;
> +
> +	pdev = to_pci_dev(dev);
> +	dev_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
> +	its = domain->parent->host_data;
> +
> +	its_dev = its_find_device(its, dev_id);
> +	if (WARN_ON(its_dev))
> +		return -EINVAL;
> +
> +	its_dev = its_create_device(its, dev_id, nvec);
> +	if (!its_dev)
> +		return -ENOMEM;
> +
> +	dev_dbg(&pdev->dev, "ITT %d entries, %d bits\n", nvec, ilog2(nvec));
> +
> +	info->scratchpad[0].ptr = its_dev;
> +	info->scratchpad[1].ptr = dev;
> +	return 0;
> +}
> +
> +static struct msi_domain_ops its_pci_msi_ops = {
> +	.msi_prepare	= its_msi_prepare,
> +};
> +
> +static struct msi_domain_info its_pci_msi_domain_info = {
> +	.flags	= (MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
> +		   MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX),
> +	.ops	= &its_pci_msi_ops,
> +	.chip	= &its_msi_irq_chip,
> +};
> +
> +static int its_irq_gic_domain_alloc(struct irq_domain *domain,
> +				    unsigned int virq,
> +				    irq_hw_number_t hwirq)
> +{
> +	struct of_phandle_args args;
> +
> +	args.np = domain->parent->of_node;
> +	args.args_count = 3;
> +	args.args[0] = GIC_IRQ_TYPE_LPI;
> +	args.args[1] = hwirq;
> +	args.args[2] = IRQ_TYPE_EDGE_RISING;
> +
> +	return irq_domain_alloc_irqs_parent(domain, virq, 1, &args);
> +}
> +
> +static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +				unsigned int nr_irqs, void *args)
> +{
> +	msi_alloc_info_t *info = args;
> +	struct its_device *its_dev = info->scratchpad[0].ptr;
> +	irq_hw_number_t hwirq;
> +	int err;
> +	int i;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		err = its_alloc_device_irq(its_dev, &hwirq);
> +		if (err)
> +			return err;
> +
> +		err = its_irq_gic_domain_alloc(domain, virq + i, hwirq);
> +		if (err)
> +			return err;
> +
> +		irq_domain_set_hwirq_and_chip(domain, virq + i,
> +					      hwirq, &its_irq_chip, its_dev);
> +		dev_dbg(info->scratchpad[1].ptr, "ID:%d pID:%d vID:%d\n",
> +			(int)(hwirq - its_dev->lpi_base), (int)hwirq, virq + i);
> +	}
> +
> +	return 0;
> +}
> +
> +static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
> +				unsigned int nr_irqs)
> +{
> +	struct irq_data *d = irq_domain_get_irq_data(domain, virq);
> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +	int i;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		struct irq_data *data = irq_domain_get_irq_data(domain,
> +								virq + i);
> +		int event = its_get_event_id(data);
> +
> +		/* Stop the delivery of interrupts */
> +		its_send_discard(its_dev, event);
> +
> +		/* Mark interrupt index as unused */
> +		clear_bit(event, its_dev->lpi_map);
> +
> +		/* Nuke the entry in the domain */
> +		irq_domain_reset_irq_data(d);

I think you mean "data" here, instead of "d"?

Regards,
	Abel

> +	}
> +
> +	/* If all interrupts have been freed, start mopping the floor */
> +	if (bitmap_empty(its_dev->lpi_map, its_dev->nr_lpis)) {
> +		its_lpi_free(its_dev->lpi_map,
> +			     its_dev->lpi_base,
> +			     its_dev->nr_lpis);
> +
> +		/* Unmap device/itt */
> +		its_send_mapd(its_dev, 0);
> +		its_free_device(its_dev);
> +	}
> +
> +	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
> +}
> +
> +static const struct irq_domain_ops its_domain_ops = {
> +	.alloc			= its_irq_domain_alloc,
> +	.free			= its_irq_domain_free,
> +};
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 21c9d70..0ed30d7 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -295,6 +295,12 @@
>  
>  #include <linux/stringify.h>
>  
> +/*
> + * We need a value to serve as a irq-type for LPIs. Choose one that will
> + * hopefully pique the interest of the reviewer.
> + */
> +#define GIC_IRQ_TYPE_LPI		0xa110c8ed
> +
>  struct rdists {
>  	struct {
>  		void __iomem	*rd_base;



