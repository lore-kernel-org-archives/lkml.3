Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaLHLgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:36:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:35192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbaLHLgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:36:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,538,1413270000"; 
   d="scan'208";a="620353062"
Date: Mon, 8 Dec 2014 17:06:37 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor
 allocation failure
Message-ID: <20141208113637.GG16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416924617-15939-1-git-send-email-j@bitron.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 03:10:17PM +0100, Jürg Billeter wrote:
> If the atomic DMA coherent pool is too small, disable use of hardware
> descriptor lists instead of crashing the system:
> 
> ERROR: 256 KiB atomic DMA coherent pool is too small!
> Please increase it with coherent_pool= kernel parameter!
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000004
> Internal error: Oops: a07 [#1] PREEMPT SMP ARM
> 
> PC is at rcar_dmac_chan_reinit+0x3c/0x160
> LR is at _raw_spin_lock_irqsave+0x18/0x5c
> 
> [<802132c0>] (rcar_dmac_chan_reinit) from [<80214818>] (rcar_dmac_isr_error+0x84/0xa0)
> [<80214818>] (rcar_dmac_isr_error) from [<80060484>] (handle_irq_event_percpu+0x50/0x150)
> [<80060484>] (handle_irq_event_percpu) from [<800605c0>] (handle_irq_event+0x3c/0x5c)
> [<800605c0>] (handle_irq_event) from [<8006350c>] (handle_fasteoi_irq+0xb8/0x198)
> [<8006350c>] (handle_fasteoi_irq) from [<8005fdb0>] (generic_handle_irq+0x20/0x30)
> [<8005fdb0>] (generic_handle_irq) from [<8000fcd0>] (handle_IRQ+0x50/0xc4)
> [<8000fcd0>] (handle_IRQ) from [<800092cc>] (gic_handle_irq+0x28/0x5c)
> [<800092cc>] (gic_handle_irq) from [<80012700>] (__irq_svc+0x40/0x70)
> 
> Kernel panic - not syncing: Fatal exception in interrupt

Can you please rebase this on my next, this fails to apply for me

Thanks
-- 
~Vinod
> 
> Signed-off-by: Jürg Billeter <j@bitron.ch>
> ---
>  drivers/dma/sh/rcar-dmac.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
> index f8f70eb..f18b1b6 100644
> --- a/drivers/dma/sh/rcar-dmac.c
> +++ b/drivers/dma/sh/rcar-dmac.c
> @@ -679,8 +679,8 @@ static void rcar_dmac_realloc_hwdesc(struct rcar_dmac_chan *chan,
>  	desc->hwdescs.size = size;
>  }
>  
> -static void rcar_dmac_fill_hwdesc(struct rcar_dmac_chan *chan,
> -				  struct rcar_dmac_desc *desc)
> +static int rcar_dmac_fill_hwdesc(struct rcar_dmac_chan *chan,
> +				 struct rcar_dmac_desc *desc)
>  {
>  	struct rcar_dmac_xfer_chunk *chunk;
>  	struct rcar_dmac_hw_desc *hwdesc;
> @@ -689,7 +689,7 @@ static void rcar_dmac_fill_hwdesc(struct rcar_dmac_chan *chan,
>  
>  	hwdesc = desc->hwdescs.mem;
>  	if (!hwdesc)
> -		return;
> +		return -ENOMEM;
>  
>  	list_for_each_entry(chunk, &desc->chunks, node) {
>  		hwdesc->sar = chunk->src_addr;
> @@ -697,6 +697,8 @@ static void rcar_dmac_fill_hwdesc(struct rcar_dmac_chan *chan,
>  		hwdesc->tcr = chunk->size >> desc->xfer_shift;
>  		hwdesc++;
>  	}
> +
> +	return 0;
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -933,8 +935,10 @@ rcar_dmac_chan_prep_sg(struct rcar_dmac_chan *chan, struct scatterlist *sgl,
>  	 * additional complexity remains to be investigated.
>  	 */
>  	desc->hwdescs.use = !highmem && nchunks > 1;
> -	if (desc->hwdescs.use)
> -		rcar_dmac_fill_hwdesc(chan, desc);
> +	if (desc->hwdescs.use) {
> +		if (rcar_dmac_fill_hwdesc(chan, desc) < 0)
> +			desc->hwdescs.use = false;
> +	}
>  
>  	return &desc->async_tx;
>  }
> -- 
> 2.1.3
> 

-- 
