Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaIVRaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:30:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:55525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaIVRaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:30:18 -0400
Message-ID: <54205C9C.4070101@infradead.org>
Date: Mon, 22 Sep 2014 10:30:04 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch] irqdomain: Introduce new interfaces to support hierarchy
 irqdomains
References: <alpine.DEB.2.10.1409160859080.4247@nanos> <1411373856-9669-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1411373856-9669-1-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/14 01:17, Jiang Liu wrote:
> ---
>  Documentation/IRQ-domain.txt |   71 +++++++++
>  include/linux/irq.h          |    3 +
>  include/linux/irqdomain.h    |   86 ++++++++++
>  kernel/irq/Kconfig           |    3 +
>  kernel/irq/chip.c            |    3 +
>  kernel/irq/irqdomain.c       |  360 ++++++++++++++++++++++++++++++++++++++++--
>  6 files changed, 510 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
> index 8a8b82c9ca53..062f6b6088b4 100644
> --- a/Documentation/IRQ-domain.txt
> +++ b/Documentation/IRQ-domain.txt
> @@ -151,3 +151,74 @@ used and no descriptor gets allocated it is very important to make sure
>  that the driver using the simple domain call irq_create_mapping()
>  before any irq_find_mapping() since the latter will actually work
>  for the static IRQ assignment case.
> +
> +==== Hierarchy IRQ domain ====
> +On some architectures, there may be multiple interrupt controllers
> +involved in delivering an interrupt from the device to the target CPU.
> +Let's look at a typical interrupt delivering path on x86 platforms:
> +
> +Device --> IOAPIC -> Interrupt remapping Controller -> Local APIC -> CPU
> +
> +There are three interrupt controllers involved:
> +1) IOAPIC controller
> +2) Interrupt remapping controller
> +3) Local APIC controller
> +
> +To support such a hardware topology and make software architecture match
> +hardware architecture, an irq_domain data structure is built for each
> +interrupt controller and those irq_domains are organized into hierarchy.
> +When building irq_domain hierarchy, the irq_domain near to the device is
> +child and the irq_domain near to CPU is parent. So a hierarchy structure
> +as below will be built for the example above.
> +	CPU Vector irq_domain (root irq_domain to manage CPU vectors)
> +		^
> +		|
> +	Interrupt Remapping irq_domain (manage irq_remapping entries)
> +		^
> +		|
> +	IOAPIC irq_domain (manage IOAPIC delivery entries/pins)
> +
> +There are four major interfaces to use hierarchy irq_domain:
> +1) irq_domain_alloc_irqs(): allocate IRQ descriptors and interrupt
> +   controller related resources to deliver these interrupts.
> +2) irq_domain_free_irqs(): free IRQ descriptors and interrupt controler

                                                                 controller

> +   related resources associated with these interrupts.
> +3) irq_domain_activate_irq(): activate interrupt controller hardware to
> +   deliver the interrupt.
> +3) irq_domain_deactivate_irq(): deactivate interrupt controller hardware
> +   to stopping delivering the interrupt.

      to stop

> +
> +Following changes are needed to support hierarchy irq_domain.
> +1) a new field 'parent' is added to struct irq_domain, it's used to

                                              irq_domain;

> +   maintain irq_domain hierarchy information.
> +2) a new field 'parent_data' is added to struct irq_data, it's used to

                                                   irq_data;

> +   build hierarchy irq_data to match hierarchy irq_domains. The irq_data
> +   is used to store irq_domain pointer and hardware irq number.
> +3) new callbacks are added to struct irq_domain_ops to support hierarchy
> +   irq_domain operations.
> +
> +With support of hierarchy irq_domain and hierarchy irq_data ready, an
> +irq_domain structure is built for each interrupt controller, and an
> +irq_data structure is allocated for each irq_domain associated with an
> +IRQ. Now we could go one step further to support stacked(hierarchy)
> +irq_chip. That is, an irq_chip is associated with each irq_data along
> +the hierarchy. A child irq_chip may implement a required action by
> +itself or by cooperating with its parent irq_chip.
> +
> +With stacked irq_chip, interrupt controller driver only needs to deal
> +with the hardware managed by itself and may ask for services from its
> +parent irq_chip when needed. So we could achieve a much more cleaner

                                                    a much cleaner

> +software architecture.
> +
> +For an interrupt controller driver to support hierarchy irq_domain, it
> +needs to:
> +1) Implement irq_domain_ops.alloc and irq_domain_ops.free
> +2) Optionally implement irq_domain_ops.activate and
> +   irq_domain_ops.deactivate.
> +3) Optionally implement an irq_chip to manage the interrupt controller
> +   hardware.
> +4) No need to implement irq_domain_ops.map and irq_domain_ops.unmap,
> +   they are unused with hierarchy irq_domain.
> +
> +Hierarchy irq_domain may also be used to support other architectures,
> +such as ARM, ARM64 etc.

> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index b0f9d16e48f6..46e047c414bc 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -77,6 +89,7 @@ struct irq_domain_chip_generic;
>   * @ops: pointer to irq_domain methods
>   * @host_data: private data pointer for use by owner.  Not touched by irq_domain
>   *             core code.
> + * @flags: host per irqdomain flags

                       irq_domain ?

>   *
>   * Optional elements
>   * @of_node: Pointer to device tree nodes associated with the irq_domain. Used
> @@ -84,6 +97,7 @@ struct irq_domain_chip_generic;
>   * @gc: Pointer to a list of generic chips. There is a helper function for
>   *      setting up one or more generic chips for interrupt controllers
>   *      drivers using the generic chip library which uses this pointer.
> + * @parent: Pointer to parent irqdomain to support hierarchy irqdomains

                                 irq_domain ?                   irq_domains ?

>   *
>   * Revmap data, used internally by irq_domain
>   * @revmap_direct_max_irq: The largest hwirq that can be set for controllers that

> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 6534ff6ce02e..26628239088c 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -709,3 +708,332 @@ const struct irq_domain_ops irq_domain_simple_ops = {
>  	.xlate = irq_domain_xlate_onetwocell,
>  };
>  EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
> +
> +static int irq_domain_alloc_descs(int virq, unsigned int nr_irqs,
> +				  irq_hw_number_t hwirq, int node)
> +{
> +	unsigned int hint;
> +
> +	if (virq >= 0) {
> +		virq = irq_alloc_descs(virq, virq, nr_irqs, node);
> +	} else {
> +		hint = hwirq % nr_irqs;
> +		if (hint == 0)
> +			hint++;
> +		virq = irq_alloc_descs_from(hint, nr_irqs, node);
> +		if (virq <= 0 && hint > 1)
> +			virq = irq_alloc_descs_from(1, nr_irqs, node);
> +	}
> +
> +	return virq;
> +}
> +
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +static void irq_domain_free_descs(unsigned int virq, unsigned int nr_irqs)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < nr_irqs; i++)
> +		irq_free_desc(virq + i);
> +}
> +
> +static void irq_domain_insert_irq(int virq)
> +{
> +	struct irq_data *data;
> +
> +	for (data = irq_get_irq_data(virq); data; data = data->parent_data) {
> +		struct irq_domain *domain = data->domain;
> +		irq_hw_number_t hwirq = data->hwirq;
> +
> +		if (hwirq < domain->revmap_size) {
> +			domain->linear_revmap[hwirq] = virq;
> +		} else {
> +			mutex_lock(&revmap_trees_mutex);
> +			radix_tree_insert(&domain->revmap_tree, hwirq, data);
> +			mutex_unlock(&revmap_trees_mutex);
> +		}
> +
> +		/* If not already assigned, give the domain the chip's name */
> +		if (!domain->name && data->chip)
> +			domain->name = data->chip->name;
> +	}
> +
> +	irq_clear_status_flags(virq, IRQ_NOREQUEST);
> +}
> +
> +static void irq_domain_remove_irq(int virq)
> +{
> +	struct irq_data *data;
> +
> +	irq_set_status_flags(virq, IRQ_NOREQUEST);
> +	irq_set_chip_and_handler(virq, NULL, NULL);
> +	synchronize_irq(virq);
> +	smp_mb();
> +
> +	for (data = irq_get_irq_data(virq); data; data = data->parent_data) {
> +		struct irq_domain *domain = data->domain;
> +		irq_hw_number_t hwirq = data->hwirq;
> +
> +		if (hwirq < domain->revmap_size) {
> +			domain->linear_revmap[hwirq] = 0;
> +		} else {
> +			mutex_lock(&revmap_trees_mutex);
> +			radix_tree_delete(&domain->revmap_tree, hwirq);
> +			mutex_unlock(&revmap_trees_mutex);
> +		}
> +	}
> +}
> +
> +static struct irq_data *irq_domain_insert_irq_data(struct irq_domain *domain,
> +						   struct irq_data *child)
> +{
> +	struct irq_data *irq_data;
> +
> +	irq_data = kzalloc_node(sizeof(*irq_data), GFP_KERNEL, child->node);
> +	if (irq_data) {
> +		child->parent_data = irq_data;
> +		irq_data->irq = child->irq;
> +		irq_data->node = child->node;
> +		irq_data->domain = domain;
> +	}
> +
> +	return irq_data;
> +}
> +
> +static void irq_domain_free_irq_data(unsigned int virq, unsigned int nr_irqs)
> +{
> +	int i;
> +	struct irq_data *irq_data, *tmp;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		irq_data = irq_get_irq_data(virq + i);
> +		tmp = irq_data->parent_data;
> +		irq_data->parent_data = NULL;
> +		irq_data->domain = NULL;
> +
> +		while (tmp) {
> +			irq_data = tmp;
> +			tmp = tmp->parent_data;
> +			kfree(irq_data);
> +		}
> +	}
> +}
> +
> +static int irq_domain_alloc_irq_data(struct irq_domain *domain,
> +				     unsigned int virq, unsigned int nr_irqs)
> +{
> +	int i;
> +	struct irq_data *irq_data;
> +	struct irq_domain *parent;
> +
> +	/* The outmost irq_data is embedded in struct irq_desc */

	       outermost

> +	for (i = 0; i < nr_irqs; i++) {
> +		irq_data = irq_get_irq_data(virq + i);
> +		irq_data->domain = domain;
> +
> +		for (parent = domain->parent; parent; parent = parent->parent) {
> +			irq_data = irq_domain_insert_irq_data(parent, irq_data);
> +			if (!irq_data) {
> +				irq_domain_free_irq_data(virq, i + 1);
> +				return -ENOMEM;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * irq_domain_get_irq_data - Get irq_data assoicated with @virq and @domain

                                             associated

> + * @domain: domain to match
> + * @virq: IRQ number to get irq_data
> + */
> +struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
> +					 unsigned int virq)
> +{
> +	struct irq_data *irq_data;
> +
> +	for (irq_data = irq_get_irq_data(virq); irq_data;
> +	     irq_data = irq_data->parent_data)
> +		if (irq_data->domain == domain)
> +			return irq_data;
> +
> +	return NULL;
> +}
> +
> +int irq_domain_set_hwirq_and_chip(struct irq_domain *domain, unsigned int virq,
> +				  irq_hw_number_t hwirq, struct irq_chip *chip,
> +				  void *chip_data)
> +{
> +	struct irq_data *irq_data = irq_domain_get_irq_data(domain, virq);
> +
> +	if (!irq_data)
> +		return -ENOENT;
> +
> +	irq_data->hwirq = hwirq;
> +	irq_data->chip = chip;
> +	irq_data->chip_data = chip_data;
> +
> +	return 0;
> +}
> +
> +void irq_domain_reset_irq_data(struct irq_data *irq_data)
> +{
> +	irq_data->hwirq = 0;
> +	irq_data->chip = NULL;
> +	irq_data->chip_data = NULL;
> +}
> +
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
> +		virq =  irq_base;
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
> +/**
> + * irq_domain_free_irqs - Free IRQ number and assoicated data structures

                                                 associated

> + * @virq: base IRQ number
> + * @nr_irqs: number of IRQs to free
> + */
> +void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs)
> +{
> +	int i;
> +	struct irq_data *data = irq_get_irq_data(virq);
> +
> +	if (WARN(!data || !data->domain || !data->domain->ops->free,
> +		 "NULL pointer, cannot free irq\n"))
> +		return;
> +
> +	mutex_lock(&irq_domain_mutex);
> +	for (i = 0; i < nr_irqs; i++)
> +		irq_domain_remove_irq(virq + i);
> +	data->domain->ops->free(data->domain, virq, nr_irqs);
> +	mutex_unlock(&irq_domain_mutex);
> +
> +	irq_domain_free_irq_data(virq, nr_irqs);
> +	irq_domain_free_descs(virq, nr_irqs);
> +}
> +
> +/**
> + * irq_domain_activate_irq - Call domain_ops->activate recursively to activate
> + *			     interrupt
> + * @irq_data: out most irq_data associated with interrupt

                 outermost

> + *
> + * It calls domain_ops->activate to program interrupt controllers, so the
> + * interrupt could actually delivered.
> + */
> +int irq_domain_activate_irq(struct irq_data *irq_data)
> +{
> +	int ret = 0;
> +
> +	if (irq_data && irq_data->domain) {
> +		struct irq_domain *domain = irq_data->domain;
> +
> +		if (irq_data->parent_data)
> +			ret = irq_domain_activate_irq(irq_data->parent_data);
> +		if (ret == 0 && domain->ops->activate)
> +			ret = domain->ops->activate(domain, irq_data);
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * irq_domain_deactivate_irq - Call domain_ops->deactivate recursively to
> + *			       deactivate interrupt
> + * @irq_data: out most irq_data associated with interrupt

                 outermost

> + *
> + * It calls domain_ops->deactivate to program interrupt controllers to disable
> + * interrupt delivery.
> + */
> +int irq_domain_deactivate_irq(struct irq_data *irq_data)
> +{
> +	int ret = 0;
> +
> +	if (irq_data && irq_data->domain) {
> +		struct irq_domain *domain = irq_data->domain;
> +
> +		if (domain->ops->deactivate)
> +			ret = domain->ops->deactivate(domain, irq_data);
> +		if (ret == 0 && irq_data->parent_data)
> +			ret = irq_domain_deactivate_irq(irq_data->parent_data);
> +	}
> +
> +	return ret;
> +}
> +#else	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
> +/**
> + * irq_domain_get_irq_data - Get irq_data assoicated with @virq and @domain

                                             associated

> + * @domain: domain to match
> + * @virq: IRQ number to get irq_data
> + */
> +struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
> +					 unsigned int virq)
> +{
> +	struct irq_data *irq_data = irq_get_irq_data(virq);
> +
> +	return (irq_data && irq_data->domain == domain) ? irq_data : NULL;
> +}
> +
> +#endif	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
> 


-- 
~Randy
