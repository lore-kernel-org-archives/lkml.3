Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaFXPdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:33:06 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:55002 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaFXPdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:33:04 -0400
MIME-Version: 1.0
In-Reply-To: <1403618235-19353-6-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
	<1403618235-19353-6-git-send-email-t.figa@samsung.com>
Date: Tue, 24 Jun 2014 21:03:03 +0530
Message-ID: <CAM4voanJ_auOJoauvsMOVz3nhjx3hGgpbzccMMwn2ouvjwWy2g@mail.gmail.com>
Subject: Re: [PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Tue, Jun 24, 2014 at 7:27 PM, Tomasz Figa <t.figa@samsung.com> wrote:
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
>  arch/arm/mach-exynos/pm.c | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
>
A patch from me has recently gone in which converts the soc_is checks
for A9 specific registers to  the A9 part number. This patch will
probably have to be rebased atop it.

Regards,
Abhilash
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index 87c0d34..98d4926 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -364,11 +364,6 @@ early_wakeup:
>         return;
>  }
>
> -static struct syscore_ops exynos_pm_syscore_ops = {
> -       .suspend        = exynos_pm_suspend,
> -       .resume         = exynos_pm_resume,
> -};
> -
>  /*
>   * Suspend Ops
>   */
> @@ -438,19 +433,13 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
>
>         switch (cmd) {
>         case CPU_PM_ENTER:
> -               if (cpu == 0) {
> -                       exynos_pm_central_suspend();
> -                       exynos_cpu_save_register();
> -               }
> +               if (cpu == 0)
> +                       exynos_pm_suspend();
>                 break;
>
>         case CPU_PM_EXIT:
> -               if (cpu == 0) {
> -                       if (!soc_is_exynos5250())
> -                               scu_enable(S5P_VA_SCU);
> -                       exynos_cpu_restore_register();
> -                       exynos_pm_central_resume();
> -               }
> +               if (cpu == 0)
> +                       exynos_pm_resume();
>                 break;
>         }
>
> @@ -475,6 +464,5 @@ void __init exynos_pm_init(void)
>         tmp |= ((0xFF << 8) | (0x1F << 1));
>         __raw_writel(tmp, S5P_WAKEUP_MASK);
>
> -       register_syscore_ops(&exynos_pm_syscore_ops);
>         suspend_set_ops(&exynos_suspend_ops);
>  }
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
