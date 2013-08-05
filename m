Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3HEUxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:53:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48944 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3HEUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:53:12 -0400
Date: Mon, 5 Aug 2013 16:52:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 06/20] tile: support LSI MEGARAID SAS HBA hybrid dma_ops
Message-ID: <20130805205235.GB24122@phenom.dumpdata.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
 <a8a7d279ad8633c6aa3b5031aa9da4a76f2487c3.1375733180.git.cmetcalf@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8a7d279ad8633c6aa3b5031aa9da4a76f2487c3.1375733180.git.cmetcalf@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 04:06:20PM -0400, Chris Metcalf wrote:
> The LSI MEGARAID SAS HBA suffers from the problem where it can do
> 64-bit DMA to streaming buffers but not to consistent buffers.
> In other words, 64-bit DMA is used for disk data transfers and 32-bit
> DMA must be used for control message transfers. According to LSI,
> the firmware is not fully functional yet. This change implements a
> kind of hybrid dma_ops to support this.

If this is generic to LSI MegaRAID HBA shouldn't this change also be
done for the other platforms?

Or perhaps some other changes to make it work with other devices?

> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/include/asm/dma-mapping.h |  4 ++--
>  arch/tile/kernel/pci-dma.c          | 17 +++++++++++------
>  2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
> index f2ff191..6da0540 100644
> --- a/arch/tile/include/asm/dma-mapping.h
> +++ b/arch/tile/include/asm/dma-mapping.h
> @@ -44,12 +44,12 @@ static inline void set_dma_offset(struct device *dev, dma_addr_t off)
>  
>  static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
>  {
> -	return paddr + get_dma_offset(dev);
> +	return paddr;
>  }
>  
>  static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
>  {
> -	return daddr - get_dma_offset(dev);
> +	return daddr;
>  }
>  
>  static inline void dma_mark_clean(void *addr, size_t size) {}
> diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
> index b9fe80e..7e98371 100644
> --- a/arch/tile/kernel/pci-dma.c
> +++ b/arch/tile/kernel/pci-dma.c
> @@ -357,7 +357,7 @@ static void *tile_pci_dma_alloc_coherent(struct device *dev, size_t size,
>  
>  	addr = page_to_phys(pg);
>  
> -	*dma_handle = phys_to_dma(dev, addr);
> +	*dma_handle = addr + get_dma_offset(dev);
>  
>  	return page_address(pg);
>  }
> @@ -387,7 +387,7 @@ static int tile_pci_dma_map_sg(struct device *dev, struct scatterlist *sglist,
>  		sg->dma_address = sg_phys(sg);
>  		__dma_prep_pa_range(sg->dma_address, sg->length, direction);
>  
> -		sg->dma_address = phys_to_dma(dev, sg->dma_address);
> +		sg->dma_address = sg->dma_address + get_dma_offset(dev);
>  #ifdef CONFIG_NEED_SG_DMA_LENGTH
>  		sg->dma_length = sg->length;
>  #endif
> @@ -422,7 +422,7 @@ static dma_addr_t tile_pci_dma_map_page(struct device *dev, struct page *page,
>  	BUG_ON(offset + size > PAGE_SIZE);
>  	__dma_prep_page(page, offset, size, direction);
>  
> -	return phys_to_dma(dev, page_to_pa(page) + offset);
> +	return page_to_pa(page) + offset + get_dma_offset(dev);
>  }
>  
>  static void tile_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
> @@ -432,7 +432,7 @@ static void tile_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
>  {
>  	BUG_ON(!valid_dma_direction(direction));
>  
> -	dma_address = dma_to_phys(dev, dma_address);
> +	dma_address -= get_dma_offset(dev);
>  
>  	__dma_complete_page(pfn_to_page(PFN_DOWN(dma_address)),
>  			    dma_address & PAGE_OFFSET, size, direction);
> @@ -445,7 +445,7 @@ static void tile_pci_dma_sync_single_for_cpu(struct device *dev,
>  {
>  	BUG_ON(!valid_dma_direction(direction));
>  
> -	dma_handle = dma_to_phys(dev, dma_handle);
> +	dma_handle -= get_dma_offset(dev);
>  
>  	__dma_complete_pa_range(dma_handle, size, direction);
>  }
> @@ -456,7 +456,7 @@ static void tile_pci_dma_sync_single_for_device(struct device *dev,
>  						enum dma_data_direction
>  						direction)
>  {
> -	dma_handle = dma_to_phys(dev, dma_handle);
> +	dma_handle -= get_dma_offset(dev);
>  
>  	__dma_prep_pa_range(dma_handle, size, direction);
>  }
> @@ -573,6 +573,11 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
>  	if (((dma_ops == gx_pci_dma_map_ops) ||
>  	    (dma_ops == gx_legacy_pci_dma_map_ops)) &&
>  	    (mask <= DMA_BIT_MASK(32))) {
> +		if (dma_ops == gx_pci_dma_map_ops) {
> +			dma_ops->alloc = tile_swiotlb_alloc_coherent;
> +			dma_ops->free = tile_swiotlb_free_coherent;
> +		}
> +

So.. that would change it for all of the devices on the host, not just
for this specific one. That is not good is it?

>  		if (mask > dev->archdata.max_direct_dma_addr)
>  			mask = dev->archdata.max_direct_dma_addr;
>  	}
> -- 
> 1.8.3.1
> 
