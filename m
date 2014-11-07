Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaKGSOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:14:40 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:54791 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKGSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:14:38 -0500
Date: Fri, 7 Nov 2014 18:14:30 +0000
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
Message-ID: <20141107181430.GH29148@e104818-lin.cambridge.arm.com>
References: <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com>
 <20141105165646.GN32700@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com>
 <20141106103337.GA19702@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com>
 <20141107110524.GA21875@localhost>
 <alpine.DEB.2.02.1411071212250.22875@kaball.uk.xensource.com>
 <20141107160006.GE29148@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411071646170.22875@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1411071732550.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411071732550.22875@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 05:35:41PM +0000, Stefano Stabellini wrote:
> On Fri, 7 Nov 2014, Stefano Stabellini wrote:
> > On Fri, 7 Nov 2014, Catalin Marinas wrote:
> > > What I would like to see is xen_dma_map_page() also using hyp calls for
> > > cache maintenance when !pfn_valid(), for symmetry with unmap. You would
> > > need another argument to xen_dma_map_page() though to pass the real
> > > device address or mfn (and on the map side you could simply check for
> > > page_to_pfn(page) != mfn). For such cases, Xen swiotlb already handles
> > > bouncing so you don't need dom0 swiotlb involved as well.
> > 
> > I can see that it would be nice to have map_page and unmap_page be
> > symmetrical. However actually doing the map_page flush with an hypercall
> > would slow things down. Hypercalls are slower than function calls. It is
> > faster to do the cache flushing in dom0 if possible. In the map_page
> > case we have the struct page so we can easily do it by calling the
> > native dma_ops function.
> > 
> > Maybe I could just add a comment to explain the reason for the asymmetry?
> 
> Ah, but the problem is that map_page could allocate a swiotlb buffer
> (actually it does on arm64) that without a corresponding unmap_page
> call, would end up being leaked, right?

Yes. You could hack dma_capable() to always return true for dom0
(because the pfn/dma address here doesn't have anything to do with the
real mfn) but that's more of a hack assuming a lot about the swiotlb
implementation.

> Oh well.. two hypercalls it is then :-/

That looks cleaner to me (though I haven't seen the code yet ;)).

Alternatively, you could keep a permanent page (per-cpu) in dom0 that
you ask the hypervisor to point at the mfn just for the unmap cache
maintenance (similarly to the kernel kmap_atomic used for cache
maintenance on high pages). This could be more expensive but, OTOH, you
only need the hyp call on the unmap path. The is_device_dma_coherent()
would still remain to avoid any unnecessary map/unmap calls but for
non-coherent devices you use whatever the SoC provides.

-- 
Catalin
