Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab3I3P4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:56:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27608 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3I3P4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:56:53 -0400
Date: Mon, 30 Sep 2013 11:56:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v6 12/19] swiotlb: don't assume that
 io_tlb_start-io_tlb_end is coherent
Message-ID: <20130930155617.GS3106@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-12-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380298207-29151-12-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:10:00PM +0100, Stefano Stabellini wrote:
> The swiotlb code has appropriate calls to dma_mark_clean in place for
> buffers passed to swiotlb_map_page as an argument. However it assumes
> that the swiotlb bounce buffer (io_tlb_start-io_tlb_end) is already
> coherent and doesn't need any calls to dma_mark_clean.
> 
> On ARM the swiotlb bounce buffer is not coherent (the memory is
> writealloc while it should be bufferable) and therefore we need to call
> dma_mark_clean appropriately on the bounce buffer code paths too.
> 
> Note that most architecures have an empty dma_mark_clean implementation
> anyway.

The other architecture that uses swiotlb is IA64 and that does have
an implementation where it touches on page attributes.

Which means I have to figure out why my HP zx6000 won't boot with 3.11 now :-(

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  lib/swiotlb.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 4e8686c..eb45d17 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -515,6 +515,7 @@ found:
>  		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
>  	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
>  		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
> +	dma_mark_clean(phys_to_virt(tlb_addr), size);
>  
>  	return tlb_addr;
>  }
> @@ -547,7 +548,10 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
>  	 * First, sync the memory before unmapping the entry
>  	 */
>  	if (orig_addr && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
> +	{
> +		dma_mark_clean(phys_to_virt(tlb_addr), size);
>  		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_FROM_DEVICE);
> +	}
>  
>  	/*
>  	 * Return the buffer to the free list by setting the corresponding
> @@ -587,17 +591,20 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
>  
>  	switch (target) {
>  	case SYNC_FOR_CPU:
> -		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
> +		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)) {
> +			dma_mark_clean(phys_to_virt(tlb_addr), size);
>  			swiotlb_bounce(orig_addr, tlb_addr,
>  				       size, DMA_FROM_DEVICE);
> +		}
>  		else
>  			BUG_ON(dir != DMA_TO_DEVICE);
>  		break;
>  	case SYNC_FOR_DEVICE:
> -		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
> +		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)) {
>  			swiotlb_bounce(orig_addr, tlb_addr,
>  				       size, DMA_TO_DEVICE);
> -		else
> +			dma_mark_clean(phys_to_virt(tlb_addr), size);
> +		} else
>  			BUG_ON(dir != DMA_FROM_DEVICE);
>  		break;
>  	default:
> -- 
> 1.7.2.5
> 
