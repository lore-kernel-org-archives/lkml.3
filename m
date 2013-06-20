Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3FTVXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:23:01 -0400
Received: from gloria.sntech.de ([95.129.55.99]:35216 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204Ab3FTVW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:22:59 -0400
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v2 4/5] clk: dt: binding for basic divider clock
Date: Thu, 20 Jun 2013 23:22:54 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Matt Sealey <neko@bakuhatsu.net>,
        Stephen Boyd <sboyd@codeaurora.org>
References: <1371437905-15567-1-git-send-email-mturquette@linaro.org> <1371437905-15567-5-git-send-email-mturquette@linaro.org>
In-Reply-To: <1371437905-15567-5-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306202322.54645.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Am Montag, 17. Juni 2013, 04:58:24 schrieb Mike Turquette:
> Devicetree binding for the basic clock divider, plus the setup function
> to register the clock.  Based on the existing fixed-clock binding.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
> Changes since v1:
> * mask is u32, shift is u8
> * use bit mask instead of bitfield width
> * DT property names use dashes instead of underscores
> * DT property names are more verbose
> * added minimum/maximum divider values to binding
> * shift property is optional in binding and can be auto-generated from a
>   full 32-bit mask
> 
>  .../devicetree/bindings/clock/divider-clock.txt    | 87
> +++++++++++++++++++++ drivers/clk/clk-divider.c                          |
> 90 +++++++++++++++++++++- include/linux/clk-provider.h                    
>   |  2 +
>  3 files changed, 178 insertions(+), 1 deletion(-)
>  create mode 100644
> Documentation/devicetree/bindings/clock/divider-clock.txt
> 
> diff --git a/Documentation/devicetree/bindings/clock/divider-clock.txt
> b/Documentation/devicetree/bindings/clock/divider-clock.txt new file mode
> 100644
> index 0000000..96bea07
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/divider-clock.txt
> @@ -0,0 +1,87 @@
> +Binding for simple divider clock.
> +
> +This binding uses the common clock binding[1].  It assumes a
> +register-mapped adjustable clock rate divider that does not gate and has
> +only one input clock or parent.  By default the value programmed into
> +the register is one less than the actual divisor value.  E.g:
> +
> +register value		actual divisor value
> +0			1
> +1			2
> +2			3
> +
> +This assumption may be modified by the following optional properties:
> +
> +index-starts-at-one - valid divisor values start at 1, not the default
> +of 0.  E.g:
> +register value		actual divisor value
> +1			1
> +2			2
> +3			3
> +
> +index-power-of-two - valid divisor values are powers of two.  E.g:
> +register value		actual divisor value
> +0			1
> +1			2
> +2			4
> +
> +index-allow-zero - same as index_one, but zero is divide-by-1.  E.g:
> +register value		actual divisor value
> +0			1
> +1			1
> +2			2
> +
> +Additionally a table of valid dividers may be supplied like so:
> +
> +	table = <4 0>, <8, 1>;
> +
> +where the first value in the pair is the divider and the second value is
> +the programmed register bitfield.

this doesn't match the current code that is taking the first as bit-value
and the second as divider.


> +
> +The binding must also provide the register to control the divider and
> +the mask for the corresponding control bits.  Optionally the number of
> +bits to shift that mask, if necessary.  If the shift value is missing it
> +is the same as supplying a zero shift.
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +Required properties:
> +- compatible : shall be "divider-clock".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : link to phandle of parent clock
> +- reg : base address for register controlling adjustable divider
> +- bit-mask : arbitrary bitmask for programming the adjustable divider
> +
> +Optional properties:
> +- clock-output-names : from common clock binding.
> +- table : array of integer pairs defining divisors & bitfield values
> +- bit-shift : number of bits to shift the bit-mask, defaults to
> +  (ffs(mask) - 1) if not present
> +- minimum-divider : min divisor for dividing the input clock rate, only
> +  needed if the first divisor is offset from the default value
> +- maximum-divider : max divisor for dividing the input clock rate, only
> +  needed if the max divisor is less than (mask + 1).
> +- index-starts-at-one : valid divisor programming starts at 1, not zero
> +- index-power-of-two : valid divisor programming must be a power of two
> +- index-allow-zero : implies index-one, and programming zero results in
> +  divide-by-one
> +
> +Examples:
> +	clock_foo: clock_foo@4a008100 {
> +		compatible = "divider-clock";
> +		#clock-cells = <0>;
> +		clocks = <&clock_baz>;
> +		reg = <0x4a008100 0x4>
> +		mask = <0x3>
> +		maximum-divider = <3>
> +	};
> +
> +	clock_bar: clock_bar@4a008108 {
> +		#clock-cells = <0>;
> +		compatible = "divider-clock";
> +		clocks = <&clock_foo>;
> +		reg = <0x4a008108 0x4>;
> +		mask = <0x1>;
> +		shift = <0>;
> +		table = < 4 0 >, < 8 1 >;
> +	};

the shift and mask properties should probably also get their "bit-" additions.

Also, if you really want to use the u8 as type, it seems like the property
must also get a "/bits/ 8" prefix, making it:

			bit-shift = /bits/ 8 <6>;

so the example should probably reflect this. Without this the
of_property_read_u8 returns wrong values.


> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index ac9cb7f..8c42c7f 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -1,7 +1,7 @@
>  /*
>   * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
>   * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
> - * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd
> <mturquette@linaro.org> + * Copyright (C) 2011-2013 Mike Turquette, Linaro
> Ltd <mturquette@linaro.org> *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -17,6 +17,8 @@
>  #include <linux/err.h>
>  #include <linux/string.h>
>  #include <linux/log2.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> 
>  /*
>   * DOC: basic adjustable divider clock that cannot gate
> @@ -340,3 +342,89 @@ struct clk *clk_register_divider_table(struct device
> *dev, const char *name, return _register_divider(dev, name, parent_name,
> flags, reg, shift, ((1 << width) - 1), clk_divider_flags, table, lock);
>  }
> +
> +#ifdef CONFIG_OF
> +struct clk_div_table *of_clk_get_div_table(struct device_node *node)
> +{
> +	int i;
> +	int table_size = 0;
> +	struct clk_div_table *table;
> +	u32 pair[2];
> +
> +	table_size = of_count_phandle_with_args(node, "table", "#clock-cells");

I don't really understand what this should do ... especially what are the "#clock-cells" doing there?

Of course the function also doesn't work for my
			table = <2 0>, <4 1>, <8 2>, <16 3>;
table.


> +
> +	if (table_size < 1)
> +		return NULL;
> +
> +	table = kzalloc(sizeof(struct clk_div_table) * table_size, GFP_KERNEL);
> +	if (!table) {
> +		pr_err("%s: unable to allocate memory for %s table\n", __func__,
> node->name); +		return NULL;
> +	}
> +
> +	for (i = 0; i < table_size; i++) {
> +		if (!of_property_read_u32_array(node, "table", pair, ARRAY_SIZE(pair)))

wouldn't this always read the same values? It does not seem to iterate thru all the table entries.



> { +			table[i].val = pair[0];
> +			table[i].div = pair[1];
> +		}
> +	}
> +
> +	return table;
> +}
> +

how about:

struct clk_div_table *of_clk_get_div_table(struct device_node *node)
{
	int i;
	int table_size = 0;
	struct clk_div_table *table;
	const __be32 *list;

	list = of_get_property(node, "table", &table_size);
	table_size /= sizeof(*list);

	if (table_size < 2 || table_size % 2)
		return NULL;

	table_size /= 2;

	table = kzalloc(sizeof(struct clk_div_table) * table_size, GFP_KERNEL);
	if (!table) {
		pr_err("%s: unable to allocate memory for %s table\n", __func__, node->name);
		return NULL;
	}

	for (i = 0; i < table_size; i++) {
		table[i].div = be32_to_cpu(*list++);
		table[i].val = be32_to_cpu(*list++);
	}

	return table;
}


Heiko
