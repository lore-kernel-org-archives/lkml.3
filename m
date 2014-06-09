Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbaFIJMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:12:46 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50913 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429AbaFIJMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:12:43 -0400
Message-ID: <53957A30.4030003@linux.vnet.ibm.com>
Date: Mon, 09 Jun 2014 14:41:12 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        svaidy@linux.vnet.ibm.com, ego@linux.vnet.ibm.com, pavel@ucw.cz
Subject: Re: [PATCH Resend] cpufreq: governor: remove copy_prev_load from
 'struct cpu_dbs_common_info'
References: <c7add1b66e706fc52c493f765d0ddfc8c83f3b2e.1402303829.git.viresh.kumar@linaro.org>
In-Reply-To: <c7add1b66e706fc52c493f765d0ddfc8c83f3b2e.1402303829.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060909-7014-0000-0000-000005094108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 02:21 PM, Viresh Kumar wrote:
> 'copy_prev_load' was recently added by commit: 18b46ab (cpufreq: governor: Be
> friendly towards latency-sensitive bursty workloads).
> 
> It actually is a bit redundant as we also have 'prev_load' which can store any
> integer value and can be used instead of 'copy_prev_load' by setting it zero.
> 
> True load can also turn out to be zero during long idle intervals (and hence the
> actual value of 'prev_load' and the overloaded value can clash). However this is
> not a problem because, if the true load was really zero in the previous
> interval, it makes sense to evaluate the load afresh for the current interval
> rather than copying the previous load.
> 
> So, drop 'copy_prev_load' and use 'prev_load' instead.
> 
> Update comments as well to make it more clear.
> 
> There is another change here which was probably missed by Srivatsa during the
> last version of updates he made. The unlikely in the 'if' statement was covering
> only half of the condition and the whole line should actually come under it.
> 
> Also checkpatch is made more silent as it was reporting this (--strict option):
> 
> CHECK: Alignment should match open parenthesis
> +		if (unlikely(wall_time > (2 * sampling_rate) &&
> +						j_cdbs->prev_load)) {
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Resend: Updated comments/logs as suggested by Srivatsa.
> 

Looks good!

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  drivers/cpufreq/cpufreq_governor.c | 19 ++++++++++++++-----
>  drivers/cpufreq/cpufreq_governor.h |  9 +++++----
>  2 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 9004450..1b44496 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -131,15 +131,25 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  		 * timer would not have fired during CPU-idle periods. Hence
>  		 * an unusually large 'wall_time' (as compared to the sampling
>  		 * rate) indicates this scenario.
> +		 *
> +		 * prev_load can be zero in two cases and we must recalculate it
> +		 * for both cases:
> +		 * - during long idle intervals
> +		 * - explicitly set to zero
>  		 */
> -		if (unlikely(wall_time > (2 * sampling_rate)) &&
> -						j_cdbs->copy_prev_load) {
> +		if (unlikely(wall_time > (2 * sampling_rate) &&
> +			     j_cdbs->prev_load)) {
>  			load = j_cdbs->prev_load;
> -			j_cdbs->copy_prev_load = false;
> +
> +			/*
> +			 * Perform a destructive copy, to ensure that we copy
> +			 * the previous load only once, upon the first wake-up
> +			 * from idle.
> +			 */
> +			j_cdbs->prev_load = 0;
>  		} else {
>  			load = 100 * (wall_time - idle_time) / wall_time;
>  			j_cdbs->prev_load = load;
> -			j_cdbs->copy_prev_load = true;
>  		}
> 
>  		if (load > max_load)
> @@ -373,7 +383,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  				(j_cdbs->prev_cpu_wall - j_cdbs->prev_cpu_idle);
>  			j_cdbs->prev_load = 100 * prev_load /
>  					(unsigned int) j_cdbs->prev_cpu_wall;
> -			j_cdbs->copy_prev_load = true;
> 
>  			if (ignore_nice)
>  				j_cdbs->prev_cpu_nice =
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index c2a5b7e..cc401d1 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -134,12 +134,13 @@ struct cpu_dbs_common_info {
>  	u64 prev_cpu_idle;
>  	u64 prev_cpu_wall;
>  	u64 prev_cpu_nice;
> -	unsigned int prev_load;
>  	/*
> -	 * Flag to ensure that we copy the previous load only once, upon the
> -	 * first wake-up from idle.
> +	 * Used to keep track of load in the previous interval. However, when
> +	 * explicitly set to zero, it is used as a flag to ensure that we copy
> +	 * the previous load to the current interval only once, upon the first
> +	 * wake-up from idle.
>  	 */
> -	bool copy_prev_load;
> +	unsigned int prev_load;
>  	struct cpufreq_policy *cur_policy;
>  	struct delayed_work work;
>  	/*
> 

