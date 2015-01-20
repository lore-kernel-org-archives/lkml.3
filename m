Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbbATKDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:03:04 -0500
Received: from mga14.intel.com ([192.55.52.115]:1242 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbbATKCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:02:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,433,1418112000"; 
   d="scan'208";a="514755951"
Message-ID: <54BE27BC.3070705@linux.intel.com>
Date: Tue, 20 Jan 2015 18:02:36 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Marc Zyngier <marc.zyngier@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposal about reorganize struct irq_data and struct irq_desc
References: <54BD1256.1020406@linux.intel.com> <alpine.DEB.2.11.1501200950370.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501200950370.5526@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2015/1/20 17:31, Thomas Gleixner wrote:
> On Mon, 19 Jan 2015, Jiang Liu wrote:
> 
>> Hi Thomas and Marc,
>> 	During working on the generic MSI support, I have some proposal
>> about reorganizing struct irq_data and struct irq_desc. The proposed
>> changes are:
>> 1) Add a pointer "struct irq_desc *" to struct irq_data, so we could
>>    quickly get struct irq_desc from struct irq_data.
>> 2) Move "node" from struct irq_data into struct irq_desc, NUMA info
>>    should be per-irq instead of per-chip.
>> 3) Move "affinity" from struct irq_data into struct irq_desc, NUMA info
>>    should be per-irq instead of per-chip.
>> 4) Move "msi_desc" from struct irq_data into struct irq_desc. (Not sure
>>    whether we should do this. Theoretically we should use
>>    irq_data->handler_data to store msi_desc.)
> 
> msi_desc belongs to the msi chip, while handler_data is common data.
> 
> I had a look at the usage sites of handler_data. Most of them use it
> in combination with chained handlers. Some sites use it instead of
> chip data and only a few use it for some random other stuff, where the
> x86 sites (hpet, ht, iommu ...) will go away with the irqdomain
> conversion.
> 
> So in the long run we should provide:
> 
>    irq_set_chained_handler_and_data(irq, handler, handler_data)
> 
> convert everything over and finally remove the direct accessor to
> handler_data.
> 
> msi_desc in a hierarchical implementation should actually be in
> chip_data, but we probably need to keep the msi_desc pointer for
> backward compability reasons.
> 
>> With above change applied, struct irq_data only hosts per-chip data, and
>> struct irq_desc hosts per-irq data. What's your thoughts?
> 
> I'm not so happy with exposing irqdesc to random code again. I went a
> great way to hide it from abuse.
> 
> So I'd rather like to see something like this:
> 
> struct irq_common_data {
> 	unsigned int		state_use_accessors;
> 	unsigned int		node;
> 	void			*handler_data;
> 	cpumask_var_t		affinity;
> };
> 
> struct irq_data {
> 	u32			mask;
> 	unsigned int		irq;
> 	unsigned long		hwirq;
> 	struct irq_chip		*chip;
> 	struct irq_domain	*domain;
> #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> 	struct irq_data		*parent_data;
> #endif
> 	void			*chip_data;
> 	struct msi_desc		*msi_desc;
> 	struct irq_common_data	*common_data;
> };
> 
> struct irq_desc {
>        struct irq_data		irq_data;
>        struct common_irq_data	common_data;
>        ...
> };
Great, will go this step by step:)

> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
