Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaAZVhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:37:00 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62169 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAZVg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:36:58 -0500
Date: Sun, 26 Jan 2014 13:36:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH] regulator: fixed: Use devm_regulator_register
Message-ID: <20140126213653.GB18840@core.coreip.homeip.net>
References: <1390673154-15839-1-git-send-email-badarkhe.manish@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390673154-15839-1-git-send-email-badarkhe.manish@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manish,

On Sat, Jan 25, 2014 at 11:35:54PM +0530, Manish Badarkhe wrote:
> Use "devm_regulator_register" instead of "regulator_register"
> which simplifies the code.

... and also breaks the driver: now you are freeing desc->name and
desc->supply_name while regulator structures are still alive and can be
referenced from its sysfs attributes, etc.

> 
> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> ---
> :100644 100644 5ea64b9... 6d32341... M	drivers/regulator/fixed.c
>  drivers/regulator/fixed.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index 5ea64b9..6d32341 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -186,7 +186,8 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
>  	cfg.driver_data = drvdata;
>  	cfg.of_node = pdev->dev.of_node;
>  
> -	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
> +	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
> +					       &cfg);
>  	if (IS_ERR(drvdata->dev)) {
>  		ret = PTR_ERR(drvdata->dev);
>  		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
> @@ -212,7 +213,6 @@ static int reg_fixed_voltage_remove(struct platform_device *pdev)
>  {
>  	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
>  
> -	regulator_unregister(drvdata->dev);
>  	kfree(drvdata->desc.supply_name);
>  	kfree(drvdata->desc.name);
>  

Thanks.

-- 
Dmitry
