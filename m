Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbaIIPPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:15:18 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62851 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbaIIPPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:15:16 -0400
Message-ID: <540F1981.1090805@gmail.com>
Date: Tue, 09 Sep 2014 08:15:13 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Anup Chenthamarakshan <anupc@chromium.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: dirk.brandewie@gmail.com, Sameer Nanda <snanda@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats
 via sysfs.
References: <1410221424-20590-1-git-send-email-anupc@chromium.org>
In-Reply-To: <1410221424-20590-1-git-send-email-anupc@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 05:10 PM, Anup Chenthamarakshan wrote:
> Exported stats appear in
> <sysfs>/devices/system/cpu/intel_pstate/time_in_state as follows:
> 
> ## CPU 0
> 400000 3647
> 500000 24342
> 600000 144150
> 700000 202469
> ## CPU 1
> 400000 4813
> 500000 22628
> 600000 149564
> 700000 211885
> 800000 173890
> 
> Signed-off-by: Anup Chenthamarakshan <anupc@chromium.org>

What is this information being used for?

Tracking the current P state request for each core is only part of the 
story.  The processor aggregates the requests from all cores and then decides
what frequency the package will run at, this evaluation happens at ~1ms time
frame.  If a core is idle then it loses its vote for that package frequency will
be and its frequency will be zero even though it may have been requesting
a high P state when it went idle.  Tracking the residency of the requested
P state doesn't provide much useful information other than ensuring the the 
requests are changing over time IMHO.

This interface will not be supportable with upcoming processors using
hardware P states as documented in volume 3 of the current SDM Section 14.4
http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf
The OS will have no way of knowing what the P state requests are for a
given core are.

--Dirk 
> ---
>   drivers/cpufreq/intel_pstate.c | 77 ++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 74 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 0668b38..7be89bd 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -84,6 +84,11 @@ struct _pid {
>   	int32_t last_err;
>   };
>   
> +struct pstate_stat {
> +	int pstate;
> +	u64 time;
> +};
> +
>   struct cpudata {
>   	int cpu;
>   
> @@ -97,6 +102,9 @@ struct cpudata {
>   	u64	prev_aperf;
>   	u64	prev_mperf;
>   	struct sample sample;
> +
> +	struct pstate_stat *stat;
> +	u64	last_updated;
>   };
>   
>   static struct cpudata **all_cpu_data;
> @@ -218,6 +226,18 @@ static inline void intel_pstate_reset_all_pid(void)
>   	}
>   }
>   
> +static void intel_pstate_account_time_to_current_pstate(struct cpudata *cpu)
> +{
> +	/* Handle the initial call from intel_pstate_init_cpu */
> +	if (likely(cpu->stat)) {
> +		u64 now = jiffies;
> +		int index = cpu->pstate.current_pstate - cpu->pstate.min_pstate;
> +
> +		cpu->stat[index].time += now - cpu->last_updated;
> +		cpu->last_updated = now;
> +	}
> +}
> +
>   /************************** debugfs begin ************************/
>   static int pid_param_set(void *data, u64 val)
>   {
> @@ -323,6 +343,40 @@ static ssize_t store_min_perf_pct(struct kobject *a, struct attribute *b,
>   	return count;
>   }
>   
> +static ssize_t show_time_in_state(struct kobject *kobj, struct attribute *attr,
> +				char *buf)
> +{
> +	unsigned int cpu;
> +	struct cpudata *cpudata;
> +	int i, len = 0, total_states;
> +
> +	for_each_online_cpu(cpu) {
> +		if (!all_cpu_data[cpu])
> +			continue;
> +
> +		cpudata = all_cpu_data[cpu];
> +		len += snprintf(buf + len, PAGE_SIZE - len, "## CPU %d\n", cpu);
> +		if (len >= PAGE_SIZE)
> +			return len;
> +
> +		total_states = cpudata->pstate.turbo_pstate -
> +			cpudata->pstate.min_pstate + 1;
> +
> +		intel_pstate_account_time_to_current_pstate(cpudata);
> +
> +		for (i = 0; i < total_states; i++) {
> +			len += snprintf(buf + len, PAGE_SIZE - len, "%d %llu\n",
> +					cpudata->stat[i].pstate * 100000,
> +					cpudata->stat[i].time);
> +
> +			if (len >= PAGE_SIZE)
> +				return len;
> +		}
> +	}
> +
> +	return len;
> +}
> +
>   show_one(no_turbo, no_turbo);
>   show_one(max_perf_pct, max_perf_pct);
>   show_one(min_perf_pct, min_perf_pct);
> @@ -331,10 +385,13 @@ define_one_global_rw(no_turbo);
>   define_one_global_rw(max_perf_pct);
>   define_one_global_rw(min_perf_pct);
>   
> +define_one_global_ro(time_in_state);
> +
>   static struct attribute *intel_pstate_attributes[] = {
>   	&no_turbo.attr,
>   	&max_perf_pct.attr,
>   	&min_perf_pct.attr,
> +	&time_in_state.attr,
>   	NULL
>   };
>   
> @@ -525,9 +582,11 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
>   
>   	trace_cpu_frequency(pstate * 100000, cpu->cpu);
>   
> -	cpu->pstate.current_pstate = pstate;
> -
>   	pstate_funcs.set(cpu, pstate);
> +
> +	intel_pstate_account_time_to_current_pstate(cpu);
> +
> +	cpu->pstate.current_pstate = pstate;
>   }
>   
>   static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
> @@ -751,6 +810,7 @@ static void intel_pstate_stop_cpu(struct cpufreq_policy *policy)
>   
>   	del_timer_sync(&all_cpu_data[cpu_num]->timer);
>   	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
> +	kfree(all_cpu_data[cpu_num]->stat);
>   	kfree(all_cpu_data[cpu_num]);
>   	all_cpu_data[cpu_num] = NULL;
>   }
> @@ -758,7 +818,7 @@ static void intel_pstate_stop_cpu(struct cpufreq_policy *policy)
>   static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
>   {
>   	struct cpudata *cpu;
> -	int rc;
> +	int rc, i, total_states;
>   	u64 misc_en;
>   
>   	rc = intel_pstate_init_cpu(policy->cpu);
> @@ -787,6 +847,16 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
>   	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
>   	cpumask_set_cpu(policy->cpu, policy->cpus);
>   
> +	total_states = cpu->pstate.turbo_pstate - cpu->pstate.min_pstate + 1;
> +	cpu->stat = kcalloc(total_states, sizeof(struct pstate_stat),
> +			GFP_KERNEL);
> +
> +	if (cpu->stat)
> +		for (i = 0; i < total_states; i++)
> +			cpu->stat[i].pstate = i + cpu->pstate.min_pstate;
> +
> +	cpu->last_updated = get_jiffies_64();
> +
>   	return 0;
>   }
>   
> @@ -958,6 +1028,7 @@ out:
>   	for_each_online_cpu(cpu) {
>   		if (all_cpu_data[cpu]) {
>   			del_timer_sync(&all_cpu_data[cpu]->timer);
> +			kfree(all_cpu_data[cpu]->stat);
>   			kfree(all_cpu_data[cpu]);
>   		}
>   	}
> 

