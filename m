Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887Ab3IGBTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 21:19:37 -0400
Received: from mail.openrapids.net ([64.15.138.104]:38211 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750726Ab3IGBTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 21:19:36 -0400
Date: Fri, 6 Sep 2013 21:19:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
	section?
Message-ID: <20130907011930.GA19943@Krystal>
References: <20130906105934.GF20519@somewhere> <20130906151851.GQ3966@linux.vnet.ibm.com> <20130906113320.46b2ea3e@gandalf.local.home> <20130906164016.GB2706@somewhere> <20130906125238.3c5ef919@gandalf.local.home> <20130906170006.GC2706@somewhere> <20130906131631.6a0a192d@gandalf.local.home> <20130906175238.GV3966@linux.vnet.ibm.com> <20130906142135.438caba1@gandalf.local.home> <20130907004923.GD3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130907004923.GD3966@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Fri, Sep 06, 2013 at 02:21:35PM -0400, Steven Rostedt wrote:
> > On Fri, 6 Sep 2013 10:52:38 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > > What exactly does "extended quiescent state" mean? (Note, that's a
> > > > rhetorical question)
> > > 
> > > In which case my rhetorical (and therefore useless) answer has to be
> > > "it is a quiescent state that is extended".  ;-)
> > > 
> > > Sorry, couldn't resist...
> > 
> > Of course you couldn't ;)
> > 
> > > 
> > > > I wonder if we should change "rcu_cpu_ignore()" for "rcu_eqs_enter()"
> > > > and "rcu_cpu_heed()" for "rcu_eqs_exit()", as IMHO that's much more
> > > > straight forward to understand than trying to wrap you head around what
> > > > a quiescent state is, and why we are entering it or exiting it.
> > > > 
> > > > It also flat out explains to people that rcu is not processing that
> > > > current CPU, and things like rcu_read_lock() should not be used.
> > > > 
> > > > Then we can say "rcu_cpu_is_ignored()" for things like
> > > > "rcu_is_cpu_eqs()".
> > > 
> > > Currently, none of RCU's _eqs functions are exported, so they have
> > > the potential to confuse only people working on the RCU implementation
> > > itself, who had better understand what "eqs" means.
> > 
> > Yeah, that's what I thought, and never cared about the "eqs" meaning.
> > 
> > > 
> > > But I do count your vote against "eqs" appearing in the name of any
> > > function exported by RCU.
> > 
> > Right, their shouldn't be any "eqs" functions that are global to users
> > outside of the RCU infrastructure.
> > 
> > > 
> > > How about if I made rcu_is_cpu_idle() be as follows?
> > > 
> > > int rcu_is_cpu_idle(void)
> > > {
> > > 	int ret;
> > > 
> > > 	ret = (atomic_read(&per_cpu(rcu_dynticks.dynticks,
> > > 				    raw_smp_processor_id())) & 0x1) == 0;
> > > 	return ret;
> > > }
> > > 
> > > This should allow existing uses to function properly and should allow
> > > you to use it as well.
> > >
> > 
> > You already said it wont work, but I still would have been against
> > using it, because I wouldn't be checking if rcu thinks the CPU is idle,
> > as NO_HZ_FULL has nothing to do with idle.
> 
> OK then, how about the following?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Is it safe to enter an RCU read-side critical section?
> 
> There is currently no way for kernel code to determine whether it
> is safe to enter an RCU read-side critical section, in other words,
> whether or not RCU is paying attention to the currently running CPU.
> Given the large and increasing quantity of code shared by the idle loop
> and non-idle code, the this shortcoming is becoming increasingly painful.
> 
> This commit therefore adds rcu_watching_this_cpu(), which returns true
> if it is safe to enter an RCU read-side critical section on the currently
> running CPU.  This function is quite fast, using only a __this_cpu_read().
> However, the caller must disable preemption.

Hi Paul,

Hopefully I won't be redundant with other prior comments, but how about
the following:

static inline __rcu_read_check(void):
  - checks if it is safe to enter a RCU read-side critical section in
    the current context.
  - requires that the caller disable preemption.

static inline rcu_read_check(void):
  - disables preemption and inlines __rcu_read_check().

I don't think it is semantically a good thing to bury the
implementation-specific detail (whether is RCU watched on this
particular CPU) into the API naming. Also, I think the generic version
of this check should require no "special knowledge" from the user, hence
my double-underscores proposal for the optimized version.

Thoughts ?

Thanks,

Mathieu

> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 5b444e0..a41eb35 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -261,6 +261,10 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
>  		rcu_irq_exit(); \
>  	} while (0)
>  
> +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
> +extern int rcu_is_cpu_idle(void);
> +#endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
> +
>  /*
>   * Infrastructure to implement the synchronize_() primitives in
>   * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
> @@ -297,10 +301,6 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
>  }
>  #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
>  
> -#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_SMP)
> -extern int rcu_is_cpu_idle(void);
> -#endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_SMP) */
> -
>  #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU)
>  bool rcu_lockdep_current_cpu_online(void);
>  #else /* #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index e31005e..67fe672 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -132,4 +132,13 @@ static inline void rcu_scheduler_starting(void)
>  }
>  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
> +#ifdef CONFIG_RCU_TRACE
> +
> +static inline bool rcu_watching_this_cpu(void)
> +{
> +	return !rcu_is_cpu_idle();
> +}
> +
> +#endif /* #ifdef CONFIG_RCU_TRACE */
> +
>  #endif /* __LINUX_RCUTINY_H */
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 226169d..c605b41 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -90,4 +90,6 @@ extern void exit_rcu(void);
>  extern void rcu_scheduler_starting(void);
>  extern int rcu_scheduler_active __read_mostly;
>  
> +extern bool rcu_watching_this_cpu(void);
> +
>  #endif /* __LINUX_RCUTREE_H */
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 7e3b0d6..b14701f 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -176,7 +176,7 @@ void rcu_irq_enter(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_irq_enter);
>  
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE)
>  
>  /*
>   * Test whether RCU thinks that the current CPU is idle.
> @@ -187,7 +187,7 @@ int rcu_is_cpu_idle(void)
>  }
>  EXPORT_SYMBOL(rcu_is_cpu_idle);
>  
> -#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> +#endif /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
>  
>  /*
>   * Test whether the current CPU was interrupted from idle.  Nested
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index a06d172..38c6883 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -666,6 +666,19 @@ int rcu_is_cpu_idle(void)
>  }
>  EXPORT_SYMBOL(rcu_is_cpu_idle);
>  
> +/**
> + * rcu_watching_this_cpu - are RCU read-side critical sections safe?
> + *
> + * Return true if RCU is watching the running CPU, which means that
> + * this CPU can safely enter RCU read-side critical sections.  Unlike
> + * rcu_is_cpu_idle(), the caller of rcu_watching_this_cpu() must have at
> + * least disabled preemption.
> + */
> +bool rcu_watching_this_cpu(void)
> +{
> +	return !!__this_cpu_read(rcu_dynticks.dynticks_nesting);
> +}
> +
>  #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
>  
>  /*
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
