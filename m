Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaF3QUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:20:20 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62621 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbaF3QUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:20:17 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-21-53b18e3f2729
Message-id: <53B18E24.70809@samsung.com>
Date: Mon, 30 Jun 2014 18:19:48 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v5 2/5] ARM: EXYNOS: Refactored code for using PMU address
 via DT
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-3-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1403705032-14835-3-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xq7r2fRuDDTbsZLdYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWq6FjGaHHz2XYmB26PluYeNo/N
	S+o9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2PKm5+sBXfFKp7+eMXcwDhVqIuRk0NCwETi
	xt85TBC2mMSFe+vZuhi5OIQEljJKXLo9hQ0kISTwmVFi2ss4EJtXQENiwocmZhCbRUBV4t7V
	VawgNpuAmsTnhkdg9fwCWhJrmq6zdDFycIgKREg8viAE0Soo8WPyPRaQ+SIC0xglLl66zQ7i
	MAssYZTYM+MUI0iVsEC4xPR1h1ggrmhnlFjc9xgswSngKXG16TnYZmYBHYn9rdPYIGx5ic1r
	3jJPYBSchWTLLCRls5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREhlfdjAuPmZ1
	iFGAg1GJh7dxxYZgIdbEsuLK3EOMEhzMSiK8N302BgvxpiRWVqUW5ccXleakFh9iZOLglGpg
	3Gq/o/1ZSyAw1G8kLWQ22ZljWmMQN+/S1ob319ZJ/RDbtEb2cUSxbFXNJp/FNv3XbwoWfPZM
	UF77Nm3Bhss9pkyOXw6/53EzOKgq+S9g7fp1/jszRS58NYoKEsxgyajUWbj57rwZkmYzI+Oe
	PV2w7UZefuDijQyrJphc2mb8XdV4rvfuS8+6lFiKMxINtZiLihMBgVc3/moCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

This looks much better now, but please see my comments inline.

On 25.06.2014 16:03, Pankaj Dubey wrote:
> Under "arm/mach-exynos" many files are using PMU register offsets.
> Since we have added support for accessing PMU base address via DT,
> now we can remove PMU mapping from exynosX_iodesc. Let's convert
> all these access using iomapped address.
> This will help us in removing static mapping of PMU base address
> as well as help in reducing dependency over machine header files.
> Thus helping for migration of PMU implementation from machine to
> driver folder which can be reused for ARM64 bsed SoC.

[snip]

> @@ -152,7 +142,7 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
>  {
>  	struct device_node *np;
>  	u32 val = 0x1;
> -	void __iomem *addr = EXYNOS_SWRESET;
> +	void __iomem *addr = NULL;

Instead of initializing this variable to NULL, pmu_base_addr +
EXYNOS_SWRESET could be used instead.

>  
>  	if (of_machine_is_compatible("samsung,exynos5440")) {
>  		u32 status;
> @@ -165,9 +155,9 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
>  		val = __raw_readl(addr);
>  
>  		val = (val & 0xffff0000) | (status & 0xffff);
> -	}
> -
> -	__raw_writel(val, addr);
> +		__raw_writel(val, addr);
> +	} else
> +		__raw_writel(val, pmu_base_addr + EXYNOS_SWRESET);

The above would allow this code to be left unchanged.

>  }
>  

[snip]

> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index f127c0c..519aefe 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -37,6 +37,9 @@
>  #include "regs-pmu.h"
>  #include "regs-sys.h"
>  
> +#define pmu_raw_writel(val, offset) \
> +		__raw_writel(val, pmu_base_addr + offset)

Please make this static inline.

> +
>  /**
>   * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
>   * @hwirq: Hardware IRQ signal of the GIC
> @@ -111,7 +114,7 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
>   */
>  void exynos_cpu_power_down(int cpu)
>  {
> -	__raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
> +	pmu_raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
>  }
>  
>  /**
> @@ -122,8 +125,8 @@ void exynos_cpu_power_down(int cpu)
>   */
>  void exynos_cpu_power_up(int cpu)
>  {
> -	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
> -		     EXYNOS_ARM_CORE_CONFIGURATION(cpu));
> +	pmu_raw_writel(S5P_CORE_LOCAL_PWR_EN,
> +			EXYNOS_ARM_CORE_CONFIGURATION(cpu));
>  }
>  
>  /**
> @@ -133,7 +136,7 @@ void exynos_cpu_power_up(int cpu)
>   */
>  int exynos_cpu_power_state(int cpu)
>  {
> -	return (__raw_readl(EXYNOS_ARM_CORE_STATUS(cpu)) &
> +	return (__raw_readl(pmu_base_addr + EXYNOS_ARM_CORE_STATUS(cpu)) &
>  			S5P_CORE_LOCAL_PWR_EN);

__raw_readl()s could be replaced with pmu_raw_readl()s too.

Best regards,
Tomasz
