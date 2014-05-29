Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbaE2HZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:25:44 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34139 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbaE2HZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:25:41 -0400
Date: Thu, 29 May 2014 00:25:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] Input: 88pm860x_onkey : Introduce the use of the managed
 version of  kzalloc
Message-ID: <20140529072538.GG11817@core.coreip.homeip.net>
References: <20140528200123.GA9946@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528200123.GA9946@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:31:23AM +0530, Himangi Saraogi wrote:
> This patch moves most data allocated in the probe function from
> unmanaged interfaces to managed interfaces. The kfrees and error
> handling code is done away with. Also, the unnecesary labels are
> removed and the function pm860x_onkey_remove is removed as it becomes
> empty after removing the no longer required function calls. Also,
> linux/device.h include is added to make sure the devm_*() routine
> declarations are unambiguously available.
> 
> The following Coccinelle semantic patch was used for making a part of
> the change:
> 
> @platform@
> identifier p, probefn, removefn;
> @@
> struct platform_driver p = {
>   .probe = probefn,
>   .remove = removefn,
> };
> 
> @prb@
> identifier platform.probefn, pdev;
> expression e, e1, e2;
> @@
> probefn(struct platform_device *pdev, ...) {
>   <+...
> - e = kzalloc(e1, e2)
> + e = devm_kzalloc(&pdev->dev, e1, e2)
>   ...
> ?-kfree(e);
>   ...+>
> }
> 
> @rem depends on prb@
> identifier platform.removefn;
> expression e;
> @@
> removefn(...) {
>   <...
> - kfree(e);
>   ...>
> }
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied, thank you.

> ---
>  drivers/input/misc/88pm860x_onkey.c | 40 ++++++++++---------------------------
>  1 file changed, 10 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/input/misc/88pm860x_onkey.c b/drivers/input/misc/88pm860x_onkey.c
> index abd8453..220ce0f 100644
> --- a/drivers/input/misc/88pm860x_onkey.c
> +++ b/drivers/input/misc/88pm860x_onkey.c
> @@ -26,6 +26,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/mfd/88pm860x.h>
>  #include <linux/slab.h>
> +#include <linux/device.h>
>  
>  #define PM8607_WAKEUP		0x0b
>  
> @@ -68,7 +69,8 @@ static int pm860x_onkey_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	info = kzalloc(sizeof(struct pm860x_onkey_info), GFP_KERNEL);
> +	info = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_onkey_info),
> +			    GFP_KERNEL);
>  	if (!info)
>  		return -ENOMEM;
>  	info->chip = chip;
> @@ -76,11 +78,10 @@ static int pm860x_onkey_probe(struct platform_device *pdev)
>  	info->dev = &pdev->dev;
>  	info->irq = irq;
>  
> -	info->idev = input_allocate_device();
> +	info->idev = devm_input_allocate_device(&pdev->dev);
>  	if (!info->idev) {
>  		dev_err(chip->dev, "Failed to allocate input dev\n");
> -		ret = -ENOMEM;
> -		goto out;
> +		return -ENOMEM;
>  	}
>  
>  	info->idev->name = "88pm860x_on";
> @@ -93,42 +94,22 @@ static int pm860x_onkey_probe(struct platform_device *pdev)
>  	ret = input_register_device(info->idev);
>  	if (ret) {
>  		dev_err(chip->dev, "Can't register input device: %d\n", ret);
> -		goto out_reg;
> +		return ret;
>  	}
>  
> -	ret = request_threaded_irq(info->irq, NULL, pm860x_onkey_handler,
> -				   IRQF_ONESHOT, "onkey", info);
> +	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
> +					pm860x_onkey_handler, IRQF_ONESHOT,
> +					"onkey", info);
>  	if (ret < 0) {
>  		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
>  			info->irq, ret);
> -		goto out_irq;
> +		return ret;
>  	}
>  
>  	platform_set_drvdata(pdev, info);
>  	device_init_wakeup(&pdev->dev, 1);
>  
>  	return 0;
> -
> -out_irq:
> -	input_unregister_device(info->idev);
> -	kfree(info);
> -	return ret;
> -
> -out_reg:
> -	input_free_device(info->idev);
> -out:
> -	kfree(info);
> -	return ret;
> -}
> -
> -static int pm860x_onkey_remove(struct platform_device *pdev)
> -{
> -	struct pm860x_onkey_info *info = platform_get_drvdata(pdev);
> -
> -	free_irq(info->irq, info);
> -	input_unregister_device(info->idev);
> -	kfree(info);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -161,7 +142,6 @@ static struct platform_driver pm860x_onkey_driver = {
>  		.pm	= &pm860x_onkey_pm_ops,
>  	},
>  	.probe		= pm860x_onkey_probe,
> -	.remove		= pm860x_onkey_remove,
>  };
>  module_platform_driver(pm860x_onkey_driver);
>  
> -- 
> 1.9.1
> 

-- 
Dmitry
