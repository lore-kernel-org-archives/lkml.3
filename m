Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaDVC3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 22:29:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2096 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbaDVC3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 22:29:13 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Neil Zhang <zhangwm@marvell.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Date: Mon, 21 Apr 2014 19:28:37 -0700
Subject: RE: [PATCH v3] ARM: perf: save/restore pmu registers in pm notifier
Thread-Topic: [PATCH v3] ARM: perf: save/restore pmu registers in pm notifier
Thread-Index: Ac9dUhBlZlEzAx/kQ3igkcWsI4ogOAAgFA4g
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE55075F216B@SC-VEXCH4.marvell.com>
References: <1398078522-26027-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1398078522-26027-1-git-send-email-zhangwm@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-22_01:2014-04-21,2014-04-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404220026
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3M2TLPu003376


> -----Original Message-----
> From: Neil Zhang [mailto:zhangwm@marvell.com]
> Sent: 2014Äê4ÔÂ21ÈÕ 19:09
> To: will.deacon@arm.com; linux@arm.linux.org.uk
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Neil
> Zhang; Sudeep KarkadaNagesha
> Subject: [PATCH v3] ARM: perf: save/restore pmu registers in pm notifier
> 
> This adds core support for saving and restoring CPU PMU registers for
> suspend/resume support i.e. deeper C-states in cpuidle terms.
> This patch adds support only to ARMv7 PMU registers save/restore.
> It needs to be extended to xscale and ARMv6 if needed.
> 
> I make this patch because of DS-5 not work on our CA7 based SoCs.
> And it is based on Sudeep KarkadaNagesha's patch set for multiple PMUs.
> 
> Thanks Will and Sudeep's suggestion to only save / restore used events.
> 
> Cc: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  arch/arm/include/asm/pmu.h       |    4 ++
>  arch/arm/kernel/perf_event.c     |    2 +
>  arch/arm/kernel/perf_event_cpu.c |   28 ++++++++++++++
>  arch/arm/kernel/perf_event_v7.c  |   75
> ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 109 insertions(+)
> 
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
>  armpmu_release_hardware(struct arm_pmu *armpmu)  {
>  	armpmu->free_irq(armpmu);
> +	armpmu->unregister_pm_notifier(armpmu);
>  	pm_runtime_put_sync(&armpmu->plat_device->dev);
>  }
> 
> @@ -339,6 +340,7 @@ armpmu_reserve_hardware(struct arm_pmu
> *armpmu)
>  		return -ENODEV;
> 
>  	pm_runtime_get_sync(&pmu_device->dev);
> +	armpmu->register_pm_notifier(armpmu);
>  	err = armpmu->request_irq(armpmu, armpmu_dispatch_irq);
>  	if (err) {
>  		armpmu_release_hardware(armpmu);
> diff --git a/arch/arm/kernel/perf_event_cpu.c
> b/arch/arm/kernel/perf_event_cpu.c
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
> @@ -173,6 +174,31 @@ static int cpu_pmu_request_irq(struct arm_pmu
> *cpu_pmu, irq_handler_t handler)
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
> +static int cpu_pmu_register_pm_notifier(struct arm_pmu *cpu_pmu) {
> +	return cpu_pm_register_notifier(&cpu_pmu_pm_notifier);
> +}
> +
> +static void cpu_pmu_unregister_pm_notifier(struct arm_pmu *cpu_pmu) {
> +	cpu_pm_unregister_notifier(&cpu_pmu_pm_notifier);
> +}
> +
>  static void cpu_pmu_init(struct arm_pmu *cpu_pmu)  {
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
> diff --git a/arch/arm/kernel/perf_event_v7.c
> b/arch/arm/kernel/perf_event_v7.c index f4ef398..8898b4d 100644
> --- a/arch/arm/kernel/perf_event_v7.c
> +++ b/arch/arm/kernel/perf_event_v7.c
> @@ -1237,6 +1237,79 @@ static void armv7_pmnc_dump_regs(struct
> arm_pmu *cpu_pmu)  }  #endif
> 
> +struct armv7_pmuregs {
> +	u32 pmc;
> +	u32 pmcntenset;
> +	u32 pmuseren;
> +	u32 pmintenset;
> +	u32 pmxevttype[8];
> +	u32 pmxevtcnt[8];
> +};
> +
> +static DEFINE_PER_CPU(struct armv7_pmuregs, pmu_regs);
> +
> +static void armv7pmu_reset(void *info);
> +
> +static void armv7pmu_save_regs(struct arm_pmu *cpu_pmu) {
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
> +	memset(regs, 0, sizeof(*regs));
> +
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
> +	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (regs->pmc)); }
> +
> +static void armv7pmu_restore_regs(struct arm_pmu *cpu_pmu) {
> +	struct pmu_hw_events *events;
> +	struct armv7_pmuregs *regs = this_cpu_ptr(&pmu_regs);
> +	int bit;
> +
> +	if (!(regs->pmc & ARMV7_PMNC_E))
> +		return;
> +

Shouldn't check regs->pmc anymore since it won't be updated every time.
I will submit another version to fix it.
Sorry for noise.

> +	armv7pmu_reset(cpu_pmu);
> +
> +	events = cpu_pmu->get_hw_events();
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
> +	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (regs->pmc)); }
> +
>  static void armv7pmu_enable_event(struct perf_event *event)  {
>  	unsigned long flags;
> @@ -1528,6 +1601,8 @@ static void armv7pmu_init(struct arm_pmu
> *cpu_pmu)
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



Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
