Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3F1ISH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:18:07 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34085 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab3F1ISD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:18:03 -0400
MIME-Version: 1.0
In-Reply-To: <1372405697-13556-1-git-send-email-cw00.choi@samsung.com>
References: <1372405697-13556-1-git-send-email-cw00.choi@samsung.com>
Date: Fri, 28 Jun 2013 13:48:01 +0530
Message-ID: <CAKohpon6AaSRQKvffPG+J=NUU+5JdVhFo-_uMm=2H3u-yT5h0A@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 June 2013 13:18, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
> 175320          1400000      1400000   41   47    0   79

We decided to left indent all entries here. I see only the first one
like this. What about others?

> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index dc9b72e..a13bdf9 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -87,6 +87,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>         struct od_dbs_tuners *od_tuners = dbs_data->tuners;
>         struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
>         struct cpufreq_policy *policy;

A simple solution to your problem can be

> +#ifdef CONFIG_CPU_FREQ_STAT
> +       struct cpufreq_freqs freq;

struct cpufreq_freqs freq = {0};

> +#endif
>         unsigned int max_load = 0;
>         unsigned int ignore_nice;
>         unsigned int j;
> @@ -148,6 +151,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>                         continue;
>
>                 load = 100 * (wall_time - idle_time) / wall_time;
> +#ifdef CONFIG_CPU_FREQ_STAT
> +               freq.load[j] = load;
> +#endif
>
>                 if (dbs_data->cdata->governor == GOV_ONDEMAND) {
>                         int freq_avg = __cpufreq_driver_getavg(policy, j);
> @@ -161,6 +167,15 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>                         max_load = load;
>         }
>
> +#ifdef CONFIG_CPU_FREQ_STAT
> +       for_each_cpu_not(j, policy->cpus)
> +               freq.load[j] = 0;

and remove this.

> +       freq.time = ktime_to_ms(ktime_get());
> +       freq.old = policy->cur;
> +
> +       cpufreq_notify_transition(policy, &freq, CPUFREQ_LOADCHECK);
> +#endif

If I remember well you had another instance where you were setting
load as zero when wall time is less than idle time?

>         dbs_data->cdata->gov_check_cpu(cpu, max_load);
>  }
>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c

> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
> +{

> +       /* Create debugfs directory and file for cpufreq */
> +       sprintf(buf, "cpu%d", policy->cpu);
> +       stat->debugfs_cpu = debugfs_create_dir(buf, debugfs_cpufreq);
> +       if (!stat->debugfs_cpu) {
> +               ret = -ENOMEM;
> +               goto err_alloc;
> +       }
> +
> +       if (!debugfs_create_file("load_table", S_IWUSR, stat->debugfs_cpu,
> +                               policy, &load_table_fops)) {
> +               ret = -ENOMEM;
> +               goto err_debugfs;
> +       }
> +
> +       return 0;
> +
> +err_debugfs:
> +       debugfs_remove_recursive(stat->debugfs_cpu);
> +err_alloc:
> +       kfree(stat->load_table);
> +err:
> +       return ret;
> +}

Can you describe a bit about the layout this will create in debugfs?
I thought you will have a load_table file per policy->cpu ??

Like: /sys/kernel/debug/cpufreq/cpu0/load_table

Now in the show table function you are doing for_each_present_cpu()
which may contain more cpus than are present in policy. Right?

Probably you need to do, for_each_cpu(cpu, policy->cpus)..

Also what will happen when governor isn't ondemand/conservative?
We will still try to create this table? What will be present inside it?
