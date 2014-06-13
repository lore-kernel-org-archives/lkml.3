Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaFMIFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:05:34 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:63870 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaFMIF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:05:29 -0400
MIME-Version: 1.0
In-Reply-To: <1402614493-12521-1-git-send-email-linux@roeck-us.net>
References: <1402614493-12521-1-git-send-email-linux@roeck-us.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 13 Jun 2014 10:05:08 +0200
Message-ID: <CAKfTPtAhykeqorg7SSbMYkHQ-bjoHQx4tCrxy+yubPxhSHThww@mail.gmail.com>
Subject: Re: [PATCH] sched: Fix compiler warnings
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

There are also such kind of function in ARM and powerpc architecture

with the additional changes below, you can add my
Acked-by Vincent Guittot <vincent.guittot@linaro.org>

Vincent

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 1576d05..7e56b2f 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -275,7 +275,7 @@ void store_cpu_topology(unsigned int cpuid)
  cpu_topology[cpuid].socket_id, mpidr);
 }

-static inline const int cpu_corepower_flags(void)
+static inline int cpu_corepower_flags(void)
 {
  return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
 }
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 10ffffe..49d5d4e 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -768,7 +768,7 @@ int setup_profiling_timer(unsigned int multiplier)

 #ifdef CONFIG_SCHED_SMT
 /* cpumask of CPUs with asymetric SMT dependancy */
-static const int powerpc_smt_flags(void)
+static int powerpc_smt_flags(void)
 {
  int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;


On 13 June 2014 01:08, Guenter Roeck <linux@roeck-us.net> wrote:
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
> Drop 'const' from the function declarations to fix the problem.
>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  include/linux/sched.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ea74596..65046b3 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -872,21 +872,21 @@ enum cpu_idle_type {
>  #define SD_NUMA                        0x4000  /* cross-node balancing */
>
>  #ifdef CONFIG_SCHED_SMT
> -static inline const int cpu_smt_flags(void)
> +static inline int cpu_smt_flags(void)
>  {
>         return SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
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
