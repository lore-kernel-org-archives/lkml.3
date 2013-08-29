Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3H2QFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:05:54 -0400
Received: from smtp.citrix.com ([66.165.176.89]:51332 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab3H2QFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:05:53 -0400
X-IronPort-AV: E=Sophos;i="4.89,984,1367971200"; 
   d="scan'208";a="48795606"
Date: Thu, 29 Aug 2013 17:05:39 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v4 09/10] swiotlb-xen: support autotranslate guests
In-Reply-To: <20130815200738.GD5337@konrad-lan.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1308282112300.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com> <1376565054-24153-9-git-send-email-stefano.stabellini@eu.citrix.com> <20130815200738.GD5337@konrad-lan.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013, Konrad Rzeszutek Wilk wrote:
> On Thu, Aug 15, 2013 at 12:10:53PM +0100, Stefano Stabellini wrote:
> > Support autotranslate guests in swiotlb-xen by keeping track of the
> > phys-to-bus and bus-to-phys mappings of the swiotlb buffer
> > (xen_io_tlb_start-xen_io_tlb_end).
> > 
> > Use a simple direct access on a pre-allocated array for phys-to-bus
> > queries. Use a red-black tree for bus-to-phys queries.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> > 
> > 
> > Changes in v4:
> > - add err_out label in xen_dma_add_entry;
> > - remove INVALID_ADDRESS, use DMA_ERROR_CODE instead;
> > - code style fixes;
> > - add in-code comments regarding the usage of xen_dma_seg[0].dma_addr.
> > 
> > Changes in v3:
> > - many code style and name changes;
> > - improve error checks in xen_dma_add_entry.
> > ---
> >  drivers/xen/swiotlb-xen.c |  172 ++++++++++++++++++++++++++++++++++++++++----
> >  1 files changed, 156 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index b72f31c..8a403a0 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -38,32 +38,148 @@
> >  #include <linux/bootmem.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/export.h>
> > +#include <linux/slab.h>
> > +#include <linux/spinlock_types.h>
> > +#include <linux/rbtree.h>
> >  #include <xen/swiotlb-xen.h>
> >  #include <xen/page.h>
> >  #include <xen/xen-ops.h>
> >  #include <xen/hvc-console.h>
> > +#include <xen/features.h>
> >  /*
> >   * Used to do a quick range check in swiotlb_tbl_unmap_single and
> >   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
> >   * API.
> >   */
> >  
> > +#define NR_DMA_SEGS  ((xen_io_tlb_nslabs + IO_TLB_SEGSIZE - 1) / IO_TLB_SEGSIZE)
> >  static char *xen_io_tlb_start, *xen_io_tlb_end;
> >  static unsigned long xen_io_tlb_nslabs;
> >  /*
> >   * Quick lookup value of the bus address of the IOTLB.
> >   */
> >  
> > -static u64 start_dma_addr;
> > +struct xen_dma_info {
> > +	dma_addr_t dma_addr;
> > +	phys_addr_t phys_addr;
> > +	size_t size;
> > +	struct rb_node rbnode;
> > +};
> > +
> > +/*
> > + * This array of struct xen_dma_info is indexed by physical addresses,
> > + * starting from virt_to_phys(xen_io_tlb_start). Each entry maps
> > + * (IO_TLB_SEGSIZE << IO_TLB_SHIFT) bytes, except the last one that is
> > + * smaller. Getting the dma address corresponding to a given physical
> > + * address can be done by direct access with the right index on the
> > + * array.
> > + */
> > +static struct xen_dma_info *xen_dma_seg;
> > +/* 
> > + * This tree keeps track of bus address to physical address
> > + * mappings.
> > + */
> > +static struct rb_root bus_to_phys = RB_ROOT;
> > +/* This lock protects operations on the bus_to_phys tree */
> > +static DEFINE_SPINLOCK(xen_bus_to_phys_lock);
> > +
> > +static int xen_dma_add_entry(struct xen_dma_info *new)
> > +{
> > +	struct rb_node **link = &bus_to_phys.rb_node;
> > +	struct rb_node *parent = NULL;
> > +	struct xen_dma_info *entry;
> > +	int rc = 0;
> > +
> > +	spin_lock(&xen_bus_to_phys_lock);
> > +
> > +	while (*link) {
> > +		parent = *link;
> > +		entry = rb_entry(parent, struct xen_dma_info, rbnode);
> > +
> > +		if (new->dma_addr == entry->dma_addr) {
> > +			spin_unlock(&xen_bus_to_phys_lock);
> > +			pr_warn("%s: cannot add phys=0x%pa -> dma=0x%pa, the dma address is already present, mapping to 0x%pa\n",
> > +					__func__, &new->phys_addr,
> > +					&new->dma_addr, &entry->phys_addr);
> > +			rc = -EINVAL;
> > +			goto err_out;
> > +		}
> > +		if (new->phys_addr == entry->phys_addr) {
> > +			spin_unlock(&xen_bus_to_phys_lock);
> > +			pr_warn("%s: cannot add phys=0x%pa -> dma=0x%pa, the phys address is already present, mapping to 0x%pa\n",
> > +					__func__, &new->phys_addr,
> > +					&new->dma_addr, &entry->dma_addr);
> > +			rc = -EINVAL;
> 
> You didn't test this logic path, did you :-)
> 
> See the double spin_unlock?
> 
> I was thinking you could have the pr_warn in the err_out
> label code.

good suggestion, I'll do that


> Did you run any performance tests to see if adding the extra
> spinlock (as the native SWIOTLB already has its own lock) and handling
> of the tree is affecting it?
> 
> In the worst case when we do need to use the bounce buffer we end
> up using two spinlocks.
> 
> Is there perhaps a better way? Could we eliminate the usage of the
> spinlocks by doing some hashing and on the red-black trees having
> a lock? And moving that in the SWIOTLB generic code? Similar to how
> we do M2P or tmem does it? That would mean we could split up the
> mega 64MB buffer in smaller chunks - as the code (swiotlb) already
> assumes IO_TLB_SEGSIZE (128) slabs to allocate - which is 512kB
> contingous memory (If memory serves right). Altering the underlaying
> code from using an array to using an  hash and from the hash
> entries use the red-black trees. Or perhaps another array.
> Obviously you still need to reference the dma to virtual address
> lookup from the tree (as you have done here).
> 
> P.S.
> I am also the SWIOTLB maintainer, so it is OK to modify the SWIOTLB
> to be faster.

I haven't done any measurements but consider that the spin_lock is
already only used to access the red-black tree that keeps track of
dma_addr -> phys_addr mappings.
So it's taken at setup time once, then every time we call
xen_bus_to_phys and the guest is an autotraslate guest.
If the guest is not autotraslate there are no additional locks.

That makes me realize that we don't need any spin_locks at all: there
are no risks of concurrent accesses and modifications of the tree
because there are no changes on the tree once it's setup at boot time.
We can get rid of the spin_lock entirely as concurrent read accesses on
the tree are obviously fine.
