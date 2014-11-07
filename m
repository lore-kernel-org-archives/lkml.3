Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaKGPgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:36:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49177 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKGPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:36:14 -0500
X-IronPort-AV: E=Sophos;i="5.07,333,1413244800"; 
   d="scan'208";a="190596674"
Date: Fri, 7 Nov 2014 15:28:38 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 6/8] xen/arm/arm64: merge xen/mm32.c into xen/mm.c
In-Reply-To: <20141107142205.GD29148@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1411071523170.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-6-git-send-email-stefano.stabellini@eu.citrix.com> <20141107142205.GD29148@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014, Catalin Marinas wrote:
> On Mon, Oct 27, 2014 at 03:09:26PM +0000, Stefano Stabellini wrote:
> > Merge xen/mm32.c into xen/mm.c.
> > As a consequence the code gets compiled on arm64 too: introduce a few
> > compat functions to actually be able to compile it.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Since I missed the commit introducing mm32.c (340720be32d4 xen/arm:
> reimplement xen_dma_unmap_page & friends), I'll add a retrospective NAK ;).
> 
> The main reason is the asymmetry between dma map and unmap. With host
> swiotlb somehow getting !dma_capable(dev), you even risk leaking dom0
> swiotlb bounce buffers (on arm64).
> 
> > --- a/arch/arm/xen/mm.c
> > +++ b/arch/arm/xen/mm.c
> [...]
> > +/* functions called by SWIOTLB */
> > +
> > +static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
> > +       size_t size, enum dma_data_direction dir,
> > +       void (*op)(const void *, size_t, int))
> > +{
> > +       unsigned long pfn;
> > +       size_t left = size;
> > +
> > +       pfn = (handle >> PAGE_SHIFT) + offset / PAGE_SIZE;
> > +       offset %= PAGE_SIZE;
> > +
> > +       do {
> > +               size_t len = left;
> > +               void *vaddr;
> > +
> > +               if (!pfn_valid(pfn))
> 
> Is this the pfn or the mfn? As you said in the previous email, there is
> no mfn_to_pfn() conversion, so that's actually in another address space
> where dom0 pfn_valid() would not make sense.

That is actually the mfn. The check works because dom0 is mapped 1:1, so
if the mfn is a valid pfn, then it means that it is a local page.


> Do you use this as a check for foreign pages? If yes, is the mfn for
> such pages guaranteed to be different from any valid dom0 pfn?

Yes and yes


> > +               {
> > +                       /* TODO: cache flush */
> 
> What does this TODO mean here? Which cases are not covered yet?

We are going to fill in the cache flush implementation for foreign pages
later, in patch 8/8.


> > +               } else {
> > +                       struct page *page = pfn_to_page(pfn);
> 
> If the pfn here is correct, can you not just have something like:
> 
> void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
> 		size_t size, enum dma_data_direction dir,
> 		struct dma_attrs *attrs)
> 
> {
> 	unsigned long pfn = handle >> PAGE_SHIFT;	/* could use some macros */
> 	if (!pfn_valid(pfn)) {
> 		/* FIXME */
> 		return;
> 	}
> 	__generic_dma_ops(hwdev)->unmap_page(hwdev, handle, size, dir, attrs);
> }

Yes, this is possible. Then in patch 8/8 I could remove the FIXME and
add a call to a function that issues the new GNTTABOP_cache_flush
hypercall. It would also remove the asymmetry you mentioned before
because we could do the same for map_page.
