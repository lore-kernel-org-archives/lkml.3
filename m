Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbaJXPNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:13:37 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:41219 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaJXPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:13:34 -0400
Message-ID: <544A6C9A.9050404@mentor.com>
Date: Fri, 24 Oct 2014 18:13:30 +0300
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
CC: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <pdeschrijver@nvidia.com>, <rjw@rjwysocki.net>,
        <viresh.kumar@linaro.org>, <mturquette@linaro.org>,
        <pwalmsley@nvidia.com>, <vinceh@nvidia.com>, <pgaikwad@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <tuomas.tynkkynen@iki.fi>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: Re: [PATCH v5 03/16] clk: tegra: Add closed loop support for the
 DFLL
References: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi> <1414161563-16812-4-git-send-email-mikko.perttunen@kapsi.fi>
In-Reply-To: <1414161563-16812-4-git-send-email-mikko.perttunen@kapsi.fi>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.2014 17:39, Mikko Perttunen wrote:
> From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> 
> With closed loop support, the clock rate of the DFLL can be adjusted.
> 
> The oscillator itself in the DFLL is a free-running oscillator whose
> rate is directly determined the supply voltage. However, the DFLL
> module contains logic to compare the DFLL output rate to a fixed
> reference clock (51 MHz) and make a decision to either lower or raise
> the DFLL supply voltage. The DFLL module can then autonomously change
> the supply voltage by communicating with an off-chip PMIC via either I2C
> or PWM signals. This driver currently supports only I2C.
> 
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> Signed-off-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> ---
>  drivers/clk/tegra/clk-dfll.c | 657 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 654 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk-dfll.c b/drivers/clk/tegra/clk-dfll.c
> index 358c5d4..e71f4fb 100644
> --- a/drivers/clk/tegra/clk-dfll.c
> +++ b/drivers/clk/tegra/clk-dfll.c

[snip]

> +/**
>   * dfll_fetch_common_params - read DFLL parameters from the device tree
>   * @td: DFLL instance
>   *
> @@ -923,6 +1563,13 @@ static int dfll_fetch_common_params(struct tegra_dfll *td)
>  	bool ok = true;
>  
>  	ok &= read_dt_param(td, "nvidia,droop-ctrl", &td->droop_ctrl);
> +	ok &= read_dt_param(td, "nvidia,sample-rate", &td->sample_rate);
> +	ok &= read_dt_param(td, "nvidia,force-mode", &td->force_mode);
> +	ok &= read_dt_param(td, "nvidia,cf", &td->cf);
> +	ok &= read_dt_param(td, "nvidia,ci", &td->ci);
> +	ok &= read_dt_param(td, "nvidia,cg", &td->cg);
> +	td->cg_scale = of_property_read_bool(td->dev->of_node,
> +					     "nvidia,cg-scale");

Oh, I see here you exploit read_dt_param() intensively.

>  	if (of_property_read_string(td->dev->of_node, "clock-output-names",
>  				    &td->output_clock_name)) {
> @@ -978,6 +1625,10 @@ int tegra_dfll_register(struct platform_device *pdev,
>  		return ret;
>  	}
>  
> +	ret = dfll_fetch_i2c_params(td);
> +	if (ret)
> +		return ret;
> +
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!mem) {
>  		dev_err(td->dev, "no control register resource\n");
> 

--
With best wishes,
Vladimir
