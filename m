Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3LLDmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 22:42:47 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45490 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3LLDmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 22:42:44 -0500
Date: Wed, 11 Dec 2013 19:42:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] rcu: use simple wait queues where possible in rcutree
Message-ID: <20131212034237.GW4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
 <1386810399-8973-4-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386810399-8973-4-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121203-7164-0000-0000-00000429E934
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 08:06:39PM -0500, Paul Gortmaker wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> As of commit dae6e64d2bcfd4b06304ab864c7e3a4f6b5fedf4 ("rcu: Introduce
> proper blocking to no-CBs kthreads GP waits") the rcu subsystem started
> making use of wait queues.
> 
> Here we convert all additions of rcu wait queues to use simple wait queues,
> since they don't need the extra overhead of the full wait queue features.
> 
> Originally this was done for RT kernels, since we would get things like...
> 
>   BUG: sleeping function called from invalid context at kernel/rtmutex.c:659
>   in_atomic(): 1, irqs_disabled(): 1, pid: 8, name: rcu_preempt
>   Pid: 8, comm: rcu_preempt Not tainted
>   Call Trace:
>    [<ffffffff8106c8d0>] __might_sleep+0xd0/0xf0
>    [<ffffffff817d77b4>] rt_spin_lock+0x24/0x50
>    [<ffffffff8106fcf6>] __wake_up+0x36/0x70
>    [<ffffffff810c4542>] rcu_gp_kthread+0x4d2/0x680
>    [<ffffffff8105f910>] ? __init_waitqueue_head+0x50/0x50
>    [<ffffffff810c4070>] ? rcu_gp_fqs+0x80/0x80
>    [<ffffffff8105eabb>] kthread+0xdb/0xe0
>    [<ffffffff8106b912>] ? finish_task_switch+0x52/0x100
>    [<ffffffff817e0754>] kernel_thread_helper+0x4/0x10
>    [<ffffffff8105e9e0>] ? __init_kthread_worker+0x60/0x60
>    [<ffffffff817e0750>] ? gs_change+0xb/0xb
> 
> ...and hence simple wait queues were deployed on RT out of necessity
> (as simple wait uses a raw lock), but mainline might as well take
> advantage of the more streamline support as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> [PG: adapt from multiple v3.10-rt patches and add a commit log.]
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

You got the swake_up_all() this time, so:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

;-)

> ---
>  kernel/rcu/tree.c        | 16 ++++++++--------
>  kernel/rcu/tree.h        |  7 ++++---
>  kernel/rcu/tree_plugin.h | 14 +++++++-------
>  3 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index dd08198..b35babb 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1550,9 +1550,9 @@ static int __noreturn rcu_gp_kthread(void *arg)
>  			trace_rcu_grace_period(rsp->name,
>  					       ACCESS_ONCE(rsp->gpnum),
>  					       TPS("reqwait"));
> -			wait_event_interruptible(rsp->gp_wq,
> -						 ACCESS_ONCE(rsp->gp_flags) &
> -						 RCU_GP_FLAG_INIT);
> +			swait_event_interruptible(rsp->gp_wq,
> +						  ACCESS_ONCE(rsp->gp_flags) &
> +						  RCU_GP_FLAG_INIT);
>  			if (rcu_gp_init(rsp))
>  				break;
>  			cond_resched();
> @@ -1576,7 +1576,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
>  			trace_rcu_grace_period(rsp->name,
>  					       ACCESS_ONCE(rsp->gpnum),
>  					       TPS("fqswait"));
> -			ret = wait_event_interruptible_timeout(rsp->gp_wq,
> +			ret = swait_event_interruptible_timeout(rsp->gp_wq,
>  					((gf = ACCESS_ONCE(rsp->gp_flags)) &
>  					 RCU_GP_FLAG_FQS) ||
>  					(!ACCESS_ONCE(rnp->qsmask) &&
> @@ -1625,7 +1625,7 @@ static void rsp_wakeup(struct irq_work *work)
>  	struct rcu_state *rsp = container_of(work, struct rcu_state, wakeup_work);
> 
>  	/* Wake up rcu_gp_kthread() to start the grace period. */
> -	wake_up(&rsp->gp_wq);
> +	swake_up(&rsp->gp_wq);
>  }
> 
>  /*
> @@ -1701,7 +1701,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
>  {
>  	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
>  	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
> -	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
> +	swake_up(&rsp->gp_wq);  /* Memory barrier implied by swake_up() path. */
>  }
> 
>  /*
> @@ -2271,7 +2271,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
>  	}
>  	rsp->gp_flags |= RCU_GP_FLAG_FQS;
>  	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
> -	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
> +	swake_up(&rsp->gp_wq); /* Memory barrier implied by swake_up() path. */
>  }
> 
>  /*
> @@ -3304,7 +3304,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
>  	}
> 
>  	rsp->rda = rda;
> -	init_waitqueue_head(&rsp->gp_wq);
> +	init_swaitqueue_head(&rsp->gp_wq);
>  	init_irq_work(&rsp->wakeup_work, rsp_wakeup);
>  	rnp = rsp->level[rcu_num_lvls - 1];
>  	for_each_possible_cpu(i) {
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index 52be957..01476e1 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -28,6 +28,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/seqlock.h>
>  #include <linux/irq_work.h>
> +#include <linux/swait.h>
> 
>  /*
>   * Define shape of hierarchy based on NR_CPUS, CONFIG_RCU_FANOUT, and
> @@ -200,7 +201,7 @@ struct rcu_node {
>  				/*  This can happen due to race conditions. */
>  #endif /* #ifdef CONFIG_RCU_BOOST */
>  #ifdef CONFIG_RCU_NOCB_CPU
> -	wait_queue_head_t nocb_gp_wq[2];
> +	swait_queue_head_t nocb_gp_wq[2];
>  				/* Place for rcu_nocb_kthread() to wait GP. */
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
>  	int need_future_gp[2];
> @@ -333,7 +334,7 @@ struct rcu_data {
>  	atomic_long_t nocb_q_count_lazy; /*  (approximate). */
>  	int nocb_p_count;		/* # CBs being invoked by kthread */
>  	int nocb_p_count_lazy;		/*  (approximate). */
> -	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
> +	swait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
>  	struct task_struct *nocb_kthread;
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
> 
> @@ -403,7 +404,7 @@ struct rcu_state {
>  	unsigned long gpnum;			/* Current gp number. */
>  	unsigned long completed;		/* # of last completed gp. */
>  	struct task_struct *gp_kthread;		/* Task for grace periods. */
> -	wait_queue_head_t gp_wq;		/* Where GP task waits. */
> +	swait_queue_head_t gp_wq;		/* Where GP task waits. */
>  	int gp_flags;				/* Commands for GP task. */
> 
>  	/* End of fields guarded by root rcu_node's lock. */
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 08a7652..b565ebd 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2060,7 +2060,7 @@ static int rcu_nocb_needs_gp(struct rcu_state *rsp)
>   */
>  static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
>  {
> -	wake_up_all(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
> +	swake_up_all(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
>  }
> 
>  /*
> @@ -2078,8 +2078,8 @@ static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
> 
>  static void rcu_init_one_nocb(struct rcu_node *rnp)
>  {
> -	init_waitqueue_head(&rnp->nocb_gp_wq[0]);
> -	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
> +	init_swaitqueue_head(&rnp->nocb_gp_wq[0]);
> +	init_swaitqueue_head(&rnp->nocb_gp_wq[1]);
>  }
> 
>  /* Is the specified CPU a no-CPUs CPU? */
> @@ -2122,7 +2122,7 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
>  	}
>  	len = atomic_long_read(&rdp->nocb_q_count);
>  	if (old_rhpp == &rdp->nocb_head) {
> -		wake_up(&rdp->nocb_wq); /* ... only if queue was empty ... */
> +		swake_up(&rdp->nocb_wq); /* ... only if queue was empty ... */
>  		rdp->qlen_last_fqs_check = 0;
>  		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeEmpty"));
>  	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
> @@ -2218,7 +2218,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
>  	 */
>  	trace_rcu_future_gp(rnp, rdp, c, TPS("StartWait"));
>  	for (;;) {
> -		wait_event_interruptible(
> +		swait_event_interruptible(
>  			rnp->nocb_gp_wq[c & 0x1],
>  			(d = ULONG_CMP_GE(ACCESS_ONCE(rnp->completed), c)));
>  		if (likely(d))
> @@ -2249,7 +2249,7 @@ static int rcu_nocb_kthread(void *arg)
>  		if (!rcu_nocb_poll) {
>  			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
>  					    TPS("Sleep"));
> -			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
> +			swait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
>  		} else if (firsttime) {
>  			firsttime = 0;
>  			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
> @@ -2314,7 +2314,7 @@ static int rcu_nocb_kthread(void *arg)
>  static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
>  {
>  	rdp->nocb_tail = &rdp->nocb_head;
> -	init_waitqueue_head(&rdp->nocb_wq);
> +	init_swaitqueue_head(&rdp->nocb_wq);
>  }
> 
>  /* Create a kthread for each RCU flavor for each no-CBs CPU. */
> -- 
> 1.8.5.1
> 

