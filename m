Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaDOFoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:44:14 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:36965 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaDOFoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <534C4E7E.4090806@semaphore.gr>
References: <534C4E7E.4090806@semaphore.gr>
Date: Tue, 15 Apr 2014 11:14:11 +0530
Message-ID: <CAKohpokfsR3soykZbtH4-L=4TC6Oab=jyzUr=W-EfkRFfefRDQ@mail.gmail.com>
Subject: Re: [PATCH 08/20] cpufreq: exynos5440: Use cpufreq_for_each_entry
 macro for iteration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 02:39, Stratos Karafotis <stratosk@semaphore.gr> wrote:

> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c

>  static void exynos_enable_dvfs(unsigned int cur_frequency)
>  {
> -       unsigned int tmp, i, cpu;
> +       unsigned int tmp, cpu;
>         struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
> +       struct cpufreq_frequency_table *pos;

Merge above two.

>         /* Disable DVFS */
>         __raw_writel(0, dvfs_info->base + XMU_DVFS_CTRL);
>
> @@ -182,15 +182,15 @@ static void exynos_enable_dvfs(unsigned int cur_frequency)
>          __raw_writel(tmp, dvfs_info->base + XMU_PMUIRQEN);
>
>         /* Set initial performance index */
> -       for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
> -               if (freq_table[i].frequency == cur_frequency)
> +       cpufreq_for_each_entry(pos, freq_table) {
> +               if (pos->frequency == cur_frequency)
>                         break;
> +       }
>
> -       if (freq_table[i].frequency == CPUFREQ_TABLE_END) {
> +       if (pos->frequency == CPUFREQ_TABLE_END) {
>                 dev_crit(dvfs_info->dev, "Boot up frequency not supported\n");
>                 /* Assign the highest frequency */
> -               i = 0;
> -               cur_frequency = freq_table[i].frequency;
> +               cur_frequency = freq_table->frequency;

First this is not readable enough and you introduced a bug here, see
below.

>         }
>
>         dev_info(dvfs_info->dev, "Setting dvfs initial frequency = %uKHZ",
> @@ -199,7 +199,7 @@ static void exynos_enable_dvfs(unsigned int cur_frequency)
>         for (cpu = 0; cpu < CONFIG_NR_CPUS; cpu++) {
>                 tmp = __raw_readl(dvfs_info->base + XMU_C0_3_PSTATE + cpu * 4);
>                 tmp &= ~(P_VALUE_MASK << C0_3_PSTATE_NEW_SHIFT);
> -               tmp |= (i << C0_3_PSTATE_NEW_SHIFT);
> +               tmp |= ((pos - freq_table) << C0_3_PSTATE_NEW_SHIFT);

We used modified value of 'i' here earlier, i.e. 0 ..

>                 __raw_writel(tmp, dvfs_info->base + XMU_C0_3_PSTATE + cpu * 4);
>         }
>
> --
> 1.9.0
