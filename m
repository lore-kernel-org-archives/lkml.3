Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643Ab3DDRHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:07:46 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:47192 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763549Ab3DDRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <1364996263-12198-1-git-send-email-vincent.guittot@linaro.org>
References: <1364996263-12198-1-git-send-email-vincent.guittot@linaro.org>
Date: Thu, 4 Apr 2013 19:07:40 +0200
Message-ID: <CAFTL4hxt++4aRw_6uTDH4HDgac6-g1bU4Unq_BXuzwM5QBK_yQ@mail.gmail.com>
Subject: Re: [PATCH Resend v5] sched: fix init NOHZ_IDLE flag
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-kernel@lists.linaro.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/3 Vincent Guittot <vincent.guittot@linaro.org>:
> On my smp platform which is made of 5 cores in 2 clusters, I have the
> nr_busy_cpu field of sched_group_power struct that is not null when the
> platform is fully idle. The root cause is:
> During the boot sequence, some CPUs reach the idle loop and set their
> NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
> field is initialized later with the assumption that all CPUs are in the busy
> state whereas some CPUs have already set their NOHZ_IDLE flag.
>
> More generally, the NOHZ_IDLE flag must be initialized when new sched_domains
> are created in order to ensure that NOHZ_IDLE and nr_busy_cpus are aligned.
>
> This condition can be ensured by adding a synchronize_rcu between the
> destruction of old sched_domains and the creation of new ones so the NOHZ_IDLE
> flag will not be updated with old sched_domain once it has been initialized.
> But this solution introduces a additionnal latency in the rebuild sequence
> that is called during cpu hotplug.
>
> As suggested by Frederic Weisbecker, another solution is to have the same
> rcu lifecycle for both NOHZ_IDLE and sched_domain struct. I have introduce
> a new sched_domain_rq struct that is the entry point for both sched_domains
> and objects that must follow the same lifecycle like NOHZ_IDLE flags. They
> will share the same RCU lifecycle and will be always synchronized.
>
> The synchronization is done at the cost of :
>  - an additional indirection for accessing the first sched_domain level
>  - an additional indirection and a rcu_dereference before accessing to the
>    NOHZ_IDLE flag.
>
> Change since v4:
>  - link both sched_domain and NOHZ_IDLE flag in one RCU object so
>    their states are always synchronized.
>
> Change since V3;
>  - NOHZ flag is not cleared if a NULL domain is attached to the CPU
>  - Remove patch 2/2 which becomes useless with latest modifications
>
> Change since V2:
>  - change the initialization to idle state instead of busy state so a CPU that
>    enters idle during the build of the sched_domain will not corrupt the
>    initialization state
>
> Change since V1:
>  - remove the patch for SCHED softirq on an idle core use case as it was
>    a side effect of the other use cases.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  include/linux/sched.h |    6 +++
>  kernel/sched/core.c   |  105 ++++++++++++++++++++++++++++++++++++++++++++-----
>  kernel/sched/fair.c   |   35 +++++++++++------
>  kernel/sched/sched.h  |   24 +++++++++--
>  4 files changed, 145 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d35d2b6..2a52188 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -959,6 +959,12 @@ struct sched_domain {
>         unsigned long span[0];
>  };
>
> +struct sched_domain_rq {
> +       struct sched_domain *sd;
> +       unsigned long flags;
> +       struct rcu_head rcu;    /* used during destruction */
> +};
> +
>  static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
>  {
>         return to_cpumask(sd->span);
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 7f12624..69e2313 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5602,6 +5602,15 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
>                 destroy_sched_domain(sd, cpu);
>  }
>
> +static void destroy_sched_domain_rq(struct sched_domain_rq *sd_rq, int cpu)
> +{
> +       if (!sd_rq)
> +               return;
> +
> +       destroy_sched_domains(sd_rq->sd, cpu);
> +       kfree_rcu(sd_rq, rcu);
> +}
> +
>  /*
>   * Keep a special pointer to the highest sched_domain that has
>   * SD_SHARE_PKG_RESOURCE set (Last Level Cache Domain) for this
> @@ -5632,10 +5641,23 @@ static void update_top_cache_domain(int cpu)
>   * hold the hotplug lock.
>   */
>  static void
> -cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
> +cpu_attach_domain(struct sched_domain_rq *sd_rq, struct root_domain *rd,
> +               int cpu)
>  {
>         struct rq *rq = cpu_rq(cpu);
> -       struct sched_domain *tmp;
> +       struct sched_domain_rq *tmp_rq;
> +       struct sched_domain *tmp, *sd = NULL;
> +
> +       /*
> +        * If we don't have any sched_domain and associated object, we can
> +        * directly jump to the attach sequence otherwise we try to degenerate
> +        * the sched_domain
> +        */
> +       if (!sd_rq)
> +               goto attach;
> +
> +       /* Get a pointer to the 1st sched_domain */
> +       sd = sd_rq->sd;
>
>         /* Remove the sched domains which do not contribute to scheduling. */
>         for (tmp = sd; tmp; ) {
> @@ -5658,14 +5680,17 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
>                 destroy_sched_domain(tmp, cpu);
>                 if (sd)
>                         sd->child = NULL;
> +               /* update sched_domain_rq */
> +               sd_rq->sd = sd;
>         }
>
> +attach:
>         sched_domain_debug(sd, cpu);
>
>         rq_attach_root(rq, rd);
> -       tmp = rq->sd;
> -       rcu_assign_pointer(rq->sd, sd);
> -       destroy_sched_domains(tmp, cpu);
> +       tmp_rq = rq->sd_rq;
> +       rcu_assign_pointer(rq->sd_rq, sd_rq);
> +       destroy_sched_domain_rq(tmp_rq, cpu);
>
>         update_top_cache_domain(cpu);
>  }
> @@ -5695,12 +5720,14 @@ struct sd_data {
>  };
>
>  struct s_data {
> +       struct sched_domain_rq ** __percpu sd_rq;
>         struct sched_domain ** __percpu sd;
>         struct root_domain      *rd;
>  };
>
>  enum s_alloc {
>         sa_rootdomain,
> +       sa_sd_rq,
>         sa_sd,
>         sa_sd_storage,
>         sa_none,
> @@ -5935,7 +5962,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>                 return;
>
>         update_group_power(sd, cpu);
> -       atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
> +       atomic_set(&sg->sgp->nr_busy_cpus, 0);

Is it possible that we can be dealing here with a
sched_group/sched_group_power that is used on another CPU (from that
CPU's rq->rq_sd->sd) concurrently?
When we call build_sched_groups(), we might reuse an exisiting struct
sched_group used elsewhere right? If so, is there a race with the
above initialization?
