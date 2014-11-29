Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaK2O3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 09:29:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:31502 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaK2O3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 09:29:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,483,1413270000"; 
   d="scan'208";a="615868942"
Message-ID: <5479D84D.7000500@linux.intel.com>
Date: Sat, 29 Nov 2014 22:29:33 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-tip-commits@vger.kernel.org, matthias.bgg@gmail.com,
        tony.luck@intel.com, tglx@linutronix.de, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        wangyijing@huawei.com, marc.zyngier@arm.com, bhelgaas@google.com,
        yingjoe.chen@mediatek.com, mingo@kernel.org
Subject: Re: [tip:irq/irqdomain] irqdomain: Introduce helper function irq_domain_add_hierarchy()
References: <1416061447-9472-5-git-send-email-jiang.liu@linux.intel.com> <tip-afb7da83b9f476728623130703acb553d7c7c4d9@git.kernel.org> <20141129125319.GA6491@pd.tnic>
In-Reply-To: <20141129125319.GA6491@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/29 20:53, Borislav Petkov wrote:
> On Sun, Nov 23, 2014 at 10:11:44AM -0800, tip-bot for Jiang Liu wrote:
>> Commit-ID:  afb7da83b9f476728623130703acb553d7c7c4d9
>> Gitweb:     http://git.kernel.org/tip/afb7da83b9f476728623130703acb553d7c7c4d9
>> Author:     Jiang Liu <jiang.liu@linux.intel.com>
>> AuthorDate: Sat, 15 Nov 2014 22:24:02 +0800
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> CommitDate: Sun, 23 Nov 2014 13:01:46 +0100
>>
>> irqdomain: Introduce helper function irq_domain_add_hierarchy()
>>
>> Introduce helper function irq_domain_add_hierarchy(), which creates
>> a linear irqdomain if parameter 'size' is not zero, otherwise creates
>> a tree irqdomain.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Yijing Wang <wangyijing@huawei.com>
>> Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Matthias Brugger <matthias.bgg@gmail.com>
>> Link: http://lkml.kernel.org/r/1416061447-9472-5-git-send-email-jiang.liu@linux.intel.com
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  include/linux/irqdomain.h |  4 ++++
>>  kernel/irq/irqdomain.c    | 36 ++++++++++++++++++++++++++++++++++++
>>  2 files changed, 40 insertions(+)
>>
>> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
>> index dd2709b..676d730 100644
>> --- a/include/linux/irqdomain.h
>> +++ b/include/linux/irqdomain.h
>> @@ -259,6 +259,10 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
>>  extern struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
>>  						unsigned int virq);
>>  #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>> +extern struct irq_domain *irq_domain_add_hierarchy(struct irq_domain *parent,
>> +			unsigned int flags, unsigned int size,
>> +			struct device_node *node,
>> +			const struct irq_domain_ops *ops, void *host_data);
>>  extern int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
>>  				   unsigned int nr_irqs, int node, void *arg,
>>  				   bool realloc);
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index 9c88db7..7fac311 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -742,6 +742,42 @@ static int irq_domain_alloc_descs(int virq, unsigned int cnt,
>>  }
>>  
>>  #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>> +/**
>> + * irq_domain_add_hierarchy - Add a irqdomain into the hierarchy
>> + * @parent:	Parent irq domain to associate with the new domain
>> + * @flags:	Irq domain flags associated to the domain
>> + * @size:	Size of the domain. See below
>> + * @node:	Optional device-tree node of the interrupt controller
>> + * @ops:	Pointer to the interrupt domain callbacks
>> + * @host_data:	Controller private data pointer
>> + *
>> + * If @size is 0 a tree domain is created, otherwise a linear domain.
>> + *
>> + * If successful the parent is associated to the new domain and the
>> + * domain flags are set.
>> + * Returns pointer to IRQ domain, or NULL on failure.
>> + */
>> +struct irq_domain *irq_domain_add_hierarchy(struct irq_domain *parent,
>> +					    unsigned int flags,
>> +					    unsigned int size,
>> +					    struct device_node *node,
>> +					    const struct irq_domain_ops *ops,
>> +					    void *host_data)
>> +{
>> +	struct irq_domain *domain;
>> +
>> +	if (size)
>> +		domain = irq_domain_add_linear(node, size, ops, host_data);
>> +	else
>> +		domain = irq_domain_add_tree(node, ops, host_data);
>> +	if (domain) {
>> +		domain->parent = parent;
>> +		domain->flags |= flags;
>> +	}
> 
> Ok, I'm going to reply to this patch because it is on the splat path but
> fixing this would need a bit more reorganizing.
> 
> So I'm seeing the lockdep splat below really early on an IVB laptop.
> 
> Basically we're not supposed to do __GFP_FS allocations with IRQs off:
> 
>   2737		/* We're only interested __GFP_FS allocations for now */
>   2738		if (!(gfp_mask & __GFP_FS))
>   2739			return;
>   2740	
>   2741		/*
>   2742		 * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
>   2743		 */
>   2744		if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))) 			<--- HERE!
>   2745			return;
>   2746	
>   2747		mark_held_locks(curr, RECLAIM_FS);
>   2748	}
> 
> Now, AFAICT, enable_IR_x2apic() disables interrupts and the whole init
> is done with IRQs off but down that path intel_setup_irq_remapping()
> calls irq_domain_add_hierarchy() and it does by default GFP_KERNEL
> allocations.
> 
> The obvious fix is this and the machine boots fine with it. I'm not sure
> it is kosher though so I rather run it by people first:
> 
> ---
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 7fac311057b8..c21a003b996a 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -46,14 +46,18 @@ struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
>  				    void *host_data)
>  {
>  	struct irq_domain *domain;
> +	gfp_t gfp_flags = GFP_KERNEL;
> +
> +	if (irqs_disabled())
> +		gfp_flags = GFP_NOFS;
Hi Borislav,
	Thanks for reporting and fixing this. How about using
GFP_ATOMIC here?
Regards!
Gerry

>  
>  	domain = kzalloc_node(sizeof(*domain) + (sizeof(unsigned int) * size),
> -			      GFP_KERNEL, of_node_to_nid(of_node));
> +			      gfp_flags, of_node_to_nid(of_node));
>  	if (WARN_ON(!domain))
>  		return NULL;
>  
>  	/* Fill structure */
> -	INIT_RADIX_TREE(&domain->revmap_tree, GFP_KERNEL);
> +	INIT_RADIX_TREE(&domain->revmap_tree, gfp_flags);
>  	domain->ops = ops;
>  	domain->host_data = host_data;
>  	domain->of_node = of_node_get(of_node);
> --
> 
> 
> [    0.085221] dmar: Host address width 36
> [    0.085298] dmar: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.085414] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
> [    0.085513] dmar: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.085598] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
> [    0.085693] dmar: RMRR base: 0x000000da2ba000 end: 0x000000da2d0fff
> [    0.085789] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
> [    0.085955] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
> [    0.086034] HPET id 0 under DRHD base 0xfed91000
> [    0.086109] Queued invalidation will be enabled to support x2apic and Intr-remapping.
> [    0.086351] ------------[ cut here ]------------
> [    0.086438] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:2744 lockdep_trace_alloc+0xd4/0xe0()
> [    0.086537] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
> [    0.086598] Modules linked in:
> [    0.086783] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc6+ #1
> [    0.086863] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
> [    0.086959]  0000000000000009 ffff880213d07b58 ffffffff816502d7 0000000000000000
> [    0.087240]  ffff880213d07ba8 ffff880213d07b98 ffffffff81059790 0000000000000001
> [    0.087521]  0000000000000092 0000000000000000 00000000000080d0 0000000000000000
> [    0.087803] Call Trace:
> [    0.087878]  [<ffffffff816502d7>] dump_stack+0x4f/0x7b
> [    0.087960]  [<ffffffff81059790>] warn_slowpath_common+0x80/0xa0
> [    0.088041]  [<ffffffff810597f6>] warn_slowpath_fmt+0x46/0x50
> [    0.088124]  [<ffffffff810a5514>] lockdep_trace_alloc+0xd4/0xe0
> [    0.088208]  [<ffffffff8114877f>] __alloc_pages_nodemask+0x7f/0x970
> [    0.088291]  [<ffffffff81148158>] ? get_page_from_freelist+0x5b8/0x980
> [    0.088375]  [<ffffffff8109f72f>] ? trace_hardirqs_off_caller+0x1f/0xc0
> [    0.088457]  [<ffffffff811490af>] alloc_kmem_pages_node+0x3f/0x60
> [    0.088542]  [<ffffffff8119280e>] kmalloc_large_node+0x2e/0x70
> [    0.088622]  [<ffffffff811989a5>] __kmalloc_node+0x215/0x2b0
> [    0.088707]  [<ffffffff81539c10>] ? __dmar_enable_qi+0x40/0x130
> [    0.088789]  [<ffffffff810bafe1>] __irq_domain_add+0x41/0x110
> [    0.088871]  [<ffffffff810bb553>] irq_domain_add_hierarchy+0x23/0x50
> [    0.088952]  [<ffffffff81651f33>] intel_setup_irq_remapping.part.4+0xdc/0x169
> [    0.089039]  [<ffffffff81d61123>] intel_enable_irq_remapping+0x240/0x2f9
> [    0.089123]  [<ffffffff81d61315>] irq_remapping_enable+0x20/0x36
> [    0.089208]  [<ffffffff81d2cbaf>] enable_IR+0x3c/0x3e
> [    0.089288]  [<ffffffff81d2cd92>] enable_IR_x2apic+0x82/0x120
> [    0.089369]  [<ffffffff81d2e614>] default_setup_apic_routing+0x12/0x6b
> [    0.089453]  [<ffffffff81d2aadc>] native_smp_prepare_cpus+0x29b/0x39f
> [    0.089538]  [<ffffffff81d1df5d>] kernel_init_freeable+0x5f/0x1a2
> [    0.089622]  [<ffffffff8165933f>] ? ret_from_fork+0xf/0xb0
> [    0.089705]  [<ffffffff8164a640>] ? rest_init+0xd0/0xd0
> [    0.089787]  [<ffffffff8164a64e>] kernel_init+0xe/0xf0
> [    0.089867]  [<ffffffff816593ac>] ret_from_fork+0x7c/0xb0
> [    0.089948]  [<ffffffff8164a640>] ? rest_init+0xd0/0xd0
> [    0.090032] ---[ end trace fac50e785fc22942 ]---
> [    0.090387] Enabled IRQ remapping in x2apic mode
> [    0.090466] Enabling x2apic
> [    0.090537] Enabled x2apic
> [    0.090630] Switched APIC routing to cluster x2apic.
> [    0.091287] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.101375] smpboot: CPU0: Intel(R) Core(TM) i7-3520M CPU @ 2.90GHz (fam: 06, model: 3a, stepping: 09)
> 
> 
