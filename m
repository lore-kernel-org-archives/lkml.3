Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3HRKDJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 06:03:09 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:48816 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab3HRKDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 06:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <d71c900c5af2378da4e4024150d9f22f4a97e9db.1376116345.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
	<d71c900c5af2378da4e4024150d9f22f4a97e9db.1376116345.git.viresh.kumar@linaro.org>
Date: Sun, 18 Aug 2013 15:33:05 +0530
X-Google-Sender-Auth: kbTzWDyB5ikU0clU5NxtT2Nf-Cg
Message-ID: <CADGdYn5xkUN8bO19Hbf2S-WcCNUe_TFOONkqyxNUF8QRAnnVzA@mail.gmail.com>
Subject: Re: [PATCH 19/44] cpufreq: exynos: Use generic cpufreq routines
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linaro-kernel@lists.linaro.org,
        "patches@linaro.org" <patches@linaro.org>, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 12:14 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
> and .attr. So its better if we have generic routines for them which can be used
> by cpufreq drivers then.
>
> This patch uses these generic routines for this driver.
>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
The consolidation code looks fine,
Acked-By: Amit Daniel Kachhap <amit.daniel@samsung.com>

Thanks,
Amit Daniel
> ---
>  drivers/cpufreq/exynos-cpufreq.c     | 23 +++--------------------
>  drivers/cpufreq/exynos5440-cpufreq.c | 15 ++-------------
>  2 files changed, 5 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index 71c4926..7663a96 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -31,12 +31,6 @@ static unsigned int locking_frequency;
>  static bool frequency_locked;
>  static DEFINE_MUTEX(cpufreq_lock);
>
> -static int exynos_verify_speed(struct cpufreq_policy *policy)
> -{
> -       return cpufreq_frequency_table_verify(policy,
> -                                             exynos_info->freq_table);
> -}
> -
>  static unsigned int exynos_getspeed(unsigned int cpu)
>  {
>         return clk_get_rate(exynos_info->cpu_clk) / 1000;
> @@ -257,26 +251,15 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
>         return cpufreq_table_validate_and_show(policy, exynos_info->freq_table);
>  }
>
> -static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
> -{
> -       cpufreq_frequency_table_put_attr(policy->cpu);
> -       return 0;
> -}
> -
> -static struct freq_attr *exynos_cpufreq_attr[] = {
> -       &cpufreq_freq_attr_scaling_available_freqs,
> -       NULL,
> -};
> -
>  static struct cpufreq_driver exynos_driver = {
>         .flags          = CPUFREQ_STICKY,
> -       .verify         = exynos_verify_speed,
> +       .verify         = cpufreq_generic_frequency_table_verify,
>         .target         = exynos_target,
>         .get            = exynos_getspeed,
>         .init           = exynos_cpufreq_cpu_init,
> -       .exit           = exynos_cpufreq_cpu_exit,
> +       .exit           = cpufreq_generic_exit,
>         .name           = "exynos_cpufreq",
> -       .attr           = exynos_cpufreq_attr,
> +       .attr           = cpufreq_generic_attr,
>  #ifdef CONFIG_PM
>         .suspend        = exynos_cpufreq_suspend,
>         .resume         = exynos_cpufreq_resume,
> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
> index b9dfc91..f139b3b 100644
> --- a/drivers/cpufreq/exynos5440-cpufreq.c
> +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> @@ -209,12 +209,6 @@ static void exynos_enable_dvfs(void)
>                                 dvfs_info->base + XMU_DVFS_CTRL);
>  }
>
> -static int exynos_verify_speed(struct cpufreq_policy *policy)
> -{
> -       return cpufreq_frequency_table_verify(policy,
> -                                             dvfs_info->freq_table);
> -}
> -
>  static unsigned int exynos_getspeed(unsigned int cpu)
>  {
>         return dvfs_info->cur_frequency;
> @@ -336,18 +330,13 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
>         return 0;
>  }
>
> -static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
> -{
> -       cpufreq_frequency_table_put_attr(policy->cpu);
> -}
> -
>  static struct cpufreq_driver exynos_driver = {
>         .flags          = CPUFREQ_STICKY,
> -       .verify         = exynos_verify_speed,
> +       .verify         = cpufreq_generic_frequency_table_verify,
>         .target         = exynos_target,
>         .get            = exynos_getspeed,
>         .init           = exynos_cpufreq_cpu_init,
> -       .exit           = exynos_cpufreq_cpu_exit,
> +       .exit           = cpufreq_generic_exit,
>         .name           = CPUFREQ_NAME,
>  };
>
> --
> 1.7.12.rc2.18.g61b472e
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
