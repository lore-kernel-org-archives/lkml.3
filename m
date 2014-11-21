Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaKUMsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:48:50 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:63661 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaKUMst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:48:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Date: Fri, 21 Nov 2014 13:48:09 +0100
Message-ID: <5029442.vhLMp7Ns7F@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141121093509.GA19783@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com> <2522857.bNQToYpBNt@wuerfel> <20141121093509.GA19783@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ExqbVoCp2q39rD1ud4lGFVFvgALMrH9Rj1RW3TuNLSd
 u37Z7PAtstxWL1fk74Cc513UN5UCwYwprHIxm/TlBRtYAnlyvA
 0px/SZsOJb+mcdu42iKhiRUrQSaZ/OA4/IUZ3teGzt57KRC/zA
 GlWNe1yNNcPZo90r7P3sBUbTVOsbnqP3rdT7NvXsTNRD4+mfQ+
 kzxRfgx05XkKWvqv9ZLrYEq/KG5nxKOf6hdY0/6GDDkGC+6X8h
 GHZejrC3gAWRJiiXT4n+gcr5+op7Xtvom+xa7ULnbKR02r1f4z
 r81+Vot3lMxcltYPz09Z1DdY6yNb+i2PGQVaaVcIimpGB+txir
 MADpmeFhtH8ZuuSE79Ls=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 09:35:10 Catalin Marinas wrote:
> On Thu, Nov 20, 2014 at 07:40:00AM +0000, Arnd Bergmann wrote:
> > On Thursday 20 November 2014 10:57:53 Ding Tianhong wrote:
> 
> But this wouldn't help Ding's case, here the driver needs to set the
> wider DMA mask.
> 
> Anyway, back to your point, to make sure I understand what you meant (I
> can send a proper patch with log afterwards):

Thanks for putting this into code!

> @@ -88,11 +89,24 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>  {
>  	if (!dev->dma_mask || !dma_supported(dev, mask))
>  		return -EIO;
> +	/* if asking for bigger dma mask, limit it to the bus dma ranges */
> +	if (mask > *dev->dma_mask)
> +		mask &= of_dma_get_range_mask(dev);
>  	*dev->dma_mask = mask;
>  
>  	return 0;
>  }

As you commented later, the dma_supported check indeed needs to happen
after the masking.

> +static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
> +{
> +	if (!dma_supported(dev, mask))
> +		return -EIO;
> +	if (mask > dev->coherent_dma_mask)
> +		mask &= of_dma_get_range_mask(dev);
> +	dev->coherent_dma_mask = mask;
> +	return 0;
> +}

There is an interesting side problem here: the dma mask points to
coherent_dma_mask for all devices probed from DT, so this breaks
if we have any driver that sets them to different values. It is a
preexisting problem them.

>  EXPORT_SYMBOL_GPL(of_dma_get_range);
>  
> +u64 of_dma_get_range_mask(struct device *dev)
> +{
> +	u64 dma_addr, paddr, size;
> +
> +	/* no dma mask limiting if no of_node or no dma-ranges property */
> +	if (!dev->of_node ||
> +	    of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size) < 0)
> +		return DMA_BIT_MASK(64);

If no dma-ranges are present, we should assume that the bus only supports
32-bit DMA, or we could make it architecture specific. It would probably
be best for arm64 to require a dma-ranges property for doing any DMA
at all, but we can't do that on arm32 any more now.

> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 3b64d0bf5bba..50d1ac4739e6 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -200,6 +200,10 @@ static void of_dma_configure(struct device *dev)
>  	/* DMA ranges found. Calculate and set dma_pfn_offset */
>  	dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
>  	dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> +
> +	/* limit the coherent_dma_mask to the dma-ranges size property */

I would change the comment to clarify that we are actually changing
the dma_mask here as well.

> +	if (size < (1ULL << 32))
> +		dev->coherent_dma_mask = DMA_BIT_MASK(ilog2(size));
>  }
>  


As you mentioned in another mail in this thread, we wouldn't be
able to suuport this case on arm64.

	Arnd
