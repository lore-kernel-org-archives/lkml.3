Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbaJ2Mrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:47:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37480 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbaJ2Mrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:47:41 -0400
Date: Wed, 29 Oct 2014 05:47:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle()
 function
Message-ID: <20141029124728.GL5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1414580827-19545-1-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414580827-19545-1-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102912-0017-0000-0000-000005E99066
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:07:07PM +0100, Alexander Gordeev wrote:
> Function rcu_is_cpu_rrupt_from_idle() is called from scheduling-
> clock interrupt handler to check if the current CPU was interrupted
> from idle. If true, it results in invocation of RCU callbacks. But
> the common hardware interrupt exit path also contains similar check
> and therefore the call to rcu_is_cpu_rrupt_from_idle() is redundant.

By common hardware interrupt exit path, you are meaning the calls
to rcu_irq_exit()?  If not, please let me know exactly what you
mean here.

							Thanx, Paul

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcu/tiny.c | 12 +-----------
>  kernel/rcu/tree.c | 14 +-------------
>  2 files changed, 2 insertions(+), 24 deletions(-)
> 
> diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
> index c0623fc..0bfb3b9 100644
> --- a/kernel/rcu/tiny.c
> +++ b/kernel/rcu/tiny.c
> @@ -186,16 +186,6 @@ EXPORT_SYMBOL(__rcu_is_watching);
>  #endif /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
> 
>  /*
> - * Test whether the current CPU was interrupted from idle.  Nested
> - * interrupts don't count, we must be running at the first interrupt
> - * level.
> - */
> -static int rcu_is_cpu_rrupt_from_idle(void)
> -{
> -	return rcu_dynticks_nesting <= 1;
> -}
> -
> -/*
>   * Helper function for rcu_sched_qs() and rcu_bh_qs().
>   * Also irqs are disabled to avoid confusion due to interrupt handlers
>   * invoking call_rcu().
> @@ -250,7 +240,7 @@ void rcu_bh_qs(void)
>  void rcu_check_callbacks(int cpu, int user)
>  {
>  	RCU_TRACE(check_cpu_stalls());
> -	if (user || rcu_is_cpu_rrupt_from_idle())
> +	if (user)
>  		rcu_sched_qs();
>  	else if (!in_softirq())
>  		rcu_bh_qs();
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 133e472..8e9341c 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -884,18 +884,6 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
> 
>  #endif /* #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU) */
> 
> -/**
> - * rcu_is_cpu_rrupt_from_idle - see if idle or immediately interrupted from idle
> - *
> - * If the current CPU is idle or running at a first-level (not nested)
> - * interrupt from idle, return true.  The caller must have at least
> - * disabled preemption.
> - */
> -static int rcu_is_cpu_rrupt_from_idle(void)
> -{
> -	return __this_cpu_read(rcu_dynticks.dynticks_nesting) <= 1;
> -}
> -
>  /*
>   * Snapshot the specified CPU's dynticks counter so that we can later
>   * credit them with an implicit quiescent state.  Return 1 if this CPU
> @@ -2391,7 +2379,7 @@ void rcu_check_callbacks(int cpu, int user)
>  {
>  	trace_rcu_utilization(TPS("Start scheduler-tick"));
>  	increment_cpu_stall_ticks();
> -	if (user || rcu_is_cpu_rrupt_from_idle()) {
> +	if (user) {
> 
>  		/*
>  		 * Get here if this CPU took its interrupt from user
> -- 
> 1.8.3.1
> 

