Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3IWRFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:05:14 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:44068 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3IWRFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:05:12 -0400
Date: Mon, 23 Sep 2013 09:55:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 02/11] sched, rcu: Make RCU use resched_cpu()
Message-ID: <20130923165540.GP9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130917082838.218329307@infradead.org>
 <20130917091143.449530904@infradead.org>
 <20130917144012.GC29354@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917144012.GC29354@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092316-7164-0000-0000-000001DB2A07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 04:40:12PM +0200, Peter Zijlstra wrote:
> Thomas Meyer reported a UP build fail, should be fixed.
> 
> ---
> Subject: sched, rcu: Make RCU use resched_cpu()
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue Sep 17 09:30:55 CEST 2013
> 
> We're going to deprecate and remove set_need_resched() for it will do
> the wrong thing. Make an exception for RCU and allow it to use
> resched_cpu() which will do the right thing.
> 
> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Queued for 3.13, thank you!

							Thanx, Paul

> ---
>  kernel/rcutree.c    |   15 ++++++++++++++-
>  kernel/sched/core.c |   10 ++--------
>  2 files changed, 16 insertions(+), 9 deletions(-)
> 
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -898,6 +898,12 @@ static void print_other_cpu_stall(struct
>  	force_quiescent_state(rsp);  /* Kick them all. */
>  }
> 
> +/*
> + * This function really isn't for public consumption, but RCU is special in
> + * that context switches can allow the state machine to make progress.
> + */
> +extern void resched_cpu(int cpu);
> +
>  static void print_cpu_stall(struct rcu_state *rsp)
>  {
>  	int cpu;
> @@ -927,7 +933,14 @@ static void print_cpu_stall(struct rcu_s
>  				     3 * rcu_jiffies_till_stall_check() + 3;
>  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> 
> -	set_need_resched();  /* kick ourselves to get things going. */
> +	/*
> +	 * Attempt to revive the RCU machinery by forcing a context switch.
> +	 *
> +	 * A context switch would normally allow the RCU state machine to make
> +	 * progress and it could be we're stuck in kernel space without context
> +	 * switches for an entirely unreasonable amount of time.
> +	 */
> +	resched_cpu(smp_processor_id());
>  }
> 
>  static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -513,12 +513,11 @@ static inline void init_hrtick(void)
>   * might also involve a cross-CPU call to trigger the scheduler on
>   * the target CPU.
>   */
> -#ifdef CONFIG_SMP
>  void resched_task(struct task_struct *p)
>  {
>  	int cpu;
> 
> -	assert_raw_spin_locked(&task_rq(p)->lock);
> +	lockdep_assert_held(&task_rq(p)->lock);
> 
>  	if (test_tsk_need_resched(p))
>  		return;
> @@ -546,6 +545,7 @@ void resched_cpu(int cpu)
>  	raw_spin_unlock_irqrestore(&rq->lock, flags);
>  }
> 
> +#ifdef CONFIG_SMP
>  #ifdef CONFIG_NO_HZ_COMMON
>  /*
>   * In the semi idle case, use the nearest busy cpu for migrating timers
> @@ -693,12 +693,6 @@ void sched_avg_update(struct rq *rq)
>  	}
>  }
> 
> -#else /* !CONFIG_SMP */
> -void resched_task(struct task_struct *p)
> -{
> -	assert_raw_spin_locked(&task_rq(p)->lock);
> -	set_tsk_need_resched(p);
> -}
>  #endif /* CONFIG_SMP */
> 
>  #if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
> 
> 

