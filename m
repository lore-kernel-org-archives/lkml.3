Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3GVLFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:05:45 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50033 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab3GVLFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:05:43 -0400
MIME-Version: 1.0
In-Reply-To: <1374146275-5758-3-git-send-email-cw00.choi@samsung.com>
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
	<1374146275-5758-3-git-send-email-cw00.choi@samsung.com>
Date: Mon, 22 Jul 2013 16:35:42 +0530
Message-ID: <CAKohponVEJv9e9V5qz+iugSMzu1zp1BeFf58W8m0qAV3_m6U1w@mail.gmail.com>
Subject: Re: [PATCH 2/3 v6] cpufreq: stats: Add 'load_table' debugfs file to
 show accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 July 2013 16:47, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c

> +static int cpufreq_stats_reset_debugfs(struct cpufreq_policy *policy)
> +{
> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
> +       int size;
> +
> +       if (!stat)
> +               return -EINVAL;
> +
> +       if (stat->load_table)
> +               kfree(stat->load_table);
> +       stat->load_last_index = 0;
> +
> +       size = sizeof(*stat->load_table) * stat->load_max_index;
> +       stat->load_table = kzalloc(size, GFP_KERNEL);
> +       if (!stat->load_table)
> +               return -ENOMEM;

Why are you freeing memory and allocating it again ??

> +       return 0;
> +}
> +
> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
> +{
> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
> +       unsigned int idx, size;
> +       int ret = 0;
> +
> +       if (!stat)
> +               return -EINVAL;
> +
> +       if (!policy->cpu_debugfs)
> +               return -EINVAL;
> +
> +       stat->load_last_index = 0;
> +       stat->load_max_index = CONFIG_NR_CPU_LOAD_STORAGE;
> +
> +       /* Allocate memory for storage of CPUs load */
> +       size = sizeof(*stat->load_table) * stat->load_max_index;
> +       stat->load_table = kzalloc(size, GFP_KERNEL);
> +       if (!stat->load_table)
> +               return -ENOMEM;
> +
> +       /* Create debugfs directory and file for cpufreq */
> +       idx = cpumask_weight(policy->cpus) > 1 ? policy->cpu : 0;

idx is broken again..

> +       stat->debugfs_load_table = debugfs_create_file("load_table", S_IWUSR,
> +                                       policy->cpu_debugfs[idx],
> +                                       policy, &load_table_fops);
> +       if (!stat->debugfs_load_table) {
> +               ret = -ENOMEM;
> +               goto err;
> +       }
> +
> +       pr_debug("Creating debugfs file for CPU%d \n", policy->cpu);

s/Creating/Created

> +
> +       return 0;
> +err:
> +       kfree(stat->load_table);
> +       return ret;
> +}
> +
> +/* should be called late in the CPU removal sequence so that the stats
> + * memory is still available in case someone tries to use it.
> + */

Please write multiline comment correctly..

> +static void cpufreq_stats_free_load_table(unsigned int cpu)
> +{
> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
> +
> +       if (stat) {
> +               pr_debug("Free memory of load_table\n");
> +               kfree(stat->load_table);
> +       }
> +}
> +
> +/* must be called early in the CPU removal sequence (before
> + * cpufreq_remove_dev) so that policy is still valid.
> + */
> +static void cpufreq_stats_free_debugfs(unsigned int cpu)
> +{
> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
> +
> +       if (stat) {
> +               pr_debug("Remove load_table debugfs file\n");
> +               debugfs_remove(stat->debugfs_load_table);
> +       }
> +}
> +
> +static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq,
> +                                          unsigned long val)
> +{
> +       struct cpufreq_stats *stat;
> +       int cpu, last_idx;
> +
> +       stat = per_cpu(cpufreq_stats_table, freq->cpu);
> +       if (!stat)
> +               return;
> +
> +       spin_lock(&cpufreq_stats_lock);
> +
> +       switch (val) {
> +       case CPUFREQ_POSTCHANGE:
> +               if (!stat->load_last_index)
> +                       last_idx = stat->load_max_index;
> +               else
> +                       last_idx = stat->load_last_index - 1;
> +
> +               stat->load_table[last_idx].new = freq->new;
> +               break;
> +       case CPUFREQ_LOADCHECK:
> +               last_idx = stat->load_last_index;
> +
> +               stat->load_table[last_idx].time = freq->time;
> +               stat->load_table[last_idx].old = freq->old;
> +               stat->load_table[last_idx].new = freq->old;
> +               for_each_present_cpu(cpu)
> +                       stat->load_table[last_idx].load[cpu] = freq->load[cpu];
> +
> +               if (++stat->load_last_index == stat->load_max_index)
> +                       stat->load_last_index = 0;
> +               break;
> +       }
> +
> +       spin_unlock(&cpufreq_stats_lock);
> +}
> +
>  static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
>  {
>         int index;
> @@ -204,7 +386,7 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
>         unsigned int alloc_size;
>         unsigned int cpu = policy->cpu;
>         if (per_cpu(cpufreq_stats_table, cpu))
> -               return -EBUSY;
> +               return 0;
>         stat = kzalloc(sizeof(struct cpufreq_stats), GFP_KERNEL);
>         if ((stat) == NULL)
>                 return -ENOMEM;
> @@ -257,6 +439,14 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
>         spin_lock(&cpufreq_stats_lock);
>         stat->last_time = get_jiffies_64();
>         stat->last_index = freq_table_get_index(stat, policy->cur);
> +
> +       ret = cpufreq_stats_create_debugfs(data);
> +       if (ret < 0) {
> +               spin_unlock(&cpufreq_stats_lock);
> +               ret = -EINVAL;
> +               goto error_out;
> +       }
> +
>         spin_unlock(&cpufreq_stats_lock);
>         cpufreq_cpu_put(data);
>         return 0;
> @@ -297,11 +487,18 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
>         if (val != CPUFREQ_NOTIFY)
>                 return 0;
>         table = cpufreq_frequency_get_table(cpu);
> -       if (!table)
> -               return 0;
> -       ret = cpufreq_stats_create_table(policy, table);
> -       if (ret)
> +       if (table) {
> +               ret = cpufreq_stats_create_table(policy, table);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       ret = cpufreq_stats_reset_debugfs(policy);

Why?

> +       if (ret < 0) {
> +               pr_debug("Failed to reset CPUs data of debugfs\n");
>                 return ret;
> +       }
> +
>         return 0;
>  }
