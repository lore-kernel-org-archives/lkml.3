Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005Ab3JPSak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:30:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57731 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761500Ab3JPSaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:30:22 -0400
Date: Wed, 16 Oct 2013 20:29:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
In-Reply-To: <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
Message-ID: <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:0E0j1O9B/Mo4xYyj7+t+oc7byG/QCo85xWY8D4MCsJ4
 bfHZpu3rFdYzMG0oUcWbOtAGEkM4Mby47XheHi/Y3bDdzFchH8
 JjfPyfc5oPaLtBejqBgRFRoLB+OgeLxWYZg3QXbPTe5B2p6hKK
 X6zcwUGdemxKEwfrQxThv3i9ZZH4/LbRkIhHmmV8Kb+0B8zVIQ
 EM1REWtWgct344vnoHsjCPAWr+o9C+Amaw2DFpS7mMshhxJ+dU
 jNnrP2UtZeBhkO2K9KuxV8pPl5w3kEI0v+m5qZPgWniiXDxL3S
 qX6ANQsrIUjsd49gNbZgB7QvgFV0EExHPTRBdBN1+ugtQJ096t
 Xkz1dNefug19dm62uOHsAaZuhXpMT1u7GD1l5GD74KSP/RjBUe
 L8nLd0TT8JQ2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Wed, 16 Oct 2013, Vinod Koul wrote:

> the DMA_SUCCESS is a misnomer as dmaengine indicates the transfer is complete and
> gives no guarantee of the transfer success. Hence we should use DMA_COMPLTE
> instead of DMA_SUCCESS
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> ---
>  drivers/dma/dmaengine.c   |    2 +-
>  include/linux/dmaengine.h |   12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 9162ac8..81d8765 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -1062,7 +1062,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
>  	unsigned long dma_sync_wait_timeout = jiffies + msecs_to_jiffies(5000);
>  
>  	if (!tx)
> -		return DMA_SUCCESS;
> +		return DMA_COMPLETE;
>  
>  	while (tx->cookie == -EBUSY) {
>  		if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 0bc7275..4b460a6 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -45,13 +45,13 @@ static inline int dma_submit_error(dma_cookie_t cookie)
>  
>  /**
>   * enum dma_status - DMA transaction status
> - * @DMA_SUCCESS: transaction completed successfully
> + * @DMA_COMPLETE: transaction completed
>   * @DMA_IN_PROGRESS: transaction not yet processed
>   * @DMA_PAUSED: transaction is paused
>   * @DMA_ERROR: transaction failed
>   */
>  enum dma_status {
> -	DMA_SUCCESS,
> +	DMA_COMPLETE,
>  	DMA_IN_PROGRESS,
>  	DMA_PAUSED,
>  	DMA_ERROR,

Doesn't this break kernel compilation for a total of 27 commits? Or am I 
missing anything?

Thanks
Guennadi

> @@ -979,10 +979,10 @@ static inline enum dma_status dma_async_is_complete(dma_cookie_t cookie,
>  {
>  	if (last_complete <= last_used) {
>  		if ((cookie <= last_complete) || (cookie > last_used))
> -			return DMA_SUCCESS;
> +			return DMA_COMPLETE;
>  	} else {
>  		if ((cookie <= last_complete) && (cookie > last_used))
> -			return DMA_SUCCESS;
> +			return DMA_COMPLETE;
>  	}
>  	return DMA_IN_PROGRESS;
>  }
> @@ -1013,11 +1013,11 @@ static inline struct dma_chan *dma_find_channel(enum dma_transaction_type tx_typ
>  }
>  static inline enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
>  {
> -	return DMA_SUCCESS;
> +	return DMA_COMPLETE;
>  }
>  static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
>  {
> -	return DMA_SUCCESS;
> +	return DMA_COMPLETE;
>  }
>  static inline void dma_issue_pending_all(void)
>  {
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
