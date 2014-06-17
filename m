Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668AbaFQQCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:02:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17264 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015AbaFQQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:02:28 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-53-53a066906e6b
Message-id: <53A0667E.6000905@samsung.com>
Date: Tue, 17 Jun 2014 18:02:06 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        vikas.sajjan@samsung.com
Subject: Re: [PATCH v4 08/11] ARM: EXYNOS: Refactored code for using PMU
 address via DT
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-9-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399704998-13321-9-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xa7oT0hYEG8zcrmuxbNJdNoveBVfZ
	LDY9vsZqcXnXHDaLGef3MVncvsxrsWjrF3aLm8+2MzlweLQ097B5bF5S79G3ZRWjx+dNcgEs
	UVw2Kak5mWWpRfp2CVwZ585sZCtYpFdx/uly5gbGJapdjJwcEgImEvOeTWWCsMUkLtxbz9bF
	yMUhJLCUUeLfqu1QzmdGiU/r34FV8QpoSazYP5kVxGYRUJXoXDWLGcRmE1CT+NzwiA3E5geq
	WdN0naWLkYNDVCBC4vEFIYhWQYkfk++xgMwUEZjCKHGxZxkjSIJZIFni07kfYHOEBSIlGvds
	gVrczijRd62DHSTBKeApcf/JN3aIBh2J/a3T2CBseYnNa94yT2AUnIVkySwkZbOQlC1gZF7F
	KJpamlxQnJSea6RXnJhbXJqXrpecn7uJERL8X3cwLj1mdYhRgINRiYdX4d+cYCHWxLLiytxD
	jBIczEoivCXiC4KFeFMSK6tSi/Lji0pzUosPMTJxcEo1MF67Ij2jTy3zdrmhnNb6swtKU2YH
	Ki0yV9vi53qwN1/m6bLwmMQVpz79YQx/su5Lpd2y2Hs7ndOD/07R8ttsld5UdvTGQf9cKZaA
	TB65yTs+Lns3iXWC5pQ2uyv8Kpams39YztLyVrGKL5niFf6v6mij5a3Z3tsqG3Zxf7HbctNc
	Ydqddy+tbyuxFGckGmoxFxUnAgBBEJXzXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

[Dropped yg1004.jang@samsung.com from CC, as apparently his mailbox is
"temporarily locked", at least from the point of view of my mail server.]

Please see my comments inline.

On 10.05.2014 08:56, Pankaj Dubey wrote:
> Under "arm/mach-exynos" many files are using PMU register offsets.
> Since we have added support for accessing PMU base address via DT,
> now we can remove PMU mapping from exynosX_iodesc. Let's convert
> all these access using either of iomapped address or regmap handle.
> This will help us in removing static mapping of PMU base address
> as well as help in reducing dependency over machine header files.
> Thus helping for migration of PMU implementation from machine to
> driver folder which can be reused for ARM64 bsed SoC.

[snip]

> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index 3b1d245..59eb1f1 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c

[snip]

> @@ -156,7 +147,7 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
>  {
>  	struct device_node *np;
>  	u32 val = 0x1;
> -	void __iomem *addr = EXYNOS_SWRESET;
> +	void __iomem *addr = NULL;

This will probably change into addr = exynos_pmu_base + EXYNOS_SWRESET.

>  
>  	if (of_machine_is_compatible("samsung,exynos5440")) {
>  		u32 status;
> @@ -169,9 +160,9 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
>  		val = __raw_readl(addr);
>  
>  		val = (val & 0xffff0000) | (status & 0xffff);
> -	}
> -
> -	__raw_writel(val, addr);
> +		__raw_writel(val, addr);
> +	} else
> +		regmap_write(exynos_pmu_regmap, EXYNOS_SWRESET, val);
>  }
>  
>  static struct platform_device exynos_cpuidle = {
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index 73b0b5c..0243ef3 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -13,6 +13,7 @@
>  #include <linux/errno.h>
>  #include <linux/smp.h>
>  #include <linux/io.h>
> +#include <linux/regmap.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/cp15.h>
> @@ -91,11 +92,12 @@ static inline void cpu_leave_lowpower(void)
>  
>  static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>  {
> +	struct regmap *pmu_regmap = get_exynos_pmuregmap();
>  	for (;;) {
>  
>  		/* make cpu1 to be turned off at next WFI command */
>  		if (cpu == 1)
> -			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
> +			regmap_write(pmu_regmap, S5P_ARM_CORE1_CONFIGURATION, 0);

This change should disappear.

[snip]

> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
> index 1f63596..33eb364 100644
> --- a/arch/arm/mach-exynos/platsmp.c
> +++ b/arch/arm/mach-exynos/platsmp.c

[snip]

> +static void __iomem *pmu_base_addr(void)
> +{
> +	struct device_node *np = NULL;
> +	if (!pmu_base) {
> +		np = of_find_matching_node(NULL, exynos_dt_pmu_match);
> +
> +		if (!np)
> +			panic("%s, failed to find PMU node\n", __func__);
> +
> +		pmu_base = of_iomap(np, 0);
> +
> +		if (!pmu_base)
> +			panic("%s: failed to map registers\n", __func__);
> +	}
> +	return pmu_base;
> +}

As we discussed before, PMU mapping for arch code should be handled in
the same way as SYSRAM.

>  static DEFINE_SPINLOCK(boot_lock);
>  
>  static void exynos_secondary_init(unsigned int cpu)
> @@ -132,14 +158,14 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  	 */
>  	write_pen_release(phys_cpu);
>  
> -	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) {
> +	if (!(__raw_readl(pmu_base + S5P_ARM_CORE1_STATUS)
> +				& S5P_CORE_LOCAL_PWR_EN)) {

Creating a variable to save register value to would probably make the
code more readable.

>  		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
> -			     S5P_ARM_CORE1_CONFIGURATION);
> -
> +			pmu_base + S5P_ARM_CORE1_CONFIGURATION);
>  		timeout = 10;
>  
>  		/* wait max 10 ms until cpu1 is on */
> -		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
> +		while ((__raw_readl(pmu_base + S5P_ARM_CORE1_STATUS)
>  			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) {

Ditto.

>  			if (timeout-- == 0)
>  				break;
> @@ -238,6 +264,8 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
>  {
>  	int i;
>  
> +	pmu_base = pmu_base_addr();
> +
>  	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
>  		scu_enable(scu_base_addr());
>  
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index f445c49..ee427d7 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -21,6 +21,7 @@
>  #include <linux/irqchip/arm-gic.h>
>  #include <linux/err.h>
>  #include <linux/clk.h>
> +#include <linux/regmap.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/hardware/cache-l2x0.h>
> @@ -38,6 +39,8 @@
>  #include "regs-pmu.h"
>  #include "regs-sys.h"
>  
> +static struct regmap *pmu_regmap;
> +

This and other regmap related changes in this file won't be needed anymore.

>  /**
>   * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
>   * @hwirq: Hardware IRQ signal of the GIC
> @@ -104,10 +107,10 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)

[snip]

> diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
> index fd8a19d..a72b1bc 100644
> --- a/arch/arm/mach-exynos/regs-pmu.h
> +++ b/arch/arm/mach-exynos/regs-pmu.h

[snip]

>  
> -#define S5P_WAKEUP_STAT				S5P_PMUREG(0x0600)
> -#define S5P_EINT_WAKEUP_MASK			S5P_PMUREG(0x0604)
> -#define S5P_WAKEUP_MASK				S5P_PMUREG(0x0608)
> +#define S5P_WAKEUP_STAT				0x0600
> +#define S5P_EINT_WAKEUP_MASK			0x0604
> +#define S5P_WAKEUP_MASK				0x0608

Is it just my mail client or indentation is inconsistent here?

Best regards,
Tomasz
