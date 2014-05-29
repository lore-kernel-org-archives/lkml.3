Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbaE2RkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:40:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41669 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2RkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:40:23 -0400
Message-ID: <53877103.8070604@wwwdotorg.org>
Date: Thu, 29 May 2014 11:40:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, dianders@chromium.org, linux@arm.linux.org.uk,
        nicolas.pitre@linaro.org, thomas.abraham@linaro.org,
        pdeschrijver@nvidia.com
Subject: Re: [PATCH V4 3/3] cpufreq: Tegra: implement intermediate frequency
 callbacks
References: <cover.1400662383.git.viresh.kumar@linaro.org> <dc2702973028425e3ded689a6da227658fb914c4.1400662383.git.viresh.kumar@linaro.org>
In-Reply-To: <dc2702973028425e3ded689a6da227658fb914c4.1400662383.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 02:59 AM, Viresh Kumar wrote:
> Tegra had always been switching to intermediate frequency (pll_p_clk) since
> ever. CPUFreq core has better support for handling notifications for these
> frequencies and so we can adapt Tegra's driver to it.
> 
> Also do a WARN() if clk_set_parent() fails while moving back to pll_x as we
> should have atleast restored to earlier frequency on error.

This patch breaks Tegra. The reason is below.

> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c

> -static int tegra_cpu_clk_set_rate(unsigned long rate)
> +static unsigned int
> +tegra_get_intermediate(struct cpufreq_policy *policy, unsigned int index)

(BTW, can we please not put the return type on a separate line; it's
inconsistent with the rest of the code in this file)

> +{
> +	unsigned int ifreq = clk_get_rate(pll_p_clk) / 1000;
> +
> +	/*
> +	 * Don't switch to intermediate freq if:
> +	 * - we are already at it, i.e. policy->cur == ifreq
> +	 * - index corresponds to ifreq
> +	 */
> +	if ((freq_table[index].frequency == ifreq) || (policy->cur == ifreq))
> +		return 0;

If policy->cur == ifreq here, then tegra_target_intermediate() isn't
called by the cpufreq core, so ...

> +static int
> +tegra_target_intermediate(struct cpufreq_policy *policy, unsigned int index)
>  {
>  	int ret;
>  
> 	/*
> 	 * Take an extra reference to the main pll so it doesn't turn
> 	 * off when we move the cpu off of it
> 	 */
> 	clk_prepare_enable(pll_x_clk);

... that reference isn't added...

> @@ -98,10 +96,23 @@ static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
>  	else
>  		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
>  
> -	ret = tegra_cpu_clk_set_rate(rate * 1000);
> +	/* target freq == pll_p */
> +	if (rate * 1000 == clk_get_rate(pll_p_clk)) {
> +		ret = tegra_target_intermediate(policy, index);
> +		goto disable_pll_x;
> +	}

... and this code doesn't call it either, since we could be switching
from the pll_p rate to something faster ...

> +
> +	ret = clk_set_rate(pll_x_clk, rate * 1000);
> +	/* Restore to earlier frequency on error, i.e. pll_x */
>  	if (ret)
> -		pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
> -			rate);
> +		pr_err("Failed to change pll_x to %lu\n", rate);
> +
> +	ret = clk_set_parent(cpu_clk, pll_x_clk);
> +	/* This shouldn't fail while changing or restoring */
> +	WARN_ON(ret);
> +
> +disable_pll_x:
> +	clk_disable_unprepare(pll_x_clk);

... so this turns off pll_x even though we're running from it.

It would be simpler if Tegra *always* used an intermediate frequency,
and hence the core *always* called tegra_target_intermediate().
Admittedly, this would result in tegra_target() sometimes (when
switching CPU clock rate to the pll_p rate) doing nothing other than
removing the extra reference on pll_x, but I think that the code would
be simpler to follow and more robust.
