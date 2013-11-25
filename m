Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab3KYSmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:42:46 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64589 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707Ab3KYSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:42:45 -0500
Date: Mon, 25 Nov 2013 18:41:59 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Tuan Phan <tphan@apm.com>
Subject: Re: [PATCH V5 2/2] arm64: perf: add support for percpu pmu interrupt
Message-ID: <20131125184159.GE28201@mudshark.cambridge.arm.com>
References: <1385372753-7396-1-git-send-email-vkale@apm.com>
 <1385372753-7396-3-git-send-email-vkale@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385372753-7396-3-git-send-email-vkale@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 09:45:53AM +0000, Vinayak Kale wrote:
> Add support for irq registration when pmu interrupt is percpu.
> 
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> ---
>  arch/arm64/kernel/perf_event.c |  108 ++++++++++++++++++++++++++++++----------
>  1 file changed, 81 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index cea1594..a2efab3 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -22,6 +22,7 @@
>  
>  #include <linux/bitmap.h>
>  #include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <linux/kernel.h>
>  #include <linux/export.h>
>  #include <linux/perf_event.h>
> @@ -363,22 +364,55 @@ validate_group(struct perf_event *event)
>  }
>  
>  static void
> +armpmu_disable_percpu_irq(void *data)
> +{
> +	struct arm_pmu *armpmu = data;
> +	struct platform_device *pmu_device = armpmu->plat_device;
> +	int irq = platform_get_irq(pmu_device, 0);
> +
> +	cpumask_test_and_clear_cpu(smp_processor_id(), &armpmu->active_irqs);
> +	disable_percpu_irq(irq);
> +}
> +
> +static void
>  armpmu_release_hardware(struct arm_pmu *armpmu)
>  {
>  	int i, irq, irqs;
>  	struct platform_device *pmu_device = armpmu->plat_device;
>  
>  	irqs = min(pmu_device->num_resources, num_possible_cpus());
> +	if (irqs < 1)

Can you just make irqs unsigned, then do if (!irqs) instead?

> +		return;
>  
> -	for (i = 0; i < irqs; ++i) {
> -		if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
> -			continue;
> -		irq = platform_get_irq(pmu_device, i);
> -		if (irq >= 0)
> -			free_irq(irq, armpmu);
> +	irq = platform_get_irq(pmu_device, 0);
> +	if (irq <= 0)
> +		return;
> +
> +	if (irq_is_percpu(irq)) {
> +		on_each_cpu(armpmu_disable_percpu_irq, armpmu, 1);
> +		free_percpu_irq(irq, &cpu_hw_events);
> +	} else {
> +		for (i = 0; i < irqs; ++i) {
> +			if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
> +				continue;
> +			irq = platform_get_irq(pmu_device, i);
> +			if (irq > 0)
> +				free_irq(irq, armpmu);
> +		}
>  	}
>  }
>  
> +static void
> +armpmu_enable_percpu_irq(void *data)
> +{
> +	struct arm_pmu *armpmu = data;
> +	struct platform_device *pmu_device = armpmu->plat_device;
> +	int irq = platform_get_irq(pmu_device, 0);
> +
> +	enable_percpu_irq(irq, 0);

IRQ_TYPE_NONE?

> +	cpumask_set_cpu(smp_processor_id(), &armpmu->active_irqs);
> +}
> +
>  static int
>  armpmu_reserve_hardware(struct arm_pmu *armpmu)
>  {
> @@ -396,34 +430,54 @@ armpmu_reserve_hardware(struct arm_pmu *armpmu)
>  		return -ENODEV;
>  	}
>  
> -	for (i = 0; i < irqs; ++i) {
> -		err = 0;
> -		irq = platform_get_irq(pmu_device, i);
> -		if (irq < 0)
> -			continue;
> +	irq = platform_get_irq(pmu_device, 0);
> +	if (irq <= 0) {
> +		pr_err("failed to get valid irq for PMU device\n");
> +		return -ENODEV;
> +	}
>  
> -		/*
> -		 * If we have a single PMU interrupt that we can't shift,
> -		 * assume that we're running on a uniprocessor machine and
> -		 * continue. Otherwise, continue without this interrupt.
> -		 */
> -		if (irq_set_affinity(irq, cpumask_of(i)) && irqs > 1) {
> -			pr_warning("unable to set irq affinity (irq=%d, cpu=%u)\n",
> -				    irq, i);
> -			continue;
> -		}
> +	if (irq_is_percpu(irq)) {
> +		err = request_percpu_irq(irq, armpmu->handle_irq,
> +				"arm-pmu", &cpu_hw_events);

This is a bit of a kludge passing in the cpu_hw_events as the per-cpu token,
but I guess that will do for now. There is potential for something like a
master-aware L2 PMU which uses PPIs and expects to pass something different
back to the IRQ handler.

Will
