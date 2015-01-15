Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbbAOI5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:57:15 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:30463 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbbAOI5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:57:14 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
CC: Boris Brezillon <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/6] ARM: at91: pm: use the mmio-sram pool to access SRAM
Thread-Topic: [PATCH 2/6] ARM: at91: pm: use the mmio-sram pool to access
 SRAM
Thread-Index: AQHQLq6UUutUpe8zt0StjolHVDneipzA4xSQ
Date: Thu, 15 Jan 2015 08:53:54 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFCDFFBB@penmbx01>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421097825-396-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421097825-396-3-git-send-email-alexandre.belloni@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre

> -----Original Message-----
> From: linux-arm-kernel [mailto:linux-arm-kernel-bounces@lists.infradead.org] On
> Behalf Of Alexandre Belloni
> Sent: Tuesday, January 13, 2015 5:24 AM
> To: Ferre, Nicolas
> Cc: Boris Brezillon; Alexandre Belloni; Jean-Christophe Plagniol-Villard; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: [PATCH 2/6] ARM: at91: pm: use the mmio-sram pool to access SRAM
> 
> Now that the SRAM is part of a genpool, use it to allocate memory to use for the
> slowclock implementation.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/mach-at91/Kconfig |  1 +
>  arch/arm/mach-at91/pm.c    | 46
> +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig index
> cec0fb5d621a..b7dcef50db23 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -178,6 +178,7 @@ comment "AT91 Feature Selections"
> 
>  config AT91_SLOW_CLOCK
>  	bool "Suspend-to-RAM disables main oscillator"
> +	select SRAM
Can we move it under config ARCH_AT91 or other place?

It may be used for other purposes, more than pm. I thinks

>  	depends on SUSPEND
>  	help
>  	  Select this if you want Suspend-to-RAM to save the most power diff --git
> a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c index
> 79aa793d1f00..515791edcc60 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -14,10 +14,12 @@
>  #include <linux/suspend.h>
>  #include <linux/sched.h>
>  #include <linux/proc_fs.h>
> +#include <linux/genalloc.h>
>  #include <linux/interrupt.h>
>  #include <linux/sysfs.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_platform.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/clk/at91_pmc.h>
> @@ -222,10 +224,52 @@ void at91_pm_set_standby(void (*at91_standby)(void))
>  	}
>  }
> 
> +#ifdef CONFIG_AT91_SLOW_CLOCK
> +static void __init at91_pm_sram_init(void) {
> +	struct gen_pool *sram_pool;
> +	phys_addr_t sram_pbase;
> +	unsigned long sram_base;
> +	struct device_node *node;
> +	struct platform_device *pdev;
> +
> +	node = of_find_compatible_node(NULL, NULL, "mmio-sram");
> +	if (!node) {
> +		pr_warn("%s: failed to find sram node!\n", __func__);
> +		return;
> +	}
> +
> +	pdev = of_find_device_by_node(node);
> +	if (!pdev) {
> +		pr_warn("%s: failed to find sram device!\n", __func__);
> +		goto put_node;
> +	}
> +
> +	sram_pool = dev_get_gen_pool(&pdev->dev);
> +	if (!sram_pool) {
> +		pr_warn("%s: sram pool unavailable!\n", __func__);
> +		goto put_node;
> +	}
> +
> +	sram_base = gen_pool_alloc(sram_pool, at91_slow_clock_sz);
> +	if (!sram_base) {
> +		pr_warn("%s: unable to alloc ocram!\n", __func__);
> +		goto put_node;
> +	}
> +
> +	sram_pbase = gen_pool_virt_to_phys(sram_pool, sram_base);
> +	slow_clock = __arm_ioremap_exec(sram_pbase, at91_slow_clock_sz,
> +false);
> +
> +put_node:
> +	of_node_put(node);
> +}
> +#endif
> +
> +
>  static int __init at91_pm_init(void)
>  {
>  #ifdef CONFIG_AT91_SLOW_CLOCK
> -	slow_clock = (void *) (AT91_IO_VIRT_BASE - at91_slow_clock_sz);
> +	at91_pm_sram_init();
>  #endif
> 
>  	pr_info("AT91: Power Management%s\n", (slow_clock ? " (with slow clock
> mode)" : ""));
> --
> 2.1.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Best Regards,
Wenyou Yang
