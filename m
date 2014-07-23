Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbaGWKqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:46:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23404 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752448AbaGWKqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:46:14 -0400
Date: Wed, 23 Jul 2014 11:45:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>, David Riley <davidriley@chromium.org>,
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
Message-ID: <20140723104554.GB1366@localhost>
References: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org>
 <1406079308-5232-4-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406079308-5232-4-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 02:35:06AM +0100, Laura Abbott wrote:
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -298,37 +298,19 @@ static void *
>  __dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot,
>  	const void *caller)
>  {
> -	struct vm_struct *area;
> -	unsigned long addr;
> -
>  	/*
>  	 * DMA allocation can be mapped to user space, so lets
>  	 * set VM_USERMAP flags too.
>  	 */
> -	area = get_vm_area_caller(size, VM_ARM_DMA_CONSISTENT | VM_USERMAP,
> -				  caller);
> -	if (!area)
> -		return NULL;
> -	addr = (unsigned long)area->addr;
> -	area->phys_addr = __pfn_to_phys(page_to_pfn(page));
> -
> -	if (ioremap_page_range(addr, addr + size, area->phys_addr, prot)) {
> -		vunmap((void *)addr);
> -		return NULL;
> -	}
> -	return (void *)addr;
> +	return dma_common_contiguous_remap(page, size,
> +			VM_ARM_DMA_CONSISTENT | VM_USERMAP,
> +			prot, caller);

I think we still need at least a comment in the commit log since the arm
code is moving from ioremap_page_range() to map_vm_area(). There is a
slight performance penalty with the addition of a kmalloc() on this
path.

Or even better (IMO), see below.

> --- a/drivers/base/dma-mapping.c
> +++ b/drivers/base/dma-mapping.c
[...]
> +void *dma_common_contiguous_remap(struct page *page, size_t size,
> +			unsigned long vm_flags,
> +			pgprot_t prot, const void *caller)
> +{
> +	int i;
> +	struct page **pages;
> +	void *ptr;
> +
> +	pages = kmalloc(sizeof(struct page *) << get_order(size), GFP_KERNEL);
> +	if (!pages)
> +		return NULL;
> +
> +	for (i = 0; i < (size >> PAGE_SHIFT); i++)
> +		pages[i] = page + i;
> +
> +	ptr = dma_common_pages_remap(pages, size, vm_flags, prot, caller);
> +
> +	kfree(pages);
> +
> +	return ptr;
> +}

You could avoid the dma_common_page_remap() here (and kmalloc) and
simply use ioremap_page_range(). We know that
dma_common_contiguous_remap() is only called with contiguous physical
range, so ioremap_page_range() is suitable. It also makes it a
non-functional change for arch/arm.

-- 
Catalin
