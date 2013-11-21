Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3KUKeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:34:22 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39539 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab3KUKeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:34:19 -0500
Date: Thu, 21 Nov 2013 10:34:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/5] mfd: max14577: Add max14577 MFD driver core
Message-ID: <20131121103408.GA22536@lee--X1>
References: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
 <1384956732-19526-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384956732-19526-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

> +/**
> + * After resuming from suspend it may happen that IRQ is signalled but
> + * IRQ GPIO is not high. Also the interrupt registers won't have any data
> + * (all of them equal to 0x00).
> + *
> + * In such case retry few times reading the interrupt registers.
> + */
> +#define IRQ_READ_REG_RETRY_CNT		5

Where is this used?

<snip>

> +#define DECLARE_IRQ(idx, _group, _mask)		\
> +	[(idx)] = { .group = (_group), .mask = (_mask) }

I'm pretty sure the parentheses are supurfluous.

> +static const inline struct max14577_irq_data *
> irq_to_max14577_irq(struct max14577 *max14577, int irq)

We should tab this back out.

> +{
> +	struct irq_data *data = irq_get_irq_data(irq);
> +	return &max14577_irqs[data->hwirq];

Shouldn't you be using irq_create_mapping() or irq_find_mapping() here?

> +static void max14577_irq_mask(struct irq_data *data)
> +{
> +	struct max14577 *max14577 = irq_get_chip_data(data->irq);

                                    irq_data_get_irq_chip_data(data); ?

> +	const struct max14577_irq_data *irq_data =
> +	    irq_to_max14577_irq(max14577, data->irq);
> +
> +	if (!irq_data)
> +		return;
> +
> +	if (irq_data->group >= MAX14577_IRQ_REGS_NUM)
> +		return;
> +
> +	max14577->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
> +}

<snip>

> +int max14577_irq_resume(struct max14577 *max14577)
> +{
> +	int ret = 0;
> +
> +	if (max14577->irq && max14577->irq_domain)
> +		ret = max14577_irq_thread(0, max14577);
> +
> +	return ret >= 0 ? 0 : ret;

Please open this out to something more easily comprehensible.

<snip>

> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> new file mode 100644
> index 0000000..bfc4eb5
> --- /dev/null
> +++ b/drivers/mfd/max14577.c
> @@ -0,0 +1,216 @@
> +/*
> + * max14577.c - mfd core driver for the Maxim 14577
> + *
> + * Copyright (C) 2013 Samsung Electrnoics
> + * Chanwoo Choi <cw00.choi@samsung.com>
> + * Krzysztof Kozlowski <k.kozlowski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * This driver is based on max8997.c
> + */
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/max14577.h>
> +#include <linux/mfd/max14577-private.h>
> +
> +static struct mfd_cell max14577_devs[] = {
> +	{ .name = "max14577-muic", },
> +	{ .name = "max14577-regulator", },
> +	{ .name = "max14577-charger", },
> +};
> +
> +static bool max14577_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case MAX14577_REG_INT1 ... MAX14577_REG_STATUS3:
> +		return true;
> +	default:
> +		break;
> +	}
> +	return false;
> +}
> +
> +static const struct regmap_config max14577_regmap_config = {
> +	.reg_bits	= 8,
> +	.val_bits	= 8,
> +	.volatile_reg	= max14577_volatile_reg,
> +	.max_register	= MAX14577_REG_END,
> +};
> +
> +static int max14577_i2c_probe(struct i2c_client *i2c,
> +			      const struct i2c_device_id *id)
> +{
> +	struct max14577 *max14577;
> +	struct max14577_platform_data *pdata = dev_get_platdata(&i2c->dev);
> +	u8 reg_data;
> +	int ret = 0;
> +
> +	if (i2c->dev.of_node) {

Can you pull this out. It looks neater as the top as:
  struct device_node *np = i2c->dev.of_node;

> +		pdata = devm_kzalloc(&i2c->dev,
> +				sizeof(struct max14577_platform_data),

I prefer:
  sizeof(*pdata),

> +				GFP_KERNEL);
> +		if (!pdata)
> +			return -ENOMEM;
> +		i2c->dev.platform_data = pdata;
> +	}
> +
> +	if (IS_ERR_OR_NULL(pdata)) {

It's not likely to be an ERR, just do:
 if (!pdata) {

> +		dev_err(&i2c->dev, "No platform data found: %ld\n",
> +				PTR_ERR(pdata));
> +		return -EINVAL;
> +	}
> +
> +	max14577 = devm_kzalloc(&i2c->dev, sizeof(struct max14577), GFP_KERNEL);
> +	if (!max14577)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, max14577);
> +	max14577->pdata = pdata;

How many different places do you want to store this?

> +	max14577->dev = &i2c->dev;

You're storing dev here anyway.

Remove the pdata property and get it from dev when/if you require it.

> +	max14577->i2c = i2c;
> +	max14577->irq = i2c->irq;
> +
> +	max14577->regmap = devm_regmap_init_i2c(i2c, &max14577_regmap_config);
> +	if (IS_ERR(max14577->regmap)) {
> +		ret = PTR_ERR(max14577->regmap);
> +		dev_err(max14577->dev, "Failed to allocate register map: %d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	ret = max14577_read_reg(max14577->regmap, MAX14577_REG_DEVICEID,
> +			&reg_data);
> +	if (ret) {
> +		dev_err(max14577->dev, "Device not found on this channel: %d\n",
> +				ret);
> +		return ret;
> +	}
> +	max14577->vendor_id = (reg_data & 0x7);
> +	max14577->device_id = ((reg_data & 0xF8) >> 0x3);
> +	dev_info(max14577->dev, "Device ID: 0x%x, vendor: 0x%x\n",
> +			max14577->device_id, max14577->vendor_id);
> +
> +	ret = max14577_irq_init(max14577);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = mfd_add_devices(max14577->dev, -1, max14577_devs,
> +			ARRAY_SIZE(max14577_devs), NULL, 0, NULL);

You should be passing the irqdomain as the final parameter here.

> +	if (ret < 0)
> +		goto err_mfd;
> +
> +	device_init_wakeup(max14577->dev, 1);
> +
> +	return 0;
> +
> +err_mfd:
> +	max14577_irq_exit(max14577);
> +	return ret;
> +}
> +
> +static int max14577_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct max14577 *max14577 = i2c_get_clientdata(i2c);
> +
> +	mfd_remove_devices(max14577->dev);
> +	max14577_irq_exit(max14577);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id max14577_i2c_id[] = {
> +	{ MAX14577_MFD_DEV_NAME, 0 },

Can you use the proper name here, these types of defines are pretty ugly.

<snip>

> +#ifdef CONFIG_OF
> +static struct of_device_id max14577_dt_match[] = {
> +	{ .compatible = "maxim,max14577", },
> +	{},
> +};
> +#else
> +#define max14577_dt_match	NULL
> +#endif

You don't need to do this and use of_match_ptr().

Remove the #ifdef.

> +static SIMPLE_DEV_PM_OPS(max14577_pm, max14577_suspend, max14577_resume);
> +
> +static struct i2c_driver max14577_i2c_driver = {
> +	.driver = {
> +		.name = MAX14577_MFD_DEV_NAME,

Can you use the proper name here, these types of defines are pretty ugly.

> +		.owner = THIS_MODULE,
> +		.pm = &max14577_pm,
> +		.of_match_table = of_match_ptr(max14577_dt_match),
> +	},
> +	.probe = max14577_i2c_probe,
> +	.remove = max14577_i2c_remove,
> +	.id_table = max14577_i2c_id,
> +};

>>>>>>>>>>>>>>>>>>>>>>

> +static int __init max14577_i2c_init(void)
> +{
> +	return i2c_add_driver(&max14577_i2c_driver);
> +}
> +subsys_initcall(max14577_i2c_init);
> +
> +static void __exit max14577_i2c_exit(void)
> +{
> +	i2c_del_driver(&max14577_i2c_driver);
> +}
> +module_exit(max14577_i2c_exit);

>>>>>>>>>>>>>>>>>>>>>>

Remove all this and replace with:
  module_i2c_driver(max14577_i2c_driver);

> +MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>");
> +MODULE_DESCRIPTION("MAXIM 14577 multi-function core driver");
> +MODULE_LICENSE("GPL");

<snip>

> diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
> new file mode 100644
> index 0000000..9514123
> --- /dev/null
> +++ b/include/linux/mfd/max14577.h
> @@ -0,0 +1,72 @@

<snip>

> +struct max14577_regulator_platform_data {
> +	int id;
> +	struct regulator_init_data *initdata;
> +	struct device_node *of_node;

Do you ever set this? What's the point of it is it's set in the device?

> +};

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
