Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaHHX0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 19:26:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38841 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaHHX0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:26:01 -0400
Message-ID: <53E55C86.3040705@codeaurora.org>
Date: Fri, 08 Aug 2014 16:25:58 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Riley <davidriley@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thierry Reding <thierry.reding@gmail.com>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv6 3/5] common: dma-mapping: Introduce common remapping
 functions
References: <1407529397-6642-1-git-send-email-lauraa@codeaurora.org> <1407529397-6642-3-git-send-email-lauraa@codeaurora.org> <20140808154556.11c7bf68d1bcf2714c148e3b@linux-foundation.org>
In-Reply-To: <20140808154556.11c7bf68d1bcf2714c148e3b@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/2014 3:45 PM, Andrew Morton wrote:
> On Fri,  8 Aug 2014 13:23:15 -0700 Laura Abbott <lauraa@codeaurora.org> wrote:
> 
>>
>> For architectures without coherent DMA, memory for DMA may
>> need to be remapped with coherent attributes. Factor out
>> the the remapping code from arm and put it in a
>> common location to reduce code duplication.
>>
>> As part of this, the arm APIs are now migrated away from
>> ioremap_page_range to the common APIs which use map_vm_area for remapping.
>> This should be an equivalent change and using map_vm_area is more
>> correct as ioremap_page_range is intended to bring in io addresses
>> into the cpu space and not regular kernel managed memory.
>>
>> ...
>>
>> @@ -267,3 +269,68 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL(dma_common_mmap);
>> +
>> +/*
>> + * remaps an allocated contiguous region into another vm_area.
>> + * Cannot be used in non-sleeping contexts
>> + */
>> +
>> +void *dma_common_contiguous_remap(struct page *page, size_t size,
>> +			unsigned long vm_flags,
>> +			pgprot_t prot, const void *caller)
>> +{
>> +	int i;
>> +	struct page **pages;
>> +	void *ptr;
>> +
>> +	pages = kmalloc(sizeof(struct page *) << get_order(size), GFP_KERNEL);
>> +	if (!pages)
>> +		return NULL;
>> +
>> +	for (i = 0; i < (size >> PAGE_SHIFT); i++)
>> +		pages[i] = page + i;
> 
> Assumes a single mem_map[] array.  That's not the case for sparsemem
> (at least).
> 
> 

Good point. I guess the best option is to increment via pfn and call
pfn_to_page. Either that or go back to slightly abusing
ioremap_page_range to remap normal memory.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
