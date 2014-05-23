Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaEWIsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:48:54 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4332 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaEWIsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:48:51 -0400
Message-ID: <537F0B4D.60700@xs4all.nl>
Date: Fri, 23 May 2014 10:48:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 21/49] media: davinci: vpif_display: use SIMPLE_DEV_PM_OPS
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com> <1400247235-31434-23-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1400247235-31434-23-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 03:33 PM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch uses SIMPLE_DEV_PM_OPS, and drops unneeded members
> from io_usrs, usrs and makes use of vb2 helepers instead.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpif_display.c |   64 ++++++++++++-------------
>  drivers/media/platform/davinci/vpif_display.h |    4 --
>  2 files changed, 30 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index 401d03a..81d955a 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1124,10 +1124,8 @@ static int vpif_probe_complete(void)
>  	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
>  		ch = vpif_obj.dev[j];
>  		/* Initialize field of the channel objects */
> -		atomic_set(&ch->usrs, 0);
>  		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
>  			common = &ch->common[k];
> -			common->io_usrs = 0;
>  			spin_lock_init(&common->irqlock);
>  			mutex_init(&common->lock);
>  			common->set_addr = NULL;
> @@ -1371,7 +1369,7 @@ static int vpif_remove(struct platform_device *device)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  static int vpif_suspend(struct device *dev)
>  {
>  	struct common_obj *common;
> @@ -1382,18 +1380,20 @@ static int vpif_suspend(struct device *dev)
>  		/* Get the pointer to the channel object */
>  		ch = vpif_obj.dev[i];
>  		common = &ch->common[VPIF_VIDEO_INDEX];
> +
> +		if (!vb2_is_streaming(&common->buffer_queue))
> +			continue;

The use of vb2_is_streaming here is not correct. It is possible to call STREAMON
without having any buffers queued. So vb2_is_streaming() can return true without
start_streaming() having been called. Only after at least one buffer has been
queued will start_streaming be called.

So this code will fail if you call STREAMON without any buffers queued and
then suspend and resume. The resume callback will start the DMA without having
proper DMA pointers set up. Probably not a good idea.

The fix is to check the vb2_queue->start_streaming_called flag. I think we
need a vb2_start_streaming_called() inline function as that's a bit cleaner
than checking that flag directly.

Regards,

	Hans

> +
>  		mutex_lock(&common->lock);
> -		if (atomic_read(&ch->usrs) && common->io_usrs) {
> -			/* Disable channel */
> -			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
> -				enable_channel2(0);
> -				channel2_intr_enable(0);
> -			}
> -			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
> -				ycmux_mode == 2) {
> -				enable_channel3(0);
> -				channel3_intr_enable(0);
> -			}
> +		/* Disable channel */
> +		if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
> +			enable_channel2(0);
> +			channel2_intr_enable(0);
> +		}
> +		if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
> +			ycmux_mode == 2) {
> +			enable_channel3(0);
> +			channel3_intr_enable(0);
>  		}
>  		mutex_unlock(&common->lock);
>  	}
> @@ -1412,18 +1412,20 @@ static int vpif_resume(struct device *dev)
>  		/* Get the pointer to the channel object */
>  		ch = vpif_obj.dev[i];
>  		common = &ch->common[VPIF_VIDEO_INDEX];
> +
> +		if (!vb2_is_streaming(&common->buffer_queue))
> +			continue;
> +
>  		mutex_lock(&common->lock);
> -		if (atomic_read(&ch->usrs) && common->io_usrs) {
> -			/* Enable channel */
> -			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
> -				enable_channel2(1);
> -				channel2_intr_enable(1);
> -			}
> -			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
> -					ycmux_mode == 2) {
> -				enable_channel3(1);
> -				channel3_intr_enable(1);
> -			}
> +		/* Enable channel */
> +		if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
> +			enable_channel2(1);
> +			channel2_intr_enable(1);
> +		}
> +		if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
> +				ycmux_mode == 2) {
> +			enable_channel3(1);
> +			channel3_intr_enable(1);
>  		}
>  		mutex_unlock(&common->lock);
>  	}
> @@ -1431,21 +1433,15 @@ static int vpif_resume(struct device *dev)
>  	return 0;
>  }
>  
> -static const struct dev_pm_ops vpif_pm = {
> -	.suspend        = vpif_suspend,
> -	.resume         = vpif_resume,
> -};
> -
> -#define vpif_pm_ops (&vpif_pm)
> -#else
> -#define vpif_pm_ops NULL
>  #endif
>  
> +static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
> +
>  static __refdata struct platform_driver vpif_driver = {
>  	.driver	= {
>  			.name	= VPIF_DRIVER_NAME,
>  			.owner	= THIS_MODULE,
> -			.pm	= vpif_pm_ops,
> +			.pm	= &vpif_pm_ops,
>  	},
>  	.probe	= vpif_probe,
>  	.remove	= vpif_remove,
> diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
> index 089e860..18cba9a 100644
> --- a/drivers/media/platform/davinci/vpif_display.h
> +++ b/drivers/media/platform/davinci/vpif_display.h
> @@ -83,8 +83,6 @@ struct common_obj {
>  	/* channel specific parameters */
>  	struct mutex lock;			/* lock used to access this
>  						 * structure */
> -	u32 io_usrs;				/* number of users performing
> -						 * IO */
>  	u32 ytop_off;				/* offset of Y top from the
>  						 * starting of the buffer */
>  	u32 ybtm_off;				/* offset of Y bottom from the
> @@ -104,8 +102,6 @@ struct channel_obj {
>  	/* V4l2 specific parameters */
>  	struct video_device *video_dev;	/* Identifies video device for
>  					 * this channel */
> -	atomic_t usrs;			/* number of open instances of
> -					 * the channel */
>  	u32 field_id;			/* Indicates id of the field
>  					 * which is being displayed */
>  	u8 initialized;			/* flag to indicate whether
> 

