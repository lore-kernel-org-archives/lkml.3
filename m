Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaLACVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 21:21:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:17742 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbaLACU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 21:20:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="491552430"
Message-ID: <547BD086.1090903@linux.intel.com>
Date: Mon, 01 Dec 2014 10:20:54 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
CC: linux-tip-commits@vger.kernel.org, matthias.bgg@gmail.com,
        tony.luck@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        wangyijing@huawei.com, marc.zyngier@arm.com, bhelgaas@google.com,
        yingjoe.chen@mediatek.com, mingo@kernel.org
Subject: Re: [tip:irq/irqdomain] irqdomain: Introduce helper function irq_domain_add_hierarchy()
References: <1416061447-9472-5-git-send-email-jiang.liu@linux.intel.com> <tip-afb7da83b9f476728623130703acb553d7c7c4d9@git.kernel.org> <20141129125319.GA6491@pd.tnic> <alpine.DEB.2.11.1411292112390.3961@nanos>
In-Reply-To: <alpine.DEB.2.11.1411292112390.3961@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/30 4:42, Thomas Gleixner wrote:
> On Sat, 29 Nov 2014, Borislav Petkov wrote:
>> So I'm seeing the lockdep splat below really early on an IVB laptop.
>>
>> Basically we're not supposed to do __GFP_FS allocations with IRQs off:
>>
>>   2737		/* We're only interested __GFP_FS allocations for now */
>>   2738		if (!(gfp_mask & __GFP_FS))
>>   2739			return;
>>   2740	
>>   2741		/*
>>   2742		 * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
>>   2743		 */
>>   2744		if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))) 			<--- HERE!
>>   2745			return;
>>   2746	
>>   2747		mark_held_locks(curr, RECLAIM_FS);
>>   2748	}
>>
>> Now, AFAICT, enable_IR_x2apic() disables interrupts and the whole init
>> is done with IRQs off but down that path intel_setup_irq_remapping()
>> calls irq_domain_add_hierarchy() and it does by default GFP_KERNEL
>> allocations.
>>
>> The obvious fix is this and the machine boots fine with it. I'm not sure
>> it is kosher though so I rather run it by people first:
>>
>> ---
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index 7fac311057b8..c21a003b996a 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -46,14 +46,18 @@ struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
>>  				    void *host_data)
>>  {
>>  	struct irq_domain *domain;
>> +	gfp_t gfp_flags = GFP_KERNEL;
>> +
>> +	if (irqs_disabled())
>> +		gfp_flags = GFP_NOFS;
> 
> We want to use GFP_ATOMIC for that, but I really hate to do so. There
> is no reason except for the early boot stage to call into this code
> with interrupts disabled. And there we are covered by gfp_allowed_mask,
> so that a GFP_KERNEL allocation can succeed.
> 
> I have no idea, why enable_IR_x2apic() has been bolted into
> smp_prepare_cpus(). Probably just because.
> 
> There is no reason WHY this cannot be done in the early irq setup path
> (at least nowadays with the allocators being available early), but
> that is another area which needs some care and cleanup, but definitely
> too late before the 3.19 merge window opens.
Hi Thomas,
	I will have a look at this after 3.19 merge window:)

> 
> So we have to bite the bullet and apply something like this along with
> a big fat comment WHY we are doing so and I'm tempted to wrap this
> into a #ifdef CONFIG_X86 so that noone else thinks that calling this
> code with interrupts disabled - except for the early boot stage - is a
> brilliant idea.
> 
> Thanks,
> 
> 	tglx
> 
