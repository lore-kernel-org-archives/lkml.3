Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3IQFxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:53:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39872 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3IQFxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:53:10 -0400
Date: Tue, 17 Sep 2013 07:53:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] uncore_pmu_event_init: using smp_processor_id() in
 preemptible core
Message-ID: <20130917055302.GB12926@twins.programming.kicks-ass.net>
References: <20130916092110.GA29018@twins.programming.kicks-ass.net>
 <5237E17A.80603@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5237E17A.80603@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 12:58:34PM +0800, Yan, Zheng wrote:
> ---
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index fd8011e..a12a22f 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -2713,7 +2713,10 @@ struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cp
>  
>  	size = sizeof(*box) + type->num_shared_regs * sizeof(struct intel_uncore_extra_reg);
>  
> -	box = kzalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
> +	if (cpu < 0)
> +		box = kzalloc(size, GFP_KERNEL);
> +	else
> +		box = kzalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
>  	if (!box)
>  		return NULL;

I believe -1 is a valid node number for all allocators, in which case
they fall back to the current node.

>  
> @@ -3031,7 +3034,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
>  	struct intel_uncore_box *fake_box;
>  	int ret = -EINVAL, n;
>  
> -	fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
> +	fake_box = uncore_alloc_box(pmu->type, -1);
>  	if (!fake_box)
>  		return -ENOMEM;
>  

Yes, much better indeed.
