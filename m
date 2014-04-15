Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaDONDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:03:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54834 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaDONDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:03:12 -0400
Date: Tue, 15 Apr 2014 15:03:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose
 the idlest cpu
Message-ID: <20140415130301.GL11182@twins.programming.kicks-ass.net>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
 <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 01:29:56PM +0100, Daniel Lezcano wrote:
> @@ -4336,20 +4337,53 @@ static int
>  find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>  {
>  	unsigned long load, min_load = ULONG_MAX;
> -	int idlest = -1;
> +	unsigned int min_exit_latency = UINT_MAX;
> +	u64 idle_stamp, min_idle_stamp = ULONG_MAX;
> +
> +	struct rq *rq;
> +	struct cpuidle_power *power;
> +
> +	int cpu_idle = -1;
> +	int cpu_busy = -1;
>  	int i;
>  
>  	/* Traverse only the allowed CPUs */
>  	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
> -		load = weighted_cpuload(i);
>  
> -		if (load < min_load || (load == min_load && i == this_cpu)) {
> -			min_load = load;
> -			idlest = i;
> +		if (idle_cpu(i)) {
> +
> +			rq = cpu_rq(i);
> +			power = rq->power;
> +			idle_stamp = rq->idle_stamp;
> +
> +			/* The cpu is idle since a shorter time */
> +			if (idle_stamp < min_idle_stamp) {
> +				min_idle_stamp = idle_stamp;
> +				cpu_idle = i;
> +				continue;
> +			}
> +
> +			/* The cpu is idle but the exit_latency is shorter */
> +			if (power && power->exit_latency < min_exit_latency) {
> +				min_exit_latency = power->exit_latency;
> +				cpu_idle = i;
> +				continue;
> +			}

Aside from the arguments made by Nico (which I agree with), depending on
the life time rules of the power object we might need
smp_read_barrier_depends() between reading and using.

If all these objects are static and never change content we do not, if
there's dynamic objects involved we probably should.
