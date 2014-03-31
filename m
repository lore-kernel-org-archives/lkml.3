Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaCaQvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:51:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45453 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaCaQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:51:48 -0400
Message-ID: <53399D1A.4070301@wwwdotorg.org>
Date: Mon, 31 Mar 2014 10:51:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Fix PLLE programming
References: <1396277142-18292-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1396277142-18292-1-git-send-email-thierry.reding@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 08:45 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> PLLE has M, N and P divider shift and width parameters that differ from
> the defaults. Furthermore, when clearing the M, N and P divider fields
> the corresponding masks were never shifted, thereby clearing only the
> lowest bits of the register. This lead to a situation where the PLLE
> programming would only work if the register hadn't been touched before.

> diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c

> @@ -730,8 +730,10 @@ static int clk_plle_enable(struct clk_hw *hw)
>  	if (pll->params->flags & TEGRA_PLLE_CONFIGURE) {
>  		/* configure dividers */
>  		val = pll_readl_base(pll);
> -		val &= ~(divm_mask(pll) | divn_mask(pll) | divp_mask(pll));
> -		val &= ~(PLLE_BASE_DIVCML_WIDTH << PLLE_BASE_DIVCML_SHIFT);
> +		val &= ~(divp_mask(pll) << PLLE_BASE_DIVP_SHIFT |
> +			 divn_mask(pll) << PLLE_BASE_DIVN_SHIFT |
> +			 divm_mask(pll) << PLLE_BASE_DIVM_SHIFT);

Shouldn't those shift values also be a macro/inline like
divm_shift(pll), since ...

> +static struct div_nmp pll_e_nmp = {
> +	.divn_shift = PLLE_BASE_DIVN_SHIFT,
> +	.divn_width = PLLE_BASE_DIVN_WIDTH,
> +	.divm_shift = PLLE_BASE_DIVM_SHIFT,
> +	.divm_width = PLLE_BASE_DIVM_WIDTH,
> +	.divp_shift = PLLE_BASE_DIVP_SHIFT,
> +	.divp_width = PLLE_BASE_DIVP_WIDTH,
> +};

... that table contains parameters for both width and shift values, not
just width values?

