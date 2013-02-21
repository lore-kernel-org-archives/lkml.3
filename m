Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab3BUVxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:53:10 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:50546 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3BUVxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:53:09 -0500
MIME-Version: 1.0
In-Reply-To: <87y5ehmp8d.fsf@linaro.org>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
	<1361389302-11968-3-git-send-email-khilman@linaro.org>
	<87y5ehmp8d.fsf@linaro.org>
Date: Thu, 21 Feb 2013 22:53:07 +0100
Message-ID: <CAFTL4hw1=mKtUadL0WDrydtspOehKuW7jhhzr65vXR2P2zdTWw@mail.gmail.com>
Subject: Re: [RFC/PATCH 2/5] kernel_cpustat: convert to atomic 64-bit accessors
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/21 Kevin Hilman <khilman@linaro.org>:
> Subject: [PATCH 2/5] kernel_cpustat: convert to atomic 64-bit accessors
>
> Use the atomic64_* accessors for all the kernel_cpustat fields to
> ensure atomic access on non-64 bit platforms.
>
> Thanks to Mats Liljegren for CGROUP_CPUACCT related fixes.
>
> Cc: Mats Liljegren <mats.liljegren@enea.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>

Funny stuff, I thought struct kernel_cpustat was made of cputime_t
field. Actually it's u64. So the issue is independant from the new
full dynticks cputime accounting. It was already broken before.

But yeah that's not the point, we still want to fix this anyway. But
let's just treat this patch as independant.

> ---
>  arch/s390/appldata/appldata_os.c   | 41 +++++++++++++++++++++++---------------
>  drivers/cpufreq/cpufreq_governor.c | 18 ++++++++---------
>  drivers/cpufreq/cpufreq_ondemand.c |  2 +-
>  drivers/macintosh/rack-meter.c     |  6 +++---
>  fs/proc/stat.c                     | 40 ++++++++++++++++++-------------------
>  fs/proc/uptime.c                   |  2 +-
>  include/linux/kernel_stat.h        |  2 +-
>  kernel/sched/core.c                | 10 +++++-----
>  kernel/sched/cputime.c             | 38 +++++++++++++++++------------------
>  9 files changed, 84 insertions(+), 75 deletions(-)
>
> diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
> index 87521ba..008b180 100644
> --- a/arch/s390/appldata/appldata_os.c
> +++ b/arch/s390/appldata/appldata_os.c
> @@ -99,6 +99,7 @@ static void appldata_get_os_data(void *data)
>         int i, j, rc;
>         struct appldata_os_data *os_data;
>         unsigned int new_size;
> +       u64 val;
>
>         os_data = data;
>         os_data->sync_count_1++;
> @@ -112,22 +113,30 @@ static void appldata_get_os_data(void *data)
>
>         j = 0;
>         for_each_online_cpu(i) {
> -               os_data->os_cpu[j].per_cpu_user =
> -                       cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_USER]);
> -               os_data->os_cpu[j].per_cpu_nice =
> -                       cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
> -               os_data->os_cpu[j].per_cpu_system =
> -                       cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
> -               os_data->os_cpu[j].per_cpu_idle =
> -                       cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IDLE]);
> -               os_data->os_cpu[j].per_cpu_irq =
> -                       cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
> -               os_data->os_cpu[j].per_cpu_softirq =
> -                       cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
> -               os_data->os_cpu[j].per_cpu_iowait =
> -                       cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IOWAIT]);
> -               os_data->os_cpu[j].per_cpu_steal =
> -                       cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
> +               val = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_USER]);

So I see this repeated pattern everywhere. How about converting that to:
           kcpustat_cpu_get(i, CPUTIME_USER)

and use that accessor in all other places. That's much more readable
and then we can later modify the accessing code in one go.

We should perhaps even use atomic_64 in 32 bits and u64 in 64 bits.

[...]
> @@ -186,11 +186,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
>
>         /* Add guest time to cpustat. */
>         if (TASK_NICE(p) > 0) {
> -               cpustat[CPUTIME_NICE] += (__force u64) cputime;
> -               cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
> +               atomic64_add((__force u64) cputime, &cpustat[CPUTIME_NICE]);
> +               atomic64_add((__force u64) cputime, &cpustat[CPUTIME_GUEST_NICE]);

That too should be kcpustat_this_cpu_set(), or kcpustat_this_cpu_add()
FWIW. But we probably don't need the overhead of atomic_add() that
does a LOCK.
atomic_set(var, atomic_read(var) + delta) would be better. All we need
is that low/high parts of the 64 bits values are stored and read
without messing up altogether.

Thanks.
