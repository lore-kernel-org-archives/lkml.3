Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935212Ab3DHRqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:46:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64737 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934506Ab3DHRqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:46:32 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 8 Apr 2013 10:46:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6] clk: add si5351 i2c common clock driver
Message-ID: <20130408174636.GA1885@roeck-us.net>
References: <1365139415-17815-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1365439617-18816-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365439617-18816-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 06:46:57PM +0200, Sebastian Hesselbarth wrote:
> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
> i2c programmable clock generators. Currently, the driver does not
> support VXCO feature of si5351b. Passing platform_data or DT bindings
> selectively allow to overwrite stored Si5351 configuration which is
> very helpful for clock generators with empty eeprom configuration.
> Corresponding device tree binding documentation is also added.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

[ ... ]

> +
> +/*
> + * Si5351 i2c probe and DT
> + */
> +#ifdef CONFIG_OF
> +static const struct of_device_id si5351_dt_ids[] = {
> +	{ .compatible = "silabs,si5351a", .data = (void *)SI5351_VARIANT_A, },
> +	{ .compatible = "silabs,si5351a-msop",
> +					 .data = (void *)SI5351_VARIANT_A3, },
> +	{ .compatible = "silabs,si5351b", .data = (void *)SI5351_VARIANT_B, },
> +	{ .compatible = "silabs,si5351c", .data = (void *)SI5351_VARIANT_C, },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, si5351_dt_ids);
> +
> +static int si5351_dt_parse(struct i2c_client *client)
> +{
> +	struct device_node *child, *np = client->dev.of_node;
> +	struct si5351_platform_data *pdata;
> +	const struct of_device_id *match;
> +	struct property *prop;
> +	const __be32 *p;
> +	int num = 0;
> +	u32 val;
> +
> +	if (np == NULL)
> +		return 0;
> +
> +	match = of_match_node(si5351_dt_ids, np);
> +	if (match == NULL)
> +		return -EINVAL;
> +
> +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	pdata->variant = (enum si5351_variant)match->data;
> +	pdata->clk_xtal = of_clk_get(np, 0);
> +	if (!IS_ERR(pdata->clk_xtal))
> +		clk_put(pdata->clk_xtal);
> +	pdata->clk_clkin = of_clk_get(np, 1);
> +	if (!IS_ERR(pdata->clk_clkin))
> +		clk_put(pdata->clk_clkin);
> +
> +	/*
> +	 * property silabs,pll-source : <num src>, [<..>]
> +	 * allow to selectively set pll source
> +	 */
> +	of_property_for_each_u32(np, "silabs,pll-source", prop, p, num) {
> +		if (num >= 2) {
> +			dev_err(&client->dev,
> +				"invalid pll %d on pll-source prop\n", num);
> +			break;

You report dev_err here, but you don't return an error to the caller.
Is this on purpose ? If it is not a fatal error, maybe it should be dev_info ?

> +		}
> +
> +		p = of_prop_next_u32(prop, p, &val);
> +		if (!p)
> +			break;
> +
> +		switch (val) {
> +		case 0:
> +			pdata->pll_src[num] = SI5351_PLL_SRC_XTAL;
> +			break;
> +		case 1:
> +			pdata->pll_src[num] = SI5351_PLL_SRC_CLKIN;
> +			break;
> +		default:
> +			dev_warn(&client->dev,
> +				 "invalid parent %d for pll %d\n", val, num);
> +			continue;

Same here, and a couple of times below. Given the context, I think it would
be better if the error cases would return an error. After all, the condition
suggests that the device tree data is wrong, meaning one has to assume it
won't work anyway and should be fixed in the device tree and not be ignored
by the driver.

> +		}
> +	}
> +
> +	/* per clkout properties */
> +	num = of_get_child_count(np);
> +
> +	if (num == 0)
> +		return 0;
> +

This doesn't set client->dev.platform_data yet returns no error, meaning the
calling code will either use provided platform data or fail after all if it is
NULL. That seems to be inconsistent, given that a dt entry was already detected.
The user might end up wondering why the provided device tree data is not used,
not realizing that it is incomplete.

If children are not mandatory, you could just drop the code above and go through
for_each_child_of_node() anyway; it won't do anything and set
client->dev.platform_data at the end. If children are mandatory, it might make
sense to return an eror here (if there is dt information, it should be complete
and consistent).

> +	for_each_child_of_node(np, child) {
> +		if (of_property_read_u32(child, "reg", &num)) {
> +			dev_err(&client->dev, "missing reg property of %s\n",
> +				child->name);
> +			continue;
> +		}
> +
What if "num" returns 100 ? Or 1000 ?

> +		if (!of_property_read_u32(child, "silabs,multisynth-source",
> +					  &val)) {
> +			switch (val) {
> +			case 0:
> +				pdata->clkout[num].multisynth_src =
> +					SI5351_MULTISYNTH_SRC_VCO0;
> +				break;
> +			case 1:
> +				pdata->clkout[num].multisynth_src =
> +					SI5351_MULTISYNTH_SRC_VCO1;
> +				break;
> +			default:
> +				dev_warn(&client->dev,
> +					 "invalid parent %d for multisynth %d\n",
> +					 val, num);
> +			}
> +		}
> +
> +		if (!of_property_read_u32(child, "silabs,clock-source", &val)) {
> +			switch (val) {
> +			case 0:
> +				pdata->clkout[num].clkout_src =
> +					SI5351_CLKOUT_SRC_MSYNTH_N;
> +				break;
> +			case 1:
> +				pdata->clkout[num].clkout_src =
> +					SI5351_CLKOUT_SRC_MSYNTH_0_4;
> +				break;
> +			case 2:
> +				pdata->clkout[num].clkout_src =
> +					SI5351_CLKOUT_SRC_XTAL;
> +				break;
> +			case 3:
> +				pdata->clkout[num].clkout_src =
> +					SI5351_CLKOUT_SRC_CLKIN;
> +				break;
> +			default:
> +				dev_warn(&client->dev,
> +					 "invalid parent %d for clkout %d\n",
> +					 val, num);
> +			}
> +		}
> +
> +		if (!of_property_read_u32(child, "silabs,drive-strength",
> +					  &val)) {
> +			switch (val) {
> +			case SI5351_DRIVE_2MA:
> +			case SI5351_DRIVE_4MA:
> +			case SI5351_DRIVE_6MA:
> +			case SI5351_DRIVE_8MA:
> +				pdata->clkout[num].drive = val;
> +				break;
> +			default:
> +				dev_warn(&client->dev,
> +					 "invalid drive strength %d for clkout %d\n",
> +					 val, num);
> +			}
> +		}
> +
> +		if (!of_property_read_u32(child, "clock-frequency", &val))
> +			pdata->clkout[num].rate = val;
> +
> +		pdata->clkout[num].pll_master =
> +			of_property_read_bool(child, "silabs,pll-master");
> +	}
> +
> +	client->dev.platform_data = pdata;
> +
> +	return 0;
> +}
> +#else
> +static int si5351_dt_parse(struct i2c_client *client)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_OF */
> +
> +static int si5351_i2c_probe(struct i2c_client *client,
> +			    const struct i2c_device_id *id)
> +{
> +	struct si5351_platform_data *pdata;
> +	struct si5351_driver_data *drvdata;
> +	struct clk_init_data init;
> +	struct clk *clk;
> +	const char *parent_names[4];
> +	u8 num_parents, num_clocks;
> +	int ret, n;
> +
> +	ret = si5351_dt_parse(client);
> +	if (ret)
> +		return ret;
> +
> +	pdata = client->dev.platform_data;
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	drvdata = devm_kzalloc(&client->dev, sizeof(*drvdata), GFP_KERNEL);
> +	if (drvdata == NULL) {
> +		dev_err(&client->dev, "unable to allocate driver data\n");
> +		return -ENOMEM;
> +	}
> +
> +	i2c_set_clientdata(client, drvdata);
> +	drvdata->client = client;
> +	drvdata->variant = pdata->variant;
> +	drvdata->pxtal = pdata->clk_xtal;
> +	drvdata->pclkin = pdata->clk_clkin;
> +
> +	drvdata->regmap = devm_regmap_init_i2c(client, &si5351_regmap_config);
> +	if (IS_ERR(drvdata->regmap)) {
> +		dev_err(&client->dev, "failed to allocate register map\n");
> +		return PTR_ERR(drvdata->regmap);
> +	}
> +
> +	/* Disable interrupts */
> +	si5351_reg_write(drvdata, SI5351_INTERRUPT_MASK, 0xf0);
> +	/* Set disabled output drivers to drive low */
> +	si5351_reg_write(drvdata, SI5351_CLK3_0_DISABLE_STATE, 0x00);
> +	si5351_reg_write(drvdata, SI5351_CLK7_4_DISABLE_STATE, 0x00);
> +	/* Ensure pll select is on XTAL for Si5351A/B */
> +	if (drvdata->variant != SI5351_VARIANT_C)
> +		si5351_set_bits(drvdata, SI5351_PLL_INPUT_SOURCE,
> +				SI5351_PLLA_SOURCE | SI5351_PLLB_SOURCE, 0);
> +
> +	/* setup clock configuration */
> +	for (n = 0; n < 2; n++)
> +		_si5351_pll_reparent(drvdata, n, pdata->pll_src[n]);
> +
> +	for (n = 0; n < 8; n++) {
> +		_si5351_msynth_reparent(drvdata, n,
> +					pdata->clkout[n].multisynth_src);
> +		_si5351_clkout_reparent(drvdata, n,
> +					pdata->clkout[n].clkout_src);
> +		_si5351_clkout_set_drive_strength(drvdata, n,
> +					pdata->clkout[n].drive);
> +	}
> +
> +	/* register xtal input clock gate */
> +	memset(&init, 0, sizeof(init));
> +	init.name = si5351_input_names[0];
> +	init.ops = &si5351_xtal_ops;
> +	init.flags = 0;
> +	if (!IS_ERR(drvdata->pxtal)) {
> +		drvdata->pxtal_name = __clk_get_name(drvdata->pxtal);
> +		init.parent_names = &drvdata->pxtal_name;
> +		init.num_parents = 1;
> +	}
> +	drvdata->xtal.init = &init;
> +	clk = devm_clk_register(&client->dev, &drvdata->xtal);
> +	if (IS_ERR(clk)) {
> +		dev_err(&client->dev, "unable to register %s\n", init.name);
> +		return PTR_ERR(clk);
> +	}
> +
> +	/* register clkin input clock gate */
> +	if (drvdata->variant == SI5351_VARIANT_C) {
> +		memset(&init, 0, sizeof(init));
> +		init.name = si5351_input_names[1];
> +		init.ops = &si5351_clkin_ops;
> +		if (!IS_ERR(drvdata->pclkin)) {
> +			drvdata->pclkin_name = __clk_get_name(drvdata->pclkin);
> +			init.parent_names = &drvdata->pclkin_name;
> +			init.num_parents = 1;
> +		}
> +		drvdata->clkin.init = &init;
> +		clk = devm_clk_register(&client->dev, &drvdata->clkin);
> +		if (IS_ERR(clk)) {
> +			dev_err(&client->dev, "unable to register %s\n",
> +				init.name);
> +			return PTR_ERR(clk);
> +		}
> +	}
> +
> +	/* Si5351C allows to mux either xtal or clkin to PLL input */
> +	num_parents = (drvdata->variant == SI5351_VARIANT_C) ? 2 : 1;
> +	parent_names[0] = si5351_input_names[0];
> +	parent_names[1] = si5351_input_names[1];
> +
> +	/* register PLLA */
> +	drvdata->pll[0].num = 0;
> +	drvdata->pll[0].drvdata = drvdata;
> +	drvdata->pll[0].hw.init = &init;
> +	memset(&init, 0, sizeof(init));
> +	init.name = si5351_pll_names[0];
> +	init.ops = &si5351_pll_ops;
> +	init.flags = 0;
> +	init.parent_names = parent_names;
> +	init.num_parents = num_parents;
> +	clk = devm_clk_register(&client->dev, &drvdata->pll[0].hw);
> +	if (IS_ERR(clk)) {
> +		dev_err(&client->dev, "unable to register %s\n", init.name);
> +		return -EINVAL;
> +	}
> +
> +	/* register PLLB or VXCO (Si5351B) */
> +	drvdata->pll[1].num = 1;
> +	drvdata->pll[1].drvdata = drvdata;
> +	drvdata->pll[1].hw.init = &init;
> +	memset(&init, 0, sizeof(init));
> +	if (drvdata->variant == SI5351_VARIANT_B) {
> +		init.name = si5351_pll_names[2];
> +		init.ops = &si5351_vxco_ops;
> +		init.flags = CLK_IS_ROOT;
> +		init.parent_names = NULL;
> +		init.num_parents = 0;
> +	} else {
> +		init.name = si5351_pll_names[1];
> +		init.ops = &si5351_pll_ops;
> +		init.flags = 0;
> +		init.parent_names = parent_names;
> +		init.num_parents = num_parents;
> +	}
> +	clk = devm_clk_register(&client->dev, &drvdata->pll[1].hw);
> +	if (IS_ERR(clk)) {
> +		dev_err(&client->dev, "unable to register %s\n", init.name);
> +		return -EINVAL;
> +	}
> +
> +	/* register clk multisync and clk out divider */
> +	num_clocks = (drvdata->variant == SI5351_VARIANT_A3) ? 3 : 8;
> +	parent_names[0] = si5351_pll_names[0];
> +	if (drvdata->variant == SI5351_VARIANT_B)
> +		parent_names[1] = si5351_pll_names[2];
> +	else
> +		parent_names[1] = si5351_pll_names[1];
> +
> +	drvdata->msynth = devm_kzalloc(&client->dev, num_clocks *
> +				       sizeof(*drvdata->msynth), GFP_KERNEL);
> +	drvdata->clkout = devm_kzalloc(&client->dev, num_clocks *
> +				       sizeof(*drvdata->clkout), GFP_KERNEL);
> +
> +	drvdata->onecell.clk_num = num_clocks;
> +	drvdata->onecell.clks = devm_kzalloc(&client->dev,
> +		num_clocks * sizeof(*drvdata->onecell.clks), GFP_KERNEL);
> +
> +	if (WARN_ON(!drvdata->msynth || !drvdata->clkout ||
> +		    !drvdata->onecell.clks))
> +		return -ENOMEM;
> +
> +	for (n = 0; n < num_clocks; n++) {
> +		drvdata->msynth[n].num = n;
> +		drvdata->msynth[n].drvdata = drvdata;
> +		drvdata->msynth[n].hw.init = &init;
> +		memset(&init, 0, sizeof(init));
> +		init.name = si5351_msynth_names[n];
> +		init.ops = &si5351_msynth_ops;
> +		init.flags = 0;
> +		if (pdata->clkout[n].pll_master)
> +			init.flags |= CLK_SET_RATE_PARENT;
> +		init.parent_names = parent_names;
> +		init.num_parents = 2;
> +		clk = devm_clk_register(&client->dev, &drvdata->msynth[n].hw);
> +		if (IS_ERR(clk)) {
> +			dev_err(&client->dev, "unable to register %s\n",
> +				init.name);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	num_parents = (drvdata->variant == SI5351_VARIANT_C) ? 4 : 3;
> +	parent_names[2] = si5351_input_names[0];
> +	parent_names[3] = si5351_input_names[1];
> +	for (n = 0; n < num_clocks; n++) {
> +		parent_names[0] = si5351_msynth_names[n];
> +		parent_names[1] = (n < 4) ? si5351_msynth_names[0] :
> +			si5351_msynth_names[4];
> +
> +		drvdata->clkout[n].num = n;
> +		drvdata->clkout[n].drvdata = drvdata;
> +		drvdata->clkout[n].hw.init = &init;
> +		memset(&init, 0, sizeof(init));
> +		init.name = si5351_clkout_names[n];
> +		init.ops = &si5351_clkout_ops;
> +		init.flags = 0;
> +		if (pdata->clkout[n].clkout_src == SI5351_CLKOUT_SRC_MSYNTH_N)
> +			init.flags |= CLK_SET_RATE_PARENT;
> +		init.parent_names = parent_names;
> +		init.num_parents = num_parents;
> +		clk = devm_clk_register(&client->dev, &drvdata->clkout[n].hw);
> +		if (IS_ERR(clk)) {
> +			dev_err(&client->dev, "unable to register %s\n",
> +				init.name);
> +			return -EINVAL;
> +		}
> +		drvdata->onecell.clks[n] = clk;
> +	}
> +
> +	ret = of_clk_add_provider(client->dev.of_node, of_clk_src_onecell_get,
> +				  &drvdata->onecell);
> +	if (ret) {
> +		dev_err(&client->dev, "unable to add clk provider\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id si5351_i2c_ids[] = {
> +	{ "silabs,si5351", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, si5351_i2c_ids);
> +
> +static struct i2c_driver si5351_driver = {
> +	.driver = {
> +		.name = "si5351",
> +		.of_match_table = of_match_ptr(si5351_dt_ids),
> +	},
> +	.probe = si5351_i2c_probe,
> +	.id_table = si5351_i2c_ids,
> +};
> +module_i2c_driver(si5351_driver);
> +
> +MODULE_AUTHOR("Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com");
> +MODULE_DESCRIPTION("Silicon Labs Si5351A/B/C clock generator driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/clk/clk-si5351.h b/drivers/clk/clk-si5351.h
> new file mode 100644
> index 0000000..af41b50
> --- /dev/null
> +++ b/drivers/clk/clk-si5351.h
> @@ -0,0 +1,155 @@
> +/*
> + * clk-si5351.h: Silicon Laboratories Si5351A/B/C I2C Clock Generator
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + * Rabeeh Khoury <rabeeh@solid-run.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef _CLK_SI5351_H_
> +#define _CLK_SI5351_H_
> +
> +#define SI5351_BUS_BASE_ADDR			0x60
> +
> +#define SI5351_PLL_VCO_MIN			600000000
> +#define SI5351_PLL_VCO_MAX			900000000
> +#define SI5351_MULTISYNTH_MIN_FREQ		1000000
> +#define SI5351_MULTISYNTH_DIVBY4_FREQ		150000000
> +#define SI5351_MULTISYNTH_MAX_FREQ		160000000
> +#define SI5351_MULTISYNTH67_MAX_FREQ		SI5351_MULTISYNTH_DIVBY4_FREQ
> +#define SI5351_CLKOUT_MIN_FREQ			8000
> +#define SI5351_CLKOUT_MAX_FREQ			SI5351_MULTISYNTH_MAX_FREQ
> +#define SI5351_CLKOUT67_MAX_FREQ		SI5351_MULTISYNTH67_MAX_FREQ
> +
> +#define SI5351_PLL_A_MIN			15
> +#define SI5351_PLL_A_MAX			90
> +#define SI5351_PLL_B_MAX			(SI5351_PLL_C_MAX-1)
> +#define SI5351_PLL_C_MAX			1048575
> +#define SI5351_MULTISYNTH_A_MIN			6
> +#define SI5351_MULTISYNTH_A_MAX			1800
> +#define SI5351_MULTISYNTH67_A_MAX		254
> +#define SI5351_MULTISYNTH_B_MAX			(SI5351_MULTISYNTH_C_MAX-1)
> +#define SI5351_MULTISYNTH_C_MAX			1048575
> +#define SI5351_MULTISYNTH_P1_MAX		((1<<18)-1)
> +#define SI5351_MULTISYNTH_P2_MAX		((1<<20)-1)
> +#define SI5351_MULTISYNTH_P3_MAX		((1<<20)-1)
> +
> +#define SI5351_DEVICE_STATUS			0
> +#define SI5351_INTERRUPT_STATUS			1
> +#define SI5351_INTERRUPT_MASK			2
> +#define  SI5351_STATUS_SYS_INIT			(1<<7)
> +#define  SI5351_STATUS_LOL_B			(1<<6)
> +#define  SI5351_STATUS_LOL_A			(1<<5)
> +#define  SI5351_STATUS_LOS			(1<<4)
> +#define SI5351_OUTPUT_ENABLE_CTRL		3
> +#define SI5351_OEB_PIN_ENABLE_CTRL		9
> +#define SI5351_PLL_INPUT_SOURCE			15
> +#define  SI5351_CLKIN_DIV_MASK			(3<<6)
> +#define  SI5351_CLKIN_DIV_1			(0<<6)
> +#define  SI5351_CLKIN_DIV_2			(1<<6)
> +#define  SI5351_CLKIN_DIV_4			(2<<6)
> +#define  SI5351_CLKIN_DIV_8			(3<<6)
> +#define  SI5351_PLLB_SOURCE			(1<<3)
> +#define  SI5351_PLLA_SOURCE			(1<<2)
> +
> +#define SI5351_CLK0_CTRL			16
> +#define SI5351_CLK1_CTRL			17
> +#define SI5351_CLK2_CTRL			18
> +#define SI5351_CLK3_CTRL			19
> +#define SI5351_CLK4_CTRL			20
> +#define SI5351_CLK5_CTRL			21
> +#define SI5351_CLK6_CTRL			22
> +#define SI5351_CLK7_CTRL			23
> +#define  SI5351_CLK_POWERDOWN			(1<<7)
> +#define  SI5351_CLK_INTEGER_MODE		(1<<6)
> +#define  SI5351_CLK_PLL_SELECT			(1<<5)
> +#define  SI5351_CLK_INVERT			(1<<4)
> +#define  SI5351_CLK_INPUT_MASK			(3<<2)
> +#define  SI5351_CLK_INPUT_XTAL			(0<<2)
> +#define  SI5351_CLK_INPUT_CLKIN			(1<<2)
> +#define  SI5351_CLK_INPUT_MULTISYNTH_0_4	(2<<2)
> +#define  SI5351_CLK_INPUT_MULTISYNTH_N		(3<<2)
> +#define  SI5351_CLK_DRIVE_STRENGTH_MASK		(3<<0)
> +#define  SI5351_CLK_DRIVE_STRENGTH_2MA		(0<<0)
> +#define  SI5351_CLK_DRIVE_STRENGTH_4MA		(1<<0)
> +#define  SI5351_CLK_DRIVE_STRENGTH_6MA		(2<<0)
> +#define  SI5351_CLK_DRIVE_STRENGTH_8MA		(3<<0)
> +
> +#define SI5351_CLK3_0_DISABLE_STATE		24
> +#define SI5351_CLK7_4_DISABLE_STATE		25
> +#define  SI5351_CLK_DISABLE_STATE_LOW		0
> +#define  SI5351_CLK_DISABLE_STATE_HIGH		1
> +#define  SI5351_CLK_DISABLE_STATE_FLOAT		2
> +#define  SI5351_CLK_DISABLE_STATE_NEVER		3
> +
> +#define SI5351_PARAMETERS_LENGTH		8
> +#define SI5351_PLLA_PARAMETERS			26
> +#define SI5351_PLLB_PARAMETERS			34
> +#define SI5351_CLK0_PARAMETERS			42
> +#define SI5351_CLK1_PARAMETERS			50
> +#define SI5351_CLK2_PARAMETERS			58
> +#define SI5351_CLK3_PARAMETERS			66
> +#define SI5351_CLK4_PARAMETERS			74
> +#define SI5351_CLK5_PARAMETERS			82
> +#define SI5351_CLK6_PARAMETERS			90
> +#define SI5351_CLK7_PARAMETERS			91
> +#define SI5351_CLK6_7_OUTPUT_DIVIDER		92
> +#define  SI5351_OUTPUT_CLK_DIV_MASK		(7 << 4)
> +#define  SI5351_OUTPUT_CLK6_DIV_MASK		(7 << 0)
> +#define  SI5351_OUTPUT_CLK_DIV_SHIFT		4
> +#define  SI5351_OUTPUT_CLK_DIV6_SHIFT		0
> +#define  SI5351_OUTPUT_CLK_DIV_1		0
> +#define  SI5351_OUTPUT_CLK_DIV_2		1
> +#define  SI5351_OUTPUT_CLK_DIV_4		2
> +#define  SI5351_OUTPUT_CLK_DIV_8		3
> +#define  SI5351_OUTPUT_CLK_DIV_16		4
> +#define  SI5351_OUTPUT_CLK_DIV_32		5
> +#define  SI5351_OUTPUT_CLK_DIV_64		6
> +#define  SI5351_OUTPUT_CLK_DIV_128		7
> +#define  SI5351_OUTPUT_CLK_DIVBY4		(3<<2)
> +
> +#define SI5351_SSC_PARAM0			149
> +#define SI5351_SSC_PARAM1			150
> +#define SI5351_SSC_PARAM2			151
> +#define SI5351_SSC_PARAM3			152
> +#define SI5351_SSC_PARAM4			153
> +#define SI5351_SSC_PARAM5			154
> +#define SI5351_SSC_PARAM6			155
> +#define SI5351_SSC_PARAM7			156
> +#define SI5351_SSC_PARAM8			157
> +#define SI5351_SSC_PARAM9			158
> +#define SI5351_SSC_PARAM10			159
> +#define SI5351_SSC_PARAM11			160
> +#define SI5351_SSC_PARAM12			161
> +
> +#define SI5351_VXCO_PARAMETERS_LOW		162
> +#define SI5351_VXCO_PARAMETERS_MID		163
> +#define SI5351_VXCO_PARAMETERS_HIGH		164
> +
> +#define SI5351_CLK0_PHASE_OFFSET		165
> +#define SI5351_CLK1_PHASE_OFFSET		166
> +#define SI5351_CLK2_PHASE_OFFSET		167
> +#define SI5351_CLK3_PHASE_OFFSET		168
> +#define SI5351_CLK4_PHASE_OFFSET		169
> +#define SI5351_CLK5_PHASE_OFFSET		170
> +
> +#define SI5351_PLL_RESET			177
> +#define  SI5351_PLL_RESET_B			(1<<7)
> +#define  SI5351_PLL_RESET_A			(1<<5)
> +
> +#define SI5351_CRYSTAL_LOAD			183
> +#define  SI5351_CRYSTAL_LOAD_MASK		(3<<6)
> +#define  SI5351_CRYSTAL_LOAD_6PF		(1<<6)
> +#define  SI5351_CRYSTAL_LOAD_8PF		(2<<6)
> +#define  SI5351_CRYSTAL_LOAD_10PF		(3<<6)
> +
> +#define SI5351_FANOUT_ENABLE			187
> +#define  SI5351_CLKIN_ENABLE			(1<<7)
> +#define  SI5351_XTAL_ENABLE			(1<<6)
> +#define  SI5351_MULTISYNTH_ENABLE		(1<<4)
> +
> +#endif
> diff --git a/include/linux/platform_data/si5351.h b/include/linux/platform_data/si5351.h
> new file mode 100644
> index 0000000..f62218e
> --- /dev/null
> +++ b/include/linux/platform_data/si5351.h
> @@ -0,0 +1,114 @@
> +/*
> + * Si5351A/B/C programmable clock generator platform_data.
> + */
> +
> +#ifndef __LINUX_PLATFORM_DATA_SI5351_H__
> +#define __LINUX_PLATFORM_DATA_SI5351_H__
> +
> +struct clk;
> +
> +/**
> + * enum si5351_variant - SiLabs Si5351 chip variant
> + * @SI5351_VARIANT_A: Si5351A (8 output clocks, XTAL input)
> + * @SI5351_VARIANT_A3: Si5351A MSOP10 (3 output clocks, XTAL input)
> + * @SI5351_VARIANT_B: Si5351B (8 output clocks, XTAL/VXCO input)
> + * @SI5351_VARIANT_C: Si5351C (8 output clocks, XTAL/CLKIN input)
> + */
> +enum si5351_variant {
> +	SI5351_VARIANT_A = 1,
> +	SI5351_VARIANT_A3 = 2,
> +	SI5351_VARIANT_B = 3,
> +	SI5351_VARIANT_C = 4,
> +};
> +
> +/**
> + * enum si5351_pll_src - Si5351 pll clock source
> + * @SI5351_PLL_SRC_DEFAULT: default, do not change eeprom config
> + * @SI5351_PLL_SRC_XTAL: pll source clock is XTAL input
> + * @SI5351_PLL_SRC_CLKIN: pll source clock is CLKIN input
> + */
> +enum si5351_pll_src {
> +	SI5351_PLL_SRC_DEFAULT = 0,
> +	SI5351_PLL_SRC_XTAL = 1,
> +	SI5351_PLL_SRC_CLKIN = 2,
> +};
> +
> +/**
> + * enum si5351_multisynth_src - Si5351 multisynth clock source
> + * @SI5351_MULTISYNTH_SRC_DEFAULT: default, do not change eeprom config
> + * @SI5351_MULTISYNTH_SRC_VCO0: multisynth source clock is VCO0
> + * @SI5351_MULTISYNTH_SRC_VCO1: multisynth source clock is VCO1
> + */
> +enum si5351_multisynth_src {
> +	SI5351_MULTISYNTH_SRC_DEFAULT = 0,
> +	SI5351_MULTISYNTH_SRC_VCO0 = 1,
> +	SI5351_MULTISYNTH_SRC_VCO1 = 2,
> +};
> +
> +/**
> + * enum si5351_clkout_src - Si5351 clock output clock source
> + * @SI5351_CLKOUT_SRC_DEFAULT: default, do not change eeprom config
> + * @SI5351_CLKOUT_SRC_MSYNTH_N: clkout N source clock is multisynth N
> + * @SI5351_CLKOUT_SRC_MSYNTH_0_4: clkout N source clock is multisynth 0 (N<4)
> + *                                or 4 (N>=4)
> + * @SI5351_CLKOUT_SRC_XTAL: clkout N source clock is XTAL
> + * @SI5351_CLKOUT_SRC_CLKIN: clkout N source clock is CLKIN
> + */
> +enum si5351_clkout_src {
> +	SI5351_CLKOUT_SRC_DEFAULT = 0,
> +	SI5351_CLKOUT_SRC_MSYNTH_N = 1,
> +	SI5351_CLKOUT_SRC_MSYNTH_0_4 = 2,
> +	SI5351_CLKOUT_SRC_XTAL = 3,
> +	SI5351_CLKOUT_SRC_CLKIN = 4,
> +};
> +
> +/**
> + * enum si5351_drive_strength - Si5351 clock output drive strength
> + * @SI5351_DRIVE_DEFAULT: default, do not change eeprom config
> + * @SI5351_DRIVE_2MA: 2mA clock output drive strength
> + * @SI5351_DRIVE_4MA: 4mA clock output drive strength
> + * @SI5351_DRIVE_6MA: 6mA clock output drive strength
> + * @SI5351_DRIVE_8MA: 8mA clock output drive strength
> + */
> +enum si5351_drive_strength {
> +	SI5351_DRIVE_DEFAULT = 0,
> +	SI5351_DRIVE_2MA = 2,
> +	SI5351_DRIVE_4MA = 4,
> +	SI5351_DRIVE_6MA = 6,
> +	SI5351_DRIVE_8MA = 8,
> +};
> +
> +/**
> + * struct si5351_clkout_config - Si5351 clock output configuration
> + * @clkout: clkout number
> + * @multisynth_src: multisynth source clock
> + * @clkout_src: clkout source clock
> + * @pll_master: if true, clkout can also change pll rate
> + * @drive: output drive strength
> + * @rate: initial clkout rate, or default if 0
> + */
> +struct si5351_clkout_config {
> +	enum si5351_multisynth_src multisynth_src;
> +	enum si5351_clkout_src clkout_src;
> +	enum si5351_drive_strength drive;
> +	bool pll_master;
> +	unsigned long rate;
> +};
> +
> +/**
> + * struct si5351_platform_data - Platform data for the Si5351 clock driver
> + * @variant: Si5351 chip variant
> + * @clk_xtal: xtal input clock
> + * @clk_clkin: clkin input clock
> + * @pll_src: array of pll source clock setting
> + * @clkout: array of clkout configuration
> + */
> +struct si5351_platform_data {
> +	enum si5351_variant variant;
> +	struct clk *clk_xtal;
> +	struct clk *clk_clkin;
> +	enum si5351_pll_src pll_src[2];
> +	struct si5351_clkout_config clkout[8];
> +};
> +
> +#endif
> -- 
> 1.7.10.4
> 
> 
