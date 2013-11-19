Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3KSImZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:42:25 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:45853 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833Ab3KSImY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:42:24 -0500
Message-ID: <1384850540.3381.6.camel@linaro1.home>
Subject: Re: [PATCH] cpufreq/stats: Add "unknown" frequency field in stats
 tables
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, nm@ti.com, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org, ceh@ti.com
Date: Tue, 19 Nov 2013 08:42:20 +0000
In-Reply-To: <b0a2e5d26be45d1d2853940d318d50415db48f6f.1384839287.git.viresh.kumar@linaro.org>
References: <b0a2e5d26be45d1d2853940d318d50415db48f6f.1384839287.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 11:10 +0530, Viresh Kumar wrote:
> commit 46a310b ([CPUFREQ] Don't set stat->last_index to -1 if the pol->cur has
> incorrect value.) tries to handle case where policy->cur does not match any
> entry in freq_table.
> 
> As indicated in the above commit, the exact match search of freq_table_get index
> will return a -1 which is stored in stat->last_index. However, as a result of
> the above commit, cpufreq_stat_notifier_trans which updates the statistics,
> fails to update any *further* valid transitions that take place as
> stat->last_index is -1 as the condition occurs at boot and never solved.
> 
> To fix this issue, lets create another entry for time_in_state and trans_table
> that will tell the user that CPU was running on unknown frequency for some time.
> 
> This is how the output looks like on my thinkpad (Removed some entries to keep
> it simple):
> 
> 	$ cat /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state 
> 	2800000 46
> 	2600000 138
> 	1200000 65
> 	1000000 152
> 	800000 34803
> 	unknown 0

I'm wondering if this would break any user-side code parsing this output
and does that matter? (E.g. powertop will end up doing strtoull on
"unknown" and get zero as the frequency.)  Would omitting 'unknown' if
the time is zero be safer in this repect? Possibly not, inconsistency is
probably worse than change.

-- 
Tixy

> 	$ cat /sys/devices/system/cpu/cpu0/cpufreq/stats/trans_table 
> 	   From  :    To
> 	         :   2801000   2800000   2600000   2400000   2200000   2000000   unknown 
> 	  2801000:         0        15        20         9        13        17         0 
> 	  2800000:        13         0         4         1         0         1         0 
> 	  2600000:        26         1         0         5         1         1         0 
> 	  2400000:        11         0         6         0         1         1         0 
> 	  2200000:         8         1         5         3         0         0         0 
> 	  2000000:        11         1         2         1         2         0         0 
> 	  unknown:         0         0         0         0         0         0         0 
> 
> Reported-by: Carlos Hernandez <ceh@ti.com>
> Reported-and-tested-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq_stats.c | 45 ++++++++++++++++++++++++++++-------------
>  1 file changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index 4cf0d28..ebb21cd 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -72,9 +72,13 @@ static ssize_t show_time_in_state(struct cpufreq_policy *policy, char *buf)
>  		return 0;
>  	cpufreq_stats_update(stat->cpu);
>  	for (i = 0; i < stat->state_num; i++) {
> -		len += sprintf(buf + len, "%u %llu\n", stat->freq_table[i],
> -			(unsigned long long)
> -			jiffies_64_to_clock_t(stat->time_in_state[i]));
> +		if (stat->freq_table[i] == -1)
> +			return sprintf(buf + len, "unknown");
> +		else
> +			return sprintf(buf + len, "%u", stat->freq_table[i]);
> +
> +		len += sprintf(buf + len, " %llu\n", (unsigned long long)
> +				jiffies_64_to_clock_t(stat->time_in_state[i]));
>  	}
>  	return len;
>  }
> @@ -94,8 +98,12 @@ static ssize_t show_trans_table(struct cpufreq_policy *policy, char *buf)
>  	for (i = 0; i < stat->state_num; i++) {
>  		if (len >= PAGE_SIZE)
>  			break;
> -		len += snprintf(buf + len, PAGE_SIZE - len, "%9u ",
> -				stat->freq_table[i]);
> +		if (stat->freq_table[i] == -1)
> +			len += snprintf(buf + len, PAGE_SIZE - len, "%9s ",
> +					"unknown");
> +		else
> +			len += snprintf(buf + len, PAGE_SIZE - len, "%9u ",
> +					stat->freq_table[i]);
>  	}
>  	if (len >= PAGE_SIZE)
>  		return PAGE_SIZE;
> @@ -106,8 +114,12 @@ static ssize_t show_trans_table(struct cpufreq_policy *policy, char *buf)
>  		if (len >= PAGE_SIZE)
>  			break;
>  
> -		len += snprintf(buf + len, PAGE_SIZE - len, "%9u: ",
> -				stat->freq_table[i]);
> +		if (stat->freq_table[i] == -1)
> +			len += snprintf(buf + len, PAGE_SIZE - len, "%9s: ",
> +					"unknown");
> +		else
> +			len += snprintf(buf + len, PAGE_SIZE - len, "%9u: ",
> +					stat->freq_table[i]);
>  
>  		for (j = 0; j < stat->state_num; j++) {
>  			if (len >= PAGE_SIZE)
> @@ -145,10 +157,12 @@ static struct attribute_group stats_attr_group = {
>  static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
>  {
>  	int index;
> -	for (index = 0; index < stat->max_state; index++)
> +	for (index = 0; index < stat->max_state - 1; index++)
>  		if (stat->freq_table[index] == freq)
>  			return index;
> -	return -1;
> +
> +	/* Last state is INVALID, to mark out of table frequency */
> +	return stat->max_state - 1;
>  }
>  
>  /* should be called late in the CPU removal sequence so that the stats
> @@ -222,6 +236,9 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
>  		count++;
>  	}
>  
> +	/* An extra entry for Invalid frequencies */
> +	count++;
> +
>  	alloc_size = count * sizeof(int) + count * sizeof(u64);
>  
>  #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> @@ -243,9 +260,13 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
>  		unsigned int freq = table[i].frequency;
>  		if (freq == CPUFREQ_ENTRY_INVALID)
>  			continue;
> -		if (freq_table_get_index(stat, freq) == -1)
> +		if (freq_table_get_index(stat, freq) == stat->max_state - 1)
>  			stat->freq_table[j++] = freq;
>  	}
> +
> +	/* Mark Invalid freq as max value to indicate Invalid freq */
> +	stat->freq_table[j++] = -1;
> +
>  	stat->state_num = j;
>  	spin_lock(&cpufreq_stats_lock);
>  	stat->last_time = get_jiffies_64();
> @@ -315,10 +336,6 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
>  	old_index = stat->last_index;
>  	new_index = freq_table_get_index(stat, freq->new);
>  
> -	/* We can't do stat->time_in_state[-1]= .. */
> -	if (old_index == -1 || new_index == -1)
> -		return 0;
> -
>  	cpufreq_stats_update(freq->cpu);
>  
>  	if (old_index == new_index)


