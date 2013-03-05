Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3CEHUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:20:13 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48009 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab3CEHUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:20:11 -0500
Message-ID: <51359C9D.5030009@linux.vnet.ibm.com>
Date: Tue, 05 Mar 2013 15:19:57 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH 2/3] irq: Add hw continuous IRQs map to virtual continuous
 IRQs support
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com> <1358235536-32741-3-git-send-email-qiudayu@linux.vnet.ibm.com> <20130305022348.GB7656@concordia>
In-Reply-To: <20130305022348.GB7656@concordia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030507-1396-0000-0000-0000029FA221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/3/5 10:23, Michael Ellerman 写道:
> On Tue, Jan 15, 2013 at 03:38:55PM +0800, Mike Qiu wrote:
>> Adding a function irq_create_mapping_many() which can associate
>> multiple MSIs to a continous irq mapping.
>>
>> This is needed to enable multiple MSI support for pSeries.
>>
>> Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
>> ---
>>   include/linux/irq.h       |    2 +
>>   include/linux/irqdomain.h |    3 ++
>>   kernel/irq/irqdomain.c    |   61 +++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 66 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/irq.h b/include/linux/irq.h
>> index 60ef45b..e00a7ec 100644
>> --- a/include/linux/irq.h
>> +++ b/include/linux/irq.h
>> @@ -592,6 +592,8 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>>   #define irq_alloc_desc_from(from, node)		\
>>   	irq_alloc_descs(-1, from, 1, node)
>>   
>> +#define irq_alloc_desc_n(nevc, node)		\
>> +	irq_alloc_descs(-1, 0, nevc, node)
> This has been superseeded by irq_alloc_descs_from(), which is the right
> way to do it.
Yes, but irq_alloc_descs_from() just for 1 irq, and if I change the api, 
maybe a lot places which call this
function will be affact.
>
>> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
>> index 0d5b17b..831dded 100644
>> --- a/include/linux/irqdomain.h
>> +++ b/include/linux/irqdomain.h
>> @@ -168,6 +168,9 @@ extern int irq_create_strict_mappings(struct irq_domain *domain,
>>   				      unsigned int irq_base,
>>   				      irq_hw_number_t hwirq_base, int count);
>>   
>> +extern int irq_create_mapping_many(struct irq_domain *domain,
>> +					irq_hw_number_t hwirq_base, int count);
>> +
>>   static inline int irq_create_identity_mapping(struct irq_domain *host,
>>   					      irq_hw_number_t hwirq)
>>   {
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index 96f3a1d..38648e6 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -636,6 +636,67 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
>>   }
>>   EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
>>   
>> +/**
>> + * irq_create_mapping_many - Map a range of hw IRQs to a range of virtual IRQs
>> + * @domain: domain owning the interrupt range
>> + * @hwirq_base: beginning of continuous hardware IRQ range
>> + * @count: Number of interrupts to map
> For multiple-MSI the allocated interrupt numbers must be a power-of-2,
> and must be naturally aligned. I don't /think/ that's a requirement for
> the virtual numbers, but it's probably best that we do it anyway.
>
> So this API needs to specify that it will give you back a power-of-2
> block that is naturally aligned - otherwise you can't use it for MSI.
rtas_call will return the numbers of hardware interrupt, and it should 
be power-of-2,
as this I think do not need to specify
>> + * This routine is used for allocating and mapping a range of hardware
>> + * irqs to virtual IRQs where the virtual irq numbers are not at pre-defined
>> + * locations.
> This comment doesn't make sense to me.
>
>> + *
>> + * Greater than 0 is returned upon success, while any failure to establish a
>> + * static mapping is treated as an error.
>> + */
>> +int irq_create_mapping_many(struct irq_domain *domain,
>> +		irq_hw_number_t hwirq_base, int count)
>> +{
>> +	int ret, irq_base;
>> +	int virq, i;
>> +
>> +	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq_base);
>
> I'd like to see this whole function rewritten to reduce the duplication
> vs irq_create_mapping(). I don't see any reason why this can't be the
> core routine, and irq_create_mapping() becomes a caller of it, passing a
> count of 1 ?
It's good suggestion.
>> +	/* Look for default domain if nececssary */
>> +	if (!domain)
>> +		domain = irq_default_domain;
>> +	if (!domain) {
>> +		pr_warn("irq_create_mapping called for NULL domain, hwirq=%lx\n"
>> +			, hwirq_base);
>> +		WARN_ON(1);
>> +		return 0;
>> +	}
>> +	pr_debug("-> using domain @%p\n", domain);
>> +
>> +	/* For IRQ_DOMAIN_MAP_LEGACY, get the first virtual interrupt number */
>> +	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
>> +		return irq_domain_legacy_revmap(domain, hwirq_base);
> The above doesn't work.
Why it doesn't work ?
>> +	/* Check if mapping already exists */
>> +	for (i = 0; i < count; i++) {
>> +		virq = irq_find_mapping(domain, hwirq_base+i);
>> +		if (virq) {
>> +			pr_debug("existing mapping on virq %d,"
>> +					" now dispose it first\n", virq);
>> +			irq_dispose_mapping(virq);
> You might have just disposed of someone elses mapping, we shouldn't do
> that. It should be an error to the caller.
It's a good question. If the interrupt used for someone elses, why I can 
apply it from the system?
So it may someone else forget to dispose mapping, and it never be used 
for others as I have got
the interrupt I think.
> cheers
>

