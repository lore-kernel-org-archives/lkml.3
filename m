Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3DZMlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:41:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37467 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3DZMlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:41:24 -0400
Date: Fri, 26 Apr 2013 14:38:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net, l.majewski@samsung.com
Subject: Re: [PATCH 03/14] sched: pack small tasks
Message-ID: <20130426123827.GB13464@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
 <1366910611-20048-4-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910611-20048-4-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:23:19PM +0200, Vincent Guittot wrote:

> +static bool is_buddy_busy(int cpu)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	u32 sum = rq->avg.runnable_avg_sum;
> +	u32 period = rq->avg.runnable_avg_period;
> +
> +	/*
> +	 * If a CPU accesses the runnable_avg_sum and runnable_avg_period
> +	 * fields of its buddy CPU while the latter updates it, it can get the
> +	 * new version of a field and the old version of the other one. This
> +	 * can generate erroneous decisions. We don't want to use a lock
> +	 * mechanism for ensuring the coherency because of the overhead in
> +	 * this critical path.
> +	 * The runnable_avg_period of a runqueue tends to the max value in
> +	 * less than 345ms after plugging a CPU, which implies that we could
> +	 * use the max value instead of reading runnable_avg_period after
> +	 * 345ms. During the starting phase, we must ensure a minimum of
> +	 * coherency between the fields. A simple rule is runnable_avg_sum <=
> +	 * runnable_avg_period.
> +	 */
> +	sum = min(sum, period);
> +
> +	/*
> +	 * A busy buddy is a CPU with a high load or a small load with a lot of
> +	 * running tasks.
> +	 */
> +	return (sum > (period / (rq->nr_running + 2)));
> +}


I'm still not sold on the entire nr_running thing and the comment doesn't say
why you're doing it.

I'm fairly sure there's software out there that wakes a gazillion threads at a
time only for a gazillion-1 to go back to sleep immediately. Patterns like that
completely defeat your heuristic.

Does that matter... I don't know.

What happens if you keep this thing simple and only put a cap on utilization
(say 80%) and drop the entire nr_running magic? Have you seen it make an actual
difference or did it just seem like a good (TM) thing to do?

> +static bool is_light_task(struct task_struct *p)
> +{
> +	/* A light task runs less than 20% in average */
> +	return ((p->se.avg.runnable_avg_sum  * 5) <
> +			(p->se.avg.runnable_avg_period));
> +}

There superfluous () and ' ' in there. Also why 20%.. seemed like a good
number? Do we want a SCHED_DEBUG sysctl for that?
