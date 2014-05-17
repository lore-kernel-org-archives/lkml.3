Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaEQWWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:22:15 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:62942 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaEQWWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:22:14 -0400
Date: Sun, 18 May 2014 00:22:10 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] ARM: imx: fix error handling in ipu device
 registration
Message-ID: <20140517222210.GA20413@lianli>
References: <1400352033-18262-1-git-send-email-emilgoode@gmail.com>
 <20140517191821.GD16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140517191821.GD16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Uwe,

I was to quick to resend the patch, sorry.

On Sat, May 17, 2014 at 09:18:21PM +0200, Uwe Kleine-König wrote:
> Hello Emil,
> 
> On Sat, May 17, 2014 at 08:40:33PM +0200, Emil Goode wrote:
> > If we fail to allocate struct platform_device pdev we
> > dereference it after the goto label err.
> > 
> > I have rearranged the error handling a bit to fix the issue
> > and also make it more clear.
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > ---
> > v3: Made subject line more specific.
> > v2: Changed to return -ENOMEM instead of ret where possible and
> >     updated the subject line.
> > 
> >  arch/arm/mach-imx/devices/platform-ipu-core.c |   22 +++++++++++++---------
> >  1 file changed, 13 insertions(+), 9 deletions(-)
> Considering that you can fix the issue also by just doing:
> 
> diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
> index fc4dd7cedc11..6bd7c3f37ac0 100644
> --- a/arch/arm/mach-imx/devices/platform-ipu-core.c
> +++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
> @@ -77,7 +77,7 @@ struct platform_device *__init imx_alloc_mx3_camera(
>  
>  	pdev = platform_device_alloc("mx3-camera", 0);
>  	if (!pdev)
> -		goto err;
> +		return ERR_PTR(-ENOMEM);
>  
>  	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
>  	if (!pdev->dev.dma_mask)
> 
> or
> 
> diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
> index fc4dd7cedc11..c609f3667200 100644
> --- a/arch/arm/mach-imx/devices/platform-ipu-core.c
> +++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
> @@ -96,7 +96,8 @@ struct platform_device *__init imx_alloc_mx3_camera(
>  		ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
>  		if (ret) {
>  err:
> -			kfree(pdev->dev.dma_mask);
> +			if (pdev)
> +				kfree(pdev->dev.dma_mask);
>  			platform_device_put(pdev);
>  			return ERR_PTR(-ENODEV);
>  		}
> 
> I would prefer one of them as it is easier to justify and for the next
> cycle convert the function to platform_device_register_full.

Agreed, that makes sense considering the second patch that would convert to
platform_device_register_full().

> 
> Also you should point out in the commit log that the issue was found by
> coccinelle.

Ok, will do that.

Thank you!

Best regards,

Emil Goode
