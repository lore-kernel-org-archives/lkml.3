Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbaICT6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:58:46 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34978 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbaICT6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:58:44 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, mturquette@linaro.org, akpm@linux-foundation.org,
        dianders@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v8 5/5] regulator: RK808: Remove pdata from the regulator
Date: Wed, 03 Sep 2014 22:00:13 +0200
Message-ID: <2162052.iucaQxK73z@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1409763974-29854-1-git-send-email-zyw@rock-chips.com>
References: <1409752307-29044-1-git-send-email-zyw@rock-chips.com> <1409763974-29854-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. September 2014, 01:06:14 schrieb Chris Zhong:
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> 
> Tested-by: Heiko <heiko@sntech.de>
> ---
> 
> Changes in v8:
> Adviced by Doug
> - remove rk808_regulator_dts() function
> - remove the check about "client->dev.of_node"
> 
> Changes in v7:
> - remove pdata struct from header file, add rk808_regulator struct
> 
> Changes in v6:
> - remove the redundant code
> 
> Changes in v5:
> - re-edit base on Mark's branch
> 
> Changes in v4:
> - use &client->dev replace rk808->dev
> 
> Changes in v3: None
> Changes in v2:
> Adviced by Mark Browm:
> - change of_find_node_by_name to find_child_by_name
> - use RK808_NUM_REGULATORS as the name of the constant
> - create a pdata when missing platform data
> - use the rk808_reg name to supply_regulator name
> - replace regulator_register with devm_regulator_register
> - some other problem with coding style
> 
>  drivers/regulator/rk808-regulator.c |   89
> +++++++---------------------------- 1 file changed, 17 insertions(+), 72
> deletions(-)
> 
> diff --git a/drivers/regulator/rk808-regulator.c
> b/drivers/regulator/rk808-regulator.c index e372008..1f6d108 100644
> --- a/drivers/regulator/rk808-regulator.c
> +++ b/drivers/regulator/rk808-regulator.c
> @@ -3,8 +3,8 @@
>   *
>   * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
>   *
> - * Author: Chris Zhong <zyw@rock-chips.com>
> - * Author: Zhang Qing <zhangqing@rock-chips.com>
> + * Author: Chris Zhong<zyw@rock-chips.com>
> + * Author: Zhang Qing<zhanqging@rock-chips.com>
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms and conditions of the GNU General Public License,
> @@ -14,24 +14,16 @@
>   * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>   * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> for * more details.
> - *
>   */
> 
>  #include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/i2c.h>
> -#include <linux/err.h>
> -#include <linux/platform_device.h>
>  #include <linux/mfd/rk808.h>
> -#include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/regulator/driver.h>
>  #include <linux/regulator/of_regulator.h>
> -#include <linux/regmap.h>
> -#include <linux/slab.h>
> -/*
> - * Field Definitions.
> - */
> +
> +/* Field Definitions */
>  #define RK808_BUCK_VSEL_MASK	0x3f
>  #define RK808_BUCK4_VSEL_MASK	0xf
>  #define RK808_LDO_VSEL_MASK	0x1f
> @@ -50,10 +42,6 @@ static const int buck_contr_base_addr[] = {
>  	RK808_BUCK4_CONFIG_REG,
>  };
> 
> -#define rk808_BUCK_SET_VOL_REG(x) (buck_set_vol_base_addr[x])
> -#define rk808_BUCK_CONTR_REG(x) (buck_contr_base_addr[x])
> -#define rk808_LDO_SET_VOL_REG(x) (ldo_set_vol_base_addr[x])
> -
>  static const int ldo_set_vol_base_addr[] = {
>  	RK808_LDO1_ON_VSEL_REG,
>  	RK808_LDO2_ON_VSEL_REG,
> @@ -65,9 +53,7 @@ static const int ldo_set_vol_base_addr[] = {
>  	RK808_LDO8_ON_VSEL_REG,
>  };
> 
> -/*
> - * rk808 voltage number
> - */
> +/* rk808 voltage number */
>  static const struct regulator_linear_range rk808_buck_voltage_ranges[] = {
>  	REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
>  };
> @@ -308,77 +294,35 @@ static struct of_regulator_match rk808_reg_matches[] =
> { [RK808_ID_SWITCH2]	= { .name = "SWITCH_REG2" },
>  };
> 
> -static int rk808_regulator_dts(struct i2c_client *client,
> -			       struct rk808_board *pdata)
> -{
> -	struct device_node *np, *reg_np;
> -	int i, ret;
> -
> -	np = client->dev.of_node;
> -	if (!np) {
> -		dev_err(&client->dev, "could not find pmic sub-node\n");
> -		return -ENXIO;
> -	}
> -
> -	reg_np = of_get_child_by_name(np, "regulators");
> -	if (!reg_np)
> -		return -ENXIO;
> -
> -	ret = of_regulator_match(&client->dev, reg_np, rk808_reg_matches,
> -				 RK808_NUM_REGULATORS);
> -	if (ret < 0) {
> -		dev_err(&client->dev,
> -			"failed to parse regulator data: %d\n", ret);
> -		return ret;
> -	}
> -
> -	for (i = 0; i < RK808_NUM_REGULATORS; i++) {
> -		if (!rk808_reg_matches[i].init_data ||
> -		    !rk808_reg_matches[i].of_node)
> -			continue;
> -
> -		pdata->rk808_init_data[i] = rk808_reg_matches[i].init_data;
> -		pdata->of_node[i] = rk808_reg_matches[i].of_node;
> -	}
> -
> -	return 0;
> -}
> -
>  static int rk808_regulator_probe(struct platform_device *pdev)
>  {
>  	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
>  	struct i2c_client *client = rk808->i2c;
> -	struct rk808_board *pdata = dev_get_platdata(&client->dev);
>  	struct regulator_config config = {};
>  	struct regulator_dev *rk808_rdev;
> -	struct regulator_init_data *reg_data;
> -	int i = 0;
>  	int ret = 0;
> +	int i = 0;
> 
> -	if (!pdata) {
> -		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> -		if (!pdata)
> -			return -ENOMEM;
> -	}
> +	reg_np = of_get_child_by_name(np, "regulators");

It looks like an error happened while moving that block of code, because with 
this applied both "reg_np" and "np" are not defined - thus producing compile 
errors.


Heiko


> +	if (!reg_np)
> +		return -ENXIO;
> 
> -	ret = rk808_regulator_dts(client, pdata);
> -	if (ret)
> +	ret = of_regulator_match(&client->dev, reg_np, rk808_reg_matches,
> +				 RK808_NUM_REGULATORS);
> +	if (ret < 0)
>  		return ret;
> 
>  	/* Instantiate the regulators */
>  	for (i = 0; i < RK808_NUM_REGULATORS; i++) {
> -		reg_data = pdata->rk808_init_data[i];
> -		if (!reg_data)
> +		if (!rk808_reg_matches[i].init_data ||
> +		    !rk808_reg_matches[i].of_node)
>  			continue;
> 
>  		config.dev = &client->dev;
>  		config.driver_data = rk808;
>  		config.regmap = rk808->regmap;
> -
> -		if (client->dev.of_node)
> -			config.of_node = pdata->of_node[i];
> -
> -		config.init_data = reg_data;
> +		config.of_node = rk808_reg_matches[i].of_node;
> +		config.init_data = rk808_reg_matches[i].init_data;
> 
>  		rk808_rdev = devm_regulator_register(&pdev->dev,
>  						     &rk808_reg[i], &config);
> @@ -388,6 +332,7 @@ static int rk808_regulator_probe(struct platform_device
> *pdev) return PTR_ERR(rk808_rdev);
>  		}
>  	}
> +
>  	return 0;
>  }

