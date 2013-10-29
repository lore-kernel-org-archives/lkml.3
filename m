Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab3J2R0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:26:04 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21446 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab3J2R0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:26:02 -0400
X-IronPort-AV: E=Sophos;i="4.93,594,1378857600"; 
   d="scan'208";a="65923201"
Date: Tue, 29 Oct 2013 17:24:50 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>,
        <will.deacon@arm.com>
Subject: Re: [PATCH v9 01/18] arm: make SWIOTLB available
In-Reply-To: <20131029142626.GQ16735@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1310291716120.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com> <1382698313-13161-1-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1310251206450.26077@kaball.uk.xensource.com> <alpine.DEB.2.02.1310290441260.26077@kaball.uk.xensource.com>
 <20131029142023.GE20487@phenom.dumpdata.com> <20131029142626.GQ16735@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, Russell King - ARM Linux wrote:
> On Tue, Oct 29, 2013 at 10:20:23AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, Oct 29, 2013 at 04:41:40AM +0000, Stefano Stabellini wrote:
> > > ping?
> > 
> > You know you are pinging yourself, right ? :-)
> 
> And the patch was only Cc'd.  I'm starting to read stuff which isn't
> flagged as having me in the To: line with less priority in recent times.

good to know


> > > On Fri, 25 Oct 2013, Stefano Stabellini wrote:
> > > > Russell,
> > > > this is the only patch that needs an ack at the moment.
> > > > As you commented on it before and I have already addressed your comments
> > > > few versions ago, unless you have any complaints I am going to add it to
> > > > linux-next and I am thinking of merging it during the next merge window.
> > > > 
> > > > On Fri, 25 Oct 2013, Stefano Stabellini wrote:
> > > > > IOMMU_HELPER is needed because SWIOTLB calls iommu_is_span_boundary,
> > > > > provided by lib/iommu_helper.c.
> > > > > 
> > > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > > Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > > CC: will.deacon@arm.com
> > > > > CC: linux@arm.linux.org.uk
> > > > > 
> > > > > 
> > > > > Changes in v8:
> > > > > - use __phys_to_pfn and __pfn_to_phys.
> > > > > 
> > > > > Changes in v7:
> > > > > - dma_mark_clean: empty implementation;
> > > > > - in dma_capable use coherent_dma_mask if dma_mask hasn't been
> > > > >   allocated.
> > > > > 
> > > > > Changes in v6:
> > > > > - check for dev->dma_mask being NULL in dma_capable.
> > > > > 
> > > > > Changes in v5:
> > > > > - implement dma_mark_clean using dmac_flush_range.
> > > > > 
> > > > > Changes in v3:
> > > > > - dma_capable: do not treat dma_mask as a limit;
> > > > > - remove SWIOTLB dependency on NEED_SG_DMA_LENGTH.
> > > > > ---
> > > > >  arch/arm/Kconfig                   |    6 +++++
> > > > >  arch/arm/include/asm/dma-mapping.h |   37 ++++++++++++++++++++++++++++++++++++
> > > > >  2 files changed, 43 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > > > index 1ad6fb6..b08374f 100644
> > > > > --- a/arch/arm/Kconfig
> > > > > +++ b/arch/arm/Kconfig
> > > > > @@ -1872,6 +1872,12 @@ config CC_STACKPROTECTOR
> > > > >  	  neutralized via a kernel panic.
> > > > >  	  This feature requires gcc version 4.2 or above.
> > > > >  
> > > > > +config SWIOTLB
> > > > > +	def_bool y
> > > > > +
> > > > > +config IOMMU_HELPER
> > > > > +	def_bool SWIOTLB
> > > > > +
> > > > >  config XEN_DOM0
> > > > >  	def_bool y
> > > > >  	depends on XEN
> > > > > diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> > > > > index 5b579b9..01b5a3d 100644
> > > > > --- a/arch/arm/include/asm/dma-mapping.h
> > > > > +++ b/arch/arm/include/asm/dma-mapping.h
> > > > > @@ -10,6 +10,7 @@
> > > > >  
> > > > >  #include <asm-generic/dma-coherent.h>
> > > > >  #include <asm/memory.h>
> > > > > +#include <asm/cacheflush.h>
> 
> Why does this need to be here?  Your'e not adding anything which
> needs it.

Legacy of a previous iteration of the patch. I'll remove it.


> > > > > +static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> > > > > +{
> > > > > +	unsigned int offset = paddr & ~PAGE_MASK;
> > > > > +	return pfn_to_dma(dev, __phys_to_pfn(paddr)) + offset;
> > > > > +}
> > > > > +
> > > > > +static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
> > > > > +{
> > > > > +	unsigned int offset = dev_addr & ~PAGE_MASK;
> > > > > +	return __pfn_to_phys(dma_to_pfn(dev, dev_addr)) + offset;
> > > > > +}
> 
> These look fine.
> 
> > > > > +static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
> > > > > +{
> > > > > +	u64 limit, mask;
> > > > > +	
> > > > > +	if (dev->dma_mask)
> > > > > +		mask = *dev->dma_mask;
> > > > > +	else 
> > > > > +		mask = dev->coherent_dma_mask;
> 
> This looks like a hack.  Either we want to use the streaming mask or
> the coherent mask as appropriate for the caller.  That should be a choice
> the caller makes, not the implementation of this behind the callers back.

How should I choose?
Admittedly this is a workaround because some drivers (including Calxeda
xgmac) don't set the dma_mask when they should:

http://marc.info/?l=linux-arm-kernel&m=138082570519601&w=2

I am happy to reduce this to:

if (dev->dma_mask)
    mask = *dev->dma_mask;

even though it means that xgmac & co won't be dma_capable.


> > > > > +
> > > > > +	if (mask == 0)
> > > > > +		return 0;
> > > > > +
> > > > > +	limit = (mask + 1) & ~mask;
> > > > > +	if (limit && size > limit)
> > > > > +		return 0;
> > > > > +
> > > > > +	if ((addr | (addr + size - 1)) & ~mask)
> > > > > +		return 0;
> > > > > +
> > > > > +	return 1;
> > > > > +}
> 
> The remainder looks fine to me.
> 
