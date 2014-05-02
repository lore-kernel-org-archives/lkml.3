Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaEBViZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:38:25 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51361 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaEBViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:38:23 -0400
Date: Fri, 2 May 2014 14:38:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH] sched: Sanitize irq accounting madness
Message-ID: <20140502213819.GU8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.02.1405022307000.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405022307000.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050221-7164-0000-0000-0000017A6E3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 11:26:24PM +0200, Thomas Gleixner wrote:
> Russell reported, that irqtime_account_idle_ticks() takes ages due to:
> 
>        for (i = 0; i < ticks; i++)
>                irqtime_account_process_tick(current, 0, rq);
> 
> It's sad, that this code was written way _AFTER_ the NOHZ idle
> functionality was available. I charge myself guitly for not paying
> attention when that crap got merged with commit abb74cefa (sched:
> Export ns irqtimes through /proc/stat)
> 
> So instead of looping nr_ticks times just apply the whole thing at
> once.
> 
> As a side note: The whole cputime_t vs. u64 business in that context
> wants to be cleaned up as well. There is no point in having all these
> back and forth conversions. Lets standardise on u64 nsec for all
> kernel internal accounting and be done with it. Everything else does
> not make sense at all for fine grained accounting. Frederic, can you
> please take care of that?
> 
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org

One nit below, other than that:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/sched/cputime.c |   32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> Index: linux-2.6/kernel/sched/cputime.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/cputime.c
> +++ linux-2.6/kernel/sched/cputime.c
> @@ -332,50 +332,50 @@ out:
>   * softirq as those do not count in task exec_runtime any more.
>   */
>  static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
> -						struct rq *rq)
> +					 struct rq *rq, int ticks)
>  {
> -	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
> +	cputime_t scaled = cputime_to_scaled(cputime_one_jiffy);
> +	u64 cputime = (__force u64) cputime_one_jiffy;
>  	u64 *cpustat = kcpustat_this_cpu->cpustat;
> 
>  	if (steal_account_process_tick())
>  		return;
> 
> +	cputime *= ticks;
> +	scaled *= ticks;
> +
>  	if (irqtime_account_hi_update()) {
> -		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
> +		cpustat[CPUTIME_IRQ] += cputime;
>  	} else if (irqtime_account_si_update()) {
> -		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
> +		cpustat[CPUTIME_SOFTIRQ] += cputime;
>  	} else if (this_cpu_ksoftirqd() == p) {
>  		/*
>  		 * ksoftirqd time do not get accounted in cpu_softirq_time.
>  		 * So, we have to handle it separately here.
>  		 * Also, p->stime needs to be updated for ksoftirqd.
>  		 */
> -		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
> -					CPUTIME_SOFTIRQ);
> +		__account_system_time(p, cputime, scaled, CPUTIME_SOFTIRQ);
>  	} else if (user_tick) {
> -		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
> +		account_user_time(p, cputime, scaled);
>  	} else if (p == rq->idle) {
> -		account_idle_time(cputime_one_jiffy);
> +		account_idle_time(cputime);
>  	} else if (p->flags & PF_VCPU) { /* System time or guest time */
> -		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
> +		account_guest_time(p, cputime, scaled);
>  	} else {
> -		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
> -					CPUTIME_SYSTEM);
> +		__account_system_time(p, cputime, scaled,	CPUTIME_SYSTEM);

Stray tab character.

>  	}
>  }
> 
>  static void irqtime_account_idle_ticks(int ticks)
>  {
> -	int i;
>  	struct rq *rq = this_rq();
> 
> -	for (i = 0; i < ticks; i++)
> -		irqtime_account_process_tick(current, 0, rq);
> +	irqtime_account_process_tick(current, 0, rq, ticks);
>  }
>  #else /* CONFIG_IRQ_TIME_ACCOUNTING */
>  static inline void irqtime_account_idle_ticks(int ticks) {}
>  static inline void irqtime_account_process_tick(struct task_struct *p, int user_tick,
> -						struct rq *rq) {}
> +						struct rq *rq, int nr_ticks) {}
>  #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
> 
>  /*
> @@ -464,7 +464,7 @@ void account_process_tick(struct task_st
>  		return;
> 
>  	if (sched_clock_irqtime) {
> -		irqtime_account_process_tick(p, user_tick, rq);
> +		irqtime_account_process_tick(p, user_tick, rq, 1);
>  		return;
>  	}
> 
> 

