Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaIXQkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:40:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:51958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaIXQkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:40:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604746108"
From: Andi Kleen <andi@firstfloor.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 08/11] perf/x86/intel: Add Intel Cache QoS Monitoring support
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
	<1411567455-31264-9-git-send-email-matt@console-pimps.org>
Date: Wed, 24 Sep 2014 09:40:10 -0700
In-Reply-To: <1411567455-31264-9-git-send-email-matt@console-pimps.org> (Matt
	Fleming's message of "Wed, 24 Sep 2014 15:04:12 +0100")
Message-ID: <874mvx6kgl.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming <matt@console-pimps.org> writes:
>
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index 7e1fd4e08552..8abb18fbcd13 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -38,7 +38,7 @@ obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_uncore_snb.o
>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore_snbep.o perf_event_intel_uncore_nhmex.o
> -obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o
> +obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o perf_event_intel_cqm.o

What's missing to be able to make this a module?

> +
> +	/*
> +	 * Is @cpu a designated cqm reader?
> +	 */
> +	if (!cpumask_test_and_clear_cpu(cpu, &cqm_cpumask))
> +		return;
> +
> +	for_each_online_cpu(i) {

Likely possible cpus to avoid races? Otherwise you'll need more locking.

> +		if (i == cpu)
> +			continue;
> +
> +		if (phys_id == topology_physical_package_id(i)) {
> +			cpumask_set_cpu(i, &cqm_cpumask);
> +			break;
> +		}
> +	}
> +}
> +
> +static int intel_cqm_cpu_notifier(struct notifier_block *nb,
> +				  unsigned long action, void *hcpu)
> +{
> +	unsigned int cpu  = (unsigned long)hcpu;
> +
> +	switch (action & ~CPU_TASKS_FROZEN) {
> +	case CPU_UP_PREPARE:
> +		intel_cqm_cpu_prepare(cpu);
> +		break;
> +	case CPU_DOWN_PREPARE:
> +		intel_cqm_cpu_exit(cpu);
> +		break;
> +	case CPU_STARTING:
> +		cqm_pick_event_reader(cpu);
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static int __init intel_cqm_init(void)
> +{
> +	int i, cpu, ret;
> +
> +	if (!cpu_has(&boot_cpu_data, X86_FEATURE_CQM_OCCUP_LLC))
> +		return -ENODEV;

This should use cpufeature.h

> +
> +	cqm_l3_scale = boot_cpu_data.x86_cache_occ_scale;
> +
> +	/*
> +	 * It's possible that not all resources support the same number
> +	 * of RMIDs. Instead of making scheduling much more complicated
> +	 * (where we have to match a task's RMID to a cpu that supports
> +	 * that many RMIDs) just find the minimum RMIDs supported across
> +	 * all cpus.
> +	 *
> +	 * Also, check that the scales match on all cpus.
> +	 */
> +	for_each_online_cpu(cpu) {

And this should take the cpu hotplug lock (although it may be
latent at this point if it's only running at early initializion)

But in fact what good is the test then if you only
every likely check cpu #0?

> +		struct cpuinfo_x86 *c = &cpu_data(cpu);
> +
> +		if (c->x86_cache_max_rmid < cqm_max_rmid)
> +			cqm_max_rmid = c->x86_cache_max_rmid;
> +
> +		if (c->x86_cache_occ_scale != cqm_l3_scale) {
> +			pr_err("Multiple LLC scale values, disabling\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	ret = intel_cqm_setup_rmid_cache();
> +	if (ret)
> +		return ret;
> +
> +	for_each_online_cpu(i) {
> +		intel_cqm_cpu_prepare(i);
> +		cqm_pick_event_reader(i);
> +	}


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
