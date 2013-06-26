Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3FZOjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:39:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49461 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3FZOjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:39:22 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 26 Jun 2013 07:39:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Jean Delvare <khali@linux-fr.org>,
        jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH 3/4] hwmon: Add a simple driver to read the MXS SoC
 temperature
Message-ID: <20130626143927.GB31998@roeck-us.net>
References: <1372236673-20725-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1372236673-20725-4-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372236673-20725-4-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:51:12AM +0200, Alexandre Belloni wrote:
> The low resolution ADC of the mxs is able to read an internal temperature
> sensor, expose that using hwmon.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---

Wouldn't it make more sense to use iio-hwmon and improve it if necessary ?

Guenter

>  .../devicetree/bindings/hwmon/mxs-cputemp.txt      |  18 +++
>  Documentation/hwmon/mxs-cputemp                    |  29 +++++
>  drivers/hwmon/Kconfig                              |  10 ++
>  drivers/hwmon/Makefile                             |   1 +
>  drivers/hwmon/mxs-cputemp.c                        | 132 +++++++++++++++++++++
>  5 files changed, 190 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hwmon/mxs-cputemp.txt
>  create mode 100644 Documentation/hwmon/mxs-cputemp
>  create mode 100644 drivers/hwmon/mxs-cputemp.c
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/mxs-cputemp.txt b/Documentation/devicetree/bindings/hwmon/mxs-cputemp.txt
> new file mode 100644
> index 0000000..7d3ae47
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/mxs-cputemp.txt
> @@ -0,0 +1,18 @@
> +mxs cputemp hwmon sensors
> +-------------------------
> +
> +See: Documentation/hwmon/mxs-cputemp
> +
> +Required properties:
> +- compatible: should be "fsl,mxs-internal-temp"
> +- io-channels: should list the two adc channels needed to calculate the
> +	       temperature
> +- io-channel-names: should map the previously listed adc channels to the "min"
> +		    and "max" value
> +
> +Example:
> +	temp {
> +		compatible = "fsl,mxs-internal-temp";
> +		io-channels = <&lradc 8>, <&lradc 9>;
> +		io-channel-names = "min", "max";
> +	};
> diff --git a/Documentation/hwmon/mxs-cputemp b/Documentation/hwmon/mxs-cputemp
> new file mode 100644
> index 0000000..6c6201f
> --- /dev/null
> +++ b/Documentation/hwmon/mxs-cputemp
> @@ -0,0 +1,29 @@
> +Kernel driver mxs-cputemp
> +=========================
> +
> +Supported chips:
> +  * Freescale i.mx28
> +    Datasheet: i.MX28 Applications Processor Reference Manual, Rev. 1, 2010
> +    	       http://cache.freescale.com/files/dsp/doc/ref_manual/MCIMX28RM.pdf
> +
> +Author: Alexandre Belloni
> +
> +Description
> +-----------
> +This driver permits reading the internal die temperature sensor embedded inside
> +Freescale i.mx28 SoCs. This sensor is read through two channels of the on chip
> +Low-Resolution ADC. After calculation, the three-sigma error of the temperature
> +sensor should be within ± 1.5% in degrees Kelvin. Additionally, the temperature
> +sampling has a three-sigma sample-to-sample variation of 2 degrees Kelvin. If
> +desired, this error can be removed by oversampling and averaging the temperature
> +result.
> +
> +The formula is:
> +	(Channel9 – Channel8) * Gain_correction/4
> +
> +As recommended by the datasheet, Gain_correction is equal to 1.012.
> +
> +sysfs entries
> +-------------
> +temp1_input	Measured and corrected temperature in millidegrees Celsius
> +
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 0428e8a..2daf794 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -929,6 +929,16 @@ config SENSORS_MCP3021
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called mcp3021.
>  
> +config SENSORS_MXS_CPU
> +	tristate "MXS internal CPU temperature sensor"
> +	depends on MXS_LRADC
> +	help
> +	  If you say yes here you get support for the i.mx28 internal
> +	  temperature sensor.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called mxs-cputemp
> +
>  config SENSORS_NCT6775
>  	tristate "Nuvoton NCT6775F and compatibles"
>  	depends on !PPC
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index d17d3e6..366c92d 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -108,6 +108,7 @@ obj-$(CONFIG_SENSORS_MAX6650)	+= max6650.o
>  obj-$(CONFIG_SENSORS_MAX6697)	+= max6697.o
>  obj-$(CONFIG_SENSORS_MC13783_ADC)+= mc13783-adc.o
>  obj-$(CONFIG_SENSORS_MCP3021)	+= mcp3021.o
> +obj-$(CONFIG_SENSORS_MXS_CPU)	+= mxs-cputemp.o
>  obj-$(CONFIG_SENSORS_NCT6775)	+= nct6775.o
>  obj-$(CONFIG_SENSORS_NTC_THERMISTOR)	+= ntc_thermistor.o
>  obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
> diff --git a/drivers/hwmon/mxs-cputemp.c b/drivers/hwmon/mxs-cputemp.c
> new file mode 100644
> index 0000000..a312fb5
> --- /dev/null
> +++ b/drivers/hwmon/mxs-cputemp.c
> @@ -0,0 +1,132 @@
> +/*
> + * Driver for the mxs internal temperature sensor
> + *
> + * Copyright 2013 Free Electrons
> + *
> + * Licensed under the GPLv2 or later.
> + */
> +
> +#define DRVNAME "mxs-hwmon"
> +
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/iio/consumer.h>
> +
> +#define GAIN_CORRECTION 1012
> +
> +/* The value we calculate from the ADCs is in Kelvins, don't forget to convert
> + * it to Celsius */
> +#define VALUES_TO_MILLIC(min, max) ((max - min) * GAIN_CORRECTION / 4 - 272150)
> +
> +struct mxs_hwmon_data {
> +	struct device *hwmon_dev;
> +	struct iio_channel *chan_min;
> +	struct iio_channel *chan_max;
> +};
> +
> +static int mxs_hwmon_show_temp(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	int err, val_min, val_max;
> +
> +	struct mxs_hwmon_data *data = dev_get_drvdata(dev);
> +
> +	err = iio_read_channel_raw(data->chan_min, &val_min);
> +	if (err < 0)
> +		return err;
> +
> +	err = iio_read_channel_raw(data->chan_max, &val_max);
> +	if (err < 0)
> +		return err;
> +
> +	return sprintf(buf, "%u\n", VALUES_TO_MILLIC(val_min, val_max));
> +}
> +
> +static DEVICE_ATTR(temp1_input, S_IRUGO, mxs_hwmon_show_temp, NULL);
> +
> +static int mxs_hwmon_probe(struct platform_device *pdev)
> +{
> +	int err;
> +	struct mxs_hwmon_data *data;
> +
> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, data);
> +
> +	err = device_create_file(&pdev->dev, &dev_attr_temp1_input);
> +	if (err)
> +		return err;
> +
> +	data->chan_min = iio_channel_get(&pdev->dev, "min");
> +	if (IS_ERR(data->chan_min)) {
> +		err = PTR_ERR(data->chan_min);
> +		goto error_chan_min;
> +	}
> +
> +	data->chan_max = iio_channel_get(&pdev->dev, "max");
> +	if (IS_ERR(data->chan_max)) {
> +		err = PTR_ERR(data->chan_max);
> +		goto error_chan_max;
> +	}
> +
> +	data->hwmon_dev = hwmon_device_register(&pdev->dev);
> +	if (IS_ERR(data->hwmon_dev)) {
> +		err = PTR_ERR(data->hwmon_dev);
> +		goto error_hwmon;
> +	}
> +
> +	return 0;
> +
> +error_hwmon:
> +	iio_channel_release(data->chan_max);
> +error_chan_max:
> +	iio_channel_release(data->chan_min);
> +error_chan_min:
> +	device_remove_file(&pdev->dev, &dev_attr_temp1_input);
> +
> +	return err;
> +}
> +
> +static int mxs_hwmon_remove(struct platform_device *pdev)
> +{
> +	struct mxs_hwmon_data *data = platform_get_drvdata(pdev);
> +
> +	iio_channel_release(data->chan_min);
> +	iio_channel_release(data->chan_max);
> +	hwmon_device_unregister(data->hwmon_dev);
> +
> +	device_remove_file(&pdev->dev, &dev_attr_temp1_input);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id mxs_hwmon_of_match[] = {
> +	{ .compatible = "fsl,mxs-internal-temp", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, mxs_hwmon_of_match);
> +
> +static struct platform_driver mxs_hwmon_driver = {
> +	.probe = mxs_hwmon_probe,
> +	.remove = mxs_hwmon_remove,
> +	.driver	= {
> +		.name = DRVNAME,
> +		.owner = THIS_MODULE,
> +		.of_match_table = mxs_hwmon_of_match,
> +	},
> +};
> +
> +module_platform_driver(mxs_hwmon_driver);
> +
> +MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>");
> +MODULE_DESCRIPTION("Freescale i.MX28 hwmon sensor driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:mxs-hwmon");
> -- 
> 1.8.1.2
> 
> 
