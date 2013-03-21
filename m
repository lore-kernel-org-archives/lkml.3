Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3CUSGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:06:55 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39778 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837Ab3CUSGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:06:53 -0400
Message-ID: <514B4CBF.7070106@metafoo.de>
Date: Thu, 21 Mar 2013 19:09:03 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] clk: add si5351 i2c common clock driver
References: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com> <1363603397-2762-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1363603397-2762-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 11:43 AM, Sebastian Hesselbarth wrote:
> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
> i2c programmable clock generators. Currently, the driver supports
> DT kernels only and VXCO feature of si5351b is not implemented. DT
> bindings selectively allow to overwrite stored Si5351 configuration
> which is very helpful for clock generators with empty eeprom
> configuration. Corresponding device tree binding documentation is
> also added.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Hi,

Couple of comments inside.

> ---
> Changes from v2:
> - add curly brackets to if-else-statements (Reported by Daniel Mack)
> - fix div-by-zero for clk6/clk7 (Reported by Daniel Mack)
> - fix parameter address calculation for clk6/clk7
> 
> Changes from v1:
> - remove .is_enabled functions as they read from i2c
>   (Reported by Daniel Mack)
> - add CLK_SET_RATE_PARENT on clkout reparent if clkout uses
>   its own multisync
[...]
> ---
>  .../devicetree/bindings/clock/silabs,si5351.txt    |  114 ++
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  drivers/clk/Kconfig                                |    9 +
>  drivers/clk/Makefile                               |    1 +
>  drivers/clk/clk-si5351.c                           | 1429 ++++++++++++++++++++
>  drivers/clk/clk-si5351.h                           |  155 +++
>  6 files changed, 1709 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/silabs,si5351.txt
>  create mode 100644 drivers/clk/clk-si5351.c
>  create mode 100644 drivers/clk/clk-si5351.h
> 
> diff --git a/Documentation/devicetree/bindings/clock/silabs,si5351.txt b/Documentation/devicetree/bindings/clock/silabs,si5351.txt
> new file mode 100644
> index 0000000..f73d2d2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/silabs,si5351.txt
> @@ -0,0 +1,114 @@
> +Binding for Silicon Labs Si5351a/b/c programmable i2c clock generator.
> +
> +Reference
> +[1] Si5351A/B/C Data Sheet
> +    http://www.silabs.com/Support%20Documents/TechnicalDocs/Si5351.pdf
> +
> +The Si5351a/b/c are programmable i2c clock generators with upto 8 output
> +clocks. Si5351a also has a reduced pin-count package (MSOP10) where only
> +3 output clocks are accessible. The internal structure of the clock
> +generators can be found in [1].
> +
> +==I2C device node==
> +
> +Required properties:
> +- compatible: shall be one of "silabs,si5351{a,a-msop,b,c}".
> +- reg: i2c device address, shall be 0x60 or 0x61.
> +- #clock-cells: from common clock binding; shall be set to 1.
> +- clocks: from common clock binding; list of parent clock
> +  handles, shall be xtal reference clock or xtal and clkin for
> +  si5351c only.
> +- #address-cells: shall be set to 1.
> +- #size-cells: shall be set to 0.
> +
> +Optional properties:
> +- pll-source: pair of (number, source) for each pll. Allows
> +  to overwrite clock source of pll A (number=0) or B (number=1).
> +
> +==Child nodes==
> +
> +Each of the clock outputs can be overwritten individually by
> +using a child node to the I2C device node. If a child node for a clock
> +output is not set, the eeprom configuration is not overwritten.
> +
> +Required child node properties:
> +- reg: number of clock output.
> +
> +Optional child node properties:
> +- clock-source: source clock of the output divider stage N, shall be
> +  0 = multisynth N
> +  1 = multisynth 0 for output clocks 0-3, else multisynth4
> +  2 = xtal
> +  3 = clkin (si5351c only)
> +- drive-strength: output drive strength in mA, shall be one of {2,4,6,8}.
> +- multisynth-source: source pll A(0) or B(1) of corresponding multisynth
> +  divider.
> +- pll-master: boolean, multisynth can change pll frequency.

Custom properties need a vendor prefix.

[...]

> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
> new file mode 100644
> index 0000000..38540e7
> --- /dev/null
> +++ b/drivers/clk/clk-si5351.c
> @@ -0,0 +1,1429 @@
[...]
> +
> +/*
> + * Si5351 vxco clock input (Si5351B only)
> + */
> +
> +static int si5351_vxco_prepare(struct clk_hw *hw)
> +{
> +	struct si5351_hw_data *hwdata =
> +		container_of(hw, struct si5351_hw_data, hw);
> +
> +	dev_warn(&hwdata->drvdata->client->dev, "VXCO currently unsupported\n");

Wouldn't it be better to not add the vxco clock if it is not supported?

> +
> +	return 0;
> +}
> +
> +static void si5351_vxco_unprepare(struct clk_hw *hw)
> +{
> +}
> +
> +static unsigned long si5351_vxco_recalc_rate(struct clk_hw *hw,
> +					     unsigned long parent_rate)
> +{
> +	return 0;
> +}
> +
> +static int si5351_vxco_set_rate(struct clk_hw *hw, unsigned long rate,
> +				unsigned long parent)
> +{
> +	return 0;
> +}
> +
> +static const struct clk_ops si5351_vxco_ops = {
> +	.prepare = si5351_vxco_prepare,
> +	.unprepare = si5351_vxco_unprepare,
> +	.recalc_rate = si5351_vxco_recalc_rate,
> +	.set_rate = si5351_vxco_set_rate,
> +};
[..]
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

MODULE_DEVICE_TABLE(of,  ....

> +static int si5351_i2c_probe(
> +	struct i2c_client *client, const struct i2c_device_id *id)

This should easily fit in one line.

> +{
> +	struct si5351_driver_data *drvdata;
> +	struct clk_init_data init;
> +	struct clk *clk;
> +	const char *parent_names[4];
> +	u8 num_parents, num_clocks;
> +	int ret, n;
> +
> +	drvdata = devm_kzalloc(&client->dev, sizeof(struct si5351_driver_data),

sizeof(*drvdata) is the preferred way of writing this, same for a few other
similar instances.

> +			       GFP_KERNEL);
> +	if (drvdata == NULL) {
> +		dev_err(&client->dev, "unable to allocate driver data\n");
> +		return -ENOMEM;
> +	}
> +
[...]
> +	of_clk_add_provider(client->dev.of_node, of_clk_src_onecell_get,
> +			    &drvdata->onecell);

You should check the return value of of_clk_add_provider

> +
> +	dev_info(&client->dev, "registered si5351 i2c client\n");
> +

That's just noise, imagine every driver would print such a line, your bootlog
would be scrolling for hours ;) I'd either remove it or make it dev_dbg

> +	return 0;
> +}
> +
> +static int si5351_i2c_remove(struct i2c_client *client)
> +{
> +	i2c_set_clientdata(client, NULL);

This is not required anymore, the core takes care of it these days. I think you
can drop the whole remove callback.

> +	return 0;
> +}
> +
> +static const struct i2c_device_id si5351_i2c_ids[] = {
> +	{ "silabs,si5351", SI5351_BUS_BASE_ADDR | 0 },
> +	{ "silabs,si5351", SI5351_BUS_BASE_ADDR | 1 },
> +	{ }
> +};

This is not how it is supposed to be used. The second field is not the i2c
address of the device, but device specific data, which you can use inside your
probe function. Since your driver only supports dt based probe you can just set
it to 0.

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

module_i2c_driver(si5351_driver) can be used to replace the two function above.

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

