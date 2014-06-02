Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaFBQN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:13:29 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:33431 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaFBQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:13:26 -0400
Message-ID: <538CA2B6.4080805@linaro.org>
Date: Mon, 02 Jun 2014 18:13:42 +0200
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
Subject: Re: [PATCH v2 4/7] ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_*
 macros by static inlines
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com> <1401712543-14281-5-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1401712543-14281-5-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 02:35 PM, Bartlomiej Zolnierkiewicz wrote:
> Replace EXYNOS_BOOT_VECTOR_ADDR and EXYNOS_BOOT_VECTOR_FLAG macros
> by exynos_boot_vector_addr() and exynos_boot_vector_flag() static
> inlines.
>
> This patch shouldn't cause any functionality changes.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   arch/arm/mach-exynos/pm.c | 28 ++++++++++++++++++++--------
>   1 file changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index 87c0d34..cf09383 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -166,12 +166,23 @@ int exynos_cluster_power_state(int cluster)
>   			S5P_CORE_LOCAL_PWR_EN);
>   }
>
> -#define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
> -			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
> -			(sysram_base_addr + 0x24) : S5P_INFORM0))
> -#define EXYNOS_BOOT_VECTOR_FLAG	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
> -			S5P_INFORM6 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
> -			(sysram_base_addr + 0x20) : S5P_INFORM1))
> +static inline void __iomem *exynos_boot_vector_addr(void)
> +{
> +	if (samsung_rev() == EXYNOS4210_REV_1_1)
> +		return S5P_INFORM7;
> +	else if (samsung_rev() == EXYNOS4210_REV_1_0)
> +		return sysram_base_addr + 0x24;
> +	return S5P_INFORM0;
> +}
> +
> +static inline void __iomem *exynos_boot_vector_flag(void)
> +{
> +	if (samsung_rev() == EXYNOS4210_REV_1_1)
> +		return S5P_INFORM6;
> +	else if (samsung_rev() == EXYNOS4210_REV_1_0)
> +		return sysram_base_addr + 0x20;
> +	return S5P_INFORM1;
> +}
>
>   #define S5P_CHECK_AFTR  0xFCBA0D10
>   #define S5P_CHECK_SLEEP 0x00000BAD
> @@ -184,8 +195,9 @@ static void exynos_set_wakeupmask(long mask)
>
>   static void exynos_cpu_set_boot_vector(long flags)
>   {
> -	__raw_writel(virt_to_phys(exynos_cpu_resume), EXYNOS_BOOT_VECTOR_ADDR);
> -	__raw_writel(flags, EXYNOS_BOOT_VECTOR_FLAG);
> +	__raw_writel(virt_to_phys(exynos_cpu_resume),
> +		     exynos_boot_vector_addr());
> +	__raw_writel(flags, exynos_boot_vector_flag());
>   }
>
>   void exynos_enter_aftr(void)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

