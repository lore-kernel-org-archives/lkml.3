Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaGNJzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:55:17 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33137 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaGNJzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:55:12 -0400
Message-ID: <53C3A8E8.4090009@gmail.com>
Date: Mon, 14 Jul 2014 11:54:48 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>
Subject: Re: [PATCH v2 5/6] ARM: EXYNOS: Fix suspend/resume sequences
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com> <1403697175-13476-1-git-send-email-t.figa@samsung.com>
In-Reply-To: <1403697175-13476-1-git-send-email-t.figa@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 25.06.2014 13:52, Tomasz Figa wrote:
> Due to recent consolidation of Exynos suspend and cpuidle code, some
> parts of suspend and resume sequences are executed two times, once from
> exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
> breaks suspend, at least on Exynos4-based boards.
> 
> This patch fixes the issue by removing exynos_pm_syscore_ops completely
> and making the code rely only on CPU PM notifier.
> 
> Tested on Exynos4210-based Trats board.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/pm.c | 23 ++++-------------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
> 
> Changes since v1:
>  - rebased onto Kukjin's fixes branch.
> 
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index 202ca73..f23cc77 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -364,11 +364,6 @@ early_wakeup:
>  	return;
>  }
>  
> -static struct syscore_ops exynos_pm_syscore_ops = {
> -	.suspend	= exynos_pm_suspend,
> -	.resume		= exynos_pm_resume,
> -};
> -
>  /*
>   * Suspend Ops
>   */
> @@ -438,22 +433,13 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
>  
>  	switch (cmd) {
>  	case CPU_PM_ENTER:
> -		if (cpu == 0) {
> -			exynos_pm_central_suspend();
> -			if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
> -				exynos_cpu_save_register();
> -		}
> +		if (cpu == 0)
> +			exynos_pm_suspend();
>  		break;
>  
>  	case CPU_PM_EXIT:
> -		if (cpu == 0) {
> -			if (read_cpuid_part_number() ==
> -					ARM_CPU_PART_CORTEX_A9) {
> -				scu_enable(S5P_VA_SCU);
> -				exynos_cpu_restore_register();
> -			}
> -			exynos_pm_central_resume();
> -		}
> +		if (cpu == 0)
> +			exynos_pm_resume();
>  		break;
>  	}
>  
> @@ -478,6 +464,5 @@ void __init exynos_pm_init(void)
>  	tmp |= ((0xFF << 8) | (0x1F << 1));
>  	__raw_writel(tmp, S5P_WAKEUP_MASK);
>  
> -	register_syscore_ops(&exynos_pm_syscore_ops);
>  	suspend_set_ops(&exynos_suspend_ops);
>  }
> 

Please consider this patch for next fixes pull request. Without it
suspend/resume is broken for Exynos4 and probably other SoCs. This patch
just restores the sequence from before the patch moving things to PM
notifier, so I don't think it should need any special treatment.

Best regards,
Tomasz
