Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3DVUKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:10:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45290 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab3DVUKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:10:44 -0400
Message-ID: <1366661437.6454.20.camel@laptop>
Subject: Re: [PATCH v7] sched: fix init NOHZ_IDLE flag
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, fweisbec@gmail.com, pjt@google.com,
        rostedt@goodmis.org, efault@gmx.de
Date: Mon, 22 Apr 2013 22:10:37 +0200
In-Reply-To: <1366645086-20345-1-git-send-email-vincent.guittot@linaro.org>
References: <1366645086-20345-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 17:38 +0200, Vincent Guittot wrote:

> ---
>  include/linux/sched.h |    1 +
>  kernel/sched/fair.c   |   34 ++++++++++++++++++++++++----------
>  2 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d35d2b6..cde4f7f 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -899,6 +899,7 @@ struct sched_domain {
>  	unsigned int wake_idx;
>  	unsigned int forkexec_idx;
>  	unsigned int smt_gain;
> +	unsigned long nohz_flags;	/* NOHZ_IDLE flag status */
>  	int flags;			/* See SD_* */
>  	int level;

There was a 4 byte hole here, I'm assuming you used unsigned long and
not utilized the hole because of the whole atomic bitop interface
taking unsigned long?

Bit wasteful but ok.. 

So we're only pulling NOHZ_IDLE out of nohz_flags()? Should we then not
also amend the rq_nohz_flag_bits enum? And it seems pointless to me to
set bit 2 our nohz_flags word if all other bits are unused.

>  
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7a33e59..09e440f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5394,14 +5394,21 @@ static inline void set_cpu_sd_state_busy(void)
>  {
>  	struct sched_domain *sd;
>  	int cpu = smp_processor_id();
> -
> -	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
> -		return;
> -	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
> +	int first_nohz_idle = 1;
>  
>  	rcu_read_lock();
> -	for_each_domain(cpu, sd)
> +	for_each_domain(cpu, sd) {
> +		if (first_nohz_idle) {
> +			if (!test_bit(NOHZ_IDLE, &sd->nohz_flags))
> +				goto unlock;
> +
> +			clear_bit(NOHZ_IDLE, &sd->nohz_flags);
> +			first_nohz_idle = 0;
> +		}
> +
>  		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
> +	}

the mind boggles... what's wrong with something like:

static inline unsigned long *rq_nohz_flags(int cpu)
{
	return rcu_dereference(cpu_rq(cpu)->sd)->nohz_flags;
}

	if (!test_bit(0, rq_nohz_flags(cpu)))
		return;
	clear_bit(0, rq_nohz_flags(cpu));

> +unlock:
>  	rcu_read_unlock();
>  }
>  
> @@ -5409,14 +5416,21 @@ void set_cpu_sd_state_idle(void)
>  {
>  	struct sched_domain *sd;
>  	int cpu = smp_processor_id();
> -
> -	if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
> -		return;
> -	set_bit(NOHZ_IDLE, nohz_flags(cpu));
> +	int first_nohz_idle = 1;
>  
>  	rcu_read_lock();
> -	for_each_domain(cpu, sd)
> +	for_each_domain(cpu, sd) {
> +		if (first_nohz_idle) {
> +			if (test_bit(NOHZ_IDLE, &sd->nohz_flags))
> +				goto unlock;
> +
> +			set_bit(NOHZ_IDLE, &sd->nohz_flags);
> +			first_nohz_idle = 0;
> +		}
> +
>  		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
> +	}
> +unlock:

Same here, .. why on earth do it for every sched_domain for that cpu?

>  	rcu_read_unlock();
>  }
>  

And since its now only a single bit in a single word, we can easily
change it to something like:

  if (*rq_nohz_idle(cpu))
	return;
  xchg(rq_nohz_idle(cpu), 1); /* set; use 0 for clear */

which drops the unsigned long nonsense..

Or am I completely missing something obvious here?

