Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaCFIc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:32:58 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:55496 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaCFIc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:32:56 -0500
MIME-Version: 1.0
In-Reply-To: <53175A3C.8010100@arm.com>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
 <1394003906-11630-3-git-send-email-vincent.guittot@linaro.org> <53175A3C.8010100@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 6 Mar 2014 16:32:35 +0800
Message-ID: <CAKfTPtC1_t78hvOw9u-t1BqUZj_dO3WFYp2OjX=RFZP-A7zSbg@mail.gmail.com>
Subject: Re: [PATCH 2/6] sched: rework of sched_domain topology definition
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2014 01:09, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 05/03/14 07:18, Vincent Guittot wrote:
>>
>> We replace the old way to configure the scheduler topology with a new
>> method
>> which enables a platform to declare additionnal level (if needed).
>>
>> We still have a default topology table definition that can be used by
>> platform
>> that don't want more level than the SMT, MC, CPU and NUMA ones. This table
>> can
>> be overwritten by an arch which wants to add new level where a load
>> balance
>> make sense like BOOK or powergating level.
>>
>> For each level, we need a function pointer that returns cpumask for each
>> cpu,
>> the flags configuration and a name. Each level must be a subset on
>
>
> Maybe it's worth mentioning here that those flags are from the set of the sd
> topology flags to distinguish them from the set of sd behavioural flags.
> Latter can't be set via this interface.

yes, i will add the list of flags that can be set with the table

>
>
>> the next one. The build sequence of the sched_domain will take care of
>> removing useless levels like those with 1 CPU and those with the same CPU
>> span
>> and relevant information for load balancing than its child .
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>   arch/ia64/include/asm/topology.h |   24 ----
>>   arch/s390/include/asm/topology.h |    2 -
>>   arch/tile/include/asm/topology.h |   33 ------
>>   include/linux/sched.h            |   29 +++++
>>   include/linux/topology.h         |  128 +++------------------
>>   kernel/sched/core.c              |  227
>> +++++++++++++++++++-------------------
>>   6 files changed, 156 insertions(+), 287 deletions(-)
>>

[snip]

>> -
>> -#define for_each_sd_topology(tl)                       \
>> -       for (tl = sched_domain_topology; tl->init; tl++)
>
>
> Why is sched_domains_curr_level now outside #ifdef CONFIG_NUMA?

it should not as well as its use in sd_init

>
>
>> +static int sched_domains_curr_level;
>>
>>   #ifdef CONFIG_NUMA
>> -
>>   static int sched_domains_numa_levels;
>>   static int *sched_domains_numa_distance;
>>   static struct cpumask ***sched_domains_numa_masks;
>> -static int sched_domains_curr_level;
>> -
>> -static inline int sd_local_flags(int level)
>> -{
>> -       if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
>> -               return 0;
>> +#endif
>>
>> -       return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
>> -}
>> +/*
>> + * SD_flags allowed in topology descriptions.
>> + *
>> + * SD_SHARE_CPUPOWER      - describes SMT topologies
>> + * SD_SHARE_PKG_RESOURCES - describes shared caches
>> + * SD_NUMA                - describes NUMA topologies
>> + *
>> + * Odd one out:
>> + * SD_ASYM_PACKING        - describes SMT quirks
>> + */
>> +#define TOPOLOGY_SD_FLAGS              \
>> +       (SD_SHARE_CPUPOWER |            \
>> +        SD_SHARE_PKG_RESOURCES |       \
>> +        SD_NUMA |                      \
>> +        SD_ASYM_PACKING)
>>
>>   static struct sched_domain *
>> -sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
>> +sd_init(struct sched_domain_topology_level *tl, int cpu)
>>   {
>>          struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
>> -       int level = tl->numa_level;
>> -       int sd_weight = cpumask_weight(
>> -
>> sched_domains_numa_masks[level][cpu_to_node(cpu)]);
>> +       int sd_weight;
>> +
>
>
> Next line could be guared by #ifdef CONFIG_NUMA. We still use #ifdef
> CONFIG_NUMA later in sd_init() though.
>
>> +       /*
>> +        * Ugly hack to pass state to sd_numa_mask()...
>> +        */
>> +       sched_domains_curr_level = tl->numa_level;
>> +
>> +       sd_weight = cpumask_weight(tl->mask(cpu));
>> +
>> +       if (WARN_ONCE(tl->sd_flags & ~TOPOLOGY_SD_FLAGS,
>> +                       "wrong sd_flags in topology description\n"))
>> +               tl->sd_flags &= ~TOPOLOGY_SD_FLAGS;
>>
>>          *sd = (struct sched_domain){
>>                  .min_interval           = sd_weight,
>>                  .max_interval           = 2*sd_weight,
>>                  .busy_factor            = 32,
>>                  .imbalance_pct          = 125,
>> -               .cache_nice_tries       = 2,
>> -               .busy_idx               = 3,
>> -               .idle_idx               = 2,
>> +
>> +               .cache_nice_tries       = 0,
>> +               .busy_idx               = 0,
>> +               .idle_idx               = 0,
>>                  .newidle_idx            = 0,
>>                  .wake_idx               = 0,
>>                  .forkexec_idx           = 0,
>
>
> Why we want to explicitly set those indexes to 0 here? IMHO, the memory for
> *sd is zeroed out before. This is true for all data members which are set to
> 0 later in this function including the | 0*SD_FOO . IMHO, would make the
> code more readable.

I would say that it makes the configuration more readable and
modifiable because you have the list of possible flag to set

>
>
>>
>>                  .flags                  = 1*SD_LOAD_BALANCE
>>                                          | 1*SD_BALANCE_NEWIDLE
>> -                                       | 0*SD_BALANCE_EXEC
>> -                                       | 0*SD_BALANCE_FORK
>> +                                       | 1*SD_BALANCE_EXEC
>> +                                       | 1*SD_BALANCE_FORK
>>                                          | 0*SD_BALANCE_WAKE
>> -                                       | 0*SD_WAKE_AFFINE
>> +                                       | 1*SD_WAKE_AFFINE
>>                                          | 0*SD_SHARE_CPUPOWER
>>                                          | 0*SD_SHARE_PKG_RESOURCES
>> -                                       | 1*SD_SERIALIZE
>> +                                       | 0*SD_SERIALIZE
>>                                          | 0*SD_PREFER_SIBLING
>> -                                       | 1*SD_NUMA
>> -                                       | sd_local_flags(level)
>> +                                       | 0*SD_NUMA
>> +                                       | tl->sd_flags
>>                                          ,
>> +
>>                  .last_balance           = jiffies,
>>                  .balance_interval       = sd_weight,
>> +               .smt_gain               = 0,
>> +               .max_newidle_lb_cost    = 0,
>> +               .next_decay_max_lb_cost = jiffies,
>> +#ifdef CONFIG_SCHED_DEBUG
>> +               .name                   = tl->name,
>> +#endif
>>          };
>> -       SD_INIT_NAME(sd, NUMA);
>> -       sd->private = &tl->data;
>>

[snip]

>>
>> +/*
>> + * Topology list, bottom-up.
>> + */
>> +static struct sched_domain_topology_level default_topology[] = {
>> +#ifdef CONFIG_SCHED_SMT
>> +       { cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES,
>> SD_INIT_NAME(SMT) },
>> +#endif
>> +#ifdef CONFIG_SCHED_MC
>> +       { cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES, SD_INIT_NAME(MC) },
>> +#endif
>> +#ifdef CONFIG_SCHED_BOOK
>> +       { cpu_book_mask, SD_INIT_NAME(BOOK) },
>> +#endif
>
>
> Never got the new name DIE for CPU? Might confuse people when they use
> /proc/sys/kernel/sched_domain/cpuX/domainY/name or sched_domain_debug_one().

In fact, CPU is also confusing because it's used for different things.
But if it makes things even more confusing, i can come back to CPU

>
>
>> +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
>> +       { NULL, },
>> +};
>> +
>> +struct sched_domain_topology_level *sched_domain_topology =
>> default_topology;
>> +
