Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaDONFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:05:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50935 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaDONFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:05:44 -0400
Message-ID: <534D2EB7.6020904@arm.com>
Date: Tue, 15 Apr 2014 14:05:59 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: perf: save/restore pmu registers in pm notifier
References: <1397439742-28337-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1397439742-28337-1-git-send-email-zhangwm@marvell.com>
X-OriginalArrivalTime: 15 Apr 2014 13:05:57.0215 (UTC) FILETIME=[70CCB6F0:01CF58AB]
X-MC-Unique: 114041514054214901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

Thanks for the response.

Hi Neil,

On 14/04/14 02:42, Neil Zhang wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> This adds core support for saving and restoring CPU PMU registers
> for suspend/resume support i.e. deeper C-states in cpuidle terms.
> This patch adds support only to ARMv7 PMU registers save/restore.
> It needs to be extended to xscale and ARMv6 if needed.
> 
> [Neil] We found that DS-5 not work on our CA7 based SoCs.
> After debuging, found PMU registers were lost because of core power down.
> Then i found Sudeep had a patch to fix it about two years ago but not in
> the mainline, just port it.
> 

The patch was written as PoC to support multiple PMUs back then and was clearly
not intended for upstream. Will has already mentioned what this patch needs to
improve on.

I have mentioned few comments which IMO is necessary.

> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  arch/arm/include/asm/pmu.h       |   11 +++++++++
>  arch/arm/kernel/perf_event_cpu.c |   29 ++++++++++++++++++++++-
>  arch/arm/kernel/perf_event_v7.c  |   47 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 86 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
> index ae1919b..f37f048 100644
> --- a/arch/arm/include/asm/pmu.h
> +++ b/arch/arm/include/asm/pmu.h
> @@ -62,6 +62,15 @@ struct pmu_hw_events {
>  	raw_spinlock_t		pmu_lock;
>  };
>  
> +struct cpupmu_regs {
> +	u32 pmc;
> +	u32 pmcntenset;
> +	u32 pmuseren;
> +	u32 pmintenset;
> +	u32 pmxevttype[8];
> +	u32 pmxevtcnt[8];
> +};
> +

This can't be generic, it needs to be specific to each PMU implementations.
I have clearly mentioned it in the commit log. It's better to move this out
to each PMU specific implementations.

>  struct arm_pmu {
>  	struct pmu	pmu;
>  	cpumask_t	active_irqs;
> @@ -83,6 +92,8 @@ struct arm_pmu {
>  	int		(*request_irq)(struct arm_pmu *, irq_handler_t handler);
>  	void		(*free_irq)(struct arm_pmu *);
>  	int		(*map_event)(struct perf_event *event);
> +	void		(*save_regs)(struct arm_pmu *, struct cpupmu_regs *);
> +	void		(*restore_regs)(struct arm_pmu *, struct cpupmu_regs *);

Once cpupmu_regs becomes PMU specific, you can remove it from the above 2
function pointers.

>  	int		num_events;
>  	atomic_t	active_events;
>  	struct mutex	reserve_mutex;
> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> index 51798d7..7f1c756 100644
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
> @@ -39,6 +40,7 @@ static DEFINE_PER_CPU(struct arm_pmu *, percpu_pmu);
>  static DEFINE_PER_CPU(struct perf_event * [ARMPMU_MAX_HWEVENTS], hw_events);
>  static DEFINE_PER_CPU(unsigned long [BITS_TO_LONGS(ARMPMU_MAX_HWEVENTS)], used_mask);
>  static DEFINE_PER_CPU(struct pmu_hw_events, cpu_hw_events);
> +static DEFINE_PER_CPU(struct cpupmu_regs, cpu_pmu_regs);
>  
>  /*
>   * Despite the names, these two functions are CPU-specific and are used
> @@ -217,6 +219,23 @@ static struct notifier_block cpu_pmu_hotplug_notifier = {
>  	.notifier_call = cpu_pmu_notify,
>  };
>  
> +static int cpu_pmu_pm_notify(struct notifier_block *b,
> +					unsigned long action, void *hcpu)

hcpu is misleading, the cpu_pm_notify doesn't pass the logical cpu index.
IIRC its NULL, rename it.

> +{
> +	struct cpupmu_regs *pmuregs = this_cpu_ptr(&cpu_pmu_regs);
> +
> +	if (action == CPU_PM_ENTER && cpu_pmu->save_regs)
> +		cpu_pmu->save_regs(cpu_pmu, pmuregs);
> +	else if (action == CPU_PM_EXIT && cpu_pmu->restore_regs)
> +		cpu_pmu->restore_regs(cpu_pmu, pmuregs);
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block cpu_pmu_pm_notifier = {
> +	.notifier_call = cpu_pmu_pm_notify,
> +};
> +
>  /*
>   * PMU platform driver and devicetree bindings.
>   */
> @@ -349,9 +368,17 @@ static int __init register_pmu_driver(void)
>  	if (err)
>  		return err;
>  
> +	err = cpu_pm_register_notifier(&cpu_pmu_pm_notifier);
> +	if (err) {
> +		unregister_cpu_notifier(&cpu_pmu_hotplug_notifier);
> +		return err;
> +	}
> +
>  	err = platform_driver_register(&cpu_pmu_driver);
> -	if (err)
> +	if (err) {
> +		cpu_pm_unregister_notifier(&cpu_pmu_pm_notifier);
>  		unregister_cpu_notifier(&cpu_pmu_hotplug_notifier);
> +	}
>  
>  	return err;
>  }
> diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
> index f4ef398..29ae8f1 100644
> --- a/arch/arm/kernel/perf_event_v7.c
> +++ b/arch/arm/kernel/perf_event_v7.c
> @@ -1237,6 +1237,51 @@ static void armv7_pmnc_dump_regs(struct arm_pmu *cpu_pmu)
>  }
>  #endif
>  
> +static void armv7pmu_save_regs(struct arm_pmu *cpu_pmu,
> +					struct cpupmu_regs *regs)
> +{
> +	unsigned int cnt;
> +	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (regs->pmc));
> +	if (!(regs->pmc & ARMV7_PMNC_E))
> +		return;
> +
> +	asm volatile("mrc p15, 0, %0, c9, c12, 1" : "=r" (regs->pmcntenset));
> +	asm volatile("mrc p15, 0, %0, c9, c14, 0" : "=r" (regs->pmuseren));
> +	asm volatile("mrc p15, 0, %0, c9, c14, 1" : "=r" (regs->pmintenset));
> +	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (regs->pmxevtcnt[0]));
> +	for (cnt = ARMV7_IDX_COUNTER0;
> +			cnt <= ARMV7_IDX_COUNTER_LAST(cpu_pmu); cnt++) {

As Will suggested better to use used_mask to save/restore only active events.

Regards,
Sudeep

