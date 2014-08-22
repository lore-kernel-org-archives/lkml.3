Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaHVQWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:22:07 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54291 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbaHVQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:22:04 -0400
Date: Fri, 22 Aug 2014 09:21:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v3 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140822162133.GB12900@core.coreip.homeip.net>
References: <1408627817-16171-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408627817-16171-1-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Thu, Aug 21, 2014 at 09:30:17PM +0800, Chris Zhong wrote:
> The RK808 chip is a power management IC for multimedia and handheld
> devices. It contains the following components:
> 
> - Regulators
> - RTC
> 
> The rk808 core driver is registered as a platform driver and provides
> communication through I2C with the host device for the different
> components.
> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> 
> ---
> 
> Changes in v3: None
> Changes in v2:
> Adviced by Mark Browm:
> - change of_find_node_by_name to find_child_by_name
> - use RK808_NUM_REGULATORS as the name of the constant
> - create a pdata when missing platform data
> - use the rk808_reg name to supply_regulator name
> - replace regulator_register with devm_regulator_register
> - some other problem with coding style
> 
>  drivers/mfd/Kconfig       |   13 ++
>  drivers/mfd/Makefile      |    1 +
>  drivers/mfd/rk808.c       |  296 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/rk808.h |  220 +++++++++++++++++++++++++++++++++
>  4 files changed, 530 insertions(+)
>  create mode 100644 drivers/mfd/rk808.c
>  create mode 100644 include/linux/mfd/rk808.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index de5abf2..1df133e 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -582,6 +582,19 @@ config MFD_RC5T583
>  	  Additional drivers must be enabled in order to use the
>  	  different functionality of the device.
>  
> +config MFD_RK808
> +	tristate "Rockchip RK808 Power Management chip"
> +	depends on I2C
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	select REGMAP_IRQ
> +	help
> +	  Select this option to get support for the RK808 Power
> +	  Management system device.
> +	  This driver provides common support for accessing the device
> +	  through i2c interface. The device supports multiple sub-devices
> +	  like interrupts, RTC, LDO and DCDC regulators, onkey.
> +
>  config MFD_SEC_CORE
>  	bool "SAMSUNG Electronics PMIC Series Support"
>  	depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f001487..dbc28e7 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -160,6 +160,7 @@ obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
>  obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
>  obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
>  obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
> +obj-$(CONFIG_MFD_RK808)		+= rk808.o
>  obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
>  obj-$(CONFIG_MFD_SYSCON)	+= syscon.o
>  obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
> diff --git a/drivers/mfd/rk808.c b/drivers/mfd/rk808.c
> new file mode 100644
> index 0000000..372e5ed
> --- /dev/null
> +++ b/drivers/mfd/rk808.c
> @@ -0,0 +1,296 @@
> +/*
> + * Mfd core driver for Rockchip RK808
> + *
> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * Author: Chris Zhong <zyw@rock-chips.com>
> + * Author: Zhang Qing <zhangqing@rock-chips.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + */
> +
> +#include <linux/bug.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/rk808.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/of_regulator.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +
> +struct rk808_reg_data {
> +	int addr;
> +	int mask;
> +	int value;
> +};
> +
> +static struct rk808 *g_rk808;
> +
> +static struct resource rtc_resources[] = {
> +	{
> +		.start  = RK808_IRQ_RTC_ALARM,
> +		.end    = RK808_IRQ_RTC_ALARM,
> +		.flags  = IORESOURCE_IRQ,
> +	}
> +};
> +
> +static const struct mfd_cell rk808s[] = {
> +	{
> +		.name = "rk808-regulator",
> +	},
> +	{
> +		.name = "rk808-rtc",
> +		.num_resources = ARRAY_SIZE(rtc_resources),
> +		.resources = &rtc_resources[0],
> +	},
> +	{
> +		.name = "rk808-clkout",
> +	},
> +};
> +
> +static const struct rk808_reg_data pre_init_reg[] = {
> +	{RK808_BUCK3_CONFIG_REG, BUCK_ILMIN_MASK, BUCK_ILMIN_150MA},
> +	{RK808_BUCK4_CONFIG_REG, BUCK_ILMIN_MASK, BUCK_ILMIN_200MA},
> +	{RK808_BOOST_CONFIG_REG, BOOST_ILMIN_MASK, BOOST_ILMIN_100MA},
> +	{RK808_BUCK1_CONFIG_REG, BUCK1_RATE_MASK,  BUCK_ILMIN_200MA},
> +	{RK808_BUCK2_CONFIG_REG, BUCK2_RATE_MASK,  BUCK_ILMIN_200MA},
> +	{RK808_VB_MON_REG,       MASK_ALL,  VB_LO_ACT | VB_LO_SEL_3500MV},
> +	{RK808_INT_STS_REG1,     MASK_NONE, 0},
> +	{RK808_INT_STS_REG2,     MASK_NONE, 0},
> +};
> +
> +static const struct regmap_irq rk808_irqs[] = {
> +	/* INT_STS */
> +	[RK808_IRQ_VOUT_LO] = {
> +		.mask = RK808_IRQ_VOUT_LO_MSK,
> +		.reg_offset = 0,
> +	},
> +	[RK808_IRQ_VB_LO] = {
> +		.mask = RK808_IRQ_VB_LO_MSK,
> +		.reg_offset = 0,
> +	},
> +	[RK808_IRQ_PWRON] = {
> +		.mask = RK808_IRQ_PWRON_MSK,
> +		.reg_offset = 0,
> +	},
> +	[RK808_IRQ_PWRON_LP] = {
> +		.mask = RK808_IRQ_PWRON_LP_MSK,
> +		.reg_offset = 0,
> +	},
> +	[RK808_IRQ_HOTDIE] = {
> +		.mask = RK808_IRQ_HOTDIE_MSK,
> +		.reg_offset = 0,
> +	},
> +	[RK808_IRQ_RTC_ALARM] = {
> +		.mask = RK808_IRQ_RTC_ALARM_MSK,
> +		.reg_offset = 0,
> +	},
> +	[RK808_IRQ_RTC_PERIOD] = {
> +		.mask = RK808_IRQ_RTC_PERIOD_MSK,
> +		.reg_offset = 0,
> +	},
> +
> +	/* INT_STS2 */
> +	[RK808_IRQ_PLUG_IN_INT] = {
> +		.mask = RK808_IRQ_PLUG_IN_INT_MSK,
> +		.reg_offset = 1,
> +	},
> +	[RK808_IRQ_PLUG_OUT_INT] = {
> +		.mask = RK808_IRQ_PLUG_OUT_INT_MSK,
> +		.reg_offset = 1,
> +	},
> +};
> +
> +static struct regmap_irq_chip rk808_irq_chip = {
> +	.name = "rk808",
> +	.irqs = rk808_irqs,
> +	.num_irqs = ARRAY_SIZE(rk808_irqs),
> +	.num_regs = 2,
> +	.irq_reg_stride = 2,
> +	.status_base = RK808_INT_STS_REG1,
> +	.mask_base = RK808_INT_STS_MSK_REG1,
> +	.ack_base = RK808_INT_STS_REG1,
> +};
> +
> +static struct rk808_board *rk808_parse_dt(struct device *dev)
> +{
> +	struct rk808_board *pdata;
> +	struct device_node *np = dev->of_node;
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return NULL;

This should be

		return ERR_PTR(-ENOMEM);

> +
> +	pdata->pm_off = of_property_read_bool(np,
> +					"rockchip,system-power-controller");
> +
> +	return pdata;
> +}
> +
> +static void rk808_device_shutdown(void)
> +{
> +	int ret;
> +	struct rk808 *rk808 = g_rk808;
> +
> +	if (!rk808) {
> +		dev_err(rk808->dev, "%s have no g_rk808\n", __func__);
> +		return;
> +	}
> +
> +	ret = regmap_update_bits(rk808->regmap,
> +				 RK808_DEVCTRL_REG,
> +				 DEV_OFF_RST, DEV_OFF_RST);
> +	if (ret < 0)
> +		dev_err(rk808->dev, "rk808 power off error!\n");
> +}
> +
> +static int rk808_pre_init(struct rk808 *rk808)
> +{
> +	int i;
> +	int ret = 0;
> +	int table_size = sizeof(pre_init_reg) / sizeof(struct rk808_reg_data);
> +
> +	for (i = 0; i < table_size; i++) {
> +		ret = regmap_update_bits(rk808->regmap, pre_init_reg[i].addr,
> +					 pre_init_reg[i].mask,
> +					 pre_init_reg[i].value);
> +		if (ret < 0) {
> +			dev_err(rk808->dev,
> +				"0x%x write err\n", pre_init_reg[i].addr);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int rk808_probe(struct i2c_client *client,
> +		       const struct i2c_device_id *id)
> +{
> +	int ret;
> +	struct rk808_board *pdata = dev_get_platdata(&client->dev);
> +	struct rk808 *rk808;
> +
> +	if (!pdata) {
> +		pdata = rk808_parse_dt(&client->dev);
> +		if (IS_ERR(pdata))
> +			return PTR_ERR(pdata);
> +	}
> +
> +	rk808 = devm_kzalloc(&client->dev, sizeof(struct rk808), GFP_KERNEL);
> +	if (!rk808)
> +		return -ENOMEM;
> +
> +	rk808->pdata = pdata;
> +	rk808->i2c = client;
> +	rk808->dev = &client->dev;
> +	i2c_set_clientdata(client, rk808);
> +
> +	rk808->regmap = devm_regmap_init_i2c(client, &rk808_regmap_config);
> +	if (IS_ERR(rk808->regmap)) {
> +		ret = PTR_ERR(rk808->regmap);
> +		dev_err(rk808->dev, "regmap initialization failed\n");
> +		return ret;
> +	}
> +
> +	ret = rk808_pre_init(rk808);
> +	if (ret < 0) {
> +		dev_err(rk808->dev, "The rk808_pre_init failed %d\n", ret);
> +		return ret;
> +	}
> +
> +	pdata->irq = client->irq;
> +	pdata->irq_base = -1;

Hmm, the platform data should really be read-only so that if you happen to
unbind and rebind the driver we would start with the same state.

> +
> +	if (!pdata->irq) {
> +		dev_err(rk808->dev, "No interrupt support, no core IRQ\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = regmap_add_irq_chip(rk808->regmap, pdata->irq,
> +				  IRQF_ONESHOT, pdata->irq_base,
> +				  &rk808_irq_chip, &rk808->irq_data);
> +	if (ret < 0) {
> +		dev_err(rk808->dev, "Failed to add irq_chip %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = mfd_add_devices(rk808->dev, -1,
> +			      rk808s, ARRAY_SIZE(rk808s),
> +			      NULL, 0, regmap_irq_get_domain(rk808->irq_data));
> +	if (ret < 0) {
> +		dev_err(rk808->dev, "failed to add MFD devices %d\n", ret);
> +		goto err_irq_init_done;
> +	}
> +
> +	g_rk808 = rk808;
> +	if (pdata->pm_off && !pm_power_off)
> +		pm_power_off = rk808_device_shutdown;
> +
> +	return 0;
> +
> +err_irq_init_done:
> +	regmap_del_irq_chip(pdata->irq, rk808->irq_data);
> +	return ret;
> +}
> +
> +static int rk808_remove(struct i2c_client *i2c)
> +{
> +	struct rk808 *rk808 = i2c_get_clientdata(i2c);
> +	struct rk808_board *pdata = rk808->pdata;
> +
> +	regmap_del_irq_chip(pdata->irq, rk808->irq_data);
> +	mfd_remove_devices(rk808->dev);

Should we undo pm_power_off assignment.

> +	return 0;
> +}
> +
> +static struct of_device_id rk808_of_match[] = {
> +	{ .compatible = "rockchip,rk808"},

Could you throw in a space before '}' please?

> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, rk808_of_match);
> +
> +static const struct i2c_device_id rk808_ids[] = {
> +	 { "rk808", 0},

And here as well.

Thanks.

-- 
Dmitry
