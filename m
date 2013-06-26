Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3FZUxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:53:39 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48613 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3FZUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:53:37 -0400
Date: Wed, 26 Jun 2013 13:53:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>
Subject: Re: [RFC][PATCH RT 1/6] rt,rcu: Have rcu_read_lock_sched() use locks
 for PREEMPT_RT
Message-ID: <20130626205331.GS3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130626192806.107564905@goodmis.org>
 <20130626193049.724948276@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626193049.724948276@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062620-7408-0000-0000-00001189CF9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:28:07PM -0400, Steven Rostedt wrote:
> There are several critical sections that require synchronization with
> synchronize_sched(). Usually these are done by disabling preemption and
> the synchronize_sched() just waits for the kernel to schedule on each
> of the CPUs.
> 
> The rcu_read_lock_sched() is the preferred API to use, but some areas
> still use preempt_disable() and local_irq_*() to prevent preemption
> from happening. But our main concern is with those users of
> rcu_read_lock_sched(), where they may also call spin_locks() that turn
> into a mutex for PREEMPT_RT. For these cases, we need to allow
> rcu_read_lock_sched() to schedule out.
> 
> To allow rcu_read_lock_sched() sections to preempt when PREEMPT_RT is enabled,
> instead of disabling preemption, it will grab a local_lock(). Then the
> synchronize_sched() will grab all CPUs local_locks() and release them.
> After that, it still does the normal synchronize_sched() as there may be
> places that still disable preemption or irqs that it needs to
> synchronize with. By grabbing all the locks and releasing them, it will
> properly synchronize with those that use the locks instead of disabling
> preemption or interrupts.
> 
> Note: The rcu_read_lock_sched_notrace() version still only disables
> preemption, because they are used for lockdep and tracing, which require
> real preemption disabling and not mutexes.

This looks much better!

A few more questions and comments below.

							Thanx, Paul

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-rt.git/include/linux/rcupdate.h
> ===================================================================
> --- linux-rt.git.orig/include/linux/rcupdate.h
> +++ linux-rt.git/include/linux/rcupdate.h
> @@ -36,6 +36,7 @@
>  #include <linux/types.h>
>  #include <linux/cache.h>
>  #include <linux/spinlock.h>
> +#include <linux/locallock.h>
>  #include <linux/threads.h>
>  #include <linux/cpumask.h>
>  #include <linux/seqlock.h>
> @@ -870,6 +871,28 @@ static inline void rcu_read_unlock_bh(vo
>  	local_bh_enable();
>  }
> 
> +/* asm-offsets.c gets confused with local_lock here */
> +#if defined(CONFIG_PREEMPT_RT_FULL)
> +DECLARE_LOCAL_IRQ_LOCK(rcu_sched_lock);
> +static inline void rcu_read_lock_sched_disable(void)
> +{
> +	local_lock(rcu_sched_lock);
> +}
> +static inline void rcu_read_lock_sched_enable(void)
> +{
> +	local_unlock(rcu_sched_lock);
> +}
> +#else
> +static inline void rcu_read_lock_sched_disable(void)
> +{
> +	preempt_disable();
> +}
> +static inline void rcu_read_lock_sched_enable(void)
> +{
> +	preempt_enable();
> +}
> +#endif
> +
>  /**
>   * rcu_read_lock_sched() - mark the beginning of a RCU-sched critical section
>   *
> @@ -885,7 +908,7 @@ static inline void rcu_read_unlock_bh(vo
>   */

How about having an rcu_read_lock_sched_rt() and rcu_read_unlock_sched_rt()?
Leave rcu_read_lock_sched() and rcu_read_unlock_sched() with their prior
semantics and deadlock immunity, with a header comment for the _rt()
variants that gives their properties and where they should be used.

>  static inline void rcu_read_lock_sched(void)
>  {
> -	preempt_disable();
> +	rcu_read_lock_sched_disable();
>  	__acquire(RCU_SCHED);
>  	rcu_lock_acquire(&rcu_sched_lock_map);
>  	rcu_lockdep_assert(!rcu_is_cpu_idle(),
> @@ -910,7 +933,7 @@ static inline void rcu_read_unlock_sched
>  			   "rcu_read_unlock_sched() used illegally while idle");
>  	rcu_lock_release(&rcu_sched_lock_map);
>  	__release(RCU_SCHED);
> -	preempt_enable();
> +	rcu_read_lock_sched_enable();
>  }
> 
>  /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
> Index: linux-rt.git/kernel/rcutree.c
> ===================================================================
> --- linux-rt.git.orig/kernel/rcutree.c
> +++ linux-rt.git/kernel/rcutree.c
> @@ -2491,6 +2491,31 @@ static inline int rcu_blocking_is_gp(voi
>  	return ret;
>  }
> 
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +DEFINE_LOCAL_IRQ_LOCK(rcu_sched_lock);
> +/*
> + * Real-time allows for synchronize sched to sleep but not migrate.
> + * This is done via the local locks. When calling synchronize_sched(),
> + * all the local locks need to be taken and released. This will ensure
> + * that all users of rcu_read_lock_sched() will be out of their critical
> + * sections at the completion of this function. synchronize_sched() will
> + * still perform the normal RCU sched operations to synchronize with
> + * locations that use disabling preemption or interrupts.
> + */
> +static void rcu_synchronize_sched_rt(void)

The name synchronize_sched_rt() would fit better with the companion
synchronize_sched() function.

> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		spin_lock(&per_cpu(rcu_sched_lock, cpu).lock);
> +		spin_unlock(&per_cpu(rcu_sched_lock, cpu).lock);
> +	}
> +}
> +#else
> +static inline void rcu_synchronize_sched_rt(void)
> +{

I bet you want a synchronize_sched() here.  ;-)

But looking below...

> +}
> +#endif
>  /**
>   * synchronize_sched - wait until an rcu-sched grace period has elapsed.
>   *
> @@ -2538,6 +2563,9 @@ void synchronize_sched(void)
>  			   !lock_is_held(&rcu_lock_map) &&
>  			   !lock_is_held(&rcu_sched_lock_map),
>  			   "Illegal synchronize_sched() in RCU-sched read-side critical section");
> +
> +	rcu_synchronize_sched_rt();
> +

Are you sure you want a single primitive to wait on both types of
read-side critical sections?  I can see arguments on either side...

For completeness, another approach would be to use SRCU instead of locking
for the preemptible RCU-sched read-side critical sections.  One benefit
of doing this is that SRCU avoids introducing the potential deadlocks
that involve locks acquired both within and across read-side critical
sections.

>  	if (rcu_blocking_is_gp())
>  		return;
>  	if (rcu_expedited)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

