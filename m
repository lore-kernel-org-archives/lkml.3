Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab3LWRbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:31:45 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60465 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3LWRbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:31:43 -0500
Date: Mon, 23 Dec 2013 09:31:39 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Jean Delvare <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [RFC 08/18] hwmon: vexpress: Use regmap instead of custom
 interface
Message-ID: <20131223173139.GA1678@roeck-us.net>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-9-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387815830-8794-9-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 04:23:40PM +0000, Pawel Moll wrote:
> This patch makes the Versatile Express hwmon driver
> use regmap interface, instead of custom vexpress config
> one. It will request the regmap resource associated
> with the device, which makes it pretty much hardware
> agnostic.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> ---
>  drivers/hwmon/Kconfig    |  3 ++-
>  drivers/hwmon/vexpress.c | 29 +++++++++++------------------
>  2 files changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 52d548f..7747a47 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1324,7 +1324,8 @@ config SENSORS_TWL4030_MADC
>  
>  config SENSORS_VEXPRESS
>  	tristate "Versatile Express"
> -	depends on VEXPRESS_CONFIG
> +	depends on ARM || ARM64
> +	depends on REGMAP
>  	help
>  	  This driver provides support for hardware sensors available on
>  	  the ARM Ltd's Versatile Express platform. It can provide wide
> diff --git a/drivers/hwmon/vexpress.c b/drivers/hwmon/vexpress.c
> index d867e6b..b58cf1c 100644
> --- a/drivers/hwmon/vexpress.c
> +++ b/drivers/hwmon/vexpress.c
> @@ -22,11 +22,11 @@
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
> -#include <linux/vexpress.h>
> +#include <linux/regmap.h>
>  
>  struct vexpress_hwmon_data {
>  	struct device *hwmon_dev;
> -	struct vexpress_config_func *func;
> +	struct regmap *reg;
>  };
>  
>  static ssize_t vexpress_hwmon_name_show(struct device *dev,
> @@ -56,7 +56,7 @@ static ssize_t vexpress_hwmon_u32_show(struct device *dev,
>  	int err;
>  	u32 value;
>  
> -	err = vexpress_config_read(data->func, 0, &value);
> +	err = regmap_read(data->reg, 0, &value);
>  	if (err)
>  		return err;
>  
> @@ -69,13 +69,13 @@ static ssize_t vexpress_hwmon_u64_show(struct device *dev,
>  {
>  	struct vexpress_hwmon_data *data = dev_get_drvdata(dev);
>  	int err;
> -	u32 value_hi, value_lo;
> +	unsigned int value_hi, value_lo;
>  
> -	err = vexpress_config_read(data->func, 0, &value_lo);
> +	err = regmap_read(data->reg, 0, &value_lo);
>  	if (err)
>  		return err;
>  
> -	err = vexpress_config_read(data->func, 1, &value_hi);
> +	err = regmap_read(data->reg, 1, &value_hi);
>  	if (err)
>  		return err;
>  
> @@ -175,26 +175,21 @@ static int vexpress_hwmon_probe(struct platform_device *pdev)
>  	if (!match)
>  		return -ENODEV;
>  
> -	data->func = vexpress_config_func_get_by_dev(&pdev->dev);
> -	if (!data->func)
> +	data->reg = dev_get_regmap(&pdev->dev, NULL);
> +	if (!data->reg)
>  		return -ENODEV;
>  
>  	err = sysfs_create_group(&pdev->dev.kobj, match->data);
>  	if (err)
> -		goto error;
> +		return err;
>  
>  	data->hwmon_dev = hwmon_device_register(&pdev->dev);
>  	if (IS_ERR(data->hwmon_dev)) {
> -		err = PTR_ERR(data->hwmon_dev);
> -		goto error;
> +		sysfs_remove_group(&pdev->dev.kobj, match->data);
> +		return PTR_ERR(data->hwmon_dev);

This change is unrelated and violates coding style. If the goto disturbs you,
I would suggest to convert the driver to use devm_hwmon_device_register_with_groups() 
in a separate patch and get rid of the error handling and the entire remove() function.

Thanks,
Guenter

>  	}
>  
>  	return 0;
> -
> -error:
> -	sysfs_remove_group(&pdev->dev.kobj, match->data);
> -	vexpress_config_func_put(data->func);
> -	return err;
>  }
>  
>  static int vexpress_hwmon_remove(struct platform_device *pdev)
> @@ -207,8 +202,6 @@ static int vexpress_hwmon_remove(struct platform_device *pdev)
>  	match = of_match_device(vexpress_hwmon_of_match, &pdev->dev);
>  	sysfs_remove_group(&pdev->dev.kobj, match->data);
>  
> -	vexpress_config_func_put(data->func);
> -
>  	return 0;
>  }
>  
> -- 
> 1.8.3.2
> 
> 
> 
