Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaFWJwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:52:14 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:17402 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbaFWJwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:52:12 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2014 05:52:12 EDT
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Beniamino Galvani <b.galvani@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, "Heiko Stuebner" <heiko@sntech.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 3/5] regulator: act8865: prepare support for other
 act88xx devices
Thread-Topic: [PATCH 3/5] regulator: act8865: prepare support for other
 act88xx devices
Thread-Index: AQHPji9mULOtp5F+mUel+qgEA39YqJt+c4FQ
Date: Mon, 23 Jun 2014 09:46:35 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436419D1B5CBD@penmbx01>
References: <1403451105-31929-1-git-send-email-b.galvani@gmail.com>
 <1403451105-31929-4-git-send-email-b.galvani@gmail.com>
In-Reply-To: <1403451105-31929-4-git-send-email-b.galvani@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Beniamino Galvani [mailto:b.galvani@gmail.com]
> Sent: Sunday, June 22, 2014 11:32 PM
> To: Liam Girdwood; Mark Brown
> Cc: Yang, Wenyou; Rob Herring; Pawel Moll; Mark Rutland; Ian Campbell;
> Kumar Gala; Heiko Stuebner; devicetree@vger.kernel.org; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Beniamino Galvani
> Subject: [PATCH 3/5] regulator: act8865: prepare support for other
> act88xx devices
> 
> This patch prepares support for other devices in the act88xx family of
> PMUs manufactured by Active-Semi.
> 
> http://www.active-semi.com/products/power-management-units/act88xx/
> 
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  drivers/regulator/act8865-regulator.c |  212 +++++++++++++------------
> --------
>  include/linux/regulator/act8865.h     |    6 +-
>  2 files changed, 88 insertions(+), 130 deletions(-)
> 
> diff --git a/drivers/regulator/act8865-regulator.c
> b/drivers/regulator/act8865-regulator.c
> index b03a0e8..c604b34 100644
> --- a/drivers/regulator/act8865-regulator.c
> +++ b/drivers/regulator/act8865-regulator.c
> @@ -1,6 +1,7 @@
>  /*
> - * act8865-regulator.c - Voltage regulation for the active-semi
> ACT8865
> - * http://www.active-semi.com/sheets/ACT8865_Datasheet.pdf
> + * act8865-regulator.c - Voltage regulation for active-semi ACT88xx
> + PMUs
> + *
> + * http://www.active-semi.com/products/power-management-units/act88xx/
>   *
>   * Copyright (C) 2013 Atmel Corporation
>   *
> @@ -70,7 +71,7 @@ static const struct regmap_config
> act8865_regmap_config = {
>  	.val_bits = 8,
>  };
> 
> -static const struct regulator_linear_range act8865_volatge_ranges[] =
> {
> +static const struct regulator_linear_range act8865_voltage_ranges[] =
> {
>  	REGULATOR_LINEAR_RANGE(600000, 0, 23, 25000),
>  	REGULATOR_LINEAR_RANGE(1200000, 24, 47, 50000),
>  	REGULATOR_LINEAR_RANGE(2400000, 48, 63, 100000), @@ -86,110
> +87,35 @@ static struct regulator_ops act8865_ops = {
>  	.is_enabled		= regulator_is_enabled_regmap,
>  };
> 
> -static const struct regulator_desc act8865_reg[] = {
> -	{
> -		.name = "DCDC_REG1",
> -		.id = ACT8865_ID_DCDC1,
> -		.ops = &act8865_ops,
> -		.type = REGULATOR_VOLTAGE,
> -		.n_voltages = ACT8865_VOLTAGE_NUM,
> -		.linear_ranges = act8865_volatge_ranges,
> -		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
> -		.vsel_reg = ACT8865_DCDC1_VSET1,
> -		.vsel_mask = ACT8865_VSEL_MASK,
> -		.enable_reg = ACT8865_DCDC1_CTRL,
> -		.enable_mask = ACT8865_ENA,
> -		.owner = THIS_MODULE,
> -	},
> -	{
> -		.name = "DCDC_REG2",
> -		.id = ACT8865_ID_DCDC2,
> -		.ops = &act8865_ops,
> -		.type = REGULATOR_VOLTAGE,
> -		.n_voltages = ACT8865_VOLTAGE_NUM,
> -		.linear_ranges = act8865_volatge_ranges,
> -		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
> -		.vsel_reg = ACT8865_DCDC2_VSET1,
> -		.vsel_mask = ACT8865_VSEL_MASK,
> -		.enable_reg = ACT8865_DCDC2_CTRL,
> -		.enable_mask = ACT8865_ENA,
> -		.owner = THIS_MODULE,
> -	},
> -	{
> -		.name = "DCDC_REG3",
> -		.id = ACT8865_ID_DCDC3,
> -		.ops = &act8865_ops,
> -		.type = REGULATOR_VOLTAGE,
> -		.n_voltages = ACT8865_VOLTAGE_NUM,
> -		.linear_ranges = act8865_volatge_ranges,
> -		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
> -		.vsel_reg = ACT8865_DCDC3_VSET1,
> -		.vsel_mask = ACT8865_VSEL_MASK,
> -		.enable_reg = ACT8865_DCDC3_CTRL,
> -		.enable_mask = ACT8865_ENA,
> -		.owner = THIS_MODULE,
> -	},
> -	{
> -		.name = "LDO_REG1",
> -		.id = ACT8865_ID_LDO1,
> -		.ops = &act8865_ops,
> -		.type = REGULATOR_VOLTAGE,
> -		.n_voltages = ACT8865_VOLTAGE_NUM,
> -		.linear_ranges = act8865_volatge_ranges,
> -		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
> -		.vsel_reg = ACT8865_LDO1_VSET,
> -		.vsel_mask = ACT8865_VSEL_MASK,
> -		.enable_reg = ACT8865_LDO1_CTRL,
> -		.enable_mask = ACT8865_ENA,
> -		.owner = THIS_MODULE,
> -	},
> -	{
> -		.name = "LDO_REG2",
> -		.id = ACT8865_ID_LDO2,
> -		.ops = &act8865_ops,
> -		.type = REGULATOR_VOLTAGE,
> -		.n_voltages = ACT8865_VOLTAGE_NUM,
> -		.linear_ranges = act8865_volatge_ranges,
> -		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
> -		.vsel_reg = ACT8865_LDO2_VSET,
> -		.vsel_mask = ACT8865_VSEL_MASK,
> -		.enable_reg = ACT8865_LDO2_CTRL,
> -		.enable_mask = ACT8865_ENA,
> -		.owner = THIS_MODULE,
> -	},
> -	{
> -		.name = "LDO_REG3",
> -		.id = ACT8865_ID_LDO3,
> -		.ops = &act8865_ops,
> -		.type = REGULATOR_VOLTAGE,
> -		.n_voltages = ACT8865_VOLTAGE_NUM,
> -		.linear_ranges = act8865_volatge_ranges,
> -		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
> -		.vsel_reg = ACT8865_LDO3_VSET,
> -		.vsel_mask = ACT8865_VSEL_MASK,
> -		.enable_reg = ACT8865_LDO3_CTRL,
> -		.enable_mask = ACT8865_ENA,
> -		.owner = THIS_MODULE,
> -	},
> -	{
> -		.name = "LDO_REG4",
> -		.id = ACT8865_ID_LDO4,
> -		.ops = &act8865_ops,
> -		.type = REGULATOR_VOLTAGE,
> -		.n_voltages = ACT8865_VOLTAGE_NUM,
> -		.linear_ranges = act8865_volatge_ranges,
> -		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
> -		.vsel_reg = ACT8865_LDO4_VSET,
> -		.vsel_mask = ACT8865_VSEL_MASK,
> -		.enable_reg = ACT8865_LDO4_CTRL,
> -		.enable_mask = ACT8865_ENA,
> -		.owner = THIS_MODULE,
> -	},
> +#define ACT88xx_REG(_name, _family, _id, _vsel_reg)			\
> +	[_family##_ID_##_id] = {					\
> +		.name			= _name,			\
> +		.id			= _family##_ID_##_id,		\
> +		.type			= REGULATOR_VOLTAGE,		\
> +		.ops			= &act8865_ops,			\
> +		.n_voltages		= ACT8865_VOLTAGE_NUM,		\
> +		.linear_ranges		= act8865_voltage_ranges,	\
> +		.n_linear_ranges	= ARRAY_SIZE(act8865_voltage_ranges), \
> +		.vsel_reg		= _family##_##_id##_##_vsel_reg, \
> +		.vsel_mask		= ACT8865_VSEL_MASK,		\
> +		.enable_reg		= _family##_##_id##_CTRL,	\
> +		.enable_mask		= ACT8865_ENA,			\
> +		.owner			= THIS_MODULE,			\
> +	}
> +
> +static const struct regulator_desc act8865_regulators[] = {
> +	ACT88xx_REG("DCDC_REG1", ACT8865, DCDC1, VSET1),
> +	ACT88xx_REG("DCDC_REG2", ACT8865, DCDC2, VSET1),
> +	ACT88xx_REG("DCDC_REG3", ACT8865, DCDC3, VSET1),
> +	ACT88xx_REG("LDO_REG1", ACT8865, LDO1, VSET),
> +	ACT88xx_REG("LDO_REG2", ACT8865, LDO2, VSET),
> +	ACT88xx_REG("LDO_REG3", ACT8865, LDO3, VSET),
> +	ACT88xx_REG("LDO_REG4", ACT8865, LDO4, VSET),
>  };
> 
>  #ifdef CONFIG_OF
>  static const struct of_device_id act8865_dt_ids[] = {
> -	{ .compatible = "active-semi,act8865" },
> +	{ .compatible = "active-semi,act8865", .data = (void *)ACT8865 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(of, act8865_dt_ids); @@ -206,7 +132,9 @@ static
> struct of_regulator_match act8865_matches[] = {
> 
>  static int act8865_pdata_from_dt(struct device *dev,
>  				 struct device_node **of_node,
> -				 struct act8865_platform_data *pdata)
> +				 struct act8865_platform_data *pdata,
> +				 struct of_regulator_match *matches,
> +				 int num_matches)
>  {
>  	int matched, i;
>  	struct device_node *np;
> @@ -218,26 +146,25 @@ static int act8865_pdata_from_dt(struct device
> *dev,
>  		return -EINVAL;
>  	}
> 
> -	matched = of_regulator_match(dev, np,
> -				act8865_matches, ARRAY_SIZE(act8865_matches));
> +	matched = of_regulator_match(dev, np, matches, num_matches);
>  	of_node_put(np);
>  	if (matched <= 0)
>  		return matched;
> 
>  	pdata->regulators = devm_kzalloc(dev,
> -				sizeof(struct act8865_regulator_data) *
> -				ARRAY_SIZE(act8865_matches), GFP_KERNEL);
> +					 sizeof(struct act8865_regulator_data) *
> +					 num_matches, GFP_KERNEL);
>  	if (!pdata->regulators)
>  		return -ENOMEM;
> 
> -	pdata->num_regulators = ARRAY_SIZE(act8865_matches);
> +	pdata->num_regulators = num_matches;
>  	regulator = pdata->regulators;
> 
> -	for (i = 0; i < ARRAY_SIZE(act8865_matches); i++) {
> +	for (i = 0; i < num_matches; i++) {
>  		regulator->id = i;
> -		regulator->name = act8865_matches[i].name;
> -		regulator->platform_data = act8865_matches[i].init_data;
> -		of_node[i] = act8865_matches[i].of_node;
> +		regulator->name = matches[i].name;
> +		regulator->platform_data = matches[i].init_data;
> +		of_node[i] = matches[i].of_node;
>  		regulator++;
>  	}
> 
> @@ -269,35 +196,59 @@ static struct regulator_init_data  }
> 
>  static int act8865_pmic_probe(struct i2c_client *client,
> -			   const struct i2c_device_id *i2c_id)
> +			      const struct i2c_device_id *i2c_id)
>  {
> -	struct regulator_dev *rdev;
> +	static const struct regulator_desc *regulators;
> +	struct act8865_platform_data pdata_of, *pdata;
> +	struct of_regulator_match *matches;
>  	struct device *dev = &client->dev;
> -	struct act8865_platform_data *pdata = dev_get_platdata(dev);
> -	struct regulator_config config = { };
> +	int i, ret, num_regulators, error;
> +	struct device_node **of_node;
>  	struct act8865 *act8865;
> -	struct device_node *of_node[ACT8865_REG_NUM];
> -	int i;
> -	int ret = -EINVAL;
> -	int error;
> +	unsigned long type;
> +
> +	pdata = dev_get_platdata(dev);
> 
>  	if (dev->of_node && !pdata) {
>  		const struct of_device_id *id;
> -		struct act8865_platform_data pdata_of;
> 
>  		id = of_match_device(of_match_ptr(act8865_dt_ids), dev);
>  		if (!id)
>  			return -ENODEV;
> 
> -		ret = act8865_pdata_from_dt(dev, of_node, &pdata_of);
> +		type = (unsigned long) id->data;
> +	} else {
> +		type = i2c_id->driver_data;
> +	}
> +
> +	switch (type) {
> +	case ACT8865:
> +		matches = act8865_matches;
> +		regulators = act8865_regulators;
> +		num_regulators = ARRAY_SIZE(act8865_regulators);
> +		break;
> +	default:
> +		dev_err(dev, "invalid device id %lu\n", type);
> +		return -EINVAL;
> +	}
> +
> +	of_node = devm_kzalloc(dev, sizeof(struct device_node *) *
> +			       num_regulators, GFP_KERNEL);
> +	if (!of_node)
> +		return -ENOMEM;
> +
> +	if (dev->of_node && !pdata) {
> +		ret = act8865_pdata_from_dt(dev, of_node, &pdata_of,
> matches,
> +					    num_regulators);
>  		if (ret < 0)
>  			return ret;
> 
>  		pdata = &pdata_of;
>  	}
> 
> -	if (pdata->num_regulators > ACT8865_REG_NUM) {
> -		dev_err(dev, "Too many regulators found!\n");
> +	if (pdata->num_regulators > num_regulators) {
> +		dev_err(dev, "too many regulators: %d\n",
> +			pdata->num_regulators);
>  		return -EINVAL;
>  	}
> 
> @@ -314,8 +265,10 @@ static int act8865_pmic_probe(struct i2c_client
> *client,
>  	}
> 
>  	/* Finally register devices */
> -	for (i = 0; i < ACT8865_REG_NUM; i++) {
> -		const struct regulator_desc *desc = &act8865_reg[i];
> +	for (i = 0; i < num_regulators; i++) {
> +		const struct regulator_desc *desc = &regulators[i];
> +		struct regulator_config config = { };
> +		struct regulator_dev *rdev;
> 
>  		config.dev = dev;
>  		config.init_data = act8865_get_init_data(desc->id, pdata);
> @@ -331,12 +284,13 @@ static int act8865_pmic_probe(struct i2c_client
> *client,
>  	}
> 
>  	i2c_set_clientdata(client, act8865);
> +	devm_kfree(dev, of_node);
> 
>  	return 0;
>  }
> 
>  static const struct i2c_device_id act8865_ids[] = {
> -	{ "act8865", 0 },
> +	{ .name = "act8865", .driver_data = ACT8865 },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(i2c, act8865_ids);
> @@ -352,6 +306,6 @@ static struct i2c_driver act8865_pmic_driver = {
> 
>  module_i2c_driver(act8865_pmic_driver);
> 
> -MODULE_DESCRIPTION("active-semi act8865 voltage regulator driver");
> +MODULE_DESCRIPTION("active-semi act88xx voltage regulator driver");
>  MODULE_AUTHOR("Wenyou Yang <wenyou.yang@atmel.com>");
> MODULE_LICENSE("GPL v2"); diff --git
> a/include/linux/regulator/act8865.h b/include/linux/regulator/act8865.h
> index 49206c1..b49be81 100644
> --- a/include/linux/regulator/act8865.h
> +++ b/include/linux/regulator/act8865.h
> @@ -1,5 +1,5 @@
>  /*
> - * act8865.h  --  Voltage regulation for the active-semi act8865
> + * act8865.h  --  Voltage regulation for active-semi act88xx PMUs
>   *
>   * Copyright (C) 2013 Atmel Corporation.
>   *
> @@ -29,6 +29,10 @@ enum {
>  	ACT8865_REG_NUM,
>  };
> 
> +enum {
> +	ACT8865,
> +};
> +
>  /**
>   * act8865_regulator_data - regulator data
>   * @id: regulator id
> --
> 1.7.10.4

Tested on at91-sama5d3_xplained with ACT8865

Tested-by Wenyou.Yang <wenyou.yang@atmel.com>

Best Regards,
Wenyou Yang

