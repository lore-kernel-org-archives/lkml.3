Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbbAIOKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:10:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:53066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbbAIOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:10:04 -0500
Date: Fri, 9 Jan 2015 15:09:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org
Subject: Re: [PATCH v8 12/14] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20150109140947.GN3337@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1415972627-37514-13-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415972627-37514-13-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 03:43:45PM +0200, Alexander Shishkin wrote:
> +static __init int pt_init(void)
> +{
> +	int ret, cpu, prior_warn = 0;
> +
> +	BUILD_BUG_ON(sizeof(struct topa) > PAGE_SIZE);
> +	get_online_cpus();
> +	for_each_online_cpu(cpu) {
> +		u64 ctl;
> +
> +		ret = rdmsrl_safe_on_cpu(cpu, MSR_IA32_RTIT_CTL, &ctl);
> +		if (!ret && (ctl & RTIT_CTL_TRACEEN))
> +			prior_warn++;
> +	}
> +	put_online_cpus();
> +
> +	ret = pt_pmu_hw_init();
> +	if (ret)
> +		return ret;
> +
> +	if (!pt_cap_get(PT_CAP_topa_output)) {
> +		pr_warn("ToPA output is not supported on this CPU\n");
> +		return -ENODEV;
> +	}
> +
> +	if (prior_warn)
> +		pr_warn("PT is enabled at boot time, traces may be empty\n");

Should we not also add_exclusive(pt) here?

Also, if its already enabled, should we not return ENODEV as well, no
saying who or what programmed it, we should not be touching it.

> +	if (!pt_cap_get(PT_CAP_topa_multiple_entries))
> +		pt_pmu.pmu.capabilities =
> +			PERF_PMU_CAP_AUX_NO_SG | PERF_PMU_CAP_AUX_SW_DOUBLEBUF;
> +
> +	pt_pmu.pmu.capabilities	|= PERF_PMU_CAP_EXCLUSIVE | PERF_PMU_CAP_ITRACE;
> +	pt_pmu.pmu.attr_groups	= pt_attr_groups;
> +	pt_pmu.pmu.task_ctx_nr	= perf_hw_context;
> +	pt_pmu.pmu.event_init	= pt_event_init;
> +	pt_pmu.pmu.add		= pt_event_add;
> +	pt_pmu.pmu.del		= pt_event_del;
> +	pt_pmu.pmu.start	= pt_event_start;
> +	pt_pmu.pmu.stop		= pt_event_stop;
> +	pt_pmu.pmu.read		= pt_event_read;
> +	pt_pmu.pmu.setup_aux	= pt_buffer_setup_aux;
> +	pt_pmu.pmu.free_aux	= pt_buffer_free_aux;
> +	ret = perf_pmu_register(&pt_pmu.pmu, "intel_pt", -1);
> +
> +	return ret;
> +}
