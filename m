Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3GEAvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:51:16 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:37767 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3GEAvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <1372951039-10375-4-git-send-email-k.krivyakin@samsung.com>
References: <1372951039-10375-1-git-send-email-k.krivyakin@samsung.com>
	<1372951039-10375-4-git-send-email-k.krivyakin@samsung.com>
Date: Fri, 5 Jul 2013 09:51:14 +0900
X-Google-Sender-Auth: GVuVnYMuKM3dpDh_IfBYKCzhIy4
Message-ID: <CAH9JG2XwWC03vR7Obg_PLBFJ5vEz19vaCjROpfGtTNsGP2Cj-w@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] Update current cpu power when cpu freq change for exynos.
From: Kyungmin Park <kmpark@infradead.org>
To: Konstantin Krivyakin <k.krivyakin@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, viresh.kumar@linaro.org,
        mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>
Cc: i.zhbanov@samsung.com, e.voevodin@samsung.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ cpufreq maintainers

On Fri, Jul 5, 2013 at 12:17 AM, Konstantin Krivyakin
<k.krivyakin@samsung.com> wrote:
> Signed-off-by: Konstantin Krivyakin <k.krivyakin@samsung.com>
> ---
>  drivers/cpufreq/exynos-cpufreq.c     |    2 ++
>  drivers/cpufreq/exynos-cpufreq.h     |    1 +
>  drivers/cpufreq/exynos4x12-cpufreq.c |   19 ++++++++++++++++++-
>  3 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index 0d32f02..02f17bc 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -178,6 +178,8 @@ static int exynos_target(struct cpufreq_policy *policy,
>         }
>
>         new_freq = freq_table[index].frequency;
> +       if (exynos_info->power_table)
> +               policy->current_power = exynos_info->power_table[index];
>
>         ret = exynos_cpufreq_scale(new_freq);
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.h b/drivers/cpufreq/exynos-cpufreq.h
> index 92b852e..64f964f 100644
> --- a/drivers/cpufreq/exynos-cpufreq.h
> +++ b/drivers/cpufreq/exynos-cpufreq.h
> @@ -38,6 +38,7 @@ struct exynos_dvfs_info {
>         unsigned int    pll_safe_idx;
>         struct clk      *cpu_clk;
>         unsigned int    *volt_table;
> +       u64             *power_table;
>         struct cpufreq_frequency_table  *freq_table;
>         void (*set_freq)(unsigned int, unsigned int);
>         bool (*need_apll_change)(unsigned int, unsigned int);
> diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
> index 08b7477..8905f9b 100644
> --- a/drivers/cpufreq/exynos4x12-cpufreq.c
> +++ b/drivers/cpufreq/exynos4x12-cpufreq.c
> @@ -219,6 +219,7 @@ static void exynos4x12_set_frequency(unsigned int old_index,
>  int exynos4x12_cpufreq_init(struct exynos_dvfs_info *info)
>  {
>         unsigned long rate;
> +       int freq_count;
>
>         cpu_clk = clk_get(NULL, "armclk");
>         if (IS_ERR(cpu_clk))
> @@ -252,8 +253,24 @@ int exynos4x12_cpufreq_init(struct exynos_dvfs_info *info)
>         info->set_freq = exynos4x12_set_frequency;
>         info->need_apll_change = exynos4x12_pms_change;
>
> -       return 0;
> +       freq_count = sizeof(exynos4x12_freq_table) /
> +               sizeof(struct cpufreq_frequency_table);
> +       info->power_table = kzalloc(sizeof(u64) * freq_count, GFP_KERNEL);
> +       if (!info->power_table)
> +               goto err_power_table;
> +
> +       for (i = 0; i <= freq_count; ++i) {
> +               u64 freq = info->freq_table[i].frequency;
> +               u64 volt = info->volt_table[i];
>
> +               do_div(freq, 1000);
> +               do_div(volt, 1000);
> +               info->power_table[i] = freq * volt * volt;
> +       }
> +
> +       return 0;
> +err_power_table:
> +       clk_put(mout_appl);
>  err_mout_apll:
>         clk_put(mout_mpll);
>  err_mout_mpll:
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
