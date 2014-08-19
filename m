Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaHSFzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:55:50 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:65304 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaHSFzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:55:48 -0400
MIME-Version: 1.0
In-Reply-To: <1408419205-10048-14-git-send-email-tuomas.tynkkynen@iki.fi>
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
	<1408419205-10048-14-git-send-email-tuomas.tynkkynen@iki.fi>
Date: Tue, 19 Aug 2014 11:25:47 +0530
Message-ID: <CAKohpokQOALPH13Ykz4nTBOby8J1X6_F30LNKz=gsC4wN3=3vg@mail.gmail.com>
Subject: Re: [PATCH v3 13/15] cpufreq: Add cpufreq driver for Tegra124
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
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
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2014 09:03, Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi> wrote:
> From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>
> Add a new cpufreq driver for Tegra124. Instead of using the PLLX as
> the CPU clocksource, switch immediately to the DFLL. It allows the use
> of higher clock rates, and will automatically scale the CPU voltage as
> well. Besides the CPU clocksource switch, we let the cpufreq-cpu0 driver
> for all the cpufreq operations.
>
> This driver also relies on the DFLL driver to fill the OPP table for the
> CPU0 device, so that the cpufreq-cpu0 driver knows what frequencies to
> use.
>
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
> v3:
>  - separate Kconfig entry

Gud..

>  - use 'select GENERIC_CPUFREQ_CPU0', not depends

Bad :(

It *has* to be a depends here, its not optional. That was outcome of the
chat we had last time, if I remember it well..

>  - support unbinding of the platform device
>  - allocate a state structure instead of globals
>  - use of_match_machine()
>  - various style nits fixed
> ---

You don't need to add these --- here, just add a blank line and git
will take care of things for you :)

>  drivers/cpufreq/Kconfig.arm        |   8 ++
>  drivers/cpufreq/Makefile           |   1 +
>  drivers/cpufreq/tegra124-cpufreq.c | 206 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 215 insertions(+)
>  create mode 100644 drivers/cpufreq/tegra124-cpufreq.c
>
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 3795a16..07bfed1 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -247,3 +247,11 @@ config ARM_TEGRA20_CPUFREQ
>         default y
>         help
>           This adds the CPUFreq driver support for Tegra20 SOCs.
> +
> +config ARM_TEGRA124_CPUFREQ
> +       bool "Tegra124 CPUFreq support"
> +       depends on ARCH_TEGRA
> +       select GENERIC_CPUFREQ_CPU0

So it will become: depends on ARCH_TEGRA && GENERIC_CPUFREQ_CPU0

> +static int tegra124_cpufreq_probe(struct platform_device *pdev)
> +{

> +       priv->vdd_cpu_reg = regulator_get(get_cpu_device(0), "vdd-cpu");

get_cpu_device() can fail as well, and so you may want to check its return
value as well..

> +static int __init tegra_cpufreq_init(void)
> +{
> +       int ret;
> +       struct platform_device *pdev;
> +
> +       if (!of_match_machine(soc_of_matches))
> +               return -ENODEV;

You may want to add a comment here on why you chose to add another layer
of platform device/driver.. i.e. to catch -EPROBE_DEFER from clk-APIs..

> +       ret = platform_driver_register(&tegra124_cpufreq_platdrv);
> +       if (ret)
> +               return ret;
> +
> +       pdev = platform_device_register_simple("cpufreq-tegra124", -1, NULL, 0);
> +       if (IS_ERR(pdev)) {
> +               platform_driver_unregister(&tegra124_cpufreq_platdrv);
> +               return PTR_ERR(pdev);
> +       }
> +
> +       return 0;
> +}
> +module_init(tegra_cpufreq_init);
> +
> +MODULE_AUTHOR("Tuomas Tynkkynen <ttynkkynen@nvidia.com>");
> +MODULE_DESCRIPTION("cpufreq driver for NVIDIA Tegra124");
> +MODULE_LICENSE("GPL v2");
> --
> 1.8.1.5
>
