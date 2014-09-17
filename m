Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbaIQPs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:48:26 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46472 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbaIQPsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:48:24 -0400
Date: Wed, 17 Sep 2014 08:48:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, jdelvare@suse.de
Subject: Re: [PATCH v3] hwmon: ntc_thermistor: Add ntc thermistor to thermal
 subsystem as a sensor.
Message-ID: <20140917154820.GC29184@roeck-us.net>
References: <1410933277-31704-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410933277-31704-1-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 02:54:37PM +0900, Jonghwa Lee wrote:
> To get more comprehensive and integrated thermal management, it adds ntc
> thermistor to thermal framework as a thermal sensor. It's governed thermal
> susbsystem only if it is described in DT node. Otherwise, it just notifies
> temperature to userspace via sysfs as it used to be.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>

Looks ok as far as I can see. I applied it to hwmon-next. I'll let you know
if there are any problems.

Guenter

> ---
> Changes:
> v3:
>  - Add dependencies of thermal subsystem for proper building.
> v2:
>  - Remove NULL pointer checking already done by thermal_zone_of_sensor_unregister().
> 
>  .../devicetree/bindings/hwmon/ntc_thermistor.txt   |    3 +++
>  drivers/hwmon/Kconfig                              |    1 +
>  drivers/hwmon/ntc_thermistor.c                     |   25 ++++++++++++++++++++
>  3 files changed, 29 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> index 2391e5c..fcca8e7 100644
> --- a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> +++ b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> @@ -25,6 +25,9 @@ Requires node properties:
>  - "io-channels"	Channel node of ADC to be used for
>  		conversion.
>  
> +Optional node properties:
> +- "#thermal-sensor-cells" Used to expose itself to thermal fw.
> +
>  Read more about iio bindings at
>  	Documentation/devicetree/bindings/iio/iio-bindings.txt
>  
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 4289a4f..f790b41 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1077,6 +1077,7 @@ config SENSORS_PC87427
>  config SENSORS_NTC_THERMISTOR
>  	tristate "NTC thermistor support from Murata"
>  	depends on !OF || IIO=n || IIO
> +	depends on THERMAL || !THERMAL_OF
>  	help
>  	  This driver supports NTC thermistors sensor reading and its
>  	  interpretation. The driver can also monitor the temperature and
> diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
> index bd41072..4ff89b2 100644
> --- a/drivers/hwmon/ntc_thermistor.c
> +++ b/drivers/hwmon/ntc_thermistor.c
> @@ -38,6 +38,7 @@
>  
>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
> +#include <linux/thermal.h>
>  
>  struct ntc_compensation {
>  	int		temp_c;
> @@ -182,6 +183,7 @@ struct ntc_data {
>  	struct device *dev;
>  	int n_comp;
>  	char name[PLATFORM_NAME_SIZE];
> +	struct thermal_zone_device *tz;
>  };
>  
>  #if defined(CONFIG_OF) && IS_ENABLED(CONFIG_IIO)
> @@ -428,6 +430,20 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
>  	return -EINVAL;
>  }
>  
> +static int ntc_read_temp(void *dev, long *temp)
> +{
> +	struct ntc_data *data = dev_get_drvdata(dev);
> +	int ohm;
> +
> +	ohm = ntc_thermistor_get_ohm(data);
> +	if (ohm < 0)
> +		return ohm;
> +
> +	*temp = get_temp_mc(data, ohm);
> +
> +	return 0;
> +}
> +
>  static ssize_t ntc_show_name(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> @@ -562,6 +578,13 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>  	dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
>  								pdev_id->name);
>  
> +	data->tz = thermal_zone_of_sensor_register(data->dev, 0, data->dev,
> +						ntc_read_temp, NULL);
> +	if (IS_ERR(data->tz)) {
> +		dev_dbg(&pdev->dev, "Failed to register to thermal fw.\n");
> +		data->tz = NULL;
> +	}
> +
>  	return 0;
>  err_after_sysfs:
>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
> @@ -578,6 +601,8 @@ static int ntc_thermistor_remove(struct platform_device *pdev)
>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
>  	ntc_iio_channel_release(pdata);
>  
> +	thermal_zone_of_sensor_unregister(data->dev, data->tz);
> +
>  	return 0;
>  }
>  
> -- 
> 1.7.9.5
> 
