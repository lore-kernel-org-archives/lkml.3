Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab3E2Cci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:32:38 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52828 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3E2Cch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:32:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] media: davinci: vpif_capture: move the freeing of irq and global variables to remove()
Date: Wed, 29 May 2013 04:32:30 +0200
Message-ID: <2564718.Z6XYOtT7FL@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369569612-30915-5-git-send-email-prabhakar.csengg@gmail.com>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com> <1369569612-30915-5-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thanks for the patch.

On Sunday 26 May 2013 17:30:07 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Ideally the freeing of irq's and the global variables needs to be
> done in the remove() rather than module_exit(), this patch moves
> the freeing up of irq's and freeing the memory allocated to channel
> objects to remove() callback of struct platform_driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c |   31 ++++++++++------------
>  1 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c
> b/drivers/media/platform/davinci/vpif_capture.c index caaf4fe..f8b7304
> 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -2225,17 +2225,29 @@ vpif_int_err:
>   */
>  static int vpif_remove(struct platform_device *device)
>  {
> -	int i;
> +	struct platform_device *pdev;
>  	struct channel_obj *ch;
> +	struct resource *res;
> +	int irq_num, i = 0;
> +
> +	pdev = container_of(vpif_dev, struct platform_device, dev);

As Sergei mentioned, the platform device is already passed to the function as 
an argument.

> +	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
> +		for (irq_num = res->start; irq_num <= res->end; irq_num++)
> +			free_irq(irq_num,
> +				 (void *)(&vpif_obj.dev[i]->channel_id));

A quick look at board code shows that each IRQ resource contains a single IRQ. 
The second loop could thus be removed. You could also add another patch to 
perform similar cleanup for the probe code.

> +		i++;
> +	}
> 
>  	v4l2_device_unregister(&vpif_obj.v4l2_dev);
> 
> +	kfree(vpif_obj.sd);
>  	/* un-register device */
>  	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
>  		/* Get the pointer to the channel object */
>  		ch = vpif_obj.dev[i];
>  		/* Unregister video device */
>  		video_unregister_device(ch->video_dev);
> +		kfree(vpif_obj.dev[i]);
>  	}
>  	return 0;
>  }
> @@ -2347,24 +2359,7 @@ static __init int vpif_init(void)
>   */
>  static void vpif_cleanup(void)
>  {
> -	struct platform_device *pdev;
> -	struct resource *res;
> -	int irq_num;
> -	int i = 0;
> -
> -	pdev = container_of(vpif_dev, struct platform_device, dev);
> -	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
> -		for (irq_num = res->start; irq_num <= res->end; irq_num++)
> -			free_irq(irq_num,
> -				 (void *)(&vpif_obj.dev[i]->channel_id));
> -		i++;
> -	}
> -
>  	platform_driver_unregister(&vpif_driver);
> -
> -	kfree(vpif_obj.sd);
> -	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++)
> -		kfree(vpif_obj.dev[i]);
>  }
> 
>  /* Function for module initialization and cleanup */
-- 
Regards,

Laurent Pinchart

