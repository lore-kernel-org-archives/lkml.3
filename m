Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3ENHQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:16:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46402
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab3ENHQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:16:03 -0400
Date: Tue, 14 May 2013 09:14:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: steven.kinney@amd.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 2/2] IOMMU/AMD: IOMMU PC PERF uncore PMU implementation
Message-ID: <20130514071424.GB15942@dyad.programming.kicks-ass.net>
References: <1368481453-5657-1-git-send-email-steven.kinney@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368481453-5657-1-git-send-email-steven.kinney@amd.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 04:44:13PM -0500, steven.kinney@amd.com wrote:
> From: Steven L Kinney <Steven.Kinney@amd.com>
> 
> Implement a perf PMU to handle IOMMU PC perf events.  This PMU will handle
> static counter perf events relative to the AMD IOMMU Performance Counters.
> 
> To invoke the AMD IOMMU PMU issue a perf tool command such as:
> 
> ./perf stat -e amd_iommu/config=<config-data>,config1=<config1-data>/u <command>
> 
> For example:
> 
> ./perf stat -e amd_iommu/config=0x8000000000000005,config1=0/u <command>
> 
> The resulting count will be how many IOMMU total peripheral memory
> operations were performed during the command execution window.
> 
> Signed-off-by: Steven Kinney <steven.kinney@amd.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---

> +PMU_FORMAT_ATTR(iommu_raw, "config:63");

> +static int perf_iommu_init(struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc = &event->hw;
> +	struct perf_iommu *perf_iommu;
> +	u64 config, config1;
> +
> +	/* initialize the cntr_assign_mask */
> +	cntr_assign_mask = 0;
> +
> +	/* test the event attr type check for PMU enumeration */
> +	if (event->attr.type != event->pmu->type)
> +		return -ENOENT;
> +
> +	perf_iommu = &perf_iommu_fetch;
> +
> +	if (perf_iommu) {
> +		config = event->attr.config;
> +		config1 = event->attr.config1;
> +	} else
> +		return -EINVAL;
> +
> +	if (event->pmu != &perf_iommu->pmu)
> +		return -ENOENT;
> +
> +	/* make sure the event->attr.config is raw (vendor specific) */
> +	if (!(config & IOMMU_PC_RAW_CONFIG_MASK))
> +		return -EINVAL;

Is this really needed? Non of the uncore PMU drivers have a magic config bit
either. Seems weird to me.

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

Also it might make sense to add a few event aliases to both this IOMMU and the
AMD uncore driver.

Search for uncore_.*_events in arch/x86/kernel/cpu/perf_event_intel_uncore.c
for examples.

This way you can also make the IOMMU a tad more useful by providing some events
you think are the most useful for people interested in this thing.
