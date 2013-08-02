Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3HBQZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:25:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43355 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3HBQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:25:47 -0400
X-IronPort-AV: E=Sophos;i="4.89,802,1367971200"; 
   d="scan'208";a="39081950"
Date: Fri, 2 Aug 2013 17:25:32 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH RFC 8/8] xen/arm,arm64: enable SWIOTLB_XEN
In-Reply-To: <20130802124000.GJ24540@konrad-lan.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1308021717330.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com> <1375292732-7627-8-git-send-email-stefano.stabellini@eu.citrix.com> <20130802124000.GJ24540@konrad-lan.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Aug 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Jul 31, 2013 at 06:45:32PM +0100, Stefano Stabellini wrote:
> > Xen on arm and arm64 needs SWIOTLB_XEN: when running on Xen we need to
> > program the hardware with mfns rather than pfns for dma addresses.
> > Remove SWIOTLB_XEN dependency on X86 and PCI and make XEN select
> > SWIOTLB_XEN on arm and arm64.
> > 
> > Implement xen_create_contiguous_region on arm and arm64 by using
> > XENMEM_get_dma_buf.
> > 
> > Initialize the xen-swiotlb from xen_early_init (before the native
> > dma_ops are initialized), set dma_ops to &xen_swiotlb_dma_ops if we are
> > running on Xen.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/Kconfig                |    1 +
> >  arch/arm/include/asm/xen/page.h |    2 +
> >  arch/arm/xen/Makefile           |    2 +-
> >  arch/arm/xen/enlighten.c        |    3 +
> >  arch/arm/xen/mm.c               |  118 +++++++++++++++++++++++++++++++++++++++
> >  arch/arm64/Kconfig              |    1 +
> >  arch/arm64/xen/Makefile         |    2 +-
> >  drivers/xen/Kconfig             |    1 -
> >  drivers/xen/swiotlb-xen.c       |   18 ++++++
> >  9 files changed, 145 insertions(+), 3 deletions(-)
> >  create mode 100644 arch/arm/xen/mm.c
> > 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 05125ab..72b53b9 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1849,6 +1849,7 @@ config XEN
> >  	depends on CPU_V7 && !CPU_V6
> >  	depends on !GENERIC_ATOMIC64
> >  	select ARM_PSCI
> > +	select SWIOTLB_XEN
> >  	help
> >  	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
> >  
> > diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> > index 359a7b5..b0f7150 100644
> > --- a/arch/arm/include/asm/xen/page.h
> > +++ b/arch/arm/include/asm/xen/page.h
> > @@ -6,12 +6,14 @@
> >  
> >  #include <linux/pfn.h>
> >  #include <linux/types.h>
> > +#include <linux/dma-mapping.h>
> >  
> >  #include <xen/interface/grant_table.h>
> >  
> >  #define pfn_to_mfn(pfn)			(pfn)
> >  #define phys_to_machine_mapping_valid(pfn) (1)
> >  #define mfn_to_pfn(mfn)			(mfn)
> > +#define mfn_to_local_pfn(m)             (mfn_to_pfn(m))
> >  #define mfn_to_virt(m)			(__va(mfn_to_pfn(m) << PAGE_SHIFT))
> >  
> >  #define pte_mfn	    pte_pfn
> > diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
> > index 4384103..66fc35d 100644
> > --- a/arch/arm/xen/Makefile
> > +++ b/arch/arm/xen/Makefile
> > @@ -1 +1 @@
> > -obj-y		:= enlighten.o hypercall.o grant-table.o
> > +obj-y		:= enlighten.o hypercall.o grant-table.o mm.o
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index 14d17ab..06a6953 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -195,6 +195,7 @@ static void xen_power_off(void)
> >   * documentation of the Xen Device Tree format.
> >   */
> >  #define GRANT_TABLE_PHYSADDR 0
> > +extern int xen_mm_init(void);
> >  void __init xen_early_init(void)
> >  {
> >  	struct resource res;
> > @@ -230,6 +231,8 @@ void __init xen_early_init(void)
> >  		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
> >  	else
> >  		xen_start_info->flags &= ~(SIF_INITDOMAIN|SIF_PRIVILEGED);
> > +
> > +	xen_mm_init();
> >  }
> >  
> >  static int __init xen_guest_init(void)
> > diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
> > new file mode 100644
> > index 0000000..4ba1add
> > --- /dev/null
> > +++ b/arch/arm/xen/mm.c
> > @@ -0,0 +1,118 @@
> > +#include <linux/bootmem.h>
> > +#include <linux/gfp.h>
> > +#include <linux/export.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/swiotlb.h>
> > +
> > +#include <xen/xen.h>
> > +#include <xen/interface/memory.h>
> > +#include <xen/swiotlb-xen.h>
> > +
> > +#include <asm/cacheflush.h>
> > +#include <asm/xen/page.h>
> > +#include <asm/xen/hypercall.h>
> > +#include <asm/xen/interface.h>
> > +
> > +static int xen_exchange_memory(xen_ulong_t extents_in,
> > +			       unsigned int order_in,
> > +			       xen_pfn_t *pfns_in,
> > +			       xen_ulong_t extents_out,
> > +			       unsigned int order_out,
> > +			       xen_pfn_t *mfns_out,
> > +			       unsigned int address_bits)
> > +{
> > +	long rc;
> > +	int success;
> > +
> > +	struct xen_memory_exchange exchange = {
> > +		.in = {
> > +			.nr_extents   = extents_in,
> > +			.extent_order = order_in,
> > +			.domid        = DOMID_SELF
> > +		},
> > +		.out = {
> > +			.nr_extents   = extents_out,
> > +			.extent_order = order_out,
> > +			.address_bits = address_bits,
> > +			.domid        = DOMID_SELF
> > +		}
> > +	};
> > +	set_xen_guest_handle(exchange.in.extent_start, pfns_in);
> > +	set_xen_guest_handle(exchange.out.extent_start, mfns_out);
> > +
> > +	BUG_ON(extents_in << order_in != extents_out << order_out);
> > +
> > +
> > +	rc = HYPERVISOR_memory_op(XENMEM_get_dma_buf, &exchange);
> > +	success = (exchange.nr_exchanged == extents_in);
> > +
> > +	BUG_ON(!success && ((exchange.nr_exchanged != 0) || (rc == 0)));
> > +	BUG_ON(success && (rc != 0));
> > +
> > +	return success;
> > +}
> 
> Could this code be made out to be more generic? It is almost the same on
> x86 - it just a different hypercall.

Maybe, but I wasn't planning on implementing XENMEM_get_dma_buf on x86
(guest_physmap_pin_range and guest_physmap_unpin_range in particular),
mostly because I admit I don't quite understand the x86 page_type system
in Xen.
