Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbaJVV1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:27:46 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:43182 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbaJVV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:27:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 04/59] dmaengine: Rework dma_chan_get
Date: Thu, 23 Oct 2014 00:27:41 +0300
Message-ID: <2155745.KzAV5BO9AY@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413992653-21963-5-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com> <1413992653-21963-5-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Wednesday 22 October 2014 17:43:18 Maxime Ripard wrote:
> dma_chan_get uses a rather interesting error handling and code path.
> 
> Change it to something more usual in the kernel.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/dma/dmaengine.c | 36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 24bfaf0b92ba..72f10e2f5c32 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -222,31 +222,33 @@ static void balance_ref_count(struct dma_chan *chan)
>   */
>  static int dma_chan_get(struct dma_chan *chan)
>  {
> -	int err = -ENODEV;
>  	struct module *owner = dma_chan_to_owner(chan);
> +	int ret;
> 
> +	/* The channel is already in use, update client count */
>  	if (chan->client_count) {
>  		__module_get(owner);
> -		err = 0;
> -	} else if (try_module_get(owner))
> -		err = 0;
> +		goto out;
> +	}
> 
> -	if (err == 0)
> -		chan->client_count++;
> +	if (!try_module_get(owner))
> +		return -ENODEV;
> 
>  	/* allocate upon first client reference */
> -	if (chan->client_count == 1 && err == 0) {
> -		int desc_cnt = chan->device->device_alloc_chan_resources(chan);
> -
> -		if (desc_cnt < 0) {
> -			err = desc_cnt;
> -			chan->client_count = 0;
> -			module_put(owner);
> -		} else if (!dma_has_cap(DMA_PRIVATE, chan->device->cap_mask))
> -			balance_ref_count(chan);
> -	}
> +	ret = chan->device->device_alloc_chan_resources(chan);
> +	if (ret < 0)
> +		goto err_out;
> 
> -	return err;
> +	if (!dma_has_cap(DMA_PRIVATE, chan->device->cap_mask))
> +		balance_ref_count(chan);
> +
> +out:
> +	chan->client_count++;
> +	return 0;
> +
> +err_out:
> +	module_put(owner);
> +	return ret;
>  }
> 
>  /**

-- 
Regards,

Laurent Pinchart

