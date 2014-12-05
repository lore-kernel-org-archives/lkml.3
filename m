Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaLEO2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:28:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:18960 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaLEO2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:28:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="633267200"
Date: Fri, 5 Dec 2014 19:59:16 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 32/61] dmaengine: mxs: Split device_control
Message-ID: <20141205142916.GG3411@intel.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <1416231775-31252-33-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416231775-31252-33-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:42:26PM +0100, Maxime Ripard wrote:
> Split the device_control callback of the Freescale MXS DMA driver to make use
> of the newly introduced callbacks, that will eventually be used to retrieve
> slave capabilities.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/dma/mxs-dma.c | 59 ++++++++++++++++++++-------------------------------
>  1 file changed, 23 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 5ea61201dbf0..834041e5a769 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -202,8 +202,9 @@ static struct mxs_dma_chan *to_mxs_dma_chan(struct dma_chan *chan)
>  	return container_of(chan, struct mxs_dma_chan, chan);
>  }
>  
> -static void mxs_dma_reset_chan(struct mxs_dma_chan *mxs_chan)
> +static void mxs_dma_reset_chan(struct dma_chan *chan)
>  {
> +	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
>  	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
>  	int chan_id = mxs_chan->chan.chan_id;
>  
> @@ -250,8 +251,9 @@ static void mxs_dma_reset_chan(struct mxs_dma_chan *mxs_chan)
>  	mxs_chan->status = DMA_COMPLETE;
>  }
>  
> -static void mxs_dma_enable_chan(struct mxs_dma_chan *mxs_chan)
> +static void mxs_dma_enable_chan(struct dma_chan *chan)
>  {
> +	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
>  	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
>  	int chan_id = mxs_chan->chan.chan_id;
>  
> @@ -272,13 +274,16 @@ static void mxs_dma_enable_chan(struct mxs_dma_chan *mxs_chan)
>  	mxs_chan->reset = false;
>  }
>  
> -static void mxs_dma_disable_chan(struct mxs_dma_chan *mxs_chan)
> +static void mxs_dma_disable_chan(struct dma_chan *chan)
>  {
> +	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
> +
>  	mxs_chan->status = DMA_COMPLETE;
>  }
>  
> -static void mxs_dma_pause_chan(struct mxs_dma_chan *mxs_chan)
> +static void mxs_dma_pause_chan(struct dma_chan *chan)
>  {
> +	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
>  	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
>  	int chan_id = mxs_chan->chan.chan_id;
>  
> @@ -293,8 +298,9 @@ static void mxs_dma_pause_chan(struct mxs_dma_chan *mxs_chan)
>  	mxs_chan->status = DMA_PAUSED;
>  }
>  
> -static void mxs_dma_resume_chan(struct mxs_dma_chan *mxs_chan)
> +static void mxs_dma_resume_chan(struct dma_chan *chan)
>  {
> +	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
>  	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
>  	int chan_id = mxs_chan->chan.chan_id;
>  
> @@ -383,7 +389,7 @@ static irqreturn_t mxs_dma_int_handler(int irq, void *dev_id)
>  			"%s: error in channel %d\n", __func__,
>  			chan);
>  		mxs_chan->status = DMA_ERROR;
> -		mxs_dma_reset_chan(mxs_chan);
> +		mxs_dma_reset_chan(mxs_chan->chan);
this would fail. chan is struct type not a pointer

-- 
~Vinod

>  	} else if (mxs_chan->status != DMA_COMPLETE) {
>  		if (mxs_chan->flags & MXS_DMA_SG_LOOP) {
>  			mxs_chan->status = DMA_IN_PROGRESS;
> @@ -432,7 +438,7 @@ static int mxs_dma_alloc_chan_resources(struct dma_chan *chan)
>  	if (ret)
>  		goto err_clk;
>  
> -	mxs_dma_reset_chan(mxs_chan);
> +	mxs_dma_reset_chan(chan);
>  
>  	dma_async_tx_descriptor_init(&mxs_chan->desc, chan);
>  	mxs_chan->desc.tx_submit = mxs_dma_tx_submit;
> @@ -456,7 +462,7 @@ static void mxs_dma_free_chan_resources(struct dma_chan *chan)
>  	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
>  	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
>  
> -	mxs_dma_disable_chan(mxs_chan);
> +	mxs_dma_disable_chan(chan);
>  
>  	free_irq(mxs_chan->chan_irq, mxs_dma);
>  
> @@ -651,28 +657,14 @@ err_out:
>  	return NULL;
>  }
>  
> -static int mxs_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> -		unsigned long arg)
> +static int mxs_dma_terminate_all(struct dma_chan *chan)
>  {
>  	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
> -	int ret = 0;
> -
> -	switch (cmd) {
> -	case DMA_TERMINATE_ALL:
> -		mxs_dma_reset_chan(mxs_chan);
> -		mxs_dma_disable_chan(mxs_chan);
> -		break;
> -	case DMA_PAUSE:
> -		mxs_dma_pause_chan(mxs_chan);
> -		break;
> -	case DMA_RESUME:
> -		mxs_dma_resume_chan(mxs_chan);
> -		break;
> -	default:
> -		ret = -ENOSYS;
> -	}
>  
> -	return ret;
> +	mxs_dma_reset_chan(chan);
> +	mxs_dma_disable_chan(chan);
> +
> +	return 0;
>  }
>  
>  static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
> @@ -701,13 +693,6 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
>  	return mxs_chan->status;
>  }
>  
> -static void mxs_dma_issue_pending(struct dma_chan *chan)
> -{
> -	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
> -
> -	mxs_dma_enable_chan(mxs_chan);
> -}
> -
>  static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
>  {
>  	int ret;
> @@ -860,8 +845,10 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
>  	mxs_dma->dma_device.device_tx_status = mxs_dma_tx_status;
>  	mxs_dma->dma_device.device_prep_slave_sg = mxs_dma_prep_slave_sg;
>  	mxs_dma->dma_device.device_prep_dma_cyclic = mxs_dma_prep_dma_cyclic;
> -	mxs_dma->dma_device.device_control = mxs_dma_control;
> -	mxs_dma->dma_device.device_issue_pending = mxs_dma_issue_pending;
> +	mxs_dma->dma_device.device_pause = mxs_dma_pause_chan;
> +	mxs_dma->dma_device.device_resume = mxs_dma_resume_chan;
> +	mxs_dma->dma_device.device_terminate_all = mxs_dma_terminate_all;
> +	mxs_dma->dma_device.device_issue_pending = mxs_dma_enable_chan;
>  
>  	ret = dma_async_device_register(&mxs_dma->dma_device);
>  	if (ret) {
> -- 
> 2.1.1
> 

-- 
