Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3I3RkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:40:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48890 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3I3RkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:40:16 -0400
Date: Mon, 30 Sep 2013 13:39:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v6 19/19] swiotlb-xen: instead of bouncing on the
 swiotlb, pin single pages
Message-ID: <20130930173945.GZ3106@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-19-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380298207-29151-19-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:10:07PM +0100, Stefano Stabellini wrote:
> If we are dealing with single page mappings that don't cross page
> boundaries, we can try to pin the page and get the corresponding mfn,
> using xen_pin_page.  This avoids going through the swiotlb bounce
> buffer.  If xen_pin_page fails (because the underlying mfn doesn't
> respect the dma_mask) fall back to the swiotlb bounce buffer.
> Add a ref count to xen_dma_info, so that we can avoid pinnig pages that
> are already pinned.
> Use a spinlock to protect accesses, insertions and deletions in the
> rbtrees.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/swiotlb-xen.c |  152 ++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 143 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 022bcaf..6f94285 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -57,6 +57,8 @@
>  #define NR_DMA_SEGS  ((xen_io_tlb_nslabs + IO_TLB_SEGSIZE - 1) / IO_TLB_SEGSIZE)
>  static char *xen_io_tlb_start, *xen_io_tlb_end;
>  static unsigned long xen_io_tlb_nslabs;
> +spinlock_t swiotlb_lock;
> +
>  /*
>   * Quick lookup value of the bus address of the IOTLB.
>   */
> @@ -79,6 +81,7 @@ struct xen_dma_info {
>  	dma_addr_t dma_addr;
>  	phys_addr_t phys_addr;
>  	size_t size;
> +	atomic_t refs;
>  	struct rb_node rbnode_dma;
>  	struct rb_node rbnode_phys;
>  };
> @@ -254,6 +257,48 @@ static dma_addr_t xen_virt_to_bus(void *address)
>  	return xen_phys_to_bus_quick(virt_to_phys(address));
>  }
>  
> +static int xen_pin_dev_page(struct device *dev,
> +							phys_addr_t phys,
> +							dma_addr_t *dev_addr)

Something is odd with your tabs.
> +{
> +	u64 dma_mask = DMA_BIT_MASK(32);

Why 32?

> +	xen_pfn_t in;
> +	struct xen_dma_info *dma_info = xen_get_dma_info_from_phys(phys);
> +
> +	if (dma_info != NULL) {
> +		atomic_inc(&dma_info->refs);
> +		*dev_addr = dma_info->dma_addr + (phys - dma_info->phys_addr);
> +		return 0;
> +	}
> +
> +	if (dev && dev->coherent_dma_mask)
> +		dma_mask = dma_alloc_coherent_mask(dev, GFP_KERNEL);
> +
> +	in = phys >> PAGE_SHIFT;
> +	if (!xen_pin_page(&in, fls64(dma_mask))) {

Why not just make xen_pin_page use an phys address and it can also
do the appropiate bit shifting in it?

> +		*dev_addr = in << PAGE_SHIFT;
> +		dma_info = kzalloc(sizeof(struct xen_dma_info), GFP_NOWAIT);
> +		if (!dma_info) {
> +			pr_warn("cannot allocate xen_dma_info\n");
> +			xen_destroy_contiguous_region(phys & PAGE_MASK, 0);

Perhaps we should add an inline function for that called 'xen_unpin_page' ?

> +			return -ENOMEM;
> +		}
> +		dma_info->phys_addr = phys & PAGE_MASK;
> +		dma_info->size = PAGE_SIZE;
> +		dma_info->dma_addr = *dev_addr;
> +		if (xen_dma_add_entry(dma_info)) {
> +			pr_warn("cannot add new entry to bus_to_phys\n");
> +			xen_destroy_contiguous_region(phys & PAGE_MASK, 0);
> +			kfree(dma_info);
> +			return -EFAULT;
> +		}
> +		atomic_set(&dma_info->refs, 1);
> +		*dev_addr += (phys & ~PAGE_MASK);
> +		return 0;
> +	}

Don't you want to the opposite of dma_alloc_coherent_mask ?

> +	return -EFAULT;
> +}
> +
>  static int check_pages_physically_contiguous(unsigned long pfn,
>  					     unsigned int offset,
>  					     size_t length)
> @@ -434,6 +479,7 @@ retry:
>  		rc = 0;
>  	} else
>  		rc = swiotlb_late_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs);
> +	spin_lock_init(&swiotlb_lock);
>  	return rc;
>  error:
>  	if (repeat--) {
> @@ -461,6 +507,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  	phys_addr_t phys;
>  	dma_addr_t dev_addr;
>  	struct xen_dma_info *dma_info = NULL;
> +	unsigned long irqflags;
>  
>  	/*
>  	* Ignore region specifiers - the kernel's ideas of
> @@ -497,7 +544,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  	    !range_straddles_page_boundary(phys, size))
>  		*dma_handle = dev_addr;
>  	else {
> -		if (xen_create_contiguous_region(phys, order,
> +		if (xen_create_contiguous_region(phys & PAGE_MASK, order,
>  						 fls64(dma_mask), dma_handle) != 0) {
>  			xen_free_coherent_pages(hwdev, size, ret, (dma_addr_t)phys, attrs);
>  			return NULL;
> @@ -509,15 +556,19 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  			xen_destroy_contiguous_region(phys, order);
>  			return NULL;
>  		}
> -		dma_info->phys_addr = phys;
> -		dma_info->size = size;
> +		dma_info->phys_addr = phys & PAGE_MASK;
> +		dma_info->size = (1U << order) << PAGE_SHIFT;
>  		dma_info->dma_addr = *dma_handle;
> +		atomic_set(&dma_info->refs, 1);
> +		spin_lock_irqsave(&swiotlb_lock, irqflags);
>  		if (xen_dma_add_entry(dma_info)) {
> +			spin_unlock_irqrestore(&swiotlb_lock, irqflags);
>  			pr_warn("cannot add new entry to bus_to_phys\n");
>  			xen_destroy_contiguous_region(phys, order);
>  			kfree(dma_info);
>  			return NULL;
>  		}
> +		spin_unlock_irqrestore(&swiotlb_lock, irqflags);
>  	}
>  	memset(ret, 0, size);
>  	return ret;
> @@ -532,6 +583,7 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
>  	phys_addr_t phys;
>  	u64 dma_mask = DMA_BIT_MASK(32);
>  	struct xen_dma_info *dma_info = NULL;
> +	unsigned long flags;
>  
>  	if (dma_release_from_coherent(hwdev, order, vaddr))
>  		return;
> @@ -539,6 +591,7 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
>  	if (hwdev && hwdev->coherent_dma_mask)
>  		dma_mask = hwdev->coherent_dma_mask;
>  
> +	spin_lock_irqsave(&swiotlb_lock, flags);
>  	/* do not use virt_to_phys because on ARM it doesn't return you the
>  	 * physical address */
>  	phys = xen_bus_to_phys(dev_addr);
> @@ -546,12 +599,16 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
>  	if (xen_feature(XENFEAT_auto_translated_physmap) ||
>  		(((dev_addr + size - 1 > dma_mask)) ||
>  		 range_straddles_page_boundary(phys, size))) {
> -		xen_destroy_contiguous_region(phys, order);
>  		dma_info = xen_get_dma_info_from_dma(dev_addr);
> -		rb_erase(&dma_info->rbnode, &bus_to_phys);
> -		kfree(dma_info);
> +		if (atomic_dec_and_test(&dma_info->refs)) {
> +			xen_destroy_contiguous_region(phys & PAGE_MASK, order);
> +			rb_erase(&dma_info->rbnode_dma, &bus_to_phys);
> +			rb_erase(&dma_info->rbnode_phys, &phys_to_bus);
> +			kfree(dma_info);
> +		}

If xen_pin_dev_page failed or was not called we would still end up
calling this. And we would decrement a potentially garbage value? Or not.
>  	}
>  
> +	spin_unlock_irqrestore(&swiotlb_lock, flags);
>  	xen_free_coherent_pages(hwdev, size, vaddr, (dma_addr_t)phys, attrs);
>  }
>  EXPORT_SYMBOL_GPL(xen_swiotlb_free_coherent);
> @@ -583,6 +640,23 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
>  		return dev_addr;
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap) &&
> +		size <= PAGE_SIZE &&
> +		!range_straddles_page_boundary(phys, size) &&
> +		!swiotlb_force) {
> +		unsigned long flags;
> +		int rc;
> +
> +		spin_lock_irqsave(&swiotlb_lock, flags);
> +		rc = xen_pin_dev_page(dev, phys, &dev_addr);
> +		spin_unlock_irqrestore(&swiotlb_lock, flags);
> +
> +		if (!rc) {
> +			dma_mark_clean(phys_to_virt(phys), size);
> +			return dev_addr;
> +		}

And if there is an rc you should probably do
		dev_warn(.., "RC ..")


But more importantly - all of this code adds an extra lock on the X86 side
which will get -ENOxxx on the xen_pin_dev_page.

I am wondering if it makes sense to make most of this code dependent
on CONFIG_ARM? As the check for auto-xlat falls flat on X86 + PVH. Thought
I have no idea what we want to do with PVH and X86 at this point.

> +	}
> +
>  	/*
>  	 * Oh well, have to allocate and map a bounce buffer.
>  	 * Pass the dma_addr of the first slab in the iotlb buffer as
> @@ -618,10 +692,37 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
>  static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
>  			     size_t size, enum dma_data_direction dir)
>  {
> -	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
> +	struct xen_dma_info *dma_info;
> +	phys_addr_t paddr = DMA_ERROR_CODE;
> +	char *vaddr = NULL;
> +	unsigned long flags;
>  
>  	BUG_ON(dir == DMA_NONE);
>  
> +	spin_lock_irqsave(&swiotlb_lock, flags);
> +	dma_info = xen_get_dma_info_from_dma(dev_addr);
> +	if (dma_info != NULL) {
> +		paddr = dma_info->phys_addr + (dev_addr - dma_info->dma_addr);
> +		vaddr = phys_to_virt(paddr);
> +	}
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap) &&
> +		paddr != DMA_ERROR_CODE &&
> +		!(vaddr >= xen_io_tlb_start && vaddr < xen_io_tlb_end) &&
> +		!swiotlb_force) {
> +		if (atomic_dec_and_test(&dma_info->refs)) {
> +			xen_destroy_contiguous_region(paddr & PAGE_MASK, 0);
> +			rb_erase(&dma_info->rbnode_dma, &bus_to_phys);
> +			rb_erase(&dma_info->rbnode_phys, &phys_to_bus);
> +			kfree(dma_info);
> +		}
> +		spin_unlock_irqrestore(&swiotlb_lock, flags);
> +		if ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL))
> +			dma_mark_clean(vaddr, size);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&swiotlb_lock, flags);
> +
>  	/* NOTE: We use dev_addr here, not paddr! */
>  	if (is_xen_swiotlb_buffer(dev_addr)) {
>  		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
> @@ -664,9 +765,19 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
>  			enum dma_sync_target target)
>  {
>  	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
> +	char *vaddr = phys_to_virt(paddr);
>  
>  	BUG_ON(dir == DMA_NONE);
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap) &&
> +		paddr != DMA_ERROR_CODE &&
> +		size <= PAGE_SIZE &&
> +		!(vaddr >= xen_io_tlb_start && vaddr < xen_io_tlb_end) &&
> +		!range_straddles_page_boundary(paddr, size) && !swiotlb_force) {
> +		dma_mark_clean(vaddr, size);		
> +		return;
> +	}
> +
>  	/* NOTE: We use dev_addr here, not paddr! */
>  	if (is_xen_swiotlb_buffer(dev_addr)) {
>  		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
> @@ -717,13 +828,36 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  			 struct dma_attrs *attrs)
>  {
>  	struct scatterlist *sg;
> -	int i;
> +	int i, rc;
> +	u64 dma_mask = DMA_BIT_MASK(32);
> +	unsigned long flags;
>  
>  	BUG_ON(dir == DMA_NONE);
>  
> +	if (hwdev && hwdev->coherent_dma_mask)
> +		dma_mask = dma_alloc_coherent_mask(hwdev, GFP_KERNEL);
> +
>  	for_each_sg(sgl, sg, nelems, i) {
>  		phys_addr_t paddr = sg_phys(sg);
> -		dma_addr_t dev_addr = xen_phys_to_bus_quick(paddr);
> +		dma_addr_t dev_addr;
> +
> +		if (xen_feature(XENFEAT_auto_translated_physmap) &&
> +			!range_straddles_page_boundary(paddr, sg->length) &&
> +			sg->length <= PAGE_SIZE &&
> +			!swiotlb_force) {
> +
> +			spin_lock_irqsave(&swiotlb_lock, flags);
> +			rc = xen_pin_dev_page(hwdev, paddr, &dev_addr);
> +			spin_unlock_irqrestore(&swiotlb_lock, flags);
> +
> +			if (!rc) {
> +				dma_mark_clean(phys_to_virt(paddr), sg->length);
> +				sg_dma_len(sg) = sg->length;
> +				sg->dma_address = dev_addr;
> +				continue;
> +			}
> +		}
> +		dev_addr = xen_phys_to_bus_quick(paddr);
>  
>  		if (swiotlb_force ||
>  		    xen_feature(XENFEAT_auto_translated_physmap) ||
> -- 
> 1.7.2.5
> 
