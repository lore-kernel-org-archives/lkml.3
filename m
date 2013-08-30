Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab3H3Npq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:45:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17874 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3H3Npo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:45:44 -0400
Date: Fri, 30 Aug 2013 09:45:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v5 07/13] xen: make xen_create_contiguous_region return
 the dma address
Message-ID: <20130830134511.GJ21239@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
 <1377801154-29215-7-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377801154-29215-7-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 07:32:28PM +0100, Stefano Stabellini wrote:
> Modify xen_create_contiguous_region to return the dma address of the
> newly contiguous buffer.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Acked-by or Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> 
> Changes in v4:
> - use virt_to_machine instead of virt_to_bus.
> ---
>  arch/x86/xen/mmu.c        |    4 +++-
>  drivers/xen/swiotlb-xen.c |    6 +++---
>  include/xen/xen-ops.h     |    3 ++-
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index fdc3ba2..6c34d7c 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2329,7 +2329,8 @@ static int xen_exchange_memory(unsigned long extents_in, unsigned int order_in,
>  }
>  
>  int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
> -				 unsigned int address_bits)
> +				 unsigned int address_bits,
> +				 dma_addr_t *dma_handle)
>  {
>  	unsigned long *in_frames = discontig_frames, out_frame;
>  	unsigned long  flags;
> @@ -2368,6 +2369,7 @@ int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
>  
>  	spin_unlock_irqrestore(&xen_reservation_lock, flags);
>  
> +	*dma_handle = virt_to_machine(vstart).maddr;
>  	return success ? 0 : -ENOMEM;
>  }
>  EXPORT_SYMBOL_GPL(xen_create_contiguous_region);
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 1b2277c..b72f31c 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -126,6 +126,7 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
>  {
>  	int i, rc;
>  	int dma_bits;
> +	dma_addr_t dma_handle;
>  
>  	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
>  
> @@ -137,7 +138,7 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
>  			rc = xen_create_contiguous_region(
>  				(unsigned long)buf + (i << IO_TLB_SHIFT),
>  				get_order(slabs << IO_TLB_SHIFT),
> -				dma_bits);
> +				dma_bits, &dma_handle);
>  		} while (rc && dma_bits++ < max_dma_bits);
>  		if (rc)
>  			return rc;
> @@ -294,11 +295,10 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  		*dma_handle = dev_addr;
>  	else {
>  		if (xen_create_contiguous_region(vstart, order,
> -						 fls64(dma_mask)) != 0) {
> +						 fls64(dma_mask), dma_handle) != 0) {
>  			free_pages(vstart, order);
>  			return NULL;
>  		}
> -		*dma_handle = virt_to_machine(ret).maddr;
>  	}
>  	memset(ret, 0, size);
>  	return ret;
> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index d6fe062..9ef704d 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -20,7 +20,8 @@ int xen_setup_shutdown_event(void);
>  
>  extern unsigned long *xen_contiguous_bitmap;
>  int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
> -				unsigned int address_bits);
> +				unsigned int address_bits,
> +				dma_addr_t *dma_handle);
>  
>  void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order);
>  
> -- 
> 1.7.2.5
> 
