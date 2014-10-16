Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaJPKoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:44:16 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:36821 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaJPKoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:44:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 03/53] dmaengine: Introduce a device_config callback
Date: Thu, 16 Oct 2014 13:44:25 +0300
Message-ID: <7987719.j9o27htEhN@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413454672-27400-4-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com> <1413454672-27400-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Thursday 16 October 2014 12:17:02 Maxime Ripard wrote:
> The fact that the channel configuration is done in device_control is rather
> misleading, since it's not really advertised as such, plus, the fact that
> the framework exposes a function of its own makes it not really intuitive,
> while we're losing the type checking whenever we pass that unsigned long
> argument.
> 
> Add a device_config callback to dma_device, with a fallback on the old
> behaviour for now for existing drivers to opt in.
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
>   *	The function takes a buffer of size buf_len. The callback function 
will
>   *	be called after period_len bytes have been transferred.
>   * @device_prep_interleaved_dma: Transfer expression in a generic way.
> + * @device_config: Pushes a new configuration to a channel, return 0 or an
> error
> + *	code
>   * @device_control: manipulate all pending operations on a channel, returns
> *	zero or error code
>   * @device_tx_status: poll for transaction completion, the optional
> @@ -662,7 +664,6 @@ struct dma_device {
>  		struct scatterlist *dst_sg, unsigned int dst_nents,
>  		struct scatterlist *src_sg, unsigned int src_nents,
>  		unsigned long flags);
> -

That's an unrelated change.

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

As you'll move device_control in the last patch of this series I would avoid 
the cosmetic modification here.

Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	enum dma_status (*device_tx_status)(struct dma_chan *chan,
>  					    dma_cookie_t cookie,
>  					    struct dma_tx_state *txstate);
> @@ -697,6 +700,9 @@ static inline int dmaengine_device_control(struct
> dma_chan *chan, static inline int dmaengine_slave_config(struct dma_chan
> *chan,
>  					  struct dma_slave_config *config)
>  {
> +	if (chan->device->device_config)
> +		return chan->device->device_config(chan, config);
> +
>  	return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
>  			(unsigned long)config);
>  }

-- 
Regards,

Laurent Pinchart

