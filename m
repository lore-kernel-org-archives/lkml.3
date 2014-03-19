Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbaCSL1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:27:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47293 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbaCSL1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:27:08 -0400
Message-ID: <53297F10.3050106@arm.com>
Date: Wed, 19 Mar 2014 11:27:12 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v2 2/7] sched: rework of sched_domain topology definition
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org> <1395165409-18055-3-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1395165409-18055-3-git-send-email-vincent.guittot@linaro.org>
X-OriginalArrivalTime: 19 Mar 2014 11:27:13.0801 (UTC) FILETIME=[2D043790:01CF4366]
X-MC-Unique: 114031911270400401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/03/14 17:56, Vincent Guittot wrote:
> We replace the old way to configure the scheduler topology with a new method
> which enables a platform to declare additionnal level (if needed).
> 
> We still have a default topology table definition that can be used by platform
> that don't want more level than the SMT, MC, CPU and NUMA ones. This table can
> be overwritten by an arch which wants to add new level where a load balance
> make sense like BOOK or powergating level.
> 
> For each level, we need a function pointer that returns cpumask for each cpu,
> a function pointer that returns the flags for the level and a name. Only flags
> that describe topology, can be set by an architecture. The current topology
> flags are:
>  SD_SHARE_CPUPOWER
>  SD_SHARE_PKG_RESOURCES
>  SD_NUMA
>  SD_ASYM_PACKING
> 
> Then, each level must be a subset on the next one. The build sequence of the
> sched_domain will take care of removing useless levels like those with 1 CPU
> and those with the same CPU span and relevant information for load balancing
> than its child.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  arch/ia64/include/asm/topology.h |  24 ----
>  arch/s390/include/asm/topology.h |   2 -
>  arch/tile/include/asm/topology.h |  33 ------
>  include/linux/sched.h            |  48 ++++++++
>  include/linux/topology.h         | 128 +++------------------
>  kernel/sched/core.c              | 235 ++++++++++++++++++++-------------------
>  6 files changed, 183 insertions(+), 287 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
> index 5cb55a1..3202aa7 100644
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
> diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
> index 05425b1..07763bd 100644
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
> index d15c0d8..9383118 100644
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
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 825ed83..4db592a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -870,6 +870,20 @@ enum cpu_idle_type {
> 
>  extern int __weak arch_sd_sibiling_asym_packing(void);
> 
> +#ifdef CONFIG_SCHED_SMT
> +static inline const int cpu_smt_flags(void)
> +{
> +       return SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
> +}
> +#endif
> +
> +#ifdef CONFIG_SCHED_MC
> +static inline const int cpu_core_flags(void)
> +{
> +       return SD_SHARE_PKG_RESOURCES;
> +}
> +#endif
> +
>  struct sched_domain_attr {
>         int relax_domain_level;
>  };
> @@ -976,6 +990,38 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
> 
>  bool cpus_share_cache(int this_cpu, int that_cpu);
> 
> +typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
> +typedef const int (*sched_domain_flags_f)(void);
> +
> +#define SDTL_OVERLAP   0x01
> +
> +struct sd_data {
> +       struct sched_domain **__percpu sd;
> +       struct sched_group **__percpu sg;
> +       struct sched_group_power **__percpu sgp;
> +};
> +
> +struct sched_domain_topology_level {
> +       sched_domain_mask_f mask;
> +       sched_domain_flags_f sd_flags;
> +       int                 flags;
> +       int                 numa_level;
> +       struct sd_data      data;
> +#ifdef CONFIG_SCHED_DEBUG
> +       char                *name;
> +#endif
> +};
> +
> +extern struct sched_domain_topology_level *sched_domain_topology;
> +
> +extern void set_sched_topology(struct sched_domain_topology_level *tl);
> +
> +#ifdef CONFIG_SCHED_DEBUG
> +# define SD_INIT_NAME(type)            .name = #type
> +#else
> +# define SD_INIT_NAME(type)
> +#endif
> +
>  #else /* CONFIG_SMP */
> 
>  struct sched_domain_attr;
> @@ -991,6 +1037,8 @@ static inline bool cpus_share_cache(int this_cpu, int that_cpu)
>         return true;
>  }
> 
> +static inline void set_sched_topology(struct sched_domain_topology_level *tl) { }
> +
>  #endif /* !CONFIG_SMP */
> 
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 12ae6ce..3a9db05 100644
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
> @@ -295,4 +180,17 @@ static inline int cpu_to_mem(int cpu)
>  #define topology_core_cpumask(cpu)             cpumask_of(cpu)
>  #endif
> 
> +#ifdef CONFIG_SCHED_SMT
> +static inline const struct cpumask *cpu_smt_mask(int cpu)
> +{
> +       return topology_thread_cpumask(cpu);
> +}
> +#endif
> +
> +static inline const struct cpumask *cpu_cpu_mask(int cpu)
> +{
> +       return cpumask_of_node(cpu_to_node(cpu));
> +}
> +
> +
>  #endif /* _LINUX_TOPOLOGY_H */
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ae365aa..3397bcb 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5603,17 +5603,6 @@ static int __init isolated_cpu_setup(char *str)
> 
>  __setup("isolcpus=", isolated_cpu_setup);
> 
> -static const struct cpumask *cpu_cpu_mask(int cpu)
> -{
> -       return cpumask_of_node(cpu_to_node(cpu));
> -}
> -
> -struct sd_data {
> -       struct sched_domain **__percpu sd;
> -       struct sched_group **__percpu sg;
> -       struct sched_group_power **__percpu sgp;
> -};
> -
>  struct s_data {
>         struct sched_domain ** __percpu sd;
>         struct root_domain      *rd;
> @@ -5626,21 +5615,6 @@ enum s_alloc {
>         sa_none,
>  };
> 
> -struct sched_domain_topology_level;
> -
> -typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
> -typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
> -
> -#define SDTL_OVERLAP   0x01
> -
> -struct sched_domain_topology_level {
> -       sched_domain_init_f init;
> -       sched_domain_mask_f mask;
> -       int                 flags;
> -       int                 numa_level;
> -       struct sd_data      data;
> -};
> -
>  /*
>   * Build an iteration mask that can exclude certain CPUs from the upwards
>   * domain traversal.
> @@ -5869,34 +5843,6 @@ int __weak arch_sd_sibling_asym_packing(void)
>   * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
>   */
> 
> -#ifdef CONFIG_SCHED_DEBUG
> -# define SD_INIT_NAME(sd, type)                sd->name = #type
> -#else
> -# define SD_INIT_NAME(sd, type)                do { } while (0)
> -#endif
> -
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
> @@ -5984,97 +5930,156 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
>                 *per_cpu_ptr(sdd->sgp, cpu) = NULL;
>  }
> 
> -#ifdef CONFIG_SCHED_SMT
> -static const struct cpumask *cpu_smt_mask(int cpu)
> -{
> -       return topology_thread_cpumask(cpu);
> -}
> -#endif
> -
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
> -
>  #ifdef CONFIG_NUMA
> -
>  static int sched_domains_numa_levels;
>  static int *sched_domains_numa_distance;
>  static struct cpumask ***sched_domains_numa_masks;
>  static int sched_domains_curr_level;
> +#endif
> 
> -static inline int sd_local_flags(int level)
> -{
> -       if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
> -               return 0;
> -
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
> +       int sd_weight, sd_flags = 0;
> +
> +#ifdef CONFIG_NUMA
> +       /*
> +        * Ugly hack to pass state to sd_numa_mask()...
> +        */
> +       sched_domains_curr_level = tl->numa_level;
> +#endif
> +
> +       sd_weight = cpumask_weight(tl->mask(cpu));
> +
> +       if (tl->sd_flags)
> +               sd_flags = (*tl->sd_flags)();
> +       if (WARN_ONCE(sd_flags & ~TOPOLOGY_SD_FLAGS,
> +                       "wrong sd_flags in topology description\n"))
> +               sd_flags &= ~TOPOLOGY_SD_FLAGS;
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
> +                                       | sd_flags
>                                         ,
> +
>                 .last_balance           = jiffies,
>                 .balance_interval       = sd_weight,
> +               .smt_gain               = 0,
> +               .max_newidle_lb_cost    = 0,
> +               .next_decay_max_lb_cost = jiffies,
> +#ifdef CONFIG_SCHED_DEBUG
> +               .name                   = tl->name,
> +#endif
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
> +               sd->flags |= arch_sd_sibling_asym_packing();
> +
> +       } else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
> +               sd->imbalance_pct = 117;
> +               sd->cache_nice_tries = 1;
> +               sd->busy_idx = 2;
> +
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
> +#endif
> +       } else {
> +               sd->flags |= SD_PREFER_SIBLING;
> +               sd->cache_nice_tries = 1;
> +               sd->busy_idx = 2;
> +               sd->idle_idx = 1;
> +       }

This 'if ... else statement' is still a weak point from the perspective
of making the code robust:

On TC2 w/ the following change in cpu_corepower_mask()

 const struct cpumask *cpu_corepower_mask(int cpu)
 {
-       return &cpu_topology[cpu].thread_sibling;
+       return cpu_topology[cpu].socket_id ?
&cpu_topology[cpu].thread_sibling :
+                       &cpu_topology[cpu].core_sibling;
 }

I get a sane set-up:

root@linaro-developer:~# cat /proc/sys/kernel/sched_domain/cpu*/domain*/name
GMC
DIE
GMC
DIE
MC
DIE
MC
DIE
MC
DIE
root@linaro-developer:~# cat
/proc/sys/kernel/sched_domain/cpu*/domain*/flags
815
4143
815
4143
559
4143
559
4143
559
4143

w/ 815 (0x32F : SD_LOAD_BALANCE SD_BALANCE_NEWIDLE SD_BALANCE_EXEC
SD_BALANCE_FORK SD_WAKE_AFFINE *SD_SHARE_POWERDOMAIN*
SD_SHARE_PKG_RESOURCES)

w/ 559 (0x22F : SD_LOAD_BALANCE SD_BALANCE_NEWIDLE SD_BALANCE_EXEC
SD_BALANCE_FORK SD_WAKE_AFFINE SD_SHARE_PKG_RESOURCES)

But when I introduce the following error into the arch specific
cpu_corepower_flags() function

 static inline const int cpu_corepower_flags(void)
 {
-       return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
+       return SD_SHARE_POWERDOMAIN;
 }

the GMC related sd's for CPU0,1 are initialized as DIE in sd_init()
resulting in this wrong set-up w/o any warning/error message:

root@linaro-developer:~# cat /proc/sys/kernel/sched_domain/cpu*/domain*/name
GMC
DIE
GMC
DIE
MC
DIE
MC
DIE
MC
DIE
root@linaro-developer:~# cat
/proc/sys/kernel/sched_domain/cpu*/domain*/flags
4399
4143
4399
4143
559
4143
559
4143
559
4143

w/ 4399 (0x112f : SD_LOAD_BALANCE SD_BALANCE_NEWIDLE SD_BALANCE_EXEC
SD_BALANCE_FORK SD_WAKE_AFFINE *SD_SHARE_POWERDOMAIN* SD_PREFER_SIBLING

Is there a way to check that MC and GMC have to have
SD_SHARE_PKG_RESOURCES set so that this can't happen unnoticed?

-- Dietmar

> +
> +       sd->private = &tl->data;
> 
>         return sd;
>  }
> 
> +/*
> + * Topology list, bottom-up.
> + */
> +static struct sched_domain_topology_level default_topology[] = {
> +#ifdef CONFIG_SCHED_SMT
> +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> +#endif
> +#ifdef CONFIG_SCHED_MC
> +       { cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
> +#endif
> +#ifdef CONFIG_SCHED_BOOK
> +       { cpu_book_mask, SD_INIT_NAME(BOOK) },
> +#endif
> +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> +       { NULL, },
> +};
> +
> +struct sched_domain_topology_level *sched_domain_topology = default_topology;
> +
> +#define for_each_sd_topology(tl)                       \
> +       for (tl = sched_domain_topology; tl->mask; tl++)
> +
> +void set_sched_topology(struct sched_domain_topology_level *tl)
> +{
> +       sched_domain_topology = tl;
> +}
> +
> +#ifdef CONFIG_NUMA
> +
>  static const struct cpumask *sd_numa_mask(int cpu)
>  {
>         return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
> @@ -6218,7 +6223,10 @@ static void sched_init_numa(void)
>                 }
>         }
> 
> -       tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
> +       /* Compute default topology size */
> +       for (i = 0; sched_domain_topology[i].mask; i++);
> +
> +       tl = kzalloc((i + level) *
>                         sizeof(struct sched_domain_topology_level), GFP_KERNEL);
>         if (!tl)
>                 return;
> @@ -6226,18 +6234,19 @@ static void sched_init_numa(void)
>         /*
>          * Copy the default topology bits..
>          */
> -       for (i = 0; default_topology[i].init; i++)
> -               tl[i] = default_topology[i];
> +       for (i = 0; sched_domain_topology[i].mask; i++)
> +               tl[i] = sched_domain_topology[i];
> 
>         /*
>          * .. and append 'j' levels of NUMA goodness.
>          */
>         for (j = 0; j < level; i++, j++) {
>                 tl[i] = (struct sched_domain_topology_level){
> -                       .init = sd_numa_init,
>                         .mask = sd_numa_mask,
> +                       .sd_flags = SD_NUMA,
>                         .flags = SDTL_OVERLAP,
>                         .numa_level = j,
> +                       SD_INIT_NAME(NUMA)
>                 };
>         }
> 
> @@ -6395,7 +6404,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
>                 const struct cpumask *cpu_map, struct sched_domain_attr *attr,
>                 struct sched_domain *child, int cpu)
>  {
> -       struct sched_domain *sd = tl->init(tl, cpu);
> +       struct sched_domain *sd = sd_init(tl, cpu);
>         if (!sd)
>                 return child;
> 
> --
> 1.9.0
> 
> 


