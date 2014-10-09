Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbaJILg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:36:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:39325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJILgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:36:19 -0400
Date: Thu, 9 Oct 2014 13:36:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com
Subject: Re: [PATCH v7 5/7] sched: get CPU's usage statistic
Message-ID: <20141009113614.GP4750@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-6-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412684017-16595-6-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:13:35PM +0200, Vincent Guittot wrote:
> Monitor the usage level of each group of each sched_domain level. The usage is
> the amount of cpu_capacity that is currently used on a CPU or group of CPUs.
> We use the utilization_load_avg to evaluate the usage level of each group.
> 
> The utilization_avg_contrib only takes into account the running time but not
> the uArch so the utilization_load_avg is in the range [0..SCHED_LOAD_SCALE]
> to reflect the running load on the CPU. We have to scale the utilization with
> the capacity of the CPU to get the usage of the latter. The usage can then be
> compared with the available capacity.

You say cpu_capacity, but in actual fact you use capacity_orig and fail
to justify/clarify this.

> The frequency scaling invariance is not taken into account in this patchset,
> it will be solved in another patchset

Maybe explain what the specific invariance issue is that is skipped over
for now.

> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index d3e9067..7364ed4 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4551,6 +4551,17 @@ static int select_idle_sibling(struct task_struct *p, int target)
>  	return target;
>  }
>  
> +static int get_cpu_usage(int cpu)
> +{
> +	unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
> +	unsigned long capacity = capacity_orig_of(cpu);
> +
> +	if (usage >= SCHED_LOAD_SCALE)
> +		return capacity + 1;

Like Morten I'm confused by that +1 thing.

> +
> +	return (usage * capacity) >> SCHED_LOAD_SHIFT;
> +}

A comment with that function that it returns capacity units might
clarify shift confusion Morten raised the other day.
