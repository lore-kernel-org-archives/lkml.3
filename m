Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaIAKJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:09:33 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54986 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaIAKJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:09:31 -0400
Date: Mon, 1 Sep 2014 11:09:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, a.zummo@towertech.it,
        mturquette@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        grant.likely@linaro.org, hl@rock-chips.com, huangtao@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, xxx@rock-chips.com,
        dianders@chromium.org, heiko@sntech.de, olof@lixom.net,
        sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v7 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140901100922.GL7374@lee--X1>
References: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
 <1409564384-18380-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409564384-18380-1-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Chris Zhong wrote:

> The RK808 chip is a power management IC for multimedia and handheld
> devices. It contains the following components:
> 
> - Regulators
> - RTC
> - Clkout
> 
> The RK808 core driver is registered as a platform driver and provides
> communication through I2C with the host device for the different
> components.
> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>

Couple of nits.  Once fixed you can apply my:

Acked-by: Lee Jones <lee.jones@linaro.org>

[...]

> +/*
> + * MFD core driver for Rockchip RK808
> + *
> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd

Author?

> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */

[...]

> +static int rk808_probe(struct i2c_client *client,
> +		       const struct i2c_device_id *id)
> +{
> +	int i;
> +	int ret;
> +	int pm_off = 0;
> +	struct rk808 *rk808;
> +	struct device_node *np = client->dev.of_node;

Reverse these declarations please, structs at the top etc.

[...]

> +	rk808->i2c = client;
> +	i2c_set_clientdata(client, rk808);

'\n' here.

> +	ret = mfd_add_devices(&client->dev, -1,
> +			      rk808s, ARRAY_SIZE(rk808s),
> +			      NULL, 0, regmap_irq_get_domain(rk808->irq_data));
> +	if (ret) {
> +		dev_err(&client->dev, "failed to add MFD devices %d\n", ret);
> +		goto err_irq;
> +	}
> +
> +	if (np) {

There has to be an 'np'.  The driver depends on OF.

> +		pm_off = of_property_read_bool(np,
> +					"rockchip,system-power-controller");
> +		if (pm_off && !pm_power_off) {
> +			rk808_i2c_client = client;
> +			pm_power_off = rk808_device_shutdown;
> +		}
> +	}
> +
> +	return 0;
> +
> +err_irq:
> +	regmap_del_irq_chip(client->irq, rk808->irq_data);
> +	return ret;
> +}

[...]

> +static struct i2c_driver rk808_i2c_driver = {
> +	.driver = {
> +		.name = "rk808",
> +		.of_match_table = of_match_ptr(rk808_of_match),

No need to use of_match_ptr() now that you depend on OF.

> +	},
> +	.probe    = rk808_probe,
> +	.remove   = rk808_remove,
> +	.id_table = rk808_ids,
> +};
> +
> +module_i2c_driver(rk808_i2c_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Chris Zhong <zyw@rock-chips.com>");
> +MODULE_AUTHOR("Zhang Qing <zhangqing@rock-chips.com>");
> +MODULE_DESCRIPTION("RK808 PMIC driver");

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
