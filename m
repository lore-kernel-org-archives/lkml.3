Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaKFLpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:45:06 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:53535 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaKFLpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:45:03 -0500
Message-ID: <545B5ED7.7090901@huawei.com>
Date: Thu, 6 Nov 2014 19:43:19 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch Part2 v4 13/31] x86: irq_remapping: Introduce new interfaces
 to support hierarchy irqdomain
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com> <1415102525-9898-14-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1415102525-9898-14-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.545B5F32.020E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 5f6b174b516898e0cc1e7cf3008c17f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +enum irq_alloc_type {
> +	X86_IRQ_ALLOC_TYPE_IOAPIC = 1,
> +	X86_IRQ_ALLOC_TYPE_HPET,
> +	X86_IRQ_ALLOC_TYPE_MSI,
> +	X86_IRQ_ALLOC_TYPE_MSIX,
> +};

Hi Gerry, why not to use X86_IRQ_ALLOC_TYPE_MSI to represent both MSI and MSI-X type?
There are some differences to process MSI and MSI-X in irq remapping domain ?

>  
> +extern struct irq_domain *irq_remapping_get_ir_irq_domain(
> +				struct irq_alloc_info *info);
> +extern struct irq_domain *irq_remapping_get_irq_domain(
> +				struct irq_alloc_info *info);

The two functions are too similar, and both get irq_domain by irq_alloc_info, possible to merge them ?

> +extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
> +
> +/*
> + * Create MSI/MSIx irqdomain for interrupt remapping device, use @parent as
> + * parent irqdomain.
> + */
> +static inline struct irq_domain *
> +arch_create_msi_irq_domain(struct irq_domain *parent)
> +{
> +	return NULL;
> +}
> +
> +/* Get parent irqdomain for interrupt remapping irqdomain */
> +static inline struct irq_domain *arch_get_ir_parent_domain(void)
> +{
> +	return x86_vector_domain;
> +}
> +
>  #else  /* CONFIG_IRQ_REMAP */
>  
>  static inline void setup_irq_remapping_ops(void) { }
> @@ -101,6 +126,20 @@ static inline bool setup_remapped_irq(int irq,
>  {
>  	return false;
>  }
> +
> +static inline struct irq_domain *
> +irq_remapping_get_ir_irq_domain(struct irq_alloc_info *info)
> +{
> +	return NULL;
> +}
> +
> +static inline struct irq_domain *
> +irq_remapping_get_irq_domain(struct irq_alloc_info *info)
> +{
> +	return NULL;
> +}
> +
> +#define	irq_remapping_print_chip	NULL
>  #endif /* CONFIG_IRQ_REMAP */
>  
>  extern int dmar_alloc_hwirq(void);
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index 63886bafed9f..176ff4372b7d 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -377,7 +377,7 @@ void panic_if_irq_remap(const char *msg)
>  		panic(msg);
>  }
>  
> -static void ir_ack_apic_edge(struct irq_data *data)
> +void ir_ack_apic_edge(struct irq_data *data)
>  {
>  	ack_APIC_irq();
>  }
> @@ -388,6 +388,19 @@ static void ir_ack_apic_level(struct irq_data *data)
>  	eoi_ioapic_irq(data->irq, irqd_cfg(data));
>  }
>  
> +void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p)
> +{
> +	/*
> +	 * Assume interrupt is remapped if the parent irqdomain isn't the
> +	 * vector domain, which is true for MSI, HPET and IOAPIC on x86
> +	 * platforms.
> +	 */
> +	if (data->domain && data->domain->parent != arch_get_ir_parent_domain())
> +		seq_printf(p, " IR-%s", data->chip->name);
> +	else
> +		seq_printf(p, " %s", data->chip->name);
> +}
> +
>  static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
>  {
>  	seq_printf(p, " IR-%s", data->chip->name);
> @@ -409,3 +422,36 @@ bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
>  	irq_remap_modify_chip_defaults(chip);
>  	return true;
>  }
> +
> +/**
> + * irq_remapping_get_ir_irq_domain - Get the irqdomain associated the IOMMU
> + *				     device serving @info
> + * @info: interrupt allocation information, used to find the IOMMU device
> + *
> + * It's used to get parent irqdomain for HPET and IOAPIC domains.
> + * Returns pointer to IRQ domain, or NULL on failure.
> + */
> +struct irq_domain *
> +irq_remapping_get_ir_irq_domain(struct irq_alloc_info *info)
> +{
> +	if (!remap_ops || !remap_ops->get_ir_irq_domain)
> +		return NULL;
> +
> +	return remap_ops->get_ir_irq_domain(info);
> +}
> +
> +/**
> + * irq_remapping_get_irq_domain - Get the irqdomain serving the MSI interrupt
> + * @info: interrupt allocation information, used to find the IOMMU device
> + *
> + * It's used to get irqdomain for MSI/MSIx interrupt allocation.
> + * Returns pointer to IRQ domain, or NULL on failure.
> + */
> +struct irq_domain *
> +irq_remapping_get_irq_domain(struct irq_alloc_info *info)
> +{
> +	if (!remap_ops || !remap_ops->get_irq_domain)
> +		return NULL;
> +
> +	return remap_ops->get_irq_domain(info);
> +}
> diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
> index fde250f86e60..8c159d6fac46 100644
> --- a/drivers/iommu/irq_remapping.h
> +++ b/drivers/iommu/irq_remapping.h
> @@ -30,6 +30,8 @@ struct irq_data;
>  struct cpumask;
>  struct pci_dev;
>  struct msi_msg;
> +struct irq_domain;
> +struct irq_alloc_info;
>  
>  extern int disable_irq_remap;
>  extern int irq_remap_broken;
> @@ -81,11 +83,19 @@ struct irq_remap_ops {
>  
>  	/* Setup interrupt remapping for an HPET MSI */
>  	int (*alloc_hpet_msi)(unsigned int, unsigned int);
> +
> +	/* Get the irqdomain associated the IOMMU device */
> +	struct irq_domain *(*get_ir_irq_domain)(struct irq_alloc_info *);
> +
> +	/* Get the MSI irqdomain associated with the IOMMU device */
> +	struct irq_domain *(*get_irq_domain)(struct irq_alloc_info *);
>  };
>  
>  extern struct irq_remap_ops intel_irq_remap_ops;
>  extern struct irq_remap_ops amd_iommu_irq_ops;
>  
> +extern void ir_ack_apic_edge(struct irq_data *data);
> +
>  #else  /* CONFIG_IRQ_REMAP */
>  
>  #define irq_remapping_enabled 0
> 


-- 
Thanks!
Yijing

