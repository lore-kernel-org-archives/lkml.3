Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3G2JqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:46:09 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48122 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3G2JqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <1374921728-9007-1-git-send-email-hanjun.guo@linaro.org>
References: <1374921728-9007-1-git-send-email-hanjun.guo@linaro.org>
Date: Mon, 29 Jul 2013 11:46:06 +0200
Message-ID: <CAKfTPtBpo41LJ3V8TB8YwudwqpURuA2u_Lvu4KYVK=qSs+gFuQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] ARM64: add cpu topology definition
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Naresh Bhat <naresh.bhat@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 July 2013 12:42, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> Power aware scheduling needs the cpu topology information to improve the
> cpu scheduler decision making.

It's not only power aware scheduling. The scheduler already uses
topology and cache sharing when  CONFIG_SCHED_MC and/or
CONFIG_SCHED_SMT are enable. So you should also add these configs for
arm64 so the scheduler can use it

Vincent

>
> For ARM64, we can get the topology from the MPIDR register which defines the
> the affinity of processors.
>
> This patch is mainly based on arch/arm/kernel/topology.c written by
> Vincent Guittot, and replaced the topology array with per cpu variable.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/Kconfig                |    9 +++
>  arch/arm64/include/asm/cputype.h  |   11 ++++
>  arch/arm64/include/asm/topology.h |   41 ++++++++++++
>  arch/arm64/kernel/Makefile        |    1 +
>  arch/arm64/kernel/smp.c           |    6 ++
>  arch/arm64/kernel/topology.c      |  128 +++++++++++++++++++++++++++++++++++++
>  6 files changed, 196 insertions(+)
>  create mode 100644 arch/arm64/include/asm/topology.h
>  create mode 100644 arch/arm64/kernel/topology.c
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 9737e97..f0ce91b 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -150,6 +150,15 @@ config SMP
>
>           If you don't know what to do here, say N.
>
> +config ARM64_CPU_TOPOLOGY
> +       bool "Support cpu topology definition"
> +       depends on SMP && ARM64
> +       default y
> +       help
> +         Support ARM64 cpu topology definition. The MPIDR register defines
> +         affinity between processors which is then used to describe the cpu
> +         topology of an ARM64 System.
> +
>  config NR_CPUS
>         int "Maximum number of CPUs (2-32)"
>         range 2 32
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index 5fe138e..68b55af 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -30,6 +30,17 @@
>
>  #define MPIDR_HWID_BITMASK     0xff00ffffff
>
> +#define MPIDR_SMP_BITMASK      (0x1 << 30)
> +#define MPIDR_MT_BITMASK       (0x1 << 24)
> +
> +#define MPIDR_LEVEL_BITS       8
> +#define MPIDR_LEVEL_MASK       ((1 << MPIDR_LEVEL_BITS) - 1)
> +
> +#define MPIDR_AFFINITY_LEVEL_0(mpidr) ((mpidr) & MPIDR_LEVEL_MASK)
> +#define MPIDR_AFFINITY_LEVEL_1(mpidr) ((mpidr >> 8) & MPIDR_LEVEL_MASK)
> +#define MPIDR_AFFINITY_LEVEL_2(mpidr) ((mpidr >> 16) & MPIDR_LEVEL_MASK)
> +#define MPIDR_AFFINITY_LEVEL_3(mpidr) ((mpidr >> 32) & MPIDR_LEVEL_MASK)
> +
>  #define read_cpuid(reg) ({                                             \
>         u64 __val;                                                      \
>         asm("mrs        %0, " reg : "=r" (__val));                      \
> diff --git a/arch/arm64/include/asm/topology.h b/arch/arm64/include/asm/topology.h
> new file mode 100644
> index 0000000..8631808
> --- /dev/null
> +++ b/arch/arm64/include/asm/topology.h
> @@ -0,0 +1,41 @@
> +#ifndef _ASM_ARM64_TOPOLOGY_H
> +#define _ASM_ARM64_TOPOLOGY_H
> +
> +#ifdef CONFIG_ARM64_CPU_TOPOLOGY
> +
> +#include <linux/cpumask.h>
> +
> +struct cputopo_arm64 {
> +       int thread_id;
> +       int core_id;
> +       int socket_id;
> +       cpumask_t thread_sibling;
> +       cpumask_t core_sibling;
> +};
> +
> +DECLARE_PER_CPU(struct cputopo_arm64, cpu_topology);
> +
> +#define cpu_topo(cpu) per_cpu(cpu_topology, cpu)
> +
> +#define topology_physical_package_id(cpu)      (cpu_topo(cpu).socket_id)
> +#define topology_core_id(cpu)          (cpu_topo(cpu).core_id)
> +#define topology_core_cpumask(cpu)     (&cpu_topo(cpu).core_sibling)
> +#define topology_thread_cpumask(cpu)   (&cpu_topo(cpu).thread_sibling)
> +
> +#define mc_capable()   (cpu_topo(0).socket_id != -1)
> +#define smt_capable()  (cpu_topo(0).thread_id != -1)
> +
> +void init_cpu_topology(void);
> +void store_cpu_topology(unsigned int cpuid);
> +const struct cpumask *cpu_coregroup_mask(int cpu);
> +
> +#else
> +
> +static inline void init_cpu_topology(void) { }
> +static inline void store_cpu_topology(unsigned int cpuid) { }
> +
> +#endif
> +
> +#include <asm-generic/topology.h>
> +
> +#endif /* _ASM_ARM64_TOPOLOGY_H */
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 7b4b564..a47c359 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -18,6 +18,7 @@ arm64-obj-$(CONFIG_SMP)                       += smp.o smp_spin_table.o smp_psci.o
>  arm64-obj-$(CONFIG_HW_PERF_EVENTS)     += perf_event.o
>  arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
>  arm64-obj-$(CONFIG_EARLY_PRINTK)       += early_printk.o
> +arm64-obj-$(CONFIG_ARM64_CPU_TOPOLOGY)  += topology.o
>
>  obj-y                                  += $(arm64-obj-y) vdso/
>  obj-m                                  += $(arm64-obj-m)
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index fee5cce..197b1da 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -39,6 +39,7 @@
>  #include <asm/atomic.h>
>  #include <asm/cacheflush.h>
>  #include <asm/cputype.h>
> +#include <asm/topology.h>
>  #include <asm/mmu_context.h>
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -215,6 +216,8 @@ asmlinkage void secondary_start_kernel(void)
>         local_irq_enable();
>         local_fiq_enable();
>
> +       store_cpu_topology(cpu);
> +
>         /*
>          * OK, it's off to the idle thread for us
>          */
> @@ -387,6 +390,9 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>         int cpu, err;
>         unsigned int ncores = num_possible_cpus();
>
> +       init_cpu_topology();
> +       store_cpu_topology(smp_processor_id());
> +
>         /*
>          * are we trying to boot more cores than exist?
>          */
> diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
> new file mode 100644
> index 0000000..1eb0435
> --- /dev/null
> +++ b/arch/arm64/kernel/topology.c
> @@ -0,0 +1,128 @@
> +/*
> + * arch/arm64/kernel/topology.c
> + *
> + * Copyright (C) 2013 Linaro Limited.
> + * Written by: Hanjun Guo
> + *
> + * based on arch/arm/kernel/topology.c
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + */
> +
> +#include <linux/cpu.h>
> +#include <linux/cpumask.h>
> +#include <linux/init.h>
> +#include <linux/percpu.h>
> +#include <linux/sched.h>
> +
> +#include <asm/cputype.h>
> +#include <asm/topology.h>
> +
> +DEFINE_PER_CPU(struct cputopo_arm64, cpu_topology);
> +
> +const struct cpumask *cpu_coregroup_mask(int cpu)
> +{
> +       return &cpu_topo(cpu).core_sibling;
> +}
> +
> +void update_siblings_masks(unsigned int cpuid)
> +{
> +       struct cputopo_arm64 *topo, *cpuid_topo = &cpu_topo(cpuid);
> +       int cpu;
> +
> +       /* update core and thread sibling masks */
> +       for_each_possible_cpu(cpu) {
> +               topo = &cpu_topo(cpu);
> +
> +               if (cpuid_topo->socket_id != topo->socket_id)
> +                       continue;
> +
> +               cpumask_set_cpu(cpuid, &topo->core_sibling);
> +               if (cpu != cpuid)
> +                       cpumask_set_cpu(cpu, &cpuid_topo->core_sibling);
> +
> +               if (cpuid_topo->core_id != topo->core_id)
> +                       continue;
> +
> +               cpumask_set_cpu(cpuid, &topo->thread_sibling);
> +               if (cpu != cpuid)
> +                       cpumask_set_cpu(cpu, &cpuid_topo->thread_sibling);
> +       }
> +       smp_wmb();
> +}
> +
> +/*
> + * store_cpu_topology is called at boot when only one cpu is running
> + * and with the mutex cpu_hotplug.lock locked, when several cpus have booted,
> + * which prevents simultaneous write access to cpu_topology array
> + */
> +void store_cpu_topology(unsigned int cpuid)
> +{
> +       struct cputopo_arm64 *cpuid_topo = &cpu_topo(cpuid);
> +       u64 mpidr;
> +
> +       /* If the cpu topology has been already set, just return */
> +       if (cpuid_topo->core_id != -1)
> +               return;
> +
> +       mpidr = read_cpuid_mpidr();
> +
> +       /* create cpu topology mapping */
> +       if (!(mpidr & MPIDR_SMP_BITMASK)) {
> +               /*
> +                * This is a multiprocessor system
> +                * multiprocessor format & multiprocessor mode field are set
> +                */
> +
> +               if (mpidr & MPIDR_MT_BITMASK) {
> +                       /* core performance interdependency */
> +                       cpuid_topo->thread_id = MPIDR_AFFINITY_LEVEL_0(mpidr);
> +                       cpuid_topo->core_id = MPIDR_AFFINITY_LEVEL_1(mpidr);
> +                       cpuid_topo->socket_id = MPIDR_AFFINITY_LEVEL_2(mpidr);
> +               } else {
> +                       /* largely independent cores */
> +                       cpuid_topo->thread_id = -1;
> +                       cpuid_topo->core_id = MPIDR_AFFINITY_LEVEL_0(mpidr);
> +                       cpuid_topo->socket_id = MPIDR_AFFINITY_LEVEL_1(mpidr);
> +               }
> +       } else {
> +               /*
> +                * This is an uniprocessor system
> +                * we are in multiprocessor format but uniprocessor system
> +                * or in the old uniprocessor format
> +                */
> +               cpuid_topo->thread_id = -1;
> +               cpuid_topo->core_id = 0;
> +               cpuid_topo->socket_id = -1;
> +       }
> +
> +       update_siblings_masks(cpuid);
> +
> +       printk(KERN_INFO "CPU%u: thread %d, cpu %d, socket %d, mpidr 0x%llx\n",
> +               cpuid, cpu_topo(cpuid).thread_id,
> +               cpu_topo(cpuid).core_id,
> +               cpu_topo(cpuid).socket_id, mpidr);
> +}
> +
> +/*
> + * init_cpu_topology is called at boot when only one cpu is running
> + * which prevent simultaneous write access to cpu_topology array
> + */
> +void __init init_cpu_topology(void)
> +{
> +       unsigned int cpu;
> +
> +       /* init core mask */
> +       for_each_possible_cpu(cpu) {
> +               struct cputopo_arm64 *topo = &cpu_topo(cpu);
> +
> +               topo->thread_id = -1;
> +               topo->core_id =  -1;
> +               topo->socket_id = -1;
> +               cpumask_clear(&topo->core_sibling);
> +               cpumask_clear(&topo->thread_sibling);
> +       }
> +       smp_wmb();
> +}
> --
> 1.7.9.5
>
