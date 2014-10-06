Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaJFUri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:47:38 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:60515 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJFUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:47:37 -0400
Date: Mon, 6 Oct 2014 21:47:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] mfd: max77693: Initialize haptic register map
Message-ID: <20141006204731.GA18035@lee--X1>
References: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
 <1410972026-25189-2-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410972026-25189-2-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Jaewon Kim wrote:

> This patch add regmap_haptic initialization to use haptic register map
> in haptic device driver.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/max77693.c |   21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)

Applied for v3.19.

> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 249c139..fbfed56 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -144,6 +144,12 @@ static const struct regmap_irq_chip max77693_muic_irq_chip = {
>  	.num_irqs		= ARRAY_SIZE(max77693_muic_irqs),
>  };
>  
> +static const struct regmap_config max77693_regmap_haptic_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX77693_HAPTIC_REG_END,
> +};
> +
>  static int max77693_i2c_probe(struct i2c_client *i2c,
>  			      const struct i2c_device_id *id)
>  {
> @@ -193,6 +199,15 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  	}
>  	i2c_set_clientdata(max77693->haptic, max77693);
>  
> +	max77693->regmap_haptic = devm_regmap_init_i2c(max77693->haptic,
> +					&max77693_regmap_haptic_config);
> +	if (IS_ERR(max77693->regmap_haptic)) {
> +		ret = PTR_ERR(max77693->regmap_haptic);
> +		dev_err(max77693->dev,
> +			"failed to initialize haptic register map: %d\n", ret);
> +		goto err_regmap;
> +	}
> +
>  	/*
>  	 * Initialize register map for MUIC device because use regmap-muic
>  	 * instance of MUIC device when irq of max77693 is initialized
> @@ -204,7 +219,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  		ret = PTR_ERR(max77693->regmap_muic);
>  		dev_err(max77693->dev,
>  			"failed to allocate register map: %d\n", ret);
> -		goto err_regmap_muic;
> +		goto err_regmap;
>  	}
>  
>  	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
> @@ -214,7 +229,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  				&max77693->irq_data_led);
>  	if (ret) {
>  		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
> -		goto err_regmap_muic;
> +		goto err_regmap;
>  	}
>  
>  	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
> @@ -265,7 +280,7 @@ err_irq_charger:
>  	regmap_del_irq_chip(max77693->irq, max77693->irq_data_topsys);
>  err_irq_topsys:
>  	regmap_del_irq_chip(max77693->irq, max77693->irq_data_led);
> -err_regmap_muic:
> +err_regmap:
>  	i2c_unregister_device(max77693->haptic);
>  err_i2c_haptic:
>  	i2c_unregister_device(max77693->muic);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
