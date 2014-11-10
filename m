Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaKJMfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:35:51 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:23559 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaKJMft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:35:49 -0500
X-IronPort-AV: E=Sophos;i="5.07,352,1413244800"; 
   d="scan'208";a="191159744"
Date: Mon, 10 Nov 2014 12:35:06 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
In-Reply-To: <20141110101645.GA21366@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1411101200080.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com> <20141106103337.GA19702@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com> <20141107110524.GA21875@localhost>
 <alpine.DEB.2.02.1411071212250.22875@kaball.uk.xensource.com> <20141107160006.GE29148@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411071646170.22875@kaball.uk.xensource.com> <alpine.DEB.2.02.1411071732550.22875@kaball.uk.xensource.com>
 <20141107181430.GH29148@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411071834540.22875@kaball.uk.xensource.com> <20141110101645.GA21366@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Catalin Marinas wrote:
> On Fri, Nov 07, 2014 at 06:45:22PM +0000, Stefano Stabellini wrote:
> > On Fri, 7 Nov 2014, Catalin Marinas wrote:
> > > On Fri, Nov 07, 2014 at 05:35:41PM +0000, Stefano Stabellini wrote:
> > > > On Fri, 7 Nov 2014, Stefano Stabellini wrote:
> > > > > On Fri, 7 Nov 2014, Catalin Marinas wrote:
> > > > > > What I would like to see is xen_dma_map_page() also using hyp calls for
> > > > > > cache maintenance when !pfn_valid(), for symmetry with unmap. You would
> > > > > > need another argument to xen_dma_map_page() though to pass the real
> > > > > > device address or mfn (and on the map side you could simply check for
> > > > > > page_to_pfn(page) != mfn). For such cases, Xen swiotlb already handles
> > > > > > bouncing so you don't need dom0 swiotlb involved as well.
> > > > > 
> > > > > I can see that it would be nice to have map_page and unmap_page be
> > > > > symmetrical. However actually doing the map_page flush with an hypercall
> > > > > would slow things down. Hypercalls are slower than function calls. It is
> > > > > faster to do the cache flushing in dom0 if possible. In the map_page
> > > > > case we have the struct page so we can easily do it by calling the
> > > > > native dma_ops function.
> > > > > 
> > > > > Maybe I could just add a comment to explain the reason for the asymmetry?
> > > > 
> > > > Ah, but the problem is that map_page could allocate a swiotlb buffer
> > > > (actually it does on arm64) that without a corresponding unmap_page
> > > > call, would end up being leaked, right?
> > > 
> > > Yes. You could hack dma_capable() to always return true for dom0
> > > (because the pfn/dma address here doesn't have anything to do with the
> > > real mfn) but that's more of a hack assuming a lot about the swiotlb
> > > implementation.
> > 
> > Another idea would be to avoid calling the native map_page for foreign
> > pages, but in the xen specific implementation instead of making the
> > hypercall, we could call __dma_map_area on arm64 and map_page on arm.
> 
> The problem here is that you assume that for an SoC that is not fully
> coherent all it needs is __dma_map_area. If you look at mach-mvebu, the
> DMA is nearly cache coherent but it needs some specific synchronisation
> barrier at the interconnect level. If we get something like this on a
> platform with virtualisation, it would be implemented at the dom0 level
> by SoC-specific DMA ops. Xen hypervisor I assume has its own BSP, hence
> it could implement SoC specific cache flushing there. But with the mix
> of cache flushing in dom0 on map and hypervisor on unmap such thing is
> no longer be possible in a nice way.

Yes, Xen has its own little platform files.

I think you convinced me that having map in Linux and unmap in Xen is
not a long term solid solution.


> > In arch/arm/include/asm/xen/page-coherent.h:
> > 
> > static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
> > 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
> > 	     enum dma_data_direction dir, struct dma_attrs *attrs)
> > {
> > 	if (pfn_valid(PFN_DOWN(dev_addr))) {
> 
> BTW, pfn_valid() is more expensive than simply comparing the mfn with
> pfn for dom0. The calling code knows this already and it may be quicker
> to simply pass a "bool foreign" argument.

Good point, I can compare mfn and pfn here.
I cannot do the same in unmap_page and the various sync operations,
because there is no pfn available, but maybe I could use
set_page_private to set a flag. I'll think about it.


> > It wouldn't be as nice as using the hypercall but it would be faster and
> > wouldn't depend on the inner workings of the arm64 implementation of
> > map_page, except for __dma_map_area.
> 
> This "except" is big as we may at some point get some SoC like mvebu (I
> would say less likely for arm64 than arm32).
> 
> BTW, does the Xen hypervisor already have a mapping of the mfn?

On arm64, it does.
On arm32, we have a pool of mappings, when we run out we start
overwriting old mappings.


> If not
> and it has to create one temporarily for the flush, you may not lose
> much by using the dom0 ops for unmap with a hyper call for temporarily
> mapping the foreign page in dom0's IPA space (you could do the unmapping
> lazily).

That's true. Fortunately on arm64 we are OK.
