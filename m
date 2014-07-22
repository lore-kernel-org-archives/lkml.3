Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaGVLG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:06:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51239 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaGVLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:06:54 -0400
Date: Tue, 22 Jul 2014 04:06:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC tip/core/rcu 1/5] rcu: Reduce overhead of
 cond_resched() checks for RCU
Message-ID: <20140722110648.GR8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53CDEA2D.1030402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CDEA2D.1030402@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072211-1542-0000-0000-000003754FEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 12:35:57AM -0400, Pranith Kumar wrote:
> Hi Paul,
> 
> I was going through this code and found a few inconsistencies. I git blamed it
> and found that it was this recent commit and thought I could ask a few
> questions. I am dropping the CC's as I am not sure since it is pretty late.
> 
> Please find a few questions below:
> 
> On 06/20/2014 02:33 PM, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Commit ac1bea85781e (Make cond_resched() report RCU quiescent states)
> > fixed a problem where a CPU looping in the kernel with but one runnable
> > task would give RCU CPU stall warnings, even if the in-kernel loop
> > contained cond_resched() calls.  Unfortunately, in so doing, it introduced
> > performance regressions in Anton Blanchard's will-it-scale "open1" test.
> > The problem appears to be not so much the increased cond_resched() path
> > length as an increase in the rate at which grace periods complete, which
> > increased per-update grace-period overhead.
> > 
> > This commit takes a different approach to fixing this bug, mainly by
> > avoiding having cond_resched() do an RCU-visible quiescent state unless
> > there is a grace period that has been in flight for a significant period
> > of time.  This commit also reduces the common-case cond_resched() overhead
> > to a check of a single per-CPU variable.
> > 
> <snip>
> > index f1ba77363fbb..2cc72ce19ff6 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -229,6 +229,58 @@ static DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
> >  #endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
> >  };
> >  
> > +/*
> > + * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
> > + */
> > +
> > +DEFINE_PER_CPU(int, rcu_cond_resched_mask);
> > +
> > +/*
> > + * Let the RCU core know that this CPU has gone through a cond_resched(),
> > + * which is a quiescent state.
> > + */
> > +void rcu_resched(void)
> > +{
> > +	unsigned long flags;
> > +	struct rcu_data *rdp;
> > +	struct rcu_dynticks *rdtp;
> > +	int resched_mask;
> > +	struct rcu_state *rsp;
> > +
> > +	local_irq_save(flags);
> > +
> > +	/*
> > +	 * Yes, we can lose flag-setting operations.  This is OK, because
> > +	 * the flag will be set again after some delay.
> > +	 */
> > +	resched_mask = raw_cpu_read(rcu_cond_resched_mask);
> > +	raw_cpu_write(rcu_cond_resched_mask, 0);
> > +
> > +	/* Find the flavor that needs a quiescent state. */
> > +	for_each_rcu_flavor(rsp) {
> > +		rdp = raw_cpu_ptr(rsp->rda);
> > +		if (!(resched_mask & rsp->flavor_mask))
> > +			continue;
> 
> Here both resched_mask and flavor_mask are not being updated within the loop.
> Are they supposed to be? It is really not clear what flavor_mask is doing in the
> code. 

Because rsp is being updated on each pass through the loop, rsp->flavor_mask
has a different value on each pass.

The idea is that each rcu_state (referenced by rsp) has one bit in its
->flavor_mask.  Then resched_mask has bits set corresponding to each
rcu_state that needs help.

There were several variants of this commit, due to some performance
concerns.

> > +		smp_mb(); /* ->flavor_mask before ->cond_resched_completed. */
> > +		if (ACCESS_ONCE(rdp->mynode->completed) !=
> > +		    ACCESS_ONCE(rdp->cond_resched_completed))
> > +			continue;
> > +
> > +		/*
> > +		 * Pretend to be momentarily idle for the quiescent state.
> > +		 * This allows the grace-period kthread to record the
> > +		 * quiescent state, with no need for this CPU to do anything
> > +		 * further.
> > +		 */
> > +		rdtp = this_cpu_ptr(&rcu_dynticks);
> > +		smp_mb__before_atomic(); /* Earlier stuff before QS. */
> > +		atomic_add(2, &rdtp->dynticks);  /* QS. */
> > +		smp_mb__after_atomic(); /* Later stuff after QS. */
> > +		break;
> > +	}
> > +	local_irq_restore(flags);
> > +}
> > +
> >  static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
> >  static long qhimark = 10000;	/* If this many pending, ignore blimit. */
> >  static long qlowmark = 100;	/* Once only this many pending, use blimit. */
> > @@ -853,6 +905,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
> >  				    bool *isidle, unsigned long *maxj)
> >  {
> >  	unsigned int curr;
> > +	int *rcrmp;
> >  	unsigned int snap;
> >  
> >  	curr = (unsigned int)atomic_add_return(0, &rdp->dynticks->dynticks);
> > @@ -893,13 +946,20 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
> >  	}
> >  
> >  	/*
> > -	 * There is a possibility that a CPU in adaptive-ticks state
> > -	 * might run in the kernel with the scheduling-clock tick disabled
> > -	 * for an extended time period.  Invoke rcu_kick_nohz_cpu() to
> > -	 * force the CPU to restart the scheduling-clock tick in this
> > -	 * CPU is in this state.
> > +	 * A CPU running for an extended time within the kernel can
> > +	 * delay RCU grace periods.  When the CPU is in NO_HZ_FULL mode,
> > +	 * even context-switching back and forth between a pair of
> > +	 * in-kernel CPU-bound tasks cannot advance grace periods.
> > +	 * So if the grace period is old enough, make the CPU pay attention.
> >  	 */
> > -	rcu_kick_nohz_cpu(rdp->cpu);
> > +	if (ULONG_CMP_GE(jiffies, rdp->rsp->gp_start + 7)) {
> > +		rcrmp = &per_cpu(rcu_cond_resched_mask, rdp->cpu);
> > +		ACCESS_ONCE(rdp->cond_resched_completed) =
> > +			ACCESS_ONCE(rdp->mynode->completed);
> > +		smp_mb(); /* ->cond_resched_completed before *rcrmp. */
> > +		ACCESS_ONCE(*rcrmp) =
> > +			ACCESS_ONCE(*rcrmp) + rdp->rsp->flavor_mask;
> > +	}
> >  
> >  	/*
> >  	 * Alternatively, the CPU might be running in the kernel
> > @@ -3491,6 +3551,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
> >  			       "rcu_node_fqs_1",
> >  			       "rcu_node_fqs_2",
> >  			       "rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
> > +	static u8 fl_mask = 0x1;
> 
> What does 0x1 mean here? Is it for a particular flavor? This could use a
> comment.

Each flavor gets its own bit, and the first flavor gets 0x1, which is
the same as 1, but indicates its use as a bit mask.

> >  	int cpustride = 1;
> >  	int i;
> >  	int j;
> > @@ -3509,6 +3570,8 @@ static void __init rcu_init_one(struct rcu_state *rsp,
> >  	for (i = 1; i < rcu_num_lvls; i++)
> >  		rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
> >  	rcu_init_levelspread(rsp);
> > +	rsp->flavor_mask = fl_mask;
> > +	fl_mask <<= 1;
> 
> Something looks off here. fl_mask is not being used after this. Was it supposed
> to be used or is it just a stray statement? 

Note the "static" on the declaration.  The next call will see the updated
value, not the initial value.

> The flavor_mask operations could really use some comments as it is not really
> clear what is being achieved by that.

Seems pretty straightforward to me.  Each flavor gets a bit in ->flavor_mask,
starting with 0x1, then 0x2, then maybe 0x4 for preemptible kernels.

I believe that you were forgetting that "static" on a local variable
means that the variable is off-stack, and that later invocations see
updates from previous invocations.  Initialization of course happens
at compile time.

							Thanx, Paul

> --
> Pranith
> 
> >  
> >  	/* Initialize the elements themselves, starting from the leaves. */
> >  
> > diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> > index bf2c1e669691..0f69a79c5b7d 100644
> > --- a/kernel/rcu/tree.h
> > +++ b/kernel/rcu/tree.h
> > @@ -307,6 +307,9 @@ struct rcu_data {
> >  	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
> >  	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
> >  	unsigned long offline_fqs;	/* Kicked due to being offline. */
> > +	unsigned long cond_resched_completed;
> > +					/* Grace period that needs help */
> > +					/*  from cond_resched(). */
> >  
> >  	/* 5) __rcu_pending() statistics. */
> >  	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
> > @@ -392,6 +395,7 @@ struct rcu_state {
> >  	struct rcu_node *level[RCU_NUM_LVLS];	/* Hierarchy levels. */
> >  	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
> >  	u8 levelspread[RCU_NUM_LVLS];		/* kids/node in each level. */
> > +	u8 flavor_mask;				/* bit in flavor mask. */
> >  	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
> >  	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
> >  		     void (*func)(struct rcu_head *head));
> > @@ -563,7 +567,7 @@ static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
> >  static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
> >  static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
> >  static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
> > -static void rcu_kick_nohz_cpu(int cpu);
> > +static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
> >  static bool init_nocb_callback_list(struct rcu_data *rdp);
> >  static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
> >  static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index cbc2c45265e2..02ac0fb186b8 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -2404,7 +2404,7 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
> >   * if an adaptive-ticks CPU is failing to respond to the current grace
> >   * period and has not be idle from an RCU perspective, kick it.
> >   */
> > -static void rcu_kick_nohz_cpu(int cpu)
> > +static void __maybe_unused rcu_kick_nohz_cpu(int cpu)
> >  {
> >  #ifdef CONFIG_NO_HZ_FULL
> >  	if (tick_nohz_full_cpu(cpu))
> > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > index a2aeb4df0f60..d22309cae9f5 100644
> > --- a/kernel/rcu/update.c
> > +++ b/kernel/rcu/update.c
> > @@ -350,21 +350,3 @@ static int __init check_cpu_stall_init(void)
> >  early_initcall(check_cpu_stall_init);
> >  
> >  #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
> > -
> > -/*
> > - * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
> > - */
> > -
> > -DEFINE_PER_CPU(int, rcu_cond_resched_count);
> > -
> > -/*
> > - * Report a set of RCU quiescent states, for use by cond_resched()
> > - * and friends.  Out of line due to being called infrequently.
> > - */
> > -void rcu_resched(void)
> > -{
> > -	preempt_disable();
> > -	__this_cpu_write(rcu_cond_resched_count, 0);
> > -	rcu_note_context_switch(smp_processor_id());
> > -	preempt_enable();
> > -}
> > 
> 

