Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990Ab3E2Dil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:38:41 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53178 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab3E2Dik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:38:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 9/9] media: davinci: vpif_display: Convert to devm_* api
Date: Wed, 29 May 2013 05:38:38 +0200
Message-ID: <1915324.uRjOv648gy@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369569612-30915-10-git-send-email-prabhakar.csengg@gmail.com>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com> <1369569612-30915-10-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 May 2013 17:30:12 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> use devm_request_irq() instead of request_irq(). This ensures
> more consistent error values and simplifies error paths.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

with a small comment below.

> ---
>  drivers/media/platform/davinci/vpif_display.c |   35 ++++++----------------
>  1 files changed, 9 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_display.c
> b/drivers/media/platform/davinci/vpif_display.c index 7bcfe7d..e2f080b
> 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1718,15 +1718,14 @@ static __init int vpif_probe(struct platform_device
> *pdev)
> 
>  	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
>  		for (i = res->start; i <= res->end; i++) {
> -			if (request_irq(i, vpif_channel_isr, IRQF_SHARED,
> -					"VPIF_Display", (void *)
> -					(&vpif_obj.dev[res_idx]->channel_id))) {
> -				err = -EBUSY;
> -				for (j = 0; j < i; j++)
> -					free_irq(j, (void *)
> -					(&vpif_obj.dev[res_idx]->channel_id));
> +			err = devm_request_irq(&pdev->dev, i, vpif_channel_isr,
> +					     IRQF_SHARED, "VPIF_Display",
> +					     (void *)(&vpif_obj.dev[res_idx]->
> +					     channel_id));
> +			if (err) {
> +				err = -EINVAL;
>  				vpif_err("VPIF IRQ request failed\n");
> -				goto vpif_int_err;
> +				goto vpif_unregister;
>  			}
>  		}
>  		res_idx++;
> @@ -1744,7 +1743,7 @@ static __init int vpif_probe(struct platform_device
> *pdev) video_device_release(ch->video_dev);
>  			}
>  			err = -ENOMEM;
> -			goto vpif_int_err;
> +			goto vpif_unregister;
>  		}
> 
>  		/* Initialize field of video device */
> @@ -1878,13 +1877,8 @@ vpif_sd_error:
>  		/* Note: does nothing if ch->video_dev == NULL */
>  		video_device_release(ch->video_dev);
>  	}
> -vpif_int_err:
> +vpif_unregister:
>  	v4l2_device_unregister(&vpif_obj.v4l2_dev);
> -	for (i = 0; i < res_idx; i++) {
> -		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
> -		for (j = res->start; j <= res->end; j++)
> -			free_irq(j, (void *)(&vpif_obj.dev[i]->channel_id));
> -	}
> 
>  	return err;
>  }
> @@ -1894,20 +1888,9 @@ vpif_int_err:
>   */
>  static int vpif_remove(struct platform_device *device)
>  {
> -	struct platform_device *pdev;
>  	struct channel_obj *ch;
> -	struct resource *res;
> -	int irq_num;
>  	int i = 0;

There's no need to initialize i to 0 anymore (same comment for patch 6/9).

> -	pdev = container_of(vpif_dev, struct platform_device, dev);
> -	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
> -		for (irq_num = res->start; irq_num <= res->end; irq_num++)
> -			free_irq(irq_num,
> -				 (void *)(&vpif_obj.dev[i]->channel_id));
> -		i++;
> -	}
> -
>  	v4l2_device_unregister(&vpif_obj.v4l2_dev);
> 
>  	kfree(vpif_obj.sd);
-- 
Regards,

Laurent Pinchart

