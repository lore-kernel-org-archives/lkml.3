Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3KFKuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:50:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51653 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab3KFKuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:50:23 -0500
Date: Wed, 6 Nov 2013 11:50:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v5 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131106105003.GG10651@twins.programming.kicks-ass.net>
References: <1383670886-30827-1-git-send-email-eranian@google.com>
 <1383670886-30827-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383670886-30827-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 06:01:25PM +0100, Stephane Eranian wrote:
> +static DEFINE_SPINLOCK(rapl_hotplug_lock);

> +static void rapl_exit_cpu(int cpu)
> +{
> +	int i, phys_id = topology_physical_package_id(cpu);
> +
> +	spin_lock(&rapl_hotplug_lock);

> +	spin_unlock(&rapl_hotplug_lock);
> +}
> +
> +static void rapl_init_cpu(int cpu)
> +{
> +	int i, phys_id = topology_physical_package_id(cpu);
> +
> +	spin_lock(&rapl_hotplug_lock);

> +	spin_unlock(&rapl_hotplug_lock);
> +}

> +static int rapl_cpu_starting(int cpu)
> +{
> +	struct rapl_pmu *pmu2;
> +	struct rapl_pmu *pmu1 = per_cpu(rapl_pmu, cpu);
> +	int i, phys_id = topology_physical_package_id(cpu);
> +
> +	if (pmu1)
> +		return 0;
> +
> +	spin_lock(&rapl_hotplug_lock);

> +	spin_unlock(&rapl_hotplug_lock);
> +	return 0;
> +}
> +
> +static int rapl_cpu_dying(int cpu)
> +{
> +	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
> +	struct perf_event *event, *tmp;
> +
> +	if (!pmu)
> +		return 0;
> +
> +	spin_lock(&rapl_hotplug_lock);

> +	spin_unlock(&rapl_hotplug_lock);
> +	return 0;
> +}
> +
> +static int rapl_cpu_notifier(struct notifier_block *self,
> +			     unsigned long action, void *hcpu)
> +{
> +	unsigned int cpu = (long)hcpu;
> +
> +	/* allocate/free data structure for uncore box */
> +	switch (action & ~CPU_TASKS_FROZEN) {
> +	case CPU_UP_PREPARE:
> +		rapl_cpu_prepare(cpu);
> +		break;
> +	case CPU_STARTING:
> +		rapl_cpu_starting(cpu);
> +		break;
> +	case CPU_UP_CANCELED:
> +	case CPU_DYING:
> +		rapl_cpu_dying(cpu);
> +		break;
> +	case CPU_ONLINE:
> +		kfree(per_cpu(rapl_pmu_kfree, cpu));
> +		per_cpu(rapl_pmu_kfree, cpu) = NULL;
> +		break;
> +	case CPU_DEAD:
> +		per_cpu(rapl_pmu, cpu) = NULL;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	/* select the cpu that collects uncore events */
> +	switch (action & ~CPU_TASKS_FROZEN) {
> +	case CPU_DOWN_FAILED:
> +	case CPU_STARTING:
> +		rapl_init_cpu(cpu);
> +		break;
> +	case CPU_DOWN_PREPARE:
> +		rapl_exit_cpu(cpu);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}

What's the point of that rapl_hotplug_lock? It appears all methods its
used from are called from hotplug notifiers and those are fully
serialized by cpu_add_remove_lock.


