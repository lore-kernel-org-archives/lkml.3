Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab3LPPc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:32:56 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:60071 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3LPPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:32:53 -0500
Date: Mon, 16 Dec 2013 07:32:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, davej@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Break call_rcu() deadlock involving
 scheduler and perf
Message-ID: <20131216153248.GA4200@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-96d3fd0d315a949e30adc80f086031c5cdf070d1@git.kernel.org>
 <20131216152636.GX21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216152636.GX21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121615-3532-0000-0000-000003E5A16E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 04:26:36PM +0100, Peter Zijlstra wrote:
> On Mon, Dec 16, 2013 at 07:19:22AM -0800, tip-bot for Paul E. McKenney wrote:
> > The underlying problem is that perf is invoking call_rcu() with the
> > scheduler locks held, but in NOCB mode, call_rcu() will with high
> > probability invoke the scheduler -- which just might want to use its
> > locks.  The reason that call_rcu() needs to invoke the scheduler is
> > to wake up the corresponding rcuo callback-offload kthread, which
> > does the job of starting up a grace period and invoking the callbacks
> > afterwards.
> > 
> > One solution (championed on a related problem by Lai Jiangshan) is to
> > simply defer the wakeup to some point where scheduler locks are no longer
> > held.  Since we don't want to unnecessarily incur the cost of such
> > deferral, the task before us is threefold:
> > 
> > 1.	Determine when it is likely that a relevant scheduler lock is held.
> > 
> > 2.	Defer the wakeup in such cases.
> > 
> > 3.	Ensure that all deferred wakeups eventually happen, preferably
> > 	sooner rather than later.
> > 
> > We use irqs_disabled_flags() as a proxy for relevant scheduler locks
> > being held.  This works because the relevant locks are always acquired
> > with interrupts disabled.  We may defer more often than needed, but that
> > is at least safe.
> 
> This would also allow us to do away with things like the below patch,
> right?

It takes care of one problem, but there are others, including
rcu_read_unlock() inovking the scheduler to deboost itself.  So for the
moment, we still need the below patch.

							Thanx, Paul

> ---
> commit 058ebd0eba3aff16b144eabf4510ed9510e1416e
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Jul 12 11:08:33 2013 +0200
> 
>     perf: Fix perf_lock_task_context() vs RCU
>     
>     Jiri managed to trigger this warning:
>     
>      [] ======================================================
>      [] [ INFO: possible circular locking dependency detected ]
>      [] 3.10.0+ #228 Tainted: G        W
>      [] -------------------------------------------------------
>      [] p/6613 is trying to acquire lock:
>      []  (rcu_node_0){..-...}, at: [<ffffffff810ca797>] rcu_read_unlock_special+0xa7/0x250
>      []
>      [] but task is already holding lock:
>      []  (&ctx->lock){-.-...}, at: [<ffffffff810f2879>] perf_lock_task_context+0xd9/0x2c0
>      []
>      [] which lock already depends on the new lock.
>      []
>      [] the existing dependency chain (in reverse order) is:
>      []
>      [] -> #4 (&ctx->lock){-.-...}:
>      [] -> #3 (&rq->lock){-.-.-.}:
>      [] -> #2 (&p->pi_lock){-.-.-.}:
>      [] -> #1 (&rnp->nocb_gp_wq[1]){......}:
>      [] -> #0 (rcu_node_0){..-...}:
>     
>     Paul was quick to explain that due to preemptible RCU we cannot call
>     rcu_read_unlock() while holding scheduler (or nested) locks when part
>     of the read side critical section was preemptible.
>     
>     Therefore solve it by making the entire RCU read side non-preemptible.
>     
>     Also pull out the retry from under the non-preempt to play nice with RT.
>     
>     Reported-by: Jiri Olsa <jolsa@redhat.com>
>     Helped-out-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Cc: <stable@kernel.org>
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index ef5e7cc686e3..eba8fb5834ae 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -947,8 +947,18 @@ perf_lock_task_context(struct task_struct *task, int ctxn, unsigned long *flags)
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
> @@ -964,6 +974,8 @@ perf_lock_task_context(struct task_struct *task, int ctxn, unsigned long *flags)
>  		raw_spin_lock_irqsave(&ctx->lock, *flags);
>  		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
>  			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
> +			rcu_read_unlock();
> +			preempt_enable();
>  			goto retry;
>  		}
> 
> @@ -973,6 +985,7 @@ perf_lock_task_context(struct task_struct *task, int ctxn, unsigned long *flags)
>  		}
>  	}
>  	rcu_read_unlock();
> +	preempt_enable();
>  	return ctx;
>  }
> 
> 

