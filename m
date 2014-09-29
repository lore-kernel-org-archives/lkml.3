Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaI2MY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:24:27 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:10165 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaI2MYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:24:25 -0400
Message-ID: <54294F1C.30606@huawei.com>
Date: Mon, 29 Sep 2014 20:22:52 +0800
From: Abel <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFT v2 01/24] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
References: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com> <1411740145-30626-2-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1411740145-30626-2-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,
Please see my comments and questions below.
On 2014/9/26 22:02, Jiang Liu wrote:

[...]
> diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
> index d269cecdfbf0..dc1f3d08892e 100644
> --- a/kernel/irq/Kconfig
> +++ b/kernel/irq/Kconfig
> @@ -55,6 +55,9 @@ config GENERIC_IRQ_CHIP
>  config IRQ_DOMAIN
>  	bool
>  
> +config IRQ_DOMAIN_HIERARCHY
> +	bool
> +

Depends on IRQ_DOMAIN?

>  config IRQ_DOMAIN_DEBUG
>  	bool "Expose hardware/virtual IRQ mapping via debugfs"
>  	depends on IRQ_DOMAIN && DEBUG_FS
[...]

> +static void irq_domain_free_descs(unsigned int virq, unsigned int nr_irqs)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < nr_irqs; i++)
> +		irq_free_desc(virq + i);
> +}

I am not sure why this function is needed, since it works in the exact same
way as irq_free_descs(virq, nr_irqs).

> +
[...]
> +/**
> + * __irq_domain_alloc_irqs - Allocate IRQs from domain
> + * @domain: domain to allocate from
> + * @irq_base: allocate specified IRQ nubmer if irq_base >= 0
> + * @nr_irqs: number of IRQs to allocate
> + * @node: NUMA node id for memory allocation
> + * @arg: domain specific argument
> + * @realloc: IRQ descriptors have already been allocated if true
> + *
> + * Allocate IRQ numbers and initialized all data structures to support
> + * hiearchy IRQ domains.
> + * Parameter @realloc is mainly to support legacy IRQs.
> + * Returns error code or allocated IRQ number
> + */
> +int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
> +			    unsigned int nr_irqs, int node, void *arg,
> +			    bool realloc)
> +{
> +	int i, ret, virq;
> +
> +	if (domain == NULL) {
> +		domain = irq_default_domain;
> +		if (WARN(!domain, "domain is NULL; cannot allocate IRQ\n"))
> +			return -EINVAL;
> +	}
> +
> +	if (!domain->ops->alloc) {
> +		pr_debug("domain->ops->alloc() is NULL\n");
> +		return -ENOSYS;
> +	}
> +
> +	if (realloc && irq_base >= 0) {
> +		virq = irq_base;
> +	} else {
> +		virq = irq_domain_alloc_descs(irq_base, nr_irqs, 0, node);
> +		if (virq < 0) {
> +			pr_debug("cannot allocate IRQ(base %d, count %d)\n",
> +				 irq_base, nr_irqs);
> +			return virq;
> +		}
> +	}
> +
> +	if (irq_domain_alloc_irq_data(domain, virq, nr_irqs)) {
> +		pr_debug("cannot allocate memory for IRQ%d\n", virq);
> +		ret = -ENOMEM;
> +		goto out_free_desc;
> +	}
> +
> +	mutex_lock(&irq_domain_mutex);
> +	ret = domain->ops->alloc(domain, virq, nr_irqs, arg);

I've been through your patches and noticed that the only domain which does not
call irq_domain_alloc_irqs_parent() is x86_vector_domain. And this makes sense
*if* we already knew which domain is the nearest one to the CPU.
But I don't think a well implemented device driver should assume itself be in
a particular position of the interrupt delivery path.
Actually it should be guaranteed by the core infrastructure that all the domains
in the interrupt delivery path should allocate a hardware interrupt for the
interrupt source.

> +	if (ret < 0) {
> +		mutex_unlock(&irq_domain_mutex);
> +		goto out_free_irq_data;
> +	}
> +	for (i = 0; i < nr_irqs; i++)
> +		irq_domain_insert_irq(virq + i);
> +	mutex_unlock(&irq_domain_mutex);
> +
> +	return virq;
> +
> +out_free_irq_data:
> +	irq_domain_free_irq_data(virq, nr_irqs);
> +out_free_desc:
> +	irq_domain_free_descs(virq, nr_irqs);
> +	return ret;
> +}
> +


And besides the comments/questions I mentioned above, I am also curious about
how the chained interrupts been processed.

Let's take a 3-level-chained-domains for example.
Given 3 interrupt controllers A, B and C, and the interrupt delivery path is:

DEV -> A -> B -> C -> CPU

After the hierarchy irqdomains are established, the unique linux interrupt of
DEV will be mapped with a hardware interrupt in each domain:

DomainA: HWIRQ_A => VIRQ_DEV
DomainB: HWIRQ_B => VIRQ_DEV
DomainC: HWIRQ_C => VIRQ_DEV

When the DEV triggered an interrupt signal, the CPU will acknowledge HWIRQ_C,
and then irq_find_mapping(DomainC, HWIRQ_C) will be called to get the linux
interrupt VIRQ_DEV, and after the handler of the VIRQ_DEV has been processed,
the interrupt will end with the level (if have) uncleared on B, which will
result in the interrupt of DEV cannot be processed again.

Or is there anything I misunderstand?

Thanks,
Abel.

