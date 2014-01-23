Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaAWQuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:50:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbaAWQuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:50:22 -0500
Date: Thu, 23 Jan 2014 14:47:28 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, dwmw2@infradead.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: Fix off-by-one in pagetable freeing
Message-ID: <20140123164728.GA23854@amt.cnet>
References: <20131220193250.17903.48255.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220193250.17903.48255.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 12:33:43PM -0700, Alex Williamson wrote:
> dma_pte_free_level() has an off-by-one error when checking whether a
> pte is completely covered by a range.  Take for example the case of
> attempting to free pfn 0x0 - 0x1ff, ie. 512 entries covering the first
> 2M superpage.  The level_size() is 0x200 and we test:
> 
> static void dma_pte_free_level(...
> 	...
> 
> 	if (!(0 > 0 || 0x1ff < 0 + 0x200)) {
> 		...
> 	}
> 
> Clearly the 2nd test is true, which means we fail to take the branch
> to clear and free the pagetable entry.  As a result, we're leaking
> pagetables and failing to install new pages over the range.
> 
> This was found with a PCI device assigned to a QEMU guest using
> vfio-pci without a VGA device present.  The first 1M of guest
> address space is mapped with various combinations of 4K pages, but
> eventually the range is entirely freed and replaced with a 2M
> contiguous mapping.  intel-iommu errors out with something like:
> 
> ERROR: DMA PTE for vPFN 0x0 already set (to 5c2b8003 not 849c00083)
> 
> In this case 5c2b8003 is the pointer to the previous leaf page that
> was neither freed nor cleared and 849c00083 is the superpage entry
> that we're trying to replace it with.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/iommu/intel-iommu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 43b9bfe..59779e1 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -917,7 +917,7 @@ static void dma_pte_free_level(struct dmar_domain *domain, int level,
>  
>  		/* If range covers entire pagetable, free it */
>  		if (!(start_pfn > level_pfn ||
> -		      last_pfn < level_pfn + level_size(level))) {
> +		      last_pfn < level_pfn + level_size(level) - 1)) {
>  			dma_clear_pte(pte);
>  			domain_flush_cache(domain, pte, sizeof(*pte));
>  			free_pgtable_page(level_pte);

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

