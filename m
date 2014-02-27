Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaB0Gxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 01:53:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:3613 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaB0Gxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 01:53:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,552,1389772800"; 
   d="scan'208";a="482714587"
Message-ID: <1393484014.2637.14.camel@rzhang1-mobl4>
Subject: Re: [PATCH] thermal: add generic IIO channel thermal sensor driver
From: Zhang Rui <rui.zhang@intel.com>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: eduardo.valentin@ti.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, grant.likely@linaro.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Feb 2014 14:53:34 +0800
In-Reply-To: <1391651007-29813-1-git-send-email-courtney.cavin@sonymobile.com>
References: <1391651007-29813-1-git-send-email-courtney.cavin@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-05 at 17:43 -0800, Courtney Cavin wrote:
> This driver is a generic method for using IIO ADC channels as thermal
> sensors.
> 
> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>

Eduardo,

what do you think of this patch?

thanks,
rui
> ---
>  .../devicetree/bindings/thermal/iio-thermal.txt    |  46 +++++
>  drivers/thermal/Kconfig                            |  13 ++
>  drivers/thermal/Makefile                           |   1 +
>  drivers/thermal/iio_thermal.c                      | 207 +++++++++++++++++++++
>  4 files changed, 267 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/iio-thermal.txt
>  create mode 100644 drivers/thermal/iio_thermal.c
> 
> diff --git a/Documentation/devicetree/bindings/thermal/iio-thermal.txt b/Documentation/devicetree/bindings/thermal/iio-thermal.txt
> new file mode 100644
> index 0000000..3be11b6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/iio-thermal.txt
> @@ -0,0 +1,46 @@
> +Generic IIO channel thermal sensor bindings
> +
> +compatible:
> +	Usage: required
> +	Type: string
> +	Desc: compatible string, must be "iio-thermal"
> +
> +conversion-method:
> +	Usage: required
> +	Type: string
> +	Desc: How to convert IIO voltage values to temperature, one of:
> +		"interpolation" - interpolate between values in lookup table
> +		"scalar" - use values as multiplier and divisor
> +
> +conversion-values:
> +	Usage: required
> +	Type: u32 array, 2-tuples
> +	Desc: lookup table for conversion, for conversion-method:
> +		"interpolation" - 2-tuples of < uV mK >; micro-volts to
> +				  milli-kelvin; table must ascend
> +		"scalar" - single scalar 2-tuple as < M D >; where:
> +			   mK = uV * M / D
> +
> +io-channels:
> +	Usage: required
> +	Type: prop-encoded-array
> +	Desc: See bindings/iio/iio-bindings.txt; must be a voltage channel
> +
> +Example:
> +
> +vadc: some_vadc {
> +	compatible = "...";
> +	#io-channel-cells = <1>;
> +};
> +
> +iio-thermal {
> +	compatible = "iio-thermal";
> +	io-channels = <&vadc 0>;
> +	conversion-method = "interpolation";
> +	conversion-values = <
> +		  30000 398200
> +		 385000 318200
> +		1738000 233200
> +	>;
> +};
> +
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 35c0664..f83a8e8 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -114,6 +114,19 @@ config THERMAL_EMULATION
>  	  because userland can easily disable the thermal policy by simply
>  	  flooding this sysfs node with low temperature values.
>  
> +config IIO_THERMAL
> +	tristate "Temperature sensor driver for generic IIO channels"
> +	depends on IIO
> +	depends on THERMAL_OF
> +	help
> +	  Support for generic IIO channels, such as ADCs.  This driver allows
> +	  you to expose an IIO voltage channel as a thermal sensor.  This is
> +	  implemented as a thermal sensor, not a thermal zone, and thus
> +	  requires DT defined thermal infrastructure in order to be useful.
> +
> +	  If you aren't sure that you need this support, or haven't configured
> +	  a thermal infrastructure in device tree, you should say 'N' here.
> +
>  config IMX_THERMAL
>  	tristate "Temperature sensor driver for Freescale i.MX SoCs"
>  	depends on CPU_THERMAL
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index 54e4ec9..0ee2c92 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -25,6 +25,7 @@ obj-y				+= samsung/
>  obj-$(CONFIG_DOVE_THERMAL)  	+= dove_thermal.o
>  obj-$(CONFIG_DB8500_THERMAL)	+= db8500_thermal.o
>  obj-$(CONFIG_ARMADA_THERMAL)	+= armada_thermal.o
> +obj-$(CONFIG_IIO_THERMAL)	+= iio_thermal.o
>  obj-$(CONFIG_IMX_THERMAL)	+= imx_thermal.o
>  obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+= db8500_cpufreq_cooling.o
>  obj-$(CONFIG_INTEL_POWERCLAMP)	+= intel_powerclamp.o
> diff --git a/drivers/thermal/iio_thermal.c b/drivers/thermal/iio_thermal.c
> new file mode 100644
> index 0000000..df21dbc
> --- /dev/null
> +++ b/drivers/thermal/iio_thermal.c
> @@ -0,0 +1,207 @@
> +/*
> + * An IIO channel based thermal sensor driver
> + *
> + * Copyright (C) 2014 Sony Mobile Communications, AB
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/consumer.h>
> +#include <linux/thermal.h>
> +#include <linux/err.h>
> +#include <linux/of.h>
> +
> +#define MILLIKELVIN_0C 273150
> +
> +struct iio_thermal_conv {
> +	s32 *values;
> +	int ntuple;
> +	long (*convert)(const struct iio_thermal_conv *, int val);
> +};
> +
> +struct iio_thermal {
> +	struct thermal_zone_device *tz;
> +	struct iio_channel *chan;
> +	struct iio_thermal_conv conv;
> +};
> +
> +static int iio_bsearch(const struct iio_thermal_conv *conv, s32 input)
> +{
> +	int h = conv->ntuple - 1;
> +	int l = 0;
> +
> +	while (h - 1 > l) {
> +		int m = (l + h) & ~1;
> +		s32 v = conv->values[m];
> +		if (v < input)
> +			l = m >> 1;
> +		else
> +			h = m >> 1;
> +	}
> +
> +	return h;
> +}
> +
> +static long iio_thermal_interpolate(const struct iio_thermal_conv *conv, int v)
> +{
> +	int n;
> +
> +	n = iio_bsearch(conv, v);
> +	if (n == 0 || n == conv->ntuple) {
> +		BUG();
> +	} else {
> +		s32 *pts = &conv->values[(n-1)*2];
> +		s32 sx = pts[3] - pts[1];
> +		s32 sy = pts[2] - pts[0];
> +		return sx * (v - pts[0]) / sy + pts[1];
> +	}
> +}
> +
> +static long iio_thermal_scale(const struct iio_thermal_conv *conv, int v)
> +{
> +	return div_s64((s64)v * conv->values[0], conv->values[1]);
> +}
> +
> +static int iio_thermal_get_temp(void *pdata, long *value)
> +{
> +	struct iio_thermal *iio = pdata;
> +	long temp;
> +	int val;
> +	int rc;
> +
> +	rc = iio_read_channel_processed(iio->chan, &val);
> +	if (rc)
> +		return rc;
> +
> +	temp = iio->conv.convert(&iio->conv, val);
> +
> +	/* thermal core wants milli-celsius; we deal in milli-kelvin */
> +	temp = temp - MILLIKELVIN_0C;
> +
> +	/*
> +	 * Although it would appear that the temperature value here is a
> +	 * signed value for sensors, the underlying thermal zone core
> +	 * doesn't deal with negative temperature. Cut this value off at 0C.
> +	 */
> +	*value = (temp < 0) ? 0 : temp;
> +
> +	return 0;
> +}
> +
> +static int iio_thermal_probe(struct platform_device *pdev)
> +{
> +	struct iio_thermal *iio;
> +	const void *values;
> +	const char *type;
> +	int rc;
> +
> +	dev_info(&pdev->dev, "registering IIO thermal device\n");
> +	iio = devm_kzalloc(&pdev->dev, sizeof(*iio), GFP_KERNEL);
> +	if (!iio)
> +		return -ENOMEM;
> +
> +	values = of_get_property(pdev->dev.of_node,
> +			"conversion-values", &iio->conv.ntuple);
> +	if (values == NULL || (iio->conv.ntuple % (sizeof(u32) * 2)) != 0) {
> +		dev_err(&pdev->dev, "invalid/missing conversion values\n");
> +		return -EINVAL;
> +	}
> +	iio->conv.ntuple /= sizeof(u32) * 2;
> +	iio->conv.values = devm_kzalloc(&pdev->dev,
> +			sizeof(u32) * 2 * iio->conv.ntuple, GFP_KERNEL);
> +	if (!iio->conv.values)
> +		return -ENOMEM;
> +
> +	rc = of_property_read_u32_array(pdev->dev.of_node,
> +			"conversion-values", (u32 *)iio->conv.values,
> +			iio->conv.ntuple * 2);
> +	if (rc) {
> +		dev_err(&pdev->dev, "invalid/missing conversion values\n");
> +		return -EINVAL;
> +	}
> +
> +	rc = of_property_read_string(pdev->dev.of_node,
> +			"conversion-method", &type);
> +	if (rc) {
> +		dev_err(&pdev->dev, "invalid/missing conversion method\n");
> +		return rc;
> +	}
> +	if (!strcmp(type, "interpolation") && iio->conv.ntuple > 1) {
> +		if (iio->conv.values[0] > iio->conv.values[2]) {
> +			dev_err(&pdev->dev,
> +					"conversion values should ascend\n");
> +			return rc;
> +		}
> +		iio->conv.convert = iio_thermal_interpolate;
> +	} else if (!strcmp(type, "scalar") && iio->conv.ntuple == 1) {
> +		iio->conv.convert = iio_thermal_scale;
> +	} else {
> +		dev_err(&pdev->dev, "invalid conversion method for values\n");
> +		return rc;
> +	}
> +
> +	iio->chan = iio_channel_get(&pdev->dev, NULL);
> +	if (IS_ERR(iio->chan)) {
> +		dev_err(&pdev->dev, "invalid/missing iio channel\n");
> +		return PTR_ERR(iio->chan);
> +	}
> +	if (iio->chan->channel->type != IIO_VOLTAGE) {
> +		dev_err(&pdev->dev, "specified iio channel is not voltage\n");
> +		iio_channel_release(iio->chan);
> +		return -EINVAL;
> +	}
> +	platform_set_drvdata(pdev, iio);
> +
> +	iio->tz = thermal_zone_of_sensor_register(&pdev->dev, 0, iio,
> +			iio_thermal_get_temp, NULL);
> +	if (IS_ERR(iio->tz)) {
> +		dev_err(&pdev->dev, "failed to register thermal sensor\n");
> +		iio_channel_release(iio->chan);
> +		return PTR_ERR(iio->tz);
> +	}
> +	dev_info(&pdev->dev, "successfully registered IIO thermal sensor\n");
> +
> +	return 0;
> +}
> +
> +static int iio_thermal_remove(struct platform_device *pdev)
> +{
> +	struct iio_thermal *iio;
> +
> +	iio = platform_get_drvdata(pdev);
> +
> +	thermal_zone_of_sensor_unregister(&pdev->dev, iio->tz);
> +	iio_channel_release(iio->chan);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id iio_thermal_match[] = {
> +	{ .compatible = "iio-thermal", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, iio_thermal_match);
> +
> +static struct platform_driver iio_thermal = {
> +	.driver = {
> +		.name = "iio-thermal",
> +		.owner = THIS_MODULE,
> +		.of_match_table = iio_thermal_match,
> +	},
> +	.probe = iio_thermal_probe,
> +	.remove = iio_thermal_remove,
> +};
> +module_platform_driver(iio_thermal);
> +
> +MODULE_DESCRIPTION("Thermal driver for IIO ADCs");
> +MODULE_LICENSE("GPL v2");


