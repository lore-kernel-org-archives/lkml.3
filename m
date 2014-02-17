Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaBQXdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 18:33:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55194 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaBQXdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:33:38 -0500
Date: Mon, 17 Feb 2014 15:33:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/3] rcu: Optimize rcu_is_nocb_cpu() for
 RCU_NOCB_CPU_ALL
Message-ID: <20140217233331.GR4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140217214007.GA6609@linux.vnet.ibm.com>
 <1392673227-7066-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140217215053.GE7941@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217215053.GE7941@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021723-0928-0000-0000-000006C3BC12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:50:53PM -0800, Josh Triplett wrote:
> On Mon, Feb 17, 2014 at 01:40:25PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > If CONFIG_RCU_NOCB_CPU_ALL=y, then rcu_is_nocb_cpu() will always
> > return true, however, the current version nevertheless checks
> > rcu_nocb_mask.  This commit therefore creates a static inline
> > implementation of rcu_is_nocb_cpu() that unconditionally returns
> > true when CONFIG_RCU_NOCB_CPU_ALL=y.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> One suggestion below.  With or without that change:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I like the change -- applied both it and your Reviewed-by.

							Thanx, Paul

> >  include/linux/rcupdate.h | 4 ++++
> >  kernel/rcu/tree_plugin.h | 2 ++
> >  2 files changed, 6 insertions(+)
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 72bf3a01a4ee..92365b1fede4 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -1016,7 +1016,11 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
> >  	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
> >  
> >  #ifdef CONFIG_RCU_NOCB_CPU
> > +#ifdef CONFIG_RCU_NOCB_CPU_ALL
> > +static inline bool rcu_is_nocb_cpu(int cpu) { return true; }
> > +#else /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
> >  bool rcu_is_nocb_cpu(int cpu);
> > +#endif /* #else #ifdef CONFIG_RCU_NOCB_CPU_ALL */
> >  #else
> >  static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
> >  #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
> 
> This seem clearer if written without the nesting:
> 
> #if defined(CONFIG_RCU_NOCB_CPU_ALL)
> static inline bool rcu_is_nocb_cpu(int cpu) { return true; }
> #elif defined(CONFIG_RCU_NOCB_CPU)
> bool rcu_is_nocb_cpu(int cpu);
> #else
> static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
> #endif
> 
> That clearly distinguishes the three cases: all, some, none.
> 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 6e2ef4b2b920..39a50b918bff 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -2101,6 +2101,7 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
> >  	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
> >  }
> >  
> > +#ifndef CONFIG_RCU_NOCB_CPU_ALL
> >  /* Is the specified CPU a no-CPUs CPU? */
> >  bool rcu_is_nocb_cpu(int cpu)
> >  {
> > @@ -2108,6 +2109,7 @@ bool rcu_is_nocb_cpu(int cpu)
> >  		return cpumask_test_cpu(cpu, rcu_nocb_mask);
> >  	return false;
> >  }
> > +#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
> >  
> >  /*
> >   * Enqueue the specified string of rcu_head structures onto the specified
> > -- 
> > 1.8.1.5
> > 
> 

