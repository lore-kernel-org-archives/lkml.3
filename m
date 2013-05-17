Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3EQKhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 06:37:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3EQKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 06:37:35 -0400
Date: Fri, 17 May 2013 11:37:31 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Inderpal Singh'" <inderpal.singh@linaro.org>,
        "'Chander Kashyap'" <chander.kashyap@linaro.org>
Subject: Re: [PATCH 3.9-stable] ARM: EXYNOS5: Fix kernel dump in AFTR idle
 mode
Message-ID: <20130517103731.GF3440@hercules>
References: <000801ce4d15$4fe51bf0$efaf53d0$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000801ce4d15$4fe51bf0$efaf53d0$%choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 09:28:36AM +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

Would you agree that this could also be applied to the 3.5 kernel as well?

Cheers,
--
Luis


> 
> ------------------
> 
> From: "Inderpal Singh <inderpal.singh@linaro.org>"
> 
> commit 088584618836b159947bc4ab5011a5cf1f081a62 upstream
> 
> The kernel crashes while resuming from AFTR idle mode. It happens
> because L2 cache was not going into retention state.
> 
> This patch configures the USE_RETENTION bit of ARM_L2_OPTION register
> so that it does not depend on MANUAL_L2RSTDISABLE_CONTROL of
> ARM_COMMON_OPTION register for L2RSTDISABLE signal.
> 
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> Tested-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  arch/arm/mach-exynos/include/mach/regs-pmu.h |    1 +
>  arch/arm/mach-exynos/pmu.c                   |    5 ++---
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/include/mach/regs-pmu.h
> b/arch/arm/mach-exynos/include/mach/regs-pmu.h
> index 3f30aa1..57344b7 100644
> --- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
> +++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
> @@ -344,6 +344,7 @@
>  #define EXYNOS5_FSYS_ARM_OPTION
> S5P_PMUREG(0x2208)
>  #define EXYNOS5_ISP_ARM_OPTION
> S5P_PMUREG(0x2288)
>  #define EXYNOS5_ARM_COMMON_OPTION
> S5P_PMUREG(0x2408)
> +#define EXYNOS5_ARM_L2_OPTION
> S5P_PMUREG(0x2608)
>  #define EXYNOS5_TOP_PWR_OPTION
> S5P_PMUREG(0x2C48)
>  #define EXYNOS5_TOP_PWR_SYSMEM_OPTION
> S5P_PMUREG(0x2CC8)
>  #define EXYNOS5_JPEG_MEM_OPTION
> S5P_PMUREG(0x2F48)
> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
> index daebc1a..97d6885 100644
> --- a/arch/arm/mach-exynos/pmu.c
> +++ b/arch/arm/mach-exynos/pmu.c
> @@ -228,6 +228,7 @@ static struct exynos_pmu_conf exynos5250_pmu_config[] =
> {
>  	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
>  	{ EXYNOS5_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
>  	{ EXYNOS5_ARM_L2_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
> +	{ EXYNOS5_ARM_L2_OPTION,			{ 0x10, 0x10, 0x0 }
> },
>  	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
>  	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
>  	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
> @@ -353,11 +354,9 @@ static void exynos5_init_pmu(void)
>  
>  	/*
>  	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
> -	 * MANUAL_L2RSTDISABLE_CONTROL_BITFIELD Enable
>  	 */
>  	tmp = __raw_readl(EXYNOS5_ARM_COMMON_OPTION);
> -	tmp |= (EXYNOS5_MANUAL_L2RSTDISABLE_CONTROL |
> -		EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN);
> +	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
>  	__raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
>  
>  	/*
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
