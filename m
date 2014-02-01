Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbaBAF6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 00:58:49 -0500
Received: from ozlabs.org ([203.10.76.45]:58874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaBAF6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 00:58:08 -0500
In-Reply-To: <1389916434-2288-5-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/8] powerpc: add hv_gpci interface header
Message-Id: <20140201055807.267F12C00BA@ozlabs.org>
Date: Sat,  1 Feb 2014 16:58:07 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-16-01 at 23:53:50 UTC, Cody P Schafer wrote:
> "H_GetPerformanceCounterInfo" (refered to as hv_gpci or just gpci from
> here on) is an interface to retrieve specific performance counters and
> other data from the hypervisor. All outputs have a fixed format (and
> are represented as structs in this patch).

So how much of this are we actually using? A lot of these seem to be only used
in the union at the bottom of this file, and not touched elsewhere - or am I
missing something subtle?

Some of it doesn't seem to be used at all?
 
> diff --git a/arch/powerpc/include/asm/hv_gpci.h b/arch/powerpc/include/asm/hv_gpci.h

Any reason this can't just live in arch/powerpc/perf ?

> +++ b/arch/powerpc/include/asm/hv_gpci.h
> @@ -0,0 +1,490 @@
> +#ifndef LINUX_POWERPC_UAPI_HV_GPCI_H_
> +#define LINUX_POWERPC_UAPI_HV_GPCI_H_
> +
> +#include <linux/types.h>
> +
> +/* From the document "H_GetPerformanceCounterInfo Interface" v1.06, paritialy
> + * updated with v1.07 */

Is that public?

> +
> +/* H_GET_PERF_COUNTER_INFO argument */
> +struct hv_get_perf_counter_info_params {
> +	__be32 counter_request; /* I */
> +	__be32 starting_index;  /* IO */
> +	__be16 secondary_index; /* IO */
> +	__be16 returned_values; /* O */
> +	__be32 detail_rc; /* O, "only for 32bit clients" */
> +
> +	/*
> +	 * O, size each of counter_value element in bytes, only set for version
> +	 * >= 0x3
> +	 */
> +	__be16 cv_element_size;
> +
> +	/* I, funny if version < 0x3 */

Funny how? Or better still, do we only support operating on some minimum
sane version of the API?

> +	__u8 counter_info_version_in;
> +
> +	/* O, funny if version < 0x3 */
> +	__u8 counter_info_version_out;
> +	__u8 reserved[0xC];
> +	__u8 counter_value[];
> +} __packed;
> +
> +/* 8 => power8 (1.07)
> + * 6 => TLBIE  (1.07)
> + * 5 => (1.05)
> + * 4 => ?
> + * 3 => ?
> + * 2 => v7r7m0.phyp (?)
> + * 1 => v7r6m0.phyp (?)
> + * 0 => v7r{2,3,4}m0.phyp (?)
> + */

I think this is a mapping of version numbers to firmware releases, it should
say so.

> +#define COUNTER_INFO_VERSION_CURRENT 0x8
> +
> +/* these determine the counter_value[] layout and the meaning of starting_index
> + * and secondary_index */

Needs: leading capital, full stop, block comment.

> +enum counter_info_requests {
> +
> +	/* GENERAL */
> +
> +	/* @starting_index: "starting" physical processor index or -1 for

Why '"starting"' ?

> +	 *                  current phyical processor. Data is only collected
> +	 *                  for the processors' "primary" thread.
> +	 * @secondary_index: unused

This seems to be true in all cases at least for this enum, can we drop it?

> +	 */
> +	CIR_dispatch_timebase_by_processor = 0x10,

Any reason for the weird capitialisation? You've obviously learnt the
noCamelCase rule, but this is still a bit odd :)

> +
> +	/* @starting_index: starting partition id or -1 for the current logical
> +	 *                  partition (virtual machine).
> +	 * @secondary_index: unused
> +	 */
> +	CIR_entitled_capped_uncapped_donated_idle_timebase_by_partition = 0x20,
> +
> +	/* @starting_index: starting partition id or -1 for the current logical
> +	 *                  partition (virtual machine).
> +	 * @secondary_index: unused
> +	 */
> +	CIR_run_instructions_run_cycles_by_partition = 0x30,
> +
> +	/* @starting_index: must be -1 (to refer to the current partition)
> +	 * @secondary_index: unused
> +	 */
> +	CIR_system_performance_capabilities = 0x40,
> +
> +
> +	/* Data from this should only be considered valid if
> +	 * counter_info_version >= 0x3
> +	 * @starting_index: starting hardware chip id or -1 for the current hw
> +	 *		    chip id
> +	 * @secondary_index: unused
> +	 */
> +	CIR_processor_bus_utilization_abc_links = 0x50,
> +
> +	/* Data from this should only be considered valid if
> +	 * counter_info_version >= 0x3
> +	 * @starting_index: starting hardware chip id or -1 for the current hw
> +	 *		    chip id
> +	 * @secondary_index: unused
> +	 */
> +	CIR_processor_bus_utilization_wxyz_links = 0x60,
> +
> +
> +	/* EXPANDED */

??

These are only available if you have the DLC ?

> +	/* Avaliable if counter_info_version >= 0x3
> +	 * @starting_index: starting hardware chip id or -1 for the current hw
> +	 *		    chip id
> +	 * @secondary_index: unused
> +	 */
> +	CIR_processor_bus_utilization_gx_links = 0x70,
> +
> +	/* Avaliable if counter_info_version >= 0x3
> +	 * @starting_index: starting hardware chip id or -1 for the current hw
> +	 *		    chip id
> +	 * @secondary_index: unused
> +	 */
> +	CIR_processor_bus_utilization_mc_links = 0x80,
> +
> +	/* Avaliable if counter_info_version >= 0x3
> +	 * @starting_index: starting physical processor or -1 for the current
> +	 *                  physical processor
> +	 * @secondary_index: unused
> +	 */
> +	CIR_processor_config = 0x90,
> +
> +	/* Avaliable if counter_info_version >= 0x3
> +	 * @starting_index: starting physical processor or -1 for the current
> +	 *                  physical processor
> +	 * @secondary_index: unused
> +	 */
> +	CIR_current_processor_frequency = 0x91,
> +
> +	CIR_processor_core_utilization = 0x94,
> +
> +	CIR_processor_core_power_mode = 0x95,
> +
> +	CIR_affinity_domain_information_by_virutal_processor = 0xA0,
> +
> +	CIR_affinity_domain_info_by_domain = 0xB0,
> +
> +	CIR_affinity_domain_info_by_partition = 0xB1,
> +
> +	/* @starting_index: unused
> +	 * @secondary_index: unused
> +	 */
> +	CIR_physical_memory_info = 0xC0,
> +
> +	CIR_processor_bus_topology = 0xD0,
> +
> +	CIR_partition_hypervisor_queuing_times = 0xE0,
> +
> +	CIR_system_hypervisor_times = 0xF0,
> +
> +	/* LAB */
> +
> +	CIR_set_mmcrh = 0x80001000,
> +	CIR_get_hpmcx = 0x80002000,
> +};


cheers
