Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbaIRH3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:29:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:3829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaIRH3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:29:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,545,1406617200"; 
   d="scan'208";a="604653399"
Message-ID: <541A89AC.9000706@linux.intel.com>
Date: Thu, 18 Sep 2014 15:28:44 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Part2 v1 01/21] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com> <1410444228-3134-2-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1409160859080.4247@nanos>
In-Reply-To: <alpine.DEB.2.10.1409160859080.4247@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/17 1:43, Thomas Gleixner wrote:
> Jiang,
> 
> On Thu, 11 Sep 2014, Jiang Liu wrote:
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>>  	/* Create mapping */
>> -	virq = irq_create_mapping(domain, hwirq);
>> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>> +	if (domain->ops->alloc)
>> +		virq = irq_domain_alloc_irqs(domain, -1, 1, NUMA_NO_NODE,
>> +					     irq_data);
>> +	else
>> +#endif
>> +		virq = irq_create_mapping(domain, hwirq);
> 
> I'd prefer to get rid of the #ifdef CONFIG...s in the code. So this
> can be written:
> 
>         if (irq_domain_has_hierarchy(domain))
> 		virq = irq_domain_alloc_irqs(domain, -1, 1, NUMA_NO_NODE,
> 					     irq_data);
> 	else
> 		virq = irq_create_mapping(domain, hwirq);
Sure, will kill the ifdef. 	

> 	   
> 
>>  	if (!virq)
>>  		return virq;
>>  
>> @@ -540,7 +542,11 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>>  		return 0;
>>  
>>  	if (hwirq < domain->revmap_direct_max_irq) {
>> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>> +		data = irq_domain_get_irq_data(domain, hwirq);
>> +#else
>>  		data = irq_get_irq_data(hwirq);
>> +#endif
> 
> Similar here. Make irq_domain_get_irq_data() map to irq_get_irq_data() for
> the non hierarchy mode so you end up with a single line:
> 
> -  		data = irq_get_irq_data(hwirq);
> +		data = irq_domain_get_irq_data(domain, hwirq);
Sure.

>> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>> +/**
>> + * irq_domain_alloc_irqs - Allocate IRQs from domain
>> + * @domain: domain to allocate from
>> + * @irq_base: allocate specified IRQ nubmer if irq_base >= 0
>> + * @nr_irqs: number of IRQs to allocate
>> + * @node: NUMA node id for memory allocation
>> + * @arg: domain specific argument
>> + * @realloc: IRQ descriptors have already been allocated if true
>> + *
>> + * Allocate IRQ numbers and initialized all data structures to support
>> + * hiearchy IRQ domains.
>> + * Parameter @realloc is mainly to support legacy IRQs.
> 
> What's the issue with the legacy irqs? So this has the interrupt
> descriptors allocated already. Are they already wired up for serving
> interrupts and what's the state of those lines?
Function arch_early_ioapic_init() will allocate irq descriptors and
irq_cfg structures for all legacy IRQ for three purposes:
1) To support ISA IRQs managed by 8259.
2) To reserve vectors on all CPUs for legacy IRQs
3) Prepare data structures to support pre_init_apic_IRQ0().
We will kill pre_init_apic_IRQ0() soon, so item 3 above won't be needed
anymore.

When __irq_domain_alloc_irqs() is called, only irq descriptor and
irq_cfg have been allocated, but the interrupt controller hardware
should be untouched yet.

> 
>> + * Returns error code or allocated IRQ number
> 
> Can you please add some documentation how the hierarchical allocation
> is supposed to work and how the domains are connected. That should
> probably go to Documentation/IRQ-domains.txt.
Sure, I will do my best to add documentations for it.
> 
> Other than that this looks pretty good! Nice work!
Thanks!
Gerry
> 
> Thanks,
> 
> 	tglx
> 
