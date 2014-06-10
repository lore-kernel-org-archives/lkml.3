Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaFJPrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:47:20 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38891 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaFJPrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:47:18 -0400
Message-ID: <53972883.7070707@gmail.com>
Date: Tue, 10 Jun 2014 08:47:15 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: dirk.brandewie@gmail.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] cpufreq: intel_pstate: Add debugfs file stats
References: <53962072.6010702@semaphore.gr>
In-Reply-To: <53962072.6010702@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 02:00 PM, Stratos Karafotis wrote:
> Add stats file in debugfs under driver's parent directory
> (pstate_snb) which counts the time in nsecs per requested
> P state and the number of times the specific state
> was requested.
>
> The file presents the statistics per logical CPU in the
> following format. The time is displayed in msecs:
>

NAK

This adds significantly to the memory footprint to gather information
that is available by post processing the perf tracepoint information.
The increase isn't horrible on single socket desktop processor machines
but gets big with server class machines.  One vendor I have talked to considers
a machine with 1024 cpus to be a SMALL machine.


> CPU0
> P-state        Time     Count
>       16     4882777     23632
>       17       21210       174
>       18      549781      3300
>       19       51171       461
>       20       35487       394
>       21       18173       219
>       22       13752       258
>       23        6048       172
>       24        7754       177
>       25        4587       151
>       26        5465       162
>       27        1432        47
>       28         863        54
>       29        1448        50
>       30        1030        47
>       31        1472        62
>       32        2221        68
>       33        1869        60
>       34        2140        70
>       39       85446      3803
>
> ...
>
> The file can be used for debugging but also for monitoring
> various system workloads.
>
> Also, make the debugfs_parent local as we never remove
> the driver's debugfs files.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>   drivers/cpufreq/intel_pstate.c | 80 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 79 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 31e2ae5..3a49269 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -86,6 +86,12 @@ struct _pid {
>   	int32_t last_err;
>   };
>
> +struct pstate_stat {
> +	int pstate;
> +	u64 time;
> +	u64 count;
> +};
> +
>   struct cpudata {
>   	int cpu;
>
> @@ -99,6 +105,7 @@ struct cpudata {
>   	u64	prev_aperf;
>   	u64	prev_mperf;
>   	struct sample sample;
> +	struct pstate_stat *stats;
>   };
>
>   static struct cpudata **all_cpu_data;
> @@ -256,9 +263,59 @@ static struct pid_param pid_files[] = {
>   	{NULL, NULL}
>   };
>
> -static struct dentry *debugfs_parent;
> +static inline unsigned int stats_state_index(struct cpudata *cpu, int pstate)
> +{
> +	if (pstate <= cpu->pstate.max_pstate)
> +		return pstate - cpu->pstate.min_pstate;
> +	else
> +		return cpu->pstate.max_pstate - cpu->pstate.min_pstate + 1;
> +}
> +
> +static int stats_debug_show(struct seq_file *m, void *unused)
> +{
> +	struct cpudata *cpu;
> +	int i, j, cnt;
> +
> +	get_online_cpus();
> +	for_each_online_cpu(i) {
> +		if (all_cpu_data[i])
> +			cpu = all_cpu_data[i];
> +		else
> +			continue;
> +
> +		seq_printf(m, "CPU%u\n", i);
> +		seq_puts(m, "P-state        Time     Count\n");
> +
> +		cnt = cpu->pstate.max_pstate - cpu->pstate.min_pstate + 2;
> +		for (j = 0; j < cnt; j++)
> +			seq_printf(m, "%7u %11llu %9llu\n",
> +				   cpu->stats[j].pstate,
> +				   cpu->stats[j].time / USEC_PER_MSEC,
> +				   cpu->stats[j].count);
> +
> +		seq_puts(m, "\n");
> +	}
> +	put_online_cpus();
> +
> +	return 0;
> +}
> +
> +static int stats_debug_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, stats_debug_show, inode->i_private);
> +}
> +
> +static const struct file_operations fops_stats_pstate = {
> +	.open		= stats_debug_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +	.owner		= THIS_MODULE,
> +};
> +
>   static void intel_pstate_debug_expose_params(void)
>   {
> +	struct dentry *debugfs_parent;
>   	int i = 0;
>
>   	debugfs_parent = debugfs_create_dir("pstate_snb", NULL);
> @@ -270,6 +327,8 @@ static void intel_pstate_debug_expose_params(void)
>   				&fops_pid_param);
>   		i++;
>   	}
> +	debugfs_create_file("stats", S_IRUSR | S_IRGRP, debugfs_parent, NULL,
> +			    &fops_stats_pstate);
>   }
>
>   /************************** debugfs end ************************/
> @@ -610,6 +669,7 @@ static inline void intel_pstate_calc_scaled_busy(struct cpudata *cpu)
>   	int32_t core_busy, max_pstate, current_pstate, sample_ratio;
>   	u32 duration_us;
>   	u32 sample_time;
> +	unsigned int i;
>
>   	core_busy = cpu->sample.core_pct_busy;
>   	max_pstate = int_tofp(cpu->pstate.max_pstate);
> @@ -626,6 +686,10 @@ static inline void intel_pstate_calc_scaled_busy(struct cpudata *cpu)
>   	}
>
>   	cpu->sample.busy_scaled = core_busy;
> +
> +	i = stats_state_index(cpu, cpu->pstate.current_pstate);
> +	cpu->stats[i].time += duration_us;
> +	cpu->stats[i].count++;
>   }
>
>   static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
> @@ -692,6 +756,7 @@ MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
>   static int intel_pstate_init_cpu(unsigned int cpunum)
>   {
>   	struct cpudata *cpu;
> +	unsigned int i, cnt;
>
>   	all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
>   	if (!all_cpu_data[cpunum])
> @@ -701,6 +766,17 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
>
>   	intel_pstate_get_cpu_pstates(cpu);
>
> +	/* cnt equals to number of p-states + 1 (for turbo p-state) */
> +	cnt = cpu->pstate.max_pstate - cpu->pstate.min_pstate + 2;
> +	cpu->stats = kzalloc(sizeof(*cpu->stats) * cnt, GFP_KERNEL);
> +	if (!cpu->stats) {
> +		kfree(all_cpu_data[cpunum]);
> +		return -ENOMEM;
> +	}
> +	for (i = 0; i < cnt - 1; i++)
> +		cpu->stats[i].pstate = cpu->pstate.min_pstate + i;
> +	cpu->stats[cnt - 1].pstate = cpu->pstate.turbo_pstate;
> +
>   	cpu->cpu = cpunum;
>
>   	init_timer_deferrable(&cpu->timer);
> @@ -779,6 +855,7 @@ static void intel_pstate_stop_cpu(struct cpufreq_policy *policy)
>
>   	del_timer_sync(&all_cpu_data[cpu_num]->timer);
>   	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
> +	kfree(all_cpu_data[cpu_num]->stats);
>   	kfree(all_cpu_data[cpu_num]);
>   	all_cpu_data[cpu_num] = NULL;
>   }
> @@ -980,6 +1057,7 @@ out:
>   	for_each_online_cpu(cpu) {
>   		if (all_cpu_data[cpu]) {
>   			del_timer_sync(&all_cpu_data[cpu]->timer);
> +			kfree(all_cpu_data[cpu]->stats);
>   			kfree(all_cpu_data[cpu]);
>   		}
>   	}
>

