Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3I3R1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:27:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22982 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3I3R1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:27:54 -0400
Date: Mon, 30 Sep 2013 13:27:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v6 18/19] swiotlb-xen: introduce a rbtree to track phys
 to bus mappings
Message-ID: <20130930172718.GY3106@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-18-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380298207-29151-18-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:10:06PM +0100, Stefano Stabellini wrote:
> Introduce a second red-back tree to track phys to bus mappings created after
> the initialization of the swiotlb buffer.

Could you explain the use case a bit more please?

As in:
 a) why is this needed
 b) why are we using the rb tree instead of something else (say FIFO queue)
 c) how long are these in usage?
 d) do we need locking now?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/swiotlb-xen.c |   99 +++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 83 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 3011736..022bcaf 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -79,7 +79,8 @@ struct xen_dma_info {
>  	dma_addr_t dma_addr;
>  	phys_addr_t phys_addr;
>  	size_t size;
> -	struct rb_node rbnode;
> +	struct rb_node rbnode_dma;
> +	struct rb_node rbnode_phys;
>  };
>  
>  /*
> @@ -96,8 +97,13 @@ static struct xen_dma_info *xen_dma_seg;
>   * mappings.
>   */
>  static struct rb_root bus_to_phys = RB_ROOT;
> +/*
> + * This tree keeps track of physical address to bus address
> + * mappings apart from the ones belonging to the initial swiotlb buffer.
> + */
> +static struct rb_root phys_to_bus = RB_ROOT;
>  
> -static int xen_dma_add_entry(struct xen_dma_info *new)
> +static int xen_dma_add_entry_bus(struct xen_dma_info *new)
>  {
>  	struct rb_node **link = &bus_to_phys.rb_node;
>  	struct rb_node *parent = NULL;
> @@ -106,7 +112,7 @@ static int xen_dma_add_entry(struct xen_dma_info *new)
>  
>  	while (*link) {
>  		parent = *link;
> -		entry = rb_entry(parent, struct xen_dma_info, rbnode);
> +		entry = rb_entry(parent, struct xen_dma_info, rbnode_dma);
>  
>  		if (new->dma_addr == entry->dma_addr)
>  			goto err_out;
> @@ -118,8 +124,41 @@ static int xen_dma_add_entry(struct xen_dma_info *new)
>  		else
>  			link = &(*link)->rb_right;
>  	}
> -	rb_link_node(&new->rbnode, parent, link);
> -	rb_insert_color(&new->rbnode, &bus_to_phys);
> +	rb_link_node(&new->rbnode_dma, parent, link);
> +	rb_insert_color(&new->rbnode_dma, &bus_to_phys);
> +	goto out;
> +
> +err_out:
> +	rc = -EINVAL;
> +	pr_warn("%s: cannot add phys=%pa -> dma=%pa: phys=%pa -> dma=%pa already exists\n",
> +			__func__, &new->phys_addr, &new->dma_addr, &entry->phys_addr, &entry->dma_addr);
> +out:
> +	return rc;
> +}
> +
> +static int xen_dma_add_entry_phys(struct xen_dma_info *new)
> +{
> +	struct rb_node **link = &phys_to_bus.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct xen_dma_info *entry;
> +	int rc = 0;
> +
> +	while (*link) {
> +		parent = *link;
> +		entry = rb_entry(parent, struct xen_dma_info, rbnode_phys);
> +
> +		if (new->dma_addr == entry->dma_addr)
> +			goto err_out;
> +		if (new->phys_addr == entry->phys_addr)
> +			goto err_out;
> +
> +		if (new->phys_addr < entry->phys_addr)
> +			link = &(*link)->rb_left;
> +		else
> +			link = &(*link)->rb_right;
> +	}
> +	rb_link_node(&new->rbnode_phys, parent, link);
> +	rb_insert_color(&new->rbnode_phys, &phys_to_bus);
>  	goto out;
>  
>  err_out:
> @@ -130,13 +169,22 @@ out:
>  	return rc;
>  }
>  
> +static int xen_dma_add_entry(struct xen_dma_info *new)
> +{
> +	int rc;
> +	if ((rc = xen_dma_add_entry_bus(new) < 0) ||
> +		(rc = xen_dma_add_entry_phys(new) < 0))

Please don't do that. Just do

	rc = xen_dma_add_entry(bus);
	if (rc)
		return rc;
	rc = xen_dma_add_entry_phys(new);
	if (rc) {
		// unwind it somehow? <<== This is important :-)
	}
	return rc;


> +		return rc;
> +	return 0;
> +}
> +
>  static struct xen_dma_info *xen_get_dma_info_from_dma(dma_addr_t dma_addr)
>  {
>  	struct rb_node *n = bus_to_phys.rb_node;
>  	struct xen_dma_info *entry;
>  
>  	while (n) {
> -		entry = rb_entry(n, struct xen_dma_info, rbnode);
> +		entry = rb_entry(n, struct xen_dma_info, rbnode_dma);
>  		if (entry->dma_addr <= dma_addr &&
>  				entry->dma_addr + entry->size > dma_addr) {
>  			return entry;
> @@ -150,11 +198,30 @@ static struct xen_dma_info *xen_get_dma_info_from_dma(dma_addr_t dma_addr)
>  	return NULL;
>  }
>  
> -static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
> +static struct xen_dma_info *xen_get_dma_info_from_phys(phys_addr_t phys)
>  {
> -	int nr_seg;
> -	unsigned long offset;
> -	char *vaddr;
> +	struct rb_node *n = phys_to_bus.rb_node;
> +	struct xen_dma_info *entry;
> +
> +	while (n) {
> +		entry = rb_entry(n, struct xen_dma_info, rbnode_phys);
> +		if (entry->phys_addr <= phys &&
> +				entry->phys_addr + entry->size > phys) {
> +			return entry;
> +		}
> +		if (phys < entry->phys_addr)
> +			n = n->rb_left;
> +		else
> +			n = n->rb_right;
> +	}
> +
> +	return NULL;
> +}
> +
> +/* Only looks into the initial buffer allocation in case of
> + * XENFEAT_auto_translated_physmap guests. */
> +static dma_addr_t xen_phys_to_bus_quick(phys_addr_t paddr) { int nr_seg;
> +	unsigned long offset; char *vaddr;
>  
>  	if (!xen_feature(XENFEAT_auto_translated_physmap))
>  		return phys_to_machine(XPADDR(paddr)).maddr;
> @@ -184,7 +251,7 @@ static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
>  
>  static dma_addr_t xen_virt_to_bus(void *address)
>  {
> -	return xen_phys_to_bus(virt_to_phys(address));
> +	return xen_phys_to_bus_quick(virt_to_phys(address));
>  }
>  
>  static int check_pages_physically_contiguous(unsigned long pfn,
> @@ -424,7 +491,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  	 * Do not use virt_to_phys(ret) because on ARM it doesn't correspond
>  	 * to *dma_handle. */
>  	phys = *dma_handle;
> -	dev_addr = xen_phys_to_bus(phys);
> +	dev_addr = xen_phys_to_bus_quick(phys);
>  	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
>  	    ((dev_addr + size - 1 <= dma_mask)) &&
>  	    !range_straddles_page_boundary(phys, size))
> @@ -503,7 +570,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  				struct dma_attrs *attrs)
>  {
>  	phys_addr_t map, phys = page_to_phys(page) + offset;
> -	dma_addr_t dev_addr = xen_phys_to_bus(phys);
> +	dma_addr_t dev_addr = xen_phys_to_bus_quick(phys);
>  
>  	BUG_ON(dir == DMA_NONE);
>  	/*
> @@ -527,7 +594,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  	if (map == SWIOTLB_MAP_ERROR)
>  		return DMA_ERROR_CODE;
>  
> -	dev_addr = xen_phys_to_bus(map);
> +	dev_addr = xen_phys_to_bus_quick(map);
>  
>  	/*
>  	 * Ensure that the address returned is DMA'ble
> @@ -656,7 +723,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  
>  	for_each_sg(sgl, sg, nelems, i) {
>  		phys_addr_t paddr = sg_phys(sg);
> -		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
> +		dma_addr_t dev_addr = xen_phys_to_bus_quick(paddr);
>  
>  		if (swiotlb_force ||
>  		    xen_feature(XENFEAT_auto_translated_physmap) ||
> @@ -682,7 +749,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  				sg_dma_len(sgl) = 0;
>  				return DMA_ERROR_CODE;
>  			}
> -			sg->dma_address = xen_phys_to_bus(map);
> +			sg->dma_address = xen_phys_to_bus_quick(map);
>  		} else
>  			sg->dma_address = dev_addr;
>  		sg_dma_len(sg) = sg->length;
> -- 
> 1.7.2.5
> 
