Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab3FRRpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:45:36 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:43134 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3FRRpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:45:32 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        arnd@arndb.de, olof@lixom.net
Subject: Re: [PATCH] ARM: EXYNOS: Fix incorrect usage of S5P_ARM_CORE1_* registers
Date: Tue, 18 Jun 2013 19:45:27 +0200
Message-ID: <4951987.HiKYku7923@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.6-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <1371569191-2364-1-git-send-email-t.figa@samsung.com>
References: <1371569191-2364-1-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing Arnd and Olof, because I forgot to add them to git send-email...

Sorry for the noise.

On Tuesday 18 of June 2013 17:26:31 Tomasz Figa wrote:
> S5P_ARM_CORE1_* registers affect only core 1. To control further cores
> properly another registers must be used.
> 
> This patch replaces S5P_ARM_CORE1_* register definitions with
> S5P_ARM_CORE_*(x) macro which return addresses of registers for
> specified core.
> 
> This fixes CPU hotplug on quad core Exynos SoCs on which currently
> offlining CPUs 2 or 3 caused CPU 1 to be turned off.

Obviously this doesn't happen currently because of the if (cpu == 1), but 
if logical cpu1 turned out not to be physical cpu1, then it would crash.

Best regards,
Tomasz

> In addition,
> bring-up of CPU 2 and 3 is fixed on boards where bootloader powers off
> secondary cores by default.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/hotplug.c               |  9 +++++----
>  arch/arm/mach-exynos/include/mach/regs-pmu.h | 10 +++++++---
>  arch/arm/mach-exynos/platsmp.c               |  9 +++++----
>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/hotplug.c
> b/arch/arm/mach-exynos/hotplug.c index af90cfa..c089943 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -93,10 +93,11 @@ static inline void cpu_leave_lowpower(void)
>  static inline void platform_do_lowpower(unsigned int cpu, int
> *spurious) {
>  	for (;;) {
> +		void __iomem *reg_base;
> +		unsigned int phys_cpu = cpu_logical_map(cpu);
> 
> -		/* make cpu1 to be turned off at next WFI command */
> -		if (cpu == 1)
> -			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
> +		reg_base = S5P_ARM_CORE_CONFIGURATION(phys_cpu);
> +		__raw_writel(0, reg_base);
> 
>  		/*
>  		 * here's the WFI
> @@ -106,7 +107,7 @@ static inline void platform_do_lowpower(unsigned int
> cpu, int *spurious)
>  		    : "memory", "cc");
> 
> -		if (pen_release == cpu_logical_map(cpu)) {
> +		if (pen_release == phys_cpu) {
>  			/*
>  			 * OK, proper wakeup, we're done
>  			 */
> diff --git a/arch/arm/mach-exynos/include/mach/regs-pmu.h
> b/arch/arm/mach-exynos/include/mach/regs-pmu.h index 57344b7..cf40b86
> 100644
> --- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
> +++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
> @@ -125,10 +125,14 @@
>  #define S5P_GPS_ALIVE_LOWPWR			S5P_PMUREG(0x13A0)
> 
>  #define S5P_ARM_CORE0_CONFIGURATION		S5P_PMUREG(0x2000)
> +#define S5P_ARM_CORE0_STATUS			S5P_PMUREG(0x2004)
>  #define S5P_ARM_CORE0_OPTION			S5P_PMUREG(0x2008)
> -#define S5P_ARM_CORE1_CONFIGURATION		S5P_PMUREG(0x2080)
> -#define S5P_ARM_CORE1_STATUS			S5P_PMUREG(0x2084)
> -#define S5P_ARM_CORE1_OPTION			S5P_PMUREG(0x2088)
> +#define S5P_ARM_CORE_CONFIGURATION(_nr)		\
> +		(S5P_ARM_CORE0_CONFIGURATION + ((_nr) * 0x80))
> +#define S5P_ARM_CORE_STATUS(_nr)		\
> +		(S5P_ARM_CORE0_STATUS + ((_nr) * 0x80))
> +#define S5P_ARM_CORE_OPTION(_nr)		\
> +		(S5P_ARM_CORE0_OPTION + ((_nr) * 0x80))
> 
>  #define S5P_ARM_COMMON_OPTION			S5P_PMUREG(0x2408)
>  #define S5P_TOP_PWR_OPTION			S5P_PMUREG(0x2C48)
> diff --git a/arch/arm/mach-exynos/platsmp.c
> b/arch/arm/mach-exynos/platsmp.c index d9c6d0a..2cbabc8 100644
> --- a/arch/arm/mach-exynos/platsmp.c
> +++ b/arch/arm/mach-exynos/platsmp.c
> @@ -109,14 +109,15 @@ static int __cpuinit
> exynos_boot_secondary(unsigned int cpu, struct task_struct */
>  	write_pen_release(phys_cpu);
> 
> -	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) 
{
> +	if (!(__raw_readl(S5P_ARM_CORE_STATUS(phys_cpu))
> +	    & S5P_CORE_LOCAL_PWR_EN)) {
>  		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
> -			     S5P_ARM_CORE1_CONFIGURATION);
> +			     S5P_ARM_CORE_CONFIGURATION(phys_cpu));
> 
>  		timeout = 10;
> 
>  		/* wait max 10 ms until cpu1 is on */
> -		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
> +		while ((__raw_readl(S5P_ARM_CORE_STATUS(phys_cpu))
>  			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) 
{
>  			if (timeout-- == 0)
>  				break;
> @@ -125,7 +126,7 @@ static int __cpuinit exynos_boot_secondary(unsigned
> int cpu, struct task_struct }
> 
>  		if (timeout == 0) {
> -			printk(KERN_ERR "cpu1 power enable failed");
> +			printk(KERN_ERR "cpu%u power enable failed", cpu);
>  			spin_unlock(&boot_lock);
>  			return -ETIMEDOUT;
>  		}
