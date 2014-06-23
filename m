Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbaFWRgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:36:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52174 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbaFWRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:36:19 -0400
Date: Mon, 23 Jun 2014 10:36:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, sbw@mit.edu, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@gentwo.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC tip/core/rcu 1/5] rcu: Reduce overhead of
 cond_resched() checks for RCU
Message-ID: <20140623173613.GI4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140623164321.GA5543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623164321.GA5543@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062317-0928-0000-0000-000002DC7CB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:43:21PM +0200, Oleg Nesterov wrote:
> On 06/20, Paul E. McKenney wrote:
> >
> > This commit takes a different approach to fixing this bug, mainly by
> > avoiding having cond_resched() do an RCU-visible quiescent state unless
> > there is a grace period that has been in flight for a significant period
> > of time.  This commit also reduces the common-case cond_resched() overhead
> > to a check of a single per-CPU variable.
> 
> I can't say I fully understand this change, but I think it is fine.
> Just a really stupid question below.
> 
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
> > +		smp_mb(); /* ->flavor_mask before ->cond_resched_completed. */
> > +		if (ACCESS_ONCE(rdp->mynode->completed) !=
> > +		    ACCESS_ONCE(rdp->cond_resched_completed))
> > +			continue;
> 
> Probably the comment above mb() meant "rcu_cond_resched_mask before
> ->cond_resched_completed" ? Otherwise I can't see why do we need any
> barrier.

You are absolutely right, changed as suggested.

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
> 
> OK, in this case I guess we need a full barrier because we need to read
> rcu_cond_resched_mask before updating it...
> 
> But, I am just curious, is there any reason to use ACCESS_ONCE() twice?
> 
> 	ACCESS_ONCE(*rcrmp) |= rdp->rsp->flavor_mask;
> 
> or even
> 
> 	ACCESS_ONCE(per_cpu(rcu_cond_resched_mask, rdp->cpu)) |=
> 		rdp->rsp->flavor_mask;
> 
> should equally work, or ACCESS_ONCE() can't be used to RMW ?

It can be, but Linus doesn't like it to be.  I recently changed all of
the RMW ACCESS_ONCE() calls as a result.  One of the reasons for avoiding
RMW ACCESS_ONCE() is that language features that might one day replace
ACCESS_ONCE() do not support RMW use.

> (and in fact at least the 2nd ACCESS_ONCE() (load) looks unnecessary anyway
>  because of smp_mb() above).

It is unlikely, but without ACCESS_ONCE() some misbegotten compiler could
split the load and still claim to be conforming to the standard.  :-(
(This is called "load tearing" by the standards guys.)

> Once again, of course I am not arguing if there is no "real" reason and you
> just prefer it this way. But the kernel has more and more ACESS_ONCE() users
> and sometime I simply do not understand why it is needed. For example,
> cyc2ns_write_end().

Could be concern about store tearing.

> Or even INIT_LIST_HEAD_RCU(). The comment in list_splice_init_rcu() says:
> 
> 	/*
> 	 * "first" and "last" tracking list, so initialize it.  RCU readers
> 	 * have access to this list, so we must use INIT_LIST_HEAD_RCU()
> 	 * instead of INIT_LIST_HEAD().
> 	 */
> 
> 	INIT_LIST_HEAD_RCU(list);
> 
> but we are going to call synchronize_rcu() or something similar, this should
> act as compiler barrier too?

Indeed, synchronize_rcu() enforces a barrier on each CPU between
any prior and subsequent accesses to RCU-protected data by that CPU.
(Which means that CPUs that would otherwise sleep through the entire
grace period can continue sleeping, given that it is not accessing
any RCU-protected data while sleeping.)  I would guess load-tearing
or store-tearing concerns.


							Thanx, Paul

