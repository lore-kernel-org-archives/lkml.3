Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3BDTvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:51:50 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57543 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3BDTvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:51:49 -0500
MIME-Version: 1.0
In-Reply-To: <1359041045-24341-1-git-send-email-gu1@aeroxteam.fr>
References: <1359041045-24341-1-git-send-email-gu1@aeroxteam.fr>
Date: Mon, 4 Feb 2013 11:51:48 -0800
Message-ID: <CADGdYn5nceorbM1uoCDgBbcTY3y6r9m+MXUL=Ls1jT2h6gybHA@mail.gmail.com>
Subject: Re: [PATCH] Thermal: fix iteration over CPU frequency list
From: amit kachhap <amit.kachhap@gmail.com>
To: Gu1 <gu1@aeroxteam.fr>, Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 7:24 AM, Gu1 <gu1@aeroxteam.fr> wrote:
> In different places in the Thermal code, the CPU frequency list is iterated
> in an incorrect way, leading to endless loops when the frequency list contains
> a CPUFREQ_TABLE_INVALID entry, which is the case by default in the the Exynos
> 4x12 cpufreq driver, for example.
>
> The frequency list is iterated with a while loop, and when a
> CPUFREQ_TABLE_INVALID entry is encountered, the continue; statement is used to
> skip it, but the index is not incremented, causing an endless loop.
>
> A similar bug was fixed by hongbo.zhang in commit:
>   Thermal: fix bug of counting cpu frequencies
>
> Signed-off-by: Gu1 <gu1@aeroxteam.fr>
This changes looks fine.

Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Thanks,
Amit Daniel

> ---
>  drivers/thermal/cpu_cooling.c    | 8 +++-----
>  drivers/thermal/exynos_thermal.c | 9 +++++----
>  2 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 836828e..51acd26 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -123,7 +123,7 @@ static int is_cpufreq_valid(int cpu)
>   */
>  static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>  {
> -       int ret = 0, i = 0;
> +       int ret = 0, i;
>         unsigned long level_index;
>         bool descend = false;
>         struct cpufreq_frequency_table *table =
> @@ -131,7 +131,7 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>         if (!table)
>                 return ret;
>
> -       while (table[i].frequency != CPUFREQ_TABLE_END) {
> +       for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>                         continue;
>
> @@ -145,7 +145,6 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>                 /*return if level matched and table in descending order*/
>                 if (descend && i == level)
>                         return table[i].frequency;
> -               i++;
>         }
>         i--;
>
> @@ -154,13 +153,12 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>         level_index = i - level;
>
>         /*Scan the table in reverse order and match the level*/
> -       while (i >= 0) {
> +       for (; i >= 0; i--) {
>                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>                         continue;
>                 /*return if level matched*/
>                 if (i == level_index)
>                         return table[i].frequency;
> -               i--;
>         }
>         return ret;
>  }
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> index 224751e..fa9e1d7 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -233,7 +233,8 @@ static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
>
>  static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>  {
> -       int i = 0, ret = -EINVAL;
> +       int i, ret = -EINVAL;
> +       unsigned int count = 0;
>         struct cpufreq_frequency_table *table = NULL;
>  #ifdef CONFIG_CPU_FREQ
>         table = cpufreq_frequency_get_table(cpu);
> @@ -241,12 +242,12 @@ static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>         if (!table)
>                 return ret;
>
> -       while (table[i].frequency != CPUFREQ_TABLE_END) {
> +       for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>                         continue;
>                 if (table[i].frequency == freq)
> -                       return i;
> -               i++;
> +                       return count;
> +               count++;
>         }
>         return ret;
>  }
> --
> 1.8.1.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
