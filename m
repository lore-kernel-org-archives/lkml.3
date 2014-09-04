Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaIDTcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:32:54 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35743 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaIDTcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:32:53 -0400
Date: Thu, 4 Sep 2014 12:32:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
Message-ID: <20140904193248.GK5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140903021152.GA14069@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409030846310.9372@gentwo.org>
 <20140903144349.GT5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031043540.24085@gentwo.org>
 <20140903171409.GZ5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031226001.24691@gentwo.org>
 <20140903181931.GB5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409040944220.4565@gentwo.org>
 <20140904161629.GF5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409041303250.14314@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409041303250.14314@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090419-9332-0000-0000-000001E853AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 01:19:29PM -0500, Christoph Lameter wrote:
> On Thu, 4 Sep 2014, Paul E. McKenney wrote:
> 
> > So in short, you don't see the potential for this use case actually
> > breaking anything, correct?
> 
> In general its a performance impact but depending on how this_cpu_ops may
> be implemented in a particular platform there may also be correctness
> issues since the assumption there is that no remote writes occur.

This assumption of yours does not seem to be shared by a fair amount
of the code using per-CPU variables.

> There is a slight issue in th RCU code. It uses DEFINE_PER_CPU for
> per cpu data which is used for true per cpu data where the
> cachelines are not evicted. False aliasing RCU structure that are
> remotely handled can cause issue for code that expects the per cpu data
> to be not contended. I think it would be better to go to
> 
> DEFINE_PER_CPU_SHARED_ALIGNED
> 
> for your definitions in particular since there are still code pieces where
> we are not sure if there are remote write accesses or not. This will give
> you separate cachelines so that the false aliasing effect is not
> occurring.

Fair enough, I have queued a commit that makes this change for the
rcu_data per-CPU structures with your Report-by.  (See below for patch.)

> > Besides RCU is not the only place where atomics are used on per-CPU
> > variables.  For one thing, there are a number of per-CPU spinlocks in use
> > in various places throughout the kernel.  For another thing, there is also
> > a large number of per-CPU structures (not pointers to structures, actual
> > structures), and I bet that a fair number of these feature cross-CPU
> > writes and cross-CPU atomics.  RCU's rcu_data structures certainly do.
> 
> Would be interested to see where that occurs.

Something like the following will find them for you:

git grep "DEFINE_PER_CPU.*spinlock"
git grep "DEFINE_PER_CPU.*(struct[^*]*$"

> > > the barrier issues, per cpu variables are updated always without the use
> > > of atomics and the inspection of the per cpu state from remote cpus works
> > > just fine also without them.
> >
> > Including the per-CPU spinlocks?  That seems a bit unlikely.  And again,
> > I expect that a fair number of the per-CPU structures involve cross-CPU
> > synchronization.
> 
> Where are those per cpu spinlocks? Cross cpu synchronization can be done
> in a number of ways that often allow avoiding remote writes to percpu
> areas.

The lglocks use should be of particular interest to you.  See above to
find the others.

> > It already is consistent, just not in the manner that you want.  ;-)
> >
> > But -why- do you want these restrictions?  How does it help anything?
> 
> 1. It allows potentially faster operations that allow to make the
> assumption that no remote writes occur. The design of deterministic low
> latency code often needs some assurances that another cpu is not simply
> kicking the cacheline out which will then require off chip memory access
> and remote cacheline eviction once the cacheline is touched again.

OK, DEFINE_PER_CPU_SHARED_ALIGNED() should avoid the false sharing.

> 2. The use of atomic without a rationale is something that I frown upon
> and it seems very likely that we have such a case here. People make
> assumptions that the use of atomic has some reason, like a remote access
> or contention, which is not occurring here.

Understood, but no hasty changes to that part of RCU.

> 3. this_cpu operations create instructions with reduced latency due tothe
> lack of lock prefix. Remote operations at the same time could create
> inconsistent results.
> 
> See also
> 
> linux/Documentation/this_cpu_ops.txt

Yep.  If you use atomic operations, you need to be very careful about
mixing in non-atomic operations, which in this case includes the
per-CPU atomic operations.  Normally the atomic_t and atomic_long_t
types make it difficult to mess up.  Of course, you can work around
this type checking, and you can also use xchg() and cmpxchg(), which
don't provide this type-checking misuse-avoidance help.

Just as it has always been.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Use DEFINE_PER_CPU_SHARED_ALIGNED for rcu_data

The rcu_data per-CPU variable has a number of fields that are atomically
manipulated, potentially by any CPU.  This situation can result in false
sharing with per-CPU variables that have the misfortune of being allocated
adjacent to rcu_data in memory.  This commit therefore changes the
DEFINE_PER_CPU() to DEFINE_PER_CPU_SHARED_ALIGNED() in order to avoid
this false sharing.

Reported-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1b7eba915dbe..e4c6d604694e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -105,7 +105,7 @@ struct rcu_state sname##_state = { \
 	.name = RCU_STATE_NAME(sname), \
 	.abbr = sabbr, \
 }; \
-DEFINE_PER_CPU(struct rcu_data, sname##_data)
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, sname##_data)
 
 RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
 RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);

