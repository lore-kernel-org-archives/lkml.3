Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbbAXAnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:43:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:23564 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbbAXAnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:43:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,457,1418112000"; 
   d="scan'208";a="641871891"
Message-ID: <54C2EA9B.9090101@linux.intel.com>
Date: Sat, 24 Jan 2015 08:43:07 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <marc.zyngier@arm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] genirq: Allow irq_desc to carry the union of stacked
 irq_chip flags
References: <1421246717-11640-1-git-send-email-marc.zyngier@arm.com> <1421246717-11640-3-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1501231648110.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501231648110.5526@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/23 23:55, Thomas Gleixner wrote:
> On Wed, 14 Jan 2015, Marc Zyngier wrote:
> 
>> The current infrastructure for stacked domains doesn't propagate
>> irq_chip flags, and as we only look at the top-level irq_chip,
>> we may miss a number of critical flags.
>>
>> This patch accumulates the flags into a new set, stored at the
>> irq_desc level, with an additional flag to indicate that this is
>> a stack of irqchip. The accessor is updated to return the right one.
> 
>>  static inline unsigned long irq_desc_get_chip_flags(struct irq_desc *desc)
>>  {
>> +#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
>> +	if (desc->chip_flags & IRQCHIP_STACKED_CHIPS)
>> +		return desc->chip_flags;
>> +#endif
>>  	return desc->irq_data.chip->flags;
> 
> We can avoid the extra conditional if we just make the accumulated
> flags unconditional and collect them even for the !hierarchy case.
> 
> Also this patch is missing that chips can be swapped at runtime either
> via the normal interfaces or via __irq_set_chip_handler_name_locked().
> 
> This needs to be addressed otherwise we might end up looking at the
> wrong flags.
I'm splitting irq_data into irq_common_data and irq_data, seems
we could host flags by using irq_common_data instead of irq_desc.

> 
> Thanks,
> 
> 	tglx
> 
