Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaKYK6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:58:23 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38741 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbaKYK6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:58:21 -0500
Date: Tue, 25 Nov 2014 10:58:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141125105815.GB18858@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com>
 <20141121175118.GA10451@localhost>
 <20141121180925.GG19783@e104818-lin.cambridge.arm.com>
 <2166613.l2i4mdmtLA@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2166613.l2i4mdmtLA@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 08:12:09PM +0000, Arnd Bergmann wrote:
> On Friday 21 November 2014 18:09:25 Catalin Marinas wrote:
> > On Fri, Nov 21, 2014 at 05:51:19PM +0000, Catalin Marinas wrote:
> > > On Fri, Nov 21, 2014 at 05:04:28PM +0000, Arnd Bergmann wrote:
> > > > On Friday 21 November 2014 16:57:09 Catalin Marinas wrote:
> > > > > There is a scenario where smaller mask would work on arm64. For example
> > > > > Juno, you can have 2GB of RAM in the 32-bit phys range (starting at
> > > > > 0x80000000). A device with 31-bit mask and a dma_pfn_offset of
> > > > > 0x80000000 would still work (there isn't any but just as an example). So
> > > > > the check in dma_alloc_coherent() would be something like:
> > > > > 
> > > > > 	phys_to_dma(top of ZONE_DMA) - dma_pfn_offset <= coherent_dma_mask
> > > > > 
> > > > > (or assuming RAM starts at 0 and ignoring dma_pfn_offset for now)
> > > > > 
> > > > > If the condition above fails, dma_alloc_coherent() would no longer fall
> > > > > back to swiotlb but issue a dev_warn() and return NULL.
> > > > 
> > > > Ah, that looks like it should work on all architectures, very nice.
> > > > How about checking this condition, and then printing a small warning
> > > > (dev_warn, not WARN_ON) and setting the dma_mask pointer to NULL?
> > > 
> > > I would not add the above ZONE_DMA check to of_dma_configure(). For
> > > example on arm64, we may not support a small coherent_dma_mask but the
> > > same value for dma_mask could be fine via swiotlb bouncing (or IOMMU).
> > > However, that's an arch-specific decision. Maybe after the above setting
> > > of dev->coherent_dma_mask in of_dma_configure(), we could add:
> 
> You seem to implement the opposite:

Possibly, but I had something else in mind.

> > +	/*
> > +	 * If the bus dma-ranges property specifies a size smaller than 4GB,
> > +	 * the device would not be capable of accessing the whole 32-bit
> > +	 * space, so reduce the default coherent_dma_mask accordingly.
> > +	 */
> > +	if (size && size < (1ULL << 32))
> > +		dev->coherent_dma_mask = DMA_BIT_MASK(ilog2(size));
> > +
> > +	/*
> > +	 * Set dma_mask to coherent_dma_mask by default if the architecture
> > +	 * code has not set it and DMA on such mask is supported.
> > +	 */
> > +	if (!dev->dma_mask && dma_supported(dev, dev->coherent_dma_mask))
> > +		dev->dma_mask = &dev->coherent_dma_mask;
> >  }
> 
> Here, coherent_dma_mask wouldn't work while dma_mask might be
> fine in case of swiotlb, but you set a nonzero coherent_dma_mask
> and an invalid dma_mask.

My assumption is that dma_supported() only checks the validity of
dma_mask (not the coherent one). On arm64 it is currently routed to
swiotlb_dma_supported() which returns true if the swiotlb bounce buffer
is within that mask. So if the coherent_dma_mask is enough for swiotlb
bounce buffer, we point dma_mask to it. Otherwise, there is no way to do
streaming DMA to such mask, hence setting it to NULL.

Since we don't have a coherent_dma_supported() function, we defer the
validity check of coherent_dma_mask to dma_alloc_coherent() (and here we
can remove bouncing since swiotlb has relatively small buffers).

There is a slight downside if dma_supported() on the default 32-bit mask
fails, we end up with dma_mask == NULL and the driver calling
dma_set_mask_and_coherent(64-bit) would fail to set dma_mask even though
dma-ranges allows it. Is this a real scenario (not for arm64 where we
allow DMA into 32-bit via ZONE_DMA)?

-- 
Catalin
