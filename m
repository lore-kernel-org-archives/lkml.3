Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbaDVKhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:37:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39298 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937AbaDVKhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:37:14 -0400
Date: Tue, 22 Apr 2014 11:36:42 +0100
From: Will Deacon <will.deacon@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Message-ID: <20140422103642.GF7484@arm.com>
References: <1398133596-29170-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398133596-29170-1-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Tue, Apr 22, 2014 at 03:26:36AM +0100, Neil Zhang wrote:
> This adds core support for saving and restoring CPU PMU registers
> for suspend/resume support i.e. deeper C-states in cpuidle terms.
> This patch adds support only to ARMv7 PMU registers save/restore.
> It needs to be extended to xscale and ARMv6 if needed.
> 
> I made this patch because DS-5 is not working on Marvell's CA7 based SoCs.
> And it has consulted Sudeep KarkadaNagesha's patch set for multiple PMUs.
> 
> Thanks Will and Sudeep's suggestion to only save / restore used events.

Whilst this is a step in the right direction, I'd still like to see the
save/restore predicated on something in the device-tree or otherwise. Most
SoCs *don't* require these registers to be preserved by software, so we need
a way to describe that the PMU is in a power-domain where its state is lost
when the CPU goes idle.

This doesn't sound like a PMU-specific problem, so there's a possibility
that this has been discussed elsewhere, in the context of other IP blocks

[adding the devicetree list in case somebody there is aware of any work in
 this area]

Will

> diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
> index ae1919b..3de3db7 100644
> --- a/arch/arm/include/asm/pmu.h
> +++ b/arch/arm/include/asm/pmu.h
> @@ -83,6 +83,10 @@ struct arm_pmu {
>  	int		(*request_irq)(struct arm_pmu *, irq_handler_t handler);
>  	void		(*free_irq)(struct arm_pmu *);
>  	int		(*map_event)(struct perf_event *event);
> +	int		(*register_pm_notifier)(struct arm_pmu *);
> +	void		(*unregister_pm_notifier)(struct arm_pmu *);
> +	void		(*save_regs)(struct arm_pmu *);
> +	void		(*restore_regs)(struct arm_pmu *);
>  	int		num_events;
>  	atomic_t	active_events;
>  	struct mutex	reserve_mutex;
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index a6bc431..08822de 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -326,6 +326,7 @@ static void
>  armpmu_release_hardware(struct arm_pmu *armpmu)
>  {
>  	armpmu->free_irq(armpmu);
> +	armpmu->unregister_pm_notifier(armpmu);
>  	pm_runtime_put_sync(&armpmu->plat_device->dev);
>  }
>  
> @@ -339,6 +340,7 @@ armpmu_reserve_hardware(struct arm_pmu *armpmu)
>  		return -ENODEV;
>  
>  	pm_runtime_get_sync(&pmu_device->dev);
> +	armpmu->register_pm_notifier(armpmu);
>  	err = armpmu->request_irq(armpmu, armpmu_dispatch_irq);
>  	if (err) {
>  		armpmu_release_hardware(armpmu);
> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> index 51798d7..79e1c06 100644
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@ -19,6 +19,7 @@
>  #define pr_fmt(fmt) "CPU PMU: " fmt
>  
>  #include <linux/bitmap.h>
> +#include <linux/cpu_pm.h>
>  #include <linux/export.h>
>  #include <linux/kernel.h>
>  #include <linux/of.h>
> @@ -173,6 +174,31 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
>  	return 0;
>  }
>  
> +static int cpu_pmu_pm_notify(struct notifier_block *b,
> +					unsigned long action, void *v)
> +{
> +	if (action == CPU_PM_ENTER && cpu_pmu->save_regs)
> +		cpu_pmu->save_regs(cpu_pmu);
> +	else if (action == CPU_PM_EXIT && cpu_pmu->restore_regs)
> +		cpu_pmu->restore_regs(cpu_pmu);
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block cpu_pmu_pm_notifier = {
> +	.notifier_call = cpu_pmu_pm_notify,
> +};
> +
> +static int cpu_pmu_register_pm_notifier(struct arm_pmu *cpu_pmu)
> +{
> +	return cpu_pm_register_notifier(&cpu_pmu_pm_notifier);
> +}
> +
> +static void cpu_pmu_unregister_pm_notifier(struct arm_pmu *cpu_pmu)
> +{
> +	cpu_pm_unregister_notifier(&cpu_pmu_pm_notifier);
> +}
> +
>  static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
>  {
>  	int cpu;
> @@ -187,6 +213,8 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
>  	cpu_pmu->get_hw_events	= cpu_pmu_get_cpu_events;
>  	cpu_pmu->request_irq	= cpu_pmu_request_irq;
>  	cpu_pmu->free_irq	= cpu_pmu_free_irq;
> +	cpu_pmu->register_pm_notifier	= cpu_pmu_register_pm_notifier;
> +	cpu_pmu->unregister_pm_notifier	= cpu_pmu_unregister_pm_notifier;
>  
>  	/* Ensure the PMU has sane values out of reset. */
>  	if (cpu_pmu->reset)
> diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
> index f4ef398..9069310 100644
> --- a/arch/arm/kernel/perf_event_v7.c
> +++ b/arch/arm/kernel/perf_event_v7.c
> @@ -1237,6 +1237,78 @@ static void armv7_pmnc_dump_regs(struct arm_pmu *cpu_pmu)
>  }
>  #endif
>  
> +struct armv7_pmuregs {
> +	u32 pmc;
> +	u32 pmcntenset;
> +	u32 pmintenset;
> +	u32 pmxevttype[8];
> +	u32 pmxevtcnt[8];
> +};
> +
> +static DEFINE_PER_CPU(struct armv7_pmuregs, pmu_regs);
> +
> +static void armv7pmu_reset(void *info);
> +
> +static void armv7pmu_save_regs(struct arm_pmu *cpu_pmu)
> +{
> +	struct pmu_hw_events *events = cpu_pmu->get_hw_events();
> +	struct armv7_pmuregs *regs;
> +	int bit;
> +
> +	/* Check whether there are events used */
> +	bit = find_first_bit(events->used_mask, cpu_pmu->num_events);
> +	if (bit >= cpu_pmu->num_events)
> +		return;
> +
> +	regs = this_cpu_ptr(&pmu_regs);
> +	for_each_set_bit(bit, events->used_mask, cpu_pmu->num_events) {
> +		if (bit) {
> +			armv7_pmnc_select_counter(bit);
> +			asm volatile("mrc p15, 0, %0, c9, c13, 1"
> +					: "=r"(regs->pmxevttype[bit]));
> +			asm volatile("mrc p15, 0, %0, c9, c13, 2"
> +					: "=r"(regs->pmxevtcnt[bit]));
> +		} else
> +			asm volatile("mrc p15, 0, %0, c9, c13, 0"
> +					: "=r" (regs->pmxevtcnt[0]));
> +	}
> +
> +	asm volatile("mrc p15, 0, %0, c9, c12, 1" : "=r" (regs->pmcntenset));
> +	asm volatile("mrc p15, 0, %0, c9, c14, 1" : "=r" (regs->pmintenset));
> +	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (regs->pmc));
> +}
> +
> +static void armv7pmu_restore_regs(struct arm_pmu *cpu_pmu)
> +{
> +	struct pmu_hw_events *events = cpu_pmu->get_hw_events();
> +	struct armv7_pmuregs *regs;
> +	int bit;
> +
> +	/* Check whether there are events used */
> +	bit = find_first_bit(events->used_mask, cpu_pmu->num_events);
> +	if (bit >= cpu_pmu->num_events)
> +		return;
> +
> +	armv7pmu_reset(cpu_pmu);
> +
> +	regs = this_cpu_ptr(&pmu_regs);
> +	for_each_set_bit(bit, events->used_mask, cpu_pmu->num_events) {
> +		if (bit) {
> +			armv7_pmnc_select_counter(bit);
> +			asm volatile("mcr p15, 0, %0, c9, c13, 1"
> +					: : "r"(regs->pmxevttype[bit]));
> +			asm volatile("mcr p15, 0, %0, c9, c13, 2"
> +					: : "r"(regs->pmxevtcnt[bit]));
> +		} else
> +			asm volatile("mcr p15, 0, %0, c9, c13, 0"
> +					: : "r" (regs->pmxevtcnt[0]));
> +	}
> +
> +	asm volatile("mcr p15, 0, %0, c9, c12, 1" : : "r" (regs->pmcntenset));
> +	asm volatile("mcr p15, 0, %0, c9, c14, 1" : : "r" (regs->pmintenset));
> +	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (regs->pmc));
> +}
> +
>  static void armv7pmu_enable_event(struct perf_event *event)
>  {
>  	unsigned long flags;
> @@ -1528,6 +1600,8 @@ static void armv7pmu_init(struct arm_pmu *cpu_pmu)
>  	cpu_pmu->start		= armv7pmu_start;
>  	cpu_pmu->stop		= armv7pmu_stop;
>  	cpu_pmu->reset		= armv7pmu_reset;
> +	cpu_pmu->save_regs	= armv7pmu_save_regs;
> +	cpu_pmu->restore_regs	= armv7pmu_restore_regs;
>  	cpu_pmu->max_period	= (1LLU << 32) - 1;
>  };
>  
> -- 
> 1.7.9.5
> 
> 
