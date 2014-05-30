Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaE3Lao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:30:44 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49217 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaE3Lam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:30:42 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-e8-53886bdf6777
Message-id: <1401449444.20793.2.camel@AMDC1943>
Subject: Re: [PATCH] ARM: exynos4212: hotplug: Fix CPU idle clock down after
 CPU1 off
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Fri, 30 May 2014 13:30:44 +0200
In-reply-to: <1399990378-7023-1-git-send-email-k.kozlowski@samsung.com>
References: <1399990378-7023-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xK7r3szuCDd4vMbPYOGM9q0Xvgqts
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77BbrZ7xmceD0aGnuYfPYvKTeo2/LKkaP
	z5vkAliiuGxSUnMyy1KL9O0SuDKOX+1nL5glXbH43EuWBsYjol2MnBwSAiYSSydPZ4ewxSQu
	3FvP1sXIxSEksJRR4uO69SwQzmdGiT1T3jGDVPEK6EtcuHOKBcQWFgiXeLvkJiOIzSZgLLF5
	+RI2EFtEQFPi1OKLzCDNzALHmSRWdj5mAkmwCKhKLN+6BKyBU8BdYs3+JWCrhQTcJL6fvgxm
	MwuoS0yat4gZ4iRliXn7jzFBLBaU+DH5HgtEjbzE5jVvmScwCsxC0jILSdksJGULGJlXMYqm
	liYXFCel5xrpFSfmFpfmpesl5+duYoSE+9cdjEuPWR1iFOBgVOLhzXBpDxZiTSwrrsw9xCjB
	wawkwns8viNYiDclsbIqtSg/vqg0J7X4ECMTB6dUA6Nt4x+Pshnh525y16RPP7xr2aLwCee1
	u39eXefwTlV2l/Rt/cbqrS4Nyz7u/mC4Kbi99Kt87pflsxq3T2OwL+B9y5kn4NPwc+mz6LVT
	fq2MKV3wt6veJDP5al2GR8Cy72cZl8ZKqDLOantk6rd1koX1/NJHuy/0v10yw7nzrUbCer4j
	S36LKpsosRRnJBpqMRcVJwIAqlwC9FUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-05-13 at 16:12 +0200, Krzysztof Kozlowski wrote:
> On Exynos4212 USE_DELAYED_RESET_ASSERTION must be set in
> ARM_CORE1_OPTION register during CPU power down. This is the proper way
> of powering down CPU. Additionally without this the CPU clock down won't
> work after powering down CPU1 and CPU will work at full frequency chosen
> by CPUfreq governor.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>



I am humbly reminding myself - any comments on this patch?

Best regards,
Krzysztof


> ---
>  arch/arm/mach-exynos/hotplug.c  | 28 +++++++++++++++++++++++++---
>  arch/arm/mach-exynos/regs-pmu.h |  2 ++
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index 5eead530c6f8..59b813e74558 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -74,7 +74,7 @@ static inline void cpu_enter_lowpower_a15(void)
>  	dsb();
>  }
>  
> -static inline void cpu_leave_lowpower(void)
> +static inline void cpu_leave_lowpower(unsigned int cpu)
>  {
>  	unsigned int v;
>  
> @@ -88,6 +88,14 @@ static inline void cpu_leave_lowpower(void)
>  	  : "=&r" (v)
>  	  : "Ir" (CR_C), "Ir" (0x40)
>  	  : "cc");
> +
> +	if (cpu == 1 && soc_is_exynos4212()) {
> +		unsigned int tmp;
> +
> +		tmp = __raw_readl(S5P_ARM_CORE1_OPTION);
> +		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
> +		__raw_writel(tmp, S5P_ARM_CORE1_OPTION);
> +	}
>  }
>  
>  static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
> @@ -95,8 +103,22 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>  	for (;;) {
>  
>  		/* make cpu1 to be turned off at next WFI command */
> -		if (cpu == 1)
> +		if (cpu == 1) {
> +			if (soc_is_exynos4212()) {
> +				unsigned int tmp;
> +
> +				/*
> +				 * Exynos 4212 requires setting
> +				 * USE_DELAYED_RESET_ASSERTION so the CPU idle
> +				 * clock down feature could properly detect
> +				 * global idle state when CPU1 is off.
> +				 */
> +				tmp = __raw_readl(S5P_ARM_CORE1_OPTION);
> +				tmp |= S5P_USE_DELAYED_RESET_ASSERTION;
> +				__raw_writel(tmp, S5P_ARM_CORE1_OPTION);
> +			}
>  			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
> +		}
>  
>  		/*
>  		 * here's the WFI
> @@ -152,7 +174,7 @@ void __ref exynos_cpu_die(unsigned int cpu)
>  	 * bring this CPU back into the world of cache
>  	 * coherency, and then restore interrupts
>  	 */
> -	cpu_leave_lowpower();
> +	cpu_leave_lowpower(cpu);
>  
>  	if (spurious)
>  		pr_warn("CPU%u: %u spurious wakeup calls\n", cpu, spurious);
> diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
> index 4f6a2560d022..1a3da4ef0e22 100644
> --- a/arch/arm/mach-exynos/regs-pmu.h
> +++ b/arch/arm/mach-exynos/regs-pmu.h
> @@ -25,6 +25,7 @@
>  
>  #define S5P_USE_STANDBY_WFI0			(1 << 16)
>  #define S5P_USE_STANDBY_WFE0			(1 << 24)
> +#define S5P_USE_DELAYED_RESET_ASSERTION		BIT(12)
>  
>  #define EXYNOS_SWRESET				S5P_PMUREG(0x0400)
>  #define EXYNOS5440_SWRESET			S5P_PMUREG(0x00C4)
> @@ -107,6 +108,7 @@
>  
>  #define S5P_ARM_CORE1_CONFIGURATION		S5P_PMUREG(0x2080)
>  #define S5P_ARM_CORE1_STATUS			S5P_PMUREG(0x2084)
> +#define S5P_ARM_CORE1_OPTION			S5P_PMUREG(0x2088)
>  
>  #define S5P_PAD_RET_MAUDIO_OPTION		S5P_PMUREG(0x3028)
>  #define S5P_PAD_RET_GPIO_OPTION			S5P_PMUREG(0x3108)

