Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaKGQsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:48:31 -0500
Received: from smtp.citrix.com ([66.165.176.89]:15395 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbaKGQs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:48:29 -0500
X-IronPort-AV: E=Sophos;i="5.07,333,1413244800"; 
   d="scan'208";a="189206495"
Date: Fri, 7 Nov 2014 16:46:14 +0000
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
In-Reply-To: <20141107160306.GF29148@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1411071645480.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-6-git-send-email-stefano.stabellini@eu.citrix.com> <20141107142205.GD29148@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411071523170.22875@kaball.uk.xensource.com>
 <20141107160306.GF29148@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014, Catalin Marinas wrote:
> On Fri, Nov 07, 2014 at 03:28:38PM +0000, Stefano Stabellini wrote:
> > On Fri, 7 Nov 2014, Catalin Marinas wrote:
> > > On Mon, Oct 27, 2014 at 03:09:26PM +0000, Stefano Stabellini wrote:
> > > > Merge xen/mm32.c into xen/mm.c.
> > > > As a consequence the code gets compiled on arm64 too: introduce a few
> > > > compat functions to actually be able to compile it.
> > > > 
> > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > > 
> > > Since I missed the commit introducing mm32.c (340720be32d4 xen/arm:
> > > reimplement xen_dma_unmap_page & friends), I'll add a retrospective NAK ;).
> > > 
> > > The main reason is the asymmetry between dma map and unmap. With host
> > > swiotlb somehow getting !dma_capable(dev), you even risk leaking dom0
> > > swiotlb bounce buffers (on arm64).
> > > 
> > > > --- a/arch/arm/xen/mm.c
> > > > +++ b/arch/arm/xen/mm.c
> > > [...]
> > > > +/* functions called by SWIOTLB */
> > > > +
> > > > +static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
> > > > +       size_t size, enum dma_data_direction dir,
> > > > +       void (*op)(const void *, size_t, int))
> > > > +{
> > > > +       unsigned long pfn;
> > > > +       size_t left = size;
> > > > +
> > > > +       pfn = (handle >> PAGE_SHIFT) + offset / PAGE_SIZE;
> > > > +       offset %= PAGE_SIZE;
> > > > +
> > > > +       do {
> > > > +               size_t len = left;
> > > > +               void *vaddr;
> > > > +
> > > > +               if (!pfn_valid(pfn))
> > > 
> > > Is this the pfn or the mfn? As you said in the previous email, there is
> > > no mfn_to_pfn() conversion, so that's actually in another address space
> > > where dom0 pfn_valid() would not make sense.
> > 
> > That is actually the mfn. The check works because dom0 is mapped 1:1, so
> > if the mfn is a valid pfn, then it means that it is a local page.
> 
> So the Xen DMA ops would never be called on anything other than dom0?

That's right.


> If that's correct, the pfn_valid() check would work. But add some big
> comments as it's not clear at all to someone not familiar with Xen.

Yeah...
