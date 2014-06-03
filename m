Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaFCGdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:33:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15995 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbaFCGdk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:33:40 -0400
Date: Tue, 3 Jun 2014 14:31:13 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] ARM: berlin: add SMP support
Message-ID: <20140603143113.0b2aeb74@xhacker>
In-Reply-To: <1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
	<1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-02_02:2014-06-02,2014-06-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406030090
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

On Mon, 2 Jun 2014 02:21:02 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> Adds SMP support for Berlin SoCs. Secondary CPUs are reseted, then
> execute the instruction we put in the reset exception register, setting
> the pc at the address contained in the software reset address register,
> which is the physical address of the Berlin secondary startup.
> 
> This implementation avoid using the pen lock mechanism.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  arch/arm/mach-berlin/Kconfig   |  3 ++
>  arch/arm/mach-berlin/Makefile  |  3 +-
>  arch/arm/mach-berlin/headsmp.S | 30 +++++++++++++
>  arch/arm/mach-berlin/platsmp.c | 99
> ++++++++++++++++++++++++++++++++++++++++++ 4 files changed, 134
> insertions(+), 1 deletion(-) create mode 100644
> arch/arm/mach-berlin/headsmp.S create mode 100644
> arch/arm/mach-berlin/platsmp.c
> 
> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> index d3c5f14dc142..e3733692f67a 100644
> --- a/arch/arm/mach-berlin/Kconfig
> +++ b/arch/arm/mach-berlin/Kconfig
> @@ -4,6 +4,7 @@ config ARCH_BERLIN
>  	select GENERIC_IRQ_CHIP
>  	select DW_APB_ICTL
>  	select DW_APB_TIMER_OF
> +	select SMP
>  
>  if ARCH_BERLIN
>  
> @@ -13,6 +14,7 @@ config MACH_BERLIN_BG2
>  	bool "Marvell Armada 1500 (BG2)"
>  	select CACHE_L2X0
>  	select CPU_PJ4B
> +	select HAVE_ARM_SCU if SMP
>  	select HAVE_ARM_TWD if SMP
>  
>  config MACH_BERLIN_BG2CD
> @@ -24,6 +26,7 @@ config MACH_BERLIN_BG2Q
>  	bool "Marvell Armada 1500 Pro (BG2-Q)"
>  	select CACHE_L2X0
>  	select CPU_V7
> +	select HAVE_ARM_SCU if SMP
>  	select HAVE_ARM_TWD if SMP
>  	select HAVE_SMP
>  
> diff --git a/arch/arm/mach-berlin/Makefile b/arch/arm/mach-berlin/Makefile
> index ab69fe956f49..c0719ecd1890 100644
> --- a/arch/arm/mach-berlin/Makefile
> +++ b/arch/arm/mach-berlin/Makefile
> @@ -1 +1,2 @@
> -obj-y += berlin.o
> +obj-y			+= berlin.o
> +obj-$(CONFIG_SMP)	+= headsmp.o platsmp.o
> diff --git a/arch/arm/mach-berlin/headsmp.S b/arch/arm/mach-berlin/headsmp.S
> new file mode 100644
> index 000000000000..d295b5185598
> --- /dev/null
> +++ b/arch/arm/mach-berlin/headsmp.S
> @@ -0,0 +1,30 @@
> +/*
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +#include <asm/assembler.h>
> +
> +ENTRY(berlin_secondary_startup)
> + ARM_BE8(setend be)
> +	bl	v7_invalidate_l1
> +	b       secondary_startup
> +ENDPROC(berlin_secondary_startup)
> +
> +/*
> + * If the following instruction is set in the reset exception register,
> CPUs
> + * will fetch the value of the software reset address register when being
> + * reseted.
> + */
> +.global boot_inst
> +boot_inst:
> +	ldr	pc, [pc, #140]
> +
> +	.align
> diff --git a/arch/arm/mach-berlin/platsmp.c b/arch/arm/mach-berlin/platsmp.c
> new file mode 100644
> index 000000000000..c04c90b81ae3
> --- /dev/null
> +++ b/arch/arm/mach-berlin/platsmp.c
> @@ -0,0 +1,99 @@
> +/*
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/smp_plat.h>
> +#include <asm/smp_scu.h>
> +
> +#define CPU_RESET		0x00
> +
> +#define RESET_VECT		0x00
> +#define SW_RESET_ADDR		0x94
> +
> +extern void berlin_secondary_startup(void);
> +extern u32 boot_inst;
> +
> +static void __iomem *cpu_ctrl;
> +
> +static inline void berlin_reset_cpu(unsigned int cpu)
> +{
> +	u32 val;
> +
> +	val = readl(cpu_ctrl + CPU_RESET);
> +	val |= BIT(cpu_logical_map(cpu));
> +	writel(val, cpu_ctrl + CPU_RESET);

"writel(BIT(cpu_logical_map(cpu)), cpu_ctrl + CPU_RESET)" is enough.
we don't need to read and modify, because we writing 0 has no any effect.

> +}
> +
> +static int berlin_boot_secondary(unsigned int cpu, struct task_struct
> *idle) +{
> +	if (!cpu_ctrl)
> +		return -EFAULT;
> +
> +	/*
> +	 * Reset the CPU, making it to execute the instruction in the reset
> +	 * exception register.
> +	 */
> +	berlin_reset_cpu(cpu);
> +
> +	return 0;
> +}
> +
> +static void __init berlin_smp_prepare_cpus(unsigned int max_cpus)
> +{
> +	struct device_node *np;
> +	void __iomem *scu_base;
> +	void __iomem *vectors_base;
> +
> +	np = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
> +	scu_base = of_iomap(np, 0);
> +	of_node_put(np);
> +	if (!scu_base)
> +		return;
> +
> +	np = of_find_compatible_node(NULL, NULL,
> "marvell,berlin-cpu-ctrl");
> +	cpu_ctrl = of_iomap(np, 0);
> +	of_node_put(np);
> +	if (!cpu_ctrl)
> +		goto unmap_scu;
> +
> +	vectors_base = ioremap(CONFIG_VECTORS_BASE, SZ_32K);
> +	if (!vectors_base)
> +		goto unmap_scu;
> +
> +	scu_enable(scu_base);
> +	flush_cache_all();
> +
> +	/*
> +	 * Write the first instruction the CPU will execute after being
> reseted
> +	 * in the reset exception register.
> +	 */
> +	writel(boot_inst, vectors_base + RESET_VECT);

Is it better to let bootloader/firmware handle this writing. Then, we can
also remove the tricky boot_inst in headsmp.S.

Many thanks for this patch,
Jisheng

