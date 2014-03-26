Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaCZHIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:08:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49118 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaCZHIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:08:20 -0400
Subject: Re: [PATCH 6/7] DMA: Freescale: use spin_lock_bh instead of
 spin_lock_irqsave
From: Vinod Koul <vkoul@infradead.org>
To: hongbo.zhang@freescale.com
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, LeoLi@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1389851246-8564-7-git-send-email-hongbo.zhang@freescale.com>
References: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
	 <1389851246-8564-7-git-send-email-hongbo.zhang@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Mar 2014 12:31:34 +0530
Message-ID: <1395817294.6569.2.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 13:47 +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> The usage of spin_lock_irqsave() is a stronger locking mechanism than is
> required throughout the driver. The minimum locking required should be used
> instead. Interrupts will be turned off and context will be saved, it is
> unnecessary to use irqsave.
> 
> This patch changes all instances of spin_lock_irqsave() to spin_lock_bh(). All
> manipulation of protected fields is done using tasklet context or weaker, which
> makes spin_lock_bh() the correct choice.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> ---
>  drivers/dma/fsldma.c |   25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index bbace54..437794e 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -396,10 +396,9 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>  	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
>  	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
>  	struct fsl_desc_sw *child;
> -	unsigned long flags;
>  	dma_cookie_t cookie = -EINVAL;
>  
> -	spin_lock_irqsave(&chan->desc_lock, flags);
> +	spin_lock_bh(&chan->desc_lock);
>  
>  	/*
>  	 * assign cookies to all of the software descriptors
> @@ -412,7 +411,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>  	/* put this transaction onto the tail of the pending queue */
>  	append_ld_queue(chan, desc);
>  
> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
> +	spin_unlock_bh(&chan->desc_lock);
>  
>  	return cookie;
>  }
> @@ -731,15 +730,14 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
>  static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
>  {
>  	struct fsldma_chan *chan = to_fsl_chan(dchan);
> -	unsigned long flags;
>  
>  	chan_dbg(chan, "free all channel resources\n");
> -	spin_lock_irqsave(&chan->desc_lock, flags);
> +	spin_lock_bh(&chan->desc_lock);
>  	fsldma_cleanup_descriptors(chan);
>  	fsldma_free_desc_list(chan, &chan->ld_pending);
>  	fsldma_free_desc_list(chan, &chan->ld_running);
>  	fsldma_free_desc_list(chan, &chan->ld_completed);
> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
> +	spin_unlock_bh(&chan->desc_lock);
>  
>  	dma_pool_destroy(chan->desc_pool);
>  	chan->desc_pool = NULL;
> @@ -958,7 +956,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
>  {
>  	struct dma_slave_config *config;
>  	struct fsldma_chan *chan;
> -	unsigned long flags;
>  	int size;
>  
>  	if (!dchan)
> @@ -968,7 +965,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
>  
>  	switch (cmd) {
>  	case DMA_TERMINATE_ALL:
> -		spin_lock_irqsave(&chan->desc_lock, flags);
> +		spin_lock_bh(&chan->desc_lock);
>  
>  		/* Halt the DMA engine */
>  		dma_halt(chan);
> @@ -979,7 +976,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
>  		fsldma_free_desc_list(chan, &chan->ld_completed);
>  		chan->idle = true;
>  
> -		spin_unlock_irqrestore(&chan->desc_lock, flags);
> +		spin_unlock_bh(&chan->desc_lock);
>  		return 0;
>  
>  	case DMA_SLAVE_CONFIG:
> @@ -1021,11 +1018,10 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
>  static void fsl_dma_memcpy_issue_pending(struct dma_chan *dchan)
>  {
>  	struct fsldma_chan *chan = to_fsl_chan(dchan);
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&chan->desc_lock, flags);
> +	spin_lock_bh(&chan->desc_lock);
>  	fsl_chan_xfer_ld_queue(chan);
> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
> +	spin_unlock_bh(&chan->desc_lock);
>  }
>  
>  /**
> @@ -1124,11 +1120,10 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
>  static void dma_do_tasklet(unsigned long data)
>  {
>  	struct fsldma_chan *chan = (struct fsldma_chan *)data;
> -	unsigned long flags;
>  
>  	chan_dbg(chan, "tasklet entry\n");
>  
> -	spin_lock_irqsave(&chan->desc_lock, flags);
> +	spin_lock_bh(&chan->desc_lock);
okay here is the problem :(

You moved to _bh variant. So if you grab the lock in rest of the code
and irq gets triggered then here we will be spinning to grab the lock.
So effectively you made right locking solution into deadlock situation!

>  
>  	/* the hardware is now idle and ready for more */
>  	chan->idle = true;
> @@ -1136,7 +1131,7 @@ static void dma_do_tasklet(unsigned long data)
>  	/* Run all cleanup for descriptors which have been completed */
>  	fsldma_cleanup_descriptors(chan);
>  
> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
> +	spin_unlock_bh(&chan->desc_lock);
>  
>  	chan_dbg(chan, "tasklet exit\n");
>  }


-- 
Vinod Koul
Intel Corp.

