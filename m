Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3CKHup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:50:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3CKHun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:50:43 -0400
Date: Mon, 11 Mar 2013 08:50:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
cc: linux-media@vger.kernel.org, mchehab@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc_camera: convert to devm_ioremap_resource()
In-Reply-To: <1362987621-6527-1-git-send-email-silviupopescu1990@gmail.com>
Message-ID: <Pine.LNX.4.64.1303110849530.21241@axis700.grange>
References: <1362987621-6527-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ZS70se+63sN/VE6Hm/BobNgcQpw26/t9gSD4iQpVXtT
 1vQBehVMxJmwPiWPFeEHvy17cj30eP7Sf8a89tYcbACNck8TjI
 X22Yk+eCQ2bRHvzGtREEDrgMzUbrvazdlgcMtfSR18LoVHggWv
 zwI1lsR7fAQ0mL071yQG5inLkFZ9zx5DsMVCijheVSk/AGe0CH
 VJdAn+cSEQ/rVZ3yWZ67ZBUnqTM7BRvdt1dMEiUscrZ8+FSX1W
 fhurekociDhnMhZWaxRqT0f8oKuWqGyeN12ESsVgP9YR7CErxN
 KJxpu9N7/S1Un27FZL2ZZ79pyMcViaKIRzYLILvzXnmebcmybb
 Z5+21YEYZ7tEO6d++XJHSaWsyDEZ70LKibON/vUGOJgPpIqQ8+
 HOpPCsC6RPwTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Silviu-Mihai

On Mon, 11 Mar 2013, Silviu-Mihai Popescu wrote:

> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Is there anything in this patch, that this patch series

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/61337

is missing?

Thanks
Guennadi

> ---
>  drivers/media/platform/soc_camera/pxa_camera.c     |    6 +++---
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |    8 +++-----
>  drivers/media/platform/soc_camera/sh_mobile_csi2.c |    8 +++-----
>  3 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index 395e2e0..e94ed6c 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -1710,9 +1710,9 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	/*
>  	 * Request the regions.
>  	 */
> -	base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!base)
> -		return -ENOMEM;
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
>  	pcdev->irq = irq;
>  	pcdev->base = base;
>  
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> index bb08a46..8cdee71 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> @@ -2110,11 +2110,9 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
>  	pcdev->max_width = pcdev->pdata->max_width ? : 2560;
>  	pcdev->max_height = pcdev->pdata->max_height ? : 1920;
>  
> -	base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!base) {
> -		dev_err(&pdev->dev, "Unable to ioremap CEU registers.\n");
> -		return -ENXIO;
> -	}
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
>  
>  	pcdev->irq = irq;
>  	pcdev->base = base;
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> index 42c559e..3ec7735 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> @@ -324,11 +324,9 @@ static int sh_csi2_probe(struct platform_device *pdev)
>  
>  	priv->irq = irq;
>  
> -	priv->base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!priv->base) {
> -		dev_err(&pdev->dev, "Unable to ioremap CSI2 registers.\n");
> -		return -ENXIO;
> -	}
> +	priv->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
>  
>  	priv->pdev = pdev;
>  	platform_set_drvdata(pdev, priv);
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
