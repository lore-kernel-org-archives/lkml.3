Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3HWKGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:06:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49097 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754661Ab3HWKGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:06:03 -0400
Message-ID: <52173408.1000702@free-electrons.com>
Date: Fri, 23 Aug 2013 12:06:00 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/17] ARM: mvebu: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-9-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376964271-22715-9-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 20/08/2013 04:04, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks.
> 

As a feared it won't work on Armada XP. You moved coherency_init(), and
l2x0_of_init() in the init_machine hook. However init_machine is an
arch_initcall, and as all the initcall it is called at the end of the
do_basic_setup() which is called after smp_prepare_cpus(). The issue is
that smp_prepare_cpus need coherency (and I think L2 cache) already enable.

Regards,

> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Notes:
> - coherency, mbus, and cache init are moved to .init_machine hook
> - time-armada-370-xp is converted to clocksource_of_init compatible init
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-mvebu/armada-370-xp.c      |   11 +----------
>  drivers/clocksource/time-armada-370-xp.c |    7 +++----
>  include/linux/time-armada-370-xp.h       |   16 ----------------
>  3 files changed, 4 insertions(+), 30 deletions(-)
>  delete mode 100644 include/linux/time-armada-370-xp.h
> 
> diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
> index 829b573..139f572 100644
> --- a/arch/arm/mach-mvebu/armada-370-xp.c
> +++ b/arch/arm/mach-mvebu/armada-370-xp.c
> @@ -14,11 +14,9 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> -#include <linux/clk-provider.h>
>  #include <linux/of_address.h>
>  #include <linux/of_platform.h>
>  #include <linux/io.h>
> -#include <linux/time-armada-370-xp.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/mbus.h>
>  #include <asm/hardware/cache-l2x0.h>
> @@ -34,19 +32,13 @@ static void __init armada_370_xp_map_io(void)
>  	debug_ll_io_init();
>  }
>  
> -static void __init armada_370_xp_timer_and_clk_init(void)
> +static void __init armada_370_xp_dt_init(void)
>  {
> -	of_clk_init(NULL);
> -	armada_370_xp_timer_init();
>  	coherency_init();
>  	BUG_ON(mvebu_mbus_dt_init());
>  #ifdef CONFIG_CACHE_L2X0
>  	l2x0_of_init(0, ~0UL);
>  #endif
> -}
> -
> -static void __init armada_370_xp_dt_init(void)
> -{
>  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>  }
>  
> @@ -59,7 +51,6 @@ DT_MACHINE_START(ARMADA_XP_DT, "Marvell Armada 370/XP (Device Tree)")
>  	.smp		= smp_ops(armada_xp_smp_ops),
>  	.init_machine	= armada_370_xp_dt_init,
>  	.map_io		= armada_370_xp_map_io,
> -	.init_time	= armada_370_xp_timer_and_clk_init,
>  	.restart	= mvebu_restart,
>  	.dt_compat	= armada_370_xp_dt_compat,
>  MACHINE_END
> diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
> index 847cab6..67904cf 100644
> --- a/drivers/clocksource/time-armada-370-xp.c
> +++ b/drivers/clocksource/time-armada-370-xp.c
> @@ -30,7 +30,6 @@
>  #include <linux/module.h>
>  #include <linux/sched_clock.h>
>  #include <linux/percpu.h>
> -#include <linux/time-armada-370-xp.h>
>  
>  /*
>   * Timer block registers.
> @@ -217,13 +216,11 @@ static struct notifier_block armada_370_xp_timer_cpu_nb = {
>  	.notifier_call = armada_370_xp_timer_cpu_notify,
>  };
>  
> -void __init armada_370_xp_timer_init(void)
> +void __init armada_370_xp_timer_init(struct device_node *np)
>  {
>  	u32 u;
> -	struct device_node *np;
>  	int res;
>  
> -	np = of_find_compatible_node(NULL, NULL, "marvell,armada-370-xp-timer");
>  	timer_base = of_iomap(np, 0);
>  	WARN_ON(!timer_base);
>  	local_base = of_iomap(np, 1);
> @@ -293,3 +290,5 @@ void __init armada_370_xp_timer_init(void)
>  	if (!res)
>  		armada_370_xp_timer_setup(this_cpu_ptr(armada_370_xp_evt));
>  }
> +CLOCKSOURCE_OF_DECLARE(armada_370_xp_timer, "marvell,armada-370-xp-timer",
> +		       armada_370_xp_timer_init);
> diff --git a/include/linux/time-armada-370-xp.h b/include/linux/time-armada-370-xp.h
> deleted file mode 100644
> index 6fb0856..0000000
> --- a/include/linux/time-armada-370-xp.h
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -/*
> - * Marvell Armada 370/XP SoC timer handling.
> - *
> - * Copyright (C) 2012 Marvell
> - *
> - * Lior Amsalem <alior@marvell.com>
> - * Gregory CLEMENT <gregory.clement@free-electrons.com>
> - * Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> - *
> - */
> -#ifndef __TIME_ARMADA_370_XPPRCMU_H
> -#define __TIME_ARMADA_370_XPPRCMU_H
> -
> -void armada_370_xp_timer_init(void);
> -
> -#endif
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
