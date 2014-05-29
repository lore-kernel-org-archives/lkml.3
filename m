Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbaE2H0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:26:08 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39213 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaE2H0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:26:05 -0400
Date: Thu, 29 May 2014 00:26:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] input: ab8500-ponkey: Allocate resources using managed
 interfaces
Message-ID: <20140529072602.GJ11817@core.coreip.homeip.net>
References: <20140528201200.GA10661@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528201200.GA10661@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:42:00AM +0530, Himangi Saraogi wrote:
> This patch moves most data allocated in the probe function from
> unmanaged interfaces to managed interfaces. The kfrees and error
> handling code is done away with. Also, the unnecesary labels are
> removed and the function ab8500_ponkey_remove is removed as it becomes
> empty after removing the no longer required function calls. Also,
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
> 
>  drivers/input/misc/ab8500-ponkey.c | 51 +++++++++++---------------------------
>  1 file changed, 15 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
> index f2fbdd8..89fb1c6 100644
> --- a/drivers/input/misc/ab8500-ponkey.c
> +++ b/drivers/input/misc/ab8500-ponkey.c
> @@ -7,6 +7,7 @@
>   * AB8500 Power-On Key handler
>   */
>  
> +#include <linux/device.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> @@ -65,12 +66,11 @@ static int ab8500_ponkey_probe(struct platform_device *pdev)
>  		return irq_dbr;
>  	}
>  
> -	ponkey = kzalloc(sizeof(struct ab8500_ponkey), GFP_KERNEL);
> -	input = input_allocate_device();
> -	if (!ponkey || !input) {
> -		error = -ENOMEM;
> -		goto err_free_mem;
> -	}
> +	ponkey = devm_kzalloc(&pdev->dev, sizeof(struct ab8500_ponkey),
> +			      GFP_KERNEL);
> +	input = devm_input_allocate_device(&pdev->dev);
> +	if (!ponkey || !input)
> +		return -ENOMEM;
>  
>  	ponkey->idev = input;
>  	ponkey->ab8500 = ab8500;
> @@ -82,52 +82,32 @@ static int ab8500_ponkey_probe(struct platform_device *pdev)
>  
>  	input_set_capability(input, EV_KEY, KEY_POWER);
>  
> -	error = request_any_context_irq(ponkey->irq_dbf, ab8500_ponkey_handler,
> -					0, "ab8500-ponkey-dbf", ponkey);
> +	error = devm_request_any_context_irq(&pdev->dev, ponkey->irq_dbf,
> +					     ab8500_ponkey_handler, 0,
> +					     "ab8500-ponkey-dbf", ponkey);
>  	if (error < 0) {
>  		dev_err(ab8500->dev, "Failed to request dbf IRQ#%d: %d\n",
>  			ponkey->irq_dbf, error);
> -		goto err_free_mem;
> +		return error;
>  	}
>  
> -	error = request_any_context_irq(ponkey->irq_dbr, ab8500_ponkey_handler,
> -					0, "ab8500-ponkey-dbr", ponkey);
> +	error = devm_request_any_context_irq(&pdev->dev, ponkey->irq_dbr,
> +					     ab8500_ponkey_handler, 0,
> +					     "ab8500-ponkey-dbr", ponkey);
>  	if (error < 0) {
>  		dev_err(ab8500->dev, "Failed to request dbr IRQ#%d: %d\n",
>  			ponkey->irq_dbr, error);
> -		goto err_free_dbf_irq;
> +		return error;
>  	}
>  
>  	error = input_register_device(ponkey->idev);
>  	if (error) {
>  		dev_err(ab8500->dev, "Can't register input device: %d\n", error);
> -		goto err_free_dbr_irq;
> +		return error;
>  	}
>  
>  	platform_set_drvdata(pdev, ponkey);
>  	return 0;
> -
> -err_free_dbr_irq:
> -	free_irq(ponkey->irq_dbr, ponkey);
> -err_free_dbf_irq:
> -	free_irq(ponkey->irq_dbf, ponkey);
> -err_free_mem:
> -	input_free_device(input);
> -	kfree(ponkey);
> -
> -	return error;
> -}
> -
> -static int ab8500_ponkey_remove(struct platform_device *pdev)
> -{
> -	struct ab8500_ponkey *ponkey = platform_get_drvdata(pdev);
> -
> -	free_irq(ponkey->irq_dbf, ponkey);
> -	free_irq(ponkey->irq_dbr, ponkey);
> -	input_unregister_device(ponkey->idev);
> -	kfree(ponkey);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_OF
> @@ -144,7 +124,6 @@ static struct platform_driver ab8500_ponkey_driver = {
>  		.of_match_table = of_match_ptr(ab8500_ponkey_match),
>  	},
>  	.probe		= ab8500_ponkey_probe,
> -	.remove		= ab8500_ponkey_remove,
>  };
>  module_platform_driver(ab8500_ponkey_driver);
>  
> -- 
> 1.9.1
> 

-- 
Dmitry
