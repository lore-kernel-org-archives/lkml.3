Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaJVHZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:25:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:35318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaJVHZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,767,1406617200"; 
   d="scan'208";a="593584152"
Message-ID: <54475BC0.5010006@linux.intel.com>
Date: Wed, 22 Oct 2014 15:24:48 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFT v2 01/24] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
References: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com> <1411740145-30626-2-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1411740145-30626-2-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,
	Really appreciate your time to review the hierarchy irqdomain
code at LinuxCon. During review, you mentioned your concerns about the
hint when allocating IRQ number. I have checked related code again
and current situation is:
1) For existing irq_create_mapping() interface, it still expects
   hwirq as a hint in the same way when allocating IRQ number,
   so there's should be no backward compatibility issues.
2) For new hierarchy irqdomain interface __irq_domain_alloc_irqs(),
   it has no concept of hwirq, so it's hard to respect hint when
   allocating IRQ number.
   int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
                            unsigned int nr_irqs, int node, void *arg,
                            bool realloc)
3) If caller of __irq_domain_alloc_irqs() needs special IRQ number for
   a hwirq, it should specify the required IRQ number in argument
   irq_base.

Are you ok with current design or should we teach
__irq_domain_alloc_irqs() to know about hwirq?

Thanks!
Gerry

On 2014/9/26 22:02, Jiang Liu wrote:
> We plan to use hierarchy irqdomain to suppport CPU vector assignment,
> interrupt remapping controller, IO-APIC controller, MSI interrupt
> and hypertransport interrupt etc on x86 platforms. So extend irqdomain
> interfaces to support hierarchy irqdomain.
> 
> There are already many clients of current irqdomain interfaces.
> To minimize the changes, we choose to introduce new version 2 interfaces
> to support hierarchy instead of extending existing irqdomain interfaces.
> 
> According to Thomas's suggestion, the most important design decision is
> to build hierarchy struct irq_data to support hierarchy irqdomain, so
> hierarchy irqdomain related data could be saved in struct irq_data.
> With support of hierarchy irq_data, we could also support stacked
> irq_chips. This is most useful in case of set_affinity().
> 
> The new hierarchy irqdomain introduces following interfaces:
> 1) irq_domain_alloc_irqs()/irq_domain_free_irqs(): allocate/release IRQ
>    and related resources.
> 2) __irq_domain_alloc_irqs(): a special version to support legacy IRQs.
> 3) irq_domain_activate_irq()/irq_domain_deactivate_irq(): program
>    interrupt controllers to activate/deactivate interrupt.
> 
> There are also several help functions to ease irqdomain implemenations:
> 1) irq_domain_get_irq_data(): get irq_data associated with a specific
>    irqdomain.
> 2) irq_domain_set_hwirq_and_chip(): save irqdomain specific data into
>    irq_data.
> 3) irq_domain_alloc_irqs_parent()/irq_domain_free_irqs_parent(): invoke
>    parent irqdomain's alloc/free callbacks.
> 
> We also changed irq_startup()/irq_shutdown() to invoke
> irq_domain_activate_irq()/irq_domain_deactivate_irq() to program
> interrupt controller when start/stop interrupts.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  Documentation/IRQ-domain.txt |   71 ++++++++
>  include/linux/irq.h          |    5 +
>  include/linux/irqdomain.h    |   81 +++++++++
>  kernel/irq/Kconfig           |    3 +
>  kernel/irq/chip.c            |    3 +
>  kernel/irq/irqdomain.c       |  372 ++++++++++++++++++++++++++++++++++++++++--
>  6 files changed, 520 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
> index 8a8b82c9ca53..39cfa72732ff 100644
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
> +2) irq_domain_free_irqs(): free IRQ descriptors and interrupt controller
> +   related resources associated with these interrupts.
> +3) irq_domain_activate_irq(): activate interrupt controller hardware to
> +   deliver the interrupt.
> +3) irq_domain_deactivate_irq(): deactivate interrupt controller hardware
> +   to stop delivering the interrupt.
> +
> +Following changes are needed to support hierarchy irq_domain.
> +1) a new field 'parent' is added to struct irq_domain; it's used to
> +   maintain irq_domain hierarchy information.
> +2) a new field 'parent_data' is added to struct irq_data; it's used to
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
> +parent irq_chip when needed. So we could achieve a much cleaner
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
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 62af59242ddc..b1aa23eea711 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -133,6 +133,8 @@ struct irq_domain;
>   * @chip:		low level interrupt hardware access
>   * @domain:		Interrupt translation domain; responsible for mapping
>   *			between hwirq number and linux irq number.
> + * @parent_data:	pointer to parent struct irq_data to support hierarchy
> + *			irq_domain
>   * @handler_data:	per-IRQ data for the irq_chip methods
>   * @chip_data:		platform-specific per-chip private data for the chip
>   *			methods, to allow shared chip implementations
> @@ -151,6 +153,9 @@ struct irq_data {
>  	unsigned int		state_use_accessors;
>  	struct irq_chip		*chip;
>  	struct irq_domain	*domain;
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +	struct irq_data		*parent_data;
> +#endif
>  	void			*handler_data;
>  	void			*chip_data;
>  	struct msi_desc		*msi_desc;
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index b0f9d16e48f6..b20b34b1a8ea 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -38,6 +38,8 @@
>  struct device_node;
>  struct irq_domain;
>  struct of_device_id;
> +struct irq_chip;
> +struct irq_data;
>  
>  /* Number of irqs reserved for a legacy isa controller */
>  #define NUM_ISA_INTERRUPTS	16
> @@ -64,6 +66,16 @@ struct irq_domain_ops {
>  	int (*xlate)(struct irq_domain *d, struct device_node *node,
>  		     const u32 *intspec, unsigned int intsize,
>  		     unsigned long *out_hwirq, unsigned int *out_type);
> +
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +	/* extended V2 interfaces to support hierarchy irq_domains */
> +	int (*alloc)(struct irq_domain *d, unsigned int virq,
> +		     unsigned int nr_irqs, void *arg);
> +	void (*free)(struct irq_domain *d, unsigned int virq,
> +		     unsigned int nr_irqs);
> +	int (*activate)(struct irq_domain *d, struct irq_data *irq_data);
> +	int (*deactivate)(struct irq_domain *d, struct irq_data *irq_data);
> +#endif
>  };
>  
>  extern struct irq_domain_ops irq_generic_chip_ops;
> @@ -77,6 +89,7 @@ struct irq_domain_chip_generic;
>   * @ops: pointer to irq_domain methods
>   * @host_data: private data pointer for use by owner.  Not touched by irq_domain
>   *             core code.
> + * @flags: host per irq_domain flags
>   *
>   * Optional elements
>   * @of_node: Pointer to device tree nodes associated with the irq_domain. Used
> @@ -84,6 +97,7 @@ struct irq_domain_chip_generic;
>   * @gc: Pointer to a list of generic chips. There is a helper function for
>   *      setting up one or more generic chips for interrupt controllers
>   *      drivers using the generic chip library which uses this pointer.
> + * @parent: Pointer to parent irq_domain to support hierarchy irq_domains
>   *
>   * Revmap data, used internally by irq_domain
>   * @revmap_direct_max_irq: The largest hwirq that can be set for controllers that
> @@ -97,10 +111,14 @@ struct irq_domain {
>  	const char *name;
>  	const struct irq_domain_ops *ops;
>  	void *host_data;
> +	unsigned int flags;
>  
>  	/* Optional data */
>  	struct device_node *of_node;
>  	struct irq_domain_chip_generic *gc;
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +	struct irq_domain *parent;
> +#endif
>  
>  	/* reverse map data. The linear map gets appended to the irq_domain */
>  	irq_hw_number_t hwirq_max;
> @@ -110,6 +128,9 @@ struct irq_domain {
>  	unsigned int linear_revmap[];
>  };
>  
> +#define	IRQ_DOMAIN_FLAG_HIERARCHY	0x1
> +#define	IRQ_DOMAIN_FLAG_ARCH1		0x10000
> +
>  #ifdef CONFIG_IRQ_DOMAIN
>  struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
>  				    irq_hw_number_t hwirq_max, int direct_max,
> @@ -220,8 +241,68 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
>  			const u32 *intspec, unsigned int intsize,
>  			irq_hw_number_t *out_hwirq, unsigned int *out_type);
>  
> +/* V2 interfaces to support hierarchy IRQ domains. */
> +extern struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
> +						unsigned int virq);
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +extern int irq_domain_set_hwirq_and_chip(struct irq_domain *domain,
> +					 unsigned int virq,
> +					 irq_hw_number_t hwirq,
> +					 struct irq_chip *chip,
> +					 void *chip_data);
> +extern void irq_domain_reset_irq_data(struct irq_data *irq_data);
> +extern int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
> +				   unsigned int nr_irqs, int node, void *arg,
> +				   bool realloc);
> +extern void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs);
> +extern int irq_domain_activate_irq(struct irq_data *irq_data);
> +extern int irq_domain_deactivate_irq(struct irq_data *irq_data);
> +
> +static inline int irq_domain_alloc_irqs(struct irq_domain *domain,
> +			unsigned int nr_irqs, int node, void *arg)
> +{
> +	return __irq_domain_alloc_irqs(domain, -1, nr_irqs, node, arg, false);
> +}
> +
> +static inline int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
> +				int irq_base, unsigned int nr_irqs, void *arg)
> +{
> +	if (domain->parent && domain->parent->ops->alloc)
> +		return domain->parent->ops->alloc(domain->parent, irq_base,
> +						  nr_irqs, arg);
> +	return -ENOSYS;
> +}
> +
> +static inline void irq_domain_free_irqs_parent(struct irq_domain *domain,
> +					int irq_base, unsigned int nr_irqs)
> +{
> +	if (domain->parent && domain->parent->ops->free)
> +		domain->parent->ops->free(domain->parent, irq_base, nr_irqs);
> +}
> +
> +static inline bool irq_domain_is_hierarchy(struct irq_domain *domain)
> +{
> +	return domain->flags & IRQ_DOMAIN_FLAG_HIERARCHY;
> +}
> +#else	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
> +static inline int irq_domain_activate_irq(struct irq_data *data) { return 0; }
> +static inline int irq_domain_deactivate_irq(struct irq_data *data) { return 0; }
> +static inline int irq_domain_alloc_irqs(struct irq_domain *domain,
> +			unsigned int nr_irqs, int node, void *arg)
> +{
> +	return -1;
> +}
> +
> +static inline bool irq_domain_is_hierarchy(struct irq_domain *domain)
> +{
> +	return false;
> +}
> +#endif	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
> +
>  #else /* CONFIG_IRQ_DOMAIN */
>  static inline void irq_dispose_mapping(unsigned int virq) { }
> +static inline int irq_domain_activate_irq(struct irq_data *data) { return 0; }
> +static inline int irq_domain_deactivate_irq(struct irq_data *data) { return 0; }
>  #endif /* !CONFIG_IRQ_DOMAIN */
>  
>  #endif /* _LINUX_IRQDOMAIN_H */
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
>  config IRQ_DOMAIN_DEBUG
>  	bool "Expose hardware/virtual IRQ mapping via debugfs"
>  	depends on IRQ_DOMAIN && DEBUG_FS
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 6223fab9a9d2..46bd5e2190c3 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
> +#include <linux/irqdomain.h>
>  
>  #include <trace/events/irq.h>
>  
> @@ -178,6 +179,7 @@ int irq_startup(struct irq_desc *desc, bool resend)
>  	irq_state_clr_disabled(desc);
>  	desc->depth = 0;
>  
> +	irq_domain_activate_irq(&desc->irq_data);
>  	if (desc->irq_data.chip->irq_startup) {
>  		ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
>  		irq_state_clr_masked(desc);
> @@ -199,6 +201,7 @@ void irq_shutdown(struct irq_desc *desc)
>  		desc->irq_data.chip->irq_disable(&desc->irq_data);
>  	else
>  		desc->irq_data.chip->irq_mask(&desc->irq_data);
> +	irq_domain_deactivate_irq(&desc->irq_data);
>  	irq_state_set_masked(desc);
>  }
>  
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 6534ff6ce02e..584be46c899e 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -23,6 +23,10 @@ static DEFINE_MUTEX(irq_domain_mutex);
>  static DEFINE_MUTEX(revmap_trees_mutex);
>  static struct irq_domain *irq_default_domain;
>  
> +static int irq_domain_alloc_descs(int virq, unsigned int nr_irqs,
> +				  irq_hw_number_t hwirq, int node);
> +static void irq_domain_check_hierarchy(struct irq_domain *domain);
> +
>  /**
>   * __irq_domain_add() - Allocate a new irq_domain data structure
>   * @of_node: optional device-tree node of the interrupt controller
> @@ -30,7 +34,7 @@ static struct irq_domain *irq_default_domain;
>   * @hwirq_max: Maximum number of interrupts supported by controller
>   * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
>   *              direct mapping
> - * @ops: map/unmap domain callbacks
> + * @ops: domain callbacks
>   * @host_data: Controller private data pointer
>   *
>   * Allocates and initialize and irq_domain structure.
> @@ -56,6 +60,7 @@ struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
>  	domain->hwirq_max = hwirq_max;
>  	domain->revmap_size = size;
>  	domain->revmap_direct_max_irq = direct_max;
> +	irq_domain_check_hierarchy(domain);
>  
>  	mutex_lock(&irq_domain_mutex);
>  	list_add(&domain->link, &irq_domain_list);
> @@ -109,7 +114,7 @@ EXPORT_SYMBOL_GPL(irq_domain_remove);
>   * @first_irq: first number of irq block assigned to the domain,
>   *	pass zero to assign irqs on-the-fly. If first_irq is non-zero, then
>   *	pre-map all of the irqs in the domain to virqs starting at first_irq.
> - * @ops: map/unmap domain callbacks
> + * @ops: domain callbacks
>   * @host_data: Controller private data pointer
>   *
>   * Allocates an irq_domain, and optionally if first_irq is positive then also
> @@ -174,10 +179,8 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
>  
>  	domain = __irq_domain_add(of_node, first_hwirq + size,
>  				  first_hwirq + size, 0, ops, host_data);
> -	if (!domain)
> -		return NULL;
> -
> -	irq_domain_associate_many(domain, first_irq, first_hwirq, size);
> +	if (domain)
> +		irq_domain_associate_many(domain, first_irq, first_hwirq, size);
>  
>  	return domain;
>  }
> @@ -388,7 +391,6 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
>  unsigned int irq_create_mapping(struct irq_domain *domain,
>  				irq_hw_number_t hwirq)
>  {
> -	unsigned int hint;
>  	int virq;
>  
>  	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
> @@ -410,12 +412,8 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  	}
>  
>  	/* Allocate a virtual interrupt number */
> -	hint = hwirq % nr_irqs;
> -	if (hint == 0)
> -		hint++;
> -	virq = irq_alloc_desc_from(hint, of_node_to_nid(domain->of_node));
> -	if (virq <= 0)
> -		virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
> +	virq = irq_domain_alloc_descs(-1, 1, hwirq,
> +				      of_node_to_nid(domain->of_node));
>  	if (virq <= 0) {
>  		pr_debug("-> virq allocation failed\n");
>  		return 0;
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
>  
> @@ -709,3 +712,342 @@ const struct irq_domain_ops irq_domain_simple_ops = {
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
> +	irq_domain_free_descs(virq, nr_irqs);
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
> +	irq_domain_free_descs(virq, nr_irqs);
> +}
> +
> +/**
> + * irq_domain_activate_irq - Call domain_ops->activate recursively to activate
> + *			     interrupt
> + * @irq_data: outermost irq_data associated with interrupt
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
> 
