Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaDUGFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 02:05:31 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36300 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaDUGFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 02:05:19 -0400
MIME-Version: 1.0
In-Reply-To: <1397787634-9334-2-git-send-email-cw00.choi@samsung.com>
References: <1397787634-9334-1-git-send-email-cw00.choi@samsung.com>
	<1397787634-9334-2-git-send-email-cw00.choi@samsung.com>
Date: Mon, 21 Apr 2014 11:35:19 +0530
Message-ID: <CAKohpo=-Oxu6ZoB4B2H4552meq46iXrVzKbP5ZwnG==sCc2_MA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: exynos: Use dev_err/info function instead of pr_err/info
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2014 07:50, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch uses dev_err/info function to show accurate log message with device name
> instead of pr_err/info function.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/cpufreq/exynos-cpufreq.c | 21 ++++++++++++---------
>  drivers/cpufreq/exynos-cpufreq.h |  1 +
>  2 files changed, 13 insertions(+), 9 deletions(-)

This still looks fine even if we don't take the new driver ?

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index f99cfe2..8b4bb4a 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -49,6 +49,7 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
>         struct cpufreq_policy *policy = cpufreq_cpu_get(0);
>         unsigned int arm_volt, safe_arm_volt = 0;
>         unsigned int mpll_freq_khz = exynos_info->mpll_freq_khz;
> +       struct device *dev = exynos_info->dev;
>         unsigned int old_freq;
>         int index, old_index;
>         int ret = 0;
> @@ -90,8 +91,8 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
>                 /* Firstly, voltage up to increase frequency */
>                 ret = regulator_set_voltage(arm_regulator, arm_volt, arm_volt);
>                 if (ret) {
> -                       pr_err("%s: failed to set cpu voltage to %d\n",
> -                               __func__, arm_volt);
> +                       dev_err(dev, "failed to set cpu voltage to %d\n",
> +                               arm_volt);
>                         return ret;
>                 }
>         }
> @@ -100,8 +101,8 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
>                 ret = regulator_set_voltage(arm_regulator, safe_arm_volt,
>                                       safe_arm_volt);
>                 if (ret) {
> -                       pr_err("%s: failed to set cpu voltage to %d\n",
> -                               __func__, safe_arm_volt);
> +                       dev_err(dev, "failed to set cpu voltage to %d\n",
> +                               safe_arm_volt);
>                         return ret;
>                 }
>         }
> @@ -115,8 +116,8 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
>                 ret = regulator_set_voltage(arm_regulator, arm_volt,
>                                 arm_volt);
>                 if (ret) {
> -                       pr_err("%s: failed to set cpu voltage to %d\n",
> -                               __func__, arm_volt);
> +                       dev_err(dev, "failed to set cpu voltage to %d\n",
> +                               arm_volt);
>                         goto out;
>                 }
>         }
> @@ -163,6 +164,8 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
>         if (!exynos_info)
>                 return -ENOMEM;
>
> +       exynos_info->dev = &pdev->dev;
> +
>         if (soc_is_exynos4210())
>                 ret = exynos4210_cpufreq_init(exynos_info);
>         else if (soc_is_exynos4212() || soc_is_exynos4412())
> @@ -176,13 +179,13 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
>                 goto err_vdd_arm;
>
>         if (exynos_info->set_freq == NULL) {
> -               pr_err("%s: No set_freq function (ERR)\n", __func__);
> +               dev_err(&pdev->dev, "No set_freq function (ERR)\n");
>                 goto err_vdd_arm;
>         }
>
>         arm_regulator = regulator_get(NULL, "vdd_arm");
>         if (IS_ERR(arm_regulator)) {
> -               pr_err("%s: failed to get resource vdd_arm\n", __func__);
> +               dev_err(&pdev->dev, "failed to get resource vdd_arm\n");
>                 goto err_vdd_arm;
>         }
>
> @@ -192,7 +195,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
>         if (!cpufreq_register_driver(&exynos_driver))
>                 return 0;
>
> -       pr_err("%s: failed to register cpufreq driver\n", __func__);
> +       dev_err(&pdev->dev, "failed to register cpufreq driver\n");
>         regulator_put(arm_regulator);
>  err_vdd_arm:
>         kfree(exynos_info);
> diff --git a/drivers/cpufreq/exynos-cpufreq.h b/drivers/cpufreq/exynos-cpufreq.h
> index 3ddade8..b72ff10 100644
> --- a/drivers/cpufreq/exynos-cpufreq.h
> +++ b/drivers/cpufreq/exynos-cpufreq.h
> @@ -34,6 +34,7 @@ struct apll_freq {
>  };
>
>  struct exynos_dvfs_info {
> +       struct device   *dev;
>         unsigned long   mpll_freq_khz;
>         unsigned int    pll_safe_idx;
>         struct clk      *cpu_clk;
> --
> 1.8.0
>
