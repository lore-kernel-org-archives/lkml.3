Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3KLRnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:43:47 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36167 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3KLRno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:43:44 -0500
Message-ID: <528268C8.8010501@arm.com>
Date: Tue, 12 Nov 2013 17:43:36 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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
        Lukasz Majewski <l.majewski@samsung.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH v5 01/14] sched: add a new arch_sd_local_flags for
 sched_domain init
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org> <1382097147-30088-2-git-send-email-vincent.guittot@linaro.org> <20131105140626.GP31370@twins.programming.kicks-ass.net> <CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com> <20131105222752.GD16117@laptop.programming.kicks-ass.net> <20131106145344.448d7733@mschwide> <20131106140807.GM10651@twins.programming.kicks-ass.net>
In-Reply-To: <20131106140807.GM10651@twins.programming.kicks-ass.net>
X-OriginalArrivalTime: 12 Nov 2013 17:43:38.0029 (UTC) FILETIME=[B7CDADD0:01CEDFCE]
X-MC-Unique: 113111217434100801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/13 14:08, Peter Zijlstra wrote:
> On Wed, Nov 06, 2013 at 02:53:44PM +0100, Martin Schwidefsky wrote:
>> On Tue, 5 Nov 2013 23:27:52 +0100
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Tue, Nov 05, 2013 at 03:57:23PM +0100, Vincent Guittot wrote:
>>>> Your proposal looks fine for me. It's clearly better to move in one
>>>> place the configuration of sched_domain fields. Have you already got
>>>> an idea about how to let architecture override the topology?
>>>
>>> Maybe something like the below -- completely untested (my s390 compiler
>>> is on a machine that's currently powered off).
>>
>> In principle I do not see a reason why this should not work, but there
>> are a few more things to take care of. E.g. struct sd_data is defined
>> in kernel/sched/core.c, cpu_cpu_mask as well. These need to be moved
>> to a header where arch/s390/kernel/smp.c can pick it up.
>>
>> I do have the feeling that the sched_domain_topology should be left
>> where they are, or do we really want to expose more of the scheduler
>> internals?
> 
> Ah, its a trade off; in that previous patch I removed the entire
> sched_domain initializers the archs used to 'have' to fill out. That
> exposed far too much behavioural stuff the archs really shouldn't
> bother with.
> 
> In return we now provide a (hopefully) simpler interface that allows
> archs to communicate their topology to the scheduler -- without getting
> mixed up in the behavioural aspects (too much).
> 
> Maybe s390 wasn't the best example to pick, as the book domain really
> isn't that exciting. Arguably I should have taken Power7+ and the
> ASYM_PACKING SMT thing.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

We actually don't have to expose sched_domain_topology or any internal
scheduler data structures.

We still can get rid of the SD_XXX_INIT stuff and do the sched_domain
initialization for all levels in one function sd_init().

Moreover, we could introduce a arch specific general function replacing
arch specific functions for particular flags and levels like
arch_sd_sibling_asym_packing() or Vincent's arch_sd_local_flags().
This arch specific general function exposes the level and the
sched_domain pointer to the arch which then could fine tune sched_domain
in each individual level.

Below is a patch which bases on your idea to transform sd_numa_init()
into sd_init(). The main difference is that I don't try to distinguish
based of power management related flags inside sd_init() but rather on
the new sd level data.

Dietmar

----8<----

>From 3df278ad50690a7878c9cc6b18e226805e1f4bd1 Mon Sep 17 00:00:00 2001
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
Date: Tue, 12 Nov 2013 12:37:36 +0000
Subject: [PATCH] sched: rework sched_domain setup code

This patch removes the sched_domain initializer macros
SD_[SIBLING|MC|BOOK|CPU]_INIT in core.c and in archs and replaces them
with calls to the new function sd_init().  The function sd_init
incorporates the already existing function sd_numa_init().

It introduces preprocessor constants (SD_LVL_[INV|SMT|MC|BOOK|CPU|NUMA])
and replaces 'sched_domain_init_f init' with 'int level' data member in
struct sched_domain_topology_level.

The new data member is used to distinguish the sched_domain level in
sd_init() and is also passed as an argument to the arch specific
function to tweak the sched_domain described below.

To make it still possible for archs to tweak the individual
sched_domain level, a new weak function arch_sd_customize(int level,
struct sched_domain *sd, int cpu) is introduced.
By exposing the sched_domain level and the pointer to the sched_domain
data structure, the archs can tweak individual data members, like the
min or max interval or the flags.  This function also replaces the
existing function arch_sd_sibiling_asym_packing() which is specialized
in setting the SD_ASYM_PACKING flag for the SMT sched_domain level.
The parameter cpu is currently not used but could be used in the
future to setup sched_domain structures in one sched_domain level
differently for different cpus.

Initialization of a sched_domain is done in three steps. First, at the
beginning of sd_init(), the sched_domain data members are set which
have the same value for all or at least most of the sched_domain
levels.  Second, sched_domain data members are set for each
sched_domain level individually in sd_init().  Third,
arch_sd_customize() is called in sd_init().

One exception is SD_NODE_INIT which this patch removes from
arch/metag/include/asm/topology.h. I don't now how it's been used so
this patch does not provide a metag specific arch_sd_customize()
implementation.

This patch has been tested on ARM TC2 (5 CPUs, sched_domain level MC
and CPU) and compile-tested for x86_64, powerpc (chroma_defconfig) and
mips (ip27_defconfig).

It is against v3.12 .

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/ia64/include/asm/topology.h  |   24 -----
 arch/ia64/kernel/topology.c       |    8 ++
 arch/metag/include/asm/topology.h |   25 -----
 arch/powerpc/kernel/smp.c         |    7 +-
 arch/tile/include/asm/topology.h  |   33 ------
 arch/tile/kernel/smp.c            |   12 +++
 include/linux/sched.h             |    8 +-
 include/linux/topology.h          |  109 -------------------
 kernel/sched/core.c               |  214 +++++++++++++++++++++----------------
 9 files changed, 150 insertions(+), 290 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index a2496e4..20d12fa 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -46,30 +46,6 @@
 
 void build_cpu_to_node_map(void);
 
-#define SD_CPU_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 1,			\
-	.max_interval		= 4,			\
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 2,			\
-	.idle_idx		= 1,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_WAKE_AFFINE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index ca69a5a..5dd627d 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -99,6 +99,14 @@ out:
 
 subsys_initcall(topology_init);
 
+void arch_sd_customize(int level, struct sched_domain *sd, int cpu)
+{
+	if (level == SD_LVL_CPU) {
+		sd->cache_nice_tries = 2;
+
+		sd->flags &= ~SD_PREFER_SIBLING;
+	}
+}
 
 /*
  * Export cpu cache information through sysfs
diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
index 23f5118..e95f874 100644
--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -3,31 +3,6 @@
 
 #ifdef CONFIG_NUMA
 
-/* sched_domains SD_NODE_INIT for Meta machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #define cpu_to_node(cpu)	((void)(cpu), 0)
 #define parent_node(node)	((void)(node), 0)
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 8e59abc..9ac5bfb 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -802,13 +802,12 @@ void __init smp_cpus_done(unsigned int max_cpus)
 
 }
 
-int arch_sd_sibling_asym_packing(void)
+void arch_sd_customize(int level, struct sched_domain *sd, int cpu)
 {
-	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
+	if (level == SD_LVL_SMT && cpu_has_feature(CPU_FTR_ASYM_SMT)) {
 		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
-		return SD_ASYM_PACKING;
+		sd->flags |= SD_ASYM_PACKING;
 	}
-	return 0;
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index d15c0d8..9383118 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -44,39 +44,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 /* For now, use numa node -1 for global allocation. */
 #define pcibus_to_node(bus)		((void)(bus), -1)
 
-/*
- * TILE architecture has many cores integrated in one processor, so we need
- * setup bigger balance_interval for both CPU/NODE scheduling domains to
- * reduce process scheduling costs.
- */
-
-/* sched_domains SD_CPU_INIT for TILE architecture */
-#define SD_CPU_INIT (struct sched_domain) {				\
-	.min_interval		= 4,					\
-	.max_interval		= 128,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 32,					\
-}
-
 /* By definition, we create nodes based on online memory. */
 #define node_has_online_mem(nid) 1
 
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 01e8ab2..dfafe55 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -254,3 +254,15 @@ void smp_send_reschedule(int cpu)
 }
 
 #endif /* CHIP_HAS_IPI() */
+
+void arch_sd_customize(int level, struct sched_domain *sd, int cpu)
+{
+	if (level == SD_LVL_CPU) {
+		sd->min_interval = 4;
+		sd->max_interval = 128;
+
+		sd->flags &= ~(SD_WAKE_AFFINE | SD_PREFER_SIBLING);
+
+		sd->balance_interval = 32;
+	}
+}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e27baee..847485d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -769,7 +769,13 @@ enum cpu_idle_type {
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 
-extern int __weak arch_sd_sibiling_asym_packing(void);
+/* sched-domain levels */
+#define SD_LVL_INV		0x00 /* invalid */
+#define SD_LVL_SMT		0x01
+#define SD_LVL_MC		0x02
+#define SD_LVL_BOOK		0x04
+#define SD_LVL_CPU		0x08
+#define SD_LVL_NUMA		0x10
 
 struct sched_domain_attr {
 	int relax_domain_level;
diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..02a397a 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -66,115 +66,6 @@ int arch_update_cpu_topology(void);
 #define PENALTY_FOR_NODE_WITH_CPUS	(1)
 #endif
 
-/*
- * Below are the 3 major initializers used in building sched_domains:
- * SD_SIBLING_INIT, for SMT domains
- * SD_CPU_INIT, for SMP domains
- *
- * Any architecture that cares to do any tuning to these values should do so
- * by defining their own arch-specific initializer in include/asm/topology.h.
- * A definition there will automagically override these default initializers
- * and allow arch-specific performance tuning of sched_domains.
- * (Only non-zero and non-null fields need be specified.)
- */
-
-#ifdef CONFIG_SCHED_SMT
-/* MCD - Do we really need this?  It is always on if CONFIG_SCHED_SMT is,
- * so can't we drop this in favor of CONFIG_SCHED_SMT?
- */
-#define ARCH_HAS_SCHED_WAKE_IDLE
-/* Common values for SMT siblings */
-#ifndef SD_SIBLING_INIT
-#define SD_SIBLING_INIT (struct sched_domain) {				\
-	.min_interval		= 1,					\
-	.max_interval		= 2,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 110,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_SHARE_CPUPOWER			\
-				| 1*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				| arch_sd_sibling_asym_packing()	\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-	.smt_gain		= 1178,	/* 15% */			\
-}
-#endif
-#endif /* CONFIG_SCHED_SMT */
-
-#ifdef CONFIG_SCHED_MC
-/* Common values for MC siblings. for now mostly derived from SD_CPU_INIT */
-#ifndef SD_MC_INIT
-#define SD_MC_INIT (struct sched_domain) {				\
-	.min_interval		= 1,					\
-	.max_interval		= 4,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 1*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-}
-#endif
-#endif /* CONFIG_SCHED_MC */
-
-/* Common values for CPUs */
-#ifndef SD_CPU_INIT
-#define SD_CPU_INIT (struct sched_domain) {				\
-	.min_interval		= 1,					\
-	.max_interval		= 4,					\
-	.busy_factor		= 64,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 2,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 0*SD_SERIALIZE			\
-				| 1*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-}
-#endif
-
-#ifdef CONFIG_SCHED_BOOK
-#ifndef SD_BOOK_INIT
-#error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
-#endif
-#endif /* CONFIG_SCHED_BOOK */
-
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DECLARE_PER_CPU(int, numa_node);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..53eda22 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5225,13 +5225,12 @@ enum s_alloc {
 
 struct sched_domain_topology_level;
 
-typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
 #define SDTL_OVERLAP	0x01
 
 struct sched_domain_topology_level {
-	sched_domain_init_f init;
+	int		    level;
 	sched_domain_mask_f mask;
 	int		    flags;
 	int		    numa_level;
@@ -5455,9 +5454,8 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
 }
 
-int __weak arch_sd_sibling_asym_packing(void)
+void __weak arch_sd_customize(int level, struct sched_domain *sd, int cpu)
 {
-       return 0*SD_ASYM_PACKING;
 }
 
 /*
@@ -5471,28 +5469,6 @@ int __weak arch_sd_sibling_asym_packing(void)
 # define SD_INIT_NAME(sd, type)		do { } while (0)
 #endif
 
-#define SD_INIT_FUNC(type)						\
-static noinline struct sched_domain *					\
-sd_init_##type(struct sched_domain_topology_level *tl, int cpu) 	\
-{									\
-	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);	\
-	*sd = SD_##type##_INIT;						\
-	SD_INIT_NAME(sd, type);						\
-	sd->private = &tl->data;					\
-	return sd;							\
-}
-
-SD_INIT_FUNC(CPU)
-#ifdef CONFIG_SCHED_SMT
- SD_INIT_FUNC(SIBLING)
-#endif
-#ifdef CONFIG_SCHED_MC
- SD_INIT_FUNC(MC)
-#endif
-#ifdef CONFIG_SCHED_BOOK
- SD_INIT_FUNC(BOOK)
-#endif
-
 static int default_relax_domain_level = -1;
 int sched_domain_level_max;
 
@@ -5587,89 +5563,140 @@ static const struct cpumask *cpu_smt_mask(int cpu)
 }
 #endif
 
-/*
- * Topology list, bottom-up.
- */
-static struct sched_domain_topology_level default_topology[] = {
+#ifdef CONFIG_NUMA
+static int sched_domains_numa_levels;
+static int *sched_domains_numa_distance;
+static struct cpumask ***sched_domains_numa_masks;
+static int sched_domains_curr_level;
+#endif
+
+static struct sched_domain *
+sd_init(struct sched_domain_topology_level *tl, int cpu)
+{
+	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
+#ifdef CONFIG_NUMA
+	int sd_weight;
+#endif
+
+	*sd = (struct sched_domain) {
+		.min_interval = 1,
+		.max_interval = 4,
+		.busy_factor = 64,
+		.imbalance_pct = 125,
+
+		.flags	= 1*SD_LOAD_BALANCE
+				| 1*SD_BALANCE_NEWIDLE
+				| 1*SD_BALANCE_EXEC
+				| 1*SD_BALANCE_FORK
+				| 0*SD_BALANCE_WAKE
+				| 1*SD_WAKE_AFFINE
+				| 0*SD_SHARE_CPUPOWER
+				| 0*SD_SHARE_PKG_RESOURCES
+				| 0*SD_SERIALIZE
+				| 0*SD_PREFER_SIBLING
+				,
+
+		.last_balance = jiffies,
+		.balance_interval = 1,
+	};
+
+	switch (tl->level) {
 #ifdef CONFIG_SCHED_SMT
-	{ sd_init_SIBLING, cpu_smt_mask, },
+	case SD_LVL_SMT:
+		sd->max_interval = 2;
+		sd->imbalance_pct = 110;
+
+		sd->flags |= SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
+
+		sd->smt_gain = 1178; /* ~15% */
+
+		SD_INIT_NAME(sd, SMT);
+		break;
 #endif
 #ifdef CONFIG_SCHED_MC
-	{ sd_init_MC, cpu_coregroup_mask, },
+	case SD_LVL_MC:
+		sd->cache_nice_tries = 1;
+		sd->busy_idx = 2;
+
+		sd->flags |= SD_SHARE_PKG_RESOURCES;
+
+		SD_INIT_NAME(sd, MC);
+		break;
 #endif
+	case SD_LVL_CPU:
 #ifdef CONFIG_SCHED_BOOK
-	{ sd_init_BOOK, cpu_book_mask, },
+	case SD_LVL_BOOK:
 #endif
-	{ sd_init_CPU, cpu_cpu_mask, },
-	{ NULL, },
-};
+		sd->cache_nice_tries = 1;
+		sd->busy_idx = 2;
+		sd->idle_idx = 1;
 
-static struct sched_domain_topology_level *sched_domain_topology = default_topology;
-
-#define for_each_sd_topology(tl)			\
-	for (tl = sched_domain_topology; tl->init; tl++)
+		sd->flags |= SD_PREFER_SIBLING;
 
+		SD_INIT_NAME(sd, CPU);
+		break;
 #ifdef CONFIG_NUMA
+	case SD_LVL_NUMA:
+		sd_weight = cpumask_weight(sched_domains_numa_masks
+				[tl->numa_level][cpu_to_node(cpu)]);
 
-static int sched_domains_numa_levels;
-static int *sched_domains_numa_distance;
-static struct cpumask ***sched_domains_numa_masks;
-static int sched_domains_curr_level;
+		sd->min_interval = sd_weight;
+		sd->max_interval = 2*sd_weight;
+		sd->busy_factor = 32;
 
-static inline int sd_local_flags(int level)
-{
-	if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
-		return 0;
+		sd->cache_nice_tries = 2;
+		sd->busy_idx = 3;
+		sd->idle_idx = 2;
 
-	return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
-}
+		sd->flags |= SD_SERIALIZE;
 
-static struct sched_domain *
-sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
-{
-	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
-	int level = tl->numa_level;
-	int sd_weight = cpumask_weight(
-			sched_domains_numa_masks[level][cpu_to_node(cpu)]);
-
-	*sd = (struct sched_domain){
-		.min_interval		= sd_weight,
-		.max_interval		= 2*sd_weight,
-		.busy_factor		= 32,
-		.imbalance_pct		= 125,
-		.cache_nice_tries	= 2,
-		.busy_idx		= 3,
-		.idle_idx		= 2,
-		.newidle_idx		= 0,
-		.wake_idx		= 0,
-		.forkexec_idx		= 0,
-
-		.flags			= 1*SD_LOAD_BALANCE
-					| 1*SD_BALANCE_NEWIDLE
-					| 0*SD_BALANCE_EXEC
-					| 0*SD_BALANCE_FORK
-					| 0*SD_BALANCE_WAKE
-					| 0*SD_WAKE_AFFINE
-					| 0*SD_SHARE_CPUPOWER
-					| 0*SD_SHARE_PKG_RESOURCES
-					| 1*SD_SERIALIZE
-					| 0*SD_PREFER_SIBLING
-					| sd_local_flags(level)
-					,
-		.last_balance		= jiffies,
-		.balance_interval	= sd_weight,
-	};
-	SD_INIT_NAME(sd, NUMA);
-	sd->private = &tl->data;
+		if (sched_domains_numa_distance[tl->numa_level] >
+				RECLAIM_DISTANCE)
+			sd->flags &= ~(SD_BALANCE_EXEC | SD_BALANCE_FORK |
+						   SD_WAKE_AFFINE);
 
-	/*
-	 * Ugly hack to pass state to sd_numa_mask()...
-	 */
-	sched_domains_curr_level = tl->numa_level;
+		sd->balance_interval = sd_weight;
+
+		/*
+		 * Ugly hack to pass state to sd_numa_mask()...
+		 */
+		sched_domains_curr_level = tl->numa_level;
+
+		SD_INIT_NAME(sd, NUMA);
+		break;
+#endif
+	}
 
+	arch_sd_customize(tl->level, sd, cpu);
+	sd->private = &tl->data;
 	return sd;
 }
 
+/*
+ * Topology list, bottom-up.
+ */
+static struct sched_domain_topology_level default_topology[] = {
+#ifdef CONFIG_SCHED_SMT
+		{ SD_LVL_SMT, cpu_smt_mask },
+#endif
+#ifdef CONFIG_SCHED_MC
+		{ SD_LVL_MC, cpu_coregroup_mask },
+#endif
+#ifdef CONFIG_SCHED_BOOK
+		{ SD_LVL_BOOK, cpu_book_mask },
+#endif
+		{ SD_LVL_CPU, cpu_cpu_mask },
+		{ SD_LVL_INV, },
+};
+
+static struct sched_domain_topology_level *sched_domain_topology =
+		default_topology;
+
+#define for_each_sd_topology(tl)                       \
+		for (tl = sched_domain_topology; tl->level; tl++)
+
+#ifdef CONFIG_NUMA
+
 static const struct cpumask *sd_numa_mask(int cpu)
 {
 	return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
@@ -5821,7 +5848,7 @@ static void sched_init_numa(void)
 	/*
 	 * Copy the default topology bits..
 	 */
-	for (i = 0; default_topology[i].init; i++)
+	for (i = 0; default_topology[i].level; i++)
 		tl[i] = default_topology[i];
 
 	/*
@@ -5829,7 +5856,6 @@ static void sched_init_numa(void)
 	 */
 	for (j = 0; j < level; i++, j++) {
 		tl[i] = (struct sched_domain_topology_level){
-			.init = sd_numa_init,
 			.mask = sd_numa_mask,
 			.flags = SDTL_OVERLAP,
 			.numa_level = j,
@@ -5990,7 +6016,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
 		struct sched_domain *child, int cpu)
 {
-	struct sched_domain *sd = tl->init(tl, cpu);
+	struct sched_domain *sd = sd_init(tl, cpu);
 	if (!sd)
 		return child;
 
-- 
1.7.9.5


