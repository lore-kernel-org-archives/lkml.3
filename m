Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3J3Rgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:36:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:1795 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885Ab3J3Rgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:36:50 -0400
X-IronPort-AV: E=Sophos;i="4.93,602,1378857600"; 
   d="scan'208";a="66379331"
Date: Wed, 30 Oct 2013 17:35:39 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: linux-next: manual merge of the xen-tip tree with the  tree
In-Reply-To: <alpine.DEB.2.02.1310301733230.26077@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1310301734420.26077@kaball.uk.xensource.com>
References: <20131030160956.dfa5c1900c2decb0018061b9@canb.auug.org.au> <alpine.DEB.2.02.1310301733230.26077@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013, Stefano Stabellini wrote:
> Looks fine thanks!
> Just an heads up: I'll be updating the Xen code below soon so this
> conflict might come up again.

Just to be clear: I meant the dma_capable function.
Sorry for top posting.


> On Wed, 30 Oct 2013, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the xen-tip tree got a conflict in
> > arch/arm/include/asm/dma-mapping.h between commit 223016339ce7 ("ARM:
> > 7805/1: mm: change max*pfn to include the physical offset of memory")
> > from the arm tree and commit 06e6295bcece ("arm: make SWIOTLB available")
> > from the xen-tip tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc arch/arm/include/asm/dma-mapping.h
> > index 863cd84eb1a2,f5945d4e4e9f..000000000000
> > --- a/arch/arm/include/asm/dma-mapping.h
> > +++ b/arch/arm/include/asm/dma-mapping.h
> > @@@ -87,13 -98,42 +99,49 @@@ static inline dma_addr_t virt_to_dma(st
> >   }
> >   #endif
> >   
> >  +/* The ARM override for dma_max_pfn() */
> >  +static inline unsigned long dma_max_pfn(struct device *dev)
> >  +{
> >  +	return PHYS_PFN_OFFSET + dma_to_pfn(dev, *dev->dma_mask);
> >  +}
> >  +#define dma_max_pfn(dev) dma_max_pfn(dev)
> >  +
> > + static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> > + {
> > + 	unsigned int offset = paddr & ~PAGE_MASK;
> > + 	return pfn_to_dma(dev, __phys_to_pfn(paddr)) + offset;
> > + }
> > + 
> > + static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
> > + {
> > + 	unsigned int offset = dev_addr & ~PAGE_MASK;
> > + 	return __pfn_to_phys(dma_to_pfn(dev, dev_addr)) + offset;
> > + }
> > + 
> > + static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
> > + {
> > + 	u64 limit, mask;
> > + 	
> > + 	if (dev->dma_mask)
> > + 		mask = *dev->dma_mask;
> > + 	else 
> > + 		mask = dev->coherent_dma_mask;
> > + 
> > + 	if (mask == 0)
> > + 		return 0;
> > + 
> > + 	limit = (mask + 1) & ~mask;
> > + 	if (limit && size > limit)
> > + 		return 0;
> > + 
> > + 	if ((addr | (addr + size - 1)) & ~mask)
> > + 		return 0;
> > + 
> > + 	return 1;
> > + }
> > + 
> > + static inline void dma_mark_clean(void *addr, size_t size) { }
> > + 
> >   /*
> >    * DMA errors are defined by all-bits-set in the DMA address.
> >    */
> > 
> 
