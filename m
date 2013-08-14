Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab3HNNBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:01:36 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:65179 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab3HNNBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:01:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,876,1367971200"; 
   d="scan'208";a="42050586"
Date: Wed, 14 Aug 2013 14:01:33 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v3 09/10] swiotlb-xen: support autotranslate guests
In-Reply-To: <20130809154558.GG5637@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1308141348540.4470@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308051503190.4893@kaball.uk.xensource.com> <1375720256-8014-9-git-send-email-stefano.stabellini@eu.citrix.com> <20130809154558.GG5637@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013, Konrad Rzeszutek Wilk wrote:
> > @@ -193,9 +315,10 @@ retry:
> >  	/*
> >  	 * Get IO TLB memory from any location.
> >  	 */
> > -	if (early)
> > +	if (early) {
> >  		xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
> > -	else {
> > +		xen_dma_seg = alloc_bootmem(sizeof(struct xen_dma_info) * NR_DMA_SEGS);
> 
> So what if the user over-wrote the size of the SWITOLB? Meaning the nslabs is different?
> Won't that blow up in  xen_swiotlb_fixup if we try to dereference past the array?

The definition of NR_DMA_SEGS is:

#define NR_DMA_SEGS  ((xen_io_tlb_nslabs + IO_TLB_SEGSIZE - 1) / IO_TLB_SEGSIZE)

xen_io_tlb_nslabs is calculated from io_tlb_nslabs.

If the user increases io_tlb_nslabs, then xen_io_tlb_nslabs and
NR_DMA_SEGS are also going to be bigger.


> > @@ -351,14 +477,15 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
> >  	 * we can safely return the device addr and not worry about bounce
> >  	 * buffering it.
> >  	 */
> > -	if (dma_capable(dev, dev_addr, size) &&
> > +	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
> > +	    dma_capable(dev, dev_addr, size) &&
> >  	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
> >  		return dev_addr;
> >  
> >  	/*
> >  	 * Oh well, have to allocate and map a bounce buffer.
> >  	 */
> > -	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir);
> > +	map = swiotlb_tbl_map_single(dev, xen_dma_seg[0].dma_addr, phys, size, dir);
> 
> That [0] really deserves a comment.

xen_dma_seg[0].dma_addr corresponds exactly to start_dma_addr, the first
machine address of the swiotlb buffer.
I think that reason why we pass the dma address of the first slab is
that we want to allocate the bounce buffer from any of the slabs in
io_tlb_start-io_tlb_end.
