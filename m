Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbaGaM0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:26:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:29670 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaGaM0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:26:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,772,1400050800"; 
   d="scan'208";a="581675929"
Date: Thu, 31 Jul 2014 17:47:02 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Joel Fernandes <joelf@ti.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/7] dmaengine: edma: fix two faults which happen with
 the 8250_dma user
Message-ID: <20140731121702.GU8181@intel.com>
References: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
 <1406660344-25307-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406660344-25307-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 08:58:58PM +0200, Sebastian Andrzej Siewior wrote:
> The rx path of the 8250_dma user in the RX-timeout case:
> - it starts the RX transfer
> - if the rx-timeout interrupt occures, it dmaengine_pause() the transfer
> - step two is dmaengine_terminate_all() on this channel.
Okay after this whole channel needs to be reset, which means all the
descriptors are discared.
> - based on dmaengine_tx_status() it learns the number of transfered
>   bytes.
> - the rx interrupt occures,
why, channel is terminated, so existing txn needs to be aborted too

>   it does not start the RX-transfer because
>   according to dmaengine_tx_status() the status of the current transfer
>   is still DMA_IN_PROGRESS because the earlier dmaengine_terminate_all()
>   did not reset this.
there is no current transfer anymore

> - on rx-timeout it invokes dmaengine_pause() again. This time, it
>   segfaults because the channel has no descriptor yet.
> 
> To make the upper case work better, this patch adds dma_cookie_complete()
> to complete the cookie. Also it adds is an additional check for echan->edesc
> in case the channel has no descriptor assigned.
I think we are fixing the behvaiour rather than cause. terminate_all(()
needs to do a proper cleanup of the channel

And this looks a series, without cover letter sent to all. Which makes it a
bit hard to see what is getting done

-- 
~Vinod
> 
> Cc: Joel Fernandes <joelf@ti.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: dmaengine@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/dma/edma.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index d08c4de..ff05dd4 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -256,6 +256,7 @@ static int edma_terminate_all(struct edma_chan *echan)
>  	 * echan->edesc is NULL and exit.)
>  	 */
>  	if (echan->edesc) {
> +		dma_cookie_complete(&echan->edesc->vdesc.tx);
>  		echan->edesc = NULL;
>  		edma_stop(echan->ch_num);
>  	}
> @@ -282,7 +283,7 @@ static int edma_slave_config(struct edma_chan *echan,
>  static int edma_dma_pause(struct edma_chan *echan)
>  {
>  	/* Pause/Resume only allowed with cyclic mode */
> -	if (!echan->edesc->cyclic)
> +	if (!echan->edesc || !echan->edesc->cyclic)
>  		return -EINVAL;
>  
>  	edma_pause(echan->ch_num);
> -- 
> 2.0.1
> 

-- 
