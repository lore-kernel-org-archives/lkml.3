Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaFBQ2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:28:42 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:59974 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbaFBQ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:28:40 -0400
Message-ID: <538CA647.8040207@linaro.org>
Date: Mon, 02 Jun 2014 18:28:55 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Tomasz Figa <t.figa@samsung.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 7/7] ARM: EXYNOS: cpuidle: add secure firmware support
 to AFTR mode code
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com> <1401712543-14281-8-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1401712543-14281-8-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 02:35 PM, Bartlomiej Zolnierkiewicz wrote:
> * Use do_idle firmware method instead of cpu_do_idle() on boards with
>    secure firmware enabled.
>
> * Use sysram_ns_base_addr + 0x24 address for exynos_boot_vector_addr()
>    and sysram_ns_base_addr + 0x20 one for exynos_boot_vector_flag() on
>    boards with secure firmware enabled.
>
> This patch fixes hang on an attempt to enter AFTR mode for TRATS2
> board (which uses EXYNOS4412 SoC with secure firmware enabled).
>
> This patch shouldn't cause any functionality changes on boards that
> don't use secure firmware.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   arch/arm/mach-exynos/pm.c        | 8 ++++++--
>   drivers/cpuidle/cpuidle-exynos.c | 7 ++++++-
>   2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index 0fb9a5a..62a0a5e 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -169,7 +169,9 @@ int exynos_cluster_power_state(int cluster)
>
>   static inline void __iomem *exynos_boot_vector_addr(void)
>   {
> -	if (samsung_rev() == EXYNOS4210_REV_1_1)
> +	if (firmware_run())
> +		return sysram_ns_base_addr + 0x24;
> +	else if (samsung_rev() == EXYNOS4210_REV_1_1)
>   		return S5P_INFORM7;
>   	else if (samsung_rev() == EXYNOS4210_REV_1_0)
>   		return sysram_base_addr + 0x24;
> @@ -178,7 +180,9 @@ static inline void __iomem *exynos_boot_vector_addr(void)
>
>   static inline void __iomem *exynos_boot_vector_flag(void)
>   {
> -	if (samsung_rev() == EXYNOS4210_REV_1_1)
> +	if (firmware_run())
> +		return sysram_ns_base_addr + 0x20;
> +	else if (samsung_rev() == EXYNOS4210_REV_1_1)
>   		return S5P_INFORM6;
>   	else if (samsung_rev() == EXYNOS4210_REV_1_0)
>   		return sysram_base_addr + 0x20;
> diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
> index 7c01512..f90a4a0 100644
> --- a/drivers/cpuidle/cpuidle-exynos.c
> +++ b/drivers/cpuidle/cpuidle-exynos.c
> @@ -17,13 +17,18 @@
>   #include <asm/proc-fns.h>
>   #include <asm/suspend.h>
>   #include <asm/cpuidle.h>
> +#include <asm/firmware.h>
>
>   static void (*exynos_enter_aftr)(void);
>
>   static int idle_finisher(unsigned long flags)
>   {
>   	exynos_enter_aftr();
> -	cpu_do_idle();
> +	if (firmware_run())
> +		/* no need to check the return value on EXYNOS SoCs */
> +		call_firmware_op(do_idle, FW_DO_IDLE_AFTR);
> +	else
> +		cpu_do_idle();

Why not move this code into the exynos_enter_aftr() function, so 
preventing more dependency ?


>   	return 1;
>   }
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

