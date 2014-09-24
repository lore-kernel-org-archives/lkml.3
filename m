Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaIXFzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:55:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:36792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaIXFzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:55:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="607626609"
Message-ID: <54225CC4.2000403@linux.intel.com>
Date: Wed, 24 Sep 2014 13:55:16 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Joe.C" <srv_yingjoe.chen@mediatek.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch] irqdomain: Introduce new interfaces to support hierarchy
 irqdomains
References: <alpine.DEB.2.10.1409160859080.4247@nanos>	 <1411373856-9669-1-git-send-email-jiang.liu@linux.intel.com> <1411465402.8922.126.camel@mtksdaap41>
In-Reply-To: <1411465402.8922.126.camel@mtksdaap41>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/9/23 17:43, Joe.C wrote:
> On Mon, 2014-09-22 at 16:17 +0800, Jiang Liu wrote:
>> @@ -388,7 +389,6 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
>>  unsigned int irq_create_mapping(struct irq_domain *domain,
>>  				irq_hw_number_t hwirq)
>>  {
>> -	unsigned int hint;
>>  	int virq;
>>  
>>  	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
>> @@ -410,12 +410,8 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>>  	}
>>  
>>  	/* Allocate a virtual interrupt number */
>> -	hint = hwirq % nr_irqs;
>> -	if (hint == 0)
>> -		hint++;
>> -	virq = irq_alloc_desc_from(hint, of_node_to_nid(domain->of_node));
>> -	if (virq <= 0)
>> -		virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
>> +	virq = irq_domain_alloc_descs(-1, 1, hwirq,
>> +				      of_node_to_nid(domain->of_node));
> 
> If I read this correct, the resulting virq is different after your
> change.
It should have the same effect. We just factored out original code as
a function, so it could be reused.

> 
>>  	if (virq <= 0) {
>>  		pr_debug("-> virq allocation failed\n");
>>  		return 0;
>> @@ -490,7 +486,10 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>>  	}
>>  
>>  	/* Create mapping */
>> -	virq = irq_create_mapping(domain, hwirq);
>> +	if (irq_domain_is_hierarchy(domain))
>> +		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
>> +	else
>> +		virq = irq_create_mapping(domain, hwirq);
>>  	if (!virq)
>>  		return virq;
> 
> hwirq returned from xlat above is lost. Without hwirq or virq, how do we
> know which irq are we working for?
> Also, if the irq_desc/irq_data was already created, this will create
> another one. Should we do irq_find_mapping just like irq_create_mapping?
When irq_create_of_mapping is called, IRQ desc/irq_data haven't been
allocated yet. The parameter irq_data is type of struct of_phandle_args
instead of struct irq_data:)

We pass irq_data to irq_domain_alloc_irqs(), the we could reconstruct
hwirq from irq_data if needed.

To make the code clearer, I plan to change code as below:
unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
{
        struct irq_domain *domain;
        irq_hw_number_t hwirq;
        unsigned int type = IRQ_TYPE_NONE;
        unsigned int virq;

        domain = irq_data->np ? irq_find_host(irq_data->np) :
irq_default_domain;
        if (!domain) {
                pr_warn("no irq domain found for %s !\n",
                        of_node_full_name(irq_data->np));
                return 0;
        }

+        if (irq_domain_is_hierarchy(domain))
+                return irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE,
irq_data);
+
        /* If domain has no translation, then we assume interrupt line */
        if (domain->ops->xlate == NULL)
                hwirq = irq_data->args[0];
        else {
                if (domain->ops->xlate(domain, irq_data->np, irq_data->args,
                                        irq_data->args_count, &hwirq,
&type))
                        return 0;
        }

        /* Create mapping */
        virq = irq_create_mapping(domain, hwirq);
        if (!virq)
                return virq;

        /* Set type if specified and different than the current one */
        if (type != IRQ_TYPE_NONE &&
            type != irq_get_trigger_type(virq))
                irq_set_irq_type(virq, type);
        return virq;
}
EXPORT_SYMBOL_GPL(irq_create_of_mapping);

>> +int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
>> +			    unsigned int nr_irqs, int node, void *arg,
>> +			    bool realloc)
>> +{
>> +	int i, ret, virq;
>> +
>> +	if (domain == NULL) {
>> +		domain = irq_default_domain;
>> +		if (WARN(!domain, "domain is NULL; cannot allocate IRQ\n"))
>> +			return -EINVAL;
>> +	}
>> +
>> +	if (!domain->ops->alloc) {
>> +		pr_debug("domain->ops->alloc() is NULL\n");
>> +		return -ENOSYS;
>> +	}
>> +
>> +	if (realloc && irq_base >= 0) {
>> +		virq =  irq_base;
>                          ^
> extra space here.
Will fix it in next version.
Thanks, Joe!
Gerry
> 
> Joe.C
> 
> 
