Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbaISPKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:10:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:41837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaISPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:10:09 -0400
Date: Fri, 19 Sep 2014 02:05:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 2/2] sched/fair: leverage the idle state info when
 choosing the "idlest" cpu
Message-ID: <20140919000545.GR2848@worktop.localdomain>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
 <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:32:10AM -0400, Nicolas Pitre wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bfa3c86d0d..416329e1a6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -23,6 +23,7 @@
>  #include <linux/latencytop.h>
>  #include <linux/sched.h>
>  #include <linux/cpumask.h>
> +#include <linux/cpuidle.h>
>  #include <linux/slab.h>
>  #include <linux/profile.h>
>  #include <linux/interrupt.h>
> @@ -4428,20 +4429,48 @@ static int
>  find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>  {
>  	unsigned long load, min_load = ULONG_MAX;
> -	int idlest = -1;
> +	unsigned int min_exit_latency = UINT_MAX;
> +	u64 latest_idle_timestamp = 0;
> +	int least_loaded_cpu = this_cpu;
> +	int shallowest_idle_cpu = -1;
>  	int i;
>  
>  	/* Traverse only the allowed CPUs */
>  	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
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

Right, matching the other changes, I killed that line. The rest looks
ok.

> +		} else {
> +			load = weighted_cpuload(i);
> +			if (load < min_load ||
> +			    (load == min_load && i == this_cpu)) {
> +				min_load = load;
> +				least_loaded_cpu = i;
> +			}
>  		}
>  	}
>  
> -	return idlest;
> +	return shallowest_idle_cpu != -1 ? shallowest_idle_cpu : least_loaded_cpu;
>  }

