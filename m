Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaEVIh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:37:26 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:50719 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaEVIhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:37:18 -0400
Date: Thu, 22 May 2014 09:37:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: devicetree@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        sameo@linux.intel.com, grant.likely@linaro.org, ian@slimlogic.co.uk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@linaro.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mfd: tps65917: Add driver for the TPS65917 PMIC
Message-ID: <20140522083707.GM6679@lee--X1>
References: <1400731239-3180-1-git-send-email-j-keerthy@ti.com>
 <1400731239-3180-4-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400731239-3180-4-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The TPS65917 chip is a power management IC for Portable Navigation Systems
> and Tablet Computing devices. It contains the following components:
> 
>  - Regulators.
>  - Over Temperature warning and Shut down.
> 
> This patch adds support for tps65917 mfd device. At this time only
> the regulator functionality is made available.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
> v3 Changes:
> 
>  * Header file formating
>  * Changed the cache_type to REGCACHE_RBTREE
>  * removed unnecessary code
>  * Corrected documentation style
>  * Added pm_power_off function
> 
>  v2 Changes:
> 
>  * Added volatile register check as some of the registers
>    in the set are volatile. 
>  
> drivers/mfd/Kconfig          |   12 +
>  drivers/mfd/Makefile         |    1 +
>  drivers/mfd/tps65917.c       |  594 +++++++++++++++++
>  include/linux/mfd/tps65917.h | 1485 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 2092 insertions(+)
>  create mode 100644 drivers/mfd/tps65917.c
>  create mode 100644 include/linux/mfd/tps65917.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3383412..4c0d051 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -925,6 +925,18 @@ config MFD_TPS65912_SPI
>  	  If you say yes here you get support for the TPS65912 series of
>  	  PM chips with SPI interface.
>  

> +#include <linux/module.h>
> +#include <linux/moduleparam.h>

What are you using this for?

> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/regmap.h>
> +#include <linux/err.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/tps65917.h>
> +#include <linux/of_device.h>
> +
> +#define TPS65917_EXT_REQ (TPS65917_EXT_CONTROL_ENABLE1 |	\
> +			TPS65917_EXT_CONTROL_ENABLE2 |	\
> +			TPS65917_EXT_CONTROL_NSLEEP)
> +
> +struct tps65917_sleep_requestor_info {
> +	int id;

Do you need this in here, or at all?

> +	int reg_offset;
> +	int bit_pos;
> +};
> +
> +#define EXTERNAL_REQUESTOR(_id, _offset, _pos)		\
> +		[TPS65917_EXTERNAL_REQSTR_ID_##_id] = {		\
> +		.id = TPS65917_EXTERNAL_REQSTR_ID_##_id,	\
> +		.reg_offset = _offset,			\
> +		.bit_pos = _pos,			\
> +	}
> +
> +static struct tps65917_sleep_requestor_info sleep_req_info[] = {
> +	EXTERNAL_REQUESTOR(REGEN1, 0, 0),
> +	EXTERNAL_REQUESTOR(REGEN2, 0, 1),
> +	EXTERNAL_REQUESTOR(REGEN3, 0, 6),
> +	EXTERNAL_REQUESTOR(SMPS1, 1, 0),
> +	EXTERNAL_REQUESTOR(SMPS2, 1, 1),
> +	EXTERNAL_REQUESTOR(SMPS3, 1, 2),
> +	EXTERNAL_REQUESTOR(SMPS4, 1, 3),
> +	EXTERNAL_REQUESTOR(SMPS5, 1, 4),
> +	EXTERNAL_REQUESTOR(LDO1, 2, 0),
> +	EXTERNAL_REQUESTOR(LDO2, 2, 1),
> +	EXTERNAL_REQUESTOR(LDO3, 2, 2),
> +	EXTERNAL_REQUESTOR(LDO4, 2, 3),
> +	EXTERNAL_REQUESTOR(LDO5, 2, 4),
> +};
> +
> +static int tps65917_voltaile_regs[] = {
> +	TPS65917_SMPS1_CTRL,
> +	TPS65917_SMPS2_CTRL,
> +	TPS65917_SMPS3_CTRL,
> +	TPS65917_SMPS4_CTRL,
> +	TPS65917_SMPS5_CTRL,
> +	TPS65917_LDO1_CTRL,
> +	TPS65917_LDO2_CTRL,
> +	TPS65917_LDO3_CTRL,
> +	TPS65917_LDO4_CTRL,
> +	TPS65917_LDO5_CTRL,
> +};
> +
> +static bool is_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	int i;
> +
> +	/*
> +	 * Caching all the required regulator registers.
> +	 */

Not sure this comment is helpful.

> +	for (i = 0; i < ARRAY_SIZE(tps65917_voltaile_regs); i++)
> +		if (reg == tps65917_voltaile_regs[i])
> +			return true;
> +
> +	return false;
> +}

[...]

> +int tps65917_ext_control_req_config(struct tps65917 *tps65917,
> +				    enum tps65917_external_requestor_id id,
> +				    int ext_ctrl, bool enable)
> +{
> +	int preq_mask_bit = 0;
> +	int reg_add = 0;
> +	int bit_pos;
> +	int ret;
> +
> +	if (!(ext_ctrl & TPS65917_EXT_REQ))
> +		return 0;
> +
> +	if (id >= TPS65917_EXTERNAL_REQSTR_ID_MAX)
> +		return 0;
> +
> +	if (ext_ctrl & TPS65917_EXT_CONTROL_NSLEEP) {
> +		reg_add = TPS65917_NSLEEP_RES_ASSIGN;
> +		preq_mask_bit = 0;
> +	} else if (ext_ctrl & TPS65917_EXT_CONTROL_ENABLE1) {
> +		reg_add = TPS65917_ENABLE1_RES_ASSIGN;
> +		preq_mask_bit = 1;
> +	} else if (ext_ctrl & TPS65917_EXT_CONTROL_ENABLE2) {
> +		reg_add = TPS65917_ENABLE2_RES_ASSIGN;
> +		preq_mask_bit = 2;
> +	}
> +
> +	bit_pos = sleep_req_info[id].bit_pos;
> +	reg_add += sleep_req_info[id].reg_offset;
> +	ret = tps65917_update_bits(tps65917, TPS65917_RESOURCE_BASE,
> +				   reg_add, BIT(bit_pos),
> +				   enable ? BIT(bit_pos) : 0);
> +

Nit: Remove this line.

> +	if (ret < 0) {

Just 'if (ret)' will do here.

> +		dev_err(tps65917->dev, "Resource reg 0x%02x update failed %d\n",
> +			reg_add, ret);
> +		return ret;
> +	}
> +
> +	/* Unmask the PREQ */
> +	ret = tps65917_update_bits(tps65917, TPS65917_PMU_CONTROL_BASE,
> +				   TPS65917_POWER_CTRL, BIT(preq_mask_bit), 0);
> +
> +	if (ret < 0)

And here. And everywhere else you check for <0 from *_update_bits.

> +		dev_err(tps65917->dev, "POWER_CTRL register update failed %d\n",
> +			ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tps65917_ext_control_req_config);
> +
> +static void tps65917_set_pdata_irq_flag(struct i2c_client *i2c,
> +				       struct tps65917_platform_data *pdata)
> +{
> +	struct irq_data *irq_data = irq_get_irq_data(i2c->irq);
> +
> +	if (!irq_data)
> +		dev_warn(&i2c->dev, "Invalid IRQ: %d\n", i2c->irq);
> +
> +	pdata->irq_flags = irqd_get_trigger_type(irq_data);

This will break with a NULL dereference error if you don't return
after the dev_warn().

> +}
> +
> +static void tps65917_dt_to_pdata(struct i2c_client *i2c,
> +				 struct tps65917_platform_data *pdata)
> +{
> +	struct device_node *np = i2c->dev.of_node;
> +	int ret;
> +	u32 prop;

I don't think this is a good name for the return value.  Prop to me
insinuates that more information that just the property value is
contained. See 'struct property' for reference.

> +	ret = of_property_read_u32(np, "ti,mux-pad1", &prop);
> +

Nit: Remove this line and all lines where there is a '\n' between a
call return and a check of the returned value.

> +	if (!ret) {
> +		pdata->mux_from_pdata = true;
> +		pdata->pad1 = prop;
> +	}
> +
> +	ret = of_property_read_u32(np, "ti,mux-pad2", &prop);
> +
> +	if (!ret) {
> +		pdata->mux_from_pdata = true;
> +		pdata->pad2 = prop;
> +	}

What happens if ti,mux-pad1 returns okay and this one fails?  Will it
matter that we'll write pdata->pad2 anyway?

> +	/* The default for this register is all masked */
> +	ret = of_property_read_u32(np, "ti,power-ctrl", &prop);
> +

Nit: Remove this line.

> +	if (!ret)
> +		pdata->power_ctrl = prop;
> +	else
> +		pdata->power_ctrl = TPS65917_POWER_CTRL_NSLEEP_MASK |
> +					TPS65917_POWER_CTRL_ENABLE1_MASK |
> +					TPS65917_POWER_CTRL_ENABLE2_MASK;
> +
> +	tps65917_set_pdata_irq_flag(i2c, pdata);
> +
> +	pdata->pm_off = of_property_read_bool(np,
> +			"ti,system-power-controller");
> +}
> +
> +static struct tps65917 *tps65917_dev;
> +
> +static void tps65917_power_off(void)
> +{
> +	int ret;
> +
> +	if (!tps65917_dev)
> +		return;
> +
> +	ret = tps65917_update_bits(tps65917_dev, TPS65917_PMU_CONTROL_BASE,
> +				   TPS65917_DEV_CTRL,
> +				   TPS65917_DEV_CTRL_DEV_ON, 0);
> +
> +	if (ret)
> +		pr_err("%s: Unable to write to DEV_CTRL_DEV_ON: %d\n",
> +		       __func__, ret);
> +}
> +
> +static const struct of_device_id of_tps65917_match_tbl[] = {
> +	{.compatible = "ti,tps65917",},

Nonstandard formatting here, space after '{' and before '}' please.

> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_tps65917_match_tbl);
> +
> +static int tps65917_i2c_probe(struct i2c_client *i2c,
> +			      const struct i2c_device_id *id)
> +{
> +	struct tps65917 *tps65917;
> +	struct tps65917_platform_data *pdata;
> +	struct device_node *node = i2c->dev.of_node;
> +	int ret = 0, i, slave;
> +	unsigned int reg, addr;
> +	const struct of_device_id *match;
> +
> +	pdata = dev_get_platdata(&i2c->dev);
> +
> +	if (node && !pdata) {
> +		pdata = devm_kzalloc(&i2c->dev, sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata)
> +			return -ENOMEM;
> +
> +		tps65917_dt_to_pdata(i2c, pdata);
> +	}
> +
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	tps65917 = devm_kzalloc(&i2c->dev, sizeof(struct tps65917), GFP_KERNEL);
> +	if (!tps65917)
> +		return -ENOMEM;
> +
> +	tps65917->dev = &i2c->dev;
> +	tps65917->irq = i2c->irq;
> +
> +	match = of_match_device(of_tps65917_match_tbl, &i2c->dev);
> +	if (!match)
> +		return -ENODATA;
> +
> +	i2c_set_clientdata(i2c, tps65917);
> +
> +	for (i = 0; i < TPS65917_NUM_CLIENTS; i++) {
> +		if (i == 0) {
> +			tps65917->i2c_clients[i] = i2c;

This is messy.  Move this line out of the loop and change the loop
parameters to start from 1.  Then we can reduce all of this
unnecessary indentation.

> +		} else {
> +			tps65917->i2c_clients[i] =
> +					i2c_new_dummy(i2c->adapter,
> +						      i2c->addr + i);
> +			if (!tps65917->i2c_clients[i]) {
> +				dev_err(tps65917->dev,
> +					"can't attach client %d\n", i);
> +				ret = -ENOMEM;
> +				goto err_i2c;
> +			}
> +
> +			tps65917->i2c_clients[i]->dev.of_node = of_node_get(node);

Don't forget to decrement the reference when you've finished with it.

> +		}
> +
> +		tps65917->regmap[i] = devm_regmap_init_i2c(tps65917->i2c_clients[i],
> +							   &tps65917_regmap_config[i]);
> +
> +		if (IS_ERR(tps65917->regmap[i])) {
> +			ret = PTR_ERR(tps65917->regmap[i]);
> +			dev_err(tps65917->dev,
> +				"Failed to allocate regmap %d, err: %d\n",
> +				i, ret);
> +			goto err_i2c;
> +		}
> +	}
> +
> +	if (!tps65917->irq) {
> +		dev_warn(tps65917->dev, "IRQ missing: skipping irq request\n");
> +		goto no_irq;
> +	}

Can this thing work without an IRQ?

> +	/* Change interrupt line output polarity */
> +	if (pdata->irq_flags & IRQ_TYPE_LEVEL_HIGH) {
> +		reg = TPS65917_POLARITY_CTRL_INT_POLARITY;
> +		ret = tps65917_update_bits(tps65917, TPS65917_PU_PD_OD_BASE,
> +					   TPS65917_POLARITY_CTRL,
> +					   TPS65917_POLARITY_CTRL_INT_POLARITY,
> +					   reg);
> +	}
> +
> +	if (ret < 0) {

Just 'if (ret)' will do here.

> +		dev_err(tps65917->dev, "POLARITY_CTRL updat failed: %d\n", ret);
> +		goto err_i2c;
> +	}
> +
> +	/* Change IRQ into clear on read mode for efficiency */
> +	slave = TPS65917_BASE_TO_SLAVE(TPS65917_INTERRUPT_BASE);
> +	addr = TPS65917_BASE_TO_REG(TPS65917_INTERRUPT_BASE, TPS65917_INT_CTRL);
> +	reg = TPS65917_INT_CTRL_INT_CLEAR;
> +
> +	regmap_write(tps65917->regmap[slave], addr, reg);
> +
> +	ret = regmap_add_irq_chip(tps65917->regmap[slave], tps65917->irq,
> +				  IRQF_ONESHOT | pdata->irq_flags, 0,
> +				  &tps65917_irq_chip,
> +				  &tps65917->irq_data);
> +	if (ret < 0)
> +		goto err_i2c;
> +
> +no_irq:
> +
> +	/*
> +	 * Read the values provided by the DT entries
> +	 * and program the corresponding values to set
> +	 * the secondary function or primary function of the PAD.
> +	 */
> +	slave = TPS65917_BASE_TO_SLAVE(TPS65917_PU_PD_OD_BASE);
> +	addr = TPS65917_BASE_TO_REG(TPS65917_PU_PD_OD_BASE,
> +				    TPS65917_PRIMARY_SECONDARY_PAD1);
> +
> +	if (pdata->mux_from_pdata) {
> +		reg = pdata->pad1;
> +		ret = regmap_write(tps65917->regmap[slave], addr, reg);
> +		if (ret)
> +			goto err_irq;
> +	} else {
> +		ret = regmap_read(tps65917->regmap[slave], addr, &reg);
> +		if (ret)
> +			goto err_irq;
> +	}

What does the read do?  You're not doing anything with the value.

> +	addr = TPS65917_BASE_TO_REG(TPS65917_PU_PD_OD_BASE,
> +				    TPS65917_PRIMARY_SECONDARY_PAD2);
> +
> +	if (pdata->mux_from_pdata) {

Why don't you just do 'if (pdata->pad2)', or if 0 is valid (I wonder
what the reset values are of these registers and if it's even relevant
to write 0?) then set pdata->pad2 to -1 when you do _not_ wish to set
it, then you can get rid of this awful Boolean check.

> +		reg = pdata->pad2;
> +		ret = regmap_write(tps65917->regmap[slave], addr, reg);
> +		if (ret)
> +			goto err_irq;
> +	} else {
> +		ret = regmap_read(tps65917->regmap[slave], addr, &reg);
> +		if (ret)
> +			goto err_irq;
> +	}
> +
> +	/*
> +	 * Program the value provided by the DT field
> +	 * to enable/disable the NSLEEP, ENABLE1, ENABLE2 signals
> +	 */
> +	reg = pdata->power_ctrl;
> +
> +	slave = TPS65917_BASE_TO_SLAVE(TPS65917_PMU_CONTROL_BASE);
> +	addr = TPS65917_BASE_TO_REG(TPS65917_PMU_CONTROL_BASE,
> +				    TPS65917_POWER_CTRL);
> +
> +	ret = regmap_write(tps65917->regmap[slave], addr, reg);
> +	if (ret)
> +		goto err_irq;
> +
> +	if (node) {
> +		ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
> +		if (ret < 0)
> +			goto err_irq;
> +		if (pdata->pm_off && !pm_power_off) {
> +			tps65917_dev = tps65917;
> +			pm_power_off = tps65917_power_off;
> +		}
> +	}

What happens if !node?  Then no children get registered and this has
all been a waste of time?

> +	return ret;

May as well just return 0 here.

> +err_irq:
> +	regmap_del_irq_chip(tps65917->irq, tps65917->irq_data);
> +err_i2c:
> +	for (i = 1; i < TPS65917_NUM_CLIENTS; i++) {
> +		if (tps65917->i2c_clients[i])
> +			i2c_unregister_device(tps65917->i2c_clients[i]);
> +	}
> +
> +	return ret;
> +}
> +
> +static int tps65917_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct tps65917 *tps65917 = i2c_get_clientdata(i2c);
> +	int i;
> +
> +	regmap_del_irq_chip(tps65917->irq, tps65917->irq_data);
> +
> +	for (i = 1; i < TPS65917_NUM_CLIENTS; i++) {
> +		if (tps65917->i2c_clients[i])
> +			i2c_unregister_device(tps65917->i2c_clients[i]);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id tps65917_i2c_id[] = {
> +	{ "tps65917", },
> +};
> +MODULE_DEVICE_TABLE(i2c, tps65917_i2c_id);
> +
> +static struct i2c_driver tps65917_i2c_driver = {
> +	.driver = {
> +		   .name = "tps65917",
> +		   .of_match_table = of_match_ptr(of_tps65917_match_tbl),
> +		   .owner = THIS_MODULE,
> +	},
> +	.probe = tps65917_i2c_probe,
> +	.remove = tps65917_i2c_remove,
> +	.id_table = tps65917_i2c_id,
> +};
> +
> +static int __init tps65917_i2c_init(void)
> +{
> +	return i2c_add_driver(&tps65917_i2c_driver);
> +}
> +/* init early so consumer devices can complete system boot */
> +subsys_initcall(tps65917_i2c_init);

How sure are you that you need this?  Why doens't -EPROBE_DEFER work
for you?

> +static void __exit tps65917_i2c_exit(void)
> +{
> +	i2c_del_driver(&tps65917_i2c_driver);
> +}
> +module_exit(tps65917_i2c_exit);
> +
> +MODULE_AUTHOR("J Keerthy <j-keerthy@ti.com>");
> +MODULE_DESCRIPTION("TPS65917 chip family Multi-Function Driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mfd/tps65917.h b/include/linux/mfd/tps65917.h
> new file mode 100644
> index 0000000..7fbb80a
> --- /dev/null
> +++ b/include/linux/mfd/tps65917.h
> @@ -0,0 +1,1485 @@
> +/*
> + * TI TPS65917
> + *
> + * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether expressed or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License version 2 for more details.
> + */
> +
> +#ifndef __LINUX_MFD_TPS65917_H
> +#define __LINUX_MFD_TPS65917_H
> +
> +#include <linux/regmap.h>
> +#include <linux/regulator/driver.h>
> +
> +#define TPS65917_NUM_CLIENTS		3
> +
> +/* The ID_REVISION NUMBERS */
> +#define TPS65917_CHIP_ID			0xC035
> +#define TPS65917_RESERVED			-1
> +
> +/**
> + * tps65917: structure for the tps65917 chip data
> + * @dev: pointer to the tps65917 device.
> + * @i2c_clients: array of pointers to the i2c clients of tps65917.
> + * @regmap: array of pointers to the regmaps of individual clients.
> + * @pmic: Pointer to the pmic structure that holds info about LDOs and SMPSs
> + * @irq: interrupt number
> + */
> +struct tps65917 {
> +	struct device *dev;
> +
> +	struct i2c_client *i2c_clients[TPS65917_NUM_CLIENTS];
> +	struct regmap *regmap[TPS65917_NUM_CLIENTS];
> +
> +	struct tps65917_pmic *pmic;
> +
> +	/* IRQ Data */
> +	int irq;
> +	u32 irq_mask;
> +	/* mutext for irq */
> +	struct mutex irq_lock;
> +	struct regmap_irq_chip_data *irq_data;
> +};
> +
> +/**
> + * tps65917_reg_init: regulator initialization structure
> + * @warm_reset: This flag controls the voltage levels of regulators
> + *		after a warm reset
> + * @roof_floor: roof_floor controls whether the regulator uses the i2c style
> + *		of DVS or uses the method where a GPIO or other control
> + *		method is attached to the NSLEEP/ENABLE1/ENABLE2 pins
> + * @mode_sleep: MODE_SLEEP bits of the regulator
> + * @voltage_sel is the bitfield loaded onto the SMPSX_VOLTAGE
> + *		register. Set this is the default voltage set in OTP needs
> + *		to be overridden.
> + */
> +struct tps65917_reg_init {
> +	/*
> +	 * 0: reload default values from OTP on warm reset
> +	 * 1: maintain voltage from VSEL on warm reset
> +	 */
> +	bool warm_reset;

Where is this used?

> +	/*
> +	 * 0: i2c selection of voltage
> +	 * 1: pin selection of voltage.
> +	 */
> +	bool roof_floor;

And this?

> +	/*
> +	 * For SMPS
> +	 *
> +	 * 0: Off
> +	 * 1: AUTO
> +	 * 2: ECO
> +	 * 3: Forced PWM
> +	 *
> +	 * For LDO
> +	 *
> +	 * 0: Off
> +	 * 1: On
> +	 */
> +	int mode_sleep;

And this?

> +	u8 vsel;

And this?

> +};
> +
> +enum tps65917_regulators {
> +	/* SMPS regulators */
> +	TPS65917_REG_SMPS1,

You probably want to ' = 0' this.

> +	TPS65917_REG_SMPS2,
> +	TPS65917_REG_SMPS3,
> +	TPS65917_REG_SMPS4,
> +	TPS65917_REG_SMPS5,
> +	/* LDO regulators */
> +	TPS65917_REG_LDO1,
> +	TPS65917_REG_LDO2,
> +	TPS65917_REG_LDO3,
> +	TPS65917_REG_LDO4,
> +	TPS65917_REG_LDO5,
> +	TPS65917_REG_REGEN1,
> +	TPS65917_REG_REGEN2,
> +	TPS65917_REG_REGEN3,
> +
> +	/* Total number of regulators */
> +	TPS65917_NUM_REGS,
> +};
> +
> +struct tps65917_pmic_platform_data {
> +	/*
> +	 * An array of pointers to regulator init data indexed by regulator
> +	 * ID
> +	 */
> +	struct regulator_init_data *reg_data[TPS65917_NUM_REGS];
> +
> +	/*
> +	 * An array of pointers to structures containing sleep mode and DVS
> +	 * configuration for regulators indexed by ID
> +	 */
> +	struct tps65917_reg_init *reg_init[TPS65917_NUM_REGS];
> +};
> +
> +
> +struct tps65917_platform_data {
> +	int irq_flags;
> +	int gpio_base;
> +
> +	/* bit value to be loaded to the POWER_CTRL register */
> +	u8 power_ctrl;
> +
> +	/*
> +	 * boolean to select if we want to configure muxing here
> +	 * then the two value to load into the registers if true

This makes no sense.

> +	 */
> +	bool mux_from_pdata;
> +	u8 pad1, pad2;
> +	bool pm_off;
> +
> +	struct tps65917_pmic_platform_data *pmic_pdata;
> +};
> +
> +/* Define the tps65917 IRQ numbers */
> +enum tps65917_irqs {
> +	/* INT1 registers */
> +	TPS65917_RESERVED1,
> +	TPS65917_PWRON_IRQ,
> +	TPS65917_LONG_PRESS_KEY_IRQ,
> +	TPS65917_RESERVED2,
> +	TPS65917_PWRDOWN_IRQ,
> +	TPS65917_HOTDIE_IRQ,
> +	TPS65917_VSYS_MON_IRQ,
> +	TPS65917_RESERVED3,
> +	/* INT2 registers */
> +	TPS65917_RESERVED4,
> +	TPS65917_OTP_ERROR_IRQ,
> +	TPS65917_WDT_IRQ,
> +	TPS65917_RESERVED5,
> +	TPS65917_RESET_IN_IRQ,
> +	TPS65917_FSD_IRQ,
> +	TPS65917_SHORT_IRQ,
> +	TPS65917_RESERVED6,
> +	/* INT3 registers */
> +	TPS65917_GPADC_AUTO_0_IRQ,
> +	TPS65917_GPADC_AUTO_1_IRQ,
> +	TPS65917_GPADC_EOC_SW_IRQ,
> +	TPS65917_RESREVED6,
> +	TPS65917_RESERVED7,
> +	TPS65917_RESERVED8,
> +	TPS65917_RESERVED9,
> +	TPS65917_VBUS_IRQ,
> +	/* INT4 registers */
> +	TPS65917_GPIO_0_IRQ,
> +	TPS65917_GPIO_1_IRQ,
> +	TPS65917_GPIO_2_IRQ,
> +	TPS65917_GPIO_3_IRQ,
> +	TPS65917_GPIO_4_IRQ,
> +	TPS65917_GPIO_5_IRQ,
> +	TPS65917_GPIO_6_IRQ,
> +	TPS65917_RESERVED10,
> +	/* Total Number IRQs */
> +	TPS65917_NUM_IRQ,
> +};
> +
> +/* External control signal name */
> +enum {
> +	TPS65917_EXT_CONTROL_ENABLE1      = 0x1,
> +	TPS65917_EXT_CONTROL_ENABLE2      = 0x2,
> +	TPS65917_EXT_CONTROL_NSLEEP       = 0x4,
> +};
> +
> +/*
> + * TPS65917 device resources can be controlled externally for
> + * enabling/disabling it rather than register write through i2c.
> + * Add the external controlled requestor ID for different resources.
> + */
> +enum tps65917_external_requestor_id {
> +	TPS65917_EXTERNAL_REQSTR_ID_REGEN1,
> +	TPS65917_EXTERNAL_REQSTR_ID_REGEN2,
> +	TPS65917_EXTERNAL_REQSTR_ID_REGEN3,
> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS1,
> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS2,
> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS3,
> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS4,
> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS5,
> +	TPS65917_EXTERNAL_REQSTR_ID_LDO1,
> +	TPS65917_EXTERNAL_REQSTR_ID_LDO2,
> +	TPS65917_EXTERNAL_REQSTR_ID_LDO3,
> +	TPS65917_EXTERNAL_REQSTR_ID_LDO4,
> +	TPS65917_EXTERNAL_REQSTR_ID_LDO5,
> +	/* Last entry */
> +	TPS65917_EXTERNAL_REQSTR_ID_MAX,
> +};
> +
> +struct tps65917_pmic {
> +	struct tps65917 *tps65917;
> +	struct device *dev;
> +	struct regulator_desc desc[TPS65917_NUM_REGS];
> +	struct regulator_dev *rdev[TPS65917_NUM_REGS];
> +	/* pmic mutex */
> +	struct mutex mutex;
> +	int smps12;
> +	int range[TPS65917_REG_SMPS5];
> +	unsigned int ramp_delay[TPS65917_REG_SMPS5];
> +	unsigned int current_reg_mode[TPS65917_REG_SMPS5];
> +};
> +
> +/* helper macro to get correct slave number */
> +#define TPS65917_BASE_TO_SLAVE(x)		((x >> 8) - 1)
> +#define TPS65917_BASE_TO_REG(x, y)	((x & 0xFF) + y)
> +
> +/* Base addresses of IP blocks in TPS65917 */
> +#define TPS65917_SMPS_DVS_BASE					0x20
> +#define TPS65917_VALIDITY_BASE					0x118
> +#define TPS65917_SMPS_BASE					0x120
> +#define TPS65917_LDO_BASE					0x150
> +#define TPS65917_DVFS_BASE					0x180
> +#define TPS65917_PMU_CONTROL_BASE				0x1A0
> +#define TPS65917_RESOURCE_BASE					0x1D4
> +#define TPS65917_PU_PD_OD_BASE					0x1F0
> +#define TPS65917_LED_BASE					0x200
> +#define TPS65917_INTERRUPT_BASE				0x210
> +#define TPS65917_GPIO_BASE					0x280
> +#define TPS65917_GPADC_BASE					0x2C0
> +#define TPS65917_TRIM_GPADC_BASE				0x3CD
> +
> +/* Registers for function BACKUP */
> +#define TPS65917_BACKUP0					0x00
> +#define TPS65917_BACKUP1					0x01
> +#define TPS65917_BACKUP2					0x02
> +#define TPS65917_BACKUP3					0x03
> +#define TPS65917_BACKUP4					0x04
> +#define TPS65917_BACKUP5					0x05
> +#define TPS65917_BACKUP6					0x06
> +#define TPS65917_BACKUP7					0x07
> +
> +/* Bit definitions for BACKUP{0-7} */
> +#define TPS65917_BACKUP_BACKUP_MASK				0xFF
> +#define TPS65917_BACKUP_BACKUP_SHIFT				0x00
> +
> +/* Registers for function SMPS */
> +#define TPS65917_SMPS1_CTRL					0x00
> +#define TPS65917_SMPS1_FORCE					0x02
> +#define TPS65917_SMPS1_VOLTAGE					0x03
> +#define TPS65917_SMPS2_CTRL					0x04
> +#define TPS65917_SMPS2_FORCE					0x06
> +#define TPS65917_SMPS2_VOLTAGE					0x07
> +#define TPS65917_SMPS3_CTRL					0x0C
> +#define TPS65917_SMPS3_FORCE					0x0E
> +#define TPS65917_SMPS3_VOLTAGE					0x0F
> +#define TPS65917_SMPS4_CTRL					0x10
> +#define TPS65917_SMPS4_VOLTAGE					0x13
> +#define TPS65917_SMPS5_CTRL					0x18
> +#define TPS65917_SMPS5_VOLTAGE					0x1B
> +#define TPS65917_SMPS_CTRL					0x24
> +#define TPS65917_SMPS_PD_CTRL					0x25
> +#define TPS65917_SMPS_THERMAL_EN				0x27
> +#define TPS65917_SMPS_THERMAL_STATUS				0x28
> +#define TPS65917_SMPS_SHORT_STATUS				0x29
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN		0x2A
> +#define TPS65917_SMPS_POWERGOOD_MASK1				0x2B
> +#define TPS65917_SMPS_POWERGOOD_MASK2				0x2C
> +
> +/* Bit definitions for SMPS1_CTRL */
> +#define TPS65917_SMPS1_CTRL_WR_S				0x80
> +#define TPS65917_SMPS1_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_SMPS1_CTRL_ROOF_FLOOR_EN			0x40
> +#define TPS65917_SMPS1_CTRL_ROOF_FLOOR_EN_SHIFT		0x06
> +#define TPS65917_SMPS1_CTRL_STATUS_MASK			0x30
> +#define TPS65917_SMPS1_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_SMPS1_CTRL_MODE_SLEEP_MASK			0x0C
> +#define TPS65917_SMPS1_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_SMPS1_CTRL_MODE_ACTIVE_MASK			0x03
> +#define TPS65917_SMPS1_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for SMPS1_FORCE */
> +#define TPS65917_SMPS1_FORCE_CMD				0x80
> +#define TPS65917_SMPS1_FORCE_CMD_SHIFT				0x07
> +#define TPS65917_SMPS1_FORCE_VSEL_MASK				0x7F
> +#define TPS65917_SMPS1_FORCE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for SMPS1_VOLTAGE */
> +#define TPS65917_SMPS1_VOLTAGE_RANGE				0x80
> +#define TPS65917_SMPS1_VOLTAGE_RANGE_SHIFT			0x07
> +#define TPS65917_SMPS1_VOLTAGE_VSEL_MASK			0x7F
> +#define TPS65917_SMPS1_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for SMPS2_CTRL */
> +#define TPS65917_SMPS2_CTRL_WR_S				0x80
> +#define TPS65917_SMPS2_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_SMPS2_CTRL_ROOF_FLOOR_EN			0x40
> +#define TPS65917_SMPS2_CTRL_ROOF_FLOOR_EN_SHIFT		0x06
> +#define TPS65917_SMPS2_CTRL_STATUS_MASK			0x30
> +#define TPS65917_SMPS2_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_SMPS2_CTRL_MODE_SLEEP_MASK			0x0C
> +#define TPS65917_SMPS2_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_SMPS2_CTRL_MODE_ACTIVE_MASK			0x03
> +#define TPS65917_SMPS2_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for SMPS2_FORCE */
> +#define TPS65917_SMPS2_FORCE_CMD				0x80
> +#define TPS65917_SMPS2_FORCE_CMD_SHIFT				0x07
> +#define TPS65917_SMPS2_FORCE_VSEL_MASK				0x7F
> +#define TPS65917_SMPS2_FORCE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for SMPS2_VOLTAGE */
> +#define TPS65917_SMPS2_VOLTAGE_RANGE				0x80
> +#define TPS65917_SMPS2_VOLTAGE_RANGE_SHIFT			0x07
> +#define TPS65917_SMPS2_VOLTAGE_VSEL_MASK			0x7F
> +#define TPS65917_SMPS2_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for SMPS3_CTRL */
> +#define TPS65917_SMPS3_CTRL_WR_S				0x80
> +#define TPS65917_SMPS3_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_SMPS3_CTRL_ROOF_FLOOR_EN			0x40
> +#define TPS65917_SMPS3_CTRL_ROOF_FLOOR_EN_SHIFT		0x06
> +#define TPS65917_SMPS3_CTRL_STATUS_MASK			0x30
> +#define TPS65917_SMPS3_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_SMPS3_CTRL_MODE_SLEEP_MASK			0x0C
> +#define TPS65917_SMPS3_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_SMPS3_CTRL_MODE_ACTIVE_MASK			0x03
> +#define TPS65917_SMPS3_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for SMPS3_FORCE */
> +#define TPS65917_SMPS3_FORCE_CMD				0x80
> +#define TPS65917_SMPS3_FORCE_CMD_SHIFT				0x07
> +#define TPS65917_SMPS3_FORCE_VSEL_MASK				0x7F
> +#define TPS65917_SMPS3_FORCE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for SMPS3_VOLTAGE */
> +#define TPS65917_SMPS3_VOLTAGE_RANGE				0x80
> +#define TPS65917_SMPS3_VOLTAGE_RANGE_SHIFT			0x07
> +#define TPS65917_SMPS3_VOLTAGE_VSEL_MASK			0x7F
> +#define TPS65917_SMPS3_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for SMPS4_CTRL */
> +#define TPS65917_SMPS4_CTRL_WR_S				0x80
> +#define TPS65917_SMPS4_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_SMPS4_CTRL_ROOF_FLOOR_EN			0x40
> +#define TPS65917_SMPS4_CTRL_ROOF_FLOOR_EN_SHIFT		0x06
> +#define TPS65917_SMPS4_CTRL_STATUS_MASK			0x30
> +#define TPS65917_SMPS4_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_SMPS4_CTRL_MODE_SLEEP_MASK			0x0C
> +#define TPS65917_SMPS4_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_SMPS4_CTRL_MODE_ACTIVE_MASK			0x03
> +#define TPS65917_SMPS4_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for SMPS4_VOLTAGE */
> +#define TPS65917_SMPS4_VOLTAGE_RANGE				0x80
> +#define TPS65917_SMPS4_VOLTAGE_RANGE_SHIFT			0x07
> +#define TPS65917_SMPS4_VOLTAGE_VSEL_MASK			0x7F
> +#define TPS65917_SMPS4_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for SMPS5_CTRL */
> +#define TPS65917_SMPS5_CTRL_WR_S				0x80
> +#define TPS65917_SMPS5_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_SMPS5_CTRL_ROOF_FLOOR_EN			0x40
> +#define TPS65917_SMPS5_CTRL_ROOF_FLOOR_EN_SHIFT		0x06
> +#define TPS65917_SMPS5_CTRL_STATUS_MASK			0x30
> +#define TPS65917_SMPS5_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_SMPS5_CTRL_MODE_SLEEP_MASK			0x0C
> +#define TPS65917_SMPS5_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_SMPS5_CTRL_MODE_ACTIVE_MASK			0x03
> +#define TPS65917_SMPS5_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for SMPS5_VOLTAGE */
> +#define TPS65917_SMPS5_VOLTAGE_RANGE				0x80
> +#define TPS65917_SMPS5_VOLTAGE_RANGE_SHIFT			0x07
> +#define TPS65917_SMPS5_VOLTAGE_VSEL_MASK			0x7F
> +#define TPS65917_SMPS5_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for SMPS_CTRL */
> +#define TPS65917_SMPS_CTRL_SMPS1_SMPS12_EN			0x10
> +#define TPS65917_SMPS_CTRL_SMPS1_SMPS12_EN_SHIFT		0x04
> +#define TPS65917_SMPS_CTRL_SMPS12_PHASE_CTRL			0x03
> +#define TPS65917_SMPS_CTRL_SMPS12_PHASE_CTRL_SHIFT		0x00
> +
> +/* Bit definitions for SMPS_PD_CTRL */
> +#define TPS65917_SMPS_PD_CTRL_SMPS5				0x40
> +#define TPS65917_SMPS_PD_CTRL_SMPS5_SHIFT			0x06
> +#define TPS65917_SMPS_PD_CTRL_SMPS4				0x10
> +#define TPS65917_SMPS_PD_CTRL_SMPS4_SHIFT			0x04
> +#define TPS65917_SMPS_PD_CTRL_SMPS3				0x08
> +#define TPS65917_SMPS_PD_CTRL_SMPS3_SHIFT			0x03
> +#define TPS65917_SMPS_PD_CTRL_SMPS2				0x02
> +#define TPS65917_SMPS_PD_CTRL_SMPS2_SHIFT			0x01
> +#define TPS65917_SMPS_PD_CTRL_SMPS1				0x01
> +#define TPS65917_SMPS_PD_CTRL_SMPS1_SHIFT			0x00
> +
> +/* Bit definitions for SMPS_THERMAL_EN */
> +#define TPS65917_SMPS_THERMAL_EN_SMPS5				0x40
> +#define TPS65917_SMPS_THERMAL_EN_SMPS5_SHIFT			0x06
> +#define TPS65917_SMPS_THERMAL_EN_SMPS3				0x08
> +#define TPS65917_SMPS_THERMAL_EN_SMPS3_SHIFT			0x03
> +#define TPS65917_SMPS_THERMAL_EN_SMPS12			0x01
> +#define TPS65917_SMPS_THERMAL_EN_SMPS12_SHIFT			0x00
> +
> +/* Bit definitions for SMPS_THERMAL_STATUS */
> +#define TPS65917_SMPS_THERMAL_STATUS_SMPS5			0x40
> +#define TPS65917_SMPS_THERMAL_STATUS_SMPS5_SHIFT		0x06
> +#define TPS65917_SMPS_THERMAL_STATUS_SMPS3			0x08
> +#define TPS65917_SMPS_THERMAL_STATUS_SMPS3_SHIFT		0x03
> +#define TPS65917_SMPS_THERMAL_STATUS_SMPS12			0x01
> +#define TPS65917_SMPS_THERMAL_STATUS_SMPS12_SHIFT		0x00
> +
> +/* Bit definitions for SMPS_SHORT_STATUS */
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS5			0x40
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS5_SHIFT			0x06
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS4			0x10
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS4_SHIFT			0x04
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS3			0x08
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS3_SHIFT			0x03
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS2			0x02
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS2_SHIFT			0x01
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS1			0x01
> +#define TPS65917_SMPS_SHORT_STATUS_SMPS1_SHIFT			0x00
> +
> +/* Bit definitions for SMPS_NEGATIVE_CURRENT_LIMIT_EN */
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS5		0x40
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS5_SHIFT	0x06
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS4		0x10
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS4_SHIFT	0x04
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS3		0x08
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS3_SHIFT	0x03
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS2		0x02
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS2_SHIFT	0x01
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS1		0x01
> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN_SMPS1_SHIFT	0x00
> +
> +/* Bit definitions for SMPS_POWERGOOD_MASK1 */
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS5			0x40
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS5_SHIFT		0x06
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS4			0x10
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS4_SHIFT		0x04
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS3			0x08
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS3_SHIFT		0x03
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS2			0x02
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS2_SHIFT		0x01
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS1			0x01
> +#define TPS65917_SMPS_POWERGOOD_MASK1_SMPS1_SHIFT		0x00
> +
> +/* Bit definitions for SMPS_POWERGOOD_MASK2 */
> +#define TPS65917_SMPS_POWERGOOD_MASK2_POWERGOOD_TYPE_SELECT		0x80
> +#define TPS65917_SMPS_POWERGOOD_MASK2_POWERGOOD_TYPE_SELECT_SHIFT	0x07
> +#define TPS65917_SMPS_POWERGOOD_MASK2_OVC_ALARM_SHIFT			0x10
> +#define TPS65917_SMPS_POWERGOOD_MASK2_OVC_ALARM			0x04
> +
> +/* Bit definitions for SMPS_PLL_CTRL */
> +
> +#define TPS65917_SMPS_PLL_CTRL_PLL_EN_PLL_BYPASS_SHIFT		0x08
> +#define TPS65917_SMPS_PLL_CTRL_PLL_PLL_EN_BYPASS		0x03
> +#define TPS65917_SMPS_PLL_CTRL_PLL_PLL_BYPASS_CLK_SHIFT	0x04
> +#define TPS65917_SMPS_PLL_CTRL_PLL_PLL_BYPASS_CLK		0x02
> +
> +/* Registers for function LDO */
> +#define TPS65917_LDO1_CTRL					0x00
> +#define TPS65917_LDO1_VOLTAGE					0x01
> +#define TPS65917_LDO2_CTRL					0x02
> +#define TPS65917_LDO2_VOLTAGE					0x03
> +#define TPS65917_LDO3_CTRL					0x04
> +#define TPS65917_LDO3_VOLTAGE					0x05
> +#define TPS65917_LDO4_CTRL					0x0E
> +#define TPS65917_LDO4_VOLTAGE					0x0F
> +#define TPS65917_LDO5_CTRL					0x12
> +#define TPS65917_LDO5_VOLTAGE					0x13
> +#define TPS65917_LDO_PD_CTRL1					0x1B
> +#define TPS65917_LDO_PD_CTRL2					0x1C
> +#define TPS65917_LDO_SHORT_STATUS1				0x1D
> +#define TPS65917_LDO_SHORT_STATUS2				0x1E
> +#define TPS65917_LDO_PD_CTRL3					0x2D
> +#define TPS65917_LDO_SHORT_STATUS3				0x2E
> +
> +/* Bit definitions for LDO1_CTRL */
> +#define TPS65917_LDO1_CTRL_WR_S				0x80
> +#define TPS65917_LDO1_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_LDO1_CTRL_BYPASS_EN				0x40
> +#define TPS65917_LDO1_CTRL_BYPASS_EN_SHIFT			0x06
> +#define TPS65917_LDO1_CTRL_STATUS				0x10
> +#define TPS65917_LDO1_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_LDO1_CTRL_MODE_SLEEP				0x04
> +#define TPS65917_LDO1_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_LDO1_CTRL_MODE_ACTIVE				0x01
> +#define TPS65917_LDO1_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for LDO1_VOLTAGE */
> +#define TPS65917_LDO1_VOLTAGE_VSEL_MASK			0x2F
> +#define TPS65917_LDO1_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for LDO2_CTRL */
> +#define TPS65917_LDO2_CTRL_WR_S				0x80
> +#define TPS65917_LDO2_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_LDO2_CTRL_BYPASS_EN				0x40
> +#define TPS65917_LDO2_CTRL_BYPASS_EN_SHIFT			0x06
> +#define TPS65917_LDO2_CTRL_STATUS				0x10
> +#define TPS65917_LDO2_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_LDO2_CTRL_MODE_SLEEP				0x04
> +#define TPS65917_LDO2_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_LDO2_CTRL_MODE_ACTIVE				0x01
> +#define TPS65917_LDO2_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for LDO2_VOLTAGE */
> +#define TPS65917_LDO2_VOLTAGE_VSEL_MASK			0x2F
> +#define TPS65917_LDO2_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for LDO3_CTRL */
> +#define TPS65917_LDO3_CTRL_WR_S				0x80
> +#define TPS65917_LDO3_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_LDO3_CTRL_STATUS				0x10
> +#define TPS65917_LDO3_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_LDO3_CTRL_MODE_SLEEP				0x04
> +#define TPS65917_LDO3_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_LDO3_CTRL_MODE_ACTIVE				0x01
> +#define TPS65917_LDO3_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for LDO3_VOLTAGE */
> +#define TPS65917_LDO3_VOLTAGE_VSEL_MASK			0x2F
> +#define TPS65917_LDO3_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for LDO4_CTRL */
> +#define TPS65917_LDO4_CTRL_WR_S				0x80
> +#define TPS65917_LDO4_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_LDO4_CTRL_STATUS				0x10
> +#define TPS65917_LDO4_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_LDO4_CTRL_MODE_SLEEP				0x04
> +#define TPS65917_LDO4_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_LDO4_CTRL_MODE_ACTIVE				0x01
> +#define TPS65917_LDO4_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for LDO4_VOLTAGE */
> +#define TPS65917_LDO4_VOLTAGE_VSEL_MASK			0x2F
> +#define TPS65917_LDO4_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for LDO5_CTRL */
> +#define TPS65917_LDO5_CTRL_WR_S				0x80
> +#define TPS65917_LDO5_CTRL_WR_S_SHIFT				0x07
> +#define TPS65917_LDO5_CTRL_STATUS				0x10
> +#define TPS65917_LDO5_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_LDO5_CTRL_MODE_SLEEP				0x04
> +#define TPS65917_LDO5_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_LDO5_CTRL_MODE_ACTIVE				0x01
> +#define TPS65917_LDO5_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for LDO5_VOLTAGE */
> +#define TPS65917_LDO5_VOLTAGE_VSEL_MASK			0x2F
> +#define TPS65917_LDO5_VOLTAGE_VSEL_SHIFT			0x00
> +
> +/* Bit definitions for LDO_PD_CTRL1 */
> +#define TPS65917_LDO_PD_CTRL1_LDO4				0x80
> +#define TPS65917_LDO_PD_CTRL1_LDO4_SHIFT			0x07
> +#define TPS65917_LDO_PD_CTRL1_LDO2				0x02
> +#define TPS65917_LDO_PD_CTRL1_LDO2_SHIFT			0x01
> +#define TPS65917_LDO_PD_CTRL1_LDO1				0x01
> +#define TPS65917_LDO_PD_CTRL1_LDO1_SHIFT			0x00
> +
> +/* Bit definitions for LDO_PD_CTRL2 */
> +#define TPS65917_LDO_PD_CTRL2_LDO3				0x04
> +#define TPS65917_LDO_PD_CTRL2_LDO3_SHIFT			0x02
> +#define TPS65917_LDO_PD_CTRL2_LDO5				0x02
> +#define TPS65917_LDO_PD_CTRL2_LDO5_SHIFT			0x01
> +
> +/* Bit definitions for LDO_PD_CTRL3 */
> +#define TPS65917_LDO_PD_CTRL2_LDOVANA				0x80
> +#define TPS65917_LDO_PD_CTRL2_LDOVANA_SHIFT			0x07
> +
> +/* Bit definitions for LDO_SHORT_STATUS1 */
> +#define TPS65917_LDO_SHORT_STATUS1_LDO4			0x80
> +#define TPS65917_LDO_SHORT_STATUS1_LDO4_SHIFT			0x07
> +#define TPS65917_LDO_SHORT_STATUS1_LDO2			0x02
> +#define TPS65917_LDO_SHORT_STATUS1_LDO2_SHIFT			0x01
> +#define TPS65917_LDO_SHORT_STATUS1_LDO1			0x01
> +#define TPS65917_LDO_SHORT_STATUS1_LDO1_SHIFT			0x00
> +
> +/* Bit definitions for LDO_SHORT_STATUS2 */
> +#define TPS65917_LDO_SHORT_STATUS2_LDO3			0x04
> +#define TPS65917_LDO_SHORT_STATUS2_LDO3_SHIFT			0x02
> +#define TPS65917_LDO_SHORT_STATUS2_LDO5			0x02
> +#define TPS65917_LDO_SHORT_STATUS2_LDO5_SHIFT			0x01
> +
> +/* Bit definitions for LDO_SHORT_STATUS2 */
> +#define TPS65917_LDO_SHORT_STATUS2_LDOVANA			0x80
> +#define TPS65917_LDO_SHORT_STATUS2_LDOVANA_SHIFT		0x07
> +
> +/* Registers for function PMU_CONTROL */
> +#define TPS65917_DEV_CTRL					0x00
> +#define TPS65917_POWER_CTRL					0x01
> +#define TPS65917_VSYS_LO					0x02
> +#define TPS65917_VSYS_MON					0x03
> +#define TPS65917_WATCHDOG					0x05
> +#define TPS65917_VRTC_CTRL					0x08
> +#define TPS65917_LONG_PRESS_KEY				0x09
> +#define TPS65917_OSC_THERM_CTRL				0x0A
> +#define TPS65917_SWOFF_HWRST					0x0F
> +#define TPS65917_SWOFF_COLDRST					0x10
> +#define TPS65917_SWOFF_STATUS					0x11
> +#define TPS65917_PMU_CONFIG					0x12
> +#define TPS65917_PMU_CTRL2					0x13
> +#define TPS65917_PMU_SECONDARY_INT				0x15
> +#define TPS65917_SW_REVISION					0x17
> +#define TPS65917_PMU_SECONDARY_INT2				0x19
> +
> +/* Bit definitions for DEV_CTRL */
> +#define TPS65917_DEV_CTRL_DEV_STATUS_MASK			0x0C
> +#define TPS65917_DEV_CTRL_DEV_STATUS_SHIFT			0x02
> +#define TPS65917_DEV_CTRL_SW_RST				0x02
> +#define TPS65917_DEV_CTRL_SW_RST_SHIFT				0x01
> +#define TPS65917_DEV_CTRL_DEV_ON				0x01
> +#define TPS65917_DEV_CTRL_DEV_ON_SHIFT				0x00
> +
> +/* Bit definitions for POWER_CTRL */
> +#define TPS65917_POWER_CTRL_ENABLE2_MASK			0x04
> +#define TPS65917_POWER_CTRL_ENABLE2_MASK_SHIFT			0x02
> +#define TPS65917_POWER_CTRL_ENABLE1_MASK			0x02
> +#define TPS65917_POWER_CTRL_ENABLE1_MASK_SHIFT			0x01
> +#define TPS65917_POWER_CTRL_NSLEEP_MASK			0x01
> +#define TPS65917_POWER_CTRL_NSLEEP_MASK_SHIFT			0x00
> +
> +/* Bit definitions for VSYS_LO */
> +#define TPS65917_VSYS_LO_THRESHOLD_MASK			0x1f
> +#define TPS65917_VSYS_LO_THRESHOLD_SHIFT			0x00
> +
> +/* Bit definitions for VSYS_MON */
> +#define TPS65917_VSYS_MON_ENABLE				0x80
> +#define TPS65917_VSYS_MON_ENABLE_SHIFT				0x07
> +#define TPS65917_VSYS_MON_THRESHOLD_MASK			0x2F
> +#define TPS65917_VSYS_MON_THRESHOLD_SHIFT			0x00
> +
> +/* Bit definitions for WATCHDOG */
> +#define TPS65917_WATCHDOG_LOCK					0x20
> +#define TPS65917_WATCHDOG_LOCK_SHIFT				0x05
> +#define TPS65917_WATCHDOG_ENABLE				0x10
> +#define TPS65917_WATCHDOG_ENABLE_SHIFT				0x04
> +#define TPS65917_WATCHDOG_MODE					0x08
> +#define TPS65917_WATCHDOG_MODE_SHIFT				0x03
> +#define TPS65917_WATCHDOG_TIMER_MASK				0x07
> +#define TPS65917_WATCHDOG_TIMER_SHIFT				0x00
> +
> +/* Bit definitions for VRTC_CTRL */
> +#define TPS65917_VRTC_CTRL_VRTC_18_15				0x80
> +#define TPS65917_VRTC_CTRL_VRTC_18_15_SHIFT			0x07
> +#define TPS65917_VRTC_CTRL_VRTC_EN_SLP				0x40
> +#define TPS65917_VRTC_CTRL_VRTC_EN_SLP_SHIFT			0x06
> +#define TPS65917_VRTC_CTRL_VRTC_EN_OFF				0x20
> +#define TPS65917_VRTC_CTRL_VRTC_EN_OFF_SHIFT			0x05
> +#define TPS65917_VRTC_CTRL_VRTC_PWEN				0x10
> +#define TPS65917_VRTC_CTRL_SHIFT				0x04
> +
> +/* Bit definitions for LONG_PRESS_KEY */
> +#define TPS65917_LONG_PRESS_KEY_LPK_LOCK			0x80
> +#define TPS65917_LONG_PRESS_KEY_LPK_LOCK_SHIFT			0x07
> +#define TPS65917_LONG_PRESS_KEY_LPK_TIME_MASK			0x0C
> +#define TPS65917_LONG_PRESS_KEY_LPK_TIME_SHIFT			0x02
> +
> +/* Bit definitions for OSC_THERM_CTRL */
> +#define TPS65917_OSC_THERM_CTRL_VANA_ON_IN_SLEEP		0x80
> +#define TPS65917_OSC_THERM_CTRL_VANA_ON_IN_SLEEP_SHIFT		0x07
> +#define TPS65917_OSC_THERM_CTRL_INT_MASK_IN_SLEEP		0x40
> +#define TPS65917_OSC_THERM_CTRL_INT_MASK_IN_SLEEP_SHIFT	0x06
> +#define TPS65917_OSC_THERM_CTRL_RC15MHZ_ON_IN_SLEEP		0x20
> +#define TPS65917_OSC_THERM_CTRL_RC15MHZ_ON_IN_SLEEP_SHIFT	0x05
> +#define TPS65917_OSC_THERM_CTRL_THERM_OFF_IN_SLEEP		0x10
> +#define TPS65917_OSC_THERM_CTRL_THERM_OFF_IN_SLEEP_SHIFT	0x04
> +#define TPS65917_OSC_THERM_CTRL_THERM_HD_SEL_MASK		0x0C
> +#define TPS65917_OSC_THERM_CTRL_THERM_HD_SEL_SHIFT		0x02
> +
> +/* Bit definitions for SWOFF_HWRST */
> +#define TPS65917_SWOFF_HWRST_PWRON_LPK				0x80
> +#define TPS65917_SWOFF_HWRST_PWRON_LPK_SHIFT			0x07
> +#define TPS65917_SWOFF_HWRST_PWRDOWN				0x40
> +#define TPS65917_SWOFF_HWRST_PWRDOWN_SHIFT			0x06
> +#define TPS65917_SWOFF_HWRST_WTD				0x20
> +#define TPS65917_SWOFF_HWRST_WTD_SHIFT				0x05
> +#define TPS65917_SWOFF_HWRST_TSHUT				0x10
> +#define TPS65917_SWOFF_HWRST_TSHUT_SHIFT			0x04
> +#define TPS65917_SWOFF_HWRST_RESET_IN				0x08
> +#define TPS65917_SWOFF_HWRST_RESET_IN_SHIFT			0x03
> +#define TPS65917_SWOFF_HWRST_SW_RST				0x04
> +#define TPS65917_SWOFF_HWRST_SW_RST_SHIFT			0x02
> +#define TPS65917_SWOFF_HWRST_VSYS_LO				0x02
> +#define TPS65917_SWOFF_HWRST_VSYS_LO_SHIFT			0x01
> +#define TPS65917_SWOFF_HWRST_GPADC_SHUTDOWN			0x01
> +#define TPS65917_SWOFF_HWRST_GPADC_SHUTDOWN_SHIFT		0x00
> +
> +/* Bit definitions for SWOFF_COLDRST */
> +#define TPS65917_SWOFF_COLDRST_PWRON_LPK			0x80
> +#define TPS65917_SWOFF_COLDRST_PWRON_LPK_SHIFT			0x07
> +#define TPS65917_SWOFF_COLDRST_PWRDOWN				0x40
> +#define TPS65917_SWOFF_COLDRST_PWRDOWN_SHIFT			0x06
> +#define TPS65917_SWOFF_COLDRST_WTD				0x20
> +#define TPS65917_SWOFF_COLDRST_WTD_SHIFT			0x05
> +#define TPS65917_SWOFF_COLDRST_TSHUT				0x10
> +#define TPS65917_SWOFF_COLDRST_TSHUT_SHIFT			0x04
> +#define TPS65917_SWOFF_COLDRST_RESET_IN			0x08
> +#define TPS65917_SWOFF_COLDRST_RESET_IN_SHIFT			0x03
> +#define TPS65917_SWOFF_COLDRST_SW_RST				0x04
> +#define TPS65917_SWOFF_COLDRST_SW_RST_SHIFT			0x02
> +#define TPS65917_SWOFF_COLDRST_VSYS_LO				0x02
> +#define TPS65917_SWOFF_COLDRST_VSYS_LO_SHIFT			0x01
> +#define TPS65917_SWOFF_COLDRST_GPADC_SHUTDOWN			0x01
> +#define TPS65917_SWOFF_COLDRST_GPADC_SHUTDOWN_SHIFT		0x00
> +
> +/* Bit definitions for SWOFF_STATUS */
> +#define TPS65917_SWOFF_STATUS_PWRON_LPK			0x80
> +#define TPS65917_SWOFF_STATUS_PWRON_LPK_SHIFT			0x07
> +#define TPS65917_SWOFF_STATUS_PWRDOWN				0x40
> +#define TPS65917_SWOFF_STATUS_PWRDOWN_SHIFT			0x06
> +#define TPS65917_SWOFF_STATUS_WTD				0x20
> +#define TPS65917_SWOFF_STATUS_WTD_SHIFT			0x05
> +#define TPS65917_SWOFF_STATUS_TSHUT				0x10
> +#define TPS65917_SWOFF_STATUS_TSHUT_SHIFT			0x04
> +#define TPS65917_SWOFF_STATUS_RESET_IN				0x08
> +#define TPS65917_SWOFF_STATUS_RESET_IN_SHIFT			0x03
> +#define TPS65917_SWOFF_STATUS_SW_RST				0x04
> +#define TPS65917_SWOFF_STATUS_SW_RST_SHIFT			0x02
> +#define TPS65917_SWOFF_STATUS_VSYS_LO				0x02
> +#define TPS65917_SWOFF_STATUS_VSYS_LO_SHIFT			0x01
> +#define TPS65917_SWOFF_STATUS_GPADC_SHUTDOWN			0x01
> +#define TPS65917_SWOFF_STATUS_GPADC_SHUTDOWN_SHIFT		0x00
> +
> +/* Bit definitions for PMU_CONFIG */
> +#define TPS65917_PMU_CONFIG_HIGH_VCC_SENSE			0x40
> +#define TPS65917_PMU_CONFIG_HIGH_VCC_SENSE_SHIFT		0x06
> +#define TPS65917_PMU_CONFIG_PLL_AUTO_CTRL_MASK			0x30
> +#define TPS65917_PMU_CONFIG_PLL_AUTO_CTRL_SHIFT		0x04
> +#define TPS65917_PMU_CONFIG_SWOFF_DLY_MASK			0x0C
> +#define TPS65917_PMU_CONFIG_SWOFF_DLY_SHIFT			0x02
> +#define TPS65917_PMU_CONFIG_AUTODEVON				0x01
> +#define TPS65917_PMU_CONFIG_AUTODEVON_SHIFT			0x00
> +
> +/* Bit definitions for PMU_CTRL2 */
> +#define TPS65917_PMU_CTRL2_INT_LINE_DIS			0x08
> +#define TPS65917_PMU_CTRL2_INT_LINE_DIS_SHIFT			0x04
> +#define TPS65917_PMU_CTRL2_WDT_HOLD_IN_SLEEP			0x04
> +#define TPS65917_PMU_CTRL2_WDT_HOLD_IN_SLEEP_SHIFT		0x03
> +#define TPS65917_PMU_CTRL2_PWRDOWN_FASTOFF			0x02
> +#define TPS65917_PMU_CTRL2_PWRDOWN_FASTOFF_SHIFT		0x01
> +#define TPS65917_PMU_CTRL2_TSHUT_FASTOFF			0x01
> +#define TPS65917_PMU_CTRL2_TSHUT_FASTOFF_SHIFT			0x00
> +
> +/* Bit definitions for PMU_SECONDARY_INT */
> +#define TPS65917_PMU_SECONDARY_INT_FSD_INT_SRC			0x10
> +#define TPS65917_PMU_SECONDARY_INT_FSD_INT_SRC_SHIFT		0x04
> +#define TPS65917_PMU_SECONDARY_INT_FSB_MASK			0x01
> +#define TPS65917_PMU_SECONDARY_INT_FSB_MASK_SHIFT		0x00
> +
> +/* Bit definitions for SW_REVISION */
> +#define TPS65917_SW_REVISION_SW_REVISION_MASK			0xFF
> +#define TPS65917_SW_REVISION_SW_REVISION_SHIFT			0x00
> +
> +/* Bit definitions for PMU_SECONDARY_INT2 */
> +#define TPS65917_PMU_SECONDARY_INT2_DVFS_INT_SRC		0x10
> +#define TPS65917_PMU_SECONDARY_INT2_DVFS_INT_SRC_SHIFT		0x04
> +#define TPS65917_PMU_SECONDARY_INT2_DVFS_MASK			0x01
> +#define TPS65917_PMU_SECONDARY_INT2_DVFS_MASK_SHIFT		0x00
> +
> +/* Registers for function RESOURCE */
> +#define TPS65917_REGEN1_CTRL					0x02
> +#define TPS65917_PLLEN_CTRL					0x03
> +#define TPS65917_NSLEEP_RES_ASSIGN				0x06
> +#define TPS65917_NSLEEP_SMPS_ASSIGN				0x07
> +#define TPS65917_NSLEEP_LDO_ASSIGN1				0x08
> +#define TPS65917_NSLEEP_LDO_ASSIGN2				0x09
> +#define TPS65917_ENABLE1_RES_ASSIGN				0x0A
> +#define TPS65917_ENABLE1_SMPS_ASSIGN				0x0B
> +#define TPS65917_ENABLE1_LDO_ASSIGN1				0x0C
> +#define TPS65917_ENABLE1_LDO_ASSIGN2				0x0D
> +#define TPS65917_ENABLE2_RES_ASSIGN				0x0E
> +#define TPS65917_ENABLE2_SMPS_ASSIGN				0x0F
> +#define TPS65917_ENABLE2_LDO_ASSIGN1				0x10
> +#define TPS65917_ENABLE2_LDO_ASSIGN2				0x11
> +#define TPS65917_REGEN2_CTRL					0x12
> +#define TPS65917_REGEN3_CTRL					0x13
> +
> +/* Bit definitions for REGEN1_CTRL */
> +#define TPS65917_REGEN1_CTRL_STATUS				0x10
> +#define TPS65917_REGEN1_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_REGEN1_CTRL_MODE_SLEEP			0x04
> +#define TPS65917_REGEN1_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_REGEN1_CTRL_MODE_ACTIVE			0x01
> +#define TPS65917_REGEN1_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for PLLEN_CTRL */
> +#define TPS65917_PLLEN_CTRL_STATUS				0x10
> +#define TPS65917_PLLEN_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_PLLEN_CTRL_MODE_SLEEP				0x04
> +#define TPS65917_PLLEN_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_PLLEN_CTRL_MODE_ACTIVE			0x01
> +#define TPS65917_PLLEN_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for REGEN2_CTRL */
> +#define TPS65917_REGEN2_CTRL_STATUS				0x10
> +#define TPS65917_REGEN2_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_REGEN2_CTRL_MODE_SLEEP			0x04
> +#define TPS65917_REGEN2_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_REGEN2_CTRL_MODE_ACTIVE			0x01
> +#define TPS65917_REGEN2_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Bit definitions for NSLEEP_RES_ASSIGN */
> +#define TPS65917_NSLEEP_RES_ASSIGN_PLL_EN			0x08
> +#define TPS65917_NSLEEP_RES_ASSIGN_PLL_EN_SHIFT		0x03
> +#define TPS65917_NSLEEP_RES_ASSIGN_REGEN3			0x04
> +#define TPS65917_NSLEEP_RES_ASSIGN_REGEN3_SHIFT		0x02
> +#define TPS65917_NSLEEP_RES_ASSIGN_REGEN2			0x02
> +#define TPS65917_NSLEEP_RES_ASSIGN_REGEN2_SHIFT		0x01
> +#define TPS65917_NSLEEP_RES_ASSIGN_REGEN1			0x01
> +#define TPS65917_NSLEEP_RES_ASSIGN_REGEN1_SHIFT		0x00
> +
> +/* Bit definitions for NSLEEP_SMPS_ASSIGN */
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS5			0x40
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS5_SHIFT		0x06
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS4			0x10
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS4_SHIFT		0x04
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS3			0x08
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS3_SHIFT		0x03
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS2			0x02
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS2_SHIFT		0x01
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS1			0x01
> +#define TPS65917_NSLEEP_SMPS_ASSIGN_SMPS1_SHIFT		0x00
> +
> +/* Bit definitions for NSLEEP_LDO_ASSIGN1 */
> +#define TPS65917_NSLEEP_LDO_ASSIGN1_LDO4			0x80
> +#define TPS65917_NSLEEP_LDO_ASSIGN1_LDO4_SHIFT			0x07
> +#define TPS65917_NSLEEP_LDO_ASSIGN1_LDO2			0x02
> +#define TPS65917_NSLEEP_LDO_ASSIGN1_LDO2_SHIFT			0x01
> +#define TPS65917_NSLEEP_LDO_ASSIGN1_LDO1			0x01
> +#define TPS65917_NSLEEP_LDO_ASSIGN1_LDO1_SHIFT			0x00
> +
> +/* Bit definitions for NSLEEP_LDO_ASSIGN2 */
> +#define TPS65917_NSLEEP_LDO_ASSIGN2_LDO3			0x04
> +#define TPS65917_NSLEEP_LDO_ASSIGN2_LDO3_SHIFT			0x02
> +#define TPS65917_NSLEEP_LDO_ASSIGN2_LDO5			0x02
> +#define TPS65917_NSLEEP_LDO_ASSIGN2_LDO5_SHIFT			0x01
> +
> +/* Bit definitions for ENABLE1_RES_ASSIGN */
> +#define TPS65917_ENABLE1_RES_ASSIGN_PLLEN			0x08
> +#define TPS65917_ENABLE1_RES_ASSIGN_PLLEN_SHIFT		0x03
> +#define TPS65917_ENABLE1_RES_ASSIGN_REGEN3			0x04
> +#define TPS65917_ENABLE1_RES_ASSIGN_REGEN3_SHIFT		0x02
> +#define TPS65917_ENABLE1_RES_ASSIGN_REGEN2			0x02
> +#define TPS65917_ENABLE1_RES_ASSIGN_REGEN2_SHIFT		0x01
> +#define TPS65917_ENABLE1_RES_ASSIGN_REGEN1			0x01
> +#define TPS65917_ENABLE1_RES_ASSIGN_REGEN1_SHIFT		0x00
> +
> +/* Bit definitions for ENABLE1_SMPS_ASSIGN */
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS5			0x40
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS5_SHIFT		0x06
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS4			0x10
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS4_SHIFT		0x04
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS3			0x08
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS3_SHIFT		0x03
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS2			0x02
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS2_SHIFT		0x01
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS1			0x01
> +#define TPS65917_ENABLE1_SMPS_ASSIGN_SMPS1_SHIFT		0x00
> +
> +/* Bit definitions for ENABLE1_LDO_ASSIGN1 */
> +#define TPS65917_ENABLE1_LDO_ASSIGN1_LDO4			0x80
> +#define TPS65917_ENABLE1_LDO_ASSIGN1_LDO4_SHIFT		0x07
> +#define TPS65917_ENABLE1_LDO_ASSIGN1_LDO2			0x02
> +#define TPS65917_ENABLE1_LDO_ASSIGN1_LDO2_SHIFT		0x01
> +#define TPS65917_ENABLE1_LDO_ASSIGN1_LDO1			0x01
> +#define TPS65917_ENABLE1_LDO_ASSIGN1_LDO1_SHIFT		0x00
> +
> +/* Bit definitions for ENABLE1_LDO_ASSIGN2 */
> +#define TPS65917_ENABLE1_LDO_ASSIGN2_LDO3			0x04
> +#define TPS65917_ENABLE1_LDO_ASSIGN2_LDO3_SHIFT		0x02
> +#define TPS65917_ENABLE1_LDO_ASSIGN2_LDO5			0x02
> +#define TPS65917_ENABLE1_LDO_ASSIGN2_LDO5_SHIFT		0x01
> +
> +/* Bit definitions for ENABLE2_RES_ASSIGN */
> +#define TPS65917_ENABLE2_RES_ASSIGN_PLLEN			0x08
> +#define TPS65917_ENABLE2_RES_ASSIGN_PLLEN_SHIFT		0x03
> +#define TPS65917_ENABLE2_RES_ASSIGN_REGEN3			0x04
> +#define TPS65917_ENABLE2_RES_ASSIGN_REGEN3_SHIFT		0x02
> +#define TPS65917_ENABLE2_RES_ASSIGN_REGEN2			0x02
> +#define TPS65917_ENABLE2_RES_ASSIGN_REGEN2_SHIFT		0x01
> +#define TPS65917_ENABLE2_RES_ASSIGN_REGEN1			0x01
> +#define TPS65917_ENABLE2_RES_ASSIGN_REGEN1_SHIFT		0x00
> +
> +/* Bit definitions for ENABLE2_SMPS_ASSIGN */
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS5			0x40
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS5_SHIFT		0x06
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS4			0x10
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS4_SHIFT		0x04
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS3			0x08
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS3_SHIFT		0x03
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS2			0x02
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS2_SHIFT		0x01
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS1			0x01
> +#define TPS65917_ENABLE2_SMPS_ASSIGN_SMPS1_SHIFT		0x00
> +
> +/* Bit definitions for ENABLE2_LDO_ASSIGN1 */
> +#define TPS65917_ENABLE2_LDO_ASSIGN1_LDO4			0x80
> +#define TPS65917_ENABLE2_LDO_ASSIGN1_LDO4_SHIFT		0x07
> +#define TPS65917_ENABLE2_LDO_ASSIGN1_LDO2			0x02
> +#define TPS65917_ENABLE2_LDO_ASSIGN1_LDO2_SHIFT		0x01
> +#define TPS65917_ENABLE2_LDO_ASSIGN1_LDO1			0x01
> +#define TPS65917_ENABLE2_LDO_ASSIGN1_LDO1_SHIFT		0x00
> +
> +/* Bit definitions for ENABLE2_LDO_ASSIGN2 */
> +#define TPS65917_ENABLE2_LDO_ASSIGN2_LDO3			0x04
> +#define TPS65917_ENABLE2_LDO_ASSIGN2_LDO3_SHIFT		0x02
> +#define TPS65917_ENABLE2_LDO_ASSIGN2_LDO5			0x02
> +#define TPS65917_ENABLE2_LDO_ASSIGN2_LDO5_SHIFT		0x01
> +
> +/* Bit definitions for REGEN3_CTRL */
> +#define TPS65917_REGEN3_CTRL_STATUS				0x10
> +#define TPS65917_REGEN3_CTRL_STATUS_SHIFT			0x04
> +#define TPS65917_REGEN3_CTRL_MODE_SLEEP			0x04
> +#define TPS65917_REGEN3_CTRL_MODE_SLEEP_SHIFT			0x02
> +#define TPS65917_REGEN3_CTRL_MODE_ACTIVE			0x01
> +#define TPS65917_REGEN3_CTRL_MODE_ACTIVE_SHIFT			0x00
> +
> +/* Registers for function PAD_CONTROL */
> +#define TPS65917_OD_OUTPUT_CTRL2				0x02
> +#define TPS65917_PU_PD_INPUT_CTRL1				0x04
> +#define TPS65917_PU_PD_INPUT_CTRL2				0x05
> +#define TPS65917_PU_PD_INPUT_CTRL3				0x06
> +#define TPS65917_OD_OUTPUT_CTRL				0x08
> +#define TPS65917_POLARITY_CTRL					0x09
> +#define TPS65917_PRIMARY_SECONDARY_PAD1			0x0A
> +#define TPS65917_PRIMARY_SECONDARY_PAD2			0x0B
> +#define TPS65917_I2C_SPI					0x0C
> +#define TPS65917_PU_PD_INPUT_CTRL4				0x0D
> +
> +/* Bit definitions for PU_PD_INPUT_CTRL1 */
> +#define TPS65917_PU_PD_INPUT_CTRL1_RESET_IN_PD			0x40
> +#define TPS65917_PU_PD_INPUT_CTRL1_RESET_IN_PD_SHIFT		0x06
> +#define TPS65917_PU_PD_INPUT_CTRL1_PWRDOWN_PD			0x04
> +#define TPS65917_PU_PD_INPUT_CTRL1_PWRDOWN_PD_SHIFT		0x02
> +#define TPS65917_PU_PD_INPUT_CTRL1_NRESWARM_PD			0x01
> +#define TPS65917_PU_PD_INPUT_CTRL1_NRESWARM_PD_SHIFT		0x00
> +
> +/* Bit definitions for PU_PD_INPUT_CTRL2 */
> +#define TPS65917_PU_PD_INPUT_CTRL2_ENABLE2_PD			0x10
> +#define TPS65917_PU_PD_INPUT_CTRL2_ENABLE2_PD_SHIFT		0x04
> +#define TPS65917_PU_PD_INPUT_CTRL2_ENABLE1_PU			0x08
> +#define TPS65917_PU_PD_INPUT_CTRL2_ENABLE1_PU_SHIFT		0x03
> +#define TPS65917_PU_PD_INPUT_CTRL2_ENABLE1_PD			0x04
> +#define TPS65917_PU_PD_INPUT_CTRL2_ENABLE1_PD_SHIFT		0x02
> +#define TPS65917_PU_PD_INPUT_CTRL2_NSLEEP_PU			0x02
> +#define TPS65917_PU_PD_INPUT_CTRL2_NSLEEP_PU_SHIFT		0x01
> +#define TPS65917_PU_PD_INPUT_CTRL2_NSLEEP_PD			0x01
> +#define TPS65917_PU_PD_INPUT_CTRL2_NSLEEP_PD_SHIFT		0x00
> +
> +/* Bit definitions for PU_PD_INPUT_CTRL3 */
> +#define TPS65917_PU_PD_INPUT_CTRL3_SYNCDCDC_PD			0x40
> +#define TPS65917_PU_PD_INPUT_CTRL3_SYNCDCDC_PD_SHIFT		0x06
> +#define TPS65917_PU_PD_INPUT_CTRL3_POWERHOLD_PD		0x04
> +#define TPS65917_PU_PD_INPUT_CTRL3_POWERHOLD_PD_SHIFT		0x02
> +
> +/* Bit definitions for OD_OUTPUT_CTRL */
> +#define TPS65917_OD_OUTPUT_CTRL_INT_OD				0x08
> +#define TPS65917_OD_OUTPUT_CTRL_INT_OD_SHIFT			0x03
> +
> +/* Bit definitions for POLARITY_CTRL */
> +#define TPS65917_POLARITY_CTRL_INT_POLARITY			0x80
> +#define TPS65917_POLARITY_CTRL_INT_POLARITY_SHIFT		0x07
> +#define TPS65917_POLARITY_CTRL_GPIO_6_POLARITY			0x40
> +#define TPS65917_POLARITY_CTRL_GPIO_6_POLARITY_SHIFT		0x06
> +#define TPS65917_POLARITY_CTRL_GPIO_5_POLARITY			0x20
> +#define TPS65917_POLARITY_CTRL_GPIO_5_POLARITY_SHIFT		0x05
> +#define TPS65917_POLARITY_CTRL_GPIO_4_POLARITY			0x10
> +#define TPS65917_POLARITY_CTRL_GPIO_4_POLARITY_SHIFT		0x04
> +#define TPS65917_POLARITY_CTRL_GPIO_3_POLARITY			0x08
> +#define TPS65917_POLARITY_CTRL_GPIO_3_POLARITY_SHIFT		0x03
> +#define TPS65917_POLARITY_CTRL_GPIO_2_POLARITY			0x04
> +#define TPS65917_POLARITY_CTRL_GPIO_2_POLARITY_SHIFT		0x02
> +#define TPS65917_POLARITY_CTRL_GPIO_1_POLARITY			0x02
> +#define TPS65917_POLARITY_CTRL_GPIO_1_POLARITY_SHIFT		0x01
> +#define TPS65917_POLARITY_CTRL_GPIO_0_POLARITY			0x01
> +#define TPS65917_POLARITY_CTRL_GPIO_0_POLARITY_SHIFT		0x00
> +
> +/* Bit definitions for PRIMARY_SECONDARY_PAD1 */
> +#define TPS65917_PRIMARY_SECONDARY_PAD1_GPIO_3			0xC0
> +#define TPS65917_PRIMARY_SECONDARY_PAD1_GPIO_3_SHIFT		0x06
> +#define TPS65917_PRIMARY_SECONDARY_PAD1_GPIO_2			0x30
> +#define TPS65917_PRIMARY_SECONDARY_PAD1_GPIO_2_SHIFT		0x04
> +#define TPS65917_PRIMARY_SECONDARY_GPIO_1			0x0C
> +#define TPS65917_PRIMARY_SECONDARY_GPIO_1_SHIFT		0x02
> +#define TPS65917_PRIMARY_SECONDARY_PAD1_GPIO_0			0x03
> +#define TPS65917_PRIMARY_SECONDARY_PAD1_GPIO_0_SHIFT		0x00
> +
> +/* Bit definitions for PRIMARY_SECONDARY_PAD2 */
> +#define TPS65917_PRIMARY_SECONDARY_PAD2_SYNCCLKOUT_MASK	0x40
> +#define TPS65917_PRIMARY_SECONDARY_PAD2_SYNCCLKOUT_SHIFT	0x06
> +#define TPS65917_PRIMARY_SECONDARY_PAD2_GPIO_6			0x30
> +#define TPS65917_PRIMARY_SECONDARY_PAD2_GPIO_6_SHIFT		0x04
> +#define TPS65917_PRIMARY_SECONDARY_PAD2_GPIO_5			0x0C
> +#define TPS65917_PRIMARY_SECONDARY_PAD2_GPIO_5_SHIFT		0x02
> +#define TPS65917_PRIMARY_SECONDARY_PAD2_GPIO_4			0x03
> +#define TPS65917_PRIMARY_SECONDARY_PAD2_GPIO_4_SHIFT		0x00
> +
> +/* Bit definitions for I2C_SPI */
> +#define TPS65917_I2C_SPI_I2C2OTP_EN				0x80
> +#define TPS65917_I2C_SPI_I2C2OTP_EN_SHIFT			0x07
> +#define TPS65917_I2C_SPI_I2C2OTP_PAGESEL			0x40
> +#define TPS65917_I2C_SPI_I2C2OTP_PAGESEL_SHIFT			0x06
> +#define TPS65917_I2C_SPI_ID_I2C2				0x20
> +#define TPS65917_I2C_SPI_ID_I2C2_SHIFT				0x05
> +#define TPS65917_I2C_SPI_I2C_SPI				0x10
> +#define TPS65917_I2C_SPI_I2C_SPI_SHIFT				0x04
> +#define TPS65917_I2C_SPI_ID_I2C1_MASK				0x0F
> +#define TPS65917_I2C_SPI_ID_I2C1_SHIFT				0x00
> +
> +/* Bit definitions for PU_PD_INPUT_CTRL4 */
> +#define TPS65917_PU_PD_INPUT_CTRL4_DVFS2_DAT_PD		0x40
> +#define TPS65917_PU_PD_INPUT_CTRL4_DVFS2_DAT_PD_SHIFT		0x06
> +#define TPS65917_PU_PD_INPUT_CTRL4_DVFS2_CLK_PD		0x10
> +#define TPS65917_PU_PD_INPUT_CTRL4_DVFS2_CLK_PD_SHIFT		0x04
> +#define TPS65917_PU_PD_INPUT_CTRL4_DVFS1_DAT_PD		0x04
> +#define TPS65917_PU_PD_INPUT_CTRL4_DVFS1_DAT_PD_SHIFT		0x02
> +#define TPS65917_PU_PD_INPUT_CTRL4_DVFS1_CLK_PD		0x01
> +#define TPS65917_PU_PD_INPUT_CTRL4_DVFS1_CLK_PD_SHIFT		0x00
> +
> +/* Bit definitions for PRIMARY_SECONDARY_PAD3 */
> +#define TPS65917_PRIMARY_SECONDARY_PAD3_DVFS2			0x02
> +#define TPS65917_PRIMARY_SECONDARY_PAD3_DVFS2_SHIFT		0x01
> +#define TPS65917_PRIMARY_SECONDARY_PAD3_DVFS1			0x01
> +#define TPS65917_PRIMARY_SECONDARY_PAD3_DVFS1_SHIFT		0x00
> +
> +/* Registers for function INTERRUPT */
> +#define TPS65917_INT1_STATUS					0x00
> +#define TPS65917_INT1_MASK					0x01
> +#define TPS65917_INT1_LINE_STATE				0x02
> +#define TPS65917_INT2_STATUS					0x05
> +#define TPS65917_INT2_MASK					0x06
> +#define TPS65917_INT2_LINE_STATE				0x07
> +#define TPS65917_INT3_STATUS					0x0A
> +#define TPS65917_INT3_MASK					0x0B
> +#define TPS65917_INT3_LINE_STATE				0x0C
> +#define TPS65917_INT4_STATUS					0x0F
> +#define TPS65917_INT4_MASK					0x10
> +#define TPS65917_INT4_LINE_STATE				0x11
> +#define TPS65917_INT4_EDGE_DETECT1				0x12
> +#define TPS65917_INT4_EDGE_DETECT2				0x13
> +#define TPS65917_INT_CTRL					0x14
> +
> +/* Bit definitions for INT1_STATUS */
> +#define TPS65917_INT1_STATUS_VSYS_MON				0x40
> +#define TPS65917_INT1_STATUS_VSYS_MON_SHIFT			0x06
> +#define TPS65917_INT1_STATUS_HOTDIE				0x20
> +#define TPS65917_INT1_STATUS_HOTDIE_SHIFT			0x05
> +#define TPS65917_INT1_STATUS_PWRDOWN				0x10
> +#define TPS65917_INT1_STATUS_PWRDOWN_SHIFT			0x04
> +#define TPS65917_INT1_STATUS_LONG_PRESS_KEY			0x04
> +#define TPS65917_INT1_STATUS_LONG_PRESS_KEY_SHIFT		0x02
> +#define TPS65917_INT1_STATUS_PWRON				0x02
> +#define TPS65917_INT1_STATUS_PWRON_SHIFT			0x01
> +
> +/* Bit definitions for INT1_MASK */
> +#define TPS65917_INT1_MASK_VSYS_MON				0x40
> +#define TPS65917_INT1_MASK_VSYS_MON_SHIFT			0x06
> +#define TPS65917_INT1_MASK_HOTDIE				0x20
> +#define TPS65917_INT1_MASK_HOTDIE_SHIFT			0x05
> +#define TPS65917_INT1_MASK_PWRDOWN				0x10
> +#define TPS65917_INT1_MASK_PWRDOWN_SHIFT			0x04
> +#define TPS65917_INT1_MASK_LONG_PRESS_KEY			0x04
> +#define TPS65917_INT1_MASK_LONG_PRESS_KEY_SHIFT		0x02
> +#define TPS65917_INT1_MASK_PWRON				0x02
> +#define TPS65917_INT1_MASK_PWRON_SHIFT				0x01
> +
> +/* Bit definitions for INT1_LINE_STATE */
> +#define TPS65917_INT1_LINE_STATE_VSYS_MON			0x40
> +#define TPS65917_INT1_LINE_STATE_VSYS_MON_SHIFT		0x06
> +#define TPS65917_INT1_LINE_STATE_HOTDIE			0x20
> +#define TPS65917_INT1_LINE_STATE_HOTDIE_SHIFT			0x05
> +#define TPS65917_INT1_LINE_STATE_PWRDOWN			0x10
> +#define TPS65917_INT1_LINE_STATE_PWRDOWN_SHIFT			0x04
> +#define TPS65917_INT1_LINE_STATE_LONG_PRESS_KEY		0x04
> +#define TPS65917_INT1_LINE_STATE_LONG_PRESS_KEY_SHIFT		0x02
> +#define TPS65917_INT1_LINE_STATE_PWRON				0x02
> +#define TPS65917_INT1_LINE_STATE_PWRON_SHIFT			0x01
> +
> +/* Bit definitions for INT2_STATUS */
> +#define TPS65917_INT2_STATUS_SHORT				0x40
> +#define TPS65917_INT2_STATUS_SHORT_SHIFT			0x06
> +#define TPS65917_INT2_STATUS_FSD				0x20
> +#define TPS65917_INT2_STATUS_FSD_SHIFT				0x05
> +#define TPS65917_INT2_STATUS_RESET_IN				0x10
> +#define TPS65917_INT2_STATUS_RESET_IN_SHIFT			0x04
> +#define TPS65917_INT2_STATUS_WDT				0x04
> +#define TPS65917_INT2_STATUS_WDT_SHIFT				0x02
> +#define TPS65917_INT2_STATUS_OTP_ERROR				0x02
> +#define TPS65917_INT2_STATUS_OTP_ERROR_SHIFT			0x01
> +
> +/* Bit definitions for INT2_MASK */
> +#define TPS65917_INT2_MASK_SHORT				0x40
> +#define TPS65917_INT2_MASK_SHORT_SHIFT				0x06
> +#define TPS65917_INT2_MASK_FSD					0x20
> +#define TPS65917_INT2_MASK_FSD_SHIFT				0x05
> +#define TPS65917_INT2_MASK_RESET_IN				0x10
> +#define TPS65917_INT2_MASK_RESET_IN_SHIFT			0x04
> +#define TPS65917_INT2_MASK_WDT					0x04
> +#define TPS65917_INT2_MASK_WDT_SHIFT				0x02
> +#define TPS65917_INT2_MASK_OTP_ERROR_TIMER			0x02
> +#define TPS65917_INT2_MASK_OTP_ERROR_SHIFT			0x01
> +
> +/* Bit definitions for INT2_LINE_STATE */
> +#define TPS65917_INT2_LINE_STATE_SHORT				0x40
> +#define TPS65917_INT2_LINE_STATE_SHORT_SHIFT			0x06
> +#define TPS65917_INT2_LINE_STATE_FSD				0x20
> +#define TPS65917_INT2_LINE_STATE_FSD_SHIFT			0x05
> +#define TPS65917_INT2_LINE_STATE_RESET_IN			0x10
> +#define TPS65917_INT2_LINE_STATE_RESET_IN_SHIFT		0x04
> +#define TPS65917_INT2_LINE_STATE_WDT				0x04
> +#define TPS65917_INT2_LINE_STATE_WDT_SHIFT			0x02
> +#define TPS65917_INT2_LINE_STATE_OTP_ERROR			0x02
> +#define TPS65917_INT2_LINE_STATE_OTP_ERROR_SHIFT		0x01
> +
> +/* Bit definitions for INT3_STATUS */
> +#define TPS65917_INT3_STATUS_VBUS				0x80
> +#define TPS65917_INT3_STATUS_VBUS_SHIFT			0x07
> +#define TPS65917_INT3_STATUS_GPADC_EOC_SW			0x04
> +#define TPS65917_INT3_STATUS_GPADC_EOC_SW_SHIFT		0x02
> +#define TPS65917_INT3_STATUS_GPADC_AUTO_1			0x02
> +#define TPS65917_INT3_STATUS_GPADC_AUTO_1_SHIFT		0x01
> +#define TPS65917_INT3_STATUS_GPADC_AUTO_0			0x01
> +#define TPS65917_INT3_STATUS_GPADC_AUTO_0_SHIFT		0x00
> +
> +/* Bit definitions for INT3_MASK */
> +#define TPS65917_INT3_MASK_VBUS				0x80
> +#define TPS65917_INT3_MASK_VBUS_SHIFT				0x07
> +#define TPS65917_INT3_MASK_GPADC_EOC_SW			0x04
> +#define TPS65917_INT3_MASK_GPADC_EOC_SW_SHIFT			0x02
> +#define TPS65917_INT3_MASK_GPADC_AUTO_1			0x02
> +#define TPS65917_INT3_MASK_GPADC_AUTO_1_SHIFT			0x01
> +#define TPS65917_INT3_MASK_GPADC_AUTO_0			0x01
> +#define TPS65917_INT3_MASK_GPADC_AUTO_0_SHIFT			0x00
> +
> +/* Bit definitions for INT3_LINE_STATE */
> +#define TPS65917_INT3_LINE_STATE_VBUS				0x80
> +#define TPS65917_INT3_LINE_STATE_VBUS_SHIFT			0x07
> +#define TPS65917_INT3_LINE_STATE_GPADC_EOC_SW			0x04
> +#define TPS65917_INT3_LINE_STATE_GPADC_EOC_SW_SHIFT		0x02
> +#define TPS65917_INT3_LINE_STATE_GPADC_AUTO_1			0x02
> +#define TPS65917_INT3_LINE_STATE_GPADC_AUTO_1_SHIFT		0x01
> +#define TPS65917_INT3_LINE_STATE_GPADC_AUTO_0			0x01
> +#define TPS65917_INT3_LINE_STATE_GPADC_AUTO_0_SHIFT		0x00
> +
> +/* Bit definitions for INT4_STATUS */
> +#define TPS65917_INT4_STATUS_GPIO_6				0x40
> +#define TPS65917_INT4_STATUS_GPIO_6_SHIFT			0x06
> +#define TPS65917_INT4_STATUS_GPIO_5				0x20
> +#define TPS65917_INT4_STATUS_GPIO_5_SHIFT			0x05
> +#define TPS65917_INT4_STATUS_GPIO_4				0x10
> +#define TPS65917_INT4_STATUS_GPIO_4_SHIFT			0x04
> +#define TPS65917_INT4_STATUS_GPIO_3				0x08
> +#define TPS65917_INT4_STATUS_GPIO_3_SHIFT			0x03
> +#define TPS65917_INT4_STATUS_GPIO_2				0x04
> +#define TPS65917_INT4_STATUS_GPIO_2_SHIFT			0x02
> +#define TPS65917_INT4_STATUS_GPIO_1				0x02
> +#define TPS65917_INT4_STATUS_GPIO_1_SHIFT			0x01
> +#define TPS65917_INT4_STATUS_GPIO_0				0x01
> +#define TPS65917_INT4_STATUS_GPIO_0_SHIFT			0x00
> +
> +/* Bit definitions for INT4_MASK */
> +#define TPS65917_INT4_MASK_GPIO_6				0x40
> +#define TPS65917_INT4_MASK_GPIO_6_SHIFT			0x06
> +#define TPS65917_INT4_MASK_GPIO_5				0x20
> +#define TPS65917_INT4_MASK_GPIO_5_SHIFT			0x05
> +#define TPS65917_INT4_MASK_GPIO_4				0x10
> +#define TPS65917_INT4_MASK_GPIO_4_SHIFT			0x04
> +#define TPS65917_INT4_MASK_GPIO_3				0x08
> +#define TPS65917_INT4_MASK_GPIO_3_SHIFT			0x03
> +#define TPS65917_INT4_MASK_GPIO_2				0x04
> +#define TPS65917_INT4_MASK_GPIO_2_SHIFT			0x02
> +#define TPS65917_INT4_MASK_GPIO_1				0x02
> +#define TPS65917_INT4_MASK_GPIO_1_SHIFT			0x01
> +#define TPS65917_INT4_MASK_GPIO_0				0x01
> +#define TPS65917_INT4_MASK_GPIO_0_SHIFT			0x00
> +
> +/* Bit definitions for INT4_LINE_STATE */
> +#define TPS65917_INT4_LINE_STATE_GPIO_6			0x40
> +#define TPS65917_INT4_LINE_STATE_GPIO_6_SHIFT			0x06
> +#define TPS65917_INT4_LINE_STATE_GPIO_5			0x20
> +#define TPS65917_INT4_LINE_STATE_GPIO_5_SHIFT			0x05
> +#define TPS65917_INT4_LINE_STATE_GPIO_4			0x10
> +#define TPS65917_INT4_LINE_STATE_GPIO_4_SHIFT			0x04
> +#define TPS65917_INT4_LINE_STATE_GPIO_3			0x08
> +#define TPS65917_INT4_LINE_STATE_GPIO_3_SHIFT			0x03
> +#define TPS65917_INT4_LINE_STATE_GPIO_2			0x04
> +#define TPS65917_INT4_LINE_STATE_GPIO_2_SHIFT			0x02
> +#define TPS65917_INT4_LINE_STATE_GPIO_1			0x02
> +#define TPS65917_INT4_LINE_STATE_GPIO_1_SHIFT			0x01
> +#define TPS65917_INT4_LINE_STATE_GPIO_0			0x01
> +#define TPS65917_INT4_LINE_STATE_GPIO_0_SHIFT			0x00
> +
> +/* Bit definitions for INT4_EDGE_DETECT1 */
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_3_RISING		0x80
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_3_RISING_SHIFT		0x07
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_3_FALLING		0x40
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_3_FALLING_SHIFT	0x06
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_2_RISING		0x20
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_2_RISING_SHIFT		0x05
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_2_FALLING		0x10
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_2_FALLING_SHIFT	0x04
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_1_RISING		0x08
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_1_RISING_SHIFT		0x03
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_1_FALLING		0x04
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_1_FALLING_SHIFT	0x02
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_0_RISING		0x02
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_0_RISING_SHIFT		0x01
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_0_FALLING		0x01
> +#define TPS65917_INT4_EDGE_DETECT1_GPIO_0_FALLING_SHIFT	0x00
> +
> +/* Bit definitions for INT4_EDGE_DETECT2 */
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_6_RISING		0x20
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_6_RISING_SHIFT		0x05
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_6_FALLING		0x10
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_6_FALLING_SHIFT	0x04
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_5_RISING		0x08
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_5_RISING_SHIFT		0x03
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_5_FALLING		0x04
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_5_FALLING_SHIFT	0x02
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_4_RISING		0x02
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_4_RISING_SHIFT		0x01
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_4_FALLING		0x01
> +#define TPS65917_INT4_EDGE_DETECT2_GPIO_4_FALLING_SHIFT	0x00
> +
> +/* Bit definitions for INT_CTRL */
> +#define TPS65917_INT_CTRL_INT_PENDING				0x04
> +#define TPS65917_INT_CTRL_INT_PENDING_SHIFT			0x02
> +#define TPS65917_INT_CTRL_INT_CLEAR				0x01
> +#define TPS65917_INT_CTRL_INT_CLEAR_SHIFT			0x00
> +
> +
> +/* Registers for function GPIO */
> +#define TPS65917_GPIO_DATA_IN					0x00
> +#define TPS65917_GPIO_DATA_DIR					0x01
> +#define TPS65917_GPIO_DATA_OUT					0x02
> +#define TPS65917_GPIO_DEBOUNCE_EN				0x03
> +#define TPS65917_GPIO_CLEAR_DATA_OUT				0x04
> +#define TPS65917_GPIO_SET_DATA_OUT				0x05
> +#define TPS65917_PU_PD_GPIO_CTRL1				0x06
> +#define TPS65917_PU_PD_GPIO_CTRL2				0x07
> +#define TPS65917_OD_OUTPUT_GPIO_CTRL				0x08
> +
> +/* Bit definitions for GPIO_DATA_IN */
> +#define TPS65917_GPIO_DATA_IN_GPIO_6_IN			0x40
> +#define TPS65917_GPIO_DATA_IN_GPIO_6_IN_SHIFT			0x06
> +#define TPS65917_GPIO_DATA_IN_GPIO_5_IN			0x20
> +#define TPS65917_GPIO_DATA_IN_GPIO_5_IN_SHIFT			0x05
> +#define TPS65917_GPIO_DATA_IN_GPIO_4_IN			0x10
> +#define TPS65917_GPIO_DATA_IN_GPIO_4_IN_SHIFT			0x04
> +#define TPS65917_GPIO_DATA_IN_GPIO_3_IN			0x08
> +#define TPS65917_GPIO_DATA_IN_GPIO_3_IN_SHIFT			0x03
> +#define TPS65917_GPIO_DATA_IN_GPIO_2_IN			0x04
> +#define TPS65917_GPIO_DATA_IN_GPIO_2_IN_SHIFT			0x02
> +#define TPS65917_GPIO_DATA_IN_GPIO_1_IN			0x02
> +#define TPS65917_GPIO_DATA_IN_GPIO_1_IN_SHIFT			0x01
> +#define TPS65917_GPIO_DATA_IN_GPIO_0_IN			0x01
> +#define TPS65917_GPIO_DATA_IN_GPIO_0_IN_SHIFT			0x00
> +
> +/* Bit definitions for GPIO_DATA_DIR */
> +#define TPS65917_GPIO_DATA_DIR_GPIO_6_DIR			0x40
> +#define TPS65917_GPIO_DATA_DIR_GPIO_6_DIR_SHIFT		0x06
> +#define TPS65917_GPIO_DATA_DIR_GPIO_5_DIR			0x20
> +#define TPS65917_GPIO_DATA_DIR_GPIO_5_DIR_SHIFT		0x05
> +#define TPS65917_GPIO_DATA_DIR_GPIO_4_DIR			0x10
> +#define TPS65917_GPIO_DATA_DIR_GPIO_4_DIR_SHIFT		0x04
> +#define TPS65917_GPIO_DATA_DIR_GPIO_3_DIR			0x08
> +#define TPS65917_GPIO_DATA_DIR_GPIO_3_DIR_SHIFT		0x03
> +#define TPS65917_GPIO_DATA_DIR_GPIO_2_DIR			0x04
> +#define TPS65917_GPIO_DATA_DIR_GPIO_2_DIR_SHIFT		0x02
> +#define TPS65917_GPIO_DATA_DIR_GPIO_1_DIR			0x02
> +#define TPS65917_GPIO_DATA_DIR_GPIO_1_DIR_SHIFT		0x01
> +#define TPS65917_GPIO_DATA_DIR_GPIO_0_DIR			0x01
> +#define TPS65917_GPIO_DATA_DIR_GPIO_0_DIR_SHIFT		0x00
> +
> +/* Bit definitions for GPIO_DATA_OUT */
> +#define TPS65917_GPIO_DATA_OUT_GPIO_6_OUT			0x40
> +#define TPS65917_GPIO_DATA_OUT_GPIO_6_OUT_SHIFT		0x06
> +#define TPS65917_GPIO_DATA_OUT_GPIO_5_OUT			0x20
> +#define TPS65917_GPIO_DATA_OUT_GPIO_5_OUT_SHIFT		0x05
> +#define TPS65917_GPIO_DATA_OUT_GPIO_4_OUT			0x10
> +#define TPS65917_GPIO_DATA_OUT_GPIO_4_OUT_SHIFT		0x04
> +#define TPS65917_GPIO_DATA_OUT_GPIO_3_OUT			0x08
> +#define TPS65917_GPIO_DATA_OUT_GPIO_3_OUT_SHIFT		0x03
> +#define TPS65917_GPIO_DATA_OUT_GPIO_2_OUT			0x04
> +#define TPS65917_GPIO_DATA_OUT_GPIO_2_OUT_SHIFT		0x02
> +#define TPS65917_GPIO_DATA_OUT_GPIO_1_OUT			0x02
> +#define TPS65917_GPIO_DATA_OUT_GPIO_1_OUT_SHIFT		0x01
> +#define TPS65917_GPIO_DATA_OUT_GPIO_0_OUT			0x01
> +#define TPS65917_GPIO_DATA_OUT_GPIO_0_OUT_SHIFT		0x00
> +
> +/* Bit definitions for GPIO_DEBOUNCE_EN */
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_6_DEBOUNCE_EN		0x40
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_6_DEBOUNCE_EN_SHIFT	0x06
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_5_DEBOUNCE_EN		0x20
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_5_DEBOUNCE_EN_SHIFT	0x05
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_4_DEBOUNCE_EN		0x10
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_4_DEBOUNCE_EN_SHIFT	0x04
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_3_DEBOUNCE_EN		0x08
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_3_DEBOUNCE_EN_SHIFT	0x03
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_2_DEBOUNCE_EN		0x04
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_2_DEBOUNCE_EN_SHIFT	0x02
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_1_DEBOUNCE_EN		0x02
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_1_DEBOUNCE_EN_SHIFT	0x01
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_0_DEBOUNCE_EN		0x01
> +#define TPS65917_GPIO_DEBOUNCE_EN_GPIO_0_DEBOUNCE_EN_SHIFT	0x00
> +
> +/* Bit definitions for GPIO_CLEAR_DATA_OUT */
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_6_CLEAR_DATA_OUT		0x40
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_6_CLEAR_DATA_OUT_SHIFT	0x06
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_5_CLEAR_DATA_OUT		0x20
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_5_CLEAR_DATA_OUT_SHIFT	0x05
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_4_CLEAR_DATA_OUT		0x10
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_4_CLEAR_DATA_OUT_SHIFT	0x04
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_3_CLEAR_DATA_OUT		0x08
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_3_CLEAR_DATA_OUT_SHIFT	0x03
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_2_CLEAR_DATA_OUT		0x04
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_2_CLEAR_DATA_OUT_SHIFT	0x02
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_1_CLEAR_DATA_OUT		0x02
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_1_CLEAR_DATA_OUT_SHIFT	0x01
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_0_CLEAR_DATA_OUT		0x01
> +#define TPS65917_GPIO_CLEAR_DATA_OUT_GPIO_0_CLEAR_DATA_OUT_SHIFT	0x00
> +
> +/* Bit definitions for GPIO_SET_DATA_OUT */
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_6_SET_DATA_OUT		0x40
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_6_SET_DATA_OUT_SHIFT	0x06
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_5_SET_DATA_OUT		0x20
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_5_SET_DATA_OUT_SHIFT	0x05
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_4_SET_DATA_OUT		0x10
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_4_SET_DATA_OUT_SHIFT	0x04
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_3_SET_DATA_OUT		0x08
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_3_SET_DATA_OUT_SHIFT	0x03
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_2_SET_DATA_OUT		0x04
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_2_SET_DATA_OUT_SHIFT	0x02
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_1_SET_DATA_OUT		0x02
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_1_SET_DATA_OUT_SHIFT	0x01
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_0_SET_DATA_OUT		0x01
> +#define TPS65917_GPIO_SET_DATA_OUT_GPIO_0_SET_DATA_OUT_SHIFT	0x00
> +
> +/* Bit definitions for PU_PD_GPIO_CTRL1 */
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_3_PD			0x40
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_3_PD_SHIFT		0x06
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_2_PU			0x20
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_2_PU_SHIFT		0x05
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_2_PD			0x10
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_2_PD_SHIFT		0x04
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_1_PD			0x04
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_1_PD_SHIFT		0x02
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_0_PD			0x01
> +#define TPS65917_PU_PD_GPIO_CTRL1_GPIO_0_PD_SHIFT		0x00
> +
> +/* Bit definitions for PU_PD_GPIO_CTRL2 */
> +#define TPS65917_PU_PD_GPIO_CTRL2_GPIO_6_PD			0x10
> +#define TPS65917_PU_PD_GPIO_CTRL2_GPIO_6_PD_SHIFT		0x04
> +#define TPS65917_PU_PD_GPIO_CTRL2_GPIO_5_PD			0x04
> +#define TPS65917_PU_PD_GPIO_CTRL2_GPIO_5_PD_SHIFT		0x02
> +#define TPS65917_PU_PD_GPIO_CTRL2_GPIO_4_PU			0x02
> +#define TPS65917_PU_PD_GPIO_CTRL2_GPIO_4_PU_SHIFT		0x01
> +#define TPS65917_PU_PD_GPIO_CTRL2_GPIO_4_PD			0x01
> +#define TPS65917_PU_PD_GPIO_CTRL2_GPIO_4_PD_SHIFT		0x00
> +
> +/* Bit definitions for OD_OUTPUT_GPIO_CTRL */
> +#define TPS65917_OD_OUTPUT_GPIO_CTRL_GPIO_4_OD			0x10
> +#define TPS65917_OD_OUTPUT_GPIO_CTRL_GPIO_4_OD_SHIFT		0x04
> +#define TPS65917_OD_OUTPUT_GPIO_CTRL_GPIO_2_OD			0x04
> +#define TPS65917_OD_OUTPUT_GPIO_CTRL_GPIO_2_OD_SHIFT		0x02
> +
> +/* Registers for function GPADC */
> +#define TPS65917_GPADC_CTRL1					0x00
> +#define TPS65917_GPADC_AUTO_CTRL				0x03
> +#define TPS65917_GPADC_STATUS					0x04
> +#define TPS65917_GPADC_AUTO_SELECT				0x08
> +#define TPS65917_GPADC_AUTO_CONV0_LSB				0x09
> +#define TPS65917_GPADC_AUTO_CONV0_MSB				0x0A
> +#define TPS65917_GPADC_AUTO_CONV1_LSB				0x0B
> +#define TPS65917_GPADC_AUTO_CONV1_MSB				0x0C
> +#define TPS65917_GPADC_SW_SELECT				0x0D
> +#define TPS65917_GPADC_SW_CONV0_LSB				0x0E
> +#define TPS65917_GPADC_SW_CONV0_MSB				0x0F
> +#define TPS65917_GPADC_THRES_CONV0_LSB				0x10
> +#define TPS65917_GPADC_THRES_CONV0_MSB				0x11
> +#define TPS65917_GPADC_THRES_CONV1_LSB				0x12
> +#define TPS65917_GPADC_THRES_CONV1_MSB				0x13
> +#define TPS65917_GPADC_SMPS_ILMONITOR_EN			0x14
> +#define TPS65917_GPADC_SMPS_VSEL_MONITORING			0x15
> +
> +#define TPS65917_GPADC_TRIM1					0x00
> +#define TPS65917_GPADC_TRIM2					0x01
> +#define TPS65917_GPADC_TRIM3					0x02
> +#define TPS65917_GPADC_TRIM4					0x03
> +#define TPS65917_GPADC_TRIM5					0x04
> +#define TPS65917_GPADC_TRIM6					0x05
> +#define TPS65917_GPADC_TRIM7					0x06
> +#define TPS65917_GPADC_TRIM8					0x07
> +#define TPS65917_GPADC_TRIM9					0x08
> +#define TPS65917_GPADC_TRIM10					0x09
> +#define TPS65917_GPADC_TRIM11					0x0A
> +#define TPS65917_GPADC_TRIM12					0x0B
> +#define TPS65917_GPADC_TRIM13					0x0C
> +#define TPS65917_GPADC_TRIM14					0x0D
> +#define TPS65917_GPADC_TRIM15					0x0E
> +#define TPS65917_GPADC_TRIM16					0x0F
> +
> +static inline int tps65917_read(struct tps65917 *tps65917, unsigned int base,
> +				unsigned int reg, unsigned int *val)
> +{
> +	unsigned int addr = TPS65917_BASE_TO_REG(base, reg);
> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
> +
> +	return regmap_read(tps65917->regmap[slave_id], addr, val);
> +}
> +
> +static inline int tps65917_write(struct tps65917 *tps65917, unsigned int base,
> +				 unsigned int reg, unsigned int value)
> +{
> +	unsigned int addr = TPS65917_BASE_TO_REG(base, reg);
> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
> +
> +	return regmap_write(tps65917->regmap[slave_id], addr, value);
> +}
> +
> +static inline int tps65917_bulk_write(struct tps65917 *tps65917,
> +				      unsigned int base,
> +				      unsigned int reg, const void *val,
> +				      size_t val_count)
> +{
> +	unsigned int addr = TPS65917_BASE_TO_REG(base, reg);
> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
> +
> +	return regmap_bulk_write(tps65917->regmap[slave_id], addr,
> +				 val, val_count);
> +}
> +
> +static inline int tps65917_bulk_read(struct tps65917 *tps65917,
> +				     unsigned int base,
> +				     unsigned int reg, void *val,
> +				     size_t val_count)
> +{
> +	unsigned int addr = TPS65917_BASE_TO_REG(base, reg);
> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
> +
> +	return regmap_bulk_read(tps65917->regmap[slave_id], addr,
> +				val, val_count);
> +}
> +
> +static inline int tps65917_update_bits(struct tps65917 *tps65917,
> +				       unsigned int base, unsigned int reg,
> +				       unsigned int mask, unsigned int val)
> +{
> +	unsigned int addr = TPS65917_BASE_TO_REG(base, reg);
> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
> +
> +	return regmap_update_bits(tps65917->regmap[slave_id], addr, mask, val);
> +}
> +
> +static inline int tps65917_irq_get_virq(struct tps65917 *tps65917, int irq)
> +{
> +	return regmap_irq_get_virq(tps65917->irq_data, irq);
> +}
> +
> +int tps65917_ext_control_req_config(struct tps65917 *tps65917,
> +				    enum tps65917_external_requestor_id ext_control_req_id,
> +				    int ext_ctrl, bool enable);
> +
> +#endif /*  __LINUX_MFD_TPS65917_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
