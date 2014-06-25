Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaFYGlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:41:42 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37370 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaFYGll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:41:41 -0400
MIME-Version: 1.0
In-Reply-To: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 25 Jun 2014 08:41:20 +0200
Message-ID: <CAKfTPtBzpuVf7Ts0YunD=38hONg2RT3Ymr-jvFxx4woa_Qt9tQ@mail.gmail.com>
Subject: Re: [PATCH v2] sched: Fix compiler warnings
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 June 2014 03:05, Guenter Roeck <linux@roeck-us.net> wrote:
> Commit 143e1e28cb (sched: Rework sched_domain topology definition)
> introduced a number of functions with a return value of 'const int'.
> gcc doesn't know what to do with that and, if the kernel is compiled
> with W=1, complains with the following warnings whenever sched.h
> is included.
>
> include/linux/sched.h:875:25: warning:
>         type qualifiers ignored on function return type
> include/linux/sched.h:882:25: warning:
>         type qualifiers ignored on function return type
> include/linux/sched.h:889:25: warning:
>         type qualifiers ignored on function return type
> include/linux/sched.h:1002:21: warning:
>         type qualifiers ignored on function return type
>
> Commits fb2aa855 (sched, ARM: Create a dedicated scheduler topology table)
> and 607b45e9a (sched, powerpc: Create a dedicated topology table) introduce
> the same warning in the arm and powerpc code.
>
> Drop 'const' from the function declarations to fix the problem.
>
> The fix for all three patches has to be applied together to avoid
> compilation failures for the affected architectures.
>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>

Acked-by Vincent Guittot <vincent.guittot@linaro.org>

> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Fix problem in all affected architectures with a single patch
>     to avoid compilation errors.
>
>  arch/arm/kernel/topology.c | 2 +-
>  arch/powerpc/kernel/smp.c  | 2 +-
>  include/linux/sched.h      | 8 ++++----
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 9d85318..e35d880 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -275,7 +275,7 @@ void store_cpu_topology(unsigned int cpuid)
>                 cpu_topology[cpuid].socket_id, mpidr);
>  }
>
> -static inline const int cpu_corepower_flags(void)
> +static inline int cpu_corepower_flags(void)
>  {
>         return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
>  }
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 51a3ff7..1007fb8 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -747,7 +747,7 @@ int setup_profiling_timer(unsigned int multiplier)
>
>  #ifdef CONFIG_SCHED_SMT
>  /* cpumask of CPUs with asymetric SMT dependancy */
> -static const int powerpc_smt_flags(void)
> +static int powerpc_smt_flags(void)
>  {
>         int flags = SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 306f4f0..0376b05 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -872,21 +872,21 @@ enum cpu_idle_type {
>  #define SD_NUMA                        0x4000  /* cross-node balancing */
>
>  #ifdef CONFIG_SCHED_SMT
> -static inline const int cpu_smt_flags(void)
> +static inline int cpu_smt_flags(void)
>  {
>         return SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
>  }
>  #endif
>
>  #ifdef CONFIG_SCHED_MC
> -static inline const int cpu_core_flags(void)
> +static inline int cpu_core_flags(void)
>  {
>         return SD_SHARE_PKG_RESOURCES;
>  }
>  #endif
>
>  #ifdef CONFIG_NUMA
> -static inline const int cpu_numa_flags(void)
> +static inline int cpu_numa_flags(void)
>  {
>         return SD_NUMA;
>  }
> @@ -999,7 +999,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
>  bool cpus_share_cache(int this_cpu, int that_cpu);
>
>  typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
> -typedef const int (*sched_domain_flags_f)(void);
> +typedef int (*sched_domain_flags_f)(void);
>
>  #define SDTL_OVERLAP   0x01
>
> --
> 1.9.1
>
