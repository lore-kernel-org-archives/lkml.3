Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbaIEHw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:52:59 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50137 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaIEHw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:52:57 -0400
Message-ID: <54096BD5.4030803@linaro.org>
Date: Fri, 05 Sep 2014 09:52:53 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 2/2] sched/fair: leverage the idle state info when
 choosing the "idlest" cpu
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org> <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
In-Reply-To: <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 05:32 PM, Nicolas Pitre wrote:
> The code in find_idlest_cpu() looks for the CPU with the smallest load.
> However, if multiple CPUs are idle, the first idle CPU is selected
> irrespective of the depth of its idle state.
>
> Among the idle CPUs we should pick the one with with the shallowest idle
> state, or the latest to have gone idle if all idle CPUs are in the same
> state.  The later applies even when cpuidle is configured out.
>
> This patch doesn't cover the following issues:
>
> - The idle exit latency of a CPU might be larger than the time needed
>    to migrate the waking task to an already running CPU with sufficient
>    capacity, and therefore performance would benefit from task packing
>    in such case (in most cases task packing is about power saving).
>
> - Some idle states have a non negligible and non abortable entry latency
>    which needs to run to completion before the exit latency can start.
>    A concurrent patch series is making this info available to the cpuidle
>    core.  Once available, the entry latency with the idle timestamp could
>    determine when the exit latency may be effective.
>
> Those issues will be handled in due course.  In the mean time, what
> is implemented here should improve things already compared to the current
> state of affairs.
>
> Based on an initial patch from Daniel Lezcano.
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Sounds good for me.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   kernel/sched/fair.c | 43 ++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 36 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bfa3c86d0d..416329e1a6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -23,6 +23,7 @@
>   #include <linux/latencytop.h>
>   #include <linux/sched.h>
>   #include <linux/cpumask.h>
> +#include <linux/cpuidle.h>
>   #include <linux/slab.h>
>   #include <linux/profile.h>
>   #include <linux/interrupt.h>
> @@ -4428,20 +4429,48 @@ static int
>   find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>   {
>   	unsigned long load, min_load = ULONG_MAX;
> -	int idlest = -1;
> +	unsigned int min_exit_latency = UINT_MAX;
> +	u64 latest_idle_timestamp = 0;
> +	int least_loaded_cpu = this_cpu;
> +	int shallowest_idle_cpu = -1;
>   	int i;
>
>   	/* Traverse only the allowed CPUs */
>   	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
> -		load = weighted_cpuload(i);
> -
> -		if (load < min_load || (load == min_load && i == this_cpu)) {
> -			min_load = load;
> -			idlest = i;
> +		if (idle_cpu(i)) {
> +			struct rq *rq = cpu_rq(i);
> +			struct cpuidle_state *idle = idle_get_state(rq);
> +			if (idle && idle->exit_latency < min_exit_latency) {
> +				/*
> +				 * We give priority to a CPU whose idle state
> +				 * has the smallest exit latency irrespective
> +				 * of any idle timestamp.
> +				 */
> +				min_exit_latency = idle->exit_latency;
> +				latest_idle_timestamp = rq->idle_stamp;
> +				shallowest_idle_cpu = i;
> +			} else if ((!idle || idle->exit_latency == min_exit_latency) &&
> +				   rq->idle_stamp > latest_idle_timestamp) {
> +				/*
> +				 * If equal or no active idle state, then
> +				 * the most recently idled CPU might have
> +				 * a warmer cache.
> +				 */
> +				latest_idle_timestamp = rq->idle_stamp;
> +				shallowest_idle_cpu = i;
> +			}
> +			cpuidle_put_state(rq);
> +		} else {
> +			load = weighted_cpuload(i);
> +			if (load < min_load ||
> +			    (load == min_load && i == this_cpu)) {
> +				min_load = load;
> +				least_loaded_cpu = i;
> +			}
>   		}
>   	}
>
> -	return idlest;
> +	return shallowest_idle_cpu != -1 ? shallowest_idle_cpu : least_loaded_cpu;
>   }
>
>   /*
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

