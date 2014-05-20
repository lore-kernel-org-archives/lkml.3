Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaETR0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:26:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39294 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaETR0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:26:49 -0400
Message-ID: <537B8FD1.7090003@ti.com>
Date: Tue, 20 May 2014 22:54:33 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>, <sameo@linux.intel.com>,
        <grant.likely@linaro.org>, <ian@slimlogic.co.uk>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <broonie@linaro.org>, <swarren@nvidia.com>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] mfd: tps65917: Add driver for the TPS65917 PMIC
References: <1400577099-8743-1-git-send-email-j-keerthy@ti.com> <1400577099-8743-4-git-send-email-j-keerthy@ti.com> <20140520135844.GP24991@lee--X1>
In-Reply-To: <20140520135844.GP24991@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee Jones,

Thanks for the review.

On Tuesday 20 May 2014 07:28 PM, Lee Jones wrote:
>> The TPS65917 chip is a power management IC for Portable Navigation Systems
>> and Tablet Computing devices. It contains the following components:
>>
>>   - Regulators.
>>   - Over Temperature warning and Shut down.
>>
>> This patch adds support for tps65917 mfd device. At this time only
>> the regulator functionality is made available.
>>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> ---
>> Changes in V2:
>>
>> Added volatile register check as some of the registers
>> in the set are volatile.
>>
>>   drivers/mfd/Kconfig          |   12 +
>>   drivers/mfd/Makefile         |    1 +
>>   drivers/mfd/tps65917.c       |  573 ++++++++++++++++
> We have quite the collection of tps* files now in MFD.  How different
> are they really?  Is consolidation possible?

Unfortunately yes! This is pretty similar to Palmas. Register offsets
are completely different and i have already compensated TPS659038
which essentially had the same register set.

I am pretty much based on Palmas driver but most of the register offsets
are different and this is a much smaller and simpler PMIC. Hence
adding a new driver.

>
>>   include/linux/mfd/tps65917.h | 1509 ++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 2095 insertions(+)
>>   create mode 100644 drivers/mfd/tps65917.c
>>   create mode 100644 include/linux/mfd/tps65917.h
>>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index 3383412..ac73e58 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -925,6 +925,18 @@ config MFD_TPS65912_SPI
>>   	  If you say yes here you get support for the TPS65912 series of
>>   	  PM chips with SPI interface.
>>   
>> +config MFD_TPS65917
>> +	bool "TI TPS65917 series chips"
>> +	select MFD_CORE
>> +	select REGMAP_I2C
>> +	select REGMAP_IRQ
>> +	depends on I2C=y
>> +	help
>> +	  If you say yes here you get support for the TPS65917
>> +	  PMIC chips from Texas Instruments. The device provides
>> +	  5 confgurable SPMSs and 5 LDOs, thermal protection module,
>> +	  GPADC.
>> +
>>   config MFD_TPS80031
>>   	bool "TI TPS80031/TPS80032 Power Management chips"
>>   	depends on I2C=y
>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>> index 2851275..248a60b 100644
>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -69,6 +69,7 @@ tps65912-objs                   := tps65912-core.o tps65912-irq.o
>>   obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o
>>   obj-$(CONFIG_MFD_TPS65912_I2C)	+= tps65912-i2c.o
>>   obj-$(CONFIG_MFD_TPS65912_SPI)  += tps65912-spi.o
>> +obj-$(CONFIG_MFD_TPS65917)	+= tps65917.o
>>   obj-$(CONFIG_MFD_TPS80031)	+= tps80031.o
>>   obj-$(CONFIG_MENELAUS)		+= menelaus.o
>>   
>> diff --git a/drivers/mfd/tps65917.c b/drivers/mfd/tps65917.c
>> new file mode 100644
>> index 0000000..dbd67c5
>> --- /dev/null
>> +++ b/drivers/mfd/tps65917.c
>> @@ -0,0 +1,573 @@
>> +/*
>> + * TI TPS65917 Integrated power management chipsets
>> + *
>> + * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com/
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether expressed or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License version 2 for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/moduleparam.h>
>> +#include <linux/init.h>
>> +#include <linux/slab.h>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/irq.h>
>> +#include <linux/regmap.h>
>> +#include <linux/err.h>
>> +#include <linux/mfd/core.h>
>> +#include <linux/mfd/tps65917.h>
>> +#include <linux/of_device.h>
>> +
>> +#define TPS65917_EXT_REQ (TPS65917_EXT_CONTROL_ENABLE1 |	\
>> +			TPS65917_EXT_CONTROL_ENABLE2 |	\
>> +			TPS65917_EXT_CONTROL_NSLEEP)
>> +
>> +struct tps65917_sleep_requestor_info {
>> +	int id;
>> +	int reg_offset;
>> +	int bit_pos;
>> +};
>> +
>> +#define EXTERNAL_REQUESTOR(_id, _offset, _pos)		\
>> +		[TPS65917_EXTERNAL_REQSTR_ID_##_id] = {		\
>> +		.id = TPS65917_EXTERNAL_REQSTR_ID_##_id,	\
>> +		.reg_offset = _offset,			\
>> +		.bit_pos = _pos,			\
>> +	}
>> +
>> +static struct tps65917_sleep_requestor_info sleep_req_info[] = {
>> +	EXTERNAL_REQUESTOR(REGEN1, 0, 0),
>> +	EXTERNAL_REQUESTOR(REGEN2, 0, 1),
>> +	EXTERNAL_REQUESTOR(REGEN3, 0, 6),
>> +	EXTERNAL_REQUESTOR(SMPS1, 1, 0),
>> +	EXTERNAL_REQUESTOR(SMPS2, 1, 1),
>> +	EXTERNAL_REQUESTOR(SMPS3, 1, 2),
>> +	EXTERNAL_REQUESTOR(SMPS4, 1, 3),
>> +	EXTERNAL_REQUESTOR(SMPS5, 1, 4),
>> +	EXTERNAL_REQUESTOR(LDO1, 2, 0),
>> +	EXTERNAL_REQUESTOR(LDO2, 2, 1),
>> +	EXTERNAL_REQUESTOR(LDO3, 2, 2),
>> +	EXTERNAL_REQUESTOR(LDO4, 2, 3),
>> +	EXTERNAL_REQUESTOR(LDO5, 2, 4),
>> +};
>> +
>> +static int tps65917_voltaile_regs[] = {
>> +	TPS65917_SMPS1_CTRL,
>> +	TPS65917_SMPS2_CTRL,
>> +	TPS65917_SMPS3_CTRL,
>> +	TPS65917_SMPS4_CTRL,
>> +	TPS65917_SMPS5_CTRL,
>> +	TPS65917_LDO1_CTRL,
>> +	TPS65917_LDO2_CTRL,
>> +	TPS65917_LDO3_CTRL,
>> +	TPS65917_LDO4_CTRL,
>> +	TPS65917_LDO5_CTRL,
>> +};
>> +
>> +static bool is_volatile_reg(struct device *dev, unsigned int reg)
>> +{
>> +	int i;
>> +
>> +	/*
>> +	 * Caching all the required regulator registers.
>> +	 */
>> +
>> +	for (i = 0; i < 11; i++)
> Are you sure?  Looks like 10 to me.
>
> Use ARRAY_SIZE(tps65917_voltaile_regs) instead

I will use

ARRAY_SIZE(tps65917_voltaile_regs)

.
>
>> +		if (reg == tps65917_voltaile_regs[i])
>> +			return true;
>> +
>> +	return false;
>> +}
> [...]
>
>> +int tps65917_ext_control_req_config(struct tps65917 *tps65917,
>> +				    enum tps65917_external_requestor_id id,
>> +				    int ext_ctrl, bool enable)
>> +{
>> +	int preq_mask_bit = 0;
>> +	int reg_add = 0;
>> +	int bit_pos;
>> +	int ret;
>> +
>> +	if (!(ext_ctrl & TPS65917_EXT_REQ))
>> +		return 0;
>> +
>> +	if (id >= TPS65917_EXTERNAL_REQSTR_ID_MAX)
>> +		return 0;
>> +
>> +	if (ext_ctrl & TPS65917_EXT_CONTROL_NSLEEP) {
>> +		reg_add = TPS65917_NSLEEP_RES_ASSIGN;
>> +		preq_mask_bit = 0;
>> +	} else if (ext_ctrl & TPS65917_EXT_CONTROL_ENABLE1) {
>> +		reg_add = TPS65917_ENABLE1_RES_ASSIGN;
>> +		preq_mask_bit = 1;
>> +	} else if (ext_ctrl & TPS65917_EXT_CONTROL_ENABLE2) {
>> +		reg_add = TPS65917_ENABLE2_RES_ASSIGN;
>> +		preq_mask_bit = 2;
>> +	}
>> +
>> +	bit_pos = sleep_req_info[id].bit_pos;
>> +	reg_add += sleep_req_info[id].reg_offset;
> New line here.

Ok.

>> +	if (enable)
>> +		ret = tps65917_update_bits(tps65917, TPS65917_RESOURCE_BASE,
>> +					   reg_add, BIT(bit_pos), BIT(bit_pos));
>> +	else
>> +		ret = tps65917_update_bits(tps65917, TPS65917_RESOURCE_BASE,
>> +					   reg_add, BIT(bit_pos), 0);
> Would prefer:
>
> ret = tps65917_update_bits(tps65917, TPS65917_RESOURCE_BASE,
> 			   reg_add, BIT(bit_pos),
> 			   enable ? BIT(bit_pos) : 0);

Ok. I will do it this way.

>> +	if (ret < 0) {
>> +		dev_err(tps65917->dev, "Resource reg 0x%02x update failed %d\n",
>> +			reg_add, ret);
>> +		return ret;
>> +	}
>> +
>> +	/* Unmask the PREQ */
>> +	ret = tps65917_update_bits(tps65917, TPS65917_PMU_CONTROL_BASE,
>> +				   TPS65917_POWER_CTRL, BIT(preq_mask_bit), 0);
>> +	if (ret < 0) {
>> +		dev_err(tps65917->dev, "POWER_CTRL register update failed %d\n",
>> +			ret);
>> +		return ret;
>> +	}
>> +	return ret;
> Just display the error - the function returns 'ret' regardless.

Ok.

>
>> +}
>> +EXPORT_SYMBOL_GPL(tps65917_ext_control_req_config);
>> +
>> +static int tps65917_set_pdata_irq_flag(struct i2c_client *i2c,
>> +				       struct tps65917_platform_data *pdata)
>> +{
>> +	struct irq_data *irq_data = irq_get_irq_data(i2c->irq);
> New line here.
Ok

>
>> +	if (!irq_data) {
>> +		dev_err(&i2c->dev, "Invalid IRQ: %d\n", i2c->irq);
>> +		return -EINVAL;
>> +	}
>> +
>> +	pdata->irq_flags = irqd_get_trigger_type(irq_data);
>> +	dev_info(&i2c->dev, "Irq flag is 0x%08x\n", pdata->irq_flags);
> Is this line really required?
>
> New line here.
Yeah this is more dev_dbg. I will make it dev_dbg message.

>> +	return 0;
>> +}
>> +
>> +static void tps65917_dt_to_pdata(struct i2c_client *i2c,
>> +				 struct tps65917_platform_data *pdata)
>> +{
>> +	struct device_node *node = i2c->dev.of_node;
> What kind of node?
>
> Personally, I'd prefer the use of 'np' as a variable name.

Ok.

>> +	int ret;
>> +	u32 prop;
>> +
>> +	ret = of_property_read_u32(node, "ti,mux-pad1", &prop);
>> +	if (!ret) {
>> +		pdata->mux_from_pdata = 1;
> This should be a bool.
>
>> +		pdata->pad1 = prop;
>> +	}
>> +
>> +	ret = of_property_read_u32(node, "ti,mux-pad2", &prop);
>> +	if (!ret) {
>> +		pdata->mux_from_pdata = 1;
> As above.

Ok.

>
>> +		pdata->pad2 = prop;
>> +	}
>> +
>> +	/* The default for this register is all masked */n
>> +	ret = of_property_read_u32(node, "ti,power-ctrl", &prop);
>> +	if (!ret)
>> +		pdata->power_ctrl = prop;
>> +	else
>> +		pdata->power_ctrl = TPS65917_POWER_CTRL_NSLEEP_MASK |
>> +					TPS65917_POWER_CTRL_ENABLE1_MASK |
>> +					TPS65917_POWER_CTRL_ENABLE2_MASK;
>> +	if (i2c->irq)
>> +		tps65917_set_pdata_irq_flag(i2c, pdata);
> What's the point of tps65917_set_pdata_irq_flag() providing a return
> value and then not checking it?

Yes. I will remove this check. Largely borrowed from Palmas driver.

>
>> +	pdata->pm_off = of_property_read_bool(node,
>> +			"ti,system-power-controller");
>> +}
>> +
>> +static struct tps65917 *tps65917_dev;
> This is never used.
>
>> +static const struct of_device_id of_tps65917_match_tbl[] = {
>> +	{
>> +		.compatible = "ti,tps65917",
>> +	},
> This can all sit on one line.

Ok.

>
>> +	{ },
>> +};
>> +MODULE_DEVICE_TABLE(of, of_tps65917_match_tbl);
>> +
>> +static int tps65917_i2c_probe(struct i2c_client *i2c,
>> +			      const struct i2c_device_id *id)
>> +{
>> +	struct tps65917 *tps65917;
>> +	struct tps65917_platform_data *pdata;
>> +	struct device_node *node = i2c->dev.of_node;
>> +	int ret = 0, i;
> Break these into separate declarations.
>
> Nit: Put them with the other int declaration(s).

Ok.

>
>> +	unsigned int reg, addr, *features;
>> +	int slave;
>> +	const struct of_device_id *match;
>> +
>> +	pdata = dev_get_platdata(&i2c->dev);
>> +
>> +	if (node && !pdata) {
>> +		pdata = devm_kzalloc(&i2c->dev, sizeof(*pdata), GFP_KERNEL);
>> +
> Remove this line.

Ok.

>> +		if (!pdata)
>> +			return -ENOMEM;
>> +
>> +		tps65917_dt_to_pdata(i2c, pdata);
> I'm sure we can fail here.

They are optional properties. Hence no check.

> 		
>> +	}
>> +
>> +	if (!pdata)
>> +		return -EINVAL;
>> +
>> +	tps65917 = devm_kzalloc(&i2c->dev, sizeof(struct tps65917), GFP_KERNEL);
>> +	if (tps65917 == NULL)
> if (!tps65917)
Ok
>
>> +		return -ENOMEM;
>> +
>> +	i2c_set_clientdata(i2c, tps65917);
> Do this at the end after a clean start-up.
>
>> +	tps65917->dev = &i2c->dev;
>> +	tps65917->irq = i2c->irq;
> Or just save i2c.
>
>> +	match = of_match_device(of_tps65917_match_tbl, &i2c->dev);
>> +
> Remove this line.

Ok

>> +	if (!match)
>> +		return -ENODATA;
>> +
>> +	features = (unsigned int *)match->data;
> This will be NULL, please remove it.
>
> In fact, why are you even checking for a match?
>
> You only support one device.

Ok. Yes agreed.

>
>> +	for (i = 0; i < TPS65917_NUM_CLIENTS; i++) {
>> +		if (i == 0) {
>> +			tps65917->i2c_clients[i] = i2c;
>> +		} else {
>> +			tps65917->i2c_clients[i] =
>> +					i2c_new_dummy(i2c->adapter,
>> +						      i2c->addr + i);
>> +			if (!tps65917->i2c_clients[i]) {
>> +				dev_err(tps65917->dev,
>> +					"can't attach client %d\n", i);
>> +				ret = -ENOMEM;
>> +				goto err_i2c;
>> +			}
>> +			tps65917->i2c_clients[i]->dev.of_node = of_node_get(node);
>> +		}
> New line here.

Ok.

>> +		tps65917->regmap[i] = devm_regmap_init_i2c(tps65917->i2c_clients[i],
>> +							   &tps65917_regmap_config[i]);
>> +		if (IS_ERR(tps65917->regmap[i])) {
>> +			ret = PTR_ERR(tps65917->regmap[i]);
>> +			dev_err(tps65917->dev,
>> +				"Failed to allocate regmap %d, err: %d\n",
>> +				i, ret);
>> +			goto err_i2c;
>> +		}
>> +	}
>> +
>> +	if (!tps65917->irq) {
>> +		dev_warn(tps65917->dev, "IRQ missing: skipping irq request\n");
>> +		goto no_irq;
>> +	}
>> +
>> +	/* Change interrupt line output polarity */
>> +	if (pdata->irq_flags & IRQ_TYPE_LEVEL_HIGH)
>> +		reg = TPS65917_POLARITY_CTRL_INT_POLARITY;
>> +	else
>> +		reg = 0;
>> +	ret = tps65917_update_bits(tps65917, TPS65917_PU_PD_OD_BASE,
>> +				   TPS65917_POLARITY_CTRL,
>> +				   TPS65917_POLARITY_CTRL_INT_POLARITY, reg);
> Do you need to do this if reg == 0?

No. This can go under if.

>
>> +	if (ret < 0) {
>> +		dev_err(tps65917->dev, "POLARITY_CTRL updat failed: %d\n", ret);
>> +		goto err_i2c;
>> +	}
>> +
>> +	/* Change IRQ into clear on read mode for efficiency */
>> +	slave = TPS65917_BASE_TO_SLAVE(TPS65917_INTERRUPT_BASE);
>> +	addr = TPS65917_BASE_TO_REG(TPS65917_INTERRUPT_BASE, TPS65917_INT_CTRL);
>> +	reg = TPS65917_INT_CTRL_INT_CLEAR;
>> +
>> +	regmap_write(tps65917->regmap[slave], addr, reg);
>> +
>> +	ret = regmap_add_irq_chip(tps65917->regmap[slave], tps65917->irq,
>> +				  IRQF_ONESHOT | pdata->irq_flags, 0,
>> +				  &tps65917_irq_chip,
>> +				  &tps65917->irq_data);
>> +	if (ret < 0)
>> +		goto err_i2c;
>> +
>> +no_irq:
>> +	slave = TPS65917_BASE_TO_SLAVE(TPS65917_PU_PD_OD_BASE);
>> +	addr = TPS65917_BASE_TO_REG(TPS65917_PU_PD_OD_BASE,
>> +				    TPS65917_PRIMARY_SECONDARY_PAD1);
>> +
>> +	if (pdata->mux_from_pdata) {
>> +		reg = pdata->pad1;
>> +		ret = regmap_write(tps65917->regmap[slave], addr, reg);
>> +		if (ret)
>> +			goto err_irq;
>> +	} else {
>> +		ret = regmap_read(tps65917->regmap[slave], addr, &reg);
>> +		if (ret)
>> +			goto err_irq;
>> +	}
> Comment this to let us know what you're trying to do.

Ok.

>> +	addr = TPS65917_BASE_TO_REG(TPS65917_PU_PD_OD_BASE,
>> +				    TPS65917_PRIMARY_SECONDARY_PAD2);
>> +
>> +	if (pdata->mux_from_pdata) {
>> +		reg = pdata->pad2;
>> +		ret = regmap_write(tps65917->regmap[slave], addr, reg);
>> +		if (ret)
>> +			goto err_irq;
>> +	} else {
>> +		ret = regmap_read(tps65917->regmap[slave], addr, &reg);
>> +		if (ret)
>> +			goto err_irq;
>> +	}
> Same here.

Ok.

>> +	reg = pdata->power_ctrl;
>> +
>> +	slave = TPS65917_BASE_TO_SLAVE(TPS65917_PMU_CONTROL_BASE);
>> +	addr = TPS65917_BASE_TO_REG(TPS65917_PMU_CONTROL_BASE,
>> +				    TPS65917_POWER_CTRL);
>> +
>> +	ret = regmap_write(tps65917->regmap[slave], addr, reg);
>> +	if (ret)
>> +		goto err_irq;
> And here.
>
>> +	/*
>> +	 * If we are probing with DT do this the DT way and return here
>> +	 * otherwise continue and add devices using mfd helpers.
> MFD

Ok

>
>> +	 */
>> +	if (node) {
>> +		ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
> What is it you're registering here?  I don't see any child devices
> anywhere.
>
>> +		if (ret < 0)
>> +			goto err_irq;
>> +		else if (pdata->pm_off && !pm_power_off)
> No need for the else.
Ok

>
>> +			tps65917_dev = tps65917;
> What does this do?
>
>> +	}
>> +
>> +	return ret;
> Where does it continue and add devices using the MFD helpers?

I will remove this part.

>
>> +err_irq:
>> +	regmap_del_irq_chip(tps65917->irq, tps65917->irq_data);
>> +err_i2c:
>> +	for (i = 1; i < TPS65917_NUM_CLIENTS; i++) {
>> +		if (tps65917->i2c_clients[i])
>> +			i2c_unregister_device(tps65917->i2c_clients[i]);
>> +	}
> New line here.

Ok.

>
>> +	return ret;
>> +}
>> +
>> +static int tps65917_i2c_remove(struct i2c_client *i2c)
>> +{
>> +	struct tps65917 *tps65917 = i2c_get_clientdata(i2c);
>> +	int i;
>> +
>> +	regmap_del_irq_chip(tps65917->irq, tps65917->irq_data);
>> +
>> +	for (i = 1; i < TPS65917_NUM_CLIENTS; i++) {
>> +		if (tps65917->i2c_clients[i])
>> +			i2c_unregister_device(tps65917->i2c_clients[i]);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id tps65917_i2c_id[] = {
>> +	{ "tps65917", },
>> +};
>> +MODULE_DEVICE_TABLE(i2c, tps65917_i2c_id);
>> +
>> +static struct i2c_driver tps65917_i2c_driver = {
>> +	.driver = {
>> +		   .name = "tps65917",
>> +		   .of_match_table = of_tps65917_match_tbl,
> of_match_ptr()

Ok

>
>> +		   .owner = THIS_MODULE,
>> +	},
>> +	.probe = tps65917_i2c_probe,
>> +	.remove = tps65917_i2c_remove,
>> +	.id_table = tps65917_i2c_id,
>> +};
>> +
>> +static int __init tps65917_i2c_init(void)
>> +{
>> +	return i2c_add_driver(&tps65917_i2c_driver);
>> +}
>> +/* init early so consumer devices can complete system boot */
> Defer?
>
>> +subsys_initcall(tps65917_i2c_init);
>> +
>> +static void __exit tps65917_i2c_exit(void)
>> +{
>> +	i2c_del_driver(&tps65917_i2c_driver);
>> +}
>> +module_exit(tps65917_i2c_exit);
>> +
>> +MODULE_AUTHOR("J Keerthy <j-keerthy@ti.com>");
>> +MODULE_DESCRIPTION("TPS65917 chip family multi-function driver");
> Multi-Function Driver
>
ok

>> +MODULE_LICENSE("GPL v2");
>> diff --git a/include/linux/mfd/tps65917.h b/include/linux/mfd/tps65917.h
>> new file mode 100644
>> index 0000000..8232e22
>> --- /dev/null
>> +++ b/include/linux/mfd/tps65917.h
>> @@ -0,0 +1,1509 @@
>> +/*
>> + * TI TPS65917
>> + *
>> + * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com/
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether expressed or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License version 2 for more details.
>> + */
>> +
>> +#ifndef __LINUX_MFD_TPS65917_H
>> +#define __LINUX_MFD_TPS65917_H
>> +
>> +#include <linux/regmap.h>
>> +#include <linux/regulator/driver.h>
>> +
>> +#define TPS65917_NUM_CLIENTS		3
>> +
>> +/* The ID_REVISION NUMBERS */
>> +#define TPS65917_CHIP_ID			0xC035
>> +#define TPS65917_RESERVED -1
> Line up with tabs.

Ok

>> +struct tps65917 {
>> +	struct device *dev;
>> +
>> +	struct i2c_client *i2c_clients[TPS65917_NUM_CLIENTS];
>> +	struct regmap *regmap[TPS65917_NUM_CLIENTS];
>> +
>> +	/* Stored chip id */
>> +	int id;
> Where is this used?

for this driver this seems redundant. I will remove this.

>> +	struct tps65917_pmic *pmic;
>> +
>> +	/* IRQ Data */
>> +	int irq;
>> +	u32 irq_mask;
>> +	/* mutext for irq */
>> +	struct mutex irq_lock;
>> +	struct regmap_irq_chip_data *irq_data;
>> +};
>> +
>> +struct tps65917_reg_init {
>> +	/* warm_rest controls the voltage levels after a warm reset
>> +	 *
>> +	 * 0: reload default values from OTP on warm reset
>> +	 * 1: maintain voltage from VSEL on warm reset
>> +	 */
> Unusual looking comment, please correct.
>
>> +	int warm_reset;
> Looks like a bool to me.
I will change it to bool


>> +	/* roof_floor controls whether the regulator uses the i2c style
>> +	 * of DVS or uses the method where a GPIO or other control method is
>> +	 * attached to the NSLEEP/ENABLE1/ENABLE2 pins
>> +	 *
>> +	 * For SMPS
>> +	 *
>> +	 * 0: i2c selection of voltage
>> +	 * 1: pin selection of voltage.
>> +	 *
>> +	 * For LDO unused
>> +	 */
> Same here.  Top line should not be populated.

Ok
>> +	int roof_floor;
> Only two values is a bool.
ok

>> +	/* sleep_mode is the mode loaded to MODE_SLEEP bits as defined in
>> +	 * the data sheet.
>> +	 *
>> +	 * For SMPS
>> +	 *
>> +	 * 0: Off
>> +	 * 1: AUTO
>> +	 * 2: ECO
>> +	 * 3: Forced PWM
>> +	 *
>> +	 * For LDO
>> +	 *
>> +	 * 0: Off
>> +	 * 1: On
>> +	 */
>> +	int mode_sleep;
>> +
>> +	/* voltage_sel is the bitfield loaded onto the SMPSX_VOLTAGE
>> +	 * register. Set this is the default voltage set in OTP needs
>> +	 * to be overridden.
>> +	 */
>> +	u8 vsel;
>> +};
>> +
>> +enum tps65917_regulators {
>> +	/* SMPS regulators */
>> +	TPS65917_REG_SMPS1,
>> +	TPS65917_REG_SMPS2,
>> +	TPS65917_REG_SMPS3,
>> +	TPS65917_REG_SMPS4,
>> +	TPS65917_REG_SMPS5,
>> +	/* LDO regulators */
>> +	TPS65917_REG_LDO1,
>> +	TPS65917_REG_LDO2,
>> +	TPS65917_REG_LDO3,
>> +	TPS65917_REG_LDO4,
>> +	TPS65917_REG_LDO5,
>> +	TPS65917_REG_REGEN1,
>> +	TPS65917_REG_REGEN2,
>> +	TPS65917_REG_REGEN3,
>> +
>> +	/* Total number of regulators */
>> +	TPS65917_NUM_REGS,
>> +};
>> +
>> +struct tps65917_pmic_platform_data {
>> +	/* An array of pointers to regulator init data indexed by regulator
>> +	 * ID
>> +	 */
> Odd multi-line comments throughout.

oops. I will correct this.

>
>> +	struct regulator_init_data *reg_data[TPS65917_NUM_REGS];
>> +
>> +	/* An array of pointers to structures containing sleep mode and DVS
>> +	 * configuration for regulators indexed by ID
>> +	 */
>> +	struct tps65917_reg_init *reg_init[TPS65917_NUM_REGS];
>> +};
>> +
>> +
>> +struct tps65917_platform_data {
>> +	int irq_flags;
>> +	int gpio_base;
>> +
>> +	/* bit value to be loaded to the POWER_CTRL register */
>> +	u8 power_ctrl;
>> +
>> +	/*
>> +	 * boolean to select if we want to configure muxing here
>> +	 * then the two value to load into the registers if true
>> +	 */
>> +	int mux_from_pdata;
>> +	u8 pad1, pad2;
>> +	bool pm_off;
>> +
>> +	struct tps65917_pmic_platform_data *pmic_pdata;
>> +};
>> +
>> +/* Define the tps65917 IRQ numbers */
>> +enum tps65917_irqs {
>> +	/* INT1 registers */
>> +	TPS65917_RESERVED1,
>> +	TPS65917_PWRON_IRQ,
>> +	TPS65917_LONG_PRESS_KEY_IRQ,
>> +	TPS65917_RESERVED2,
>> +	TPS65917_PWRDOWN_IRQ,
>> +	TPS65917_HOTDIE_IRQ,
>> +	TPS65917_VSYS_MON_IRQ,
>> +	TPS65917_RESERVED3,
>> +	/* INT2 registers */
>> +	TPS65917_RESERVED4,
>> +	TPS65917_OTP_ERROR_IRQ,
>> +	TPS65917_WDT_IRQ,
>> +	TPS65917_RESERVED5,
>> +	TPS65917_RESET_IN_IRQ,
>> +	TPS65917_FSD_IRQ,
>> +	TPS65917_SHORT_IRQ,
>> +	TPS65917_RESERVED6,
>> +	/* INT3 registers */
>> +	TPS65917_GPADC_AUTO_0_IRQ,
>> +	TPS65917_GPADC_AUTO_1_IRQ,
>> +	TPS65917_GPADC_EOC_SW_IRQ,
>> +	TPS65917_RESREVED6,
>> +	TPS65917_RESERVED7,
>> +	TPS65917_RESERVED8,
>> +	TPS65917_RESERVED9,
>> +	TPS65917_VBUS_IRQ,
>> +	/* INT4 registers */
>> +	TPS65917_GPIO_0_IRQ,
>> +	TPS65917_GPIO_1_IRQ,
>> +	TPS65917_GPIO_2_IRQ,
>> +	TPS65917_GPIO_3_IRQ,
>> +	TPS65917_GPIO_4_IRQ,
>> +	TPS65917_GPIO_5_IRQ,
>> +	TPS65917_GPIO_6_IRQ,
>> +	TPS65917_RESERVED10,
>> +	/* Total Number IRQs */
>> +	TPS65917_NUM_IRQ,
>> +};
>> +
>> +/* External controll signal name */
> Spelling.

I will correct this.

>
>> +enum {
>> +	TPS65917_EXT_CONTROL_ENABLE1      = 0x1,
>> +	TPS65917_EXT_CONTROL_ENABLE2      = 0x2,
>> +	TPS65917_EXT_CONTROL_NSLEEP       = 0x4,
>> +};
>> +
>> +/*
>> + * TPS65917 device resources can be controlled externally for
>> + * enabling/disabling it rather than register write through i2c.
>> + * Add the external controlled requestor ID for different resources.
>> + */
>> +enum tps65917_external_requestor_id {
>> +	TPS65917_EXTERNAL_REQSTR_ID_REGEN1,
>> +	TPS65917_EXTERNAL_REQSTR_ID_REGEN2,
>> +	TPS65917_EXTERNAL_REQSTR_ID_REGEN3,
>> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS1,
>> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS2,
>> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS3,
>> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS4,
>> +	TPS65917_EXTERNAL_REQSTR_ID_SMPS5,
>> +	TPS65917_EXTERNAL_REQSTR_ID_LDO1,
>> +	TPS65917_EXTERNAL_REQSTR_ID_LDO2,
>> +	TPS65917_EXTERNAL_REQSTR_ID_LDO3,
>> +	TPS65917_EXTERNAL_REQSTR_ID_LDO4,
>> +	TPS65917_EXTERNAL_REQSTR_ID_LDO5,
>> +	/* Last entry */
>> +	TPS65917_EXTERNAL_REQSTR_ID_MAX,
>> +};
>> +
>> +struct tps65917_pmic {
>> +	struct tps65917 *tps65917;
>> +	struct device *dev;
>> +	struct regulator_desc desc[TPS65917_NUM_REGS];
>> +	struct regulator_dev *rdev[TPS65917_NUM_REGS];
>> +	/* pmic mutex */
>> +	struct mutex mutex;
>> +	int smps12;
>> +	int range[TPS65917_REG_SMPS5];
>> +	unsigned int ramp_delay[TPS65917_REG_SMPS5];
>> +	unsigned int current_reg_mode[TPS65917_REG_SMPS5];
>> +};
>> +
>> +/* helper macro to get correct slave number */
>> +#define TPS65917_BASE_TO_SLAVE(x)		((x >> 8) - 1)
>> +#define TPS65917_BASE_TO_REG(x, y)	((x & 0xff) + y)
>> +
>> +/* Base addresses of IP blocks in TPS65917 */
>> +#define TPS65917_SMPS_DVS_BASE					0x20
>> +#define TPS65917_VALIDITY_BASE					0x118
>> +#define TPS65917_SMPS_BASE					0x120
>> +#define TPS65917_LDO_BASE						0x150
>> +#define TPS65917_DVFS_BASE					0x180
>> +#define TPS65917_PMU_CONTROL_BASE					0x1A0
>> +#define TPS65917_RESOURCE_BASE					0x1D4
>> +#define TPS65917_PU_PD_OD_BASE					0x1F0
>> +#define TPS65917_LED_BASE						0x200
>> +#define TPS65917_INTERRUPT_BASE					0x210
>> +#define TPS65917_GPIO_BASE					0x280
>> +#define TPS65917_GPADC_BASE					0x2C0
>> +#define TPS65917_TRIM_GPADC_BASE					0x3CD
>> +
>> +/* Registers for function BACKUP */
>> +#define TPS65917_BACKUP0						0x0
>> +#define TPS65917_BACKUP1						0x1
>> +#define TPS65917_BACKUP2						0x2
>> +#define TPS65917_BACKUP3						0x3
>> +#define TPS65917_BACKUP4						0x4
>> +#define TPS65917_BACKUP5						0x5
>> +#define TPS65917_BACKUP6						0x6
>> +#define TPS65917_BACKUP7						0x7
>> +
>> +/* Bit definitions for BACKUP0 */
>> +#define TPS65917_BACKUP0_BACKUP_MASK				0xff
>> +#define TPS65917_BACKUP0_BACKUP_SHIFT				0
>> +
>> +/* Bit definitions for BACKUP1 */
>> +#define TPS65917_BACKUP1_BACKUP_MASK				0xff
>> +#define TPS65917_BACKUP1_BACKUP_SHIFT				0
>> +
>> +/* Bit definitions for BACKUP2 */
>> +#define TPS65917_BACKUP2_BACKUP_MASK				0xff
>> +#define TPS65917_BACKUP2_BACKUP_SHIFT				0
>> +
>> +/* Bit definitions for BACKUP3 */
>> +#define TPS65917_BACKUP3_BACKUP_MASK				0xff
>> +#define TPS65917_BACKUP3_BACKUP_SHIFT				0
>> +
>> +/* Bit definitions for BACKUP4 */
>> +#define TPS65917_BACKUP4_BACKUP_MASK				0xff
>> +#define TPS65917_BACKUP4_BACKUP_SHIFT				0
>> +
>> +/* Bit definitions for BACKUP5 */
>> +#define TPS65917_BACKUP5_BACKUP_MASK				0xff
>> +#define TPS65917_BACKUP5_BACKUP_SHIFT				0
>> +
>> +/* Bit definitions for BACKUP6 */
>> +#define TPS65917_BACKUP6_BACKUP_MASK				0xff
>> +#define TPS65917_BACKUP6_BACKUP_SHIFT				0
>> +
>> +/* Bit definitions for BACKUP7 */
>> +#define TPS65917_BACKUP7_BACKUP_MASK				0xff
>> +#define TPS65917_BACKUP7_BACKUP_SHIFT				0
> If they do not differ, remove the number and consolidate:
>
> /* Bit definitions for BACKUP{0-7} */
> #define TPS65917_BACKUP_BACKUP_MASK				0xff
> #define TPS65917_BACKUP_BACKUP_SHIFT				0

Ok

>> +/* Registers for function SMPS */
>> +#define TPS65917_SMPS1_CTRL					0x0
>> +#define TPS65917_SMPS1_FORCE					0x2
>> +#define TPS65917_SMPS1_VOLTAGE					0x3
>> +#define TPS65917_SMPS2_CTRL					0x4
>> +#define TPS65917_SMPS2_FORCE					0x6
>> +#define TPS65917_SMPS2_VOLTAGE					0x7
>> +#define TPS65917_SMPS3_CTRL					0xC
>> +#define TPS65917_SMPS3_FORCE					0xE
>> +#define TPS65917_SMPS3_VOLTAGE					0xF
>> +#define TPS65917_SMPS4_CTRL					0x10
>> +#define TPS65917_SMPS4_VOLTAGE					0x13
>> +#define TPS65917_SMPS5_CTRL					0x18
>> +#define TPS65917_SMPS5_VOLTAGE					0x1B
>> +#define TPS65917_SMPS_CTRL					0x24
>> +#define TPS65917_SMPS_PD_CTRL					0x25
>> +#define TPS65917_SMPS_THERMAL_EN				0x27
>> +#define TPS65917_SMPS_THERMAL_STATUS				0x28
>> +#define TPS65917_SMPS_SHORT_STATUS				0x29
>> +#define TPS65917_SMPS_NEGATIVE_CURRENT_LIMIT_EN			0x2A
>> +#define TPS65917_SMPS_POWERGOOD_MASK1				0x2B
>> +#define TPS65917_SMPS_POWERGOOD_MASK2				0x2C
>> +
>> +/* Bit definitions for SMPS1_CTRL */
>> +#define TPS65917_SMPS1_CTRL_WR_S				0x80
>> +#define TPS65917_SMPS1_CTRL_WR_S_SHIFT				7
>> +#define TPS65917_SMPS1_CTRL_ROOF_FLOOR_EN			0x40
>> +#define TPS65917_SMPS1_CTRL_ROOF_FLOOR_EN_SHIFT			6
>> +#define TPS65917_SMPS1_CTRL_STATUS_MASK				0x30
>> +#define TPS65917_SMPS1_CTRL_STATUS_SHIFT			4
>> +#define TPS65917_SMPS1_CTRL_MODE_SLEEP_MASK			0x0c
>> +#define TPS65917_SMPS1_CTRL_MODE_SLEEP_SHIFT			2
>> +#define TPS65917_SMPS1_CTRL_MODE_ACTIVE_MASK			0x03
>> +#define TPS65917_SMPS1_CTRL_MODE_ACTIVE_SHIFT			0
> Pick a base and stick with it.  I suggest hex throughout.

Ok

> [...]
>
>> +/* Bit definitions for SMPS_PLL_CTRL */
>> +
>> +#define TPS65917_SMPS_PLL_CTRL_PLL_EN_PLL_BYPASS_SHIFT		0x8
>> +#define TPS65917_SMPS_PLL_CTRL_PLL_PLL_EN_BYPASS		3
>> +#define TPS65917_SMPS_PLL_CTRL_PLL_PLL_BYPASS_CLK_SHIFT		0x4
>> +#define TPS65917_SMPS_PLL_CTRL_PLL_PLL_BYPASS_CLK		2
>> +
>> +
> Remove this line.
Ok

>> +/* Registers for function LDO */
>> +#define TPS65917_LDO1_CTRL					0x0
>> +#define TPS65917_LDO1_VOLTAGE					0x1
>> +#define TPS65917_LDO2_CTRL					0x2
>> +#define TPS65917_LDO2_VOLTAGE					0x3
>> +#define TPS65917_LDO3_CTRL					0x4
>> +#define TPS65917_LDO3_VOLTAGE					0x5
>> +#define TPS65917_LDO4_CTRL					0xE
>> +#define TPS65917_LDO4_VOLTAGE					0xF
> Also standardise the number of digits represented and either
Ok
> capitalise none or all of the hex letters.
Ok
> [...]
>
>> +static inline int tps65917_read(struct tps65917 *tps65917, unsigned int base,
>> +				unsigned int reg, unsigned int *val)
>> +{
>> +	unsigned int addr =  TPS65917_BASE_TO_REG(base, reg);
> Extra ' '.

I will remove.

>
>> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
>> +
>> +	return regmap_read(tps65917->regmap[slave_id], addr, val);
>> +}
>> +
>> +static inline int tps65917_write(struct tps65917 *tps65917, unsigned int base,
>> +				 unsigned int reg, unsigned int value)
>> +{
>> +	unsigned int addr = TPS65917_BASE_TO_REG(base, reg);
>> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
>> +
>> +	return regmap_write(tps65917->regmap[slave_id], addr, value);
>> +}
>> +
>> +static inline int tps65917_bulk_write(struct tps65917 *tps65917,
>> +				      unsigned int base,
>> +				      unsigned int reg, const void *val,
>> +				      size_t val_count)
>> +{
>> +	unsigned int addr = TPS65917_BASE_TO_REG(base, reg);
>> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
>> +
>> +	return regmap_bulk_write(tps65917->regmap[slave_id], addr,
>> +				 val, val_count);
>> +}
>> +
>> +static inline int tps65917_bulk_read(struct tps65917 *tps65917,
>> +				     unsigned int base,
>> +				     unsigned int reg, void *val,
>> +				     size_t val_count)
>> +{
>> +	unsigned int addr = TPS65917_BASE_TO_REG(base, reg);
>> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
>> +
>> +	return regmap_bulk_read(tps65917->regmap[slave_id], addr,
>> +				val, val_count);
>> +}
>> +
>> +static inline int tps65917_update_bits(struct tps65917 *tps65917,
>> +				       unsigned int base, unsigned int reg,
>> +				       unsigned int mask, unsigned int val)
>> +{
>> +	unsigned int addr = TPS65917_BASE_TO_REG(base, reg);
>> +	int slave_id = TPS65917_BASE_TO_SLAVE(base);
>> +
>> +	return regmap_update_bits(tps65917->regmap[slave_id], addr, mask, val);
>> +}
>> +
>> +static inline int tps65917_irq_get_virq(struct tps65917 *tps65917, int irq)
>> +{
>> +	return regmap_irq_get_virq(tps65917->irq_data, irq);
>> +}
> This is quite a lot of overhead.  Are you sure you require them?

I will relook at this.

>
>> +int tps65917_ext_control_req_config(struct tps65917 *tps65917,
>> +				    enum tps65917_external_requestor_id ext_control_req_id,
>> +				    int ext_ctrl, bool enable);
>> +
>> +#endif /*  __LINUX_MFD_TPS65917_H */
Thanks,
Keerthy
