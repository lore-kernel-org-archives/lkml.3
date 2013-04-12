Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3DLIXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:23:54 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:56631 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab3DLIXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:23:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130411145618.GA15699@somewhere>
References: <1364996263-12198-1-git-send-email-vincent.guittot@linaro.org>
	<20130411145618.GA15699@somewhere>
Date: Fri, 12 Apr 2013 10:23:41 +0200
Message-ID: <CAKfTPtDtiwK=On2LdesVS7DRp+vsWuk6kgaKewhNwUfpQWrcsg@mail.gmail.com>
Subject: Re: [PATCH Resend v5] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 April 2013 16:56, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Apr 03, 2013 at 03:37:43PM +0200, Vincent Guittot wrote:
>> On my smp platform which is made of 5 cores in 2 clusters, I have the
>> nr_busy_cpu field of sched_group_power struct that is not null when the
>> platform is fully idle. The root cause is:
>> During the boot sequence, some CPUs reach the idle loop and set their
>> NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
>> field is initialized later with the assumption that all CPUs are in the busy
>> state whereas some CPUs have already set their NOHZ_IDLE flag.
>>
>> More generally, the NOHZ_IDLE flag must be initialized when new sched_domains
>> are created in order to ensure that NOHZ_IDLE and nr_busy_cpus are aligned.
>>
>> This condition can be ensured by adding a synchronize_rcu between the
>> destruction of old sched_domains and the creation of new ones so the NOHZ_IDLE
>> flag will not be updated with old sched_domain once it has been initialized.
>> But this solution introduces a additionnal latency in the rebuild sequence
>> that is called during cpu hotplug.
>>
>> As suggested by Frederic Weisbecker, another solution is to have the same
>> rcu lifecycle for both NOHZ_IDLE and sched_domain struct. I have introduce
>> a new sched_domain_rq struct that is the entry point for both sched_domains
>> and objects that must follow the same lifecycle like NOHZ_IDLE flags. They
>> will share the same RCU lifecycle and will be always synchronized.
>>
>> The synchronization is done at the cost of :
>>  - an additional indirection for accessing the first sched_domain level
>>  - an additional indirection and a rcu_dereference before accessing to the
>>    NOHZ_IDLE flag.
>>
>> Change since v4:
>>  - link both sched_domain and NOHZ_IDLE flag in one RCU object so
>>    their states are always synchronized.
>>
>> Change since V3;
>>  - NOHZ flag is not cleared if a NULL domain is attached to the CPU
>>  - Remove patch 2/2 which becomes useless with latest modifications
>>
>> Change since V2:
>>  - change the initialization to idle state instead of busy state so a CPU that
>>    enters idle during the build of the sched_domain will not corrupt the
>>    initialization state
>>
>> Change since V1:
>>  - remove the patch for SCHED softirq on an idle core use case as it was
>>    a side effect of the other use cases.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>
> Ok, the lockless scheme involving nr_buzy_cpus and rq flags seem to be correct now.
> We can hope somebody will come up with a less complicated solution. But for now that's
> the best fix I've seen.

Thanks

>
> I just have a few comments on details.
>
>> ---
>>  include/linux/sched.h |    6 +++
>>  kernel/sched/core.c   |  105 ++++++++++++++++++++++++++++++++++++++++++++-----
>>  kernel/sched/fair.c   |   35 +++++++++++------
>>  kernel/sched/sched.h  |   24 +++++++++--
>>  4 files changed, 145 insertions(+), 25 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index d35d2b6..2a52188 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -959,6 +959,12 @@ struct sched_domain {
>>       unsigned long span[0];
>>  };
>>
>> +struct sched_domain_rq {
>> +     struct sched_domain *sd;
>> +     unsigned long flags;
>> +     struct rcu_head rcu;    /* used during destruction */
>> +};
>
> So the reason for this level of indirection won't be intuitive for those
> who read that code. Please add some comments that explain why we need
> that. ie: because we need the object lifecycle of sched_power and flags to be the
> same for the lockless scheme to work.

ok, i will add a comment

>
>> +
>>  static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
>>  {
>>       return to_cpumask(sd->span);
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 7f12624..69e2313 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5602,6 +5602,15 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
>>               destroy_sched_domain(sd, cpu);
>>  }
>>
>> +static void destroy_sched_domain_rq(struct sched_domain_rq *sd_rq, int cpu)
>> +{
>> +     if (!sd_rq)
>> +             return;
>> +
>> +     destroy_sched_domains(sd_rq->sd, cpu);
>> +     kfree_rcu(sd_rq, rcu);
>> +}
>> +
>>  /*
>>   * Keep a special pointer to the highest sched_domain that has
>>   * SD_SHARE_PKG_RESOURCE set (Last Level Cache Domain) for this
>> @@ -5632,10 +5641,23 @@ static void update_top_cache_domain(int cpu)
>>   * hold the hotplug lock.
>>   */
>>  static void
>> -cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
>> +cpu_attach_domain(struct sched_domain_rq *sd_rq, struct root_domain *rd,
>> +             int cpu)
>>  {
>>       struct rq *rq = cpu_rq(cpu);
>> -     struct sched_domain *tmp;
>> +     struct sched_domain_rq *tmp_rq;
>
> old_sd_rq would be a clearer name.

ok

>
>> +     struct sched_domain *tmp, *sd = NULL;
>> +
>> +     /*
>> +      * If we don't have any sched_domain and associated object, we can
>> +      * directly jump to the attach sequence otherwise we try to degenerate
>> +      * the sched_domain
>> +      */
>> +     if (!sd_rq)
>> +             goto attach;
>> +
>> +     /* Get a pointer to the 1st sched_domain */
>> +     sd = sd_rq->sd;
>>
>>       /* Remove the sched domains which do not contribute to scheduling. */
>>       for (tmp = sd; tmp; ) {
>> @@ -5658,14 +5680,17 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
>>               destroy_sched_domain(tmp, cpu);
>>               if (sd)
>>                       sd->child = NULL;
>> +             /* update sched_domain_rq */
>> +             sd_rq->sd = sd;
>>       }
>>
>> +attach:
>>       sched_domain_debug(sd, cpu);
>>
>>       rq_attach_root(rq, rd);
>> -     tmp = rq->sd;
>> -     rcu_assign_pointer(rq->sd, sd);
>> -     destroy_sched_domains(tmp, cpu);
>> +     tmp_rq = rq->sd_rq;
>> +     rcu_assign_pointer(rq->sd_rq, sd_rq);
>> +     destroy_sched_domain_rq(tmp_rq, cpu);
>>
>>       update_top_cache_domain(cpu);
>
> [...]
>> +static void __sdrq_free(const struct cpumask *cpu_map, struct s_data *d)
>> +{
>> +     int j;
>> +
>> +     for_each_cpu(j, cpu_map)
>> +             if (*per_cpu_ptr(d->sd_rq, j))
>> +                     kfree(*per_cpu_ptr(d->sd_rq, j));
>
> kfree(NULL) works.

thanks

>
>> +}
>> +
>> +static void build_sched_domain_rq(struct s_data *d, int cpu)
>> +{
>> +     struct sched_domain_rq *sd_rq;
>> +     struct sched_domain *sd;
>> +
>> +     /* Attach sched_domain to sched_domain_rq */
>> +     sd = *per_cpu_ptr(d->sd, cpu);
>> +     sd_rq = *per_cpu_ptr(d->sd_rq, cpu);
>> +     sd_rq->sd = sd;
>> +     /* Init flags */
>> +     set_bit(NOHZ_IDLE, sched_rq_flags(sd_rq));
>> +}
>> +
>>  struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
>>               struct s_data *d, const struct cpumask *cpu_map,
>>               struct sched_domain_attr *attr, struct sched_domain *child,
>> @@ -6495,6 +6572,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
>>                              struct sched_domain_attr *attr)
>>  {
>>       enum s_alloc alloc_state = sa_none;
>> +     struct sched_domain_rq *sd_rq;
>>       struct sched_domain *sd;
>>       struct s_data d;
>>       int i, ret = -ENOMEM;
>> @@ -6547,11 +6625,18 @@ static int build_sched_domains(const struct cpumask *cpu_map,
>>               }
>>       }
>>
>> +     /* Init objects that must follow the sched_domain lifecycle */
>> +     for_each_cpu(i, cpu_map) {
>> +             build_sched_domain_rq(&d, i);
>> +     }
>
> I suggest you put the above domain_rq initialization before the domain
> initialization.

I can't because build_sched_domain will init struct s_data d that is
used in  build_sched_domain_rq

>
> So that we have that more intuitively ordered initialization:
>
> * set up domains_rq
> * set up domains
> * set up sched groups
> * set up sched groups power
>
>> +
>>       /* Attach the domains */
>>       rcu_read_lock();
>>       for_each_cpu(i, cpu_map) {
>> -             sd = *per_cpu_ptr(d.sd, i);
>> -             cpu_attach_domain(sd, d.rd, i);
>> +             sd_rq = *per_cpu_ptr(d.sd_rq, i);
>> +             cpu_attach_domain(sd_rq, d.rd, i);
>> +             /* claim allocation of sched_domain_rq object */
>> +             *per_cpu_ptr(d.sd_rq, i) = NULL;
>>       }
>>       rcu_read_unlock();
> [...]
>> @@ -5673,7 +5681,12 @@ static void run_rebalance_domains(struct softirq_action *h)
>>
>>  static inline int on_null_domain(int cpu)
>>  {
>> -     return !rcu_dereference_sched(cpu_rq(cpu)->sd);
>> +     struct sched_domain_rq *sd_rq =
>> +             rcu_dereference_sched(cpu_rq(cpu)->sd_rq);
>> +     struct sched_domain *sd = NULL;
>> +     if (sd_rq)
>> +             sd = sd_rq->sd;
>
> Is it possible to have sd_rq->sd == NULL ?

I think so with the isolcpus as an example

>
>> +     return !sd;
>>  }
>>
>>  /*
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index cc03cfd..f589306 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -417,7 +417,7 @@ struct rq {
>>
>>  #ifdef CONFIG_SMP
>>       struct root_domain *rd;
>> -     struct sched_domain *sd;
>> +     struct sched_domain_rq *sd_rq;
>>
>>       unsigned long cpu_power;
>>
>> @@ -505,21 +505,37 @@ DECLARE_PER_CPU(struct rq, runqueues);
>>
>>  #ifdef CONFIG_SMP
>>
>> -#define rcu_dereference_check_sched_domain(p) \
>> +#define rcu_dereference_check_sched_domain_rq(p) \
>>       rcu_dereference_check((p), \
>>                             lockdep_is_held(&sched_domains_mutex))
>>
>> +#define get_sched_domain_rq(cpu) \
>> +     rcu_dereference_check_sched_domain_rq(cpu_rq(cpu)->sd_rq)
>
> How about rcu_dereference_domain_rq()? It seems important to me that
> we keep the rcu_dereference_*() naming so that we don't hide what really
> happens there behind a more opaque naming.

you're right

>
> I mean RCU is tricky to deal with and it's important not to obfuscate its use.
>
>> +
>> +#define rcu_dereference_check_sched_domain(cpu) ({ \
>> +     struct sched_domain_rq *__sd_rq = get_sched_domain_rq(cpu); \
>> +     struct sched_domain *__sd = NULL; \
>> +     if (__sd_rq) \
>> +             __sd = __sd_rq->sd; \
>
> Same question for the NULL sd.
>
>> +     __sd; \
>> +})
>> +
>> +#define sched_rq_flags(sd_rq) (&sd_rq->flags)
>
> Hm, why this "sched_" prefix? Maybe rq_domain_flags() ?

ok i'm going to change the name

>
> Thanks.
