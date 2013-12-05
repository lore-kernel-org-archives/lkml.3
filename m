Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3LEXEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:04:41 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39894 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3LEXEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:04:36 -0500
Message-ID: <52A10681.4050906@wwwdotorg.org>
Date: Thu, 05 Dec 2013 16:04:33 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com> <1386229462-3474-3-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1386229462-3474-3-git-send-email-bilhuang@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 12:44 AM, Bill Huang wrote:
> Re-model Tegra cpufreq driver to support all Tegra series of SoCs.
> 
> * Make tegra-cpufreq.c a generic Tegra cpufreq driver.
> * Move Tegra20 specific codes into tegra20-cpufreq.c.
> * Bind Tegra cpufreq dirver with a fake device so defer probe would work
>   when we're going to get regulator in the driver to support voltage
>   scaling (DVFS).

> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c

> @@ -91,14 +40,10 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
...
> +	if (soc_config->vote_emc_on_cpu_rate)
> +		soc_config->vote_emc_on_cpu_rate(rate);
> +
> +	ret = soc_config->cpu_clk_set_rate(rate * 1000);
>  	if (ret)
>  		pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
>  			rate);

Is there any/much shared code left in this file after this patch? It
seems like all this file does now is make each cpufreq callback function
call soc_config->the_same_function_name(). If so, wouldn't it be better
to simply implement completely separate tegar20-cpufreq and
tegra30-cpufreq drivers, and register them each directly with the
cpufreq core, to avoid this file doing all the indirection?


> -int __init tegra_cpufreq_init(void)
> +static struct {
> +	char *compat;
> +	int (*init)(struct tegra_cpufreq_data *,
> +			const struct tegra_cpufreq_config **);
> +} tegra_init_funcs[] = {
> +	{ "nvidia,tegra20", tegra20_cpufreq_init },
> +};
> +
> +static int tegra_cpufreq_probe(struct platform_device *pdev)
...
> +	for (i = 0; i < ARRAY_SIZE(tegra_init_funcs); i++) {
> +		if (of_machine_is_compatible(tegra_init_funcs[i].compat)) {
> +			ret = tegra_init_funcs[i].init(tegra_data, &soc_config);
> +			if (!ret)
> +				break;
> +			else
> +				goto out;
> +		}
>  	}
> +	if (i == ARRAY_SIZE(tegra_init_funcs))
> +		goto out;

I think there are better ways of doing this than open-coding it. Perhaps
of_match_device() or the platform-driver equivalent could be made to work?

> +int __init tegra_cpufreq_init(void)
> +{
> +	struct platform_device_info devinfo = { .name = "tegra-cpufreq", };
> +
> +	platform_device_register_full(&devinfo);
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL(tegra_cpufreq_init);

Perhaps instead of hard-coding the name "tegra-cpufreq" here, you could
dynamically construct the device name based on the DT's root compatible
value, register "${root_compatible}-cpufreq", e.g.
"nvidia,tegra20-cpufreq" or "nvidia,tegra30-cpufreq". That would allow
the kernel's standard device/driver matching mechanism to pick the
correct driver to instantiate. Perhaps you could even dynamically
register an OF device so that you can use of_match_device() in probe, if
there's some advantage of having a single driver that supports N chips.
