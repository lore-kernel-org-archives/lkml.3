Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaEVQkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:40:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50947 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEVQkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:40:00 -0400
Message-ID: <537E285C.6060608@wwwdotorg.org>
Date: Thu, 22 May 2014 10:39:56 -0600
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

> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c

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

I think the call to tegra_target_intermediate() is wrong here; shouldn't
the cpufreq core guarantee that tegra_target_intermediate() has always
been called before tegra_target(), so there's no need to repeat that
call here?

Also, tegra_target() doesn't seem to follow the rule documented by patch
2/3 that states ->target() should restore the orignal frequency on
error. I'm not even sure if that's possible in general.
