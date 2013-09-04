Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762702Ab3IDN2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:28:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58498 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab3IDN2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:28:23 -0400
Message-ID: <5227355C.1020205@ti.com>
Date: Wed, 4 Sep 2013 08:27:56 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>, <yong.shen@linaro.org>,
        <s.hauer@pengutronix.de>, <marek.vasut@gmail.com>,
        <Nancy.Chen@freescale.com>
Subject: Re: [PATCH 7/7] regulator: ti-abb: Use devm_regulator_register
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org> <1378276263-10735-7-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1378276263-10735-7-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:31 AM, Sachin Kamat wrote:
> devm_* simplifies the code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Seems to do a little more than devm_* alone, there is pruning of error
handling done here as well.

I am not comfortable with loosing print message information that help
debug issues on the field - which we usually have to based on just
kernel logs.

Please reduce the change to just using devm_regulator_register and
removal of .remove function and i am ok with that change.
> ---
>  drivers/regulator/ti-abb-regulator.c |   82 ++++++++++------------------------
>  1 file changed, 23 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
> index 3753ed0..02392f8 100644
> --- a/drivers/regulator/ti-abb-regulator.c
> +++ b/drivers/regulator/ti-abb-regulator.c
> @@ -696,22 +696,17 @@ static int ti_abb_probe(struct platform_device *pdev)
>  	match = of_match_device(ti_abb_of_match, dev);
>  	if (!match) {
>  		/* We do not expect this to happen */
> -		ret = -ENODEV;
>  		dev_err(dev, "%s: Unable to match device\n", __func__);
> -		goto err;
> +		return -ENODEV;
>  	}
>  	if (!match->data) {
> -		ret = -EINVAL;
>  		dev_err(dev, "%s: Bad data in match\n", __func__);
> -		goto err;
> +		return -EINVAL;
>  	}
>  
>  	abb = devm_kzalloc(dev, sizeof(struct ti_abb), GFP_KERNEL);
> -	if (!abb) {
> -		dev_err(dev, "%s: Unable to allocate ABB struct\n", __func__);
> -		ret = -ENOMEM;
> -		goto err;
> -	}
> +	if (!abb)
> +		return -ENOMEM;
here.

>  	abb->regs = match->data;
>  
>  	/* Map ABB resources */
> @@ -719,21 +714,17 @@ static int ti_abb_probe(struct platform_device *pdev)
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
>  	if (!res) {
>  		dev_err(dev, "Missing '%s' IO resource\n", pname);
> -		ret = -ENODEV;
> -		goto err;
> +		return -ENODEV;
>  	}
>  	abb->base = devm_ioremap_resource(dev, res);
> -	if (IS_ERR(abb->base)) {
> -		ret = PTR_ERR(abb->base);
> -		goto err;
> -	}
> +	if (IS_ERR(abb->base))
> +		return PTR_ERR(abb->base);
>  
>  	pname = "int-address";
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
>  	if (!res) {
>  		dev_err(dev, "Missing '%s' IO resource\n", pname);
> -		ret = -ENODEV;
> -		goto err;
> +		return -ENODEV;
>  	}
>  	/*
>  	 * We may have shared interrupt register offsets which are
> @@ -743,8 +734,7 @@ static int ti_abb_probe(struct platform_device *pdev)
>  					     resource_size(res));
>  	if (!abb->int_base) {
>  		dev_err(dev, "Unable to map '%s'\n", pname);
> -		ret = -ENOMEM;
> -		goto err;
> +		return -ENOMEM;
>  	}
>  
>  	/* Map Optional resources */
> @@ -764,8 +754,7 @@ static int ti_abb_probe(struct platform_device *pdev)
>  					       resource_size(res));
>  	if (!abb->efuse_base) {
>  		dev_err(dev, "Unable to map '%s'\n", pname);
> -		ret = -ENOMEM;
> -		goto err;
> +		return -ENOMEM;
>  	}
>  
>  	pname = "ldo-address";
> @@ -776,10 +765,8 @@ static int ti_abb_probe(struct platform_device *pdev)
>  		goto skip_opt;
>  	}
>  	abb->ldo_base = devm_ioremap_resource(dev, res);
> -	if (IS_ERR(abb->ldo_base)) {
> -		ret = PTR_ERR(abb->ldo_base);
> -		goto err;
> -	}
> +	if (IS_ERR(abb->ldo_base))
> +		return PTR_ERR(abb->ldo_base);
>  
>  	/* IF ldo_base is set, the following are mandatory */
>  	pname = "ti,ldovbb-override-mask";
> @@ -788,12 +775,11 @@ static int ti_abb_probe(struct platform_device *pdev)
>  				 &abb->ldovbb_override_mask);
>  	if (ret) {
>  		dev_err(dev, "Missing '%s' (%d)\n", pname, ret);
> -		goto err;
> +		return ret;
>  	}
>  	if (!abb->ldovbb_override_mask) {
>  		dev_err(dev, "Invalid property:'%s' set as 0!\n", pname);
> -		ret = -EINVAL;
> -		goto err;
> +		return -EINVAL;
>  	}
>  
>  	pname = "ti,ldovbb-vset-mask";
> @@ -802,12 +788,11 @@ static int ti_abb_probe(struct platform_device *pdev)
>  				 &abb->ldovbb_vset_mask);
>  	if (ret) {
>  		dev_err(dev, "Missing '%s' (%d)\n", pname, ret);
> -		goto err;
> +		return ret;
>  	}
>  	if (!abb->ldovbb_vset_mask) {
>  		dev_err(dev, "Invalid property:'%s' set as 0!\n", pname);
> -		ret = -EINVAL;
> -		goto err;
> +		return -EINVAL;
>  	}
>  
>  skip_opt:
> @@ -817,31 +802,29 @@ skip_opt:
>  				 &abb->txdone_mask);
>  	if (ret) {
>  		dev_err(dev, "Missing '%s' (%d)\n", pname, ret);
> -		goto err;
> +		return ret;
>  	}
>  	if (!abb->txdone_mask) {
>  		dev_err(dev, "Invalid property:'%s' set as 0!\n", pname);
> -		ret = -EINVAL;
> -		goto err;
> +		return -EINVAL;
>  	}
>  
>  	initdata = of_get_regulator_init_data(dev, pdev->dev.of_node);
>  	if (!initdata) {
> -		ret = -ENOMEM;
>  		dev_err(dev, "%s: Unable to alloc regulator init data\n",
>  			__func__);
> -		goto err;
> +		return -ENOMEM;
>  	}
>  
>  	/* init ABB opp_sel table */
>  	ret = ti_abb_init_table(dev, abb, initdata);
>  	if (ret)
> -		goto err;
> +		return ret;
>  
>  	/* init ABB timing */
>  	ret = ti_abb_init_timings(dev, abb);
>  	if (ret)
> -		goto err;
> +		return ret;
>  
>  	desc = &abb->rdesc;
>  	desc->name = dev_name(dev);
> @@ -859,12 +842,12 @@ skip_opt:
>  	config.driver_data = abb;
>  	config.of_node = pdev->dev.of_node;
>  
> -	rdev = regulator_register(desc, &config);
> +	rdev = devm_regulator_register(dev, desc, &config);

ok with this.

>  	if (IS_ERR(rdev)) {
>  		ret = PTR_ERR(rdev);
>  		dev_err(dev, "%s: failed to register regulator(%d)\n",
>  			__func__, ret);
> -		goto err;
> +		return ret;
>  	}
>  	platform_set_drvdata(pdev, rdev);
>  
> @@ -872,31 +855,12 @@ skip_opt:
>  	ti_abb_rmw(abb->regs->sr2_en_mask, 1, abb->regs->setup_reg, abb->base);
>  
>  	return 0;
> -
> -err:
> -	dev_err(dev, "%s: Failed to initialize(%d)\n", __func__, ret);
> -	return ret;
here -> with this, the lazy non detailed prints end with a generic
fail case.

I can cleanup the error handling if you like.

> -}
> -
> -/**
> - * ti_abb_remove() - cleanups
> - * @pdev: ABB platform device
> - *
> - * Return: 0
> - */
> -static int ti_abb_remove(struct platform_device *pdev)
> -{
> -	struct regulator_dev *rdev = platform_get_drvdata(pdev);
> -
> -	regulator_unregister(rdev);
> -	return 0;
ok with this
>  }
>  
>  MODULE_ALIAS("platform:ti_abb");
>  
>  static struct platform_driver ti_abb_driver = {
>  	.probe = ti_abb_probe,
> -	.remove = ti_abb_remove,
ok with this
>  	.driver = {
>  		   .name = "ti_abb",
>  		   .owner = THIS_MODULE,
> 


-- 
Regards,
Nishanth Menon
