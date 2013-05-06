Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3EFJm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:42:59 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42707 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3EFJm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:42:58 -0400
Date: Mon, 6 May 2013 11:42:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, a.p.zijlstra@chello.nl, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf/x86/intel/lbr: Demand proper privileges
 for PERF_SAMPLE_BRANCH_KERNEL
Message-ID: <20130506094254.GB9464@gmail.com>
References: <20130503121256.230745028@chello.nl>
 <tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org>
 <20130504111907.GA3411@pd.tnic>
 <20130506080737.GA13410@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506080737.GA13410@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > > @@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
> > >  	if (br_type & PERF_SAMPLE_BRANCH_USER)
> > >  		mask |= X86_BR_USER;
> > >  
> > > -	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
> > > +	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
> > > +		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> > > +			return -EACCES;
> > 
> > It is probably not too late to amend this patch and remove the "-EACCES":
> > 
> > arch/x86/kernel/cpu/perf_event_intel_lbr.c: In function ???intel_pmu_setup_sw_lbr_filter???:
> > arch/x86/kernel/cpu/perf_event_intel_lbr.c:323:4: warning: ???return??? with a value, in function returning void [enabled by default]
> 
> Oh urgh, looks like I forgot a refresh before posting..
> 
> This one actually compiles a defconfig bzImage.
> 
> ---
> Subject: perf, x86, lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri May 03 14:07:49 CEST 2013
> 
> We should always have proper privileges when requesting kernel data.
> 
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: eranian@google.com
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-deb8yrh5fq2bijn5tlmezkmd@git.kernel.org
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -310,7 +310,7 @@ void intel_pmu_lbr_read(void)
>   * - in case there is no HW filter
>   * - in case the HW filter has errata or limitations
>   */
> -static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
> +static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
>  {
>  	u64 br_type = event->attr.branch_sample_type;
>  	int mask = 0;
> @@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filte
>  	if (br_type & PERF_SAMPLE_BRANCH_USER)
>  		mask |= X86_BR_USER;
>  
> -	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
> +	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
> +		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> +			return -EACCES;
>  		mask |= X86_BR_KERNEL;
> +	}
>  
>  	/* we ignore BRANCH_HV here */
>  
> @@ -339,6 +342,8 @@ static void intel_pmu_setup_sw_lbr_filte
>  	 * be used by fixup code for some CPU
>  	 */
>  	event->hw.branch_reg.reg = mask;
> +
> +	return 0;
>  }
>  
>  /*
> @@ -375,7 +380,7 @@ static int intel_pmu_setup_hw_lbr_filter
>  
>  int intel_pmu_setup_lbr_filter(struct perf_event *event)
>  {
> -	int ret = 0;
> +	int ret;
>  
>  	/*
>  	 * no LBR on this PMU
> @@ -386,7 +391,9 @@ int intel_pmu_setup_lbr_filter(struct pe
>  	/*
>  	 * setup SW LBR filter
>  	 */
> -	intel_pmu_setup_sw_lbr_filter(event);
> +	ret = intel_pmu_setup_sw_lbr_filter(event);
> +	if (ret)
> +		return ret;
>  
>  	/*
>  	 * setup HW LBR filter, if any

That looks pretty close to what I did as well.

Thanks,

	Ingo
