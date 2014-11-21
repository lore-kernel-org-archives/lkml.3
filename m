Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaKUSJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:09:37 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36959 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaKUSJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:09:36 -0500
Date: Fri, 21 Nov 2014 18:09:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141121180925.GG19783@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com>
 <5029442.vhLMp7Ns7F@wuerfel>
 <20141121165708.GF19783@e104818-lin.cambridge.arm.com>
 <2530749.roRsteyaXx@wuerfel>
 <20141121175118.GA10451@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121175118.GA10451@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 05:51:19PM +0000, Catalin Marinas wrote:
> On Fri, Nov 21, 2014 at 05:04:28PM +0000, Arnd Bergmann wrote:
> > On Friday 21 November 2014 16:57:09 Catalin Marinas wrote:
> > > There is a scenario where smaller mask would work on arm64. For example
> > > Juno, you can have 2GB of RAM in the 32-bit phys range (starting at
> > > 0x80000000). A device with 31-bit mask and a dma_pfn_offset of
> > > 0x80000000 would still work (there isn't any but just as an example). So
> > > the check in dma_alloc_coherent() would be something like:
> > > 
> > > 	phys_to_dma(top of ZONE_DMA) - dma_pfn_offset <= coherent_dma_mask
> > > 
> > > (or assuming RAM starts at 0 and ignoring dma_pfn_offset for now)
> > > 
> > > If the condition above fails, dma_alloc_coherent() would no longer fall
> > > back to swiotlb but issue a dev_warn() and return NULL.
> > 
> > Ah, that looks like it should work on all architectures, very nice.
> > How about checking this condition, and then printing a small warning
> > (dev_warn, not WARN_ON) and setting the dma_mask pointer to NULL?
> 
> I would not add the above ZONE_DMA check to of_dma_configure(). For
> example on arm64, we may not support a small coherent_dma_mask but the
> same value for dma_mask could be fine via swiotlb bouncing (or IOMMU).
> However, that's an arch-specific decision. Maybe after the above setting
> of dev->coherent_dma_mask in of_dma_configure(), we could add:
> 
> 	if (!dma_supported(dev, dev->coherent_dma_mask))
> 		dev->dma_mask = NULL;
> 
> The arch dma_supported() can check the swiotlb bouncing or ZONE_DMA
> limits.

More precisely, that's what I meant:

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3b64d0bf5bba..4fcdfed6a6df 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -172,13 +172,6 @@ static void of_dma_configure(struct device *dev)
 	dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
 	/*
-	 * Set it to coherent_dma_mask by default if the architecture
-	 * code has not set it.
-	 */
-	if (!dev->dma_mask)
-		dev->dma_mask = &dev->coherent_dma_mask;
-
-	/*
 	 * if dma-coherent property exist, call arch hook to setup
 	 * dma coherent operations.
 	 */
@@ -188,18 +181,32 @@ static void of_dma_configure(struct device *dev)
 	}
 
 	/*
-	 * if dma-ranges property doesn't exist - just return else
-	 * setup the dma offset
+	 * If dma-ranges property exists - setup the dma offset.
 	 */
 	ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
 	if (ret < 0) {
 		dev_dbg(dev, "no dma range information to setup\n");
-		return;
+		size = 0;
+	} else {
+		/* DMA ranges found. Calculate and set dma_pfn_offset */
+		dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
+		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
 	}
 
-	/* DMA ranges found. Calculate and set dma_pfn_offset */
-	dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
-	dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
+	/*
+	 * If the bus dma-ranges property specifies a size smaller than 4GB,
+	 * the device would not be capable of accessing the whole 32-bit
+	 * space, so reduce the default coherent_dma_mask accordingly.
+	 */
+	if (size && size < (1ULL << 32))
+		dev->coherent_dma_mask = DMA_BIT_MASK(ilog2(size));
+
+	/*
+	 * Set dma_mask to coherent_dma_mask by default if the architecture
+	 * code has not set it and DMA on such mask is supported.
+	 */
+	if (!dev->dma_mask && dma_supported(dev, dev->coherent_dma_mask))
+		dev->dma_mask = &dev->coherent_dma_mask;
 }
 
 /**

-- 
Catalin
