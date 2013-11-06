Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab3KFKxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:53:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51732 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab3KFKxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:53:15 -0500
Date: Wed, 6 Nov 2013 11:52:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v5 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131106105258.GH10651@twins.programming.kicks-ass.net>
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
> +static void rapl_exit_cpu(int cpu)
> +{
> +	int i, phys_id = topology_physical_package_id(cpu);
> +
> +	spin_lock(&rapl_hotplug_lock);
> +
> +	/* if CPU not in RAPL mask, nothing to do */
> +	if (!cpumask_test_and_clear_cpu(cpu, &rapl_cpu_mask))
> +		goto skip;
> +
> +	/* find a new cpu on same package */
> +	for_each_online_cpu(i) {
> +		if (i == cpu || i == 0)
> +			continue;
> +		if (phys_id == topology_physical_package_id(i)) {
> +			cpumask_set_cpu(i, &rapl_cpu_mask);
> +			break;
> +		}
> +	}
> +
> +	WARN_ON(cpumask_empty(&rapl_cpu_mask));
> +skip:
> +	spin_unlock(&rapl_hotplug_lock);
> +}

> +static int rapl_cpu_notifier(struct notifier_block *self,
> +			     unsigned long action, void *hcpu)
> +{

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

All other uncore drivers call perf_pmu_migrate_context() when the CPU
the events are registered on goes away.. ?
