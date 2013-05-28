Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab3E1MSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:18:55 -0400
Received: from 8bytes.org ([85.214.48.195]:58993 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933730Ab3E1MSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:18:54 -0400
Date: Tue, 28 May 2013 14:18:50 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@redhat.com,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH 2/2 V3] perf/x86/amd: AMD IOMMU PC PERF uncore PMU
 implementation
Message-ID: <20130528121850.GC2575@8bytes.org>
References: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1368819813-6481-3-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368819813-6481-3-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 28 14:18:51 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51a4a0ab20861693417632
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 02:43:32PM -0500, Suthikulpanit, Suravee wrote:
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index b0684e4..fcbd3b8 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -30,7 +30,7 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
>  obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
>  
>  ifdef CONFIG_PERF_EVENTS
> -obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o perf_event_amd_uncore.o
> +obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o perf_event_amd_uncore.o perf_event_amd_iommu.o

This should also depend on CONFIG_AMD_IOMMU. If no IOMMU driver is
compiled in it doesn't make sense to have that PMU.

> +static int perf_iommu_event_init(struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc = &event->hw;
> +	struct perf_amd_iommu *perf_iommu;
> +	u64 config, config1;
> +
> +	/* test the event attr type check for PMU enumeration */
> +	if (event->attr.type != event->pmu->type)
> +		return -ENOENT;
> +
> +	/*
> +	 * IOMMU counters are shared across all cores.
> +	 * Therefore, it does not support per-process mode.
> +	 * Also, it does not support event sampling mode.
> +	 */
> +	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
> +		return -EINVAL;
> +
> +	/* IOMMU counters do not have usr/os/guest/host bits */
> +	if (event->attr.exclude_user || event->attr.exclude_kernel ||
> +	    event->attr.exclude_host || event->attr.exclude_guest)
> +		return -EINVAL;
> +
> +	if (event->cpu < 0)
> +		return -EINVAL;
> +
> +	perf_iommu = &__perf_iommu;
> +
> +	if (event->pmu != &perf_iommu->pmu)
> +		return -ENOENT;
> +
> +	if (perf_iommu) {
> +		config = event->attr.config;
> +		config1 = event->attr.config1;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	/* integrate with iommu base devid (0000), assume one iommu */
> +	perf_iommu->max_banks =
> +		amd_iommu_pc_get_max_banks(IOMMU_BASE_DEVID);
> +	perf_iommu->max_counters =
> +		amd_iommu_pc_get_max_counters(IOMMU_BASE_DEVID);
> +
> +	/* update the hw_perf_event struct with the iommu config data */
> +	hwc->config = config;
> +	hwc->extra_reg.config = config1;
> +
> +	return 0;
> +}

That implementation is very basic. Any reason for not using the event
reporting mechanism of the IOMMU? You could implement a nice perf
iommutop or something to see which devices do the most transactions or
something like that.


	Joerg


