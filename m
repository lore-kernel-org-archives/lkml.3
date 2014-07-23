Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbaGWV4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:56:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60267 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbaGWV4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:56:13 -0400
Message-ID: <53D02F7B.5020309@codeaurora.org>
Date: Wed, 23 Jul 2014 14:56:11 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv4 3/5] common: dma-mapping: Introduce common remapping
 functions
References: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org> <1406079308-5232-4-git-send-email-lauraa@codeaurora.org> <20140723104554.GB1366@localhost>
In-Reply-To: <20140723104554.GB1366@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/2014 3:45 AM, Catalin Marinas wrote:
> On Wed, Jul 23, 2014 at 02:35:06AM +0100, Laura Abbott wrote:
>> --- a/arch/arm/mm/dma-mapping.c
>> +++ b/arch/arm/mm/dma-mapping.c
>> @@ -298,37 +298,19 @@ static void *
>>  __dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot,
>>  	const void *caller)
>>  {
>> -	struct vm_struct *area;
>> -	unsigned long addr;
>> -
>>  	/*
>>  	 * DMA allocation can be mapped to user space, so lets
>>  	 * set VM_USERMAP flags too.
>>  	 */
>> -	area = get_vm_area_caller(size, VM_ARM_DMA_CONSISTENT | VM_USERMAP,
>> -				  caller);
>> -	if (!area)
>> -		return NULL;
>> -	addr = (unsigned long)area->addr;
>> -	area->phys_addr = __pfn_to_phys(page_to_pfn(page));
>> -
>> -	if (ioremap_page_range(addr, addr + size, area->phys_addr, prot)) {
>> -		vunmap((void *)addr);
>> -		return NULL;
>> -	}
>> -	return (void *)addr;
>> +	return dma_common_contiguous_remap(page, size,
>> +			VM_ARM_DMA_CONSISTENT | VM_USERMAP,
>> +			prot, caller);
> 
> I think we still need at least a comment in the commit log since the arm
> code is moving from ioremap_page_range() to map_vm_area(). There is a
> slight performance penalty with the addition of a kmalloc() on this
> path.
> 
> Or even better (IMO), see below.
> 
>> --- a/drivers/base/dma-mapping.c
>> +++ b/drivers/base/dma-mapping.c
> [...]
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
>> +
>> +	ptr = dma_common_pages_remap(pages, size, vm_flags, prot, caller);
>> +
>> +	kfree(pages);
>> +
>> +	return ptr;
>> +}
> 
> You could avoid the dma_common_page_remap() here (and kmalloc) and
> simply use ioremap_page_range(). We know that
> dma_common_contiguous_remap() is only called with contiguous physical
> range, so ioremap_page_range() is suitable. It also makes it a
> non-functional change for arch/arm.
> 

My original thought with using map_vm_area vs. ioremap_page_range was
that ioremap_page_range is really intended for mapping io devices and
the like into the kernel virtual address space. map_vm_area is designed
to handle pages of kernel managed memory. Perhaps it's too nit-picky
a distinction though.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
