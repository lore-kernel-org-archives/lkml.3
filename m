Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbaFQRhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:37:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48647 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933325AbaFQRhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:37:22 -0400
Date: Tue, 17 Jun 2014 10:37:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Romanov Arya <romanov.arya@gmail.com>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: simplify
 force_quiescent_state()
Message-ID: <20140617173717.GA28198@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539FAE21.7070702@gmail.com>
 <20140617145419.GE4669@linux.vnet.ibm.com>
 <CAJKcOGdUDwdmdkpd0dw5xO9+TK=9W9fvF9Q+f5F_b4R8cEgdTA@mail.gmail.com>
 <53A07336.7030704@hp.com>
 <20140617171116.GH4669@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617171116.GH4669@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061717-7164-0000-0000-00000280B949
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:11:16AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 17, 2014 at 12:56:22PM -0400, Waiman Long wrote:
> > On 06/17/2014 12:01 PM, Romanov Arya wrote:
> > >On Tue, Jun 17, 2014 at 10:54 AM, Paul E. McKenney
> > ><paulmck@linux.vnet.ibm.com>  wrote:
> > >>On Mon, Jun 16, 2014 at 10:55:29PM -0400, Pranith Kumar wrote:
> > >>>This might sound really naive, but please bear with me.
> > >>>
> > >>>force_quiescent_state() used to do a lot of things in the past in addition to
> > >>>forcing a quiescent state. (In my reading of the mailing list I found state
> > >>>transitions for one).
> > >>>
> > >>>Now according to the code, what is being done is multiple callers try to go up
> > >>>the hierarchy of nodes to see who reaches the root node. The caller reaching the
> > >>>root node wins and it acquires root node lock and it gets to set rsp->gp_flags!
> > >>>
> > >>>At each level of the hierarchy we try to acquire fqslock. This is the only place
> > >>>which actually uses fqslock.
> > >>>
> > >>>I guess this was being done to avoid the contention on fqslock, but all we are
> > >>>doing here is setting one flag. This way of acquiring locks might reduce
> > >>>contention if every update is trying to do some independent work, but here all
> > >>>we are doing is setting the same flag with same value.
> > >>Actually, to reduce contention on rnp_root->lock.
> > >>
> > >>The trick is that the "losers" at each level of ->fqslock acquisition go
> > >>away.  The "winner" ends up doing the real work of setting RCU_GP_FLAG_FQS.
> > >>
> > >>>We can also remove fqslock completely if we do not need this. Also using
> > >>>cmpxchg() to set the value of the flag looks like a good idea to avoid taking
> > >>>the root node lock. Thoughts?
> > >>The ->fqslock funnel was needed to avoid lockups on large systems (many
> > >>hundreds or even thousands of CPUs).  Moving grace-period responsibilities
> > >>from softirq to the grace-period kthreads might have reduced contention
> > >>sufficienty to make the ->fqslock funnel unnecessary.  However, given
> > >>that I don't usually have access to such a large system, I will leave it,
> > >>at least for the time being.
> > >Sounds like a good case study for using the newly introduced MCS based
> > >locks(qspinlock.h).
> > >Waiman, Peter?
> > 
> > The ticket trylock and queue trylock are similar in the sense they
> > both do a read to check if the lock is free first and then use
> > cmpxchg() to acquire the lock. So if it is a problem to use ticket
> > spinlock, it will be a problem for the queue spinlock as well. The
> > advantage of the queue spinlock in a heavily contended case is that
> > the lock waiters except the one in the head of the queue will not be
> > contending the lock cacheline.
> > >Btw, is doing the following a bad idea? It reduces contention on
> > >rnp_root->lock using fqslock
> > >which seems to be the lock which needs to be taken while forcing a
> > >quiescent state:
> > 
> > I don't see any problem with the existing code as long as the number
> > of funnel levels is small.

Oh, and to answer the implicit question...  A properly configured 4096-CPU
system will have two funnel levels, with 64 nodes at the leaf level
and a single node at the root level.  If the system is not properly
configured, it will have three funnel levels.  The maximum number of
funnel levels is four, which would handle more than four million CPUs
(sixteen million if properly configured), so we should be good.  ;-)

The larger numbers of levels are intended strictly for testing.  I set
CONFIG_RCU_FANOUT_LEAF=2 and CONFIG_RCU_FANOUT=2 on a 16-CPU system just
to make sure that I am testing something uglier than what will be running
in production.  A large system should have both of these set to 64,
though this requires also booting with skew_tick=1 as well.

							Thanx, Paul

> >                            You really need to have some performance
> > data to show that your approach is better.
> 
> What Waiman said.
> 
> And you will need that performance data taken on systems with at least
> 1024 CPUs, because it was those systems that motivated this code.
> 
> 							Thanx, Paul
> 
> > >diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > >index f1ba773..f5a0e7e 100644
> > >--- a/kernel/rcu/tree.c
> > >+++ b/kernel/rcu/tree.c
> > >@@ -2401,34 +2401,24 @@ static void force_quiescent_state(struct rcu_state *rsp)
> > >      unsigned long flags;
> > >      bool ret;
> > >      struct rcu_node *rnp;
> > >-    struct rcu_node *rnp_old = NULL;
> > >-
> > >-    /* Funnel through hierarchy to reduce memory contention. */
> > >-    rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> > >-    for (; rnp != NULL; rnp = rnp->parent) {
> > >-        ret = (ACCESS_ONCE(rsp->gp_flags)&  RCU_GP_FLAG_FQS) ||
> > >-              !raw_spin_trylock(&rnp->fqslock);
> > >-        if (rnp_old != NULL)
> > >-            raw_spin_unlock(&rnp_old->fqslock);
> > >-        if (ret) {
> > >-            ACCESS_ONCE(rsp->n_force_qs_lh)++;
> > >-            return;
> > >-        }
> > >-        rnp_old = rnp;
> > >+    struct rcu_node *rnp_root = rcu_get_root(rsp);
> > >+
> > >+    if (!raw_spin_trylock(rnp_root->fqslock)) {
> > >+        ACCESS_ONCE(rsp->n_force_qs_lh)++;
> > >+        return;  /* Someone is already trying to force */
> > >      }
> > 
> > I think it is better to check the gp_flags first before doing a trylock.
> > 
> > -Longman
> > 

