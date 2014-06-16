Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaFPOfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:35:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51720 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFPOfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:35:10 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <539F0093.7070503@roeck-us.net>
Date: Mon, 16 Jun 2014 07:34:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heiko Schocher <hs@denx.de>, lm-sensors@lm-sensors.org
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] hwmon: Driver for TI TMP103 temperature sensor
References: <1402901276-6114-1-git-send-email-hs@denx.de>
In-Reply-To: <1402901276-6114-1-git-send-email-hs@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 11:47 PM, Heiko Schocher wrote:
> Driver for the TI TMP103.
>
> The TI TMP103 is similar to the TMP102.  It differs from the TMP102
> by having only 8 bit registers.
>
> Signed-off-by: Heiko Schocher <hs@denx.de>
>
Hello Heiko,

Almost there.

> ---
>
> +static int tmp103_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct device *dev = &client->dev;
> +	struct device *hwmon_dev;
> +	struct regmap *regmap;
> +	int ret;
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_SMBUS_BYTE_DATA)) {
> +		dev_err(&client->dev,
> +			"adapter doesn't support SMBus byte transactions\n");
> +		return -ENODEV;
> +	}
> +
> +	regmap = devm_regmap_init_i2c(client, &tmp103_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		dev_err(dev, "failed to allocate register map\n");
> +		return PTR_ERR(regmap);
> +	}
> +
> +	ret = regmap_update_bits(regmap, TMP103_CONF_REG, TMP103_CONFIG,
> +				 TMP103_CONFIG);

You actually want to mask out CR0, CR1, M0, and M1 here.

> +	if (ret < 0) {
> +		dev_err(&client->dev, "error writing config register\n");
> +		return ret;
> +	}
> +
> +	hwmon_dev = hwmon_device_register_with_groups(dev, client->name,
> +						      regmap, tmp103_groups);
> +	return PTR_ERR_OR_ZERO(hwmon_dev);
> +}
> +
> +#ifdef CONFIG_PM
> +static int tmp103_suspend(struct device *dev)
> +{
> +	struct regmap *regmap = dev_get_drvdata(dev);
> +
> +	return regmap_update_bits(regmap, TMP103_CONF_REG, TMP103_CONF_SD, 0);
> +}
> +
> +static int tmp103_resume(struct device *dev)
> +{
> +	struct regmap *regmap = dev_get_drvdata(dev);
> +
> +	return regmap_update_bits(regmap, TMP103_CONF_REG, TMP103_CONF_SD,
> +				  TMP103_CONF_SD);

That changes {M0, M1} to {1, 1}, but you really want {0, 1} to restore the
pre-suspend configuration.

One solution for both would be to define TMP103_CONFIG_MASK and TMP103_CONF_SD_MASK
separately to ensure you catch all the to-be-cleared bits.

Guenter

