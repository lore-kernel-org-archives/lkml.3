Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaHaWNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 18:13:20 -0400
Received: from doppler.thel33t.co.uk ([193.110.88.198]:41418 "EHLO
	doppler.thel33t.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaHaWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 18:13:15 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Aug 2014 18:13:14 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 31 Aug 2014 23:25:35 +0100
From: Leigh Brown <leigh@solinno.co.uk>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Simon Boulay <simon.boulay@vitec.com>,
        Arnaud Ebalard <arno@natisbad.org>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Raphael Rigo <ml-arm@syscall.eu>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 1/4] clk: mvebu: Fix clk frequency value if SSCG is
 enabled
In-Reply-To: <1409312620-20631-2-git-send-email-gregory.clement@free-electrons.com>
References: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com>
 <1409312620-20631-2-git-send-email-gregory.clement@free-electrons.com>
Message-ID: <d9e3be49b00eb7dd8827f05a955b4497@doppler.thel33t.co.uk>
User-Agent: Roundcube Webmail/1.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On 2014-08-29 12:43, Gregory CLEMENT wrote:
> When the SSCG (Spread Spectrum Clock Generator) is enabled, it shifts
> the frequency of the clock. The percentage is no more than 1% but when
> the clock is used for a timer it leads to a clock drift.

Thank you so much for this series.  I'm running 3.16 and without these 
patches ntpd is all over the place, so it is a huge improvement  I do 
have a comment further down though..

> This patch allows to correct the affected clock when the SSCG is
> enabled. The check is done in an new optional function related to each
> SoC: is_sscg_enabled(). If this function is not present then no
> correction is done on the clock frequency.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/clk/mvebu/common.c | 74 
> ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/mvebu/common.h |  1 +
>  2 files changed, 75 insertions(+)
> 
> diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
> index 25ceccf939ad..834d36cf79b0 100644
> --- a/drivers/clk/mvebu/common.c
> +++ b/drivers/clk/mvebu/common.c
> @@ -26,8 +26,78 @@
>   * Core Clocks
>   */
> 
> +#define SSCG_CONF_MODE(reg)	(((reg) >> 16) & 0x3)
> +#define SSCG_SPREAD_DOWN	0x0
> +#define SSCG_SPREAD_UP		0x1
> +#define SSCG_SPREAD_CENTRAL	0x2
> +#define SSCG_CONF_LOW(reg)	(((reg) >> 8) & 0xFF)
> +#define SSCG_CONF_HIGH(reg)	((reg) & 0xFF)
> +
>  static struct clk_onecell_data clk_data;
> 
> +static u32 fix_sscg_deviation(struct device_node *np, u32 system_clk)
> +{
> +	struct device_node *sscg_np = NULL;
> +	void __iomem *sscg_map;
> +	u32 sscg_reg;
> +	s32 low_bound, high_bound;
> +	u64 freq_swing_half;
> +
> +	sscg_np = of_find_node_by_name(np, "sscg");
> +	if (sscg_np == NULL) {
> +		pr_err("cannot get SSCG register node\n");
> +		return system_clk;
> +	}
> +
> +	sscg_map = of_iomap(sscg_np, 0);
> +	if (sscg_map == NULL) {
> +		pr_err("cannot map SSCG register\n");
> +		goto out;
> +	}
> +
> +	sscg_reg = readl(sscg_map);
> +	high_bound = SSCG_CONF_HIGH(sscg_reg);
> +	low_bound = SSCG_CONF_LOW(sscg_reg);
> +
> +	if ((high_bound - low_bound) <= 0)
> +		goto out;
> +	/*
> +	 * From the datasheet we got the following formula
> +	 * Spread percentage = 1/96 * (H - L) / H

In the datasheet it says the percentage is 0.96 * (H - L) / H.  1/96 is 
close but not the same as 0.0096.

> +	 * H = SSCG_High_Boundary
> +	 * L = SSCG_Low_Boundary
> +	 *
> +	 * As the deviation is half of spread then it lead to the
> +	 * following formula in the code.
> +	 *
> +	 * To avoid an overflow and not lose any significant digit in
> +	 * the same time we have to use a 64 bit integer.
> +	 */
> +
> +	freq_swing_half = (((u64)high_bound - (u64)low_bound)
> +			* (u64)system_clk);
> +	do_div(freq_swing_half, (2 * 96 * high_bound));

So this would be become :-

	/* NB: 0.96% = 0.0048 or 3/625 */
	freq_swing_half = (((u64)high_bound - (u64)low_bound)
			* (u64)system_clk * 3);
	do_div(freq_swing_half, (625 * high_bound));

> +
> +	switch (SSCG_CONF_MODE(sscg_reg)) {
> +	case SSCG_SPREAD_DOWN:
> +		system_clk -= freq_swing_half;
> +		break;
> +	case SSCG_SPREAD_UP:
> +		system_clk += freq_swing_half;
> +		break;
> +	case SSCG_SPREAD_CENTRAL:
> +	default:
> +		break;
> +	}
> +
> +	iounmap(sscg_map);
> +
> +out:
> +	of_node_put(sscg_np);
> +
> +	return system_clk;
> +}
> +
>  void __init mvebu_coreclk_setup(struct device_node *np,
>  				const struct coreclk_soc_desc *desc)
>  {
> @@ -62,6 +132,10 @@ void __init mvebu_coreclk_setup(struct device_node 
> *np,
>  	of_property_read_string_index(np, "clock-output-names", 1,
>  				      &cpuclk_name);
>  	rate = desc->get_cpu_freq(base);
> +
> +	if (desc->is_sscg_enabled && desc->is_sscg_enabled(base))
> +		rate = fix_sscg_deviation(np, rate);
> +
>  	clk_data.clks[1] = clk_register_fixed_rate(NULL, cpuclk_name, NULL,
>  						   CLK_IS_ROOT, rate);
>  	WARN_ON(IS_ERR(clk_data.clks[1]));
> diff --git a/drivers/clk/mvebu/common.h b/drivers/clk/mvebu/common.h
> index f968b4d9df92..495f94ff4c90 100644
> --- a/drivers/clk/mvebu/common.h
> +++ b/drivers/clk/mvebu/common.h
> @@ -28,6 +28,7 @@ struct coreclk_soc_desc {
>  	u32 (*get_tclk_freq)(void __iomem *sar);
>  	u32 (*get_cpu_freq)(void __iomem *sar);
>  	void (*get_clk_ratio)(void __iomem *sar, int id, int *mult, int 
> *div);
> +	bool (*is_sscg_enabled)(void __iomem *sar);
>  	const struct coreclk_ratio *ratios;
>  	int num_ratios;
>  };

I don't have a good way to measure the difference but my small 
modification seems correct as per the datasheet.

Regards,

Leigh.
