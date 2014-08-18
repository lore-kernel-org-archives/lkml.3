Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaHRGHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:07:00 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1371 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaHRGG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:06:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 17 Aug 2014 22:53:20 -0700
Message-ID: <53F19848.7020303@nvidia.com>
Date: Mon, 18 Aug 2014 14:08:08 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH v2 05/16] clk: tegra: Add closed loop support for the
 DFLL
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com> <1405957142-19416-6-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1405957142-19416-6-git-send-email-ttynkkynen@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/21/2014 11:38 PM, Tuomas Tynkkynen wrote:
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
> ---
> v2 changes:
>      - query the various properties required for I2C mode from the
>        regulator framework
>
>   drivers/clk/tegra/clk-dfll.c | 656 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 653 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clk/tegra/clk-dfll.c b/drivers/clk/tegra/clk-dfll.c
> index d83e859..0d4b2dd 100644
> --- a/drivers/clk/tegra/clk-dfll.c
> +++ b/drivers/clk/tegra/clk-dfll.c
> @@ -205,12 +205,16 @@
...
> +
> +/**
> + * dfll_calculate_rate_request - calculate DFLL parameters for a given rate
> + * @td: DFLL instance
> + * @req: DFLL-rate-request structure
> + * @rate: the desired DFLL rate
> + *
> + * Populate the DFLL-rate-request record @req fields with the scale_bits
> + * and mult_bits fields, based on the target input rate. Returns 0 upon
> + * success, or -EINVAL if the requested rate in req->rate is too high
> + * or low for the DFLL to generate.
> + */
> +static int dfll_calculate_rate_request(struct tegra_dfll *td,
> +				       struct dfll_rate_req *req,
> +				       unsigned long rate)
> +{
> +	u32 val;
> +
> +	/*
> +	 * If requested rate is below the minimum DVCO rate, active the scaler.
> +	 * In the future the DVCO minimum voltage should be selected based on
> +	 * chip temperature and the actual minimum rate should be calibrated
> +	 * at runtime.
> +	 */
> +	req->scale_bits = DFLL_FREQ_REQ_SCALE_MAX - 1;
> +	if (rate < td->dvco_rate_min) {
> +		int scale;
> +
> +		scale = DIV_ROUND_CLOSEST(rate / 1000 * DFLL_FREQ_REQ_SCALE_MAX,
> +					  td->dvco_rate_min / 1000);
> +		if (!scale) {
> +			dev_err(td->dev, "%s: Rate %lu is too low\n",
> +				__func__, rate);
> +			return -EINVAL;
> +		}
> +		req->scale_bits = scale - 1;
> +		rate = td->dvco_rate_min;
> +	}
> +
> +	/* Convert requested rate into frequency request and scale settings */
> +	val = DVCO_RATE_TO_MULT(rate, td->ref_rate);
> +	if (val > FREQ_MAX) {
> +		dev_err(td->dev, "%s: Rate %lu is above dfll range\n",
> +			__func__, rate);
> +		return -EINVAL;
> +	}
> +	req->mult_bits = val;
> +	req->dvco_target_rate = MULT_TO_DVCO_RATE(req->mult_bits, td->ref_rate);
> +	req->rate = dfll_scale_dvco_rate(req->dvco_target_rate,
> +					 req->scale_bits);
Should be dfll_scale_dvco_rate(req->scale_bits, req->dvco_target_rate);

Thanks,
Vince

> +	req->lut_index = find_lut_index_for_rate(td, req->dvco_target_rate);
> +	if (req->lut_index < 0)
> +		return req->lut_index;
> +
> +	return 0;
> +}
> +

