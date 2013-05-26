Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab3EZAta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:49:30 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59173 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436Ab3EZAt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:49:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] media: davinci: vpif: Convert to devm_* api
Date: Sun, 26 May 2013 02:49:22 +0200
Message-ID: <1492638.E2728sugZv@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369499796-18762-3-git-send-email-prabhakar.csengg@gmail.com>
References: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com> <1369499796-18762-3-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Saturday 25 May 2013 22:06:33 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Use devm_ioremap_resource instead of reques_mem_region()/ioremap().
> This ensures more consistent error values and simplifies error paths.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpif.c |   27 ++++-----------------------
>  1 files changed, 4 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif.c
> b/drivers/media/platform/davinci/vpif.c index 761c825..164c1b7 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -37,8 +37,6 @@ MODULE_LICENSE("GPL");
>  #define VPIF_CH2_MAX_MODES	(15)
>  #define VPIF_CH3_MAX_MODES	(02)
> 
> -static resource_size_t	res_len;
> -static struct resource	*res;
>  spinlock_t vpif_lock;
> 
>  void __iomem *vpif_base;
> @@ -421,23 +419,12 @@ EXPORT_SYMBOL(vpif_channel_getfid);
> 
>  static int vpif_probe(struct platform_device *pdev)
>  {
> -	int status = 0;
> +	static struct resource	*res;
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENOENT;
> -
> -	res_len = resource_size(res);
> -
> -	res = request_mem_region(res->start, res_len, res->name);
> -	if (!res)
> -		return -EBUSY;
> -
> -	vpif_base = ioremap(res->start, res_len);
> -	if (!vpif_base) {
> -		status = -EBUSY;
> -		goto fail;
> -	}
> +	vpif_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(vpif_base))
> +		return PTR_ERR(vpif_base);

You're loosing the request_mem_region(). You should use 
devm_request_and_ioremap() function instead of devm_ioremap_resource(). With 
that change,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	pm_runtime_enable(&pdev->dev);
>  	pm_runtime_get(&pdev->dev);
> @@ -445,17 +432,11 @@ static int vpif_probe(struct platform_device *pdev)
>  	spin_lock_init(&vpif_lock);
>  	dev_info(&pdev->dev, "vpif probe success\n");
>  	return 0;
> -
> -fail:
> -	release_mem_region(res->start, res_len);
> -	return status;
>  }
> 
>  static int vpif_remove(struct platform_device *pdev)
>  {
>  	pm_runtime_disable(&pdev->dev);
> -	iounmap(vpif_base);
> -	release_mem_region(res->start, res_len);
>  	return 0;
>  }
-- 
Regards,

Laurent Pinchart

