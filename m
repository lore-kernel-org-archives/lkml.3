Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbaFYR6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:58:06 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52857 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825AbaFYR6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:58:02 -0400
From: bsegall@google.com
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, <tkhai@yandex.ru>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Mike Galbraith" <umgwanakikbuti@gmail.com>, <khorenko@parallels.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH v3 1/3] sched/fair: Disable runtime_enabled on dying rq
References: <20140625081502.2861.12526.stgit@tkhai>
	<1403684382.3462.42.camel@tkhai>
Date: Wed, 25 Jun 2014 10:57:59 -0700
In-Reply-To: <1403684382.3462.42.camel@tkhai> (Kirill Tkhai's message of "Wed,
	25 Jun 2014 12:19:42 +0400")
Message-ID: <xm267g44zxaw.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Tkhai <ktkhai@parallels.com> writes:

> We kill rq->rd on the CPU_DOWN_PREPARE stage:
>
> 	cpuset_cpu_inactive -> cpuset_update_active_cpus -> partition_sched_domains ->
> 	-> cpu_attach_domain -> rq_attach_root -> set_rq_offline
>
> This unthrottles all throttled cfs_rqs.
>
> But the cpu is still able to call schedule() till
>
> 	take_cpu_down->__cpu_disable()
>
> is called from stop_machine.
>
> This case the tasks from just unthrottled cfs_rqs are pickable
> in a standard scheduler way, and they are picked by dying cpu.
> The cfs_rqs becomes throttled again, and migrate_tasks()
> in migration_call skips their tasks (one more unthrottle
> in migrate_tasks()->CPU_DYING does not happen, because rq->rd
> is already NULL).
>
> Patch sets runtime_enabled to zero. This guarantees, the runtime
> is not accounted, and the cfs_rqs won't exceed given
> cfs_rq->runtime_remaining = 1, and tasks will be pickable
> in migrate_tasks(). runtime_enabled is recalculated again
> when rq becomes online again.
>
> Ben Segall also noticed, we always enable runtime in
> tg_set_cfs_bandwidth(). Actually, we should do that for online
> cpus only. To prevent races with unthrottle_offline_cfs_rqs()
> we take get_online_cpus() lock.
>
> v2: Fix race with tg_set_cfs_bandwidth().
>     Move cfs_rq->runtime_enabled=0 above unthrottle_cfs_rq().
> v3: {get,put}_online_cpus()
>
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> CC: Konstantin Khorenko <khorenko@parallels.com>
> CC: Ben Segall <bsegall@google.com>
> CC: Paul Turner <pjt@google.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Mike Galbraith <umgwanakikbuti@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ben Segall <bsegall@google.com>

Although #ifdefing rq->online might work too. It's possibly faster but a
bit more ugly to look at, I don't care which way it is done.


> ---
>  kernel/sched/core.c |    8 +++++++-
>  kernel/sched/fair.c |   22 ++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ceea8d0..d9c4a08 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7807,6 +7807,11 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
>  	if (period > max_cfs_quota_period)
>  		return -EINVAL;
>  
> +	/*
> +	 * Prevent race between setting of cfs_rq->runtime_enabled and
> +	 * unthrottle_offline_cfs_rqs().
> +	 */
> +	get_online_cpus();
>  	mutex_lock(&cfs_constraints_mutex);
>  	ret = __cfs_schedulable(tg, period, quota);
>  	if (ret)
> @@ -7832,7 +7837,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
>  	}
>  	raw_spin_unlock_irq(&cfs_b->lock);
>  
> -	for_each_possible_cpu(i) {
> +	for_each_online_cpu(i) {
>  		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
>  		struct rq *rq = cfs_rq->rq;
>  
> @@ -7848,6 +7853,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
>  		cfs_bandwidth_usage_dec();
>  out_unlock:
>  	mutex_unlock(&cfs_constraints_mutex);
> +	put_online_cpus();
>  
>  	return ret;
>  }
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1f9c457..5616d23 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3776,6 +3776,19 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
>  	hrtimer_cancel(&cfs_b->slack_timer);
>  }
>  
> +static void __maybe_unused update_runtime_enabled(struct rq *rq)
> +{
> +	struct cfs_rq *cfs_rq;
> +
> +	for_each_leaf_cfs_rq(rq, cfs_rq) {
> +		struct cfs_bandwidth *cfs_b = &cfs_rq->tg->cfs_bandwidth;
> +
> +		raw_spin_lock(&cfs_b->lock);
> +		cfs_rq->runtime_enabled = cfs_b->quota != RUNTIME_INF;
> +		raw_spin_unlock(&cfs_b->lock);
> +	}
> +}
> +
>  static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
>  {
>  	struct cfs_rq *cfs_rq;
> @@ -3789,6 +3802,12 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
>  		 * there's some valid quota amount
>  		 */
>  		cfs_rq->runtime_remaining = 1;
> +		/*
> +		 * Offline rq is schedulable till cpu is completely disabled
> +		 * in take_cpu_down(), so we prevent new cfs throttling here.
> +		 */
> +		cfs_rq->runtime_enabled = 0;
> +
>  		if (cfs_rq_throttled(cfs_rq))
>  			unthrottle_cfs_rq(cfs_rq);
>  	}
> @@ -3832,6 +3851,7 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
>  	return NULL;
>  }
>  static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
> +static inline void update_runtime_enabled(struct rq *rq) {}
>  static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
>  
>  #endif /* CONFIG_CFS_BANDWIDTH */
> @@ -7325,6 +7345,8 @@ void trigger_load_balance(struct rq *rq)
>  static void rq_online_fair(struct rq *rq)
>  {
>  	update_sysctl();
> +
> +	update_runtime_enabled(rq);
>  }
>  
>  static void rq_offline_fair(struct rq *rq)
