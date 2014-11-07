Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaKGSph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:45:37 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:11422 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaKGSpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:45:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,334,1413244800"; 
   d="scan'208";a="190678429"
Date: Fri, 7 Nov 2014 18:45:22 +0000
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
In-Reply-To: <20141107181430.GH29148@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1411071834540.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com> <20141105165646.GN32700@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com> <20141106103337.GA19702@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com> <20141107110524.GA21875@localhost> <alpine.DEB.2.02.1411071212250.22875@kaball.uk.xensource.com> <20141107160006.GE29148@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411071646170.22875@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1411071732550.22875@kaball.uk.xensource.com> <20141107181430.GH29148@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014, Catalin Marinas wrote:
> On Fri, Nov 07, 2014 at 05:35:41PM +0000, Stefano Stabellini wrote:
> > On Fri, 7 Nov 2014, Stefano Stabellini wrote:
> > > On Fri, 7 Nov 2014, Catalin Marinas wrote:
> > > > What I would like to see is xen_dma_map_page() also using hyp calls for
> > > > cache maintenance when !pfn_valid(), for symmetry with unmap. You would
> > > > need another argument to xen_dma_map_page() though to pass the real
> > > > device address or mfn (and on the map side you could simply check for
> > > > page_to_pfn(page) != mfn). For such cases, Xen swiotlb already handles
> > > > bouncing so you don't need dom0 swiotlb involved as well.
> > > 
> > > I can see that it would be nice to have map_page and unmap_page be
> > > symmetrical. However actually doing the map_page flush with an hypercall
> > > would slow things down. Hypercalls are slower than function calls. It is
> > > faster to do the cache flushing in dom0 if possible. In the map_page
> > > case we have the struct page so we can easily do it by calling the
> > > native dma_ops function.
> > > 
> > > Maybe I could just add a comment to explain the reason for the asymmetry?
> > 
> > Ah, but the problem is that map_page could allocate a swiotlb buffer
> > (actually it does on arm64) that without a corresponding unmap_page
> > call, would end up being leaked, right?
> 
> Yes. You could hack dma_capable() to always return true for dom0
> (because the pfn/dma address here doesn't have anything to do with the
> real mfn) but that's more of a hack assuming a lot about the swiotlb
> implementation.

Another idea would be to avoid calling the native map_page for foreign
pages, but in the xen specific implementation instead of making the
hypercall, we could call __dma_map_area on arm64 and map_page on arm.

Something like this:


In arch/arm/include/asm/xen/page-coherent.h:

static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
	     dma_addr_t dev_addr, unsigned long offset, size_t size,
	     enum dma_data_direction dir, struct dma_attrs *attrs)
{
	if (pfn_valid(PFN_DOWN(dev_addr))) {
		if (__generic_dma_ops(hwdev)->map_page)
			__generic_dma_ops(hwdev)->map_page(hwdev, page, offset, size, dir, attrs);
	} else
		__xen_dma_map_page(hwdev, page, dev_addr, offset, size, dir, attrs);
}



In arch/arm/xen/mm.c:

void __xen_dma_map_page(struct device *hwdev, struct page *page,
	     dma_addr_t dev_addr, unsigned long offset, size_t size,
	     enum dma_data_direction dir, struct dma_attrs *attrs)
{
	if (is_device_dma_coherent(hwdev))
		return;
#ifdef CONFIG_ARM64
	__dma_map_area(page_to_phys(page) + offset, size, dir);
#else
	__generic_dma_ops(hwdev)->map_page(hwdev, page, offset, size, dir, attrs);
#endif
}


It wouldn't be as nice as using the hypercall but it would be faster and
wouldn't depend on the inner workings of the arm64 implementation of
map_page, except for __dma_map_area.
