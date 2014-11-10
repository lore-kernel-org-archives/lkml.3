Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaKJKRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:17:04 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55366 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaKJKRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:17:01 -0500
Date: Mon, 10 Nov 2014 10:16:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
Message-ID: <20141110101645.GA21366@e104818-lin.cambridge.arm.com>
References: <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com>
 <20141106103337.GA19702@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com>
 <20141107110524.GA21875@localhost>
 <alpine.DEB.2.02.1411071212250.22875@kaball.uk.xensource.com>
 <20141107160006.GE29148@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411071646170.22875@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1411071732550.22875@kaball.uk.xensource.com>
 <20141107181430.GH29148@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411071834540.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411071834540.22875@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 06:45:22PM +0000, Stefano Stabellini wrote:
> On Fri, 7 Nov 2014, Catalin Marinas wrote:
> > On Fri, Nov 07, 2014 at 05:35:41PM +0000, Stefano Stabellini wrote:
> > > On Fri, 7 Nov 2014, Stefano Stabellini wrote:
> > > > On Fri, 7 Nov 2014, Catalin Marinas wrote:
> > > > > What I would like to see is xen_dma_map_page() also using hyp calls for
> > > > > cache maintenance when !pfn_valid(), for symmetry with unmap. You would
> > > > > need another argument to xen_dma_map_page() though to pass the real
> > > > > device address or mfn (and on the map side you could simply check for
> > > > > page_to_pfn(page) != mfn). For such cases, Xen swiotlb already handles
> > > > > bouncing so you don't need dom0 swiotlb involved as well.
> > > > 
> > > > I can see that it would be nice to have map_page and unmap_page be
> > > > symmetrical. However actually doing the map_page flush with an hypercall
> > > > would slow things down. Hypercalls are slower than function calls. It is
> > > > faster to do the cache flushing in dom0 if possible. In the map_page
> > > > case we have the struct page so we can easily do it by calling the
> > > > native dma_ops function.
> > > > 
> > > > Maybe I could just add a comment to explain the reason for the asymmetry?
> > > 
> > > Ah, but the problem is that map_page could allocate a swiotlb buffer
> > > (actually it does on arm64) that without a corresponding unmap_page
> > > call, would end up being leaked, right?
> > 
> > Yes. You could hack dma_capable() to always return true for dom0
> > (because the pfn/dma address here doesn't have anything to do with the
> > real mfn) but that's more of a hack assuming a lot about the swiotlb
> > implementation.
> 
> Another idea would be to avoid calling the native map_page for foreign
> pages, but in the xen specific implementation instead of making the
> hypercall, we could call __dma_map_area on arm64 and map_page on arm.

The problem here is that you assume that for an SoC that is not fully
coherent all it needs is __dma_map_area. If you look at mach-mvebu, the
DMA is nearly cache coherent but it needs some specific synchronisation
barrier at the interconnect level. If we get something like this on a
platform with virtualisation, it would be implemented at the dom0 level
by SoC-specific DMA ops. Xen hypervisor I assume has its own BSP, hence
it could implement SoC specific cache flushing there. But with the mix
of cache flushing in dom0 on map and hypervisor on unmap such thing is
no longer be possible in a nice way.

> In arch/arm/include/asm/xen/page-coherent.h:
> 
> static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
> 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
> 	     enum dma_data_direction dir, struct dma_attrs *attrs)
> {
> 	if (pfn_valid(PFN_DOWN(dev_addr))) {

BTW, pfn_valid() is more expensive than simply comparing the mfn with
pfn for dom0. The calling code knows this already and it may be quicker
to simply pass a "bool foreign" argument.

> It wouldn't be as nice as using the hypercall but it would be faster and
> wouldn't depend on the inner workings of the arm64 implementation of
> map_page, except for __dma_map_area.

This "except" is big as we may at some point get some SoC like mvebu (I
would say less likely for arm64 than arm32).

BTW, does the Xen hypervisor already have a mapping of the mfn? If not
and it has to create one temporarily for the flush, you may not lose
much by using the dom0 ops for unmap with a hyper call for temporarily
mapping the foreign page in dom0's IPA space (you could do the unmapping
lazily).

-- 
Catalin
