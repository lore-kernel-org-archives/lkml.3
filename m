Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaDRFwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 01:52:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39992 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaDRFwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 01:52:50 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5350BD85.4050302@jp.fujitsu.com>
Date: Fri, 18 Apr 2014 14:52:05 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race
 on idle time stats
References: <53465F54.708@jp.fujitsu.com> <534660D2.1080505@jp.fujitsu.com> <20140415101910.GN11096@twins.programming.kicks-ass.net> <534E2422.1040706@jp.fujitsu.com> <20140417100519.GF11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140417100519.GF11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/17 19:05), Peter Zijlstra wrote:
> Anyway, if you want to preserve the same broken ass crap we had pre
> NOHZ, something like the below should do that.
> 
> I'm not really thrilled with iowait_{start,stop}() but I think they
> should have the same general cost as the atomic ops we already had. In
> particular on x86 an uncontended lock+unlock is a single atomic.
> 
> This is on top the first patch from Frederic that both you and Denys
> carried.
> 
> That said; I really hate duckt taping this together, for the generated
> numbers are still useless.
> 
> --- a/include/linux/ktime.h
> +++ b/include/linux/ktime.h
> @@ -58,6 +58,8 @@ union ktime {
>  
>  typedef union ktime ktime_t;		/* Kill this */
>  
> +#define ktime_zero ((ktime_t){ .tv64 = 0 })
> +
>  /*
>   * ktime_t definitions when using the 64-bit scalar representation:
>   */
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2297,15 +2297,29 @@ unsigned long nr_iowait(void)
>  	unsigned long i, sum = 0;
>  
>  	for_each_possible_cpu(i)
> -		sum += atomic_read(&cpu_rq(i)->nr_iowait);
> +		sum += cpu_rq(i)->nr_iowait;
>  
>  	return sum;
>  }
>  
>  unsigned long nr_iowait_cpu(int cpu)
>  {
> -	struct rq *this = cpu_rq(cpu);
> -	return atomic_read(&this->nr_iowait);
> +	return cpu_rq(cpu)->nr_iowait;
> +}
> +
> +void nr_iowait_deltas(ktime_t start, ktime_t now,
> +		      ktime_t *iowait_delta, ktime_t *idle_delta)
> +{
> +	struct rq *rq = this_rq();
> +
> +	raw_spin_lock(&rq->iowait_lock);
> +	if (rq->nr_iowait) {
> +		*iowait_delta = ktime_sub(now, start);
> +	} else {
> +		*iowait_delta = ktime_sub(rq->last_iowait, start);
> +		*idle_delta = ktime_sub(now, rq->last_iowait);
> +	}
> +	raw_spin_unlock(&rq->iowait_lock);
>  }
>  
>  #ifdef CONFIG_SMP
> @@ -4201,6 +4215,24 @@ bool __sched yield_to(struct task_struct
>  }
>  EXPORT_SYMBOL_GPL(yield_to);
>  
> +static inline void iowait_start(struct rq *rq)
> +{
> +	raw_spin_lock(&rq->iowait_lock);
> +	rq->nr_iowait++;
> +	raw_spin_unlock(&rq->iowait_lock);
> +	current->in_iowait = 1;
> +}
> +
> +static inline void iowait_stop(struct rq *rq)
> +{
> +	current->in_iowait = 0;
> +	raw_spin_lock(&rq->iowait_lock);
> +	rq->nr_iowait--;
> +	if (!rq->nr_iowait && rq != this_rq())
> +		rq->last_iowait = ktime_get();
> +	raw_spin_unlock(&rq->iowait_lock);
> +}
> +
>  /*
>   * This task is about to go to sleep on IO. Increment rq->nr_iowait so
>   * that process accounting knows that this is a task in IO wait state.
> @@ -4210,12 +4242,10 @@ void __sched io_schedule(void)
>  	struct rq *rq = raw_rq();
>  
>  	delayacct_blkio_start();
> -	atomic_inc(&rq->nr_iowait);
> +	iowait_start();
>  	blk_flush_plug(current);
> -	current->in_iowait = 1;
>  	schedule();
> -	current->in_iowait = 0;
> -	atomic_dec(&rq->nr_iowait);
> +	iowait_stop();
>  	delayacct_blkio_end();
>  }
>  EXPORT_SYMBOL(io_schedule);
> @@ -4226,12 +4256,10 @@ long __sched io_schedule_timeout(long ti
>  	long ret;
>  
>  	delayacct_blkio_start();
> -	atomic_inc(&rq->nr_iowait);
> +	iowait_start();
>  	blk_flush_plug(current);
> -	current->in_iowait = 1;
>  	ret = schedule_timeout(timeout);
> -	current->in_iowait = 0;
> -	atomic_dec(&rq->nr_iowait);
> +	iowait_stop();
>  	delayacct_blkio_end();
>  	return ret;
>  }
> @@ -6880,7 +6908,10 @@ void __init sched_init(void)
>  #endif
>  #endif
>  		init_rq_hrtick(rq);
> -		atomic_set(&rq->nr_iowait, 0);
> +
> +		raw_spinlock_init(&rq->iowait_lock);
> +		rq->nr_iowait = 0;
> +		rq->last_iowait = ktime_get();
>  	}
>  
>  	set_load_weight(&init_task);

I think it also works... but I have some concerns here:

 - it changes golden path in scheduler core.
    impact for performance is questionable.

 - it forces managing last_iowait even if system is in busy
    I guess it will drop max performance of the system
    while my proposed fix only touches procedure for idle
    with nohz. 

By the way, I have posted my v4 patch set:
https://lkml.org/lkml/2014/4/17/120

I'll happy if you could give your comments on it too!


Thanks,
H.Seto

