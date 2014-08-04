Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaHDOgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:36:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26636 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaHDOg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:36:29 -0400
X-AuditID: cbfee61a-f79e46d00000134f-cd-53df9a64ccb6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, arm@kernel.org
Subject: Re: [PATCH v3][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
Date: Mon, 04 Aug 2014 16:36:09 +0200
Message-id: <3315016.uq8MCuqyTs@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <19823219.PknUbmjHjT@amdc1032>
References: <19823219.PknUbmjHjT@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jAd2UWfeDDf50Wlgc+7KFzeLvpGPs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jslh75C67xanrn9ks1s94zeLA6fH71yRGj02rOtk8Ni+p
	97hyoonVo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDLObn3JVPDes+Jn2zzWBsb91l2MnBwS
	AiYSE489ZoawxSQu3FvP1sXIxSEksIhRYv/XXlYIp4VJYs+yd+wgVWwCVhIT21cxgtgiAmoS
	PYu3MoIUMQv0MUlMm9IFlhAWCJCYv2QX2FgWAVWJTYu3gdm8ApoSyzbsZwGxRQU8JXZsX8kG
	YnMKaEv0dvaD9QoJaEk8e/GGEaJeUOLH5Htg9cwC8hL79k9lhbC1JNbvPM40gVFgFpKyWUjK
	ZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOAqeSe1gXNlgcYhRgINRiYdXQO1+
	sBBrYllxZe4hRgkOZiUR3uwyoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6Yklqdmp
	qQWpRTBZJg5OqQZGPxvh40Fdofv4LixL+fz7zd+SWpMLzDN5Gm7tMT3B8r1KfO6WBxkuPVFh
	4l7ahya/PCGpxidnk7jaRfRny64H5tJTD/9SXKYfHvSj+OfVBfs6BGSNdH6rNFuzSMs2vl8d
	dkaauehfrzrzt2mvAy5F76z6azmXr+r/28pdous3WEQvkpnJoi2mxFKckWioxVxUnAgAl//M
	/34CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, August 04, 2014 04:09:51 PM Bartlomiej Zolnierkiewicz wrote:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> Due to recent consolidation of Exynos suspend and cpuidle code, some
> parts of suspend and resume sequences are executed two times, once from
> exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
> breaks suspend, at least on Exynos4-based boards. In addition, simple
> core power down from a cpuidle driver could, in case of CPU 0 could
> result in calling functions that are specific to suspend and deeper idle
> states.
> 
> This patch fixes the issue by moving those operations outside the CPU PM
> notifier into suspend and AFTR code paths. This leads to a bit of code
> duplication, but allows additional code simplification, so in the end
> more code is removed than added.
> 
> Fixes: 85f9f90808b4 ("ARM: EXYNOS: Use the cpu_pm notifier for pm")
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: arm@kernel.org
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> [b.zolnierkie: ported patch over current changes]
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  arch/arm/mach-exynos/pm.c        | 163 ++++++++++++++++++---------------------
>  drivers/cpuidle/cpuidle-exynos.c |  25 +-----
>  2 files changed, 80 insertions(+), 108 deletions(-)
> 
> This is a Tomasz's patch ([1]) ported over current -next kernel.
> 
> I'm sending this because Tomasz is on holiday currently and cannot
> test the patch (I tested it with Exynos4210 SoC based Origen board
> and Exynos4212 SoC based Trats2 target, BTW @Tomasz: on the former
> device S2R works even without this patch and on the latter one S2R
> doesn't work even with this patch applied).  I also need this patch
> as a prerequisite for my cpuidle AFTR changes.
> 
> Kukjin, could you please apply it to your v3.17 tree?  Thanks!

I noticed one thing that is not correct (please see below),
I will send updated patch shortly.

> [1] http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35094.html
> 
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index 18646b7..e2c5c7b 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -114,26 +114,6 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
>  #define S5P_CHECK_AFTR  0xFCBA0D10
>  #define S5P_CHECK_SLEEP 0x00000BAD
>  
> -/* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
> -static void exynos_set_wakeupmask(long mask)
> -{
> -	pmu_raw_writel(mask, S5P_WAKEUP_MASK);
> -}
> -
> -static void exynos_cpu_set_boot_vector(long flags)
> -{
> -	__raw_writel(virt_to_phys(exynos_cpu_resume), EXYNOS_BOOT_VECTOR_ADDR);
> -	__raw_writel(flags, EXYNOS_BOOT_VECTOR_FLAG);
> -}
> -
> -void exynos_enter_aftr(void)
> -{
> -	exynos_set_wakeupmask(0x0000ff3e);
> -	exynos_cpu_set_boot_vector(S5P_CHECK_AFTR);
> -	/* Set value of power down register for aftr mode */
> -	exynos_sys_powerdown_conf(SYS_AFTR);
> -}
> -
>  /* For Cortex-A9 Diagnostic and Power control register */
>  static unsigned int save_arm_register[2];
>  
> @@ -173,6 +153,82 @@ static void exynos_cpu_restore_register(void)
>  		      : "cc");
>  }
>  
> +static void exynos_pm_central_suspend(void)
> +{
> +	unsigned long tmp;
> +
> +	/* Setting Central Sequence Register for power down mode */
> +	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
> +	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
> +	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
> +}
> +
> +static int exynos_pm_central_resume(void)
> +{
> +	unsigned long tmp;
> +
> +	/*
> +	 * If PMU failed while entering sleep mode, WFI will be
> +	 * ignored by PMU and then exiting cpu_do_idle().
> +	 * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
> +	 * in this situation.
> +	 */
> +	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
> +	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
> +		tmp |= S5P_CENTRAL_LOWPWR_CFG;
> +		pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
> +		/* clear the wakeup state register */
> +		pmu_raw_writel(0x0, S5P_WAKEUP_STAT);
> +		/* No need to perform below restore code */
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
> +static void exynos_set_wakeupmask(long mask)
> +{
> +	pmu_raw_writel(mask, S5P_WAKEUP_MASK);
> +}
> +
> +static void exynos_cpu_set_boot_vector(long flags)
> +{
> +	__raw_writel(virt_to_phys(exynos_cpu_resume), EXYNOS_BOOT_VECTOR_ADDR);
> +	__raw_writel(flags, EXYNOS_BOOT_VECTOR_FLAG);
> +}
> +
> +static int exynos_aftr_finisher(unsigned long flags)
> +{
> +	exynos_set_wakeupmask(0x0000ff3e);
> +	exynos_cpu_set_boot_vector(S5P_CHECK_AFTR);
> +	/* Set value of power down register for aftr mode */
> +	exynos_sys_powerdown_conf(SYS_AFTR);
> +	cpu_do_idle();
> +
> +	return 0;

In the original code (before the patch) '1' not '0' was returned and
I believe that the old code was correct.

> +}
> +
> +void exynos_enter_aftr(void)
> +{
> +	cpu_pm_enter();
> +
> +	exynos_pm_central_suspend();
> +	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
> +		exynos_cpu_save_register();
> +
> +	cpu_suspend(0, exynos_aftr_finisher);
> +
> +	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9) {
> +		scu_enable(S5P_VA_SCU);
> +		exynos_cpu_restore_register();
> +	}
> +
> +	exynos_pm_central_resume();
> +
> +	cpu_pm_exit();
> +}
> +
>  static int exynos_cpu_suspend(unsigned long arg)
>  {
>  #ifdef CONFIG_CACHE_L2X0
> @@ -217,16 +273,6 @@ static void exynos_pm_prepare(void)
>  	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
>  }
>  
> -static void exynos_pm_central_suspend(void)
> -{
> -	unsigned long tmp;
> -
> -	/* Setting Central Sequence Register for power down mode */
> -	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
> -	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
> -	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
> -}
> -
>  static int exynos_pm_suspend(void)
>  {
>  	unsigned long tmp;
> @@ -244,29 +290,6 @@ static int exynos_pm_suspend(void)
>  	return 0;
>  }
>  
> -static int exynos_pm_central_resume(void)
> -{
> -	unsigned long tmp;
> -
> -	/*
> -	 * If PMU failed while entering sleep mode, WFI will be
> -	 * ignored by PMU and then exiting cpu_do_idle().
> -	 * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
> -	 * in this situation.
> -	 */
> -	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
> -	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
> -		tmp |= S5P_CENTRAL_LOWPWR_CFG;
> -		pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
> -		/* clear the wakeup state register */
> -		pmu_raw_writel(0x0, S5P_WAKEUP_STAT);
> -		/* No need to perform below restore code */
> -		return -1;
> -	}
> -
> -	return 0;
> -}
> -
>  static void exynos_pm_resume(void)
>  {
>  	if (exynos_pm_central_resume())
> @@ -369,44 +392,10 @@ static const struct platform_suspend_ops exynos_suspend_ops = {
>  	.valid		= suspend_valid_only_mem,
>  };
>  
> -static int exynos_cpu_pm_notifier(struct notifier_block *self,
> -				  unsigned long cmd, void *v)
> -{
> -	int cpu = smp_processor_id();
> -
> -	switch (cmd) {
> -	case CPU_PM_ENTER:
> -		if (cpu == 0) {
> -			exynos_pm_central_suspend();
> -			if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
> -				exynos_cpu_save_register();
> -		}
> -		break;
> -
> -	case CPU_PM_EXIT:
> -		if (cpu == 0) {
> -			if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
> -				scu_enable(S5P_VA_SCU);
> -				exynos_cpu_restore_register();
> -			}
> -			exynos_pm_central_resume();
> -		}
> -		break;
> -	}
> -
> -	return NOTIFY_OK;
> -}
> -
> -static struct notifier_block exynos_cpu_pm_notifier_block = {
> -	.notifier_call = exynos_cpu_pm_notifier,
> -};
> -
>  void __init exynos_pm_init(void)
>  {
>  	u32 tmp;
>  
> -	cpu_pm_register_notifier(&exynos_cpu_pm_notifier_block);
> -
>  	/* Platform-specific GIC callback */
>  	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
>  
> diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
> index 7c01512..ba9b34b 100644
> --- a/drivers/cpuidle/cpuidle-exynos.c
> +++ b/drivers/cpuidle/cpuidle-exynos.c
> @@ -20,25 +20,6 @@
>  
>  static void (*exynos_enter_aftr)(void);
>  
> -static int idle_finisher(unsigned long flags)
> -{
> -	exynos_enter_aftr();
> -	cpu_do_idle();
> -
> -	return 1;
> -}
> -
> -static int exynos_enter_core0_aftr(struct cpuidle_device *dev,
> -				struct cpuidle_driver *drv,
> -				int index)
> -{
> -	cpu_pm_enter();
> -	cpu_suspend(0, idle_finisher);
> -	cpu_pm_exit();
> -
> -	return index;
> -}
> -
>  static int exynos_enter_lowpower(struct cpuidle_device *dev,
>  				struct cpuidle_driver *drv,
>  				int index)
> @@ -51,8 +32,10 @@ static int exynos_enter_lowpower(struct cpuidle_device *dev,
>  
>  	if (new_index == 0)
>  		return arm_cpuidle_simple_enter(dev, drv, new_index);
> -	else
> -		return exynos_enter_core0_aftr(dev, drv, new_index);
> +
> +	exynos_enter_aftr();
> +
> +	return new_index;
>  }
>  
>  static struct cpuidle_driver exynos_idle_driver = {

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

