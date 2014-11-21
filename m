Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaKURvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:51:43 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36946 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaKURvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:51:42 -0500
Date: Fri, 21 Nov 2014 17:51:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141121175118.GA10451@localhost>
References: <5469E26B.2010905@huawei.com>
 <5029442.vhLMp7Ns7F@wuerfel>
 <20141121165708.GF19783@e104818-lin.cambridge.arm.com>
 <2530749.roRsteyaXx@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2530749.roRsteyaXx@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 05:04:28PM +0000, Arnd Bergmann wrote:
> On Friday 21 November 2014 16:57:09 Catalin Marinas wrote:
> > There is a scenario where smaller mask would work on arm64. For example
> > Juno, you can have 2GB of RAM in the 32-bit phys range (starting at
> > 0x80000000). A device with 31-bit mask and a dma_pfn_offset of
> > 0x80000000 would still work (there isn't any but just as an example). So
> > the check in dma_alloc_coherent() would be something like:
> > 
> > 	phys_to_dma(top of ZONE_DMA) - dma_pfn_offset <= coherent_dma_mask
> > 
> > (or assuming RAM starts at 0 and ignoring dma_pfn_offset for now)
> > 
> > If the condition above fails, dma_alloc_coherent() would no longer fall
> > back to swiotlb but issue a dev_warn() and return NULL.
> 
> Ah, that looks like it should work on all architectures, very nice.
> How about checking this condition, and then printing a small warning
> (dev_warn, not WARN_ON) and setting the dma_mask pointer to NULL?

I would not add the above ZONE_DMA check to of_dma_configure(). For
example on arm64, we may not support a small coherent_dma_mask but the
same value for dma_mask could be fine via swiotlb bouncing (or IOMMU).
However, that's an arch-specific decision. Maybe after the above setting
of dev->coherent_dma_mask in of_dma_configure(), we could add:

	if (!dma_supported(dev, dev->coherent_dma_mask))
		dev->dma_mask = NULL;

The arch dma_supported() can check the swiotlb bouncing or ZONE_DMA
limits.

Strangely, we don't have a coherent_dma_supported() but we can defer
such check to dma_alloc_coherent() and that's where we would check the
top of ZONE_DMA.

-- 
Catalin
