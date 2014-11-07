Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaKGLGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:06:17 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:54412 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKGLFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:05:55 -0500
Date: Fri, 7 Nov 2014 11:05:25 +0000
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
Message-ID: <20141107110524.GA21875@localhost>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com>
 <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com>
 <20141103105716.GC23162@arm.com>
 <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com>
 <20141105165646.GN32700@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com>
 <20141106103337.GA19702@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com>
Thread-Topic: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:22:13PM +0000, Stefano Stabellini wrote:
> On Thu, 6 Nov 2014, Catalin Marinas wrote:
> > On Wed, Nov 05, 2014 at 06:15:38PM +0000, Stefano Stabellini wrote:
> > > On Wed, 5 Nov 2014, Catalin Marinas wrote:
> > > > Note that if !is_device_dma_coherent(), it doesn't always mean that
> > > > standard cache maintenance would be enough (but that's a Xen problem,
> > > > not sure how to solve).
> > > 
> > > It is a thorny issue indeed.
> > > Xen would need to know how to do non-standard cache maintenance
> > > operations.
> > 
> > Is EL2 hyp or EL1 dom0 doing such maintenance? If the latter, you could
> > just use the currently registered dma ops.
> 
> It is Xen, so El2 hypervisor.

So what is arch/arm/xen/mm32.c cache maintenance for? Doesn't it run in
dom0?

> > > Otherwise we would need to resurrect XENFEAT_grant_map_identity (that I
> > > am reverting in this series) and be content with having CONFIG_XEN_DOM0
> > > depend on CONFIG_ARM_LPAE.
> > 
> > So what does buy you? Is it just the hope that with LPAE you won't have
> > weird system caches?
> 
> Let me explain a bit more and let's assume there is no SMMU.
> 
> The problem is not normal dma originating in dom0, currently mapped 1:1
> (pseudo-physical == physical). The problem are dma operations that
> involve foreign pages (pages belonging to other virtual machines)
> currently mapped also in dom0 to do IO. It is common for the Xen PV
> network and block frontends to grant access to one or more pages to the
> network and block backends for IO. The backends, usually in dom0, map
> the pages and perform the actual IO. Sometimes the IO is a dma operation
> that involves one of the granted pages directly.
> 
> For these pages, the pseudo-physical address in dom0 is different from
> the physical address. Dom0 keeps track of the pseudo-physical to
> physical relationship (pfn_to_mfn in Xen terminology). The swiotlb-xen
> driver makes sure to return the right mfn from map_page and map_sg.

For my understanding, xen_dma_map_page() is called from dom0 and it
simply calls the __generic_dma_ops()->map_page(). The "page" argument
here is the dom0 page and it gets translated to dom0 phys and then to a
bus address via xen_phys_to_bus().

On arm64, __swiotlb_map_page() uses the page structure to get some
pseudo device address which gets converted back to a dom0 virtual
address. The latter is used for cache maintenance by VA in dom0. With
PIPT-like caches, that's fine, you don't need the actual machine PA
unless you have caches like PL310 (which are not compatible with
virtualisation anyway and the latest ARMv8 ARM even makes a clear
statement here).

(one potential problem here is the dma_capable() check in
swiotlb_map_page() (non-xen) which uses the pseudo device address)

The interesting part is that xen_swiotlb_map_page() returns the real
machine device address to dom0, which is different from what dom0 thinks
of a device address (phys_to_dma(phys_to_page(page))). Does dom0 use
such real/machine device address to program the device directly or there
is another layer where you could do the translation?

> However some of the dma_ops give you only a dma_addr_t handle
> (unmap_page and unmap_sg), that is the physical address of the page.

OK, I started to get it now, the __swiotlb_unmap_page() on arm64, if
called from dom0, would get the machine device address and dma_to_phys()
does not work.

> Dom0 doesn't know how to find the pseudo-physical address corresponding
> to it. Therefore it also doesn't know how to find the struct page for
> it. This is not a trivial problem to solve as the same page can be
> granted multiple times, therefore could have multiple pseudo-physical
> addresses and multiple struct pages corresponding to one physical
> address in dom0.

So what is mfn_to_pfn() and xen_bus_to_phys() used for? Isn't
mfn_to_pfn(pfn_to_mfn(x)) an identity function?

> Fortunately these dma_ops don't actually need to do much. In fact they
> only need to flush caches if the device is not dma-coherent. So the
> current proposed solution is to issue an hypercall to ask Xen to do the
> flushing, passing the physical address dom0 knows.

I really don't like the dma_cache_maint() duplication you added in
arch/arm/xen/mm32.c just because you cannot call the host dma_ops when
the page is not available.

You basically only need a VA that was mapped in dom0 when map_page() was
called and is still mapped when page_unmap() is called. You can free the
actual mapping after calling __generic_dma_ops()->unmap_page() in
xen_dma_unmap_page() (in xen_unmap_single()).

BTW, drivers/xen/swiotlb-xen.c needs something like:

        dma_addr_t dev_addr = xen_phys_to_bus(phys_to_dma(phys));

phys != bus address.

-- 
Catalin
