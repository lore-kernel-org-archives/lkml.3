Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3JWRVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 13:21:31 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53203 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3JWRVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:21:30 -0400
X-IronPort-AV: E=Sophos;i="4.93,555,1378857600"; 
   d="scan'208";a="66578781"
Date: Wed, 23 Oct 2013 18:20:25 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v8 13/19] swiotlb-xen: use xen_dma_map/unmap_page,
 xen_dma_sync_single_for_cpu/device
In-Reply-To: <20131023140927.GD27771@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1310231816180.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com> <1382031814-8782-13-git-send-email-stefano.stabellini@eu.citrix.com> <20131023140927.GD27771@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Oct 2013, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 17, 2013 at 06:43:28PM +0100, Stefano Stabellini wrote:
> > Call xen_dma_map_page, xen_dma_unmap_page, xen_dma_sync_single_for_cpu,
> > xen_dma_sync_single_for_device from swiotlb-xen to ensure cpu/device
> > coherency of the pages used for DMA, including the ones belonging to the
> > swiotlb buffer.
> 
> You lost me.
> 
> Isn't it the driver's responsibility to do this?
> 
> Looking at what 'xen_dma_map_page()' does for x86 it looks to add an extra
> call - page_to_phys - and we ignore it here.

map_page on arm calls the right cache flushes needed to communicate with
the device. Same with unmap_page.
On x86 they are basically nop.
Only map_page and unmap_page know exactly what needs to be done to
map a page for dma, this is why we need to call them here.


> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/xen/swiotlb-xen.c |   39 +++++++++++++++++++++++++++++++--------
> >  1 files changed, 31 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index 189b8db..4221cb5 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -378,8 +378,13 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
> >  	 * buffering it.
> >  	 */
> >  	if (dma_capable(dev, dev_addr, size) &&
> > -	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
> > +	    !range_straddles_page_boundary(phys, size) && !swiotlb_force) {
> > +		/* we are not interested in the dma_addr returned by
> > +		 * xen_dma_map_page, only in the potential cache flushes executed
> > +		 * by the function. */
> > +		xen_dma_map_page(dev, page, offset, size, dir, attrs);
> >  		return dev_addr;
> > +	}
> >  
> >  	/*
> >  	 * Oh well, have to allocate and map a bounce buffer.
> > @@ -388,6 +393,8 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
> >  	if (map == SWIOTLB_MAP_ERROR)
> >  		return DMA_ERROR_CODE;
> >  
> > +	xen_dma_map_page(dev, pfn_to_page(map >> PAGE_SHIFT),
> > +					map & ~PAGE_MASK, size, dir, attrs);
> >  	dev_addr = xen_phys_to_bus(map);
> >  
> >  	/*
> > @@ -410,12 +417,15 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
> >   * whatever the device wrote there.
> >   */
> >  static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
> > -			     size_t size, enum dma_data_direction dir)
> > +			     size_t size, enum dma_data_direction dir,
> > +				 struct dma_attrs *attrs)
> >  {
> >  	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
> >  
> >  	BUG_ON(dir == DMA_NONE);
> >  
> > +	xen_dma_unmap_page(hwdev, paddr, size, dir, attrs);
> > +
> >  	/* NOTE: We use dev_addr here, not paddr! */
> >  	if (is_xen_swiotlb_buffer(dev_addr)) {
> >  		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
> > @@ -438,7 +448,7 @@ void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
> >  			    size_t size, enum dma_data_direction dir,
> >  			    struct dma_attrs *attrs)
> >  {
> > -	xen_unmap_single(hwdev, dev_addr, size, dir);
> > +	xen_unmap_single(hwdev, dev_addr, size, dir, attrs);
> >  }
> >  EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_page);
> >  
> > @@ -461,11 +471,15 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
> >  
> >  	BUG_ON(dir == DMA_NONE);
> >  
> > +	if (target == SYNC_FOR_CPU)
> > +		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
> > +
> >  	/* NOTE: We use dev_addr here, not paddr! */
> > -	if (is_xen_swiotlb_buffer(dev_addr)) {
> > +	if (is_xen_swiotlb_buffer(dev_addr))
> >  		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
> > -		return;
> > -	}
> > +
> > +	if (target == SYNC_FOR_DEVICE)
> > +		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
> >  
> >  	if (dir != DMA_FROM_DEVICE)
> >  		return;
> > @@ -536,8 +550,17 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> >  				return DMA_ERROR_CODE;
> >  			}
> >  			sg->dma_address = xen_phys_to_bus(map);
> > -		} else
> > +		} else {
> > +			/* we are not interested in the dma_addr returned by
> > +			 * xen_dma_map_page, only in the potential cache flushes executed
> > +			 * by the function. */
> > +			xen_dma_map_page(hwdev, pfn_to_page(paddr >> PAGE_SHIFT),
> > +						paddr & ~PAGE_MASK,
> > +						sg->length,
> > +						dir,
> > +						attrs);
> >  			sg->dma_address = dev_addr;
> > +		}
> >  		sg_dma_len(sg) = sg->length;
> >  	}
> >  	return nelems;
> > @@ -559,7 +582,7 @@ xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
> >  	BUG_ON(dir == DMA_NONE);
> >  
> >  	for_each_sg(sgl, sg, nelems, i)
> > -		xen_unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir);
> > +		xen_unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir, attrs);
> >  
> >  }
> >  EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg_attrs);
> > -- 
> > 1.7.2.5
> > 
> 
