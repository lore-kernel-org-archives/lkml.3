Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934611Ab3BSTPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:15:51 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62397 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934597Ab3BSTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:15:48 -0500
Message-ID: <5123CF5B.9060804@gmail.com>
Date: Tue, 19 Feb 2013 20:15:39 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dom Cobley <popcornmix@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rabeeh Khoury <rabeeh@solid-run.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: add si5351 i2c common clock driver
References: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

I did some more tests today and it took me a while to dig for the root
cause why things were not working for me in the first place - see below.


On 09.02.2013 13:59, Sebastian Hesselbarth wrote:

> +==Example==
> +
> +/* 25MHz reference crystal */
> +ref25: ref25M {
> +	compatible = "fixed-clock";
> +	#clock-cells = <0>;
> +	clock-frequency = <25000000>;
> +};
> +
> +i2c-master-node {
> +
> +	/* Si5351a msop10 i2c clock generator */
> +	si5351a: clock-generator@60 {
> +		compatible = "silabs,si5351a-msop";
> +		reg = <0x60>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		#clock-cells = <1>;
> +
> +		/* connect xtal input to 25MHz reference */
> +		clocks = <&ref25>;

As referred to in another thread, registering the ref25M clock that way
didn't suffice for me on my platform - but that's a different story.

> +static void si5351_read_parameters(struct si5351_driver_data *drvdata,
> +	unsigned char reg, struct si5351_parameters *params)
> +{
> +	unsigned char buf[SI5351_PARAMETERS_LENGTH];

On a general note, I think you can use u8 instead of unsigned char all
over the place here, which will save you some indentation trouble.

> +static inline int _si5351_clkout_reparent(struct si5351_driver_data *drvdata,
> +				  unsigned char num, unsigned char parent)
> +{
> +	struct clk *pclk;
> +
> +	if (num > 8 ||
> +	    (drvdata->variant == SI5351_VARIANT_A3 && num > 3))
> +		return -EINVAL;
> +
> +	switch (parent) {
> +	case 0:
> +		pclk = drvdata->msynth[num].hw.clk;
> +		break;
> +	case 1:
> +		pclk = drvdata->msynth[0].hw.clk;
> +		if (num >= 4)
> +			pclk = drvdata->msynth[4].hw.clk;
> +		break;
> +	case 2:
> +		pclk = drvdata->xtal.clk;
> +		break;
> +	case 3:
> +		if (drvdata->variant != SI5351_VARIANT_C)
> +			return -EINVAL;
> +		pclk = drvdata->clkin.clk;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return clk_set_parent(drvdata->clkout[num].hw.clk, pclk);
> +}

[...]

> +static int si5351_clkout_set_parent(struct clk_hw *hw, u8 index)
> +{
> +	struct si5351_hw_data *hwdata =
> +		container_of(hw, struct si5351_hw_data, hw);
> +	unsigned val;
> +
> +	val = 0;
> +	hw->clk->flags &= ~CLK_SET_RATE_PARENT;
> +	switch (index) {
> +	case 0:
> +		hw->clk->flags |= CLK_SET_RATE_PARENT;
> +		val = SI5351_CLK_INPUT_MULTISYNTH_N;
> +		break;

I fugured that _si5351_clkout_reparent() wouldn't actually call
->set_parent() on the clock, which leads to the fact that
CLK_SET_RATE_PARENT is not set in the flags. That way, only the clkout
end leaf is actually supplied with a new rate, which leads to incorrect
effective clocks, depending on the current multisynth/pll configuration.

The reason for this is in clk_set_parent() itself, which bails if the
parent is already set to the passed value:

	if (clk->parent == parent)
		goto out;

I fixed that for now by explicitly setting the clock's parent to NULL
before calling clk_set_parent() in _si5351_clkout_reparent(), so the
calbacks are triggered. But there might be a nicer way, for example to
factor out the CLK_SET_RATE_PARENT handling to some function called from
_si5351_clkout_reparent() or so.

Anyway, with this hack in place along with the other details I mentioned
in my first mail, the driver seems to work for me now, which is great. I
will do more extensive tests later that week when I have access to
better scopes ...


Many thanks again,
Daniel



> +	case 1:
> +		/* clk0/clk4 can only connect to its own multisync */
> +		if (hwdata->num == 0 || hwdata->num == 4)
> +			val = SI5351_CLK_INPUT_MULTISYNTH_N;
> +		else
> +			val = SI5351_CLK_INPUT_MULTISYNTH_0_4;
> +		break;
> +	case 2:
> +		val = SI5351_CLK_INPUT_XTAL;
> +		break;
> +	case 3:
> +		val = SI5351_CLK_INPUT_CLKIN;
> +		break;
> +	}
> +	si5351_set_bits(hwdata->drvdata, SI5351_CLK0_CTRL + hwdata->num,
> +			SI5351_CLK_INPUT_MASK, val);
> +
> +	return 0;
> +}
> +
> +static unsigned long si5351_clkout_recalc_rate(struct clk_hw *hw,
> +					       unsigned long parent_rate)
> +{
> +	struct si5351_hw_data *hwdata =
> +		container_of(hw, struct si5351_hw_data, hw);
> +	unsigned char reg = SI5351_CLK0_PARAMETERS +
> +		(SI5351_PARAMETERS_LENGTH * hwdata->num);
> +	unsigned char rdiv;
> +
> +	rdiv = (si5351_reg_read(hwdata->drvdata, reg + 2) &
> +		SI5351_OUTPUT_CLK_DIV_MASK) >> SI5351_OUTPUT_CLK_DIV_SHIFT;
> +
> +	return parent_rate >> rdiv;
> +}
> +
> +static long si5351_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
> +				     unsigned long *parent_rate)
> +{
> +	struct si5351_hw_data *hwdata =
> +		container_of(hw, struct si5351_hw_data, hw);
> +	unsigned char rdiv;
> +
> +	/* clkout6/7 can only handle output freqencies < 150MHz */
> +	if (hwdata->num >= 6 && rate > SI5351_CLKOUT67_MAX_FREQ)
> +		rate = SI5351_CLKOUT67_MAX_FREQ;
> +
> +	/* clkout freqency is 8kHz - 160MHz */
> +	if (rate > SI5351_CLKOUT_MAX_FREQ)
> +		rate = SI5351_CLKOUT_MAX_FREQ;
> +	if (rate < SI5351_CLKOUT_MIN_FREQ)
> +		rate = SI5351_CLKOUT_MIN_FREQ;
> +
> +	/* request frequency if multisync master */
> +	if (hwdata->hw.clk->flags & CLK_SET_RATE_PARENT) {
> +		/* use r divider for frequencies below 1MHz */
> +		rdiv = SI5351_OUTPUT_CLK_DIV_1;
> +		while (rate < SI5351_MULTISYNTH_MIN_FREQ &&
> +		       rdiv < SI5351_OUTPUT_CLK_DIV_128) {
> +			rdiv += 1;
> +			rate *= 2;
> +		}
> +		*parent_rate = rate;
> +	} else {
> +		unsigned long new_rate, new_err, err;
> +
> +		/* round to closed rdiv */
> +		rdiv = SI5351_OUTPUT_CLK_DIV_1;
> +		new_rate = *parent_rate;
> +		err = abs(new_rate - rate);
> +		do {
> +			new_rate >>= 1;
> +			new_err = abs(new_rate - rate);
> +			if (new_err > err || rdiv == SI5351_OUTPUT_CLK_DIV_128)
> +				break;
> +			rdiv++;
> +			err = new_err;
> +		} while (1);
> +	}
> +	rate = *parent_rate >> rdiv;
> +
> +	dev_dbg(&hwdata->drvdata->client->dev,
> +		"%s - %s: rdiv = %u, parent_rate = %lu, rate = %lu\n",
> +		__func__, hwdata->hw.clk->name, (1 << rdiv), *parent_rate,
> +		rate);
> +
> +	return rate;
> +}
> +
> +static int si5351_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
> +				  unsigned long parent_rate)
> +{
> +	struct si5351_hw_data *hwdata =
> +		container_of(hw, struct si5351_hw_data, hw);
> +	unsigned char reg = SI5351_CLK0_PARAMETERS +
> +		(SI5351_PARAMETERS_LENGTH * hwdata->num);
> +	unsigned long new_rate, new_err, err;
> +	unsigned char rdiv;
> +
> +	/* round to closed rdiv */
> +	rdiv = SI5351_OUTPUT_CLK_DIV_1;
> +	new_rate = parent_rate;
> +	err = abs(new_rate - rate);
> +	do {
> +		new_rate >>= 1;
> +		new_err = abs(new_rate - rate);
> +		if (new_err > err || rdiv == SI5351_OUTPUT_CLK_DIV_128)
> +			break;
> +		rdiv++;
> +		err = new_err;
> +	} while (1);
> +
> +	/* powerdown clkout */
> +	si5351_set_bits(hwdata->drvdata, SI5351_CLK0_CTRL + hwdata->num,
> +			SI5351_CLK_POWERDOWN, SI5351_CLK_POWERDOWN);
> +
> +	/* write output divider */
> +	switch (hwdata->num) {
> +	case 6:
> +		si5351_set_bits(hwdata->drvdata, SI5351_CLK6_7_OUTPUT_DIVIDER,
> +				SI5351_OUTPUT_CLK6_DIV_MASK, rdiv);
> +		break;
> +	case 7:
> +		si5351_set_bits(hwdata->drvdata, SI5351_CLK6_7_OUTPUT_DIVIDER,
> +				SI5351_OUTPUT_CLK_DIV_MASK,
> +				rdiv << SI5351_OUTPUT_CLK_DIV_SHIFT);
> +		break;
> +	default:
> +		si5351_set_bits(hwdata->drvdata, reg + 2,
> +				SI5351_OUTPUT_CLK_DIV_MASK,
> +				rdiv << SI5351_OUTPUT_CLK_DIV_SHIFT);
> +	}
> +
> +	/* powerup clkout */
> +	si5351_set_bits(hwdata->drvdata, SI5351_CLK0_CTRL + hwdata->num,
> +			SI5351_CLK_POWERDOWN, 0);
> +
> +	dev_dbg(&hwdata->drvdata->client->dev,
> +		"%s - %s: rdiv = %u, parent_rate = %lu, rate = %lu\n",
> +		__func__, hwdata->hw.clk->name, (1 << rdiv), parent_rate, rate);
> +
> +	return 0;
> +}
> +
> +static const struct clk_ops si5351_clkout_ops = {
> +	.prepare = si5351_clkout_prepare,
> +	.unprepare = si5351_clkout_unprepare,
> +	.is_enabled = si5351_clkout_is_enabled,
> +	.set_parent = si5351_clkout_set_parent,
> +	.get_parent = si5351_clkout_get_parent,
> +	.recalc_rate = si5351_clkout_recalc_rate,
> +	.round_rate = si5351_clkout_round_rate,
> +	.set_rate = si5351_clkout_set_rate,
> +};
> +
> +/*
> + * Si5351 i2c probe and DT
> + */
> +static void si5351_dt_setup(
> +	struct i2c_client *client, struct si5351_driver_data *drvdata)
> +{
> +	struct device_node *np = client->dev.of_node;
> +	struct property *prop;
> +	const __be32 *p;
> +	unsigned int num, val;
> +
> +	if (np == NULL)
> +		return;
> +
> +	/*
> +	 * property pll-source : <num src>, [<..>]
> +	 * allow to selectively set pll source
> +	 */
> +	of_property_for_each_u32(client->dev.of_node, "pll-source",
> +				 prop, p, num) {
> +		if (num >= 2) {
> +			dev_err(&client->dev,
> +				"invalid pll %d on pll-source prop\n", num);
> +			break;
> +		}
> +
> +		p = of_prop_next_u32(prop, p, &val);
> +		if (!p)
> +			break;
> +
> +		if (_si5351_pll_reparent(drvdata, num, val))
> +			dev_warn(&client->dev,
> +				 "unable to reparent pll %d to %d\n",
> +				 num, val);
> +	}
> +
> +	for_each_child_of_node(client->dev.of_node, np) {
> +		if (of_property_read_u32(np, "reg", &num)) {
> +			dev_err(&client->dev, "missing reg property of %s\n",
> +				np->full_name);
> +			continue;
> +		}
> +
> +		if (of_property_read_bool(np, "pll-master"))
> +			_si5351_msynth_set_pll_master(drvdata, num, 1);
> +
> +		if (!of_property_read_u32(np, "drive-strength", &val)) {
> +			if (_si5351_clkout_set_drive_strength(drvdata,
> +							      num, val))
> +				dev_warn(&client->dev,
> +					 "unable to set drive strength of %d to %d\n",
> +					 num, val);
> +		}
> +
> +		if (!of_property_read_u32(np, "multisynth-source", &val)) {
> +			if (_si5351_msynth_reparent(drvdata, num, val))
> +				dev_warn(&client->dev,
> +					 "unable to reparent multisynth %d to %d\n",
> +					 num, val);
> +		}
> +
> +		if (!of_property_read_u32(np, "clock-source", &val)) {
> +			if (_si5351_clkout_reparent(drvdata, num, val))
> +				dev_warn(&client->dev,
> +					 "unable to reparent clockout %d to %d\n",
> +					 num, val);
> +		}
> +
> +		if (!of_property_read_u32(np, "clock-frequency", &val))
> +			clk_set_rate(drvdata->onecell.clks[num], val);
> +	}
> +}
> +
> +static const struct of_device_id si5351_dt_ids[] = {
> +	{ .compatible = "silabs,si5351a", .data = (void *)SI5351_VARIANT_A, },
> +	{ .compatible = "silabs,si5351a-msop",
> +					 .data = (void *)SI5351_VARIANT_A3, },
> +	{ .compatible = "silabs,si5351b", .data = (void *)SI5351_VARIANT_B, },
> +	{ .compatible = "silabs,si5351c", .data = (void *)SI5351_VARIANT_C, },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, si5351_dt_ids);
> +
> +static int si5351_dt_parse(
> +	struct i2c_client *client, struct si5351_driver_data *drvdata)
> +{
> +	struct device_node *np = client->dev.of_node;
> +	const struct of_device_id *match;
> +
> +	if (np == NULL)
> +		return -EINVAL;
> +
> +	match = of_match_node(si5351_dt_ids, np);
> +	if (match == NULL)
> +		return -EINVAL;
> +
> +	drvdata->variant = (enum si5351_variant)match->data;
> +	drvdata->pxtal = of_clk_get(np, 0);
> +	drvdata->pclkin = of_clk_get(np, 1);
> +
> +	return 0;
> +}
> +
> +static int si5351_i2c_probe(
> +	struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +	struct si5351_driver_data *drvdata;
> +	struct clk_init_data init;
> +	struct clk *clk;
> +	const char *parent_names[4];
> +	u8 num_parents, num_clocks;
> +	int ret, n;
> +
> +	drvdata = devm_kzalloc(&client->dev, sizeof(struct si5351_driver_data),
> +			       GFP_KERNEL);
> +	if (drvdata == NULL) {
> +		dev_err(&client->dev, "unable to allocate driver data\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = si5351_dt_parse(client, drvdata);
> +	if (ret)
> +		return ret;
> +
> +	i2c_set_clientdata(client, drvdata);
> +	drvdata->client = client;
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
> +	/* register xtal input clock gate */
> +	memset(&init, 0, sizeof(struct clk_init_data));
> +	init.name = si5351_input_names[0];
> +	init.ops = &si5351_xtal_ops;
> +	init.flags = 0;
> +	if (!IS_ERR(drvdata->pxtal)) {
> +		init.parent_names = &drvdata->pxtal->name;
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
> +		memset(&init, 0, sizeof(struct clk_init_data));
> +		init.name = si5351_input_names[1];
> +		init.ops = &si5351_clkin_ops;
> +		if (!IS_ERR(drvdata->pclkin)) {
> +			init.parent_names = &drvdata->pclkin->name;
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
> +	memset(&init, 0, sizeof(struct clk_init_data));
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
> +	memset(&init, 0, sizeof(struct clk_init_data));
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
> +	drvdata->msynth = devm_kzalloc(&client->dev,
> +		num_clocks * sizeof(struct si5351_hw_data), GFP_KERNEL);
> +
> +	drvdata->clkout = devm_kzalloc(&client->dev,
> +		num_clocks * sizeof(struct si5351_hw_data), GFP_KERNEL);
> +
> +	drvdata->onecell.clk_num = num_clocks;
> +	drvdata->onecell.clks = devm_kzalloc(&client->dev,
> +		num_clocks * sizeof(struct clk *), GFP_KERNEL);
> +
> +	if (WARN_ON(!drvdata->msynth || !drvdata->clkout ||
> +		    !drvdata->onecell.clks))
> +		return -ENOMEM;
> +
> +	for (n = 0; n < num_clocks; n++) {
> +		drvdata->msynth[n].num = n;
> +		drvdata->msynth[n].drvdata = drvdata;
> +		drvdata->msynth[n].hw.init = &init;
> +		memset(&init, 0, sizeof(struct clk_init_data));
> +		init.name = si5351_msynth_names[n];
> +		init.ops = &si5351_msynth_ops;
> +		init.flags = 0;
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
> +		memset(&init, 0, sizeof(struct clk_init_data));
> +		init.name = si5351_clkout_names[n];
> +		init.ops = &si5351_clkout_ops;
> +		init.flags = 0;
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
> +	/* setup clock setup from DT */
> +	si5351_dt_setup(client, drvdata);
> +
> +	of_clk_add_provider(client->dev.of_node, of_clk_src_onecell_get,
> +			    &drvdata->onecell);
> +
> +	dev_info(&client->dev, "registered si5351 i2c client\n");
> +
> +	return 0;
> +}
> +
> +static int si5351_i2c_remove(struct i2c_client *client)
> +{
> +	i2c_set_clientdata(client, NULL);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id si5351_i2c_ids[] = {
> +	{ "silabs,si5351", SI5351_BUS_BASE_ADDR | 0 },
> +	{ "silabs,si5351", SI5351_BUS_BASE_ADDR | 1 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, si5351_i2c_ids);
> +
> +static struct i2c_driver si5351_driver = {
> +	.driver = {
> +		.name = "si5351",
> +		.of_match_table = si5351_dt_ids,
> +	},
> +	.probe = si5351_i2c_probe,
> +	.remove = si5351_i2c_remove,
> +	.id_table = si5351_i2c_ids,
> +};
> +
> +static int __init si5351_module_init(void)
> +{
> +	return i2c_add_driver(&si5351_driver);
> +}
> +module_init(si5351_module_init);
> +
> +static void __exit si5351_module_exit(void)
> +{
> +	i2c_del_driver(&si5351_driver);
> +}
> +module_exit(si5351_module_exit);
> +
> +MODULE_AUTHOR("Sebastian Hesselbarth <sebastian.hesselbarth@gmail.de");
> +MODULE_DESCRIPTION("Silicon Labs Si5351A/B/C clock generator driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/clk/clk-si5351.h b/drivers/clk/clk-si5351.h
> new file mode 100644
> index 0000000..424073c
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
> +#define  SI5351_CLK_DRIVE_MASK			(3<<0)
> +#define  SI5351_CLK_DRIVE_2MA			(0<<0)
> +#define  SI5351_CLK_DRIVE_4MA			(1<<0)
> +#define  SI5351_CLK_DRIVE_6MA			(2<<0)
> +#define  SI5351_CLK_DRIVE_8MA			(3<<0)
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
> 

