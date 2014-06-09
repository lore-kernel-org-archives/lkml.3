Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaFIHHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 03:07:43 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37719 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaFIHHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 03:07:41 -0400
Message-ID: <53955CE0.1090408@linux.vnet.ibm.com>
Date: Mon, 09 Jun 2014 12:36:08 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        svaidy@linux.vnet.ibm.com, ego@linux.vnet.ibm.com, pavel@ucw.cz
Subject: Re: [PATCH] cpufreq: governor: remove copy_prev_load from 'struct
 cpu_dbs_common_info'
References: <d4241c6ef57c901dde270380cce74e24effa4852.1402291351.git.viresh.kumar@linaro.org>
In-Reply-To: <d4241c6ef57c901dde270380cce74e24effa4852.1402291351.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060907-3568-0000-0000-000005A587D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 10:54 AM, Viresh Kumar wrote:
> 'copy_prev_load' was recently added by commit: 18b46ab (cpufreq: governor: Be
> friendly towards latency-sensitive bursty workloads).
> 
> It actually is a bit redundant as we also have 'prev_load' which can store any
> integer value and can be used instead of 'copy_prev_load' by setting it to zero
> when we don't want to use previous load.
> 
> So, drop 'copy_prev_load' and use 'prev_load' instead.

Well, to be honest, I'm not a great fan of writing tricky code (i.e.,
overloading multiple semantics onto one single thing). However, in this case,
it does save a bool for every CPU in the system, and this savings might be
worthwhile on some systems.

Perhaps you should also mention in the changelog that the true load can also
turn out to be zero during long idle intervals (and hence the actual value of
'prev_load' and the overloaded value can clash). However this is not a problem
because, if the true load was really zero in the previous interval, it makes
more sense to evaluate the load afresh for the current interval rather than
copying the previous load.

> 
> Update comments as well to make it more clear.
> 
> There is another change here which was probably missed by Srivatsa during the
> last version of updates he made. The unlikely in the 'if' statement was covering
> only half of the condition and the whole line should actually come under it.
> 

Well, I had thought about that too, but I felt that the second AND condition
was actually not that infrequent when compared to the first AND condition. And
the C language already guarantees that the second part won't be evaluated if
the first one turns out to be false. So I thought of making use of that and
hence wrapped only the first part within unlikely(), so that we can just
evaluate a subset of the 'if' condition most of the time. But anyway, your
version looks good too, so I don't mind.

> Also checkpatch is made more silent as it was reporting this (--strict option):
> 
> CHECK: Alignment should match open parenthesis
> +		if (unlikely(wall_time > (2 * sampling_rate) &&
> +						j_cdbs->prev_load)) {

Sure, this one is a welcome cleanup, thanks!

> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq_governor.c | 13 ++++++++-----
>  drivers/cpufreq/cpufreq_governor.h |  8 ++++----
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 9004450..a1ad804 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -132,14 +132,18 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  		 * an unusually large 'wall_time' (as compared to the sampling
>  		 * rate) indicates this scenario.
>  		 */
> -		if (unlikely(wall_time > (2 * sampling_rate)) &&
> -						j_cdbs->copy_prev_load) {
> +		if (unlikely(wall_time > (2 * sampling_rate) &&
> +			     j_cdbs->prev_load)) {
>  			load = j_cdbs->prev_load;
> -			j_cdbs->copy_prev_load = false;
> +
> +			/*
> +			 * Ensure that we copy the previous load only once, upon
> +			 * the first wake-up from idle.
> +			 */

Can you also add the term 'destructive copy' to the comment, while you are at it?
Because, that term (which means that we destroy the source during a copy) explains
the situation very aptly. Something like this:

Perform a destructive copy, to ensure that we copy the previous load only once,
upon the first wake-up from idle.

> +			j_cdbs->prev_load = 0;
>  		} else {
>  			load = 100 * (wall_time - idle_time) / wall_time;
>  			j_cdbs->prev_load = load;
> -			j_cdbs->copy_prev_load = true;
>  		}
> 
>  		if (load > max_load)
> @@ -373,7 +377,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  				(j_cdbs->prev_cpu_wall - j_cdbs->prev_cpu_idle);
>  			j_cdbs->prev_load = 100 * prev_load /
>  					(unsigned int) j_cdbs->prev_cpu_wall;
> -			j_cdbs->copy_prev_load = true;
> 
>  			if (ignore_nice)
>  				j_cdbs->prev_cpu_nice =
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index c2a5b7e..d3082ee 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -134,12 +134,12 @@ struct cpu_dbs_common_info {
>  	u64 prev_cpu_idle;
>  	u64 prev_cpu_wall;
>  	u64 prev_cpu_nice;
> -	unsigned int prev_load;
>  	/*
> -	 * Flag to ensure that we copy the previous load only once, upon the
> -	 * first wake-up from idle.
> +	 * Used to store system load before going into idle, when set to zero:
> +	 * used as a flag to ensure that we copy the previous load only once,
> +	 * upon the first wake-up from idle.

Perhaps a bit of a touch-up to the comment would be worthwhile. Something
like this:

Used to keep track of the load in the previous interval. However, when
explicitly set to zero, it is used as a flag to ensure that we copy the
previous load to the current interval only once, upon the first wake-up
from idle.

>  	 */
> -	bool copy_prev_load;
> +	unsigned int prev_load;
>  	struct cpufreq_policy *cur_policy;
>  	struct delayed_work work;
>  	/*
> 

Thank you!

Regards,
Srivatsa S. Bhat

