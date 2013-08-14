Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159Ab3HNRmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:42:36 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:41294 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760087Ab3HNRmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:42:35 -0400
Date: Wed, 14 Aug 2013 18:42:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chao Xie <chao.xie@marvell.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        xiechao.mail@gmail.com
Subject: Re: [PATCH 3/4] mfd: 88pm800: add device tree support
Message-ID: <20130814174227.GI4046@lee--X1>
References: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
 <1376468930-9794-4-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376468930-9794-4-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You need to Cc:  devicetree@vger.kernel.org

Please insert a commit log.

> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  Documentation/devicetree/bindings/mfd/88pm800.c |   55 +++++++++++++++++++++++
>  drivers/mfd/88pm800.c                           |   55 +++++++++++++++++++++++
>  2 files changed, 110 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/88pm800.c
> 
> diff --git a/Documentation/devicetree/bindings/mfd/88pm800.c b/Documentation/devicetree/bindings/mfd/88pm800.c
> new file mode 100644
> index 0000000..2299752
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/88pm800.c
> @@ -0,0 +1,55 @@
> +* Marvell 88PM800 Power Management IC
> +
> +Required parent device properties:
> +- compatible : "marvell,88pm800"
> +- reg : the I2C slave address for the 88pm800 chip
> +- interrupts : IRQ line for the 88pm800 chip
> +- interrupt-controller: describes the 88pm800 as an interrupt controller (has its own domain)

You don't need "(has its own domain)", as this is expected.

> +- #interrupt-cells : should be 1.
> +		- The cell is the 88pm800 local IRQ number

No need for the last line.

> +Optional parent device properties:
> +- marvell,88pm800-irq-write-clear: inicates whether interrupt status is cleared by write
> +- marvell,88pm800-battery-detection: indicats whether need 88pm800 to support battery
> +				detection or not.

Not sure what these are. This is why you need to CC the Device Tree
guys.

> +88pm800 consists of a large and varied group of sub-devices:

Really? Or just 3?

> +Device			 Supply Names	 Description
> +------			 ------------	 -----------
> +88pm80x-onkey		:		: On key
> +88pm80x-rtc		:		: RTC
> +88pm80x-regulator	:		: Regulators

If more than 3 please list them.

> +Example:
> +
> +	pmic: 88pm800@30 {
> +		compatible = "marvell,88pm800";
> +		reg = <0x30>;
> +		interrupts = <0 4 0x4>;

Use the defines in include/dt-bindings.

> +		interrupt-parent = <&gic>;
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +
> +		marvell,88pm800-irq-write-clr;
> +
> +		regulators {
> +			compatible = "marvell,88pm80x-regulator";
> +
> +			BUCK1 {
> +				regulator-min-microvolt = <600000>;
> +				regulator-max-microvolt = <3950000>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +			LDO1 {
> +				regulator-min-microvolt = <600000>;
> +				regulator-max-microvolt = <3950000>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +		};
> +		rtc {
> +			compatible = "marvell,88pm80x-rtc";
> +		};
> +	};
> diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
> index d4d272f..07a24e2 100644
> --- a/drivers/mfd/88pm800.c
> +++ b/drivers/mfd/88pm800.c
> @@ -27,6 +27,7 @@
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/88pm80x.h>
>  #include <linux/slab.h>
> +#include <linux/of_device.h>
>  
>  /* Interrupt Registers */
>  #define PM800_INT_STATUS1		(0x05)
> @@ -121,6 +122,12 @@ static const struct i2c_device_id pm80x_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, pm80x_id_table);
>  
> +static const struct of_device_id pm80x_dt_ids[] = {
> +	{ .compatible = "marvell,88pm800", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, pm80x_dt_ids);
> +
>  static struct resource rtc_resources[] = {
>  	{
>  	 .name = "88pm80x-rtc",
> @@ -133,6 +140,7 @@ static struct resource rtc_resources[] = {
>  static struct mfd_cell rtc_devs[] = {
>  	{
>  	 .name = "88pm80x-rtc",
> +	 .of_compatible = "marvell,88pm80x-rtc",
>  	 .num_resources = ARRAY_SIZE(rtc_resources),
>  	 .resources = &rtc_resources[0],
>  	 .id = -1,
> @@ -151,6 +159,7 @@ static struct resource onkey_resources[] = {
>  static struct mfd_cell onkey_devs[] = {
>  	{
>  	 .name = "88pm80x-onkey",
> +	 .of_compatible = "marvell,88pm80x-onkey",
>  	 .num_resources = 1,
>  	 .resources = &onkey_resources[0],
>  	 .id = -1,
> @@ -160,6 +169,7 @@ static struct mfd_cell onkey_devs[] = {
>  static struct mfd_cell regulator_devs[] = {
>  	{
>  	 .name = "88pm80x-regulator",
> +	 .of_compatible = "marvell,88pm80x-regulator",
>  	 .id = -1,
>  	},
>  };
> @@ -538,14 +548,58 @@ out:
>  	return ret;
>  }
>  
> +static int pm800_dt_init(struct device_node *np,
> +			 struct device *dev,
> +			 struct pm80x_platform_data *pdata)
> +{
> +	pdata->irq_mode =
> +		!of_property_read_bool(np, "marvell,88pm800-irq-write-clear");
> +	pdata->batt_det =
> +		of_property_read_bool(np, "marvell,88pm800-battery-detection");
> +
> +	return 0;
> +}
> +
> +

Why two /n's?

>  static int pm800_probe(struct i2c_client *client,
>  				 const struct i2c_device_id *id)
>  {
>  	int ret = 0;
>  	struct pm80x_chip *chip;
>  	struct pm80x_platform_data *pdata = client->dev.platform_data;
> +	struct device_node *node = client->dev.of_node;
>  	struct pm80x_subchip *subchip;
>  
> +	if (IS_ENABLED(CONFIG_OF)) {
> +		if (!pdata) {
> +			pdata = devm_kzalloc(&client->dev,
> +					     sizeof(*pdata), GFP_KERNEL);
> +			if (!pdata)
> +				return -ENOMEM;
> +		}
> +		ret = pm800_dt_init(node, &client->dev, pdata);
> +		if (ret)
> +			return ret;
> +	} else if (!pdata) {
> +		return -EINVAL;
> +	}

Replace with:

        if (!pdata) {
                if (node)
                        /* <blah> populate pdata with DT </blah> */
                else
                        return -EINVAL;
        }

> +	/*
> +	 * RTC in pmic can run even the core is powered off, and user can set
> +	 * alarm in RTC. When the alarm is time out, the PMIC will power up
> +	 * the core, and the whole system will boot up. When PMIC driver is
> +	 * probed, it will read out some register to find out whether this
> +	 * boot is caused by RTC timeout or not, and it need pass this
> +	 * information to RTC driver.
> +	 * So we need rtc platform data to be existed to pass this information.
> +	 */
> +	if (!pdata->rtc) {
> +		pdata->rtc = devm_kzalloc(&client->dev,
> +					  sizeof(*(pdata->rtc)), GFP_KERNEL);
> +		if (!pdata->rtc)
> +			return -ENOMEM;
> +	}
> +
>  	ret = pm80x_init(client);
>  	if (ret) {
>  		dev_err(&client->dev, "pm800_init fail\n");
> @@ -612,6 +666,7 @@ static struct i2c_driver pm800_driver = {
>  		.name = "88PM800",
>  		.owner = THIS_MODULE,
>  		.pm = &pm80x_pm_ops,
> +		.of_match_table	= of_match_ptr(pm80x_dt_ids),
>  		},
>  	.probe = pm800_probe,
>  	.remove = pm800_remove,

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
