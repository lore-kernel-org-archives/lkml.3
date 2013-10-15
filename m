Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584Ab3JOSq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:46:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56748 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab3JOSq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:46:26 -0400
Message-ID: <525D8D7D.10301@wwwdotorg.org>
Date: Tue, 15 Oct 2013 12:46:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 02/19] clk: tegra: simplify periph clock data
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-3-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381848794-11761-3-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> This patch determines the register bank for clock enable/disable and reset
> based on the clock ID instead of hardcoding it in the tables describing the
> clocks. This results in less data to be maintained in the tables, making the
> code easier to understand. The full benefit of the change will be realized once
> also other clocktypes will be table based.

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

>  #define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
> -			    _clk_num, _regs, _gate_flags, _clk_id)	\
> +			    _clk_num, _gate_flags, _clk_id)	\
>  	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
> -			30, MASK(2), 0, 0, 8, 1, 0, _regs, _clk_num,	\
> -			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
> -			_parents##_idx, 0)
> +			30, MASK(2), 0, 0, 8, 1, 0, \
> +			_clk_num, periph_clk_enb_refcnt, _gate_flags,\
> +			 _clk_id, _parents##_idx, 0)

Nit (since there are bugs since I know V4 is needed): If you kept
_clk_num on the same line in that macro, the diff would be much more
obvious. I think I said this last time.

>  	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
>  		data = &tegra_periph_clk_list[i];
> -		clk = tegra_clk_register_periph(data->name, data->parent_names,
> -				data->num_parents, &data->periph,
> -				clk_base, data->offset, data->flags);
> +
> +		clk = tegra_clk_register_periph(data->name,
> +			data->parent_names, data->num_parents, &data->periph,
> +			clk_base, data->offset, data->flags);
>  		clks[data->clk_id] = clk;
>  	}
>  
>  	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
>  		data = &tegra_periph_nodiv_clk_list[i];
> +
>  		clk = tegra_clk_register_periph_nodiv(data->name,

Nit: Seems like an unrelated change, and inconsistent with the other
loop above.

> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c

> +struct tegra_clk_periph_regs * __init get_reg_bank(int clkid)
> +{
> +	int reg_bank = clkid / 32;
> +
> +	if (reg_bank < periph_banks)
> +		return &periph_regs[reg_bank];
> +	else {
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +}
> +
> +int __init tegra_clk_periph_banks(int num)
> +{
> +	if (num > ARRAY_SIZE(periph_regs))
> +		return -EINVAL;
> +
> +	periph_banks = num;
> +
> +	return 0;
> +}

Shouldn't the condition in tegra_clk_periph_banks() check against
periph_banks rather than ARRAY_SIZE(periph_regs)? I assume the calls to
tegra_clk_periph_banks() from tegra*_clock_init() are intended to ensure
that periph_regs is set up correctly in this file? I wonder if
s/tegra_clk_periph_banks/tegra_clk_validate_periph_bank_count/ isn't
called for?
