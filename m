Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858AbaE2H0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:26:00 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47761 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbaE2HZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:25:57 -0400
Date: Thu, 29 May 2014 00:25:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] Input: max8925_onkey :Allocate resources using managed
 interfaces
Message-ID: <20140529072554.GI11817@core.coreip.homeip.net>
References: <20140528201014.GA10607@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528201014.GA10607@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:40:14AM +0530, Himangi Saraogi wrote:
> This patch moves most data allocated in the probe function from
> unmanaged interfaces to managed interfaces. The kfrees and error
> handling code is done away with. The unnecesary labels are removed
> and the function max8925_onkey_remove is removed as it becomes empty
> after removing the no longer required function calls. Also,
> linux/device.h is added to make sure the devm_*() routine declarations
> are unambiguously available.
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
> To send to: Dmitry Torokhov <dmitry.torokhov@gmail.com>,linux-input@vger.kernel.org,linux-kernel@vger.kernel.org
>  drivers/input/misc/max8925_onkey.c | 52 +++++++++++---------------------------
>  1 file changed, 15 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/input/misc/max8925_onkey.c b/drivers/input/misc/max8925_onkey.c
> index eef41cf..62899e5 100644
> --- a/drivers/input/misc/max8925_onkey.c
> +++ b/drivers/input/misc/max8925_onkey.c
> @@ -26,6 +26,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/mfd/max8925.h>
>  #include <linux/slab.h>
> +#include <linux/device.h>
>  
>  #define SW_INPUT		(1 << 7)	/* 0/1 -- up/down */
>  #define HARDRESET_EN		(1 << 7)
> @@ -81,12 +82,11 @@ static int max8925_onkey_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	info = kzalloc(sizeof(struct max8925_onkey_info), GFP_KERNEL);
> -	input = input_allocate_device();
> -	if (!info || !input) {
> -		error = -ENOMEM;
> -		goto err_free_mem;
> -	}
> +	info = devm_kzalloc(&pdev->dev, sizeof(struct max8925_onkey_info),
> +			    GFP_KERNEL);
> +	input = devm_input_allocate_device(&pdev->dev);
> +	if (!info || !input)
> +		return -ENOMEM;
>  
>  	info->idev = input;
>  	info->i2c = chip->i2c;
> @@ -100,55 +100,34 @@ static int max8925_onkey_probe(struct platform_device *pdev)
>  	input->dev.parent = &pdev->dev;
>  	input_set_capability(input, EV_KEY, KEY_POWER);
>  
> -	error = request_threaded_irq(irq[0], NULL, max8925_onkey_handler,
> -				     IRQF_ONESHOT, "onkey-down", info);
> +	error = devm_request_threaded_irq(&pdev->dev, irq[0], NULL,
> +					  max8925_onkey_handler, IRQF_ONESHOT,
> +					  "onkey-down", info);
>  	if (error < 0) {
>  		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
>  			irq[0], error);
> -		goto err_free_mem;
> +		return error;
>  	}
>  
> -	error = request_threaded_irq(irq[1], NULL, max8925_onkey_handler,
> -				     IRQF_ONESHOT, "onkey-up", info);
> +	error = devm_request_threaded_irq(&pdev->dev, irq[1], NULL,
> +					  max8925_onkey_handler, IRQF_ONESHOT,
> +					  "onkey-up", info);
>  	if (error < 0) {
>  		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
>  			irq[1], error);
> -		goto err_free_irq0;
> +		return error;
>  	}
>  
>  	error = input_register_device(info->idev);
>  	if (error) {
>  		dev_err(chip->dev, "Can't register input device: %d\n", error);
> -		goto err_free_irq1;
> +		return error;
>  	}
>  
>  	platform_set_drvdata(pdev, info);
>  	device_init_wakeup(&pdev->dev, 1);
>  
>  	return 0;
> -
> -err_free_irq1:
> -	free_irq(irq[1], info);
> -err_free_irq0:
> -	free_irq(irq[0], info);
> -err_free_mem:
> -	input_free_device(input);
> -	kfree(info);
> -
> -	return error;
> -}
> -
> -static int max8925_onkey_remove(struct platform_device *pdev)
> -{
> -	struct max8925_onkey_info *info = platform_get_drvdata(pdev);
> -	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
> -
> -	free_irq(info->irq[0] + chip->irq_base, info);
> -	free_irq(info->irq[1] + chip->irq_base, info);
> -	input_unregister_device(info->idev);
> -	kfree(info);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -190,7 +169,6 @@ static struct platform_driver max8925_onkey_driver = {
>  		.pm	= &max8925_onkey_pm_ops,
>  	},
>  	.probe		= max8925_onkey_probe,
> -	.remove		= max8925_onkey_remove,
>  };
>  module_platform_driver(max8925_onkey_driver);
>  
> -- 
> 1.9.1
> 

-- 
Dmitry
