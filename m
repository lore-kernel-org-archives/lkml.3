Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaKUQ5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:57:20 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36878 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaKUQ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:57:19 -0500
Date: Fri, 21 Nov 2014 16:57:09 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141121165708.GF19783@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com>
 <2522857.bNQToYpBNt@wuerfel>
 <20141121093509.GA19783@e104818-lin.cambridge.arm.com>
 <5029442.vhLMp7Ns7F@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5029442.vhLMp7Ns7F@wuerfel>
Thread-Topic: For the problem when using swiotlb
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 12:48:09PM +0000, Arnd Bergmann wrote:
> On Friday 21 November 2014 09:35:10 Catalin Marinas wrote:
> > +static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
> > +{
> > +	if (!dma_supported(dev, mask))
> > +		return -EIO;
> > +	if (mask > dev->coherent_dma_mask)
> > +		mask &= of_dma_get_range_mask(dev);
> > +	dev->coherent_dma_mask = mask;
> > +	return 0;
> > +}
> 
> There is an interesting side problem here: the dma mask points to
> coherent_dma_mask for all devices probed from DT, so this breaks
> if we have any driver that sets them to different values. It is a
> preexisting problem them.

Such drivers would have to set both masks separately (or call
dma_set_mask_and_coherent). What we assume though is that dma-ranges
refers to both dma_mask and coherent_dma_mask. I don't think that would
be a problem for ARM systems.

> >  EXPORT_SYMBOL_GPL(of_dma_get_range);
> >  
> > +u64 of_dma_get_range_mask(struct device *dev)
> > +{
> > +	u64 dma_addr, paddr, size;
> > +
> > +	/* no dma mask limiting if no of_node or no dma-ranges property */
> > +	if (!dev->of_node ||
> > +	    of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size) < 0)
> > +		return DMA_BIT_MASK(64);
> 
> If no dma-ranges are present, we should assume that the bus only supports
> 32-bit DMA, or we could make it architecture specific. It would probably
> be best for arm64 to require a dma-ranges property for doing any DMA
> at all, but we can't do that on arm32 any more now.

I thought about this but it could break some existing arm64 DT files if
we mandate dma-ranges property (we could try though). The mask limiting
is arch-specific anyway.

> > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > index 3b64d0bf5bba..50d1ac4739e6 100644
> > --- a/drivers/of/platform.c
> > +++ b/drivers/of/platform.c
> > @@ -200,6 +200,10 @@ static void of_dma_configure(struct device *dev)
> >  	/* DMA ranges found. Calculate and set dma_pfn_offset */
> >  	dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
> >  	dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> > +
> > +	/* limit the coherent_dma_mask to the dma-ranges size property */
> 
> I would change the comment to clarify that we are actually changing
> the dma_mask here as well.
> 
> > +	if (size < (1ULL << 32))
> > +		dev->coherent_dma_mask = DMA_BIT_MASK(ilog2(size));
> >  }
> 
> As you mentioned in another mail in this thread, we wouldn't be
> able to suuport this case on arm64.

The mask would still be valid and even usable if an IOMMU is present. Do
you mean we should not limit it at all here?

There is a scenario where smaller mask would work on arm64. For example
Juno, you can have 2GB of RAM in the 32-bit phys range (starting at
0x80000000). A device with 31-bit mask and a dma_pfn_offset of
0x80000000 would still work (there isn't any but just as an example). So
the check in dma_alloc_coherent() would be something like:

	phys_to_dma(top of ZONE_DMA) - dma_pfn_offset <= coherent_dma_mask

(or assuming RAM starts at 0 and ignoring dma_pfn_offset for now)

If the condition above fails, dma_alloc_coherent() would no longer fall
back to swiotlb but issue a dev_warn() and return NULL.

-- 
Catalin
