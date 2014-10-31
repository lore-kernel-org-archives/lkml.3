Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaJaMEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 08:04:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:15360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbaJaMEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 08:04:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,294,1413270000"; 
   d="scan'208";a="599708999"
Message-ID: <54537AC7.90409@linux.intel.com>
Date: Fri, 31 Oct 2014 20:04:23 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: [Patch Part2 v3 15/24] x86, MSI: Use hierarchy irqdomain to manage
 MSI interrupts
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com> <1414484803-10311-16-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1410282046120.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410282046120.5308@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/10/29 5:37, Thomas Gleixner wrote:
> On Tue, 28 Oct 2014, Jiang Liu wrote:
>> @@ -166,25 +264,59 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
>>  
>>  int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>>  {
>> -	struct msi_desc *msidesc;
>> -	int irq, ret;
>> +	int irq, cnt, nvec_pow2;
>> +	struct irq_domain *domain;
>> +	struct msi_desc *msidesc, *iter;
>> +	struct irq_alloc_info info;
>> +	int node = dev_to_node(&dev->dev);
>>  
>> -	/* Multiple MSI vectors only supported with interrupt remapping */
>> -	if (type == PCI_CAP_ID_MSI && nvec > 1)
>> -		return 1;
>> +	if (disable_apic)
>> +		return -ENOSYS;
>>  
>> -	list_for_each_entry(msidesc, &dev->msi_list, list) {
>> -		irq = irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
>> +	init_irq_alloc_info(&info, NULL);
>> +	info.msi_dev = dev;
>> +	if (type == PCI_CAP_ID_MSI) {
>> +		msidesc = list_first_entry(&dev->msi_list,
>> +					   struct msi_desc, list);
>> +		WARN_ON(!list_is_singular(&dev->msi_list));
>> +		WARN_ON(msidesc->irq);
>> +		WARN_ON(msidesc->msi_attrib.multiple);
>> +		WARN_ON(msidesc->nvec_used);
>> +		info.type = X86_IRQ_ALLOC_TYPE_MSI;
>> +		cnt = nvec;
>> +	} else {
>> +		info.type = X86_IRQ_ALLOC_TYPE_MSIX;
>> +		cnt = 1;
>> +	}
> 
> We have a similar issue here.
> 
>> +	domain = irq_remapping_get_irq_domain(&info);
> 
> We add domain specific knowledge to the MSI implementation. Not
> necessary at all.
> 
> Again MSI is not an x86 problem and we really can move most of that to
> the core code. The above sanity checks and the distinction between MSI
> and MSIX can be handled in the core code. And every domain involved in
> the MSI chain would need a alloc_msi() callback.
Add alloc_msi() callback to irq_domain_ops seems a little overaction.
I think the main idea is to make MSI code public as much as possible,
so I have found another solution to move MSI irqdomain code into
drivers/pci/msi.c and only following code are platform dependent now.
How about this solution?
------------------------------------------------------------------------
int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
{
        struct irq_domain *domain;
        struct irq_alloc_info info;

        init_irq_alloc_info(&info, NULL);
        info.msi_dev = dev;
        if (type == PCI_CAP_ID_MSI) {
                info.type = X86_IRQ_ALLOC_TYPE_MSI;
                info.flags |= X86_IRQ_ALLOC_CONTIGOUS_VECTORS;
        } else {
                info.type = X86_IRQ_ALLOC_TYPE_MSIX;
        }

        domain = irq_remapping_get_irq_domain(&info);
        if (domain == NULL)
                domain = msi_default_domain;
        if (domain == NULL)
                return -ENOSYS;

        return msi_irq_domain_alloc_irqs(domain, type, dev, &info);
}

void native_teardown_msi_irq(unsigned int irq)
{
        irq_domain_free_irqs(irq, 1);
}

irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg)
{
        struct irq_alloc_info *info = arg;

        return info->msi_hwirq;
}

void arch_msi_irq_domain_set_hwirq(void *arg, irq_hw_number_t hwirq)
{
        struct irq_alloc_info *info = arg;

        info->msi_hwirq = hwirq;
}

void arch_init_msi_domain(struct irq_domain *parent)
{
        if (disable_apic)
                return;

        msi_default_domain = msi_create_irq_domain(parent);
        if (!msi_default_domain)
                pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
}

#ifdef CONFIG_IRQ_REMAP
struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
{
        return msi_create_irq_domain(parent);
}
#endif
-----------------------------------------------------------------

> 
> So native_setup_msi_irqs() would boil down to:
> + {
> +	if (disable_apic)
> +		return -ENOSYS;
> + 
> +	return irq_domain_alloc_msi(msi_domain, dev, nvec, type);   
> + }
> 
> Now that core function performs the sanity checks for the MSI case. In
> fact it should not proceed when a warning condition is detected. Not a
> x86 issue at all, its true for every MSI implementation.
> 
> Then it calls down the domain allocation chain. x86_msi_domain would
> simply hand down to the parent domain. That would either be the remap
> domain or the vector domain.
The issue here is that, the hierarchy irqdomain maintains a tree
topology and every irqdomain only supports one parent.

In case of irq remapping, we need to build one irqdomain for each IOMMU
unit to support hotplug and simplify the implementation. So we need to
build one MSI irqdomain for each IOMMU unit too instead of using a
common MSI irqdomain.

Current design is that, a common MSI irqdomain to support all MSI when
irq remapping is disabled, and one MSI irqdomain for each IOMMU unit
when irq remapping is enabled.

So we have the code below to choose the correct irqdomain for MSI.
        domain = irq_remapping_get_irq_domain(&info);
        if (domain == NULL)
                domain = msi_default_domain;
        if (domain == NULL)
                return -ENOSYS;

> 
> The reject for the multi MSI would only be implemented in the vector
> domain callback, while the remap domain can handle it. Once we gain
> support for allocating consecutive vectors for multi-MSI in the vector
> domain we would not have to change any of the MSI code at all. 
I have worked out a working patch to make decision in vector domain,
as you have suggested.

> 
> Thoughts?
> 
> Thanks,
> 
> 	tglx
> 
