Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaETOPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:15:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48694 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaETOPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:15:37 -0400
Message-ID: <537B6376.2050000@ti.com>
Date: Tue, 20 May 2014 09:15:18 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>
CC: <robh+dt@kernel.org>, <mark.rutland@arm.com>, <sameo@linux.intel.com>,
        <grant.likely@linaro.org>, <ian@slimlogic.co.uk>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <broonie@linaro.org>, <swarren@nvidia.com>, <lee.jones@linaro.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] mfd: tps65917: Add driver for the TPS65917 PMIC
References: <1400577099-8743-1-git-send-email-j-keerthy@ti.com> <1400577099-8743-4-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1400577099-8743-4-git-send-email-j-keerthy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 04:11 AM, Keerthy wrote:
[...]
> +config MFD_TPS65917
> +	bool "TI TPS65917 series chips"
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	select REGMAP_IRQ
> +	depends on I2C=y
^^ why =y?

> +	help
> +	  If you say yes here you get support for the TPS65917
> +	  PMIC chips from Texas Instruments. The device provides
> +	  5 confgurable SPMSs and 5 LDOs, thermal protection module,
> +	  GPADC.
> +
>  config MFD_TPS80031
>  	bool "TI TPS80031/TPS80032 Power Management chips"
>  	depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 2851275..248a60b 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -69,6 +69,7 @@ tps65912-objs                   := tps65912-core.o tps65912-irq.o
>  obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o
>  obj-$(CONFIG_MFD_TPS65912_I2C)	+= tps65912-i2c.o
>  obj-$(CONFIG_MFD_TPS65912_SPI)  += tps65912-spi.o
> +obj-$(CONFIG_MFD_TPS65917)	+= tps65917.o
>  obj-$(CONFIG_MFD_TPS80031)	+= tps80031.o
>  obj-$(CONFIG_MENELAUS)		+= menelaus.o
>  
> diff --git a/drivers/mfd/tps65917.c b/drivers/mfd/tps65917.c
> new file mode 100644
> index 0000000..dbd67c5
> --- /dev/null
> +++ b/drivers/mfd/tps65917.c
> @@ -0,0 +1,573 @@
> +/*
> + * TI TPS65917 Integrated power management chipsets
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
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
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
<snip>
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
> +
> +	for (i = 0; i < 11; i++)
> +		if (reg == tps65917_voltaile_regs[i])
> +			return true;
> +
> +	return false;
> +}
> +
> +static const struct regmap_config tps65917_regmap_config[TPS65917_NUM_CLIENTS] = {
> +	{
> +		.reg_bits = 8,
> +		.val_bits = 8,
> +		.volatile_reg = is_volatile_reg,
> +		.cache_type = REGCACHE_NONE,
Assume you wanted cached here, since you are marking certain registers
as volatile?
[...]
> 
> +};
> +
> +int tps65917_ext_control_req_config(struct tps65917 *tps65917,
> +				    enum tps65917_external_requestor_id id,
> +				    int ext_ctrl, bool enable)
> +{

kernel doc style documentation
[...]

> +static struct tps65917 *tps65917_dev;
> +
> +static const struct of_device_id of_tps65917_match_tbl[] = {
> +	{
> +		.compatible = "ti,tps65917",
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_tps65917_match_tbl);
> +
> +static int tps65917_i2c_probe(struct i2c_client *i2c,
> +			      const struct i2c_device_id *id)
> +{

[...]
> +	/*
> +	 * If we are probing with DT do this the DT way and return here
> +	 * otherwise continue and add devices using mfd helpers.
> +	 */
> +	if (node) {
> +		ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
> +		if (ret < 0)
> +			goto err_irq;
> +		else if (pdata->pm_off && !pm_power_off)
> +			tps65917_dev = tps65917;

and where is the actual power off function?

> +	}
> +
> +	return ret;
> +
> +err_irq:
> +	regmap_del_irq_chip(tps65917->irq, tps65917->irq_data);
> +err_i2c:
> +	for (i = 1; i < TPS65917_NUM_CLIENTS; i++) {
> +		if (tps65917->i2c_clients[i])
> +			i2c_unregister_device(tps65917->i2c_clients[i]);
> +	}
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
> +		   .of_match_table = of_tps65917_match_tbl,
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
Should we let them just defer?

[...]

> diff --git a/include/linux/mfd/tps65917.h b/include/linux/mfd/tps65917.h
> new file mode 100644
> index 0000000..8232e22
> --- /dev/null
> +++ b/include/linux/mfd/tps65917.h

> +
> +struct tps65917 {
> +	struct device *dev;
> +
> +	struct i2c_client *i2c_clients[TPS65917_NUM_CLIENTS];
> +	struct regmap *regmap[TPS65917_NUM_CLIENTS];
> +
> +	/* Stored chip id */
> +	int id;
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

For all structures, could you use kerneldoc style documentation?
See: Documentation/kernel-doc-nano-HOWTO.txt +273


> +static inline int tps65917_read(struct tps65917 *tps65917, unsigned int base,
> +				unsigned int reg, unsigned int *val)

Again for all functions expected to be called by other driver(such as
regulator) to mfd, kernel-doc style documentation?

[...]

-- 
Regards,
Nishanth Menon
