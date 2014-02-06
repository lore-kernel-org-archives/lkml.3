Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaBFUa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:30:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:21882 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbaBFUaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:30:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,795,1384329600"; 
   d="scan'208";a="471014453"
Date: Thu, 6 Feb 2014 12:29:59 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 07/11] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20140206202959.GA12219@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-8-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391683834-29868-8-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 0fa4f24..28b5023 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1312,6 +1312,8 @@ int intel_pmu_save_and_restart(struct perf_event *event)
>  	return x86_perf_event_set_period(event);
>  }
>  
> +void intel_pt_interrupt(void);

Should be in $(pwd)/perf_event.h

> diff --git a/arch/x86/kernel/cpu/perf_event_intel_pt.c b/arch/x86/kernel/cpu/perf_event_intel_pt.c
> new file mode 100644
> index 0000000..b6b1a84
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/perf_event_intel_pt.c
> @@ -0,0 +1,991 @@
> +/*
> + * Intel(R) Processor Trace PMU driver for perf
> + * Copyright (c) 2013-2014, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.

Remove the address, and add a pointer to the specification

Similar in the other files.

> +/*
> + * Capabilities of Intel PT hardware, such as number of address bits or
> + * supported output schemes, are cached and exported to userspace as "caps"
> + * attribute group of pt pmu device
> + * (/sys/bus/event_source/devices/intel_pt/caps/) so that userspace can store
> + * relevant bits together with intel_pt traces.
> + *
> + * Currently, for debugging purposes, these attributes are also writable; this
> + * should be removed in the final version.

Already remove that code?

> +{
> +	u64 reg;
> +
> +	reg = RTIT_CTL_TOPA | RTIT_CTL_BRANCH_EN;
> +
> +	if (!event->attr.exclude_kernel)
> +		reg |= RTIT_CTL_OS;
> +	if (!event->attr.exclude_user)
> +		reg |= RTIT_CTL_USR;
> +
> +	reg |= (event->attr.itrace_config & PT_CONFIG_MASK);
> +
> +	if (wrmsr_safe(MSR_IA32_RTIT_CTL, reg, 0) < 0) {
> +		pr_warn("Failed to enable PT on cpu %d\n", event->cpu);

Should rate limit this warning

> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static void pt_config_start(bool start)
> +{
> +	u64 ctl;
> +
> +	rdmsrl(MSR_IA32_RTIT_CTL, ctl);

Should bail out here if someone else already started (e.g. hardware debugger)
The read needs to be moved to before we overwrite other MSRs

> +	if (start)
> +		ctl |= RTIT_CTL_TRACEEN;
> +	else
> +		ctl &= ~RTIT_CTL_TRACEEN;
> +	wrmsrl(MSR_IA32_RTIT_CTL, ctl);


> +
> +/**
> + * pt_handle_status - take care of possible status conditions
> + * @event: currently active PT event
> + */
> +static void pt_handle_status(struct perf_event *event)
> +{
> +	struct pt_buffer *buf = itrace_priv(event);
> +	int advance = 0;
> +	u64 status;
> +
> +	rdmsrl(MSR_IA32_RTIT_STATUS, status);
> +
> +	if (status & RTIT_STATUS_ERROR) {
> +		pr_err("ToPA ERROR encountered, trying to recover\n");

Add perf: prefix here (or better redefine pr_fmt at the beginning) 
Should be rate limited

> +static struct pt_buffer *pt_buffer_alloc(int cpu, size_t size,
> +					 unsigned long watermark,
> +					 bool snapshot, gfp_t gfp,
> +					 void **pages)
> +{
> +	struct pt_buffer *buf;
> +	int node;
> +	int ret;
> +
> +	if (!size || watermark << PAGE_SHIFT > size)
> +		return NULL;
> +
> +	if (cpu == -1)
> +		cpu = raw_smp_processor_id();
> +	node = cpu_to_node(cpu);
> +
> +	buf = kzalloc(sizeof(struct pt_buffer), gfp);
> +	if (!buf)
> +		return NULL;

Should be kzalloc_node() 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
