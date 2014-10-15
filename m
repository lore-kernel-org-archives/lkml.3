Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaJOQEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:04:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:48402 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaJOQEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:04:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,725,1406617200"; 
   d="scan'208";a="614977892"
Date: Wed, 15 Oct 2014 20:57:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 09/13] dmaengine: edma: check for echan->edesc => NULL
 in edma_dma_pause()
Message-ID: <20141015152700.GY1638@intel.com>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
 <1412014009-13315-10-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412014009-13315-10-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:06:45PM +0200, Sebastian Andrzej Siewior wrote:
> I added book keeping of whether or not the 8250-dma driver has an RX
> transfer pending or not so we don't BUG here if it calls
> dmaengine_pause() on a channel which has not a pending transfer. Guess
> what, this is not enough.
> The following can be triggered with a busy RX channel and hackbench in
> background:
> - DMA transfer completes. The callback is delayed via
>   vchan_cookie_complete() into a tasklet so it das not happen asap.
> - hackbench keeps the system busy so the tasklet does not run "soon".
> - the UART collected enough data and generates an "timeout"-interrupt.
>   Since 8250-dma *thinks* the DMA-transfer is still pending it tries to
>   cancel it via invoking dmaengine_pause() first. This causes the segfault
>   because echan->edesc is NULL now that the transfer completed (however
>   the callback did not run yet).
> 
> With this patch we don't BUG in the scenario described.

Applied thanks

-- 
~Vinod
> 
> Cc: vinod.koul@intel.com
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/dma/edma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 7b65633f495e..123f578d6dd3 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -288,7 +288,7 @@ static int edma_slave_config(struct edma_chan *echan,
>  static int edma_dma_pause(struct edma_chan *echan)
>  {
>  	/* Pause/Resume only allowed with cyclic mode */
> -	if (!echan->edesc->cyclic)
> +	if (!echan->edesc || !echan->edesc->cyclic)
>  		return -EINVAL;
>  
>  	edma_pause(echan->ch_num);
> -- 
> 2.1.0
> 

-- 
