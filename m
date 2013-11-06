Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab3KFKKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:10:24 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55000 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3KFKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:10:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
	<1382097147-30088-2-git-send-email-vincent.guittot@linaro.org>
	<20131105140626.GP31370@twins.programming.kicks-ass.net>
	<CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com>
	<20131105222752.GD16117@laptop.programming.kicks-ass.net>
Date: Wed, 6 Nov 2013 11:10:22 +0100
Message-ID: <CAKfTPtByh_HW02Aw_346iO+Ovyzfp-Gqdkqr3PoxuA_Nxcf_KA@mail.gmail.com>
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

On 5 November 2013 23:27, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Nov 05, 2013 at 03:57:23PM +0100, Vincent Guittot wrote:
>> Your proposal looks fine for me. It's clearly better to move in one
>> place the configuration of sched_domain fields. Have you already got
>> an idea about how to let architecture override the topology?
>
> Maybe something like the below -- completely untested (my s390 compiler
> is on a machine that's currently powered off).
>
>> My primary need comes from the fact that the topology configuration is
>> not the same for all cores
>
> Do expand.. the various cpu masks used in the topology list are per cpu,
> is that sufficient room to wriggle or do you need more?

My current implementation sets a flag in each level (SMT, MC and CPU)
to describe the power gating capabilities for the groups of cpus but
the capabilities can be different for a same level; I mean that we can
have a group of cpus that can power gate at MC level in the system
whereas another group of CPUs can only power gate at CPU level. With
the current implementation i can't make the difference so i have added
the cpu parameters when setting the flags.
The other solution is to add new topology levels with cpu masks that
can give the power dependency with other (currently the power gating
but we can have more level for frequency dependency as an example). In
this case the current implementation is enough and the main difficulty
will be the place where we can insert these new levels compared to
current ones.

A typical example with one cluster that can power gate at core level
whereas the other cluster can power gate at cluster level, will give
the following domain topology:

If we set a flag in the current topology levels we should have
something like below

CPU0:
domain 0: span 0-1 level: SMT flags: SD_SHARE_CPUPOWER |
SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
    groups: 0 1
domain 1: span 0-7 level: MC flags: SD_SHARE_PKG_RESOURCES
    groups: 0-1 2-3 4-5 6-7
domain 2: span 0-15 level: CPU flags:
    groups: 0-7 8-15

CPU8
domain 0: span 8-9 level: SMT flags: SD_SHARE_CPUPOWER |
SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
    groups: 8 9
domain 1: span 8-15 level: MC flags: SD_SHARE_PKG_RESOURCES |
SD_SHARE_POWERDOMAIN
    groups: 8-9 10-11 12-13 14-15
domain 2: span 0-15 level CPU flags:
    groups: 8-15 0-7

If we create new levels, we could have something like below

CPU0
domain 0: span 0-1 level: SMT flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES
    groups: 0 1
domain 1: span 0-7 level: MC flags: SD_SHARE_PKG_RESOURCES
    groups: 0-1 2-3 4-5 6-7
domain 2: span 0-15 level PWR flags  SD_NOT_SHARE_POWERDOMAIN
    groups: 0-1 2-3 4-5 6-7 8-15
domain 3: span 0-15 level: CPU flags:
    groups: 0-7 8-15

CPU8
domain 0: span 8-9 level: SMT flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES
    groups: 8 9
domain 1: span 8-15 level: MC flags: SD_SHARE_PKG_RESOURCES
    groups: 8-9 10-11 12-13 14-15
domain 2: span 0-15 level PWR flags  SD_NOT_SHARE_POWERDOMAIN
    groups: 0-1 2-3 4-5 6-7 8-15
domain 3: span 0-15 level CPU flags:
    groups: 8-15 0-7

Vincent

>
> ---
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -1070,3 +1070,23 @@ static int __init s390_smp_init(void)
>         return 0;
>  }
>  subsys_initcall(s390_smp_init);
> +
> +static struct sched_domain_topology_level s390_topology[] = {
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
> +static int __init s390_sched_topology(void)
> +{
> +       sched_domain_topology = s390_topology;
> +}
> +early_initcall(s390_sched_topology);
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -889,6 +889,20 @@ void free_sched_domains(cpumask_var_t do
>
>  bool cpus_share_cache(int this_cpu, int that_cpu);
>
> +typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
> +
> +#define SDTL_OVERLAP   0x01
> +
> +struct sched_domain_topology_level {
> +       sched_domain_mask_f mask;
> +       int                 sd_flags;
> +       int                 flags;
> +       int                 numa_level;
> +       struct sd_data      data;
> +};
> +
> +extern struct sched_domain_topology_level *sched_domain_topology;
> +
>  #else /* CONFIG_SMP */
>
>  struct sched_domain_attr;
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5377,20 +5377,6 @@ enum s_alloc {
>         sa_none,
>  };
>
> -struct sched_domain_topology_level;
> -
> -typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
> -
> -#define SDTL_OVERLAP   0x01
> -
> -struct sched_domain_topology_level {
> -       sched_domain_mask_f mask;
> -       int                 sd_flags;
> -       int                 flags;
> -       int                 numa_level;
> -       struct sd_data      data;
> -};
> -
>  /*
>   * Build an iteration mask that can exclude certain CPUs from the upwards
>   * domain traversal.
> @@ -5841,6 +5827,7 @@ sd_init(struct sched_domain_topology_lev
>
>         return sd;
>  }
> +
>  /*
>   * Topology list, bottom-up.
>   */
> @@ -5851,14 +5838,11 @@ static struct sched_domain_topology_leve
>  #ifdef CONFIG_SCHED_MC
>         { cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES },
>  #endif
> -#ifdef CONFIG_SCHED_BOOK
> -       { cpu_book_mask, },
> -#endif
>         { cpu_cpu_mask, },
>         { NULL, },
>  };
>
> -static struct sched_domain_topology_level *sched_domain_topology = default_topology;
> +struct sched_domain_topology_level *sched_domain_topology = default_topology;
>
>  #define for_each_sd_topology(tl)                       \
>         for (tl = sched_domain_topology; tl->mask; tl++)
