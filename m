Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbaKULg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:36:29 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36467 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaKULg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:36:28 -0500
Date: Fri, 21 Nov 2014 11:36:18 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141121113618.GD19783@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com>
 <3918100.vD6471iH9k@wuerfel>
 <20141121110609.GC19783@e104818-lin.cambridge.arm.com>
 <2310899.ejrSzj6BIr@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2310899.ejrSzj6BIr@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:26:45AM +0000, Arnd Bergmann wrote:
> On Friday 21 November 2014 11:06:10 Catalin Marinas wrote:
> > On Wed, Nov 19, 2014 at 03:56:42PM +0000, Arnd Bergmann wrote:
> > > On Wednesday 19 November 2014 15:46:35 Catalin Marinas wrote:
> > > > Going back to original topic, the dma_supported() function on arm64
> > > > calls swiotlb_dma_supported() which actually checks whether the swiotlb
> > > > bounce buffer is within the dma mask. This transparent bouncing (unlike
> > > > arm32 where it needs to be explicit) is not always optimal, though
> > > > required for 32-bit only devices on a 64-bit system. The problem is when
> > > > the driver is 64-bit capable but forgets to call
> > > > dma_set_mask_and_coherent() (that's not the only question I got about
> > > > running out of swiotlb buffers).
> > > 
> > > I think it would be nice to warn once per device that starts using the
> > > swiotlb. Really all 32-bit DMA masters should have a proper IOMMU
> > > attached.
> > 
> > It would be nice to have a dev_warn_once().
> > 
> > I think it makes sense on arm64 to avoid swiotlb bounce buffers for
> > coherent allocations altogether. The __dma_alloc_coherent() function
> > already checks coherent_dma_mask and sets GFP_DMA accordingly. If we
> > have a device that cannot even cope with a 32-bit ZONE_DMA, we should
> > just not support DMA at all on it (without an IOMMU). The arm32
> > __dma_supported() has a similar check.
> 
> If we ever encounter this case, we may have to add a smaller ZONE_DMA
> and use ZONE_DMA32 for the normal dma allocations.

Traditionally on x86 I think ZONE_DMA was for ISA and ZONE_DMA32 had to
cover the 32-bit physical address space. On arm64 we don't expect ISA,
so we only use ZONE_DMA (which is 4G, similar to IA-64, sparc). We had
ZONE_DMA32 originally but it broke swiotlb which assumes ZONE_DMA for
its bounce buffer.

> > Swiotlb is still required for the streaming DMA since we get bouncing
> > for pages allocated outside the driver control (e.g. VFS layer which
> > doesn't care about GFP_DMA), hoping a 16M bounce buffer would be enough.
> > 
> > Ding seems to imply that CMA fixes the problem, which means that the
> > issue is indeed coherent allocations.
> 
> I wonder what's going on here, since swiotlb_alloc_coherent() actually
> tries a regular __get_free_pages(flags, order) first, and when ZONE_DMA
> is set here, it just work without using the pool.

As long as coherent_dma_mask is sufficient for ZONE_DMA. I have no idea
what this mask is set to in Ding's case (but I've seen the problem
previously with an out of tree driver where coherent_dma_mask was some
random number; so better reporting here would help).

There could be another case where dma_pfn_offset is required but let's
wait for some more info from Ding (ZONE_DMA is 32-bit from the start of
RAM which could be 40-bit like on Seattle, so basically such devices
would need to set dma_pfn_offset).

-- 
Catalin
