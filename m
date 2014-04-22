Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaDVLfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:35:54 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34825 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbaDVLfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:35:51 -0400
Date: Tue, 22 Apr 2014 13:35:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140422113545.GA14950@gmail.com>
References: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com>
 <20140418105354.GA29167@gmail.com>
 <53548008.3040504@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53548008.3040504@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yan, Zheng <zheng.z.yan@intel.com> wrote:

> On 04/18/2014 06:53 PM, Ingo Molnar wrote:
> > 
> > * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> > 
> >> This patch adds support for building Intel uncore driver as module.
> >> It adds clean-up code and config option for the Intel uncore driver
> >>
> >> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> >> ---
> >> Changes since v1:
> >>  move config option to "General setup/Kernel Performance Events and Counters"
> >>
> >>  arch/x86/kernel/cpu/Makefile                  |  3 +-
> >>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 48 ++++++++++++++++++++++++---
> >>  init/Kconfig                                  | 10 ++++++
> >>  3 files changed, 56 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> >> index 7fd54f0..5d3da70 100644
> >> --- a/arch/x86/kernel/cpu/Makefile
> >> +++ b/arch/x86/kernel/cpu/Makefile
> >> @@ -36,7 +36,8 @@ obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd_iommu.o
> >>  endif
> >>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
> >>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
> >> -obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_rapl.o
> >> +obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o
> >> +obj-$(CONFIG_PERF_X86_INTEL_UNCORE)	+= perf_event_intel_uncore.o
> >>  endif
> >>  
> >>  
> >> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> >> index 618d502..fd5e883 100644
> >> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> >> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > 
> > So I'm not willing to apply this patch until the documentation of 
> > perf_event_intel_uncore.c is improved. Right now the file starts 
> > without a single comment (!). Just lines after lines of code, without 
> > any explanation what it does, what its scope is, etc.
> 
> there are comments mark the scope of code for different CPU.
> 
> > 
> > How should even a knowledgable user know about what it's all about?
> > 
> > That problem percolates to the Kconfig entry as well:
> > 
> 
> Most of the codes without comments are hardware specific codes. The 
> corresponding contents in Intel uncore documents are big 
> tables/lists, nothing tricky/interesting. I really don't know how to 
> comment these code.

Have a look at other PMU drivers, such as 
arch/x86/kernel/cpu/perf_event_intel_rapl.c, which begin with a 
general explanation attached below.

Thanks,

	Ingo


/*
 * perf_event_intel_rapl.c: support Intel RAPL energy consumption counters
 * Copyright (C) 2013 Google, Inc., Stephane Eranian
 *
 * Intel RAPL interface is specified in the IA-32 Manual Vol3b
 * section 14.7.1 (September 2013)
 *
 * RAPL provides more controls than just reporting energy consumption
 * however here we only expose the 3 energy consumption free running
 * counters (pp0, pkg, dram).
 *
 * Each of those counters increments in a power unit defined by the
 * RAPL_POWER_UNIT MSR. On SandyBridge, this unit is 1/(2^16) Joules
 * but it can vary.
 *
 * Counter to rapl events mappings:
 *
 *  pp0 counter: consumption of all physical cores (power plane 0)
 * 	  event: rapl_energy_cores
 *    perf code: 0x1
 *
 *  pkg counter: consumption of the whole processor package
 *	  event: rapl_energy_pkg
 *    perf code: 0x2
 *
 * dram counter: consumption of the dram domain (servers only)
 *	  event: rapl_energy_dram
 *    perf code: 0x3
 *
 * dram counter: consumption of the builtin-gpu domain (client only)
 *	  event: rapl_energy_gpu
 *    perf code: 0x4
 *
 * We manage those counters as free running (read-only). They may be
 * use simultaneously by other tools, such as turbostat.
 *
 * The events only support system-wide mode counting. There is no
 * sampling support because it does not make sense and is not
 * supported by the RAPL hardware.
 *
 * Because we want to avoid floating-point operations in the kernel,
 * the events are all reported in fixed point arithmetic (32.32).
 * Tools must adjust the counts to convert them to Watts using
 * the duration of the measurement. Tools may use a function such as
 * ldexp(raw_count, -32);
 */
