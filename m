Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab3EONR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:17:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63173 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab3EONRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:17:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
Date: Wed, 15 May 2013 15:16:52 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com> <201303181503.49491.arnd@arndb.de> <CACmBeS1empYyoaKidgTrYwUFCw447OKndxZjT98TvYfKVWB00A@mail.gmail.com>
In-Reply-To: <CACmBeS1empYyoaKidgTrYwUFCw447OKndxZjT98TvYfKVWB00A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305151516.52389.arnd@arndb.de>
X-Provags-ID: V02:K0:sPymFKP5j5vAixEfXW3zguO3/LKrXMME/Q3SfMJhUYL
 PEpfE+JRj3MQ6f6n5Wa/MNUqmpSrQeUgC46VgFwrB/sNy6NoqT
 cdFE6TPhLd4g34bSJ7nYc1VFfUYrhiB9z4LAe1i6XKKOjAFnf4
 M1KhoLi7y/uoN6CqCDYchrG1TxCqX+oDiPYPL8RZSSrg+3VmUx
 WrZv72ESPO2MfCdPRLBfah/Ep+rPx0Ie9y/90TpubVWg43ei/R
 8u7YPfuHa6LkEVJlw17NjuVW8qEA2+lzElxklnXuki+zfsybRh
 Bfg37BsZMofuWRqv+LmHRSB08oOqt9qqlb/VGj6snKkZ2Npjmr
 Jwh4jiQJBSyaGtX4NbCg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 May 2013, Jonas Jensen wrote:
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 29f7623..d534fce 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -429,6 +429,15 @@ choice
>  		  Say Y here if you want kernel low-level debugging support
>  		  on Allwinner A1X based platforms on the UART1.
> 
> +	config DEBUG_MOXART_UART0
> +        bool "Kernel low-level debugging messages via MOXART UART0"
> +        depends on ARCH_MOXART
> +        help
> +          Say Y here if you want kernel low-level debugging support
> +          on MOXART based platforms on the UART0.
> +          select this to make sure "putc" in arch/arm/boot/compressed/debug.S
> +          uses arch/arm/include/debug/moxart.S:s "addruart" macro
> +
>  	config DEBUG_TEGRA_UART
>  		depends on ARCH_TEGRA
>  		bool "Use Tegra UART for low-level debug"
> @@ -651,6 +660,7 @@ config DEBUG_LL_INCLUDE
>  	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
>  	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
>  	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
> +	default "debug/moxart.S" if DEBUG_MOXART_UART0
>  	default "debug/tegra.S" if DEBUG_TEGRA_UART
>  	default "debug/ux500.S" if DEBUG_UX500_UART
>  	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT || \

Please split this patch into separate patches. All the debug stuff can go into
one patch that is fairly separate from the rest. You can probably find a few
other things that can be split out, just make sure that the order is so that
we don't have a broken source tree when only applying a few of them.

You can use git-format-patch and git-send-email to send out a series properly.
> +
> +		intc: interrupt-controller@98800000 {
> +			compatible = "moxart,moxart-interrupt-controller";
> +			reg = <0x98800000 0x38>;
> +			interrupt-controller;
> +			#interrupt-cells = <2>;
> +			interrupt-mask = <0x00080000>;		/* single register vector,
> interrupts 0-31, 1s signify edge */
> +		};

That will also take care of broken line wrapping as above. The current version can not
be applied.

> +		timer0: timer@98400000 {
> +			compatible = "moxart,moxart-timer0";
> +			reg = <0x98400000 0x10>;
> +			interrupts = <19 1>;
> +		};

"moxart,moxart-timer0" is a strange identifier for a device. First of all, all your
compatible strings should probably start with "moxa," rather than "moxart,".

The part that I don't understand at all is the "timer0" part. Is that a string
from the data sheet?

> +		gpio: gpio@98700000 {
> +			compatible = "moxart,moxart-gpio";
> +			reg =	<0x98700000 0x1000>,
> +					<0x98100000 0x1000>;		/* PMU */
> +		};

Can you provide some more detail why what PMU registers are used here? Is that
a "Performance Measurement Unit", "Power Management Unit" or something else?
Are you sure that those registers are only ever needed for GPIO?

> @@ -0,0 +1,34 @@
> +config ARCH_MOXART
> +	bool "MOXA ART SoC" if (ARCH_MULTI_V4)
> +	select ARCH_REQUIRE_GPIOLIB
> +	select USE_OF
> +	help
> +	  Say Y here if you want to run your kernel on hardware
> +	  with a MOXA ART SoC.
> +	  These are DIN-rail / wall-mountable embedded PCs sold by MOXA.
> +	  http://www.moxa.com/product/Embedded_Computers.htm
> +
> +config SOC_MOXART
> +	bool "MOXART support"
> +	depends on ARCH_MOXART
> +	default y
> +	select CPU_FA526
> +	select ARM_DMA_MEM_BUFFERABLE
> +	help
> +	  Support for the MOXA ART SoC. This is a Faraday FA526 ARMv4 32-bit
> 192 MHz processor with MMU and 16KB/8KB D/I-cache (UC-7112-LX)
> +	  This perticular SoC is used on models UC-7101, UC-7112/UC-7110,
> IA240/IA241, IA3341.
> +	  These are DIN-rail / wall-mountable embedded PCs sold by MOXA (
> http://www.moxa.com/product/Embedded_Computers.htm ).
> +
> +if ARCH_MOXART
> +
> +menu "MOXA ART SoC Implementation"
> +
> +config MACH_UC7112LX
> +	bool "MOXA UC-7112-LX"
> +	depends on ARCH_MOXART && SOC_MOXART
> +	help
> +	  Say Y here if you intend to run this kernel on a MOXA UC-7112-LX
> embedded computer.

There should be no need for three separate symbols here. Just fold it
all into ARCH_MOXART. Note that you messed up the line wrapping above,
so that should be fixed. Hopefully the UC-7112-LX specific portions
can remain small to nonexisting so we don't have a need to make that
a separate option.

> +
> +ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include

Just leave this out and move all header files into the arch/arm/mach-moxart/
directory directly.

> diff --git a/arch/arm/mach-moxart/Makefile.boot
> b/arch/arm/mach-moxart/Makefile.boot
> new file mode 100644
> index 0000000..760a0ef
> --- /dev/null
> +++ b/arch/arm/mach-moxart/Makefile.boot
> @@ -0,0 +1,3 @@
> +   zreladdr-y	+= 0x00008000
> +params_phys-y	:= 0x00000100
> +initrd_phys-y	:= 0x00800000

Is this still used?

> diff --git a/arch/arm/mach-moxart/idle.c b/arch/arm/mach-moxart/idle.c
> new file mode 100644
> index 0000000..5970c27
> --- /dev/null
> +++ b/arch/arm/mach-moxart/idle.c

> +static void moxart_idle(void)
> +{
> +	/*
> +	 * Because of broken hardware we have to enable interrupts or the CPU
> +	 * will never wakeup... Acctualy it is not very good to enable
> +	 * interrupts first since scheduler can miss a tick, but there is
> +	 * no other way around this. Platforms that needs it for power saving
> +	 * should call enable_hlt() in init code, since by default it is
> +	 * disabled.
> +	 */
> +/*	local_irq_enable();
> +	cpu_do_idle();*/
> +}
> +
> +static int __init moxart_idle_init(void)
> +{
> +	arm_pm_idle = moxart_idle;
> +	return 0;
> +}
> +
> +arch_initcall(moxart_idle_init);

This does not seem to do anything at this point. Does the comment still
apply?

> +
> +static void __init moxart_init(void)
> +{
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}
> +
> +void moxart_restart(char mode, const char *cmd)
> +{
> +	writel(1, reg_wdt + 4);
> +	writel(0x5ab9, reg_wdt + 8);
> +	writel(0x03, reg_wdt + 12);
> +}
> +
> +static const char * const moxart_board_dt_compat[] = {
> +	"moxart,moxart-uc-7112-lx",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(MOXART, "MOXA UC-7112-LX")
> +	.init_irq		= moxart_init_irq,
> +	.init_time		= moxart_timer_init,
> +	.init_machine	= moxart_init,
> +	.handle_irq		= moxart_handle_irq,
> +	.restart        = moxart_restart,
> +	.dt_compat		= moxart_board_dt_compat,
> +	.nr_irqs		= 32,
> +MACHINE_END

You can leave out moxart_init() now, it's the default implementation.
moxart_init_irq, moxart_handle_irq and nr_irqs should be obsolete if
you did the irqchip driver correctly, same for moxart_timer_init and
the clocksource driver.

I think the only part remaining here is moxart_restart, but that is
broken as long as reg_wdt does not get initialized. I think you could
move that function into the watchdog driver and assign it to 
arm_pm_restart when you add that driver.

That would in fact make moxart the first platform that can run without
any platform specific code whatsoever.

	Arnd
