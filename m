Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3EaLZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:25:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EaLZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:25:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Neil Zhang <zhangwm@marvell.com>, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
Date: Fri, 31 May 2013 13:24:59 +0200
Message-ID: <1726105.oKcjXShr89@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1369969115-4279-2-git-send-email-zhangwm@marvell.com>
References: <1369969115-4279-1-git-send-email-zhangwm@marvell.com> <1369969115-4279-2-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RC1eMljwVTnrMaYeoPQ4UlzkIKRk+T3FITIK4nFJca8
 Jz6lEu2Ek6+UfuLQUl3Vc0qaNNoowfy/86rbcJRHD+yZ+DSbdt
 7EXVebjjdd3b0ASi9byLFKG84q5fcNnD/ZOxcsZgF0Y8E3W6IW
 R82FtEa8EwRk3OHikTgIr57QFaav1zKrakOfBvE/KrrdMBk+fy
 uzRbGH89s5DuXMG+e+YtJD8okw4VbVoqvUuFnWEMXSv145DUWi
 0OPpBY0eykAjwqu7bZzGqZJ2/fNG8m1071LnHIX8vLp4Z6gH1m
 HEkeRWDmu1hadSFzKBlKtUUjJncwUuh6+vW06p6A7Ldxfhx3oR
 XVFMIVssQt87wupgziks=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 10:58:35 Neil Zhang wrote:
> bring up pxa988 with device tree support.
> 
> Change-Id: I6fc869b7d5ff8dc6e4eb0042a89429200f7a9fb1

Please don't post silly extra headers like that.

> Signed-off-by: Neil Zhang <zhangwm@marvell.com>

A couple of comments on the DT structure:

> +	gic: interrupt-controller@d1dfe100 {
> +		compatible = "arm,cortex-a9-gic";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		reg = <0xd1dff000 0x1000>,
> +		      <0xd1dfe100 0x0100>;
> +	};
> +
> +	L2: l2-cache-controller@d1dfb000 {
> +		compatible = "arm,pl310-cache";
> +		reg = <0xd1dfb000 0x1000>;
> +		arm,data-latency = <2 1 1>;
> +		arm,tag-latency = <2 1 1>;
> +		arm,pwr-dynamic-clk-gating;
> +		arm,pwr-standby-mode;
> +		cache-unified;
> +		cache-level = <2>;
> +	};
> +
> +	local-timer@d1dfe600 {
> +		compatible = "arm,cortex-a9-twd-timer";
> +		reg = <0xd1dfe600 0x20>;
> +		interrupts = <1 13 0x304>;
> +	};

Why are these all top-level devices, rather than part of the
'soc' node?

> +	soc {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		compatible = "simple-bus";
> +		interrupt-parent = <&gic>;
> +		ranges;
> +
> +		axi@d4200000 {	/* AXI */
> +			compatible = "mrvl,axi-bus", "simple-bus";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			reg = <0xd4200000 0x00200000>;
> +			ranges;
> +
> +			intc: wakeupgen@d4282000 {
> +				compatible = "mrvl,mmp-intc";
> +				reg = <0xd4282000 0x1000>;
> +				mrvl,intc-wakeup = <0x114 0x3
> +						    0x144 0x3>;
> +			};
> +
> +		};

What is a 'mrvl,axi-bus'? Is that different from ARM's AXI bus?

The documented vendor prefix for Marvell is 'marvell', not 'mrvl',
please be consistent with that.

What is the purpose of the 'reg' property in the axi bus? I notice
that it overlaps with its own children, wich seens very strange.
Maybe you meant this:

	axi {
		ranges = <0xd4200000 0xd4200000 0x00200000>;
		...
	};

> +		apb@d4000000 {	/* APB */
> +			compatible = "mrvl,apb-bus", "simple-bus";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			reg = <0xd4000000 0x00200000>;
> +			ranges;

Same comments apply here.

> diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
> index ebdda83..0955191 100644
> --- a/arch/arm/mach-mmp/Kconfig
> +++ b/arch/arm/mach-mmp/Kconfig
> @@ -107,6 +107,16 @@ config MACH_MMP2_DT
>  	  Include support for Marvell MMP2 based platforms using
>  	  the device tree.
>  
> +config MACH_MMPX_DT
> +	bool "Support no-PJ/PJ4(ARMv7) platforms from device tree"
> +	depends on !CPU_MOHAWK && !CPU_PJ4
> +	select CPU_PXA988
> +	select USE_OF
> +	select PINCTRL
> +	select PINCTRL_SINGLE

Why would this be mutually exclusive with PJ4? Cortex-A9 and PJ4
are both ARMv7 based, so we should be able to have them in the
same kernel.

> +	help
> +	  Include support for Marvell MMP2 based platforms using
> +	  the device tree.
>  endmenu

You should probably change the help texts to say different things
here, e.g. list the models supported under these.

> diff --git a/arch/arm/mach-mmp/common.c b/arch/arm/mach-mmp/common.c
> index 9292b79..0c621bc 100644
> --- a/arch/arm/mach-mmp/common.c
> +++ b/arch/arm/mach-mmp/common.c
> @@ -11,6 +11,10 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/of_address.h>
>  
>  #include <asm/page.h>
>  #include <asm/mach/map.h>
> @@ -36,7 +40,12 @@ static struct map_desc standard_io_desc[] __initdata = {
>  		.virtual	= (unsigned long)AXI_VIRT_BASE,
>  		.length		= AXI_PHYS_SIZE,
>  		.type		= MT_DEVICE,
> -	},
> +	}, {
> +		.pfn		= __phys_to_pfn(MMP_CORE_PERIPH_PHYS_BASE),
> +		.virtual	= (unsigned long)MMP_CORE_PERIPH_VIRT_BASE,
> +		.length		= MMP_CORE_PERIPH_PHYS_SIZE,
> +		.type		= MT_DEVICE,
> +	}
>  };
>  
>  void __init mmp_map_io(void)

What is this needed for?

> +/* PXA988 */
> +static const struct of_dev_auxdata pxa988_auxdata_lookup[] __initconst = {
> +	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
> +	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
> +	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2", NULL),
> +	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
> +	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1", NULL),
> +	OF_DEV_AUXDATA("mrvl,mmp-gpio", 0xd4019000, "pxa-gpio", NULL),
> +	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
> +	{}
> +};

Why do you need auxdata?

> +void __init pxa988_dt_init_timer(void)
> +{
> +	extern void __init mmp_dt_init_timer(void);

You should never put 'extern' declarations into a .c file.

> +	/*
> +	 * Is is a SOC timer, and will be used for broadcasting
> +	 * when local timers are disabled.
> +	 */
> +	mmp_dt_init_timer();
> +
> +	clocksource_of_init();
> +}

Please just change the mmp_dt_init_timer function to use
CLOCKSOURCE_OF_DECLARE(), and if possible move the file to
drivers/clocksource.

> +static const char *pxa988_dt_board_compat[] __initdata = {
> +	"mrvl,pxa988-dkb",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(PXA988_DT, "Marvell PXA988 (Device Tree Support)")
> +	.smp		= smp_ops(mmp_smp_ops),
> +	.map_io		= mmp_map_io,
> +	.init_irq	= irqchip_init,

You can leave out the init_irq, it's implicit.

> +	.init_time	= pxa988_dt_init_timer,
> +	.init_machine	= pxa988_dt_init_machine,
> +	.dt_compat	= pxa988_dt_board_compat,
> +MACHINE_END


> +
> +static int __init mmp_entry_vector_init(void)
> +{
> +	int cpu;
> +
> +	/* We will reset from DDR directly by default */
> +	writel(__pa(mmp_cpu_reset_entry), CIU_CA9_WARM_RESET_VECTOR);
> +
> +	for (cpu = 1; cpu < CONFIG_NR_CPUS; cpu++)
> +		mmp_set_entry_vector(cpu, __pa(mmp_secondary_startup));
> +}
> +
> +early_initcall(mmp_entry_vector_init);

You need to check which machine you are running on here. Best just move
the call into one of the init functions of the machine descriptor,
e.g. init_machine or init_late.

CONFIG_NR_CPUS is probably the wrong constant to use here, it does
not have to match the physically present CPU cores.

	Arnd
