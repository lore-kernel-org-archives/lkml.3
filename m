Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaJ1Jso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:48:44 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:55580 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979AbaJ1Jsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:48:41 -0400
X-Listener-Flag: 11101
Subject: Re: [Patch Part2 v3 01/24] irqdomain: Introduce new interfaces to
 support hierarchy irqdomains
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <1414484803-10311-2-git-send-email-jiang.liu@linux.intel.com>
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com>
	 <1414484803-10311-2-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Oct 2014 17:48:31 +0800
Message-ID: <1414489711.32399.53.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jiang,

On Tue, 2014-10-28 at 16:26 +0800, Jiang Liu wrote:
<deleted...>
> @@ -471,7 +469,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>  	struct irq_domain *domain;
>  	irq_hw_number_t hwirq;
>  	unsigned int type = IRQ_TYPE_NONE;
> -	unsigned int virq;
> +	int virq;
>  
>  	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
>  	if (!domain) {
> @@ -480,6 +478,11 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>  		return 0;
>  	}
>  
> +	if (irq_domain_is_hierarchy(domain)) {
> +		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
> +		return virq <= 0 ? 0 : virq;
> +	}
> +
>  	/* If domain has no translation, then we assume interrupt line */
>  	if (domain->ops->xlate == NULL)
>  		hwirq = irq_data->args[0];
> @@ -540,8 +543,8 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>  		return 0;
>  
>  	if (hwirq < domain->revmap_direct_max_irq) {
> -		data = irq_get_irq_data(hwirq);
> -		if (data && (data->domain == domain) && (data->hwirq == hwirq))
> +		data = irq_domain_get_irq_data(domain, hwirq);
> +		if (data && data->hwirq == hwirq)
>  			return hwirq;
>  	}

Why do you want to move irq_domain_alloc_irqs up there?

On the ARM side, the irqchips will be different on different SoCs, so we
will need to implement irq_find_mapping check and set_type in several
different location. This leads to code duplication. It is preferred to
do these in general code [1], [2]

Is it acceptable if we do irq_find_mapping and set_type here like [3]?

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/294294.html
[2]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/294306.html
[3]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296543.html


Joe.C


>  
> @@ -709,3 +712,341 @@ const struct irq_domain_ops irq_domain_simple_ops = {
>  	.xlate = irq_domain_xlate_onetwocell,
>  };
>  EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
> +
> +static int irq_domain_alloc_descs(int virq, unsigned int cnt,
> +				  irq_hw_number_t hwirq, int node)
> +{
> +	unsigned int hint;
> +
> +	if (virq >= 0) {
> +		virq = irq_alloc_descs(virq, virq, cnt, node);
> +	} else {
> +		hint = hwirq % nr_irqs;
> +		if (hint == 0)
> +			hint++;
> +		virq = irq_alloc_descs_from(hint, cnt, node);
> +		if (virq <= 0 && hint > 1)
> +			virq = irq_alloc_descs_from(1, cnt, node);
> +	}
> +
> +	return virq;
> +}
> +
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
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
> +	/* The outermost irq_data is embedded in struct irq_desc */
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
> + * irq_domain_get_irq_data - Get irq_data associated with @virq and @domain
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
> +	irq_data->chip = chip ? chip : &no_irq_chip;
> +	irq_data->chip_data = chip_data;
> +
> +	return 0;
> +}
> +
> +void irq_domain_reset_irq_data(struct irq_data *irq_data)
> +{
> +	irq_data->hwirq = 0;
> +	irq_data->chip = &no_irq_chip;
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
> + *
> + * The whole process to setup an IRQ has been split into two steps.
> + * The first step, __irq_domain_alloc_irqs(), is to allocate IRQ
> + * descriptor and required hardware resources. The second step,
> + * irq_domain_activate_irq(), is to program hardwares with preallocated
> + * resources. In this way, it's easier to rollback when failing to
> + * allocate resources.
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
> +	irq_free_descs(virq, nr_irqs);
> +	return ret;
> +}
> +
> +/**
> + * irq_domain_free_irqs - Free IRQ number and associated data structures
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
> +	irq_free_descs(virq, nr_irqs);
> +}
> +
> +/**
> + * irq_domain_activate_irq - Call domain_ops->activate recursively to activate
> + *			     interrupt
> + * @irq_data: outermost irq_data associated with interrupt
> + *
> + * This is the second step to call domain_ops->activate to program interrupt
> + * controllers, so the interrupt could actually get delivered.
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
> + * @irq_data: outermost irq_data associated with interrupt
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
> +
> +static void irq_domain_check_hierarchy(struct irq_domain *domain)
> +{
> +	/* Hierarchy irq_domains must implement callback alloc() */
> +	if (domain->ops->alloc)
> +		domain->flags |= IRQ_DOMAIN_FLAG_HIERARCHY;
> +}
> +#else	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
> +/**
> + * irq_domain_get_irq_data - Get irq_data associated with @virq and @domain
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
> +static void irq_domain_check_hierarchy(struct irq_domain *domain)
> +{
> +}
> +#endif	/* CONFIG_IRQ_DOMAIN_HIERARCHY */


