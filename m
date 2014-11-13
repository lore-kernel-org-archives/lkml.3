Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbaKMMlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:41:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:52142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbaKMMle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:41:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487161931"
Message-ID: <5464A6F6.3070506@linux.intel.com>
Date: Thu, 13 Nov 2014 20:41:26 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Gordeev <agordeev@redhat.com>
CC: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch V1 3/6] genirq: Introduce msi_irq_domain_{alloc|free}_irqs()
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <1415879029-20098-5-git-send-email-jiang.liu@linux.intel.com> <5464A569.5060300@huawei.com>
In-Reply-To: <5464A569.5060300@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/13 20:34, Yijing Wang wrote:
> Gerry, this patch seems to be the same as last one.
Do you means patch 6/6? They are different:)

> 
> 
> On 2014/11/13 19:43, Jiang Liu wrote:
>> Introduce msi_irq_domain_{alloc|free}_irqs() to alloc/free interrupts
>> from irqdomain for generic MSI interrupts.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  include/linux/msi.h |   35 ++++++++++++++++++++++++++++++
>>  kernel/irq/msi.c    |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 94 insertions(+)
>>
>> diff --git a/include/linux/msi.h b/include/linux/msi.h
>> index 714716a3ffdd..6b356a1410b2 100644
>> --- a/include/linux/msi.h
>> +++ b/include/linux/msi.h
>> @@ -3,6 +3,7 @@
>>  
>>  #include <linux/kobject.h>
>>  #include <linux/list.h>
>> +#include <asm/hw_irq.h>		/* for msi_alloc_info_t */
>>  
>>  struct msi_msg {
>>  	u32	address_lo;	/* low 32 bits of msi message address */
>> @@ -100,7 +101,26 @@ struct irq_chip;
>>  struct device_node;
>>  struct msi_domain_info;
>>  
>> +#ifndef NUM_MSI_ALLOC_SCRATCHPAD_REGS
>> +#define NUM_MSI_ALLOC_SCRATCHPAD_REGS	2
>> +#endif
>> +
>> +/*
>> + * Default structure for MSI interrupt allocation.
>> + * Arch may overwrite it by define msi_alloc_info_t.
>> + */
>> +struct msi_alloc_info {
>> +	struct msi_desc *desc;
>> +	irq_hw_number_t hwirq;
>> +	long		scratchpad[NUM_MSI_ALLOC_SCRATCHPAD_REGS];
>> +};
>> +
>> +#ifndef msi_alloc_info_t
>> +typedef struct msi_alloc_info msi_alloc_info_t;
>> +#endif
>> +
>>  struct msi_domain_ops {
>> +	/* Callbacks for msi_create_irq_domain() */
>>  	void		(*calc_hwirq)(struct msi_domain_info *info, void *arg,
>>  				      struct msi_desc *desc);
>>  	irq_hw_number_t	(*get_hwirq)(struct msi_domain_info *info, void *arg);
>> @@ -111,6 +131,19 @@ struct msi_domain_ops {
>>  	void		(*msi_free)(struct irq_domain *domain,
>>  				    struct msi_domain_info *info,
>>  				    unsigned int virq);
>> +
>> +	/* Callbacks for msi_irq_domain_alloc_irqs() based on msi_descs */
>> +	int		(*msi_check)(struct irq_domain *domain,
>> +				     struct msi_domain_info *info,
>> +				     struct device *dev);
>> +	int		(*msi_prepare)(struct irq_domain *domain,
>> +				       struct device *dev,
>> +				       msi_alloc_info_t *arg);
>> +	void		(*msi_finish)(msi_alloc_info_t *arg, int retval);
>> +	void		(*set_desc)(msi_alloc_info_t *arg,
>> +				    struct msi_desc *desc);
>> +	int		(*handle_error)(struct irq_domain *domain,
>> +					struct msi_desc *desc, int error);
>>  };
>>  
>>  struct msi_domain_info {
>> @@ -125,6 +158,8 @@ int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
>>  struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
>>  					 struct msi_domain_info *info,
>>  					 struct irq_domain *parent);
>> +int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev);
>> +void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev);
>>  struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
>>  
>>  #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
>> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
>> index 94d6d87ee23e..0b6665de3a60 100644
>> --- a/kernel/irq/msi.c
>> +++ b/kernel/irq/msi.c
>> @@ -13,6 +13,9 @@
>>  #include <linux/irqdomain.h>
>>  #include <linux/msi.h>
>>  
>> +/* Temparory solution for building, will be removed later */
>> +#include <linux/pci.h>
>> +
>>  void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
>>  {
>>  	*msg = entry->msg;
>> @@ -124,6 +127,62 @@ struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
>>  	return domain;
>>  }
>>  
>> +int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev)
>> +{
>> +	int i, ret, virq = -1;
>> +	msi_alloc_info_t arg;
>> +	struct msi_desc *desc;
>> +	struct msi_domain_info *info = domain->host_data;
>> +	struct msi_domain_ops *ops = info->ops;
>> +
>> +	ret = ops->msi_check(domain, info, dev);
>> +	if (ret == 0)
>> +		ret = ops->msi_prepare(domain, dev, &arg);
>> +	if (ret)
>> +		return ret;
>> +
>> +	for_each_msi_entry(desc, dev) {
>> +		ops->set_desc(&arg, desc);
>> +
>> +		virq = __irq_domain_alloc_irqs(domain, -1, desc->nvec_used,
>> +					       dev_to_node(dev), &arg, false);
>> +		if (virq < 0) {
>> +			ret = -ENOSPC;
>> +			if (ops->handle_error)
>> +				ret = ops->handle_error(domain, desc, ret);
>> +			if (ops->msi_finish)
>> +				ops->msi_finish(&arg, ret);
>> +			return ret;
>> +		}
>> +
>> +		for (i = 0; i < desc->nvec_used; i++)
>> +			irq_set_msi_desc_off(virq, i, desc);
>> +	}
>> +
>> +	if (ops->msi_finish)
>> +		ops->msi_finish(&arg, 0);
>> +
>> +	for_each_msi_entry(desc, dev) {
>> +		if (desc->nvec_used == 1)
>> +			dev_dbg(dev, "irq %d for MSI\n", virq);
>> +		else
>> +			dev_dbg(dev, "irq [%d-%d] for MSI\n",
>> +				virq, virq + desc->nvec_used - 1);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
>> +{
>> +	struct msi_desc *desc;
>> +
>> +	for_each_msi_entry(desc, dev) {
>> +		irq_domain_free_irqs(desc->irq, desc->nvec_used);
>> +		desc->irq = 0;
>> +	}
>> +}
>> +
>>  struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
>>  {
>>  	return (struct msi_domain_info *)domain->host_data;
>>
> 
> 
