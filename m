Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaGZCaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:30:21 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53175 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaGZCaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:30:20 -0400
Date: Sat, 26 Jul 2014 04:30:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, sasha.levin@oracle.com
Subject: Re: [PATCH RFC tip/core/rcu] Fix attempt to avoid offloading
 callbacks unless requested
Message-ID: <20140726023013.GG16182@localhost.localdomain>
References: <20140725233623.GA18537@linux.vnet.ibm.com>
 <53D2F211.4090509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D2F211.4090509@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
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
> 
> >
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

Yeah, for any nohz full CPU, we need the corresponding CPU to be rcu_nocb.
So if all CPUs are full dynticks, all CPUs must be rcunocb.

That said with this patch, the dependency is perhaps not needed anymore.

> 
> I ask because a user can override CONFIG_NO_HZ_FULL_ALL=y at boot time
> using the nohz_full= boot time parameter.

No, the content of nohz_full= is ignored with CONFIG_NO_HZ_FULL_ALL=y.

That said you made me check and I realize that when that happens, we alloc
the mask two times and we leak the first. I need to fix that.

Thanks.
