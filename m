Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaIBUht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:37:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38266 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaIBUhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:37:47 -0400
Date: Tue, 2 Sep 2014 13:37:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
Message-ID: <20140902203743.GL5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.11.1409021513490.26284@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409021513490.26284@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090220-1542-0000-0000-0000047B74CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 03:14:43PM -0500, Christoph Lameter wrote:
> 
> Since dynticks_idle is only ever modified by the local cpu we do
> not need to use an atomic there. The weak "atomicity" of this_cpu
> ops is sufficient since there is no other cpu modifying the variable.
> 
> [This is a cautious patch that leaves the barriers in place]

Actually, not so cautious.  On x86:

#define smp_mb__before_atomic() barrier()
#define smp_mb__after_atomic()  barrier()

But yes, in theory, something like this can work if appropriate memory
barriers are put in place.  In practice, this sort of change needs
profound testing on multiple architectures.

							Thanx, Paul

> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/kernel/rcu/tree.c
> ===================================================================
> --- linux.orig/kernel/rcu/tree.c
> +++ linux/kernel/rcu/tree.c
> @@ -213,7 +213,7 @@ static DEFINE_PER_CPU(struct rcu_dyntick
>  	.dynticks = ATOMIC_INIT(1),
>  #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
>  	.dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE,
> -	.dynticks_idle = ATOMIC_INIT(1),
> +	.dynticks_idle = 1,
>  #endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
>  };
> 
> Index: linux/kernel/rcu/tree.h
> ===================================================================
> --- linux.orig/kernel/rcu/tree.h
> +++ linux/kernel/rcu/tree.h
> @@ -91,7 +91,7 @@ struct rcu_dynticks {
>  #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
>  	long long dynticks_idle_nesting;
>  				    /* irq/process nesting level from idle. */
> -	atomic_t dynticks_idle;	    /* Even value for idle, else odd. */
> +	long dynticks_idle;	    /* Even value for idle, else odd. */
>  				    /*  "Idle" excludes userspace execution. */
>  	unsigned long dynticks_idle_jiffies;
>  				    /* End of last non-NMI non-idle period. */
> Index: linux/kernel/rcu/tree_plugin.h
> ===================================================================
> --- linux.orig/kernel/rcu/tree_plugin.h
> +++ linux/kernel/rcu/tree_plugin.h
> @@ -2644,9 +2644,9 @@ static void rcu_sysidle_enter(int irq)
>  	j = jiffies;
>  	ACCESS_ONCE(rdtp->dynticks_idle_jiffies) = j;
>  	smp_mb__before_atomic();
> -	atomic_inc(&rdtp->dynticks_idle);
> +	this_cpu_inc(rcu_dynticks.dynticks_idle);
>  	smp_mb__after_atomic();
> -	WARN_ON_ONCE(atomic_read(&rdtp->dynticks_idle) & 0x1);
> +	WARN_ON_ONCE(__this_cpu_read(rcu_dynticks.dynticks_idle) & 0x1);
>  }
> 
>  /*
> @@ -2712,9 +2712,9 @@ static void rcu_sysidle_exit(int irq)
> 
>  	/* Record end of idle period. */
>  	smp_mb__before_atomic();
> -	atomic_inc(&rdtp->dynticks_idle);
> +	this_cpu_inc(rcu_dynticks.dynticks_idle);
>  	smp_mb__after_atomic();
> -	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
> +	WARN_ON_ONCE(!(__this_cpu_read(rcu_dynticks.dynticks_idle) & 0x1));
> 
>  	/*
>  	 * If we are the timekeeping CPU, we are permitted to be non-idle
> @@ -2755,7 +2755,7 @@ static void rcu_sysidle_check_cpu(struct
>  		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
> 
>  	/* Pick up current idle and NMI-nesting counter and check. */
> -	cur = atomic_read(&rdtp->dynticks_idle);
> +	cur = rdtp->dynticks_idle;
>  	if (cur & 0x1) {
>  		*isidle = false; /* We are not idle! */
>  		return;
> 

