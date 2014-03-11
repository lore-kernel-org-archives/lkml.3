Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaCKNTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:19:16 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47999 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaCKNTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <531EE087.7050707@linux.vnet.ibm.com>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
 <1394003906-11630-5-git-send-email-vincent.guittot@linaro.org> <531EE087.7050707@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 11 Mar 2014 14:18:53 +0100
Message-ID: <CAKfTPtCJEX7qknTb85FqJfuT03oNFN3rTOncy5Df37w65+GX8Q@mail.gmail.com>
Subject: Re: [RFC 4/6] sched: powerpc: create a dedicated topology table
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 March 2014 11:08, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi Vincent,
>
> On 03/05/2014 12:48 PM, Vincent Guittot wrote:
>> Create a dedicated topology table for handling asymetric feature.
>> The current proposal creates a new level which describes which groups of CPUs
>> take adavantge of SD_ASYM_PACKING. The useless level will be removed during the
>> build of the sched_domain topology.
>>
>> Another solution would be to set SD_ASYM_PACKING in the sd_flags of SMT level
>> during the boot sequence and before the build of the sched_domain topology.
>
> Is the below what you mean as the other solution? If it is so, I would
> strongly recommend this approach rather than adding another level to the
> topology level to represent the asymmetric behaviour.
>
> +static struct sched_domain_topology_level powerpc_topology[] = {
> +#ifdef CONFIG_SCHED_SMT
> +       { cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES,
> SD_INIT_NAME(SMT) | arch_sd_sibling_asym_packing() },
> +#endif
> +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> +       { NULL, },
> +};

Not exactly like that but something like below

+static struct sched_domain_topology_level powerpc_topology[] = {
+#ifdef CONFIG_SCHED_SMT
+ { cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES,
SD_INIT_NAME(SMT) },
+#endif
+ { cpu_cpu_mask, SD_INIT_NAME(DIE) },
+ { NULL, },
+};
+
+static void __init set_sched_topology(void)
+{
+#ifdef CONFIG_SCHED_SMT
+ powerpc_topology[0].sd_flags |= arch_sd_sibling_asym_packing();
+#endif
+ sched_domain_topology = powerpc_topology;
+}

>
> Regards
> Preeti U Murthy
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  arch/powerpc/kernel/smp.c |   35 +++++++++++++++++++++++++++--------
>>  kernel/sched/core.c       |    6 ------
>>  2 files changed, 27 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
>> index ac2621a..75da054 100644
>> --- a/arch/powerpc/kernel/smp.c
>> +++ b/arch/powerpc/kernel/smp.c
>> @@ -755,6 +755,32 @@ int setup_profiling_timer(unsigned int multiplier)
>>       return 0;
>>  }
>>
>> +#ifdef CONFIG_SCHED_SMT
>> +/* cpumask of CPUs with asymetric SMT dependancy */
>> +static const struct cpumask *cpu_asmt_mask(int cpu)
>> +{
>> +     if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
>> +             printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
>> +             return topology_thread_cpumask(cpu);
>> +     }
>> +     return cpumask_of(cpu);
>> +}
>> +#endif
>> +
>> +static struct sched_domain_topology_level powerpc_topology[] = {
>> +#ifdef CONFIG_SCHED_SMT
>> +     { cpu_asmt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_ASYM_PACKING, SD_INIT_NAME(ASMT) },
>> +     { cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES, SD_INIT_NAME(SMT) },
>> +#endif
>> +     { cpu_cpu_mask, SD_INIT_NAME(DIE) },
>> +     { NULL, },
>> +};
>> +
>> +static void __init set_sched_topology(void)
>> +{
>> +     sched_domain_topology = powerpc_topology;
>> +}
>> +
>>  void __init smp_cpus_done(unsigned int max_cpus)
>>  {
>>       cpumask_var_t old_mask;
>> @@ -779,15 +805,8 @@ void __init smp_cpus_done(unsigned int max_cpus)
>>
>>       dump_numa_cpu_topology();
>>
>> -}
>> +     set_sched_topology();
>>
>> -int arch_sd_sibling_asym_packing(void)
>> -{
>> -     if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
>> -             printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
>> -             return SD_ASYM_PACKING;
>> -     }
>> -     return 0;
>>  }
>>
>>  #ifdef CONFIG_HOTPLUG_CPU
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 3479467..7606de0 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5818,11 +5818,6 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>>       atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
>>  }
>>
>> -int __weak arch_sd_sibling_asym_packing(void)
>> -{
>> -       return 0*SD_ASYM_PACKING;
>> -}
>> -
>>  /*
>>   * Initializers for schedule domains
>>   * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
>> @@ -6000,7 +5995,6 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
>>       if (sd->flags & SD_SHARE_CPUPOWER) {
>>               sd->imbalance_pct = 110;
>>               sd->smt_gain = 1178; /* ~15% */
>> -             sd->flags |= arch_sd_sibling_asym_packing();
>>
>>       } else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
>>               sd->imbalance_pct = 117;
>>
>
