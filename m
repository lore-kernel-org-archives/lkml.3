Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaJ2LAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:00:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:41931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaJ2LAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:00:00 -0400
Date: Wed, 29 Oct 2014 11:59:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 3/7] rcu: Avoid IPIing idle CPUs from
 synchronize_sched_expedited()
Message-ID: <20141029105954.GZ3337@twins.programming.kicks-ass.net>
References: <20141028222224.GA28263@linux.vnet.ibm.com>
 <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534982-29203-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414534982-29203-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:22:58PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Currently, synchronize_sched_expedited() sends IPIs to all online CPUs,
> even those that are idle or executing in nohz_full= userspace.  Because
> idle CPUs and nohz_full= userspace CPUs are in extended quiescent states,
> there is no need to IPI them in the first place.  This commit therefore
> avoids IPIing CPUs that are already in extended quiescent states.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcu/tree.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 7f73c5edf8cf..9e3c20f117cd 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -2950,6 +2950,9 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
>   */
>  void synchronize_sched_expedited(void)
>  {
> +	cpumask_var_t cm;
> +	bool cma = false;
> +	int cpu;
>  	long firstsnap, s, snap;
>  	int trycount = 0;
>  	struct rcu_state *rsp = &rcu_sched_state;
> @@ -2984,11 +2987,26 @@ void synchronize_sched_expedited(void)
>  	}
>  	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
>  
> +	/* Offline CPUs, idle CPUs, and any CPU we run on are quiescent. */
> +	cma = zalloc_cpumask_var(&cm, GFP_KERNEL);
> +	if (cma) {
> +		cpumask_copy(cm, cpu_online_mask);
> +		cpumask_clear_cpu(raw_smp_processor_id(), cm);
> +		for_each_cpu(cpu, cm) {
> +			struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
> +
> +			if (!(atomic_add_return(0, &rdtp->dynticks) & 0x1))
> +				cpumask_clear_cpu(cpu, cm);
> +		}
> +		if (cpumask_weight(cm) == 0)
> +			goto all_cpus_idle;
> +	}

Is there a reason not to use on_each_cpu_cond()?
