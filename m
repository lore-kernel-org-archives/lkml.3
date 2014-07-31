Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaGaRBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:01:14 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58712 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaGaRBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:01:13 -0400
Date: Thu, 31 Jul 2014 10:01:08 -0700
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 05/10] rcutorture: Add torture tests
 for RCU-tasks
Message-ID: <20140731170108.GE12697@cloud>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1406767182-4356-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406767182-4356-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 05:39:37PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit adds torture tests for RCU-tasks.  It also fixes a bug that
> would segfault for an RCU flavor lacking a callback-barrier function.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Seems reasonable; however, you could also set .cb_barrier =
synchronize_rcu_tasks and drop rcu_barrier_tasks.

Either way:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/rcupdate.h |  1 +
>  kernel/rcu/rcutorture.c  | 40 +++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 17c7e25c38be..ecb2198849e0 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -55,6 +55,7 @@ enum rcutorture_type {
>  	RCU_FLAVOR,
>  	RCU_BH_FLAVOR,
>  	RCU_SCHED_FLAVOR,
> +	RCU_TASKS_FLAVOR,
>  	SRCU_FLAVOR,
>  	INVALID_RCU_FLAVOR
>  };
> diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> index febe07062ac5..6d12ab6675bc 100644
> --- a/kernel/rcu/rcutorture.c
> +++ b/kernel/rcu/rcutorture.c
> @@ -602,6 +602,42 @@ static struct rcu_torture_ops sched_ops = {
>  };
>  
>  /*
> + * Definitions for RCU-tasks torture testing.
> + */
> +
> +static int tasks_torture_read_lock(void)
> +{
> +	return 0;
> +}
> +
> +static void tasks_torture_read_unlock(int idx)
> +{
> +}
> +
> +static void rcu_tasks_torture_deferred_free(struct rcu_torture *p)
> +{
> +	call_rcu_tasks(&p->rtort_rcu, rcu_torture_cb);
> +}
> +
> +static struct rcu_torture_ops tasks_ops = {
> +	.ttype		= RCU_TASKS_FLAVOR,
> +	.init		= rcu_sync_torture_init,
> +	.readlock	= tasks_torture_read_lock,
> +	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
> +	.readunlock	= tasks_torture_read_unlock,
> +	.completed	= rcu_no_completed,
> +	.deferred_free	= rcu_tasks_torture_deferred_free,
> +	.sync		= synchronize_rcu_tasks,
> +	.exp_sync	= synchronize_rcu_tasks,
> +	.call		= call_rcu_tasks,
> +	.cb_barrier	= rcu_barrier_tasks,
> +	.fqs		= NULL,
> +	.stats		= NULL,
> +	.irq_capable	= 1,
> +	.name		= "tasks"
> +};
> +
> +/*
>   * RCU torture priority-boost testing.  Runs one real-time thread per
>   * CPU for moderate bursts, repeatedly registering RCU callbacks and
>   * spinning waiting for them to be invoked.  If a given callback takes
> @@ -1295,7 +1331,8 @@ static int rcu_torture_barrier_cbs(void *arg)
>  		if (atomic_dec_and_test(&barrier_cbs_count))
>  			wake_up(&barrier_wq);
>  	} while (!torture_must_stop());
> -	cur_ops->cb_barrier();
> +	if (cur_ops->cb_barrier != NULL)
> +		cur_ops->cb_barrier();
>  	destroy_rcu_head_on_stack(&rcu);
>  	torture_kthread_stopping("rcu_torture_barrier_cbs");
>  	return 0;
> @@ -1534,6 +1571,7 @@ rcu_torture_init(void)
>  	int firsterr = 0;
>  	static struct rcu_torture_ops *torture_ops[] = {
>  		&rcu_ops, &rcu_bh_ops, &rcu_busted_ops, &srcu_ops, &sched_ops,
> +		&tasks_ops,
>  	};
>  
>  	if (!torture_init_begin(torture_type, verbose, &rcutorture_runnable))
> -- 
> 1.8.1.5
> 
