Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbaDPTFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:05:45 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:39444 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbaDPTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:05:42 -0400
Message-ID: <534ED481.1020909@gmail.com>
Date: Wed, 16 Apr 2014 21:05:37 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
CC: Russell King <linux@arm.linux.org.uk>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: berlin: add SMP support
References: <1395347986-30203-1-git-send-email-sebastian.hesselbarth@gmail.com> <1395347986-30203-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1395347986-30203-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 09:39 PM, Sebastian Hesselbarth wrote:
> This adds SMP support to Marvell Berlin2 SoCs. Secondary CPUs boot into
> BootROM, wait for interrupt, and read SW generic register 1 with actual
> boot code address. Synchronization by holding pen is copied from
> plat-versatile and mach-prima2.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---

I'll postpone this one until we are clear how to proceed with
non-holding pen SMP.

Sebastian

> ---
>  arch/arm/mach-berlin/Kconfig   |   1 +
>  arch/arm/mach-berlin/Makefile  |   1 +
>  arch/arm/mach-berlin/berlin.c  |   3 +
>  arch/arm/mach-berlin/common.h  |  18 ++++++
>  arch/arm/mach-berlin/headsmp.S |  43 +++++++++++++
>  arch/arm/mach-berlin/platsmp.c | 139 +++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 205 insertions(+)
>  create mode 100644 arch/arm/mach-berlin/common.h
>  create mode 100644 arch/arm/mach-berlin/headsmp.S
>  create mode 100644 arch/arm/mach-berlin/platsmp.c
> 
> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> index 7a02d222c378..eecec99c3096 100644
> --- a/arch/arm/mach-berlin/Kconfig
> +++ b/arch/arm/mach-berlin/Kconfig
> @@ -15,6 +15,7 @@ config MACH_BERLIN_BG2
>  	bool "Marvell Armada 1500 (BG2)"
>  	select CACHE_L2X0
>  	select CPU_PJ4B
> +	select HAVE_ARM_SCU if SMP
>  	select HAVE_ARM_TWD if SMP
>  	select HAVE_SMP
>  
> diff --git a/arch/arm/mach-berlin/Makefile b/arch/arm/mach-berlin/Makefile
> index ab69fe956f49..e11b1b0be4dd 100644
> --- a/arch/arm/mach-berlin/Makefile
> +++ b/arch/arm/mach-berlin/Makefile
> @@ -1 +1,2 @@
>  obj-y += berlin.o
> +obj-$(CONFIG_SMP)	+= platsmp.o headsmp.o
> diff --git a/arch/arm/mach-berlin/berlin.c b/arch/arm/mach-berlin/berlin.c
> index 025bcb5473eb..1bbca793174d 100644
> --- a/arch/arm/mach-berlin/berlin.c
> +++ b/arch/arm/mach-berlin/berlin.c
> @@ -18,6 +18,8 @@
>  #include <asm/hardware/cache-l2x0.h>
>  #include <asm/mach/arch.h>
>  
> +#include "common.h"
> +
>  static void __init berlin_init_machine(void)
>  {
>  	/*
> @@ -36,4 +38,5 @@ static const char * const berlin_dt_compat[] = {
>  DT_MACHINE_START(BERLIN_DT, "Marvell Berlin")
>  	.dt_compat	= berlin_dt_compat,
>  	.init_machine	= berlin_init_machine,
> +	.smp		= smp_ops(berlin_smp_ops),
>  MACHINE_END
> diff --git a/arch/arm/mach-berlin/common.h b/arch/arm/mach-berlin/common.h
> new file mode 100644
> index 000000000000..57c97669af0a
> --- /dev/null
> +++ b/arch/arm/mach-berlin/common.h
> @@ -0,0 +1,18 @@
> +/*
> + * Marvell Berlin SoCs common include.
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __ARCH_BERLIN_COMMON_H
> +#define __ARCH_BERLIN_COMMON_H
> +
> +extern void berlin_secondary_startup(void);
> +
> +extern struct smp_operations berlin_smp_ops;
> +
> +#endif
> diff --git a/arch/arm/mach-berlin/headsmp.S b/arch/arm/mach-berlin/headsmp.S
> new file mode 100644
> index 000000000000..bd187257fefd
> --- /dev/null
> +++ b/arch/arm/mach-berlin/headsmp.S
> @@ -0,0 +1,43 @@
> +/*
> + * linux/arch/arm/mach-berlin/headsmp.S
> + *
> + * Based on linux/arch/arm/mach-prima2/headsmp.S
> + *
> + * Copyright (c) 2003 ARM Limited
> + * All Rights Reserved
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +#include <asm/assembler.h>
> +
> +/*
> + * Entry point for secondary CPUs, this provides a "holding pen" into which
> + * all secondary cores are held until we're ready for them to initialise.
> + */
> +ENTRY(berlin_secondary_startup)
> + ARM_BE8(setend be)
> +	bl	v7_invalidate_l1
> +	mrc	p15, 0, r0, c0, c0, 5
> +	and	r0, r0, #15
> +	adr	r4, 1f
> +	ldmia	r4, {r5, r6}
> +	sub	r4, r4, r5
> +	add	r6, r6, r4
> +pen:	ldr	r7, [r6]
> +	cmp	r7, r0
> +	bne	pen
> +
> +	/*
> +	 * we've been released from the holding pen: secondary_stack
> +	 * should now contain the SVC stack for this core
> +	 */
> +	b	secondary_startup
> +ENDPROC(berlin_secondary_startup)
> +
> +	.align
> +1:	.long	.
> +	.long	pen_release
> diff --git a/arch/arm/mach-berlin/platsmp.c b/arch/arm/mach-berlin/platsmp.c
> new file mode 100644
> index 000000000000..5c83941b0918
> --- /dev/null
> +++ b/arch/arm/mach-berlin/platsmp.c
> @@ -0,0 +1,139 @@
> +/*
> + * linux/arch/arm/mach-berlin/platsmp.c
> + *
> + * Based on linux/arch/arm/plat-versatile/platsmp.c
> + *
> + * Copyright (C) 2002 ARM Ltd.
> + * All Rights Reserved
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/io.h>
> +#include <linux/jiffies.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/smp.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/smp_plat.h>
> +#include <asm/smp_scu.h>
> +
> +#include "common.h"
> +
> +/*
> + * Write pen_release in a way that is guaranteed to be visible to all
> + * observers, irrespective of whether they're taking part in coherency
> + * or not.  This is necessary for the hotplug code to work reliably.
> + */
> +static void write_pen_release(int val)
> +{
> +	pen_release = val;
> +	/* write and flush pen_release to memory */
> +	smp_wmb();
> +	sync_cache_w(&pen_release);
> +}
> +
> +static DEFINE_SPINLOCK(boot_lock);
> +
> +static void berlin_secondary_init(unsigned int cpu)
> +{
> +	/*
> +	 * let the primary processor know we're out of the
> +	 * pen, then head off into the C entry point
> +	 */
> +	write_pen_release(-1);
> +
> +	/*
> +	 * Synchronise with the boot thread.
> +	 */
> +	spin_lock(&boot_lock);
> +	spin_unlock(&boot_lock);
> +}
> +
> +static int berlin_boot_secondary(unsigned int cpu, struct task_struct *idle)
> +{
> +	unsigned long timeout;
> +
> +	/*
> +	 * Set synchronisation state between this boot processor
> +	 * and the secondary one
> +	 */
> +	spin_lock(&boot_lock);
> +
> +	/*
> +	 * This is really belt and braces; we hold unintended secondary
> +	 * CPUs in the holding pen until we're ready for them.  However,
> +	 * since we haven't sent them a soft interrupt, they shouldn't
> +	 * be there.
> +	 */
> +	write_pen_release(cpu_logical_map(cpu));
> +
> +	/*
> +	 * Send the secondary CPU a soft interrupt, thereby causing
> +	 * the boot monitor to read the system wide flags register,
> +	 * and branch to the address found there.
> +	 */
> +	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
> +
> +	timeout = jiffies + (1 * HZ);
> +	while (time_before(jiffies, timeout)) {
> +		/* pen_release SMP read barrier */
> +		smp_rmb();
> +		if (pen_release == -1)
> +			break;
> +
> +		udelay(10);
> +	}
> +
> +	/*
> +	 * now the secondary core is starting up let it run its
> +	 * calibrations, then wait for it to finish
> +	 */
> +	spin_unlock(&boot_lock);
> +
> +	return pen_release != -1 ? -ENOSYS : 0;
> +}
> +
> +static void __init berlin_smp_prepare_cpus(unsigned int max_cpus)
> +{
> +	struct device_node *np;
> +	void __iomem *scu_base;
> +	void __iomem *gpr_base;
> +
> +	np = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
> +	scu_base = of_iomap(np, 0);
> +	of_node_put(np);
> +	if (!scu_base)
> +		return;
> +
> +	np = of_find_compatible_node(NULL, NULL, "marvell,berlin-generic-regs");
> +	gpr_base = of_iomap(np, 0);
> +	of_node_put(np);
> +	if (!gpr_base) {
> +		iounmap(scu_base);
> +		return;
> +	}
> +
> +	/*
> +	 * Enable SCU and write the address of secondary startup into the
> +	 * global SW generic register 1. The secondary CPU waits for an
> +	 * interrupt and then branches to the address stored in the SW
> +	 * generic register 1.
> +	 */
> +	scu_enable(scu_base);
> +	writel(virt_to_phys(berlin_secondary_startup), gpr_base + 0x04);
> +	iounmap(scu_base);
> +	iounmap(gpr_base);
> +}
> +
> +struct smp_operations berlin_smp_ops __initdata = {
> +	.smp_prepare_cpus	= berlin_smp_prepare_cpus,
> +	.smp_secondary_init	= berlin_secondary_init,
> +	.smp_boot_secondary	= berlin_boot_secondary,
> +};
> 

