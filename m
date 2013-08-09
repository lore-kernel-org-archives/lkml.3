Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968009Ab3HIPqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:46:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27077 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964975Ab3HIPqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:46:30 -0400
Date: Fri, 9 Aug 2013 11:45:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v3 09/10] swiotlb-xen: support autotranslate guests
Message-ID: <20130809154558.GG5637@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1308051503190.4893@kaball.uk.xensource.com>
 <1375720256-8014-9-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375720256-8014-9-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n Mon, Aug 05, 2013 at 05:30:55PM +0100, Stefano Stabellini wrote:
> Support autotranslate guests in swiotlb-xen by keeping track of the
> phys-to-bus and bus-to-phys mappings of the swiotlb buffer
> (xen_io_tlb_start-xen_io_tlb_end).
> 
> Use a simple direct access on a pre-allocated array for phys-to-bus
> queries. Use a red-black tree for bus-to-phys queries.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> 
> 
> Changes in v3:
> - many code style and name changes;
> - improve error checks in xen_dma_add_entry.
> ---
>  drivers/xen/swiotlb-xen.c |  160 ++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 144 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index b72f31c..5e9ac83 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -38,32 +38,146 @@
>  #include <linux/bootmem.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/export.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock_types.h>
> +#include <linux/rbtree.h>
>  #include <xen/swiotlb-xen.h>
>  #include <xen/page.h>
>  #include <xen/xen-ops.h>
>  #include <xen/hvc-console.h>
> +#include <xen/features.h>
>  /*
>   * Used to do a quick range check in swiotlb_tbl_unmap_single and
>   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
>   * API.
>   */
>  
> +#define NR_DMA_SEGS  ((xen_io_tlb_nslabs + IO_TLB_SEGSIZE - 1) / IO_TLB_SEGSIZE)
>  static char *xen_io_tlb_start, *xen_io_tlb_end;
>  static unsigned long xen_io_tlb_nslabs;
>  /*
>   * Quick lookup value of the bus address of the IOTLB.
>   */
>  
> -static u64 start_dma_addr;
> +struct xen_dma_info {
> +	dma_addr_t dma_addr;
> +	phys_addr_t phys_addr;
> +	size_t size;
> +	struct rb_node rbnode;
> +};
> +
> +/*
> + * This array of struct xen_dma_info is indexed by physical addresses,
> + * starting from virt_to_phys(xen_io_tlb_start). Each entry maps
> + * (IO_TLB_SEGSIZE << IO_TLB_SHIFT) bytes, except the last one that is
> + * smaller. Getting the dma address corresponding to a given physical
> + * address can be done by direct access with the right index on the
> + * array.
> + */
> +static struct xen_dma_info *xen_dma_seg;
> +/* 
> + * This tree keeps track of bus address to physical address
> + * mappings.
> + */
> +static struct rb_root bus_to_phys = RB_ROOT;
> +/* This lock protects operations on the bus_to_phys tree */
> +static DEFINE_SPINLOCK(xen_bus_to_phys_lock);
> +
> +static int xen_dma_add_entry(struct xen_dma_info *new)
> +{
> +	struct rb_node **link = &bus_to_phys.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct xen_dma_info *entry;
> +
> +	spin_lock(&xen_bus_to_phys_lock);
> +
> +	while (*link) {
> +		parent = *link;
> +		entry = rb_entry(parent, struct xen_dma_info, rbnode);
> +
> +		if (new->dma_addr == entry->dma_addr) {
> +			spin_unlock(&xen_bus_to_phys_lock);
> +			pr_warn("%s: cannot add phys=0x%pa -> dma=0x%pa, the dma address is already present, mapping to 0x%pa\n",
> +					__func__, &new->phys_addr,
> +					&new->dma_addr, &entry->phys_addr);
> +			return -EINVAL;
> +		}
> +		if (new->phys_addr == entry->phys_addr) {
> +			spin_unlock(&xen_bus_to_phys_lock);
> +			pr_warn("%s: cannot add phys=0x%pa -> dma=0x%pa, the phys address is already present, mapping to 0x%pa\n",
> +					__func__, &new->phys_addr,
> +					&new->dma_addr, &entry->dma_addr);
> +			return -EINVAL;

How about adding a
"err_out:
spin_unlock(...)
pr_warn(..)
return -EINVAL:
at the end of the function (past the return 0) and just do a goto err_out here.

> +		}
> +
> +		if (new->dma_addr < entry->dma_addr)
> +			link = &(*link)->rb_left;
> +		else
> +			link = &(*link)->rb_right;
> +	}
> +	rb_link_node(&new->rbnode, parent, link);
> +	rb_insert_color(&new->rbnode, &bus_to_phys);
> +
> +	spin_unlock(&xen_bus_to_phys_lock);
> +	return 0;
> +}
> +
> +static struct xen_dma_info *xen_get_dma_info(dma_addr_t dma_addr)
> +{
> +	struct rb_node *n = bus_to_phys.rb_node;
> +	struct xen_dma_info *entry;
> +
> +	spin_lock(&xen_bus_to_phys_lock);
> +
> +	while (n) {
> +		entry = rb_entry(n, struct xen_dma_info, rbnode);
> +		if (entry->dma_addr <= dma_addr &&
> +				entry->dma_addr + entry->size > dma_addr) {
> +			spin_unlock(&xen_bus_to_phys_lock);
> +			return entry;
> +		}
> +		if (dma_addr < entry->dma_addr)
> +			n = n->rb_left;
> +		else
> +			n = n->rb_right;
> +	}
> +
> +	spin_unlock(&xen_bus_to_phys_lock);
> +	return NULL;
> +}
> +
> +#define INVALID_ADDRESS   ~0

s/INVALID_ADDRESS/DMA_ERROR_CODE/

>  
>  static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
>  {
> -	return phys_to_machine(XPADDR(paddr)).maddr;
> +	int nr_seg;
> +	unsigned long offset;
> +	char *vaddr;
> +
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> +		return phys_to_machine(XPADDR(paddr)).maddr;
> +
> +	vaddr = (char *) phys_to_virt(paddr);

The space there is not needed.

> +	if (vaddr >= xen_io_tlb_end || vaddr < xen_io_tlb_start)
> +		return INVALID_ADDRESS;
> +
> +	offset = vaddr - xen_io_tlb_start;
> +	nr_seg = offset / (IO_TLB_SEGSIZE << IO_TLB_SHIFT);
> +
> +	return xen_dma_seg[nr_seg].dma_addr +
> +		(paddr - xen_dma_seg[nr_seg].phys_addr);
>  }
>  
>  static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
>  {
> -	return machine_to_phys(XMADDR(baddr)).paddr;
> +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +		struct xen_dma_info *dma = xen_get_dma_info(baddr);
> +		if (dma == NULL)
> +			return INVALID_ADDRESS;
> +		else
> +			return dma->phys_addr + (baddr - dma->dma_addr);
> +	} else
> +		return machine_to_phys(XMADDR(baddr)).paddr;
>  }
>  
>  static dma_addr_t xen_virt_to_bus(void *address)
> @@ -107,6 +221,9 @@ static int is_xen_swiotlb_buffer(dma_addr_t dma_addr)
>  	unsigned long pfn = mfn_to_local_pfn(mfn);
>  	phys_addr_t paddr;
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return 1;
> +
>  	/* If the address is outside our domain, it CAN
>  	 * have the same virtual address as another address
>  	 * in our domain. Therefore _only_ check address within our domain.
> @@ -124,13 +241,12 @@ static int max_dma_bits = 32;
>  static int
>  xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
>  {
> -	int i, rc;
> +	int i, j, rc;
>  	int dma_bits;
> -	dma_addr_t dma_handle;
>  
>  	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
>  
> -	i = 0;
> +	i = j = 0;
>  	do {
>  		int slabs = min(nslabs - i, (unsigned long)IO_TLB_SEGSIZE);
>  
> @@ -138,12 +254,18 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
>  			rc = xen_create_contiguous_region(
>  				(unsigned long)buf + (i << IO_TLB_SHIFT),
>  				get_order(slabs << IO_TLB_SHIFT),
> -				dma_bits, &dma_handle);
> +				dma_bits, &xen_dma_seg[j].dma_addr);
>  		} while (rc && dma_bits++ < max_dma_bits);
>  		if (rc)
>  			return rc;
>  
> +		xen_dma_seg[j].phys_addr = virt_to_phys(buf + (i << IO_TLB_SHIFT));
> +		xen_dma_seg[j].size = slabs << IO_TLB_SHIFT;
> +		rc = xen_dma_add_entry(&xen_dma_seg[j]);
> +		if (rc != 0)
> +			return rc;
>  		i += slabs;
> +		j++;
>  	} while (i < nslabs);
>  	return 0;
>  }
> @@ -193,9 +315,10 @@ retry:
>  	/*
>  	 * Get IO TLB memory from any location.
>  	 */
> -	if (early)
> +	if (early) {
>  		xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
> -	else {
> +		xen_dma_seg = alloc_bootmem(sizeof(struct xen_dma_info) * NR_DMA_SEGS);

So what if the user over-wrote the size of the SWITOLB? Meaning the nslabs is different?
Won't that blow up in  xen_swiotlb_fixup if we try to dereference past the array?

> +	} else {
>  #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
>  #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
>  		while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
> @@ -210,6 +333,8 @@ retry:
>  			xen_io_tlb_nslabs = SLABS_PER_PAGE << order;
>  			bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
>  		}
> +		xen_dma_seg = kzalloc(sizeof(struct xen_dma_info) * NR_DMA_SEGS,
> +				GFP_KERNEL);

Ditto.
>  	}
>  	if (!xen_io_tlb_start) {
>  		m_ret = XEN_SWIOTLB_ENOMEM;
> @@ -232,7 +357,6 @@ retry:
>  		m_ret = XEN_SWIOTLB_EFIXUP;
>  		goto error;
>  	}
> -	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
>  	if (early) {
>  		if (swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs,
>  			 verbose))
> @@ -290,7 +414,8 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  
>  	phys = virt_to_phys(ret);
>  	dev_addr = xen_phys_to_bus(phys);
> -	if (((dev_addr + size - 1 <= dma_mask)) &&
> +	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
> +	    ((dev_addr + size - 1 <= dma_mask)) &&
>  	    !range_straddles_page_boundary(phys, size))
>  		*dma_handle = dev_addr;
>  	else {
> @@ -321,8 +446,9 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
>  
>  	phys = virt_to_phys(vaddr);
>  
> -	if (((dev_addr + size - 1 > dma_mask)) ||
> -	    range_straddles_page_boundary(phys, size))
> +	if (xen_feature(XENFEAT_auto_translated_physmap) ||
> +		(((dev_addr + size - 1 > dma_mask)) ||
> +		 range_straddles_page_boundary(phys, size)))
>  		xen_destroy_contiguous_region((unsigned long)vaddr, order);
>  
>  	free_pages((unsigned long)vaddr, order);
> @@ -351,14 +477,15 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  	 * we can safely return the device addr and not worry about bounce
>  	 * buffering it.
>  	 */
> -	if (dma_capable(dev, dev_addr, size) &&
> +	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
> +	    dma_capable(dev, dev_addr, size) &&
>  	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
>  		return dev_addr;
>  
>  	/*
>  	 * Oh well, have to allocate and map a bounce buffer.
>  	 */
> -	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir);
> +	map = swiotlb_tbl_map_single(dev, xen_dma_seg[0].dma_addr, phys, size, dir);

That [0] really deserves a comment.


>  	if (map == SWIOTLB_MAP_ERROR)
>  		return DMA_ERROR_CODE;
>  
> @@ -494,10 +621,11 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
>  
>  		if (swiotlb_force ||
> +		    xen_feature(XENFEAT_auto_translated_physmap) ||
>  		    !dma_capable(hwdev, dev_addr, sg->length) ||
>  		    range_straddles_page_boundary(paddr, sg->length)) {
>  			phys_addr_t map = swiotlb_tbl_map_single(hwdev,
> -								 start_dma_addr,
> +								 xen_dma_seg[0].dma_addr,

Ditto
>  								 sg_phys(sg),
>  								 sg->length,
>  								 dir);
> -- 
> 1.7.2.5
> 
