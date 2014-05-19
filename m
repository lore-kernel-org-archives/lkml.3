Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaESP6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:58:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40063 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170AbaESP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:58:01 -0400
Date: Mon, 19 May 2014 16:57:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] perf, ARM: use common PMU interrupt disabled code
Message-ID: <20140519155710.GK15130@arm.com>
References: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405161712190.11099@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405161712190.11099@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:15:49PM +0100, Vince Weaver wrote:
> 
> Make the ARM perf code use the new common PMU interrupt disabled code.
> 
> This allows perf to work on ARM machines without a working PMU
> interrupt (for example, raspberry pi).
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index a6bc431..4238bcb 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -410,7 +410,7 @@ __hw_perf_event_init(struct perf_event *event)
>  	 */
>  	hwc->config_base	    |= (unsigned long)mapping;
>  
> -	if (!hwc->sample_period) {
> +	if (!is_sampling_event(event)) {
>  		/*
>  		 * For non-sampling runs, limit the sample_period to half
>  		 * of the counter width. That way, the new counter value
> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> index 51798d7..63d95fa 100644
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@ -126,8 +126,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
>  
>  	irqs = min(pmu_device->num_resources, num_possible_cpus());
>  	if (irqs < 1) {
> -		pr_err("no irqs for PMUs defined\n");
> -		return -ENODEV;
> +		printk_once("no irqs for PMU defined, sampled events not supported\n");

s/sampled/sampling/

> +		return 0;
>  	}
>  
>  	irq = platform_get_irq(pmu_device, 0);
> @@ -191,6 +191,11 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
>  	/* Ensure the PMU has sane values out of reset. */
>  	if (cpu_pmu->reset)
>  		on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
> +
> +	/* If no interrupts available, set the corresponding capability flag */
> +	if (platform_get_irq(cpu_pmu->plat_device, 0) <= 0) {

I think you can just do if (!platform_get_irq(cpu_pmu->plat_device, 0))
here (I appreciate the ARM perf code isn't consistent here).

Anyway, with those minor changes:

  Acked-by: Will Deacon <will.deacon@arm.com>

Thanks,

Will
