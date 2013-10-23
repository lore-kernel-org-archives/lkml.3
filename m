Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3JWTxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:53:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35289 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3JWTxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:53:35 -0400
Date: Wed, 23 Oct 2013 15:51:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v8 13/19] swiotlb-xen: use xen_dma_map/unmap_page,
 xen_dma_sync_single_for_cpu/device
Message-ID: <20131023195154.GB28963@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com>
 <1382031814-8782-13-git-send-email-stefano.stabellini@eu.citrix.com>
 <20131023140927.GD27771@phenom.dumpdata.com>
 <alpine.DEB.2.02.1310231816180.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310231816180.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 06:20:25PM +0100, Stefano Stabellini wrote:
> On Wed, 23 Oct 2013, Konrad Rzeszutek Wilk wrote:
> > On Thu, Oct 17, 2013 at 06:43:28PM +0100, Stefano Stabellini wrote:
> > > Call xen_dma_map_page, xen_dma_unmap_page, xen_dma_sync_single_for_cpu,
> > > xen_dma_sync_single_for_device from swiotlb-xen to ensure cpu/device
> > > coherency of the pages used for DMA, including the ones belonging to the
> > > swiotlb buffer.
> > 
> > You lost me.
> > 
> > Isn't it the driver's responsibility to do this?
> > 
> > Looking at what 'xen_dma_map_page()' does for x86 it looks to add an extra
> > call - page_to_phys - and we ignore it here.
> 
> map_page on arm calls the right cache flushes needed to communicate with
> the device. Same with unmap_page.

If this is flushing the cache then I think it makes more sense to do
that without this fancy 'dma_map_page'.

Just call it 'xen_flush_dma_page' and make it a nop on all platforms
except ARM.

> On x86 they are basically nop.

It calls page_to_phys in your patch. That is hardly nop.

> Only map_page and unmap_page know exactly what needs to be done to
> map a page for dma, this is why we need to call them here.
> 
> 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > ---
> > >  drivers/xen/swiotlb-xen.c |   39 +++++++++++++++++++++++++++++++--------
> > >  1 files changed, 31 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > > index 189b8db..4221cb5 100644
> > > --- a/drivers/xen/swiotlb-xen.c
> > > +++ b/drivers/xen/swiotlb-xen.c
> > > @@ -378,8 +378,13 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
> > >  	 * buffering it.
> > >  	 */
> > >  	if (dma_capable(dev, dev_addr, size) &&
> > > -	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
> > > +	    !range_straddles_page_boundary(phys, size) && !swiotlb_force) {
> > > +		/* we are not interested in the dma_addr returned by
> > > +		 * xen_dma_map_page, only in the potential cache flushes executed
> > > +		 * by the function. */
> > > +		xen_dma_map_page(dev, page, offset, size, dir, attrs);
> > >  		return dev_addr;
> > > +	}
> > >  
> > >  	/*
> > >  	 * Oh well, have to allocate and map a bounce buffer.
> > > @@ -388,6 +393,8 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
> > >  	if (map == SWIOTLB_MAP_ERROR)
> > >  		return DMA_ERROR_CODE;
> > >  
> > > +	xen_dma_map_page(dev, pfn_to_page(map >> PAGE_SHIFT),
> > > +					map & ~PAGE_MASK, size, dir, attrs);
> > >  	dev_addr = xen_phys_to_bus(map);
> > >  
> > >  	/*
> > > @@ -410,12 +417,15 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
> > >   * whatever the device wrote there.
> > >   */
> > >  static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
> > > -			     size_t size, enum dma_data_direction dir)
> > > +			     size_t size, enum dma_data_direction dir,
> > > +				 struct dma_attrs *attrs)
> > >  {
> > >  	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
> > >  
> > >  	BUG_ON(dir == DMA_NONE);
> > >  
> > > +	xen_dma_unmap_page(hwdev, paddr, size, dir, attrs);
> > > +
> > >  	/* NOTE: We use dev_addr here, not paddr! */
> > >  	if (is_xen_swiotlb_buffer(dev_addr)) {
> > >  		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
> > > @@ -438,7 +448,7 @@ void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
> > >  			    size_t size, enum dma_data_direction dir,
> > >  			    struct dma_attrs *attrs)
> > >  {
> > > -	xen_unmap_single(hwdev, dev_addr, size, dir);
> > > +	xen_unmap_single(hwdev, dev_addr, size, dir, attrs);
> > >  }
> > >  EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_page);
> > >  
> > > @@ -461,11 +471,15 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
> > >  
> > >  	BUG_ON(dir == DMA_NONE);
> > >  
> > > +	if (target == SYNC_FOR_CPU)
> > > +		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
> > > +
> > >  	/* NOTE: We use dev_addr here, not paddr! */
> > > -	if (is_xen_swiotlb_buffer(dev_addr)) {
> > > +	if (is_xen_swiotlb_buffer(dev_addr))
> > >  		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
> > > -		return;
> > > -	}
> > > +
> > > +	if (target == SYNC_FOR_DEVICE)
> > > +		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
> > >  
> > >  	if (dir != DMA_FROM_DEVICE)
> > >  		return;
> > > @@ -536,8 +550,17 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> > >  				return DMA_ERROR_CODE;
> > >  			}
> > >  			sg->dma_address = xen_phys_to_bus(map);
> > > -		} else
> > > +		} else {
> > > +			/* we are not interested in the dma_addr returned by
> > > +			 * xen_dma_map_page, only in the potential cache flushes executed
> > > +			 * by the function. */
> > > +			xen_dma_map_page(hwdev, pfn_to_page(paddr >> PAGE_SHIFT),
> > > +						paddr & ~PAGE_MASK,
> > > +						sg->length,
> > > +						dir,
> > > +						attrs);
> > >  			sg->dma_address = dev_addr;
> > > +		}
> > >  		sg_dma_len(sg) = sg->length;
> > >  	}
> > >  	return nelems;
> > > @@ -559,7 +582,7 @@ xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> > >  	BUG_ON(dir == DMA_NONE);
> > >  
> > >  	for_each_sg(sgl, sg, nelems, i)
> > > -		xen_unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir);
> > > +		xen_unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir, attrs);
> > >  
> > >  }
> > >  EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg_attrs);
> > > -- 
> > > 1.7.2.5
> > > 
> > 
