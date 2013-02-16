Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab3BPFzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 00:55:00 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:35062 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3BPFy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 00:54:58 -0500
Date: Sat, 16 Feb 2013 14:54:55 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH/RFC] mfd: as3711: add OF support
Message-ID: <20130216055454.GA17713@verge.net.au>
References: <Pine.LNX.4.64.1302151101140.7446@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1302151101140.7446@axis700.grange>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:07:16AM +0100, Guennadi Liakhovetski wrote:
> Add device-tree bindings to the AS3711 regulator and backlight drivers.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> As usual - comments to the new bindings are very welcome!
> 
>  Documentation/devicetree/bindings/mfd/as3711.txt |   73 +++++++++++++
>  drivers/mfd/as3711.c                             |   30 +++++-
>  drivers/regulator/as3711-regulator.c             |   69 ++++++++++++-
>  drivers/video/backlight/as3711_bl.c              |  118 +++++++++++++++++++++-
>  4 files changed, 282 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/as3711.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/as3711.txt b/Documentation/devicetree/bindings/mfd/as3711.txt
> new file mode 100644
> index 0000000..d98cf18
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/as3711.txt
> @@ -0,0 +1,73 @@
> +AS3711 is an I2C PMIC from Austria MicroSystems with multiple DCDC and LDO power
> +supplies, a battery charger and an RTC. So far only bindings for the two stepup
> +DCDC converters are defined. Other DCDC and LDO supplies are configured, using
> +standard regulator properties, they must belong to a sub-node, called
> +"regulators" and be called "sd1" to "sd4" and "ldo1" to "ldo8." Stepup converter
> +configuration should be placed in a subnode, called "backlight."
> +
> +Compulsory properties:
> +- compatible		: must be "ams,as3711"
> +- reg			: specifies the I2C address
> +
> +To use the SU1 converter as a backlight source the following two properties must
> +be provided:
> +- su1-dev		: framebuffer phandle
> +- su1-max-uA		: maximum current
> +
> +To use the SU2 converter as a backlight source the following two properties must
> +be provided:
> +- su2-dev		: framebuffer phandle
> +- su1-max-uA		: maximum current
> +
> +Additionally one of these properties must be provided to select the type of
> +feedback used:
> +- su2-feedback-voltage	: voltage feedback is used
> +- su2-feedback-curr1	: CURR1 input used for current feedback
> +- su2-feedback-curr2	: CURR2 input used for current feedback
> +- su2-feedback-curr3	: CURR3 input used for current feedback
> +- su2-feedback-curr-auto: automatic current feedback selection
> +
> +and one of these to select the over-voltage protection pin
> +- su2-fbprot-lx-sd4	: LX_SD4 is used for over-voltage protection
> +- su2-fbprot-gpio2	: GPIO2 is used for over-voltage protection
> +- su2-fbprot-gpio3	: GPIO3 is used for over-voltage protection
> +- su2-fbprot-gpio4	: GPIO4 is used for over-voltage protection
> +
> +If "su2-feedback-curr-auto" is selected, one or more of the following properties
> +have to be specified:
> +- su2-auto-curr1	: use CURR1 input for current feedback
> +- su2-auto-curr2	: use CURR2 input for current feedback
> +- su2-auto-curr3	: use CURR3 input for current feedback
> +
> +Example:
> +
> +as3711@40 {
> +	compatible = "ams,as3711";
> +	reg = <0x40>;
> +
> +	regulators {
> +		sd4 {
> +			regulator-name = "1.215V";
> +			regulator-min-microvolt = <1215000>;
> +			regulator-max-microvolt = <1235000>;
> +		};
> +		ldo2 {
> +			regulator-name = "2.8V CPU";
> +			regulator-min-microvolt = <2800000>;
> +			regulator-max-microvolt = <2800000>;
> +			regulator-always-on;
> +			regulator-boot-on;
> +		};
> +	};
> +
> +	backlight {
> +		compatible = "ams,as3711-bl";
> +		su2-dev = <&lcdc>;
> +		su2-max-uA = <36000>;
> +		su2-feedback-curr-auto;
> +		su2-fbprot-gpio4;
> +		su2-auto-curr1;
> +		su2-auto-curr2;
> +		su2-auto-curr3;
> +	};
> +};
> diff --git a/drivers/mfd/as3711.c b/drivers/mfd/as3711.c
> index e994c96..5e0e8b3 100644
> --- a/drivers/mfd/as3711.c
> +++ b/drivers/mfd/as3711.c
> @@ -112,16 +112,37 @@ static const struct regmap_config as3711_regmap_config = {
>  	.cache_type = REGCACHE_RBTREE,
>  };
>  
> +#ifdef CONFIG_OF
> +static struct of_device_id as3711_of_match[] = {
> +	{.compatible = "ams,as3711",},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, as3711_of_match);
> +#endif
> +
>  static int as3711_i2c_probe(struct i2c_client *client,
>  			    const struct i2c_device_id *id)
>  {
>  	struct as3711 *as3711;
> -	struct as3711_platform_data *pdata = client->dev.platform_data;
> +	struct as3711_platform_data *pdata;
>  	unsigned int id1, id2;
>  	int ret;
>  
> -	if (!pdata)
> -		dev_dbg(&client->dev, "Platform data not found\n");
> +	if (!client->dev.of_node) {
> +		pdata = client->dev.platform_data;
> +		if (!pdata)
> +			dev_dbg(&client->dev, "Platform data not found\n");
> +	} else {
> +		if (!of_device_is_available(client->dev.of_node))
> +			return -ENODEV;

The wonder that is kbuild tells me that the above call to
of_device_is_available() may cause a build-time error.
Perhaps it or this entire else clause should be guarded by CONFIG_OF?

> +
> +		pdata = devm_kzalloc(&client->dev,
> +				     sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata) {
> +			dev_err(&client->dev, "Failed to allocate pdata\n");
> +			return -ENOMEM;
> +		}
> +	}
>  
>  	as3711 = devm_kzalloc(&client->dev, sizeof(struct as3711), GFP_KERNEL);
>  	if (!as3711) {
> @@ -193,7 +214,8 @@ static struct i2c_driver as3711_i2c_driver = {
>  	.driver = {
>  		   .name = "as3711",
>  		   .owner = THIS_MODULE,
> -		   },
> +		   .of_match_table = of_match_ptr(as3711_of_match),
> +	},
>  	.probe = as3711_i2c_probe,
>  	.remove = as3711_i2c_remove,
>  	.id_table = as3711_i2c_id,
> diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
> index f0ba8c4..cf145fc 100644
> --- a/drivers/regulator/as3711-regulator.c
> +++ b/drivers/regulator/as3711-regulator.c
> @@ -13,9 +13,11 @@
>  #include <linux/init.h>
>  #include <linux/mfd/as3711.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/regulator/driver.h>
> +#include <linux/regulator/of_regulator.h>
>  #include <linux/slab.h>
>  
>  struct as3711_regulator_info {
> @@ -276,6 +278,57 @@ static struct as3711_regulator_info as3711_reg_info[] = {
>  
>  #define AS3711_REGULATOR_NUM ARRAY_SIZE(as3711_reg_info)
>  
> +static const char *as3711_regulator_of_names[AS3711_REGULATOR_NUM] = {
> +	[AS3711_REGULATOR_SD_1] = "sd1",
> +	[AS3711_REGULATOR_SD_2] = "sd2",
> +	[AS3711_REGULATOR_SD_3] = "sd3",
> +	[AS3711_REGULATOR_SD_4] = "sd4",
> +	[AS3711_REGULATOR_LDO_1] = "ldo1",
> +	[AS3711_REGULATOR_LDO_2] = "ldo2",
> +	[AS3711_REGULATOR_LDO_3] = "ldo3",
> +	[AS3711_REGULATOR_LDO_4] = "ldo4",
> +	[AS3711_REGULATOR_LDO_5] = "ldo5",
> +	[AS3711_REGULATOR_LDO_6] = "ldo6",
> +	[AS3711_REGULATOR_LDO_7] = "ldo7",
> +	[AS3711_REGULATOR_LDO_8] = "ldo8",
> +};
> +
> +static int as3711_regulator_parse_dt(struct device *dev)
> +{
> +	struct as3711_regulator_pdata *pdata = dev_get_platdata(dev);
> +	struct device_node *regulators =
> +		of_find_node_by_name(dev->parent->of_node, "regulators");
> +	struct of_regulator_match *matches, *match;
> +	const int count = AS3711_REGULATOR_NUM;
> +	int ret, i;
> +
> +	if (!regulators) {
> +		dev_err(dev, "regulator node not found\n");
> +		return -ENODEV;
> +	}
> +
> +	matches = devm_kzalloc(dev, sizeof(*matches) * count, GFP_KERNEL);
> +	if (!matches)
> +		return -ENOMEM;
> +
> +	for (i = 0, match = matches; i < count; i++, match++) {
> +		match->name = as3711_regulator_of_names[i];
> +		match->driver_data = as3711_reg_info + i;
> +	}
> +
> +	ret = of_regulator_match(dev->parent, regulators, matches, count);
> +	if (ret < 0) {
> +		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
> +		return ret;
> +	}
> +
> +	for (i = 0, match = matches; i < count; i++, match++)
> +		if (match->of_node)
> +			pdata->init_data[i] = match->init_data;
> +
> +	return 0;
> +}
> +
>  static int as3711_regulator_probe(struct platform_device *pdev)
>  {
>  	struct as3711_regulator_pdata *pdata = dev_get_platdata(&pdev->dev);
> @@ -289,8 +342,18 @@ static int as3711_regulator_probe(struct platform_device *pdev)
>  	int ret;
>  	int id;
>  
> -	if (!pdata)
> -		dev_dbg(&pdev->dev, "No platform data...\n");
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "No platform data...\n");
> +		return -ENODEV;
> +	}
> +
> +	if (pdev->dev.parent->of_node) {
> +		ret = as3711_regulator_parse_dt(&pdev->dev);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "DT parsing failed: %d\n", ret);
> +			return ret;
> +		}
> +	}
>  
>  	regs = devm_kzalloc(&pdev->dev, AS3711_REGULATOR_NUM *
>  			sizeof(struct as3711_regulator), GFP_KERNEL);
> @@ -300,7 +363,7 @@ static int as3711_regulator_probe(struct platform_device *pdev)
>  	}
>  
>  	for (id = 0, ri = as3711_reg_info; id < AS3711_REGULATOR_NUM; ++id, ri++) {
> -		reg_data = pdata ? pdata->init_data[id] : NULL;
> +		reg_data = pdata->init_data[id];
>  
>  		/* No need to register if there is no regulator data */
>  		if (!reg_data)
> diff --git a/drivers/video/backlight/as3711_bl.c b/drivers/video/backlight/as3711_bl.c
> index c6bc65d..90c9208 100644
> --- a/drivers/video/backlight/as3711_bl.c
> +++ b/drivers/video/backlight/as3711_bl.c
> @@ -257,6 +257,109 @@ static int as3711_bl_register(struct platform_device *pdev,
>  	return 0;
>  }
>  
> +static int as3711_backlight_parse_dt(struct device *dev)
> +{
> +	struct as3711_bl_pdata *pdata = dev_get_platdata(dev);
> +	struct device_node *bl =
> +		of_find_node_by_name(dev->parent->of_node, "backlight"), *fb;
> +	int ret;
> +
> +	if (!bl) {
> +		dev_dbg(dev, "backlight node not found\n");
> +		return -ENODEV;
> +	}
> +
> +	fb = of_parse_phandle(bl, "su1-dev", 0);
> +	if (fb) {
> +		pdata->su1_fb = fb->full_name;
> +
> +		ret = of_property_read_u32(bl, "su1-max-uA", &pdata->su1_max_uA);
> +		if (pdata->su1_max_uA <= 0)
> +			ret = -EINVAL;
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	fb = of_parse_phandle(bl, "su2-dev", 0);
> +	if (fb) {
> +		int count = 0;
> +
> +		pdata->su2_fb = fb->full_name;
> +
> +		ret = of_property_read_u32(bl, "su2-max-uA", &pdata->su2_max_uA);
> +		if (pdata->su2_max_uA <= 0)
> +			ret = -EINVAL;
> +		if (ret < 0)
> +			return ret;
> +
> +		if (of_find_property(bl, "su2-feedback-voltage", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_VOLTAGE;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr1", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR1;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr2", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR2;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr3", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR3;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr-auto", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR_AUTO;
> +			count++;
> +		}
> +		if (count != 1)
> +			return -EINVAL;
> +
> +		count = 0;
> +		if (of_find_property(bl, "su2-fbprot-lx-sd4", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_LX_SD4;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-fbprot-gpio2", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_GPIO2;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-fbprot-gpio3", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_GPIO3;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-fbprot-gpio4", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_GPIO4;
> +			count++;
> +		}
> +		if (count != 1)
> +			return -EINVAL;
> +
> +		count = 0;
> +		if (of_find_property(bl, "su2-auto-curr1", NULL)) {
> +			pdata->su2_auto_curr1 = true;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-auto-curr2", NULL)) {
> +			pdata->su2_auto_curr2 = true;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-auto-curr3", NULL)) {
> +			pdata->su2_auto_curr3 = true;
> +			count++;
> +		}
> +
> +		/*
> +		 * At least one su2-auto-curr* must be specified iff
> +		 * AS3711_SU2_CURR_AUTO is used
> +		 */
> +		if (!count ^ pdata->su2_feedback != AS3711_SU2_CURR_AUTO)
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int as3711_backlight_probe(struct platform_device *pdev)
>  {
>  	struct as3711_bl_pdata *pdata = dev_get_platdata(&pdev->dev);
> @@ -266,11 +369,24 @@ static int as3711_backlight_probe(struct platform_device *pdev)
>  	unsigned int max_brightness;
>  	int ret;
>  
> -	if (!pdata || (!pdata->su1_fb && !pdata->su2_fb)) {
> +	if (!pdata) {
>  		dev_err(&pdev->dev, "No platform data, exiting...\n");
>  		return -ENODEV;
>  	}
>  
> +	if (pdev->dev.parent->of_node) {
> +		ret = as3711_backlight_parse_dt(&pdev->dev);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "DT parsing failed: %d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	if (!pdata->su1_fb && !pdata->su2_fb) {
> +		dev_err(&pdev->dev, "No framebuffer specified\n");
> +		return -EINVAL;
> +	}
> +
>  	/*
>  	 * Due to possible hardware damage I chose to block all modes,
>  	 * unsupported on my hardware. Anyone, wishing to use any of those modes
> -- 
> 1.7.2.5
> 
