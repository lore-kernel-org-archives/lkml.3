Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaKOB04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:26:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:62717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679AbaKOB0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:26:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487655219"
Message-ID: <5466ABDA.8070804@linux.intel.com>
Date: Sat, 15 Nov 2014 09:26:50 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 07/16] genirq: Introduce helper irq_domain_set_info()
 to reduce duplicated code
References: <20141112133941.647950773@linutronix.de> <20141112134120.393705922@linutronix.de> <54662062.8030807@arm.com> <546622A1.1030308@linux.intel.com> <54663D7C.7020104@arm.com>
In-Reply-To: <54663D7C.7020104@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/15 1:35, Marc Zyngier wrote:
> On 14/11/14 15:41, Jiang Liu wrote:
>> On 2014/11/14 23:31, Marc Zyngier wrote:
>>> On 12/11/14 13:43, Thomas Gleixner wrote:
>>>> From: Jiang Liu <jiang.liu@linux.intel.com>
>>>>
>>>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>>>> Cc: Grant Likely <grant.likely@linaro.org>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
>>>> Cc: Yijing Wang <wangyijing@huawei.com>
>>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>>> ---
>>>>  include/linux/irqdomain.h |    5 +++++
>>>>  kernel/irq/irqdomain.c    |   10 ++++++++++
>>>>  2 files changed, 15 insertions(+)
>>>>
>>>> Index: tip/include/linux/irqdomain.h
>>>> ===================================================================
>>>> --- tip.orig/include/linux/irqdomain.h
>>>> +++ tip/include/linux/irqdomain.h
>>>> @@ -33,6 +33,7 @@
>>>>  #define _LINUX_IRQDOMAIN_H
>>>>  
>>>>  #include <linux/types.h>
>>>> +#include <linux/irqhandler.h>
>>>>  #include <linux/radix-tree.h>
>>>>  
>>>>  struct device_node;
>>>> @@ -263,6 +264,10 @@ extern int irq_domain_set_hwirq_and_chip
>>>>  					 irq_hw_number_t hwirq,
>>>>  					 struct irq_chip *chip,
>>>>  					 void *chip_data);
>>>> +extern void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
>>>> +				irq_hw_number_t hwirq, struct irq_chip *chip,
>>>> +				void *chip_data, irq_flow_handler_t handler,
>>>> +				void *handler_data, const char *handler_name);
>>>>  extern void irq_domain_reset_irq_data(struct irq_data *irq_data);
>>>>  extern void irq_domain_free_irqs_common(struct irq_domain *domain,
>>>>  					int virq, int nr_irqs);
>>>> Index: tip/kernel/irq/irqdomain.c
>>>> ===================================================================
>>>> --- tip.orig/kernel/irq/irqdomain.c
>>>> +++ tip/kernel/irq/irqdomain.c
>>>> @@ -882,6 +882,16 @@ int irq_domain_set_hwirq_and_chip(struct
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
>>>> +			 irq_hw_number_t hwirq, struct irq_chip *chip,
>>>> +			 void *chip_data, irq_flow_handler_t handler,
>>>> +			 void *handler_data, const char *handler_name)
>>>> +{
>>>> +	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
>>>> +	__irq_set_handler(virq, handler, 0, handler_name);
>>>> +	irq_set_handler_data(virq, handler_data);
>>>> +}
>>>> +
>>>
>>> We still have the issue that, depending on where in the stack this is
>>>  called, this will succeed or fail: If this is called from the inner
>>> irqchip, __irq_set_handler() will fail, as it will look at the outer
>>> domain as the (desc->irq_data.chip == &no_irq_chip) test fails (we
>>> haven't set the top level yet).
>>>
>>> I have this very imperfect workaround in my tree:
>>>
>>> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
>>> index d028b34..91e6515 100644
>>> --- a/kernel/irq/chip.c
>>> +++ b/kernel/irq/chip.c
>>> @@ -731,7 +731,16 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
>>>  	if (!handle) {
>>>  		handle = handle_bad_irq;
>>>  	} else {
>>> -		if (WARN_ON(desc->irq_data.chip == &no_irq_chip))
>>> +#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
>>> +		struct irq_data *irq_data = &desc->irq_data;
>>> +		while (irq_data) {
>>> +			if (irq_data->chip != &no_irq_chip)
>>> +				break;
>>> +			irq_data = irq_data->parent_data;
>>> +		}
>>> +#endif
>>> +
>>> +		if (WARN_ON(!irq_data || irq_data->chip == &no_irq_chip))
>>>  			goto out;
>>>  	}
>>>  
>>> Which translate into: If there is at least one irqchip in the domain,
>>> it will probably sort itself out. Not ideal. Any real solution to
>>> this problem?
>>>
>>> GICv2 faces this exact problem, as some of its interrupts are used
>>> directly, and some others are used through the MSI domain. In the
>>> GIC driver, it is almost impossible to find out...
>> Hi Marc,
>> 	I prefer the above solution to relax the warning conditions.
>> Changing the calling order in irq_domain_ops->alloc() looks a little
>> strange, and other interrupt drivers may still run into the same issue.
> 
> OK. Where do we from from there? Do you want a proper patch, or will you
> fold this into the existing code?
A patch will be great:)

> 
> Thanks,
> 
> 	M.
> 
