Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3GHUQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:16:44 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50636 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab3GHUQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:16:41 -0400
Date: Mon, 8 Jul 2013 12:46:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Fix perf_lock_task_context() vs RCU
Message-ID: <20130708194617.GC16780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130708191742.GB25631@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708191742.GB25631@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070819-5518-0000-0000-0000102E2D7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 09:17:42PM +0200, Peter Zijlstra wrote:
> Subject: perf: Fix perf_lock_task_context() vs RCU
> 
> Jiri managed to trigger:
> 
> [] ======================================================
> [] [ INFO: possible circular locking dependency detected ]
> [] 3.10.0+ #228 Tainted: G        W  
> [] -------------------------------------------------------
> [] p/6613 is trying to acquire lock:
> []  (rcu_node_0){..-...}, at: [<ffffffff810ca797>] rcu_read_unlock_special+0xa7/0x250
> []
> [] but task is already holding lock:
> []  (&ctx->lock){-.-...}, at: [<ffffffff810f2879>] perf_lock_task_context+0xd9/0x2c0
> []
> [] which lock already depends on the new lock.
> []
> [] the existing dependency chain (in reverse order) is:
> []
> [] -> #4 (&ctx->lock){-.-...}:
> [] -> #3 (&rq->lock){-.-.-.}:
> [] -> #2 (&p->pi_lock){-.-.-.}:
> [] -> #1 (&rnp->nocb_gp_wq[1]){......}:
> [] -> #0 (rcu_node_0){..-...}:
> 
> Paul was quick to explain that due to preemptible RCU we cannot call
> rcu_read_unlock() while holding scheduler (or nested) locks when part of the
> read side critical section was preemptible.
> 
> Therefore solve it by making the entire RCU read side non-preemptible.
> 
> Also pull out the retry from under the non-preempt to play nice with RT.
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/events/core.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -947,8 +947,18 @@ perf_lock_task_context(struct task_struc
>  {
>  	struct perf_event_context *ctx;
> 
> -	rcu_read_lock();
>  retry:
> +	/*
> +	 * One of the few rules of preemptible RCU is that one cannot do
> +	 * rcu_read_unlock() while holding a scheduler (or nested) lock when
> +	 * part of the read side critical section was preemptible -- see
> +	 * rcu_read_unlock_special().
> +	 *
> +	 * Since ctx->lock nests under rq->lock we must ensure the entire read
> +	 * side critical section is non-preemptible.
> +	 */
> +	preempt_disable();
> +	rcu_read_lock();
>  	ctx = rcu_dereference(task->perf_event_ctxp[ctxn]);
>  	if (ctx) {
>  		/*
> @@ -964,6 +974,8 @@ perf_lock_task_context(struct task_struc
>  		raw_spin_lock_irqsave(&ctx->lock, *flags);
>  		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
>  			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
> +			rcu_read_unlock();
> +			preempt_enable();
>  			goto retry;
>  		}
> 
> @@ -973,6 +985,7 @@ perf_lock_task_context(struct task_struc
>  		}
>  	}
>  	rcu_read_unlock();
> +	preempt_enable();
>  	return ctx;
>  }
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

