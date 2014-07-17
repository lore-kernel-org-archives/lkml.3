Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaGQT0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:26:51 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43470 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaGQT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:26:49 -0400
Date: Thu, 17 Jul 2014 21:24:59 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: caesar <caesar.wang@rock-chips.com>
Cc: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cf@rock-chips.com,
        addy.ke@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        hj@rock-chips.com
Subject: Re: [PATCH 2/2] pwm: add this series patch to support for rk-pwm and
 vop-pwm.
Message-ID: <20140717192459.GA4617@gmail.com>
References: <1405577294-19336-1-git-send-email-caesar.wang@rock-chips.com>
 <1405577294-19336-3-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405577294-19336-3-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 02:08:14PM +0800, caesar wrote:
> Signed-off-by: caesar <caesar.wang@rock-chips.com>

Hi Caesar,

just a couple of comments below.

> ---
>  drivers/pwm/pwm-rockchip.c | 108 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 88 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
> index eec2145..59b0380 100644
> --- a/drivers/pwm/pwm-rockchip.c
> +++ b/drivers/pwm/pwm-rockchip.c
> @@ -2,6 +2,7 @@
>   * PWM driver for Rockchip SoCs
>   *
>   * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
> + * Copyright (C) 2014 Caesar Wang <caesar.wang@rock-chips.com>
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -12,6 +13,8 @@
>  #include <linux/io.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_address.h>

These two should be swapped to keep the alphabetical order of the
includes.

>  #include <linux/platform_device.h>
>  #include <linux/pwm.h>
>  #include <linux/time.h>
> @@ -23,14 +26,37 @@
>  #define PWM_CTRL_TIMER_EN	(1 << 0)
>  #define PWM_CTRL_OUTPUT_EN	(1 << 3)
> +

[...]

>  static int rockchip_pwm_probe(struct platform_device *pdev)
>  {
> +	const struct of_device_id *of_id =
> +	    of_match_device(rockchip_pwm_dt_ids, &pdev->dev);
> +	struct device_node *np = pdev->dev.of_node;
>  	struct rockchip_pwm_chip *pc;
>  	struct resource *r;
>  	int ret;
> @@ -119,9 +185,12 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	pc->base = devm_ioremap_resource(&pdev->dev, r);
> -	if (IS_ERR(pc->base))
> -		return PTR_ERR(pc->base);
> +	pc->base = of_iomap(np, 0);
> +	if (!pc->base) {
> +		dev_err(&pdev->dev, "failed to map controller\n");
> +		ret = -ENOMEM;
> +		goto fail_map;
> +	}

I think that this change is not needed. devm_ioremap_resource()
guarantees an automatic unmapping when the device is destroyed.

Moreover, when of_iomap() fails you don't need to call iounmap().

Beniamino

>  
>  	pc->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(pc->clk))
> @@ -133,6 +202,7 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, pc);
>  
> +	pc->data = of_id->data;
>  	pc->chip.dev = &pdev->dev;
>  	pc->chip.ops = &rockchip_pwm_ops;
>  	pc->chip.base = -1;
> @@ -145,6 +215,10 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
>  	}
>  
>  	return ret;
> +
> +fail_map:
> +	iounmap(pc->base);
> +	return ret;
>  }
>  
>  static int rockchip_pwm_remove(struct platform_device *pdev)
> @@ -156,12 +230,6 @@ static int rockchip_pwm_remove(struct platform_device *pdev)
>  	return pwmchip_remove(&pc->chip);
>  }
>  
> -static const struct of_device_id rockchip_pwm_dt_ids[] = {
> -	{ .compatible = "rockchip,rk2928-pwm" },
> -	{ /* sentinel */ }
> -};
> -MODULE_DEVICE_TABLE(of, rockchip_pwm_dt_ids);
> -
>  static struct platform_driver rockchip_pwm_driver = {
>  	.driver = {
>  		.name = "rockchip-pwm",
> -- 
> 1.9.1
> 
