Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab3GaBBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 21:01:40 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:56417 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3GaBBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 21:01:39 -0400
Message-ID: <51F861E5.7010909@elopez.com.ar>
Date: Tue, 30 Jul 2013 22:01:25 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] clk: sunxi: Add A31 clocks support
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com> <1375195462-19566-4-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1375195462-19566-4-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 30/07/13 11:44, Maxime Ripard escribió:
> The A31 has a mostly different clock set compared to the other older
> SoCs currently supported in the Allwinner clock driver.
> 
> Add support for the basic useful clocks. The other ones will come in
> eventually.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/clk/sunxi/clk-sunxi.c | 120 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)
> 
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 6e9cbc9..8cd69e6 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -124,7 +124,67 @@ static void sun4i_get_pll1_factors(u32 *freq, u32 parent_rate,
>  	*n = div / 4;
>  }
>  
> +/**
> + * sun6i_get_pll1_factors() - calculates n, k and m factors for PLL1
> + * PLL1 rate is calculated as follows
> + * rate = parent_rate * (n + 1) * (k + 1) / (m + 1);
> + * parent_rate should always be 24MHz
> + */
> +static void sun6i_get_pll1_factors(u32 *freq, u32 parent_rate,
> +				   u8 *n, u8 *k, u8 *m, u8 *p)
> +{
> +	/*
> +	 * We can operate only on MHz, this will make our life easier
> +	 * later.
> +	 */
> +	u32 freq_mhz = *freq / 1000000;
> +	u32 parent_freq_mhz = parent_rate / 1000000;
> +
> +	/* If the frequency is a multiple of 32 MHz, k is always 3 */
> +	if (!(freq_mhz % 32))
> +		*k = 3;
> +	/* If the frequency is a multiple of 9 MHz, k is always 2 */
> +	else if (!(freq_mhz % 9))
> +		*k = 2;
> +	/* If the frequency is a multiple of 8 MHz, k is always 1 */
> +	else if (!(freq_mhz % 8))
> +		*k = 1;
> +	/* Otherwise, we don't use the k factor */
> +	else
> +		*k = 0;
>  
> +	/*
> +	 * If the frequency is a multiple of 2 but not a multiple of
> +	 * 3, m is 3. This is the first time we use 6 here, yet we
> +	 * will use it on several other places.
> +	 * We use this number because it's the lowest frequency we can
> +	 * generate (with n = 0, k = 0, m = 3), so every other frequency
> +	 * somehow relates to this frequency.
> +	 */
> +	if ((freq_mhz % 6) == 2 || (freq_mhz % 6) == 4)
> +		*m = 2;
> +	/*
> +	 * If the frequency is a multiple of 6MHz, but the factor is
> +	 * odd, m will be 3
> +	 */
> +	else if ((freq_mhz / 6) & 1)
> +		*m = 3;
> +	/* Otherwise, we end up with m = 1 */
> +	else
> +		*m = 1;
> +
> +	/* Calculate n thanks to the above factors we already got */
> +	*n = freq_mhz * (*m + 1) / ((*k + 1) * parent_freq_mhz) - 1;
> +
> +	/*
> +	 * If n end up being outbound, and that we can still decrease
> +	 * m, do it.
> +	 */
> +	if ((*n + 1) > 31 && (*m + 1) > 1) {
> +		*n = (*n + 1) / 2 - 1;
> +		*m = (*m + 1) / 2 - 1;
> +	}
> +}

Nice! My rate-to-factors functions pale in comparison :) Remember that
n/k/m/p may be NULL when the caller just wants you to round freq to an
achievable value (see clk_factors_round_rate(...) in clk-factors.c).

>  /**
>   * sun4i_get_apb1_factors() - calculates m, p factors for APB1
> @@ -189,6 +249,15 @@ static struct clk_factors_config sun4i_pll1_config = {
>  	.pwidth = 2,
>  };
>  
> +static struct clk_factors_config sun6i_pll1_config = {
> +	.nshift	= 8,
> +	.nwidth = 5,
> +	.kshift = 4,
> +	.kwidth = 2,
> +	.mshift = 0,
> +	.mwidth = 2,
> +};
> +
>  static struct clk_factors_config sun4i_apb1_config = {
>  	.mshift = 0,
>  	.mwidth = 5,
> @@ -201,6 +270,11 @@ static const __initconst struct factors_data sun4i_pll1_data = {
>  	.getter = sun4i_get_pll1_factors,
>  };
>  
> +static const __initconst struct factors_data sun6i_pll1_data = {
> +	.table = &sun6i_pll1_config,
> +	.getter = sun6i_get_pll1_factors,
> +};
> +
>  static const __initconst struct factors_data sun4i_apb1_data = {
>  	.table = &sun4i_apb1_config,
>  	.getter = sun4i_get_apb1_factors,
> @@ -243,6 +317,10 @@ static const __initconst struct mux_data sun4i_cpu_mux_data = {
>  	.shift = 16,
>  };
>  
> +static const __initconst struct mux_data sun6i_ahb1_mux_data = {
> +	.shift = 12,
> +};
> +
>  static const __initconst struct mux_data sun4i_apb1_mux_data = {
>  	.shift = 24,
>  };
> @@ -301,6 +379,12 @@ static const __initconst struct div_data sun4i_apb0_data = {
>  	.width	= 2,
>  };
>  
> +static const __initconst struct div_data sun6i_apb2_div_data = {
> +	.shift	= 0,
> +	.pow	= 0,
> +	.width	= 4,
> +};
> +
>  static void __init sunxi_divider_clk_setup(struct device_node *node,
>  					   struct div_data *data)
>  {
> @@ -347,6 +431,10 @@ static const __initconst struct gates_data sun5i_a13_ahb_gates_data = {
>  	.mask = {0x107067e7, 0x185111},
>  };
>  
> +static const __initconst struct gates_data sun6i_a31_ahb1_gates_data = {
> +	.mask = { 0xedfe7f62, 0x794f931 },
> +};
> +
>  static const __initconst struct gates_data sun4i_apb0_gates_data = {
>  	.mask = {0x4EF},
>  };
> @@ -363,6 +451,14 @@ static const __initconst struct gates_data sun5i_a13_apb1_gates_data = {
>  	.mask = {0xa0007},
>  };
>  
> +static const __initconst struct gates_data sun6i_a31_apb1_gates_data = {
> +	.mask = { 0x3031 },
> +};
> +
> +static const __initconst struct gates_data sun6i_a31_apb2_gates_data = {
> +	.mask = { 0x3f000f },
> +};
> +

We should decide on a style here and use it across the board, so far we
have definitions with and without spaces between constants and braces,
and constants both with upper and lower case A-F. Personally I don't
feel strongly about the spacing and prefer upper-case constants, but if
the style guide suggests otherwise, I can live with it (as long as we
use it consistently, that is)

>  static void __init sunxi_gates_clk_setup(struct device_node *node,
>  					 struct gates_data *data)
>  {
> @@ -420,6 +516,10 @@ static const __initconst struct of_device_id clk_factors_match[] = {
>  		.data = &sun4i_pll1_data,
>  	},
>  	{
> +		.compatible = "allwinner,sun6i-pll1-clk",
> +		.data = &sun6i_pll1_data,
> +	},
> +	{
>  		.compatible = "allwinner,sun4i-apb1-clk",
>  		.data = &sun4i_apb1_data,
>  	},
> @@ -440,6 +540,10 @@ static const __initconst struct of_device_id clk_div_match[] = {
>  		.compatible = "allwinner,sun4i-apb0-clk",
>  		.data = &sun4i_apb0_data,
>  	},
> +	{
> +		.compatible = "allwinner,sun6i-apb2-div-clk",
> +		.data = &sun6i_apb2_div_data,
> +	},
>  	{}
>  };
>  
> @@ -453,6 +557,10 @@ static const __initconst struct of_device_id clk_mux_match[] = {
>  		.compatible = "allwinner,sun4i-apb1-mux-clk",
>  		.data = &sun4i_apb1_mux_data,
>  	},
> +	{
> +		.compatible = "allwinner,sun6i-ahb1-mux-clk",
> +		.data = &sun6i_ahb1_mux_data,
> +	},
>  	{}
>  };
>  
> @@ -471,6 +579,10 @@ static const __initconst struct of_device_id clk_gates_match[] = {
>  		.data = &sun5i_a13_ahb_gates_data,
>  	},
>  	{
> +		.compatible = "allwinner,sun6i-a31-ahb1-gates-clk",
> +		.data = &sun6i_a31_ahb1_gates_data,
> +	},
> +	{
>  		.compatible = "allwinner,sun4i-apb0-gates-clk",
>  		.data = &sun4i_apb0_gates_data,
>  	},
> @@ -486,6 +598,14 @@ static const __initconst struct of_device_id clk_gates_match[] = {
>  		.compatible = "allwinner,sun5i-a13-apb1-gates-clk",
>  		.data = &sun5i_a13_apb1_gates_data,
>  	},
> +	{
> +		.compatible = "allwinner,sun6i-a31-apb1-gates-clk",
> +		.data = &sun6i_a31_apb1_gates_data,
> +	},
> +	{
> +		.compatible = "allwinner,sun6i-a31-apb2-gates-clk",
> +		.data = &sun6i_a31_apb2_gates_data,
> +	},

Please see my comments on the first patch regarding these.

Thanks!

Emilio
