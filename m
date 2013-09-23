Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3IWR3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:29:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33167 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3IWR3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:29:37 -0400
Message-ID: <52407A7D.6080002@wwwdotorg.org>
Date: Mon, 23 Sep 2013 11:29:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 01/12] clk: tegra: simplify periph clock data
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1379515331-19427-2-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:40 AM, Peter De Schrijver wrote:
> This patch determines the register bank for clock enable/disable and reset
> based on the clock ID instead of hardcoding it in the tables describing the
> clocks. This results in less data to be maintained in the tables, making the
> code easier to understand. The full benefit of the change will be realized once
> also other clocktypes will be table based.

>  drivers/clk/tegra/clk-tegra114.c |  483 ++++++++++++++++----------------------
>  drivers/clk/tegra/clk.c          |  105 ++++++++
>  drivers/clk/tegra/clk.h          |    3 +

Can't this change be applied to the Tegra20/30 diffstat too, for even
more negative diffstat? Similar comments probably apply for other
patches in the series.

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

>  #define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
> -			    _clk_num, _regs, _gate_flags, _clk_id)	\
> +			    _clk_num, _gate_flags, _clk_id)	\
>  	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
> -			30, MASK(2), 0, 0, 8, 1, 0, _regs, _clk_num,	\
> -			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
> -			_parents##_idx, 0)
> +			30, MASK(2), 0, 0, 8, 1, 0, 0,\
> +			_clk_num, periph_clk_enb_refcnt, _gate_flags,\
> +			 _clk_id, _parents##_idx, 0)

Nit: A simple s/_regs/0/ without re-flowing the parameters would have
made that diff smaller, and more similar to all the others...

> @@ -1606,9 +1538,9 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
>  	clk = tegra_clk_register_divider("audio0_div", "audio0_doubler",
>  				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 24, 1,
>  				0, &clk_doubler_lock);
> -	clk = tegra_clk_register_periph_gate("audio0_2x", "audio0_div",
> +	clk = tegra114_periph_gate_helper("audio0_2x", "audio0_div",
>  				  TEGRA_PERIPH_NO_RESET, clk_base,
> -				  CLK_SET_RATE_PARENT, 113, &periph_v_regs,
> +				  CLK_SET_RATE_PARENT, 113,
>  				  periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "audio0_2x", NULL);
>  	clks[TEGRA114_CLK_AUDIO0_2X] = clk;

It sure seems like much of this repetitive code could be driven from a
data table rather than cut/paste code. Perhaps a later patch in this
series cleans this up?

> @@ -2030,21 +1949,10 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
...
> -	/* dsib */
> -	clk = clk_register_mux(NULL, "dsib_mux", mux_plld_out0_plld2_out0,
> -			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
> -			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
> -	clks[TEGRA114_CLK_DSIB_MUX] = clk;
> -	clk = tegra_clk_register_periph_gate("dsib", "dsib_mux", 0, clk_base,
> -				    0, 82, &periph_u_regs,
> -				    periph_clk_enb_refcnt);
> -	clks[TEGRA114_CLK_DSIB] = clk;
> -

Why delete dsib? I don't think it got added elsewhere in this patch.

> @@ -2077,21 +1982,36 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)

>  	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
> +		struct tegra_clk_periph_regs *bank;
> +
>  		data = &tegra_periph_clk_list[i];
> -		clk = tegra_clk_register_periph(data->name, data->parent_names,
> -				data->num_parents, &data->periph,
> -				clk_base, data->offset, data->flags);
> +		bank = get_reg_bank(data->periph.gate.clk_num);
> +
> +		if (!bank)
> +			continue;

Nit: I dislike blank lines between the code that retrieves a value, and
the immediately following error-check of the value. This applies to the
second change to this function too.

> @@ -2337,6 +2257,9 @@ static void __init tegra114_clock_init(struct device_node *np)
>  	if (tegra114_osc_clk_init(clk_base) < 0)
>  		return;
>  
> +	if (tegra_clk_periph_banks(5) < 0)
> +		return;

Is that just debugging code? If you intend to keep this as a permanent
run-time check, wouldn't it be better to validate the result of
get_reg_bank(max_tegra114_periph_clock_id)? But, I'm not sure the check
is necessary at all, since the result of get_reg_bank() is checked when
registering each individual clock, so there's already plenty of coverage.
