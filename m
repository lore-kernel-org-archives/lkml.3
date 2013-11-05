Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab3KEO5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:57:25 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:59752 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3KEO5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:57:23 -0500
MIME-Version: 1.0
In-Reply-To: <20131105140626.GP31370@twins.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
	<1382097147-30088-2-git-send-email-vincent.guittot@linaro.org>
	<20131105140626.GP31370@twins.programming.kicks-ass.net>
Date: Tue, 5 Nov 2013 15:57:23 +0100
Message-ID: <CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com>
Subject: Re: [RFC][PATCH v5 01/14] sched: add a new arch_sd_local_flags for
 sched_domain init
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>, james.hogan@imgtec.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 November 2013 15:06, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Oct 18, 2013 at 01:52:15PM +0200, Vincent Guittot wrote:
>> The function arch_sd_local_flags is used to set flags in sched_domains
>> according to the platform architecture. A new flag SD_SHARE_POWERDOMAIN is
>> also created to reflect whether groups of CPUs in a sched_domain level can or
>> not reach different power state. As an example, the flag should be cleared at
>> CPU level if groups of cores can be power gated independently. This information
>> is used to decide if it's worth packing some tasks in a group of CPUs in order
>> to power gate the other groups instead of spreading the tasks. The default
>> behavior of the scheduler is to spread tasks across CPUs and groups of CPUs so
>> the flag is set into all sched_domains.
>>
>> The cpu parameter of arch_sd_local_flags can be used by architecture to fine
>> tune the scheduler domain flags. As an example SD_SHARE_POWERDOMAIN flag can be
>> set differently for groups of CPUs according to DT information
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>
> Not your fault, but you're making a bigger mess of the arch topology
> interface.
>
> How about we start with something like the below -- compile tested only.
>
> And then try and lift default_topology so that an arch can override it?

Your proposal looks fine for me. It's clearly better to move in one
place the configuration of sched_domain fields. Have you already got
an idea about how to let architecture override the topology?

My primary need comes from the fact that the topology configuration is
not the same for all cores

Vincent
>
> ---
>  arch/ia64/include/asm/topology.h  |  24 -----
>  arch/metag/include/asm/topology.h |  27 ------
>  arch/s390/include/asm/topology.h  |   2 -
>  arch/tile/include/asm/topology.h  |  33 -------
>  include/linux/topology.h          | 115 -----------------------
>  kernel/sched/core.c               | 188 +++++++++++++++++++++++---------------
>  6 files changed, 114 insertions(+), 275 deletions(-)
>
> diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
> index a2496e449b75..20d12fa7e0cd 100644
> --- a/arch/ia64/include/asm/topology.h
> +++ b/arch/ia64/include/asm/topology.h
> @@ -46,30 +46,6 @@
>
>  void build_cpu_to_node_map(void);
>
> -#define SD_CPU_INIT (struct sched_domain) {            \
> -       .parent                 = NULL,                 \
> -       .child                  = NULL,                 \
> -       .groups                 = NULL,                 \
> -       .min_interval           = 1,                    \
> -       .max_interval           = 4,                    \
> -       .busy_factor            = 64,                   \
> -       .imbalance_pct          = 125,                  \
> -       .cache_nice_tries       = 2,                    \
> -       .busy_idx               = 2,                    \
> -       .idle_idx               = 1,                    \
> -       .newidle_idx            = 0,                    \
> -       .wake_idx               = 0,                    \
> -       .forkexec_idx           = 0,                    \
> -       .flags                  = SD_LOAD_BALANCE       \
> -                               | SD_BALANCE_NEWIDLE    \
> -                               | SD_BALANCE_EXEC       \
> -                               | SD_BALANCE_FORK       \
> -                               | SD_WAKE_AFFINE,       \
> -       .last_balance           = jiffies,              \
> -       .balance_interval       = 1,                    \
> -       .nr_balance_failed      = 0,                    \
> -}
> -
>  #endif /* CONFIG_NUMA */
>
>  #ifdef CONFIG_SMP
> diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
> index 8e9c0b3b9691..e95f874ded1b 100644
> --- a/arch/metag/include/asm/topology.h
> +++ b/arch/metag/include/asm/topology.h
> @@ -3,33 +3,6 @@
>
>  #ifdef CONFIG_NUMA
>
> -/* sched_domains SD_NODE_INIT for Meta machines */
> -#define SD_NODE_INIT (struct sched_domain) {           \
> -       .parent                 = NULL,                 \
> -       .child                  = NULL,                 \
> -       .groups                 = NULL,                 \
> -       .min_interval           = 8,                    \
> -       .max_interval           = 32,                   \
> -       .busy_factor            = 32,                   \
> -       .imbalance_pct          = 125,                  \
> -       .cache_nice_tries       = 2,                    \
> -       .busy_idx               = 3,                    \
> -       .idle_idx               = 2,                    \
> -       .newidle_idx            = 0,                    \
> -       .wake_idx               = 0,                    \
> -       .forkexec_idx           = 0,                    \
> -       .flags                  = SD_LOAD_BALANCE       \
> -                               | SD_BALANCE_FORK       \
> -                               | SD_BALANCE_EXEC       \
> -                               | SD_BALANCE_NEWIDLE    \
> -                               | SD_SERIALIZE,         \
> -       .last_balance           = jiffies,              \
> -       .balance_interval       = 1,                    \
> -       .nr_balance_failed      = 0,                    \
> -       .max_newidle_lb_cost    = 0,                    \
> -       .next_decay_max_lb_cost = jiffies,              \
> -}
> -
>  #define cpu_to_node(cpu)       ((void)(cpu), 0)
>  #define parent_node(node)      ((void)(node), 0)
>
> diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
> index 05425b18c0aa..07763bdb408d 100644
> --- a/arch/s390/include/asm/topology.h
> +++ b/arch/s390/include/asm/topology.h
> @@ -64,8 +64,6 @@ static inline void s390_init_cpu_topology(void)
>  };
>  #endif
>
> -#define SD_BOOK_INIT   SD_CPU_INIT
> -
>  #include <asm-generic/topology.h>
>
>  #endif /* _ASM_S390_TOPOLOGY_H */
> diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
> index d15c0d8d550f..938311844233 100644
> --- a/arch/tile/include/asm/topology.h
> +++ b/arch/tile/include/asm/topology.h
> @@ -44,39 +44,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
>  /* For now, use numa node -1 for global allocation. */
>  #define pcibus_to_node(bus)            ((void)(bus), -1)
>
> -/*
> - * TILE architecture has many cores integrated in one processor, so we need
> - * setup bigger balance_interval for both CPU/NODE scheduling domains to
> - * reduce process scheduling costs.
> - */
> -
> -/* sched_domains SD_CPU_INIT for TILE architecture */
> -#define SD_CPU_INIT (struct sched_domain) {                            \
> -       .min_interval           = 4,                                    \
> -       .max_interval           = 128,                                  \
> -       .busy_factor            = 64,                                   \
> -       .imbalance_pct          = 125,                                  \
> -       .cache_nice_tries       = 1,                                    \
> -       .busy_idx               = 2,                                    \
> -       .idle_idx               = 1,                                    \
> -       .newidle_idx            = 0,                                    \
> -       .wake_idx               = 0,                                    \
> -       .forkexec_idx           = 0,                                    \
> -                                                                       \
> -       .flags                  = 1*SD_LOAD_BALANCE                     \
> -                               | 1*SD_BALANCE_NEWIDLE                  \
> -                               | 1*SD_BALANCE_EXEC                     \
> -                               | 1*SD_BALANCE_FORK                     \
> -                               | 0*SD_BALANCE_WAKE                     \
> -                               | 0*SD_WAKE_AFFINE                      \
> -                               | 0*SD_SHARE_CPUPOWER                   \
> -                               | 0*SD_SHARE_PKG_RESOURCES              \
> -                               | 0*SD_SERIALIZE                        \
> -                               ,                                       \
> -       .last_balance           = jiffies,                              \
> -       .balance_interval       = 32,                                   \
> -}
> -
>  /* By definition, we create nodes based on online memory. */
>  #define node_has_online_mem(nid) 1
>
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 12ae6ce997d6..02a397aa150e 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -66,121 +66,6 @@ int arch_update_cpu_topology(void);
>  #define PENALTY_FOR_NODE_WITH_CPUS     (1)
>  #endif
>
> -/*
> - * Below are the 3 major initializers used in building sched_domains:
> - * SD_SIBLING_INIT, for SMT domains
> - * SD_CPU_INIT, for SMP domains
> - *
> - * Any architecture that cares to do any tuning to these values should do so
> - * by defining their own arch-specific initializer in include/asm/topology.h.
> - * A definition there will automagically override these default initializers
> - * and allow arch-specific performance tuning of sched_domains.
> - * (Only non-zero and non-null fields need be specified.)
> - */
> -
> -#ifdef CONFIG_SCHED_SMT
> -/* MCD - Do we really need this?  It is always on if CONFIG_SCHED_SMT is,
> - * so can't we drop this in favor of CONFIG_SCHED_SMT?
> - */
> -#define ARCH_HAS_SCHED_WAKE_IDLE
> -/* Common values for SMT siblings */
> -#ifndef SD_SIBLING_INIT
> -#define SD_SIBLING_INIT (struct sched_domain) {                                \
> -       .min_interval           = 1,                                    \
> -       .max_interval           = 2,                                    \
> -       .busy_factor            = 64,                                   \
> -       .imbalance_pct          = 110,                                  \
> -                                                                       \
> -       .flags                  = 1*SD_LOAD_BALANCE                     \
> -                               | 1*SD_BALANCE_NEWIDLE                  \
> -                               | 1*SD_BALANCE_EXEC                     \
> -                               | 1*SD_BALANCE_FORK                     \
> -                               | 0*SD_BALANCE_WAKE                     \
> -                               | 1*SD_WAKE_AFFINE                      \
> -                               | 1*SD_SHARE_CPUPOWER                   \
> -                               | 1*SD_SHARE_PKG_RESOURCES              \
> -                               | 0*SD_SERIALIZE                        \
> -                               | 0*SD_PREFER_SIBLING                   \
> -                               | arch_sd_sibling_asym_packing()        \
> -                               ,                                       \
> -       .last_balance           = jiffies,                              \
> -       .balance_interval       = 1,                                    \
> -       .smt_gain               = 1178, /* 15% */                       \
> -       .max_newidle_lb_cost    = 0,                                    \
> -       .next_decay_max_lb_cost = jiffies,                              \
> -}
> -#endif
> -#endif /* CONFIG_SCHED_SMT */
> -
> -#ifdef CONFIG_SCHED_MC
> -/* Common values for MC siblings. for now mostly derived from SD_CPU_INIT */
> -#ifndef SD_MC_INIT
> -#define SD_MC_INIT (struct sched_domain) {                             \
> -       .min_interval           = 1,                                    \
> -       .max_interval           = 4,                                    \
> -       .busy_factor            = 64,                                   \
> -       .imbalance_pct          = 125,                                  \
> -       .cache_nice_tries       = 1,                                    \
> -       .busy_idx               = 2,                                    \
> -       .wake_idx               = 0,                                    \
> -       .forkexec_idx           = 0,                                    \
> -                                                                       \
> -       .flags                  = 1*SD_LOAD_BALANCE                     \
> -                               | 1*SD_BALANCE_NEWIDLE                  \
> -                               | 1*SD_BALANCE_EXEC                     \
> -                               | 1*SD_BALANCE_FORK                     \
> -                               | 0*SD_BALANCE_WAKE                     \
> -                               | 1*SD_WAKE_AFFINE                      \
> -                               | 0*SD_SHARE_CPUPOWER                   \
> -                               | 1*SD_SHARE_PKG_RESOURCES              \
> -                               | 0*SD_SERIALIZE                        \
> -                               ,                                       \
> -       .last_balance           = jiffies,                              \
> -       .balance_interval       = 1,                                    \
> -       .max_newidle_lb_cost    = 0,                                    \
> -       .next_decay_max_lb_cost = jiffies,                              \
> -}
> -#endif
> -#endif /* CONFIG_SCHED_MC */
> -
> -/* Common values for CPUs */
> -#ifndef SD_CPU_INIT
> -#define SD_CPU_INIT (struct sched_domain) {                            \
> -       .min_interval           = 1,                                    \
> -       .max_interval           = 4,                                    \
> -       .busy_factor            = 64,                                   \
> -       .imbalance_pct          = 125,                                  \
> -       .cache_nice_tries       = 1,                                    \
> -       .busy_idx               = 2,                                    \
> -       .idle_idx               = 1,                                    \
> -       .newidle_idx            = 0,                                    \
> -       .wake_idx               = 0,                                    \
> -       .forkexec_idx           = 0,                                    \
> -                                                                       \
> -       .flags                  = 1*SD_LOAD_BALANCE                     \
> -                               | 1*SD_BALANCE_NEWIDLE                  \
> -                               | 1*SD_BALANCE_EXEC                     \
> -                               | 1*SD_BALANCE_FORK                     \
> -                               | 0*SD_BALANCE_WAKE                     \
> -                               | 1*SD_WAKE_AFFINE                      \
> -                               | 0*SD_SHARE_CPUPOWER                   \
> -                               | 0*SD_SHARE_PKG_RESOURCES              \
> -                               | 0*SD_SERIALIZE                        \
> -                               | 1*SD_PREFER_SIBLING                   \
> -                               ,                                       \
> -       .last_balance           = jiffies,                              \
> -       .balance_interval       = 1,                                    \
> -       .max_newidle_lb_cost    = 0,                                    \
> -       .next_decay_max_lb_cost = jiffies,                              \
> -}
> -#endif
> -
> -#ifdef CONFIG_SCHED_BOOK
> -#ifndef SD_BOOK_INIT
> -#error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
> -#endif
> -#endif /* CONFIG_SCHED_BOOK */
> -
>  #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
>  DECLARE_PER_CPU(int, numa_node);
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 450a34b2a637..b4e0b1c97a96 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5379,14 +5379,13 @@ enum s_alloc {
>
>  struct sched_domain_topology_level;
>
> -typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
>  typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
>
>  #define SDTL_OVERLAP   0x01
>
>  struct sched_domain_topology_level {
> -       sched_domain_init_f init;
>         sched_domain_mask_f mask;
> +       int                 sd_flags;
>         int                 flags;
>         int                 numa_level;
>         struct sd_data      data;
> @@ -5625,28 +5624,6 @@ int __weak arch_sd_sibling_asym_packing(void)
>  # define SD_INIT_NAME(sd, type)                do { } while (0)
>  #endif
>
> -#define SD_INIT_FUNC(type)                                             \
> -static noinline struct sched_domain *                                  \
> -sd_init_##type(struct sched_domain_topology_level *tl, int cpu)        \
> -{                                                                      \
> -       struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);       \
> -       *sd = SD_##type##_INIT;                                         \
> -       SD_INIT_NAME(sd, type);                                         \
> -       sd->private = &tl->data;                                        \
> -       return sd;                                                      \
> -}
> -
> -SD_INIT_FUNC(CPU)
> -#ifdef CONFIG_SCHED_SMT
> - SD_INIT_FUNC(SIBLING)
> -#endif
> -#ifdef CONFIG_SCHED_MC
> - SD_INIT_FUNC(MC)
> -#endif
> -#ifdef CONFIG_SCHED_BOOK
> - SD_INIT_FUNC(BOOK)
> -#endif
> -
>  static int default_relax_domain_level = -1;
>  int sched_domain_level_max;
>
> @@ -5741,89 +5718,152 @@ static const struct cpumask *cpu_smt_mask(int cpu)
>  }
>  #endif
>
> -/*
> - * Topology list, bottom-up.
> - */
> -static struct sched_domain_topology_level default_topology[] = {
> -#ifdef CONFIG_SCHED_SMT
> -       { sd_init_SIBLING, cpu_smt_mask, },
> -#endif
> -#ifdef CONFIG_SCHED_MC
> -       { sd_init_MC, cpu_coregroup_mask, },
> -#endif
> -#ifdef CONFIG_SCHED_BOOK
> -       { sd_init_BOOK, cpu_book_mask, },
> -#endif
> -       { sd_init_CPU, cpu_cpu_mask, },
> -       { NULL, },
> -};
> -
> -static struct sched_domain_topology_level *sched_domain_topology = default_topology;
> -
> -#define for_each_sd_topology(tl)                       \
> -       for (tl = sched_domain_topology; tl->init; tl++)
> +static int sched_domains_curr_level;
>
>  #ifdef CONFIG_NUMA
> -
>  static int sched_domains_numa_levels;
>  static int *sched_domains_numa_distance;
>  static struct cpumask ***sched_domains_numa_masks;
> -static int sched_domains_curr_level;
> -
> -static inline int sd_local_flags(int level)
> -{
> -       if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
> -               return 0;
> +#endif
>
> -       return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
> -}
> +/*
> + * SD_flags allowed in topology descriptions.
> + *
> + * SD_SHARE_CPUPOWER      - describes SMT topologies
> + * SD_SHARE_PKG_RESOURCES - describes shared caches
> + * SD_NUMA                - describes NUMA topologies
> + *
> + * Odd one out:
> + * SD_ASYM_PACKING        - describes SMT quirks
> + */
> +#define TOPOLOGY_SD_FLAGS              \
> +       (SD_SHARE_CPUPOWER |            \
> +        SD_SHARE_PKG_RESOURCES |       \
> +        SD_NUMA |                      \
> +        SD_ASYM_PACKING)
>
>  static struct sched_domain *
> -sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
> +sd_init(struct sched_domain_topology_level *tl, int cpu)
>  {
>         struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
> -       int level = tl->numa_level;
> -       int sd_weight = cpumask_weight(
> -                       sched_domains_numa_masks[level][cpu_to_node(cpu)]);
> +       int sd_weight;
> +
> +       /*
> +        * Ugly hack to pass state to sd_numa_mask()...
> +        */
> +       sched_domains_curr_level = tl->numa_level;
> +
> +       sd_weight = cpumask_weight(tl->mask(cpu));
> +
> +       if (WARN_ONCE(tl->sd_flags & ~TOPOLOGY_SD_FLAGS,
> +                       "wrong sd_flags in topology description\n"))
> +               tl->sd_flags &= ~TOPOLOGY_SD_FLAGS;
>
>         *sd = (struct sched_domain){
>                 .min_interval           = sd_weight,
>                 .max_interval           = 2*sd_weight,
>                 .busy_factor            = 32,
>                 .imbalance_pct          = 125,
> -               .cache_nice_tries       = 2,
> -               .busy_idx               = 3,
> -               .idle_idx               = 2,
> +
> +               .cache_nice_tries       = 0,
> +               .busy_idx               = 0,
> +               .idle_idx               = 0,
>                 .newidle_idx            = 0,
>                 .wake_idx               = 0,
>                 .forkexec_idx           = 0,
>
>                 .flags                  = 1*SD_LOAD_BALANCE
>                                         | 1*SD_BALANCE_NEWIDLE
> -                                       | 0*SD_BALANCE_EXEC
> -                                       | 0*SD_BALANCE_FORK
> +                                       | 1*SD_BALANCE_EXEC
> +                                       | 1*SD_BALANCE_FORK
>                                         | 0*SD_BALANCE_WAKE
> -                                       | 0*SD_WAKE_AFFINE
> +                                       | 1*SD_WAKE_AFFINE
>                                         | 0*SD_SHARE_CPUPOWER
>                                         | 0*SD_SHARE_PKG_RESOURCES
> -                                       | 1*SD_SERIALIZE
> +                                       | 0*SD_SERIALIZE
>                                         | 0*SD_PREFER_SIBLING
> -                                       | 1*SD_NUMA
> -                                       | sd_local_flags(level)
> +                                       | 0*SD_NUMA
> +                                       | tl->sd_flags
>                                         ,
> +
>                 .last_balance           = jiffies,
>                 .balance_interval       = sd_weight,
> +               .smt_gain               = 0,
> +               .max_newidle_lb_cost    = 0,
> +               .next_decay_max_lb_cost = jiffies,
>         };
> -       SD_INIT_NAME(sd, NUMA);
> -       sd->private = &tl->data;
>
>         /*
> -        * Ugly hack to pass state to sd_numa_mask()...
> +        * Convert topological properties into behaviour.
>          */
> -       sched_domains_curr_level = tl->numa_level;
> +
> +       if (sd->flags & SD_SHARE_CPUPOWER) {
> +               sd->imbalance_pct = 110;
> +               sd->smt_gain = 1178; /* ~15% */
> +
> +               /*
> +                * XXX hoist into arch topology descriptions.
> +                */
> +               sd->flags |= arch_sd_sibling_asym_packing();
> +
> +               SD_INIT_NAME(sd, SMT);
> +       } else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
> +               sd->imbalance_pct = 117;
> +               sd->cache_nice_tries = 1;
> +               sd->busy_idx = 2;
> +
> +               SD_INIT_NAME(sd, MC);
> +#ifdef CONFIG_NUMA
> +       } else if (sd->flags & SD_NUMA) {
> +               sd->cache_nice_tries = 2;
> +               sd->busy_idx = 3;
> +               sd->idle_idx = 2;
> +
> +               sd->flags |= SD_SERIALIZE;
> +               if (sched_domains_numa_distance[tl->numa_level] > RECLAIM_DISTANCE) {
> +                       sd->flags &= ~(SD_BALANCE_EXEC |
> +                                      SD_BALANCE_FORK |
> +                                      SD_WAKE_AFFINE);
> +               }
> +
> +               SD_INIT_NAME(sd, NUMA);
> +#endif
> +       } else {
> +               sd->flags |= SD_PREFER_SIBLING;
> +               sd->cache_nice_tries = 1;
> +               sd->busy_idx = 2;
> +               sd->idle_idx = 1;
> +
> +               SD_INIT_NAME(sd, DIE);
> +       }
> +
> +       sd->private = &tl->data;
>
>         return sd;
>  }
> +/*
> + * Topology list, bottom-up.
> + */
> +static struct sched_domain_topology_level default_topology[] = {
> +#ifdef CONFIG_SCHED_SMT
> +       { cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES },
> +#endif
> +#ifdef CONFIG_SCHED_MC
> +       { cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES },
> +#endif
> +#ifdef CONFIG_SCHED_BOOK
> +       { cpu_book_mask, },
> +#endif
> +       { cpu_cpu_mask, },
> +       { NULL, },
> +};
> +
> +static struct sched_domain_topology_level *sched_domain_topology = default_topology;
> +
> +#define for_each_sd_topology(tl)                       \
> +       for (tl = sched_domain_topology; tl->mask; tl++)
> +
> +#ifdef CONFIG_NUMA
>
>  static const struct cpumask *sd_numa_mask(int cpu)
>  {
> @@ -5976,7 +6016,7 @@ static void sched_init_numa(void)
>         /*
>          * Copy the default topology bits..
>          */
> -       for (i = 0; default_topology[i].init; i++)
> +       for (i = 0; default_topology[i].mask; i++)
>                 tl[i] = default_topology[i];
>
>         /*
> @@ -5984,8 +6024,8 @@ static void sched_init_numa(void)
>          */
>         for (j = 0; j < level; i++, j++) {
>                 tl[i] = (struct sched_domain_topology_level){
> -                       .init = sd_numa_init,
>                         .mask = sd_numa_mask,
> +                       .sd_flags = SD_NUMA,
>                         .flags = SDTL_OVERLAP,
>                         .numa_level = j,
>                 };
> @@ -6145,7 +6185,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
>                 const struct cpumask *cpu_map, struct sched_domain_attr *attr,
>                 struct sched_domain *child, int cpu)
>  {
> -       struct sched_domain *sd = tl->init(tl, cpu);
> +       struct sched_domain *sd = sd_init(tl, cpu);
>         if (!sd)
>                 return child;
>
