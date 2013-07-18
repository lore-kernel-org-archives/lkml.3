Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab3GRLqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:46:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60410 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3GRLqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:46:16 -0400
Date: Thu, 18 Jul 2013 13:46:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
Message-ID: <20130718114604.GN27075@twins.programming.kicks-ass.net>
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com>
 <20130718082324.GA27075@twins.programming.kicks-ass.net>
 <51E7A6F3.10109@intel.com>
 <20130718090248.GF27075@twins.programming.kicks-ass.net>
 <51E7C7E6.4020200@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E7C7E6.4020200@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 06:48:06PM +0800, Yan, Zheng wrote:
> ---
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 8249df4..aa0d876 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -140,7 +140,6 @@ struct x86_pmu_capability {
>  /* CPU_CLK_Unhalted.Ref: */
>  #define MSR_ARCH_PERFMON_FIXED_CTR2	0x30b
>  #define INTEL_PMC_IDX_FIXED_REF_CYCLES	(INTEL_PMC_IDX_FIXED + 2)
> -#define INTEL_PMC_MSK_FIXED_REF_CYCLES	(1ULL << INTEL_PMC_IDX_FIXED_REF_CYCLES)
>  
>  /*
>   * We model BTS tracing as another fixed-mode PMC.
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index e4bb30a..47ffb48 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -169,7 +169,6 @@ static struct event_constraint intel_slm_event_constraints[] __read_mostly =
>  	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
>  	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
>  	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
> -	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
>  	EVENT_CONSTRAINT_END
>  };

Stephane, should we preserve the 0x0300 event as alias in this case? If
so the below gets a little more complicated.

>  
> @@ -2331,6 +2330,9 @@ __init int intel_pmu_init(void)
>  
>  		intel_pmu_lbr_init_atom();
>  
> +		/* both event 0x013c and fixed counter2 count REF_CYCLES */
> +		intel_perfmon_event_map[PERF_COUNT_HW_REF_CPU_CYCLES] = 0x013c;
> +
>  		x86_pmu.event_constraints = intel_slm_event_constraints;
>  		x86_pmu.pebs_constraints = intel_slm_pebs_event_constraints;
>  		x86_pmu.extra_regs = intel_slm_extra_regs;
> @@ -2486,12 +2488,12 @@ __init int intel_pmu_init(void)
>  
>  	if (x86_pmu.event_constraints) {
>  		/*
> -		 * event on fixed counter2 (REF_CYCLES) only works on this
> -		 * counter, so do not extend mask to generic counters
> +		 * If only fixed counter2 can count event REF_CYCLES, we use
> +		 * pseudo-code 0x0300 for REF_CYCLES.
>  		 */
>  		for_each_event_constraint(c, x86_pmu.event_constraints) {
> -			if (c->cmask != FIXED_EVENT_FLAGS
> -			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
> +			if (c->cmask != FIXED_EVENT_FLAGS ||
> +			    c->code == 0x0300) {
>  				continue;
>  			}

Yeah, this looks basically OK, but now that I look at it we should
probably have a symbolic name for the fake events. ISTR us having more,
by virtue of this being umask=3 not 1. But I can't find them.

Stephane?


