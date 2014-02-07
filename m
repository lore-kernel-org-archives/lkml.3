Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaBGK5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:57:07 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62307 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaBGK5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:57:05 -0500
Date: Fri, 7 Feb 2014 10:56:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/8] ASoC: da9055: Fix device registration of PMIC and
 CODEC devices
Message-ID: <20140207105657.GL14727@lee--X1>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently the I2C device Ids conflict for the MFD and CODEC so
> cannot be both instantiated on one platform. This patch updates
> the Ids and names to make them unique from each other.
> 
> It should be noted that the I2C addresses for both PMIC and CODEC
> are modifiable so instantiation of the two are kept as separate
> devices, rather than instantiating the CODEC from the MFD code.
> 
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> Acked-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/da9055-i2c.c  |   12 ++++++++++--
>  sound/soc/codecs/da9055.c |   11 +++++++++--
>  2 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/da9055-i2c.c b/drivers/mfd/da9055-i2c.c
> index 13af7e5..8103e43 100644
> --- a/drivers/mfd/da9055-i2c.c
> +++ b/drivers/mfd/da9055-i2c.c
> @@ -53,17 +53,25 @@ static int da9055_i2c_remove(struct i2c_client *i2c)
>  	return 0;
>  }
> 
> +/*
> + * DO NOT change the device Ids. The naming is intentionally specific as both
> + * the PMIC and CODEC parts of this chip are instantiated separately as I2C
> + * devices (both have configurable I2C addresses, and are to all intents and
> + * purposes separate). As a result there are specific DA9055 ids for PMIC
> + * and CODEC, which must be different to operate together.
> + */

I'm not sure this comment is required.

Most device IDs are named this way.

>  static struct i2c_device_id da9055_i2c_id[] = {
> -	{"da9055", 0},
> +	{"da9055-pmic", 0},
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(i2c, da9055_i2c_id);
> 
>  static struct i2c_driver da9055_i2c_driver = {
>  	.probe = da9055_i2c_probe,
>  	.remove = da9055_i2c_remove,
>  	.id_table = da9055_i2c_id,
>  	.driver = {
> -		.name = "da9055",
> +		.name = "da9055-pmic",
>  		.owner = THIS_MODULE,
>  	},
>  };
> diff --git a/sound/soc/codecs/da9055.c b/sound/soc/codecs/da9055.c
> index 52b79a4..4228126 100644
> --- a/sound/soc/codecs/da9055.c
> +++ b/sound/soc/codecs/da9055.c
> @@ -1523,8 +1523,15 @@ static int da9055_remove(struct i2c_client *client)
>  	return 0;
>  }
> 
> +/*
> + * DO NOT change the device Ids. The naming is intentionally specific as both
> + * the CODEC and PMIC parts of this chip are instantiated separately as I2C
> + * devices (both have configurable I2C addresses, and are to all intents and
> + * purposes separate). As a result there are specific DA9055 Ids for CODEC
> + * and PMIC, which must be different to operate together.
> + */

And here, really, no need.

>  static const struct i2c_device_id da9055_i2c_id[] = {
> -	{ "da9055", 0 },
> +	{ "da9055-codec", 0 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, da9055_i2c_id);
> @@ -1532,7 +1539,7 @@ MODULE_DEVICE_TABLE(i2c, da9055_i2c_id);
>  /* I2C codec control layer */
>  static struct i2c_driver da9055_i2c_driver = {
>  	.driver = {
> -		.name = "da9055",
> +		.name = "da9055-codec",
>  		.owner = THIS_MODULE,
>  	},
>  	.probe		= da9055_i2c_probe,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
