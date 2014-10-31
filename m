Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaJaRgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:36:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43662 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaJaRgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:36:08 -0400
Date: Fri, 31 Oct 2014 10:36:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle()
 from tiny RCU
Message-ID: <20141031173603.GA15718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141029151622.GD30198@agordeev.usersys.redhat.com>
 <20141029154615.GR5718@linux.vnet.ibm.com>
 <20141029210916.GB13273@agordeev.usersys.redhat.com>
 <20141030000524.GG5718@linux.vnet.ibm.com>
 <20141030175435.GC13273@agordeev.usersys.redhat.com>
 <20141030204318.GR5718@linux.vnet.ibm.com>
 <20141030215433.GA18126@agordeev.usersys.redhat.com>
 <20141031034559.GT5718@linux.vnet.ibm.com>
 <20141031145326.GB18126@agordeev.usersys.redhat.com>
 <20141031145504.GC18126@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031145504.GC18126@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14103117-0005-0000-0000-00000608A47B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 02:55:05PM +0000, Alexander Gordeev wrote:
> Let's start assuming that something in the idle loop posts a callback,
> and scheduling-clock interrupt occurs:
> 
> 1. The system is idle and stays that way, no runnable tasks.
> 
> 2. Scheduling-clock interrupt occurs, rcu_check_callbacks() is called
>    as result, which in turn calls rcu_is_cpu_rrupt_from_idle().
> 
> 3. rcu_is_cpu_rrupt_from_idle() reports the CPU was interrupted from
>    idle, which results in rcu_sched_qs() call, which does a
>    raise_softirq(RCU_SOFTIRQ).
> 
> 4. Upon return from interrupt, rcu_irq_exit() is invoked, which calls
>    rcu_idle_enter_common(), which in turn calls rcu_sched_qs() again,
>    which does another raise_softirq(RCU_SOFTIRQ).
> 
> 5. The softirq happens shortly and invokes rcu_process_callbacks(),
>    which invokes __rcu_process_callbacks().
> 
> 6. So now callbacks can be invoked. At least they can be if
>    ->donetail has been updated. Which it will have been because
>    rcu_sched_qs() invokes rcu_qsctr_help().
> 
> In the described scenario rcu_sched_qs() and raise_softirq(RCU_SOFTIRQ)
> get called twice in steps 3 and 4. This redundancy could be eliminated
> by removing rcu_is_cpu_rrupt_from_idle() function.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Queued for 3.20, thank you!

							Thanx, Paul

> ---
>  kernel/rcu/tiny.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
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
>  void rcu_check_callbacks(int user)
>  {
>  	RCU_TRACE(check_cpu_stalls());
> -	if (user || rcu_is_cpu_rrupt_from_idle())
> +	if (user)
>  		rcu_sched_qs();
>  	else if (!in_softirq())
>  		rcu_bh_qs();
> -- 
> 1.8.3.1
> 
> -- 
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

