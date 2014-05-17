Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaEQWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:09:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40407 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaEQWJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:09:28 -0400
Date: Sun, 18 May 2014 01:08:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Emil Goode <emilgoode@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] ARM: imx: fix error handling in ipu device
 registration
Message-ID: <20140517220836.GI15585@mwanda>
References: <1400352033-18262-1-git-send-email-emilgoode@gmail.com>
 <20140517191821.GD16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140517191821.GD16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 09:18:21PM +0200, Uwe Kleine-König wrote:
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

Emil, do this one, please and not the second suggestion.

Direct returns are more readable.  Otherwise, you wonder what the goto
is for and where it will take you and be annoyed to discover it is a
waste of time, no-op goto.  Also you will wonder if platform_device_put()
accepts NULL pointers.  Thirdly there is a small ugliness that the error
code is not preserved.  What is the point of setting the error code to
-ENOMEM only to discard it?

Let's look at that error handling again.

err:  <-- the name is not descriptive.  the location is bad.
		kfree(pdev->dev.dma_mask);  <- null dereference.
		platform_device_put(pdev);  <- ok
		return ERR_PTR(-ENODEV);    <- should be "return ERR_PTR(ret);"

3 out of 4 of the lines are bad.

regards,
dan carpenter

