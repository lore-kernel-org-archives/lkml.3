Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaKQLUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:20:44 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59169 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaKQLUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:20:43 -0500
Date: Mon, 17 Nov 2014 11:20:35 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] arm: perf: parse cpu affinity from dt
Message-ID: <20141117112033.GF18061@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
 <1415377536-12841-10-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415377536-12841-10-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 04:25:34PM +0000, Mark Rutland wrote:
> The current way we read interrupts form devicetree assumes that
> interrupts are in increasing order of logical cpu id (MPIDR.Aff{2,1,0}),
> and that these logical ids are in a contiguous block. This may not be
> the case in general - after a kexec cpu ids may be arbitrarily assigned,
> and multi-cluster systems do not have a contiguous range of cpu ids.
> 
> This patch parses cpu affinity information for interrupts from an
> optional "interrupts-affinity" devicetree property described in the
> devicetree binding document. Support for existing dts and board files
> remains.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> ---
>  arch/arm/include/asm/pmu.h       |  12 +++
>  arch/arm/kernel/perf_event_cpu.c | 196 +++++++++++++++++++++++++++++----------
>  2 files changed, 161 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
> index b630a44..92fc1da 100644
> --- a/arch/arm/include/asm/pmu.h
> +++ b/arch/arm/include/asm/pmu.h
> @@ -12,6 +12,7 @@
>  #ifndef __ARM_PMU_H__
>  #define __ARM_PMU_H__
>  
> +#include <linux/cpumask.h>
>  #include <linux/interrupt.h>
>  #include <linux/perf_event.h>
>  
> @@ -89,6 +90,15 @@ struct pmu_hw_events {
>  	struct arm_pmu		*percpu_pmu;
>  };
>  
> +/*
> + * For systems with heterogeneous PMUs, we need to know which CPUs each
> + * (possibly percpu) IRQ targets. Map between them with an array of these.
> + */
> +struct cpu_irq {
> +	cpumask_t cpus;
> +	int irq;
> +};
> +
>  struct arm_pmu {
>  	struct pmu	pmu;
>  	cpumask_t	active_irqs;
> @@ -118,6 +128,8 @@ struct arm_pmu {
>  	struct platform_device	*plat_device;
>  	struct pmu_hw_events	__percpu *hw_events;
>  	struct notifier_block	hotplug_nb;
> +	int		nr_irqs;
> +	struct cpu_irq *irq_map;
>  };
>  
>  #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> index dfcaba5..f09c8a0 100644
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@ -85,20 +85,27 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
>  	struct platform_device *pmu_device = cpu_pmu->plat_device;
>  	struct pmu_hw_events __percpu *hw_events = cpu_pmu->hw_events;
>  
> -	irqs = min(pmu_device->num_resources, num_possible_cpus());
> +	irqs = cpu_pmu->nr_irqs;
>  
> -	irq = platform_get_irq(pmu_device, 0);
> -	if (irq >= 0 && irq_is_percpu(irq)) {
> -		on_each_cpu(cpu_pmu_disable_percpu_irq, &irq, 1);
> -		free_percpu_irq(irq, &hw_events->percpu_pmu);
> -	} else {
> -		for (i = 0; i < irqs; ++i) {
> -			if (!cpumask_test_and_clear_cpu(i, &cpu_pmu->active_irqs))
> -				continue;
> -			irq = platform_get_irq(pmu_device, i);
> -			if (irq >= 0)
> -				free_irq(irq, per_cpu_ptr(&hw_events->percpu_pmu, i));
> +	for (i = 0; i < irqs; i++) {
> +		struct cpu_irq *map = &cpu_pmu->irq_map[i];
> +		irq = map->irq;
> +
> +		if (irq <= 0)
> +			continue;
> +
> +		if (irq_is_percpu(irq)) {
> +			on_each_cpu(cpu_pmu_disable_percpu_irq, &irq, 1);

Hmm, ok, so we're assuming that all the PMUs will be wired with PPIs in this
case. I have a patch allowing per-cpu interrupts to be requested for a
cpumask, but I suppose that can wait until it's actually needed.

Will
