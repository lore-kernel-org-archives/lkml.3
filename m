Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbaE3L3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:29:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47794 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbaE3L3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:29:36 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-6a-53886b9e3e63
Message-id: <1401449378.20793.1.camel@AMDC1943>
Subject: Re: [PATCH] ARM: EXYNOS: SWRESET is needed to boot secondary CPU on
 Exynos3250
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Fri, 30 May 2014 13:29:38 +0200
In-reply-to: <1400152691-29705-1-git-send-email-k.kozlowski@samsung.com>
References: <1400152691-29705-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xy7rzsjuCDb43sltsnLGe1aJ3wVU2
	i7NNb9gtNj2+xmpxedccNosZ5/cxWdy+zGux9shddov1M16zOHB6tDT3sHlsXlLv0bdlFaPH
	501yASxRXDYpqTmZZalF+nYJXBlPjh5jK1gvXjF17gSWBsbHQl2MnBwSAiYSvUtb2SBsMYkL
	99YD2VwcQgJLGSW2Ht3BDuF8ZpT4dmgDM0gVr4C+RPup02AdwgKREnPe3WMBsdkEjCU2L18C
	FhcR0JQ4tfgiM0gzs8BxJomVnY+ZQBIsAqoSG1YvZwexOQU8JFo3rwcbKiTgLjF9/xqwGmYB
	dYlJ8xYxQ5ykLDFv/zEmiMWCEj8mQyxjFpCX2LzmLfMERoFZSFpmISmbhaRsASPzKkbR1NLk
	guKk9FxDveLE3OLSvHS95PzcTYyQcP+yg3HxMatDjAIcjEo8vJku7cFCrIllxZW5hxglOJiV
	RHiPx3cEC/GmJFZWpRblxxeV5qQWH2Jk4uCUamBMsW0st3srw7XFIm+3xeydit0r54h+lJow
	h/v5+iO2m5N7bh2Sa/WZnKV8rWbD3tDHISypGe9WG831mKe5Iu797povScXntpdn5tiKanZ6
	57a/FJU8yrCFuT5AxGL3t8mr2pru2TCyFqazhf6v5ur+mfxotvUT55dJe6/N2bJYJfjWocif
	WfOVWIozEg21mIuKEwE7fjRnVQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-05-15 at 13:18 +0200, Krzysztof Kozlowski wrote:
> Without software reset the secondary CPU does not power up and
> exynos_boot_secondary() ends with pen_release equal to 1. This can be
> observed in dmesg:
> 	CPU1: failed to come online
> 	Brought up 1 CPUs
> 	SMP: Total of 1 processors activated.
> 	CPU: All CPU(s) started in SVC mode.
> 
> When booting the secondary CPU on Exynos3250 execute also software
> reset for core 1.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

I am humbly reminding myself - any comments on this patch?

Best regards,
Krzysztof


> ---
>  arch/arm/mach-exynos/platsmp.c  | 22 ++++++++++++++++++++++
>  arch/arm/mach-exynos/regs-pmu.h |  3 +++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
> index 8b88eb2f077b..64ec5ca18f60 100644
> --- a/arch/arm/mach-exynos/platsmp.c
> +++ b/arch/arm/mach-exynos/platsmp.c
> @@ -76,6 +76,25 @@ static inline void __iomem *cpu_boot_reg(int cpu)
>  }
>  
>  /*
> + * Set wake up by local power mode and execute software reset for given core.
> + *
> + * Currently this is needed only when booting secondary CPU on Exynos3250.
> + */
> +static inline void exynos_core_restart(u32 core_id)
> +{
> +	if (of_machine_is_compatible("samsung,exynos3250")) {
> +		u32 val;
> +
> +		val = __raw_readl(S5P_ARM_CORE_STATUS(core_id));
> +		val |= S5P_CORE_WAKEUP_FROM_LOCAL_CFG;
> +		__raw_writel(val, S5P_ARM_CORE_STATUS(core_id));
> +
> +		pr_info("CPU%u: Software reset\n", core_id);
> +		__raw_writel(EXYNOS_CORE_PO_RESET(core_id), EXYNOS_SWRESET);
> +	}
> +}
> +
> +/*
>   * Write pen_release in a way that is guaranteed to be visible to all
>   * observers, irrespective of whether they're taking part in coherency
>   * or not.  This is necessary for the hotplug code to work reliably.
> @@ -155,6 +174,9 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  			return -ETIMEDOUT;
>  		}
>  	}
> +
> +	exynos_core_restart(core_id);
> +
>  	/*
>  	 * Send the secondary CPU a soft interrupt, thereby causing
>  	 * the boot monitor to read the system wide flags register,
> diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
> index d94bbc85d7e0..3ecbb4fe227b 100644
> --- a/arch/arm/mach-exynos/regs-pmu.h
> +++ b/arch/arm/mach-exynos/regs-pmu.h
> @@ -26,6 +26,8 @@
>  #define S5P_USE_STANDBY_WFI0			(1 << 16)
>  #define S5P_USE_STANDBY_WFE0			(1 << 24)
>  
> +#define EXYNOS_CORE_PO_RESET(n)			((1 << 4) << n)
> +
>  #define EXYNOS_SWRESET				S5P_PMUREG(0x0400)
>  #define EXYNOS5440_SWRESET			S5P_PMUREG(0x00C4)
>  
> @@ -117,6 +119,7 @@
>  #define S5P_PAD_RET_EBIB_OPTION			S5P_PMUREG(0x31A8)
>  
>  #define S5P_CORE_LOCAL_PWR_EN			0x3
> +#define S5P_CORE_WAKEUP_FROM_LOCAL_CFG		(0x3 << 8)
>  #define S5P_INT_LOCAL_PWR_EN			0x7
>  
>  #define S5P_CHECK_SLEEP				0x00000BAD

