Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaHRGEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:04:47 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1569 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaHRGEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:04:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 17 Aug 2014 22:55:13 -0700
Message-ID: <53F197C3.5010002@nvidia.com>
Date: Mon, 18 Aug 2014 14:05:55 +0800
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
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 04/16] clk: tegra: Add library for the DFLL clock source
 (open-loop mode)
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com> <1405957142-19416-5-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1405957142-19416-5-git-send-email-ttynkkynen@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/21/2014 11:38 PM, Tuomas Tynkkynen wrote:
> Add shared code to support the Tegra DFLL clocksource in open-loop
> mode. This root clocksource is present on the Tegra124 SoCs. The
> DFLL is the intended primary clock source for the fast CPU cluster.
>
> This code is very closely based on a patch by Paul Walmsley from
> December (http://comments.gmane.org/gmane.linux.ports.tegra/15273),
> which in turn comes from the internal driver by originally created
> by Aleksandr Frid <afrid@nvidia.com>.
>
> Subsequent patches will add support for closed loop mode and drivers
> for the Tegra124 fast CPU cluster DFLL devices, which rely on this
> code.
>
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
> v2 changes:
>      - minor, moved the devm_regulator_get here
>
>   drivers/clk/tegra/Makefile   |    1 +
>   drivers/clk/tegra/clk-dfll.c | 1085 ++++++++++++++++++++++++++++++++++++++++++
>   drivers/clk/tegra/clk-dfll.h |   55 +++
>   3 files changed, 1141 insertions(+)
>   create mode 100644 drivers/clk/tegra/clk-dfll.c
>   create mode 100644 drivers/clk/tegra/clk-dfll.h
...
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-dfll.c
...
> +
> +/*
> + * Output clock scaler helpers
> + */
> +
> +/**
> + * dfll_scale_dvco_rate - calculate scaled rate from the DVCO rate
> + * @scale_bits: clock scaler value (bits in the DFLL_FREQ_REQ_SCALE field)
> + * @dvco_rate: the DVCO rate
> + *
> + * Apply the same scaling formula that the DFLL hardware uses to scale
> + * the DVCO rate.
> + */
> +static unsigned long dfll_scale_dvco_rate(int scale_bits,
> +					  unsigned long dvco_rate)
> +{
> +	return (u64)dvco_rate * (scale_bits + 1) / DFLL_FREQ_REQ_SCALE_MAX;
> +}
...
> +static u64 dfll_read_monitor_rate(struct tegra_dfll *td)
> +{
> +	u32 v, s;
> +	u64 pre_scaler_rate, post_scaler_rate;
> +
> +	if (!dfll_is_running(td))
> +		return 0;
> +
> +	v = dfll_readl(td, DFLL_MONITOR_DATA);
> +	v = (v & DFLL_MONITOR_DATA_VAL_MASK) >> DFLL_MONITOR_DATA_VAL_SHIFT;
> +	pre_scaler_rate = dfll_calc_monitored_rate(v, td->ref_rate);
> +
> +	s = dfll_readl(td, DFLL_FREQ_REQ);
> +	s = (s & DFLL_FREQ_REQ_SCALE_MASK) >> DFLL_FREQ_REQ_SCALE_SHIFT;
> +	post_scaler_rate = dfll_scale_dvco_rate(pre_scaler_rate, s);
Should be dfll_scale_dvco_rate(s, pre_scaler_rate);

Thanks,
Vince


