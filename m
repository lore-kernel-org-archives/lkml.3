Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbaIBU6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:58:35 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49370 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaIBU6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:58:34 -0400
Date: Tue, 2 Sep 2014 13:58:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: rcu: Remove rcu_dynticks * parameters when they are always
 this_cpu_ptr(&rcu_dynticks)
Message-ID: <20140902205828.GN5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.11.1409021512520.26284@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409021512520.26284@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090220-8236-0000-0000-00000514B1F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 03:13:44PM -0500, Christoph Lameter wrote:
> For some functions in kernel/rcu/tree* the rdtp parameter is always this_cpu_ptr(rdtp).
> Remove the parameter if constant and calculate the pointer in function.
> 
> This will have the advantage that it is obvious that the address are all per cpu
> offsets and thus it will enable the use of this_cpu_ops in the future.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Looks plausible, thank you.  Let's see what testing, especially
Fengguang's testing, makes of this.  ;-)

							Thanx, Paul

> Index: linux/kernel/rcu/tree.c
> ===================================================================
> --- linux.orig/kernel/rcu/tree.c
> +++ linux/kernel/rcu/tree.c
> @@ -499,11 +499,11 @@ cpu_needs_another_gp(struct rcu_state *r
>   * we really have entered idle, and must do the appropriate accounting.
>   * The caller must have disabled interrupts.
>   */
> -static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
> -				bool user)
> +static void rcu_eqs_enter_common(long long oldval, bool user)
>  {
>  	struct rcu_state *rsp;
>  	struct rcu_data *rdp;
> +	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
> 
>  	trace_rcu_dyntick(TPS("Start"), oldval, rdtp->dynticks_nesting);
>  	if (!user && !is_idle_task(current)) {
> @@ -553,7 +553,7 @@ static void rcu_eqs_enter(bool user)
>  	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
>  	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE) {
>  		rdtp->dynticks_nesting = 0;
> -		rcu_eqs_enter_common(rdtp, oldval, user);
> +		rcu_eqs_enter_common(oldval, user);
>  	} else {
>  		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
>  	}
> @@ -577,7 +577,7 @@ void rcu_idle_enter(void)
> 
>  	local_irq_save(flags);
>  	rcu_eqs_enter(false);
> -	rcu_sysidle_enter(this_cpu_ptr(&rcu_dynticks), 0);
> +	rcu_sysidle_enter(0);
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_idle_enter);
> @@ -627,8 +627,8 @@ void rcu_irq_exit(void)
>  	if (rdtp->dynticks_nesting)
>  		trace_rcu_dyntick(TPS("--="), oldval, rdtp->dynticks_nesting);
>  	else
> -		rcu_eqs_enter_common(rdtp, oldval, true);
> -	rcu_sysidle_enter(rdtp, 1);
> +		rcu_eqs_enter_common(oldval, true);
> +	rcu_sysidle_enter(1);
>  	local_irq_restore(flags);
>  }
> 
> @@ -639,9 +639,11 @@ void rcu_irq_exit(void)
>   * we really have exited idle, and must do the appropriate accounting.
>   * The caller must have disabled interrupts.
>   */
> -static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
> +static void rcu_eqs_exit_common(long long oldval,
>  			       int user)
>  {
> +	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
> +
>  	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
>  	atomic_inc(&rdtp->dynticks);
>  	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
> @@ -678,7 +680,7 @@ static void rcu_eqs_exit(bool user)
>  		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
>  	} else {
>  		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
> -		rcu_eqs_exit_common(rdtp, oldval, user);
> +		rcu_eqs_exit_common(oldval, user);
>  	}
>  }
> 
> @@ -699,7 +701,7 @@ void rcu_idle_exit(void)
> 
>  	local_irq_save(flags);
>  	rcu_eqs_exit(false);
> -	rcu_sysidle_exit(this_cpu_ptr(&rcu_dynticks), 0);
> +	rcu_sysidle_exit(0);
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_idle_exit);
> @@ -750,8 +752,8 @@ void rcu_irq_enter(void)
>  	if (oldval)
>  		trace_rcu_dyntick(TPS("++="), oldval, rdtp->dynticks_nesting);
>  	else
> -		rcu_eqs_exit_common(rdtp, oldval, true);
> -	rcu_sysidle_exit(rdtp, 1);
> +		rcu_eqs_exit_common(oldval, true);
> +	rcu_sysidle_exit(1);
>  	local_irq_restore(flags);
>  }
> 
> Index: linux/kernel/rcu/tree.h
> ===================================================================
> --- linux.orig/kernel/rcu/tree.h
> +++ linux/kernel/rcu/tree.h
> @@ -595,8 +595,8 @@ static void rcu_boot_init_nocb_percpu_da
>  static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
>  static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
>  static bool init_nocb_callback_list(struct rcu_data *rdp);
> -static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
> -static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
> +static void rcu_sysidle_enter(int irq);
> +static void rcu_sysidle_exit(int irq);
>  static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
>  				  unsigned long *maxj);
>  static bool is_sysidle_rcu_state(struct rcu_state *rsp);
> Index: linux/kernel/rcu/tree_plugin.h
> ===================================================================
> --- linux.orig/kernel/rcu/tree_plugin.h
> +++ linux/kernel/rcu/tree_plugin.h
> @@ -2618,9 +2618,10 @@ static int full_sysidle_state;		/* Curre
>   * to detect full-system idle states, not RCU quiescent states and grace
>   * periods.  The caller must have disabled interrupts.
>   */
> -static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
> +static void rcu_sysidle_enter(int irq)
>  {
>  	unsigned long j;
> +	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
> 
>  	/* Adjust nesting, check for fully idle. */
>  	if (irq) {
> @@ -2685,8 +2686,9 @@ void rcu_sysidle_force_exit(void)
>   * usermode execution does -not- count as idle here!  The caller must
>   * have disabled interrupts.
>   */
> -static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
> +static void rcu_sysidle_exit(int irq)
>  {
> +	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
>  	/* Adjust nesting, check for already non-idle. */
>  	if (irq) {
>  		rdtp->dynticks_idle_nesting++;
> @@ -2968,11 +2970,11 @@ static void rcu_sysidle_init_percpu_data
> 
>  #else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
> 
> -static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
> +static void rcu_sysidle_enter(int irq)
>  {
>  }
> 
> -static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
> +static void rcu_sysidle_exit(int irq)
>  {
>  }
> 

