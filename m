Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaDZEnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 00:43:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58847 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaDZEnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 00:43:49 -0400
Date: Fri, 25 Apr 2014 21:43:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] Input: gpio_keys - convert to use devm_*
Message-ID: <20140426044346.GB27425@core.coreip.homeip.net>
References: <1398442937-15309-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1398442937-15309-3-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398442937-15309-3-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 07:22:16PM +0300, Andy Shevchenko wrote:
> This makes the error handling much more simpler than open-coding everything and
> in addition makes the probe function smaller an tidier.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/input/keyboard/gpio_keys.c | 75 +++++++++++++-------------------------
>  1 file changed, 25 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> index 209d4c6..8791d94 100644
> --- a/drivers/input/keyboard/gpio_keys.c
> +++ b/drivers/input/keyboard/gpio_keys.c
> @@ -47,7 +47,7 @@ struct gpio_keys_drvdata {
>  	const struct gpio_keys_platform_data *pdata;
>  	struct input_dev *input;
>  	struct mutex disable_lock;
> -	struct gpio_button_data data[0];
> +	struct gpio_button_data *data;
>  };
>  
>  /*
> @@ -577,25 +577,22 @@ gpio_keys_get_devtree_pdata(struct device *dev)
>  	int i;
>  
>  	node = dev->of_node;
> -	if (!node) {
> -		error = -ENODEV;
> -		goto err_out;
> -	}
> +	if (!node)
> +		return ERR_PTR(-ENODEV);
>  
>  	nbuttons = of_get_child_count(node);
> -	if (nbuttons == 0) {
> -		error = -ENODEV;
> -		goto err_out;
> -	}
> +	if (nbuttons == 0)
> +		return ERR_PTR(-ENODEV);
>  
> -	pdata = kzalloc(sizeof(*pdata) + nbuttons * (sizeof *button),
> -			GFP_KERNEL);
> -	if (!pdata) {
> -		error = -ENOMEM;
> -		goto err_out;
> -	}
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return ERR_PTR(-ENOMEM);
> +
> +	pdata->buttons = devm_kcalloc(dev, nbuttons, sizeof (*button),
> +				      GFP_KERNEL);
> +	if (!pdata->buttons)
> +		return ERR_PTR(-ENOMEM);

Why are we splitting the allocation in 2?

>  
> -	pdata->buttons = (struct gpio_keys_button *)(pdata + 1);
>  	pdata->nbuttons = nbuttons;
>  
>  	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
> @@ -618,7 +615,7 @@ gpio_keys_get_devtree_pdata(struct device *dev)
>  				dev_err(dev,
>  					"Failed to get gpio flags, error: %d\n",
>  					error);
> -			goto err_free_pdata;
> +			return ERR_PTR(error);
>  		}
>  
>  		button = &pdata->buttons[i++];
> @@ -629,8 +626,7 @@ gpio_keys_get_devtree_pdata(struct device *dev)
>  		if (of_property_read_u32(pp, "linux,code", &button->code)) {
>  			dev_err(dev, "Button without keycode: 0x%x\n",
>  				button->gpio);
> -			error = -EINVAL;
> -			goto err_free_pdata;
> +			return ERR_PTR(-EINVAL);
>  		}
>  
>  		button->desc = of_get_property(pp, "label", NULL);
> @@ -645,17 +641,10 @@ gpio_keys_get_devtree_pdata(struct device *dev)
>  			button->debounce_interval = 5;
>  	}
>  
> -	if (pdata->nbuttons == 0) {
> -		error = -EINVAL;
> -		goto err_free_pdata;
> -	}
> +	if (pdata->nbuttons == 0)
> +		return ERR_PTR(-EINVAL);
>  
>  	return pdata;
> -
> -err_free_pdata:
> -	kfree(pdata);
> -err_out:
> -	return ERR_PTR(error);
>  }
>  
>  static struct of_device_id gpio_keys_of_match[] = {
> @@ -699,16 +688,18 @@ static int gpio_keys_probe(struct platform_device *pdev)
>  			return PTR_ERR(pdata);
>  	}
>  
> -	ddata = kzalloc(sizeof(struct gpio_keys_drvdata) +
> -			pdata->nbuttons * sizeof(struct gpio_button_data),
> -			GFP_KERNEL);
> -	input = input_allocate_device();
> +	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
> +	input = devm_input_allocate_device(dev);
>  	if (!ddata || !input) {
>  		dev_err(dev, "failed to allocate state\n");
> -		error = -ENOMEM;
> -		goto fail1;
> +		return -ENOMEM;
>  	}
>  
> +	ddata->data = devm_kcalloc(dev, pdata->nbuttons,  sizeof(*ddata->data),
> +				   GFP_KERNEL);
> +	if (!ddata->data)
> +		return -ENOMEM;
> +

Same here. I dropped the separate allocations and applied.

Thanks.

-- 
Dmitry
