Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaBNLn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:43:57 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33501 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBNLn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:43:56 -0500
Date: Fri, 14 Feb 2014 11:43:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: jdelvare@suse.de, linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: MAX6650/6651 support
Message-ID: <20140214114349.GG9462@lee--X1>
References: <1392369342-11472-1-git-send-email-lpapp@kde.org>
 <1392369342-11472-2-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392369342-11472-2-git-send-email-lpapp@kde.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From [PATCH 0/2]:
  What's the resaon for not testing this on h/w yet?

> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
> chip includes fan-speed regulators and monitors, GPIO, and alarm.
> 
> This patch is an initial release of a MAX6650/6651 MFD driver that
> supports to enable the chip with its primary I2C bus that will connect
> the hwmon, and then the gpio devices for now.
> 
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/mfd/Kconfig                 | 11 +++++
>  drivers/mfd/Makefile                |  1 +
>  drivers/mfd/max665x.c               | 94 +++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/max665x-private.h | 34 ++++++++++++++
>  4 files changed, 140 insertions(+)
>  create mode 100644 drivers/mfd/max665x.c
>  create mode 100644 include/linux/mfd/max665x-private.h

<snip>

> +++ b/drivers/mfd/max665x.c
> @@ -0,0 +1,94 @@
> +/*
> + * Device access for MAX6650-MAX6651

Nit: Prefer "for Maxim MAX6650 and MAX6651" + <device type>

<snip>

> +#include <linux/device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>

I thought this driver was bool i.e. Y or N, not tristate?

<snip>

> +static struct mfd_cell max665x_devs[] = {
> +	{ .name = "max6651-gpio", },
> +	{ .name = "max6650", }, /* hwmon driver */

We really need to do something about this.

Guenter,
  once we've converted the hwmon part to a platform device, can we
  then safely rename it with "-hwmon" appended?

> +	{},
> +};
> +
> +static const struct regmap_config max665x_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,

This looks more sane, but it really should be tested.

> +static int max665x_probe(struct i2c_client *i2c,
> +			    const struct i2c_device_id *id)
> +{
> +	struct max665x_dev *max665x;
> +	int ret;
> +
> +	max665x = devm_kzalloc(&i2c->dev, sizeof(*max665x), GFP_KERNEL);
> +	if (!max665x)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, max665x);
> +	max665x->dev = &i2c->dev;
> +	max665x->i2c = i2c;
> +	max665x->map = devm_regmap_init_i2c(i2c, &max665x_regmap_config);
> +	if (IS_ERR(max665x->map)) {
> +		ret = PTR_ERR(max665x->map);
> +		dev_err(max665x->dev, "Failed to allocate register map: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	mutex_init(&max665x->iolock);

*cough*

> +	ret = mfd_add_devices(max665x->dev, -1, max665x_devs,
> +			ARRAY_SIZE(max665x_devs),
> +			NULL, 0, NULL);
> +
> +	if (ret < 0)

Just 'if (ret)'

<snip>

> +static struct of_device_id max665x_dt_match[] = {
> +	{ .compatible = "maxim,max665x" },

  	{ .compatible = "maxim,max6650" },
  	{ .compatible = "maxim,max6651" },

> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, max665x_dt_match);

Module?

> +static struct i2c_driver max665x_driver = {
> +	.driver = {
> +		.name = "max665x",
> +		.owner = THIS_MODULE,
> +		.of_match_table = max665x_dt_match,

of_match_ptr()

> +	},
> +	.probe = max665x_probe,
> +	.remove = max665x_remove,
> +};
> +
> +module_i2c_driver(max665x_driver);

Module?

> +MODULE_AUTHOR("Laszlo Papp <laszlo.papp@polatis.com>");
> +MODULE_DESCRIPTION("MAX6650-MAX6651 MFD");

s/-/ and /

> +MODULE_LICENSE("GPL");

v1 or v2?

<snip>

> +#ifndef __LINUX_MFD_MAX665X_PRIVATE_H
> +#define __LINUX_MFD_MAX665X_PRIVATE_H
> +
> +#include <linux/i2c.h>
> +#include <linux/regmap.h>
> +
> +struct max665x_dev {
> +	struct device *dev;
> +	struct mutex iolock;

*Ah hem*

> +	struct i2c_client *i2c;
> +	struct regmap     *map;
> +	int type;

What's this used for?

> +};

> +#endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
