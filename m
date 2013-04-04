Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3DDLMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:12:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab3DDLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:12:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
Date: Thu, 4 Apr 2013 11:12:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Tang <dt.tangr@gmail.com>, linux@arm.linux.org.uk,
        fabian@ritter-vogt.de, Lionel Debroux <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com>
In-Reply-To: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304041112.25780.arnd@arndb.de>
X-Provags-ID: V02:K0:I+esKo8GizQUgMGP1FSPHN2kSArNhK1nBuNhi5ecC2q
 OKM+bZPuavXETv0GPv3qAWe6w4XlmcTJSN0kgOoxSW8UR903mZ
 yTk9oF9+jC5AVyyF80r08Ts8Ajtsd1oXe94XcFrhM2cIo/U6yU
 g9Y/fa1kzvRJ0I2lMBPVmtPIgtKlejBi4CwUYR1IOFRzWwg9sb
 cJj/VuOv9Jppf5/4hJXAJQF7SwRKIUt/bmSFfO2fsTrPrKHe/a
 YrJXLXvcaEzjA0qvA0sM9Cxoo2ZQqox9H5oySA8jyArlGxYAcS
 oO6tsPmz7/EO+mobGQJ2RFHfvfCtWDR0yQplWJ7k7IG5O57Dvo
 /XZ8VUaFyDQc2g6s0iEA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 April 2013, Daniel Tang wrote:
> We're sending out for comments an early patch adding TI-Nspire support
> to Linux.
> 
> Some words on the Nspire platform: it's a series of graphing
> calculators, made of four models: "Clickpad" (2007-2010), "Touchpad"
> (2010-2012?), "CX" (2011-), "CM-C" (2011-).

Very cool! I hope we can get this merged.

> Patch contents
> --------------
> This patch (against mainline, but it also applies to linux-next)
> contains the essential support code required to boot Linux to a shell 
> on all models, but contains nothing else at the moment.
> Code containing drivers for other peripherals exists, and will
> eventually be posted for review as well: we need to do a bit of
> cleanup. If you prefer them to be posted here now, we'll do.
> They're at https://github.com/tangrs/linux .
> 
> A possibly noteworthy fact is that despite the gradual shift to
> using Device Tree definitions for ARM machine types, we've decided not
> to use it, for the following reasons:
> 
>     * the (perceived) extra complexity and code size;
>     * the fact that we're using our own, simple, bootloader, due to
>       the impossibility to bootstrap on most models (because boot1
>       is usually not modifiable) and the fact that the image is stored
>       in a proprietary FS not supported by mainline Linux and
>       common bootloaders...

For new platforms, we want to have only the absolute minimum amount of
code in arch/arm and move everything else into drivers. However, that
is only possible using device tree. It should not add any significant
complexity to your code, and you can easily bundle the device tree blob
with the kernel.
> 
> +config ARCH_NSPIRE
> +	bool "TI-NSPIRE based"
> +	depends on MMU
> +	select CPU_ARM926T
> +	select HAVE_MACH_CLKDEV
> +	select CLKDEV_LOOKUP
> +	select ARM_AMBA
> +	select USB_ARCH_HAS_EHCI
> +	select ARCH_WANT_OPTIONAL_GPIOLIB
> +	select GENERIC_ALLOCATOR
> +	select ARCH_HAS_CPUFREQ
> +	select CPU_FREQ_TABLE

Any new platform should use COMMON_CLK and SPARSE_IRQ in addition
to these.

> diff --git a/arch/arm/mach-nspire/Kconfig b/arch/arm/mach-nspire/Kconfig
> new file mode 100644
> index 0000000..da032b7
> --- /dev/null
> +++ b/arch/arm/mach-nspire/Kconfig
> @@ -0,0 +1,36 @@
> +if ARCH_NSPIRE
> +
> +choice
> +	prompt "Early printk and boot message serial interface"
> +	help
> +	  Early printk output interface
> +	depends on EARLY_PRINTK
> +	default NSPIRE_EARLYPRINTK_CX
> +
> +config NSPIRE_EARLYPRINTK_CLASSIC
> +	bool "Classic"
> +
> +config NSPIRE_EARLYPRINTK_CX
> +	bool "CX model"
> +endchoice

This should go into arch/arm/Kconfig.debug.

> +
> +menu "Supported models"
> +
> +config MACH_NSPIRECX
> +	select GENERIC_CLOCKEVENTS
> +	select ARM_VIC
> +	select ARM_TIMER_SP804
> +	bool "CX/CX CAS"

The SP804 driver is currently being changed in the move to drivers/clocksource,
which may impact your code as well.

> diff --git a/arch/arm/mach-nspire/Makefile.boot b/arch/arm/mach-nspire/Makefile.boot
> new file mode 100644
> index 0000000..7db966b
> --- /dev/null
> +++ b/arch/arm/mach-nspire/Makefile.boot
> @@ -0,0 +1 @@
> +zreladdr-y	:= 0x10008000

Please use AUTO_ZRELADDR

> +static unsigned long classic_clocks_to_io(struct nspire_clk_speeds *clks)
> +{
> +	union reg_clk_speed reg;
> +
> +	BUG_ON(clks->div.base_cpu < 2);
> +	BUG_ON(clks->div.cpu_ahb < 1);
> +
> +	reg.raw = 0;
> +	reg.val.base_cpu_ratio = clks->div.base_cpu / 2;
> +	reg.val.cpu_ahb_ratio = clks->div.cpu_ahb - 1;
> +	reg.val.is_base_27mhz = (clks->base <= 27000000);
> +	reg.val.base_val = (300 - (clks->base / 1000000)) / 6;
> +
> +	return reg.raw;
> +}

Clock code should live in drivers/clk/

> +/* Interrupt handling */
> +
> +static inline int check_interrupt(void __iomem *base, struct pt_regs *regs)
> +{
> +	if (readl(base + 0x0)) {
> +		int irqnr = readl(base + 0x24);
> +		unsigned prev_priority;
> +		handle_IRQ(irqnr, regs);
> +
> +		/* Reset priorities */
> +		prev_priority = readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));
> +		writel(prev_priority, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x2c));
> +		return 1;
> +	}
> +	return 0;
> +}

Interrupt code should live in drivers/irqchip/

Your method of doing "readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));" has multiple
flaws:

* A FOO_VIRT_BASE constant should already be of type "void __iomem *" and not
  require another IOMEM()
* Normally the base address is generated at runtime using ioremap or of_iomap,
  since in  multiplatform kernel, you have no access to platform specific constants
  from a device driver
* You might want to define symbolic constants for "0x28".

> +void __init nspire_classic_init_irq(void)
> +{
> +	/* No stickies */
> +	writel(0, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x204));
> +
> +	/* Disable all interrupts */
> +	writel(~0, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0xc));
> +	writel(~0, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x10c));
> +
> +	/* Set all priorities to 0 */
> +	memset_io(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x300), 0, 0x7f);
> +
> +	/* Accept interrupts of all priorities */
> +	writel(0xf, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x2c));
> +	writel(0xf, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x12c));
> +
> +	/* Clear existing interrupts */
> +	readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));
> +	readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x128));
> +
> +	/* Add chip */
> +	classic_allocate_gc();
> +}

For sparse irq and for devicetree, you need to allocate an irqdomain here.

> +
> +
> +static struct clock_event_device nspire_clkevt = {
> +	.name		= "clockevent",
> +	.features	= CLOCK_EVT_FEAT_ONESHOT,
> +	.shift		= 32,
> +	.rating		= 400,
> +	.set_next_event = classic_timer_set_event,
> +	.set_mode	= classic_timer_set_mode,
> +	.cpumask		= cpu_all_mask,
> +};

clockevent code should live in drivers/clocksource, although there
is ongoing discussion about creating a new directory for clockevent
separate from clocksource. Not in arch/arm though.

> +/* Serial */
> +static struct plat_serial8250_port classic_serial_platform_data[] = {
> +	{
> +		.mapbase	= NSPIRE_APB_PHYS(NSPIRE_APB_UART),
> +		.irq		= NSPIRE_IRQ_UART,
> +		.uartclk	= 29491200,
> +		.iotype		= UPIO_MEM,
> +		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST |
> +				UPF_IOREMAP,
> +		.regshift	= 2
> +	},
> +	{ }
> +};
> +
> +struct platform_device nspire_classic_serial_device = {
> +	.name		= "serial8250",
> +	.id			= PLAT8250_DEV_PLATFORM,
> +	.dev = {
> +		.platform_data = &classic_serial_platform_data
> +	}
> +};

You can use the of_serial driver to get that information from the device tree.

> > +/* Framebuffer */
> +static struct clcd_panel classic_lcd_panel = {
> +	.mode		= {
> +		.name		= "grayscale lcd",
> +		.refresh	= 60,
> +		.xres		= 320,
> +		.yres		= 240,
> +		.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
> +		.vmode		= FB_VMODE_NONINTERLACED,
> +		.pixclock	= 1,
> +		.hsync_len	= 6,
> +		.vsync_len	= 1,
> +		.right_margin	= 6,
> +		.left_margin	= 6,
> +	},
> +	.width		= 71, /* 7.11cm */
> +	.height		= 53, /* 5.33cm */
> +	.tim2		= 0x80007d0,
> +	.cntl		= CNTL_LCDBPP8 | CNTL_LCDMONO8,
> +	.bpp		= 8,
> +	.grayscale	= 1
> +};
> +#define PANEL_SIZE (19 * SZ_4K)
> +
> +static int classic_clcd_setup(struct clcd_fb *fb)
> +{
> +	return nspire_clcd_setup(fb, PANEL_SIZE, &classic_lcd_panel);
> +}

And drivers/video/of_display_timing.c for these.

> diff --git a/arch/arm/mach-nspire/clock.c b/arch/arm/mach-nspire/clock.c
> new file mode 100644
> index 0000000..c679449
> --- /dev/null
> +++ b/arch/arm/mach-nspire/clock.c

Not needed with COMMON_CLK


> +
> +#define IOTABLE_ENTRY(t) \
> +	{ \
> +		.virtual	= NSPIRE_##t##_VIRT_BASE, \
> +		.pfn		= __phys_to_pfn(NSPIRE_##t##_PHYS_BASE), \
> +		.length		= NSPIRE_##t##_SIZE, \
> +		.type		= MT_DEVICE \
> +	}
> +
> +#define RESOURCE_ENTRY_IRQ(t) \
> +	{ \
> +		.start	= NSPIRE_IRQ_##t, \
> +		.end	= NSPIRE_IRQ_##t, \
> +		.flags	= IORESOURCE_IRQ \
> +	}
> +
> +#define RESOURCE_ENTRY_MEM(t) \
> +	{ \
> +		.start	= NSPIRE_##t##_PHYS_BASE, \
> +		.end	= NSPIRE_##t##_PHYS_BASE + NSPIRE_##t##_SIZE - 1, \
> +		.flags	= IORESOURCE_MEM \
> +	}

Please don't define your own macros for generic functionality. If you think
that macros are good for these, you can submit a patch to make them available
for everyone.

For the resources, we already have macros in include/linux/ioport.h

> +extern struct platform_device nspire_keypad_device;
> +extern struct platform_device nspire_otg_device;
> +extern struct platform_device nspire_usb_nop_xceiver;
> +extern struct nspire_keypad_data nspire_keypad_data;

Do not define "struct platform_devices" as global data structures, it messes
up reference counting. Ideally all platform and AMBA devices get created
from device tree. If that should not be possible for one of them, you can
use platform_device_register_resndata or the associated functions.

> diff --git a/arch/arm/mach-nspire/include/mach/clkdev.h b/arch/arm/mach-nspire/include/mach/clkdev.h
> new file mode 100644
> index 0000000..b4afe65
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/clkdev.h

Not needed with common clk.

> diff --git a/arch/arm/mach-nspire/include/mach/debug-macro.S b/arch/arm/mach-nspire/include/mach/debug-macro.S
> new file mode 100644
> index 0000000..b71daa4
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/debug-macro.S

Move this to arch/arm/include/debug/

> diff --git a/arch/arm/mach-nspire/include/mach/hardware.h b/arch/arm/mach-nspire/include/mach/hardware.h
> new file mode 100644
> index 0000000..7c9c3b6
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/hardware.h

delete this

> diff --git a/arch/arm/mach-nspire/include/mach/irqs.h b/arch/arm/mach-nspire/include/mach/irqs.h
> new file mode 100644
> index 0000000..70be120
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/irqs.h
> @@ -0,0 +1,34 @@
> +/*
> + *  linux/arch/arm/mach-nspire/include/mach/irqs.h
> + *
> + *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef NSPIRE_IRQS_H
> +#define NSPIRE_IRQS_H
> +
> +#define NSPIRE_IRQ_MASK         0x007FEB9A
> +
> +enum {
> +	NSPIRE_IRQ_UART = 1,
> +	NSPIRE_IRQ_WATCHDOG = 3,
> +	NSPIRE_IRQ_RTC = 4,
> +	NSPIRE_IRQ_GPIO = 7,
> +	NSPIRE_IRQ_OTG = 8,
> +	NSPIRE_IRQ_HOSTUSB = 9,
> +	NSPIRE_IRQ_ADC = 11,
> +	NSPIRE_IRQ_PWR = 15,
> +	NSPIRE_IRQ_KEYPAD = 16,
> +	NSPIRE_IRQ_TIMER2 = 19,
> +	NSPIRE_IRQ_I2C = 20,
> +	NSPIRE_IRQ_LCD = 21
> +};
> +
> +#define NR_IRQS 32
> +
> +#endif

Not needed as a globally visible file with sparse IRQ.

> diff --git a/arch/arm/mach-nspire/include/mach/keypad.h b/arch/arm/mach-nspire/include/mach/keypad.h
> new file mode 100644
> index 0000000..18cf3fd
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/keypad.h

Move this to include/linux/platform_data or delete this once you have converted
to device tree.


> diff --git a/arch/arm/mach-nspire/include/mach/memory.h b/arch/arm/mach-nspire/include/mach/memory.h
> new file mode 100644
> index 0000000..eec3f36
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/memory.h
> @@ -0,0 +1,17 @@
> +/*
> + *  linux/arch/arm/mach-nspire/include/mach/memory.h
> + *
> + *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef NSPIRE_MEMORY_H
> +#define NSPIRE_MEMORY_H
> +
> +#define PLAT_PHYS_OFFSET 0x10000000
> +
> +#endif

I think you already don't use this.

> diff --git a/arch/arm/mach-nspire/include/mach/nspire_mmio.h b/arch/arm/mach-nspire/include/mach/nspire_mmio.h
> new file mode 100644
> index 0000000..eaeb100
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/nspire_mmio.h

Move to arch/arm/mach-nspire/, drivers should not see this.

> diff --git a/arch/arm/mach-nspire/include/mach/sram.h b/arch/arm/mach-nspire/include/mach/sram.h
> new file mode 100644
> index 0000000..2f652f3
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/sram.h

A new sram subsystem is getting added, so don't provide your own copy.

> diff --git a/arch/arm/mach-nspire/include/mach/timex.h b/arch/arm/mach-nspire/include/mach/timex.h
> new file mode 100644
> index 0000000..2d4449e
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/timex.h

delete this.

> diff --git a/arch/arm/mach-nspire/include/mach/uncompress.h b/arch/arm/mach-nspire/include/mach/uncompress.h
> new file mode 100644
> index 0000000..7be9d06
> --- /dev/null
> +++ b/arch/arm/mach-nspire/include/mach/uncompress.h

You can delete this once you enable CONFIG_ARCH_MULTIPLATFORM

> +#if defined(CONFIG_MOUSE_SYNAPTICS_I2C) || \
> +	defined(CONFIG_MOUSE_SYNAPTICS_I2C_MODULE)
> +static struct i2c_board_info synaptics_i2c = {
> +	I2C_BOARD_INFO("synaptics_i2c", 0x20),
> +	.irq    = 0,
> +};
> +
> +void __init nspire_touchpad_init()
> +{
> +	i2c_register_board_info(0, &synaptics_i2c, 1);
> +}
> +
> +#else
> +inline void nspire_touchpad_init() {}
> +#endif

Device definitions should not be conditional on the presence of the driver.
This will of course be no issue once you move to DT.

	Arnd
