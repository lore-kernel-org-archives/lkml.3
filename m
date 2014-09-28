Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaI1QnE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:43:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:53513 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbaI1QnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:43:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,615,1406617200"; 
   d="scan'208";a="609917834"
Date: Sun, 28 Sep 2014 21:43:33 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de
Subject: Re: [PATCH 3/9] dmaengine: Introduce a device_config callback
Message-ID: <20140928161333.GK1638@intel.com>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
 <1411808085-27792-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411808085-27792-4-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 10:54:39AM +0200, Maxime Ripard wrote:
> The fact that the channel configuration is done in device_control is rather
> misleading, since it's not really advertised as such, plus, the fact that the
> framework exposes a function of its own makes it not really intuitive, while
> we're losing the type checking whenever we pass that unsigned long argument.
> 
> Add a device_config callback to dma_device, with a fallback on the old
> behaviour for now for existing drivers to opt in.
This will break bisect, we have users of device_control in tree, they need
to be converted first to use wrappers and then we should introduce these

-- 
~Vinod
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  include/linux/dmaengine.h | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index f4b71ce1a0a6..7937f81e5e2e 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -608,6 +608,8 @@ struct dma_tx_state {
>   *	The function takes a buffer of size buf_len. The callback function will
>   *	be called after period_len bytes have been transferred.
>   * @device_prep_interleaved_dma: Transfer expression in a generic way.
> + * @device_config: Pushes a new configuration to a channel, return 0 or an error
> + *	code
>   * @device_control: manipulate all pending operations on a channel, returns
>   *	zero or error code
>   * @device_tx_status: poll for transaction completion, the optional
> @@ -662,7 +664,6 @@ struct dma_device {
>  		struct scatterlist *dst_sg, unsigned int dst_nents,
>  		struct scatterlist *src_sg, unsigned int src_nents,
>  		unsigned long flags);
> -
>  	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
>  		struct dma_chan *chan, struct scatterlist *sgl,
>  		unsigned int sg_len, enum dma_transfer_direction direction,
> @@ -674,9 +675,11 @@ struct dma_device {
>  	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
>  		struct dma_chan *chan, struct dma_interleaved_template *xt,
>  		unsigned long flags);
> -	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> -		unsigned long arg);
>  
> +	int (*device_config)(struct dma_chan *chan,
> +			     struct dma_slave_config *config);
> +	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +			      unsigned long arg);
>  	enum dma_status (*device_tx_status)(struct dma_chan *chan,
>  					    dma_cookie_t cookie,
>  					    struct dma_tx_state *txstate);
> @@ -697,6 +700,9 @@ static inline int dmaengine_device_control(struct dma_chan *chan,
>  static inline int dmaengine_slave_config(struct dma_chan *chan,
>  					  struct dma_slave_config *config)
>  {
> +	if (chan->device->device_config)
> +		return chan->device->device_config(chan, config);
> +
>  	return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
>  			(unsigned long)config);
>  }
> -- 
> 2.1.0
> 

-- 
