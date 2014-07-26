Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaGZAvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 20:51:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47425 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaGZAvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 20:51:15 -0400
Date: Fri, 25 Jul 2014 17:51:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sasha.levin@oracle.com
Subject: Re: [PATCH RFC tip/core/rcu] Fix attempt to avoid offloading
 callbacks unless requested
Message-ID: <20140726005104.GK11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140725233623.GA18537@linux.vnet.ibm.com>
 <53D2F211.4090509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D2F211.4090509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072600-8236-0000-0000-000004245486
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 08:10:57PM -0400, Pranith Kumar wrote:
> On 07/25/2014 07:36 PM, Paul E. McKenney wrote:
> > [ Note: This applies on top of commit 187497fa5e9e (rcu: Allow for NULL
> >     tick_nohz_full_mask when nohz_full= missing) in -tip
> >     or -rcu.  To make this work on top of rcu/next, move the
> >     call to rcu_organize_nocb_kthreads(rsp) to the end of the
> >     for_each_rcu_flavor(rsp) loop in rcu_init_nohz(). ]
> >
> > Commit b58cc46c5f6b (rcu: Don't offload callbacks unless specifically
> > requested) failed to adjust the callback lists of the CPUs that are
> > known to be no-CBs CPUs only because they are also nohz_full= CPUs.
> > This failure can result in callbacks that are posted during early boot
> > getting stranded on nxtlist for CPUs whose no-CBs property becomes
> > apparent late, and there can also be spurious warnings about offline
> > CPUs posting callbacks.
> >
> > This commit fixes these problems by adding an early-boot rcu_init_nohz()
> > that properly initializes the no-CBs CPUs.
> >
> > Note that kernels built with CONFIG_RCU_NOCB_CPU_ALL=y or with
> > CONFIG_RCU_NOCB_CPU=n do not exhibit this bug.  Neither do kernels
> > booted without the nohz_full= boot parameter.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Please find two points below.
> 
> <snip>
> >  #ifdef CONFIG_TREE_PREEMPT_RCU
> > @@ -2451,6 +2424,66 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
> >      trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWakeEmpty"));
> >  }
> >  
> > +void rcu_init_nohz(void)
> > +{
> > +    int cpu;
> > +    bool need_rcu_nocb_mask = true;
> > +    struct rcu_state *rsp;
> > +
> > +#ifdef CONFIG_RCU_NOCB_CPU_NONE
> > +    need_rcu_nocb_mask = false;
> > +#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
> > +
> > +#if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL)
> > +    if (tick_nohz_full_running && cpumask_weight(tick_nohz_full_mask))
> > +        need_rcu_nocb_mask = true;
> > +#endif /* #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL) */
> > +
> > +    if (!have_rcu_nocb_mask && need_rcu_nocb_mask) {
> > +        zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
> 
> Please check the return value unless you want to increase my commit count ;)

I have already queued an adapted version of your patch on top of this
one, see below.  ;-)

> > +        have_rcu_nocb_mask = true;
> > +    }
> > +    if (!have_rcu_nocb_mask)
> > +        return;
> > +
> > +#ifdef CONFIG_RCU_NOCB_CPU_ZERO
> > +    pr_info("\tOffload RCU callbacks from CPU 0\n");
> > +    cpumask_set_cpu(0, rcu_nocb_mask);
> > +#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
> > +#ifdef CONFIG_RCU_NOCB_CPU_ALL
> > +    pr_info("\tOffload RCU callbacks from all CPUs\n");
> > +    cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
> > +#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
> > +#if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL)
> > +    cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
> > +#endif /* #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL) */
> 
> I understand that if CONFIG_NO_HZ_FULL_ALL is set then CONFIG_NOCB_CPU_ALL
> will also be set and there is no need for this cpumask_or().
> 
> Is there any reason for the coupling between CONFIG_NO_HZ_FULL_ALL
> and CONFIG_NOCB_CPU_ALL?
> 
> I ask because a user can override CONFIG_NO_HZ_FULL_ALL=y at boot time
> using the nohz_full= boot time parameter. In this case even if a user marks
> CPU 0 as the only nohz_full cpu, we will offload call backs from all CPUs.
> Is this behavior what you have in mind?

Yep.  The normal setup will be CONFIG_NO_HZ_FULL=y and
CONFIG_NO_HZ_FULL_ALL=n, and that works as you advocate.
If someone builds with CONFIG_NO_HZ_FULL_ALL=y, then they get
all CPUs offloaded.

Longer term, the hope is that offloading is unconditional, so that
CONFIG_NOCB_CPU and friends disappear, but the current code is most
definitely not up to that task yet.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Check the return value of zalloc_cpumask_var()

This commit checks the return value of the zalloc_cpumask_var() used for
allocating cpumask for rcu_nocb_mask.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 095d6e4d2fd7..5a6398e21bfc 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2440,7 +2440,10 @@ void rcu_init_nohz(void)
 #endif /* #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL) */
 
 	if (!have_rcu_nocb_mask && need_rcu_nocb_mask) {
-		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
+		if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
+			pr_info("rcu_nocb_mask allocation failed, callback offloading disabled.\n");
+			return;
+		}
 		have_rcu_nocb_mask = true;
 	}
 	if (!have_rcu_nocb_mask)

