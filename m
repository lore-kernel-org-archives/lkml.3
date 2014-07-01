Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbaGAPPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:15:31 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62551 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbaGAPP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:15:28 -0400
Date: Tue, 1 Jul 2014 16:15:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] mfd: Add driver for Maxim 77802 Power
 Management IC
Message-ID: <20140701151519.GM27971@lee--X1>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403806546-31122-8-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403806546-31122-8-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Javier Martinez Canillas wrote:

> Maxim MAX77802 is a power management chip that contains 10 high
> efficiency Buck regulators, 32 Low-dropout (LDO) regulators used
> to power up application processors and peripherals, a 2-channel
> 32kHz clock outputs, a Real-Time-Clock (RTC) and a I2C interface
> to program the individual regulators, clocks outputs and the RTC.
> 
> This patch adds the core support for MAX77802 PMIC and is based
> on a driver added by Simon Glass to the Chrome OS kernel 3.8 tree.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> 
> Changes since v4:
>  - Use consistent expressions when checking for NULL values.
>    Suggested by Krzysztof Kozlowski.
>  - Remove unused defines. Suggested by Krzysztof Kozlowski.
>  - Explain why IRQ is disabled on suspend. Suggested by Krzysztof Kozlowski.
> 
> Changes since v3:
>  - Remove unnecessary OOM error message since the mm subsystem already logs it. 
> 
> Changes since v2:
>  - Split the DT binding docs in a separate patch and improve the documentation.
>    Suggested by Mark Brown.
>  - Add all the devices in the MFD driver instead of doing in separate patches.
>    Suggested by Mark Brown.
> 
> Changes since v1:
>  - Convert max77{686,802} to regmap irq API and get rid of max77{686,802}-irq.c
>    Suggested by Krzysztof Kozlowski.
>  - Don't protect max77802 mfd_cells using Kconfig options since mfd core omits
>    devices that don't match. Suggested by Lee Jones.
>  - Change mfd driver to be tristate instead of boolean. Suggested by Mark Brown.
>  - Change binding "voltage-regulators" property to "regulators" to be consistent
>    with other PMIC drivers. Suggested by Mark Brown.
>  - Use regulators node names instead of the deprecated "regulator-compatible"
>    property. Suggested by Mark Brown.
>  - Use the new descriptor-based GPIO interface instead of the deprecated
>    integer based GPIO one. Suggested by Mark Brown.
>  - Remove the type parameter from i2c_device_id table since was not used.
>  - Fix device not found error message and remove unneeded device found message.
> 
>  drivers/mfd/Kconfig                  |  14 ++
>  drivers/mfd/Makefile                 |   1 +
>  drivers/mfd/max77802.c               | 366 ++++++++++++++++++++++++++++++++++

I don't think this needs it's own, brand new file.  You can just as
easy slot the enablement into max77686, which I suggest you do.

>  include/linux/mfd/max77802-private.h | 307 +++++++++++++++++++++++++++++
>  include/linux/mfd/max77802.h         | 121 ++++++++++++
>  5 files changed, 809 insertions(+)
>  create mode 100644 drivers/mfd/max77802.c
>  create mode 100644 include/linux/mfd/max77802-private.h
>  create mode 100644 include/linux/mfd/max77802.h

[...]

> +#ifdef CONFIG_OF
> +static struct of_device_id max77802_pmic_dt_match[] = {
> +	{.compatible = "maxim,max77802", .data = NULL},

Space before .compatible.

No need to set .data to NULL, just omit it.

> +	{},
> +};
> +
> +static void max77802_dt_parse_dvs_gpio(struct device *dev,
> +				       struct max77802_platform_data *pd,
> +				       struct device_node *np)

No need to overload these parameters by passing np, you can extract it
from dev.  Same goes for pd if you populate platform_data _before_
calling this function.

> +{
> +	int i;
> +
> +	/*
> +	 * NOTE: we don't consider GPIO errors fatal; board may have some lines
> +	 * directly pulled high or low and thus doesn't specify them.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_dvs); i++)
> +		pd->buck_gpio_dvs[i] =
> +			devm_gpiod_get_index(dev, "max77802,pmic-buck-dvs", i);
> +
> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++)
> +		pd->buck_gpio_selb[i] =
> +			devm_gpiod_get_index(dev, "max77802,pmic-buck-selb", i);
> +}
> +
> +static struct max77802_platform_data *max77802_i2c_parse_dt_pdata(struct device
> +								  *dev)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct max77802_platform_data *pd;
> +
> +	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> +	if (!pd)
> +		return NULL;
> +
> +	/* Read default index and ignore errors, since default is 0 */
> +	of_property_read_u32(np, "max77802,pmic-buck-default-dvs-idx",
> +			     &pd->buck_default_idx);
> +
> +	max77802_dt_parse_dvs_gpio(dev, pd, np);
> +
> +	dev->platform_data = pd;
> +	return pd;
> +}
> +#else
> +static struct max77802_platform_data *max77802_i2c_parse_dt_pdata(struct device
> +								  *dev)
> +{
> +	return 0;
> +}
> +#endif

No need for dummy functions.

Use if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node) instead.

> +static int max77802_i2c_probe(struct i2c_client *i2c,
> +			      const struct i2c_device_id *id)
> +{
> +	struct max77802_dev *max77802 = NULL;
> +	struct max77802_platform_data *pdata = dev_get_platdata(&i2c->dev);
> +	unsigned int data;
> +	int ret = 0;
> +
> +	if (i2c->dev.of_node)
> +		pdata = max77802_i2c_parse_dt_pdata(&i2c->dev);

DT should not over-rule platform data.  If the driver supports pdata
and it's present, it should over-rule DT.

> +	if (!pdata) {
> +		dev_err(&i2c->dev, "No platform data found.\n");
> +		return -EIO;

-EIO is not the correct error code here.  Either -EINVAL or -ENODEV
would be better.

> +	}
> +
> +	max77802 = devm_kzalloc(&i2c->dev, sizeof(struct max77802_dev),
> +				GFP_KERNEL);
> +	if (max77802 == NULL)

if (!max77802)

> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, max77802);
> +
> +	max77802->dev = &i2c->dev;
> +	max77802->i2c = i2c;
> +	max77802->type = id->driver_data;
> +
> +	max77802->wakeup = pdata->wakeup;
> +	max77802->irq = i2c->irq;
> +
> +	max77802->regmap = devm_regmap_init_i2c(i2c, &max77802_regmap_config);
> +	if (IS_ERR(max77802->regmap)) {
> +		ret = PTR_ERR(max77802->regmap);
> +		dev_err(max77802->dev, "Failed to allocate register map: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	if (regmap_read(max77802->regmap,
> +			 MAX77802_REG_DEVICE_ID, &data) < 0) {
> +		dev_err(max77802->dev,
> +			"device not found on this channel\n");
> +		return -ENODEV;
> +	}

The return values for all other calls are first placed into a variable
and _then_ evaluated.  For consistency can you do the same here
please?

> +	ret = regmap_add_irq_chip(max77802->regmap, max77802->irq,
> +				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
> +				  IRQF_SHARED, 0, &max77802_irq_chip,
> +				  &max77802->irq_data);
> +	if (ret != 0) {

if (ret)

> +		dev_err(&i2c->dev, "failed to add PMIC irq chip: %d\n", ret);
> +		return ret;
> +	}

'\n'

[...]

> +static struct i2c_driver max77802_i2c_driver = {
> +	.driver = {
> +		   .name = "max77802",
> +		   .owner = THIS_MODULE,
> +		   .pm = &max77802_pm,
> +		   .of_match_table = of_match_ptr(max77802_pmic_dt_match),

This tabbing is off.

> +	},
> +	.probe = max77802_i2c_probe,
> +	.remove = max77802_i2c_remove,
> +	.id_table = max77802_i2c_id,
> +};
> +
> +static int __init max77802_i2c_init(void)
> +{
> +	return i2c_add_driver(&max77802_i2c_driver);
> +}
> +/* init early so consumer devices can complete system boot */
> +subsys_initcall(max77802_i2c_init);
> +
> +static void __exit max77802_i2c_exit(void)
> +{
> +	i2c_del_driver(&max77802_i2c_driver);
> +}
> +module_exit(max77802_i2c_exit);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
