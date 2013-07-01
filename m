Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3GAPER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:04:17 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46590 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753648Ab3GAPEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:04:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18GFh75p3zb2ST0qJVRE0a2PSbFwEpQ73U=
Date: Mon, 1 Jul 2013 11:04:07 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Fix Marvell Orion and mv_xor after MEMSET removal
Message-ID: <20130701150407.GB19937@titan.lakedaemon.net>
References: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 04:56:29PM +0200, Sebastian Hesselbarth wrote:
> Commit 834cbfe966bece50afded79da8e975d255bf0772
>  ("drivers/dma: remove unused support for MEMSET operations")
> removes MEMSET from dmaengine but does not completely removes it from
> Marvell Orion (arch/arm/plat-orion) and XOR (drivers/dma/mv_xor).
> This also fixes some compiler warnings about now obsolete functions by
> removing those.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/plat-orion/common.c |    6 ------
>  drivers/dma/mv_xor.c         |   25 +------------------------
>  2 files changed, 1 insertions(+), 30 deletions(-)

Please take a look at the email from lkml I just forwarded to you.  I
believe this solves your problem, but I don't have time to look closely
atm.

thx,

Jason.

> 
> diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
> index 797f284..dd2cbd3 100644
> --- a/arch/arm/plat-orion/common.c
> +++ b/arch/arm/plat-orion/common.c
> @@ -727,14 +727,8 @@ void __init orion_xor1_init(unsigned long mapbase_low,
>  	orion_xor1_shared_resources[3].start = irq_1;
>  	orion_xor1_shared_resources[3].end = irq_1;
>  
> -	/*
> -	 * two engines can't do memset simultaneously, this limitation
> -	 * satisfied by removing memset support from one of the engines.
> -	 */
>  	dma_cap_set(DMA_MEMCPY, orion_xor1_channels_data[0].cap_mask);
>  	dma_cap_set(DMA_XOR, orion_xor1_channels_data[0].cap_mask);
> -
> -	dma_cap_set(DMA_MEMSET, orion_xor1_channels_data[1].cap_mask);
>  	dma_cap_set(DMA_MEMCPY, orion_xor1_channels_data[1].cap_mask);
>  	dma_cap_set(DMA_XOR, orion_xor1_channels_data[1].cap_mask);
>  
> diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
> index c434fe6..200f1a3 100644
> --- a/drivers/dma/mv_xor.c
> +++ b/drivers/dma/mv_xor.c
> @@ -89,11 +89,6 @@ static void mv_desc_clear_next_desc(struct mv_xor_desc_slot *desc)
>  	hw_desc->phy_next_desc = 0;
>  }
>  
> -static void mv_desc_set_block_fill_val(struct mv_xor_desc_slot *desc, u32 val)
> -{
> -	desc->value = val;
> -}
> -
>  static void mv_desc_set_dest_addr(struct mv_xor_desc_slot *desc,
>  				  dma_addr_t addr)
>  {
> @@ -128,22 +123,6 @@ static void mv_chan_set_next_descriptor(struct mv_xor_chan *chan,
>  	__raw_writel(next_desc_addr, XOR_NEXT_DESC(chan));
>  }
>  
> -static void mv_chan_set_dest_pointer(struct mv_xor_chan *chan, u32 desc_addr)
> -{
> -	__raw_writel(desc_addr, XOR_DEST_POINTER(chan));
> -}
> -
> -static void mv_chan_set_block_size(struct mv_xor_chan *chan, u32 block_size)
> -{
> -	__raw_writel(block_size, XOR_BLOCK_SIZE(chan));
> -}
> -
> -static void mv_chan_set_value(struct mv_xor_chan *chan, u32 value)
> -{
> -	__raw_writel(value, XOR_INIT_VALUE_LOW(chan));
> -	__raw_writel(value, XOR_INIT_VALUE_HIGH(chan));
> -}
> -
>  static void mv_chan_unmask_interrupts(struct mv_xor_chan *chan)
>  {
>  	u32 val = __raw_readl(XOR_INTR_MASK(chan));
> @@ -1134,7 +1113,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
>  			goto err_free_irq;
>  	}
>  
> -	dev_info(&pdev->dev, "Marvell XOR: ( %s%s%s%s)\n",
> +	dev_info(&pdev->dev, "Marvell XOR: ( %s%s%s)\n",
>  		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
>  		 dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
>  		 dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
> @@ -1244,8 +1223,6 @@ static int mv_xor_probe(struct platform_device *pdev)
>  				dma_cap_set(DMA_MEMCPY, cap_mask);
>  			if (of_property_read_bool(np, "dmacap,xor"))
>  				dma_cap_set(DMA_XOR, cap_mask);
> -			if (of_property_read_bool(np, "dmacap,memset"))
> -				dma_cap_set(DMA_MEMSET, cap_mask);
>  			if (of_property_read_bool(np, "dmacap,interrupt"))
>  				dma_cap_set(DMA_INTERRUPT, cap_mask);
>  
> -- 
> 1.7.2.5
> 
