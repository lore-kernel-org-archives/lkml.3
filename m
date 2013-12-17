Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3LQGbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:31:41 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:54495 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3LQGbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:31:38 -0500
MIME-Version: 1.0
In-Reply-To: <1386229462-3474-2-git-send-email-bilhuang@nvidia.com>
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
	<1386229462-3474-2-git-send-email-bilhuang@nvidia.com>
Date: Tue, 17 Dec 2013 12:01:37 +0530
Message-ID: <CAKohpo=OAg96OUe_dmitd_OWThtZv6M+0fsx=4ngCez0MgDhLw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cpufreq: tegra: Call tegra_cpufreq_init()
 specifically in machine code
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Bill Huang <bilhuang@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2013 13:14, Bill Huang <bilhuang@nvidia.com> wrote:
> Move the call from module_init to Tegra machine codes so it won't be
> called in a multi-platform kernel running on non-Tegra SoCs.
>
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> ---
>  arch/arm/mach-tegra/tegra.c     |    2 ++
>  drivers/cpufreq/tegra-cpufreq.c |   13 ++-----------
>  include/linux/tegra-soc.h       |   11 ++++++++++-
>  3 files changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
> index 7336817..14490ad 100644
> --- a/arch/arm/mach-tegra/tegra.c
> +++ b/arch/arm/mach-tegra/tegra.c
> @@ -34,6 +34,7 @@
>  #include <linux/usb/tegra_usb_phy.h>
>  #include <linux/clk/tegra.h>
>  #include <linux/irqchip.h>
> +#include <linux/tegra-soc.h>
>
>  #include <asm/hardware/cache-l2x0.h>
>  #include <asm/mach-types.h>
> @@ -160,6 +161,7 @@ static void __init tegra_dt_init_late(void)
>  {
>         int i;
>
> +       tegra_cpufreq_init();
>         tegra_init_suspend();
>         tegra_cpuidle_init();
>         tegra_powergate_debugfs_init();
> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
> index 63f0059..ae1c0f1 100644
> --- a/drivers/cpufreq/tegra-cpufreq.c
> +++ b/drivers/cpufreq/tegra-cpufreq.c
> @@ -155,7 +155,7 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
>  #endif
>  };

Remove module.h as well ??

> -static int __init tegra_cpufreq_init(void)
> +int __init tegra_cpufreq_init(void)
>  {
>         cpu_clk = clk_get_sys(NULL, "cclk");
>         if (IS_ERR(cpu_clk))
> @@ -177,17 +177,8 @@ static int __init tegra_cpufreq_init(void)
>
>         return cpufreq_register_driver(&tegra_cpufreq_driver);
>  }
> -
> -static void __exit tegra_cpufreq_exit(void)
> -{
> -        cpufreq_unregister_driver(&tegra_cpufreq_driver);
> -       clk_put(emc_clk);
> -       clk_put(cpu_clk);
> -}
> -
> +EXPORT_SYMBOL(tegra_cpufreq_init);
>
>  MODULE_AUTHOR("Colin Cross <ccross@android.com>");
>  MODULE_DESCRIPTION("cpufreq driver for Nvidia Tegra2");
>  MODULE_LICENSE("GPL");

Remove these as well? As they don't have a meaning for Tegra
cpufreq driver which can't be compiled as module.

> -module_init(tegra_cpufreq_init);
> -module_exit(tegra_cpufreq_exit);

Rest as what Stephen suggested.
