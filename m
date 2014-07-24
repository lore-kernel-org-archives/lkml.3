Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbaGXNxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:53:08 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:53619 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759202AbaGXNxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:53:04 -0400
Date: Thu, 24 Jul 2014 14:52:38 +0100
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
Message-ID: <20140724135238.GC13371@arm.com>
References: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org>
 <1406079308-5232-4-git-send-email-lauraa@codeaurora.org>
 <20140723104554.GB1366@localhost>
 <53D02F7B.5020309@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D02F7B.5020309@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:56:11PM +0100, Laura Abbott wrote:
> On 7/23/2014 3:45 AM, Catalin Marinas wrote:
> > On Wed, Jul 23, 2014 at 02:35:06AM +0100, Laura Abbott wrote:
> >> --- a/drivers/base/dma-mapping.c
> >> +++ b/drivers/base/dma-mapping.c
> > [...]
> >> +void *dma_common_contiguous_remap(struct page *page, size_t size,
> >> +			unsigned long vm_flags,
> >> +			pgprot_t prot, const void *caller)
> >> +{
> >> +	int i;
> >> +	struct page **pages;
> >> +	void *ptr;
> >> +
> >> +	pages = kmalloc(sizeof(struct page *) << get_order(size), GFP_KERNEL);
> >> +	if (!pages)
> >> +		return NULL;
> >> +
> >> +	for (i = 0; i < (size >> PAGE_SHIFT); i++)
> >> +		pages[i] = page + i;
> >> +
> >> +	ptr = dma_common_pages_remap(pages, size, vm_flags, prot, caller);
> >> +
> >> +	kfree(pages);
> >> +
> >> +	return ptr;
> >> +}
> > 
> > You could avoid the dma_common_page_remap() here (and kmalloc) and
> > simply use ioremap_page_range(). We know that
> > dma_common_contiguous_remap() is only called with contiguous physical
> > range, so ioremap_page_range() is suitable. It also makes it a
> > non-functional change for arch/arm.
> 
> My original thought with using map_vm_area vs. ioremap_page_range was
> that ioremap_page_range is really intended for mapping io devices and
> the like into the kernel virtual address space. map_vm_area is designed
> to handle pages of kernel managed memory. Perhaps it's too nit-picky
> a distinction though.

I think you are right. We had a discussion in the past about using
ioremap on valid RAM addresses and decided not to allow this. This would
be similar with the ioremap_page_range() here.

>From my perspective, you can leave the code as is (wouldn't be any
functional change for arm64 since it was using vmap() already). But
please add a comment in the commit log about this change.

-- 
Catalin
