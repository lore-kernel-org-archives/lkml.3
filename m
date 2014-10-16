Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaJPQPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:15:33 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:37143 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaJPQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:15:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 06/53] dmaengine: Create a generic dma_slave_caps callback
Date: Thu, 16 Oct 2014 19:15:40 +0300
Message-ID: <1496298.0f0GAuhKve@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413454672-27400-7-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com> <1413454672-27400-7-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Thursday 16 October 2014 12:17:05 Maxime Ripard wrote:
> dma_slave_caps is very important to the generic layers that might interact
> with dmaengine, such as ASoC. Unfortunately, it has been added as yet
> another dma_device callback, and most of the existing drivers haven't
> implemented it, reducing its reliability.
> 
> Introduce a generic behaviour and a flag to trigger it. In case this flag
> hasn't been set, fall back to the old mechanism.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  include/linux/dmaengine.h | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 4d0294ec3567..85afd71df2e7 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -643,6 +643,8 @@ struct dma_device {
>  	int dev_id;
>  	struct device *dev;
> 
> +	bool generic_slave_caps;
> +
>  	int (*device_alloc_chan_resources)(struct dma_chan *chan);
>  	void (*device_free_chan_resources)(struct dma_chan *chan);
> 
> @@ -772,17 +774,32 @@ static inline struct dma_async_tx_descriptor
> *dmaengine_prep_interleaved_dma(
> 
>  static inline int dma_get_slave_caps(struct dma_chan *chan, struct
> dma_slave_caps *caps) {

This is getting too big for an inline function, it should be moved to 
drivers/dma/dmaengine.c.

> +	struct dma_device *device;
> +
>  	if (!chan || !caps)
>  		return -EINVAL;
> 
> +	device = chan->device;
> +
>  	/* check if the channel supports slave transactions */
> -	if (!test_bit(DMA_SLAVE, chan->device->cap_mask.bits))
> +	if (!test_bit(DMA_SLAVE, device->cap_mask.bits))
> +		return -ENXIO;
> +
> +	if (device->device_slave_caps)
> +		return device->device_slave_caps(chan, caps);
> +
> +	/*
> +	 * Check whether it reports it uses the generic slave
> +	 * capabilities, if not, that means it doesn't support any
> +	 * kind of slave capabilities reporting.
> +	 */
> +	if (device->generic_slave_caps)
>  		return -ENXIO;

Couldn't we replace that check with if (device->device_control) and get rid of 
the generic_slave_caps field ? Drivers converted to the new API would then get 
slave caps support for free.

> -	if (chan->device->device_slave_caps)
> -		return chan->device->device_slave_caps(chan, caps);
> +	caps->cmd_pause = !!device->device_pause;
> +	caps->cmd_terminate = !!device->device_terminate_all;
> 
> -	return -ENXIO;
> +	return 0;
>  }
> 
>  static inline int dmaengine_terminate_all(struct dma_chan *chan)

-- 
Regards,

Laurent Pinchart

