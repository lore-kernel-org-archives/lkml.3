Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaGWEor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:44:47 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:54854 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaGWEop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:44:45 -0400
MIME-Version: 1.0
In-Reply-To: <1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
	<1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
Date: Wed, 23 Jul 2014 10:14:44 +0530
Message-ID: <CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 July 2014 21:09, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:

> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 7364a53..df3c73e 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -244,6 +244,7 @@ config ARM_SPEAR_CPUFREQ
>  config ARM_TEGRA_CPUFREQ
>         bool "TEGRA CPUFreq support"
>         depends on ARCH_TEGRA
> +       depends on GENERIC_CPUFREQ_CPU0

Wouldn't this also disturb the existing cpufreq driver for earlier
tegra platforms? i.e. we don't need cpufreq-cpu0 for them
atleast as of now.

>         default y
>         help
>           This adds the CPUFreq driver support for TEGRA SOCs.
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index db6d9a2..3437d24 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -76,6 +76,7 @@ obj-$(CONFIG_ARM_SA1100_CPUFREQ)      += sa1100-cpufreq.o
>  obj-$(CONFIG_ARM_SA1110_CPUFREQ)       += sa1110-cpufreq.o
>  obj-$(CONFIG_ARM_SPEAR_CPUFREQ)                += spear-cpufreq.o
>  obj-$(CONFIG_ARM_TEGRA_CPUFREQ)                += tegra-cpufreq.o
> +obj-$(CONFIG_ARM_TEGRA_CPUFREQ)                += tegra124-cpufreq.o

Maybe, you can update the same line if you want.

>  obj-$(CONFIG_ARM_VEXPRESS_SPC_CPUFREQ) += vexpress-spc-cpufreq.o
>
>  ##################################################################################
> diff --git a/drivers/cpufreq/tegra124-cpufreq.c b/drivers/cpufreq/tegra124-cpufreq.c

> +static struct cpufreq_frequency_table *freq_table;
> +
> +static struct device *cpu_dev;
> +static struct clk *cpu_clk;
> +static struct clk *pllp_clk;
> +static struct clk *pllx_clk;
> +static struct clk *dfll_clk;

The routines in this file are going to be called just once at boot, right?
In that case we are actually wasting some memory by creating globals.
Probably just move all these in a struct and allocate it at runtime.

> +static int tegra124_cpu_switch_to_dfll(void)
> +{
> +       struct clk *original_cpu_clk_parent;
> +       unsigned long rate;
> +       struct dev_pm_opp *opp;
> +       int ret;
> +
> +       rate = clk_get_rate(cpu_clk);
> +       opp = dev_pm_opp_find_freq_ceil(cpu_dev, &rate);
> +       if (IS_ERR(opp))
> +               return PTR_ERR(opp);
> +
> +       ret = clk_set_rate(dfll_clk, rate);
> +       if (ret)
> +               return ret;
> +
> +       original_cpu_clk_parent = clk_get_parent(cpu_clk);
> +       clk_set_parent(cpu_clk, pllp_clk);
> +       if (ret)
> +               return ret;
> +
> +       ret = clk_prepare_enable(dfll_clk);
> +       if (ret)
> +               goto out_switch_to_original_parent;
> +
> +       clk_set_parent(cpu_clk, dfll_clk);
> +
> +       return 0;
> +
> +out_switch_to_original_parent:
> +       clk_set_parent(cpu_clk, original_cpu_clk_parent);
> +
> +       return ret;
> +}
> +
> +static struct platform_device_info cpufreq_cpu0_devinfo = {
> +       .name = "cpufreq-cpu0",
> +};
> +
> +static int tegra124_cpufreq_probe(struct platform_device *pdev)
> +{
> +       int ret;
> +
> +       cpu_dev = get_cpu_device(0);
> +       if (!cpu_dev)
> +               return -ENODEV;
> +

Shouldn't we do a of_node_get() here?

> +       cpu_clk = of_clk_get_by_name(cpu_dev->of_node, "cpu_g");
> +       if (IS_ERR(cpu_clk))
> +               return PTR_ERR(cpu_clk);
> +
> +       dfll_clk = of_clk_get_by_name(cpu_dev->of_node, "dfll");
> +       if (IS_ERR(dfll_clk)) {
> +               ret = PTR_ERR(dfll_clk);
> +               goto out_put_cpu_clk;
> +       }
> +
> +       pllx_clk = of_clk_get_by_name(cpu_dev->of_node, "pll_x");
> +       if (IS_ERR(pllx_clk)) {
> +               ret = PTR_ERR(pllx_clk);
> +               goto out_put_dfll_clk;
> +       }
> +
> +       pllp_clk = of_clk_get_by_name(cpu_dev->of_node, "pll_p");
> +       if (IS_ERR(pllp_clk)) {
> +               ret = PTR_ERR(pllp_clk);
> +               goto out_put_pllx_clk;
> +       }
> +
> +       ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
> +       if (ret)
> +               goto out_put_pllp_clk;

Why do you need this? cpufreq-cpu0 also does it and this freq_table is
just not getting used at all then.

> +
> +       ret = tegra124_cpu_switch_to_dfll();
> +       if (ret)
> +               goto out_free_table;
> +
> +       platform_device_register_full(&cpufreq_cpu0_devinfo);
> +
> +       return 0;
> +
> +out_free_table:
> +       dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
> +out_put_pllp_clk:
> +       clk_put(pllp_clk);
> +out_put_pllx_clk:
> +       clk_put(pllx_clk);
> +out_put_dfll_clk:
> +       clk_put(dfll_clk);
> +out_put_cpu_clk:
> +       clk_put(cpu_clk);
> +
> +       return ret;
> +}
> +
> +static struct platform_driver tegra124_cpufreq_platdrv = {
> +       .driver = {
> +               .name   = "cpufreq-tegra124",
> +               .owner  = THIS_MODULE,
> +       },
> +       .probe          = tegra124_cpufreq_probe,
> +};
> +
> +static const struct of_device_id soc_of_matches[] = {
> +       { .compatible = "nvidia,tegra124", },
> +       {}
> +};
> +
> +static int __init tegra_cpufreq_init(void)
> +{
> +       int ret;
> +       struct platform_device *pdev;
> +
> +       if (!of_find_matching_node(NULL, soc_of_matches))
> +               return -ENODEV;
> +
> +       ret = platform_driver_register(&tegra124_cpufreq_platdrv);
> +       if (ret)
> +               return ret;
> +
> +       pdev = platform_device_register_simple("cpufreq-tegra124", -1, NULL, 0);
> +       if (IS_ERR(pdev)) {
> +               platform_driver_unregister(&tegra124_cpufreq_platdrv);
> +               return PTR_ERR(pdev);
> +       }

Why create another unnecessary platform-device/driver here? If
of_find_matching_node() passes and you really need to probe cpufreq-cpu0
here, then just remove the other two calls and move probe's implementation
here only.

> +       return 0;
> +}
> +
> +MODULE_AUTHOR("Tuomas Tynkkynen <ttynkkynen@nvidia.com>");
> +MODULE_DESCRIPTION("cpufreq driver for nVIDIA Tegra124");
> +MODULE_LICENSE("GPLv2");
> +module_init(tegra_cpufreq_init);
> --
> 1.8.1.5
>
