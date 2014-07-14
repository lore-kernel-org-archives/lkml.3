Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaGNQsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:48:51 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:56653 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbaGNQsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:48:43 -0400
Message-ID: <53C409F6.6080309@gmail.com>
Date: Mon, 14 Jul 2014 12:48:54 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
CC: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@go
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Create rcuo kthreads only for
 onlined CPUs
References: <20140714100604.GA9905@linux.vnet.ibm.com> <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com> <1405332404-10094-2-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1405332404-10094-2-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/14/2014 06:06 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>
> RCU currently uses for_each_possible_cpu() to spawn rcuo kthreads,
> which can result in more rcuo kthreads than one would expect, for
> example, derRichard reported 64 CPUs worth of rcuo kthreads on an
> 8-CPU image.  This commit therefore creates rcuo kthreads only for
> those CPUs that actually come online.
>
> Reported-by: derRichard
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcu/tree.c        |  4 ++-
>  kernel/rcu/tree.h        |  4 ++-
>  kernel/rcu/tree_plugin.h | 93 ++++++++++++++++++++++++++++++++++++++++++------
>  3 files changed, 88 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index eecdbe20a08e..a1abaa8abd49 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -3444,6 +3444,7 @@ static int rcu_cpu_notify(struct notifier_block *self,
>  	case CPU_UP_PREPARE_FROZEN:
>  		rcu_prepare_cpu(cpu);
>  		rcu_prepare_kthreads(cpu);
> +		rcu_spawn_all_nocb_kthreads(cpu);
>  		break;
>  	case CPU_ONLINE:
>  	case CPU_DOWN_FAILED:
> @@ -3508,8 +3509,8 @@ static int __init rcu_spawn_gp_kthread(void)
>  		raw_spin_lock_irqsave(&rnp->lock, flags);
>  		rsp->gp_kthread = t;
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -		rcu_spawn_nocb_kthreads(rsp);
>  	}
> +	rcu_spawn_nocb_kthreads();
>  	rcu_spawn_boost_kthreads();
>  	return 0;
>  }
> @@ -3643,6 +3644,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
>  		rcu_boot_init_percpu_data(i, rsp);
>  	}
>  	list_add(&rsp->flavors, &rcu_struct_flavors);
> +	rcu_organize_nocb_kthreads(rsp);
>  }
>  
>  /*
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index bd7b63da9a8c..f703ea8b7836 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -593,7 +593,9 @@ static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
>  static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
>  static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
>  static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
> -static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
> +static void rcu_spawn_all_nocb_kthreads(int cpu);
> +static void __init rcu_spawn_nocb_kthreads(void);
> +static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp);
>  static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
>  static bool init_nocb_callback_list(struct rcu_data *rdp);
>  static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index f5314cc20750..cedb020f1f90 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2455,15 +2455,85 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
>  	rdp->nocb_follower_tail = &rdp->nocb_follower_head;
>  }
>  
> +/*
> + * If the specified CPU is a no-CBs CPU that does not already have its
> + * rcuo kthread for the specified RCU flavor, spawn it.  If the CPUs are
> + * brought online out of order, this can require require re-organizing

double require, can remove one

> + * the leader-follower relationships.
> + */
> +static void rcu_spawn_one_nocb_kthread(struct rcu_state *rsp, int cpu)
> +{
> +	struct rcu_data *rdp;
> +	struct rcu_data *rdp_last;
> +	struct rcu_data *rdp_old_leader;
> +	struct rcu_data *rdp_spawn = per_cpu_ptr(rsp->rda, cpu);
> +	struct task_struct *t;
> +
> +	/*
> +	 * If this isn't a no-CBs CPU or if it already has an rcuo kthread,
> +	 * then nothing to do.
> +	 */
> +	if (!rcu_is_nocb_cpu(cpu) || rdp_spawn->nocb_kthread)
> +		return;
> +
> +	/* If we didn't spawn the leader first, reorganize! */
> +	rdp_old_leader = rdp_spawn->nocb_leader;
> +	if (rdp_old_leader != rdp_spawn && !rdp_old_leader->nocb_kthread) {
> +		rdp_last = NULL;
> +		rdp = rdp_old_leader;
> +		do {
> +			rdp->nocb_leader = rdp_spawn;
> +			if (rdp_last && rdp != rdp_spawn)
> +				rdp_last->nocb_next_follower = rdp;
> +			rdp_last = rdp;
> +			rdp = rdp->nocb_next_follower;
> +			rdp_last->nocb_next_follower = NULL;
> +		} while (rdp);
> +		rdp_spawn->nocb_next_follower = rdp_old_leader;
> +	}
> +
> +	/* Spawn the kthread for this CPU and RCU flavor. */
> +	t = kthread_run(rcu_nocb_kthread, rdp_spawn,
> +			"rcuo%c/%d", rsp->abbr, cpu);
> +	BUG_ON(IS_ERR(t));
> +	ACCESS_ONCE(rdp_spawn->nocb_kthread) = t;
> +}
> +
> +/*
> + * If the specified CPU is a no-CBs CPU that does not already have its
> + * rcuo kthreads, spawn them.
> + */
> +static void rcu_spawn_all_nocb_kthreads(int cpu)
> +{
> +	struct rcu_state *rsp;
> +
> +	if (rcu_scheduler_fully_active)
> +		for_each_rcu_flavor(rsp)
> +			rcu_spawn_one_nocb_kthread(rsp, cpu);
> +}
> +
> +/*
> + * Once the scheduler is running, spawn rcuo kthreads for all online
> + * no-CBs CPUs.  This assumes that the early_initcall()s happen before
> + * non-boot CPUs come online -- if this changes, we will need to add
> + * some mutual exclusion.
> + */
> +static void __init rcu_spawn_nocb_kthreads(void)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu)
> +		rcu_spawn_all_nocb_kthreads(cpu);
> +}

Minor nit but how about checking that the cpu is a no-CB cpu here? You are currently doing it in rcu_spawn_one_nocb_kthread two levels down.


        for_each_online_cpu(cpu)
-               rcu_spawn_all_nocb_kthreads(cpu);
+               if (rcu_is_nocb_cpu(cpu))
+                       rcu_spawn_all_nocb_kthreads(cpu);
 }
 

--
Pranith
