Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab3IKTds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:33:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35705 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3IKTdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:33:46 -0400
Message-ID: <5230C596.7010000@wwwdotorg.org>
Date: Wed, 11 Sep 2013 13:33:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: rjw@sisk.pl, viresh.kumar@linaro.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
References: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com> <1378898355-31290-3-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1378898355-31290-3-git-send-email-bilhuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 05:19 AM, Bill Huang wrote:
> Re-model Tegra cpufreq driver to support all Tegra series of SoCs.
> 
> * Make tegra-cpufreq.c a generic Tegra cpufreq driver.
> * Move Tegra20 specific codes into tegra20-cpufreq.c.
> * Bind Tegra cpufreq dirver with a fake device so defer probe would work
>   when we're going to get regulator in the driver to support voltage
>   scaling (DVFS).
> * Call tegra_cpufreq_init() in Tegra machine code specifically so it
>   won't be called in multi-platform kernel which is not running on Tegra
>   SoCs.

That's a lot of things for one patch. Can this please be split up?

In particular, I would like a separate patch for the final bullet point,
and for that patch to be the first in the series, so that we can merge
it into both the Tegra and cpufreq trees if needed to resolve any conflicts.

> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm

>  config ARM_TEGRA_CPUFREQ
> -	bool "TEGRA CPUFreq support"
> -	depends on ARCH_TEGRA
> +	bool
> +	select CPU_FREQ_TABLE

Why make this a hidden option? It'd be best to leave it user-visible, so
that existing defconfigs aren't broken by this change.

> +config ARM_EXYNOS_CPUFREQ
> +	bool
>  	select CPU_FREQ_TABLE

I think that Exynos change is a mistake?

> +
> +config ARM_TEGRA20_CPUFREQ
> +	bool "NVIDIA TEGRA20"
> +	depends on ARCH_TEGRA

Shouldn't that be ARCH_TEGRA_2x_SOC specifically?

>  	default y

Does the syntax "default ARM_TEGRA_CPUFREQ" work? Actually, this should
depend on ARM_TEGRA_CPUFREQ rather than select it, and that way you can
keep this "default y" and it'll only be enabled if Tegra cpufreq is enabled.

In summary, I think the following should work well:

config ARM_TEGRA_CPUFREQ
	bool "TEGRA CPUFreq support"
	depends on ARCH_TEGRA
	select CPU_FREQ_TABLE

config ARM_TEGRA20_CPUFREQ
	bool "NVIDIA TEGRA20"
	depends on ARM_TEGRA_CPUFREQ && ARCH_TEGRA_2x_SOC
	default y
	help
	  This adds the CPUFreq driver for NVIDIA TEGRA20 SoC.

	  If in doubt, say N.

> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c

> -#define NUM_CPUS	2
> +#define NUM_CPUS	4

NUM_ or MAX_?

> diff --git a/drivers/cpufreq/tegra-cpufreq.h b/drivers/cpufreq/tegra-cpufreq.h

> +struct tegra_cpufreq_data {
> +	struct device *dev;
> +	struct clk	*cpu_clk;
> +	struct cpufreq_frequency_table	*freq_table;
> +	void (*vote_emc_on_cpu_rate)(unsigned long);
> +	int (*cpu_clk_set_rate)(unsigned long);
> +	void (*cpufreq_clk_init)(void);
> +	void (*cpufreq_clk_exit)(void);
> +};

There's a mix of runtime and configuration-time data there. It'd be
nicer to split the two out, so that all the configuration data could be
in a const struct that's pointed to by a field in the runtime data
struct, or passed back out of tegra20_cpufreq_init() as a separate
pointer variable and assigned to a separate global in tegra-cpufreq.c,
to avoid double-indirections everywhere at runtime.

> diff --git a/drivers/cpufreq/tegra20-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c

> +static struct cpufreq_frequency_table freq_table[] = {
> +	{ .frequency = 216000 },
> +	{ .frequency = 312000 },
> +	{ .frequency = 456000 },
> +	{ .frequency = 608000 },
> +	{ .frequency = 760000 },
> +	{ .frequency = 816000 },
> +	{ .frequency = 912000 },
> +	{ .frequency = 1000000 },
> +	{ .frequency = CPUFREQ_TABLE_END },
> +};

Should/can we query that list from the clock driver?

> +int tegra20_cpufreq_init(struct tegra_cpufreq_data *data)
...
> +	data->cpu_clk = cpu_clk;
> +	data->freq_table = freq_table;
> +	data->vote_emc_on_cpu_rate = tegra20_vote_emc_on_cpu_rate;
> +	data->cpu_clk_set_rate = tegra20_cpu_clk_set_rate;
> +	data->cpufreq_clk_init = tegra20_cpufreq_clk_init;
> +	data->cpufreq_clk_exit = tegra20_cpufreq_clk_exit;

With the struct split I proposed above, most of that could just be:

*soc_config = &tegra20_cpufreq_config;

where there's an extra function parameter "struct tegra_cpufreq_config
**soc_config", and most of those values are in a static const
tegra_cpufreq_config tegra20_cpufreq_config = { ... }.

