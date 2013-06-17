Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab3FQORq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:17:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:27054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab3FQORp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:17:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="330900274"
Date: Mon, 17 Jun 2013 19:08:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Subject: Re: [PATCH] dma: mmp_pdma: support for getting residual bytes
Message-ID: <20130617133808.GB10671@intel.com>
References: <1369988485-23176-1-git-send-email-wangxfdu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369988485-23176-1-git-send-email-wangxfdu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 04:21:25PM +0800, Xiang Wang wrote:
> From: Xiang Wang <wangx@marvell.com>
> 
> In some of our drivers (e.g. UART) we may stop a running DMA
> before it finishes. So we need to know how many bytes have
> been transferred.
> 
> Signed-off-by: Xiang Wang <wangx@marvell.com>
> ---
>  drivers/dma/mmp_pdma.c |   77 +++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 69 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index 76a8dcf..0c623cc 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -104,7 +104,8 @@ struct mmp_pdma_chan {
>  	spinlock_t desc_lock;		/* Descriptor list lock */
>  	struct list_head chain_pending;	/* Link descriptors queue for pending */
>  	struct list_head chain_running;	/* Link descriptors queue for running */
> -	bool idle;			/* channel statue machine */
> +	enum dma_status status; /* channel status machine */
> +	u32 bytes_residue;
>  
>  	struct dma_pool *desc_pool;	/* Descriptors pool */
>  };
> @@ -270,7 +271,7 @@ static void start_pending_queue(struct mmp_pdma_chan *chan)
>  	struct mmp_pdma_desc_sw *desc;
>  
>  	/* still in running, irq will start the pending list */
> -	if (!chan->idle) {
> +	if (chan->status == DMA_IN_PROGRESS) {
>  		dev_dbg(chan->dev, "DMA controller still busy\n");
why are you not reading the residue and filling it here as well

>  		return;
>  	}
> @@ -307,7 +308,55 @@ static void start_pending_queue(struct mmp_pdma_chan *chan)
>  	 */
>  	set_desc(chan->phy, desc->async_tx.phys);
>  	enable_chan(chan->phy);
> -	chan->idle = false;
> +	chan->status = DMA_IN_PROGRESS;
> +	chan->bytes_residue = 0;
> +}
> +
> +/*
> + * Get the number of bytes untransferred by DMA.
			      ^^^^^^^^^^^^^
The word which might fit better is pending
> + */
> +static u32 mmp_pdma_get_bytes_residue(struct mmp_pdma_chan *chan)
> +{
> +	u32 reg, orig_pos, cur_pos, residue = 0;
> +	struct mmp_pdma_desc_sw *desc_sw;
> +	struct list_head *list_chain = NULL;
> +
> +	/*
> +	 * When a phy channel is unavailable, maybe its destroied, return last
typo							^^^^^^^^^
> +	 * stored value for safe.
> +	 */
> +	if (!chan || !chan->phy)
> +		return chan->bytes_residue;
> +
> +	if (!list_empty(&chan->chain_running))
> +		list_chain = &chan->chain_running;
> +	else
> +		return 0;
> +
> +	desc_sw = list_first_entry(list_chain, struct mmp_pdma_desc_sw, node);
> +
> +	switch (chan->dir) {
> +	case DMA_DEV_TO_MEM:
> +		reg = (chan->phy->idx << 4) + DTADR;
> +		cur_pos = readl_relaxed(chan->phy->base + reg);
> +		orig_pos = desc_sw->desc.dtadr;
> +		break;
empty line here and below pls

> +	case DMA_MEM_TO_DEV:
> +		reg = (chan->phy->idx << 4) + DSADR;
> +		cur_pos = readl_relaxed(chan->phy->base + reg);
> +		orig_pos = desc_sw->desc.dsadr;
> +		break;
> +	case DMA_MEM_TO_MEM:
> +		reg = (chan->phy->idx << 4) + DTADR;
> +		cur_pos = readl_relaxed(chan->phy->base + reg);
> +		orig_pos = desc_sw->desc.dtadr;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	residue = (u32)(desc_sw->desc.dcmd & DCMD_LENGTH) + orig_pos - cur_pos;
> +	return residue;
>  }
>  
>  
> @@ -381,7 +430,7 @@ static int mmp_pdma_alloc_chan_resources(struct dma_chan *dchan)
>  		chan->phy->vchan = NULL;
>  		chan->phy = NULL;
>  	}
> -	chan->idle = true;
> +	chan->status = DMA_SUCCESS;
>  	chan->dev_addr = 0;
>  	return 1;
>  }
> @@ -409,7 +458,7 @@ static void mmp_pdma_free_chan_resources(struct dma_chan *dchan)
>  
>  	dma_pool_destroy(chan->desc_pool);
>  	chan->desc_pool = NULL;
> -	chan->idle = true;
> +	chan->status = DMA_SUCCESS;
>  	chan->dev_addr = 0;
>  	if (chan->phy) {
>  		chan->phy->vchan = NULL;
> @@ -589,7 +638,13 @@ static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
>  		mmp_pdma_free_desc_list(chan, &chan->chain_pending);
>  		mmp_pdma_free_desc_list(chan, &chan->chain_running);
>  		spin_unlock_irqrestore(&chan->desc_lock, flags);
> -		chan->idle = true;
> +		chan->status = DMA_SUCCESS;
> +		chan->bytes_residue = 0;
> +		break;
ditto
> +	case DMA_PAUSE:
> +		disable_chan(chan->phy);
> +		chan->status = DMA_PAUSED;
> +		chan->bytes_residue = mmp_pdma_get_bytes_residue(chan);
>  		break;
>  	case DMA_SLAVE_CONFIG:
>  		if (cfg->direction == DMA_DEV_TO_MEM) {
> @@ -637,7 +692,8 @@ static enum dma_status mmp_pdma_tx_status(struct dma_chan *dchan,
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&chan->desc_lock, flags);
> -	ret = dma_cookie_status(dchan, cookie, txstate);
> +	ret = chan->status;
> +	dma_set_residue(txstate, chan->bytes_residue);
>  	spin_unlock_irqrestore(&chan->desc_lock, flags);
>  
>  	return ret;
> @@ -684,6 +740,8 @@ static void dma_do_tasklet(unsigned long data)
>  		dev_dbg(chan->dev, "completed_cookie=%d\n", cookie);
>  	}
>  
> +	/* update bytes_residue so that the user can query later on */
> +	chan->bytes_residue = mmp_pdma_get_bytes_residue(chan);
>  	/*
>  	 * move the descriptors to a temporary list so we can drop the lock
>  	 * during the entire cleanup operation
> @@ -691,7 +749,7 @@ static void dma_do_tasklet(unsigned long data)
>  	list_splice_tail_init(&chan->chain_running, &chain_cleanup);
>  
>  	/* the hardware is now idle and ready for more */
> -	chan->idle = true;
> +	chan->status = DMA_SUCCESS;
>  
>  	/* Start any pending transactions automatically */
>  	start_pending_queue(chan);
> @@ -750,6 +808,9 @@ static int mmp_pdma_chan_init(struct mmp_pdma_device *pdev,
>  	INIT_LIST_HEAD(&chan->chain_pending);
>  	INIT_LIST_HEAD(&chan->chain_running);
>  
> +	chan->status = DMA_SUCCESS;
> +	chan->bytes_residue = 0;
> +
>  	/* register virt channel to dma engine */
>  	list_add_tail(&chan->chan.device_node,
>  			&pdev->device.channels);
Okay I went thru the thread briefly. I understand why you are returning the
reside and nice usage model you have here.
What i odnt understand is that the reason for limiting the dma driver to a
certain usage model. Yes this is what you need a nd what you have done. But
nothing prevents you from reading the reside and returning on the fly. All the
basic elements are alreayd in this patch. SO lets do the right thing now :)

--
~Vinod
