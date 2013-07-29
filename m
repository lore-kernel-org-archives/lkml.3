Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3G2Dcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 23:32:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45471 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab3G2DcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 23:32:10 -0400
X-IronPort-AV: E=Sophos;i="4.89,766,1367942400"; 
   d="scan'208";a="8053015"
Message-ID: <51F5E325.4000607@cn.fujitsu.com>
Date: Mon, 29 Jul 2013 11:36:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 7/7] nohz_full: Force RCU's grace-period
 kthreads onto timekeeping CPU
References: <20130726231848.GA12967@linux.vnet.ibm.com> <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com> <1374880764-14248-7-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1374880764-14248-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 11:29:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 11:30:00,
	Serialize complete at 2013/07/29 11:30:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 07:19 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Because RCU's quiescent-state-forcing mechanism is used to drive the
> full-system-idle state machine, and because this mechanism is executed
> by RCU's grace-period kthreads, this commit forces these kthreads to
> run on the timekeeping CPU (tick_do_timer_cpu).  To do otherwise would
> mean that the RCU grace-period kthreads would force the system into
> non-idle state every time they drove the state machine, which would
> be just a bit on the futile side.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/rcutree.c        |  1 +
>  kernel/rcutree.h        |  1 +
>  kernel/rcutree_plugin.h | 20 +++++++++++++++++++-
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index aa6d96e..fe83085 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1286,6 +1286,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  	struct rcu_data *rdp;
>  	struct rcu_node *rnp = rcu_get_root(rsp);
>  
> +	rcu_bind_gp_kthread();
>  	raw_spin_lock_irq(&rnp->lock);
>  	rsp->gp_flags = 0; /* Clear all flags: New grace period. */

bind the gp thread when RCU_GP_FLAG_INIT ...

>  
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index e0de5dc..49dac99 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -560,6 +560,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
>  static bool is_sysidle_rcu_state(struct rcu_state *rsp);
>  static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
>  				  unsigned long maxj);
> +static void rcu_bind_gp_kthread(void);
>  static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
>  
>  #endif /* #ifndef RCU_TREE_NONCORE */
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index ff84bed..f65d9c2 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -2544,7 +2544,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
>  	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
>  	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
>  		return;
> -	/* WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu); */
> +	WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);


but call rcu_sysidle_check_cpu() when RCU_GP_FLAG_FQS.

In this time, the thread may not be bound to tick_do_timer_cpu,
the WARN_ON_ONCE() may be wrong.

Does any other code ensure the gp thread bound on tick_do_timer_cpu
which I missed?

>  
>  	/* Pick up current idle and NMI-nesting counter and check. */
>  	cur = atomic_read(&rdtp->dynticks_idle);
> @@ -2570,6 +2570,20 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
>  }
>  
>  /*
> + * Bind the grace-period kthread for the sysidle flavor of RCU to the
> + * timekeeping CPU.
> + */
> +static void rcu_bind_gp_kthread(void)
> +{
> +	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
> +
> +	if (cpu < 0 || cpu >= nr_cpu_ids)
> +		return;
> +	if (raw_smp_processor_id() != cpu)
> +		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> +}
> +
> +/*
>   * Return a delay in jiffies based on the number of CPUs, rcu_node
>   * leaf fanout, and jiffies tick rate.  The idea is to allow larger
>   * systems more time to transition to full-idle state in order to
> @@ -2767,6 +2781,10 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
>  	return false;
>  }
>  
> +static void rcu_bind_gp_kthread(void)
> +{
> +}
> +
>  static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
>  				  unsigned long maxj)
>  {

