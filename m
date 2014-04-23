Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaDWOrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:47:00 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:47360 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaDWOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:46:58 -0400
MIME-Version: 1.0
In-Reply-To: <5357A802.1030804@arm.com>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
 <1397209481-28542-6-git-send-email-vincent.guittot@linaro.org> <5357A802.1030804@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 23 Apr 2014 16:46:38 +0200
Message-ID: <CAKfTPtDnw-OZZekdE3oNGS11m6dfpS4veMNZ_Bezs-Lm7zn6QQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] sched: ARM: create a dedicated scheduler topology table
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
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

On 23 April 2014 13:46, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> Hi,
>
> I'm trying to use this approach of specifying different per-cpu views on
> sd flags on DIE level on a TC2 platform (cluster 0 w/ CPU0/1 and cluster
> 1 w/ CPU2/3/4 w/o SMT). It doesn't work like in the case for the GMC/MC
> sd level.
>
> If I use the following patch (just to illustrate the issue) on top
> (returning SD_SHARE_POWERDOMAIN in cpu_cpupower_flags() is bogus ... I
> just needed a flag function for GDIE level):
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 71e1fec6d31a..803330d89c09 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -194,6 +194,14 @@ const struct cpumask *cpu_corepower_mask(int cpu)
>         return &cpu_topology[cpu].thread_sibling;
>  }
>
> +const struct cpumask *cpu_cpupower_mask(int cpu)
> +{
> +       return cpu_topology[cpu].socket_id ?
> +                       cpumask_of_node(cpu_to_node(cpu)) :
> +                       &cpu_topology[cpu].core_sibling;
> +}
> +
> +
>  static void update_siblings_masks(unsigned int cpuid)
>  {
>         struct cputopo_arm *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
> @@ -280,11 +288,18 @@ static inline const int cpu_corepower_flags(void)
>         return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
>  }
>
> +static inline const int cpu_cpupower_flags(void)
> +{
> +       return SD_SHARE_POWERDOMAIN;
> +}
> +
> +
>  static struct sched_domain_topology_level arm_topology[] = {
>  #ifdef CONFIG_SCHED_MC
>         { cpu_corepower_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
>         { cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
>  #endif
> +       { cpu_cpupower_mask, cpu_cpupower_flags, SD_INIT_NAME(GDIE) },
>         { cpu_cpu_mask, SD_INIT_NAME(DIE) },
>         { NULL, },
>  };
>
> so I get the following topology:
>
> CPU0: cpu_corepower_mask=0   (GMC)
> CPU0: cpu_coregroup_mask=0-1 (MC)
> CPU0:  cpu_cpupower_mask=0-1 (GDIE)
> CPU0:       cpu_cpu_mask=0-4 (DIE)
> CPU1: cpu_corepower_mask=1    ...
> CPU1: cpu_coregroup_mask=0-1
> CPU1:  cpu_cpupower_mask=0-1
> CPU1:       cpu_cpu_mask=0-4
> CPU2: cpu_corepower_mask=2
> CPU2: cpu_coregroup_mask=2-4
> CPU2:  cpu_cpupower_mask=0-4
> CPU2:       cpu_cpu_mask=0-4
> CPU3: cpu_corepower_mask=3
> CPU3: cpu_coregroup_mask=2-4
> CPU3:  cpu_cpupower_mask=0-4
> CPU3:       cpu_cpu_mask=0-4
> CPU4: cpu_corepower_mask=4
> CPU4: cpu_coregroup_mask=2-4
> CPU4:  cpu_cpupower_mask=0-4
> CPU4:       cpu_cpu_mask=0-4

You  have an inconsistency in your topology description:

At GDIE level:
CPU1 cpu_cpupower_mask=0-1
but
CPU2 cpu_cpupower_mask=0-4

so CPU2 says that it shares power domain with CPU0 but CPU1 says the opposite

Regards
Vincent

>
> Firstly, I had to get rid of the cpumask_equal(cpu_map,
> sched_domain_span(sd)) condition in build_sched_domains() to allow that
> I can have two sd levels which span CPU 0-4 (for CPU2/3/4).
>
> But it still doesn't work correctly:
>
> dmesg snippet 2:
>
> CPU0 attaching sched-domain:
>  domain 0: span 0-1 level MC
>   groups: 0 1
>   domain 1: span 0-4 level DIE     <-- error (there's only one group)
>    groups: 0-4 (cpu_power = 2048)
> ...
> CPU2 attaching sched-domain:
>  domain 0: span 2-4 level MC
>   groups: 2 3 4
>   domain 1: span 0-4 level GDIE
> ERROR: domain->groups does not contain CPU2
>    groups:
> ERROR: domain->cpu_power not set
>
> ERROR: groups don't span domain->span
> ...
>
> It turns out that the function get_group() which is used a couple of
> times in build_sched_groups() uses a reference to sd->child and even
> though the degenerate functionality gets rid of GDIE for CPU0/1 and DIE
> for CPU2/3/4 the group set-up doesn't work as expected since sd->child
> for DIE is GDIE and not MC any more.
> So it looks like GMC/MC level is somehow special (GMC has no sd->child
> for TC2 or GMC/MC contains only one cpu per group?).
>
> Although this problem does not effect the current patch-set, people
> might think that they can apply this degenerate trick for other sd
> levels as well.
>
> I'm trying to fix get_group()/build_sched_groups() in such a way that my
> example would work but so far I haven't succeeded. The question for me
> remains ... is this application of the degenerate trick feasible at all
> in all sd levels, i.e. does it scale? What about platforms w/ SMT sd
> level which want to use this trick in GMC/MC level?
>
> Any hints are highly appreciated here.
>
> -- Dietmar
>
> On 11/04/14 10:44, Vincent Guittot wrote:
>> Create a dedicated topology table for ARM which will create new level to
>> differentiate CPUs that can or not powergate independantly from others.
>>
>> The patch gives an example of how to add domain that will take advantage of
>> SD_SHARE_POWERDOMAIN.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  arch/arm/kernel/topology.c | 26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
>> index 0bc94b1..71e1fec 100644
>> --- a/arch/arm/kernel/topology.c
>> +++ b/arch/arm/kernel/topology.c
>> @@ -185,6 +185,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>>       return &cpu_topology[cpu].core_sibling;
>>  }
>>
>> +/*
>> + * The current assumption is that we can power gate each core independently.
>> + * This will be superseded by DT binding once available.
>> + */
>> +const struct cpumask *cpu_corepower_mask(int cpu)
>> +{
>> +     return &cpu_topology[cpu].thread_sibling;
>> +}
>> +
>>  static void update_siblings_masks(unsigned int cpuid)
>>  {
>>       struct cputopo_arm *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
>> @@ -266,6 +275,20 @@ void store_cpu_topology(unsigned int cpuid)
>>               cpu_topology[cpuid].socket_id, mpidr);
>>  }
>>
>> +static inline const int cpu_corepower_flags(void)
>> +{
>> +     return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
>> +}
>> +
>> +static struct sched_domain_topology_level arm_topology[] = {
>> +#ifdef CONFIG_SCHED_MC
>> +     { cpu_corepower_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
>> +     { cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
>> +#endif
>> +     { cpu_cpu_mask, SD_INIT_NAME(DIE) },
>> +     { NULL, },
>> +};
>> +
>>  /*
>>   * init_cpu_topology is called at boot when only one cpu is running
>>   * which prevent simultaneous write access to cpu_topology array
>> @@ -289,4 +312,7 @@ void __init init_cpu_topology(void)
>>       smp_wmb();
>>
>>       parse_dt_topology();
>> +
>> +     /* Set scheduler topology descriptor */
>> +     set_sched_topology(arm_topology);
>>  }
>>
>
>
