Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaKRMuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:50:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:5952 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbaKRMuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:50:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,409,1413270000"; 
   d="scan'208";a="638937305"
Message-ID: <546B4075.9050406@linux.intel.com>
Date: Tue, 18 Nov 2014 20:49:57 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 09/16] genirq: Add generic msi irq domain support
References: <20141112133941.647950773@linutronix.de> <20141112134120.569789374@linutronix.de> <546B3667.9040506@huawei.com>
In-Reply-To: <546B3667.9040506@huawei.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/11/18 20:07, Yun Wu (Abel) wrote:
> On 2014/11/12 21:43, Thomas Gleixner wrote:
> 
>> From: Jiang Liu <jiang.liu@linux.intel.com>
<snip>
>> +static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
>> +			    unsigned int nr_irqs, void *arg)
>> +{
>> +	struct msi_domain_info *info = domain->host_data;
>> +	struct msi_domain_ops *ops = info->ops;
>> +	irq_hw_number_t hwirq = ops->get_hwirq(info, arg);
>> +	int i, ret;
>> +
>> +	if (irq_find_mapping(domain, hwirq) > 0)
>> +		return -EEXIST;
> 
> I think we need to check range here.
> I fixed this by applying a patch showed in the bottom.
Hi Yun,
	Yes, we have some assumptions here about the way the interface
will be used for. Will improve it in future patches.
Regards!
Gerry
> 
>> +
>> +	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	for (i = 0; i < nr_irqs; i++) {
>> +		ret = ops->msi_init(domain, info, virq + i, hwirq + i, arg);
>> +		if (ret < 0) {
>> +			if (ops->msi_free) {
>> +				for (i--; i > 0; i--)
> 
> while (i--) ?
> 
> Regards,
> 	Abel
> 
>> +					ops->msi_free(domain, info, virq + i);
>> +			}
>> +			irq_domain_free_irqs_top(domain, virq, nr_irqs);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
>> +			    unsigned int nr_irqs)
>> +{
>> +	struct msi_domain_info *info = domain->host_data;
>> +	int i;
>> +
>> +	if (info->ops->msi_free) {
>> +		for (i = 0; i < nr_irqs; i++)
>> +			info->ops->msi_free(domain, info, virq + i);
>> +	}
>> +	irq_domain_free_irqs_top(domain, virq, nr_irqs);
>> +}
>> +
>> +static struct irq_domain_ops msi_domain_ops = {
>> +	.alloc		= msi_domain_alloc,
>> +	.free		= msi_domain_free,
>> +	.activate	= msi_domain_activate,
>> +	.deactivate	= msi_domain_deactivate,
>> +};
>> +
>> +struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
>> +					 struct msi_domain_info *info,
>> +					 struct irq_domain *parent)
>> +{
>> +	struct irq_domain *domain;
>> +
>> +	domain = irq_domain_add_tree(of_node, &msi_domain_ops, info);
>> +	if (domain)
>> +		domain->parent = parent;
>> +
>> +	return domain;
>> +}
>> +
>> +struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
>> +{
>> +	return (struct msi_domain_info *)domain->host_data;
>> +}
>> +
>> +#endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
>>
>>
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index cc18182..6d1be00 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -568,6 +568,34 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>  }
>  EXPORT_SYMBOL_GPL(irq_find_mapping);
> 
> +/**
> + * irq_find_mapping_many() - Find a range of linux irqs from a range of hwirqs.
> + * @domain:	domain owning these hardware interrupts
> + * @hwirq:	start hardware irq number in @domain space
> + * @count:	number of interrupts to find
> + *
> + * Returns the first linux irq number on success, or 0 when not found, or error.
> + */
> +int irq_find_mapping_many(struct irq_domain *domain, irq_hw_number_t hwirq,
> +			  int count)
> +{
> +	unsigned int from;
> +	int i;
> +
> +	for (i = from = 0; i < count; i++) {
> +		if (!from) {
> +			from = irq_find_mapping(domain, hwirq + i);
> +			if (from && i)
> +				return -1;
> +		} else if ((from + i) != irq_find_mapping(domain, hwirq + i)) {
> +			return -1;
> +		}
> +	}
> +
> +	return from;
> +}
> +EXPORT_SYMBOL_GPL(irq_find_mapping_many);
> +
>  #ifdef CONFIG_IRQ_DOMAIN_DEBUG
>  static int virq_debug_show(struct seq_file *m, void *private)
>  {
> 
> 
> 
