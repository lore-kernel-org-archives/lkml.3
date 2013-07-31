Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab3GaTEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:04:00 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25336 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab3GaTD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:03:59 -0400
X-IronPort-AV: E=Sophos;i="4.89,788,1367971200"; 
   d="scan'208";a="40568563"
Date: Wed, 31 Jul 2013 20:03:46 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>, <david.vrabel@citrix.com>
Subject: Re: [PATCH RFC 7/8] swiotlb-xen: support autotranslate guests
In-Reply-To: <1375292732-7627-7-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1307312001450.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com> <1375292732-7627-7-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013, Stefano Stabellini wrote:
> Support autotranslate guests in swiotlb-xen by keeping track of the
> phys-to-bus and bus-to-phys mappings of the swiotlb buffer
> (xen_io_tlb_start-xen_io_tlb_end).
> 
> Use a simple direct access on a pre-allocated array for phys-to-bus
> queries. Use a red-black tree for bus-to-phys queries.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: david.vrabel@citrix.com
> ---
>  drivers/xen/swiotlb-xen.c |  127 +++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 111 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 353f013..c79ac88 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -38,32 +38,116 @@
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
> +struct xen_dma{
> +	dma_addr_t dma_addr;
> +	phys_addr_t phys_addr;
> +	size_t size;
> +	struct rb_node rbnode;
> +};
> +
> +static struct xen_dma *xen_dma_seg;
> +static struct rb_root bus_to_phys = RB_ROOT;
> +static DEFINE_SPINLOCK(xen_dma_lock);
> +
> +static void xen_dma_insert(struct xen_dma *entry)
> +{
> +	struct rb_node **link = &bus_to_phys.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct xen_dma *e;
> +
> +	spin_lock(&xen_dma_lock);
> +
> +	while (*link) {
> +		parent = *link;
> +		e = rb_entry(parent, struct xen_dma, rbnode);
> +
> +		WARN_ON(entry->dma_addr == e->dma_addr);
> +
> +		if (entry->dma_addr < e->dma_addr)
> +			link = &(*link)->rb_left;
> +		else
> +			link = &(*link)->rb_right;
> +	}
> +	rb_link_node(&entry->rbnode, parent, link);
> +	rb_insert_color(&entry->rbnode, &bus_to_phys);
> +
> +	spin_unlock(&xen_dma_lock);
> +}
> +
> +static struct xen_dma *xen_dma_retrieve(dma_addr_t dma_addr)
> +{
> +	struct rb_node *n = bus_to_phys.rb_node;
> +	struct xen_dma *e;
> +	
> +	spin_lock(&xen_dma_lock);
> +
> +	while (n) {
> +		e = rb_entry(n, struct xen_dma, rbnode);
> +		if (e->dma_addr <= dma_addr && e->dma_addr + e->size > dma_addr) {
> +			spin_unlock(&xen_dma_lock);
> +			return e;
> +		}
> +		if (dma_addr < e->dma_addr)
> +			n = n->rb_left;
> +		else
> +			n = n->rb_right;
> +	}
> +
> +	spin_unlock(&xen_dma_lock);
> +	return NULL;
> +}
>  
>  static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
>  {
> -	return phys_to_machine(XPADDR(paddr)).maddr;
> +	int nr_seg;
> +	unsigned long offset;
> +	char* vaddr;
> +
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> +		return phys_to_machine(XPADDR(paddr)).maddr;
> +
> +	vaddr = (char *) phys_to_virt(paddr);
> +	if (vaddr >= xen_io_tlb_end || vaddr < xen_io_tlb_start)
> +		return ~0;
> +
> +	offset = vaddr - xen_io_tlb_start;
> +	nr_seg = offset / (IO_TLB_SEGSIZE << IO_TLB_SHIFT);
> +
> +	return xen_dma_seg[nr_seg].dma_addr + (paddr & ((IO_TLB_SEGSIZE << IO_TLB_SHIFT) - 1));

I have just realized that there is a much better way of doing this:

return xen_dma_seg[nr_seg].dma_addr + (paddr - xen_dma_seg[nr_seg].phys_addr);


>  }
>  
>  static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
>  {
> -	return machine_to_phys(XMADDR(baddr)).paddr;
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +	{
> +		struct xen_dma *dma = xen_dma_retrieve(baddr);
> +		if (dma == NULL)
> +			return ~0;
> +		else
> +			return dma->phys_addr + (baddr & ((IO_TLB_SEGSIZE << IO_TLB_SHIFT) - 1));

same here:

return dma->phys_addr + (baddr - dma->dma_addr);
