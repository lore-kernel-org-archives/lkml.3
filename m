Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934811Ab3E2DhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:37:05 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53168 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab3E2DhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:37:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/9] media: davinci: vpif_capture: Convert to devm_* api
Date: Wed, 29 May 2013 05:37:01 +0200
Message-ID: <1758769.0xLW0L5ybf@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369569612-30915-7-git-send-email-prabhakar.csengg@gmail.com>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com> <1369569612-30915-7-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 May 2013 17:30:09 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> use devm_request_irq() instead of request_irq(). This ensures
> more consistent error values and simplifies error paths.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/davinci/vpif_capture.c |   38 ++++++++--------------
>  1 files changed, 12 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c
> b/drivers/media/platform/davinci/vpif_capture.c index 38c1fba..5e1e5f6
> 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -2082,14 +2082,14 @@ static __init int vpif_probe(struct platform_device
> *pdev)
> 
>  	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
>  		for (i = res->start; i <= res->end; i++) {
> -			if (request_irq(i, vpif_channel_isr, IRQF_SHARED,
> -					"VPIF_Capture", (void *)
> -					(&vpif_obj.dev[res_idx]->channel_id))) {
> -				err = -EBUSY;
> -				for (j = 0; j < i; j++)
> -					free_irq(j, (void *)
> -					(&vpif_obj.dev[res_idx]->channel_id));
> -				goto vpif_int_err;
> +			err = devm_request_irq(&pdev->dev, i, vpif_channel_isr,
> +					     IRQF_SHARED, "VPIF_Capture",
> +					     (void *)(&vpif_obj.dev[res_idx]->
> +					     channel_id));
> +			if (err) {
> +				err = -EINVAL;
> +				goto vpif_unregister;
> +
>  			}
>  		}
>  		res_idx++;
> @@ -2106,7 +2106,7 @@ static __init int vpif_probe(struct platform_device
> *pdev) video_device_release(ch->video_dev);
>  			}
>  			err = -ENOMEM;
> -			goto vpif_int_err;
> +			goto vpif_unregister;
>  		}
> 
>  		/* Initialize field of video device */
> @@ -2207,13 +2207,9 @@ vpif_sd_error:
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
> +
>  	return err;
>  }
> 
> @@ -2225,18 +2221,8 @@ vpif_int_err:
>   */
>  static int vpif_remove(struct platform_device *device)
>  {
> -	struct platform_device *pdev;
>  	struct channel_obj *ch;
> -	struct resource *res;
> -	int irq_num, i = 0;
> -
> -	pdev = container_of(vpif_dev, struct platform_device, dev);
> -	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
> -		for (irq_num = res->start; irq_num <= res->end; irq_num++)
> -			free_irq(irq_num,
> -				 (void *)(&vpif_obj.dev[i]->channel_id));
> -		i++;
> -	}
> +	int i;
> 
>  	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-- 
Regards,

Laurent Pinchart

