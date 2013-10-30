Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3J3Plq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:41:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45891 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3J3Plo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:41:44 -0400
Message-ID: <527128B5.2020101@wwwdotorg.org>
Date: Wed, 30 Oct 2013 09:41:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: use pll_ref as the pll_e parent
References: <1383093707-10312-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1383093707-10312-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 06:41 PM, Peter De Schrijver wrote:
> Use pll_ref instead of pll_re_vco as the pll_e parent on Tegra114 and
> Tegra124. Also add a pll_ref table entry for pll_e for Tegra114.

Why? What benefit does this give, or what bug does this fix?

> diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c

>  	val_aux = pll_readl(pll_params->aux_reg, pll);
>  
>  	if (val & PLL_BASE_ENABLE) {
> -		if (!(val_aux & PLLE_AUX_PLLRE_SEL))
> +		if ((val_aux & PLLE_AUX_PLLRE_SEL) || (val_aux & val_aux))

Isn't "|| (val_aux & val_aux)" always true, at least if the value is
non-zero? Either this should be simply "|| val_aux", or one of those two
"val_aux" is the wrong thing.

>  			WARN(1, "pll_e enabled with unsupported parent %s\n",
> -			  (val & PLLE_AUX_PLLP_SEL) ? "pllp_out0" : "pll_ref");
> +			  (val_aux & PLLE_AUX_PLLP_SEL) ? "pllp_out0" :
> +					"pll_re_vco");
>  	} else {
> -		val_aux |= PLLE_AUX_PLLRE_SEL;
> +		val_aux &= ~(PLLE_AUX_PLLRE_SEL | PLLE_AUX_PLLP_SEL);
>  		pll_writel(val, pll_params->aux_reg, pll);
>  	}

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

> @@ -560,6 +560,7 @@ static struct tegra_clk_pll_freq_table pll_e_freq_table[] = {
>  	/* PLLE special case: use cpcon field to store cml divider value */
>  	{336000000, 100000000, 100, 21, 16, 11},
>  	{312000000, 100000000, 200, 26, 24, 13},
> +	{12000000, 100000000, 200,  1,  24, 13},

Presumably this is because pll_ref is the crystal, which runs at 12MHz.
What if it doesn't; Tegra supports a bunch of other crystal rates. Don't
we need entries for all the other potential crystal rates too?
