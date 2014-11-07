Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaKGQAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:00:19 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:54672 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:00:17 -0500
Date: Fri, 7 Nov 2014 16:00:06 +0000
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
Message-ID: <20141107160006.GE29148@e104818-lin.cambridge.arm.com>
References: <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com>
 <20141103105716.GC23162@arm.com>
 <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com>
 <20141105165646.GN32700@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com>
 <20141106103337.GA19702@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com>
 <20141107110524.GA21875@localhost>
 <alpine.DEB.2.02.1411071212250.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411071212250.22875@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(talking to Ian in person helped a bit ;))

On Fri, Nov 07, 2014 at 02:10:25PM +0000, Stefano Stabellini wrote:
> On Fri, 7 Nov 2014, Catalin Marinas wrote:
> > On Thu, Nov 06, 2014 at 12:22:13PM +0000, Stefano Stabellini wrote:
> > > On Thu, 6 Nov 2014, Catalin Marinas wrote:
> > > > On Wed, Nov 05, 2014 at 06:15:38PM +0000, Stefano Stabellini wrote:
> > > > > On Wed, 5 Nov 2014, Catalin Marinas wrote:
> > > > > > Note that if !is_device_dma_coherent(), it doesn't always mean that
> > > > > > standard cache maintenance would be enough (but that's a Xen problem,
> > > > > > not sure how to solve).
> > > > > 
> > > > > It is a thorny issue indeed.
> > > > > Xen would need to know how to do non-standard cache maintenance
> > > > > operations.
> > > > 
> > > > Is EL2 hyp or EL1 dom0 doing such maintenance? If the latter, you could
> > > > just use the currently registered dma ops.
> > > 
> > > It is Xen, so El2 hypervisor.
> > 
> > So what is arch/arm/xen/mm32.c cache maintenance for? Doesn't it run in
> > dom0?
> 
> This patch series changes that code path specifically. As a matter of
> fact it removes mm32.c.

Well, it actually merges it into another file, dma_cache_maint() still
remains.

> Before this patch series, cache maintenance in dom0 was being done with
> XENFEAT_grant_map_identity (see explanation in previous email).
> After this patch series, an hypercall is made when foreign pages are
> involved, see patch 8/8, the if(!pfn_valid(pfn)) code path. Local pages
> are still flushed in dom0.

OK. One question I had though is whether pfn_valid(mfn) is always false for
foreign pages. IIUC, dom0 uses a 1:1 pfn:mfn mapping, so it would work.
But from what I gather, there can be other guest, not necessarily dom0,
handling the DMA in which case, if it doesn't use a 1:1 pfn:mfn mapping,
your pfn_valid(mfn) check would no longer work for foreign pages.

> > > Fortunately these dma_ops don't actually need to do much. In fact they
> > > only need to flush caches if the device is not dma-coherent. So the
> > > current proposed solution is to issue an hypercall to ask Xen to do the
> > > flushing, passing the physical address dom0 knows.
> > 
> > I really don't like the dma_cache_maint() duplication you added in
> > arch/arm/xen/mm32.c just because you cannot call the host dma_ops when
> > the page is not available.
> 
> I agree is bad, but this patch series is a big step forward removing the
> duplication. In fact now that I think about it, when a page is local (not a
> foreign page) I could just call the host dma_ops. mm.c:dma_cache_maint
> would only be used for foreign pages (pages for which !pfn_valid(pfn)).

Indeed. I already replied to patch 6/8. This way I think you can remove
dma_cache_maint() duplication entirely, just add one specific to foreign
pages.

What I would like to see is xen_dma_map_page() also using hyp calls for
cache maintenance when !pfn_valid(), for symmetry with unmap. You would
need another argument to xen_dma_map_page() though to pass the real
device address or mfn (and on the map side you could simply check for
page_to_pfn(page) != mfn). For such cases, Xen swiotlb already handles
bouncing so you don't need dom0 swiotlb involved as well.

> > You basically only need a VA that was mapped in dom0 when map_page() was
> > called and is still mapped when page_unmap() is called. You can free the
> > actual mapping after calling __generic_dma_ops()->unmap_page() in
> > xen_dma_unmap_page() (in xen_unmap_single()).
> 
> That is true, but where would I store the mapping?

dev_archdata ;).

> I don't want to introduce another data structure to keep physical to va
> or physical to struct page mappings that I need to modify at every
> map_page and unmap_page. It wouldn't even be a trivial data structure as
> multiple dma operations involving the same mfn but different struct page
> can happen simultaneously.
> 
> The performance hit of maintaining such a data structure would be
> significant.

There would indeed be a performance hit especially for sg ops.

> It would negatively impact any dma operations involving any devices,
> including dma coherent ones. While this series only requires special
> handling of dma operations involving non-coherent devices (resulting in
> an hypercall being made).
> 
> In a way this series rewards hardware that makes life easier to software
> developers :-)

I only need the pfn_valid() clarification now together with the
map/unmap symmetry fix.

I think for the time being is_device_dma_coherent() can stay as an
arch-only function as it is only used by Xen on arm/arm64. If we later
need this on other architectures, we can make it generic.

-- 
Catalin
