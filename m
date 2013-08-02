Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab3HBJI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:08:58 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:65166 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab3HBJIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:08:54 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-aa-51fb77249f03
Date: Fri, 2 Aug 2013 18:08:52 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v2 2/3] sched: factor out code to should_we_balance()
Message-ID: <20130802090851.GA11057@lge.com>
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375408223-10934-3-git-send-email-iamjoonsoo.kim@lge.com>
 <CAKfTPtDa4eDZP58YaBeT31VWRBQ-44Wen34aKsxSseOxUYD6NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDa4eDZP58YaBeT31VWRBQ-44Wen34aKsxSseOxUYD6NQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 09:51:45AM +0200, Vincent Guittot wrote:
> On 2 August 2013 03:50, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > Now checking whether this cpu is appropriate to balance or not
> > is embedded into update_sg_lb_stats() and this checking has no direct
> > relationship to this function. There is not enough reason to place
> > this checking at update_sg_lb_stats(), except saving one iteration
> > for sched_group_cpus.
> >
> > In this patch, I factor out this checking to should_we_balance() function.
> > And before doing actual work for load_balancing, check whether this cpu is
> > appropriate to balance via should_we_balance(). If this cpu is not
> > a candidate for balancing, it quit the work immediately.
> >
> > With this change, we can save two memset cost and can expect better
> > compiler optimization.
> >
> > Below is result of this patch.
> >
> > * Vanilla *
> >    text    data     bss     dec     hex filename
> >   34499    1136     116   35751    8ba7 kernel/sched/fair.o
> >
> > * Patched *
> >    text    data     bss     dec     hex filename
> >   34243    1136     116   35495    8aa7 kernel/sched/fair.o
> >
> > In addition, rename @balance to @should_balance in order to represent
> > its purpose more clearly.
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index eaae77e..7f51b8c 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4426,22 +4426,17 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
> >   * @group: sched_group whose statistics are to be updated.
> >   * @load_idx: Load index of sched_domain of this_cpu for load calc.
> >   * @local_group: Does group contain this_cpu.
> > - * @balance: Should we balance.
> >   * @sgs: variable to hold the statistics for this group.
> >   */
> >  static inline void update_sg_lb_stats(struct lb_env *env,
> >                         struct sched_group *group, int load_idx,
> > -                       int local_group, int *balance, struct sg_lb_stats *sgs)
> > +                       int local_group, struct sg_lb_stats *sgs)
> >  {
> >         unsigned long nr_running, max_nr_running, min_nr_running;
> >         unsigned long load, max_cpu_load, min_cpu_load;
> > -       unsigned int balance_cpu = -1, first_idle_cpu = 0;
> >         unsigned long avg_load_per_task = 0;
> >         int i;
> >
> > -       if (local_group)
> > -               balance_cpu = group_balance_cpu(group);
> > -
> >         /* Tally up the load of all CPUs in the group */
> >         max_cpu_load = 0;
> >         min_cpu_load = ~0UL;
> > @@ -4454,15 +4449,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
> >                 nr_running = rq->nr_running;
> >
> >                 /* Bias balancing toward cpus of our domain */
> > -               if (local_group) {
> > -                       if (idle_cpu(i) && !first_idle_cpu &&
> > -                                       cpumask_test_cpu(i, sched_group_mask(group))) {
> > -                               first_idle_cpu = 1;
> > -                               balance_cpu = i;
> > -                       }
> > -
> > +               if (local_group)
> >                         load = target_load(i, load_idx);
> > -               } else {
> > +               else {
> >                         load = source_load(i, load_idx);
> >                         if (load > max_cpu_load)
> >                                 max_cpu_load = load;
> > @@ -4482,22 +4471,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
> >                         sgs->idle_cpus++;
> >         }
> >
> > -       /*
> > -        * First idle cpu or the first cpu(busiest) in this sched group
> > -        * is eligible for doing load balancing at this and above
> > -        * domains. In the newly idle case, we will allow all the cpu's
> > -        * to do the newly idle load balance.
> > -        */
> > -       if (local_group) {
> > -               if (env->idle != CPU_NEWLY_IDLE) {
> > -                       if (balance_cpu != env->dst_cpu) {
> > -                               *balance = 0;
> > -                               return;
> > -                       }
> > -                       update_group_power(env->sd, env->dst_cpu);
> > -               } else if (time_after_eq(jiffies, group->sgp->next_update))
> > -                       update_group_power(env->sd, env->dst_cpu);
> > -       }
> > +       if (local_group && (env->idle != CPU_NEWLY_IDLE ||
> > +                       time_after_eq(jiffies, group->sgp->next_update)))
> > +               update_group_power(env->sd, env->dst_cpu);
> >
> >         /* Adjust by relative CPU power of the group */
> >         sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
> > @@ -4576,7 +4552,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
> >   * @sds: variable to hold the statistics for this sched_domain.
> >   */
> >  static inline void update_sd_lb_stats(struct lb_env *env,
> > -                                       int *balance, struct sd_lb_stats *sds)
> > +                                       struct sd_lb_stats *sds)
> >  {
> >         struct sched_domain *child = env->sd->child;
> >         struct sched_group *sg = env->sd->groups;
> > @@ -4593,10 +4569,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
> >
> >                 local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
> >                 memset(&sgs, 0, sizeof(sgs));
> > -               update_sg_lb_stats(env, sg, load_idx, local_group, balance, &sgs);
> > -
> > -               if (local_group && !(*balance))
> > -                       return;
> > +               update_sg_lb_stats(env, sg, load_idx, local_group, &sgs);
> >
> >                 sds->total_load += sgs.group_load;
> >                 sds->total_pwr += sg->sgp->power;
> > @@ -4829,8 +4802,6 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
> >   * to restore balance.
> >   *
> >   * @env: The load balancing environment.
> > - * @balance: Pointer to a variable indicating if this_cpu
> > - *     is the appropriate cpu to perform load balancing at this_level.
> >   *
> >   * Returns:    - the busiest group if imbalance exists.
> >   *             - If no imbalance and user has opted for power-savings balance,
> > @@ -4838,7 +4809,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
> >   *                put to idle by rebalancing its tasks onto our group.
> >   */
> >  static struct sched_group *
> > -find_busiest_group(struct lb_env *env, int *balance)
> > +find_busiest_group(struct lb_env *env)
> >  {
> >         struct sd_lb_stats sds;
> >
> > @@ -4848,14 +4819,7 @@ find_busiest_group(struct lb_env *env, int *balance)
> >          * Compute the various statistics relavent for load balancing at
> >          * this level.
> >          */
> > -       update_sd_lb_stats(env, balance, &sds);
> > -
> > -       /*
> > -        * this_cpu is not the appropriate cpu to perform load balancing at
> > -        * this level.
> > -        */
> > -       if (!(*balance))
> > -               goto ret;
> > +       update_sd_lb_stats(env, &sds);
> >
> >         if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
> >             check_asym_packing(env, &sds))
> > @@ -4919,7 +4883,6 @@ force_balance:
> >         return sds.busiest;
> >
> >  out_balanced:
> > -ret:
> >         env->imbalance = 0;
> >         return NULL;
> >  }
> > @@ -5001,13 +4964,47 @@ static int need_active_balance(struct lb_env *env)
> >
> >  static int active_load_balance_cpu_stop(void *data);
> >
> > +static int should_we_balance(struct lb_env *env)
> > +{
> > +       struct sched_group *sg = env->sd->groups;
> > +       struct cpumask *sg_cpus, *sg_mask;
> > +       int cpu, balance_cpu = -1;
> > +
> > +       /*
> > +        * In the newly idle case, we will allow all the cpu's
> > +        * to do the newly idle load balance.
> > +        */
> > +       if (env->idle == CPU_NEWLY_IDLE)
> > +               return 1;
> > +
> > +       sg_cpus = sched_group_cpus(sg);
> > +       sg_mask = sched_group_mask(sg);
> > +       /* Try to find first idle cpu */
> > +       for_each_cpu_and(cpu, sg_cpus, env->cpus) {
> > +               if (!cpumask_test_cpu(cpu, sg_mask) || idle_cpu(cpu))
> > +                       continue;
> > +
> > +               balance_cpu = cpu;
> > +               break;
> > +       }
> > +
> > +       if (balance_cpu == -1)
> > +               balance_cpu = group_balance_cpu(sg);
> > +
> > +       /*
> > +        * First idle cpu or the first cpu(busiest) in this sched group
> > +        * is eligible for doing load balancing at this and above domains.
> > +        */
> > +       return balance_cpu != env->dst_cpu;
> > +}
> > +
> >  /*
> >   * Check this_cpu to ensure it is balanced within domain. Attempt to move
> >   * tasks if there is an imbalance.
> >   */
> >  static int load_balance(int this_cpu, struct rq *this_rq,
> >                         struct sched_domain *sd, enum cpu_idle_type idle,
> > -                       int *balance)
> > +                       int *should_balance)
> >  {
> >         int ld_moved, cur_ld_moved, active_balance = 0;
> >         struct sched_group *group;
> > @@ -5036,12 +5033,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
> >
> >         schedstat_inc(sd, lb_count[idle]);
> >
> > -redo:
> > -       group = find_busiest_group(&env, balance);
> > -
> > -       if (*balance == 0)
> > +       if (!should_we_balance(&env)) {
> > +               *should_balance = 0;
> >                 goto out_balanced;
> > +       } else
> > +               *should_balance = 1;
> >
> > +redo:
> > +       group = find_busiest_group(&env);
> >         if (!group) {
> >                 schedstat_inc(sd, lb_nobusyg[idle]);
> >                 goto out_balanced;
> > @@ -5254,7 +5253,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
> >         rcu_read_lock();
> >         for_each_domain(this_cpu, sd) {
> >                 unsigned long interval;
> > -               int balance = 1;
> > +               int should_balance;
> >
> >                 if (!(sd->flags & SD_LOAD_BALANCE))
> >                         continue;
> > @@ -5262,7 +5261,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
> >                 if (sd->flags & SD_BALANCE_NEWIDLE) {
> >                         /* If we've pulled tasks over stop searching: */
> >                         pulled_task = load_balance(this_cpu, this_rq,
> > -                                                  sd, CPU_NEWLY_IDLE, &balance);
> > +                                                  sd, CPU_NEWLY_IDLE,
> > +                                                  &should_balance);
> >                 }
> >
> >                 interval = msecs_to_jiffies(sd->balance_interval);
> > @@ -5502,7 +5502,7 @@ void update_max_interval(void)
> >   */
> >  static void rebalance_domains(int cpu, enum cpu_idle_type idle)
> >  {
> > -       int balance = 1;
> > +       int should_balance;
> 
> int should_balance = 1;
> because if (time_after_eq(jiffies, sd->last_balance + interval)) can
> skip the 1st load_balance and you will test should_balance with its
> initial value.

Hello, Vincent.

Yes, you are right.
I will fix it.

Thanks.

> 
> Vincent
> 
> >         struct rq *rq = cpu_rq(cpu);
> >         unsigned long interval;
> >         struct sched_domain *sd;
> > @@ -5534,7 +5534,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
> >                 }
> >
> >                 if (time_after_eq(jiffies, sd->last_balance + interval)) {
> > -                       if (load_balance(cpu, rq, sd, idle, &balance)) {
> > +                       if (load_balance(cpu, rq, sd, idle, &should_balance)) {
> >                                 /*
> >                                  * The LBF_SOME_PINNED logic could have changed
> >                                  * env->dst_cpu, so we can't know our idle
> > @@ -5557,7 +5557,7 @@ out:
> >                  * CPU in our sched group which is doing load balancing more
> >                  * actively.
> >                  */
> > -               if (!balance)
> > +               if (!should_balance)
> >                         break;
> >         }
> >         rcu_read_unlock();
> > --
> > 1.7.9.5
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
