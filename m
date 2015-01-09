Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbbAIJoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:44:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58475 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbbAIJoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:44:10 -0500
Message-ID: <54AFA2DD.5010105@arm.com>
Date: Fri, 09 Jan 2015 09:43:57 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] genirq: Abstract access to irq_chip flags
References: <1420738365-22063-1-git-send-email-marc.zyngier@arm.com> <1420738365-22063-2-git-send-email-marc.zyngier@arm.com> <54AF4449.2040004@linux.intel.com>
In-Reply-To: <54AF4449.2040004@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/15 03:00, Jiang Liu wrote:
> On 2015/1/9 1:32, Marc Zyngier wrote:
>> In order to safely migrate to a cumulative set of flags, start by
>> abstracting the way we look at these flags. There is otherwise no
>> change in semantics here.
> <snit>
>> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>> index 8069237..b2a43e0 100644
>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -491,7 +491,7 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
>>  	struct irq_desc *desc = irq_to_desc(irq);
>>  	int ret = -ENXIO;
>>  
>> -	if (irq_desc_get_chip(desc)->flags &  IRQCHIP_SKIP_SET_WAKE)
>> +	if (irq_desc_get_chip_flags(desc) &  IRQCHIP_SKIP_SET_WAKE)
>>  		return 0;
>>  
>>  	if (desc->irq_data.chip->irq_set_wake)
>> @@ -589,7 +589,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
>>  
>>  	flags &= IRQ_TYPE_SENSE_MASK;
>>  
>> -	if (chip->flags & IRQCHIP_SET_TYPE_MASKED) {
>> +	if (irq_desc_get_chip_flags(desc) & IRQCHIP_SET_TYPE_MASKED) {
>>  		if (!irqd_irq_masked(&desc->irq_data))
>>  			mask_irq(desc);
>>  		if (!irqd_irq_disabled(&desc->irq_data))
>> @@ -1043,7 +1043,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>>  	 * chip flags, so we can avoid the unmask dance at the end of
>>  	 * the threaded handler for those.
>>  	 */
>> -	if (desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)
>> +	if (irq_desc_get_chip_flags(desc) & IRQCHIP_ONESHOT_SAFE)
>>  		new->flags &= ~IRQF_ONESHOT;
>>  
>>  	/*
> Hi Mark,
> 	Seems you missed on instance of IRQCHIP_ONESHOT_SAFE in
> __setup_irq() as below.
> Thanks!
> Gerry
> -----------------------------------------------------------------
>         } else if (new->handler == irq_default_primary_handler &&
>                    !(desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)) {
> ------------------------------------------------------------------

Ah, nice catch.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
