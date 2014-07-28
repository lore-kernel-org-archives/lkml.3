Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaG1PVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:21:55 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46792 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaG1PVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:21:52 -0400
Date: Mon, 28 Jul 2014 08:21:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: Use separate wait queues for leaders and
 followers
Message-ID: <20140728152146.GA11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406559487-30007-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406559487-30007-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072815-9332-0000-0000-00000185D191
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 10:58:07AM -0400, Pranith Kumar wrote:
> Commit fbce7497ee5a ("rcu: Parallelize and economize NOCB kthread wakeups")
> 
> tries to reduce the wake up overhead by creating leader and follower nocb
> kthreads. 
> 
> One thing overlooked here is that all the kthreads wait on the same wait queue.
> When we try to wake up the leader threads on the wait queue, we also try to wake
> up the follower threads because of which there is still wake up overhead. 
> 
> This commit tries to avoid that by using separate wait queues for the leaders and
> followers.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

But there is a separate rcu_data structure for each CPU.  This means that
the pre-existing ->nocb_wq is automatically either a leader waitqueue
or a follower waitqueue, depending on whether the enclosing rcu_data
structure is a leader or a follower.  So I don't see how adding the
separate ->nocb_leader_wq and ->nocb_follower_wq is doing anything
other than wasting memory.  After all, with your patch, a given rcu_data
structure will use either ->nocb_leader_wq or ->nocb_follower_wq, and
the other will remain unused.

So unless I am missing something subtle here, I must say "no" to this one.

							Thanx, Paul

> ---
>  kernel/rcu/tree.h        |  3 ++-
>  kernel/rcu/tree_plugin.h | 11 ++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index f703ea8..915ca71 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -348,7 +348,8 @@ struct rcu_data {
>  	atomic_long_t nocb_follower_count_lazy; /*  (approximate). */
>  	int nocb_p_count;		/* # CBs being invoked by kthread */
>  	int nocb_p_count_lazy;		/*  (approximate). */
> -	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
> +	wait_queue_head_t nocb_leader_wq; /* leader kthreads sleep on. */
> +	wait_queue_head_t nocb_follower_wq; /* follower kthreads sleep on. */
>  	struct task_struct *nocb_kthread;
>  	bool nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 4242c94..bd6faba 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2045,7 +2045,7 @@ static void wake_nocb_leader(struct rcu_data *rdp, bool force)
>  	if (!ACCESS_ONCE(rdp_leader->nocb_leader_wake) || force) {
>  		/* Prior xchg orders against prior callback enqueue. */
>  		ACCESS_ONCE(rdp_leader->nocb_leader_wake) = true;
> -		wake_up(&rdp_leader->nocb_wq);
> +		wake_up(&rdp_leader->nocb_leader_wq);
>  	}
>  }
> 
> @@ -2220,7 +2220,7 @@ wait_again:
>  	/* Wait for callbacks to appear. */
>  	if (!rcu_nocb_poll) {
>  		trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu, "Sleep");
> -		wait_event_interruptible(my_rdp->nocb_wq,
> +		wait_event_interruptible(my_rdp->nocb_leader_wq,
>  					 ACCESS_ONCE(my_rdp->nocb_leader_wake));
>  		/* Memory barrier handled by smp_mb() calls below and repoll. */
>  	} else if (firsttime) {
> @@ -2300,7 +2300,7 @@ wait_again:
>  			 * List was empty, wake up the follower.
>  			 * Memory barriers supplied by atomic_long_add().
>  			 */
> -			wake_up(&rdp->nocb_wq);
> +			wake_up(&rdp->nocb_follower_wq);
>  		}
>  	}
> 
> @@ -2321,7 +2321,7 @@ static void nocb_follower_wait(struct rcu_data *rdp)
>  		if (!rcu_nocb_poll) {
>  			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
>  					    "FollowerSleep");
> -			wait_event_interruptible(rdp->nocb_wq,
> +			wait_event_interruptible(rdp->nocb_follower_wq,
>  						 ACCESS_ONCE(rdp->nocb_follower_head));
>  		} else if (firsttime) {
>  			/* Don't drown trace log with "Poll"! */
> @@ -2489,7 +2489,8 @@ void __init rcu_init_nohz(void)
>  static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
>  {
>  	rdp->nocb_tail = &rdp->nocb_head;
> -	init_waitqueue_head(&rdp->nocb_wq);
> +	init_waitqueue_head(&rdp->nocb_leader_wq);
> +	init_waitqueue_head(&rdp->nocb_follower_wq);
>  	rdp->nocb_follower_tail = &rdp->nocb_follower_head;
>  }
> 
> -- 
> 1.9.1
> 

