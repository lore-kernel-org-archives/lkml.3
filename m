Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3JGLYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:24:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3JGLYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:24:32 -0400
Date: Mon, 7 Oct 2013 13:24:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131007112421.GD3081@twins.programming.kicks-ass.net>
References: <20131003194226.GO28601@twins.programming.kicks-ass.net>
 <20131003195832.GU5790@linux.vnet.ibm.com>
 <20131004065835.GP28601@twins.programming.kicks-ass.net>
 <20131004160352.GF5790@linux.vnet.ibm.com>
 <20131004165044.GV28601@twins.programming.kicks-ass.net>
 <20131004170954.GK5790@linux.vnet.ibm.com>
 <20131004185239.GS15690@laptop.programming.kicks-ass.net>
 <20131004212506.GM5790@linux.vnet.ibm.com>
 <20131004220232.GA8293@linux.vnet.ibm.com>
 <20131005002348.GA11762@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005002348.GA11762@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 05:23:48PM -0700, Paul E. McKenney wrote:
> The underlying problem is that perf is invoking call_rcu() with the
> scheduler locks held, but in NOCB mode, call_rcu() will with high
> probability invoke the scheduler -- which just might want to use its
> locks.  The reason that call_rcu() needs to invoke the scheduler is
> to wake up the corresponding rcuo callback-offload kthread, which
> does the job of starting up a grace period and invoking the callbacks
> afterwards.
> 
> One solution (championed on a related problem by Lai Jiangshan) is to

That's rcu_read_unlock_special(), right? 

> simply defer the wakeup to some point where scheduler locks are no longer
> held.  Since we don't want to unnecessarily incur the cost of such
> deferral, the task before us is threefold:
> 
> 1.	Determine when it is likely that a relevant scheduler lock is held.
> 
> 2.	Defer the wakeup in such cases.
> 
> 3.	Ensure that all deferred wakeups eventually happen, preferably
>     	sooner rather than later.
> 
> We use irqs_disabled_flags() as a proxy for relevant scheduler locks
> being held.  This works because the relevant locks are always acquired
> with interrupts disabled.  We may defer more often than needed, but that
> is at least safe.

Fair enough; do you feel the need for something more specific?

> The wakeup deferral is tracked via a new field in the per-CPU and
> per-RCU-flavor rcu_data structure, namely ->nocb_defer_wakeup.
> 
> This flag is checked by the RCU core processing.  The __rcu_pending()
> function now checks this flag, which causes rcu_check_callbacks()
> to initiate RCU core processing at each scheduling-clock interrupt
> where this flag is set.  Of course this is not sufficient because
> scheduling-clock interrupts are often turned off (the things we used to
> be able to count on!).  So the flags are also checked on entry to any
> state that RCU considers to be idle, which includes both NO_HZ_IDLE idle
> state and NO_HZ_FULL user-mode-execution state.

So RCU doesn't current differentiate between EQS for nr_running==1 and
nr_running==0?

> This approach should allow call_rcu() to be invoked regardless of what
> locks you might be holding, the key word being "should".

Agreed. Except it looks like you've inverted the deferred wakeup
condition :-)

> @@ -2314,6 +2323,22 @@ static int rcu_nocb_kthread(void *arg)
>  	return 0;
>  }
>  
> +/* Is a deferred wakeup of rcu_nocb_kthread() required? */
> +static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
> +{
> +	return ACCESS_ONCE(rdp->nocb_defer_wakeup);
> +}
> +
> +/* Do a deferred wakeup of rcu_nocb_kthread(). */
> +static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
> +{
> +	if (rcu_nocb_need_deferred_wakeup(rdp))

	!rcu_nocb_need_deferred_wakeup() ?

> +		return;
> +	ACCESS_ONCE(rdp->nocb_defer_wakeup) = false;
> +	wake_up(&rdp->nocb_wq);
> +	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWakeEmpty"));
> +}
> +
>  /* Initialize per-rcu_data variables for no-CBs CPUs. */
>  static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
>  {

