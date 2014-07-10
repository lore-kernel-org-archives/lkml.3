Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaGJLbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:31:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:35604 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaGJLbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:31:23 -0400
Date: Thu, 10 Jul 2014 13:31:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 08/12] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140710113120.GA3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 06:05:39PM +0200, Vincent Guittot wrote:

You 'forgot' to update the comment that goes with nohz_kick_needed().

> @@ -7233,9 +7253,10 @@ static inline int nohz_kick_needed(struct rq *rq)
>  	struct sched_domain *sd;
>  	struct sched_group_capacity *sgc;
>  	int nr_busy, cpu = rq->cpu;
> +	bool kick = false;
>  
>  	if (unlikely(rq->idle_balance))
> +		return false;
>  
>         /*
>  	* We may be recently in ticked or tickless idle mode. At the first
> @@ -7249,38 +7270,41 @@ static inline int nohz_kick_needed(struct rq *rq)
>  	 * balancing.
>  	 */
>  	if (likely(!atomic_read(&nohz.nr_cpus)))
> +		return false;
>  
>  	if (time_before(now, nohz.next_balance))
> +		return false;
>  
>  	if (rq->nr_running >= 2)
> +		return true;
>  
>  	rcu_read_lock();
>  	sd = rcu_dereference(per_cpu(sd_busy, cpu));
>  	if (sd) {
>  		sgc = sd->groups->sgc;
>  		nr_busy = atomic_read(&sgc->nr_busy_cpus);
>  
> +		if (nr_busy > 1) {
> +			kick = true;
> +			goto unlock;
> +		}
> +
> +		if ((rq->cfs.h_nr_running >= 1)
> +		 && ((rq->cpu_capacity * sd->imbalance_pct) <
> +					(rq->cpu_capacity_orig * 100))) {
> +			kick = true;
> +			goto unlock;
> +		}

Again, why only for shared caches?

>  	}
>  
>  	sd = rcu_dereference(per_cpu(sd_asym, cpu));
>  	if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
>  				  sched_domain_span(sd)) < cpu))
> +		kick = true;
>  
> +unlock:
>  	rcu_read_unlock();
> +	return kick;
>  }

