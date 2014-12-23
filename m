Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaLWHSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:18:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:39939 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaLWHSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:18:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="503001547"
Message-ID: <54991730.8000406@linux.intel.com>
Date: Tue, 23 Dec 2014 15:18:08 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: Dimitri Sivanich <sivanich@sgi.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: [Patch Part2 v6 22/27] x86, uv: Use hierarchy irqdomain to manage
 UV interrupts
References: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com> <1416894816-23245-23-git-send-email-jiang.liu@linux.intel.com> <20141215213735.GA8149@sgi.com> <20141216172902.GA24760@sgi.com> <5490ED6F.4040409@linux.intel.com> <20141217164532.GB25783@sgi.com>
In-Reply-To: <20141217164532.GB25783@sgi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/18 0:45, Russ Anderson wrote:
> On Wed, Dec 17, 2014 at 10:41:51AM +0800, Jiang Liu wrote:
>> On 2014/12/17 1:29, Dimitri Sivanich wrote:
>>> I answered my own question, this had never been tested on UV.
>>>
>>> The gru driver fails with:
>>>         SGI GRU Device Driver: uv_setup_irq failed, errno=22
>>>
>>> The info->type in uv_domain_alloc() is not set to X86_IRQ_ALLOC_TYPE_UV
>>> (info->type is never set to that value anywhere).
>>>
>>> Adding the following to uv_setup_irq allows it to work:
>>>
>>> --- linux.orig/arch/x86/platform/uv/uv_irq.c
>>> +++ linux/arch/x86/platform/uv/uv_irq.c
>>> @@ -187,6 +187,7 @@ int uv_setup_irq(char *irq_name, int cpu
>>>                 return -ENOMEM;
>>>
>>>         init_irq_alloc_info(&info, cpumask_of(cpu));
>>> +       info.type = X86_IRQ_ALLOC_TYPE_UV;
>>>         info.uv_limit = limit;
>>>         info.uv_blade = mmr_blade;
>>>         info.uv_offset = mmr_offset;
>>>
>>> On Mon, Dec 15, 2014 at 03:37:35PM -0600, Dimitri Sivanich wrote:
>> Hi Dimitri,
>> 	Thanks for reporting and fixing this bug. We will rebase the
>> tip/x86/apic branch and fold the above patch into the original patch.
>> May I assume a Tested-by from you? I have no UV systems for testing.
> 
> 287 lines of change in uv_irq.c completely untested in linux-next?  Ouch.
> 
> Dimitri tested the one line change above, because the driver would
> not even load without it.  It will take some time to look through
> your extensive changes to understand and verify it works.
Hi Anderson,
	The whole patch set has been exposed to linux-next through
tip/x86/apic, but not sure why this bug hasn't been discovered.
Will Cc you and Dimitri next time.
Regards!
Gerry

> 
> Thanks.
> 
>> Regards!
>> Gerry
>>
>>>> Was this patch ever tested on a UV system?
>>>>
>>>> Also, adding some SGI folks to the CC list, since there were none listed before.
>>>>
>>>> On Tue, Nov 25, 2014 at 01:53:31PM +0800, Jiang Liu wrote:
>>>>> Enhance UV code to support hierarchy irqdomain, it helps to make
>>>>> the architecture more clear.
>>>>>
>>>>> We should construct hwirq based on mmr_blade and mmr_offset, but
>>>>> mmr_offset is type of unsigned long, it may exceed the range of
>>>>> irq_hw_number_t. So help about the way to construct hwirq based
>>>>> on mmr_blade and mmr_offset is welcomed!
>>>>>
>>>>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>>>> ---
>>>>>  arch/x86/include/asm/hw_irq.h |    9 ++
>>>>>  arch/x86/platform/uv/uv_irq.c |  287 ++++++++++++++++-------------------------
>>>>>  2 files changed, 117 insertions(+), 179 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
>>>>> index 46dec7e37829..bbf90fe2a224 100644
>>>>> --- a/arch/x86/include/asm/hw_irq.h
>>>>> +++ b/arch/x86/include/asm/hw_irq.h
>>>>> @@ -123,6 +123,7 @@ enum irq_alloc_type {
>>>>>  	X86_IRQ_ALLOC_TYPE_MSI,
>>>>>  	X86_IRQ_ALLOC_TYPE_MSIX,
>>>>>  	X86_IRQ_ALLOC_TYPE_DMAR,
>>>>> +	X86_IRQ_ALLOC_TYPE_UV,
>>>>>  };
>>>>>  
>>>>>  struct irq_alloc_info {
>>>>> @@ -169,6 +170,14 @@ struct irq_alloc_info {
>>>>>  			void		*ht_update;
>>>>>  		};
>>>>>  #endif
>>>>> +#ifdef	CONFIG_X86_UV
>>>>> +		struct {
>>>>> +			int		uv_limit;
>>>>> +			int		uv_blade;
>>>>> +			unsigned long	uv_offset;
>>>>> +			char		*uv_name;
>>>>> +		};
>>>>> +#endif
>>>>>  	};
>>>>>  };
>>>>>  
>>>>> diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
>>>>> index 474912d03f40..c237ed34a498 100644
>>>>> --- a/arch/x86/platform/uv/uv_irq.c
>>>>> +++ b/arch/x86/platform/uv/uv_irq.c
>>>>> @@ -19,17 +19,31 @@
>>>>>  #include <asm/uv/uv_hub.h>
>>>>>  
>>>>>  /* MMR offset and pnode of hub sourcing interrupts for a given irq */
>>>>> -struct uv_irq_2_mmr_pnode{
>>>>> -	struct rb_node		list;
>>>>> +struct uv_irq_2_mmr_pnode {
>>>>>  	unsigned long		offset;
>>>>>  	int			pnode;
>>>>> -	int			irq;
>>>>>  };
>>>>>  
>>>>> -static DEFINE_SPINLOCK(uv_irq_lock);
>>>>> -static struct rb_root		uv_irq_root;
>>>>> +static void uv_program_mmr(struct irq_cfg *cfg, struct uv_irq_2_mmr_pnode *info)
>>>>> +{
>>>>> +	unsigned long mmr_value;
>>>>> +	struct uv_IO_APIC_route_entry *entry;
>>>>> +
>>>>> +	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
>>>>> +		     sizeof(unsigned long));
>>>>> +
>>>>> +	mmr_value = 0;
>>>>> +	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
>>>>> +	entry->vector		= cfg->vector;
>>>>> +	entry->delivery_mode	= apic->irq_delivery_mode;
>>>>> +	entry->dest_mode	= apic->irq_dest_mode;
>>>>> +	entry->polarity		= 0;
>>>>> +	entry->trigger		= 0;
>>>>> +	entry->mask		= 0;
>>>>> +	entry->dest		= cfg->dest_apicid;
>>>>>  
>>>>> -static int uv_set_irq_affinity(struct irq_data *, const struct cpumask *, bool);
>>>>> +	uv_write_global_mmr64(info->pnode, info->offset, mmr_value);
>>>>> +}
>>>>>  
>>>>>  static void uv_noop(struct irq_data *data) { }
>>>>>  
>>>>> @@ -38,6 +52,24 @@ static void uv_ack_apic(struct irq_data *data)
>>>>>  	ack_APIC_irq();
>>>>>  }
>>>>>  
>>>>> +static int
>>>>> +uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
>>>>> +		    bool force)
>>>>> +{
>>>>> +	struct irq_data *parent = data->parent_data;
>>>>> +	struct irq_cfg *cfg = irqd_cfg(data);
>>>>> +	int ret;
>>>>> +
>>>>> +	ret = parent->chip->irq_set_affinity(parent, mask, force);
>>>>> +	if (ret >= 0) {
>>>>> +		uv_program_mmr(cfg, data->chip_data);
>>>>> +		if (cfg->move_in_progress)
>>>>> +			send_cleanup_vector(cfg);
>>>>> +	}
>>>>> +
>>>>> +	return ret;
>>>>> +}
>>>>> +
>>>>>  static struct irq_chip uv_irq_chip = {
>>>>>  	.name			= "UV-CORE",
>>>>>  	.irq_mask		= uv_noop,
>>>>> @@ -46,179 +78,99 @@ static struct irq_chip uv_irq_chip = {
>>>>>  	.irq_set_affinity	= uv_set_irq_affinity,
>>>>>  };
>>>>>  
>>>>> -/*
>>>>> - * Add offset and pnode information of the hub sourcing interrupts to the
>>>>> - * rb tree for a specific irq.
>>>>> - */
>>>>> -static int uv_set_irq_2_mmr_info(int irq, unsigned long offset, unsigned blade)
>>>>> +static int uv_domain_alloc(struct irq_domain *domain, unsigned int virq,
>>>>> +			   unsigned int nr_irqs, void *arg)
>>>>>  {
>>>>> -	struct rb_node **link = &uv_irq_root.rb_node;
>>>>> -	struct rb_node *parent = NULL;
>>>>> -	struct uv_irq_2_mmr_pnode *n;
>>>>> -	struct uv_irq_2_mmr_pnode *e;
>>>>> -	unsigned long irqflags;
>>>>> -
>>>>> -	n = kmalloc_node(sizeof(struct uv_irq_2_mmr_pnode), GFP_KERNEL,
>>>>> -				uv_blade_to_memory_nid(blade));
>>>>> -	if (!n)
>>>>> +	struct uv_irq_2_mmr_pnode *chip_data;
>>>>> +	struct irq_alloc_info *info = arg;
>>>>> +	struct irq_data *irq_data = irq_domain_get_irq_data(domain, virq);
>>>>> +	int ret;
>>>>> +
>>>>> +	if (nr_irqs > 1 || !info || info->type != X86_IRQ_ALLOC_TYPE_UV)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	chip_data = kmalloc_node(sizeof(*chip_data), GFP_KERNEL,
>>>>> +				 irq_data->node);
>>>>> +	if (!chip_data)
>>>>>  		return -ENOMEM;
>>>>>  
>>>>> -	n->irq = irq;
>>>>> -	n->offset = offset;
>>>>> -	n->pnode = uv_blade_to_pnode(blade);
>>>>> -	spin_lock_irqsave(&uv_irq_lock, irqflags);
>>>>> -	/* Find the right place in the rbtree: */
>>>>> -	while (*link) {
>>>>> -		parent = *link;
>>>>> -		e = rb_entry(parent, struct uv_irq_2_mmr_pnode, list);
>>>>> -
>>>>> -		if (unlikely(irq == e->irq)) {
>>>>> -			/* irq entry exists */
>>>>> -			e->pnode = uv_blade_to_pnode(blade);
>>>>> -			e->offset = offset;
>>>>> -			spin_unlock_irqrestore(&uv_irq_lock, irqflags);
>>>>> -			kfree(n);
>>>>> -			return 0;
>>>>> -		}
>>>>> -
>>>>> -		if (irq < e->irq)
>>>>> -			link = &(*link)->rb_left;
>>>>> +	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
>>>>> +	if (ret >= 0) {
>>>>> +		if (info->uv_limit == UV_AFFINITY_CPU)
>>>>> +			irq_set_status_flags(virq, IRQ_NO_BALANCING);
>>>>>  		else
>>>>> -			link = &(*link)->rb_right;
>>>>> +			irq_set_status_flags(virq, IRQ_MOVE_PCNTXT);
>>>>> +
>>>>> +		chip_data->pnode = uv_blade_to_pnode(info->uv_blade);
>>>>> +		chip_data->offset = info->uv_offset;
>>>>> +		irq_domain_set_info(domain, virq, virq, &uv_irq_chip, chip_data,
>>>>> +				    handle_percpu_irq, NULL, info->uv_name);
>>>>> +	} else {
>>>>> +		kfree(chip_data);
>>>>>  	}
>>>>>  
>>>>> -	/* Insert the node into the rbtree. */
>>>>> -	rb_link_node(&n->list, parent, link);
>>>>> -	rb_insert_color(&n->list, &uv_irq_root);
>>>>> -
>>>>> -	spin_unlock_irqrestore(&uv_irq_lock, irqflags);
>>>>> -	return 0;
>>>>> +	return ret;
>>>>>  }
>>>>>  
>>>>> -/* Retrieve offset and pnode information from the rb tree for a specific irq */
>>>>> -int uv_irq_2_mmr_info(int irq, unsigned long *offset, int *pnode)
>>>>> +static void uv_domain_free(struct irq_domain *domain, unsigned int virq,
>>>>> +			   unsigned int nr_irqs)
>>>>>  {
>>>>> -	struct uv_irq_2_mmr_pnode *e;
>>>>> -	struct rb_node *n;
>>>>> -	unsigned long irqflags;
>>>>> -
>>>>> -	spin_lock_irqsave(&uv_irq_lock, irqflags);
>>>>> -	n = uv_irq_root.rb_node;
>>>>> -	while (n) {
>>>>> -		e = rb_entry(n, struct uv_irq_2_mmr_pnode, list);
>>>>> -
>>>>> -		if (e->irq == irq) {
>>>>> -			*offset = e->offset;
>>>>> -			*pnode = e->pnode;
>>>>> -			spin_unlock_irqrestore(&uv_irq_lock, irqflags);
>>>>> -			return 0;
>>>>> -		}
>>>>> -
>>>>> -		if (irq < e->irq)
>>>>> -			n = n->rb_left;
>>>>> -		else
>>>>> -			n = n->rb_right;
>>>>> -	}
>>>>> -	spin_unlock_irqrestore(&uv_irq_lock, irqflags);
>>>>> -	return -1;
>>>>> +	struct irq_data *irq_data = irq_domain_get_irq_data(domain, virq);
>>>>> +
>>>>> +	BUG_ON(nr_irqs != 1);
>>>>> +	kfree(irq_data->chip_data);
>>>>> +	irq_clear_status_flags(virq, IRQ_MOVE_PCNTXT);
>>>>> +	irq_clear_status_flags(virq, IRQ_NO_BALANCING);
>>>>> +	irq_domain_free_irqs_top(domain, virq, nr_irqs);
>>>>>  }
>>>>>  
>>>>>  /*
>>>>>   * Re-target the irq to the specified CPU and enable the specified MMR located
>>>>>   * on the specified blade to allow the sending of MSIs to the specified CPU.
>>>>>   */
>>>>> -static int
>>>>> -arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
>>>>> -		       unsigned long mmr_offset, int limit)
>>>>> +static void uv_domain_activate(struct irq_domain *domain,
>>>>> +			       struct irq_data *irq_data)
>>>>>  {
>>>>> -	struct irq_cfg *cfg = irq_cfg(irq);
>>>>> -	unsigned long mmr_value;
>>>>> -	struct uv_IO_APIC_route_entry *entry;
>>>>> -	int mmr_pnode;
>>>>> -
>>>>> -	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
>>>>> -			sizeof(unsigned long));
>>>>> -
>>>>> -	if (limit == UV_AFFINITY_CPU)
>>>>> -		irq_set_status_flags(irq, IRQ_NO_BALANCING);
>>>>> -	else
>>>>> -		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
>>>>> -
>>>>> -	irq_set_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
>>>>> -				      irq_name);
>>>>> -
>>>>> -	mmr_value = 0;
>>>>> -	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
>>>>> -	entry->vector		= cfg->vector;
>>>>> -	entry->delivery_mode	= apic->irq_delivery_mode;
>>>>> -	entry->dest_mode	= apic->irq_dest_mode;
>>>>> -	entry->polarity		= 0;
>>>>> -	entry->trigger		= 0;
>>>>> -	entry->mask		= 0;
>>>>> -	entry->dest		= cfg->dest_apicid;
>>>>> -
>>>>> -	mmr_pnode = uv_blade_to_pnode(mmr_blade);
>>>>> -	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
>>>>> -
>>>>> -	if (cfg->move_in_progress)
>>>>> -		send_cleanup_vector(cfg);
>>>>> -
>>>>> -	return irq;
>>>>> +	uv_program_mmr(irqd_cfg(irq_data), irq_data->chip_data);
>>>>>  }
>>>>>  
>>>>>  /*
>>>>>   * Disable the specified MMR located on the specified blade so that MSIs are
>>>>>   * longer allowed to be sent.
>>>>>   */
>>>>> -static void arch_disable_uv_irq(int mmr_pnode, unsigned long mmr_offset)
>>>>> +static void uv_domain_deactivate(struct irq_domain *domain,
>>>>> +				 struct irq_data *irq_data)
>>>>>  {
>>>>>  	unsigned long mmr_value;
>>>>>  	struct uv_IO_APIC_route_entry *entry;
>>>>>  
>>>>> -	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
>>>>> -			sizeof(unsigned long));
>>>>> -
>>>>>  	mmr_value = 0;
>>>>>  	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
>>>>>  	entry->mask = 1;
>>>>> -
>>>>> -	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
>>>>> +	uv_program_mmr(irqd_cfg(irq_data), irq_data->chip_data);
>>>>>  }
>>>>>  
>>>>> -static int
>>>>> -uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
>>>>> -		    bool force)
>>>>> -{
>>>>> -	struct irq_cfg *cfg = irqd_cfg(data);
>>>>> -	unsigned int dest;
>>>>> -	unsigned long mmr_value, mmr_offset;
>>>>> -	struct uv_IO_APIC_route_entry *entry;
>>>>> -	int mmr_pnode;
>>>>> -
>>>>> -	if (apic_set_affinity(data, mask, &dest))
>>>>> -		return -1;
>>>>> -
>>>>> -	mmr_value = 0;
>>>>> -	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
>>>>> -
>>>>> -	entry->vector		= cfg->vector;
>>>>> -	entry->delivery_mode	= apic->irq_delivery_mode;
>>>>> -	entry->dest_mode	= apic->irq_dest_mode;
>>>>> -	entry->polarity		= 0;
>>>>> -	entry->trigger		= 0;
>>>>> -	entry->mask		= 0;
>>>>> -	entry->dest		= dest;
>>>>> -
>>>>> -	/* Get previously stored MMR and pnode of hub sourcing interrupts */
>>>>> -	if (uv_irq_2_mmr_info(data->irq, &mmr_offset, &mmr_pnode))
>>>>> -		return -1;
>>>>> -
>>>>> -	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
>>>>> +static struct irq_domain_ops uv_domain_ops = {
>>>>> +	.alloc = uv_domain_alloc,
>>>>> +	.free = uv_domain_free,
>>>>> +	.activate = uv_domain_activate,
>>>>> +	.deactivate = uv_domain_deactivate,
>>>>> +};
>>>>>  
>>>>> -	if (cfg->move_in_progress)
>>>>> -		send_cleanup_vector(cfg);
>>>>> +static struct irq_domain *uv_get_irq_domain(void)
>>>>> +{
>>>>> +	static struct irq_domain *uv_domain;
>>>>> +	static DEFINE_MUTEX(uv_lock);
>>>>> +
>>>>> +	mutex_lock(&uv_lock);
>>>>> +	if (uv_domain == NULL) {
>>>>> +		uv_domain = irq_domain_add_tree(NULL, &uv_domain_ops, NULL);
>>>>> +		if (uv_domain)
>>>>> +			uv_domain->parent = x86_vector_domain;
>>>>> +	}
>>>>> +	mutex_unlock(&uv_lock);
>>>>>  
>>>>> -	return IRQ_SET_MASK_OK_NOCOPY;
>>>>> +	return uv_domain;
>>>>>  }
>>>>>  
>>>>>  /*
>>>>> @@ -229,23 +181,20 @@ uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
>>>>>  int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
>>>>>  		 unsigned long mmr_offset, int limit)
>>>>>  {
>>>>> -	int ret, irq;
>>>>>  	struct irq_alloc_info info;
>>>>> +	struct irq_domain *domain = uv_get_irq_domain();
>>>>> +
>>>>> +	if (!domain)
>>>>> +		return -ENOMEM;
>>>>>  
>>>>>  	init_irq_alloc_info(&info, cpumask_of(cpu));
>>>>> -	irq = irq_domain_alloc_irqs(NULL, 1, uv_blade_to_memory_nid(mmr_blade),
>>>>> -				    &info);
>>>>> -	if (irq <= 0)
>>>>> -		return -EBUSY;
>>>>> -
>>>>> -	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset,
>>>>> -		limit);
>>>>> -	if (ret == irq)
>>>>> -		uv_set_irq_2_mmr_info(irq, mmr_offset, mmr_blade);
>>>>> -	else
>>>>> -		irq_domain_free_irqs(irq, 1);
>>>>> +	info.uv_limit = limit;
>>>>> +	info.uv_blade = mmr_blade;
>>>>> +	info.uv_offset = mmr_offset;
>>>>> +	info.uv_name = irq_name;
>>>>>  
>>>>> -	return ret;
>>>>> +	return irq_domain_alloc_irqs(domain, 1,
>>>>> +				     uv_blade_to_memory_nid(mmr_blade), &info);
>>>>>  }
>>>>>  EXPORT_SYMBOL_GPL(uv_setup_irq);
>>>>>  
>>>>> @@ -258,26 +207,6 @@ EXPORT_SYMBOL_GPL(uv_setup_irq);
>>>>>   */
>>>>>  void uv_teardown_irq(unsigned int irq)
>>>>>  {
>>>>> -	struct uv_irq_2_mmr_pnode *e;
>>>>> -	struct rb_node *n;
>>>>> -	unsigned long irqflags;
>>>>> -
>>>>> -	spin_lock_irqsave(&uv_irq_lock, irqflags);
>>>>> -	n = uv_irq_root.rb_node;
>>>>> -	while (n) {
>>>>> -		e = rb_entry(n, struct uv_irq_2_mmr_pnode, list);
>>>>> -		if (e->irq == irq) {
>>>>> -			arch_disable_uv_irq(e->pnode, e->offset);
>>>>> -			rb_erase(n, &uv_irq_root);
>>>>> -			kfree(e);
>>>>> -			break;
>>>>> -		}
>>>>> -		if (irq < e->irq)
>>>>> -			n = n->rb_left;
>>>>> -		else
>>>>> -			n = n->rb_right;
>>>>> -	}
>>>>> -	spin_unlock_irqrestore(&uv_irq_lock, irqflags);
>>>>>  	irq_domain_free_irqs(irq, 1);
>>>>>  }
>>>>>  EXPORT_SYMBOL_GPL(uv_teardown_irq);
>>>>> -- 
>>>>> 1.7.10.4
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
> 
