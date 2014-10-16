Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaJPKpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:45:19 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:36824 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJPKpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:45:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 04/53] dmaengine: split out pause/resume operations from device_control
Date: Thu, 16 Oct 2014 13:45:29 +0300
Message-ID: <4666963.qZuBZWrpU6@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413454672-27400-5-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com> <1413454672-27400-5-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Thursday 16 October 2014 12:17:03 Maxime Ripard wrote:
> Split out the pause and resume operations to callbacks of their own. In
> order to preserve some backwark compatibility, the
> dmaengine_pause/dmaengine_resume are still falling back on
> dmaengine_device_control.
> 
> Hopefully, that will allow to get the device capabilities in a generic way,
> removing the need to implement device_slave_caps.

Instead of being hopeful let's implement that ;-)

> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/linux/dmaengine.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 7937f81e5e2e..b89c8004fcd8 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -612,6 +612,10 @@ struct dma_tx_state {
>   *	code
>   * @device_control: manipulate all pending operations on a channel, returns
> *	zero or error code
> + * @device_pause: Pauses any transfer happening on a channel. Returns
> + *	0 or an error code
> + * @device_resume: Resumes any transfer on a channel previously
> + *	paused. Returns 0 or an error code
>   * @device_tx_status: poll for transaction completion, the optional
>   *	txstate parameter can be supplied with a pointer to get a
>   *	struct with auxiliary transfer status information, otherwise the call
> @@ -680,6 +684,8 @@ struct dma_device {
>  			     struct dma_slave_config *config);
>  	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  			      unsigned long arg);
> +	int (*device_pause)(struct dma_chan *chan);
> +	int (*device_resume)(struct dma_chan *chan);
>  	enum dma_status (*device_tx_status)(struct dma_chan *chan,
>  					    dma_cookie_t cookie,
>  					    struct dma_tx_state *txstate);
> @@ -783,11 +789,17 @@ static inline int dmaengine_terminate_all(struct
> dma_chan *chan)
> 
>  static inline int dmaengine_pause(struct dma_chan *chan)
>  {
> +	if (chan->device->device_pause)
> +		return chan->device->device_pause(chan);
> +
>  	return dmaengine_device_control(chan, DMA_PAUSE, 0);
>  }
> 
>  static inline int dmaengine_resume(struct dma_chan *chan)
>  {
> +	if (chan->device->device_resume)
> +		return chan->device->device_resume(chan);
> +
>  	return dmaengine_device_control(chan, DMA_RESUME, 0);
>  }

-- 
Regards,

Laurent Pinchart

