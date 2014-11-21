Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaKUREi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:04:38 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:50844 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbaKUREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:04:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Date: Fri, 21 Nov 2014 18:04:28 +0100
Message-ID: <2530749.roRsteyaXx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141121165708.GF19783@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com> <5029442.vhLMp7Ns7F@wuerfel> <20141121165708.GF19783@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:R+hTQYFpdmfh+aczFbG11ebxu9nmG8uIV6z95C1nMpW
 wofkyhxSN+OP9+X42SlmnJwyT8eILV0k3o+b1WpAO3yhUg0avB
 vcHAO5x1pp+du20ENwsa1yBVTxqfsXTZeaBjBuwVr5l0sMp0K8
 6f21t7ki5zifxB8rzPZAIg9o1uMBpzhPPot+7uqND5Saav0pDS
 SSVwdd3Lad3yHYrQ6BCL0zWI0ZnFP9Fhua04VpOo06UmKqD6E9
 lxlOkn/nBIu7NdJlC5Hi7mY+NTWzy1Odx7vUKRKvv57Xd7iASY
 M5pkJsbXYUAEISpNTqi5kbjfTAHhww3sHPk4AkxRWAEavNEajO
 Vbjxbhee9iD3PT5eAlu0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 16:57:09 Catalin Marinas wrote:
> On Fri, Nov 21, 2014 at 12:48:09PM +0000, Arnd Bergmann wrote:
> > On Friday 21 November 2014 09:35:10 Catalin Marinas wrote:
> > > +static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
> > > +{
> > > +	if (!dma_supported(dev, mask))
> > > +		return -EIO;
> > > +	if (mask > dev->coherent_dma_mask)
> > > +		mask &= of_dma_get_range_mask(dev);
> > > +	dev->coherent_dma_mask = mask;
> > > +	return 0;
> > > +}
> > 
> > There is an interesting side problem here: the dma mask points to
> > coherent_dma_mask for all devices probed from DT, so this breaks
> > if we have any driver that sets them to different values. It is a
> > preexisting problem them.
> 
> Such drivers would have to set both masks separately (or call
> dma_set_mask_and_coherent). What we assume though is that dma-ranges
> refers to both dma_mask and coherent_dma_mask. I don't think that would
> be a problem for ARM systems.

Right, I'm just saying that we don't have a way to detect drivers that
break this assumption, not that we have a serious problem already.

> > >  EXPORT_SYMBOL_GPL(of_dma_get_range);
> > >  
> > > +u64 of_dma_get_range_mask(struct device *dev)
> > > +{
> > > +	u64 dma_addr, paddr, size;
> > > +
> > > +	/* no dma mask limiting if no of_node or no dma-ranges property */
> > > +	if (!dev->of_node ||
> > > +	    of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size) < 0)
> > > +		return DMA_BIT_MASK(64);
> > 
> > If no dma-ranges are present, we should assume that the bus only supports
> > 32-bit DMA, or we could make it architecture specific. It would probably
> > be best for arm64 to require a dma-ranges property for doing any DMA
> > at all, but we can't do that on arm32 any more now.
> 
> I thought about this but it could break some existing arm64 DT files if
> we mandate dma-ranges property (we could try though). The mask limiting
> is arch-specific anyway.

Yes, this has taken far too long to get addressed, we should have added
the properties right from the start. If we have a function in architecture
specific code, maybe we can just check for the short list of already
supported platforms that need backwards compatibility and require the
mask for everything else?

> > > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > > index 3b64d0bf5bba..50d1ac4739e6 100644
> > > --- a/drivers/of/platform.c
> > > +++ b/drivers/of/platform.c
> > > @@ -200,6 +200,10 @@ static void of_dma_configure(struct device *dev)
> > >  	/* DMA ranges found. Calculate and set dma_pfn_offset */
> > >  	dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
> > >  	dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> > > +
> > > +	/* limit the coherent_dma_mask to the dma-ranges size property */
> > 
> > I would change the comment to clarify that we are actually changing
> > the dma_mask here as well.
> > 
> > > +	if (size < (1ULL << 32))
> > > +		dev->coherent_dma_mask = DMA_BIT_MASK(ilog2(size));
> > >  }
> > 
> > As you mentioned in another mail in this thread, we wouldn't be
> > able to suuport this case on arm64.
> 
> The mask would still be valid and even usable if an IOMMU is present. Do
> you mean we should not limit it at all here?

The code is certainly correct on arm32, as long as we have an appropriate
DMA zone.

> There is a scenario where smaller mask would work on arm64. For example
> Juno, you can have 2GB of RAM in the 32-bit phys range (starting at
> 0x80000000). A device with 31-bit mask and a dma_pfn_offset of
> 0x80000000 would still work (there isn't any but just as an example). So
> the check in dma_alloc_coherent() would be something like:
> 
> 	phys_to_dma(top of ZONE_DMA) - dma_pfn_offset <= coherent_dma_mask
> 
> (or assuming RAM starts at 0 and ignoring dma_pfn_offset for now)
> 
> If the condition above fails, dma_alloc_coherent() would no longer fall
> back to swiotlb but issue a dev_warn() and return NULL.

Ah, that looks like it should work on all architectures, very nice.
How about checking this condition, and then printing a small warning
(dev_warn, not WARN_ON) and setting the dma_mask pointer to NULL?

	Arnd
