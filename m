Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3DPGvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:51:44 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:46357 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3DPGvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:51:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAGo_u6qD5hO7x0fYwe+cZ5GHRA6tRG+vmhnf4GFjt9G0inQ0xA@mail.gmail.com>
References: <1366007087-12090-1-git-send-email-amit.daniel@samsung.com>
	<CAGo_u6qD5hO7x0fYwe+cZ5GHRA6tRG+vmhnf4GFjt9G0inQ0xA@mail.gmail.com>
Date: Tue, 16 Apr 2013 12:21:41 +0530
X-Google-Sender-Auth: 0K6K_ETmS27LxxdS7PCJ8xXmULc
Message-ID: <CADGdYn6FJFWgx=8PGNwjmxVpsBU=QrvMKpPQMANuBwOHUPmt8w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: exynos5440: Protect opp search calls with rcu lock
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

Thanks for reviewing this patch.

On Mon, Apr 15, 2013 at 7:40 PM, Nishanth Menon <nm@ti.com> wrote:
> Daniel,
> On Mon, Apr 15, 2013 at 1:24 AM, Amit Daniel Kachhap
> <amit.daniel@samsung.com> wrote:
>> As per the OPP library documentation(Documentation/power/opp.txt) all
>> opp find/get calls should be protected by rcu locks.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>
>> This patch is created against linux-next tree and is suggested by
>> Nishanth Menon. (https://lkml.org/lkml/2013/4/12/119)
>>
>>  drivers/cpufreq/exynos5440-cpufreq.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
>> index ead7ed4..0c74018 100644
>> --- a/drivers/cpufreq/exynos5440-cpufreq.c
>> +++ b/drivers/cpufreq/exynos5440-cpufreq.c
>> @@ -120,11 +120,13 @@ static int init_div_table(void)
>>         int i = 0;
>>         struct opp *opp;
>>
>> +       rcu_read_lock();
>>         for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
>>
>>                 opp = opp_find_freq_exact(dvfs_info->dev,
>>                                         freq_tbl[i].frequency * 1000, true);
>>                 if (IS_ERR(opp)) {
>> +                       rcu_read_unlock();
>>                         dev_err(dvfs_info->dev,
>>                                 "failed to find valid OPP for %u KHZ\n",
>>                                 freq_tbl[i].frequency);
>> @@ -159,6 +161,7 @@ static int init_div_table(void)
>>                 __raw_writel(tmp, dvfs_info->base + XMU_PMU_P0_7 + 4 * i);
>>         }
>>
>> +       rcu_read_unlock();
>
> Is it not possible to reduce the amount of code protected by RCU lock?
> something like this:
Yes it is possible but then this part of code is a loop of max 8
iteration so rcu_read_lock will be called those many times.
Also this code blocks are just register writes and not doing any time
consuming operations.

Thanks,
Amit Daniel
> +               rcu_read_lock();
>                 opp = opp_find_freq_exact(dvfs_info->dev,
>                                         freq_tbl[i].frequency * 1000, true);
>                 if (IS_ERR(opp)) {
> +                       rcu_read_unlock();
>                         dev_err(dvfs_info->dev,
>                                 "failed to find valid OPP for %u KHZ\n",
>                                 freq_tbl[i].frequency);
>                         return PTR_ERR(opp);
>                 }
> +               volt_id = opp_get_voltage(opp);
> +               rcu_unlock();
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
