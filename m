Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaFPOJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:09:00 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:45505 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbaFPOI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:08:56 -0400
Message-ID: <539EFA6B.20501@kapsi.fi>
Date: Mon, 16 Jun 2014 17:08:43 +0300
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 4/4] cpufreq: tegra: Register a minimum EMC frequency
 based on the CPU clock
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-5-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1402925713-25426-5-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:be5f:f4ff:fe47:6518
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tegra-cpufreq driver is only for Tegra20, an upcoming driver for 
Tegra124 will be separate, so this is not needed.

Thanks,
- Mikko

On 06/16/2014 04:35 PM, Tomeu Vizoso wrote:
> Instead of setting a direct correlation to the CPU frequency. This allows
> for other devices to influence the final effective EMC frequency.
>
> In the future, this should be done instead by an ACTMON driver,
> which would also take load stats into account when calculating the
> floor EMC frequency.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>   drivers/cpufreq/tegra-cpufreq.c | 20 +++++---------------
>   1 file changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
> index 8084c7f..64935f8 100644
> --- a/drivers/cpufreq/tegra-cpufreq.c
> +++ b/drivers/cpufreq/tegra-cpufreq.c
> @@ -26,6 +26,7 @@
>   #include <linux/err.h>
>   #include <linux/clk.h>
>   #include <linux/io.h>
> +#include <linux/platform_data/tegra_emc.h>
>
>   static struct cpufreq_frequency_table freq_table[] = {
>   	{ .frequency = 216000 },
> @@ -44,7 +45,6 @@ static struct cpufreq_frequency_table freq_table[] = {
>   static struct clk *cpu_clk;
>   static struct clk *pll_x_clk;
>   static struct clk *pll_p_clk;
> -static struct clk *emc_clk;
>   static bool pll_x_prepared;
>
>   static unsigned int tegra_get_intermediate(struct cpufreq_policy *policy,
> @@ -96,15 +96,15 @@ static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
>   	int ret = 0;
>
>   	/*
> -	 * Vote on memory bus frequency based on cpu frequency
> +	 * Set minimum memory bus frequency based on cpu frequency
>   	 * This sets the minimum frequency, display or avp may request higher
>   	 */
>   	if (rate >= 816000)
> -		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
> +		tegra124_emc_set_floor(600000000); /* cpu 816 MHz, emc max */
>   	else if (rate >= 456000)
> -		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
> +		tegra124_emc_set_floor(300000000); /* cpu 456 MHz, emc 150Mhz */
>   	else
> -		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
> +		tegra124_emc_set_floor(100000000);  /* emc 50Mhz */
>
>   	/*
>   	 * target freq == pll_p, don't need to take extra reference to pll_x_clk
> @@ -141,14 +141,12 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
>   	if (policy->cpu >= NUM_CPUS)
>   		return -EINVAL;
>
> -	clk_prepare_enable(emc_clk);
>   	clk_prepare_enable(cpu_clk);
>
>   	/* FIXME: what's the actual transition time? */
>   	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
>   	if (ret) {
>   		clk_disable_unprepare(cpu_clk);
> -		clk_disable_unprepare(emc_clk);
>   		return ret;
>   	}
>
> @@ -160,7 +158,6 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
>   static int tegra_cpu_exit(struct cpufreq_policy *policy)
>   {
>   	clk_disable_unprepare(cpu_clk);
> -	clk_disable_unprepare(emc_clk);
>   	return 0;
>   }
>
> @@ -194,19 +191,12 @@ static int __init tegra_cpufreq_init(void)
>   	if (IS_ERR(pll_p_clk))
>   		return PTR_ERR(pll_p_clk);
>
> -	emc_clk = clk_get_sys("cpu", "emc");
> -	if (IS_ERR(emc_clk)) {
> -		clk_put(cpu_clk);
> -		return PTR_ERR(emc_clk);
> -	}
> -
>   	return cpufreq_register_driver(&tegra_cpufreq_driver);
>   }
>
>   static void __exit tegra_cpufreq_exit(void)
>   {
>           cpufreq_unregister_driver(&tegra_cpufreq_driver);
> -	clk_put(emc_clk);
>   	clk_put(cpu_clk);
>   }
>
>

