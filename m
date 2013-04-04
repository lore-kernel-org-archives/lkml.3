Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3DDJCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:02:13 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44848 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3DDJCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:02:06 -0400
From: Daniel Tang <dt.tangr@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [RFC PATCH arm: initial TI-Nspire support]
Date: Thu, 4 Apr 2013 20:01:50 +1100
Message-Id: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com>
Cc: linux-kernel@vger.kernel.org, fabian@ritter-vogt.de,
        Lionel Debroux <lionel_debroux@yahoo.fr>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're sending out for comments an early patch adding TI-Nspire support
to Linux.

Some words on the Nspire platform: it's a series of graphing
calculators, made of four models: "Clickpad" (2007-2010), "Touchpad"
(2010-2012?), "CX" (2011-), "CM-C" (2011-).

The main hardware characteristics are significantly outdated - and
yet, Nspires are the most powerful graphing calculators on the
market:
    * ARM926EJ-S based ASICs by LSI Logic, up to 200+ MHz;
    * 32 MB of SDRAM for Clickpad/Touchpad/CM-C, 64 MB of SDRAM for CX;
    * 512 KB of external NOR Flash for first-stage bootloader ("boot1")
      on the oldest models, internal since then;
    * NAND Flash for manufacturer data + boot2 (second-stage
      platform-specific bootloader) + "diags" (diagnostics software)
      + filesystem (containing OS): 32 MB for Clickpad / Touchpad,
      128 MB for CX. Multiple chip models are used.
    * 320x240 grayscale non-backlit DSTN screen for Clickpad / Touchpad
      (usually used in 4 bpp mode), 320x240 16 bpp backlit color screen
      for CX / CM-C;
    * USB OTG capable controller, for calc-to-calc transfers;
    * RS232 TTL and GPIO on proprietary-pitch "dock" connector.


>From a software point of view, the Nspire is usually running a
proprietary Nucleus-based OS, which uses the proprietary Datalight
Reliance filesystem, layered on top of proprietary FlashFX.
TI uses RSA signature validation for boot2, diags and OS upgrades;
boot2 and diags are compressed, OS upgrades are encrypted (Blowfish).
On the CX, some chunks of the boot2 are encrypted with 3-DES.
The officially sanctioned programming abilities are pretty limited:
    * a BASIC which cannot draw pixels to the screen or read arbitrary
      keys from the keyboard (yes, we're talking about a calculator
      used for teaching purposes !!);
    * a proprietary Lua with significant two-way incompatibilities with
      standard Lua: no io.*, so no file I/O, and no os.*; but a
      proprietary framework for event-driven programming.

Native code is accessible on select OS versions (Ndless) or boot2
versions (nLaunch & nLaunch CX) through arbitrary native code execution
exploits.
TI actively fights attempts to use native code on the Nspire series.


Patch contents
--------------
This patch (against mainline, but it also applies to linux-next)
contains the essential support code required to boot Linux to a shell 
on all models, but contains nothing else at the moment.
Code containing drivers for other peripherals exists, and will
eventually be posted for review as well: we need to do a bit of
cleanup. If you prefer them to be posted here now, we'll do.
They're at https://github.com/tangrs/linux .

A possibly noteworthy fact is that despite the gradual shift to
using Device Tree definitions for ARM machine types, we've decided not
to use it, for the following reasons:

    * the (perceived) extra complexity and code size;
    * the fact that we're using our own, simple, bootloader, due to
      the impossibility to bootstrap on most models (because boot1
      is usually not modifiable) and the fact that the image is stored
      in a proprietary FS not supported by mainline Linux and
      common bootloaders...


TODO
----
    * Address review comments, of course ;-)
    * Expand and clean up the drivers that have been written so far
      (for instance, GPIO) and submit them for review.
    * Continue to reverse engineer and write drivers to support the
      remaining hardware. We still need to work on power management and
      the NAND Flash. The platform also has a SPI somewhere, probably
      another USB port, and more anecdotal, 3-DES and SHA-256 hardware
      acceleration.


Thanks in advance for reviews ;)

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 arch/arm/Kconfig                                 |   17 +
 arch/arm/Makefile                                |    1 +
 arch/arm/mach-nspire/Kconfig                     |   36 +++
 arch/arm/mach-nspire/Makefile                    |   16 +
 arch/arm/mach-nspire/Makefile.boot               |    1 +
 arch/arm/mach-nspire/classic.c                   |  363 ++++++++++++++++++++++
 arch/arm/mach-nspire/classic.h                   |   23 ++
 arch/arm/mach-nspire/clock.c                     |   39 +++
 arch/arm/mach-nspire/clock.h                     |   10 +
 arch/arm/mach-nspire/common.c                    |  311 ++++++++++++++++++
 arch/arm/mach-nspire/common.h                    |   52 ++++
 arch/arm/mach-nspire/include/mach/clkdev.h       |   24 ++
 arch/arm/mach-nspire/include/mach/debug-macro.S  |   28 ++
 arch/arm/mach-nspire/include/mach/hardware.h     |   15 +
 arch/arm/mach-nspire/include/mach/irqs.h         |   34 ++
 arch/arm/mach-nspire/include/mach/keypad.h       |   31 ++
 arch/arm/mach-nspire/include/mach/memory.h       |   17 +
 arch/arm/mach-nspire/include/mach/nspire_clock.h |   52 ++++
 arch/arm/mach-nspire/include/mach/nspire_mmio.h  |   67 ++++
 arch/arm/mach-nspire/include/mach/sram.h         |   26 ++
 arch/arm/mach-nspire/include/mach/timex.h        |   15 +
 arch/arm/mach-nspire/include/mach/uncompress.h   |   42 +++
 arch/arm/mach-nspire/keypad.c                    |  100 ++++++
 arch/arm/mach-nspire/nspire_clp.c                |   57 ++++
 arch/arm/mach-nspire/nspire_cx.c                 |  316 +++++++++++++++++++
 arch/arm/mach-nspire/nspire_tp.c                 |   80 +++++
 arch/arm/mach-nspire/sram.c                      |   66 ++++
 arch/arm/mach-nspire/touchpad.c                  |   30 ++
 arch/arm/mach-nspire/touchpad.h                  |   17 +
 arch/arm/tools/mach-types                        |    3 +
 30 files changed, 1889 insertions(+)
 create mode 100644 arch/arm/mach-nspire/Kconfig
 create mode 100644 arch/arm/mach-nspire/Makefile
 create mode 100644 arch/arm/mach-nspire/Makefile.boot
 create mode 100644 arch/arm/mach-nspire/classic.c
 create mode 100644 arch/arm/mach-nspire/classic.h
 create mode 100644 arch/arm/mach-nspire/clock.c
 create mode 100644 arch/arm/mach-nspire/clock.h
 create mode 100644 arch/arm/mach-nspire/common.c
 create mode 100644 arch/arm/mach-nspire/common.h
 create mode 100644 arch/arm/mach-nspire/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-nspire/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-nspire/include/mach/hardware.h
 create mode 100644 arch/arm/mach-nspire/include/mach/irqs.h
 create mode 100644 arch/arm/mach-nspire/include/mach/keypad.h
 create mode 100644 arch/arm/mach-nspire/include/mach/memory.h
 create mode 100644 arch/arm/mach-nspire/include/mach/nspire_clock.h
 create mode 100644 arch/arm/mach-nspire/include/mach/nspire_mmio.h
 create mode 100644 arch/arm/mach-nspire/include/mach/sram.h
 create mode 100644 arch/arm/mach-nspire/include/mach/timex.h
 create mode 100644 arch/arm/mach-nspire/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-nspire/keypad.c
 create mode 100644 arch/arm/mach-nspire/nspire_clp.c
 create mode 100644 arch/arm/mach-nspire/nspire_cx.c
 create mode 100644 arch/arm/mach-nspire/nspire_tp.c
 create mode 100644 arch/arm/mach-nspire/sram.c
 create mode 100644 arch/arm/mach-nspire/touchpad.c
 create mode 100644 arch/arm/mach-nspire/touchpad.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13b7394..4aa5029 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -492,6 +492,21 @@ config ARCH_NETX
 	help
 	  This enables support for systems based on the Hilscher NetX Soc

+config ARCH_NSPIRE
+	bool "TI-NSPIRE based"
+	depends on MMU
+	select CPU_ARM926T
+	select HAVE_MACH_CLKDEV
+	select CLKDEV_LOOKUP
+	select ARM_AMBA
+	select USB_ARCH_HAS_EHCI
+	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select GENERIC_ALLOCATOR
+	select ARCH_HAS_CPUFREQ
+	select CPU_FREQ_TABLE
+	help
+	  This enables support for systems using the TI-NSPIRE CPU
+
 config ARCH_H720X
 	bool "Hynix HMS720x-based"
 	select ARCH_USES_GETTIMEOFFSET
@@ -1081,6 +1096,8 @@ source "arch/arm/mach-netx/Kconfig"

 source "arch/arm/mach-nomadik/Kconfig"

+source "arch/arm/mach-nspire/Kconfig"
+
 source "arch/arm/plat-omap/Kconfig"

 source "arch/arm/mach-omap1/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index ee4605f..2580d2b 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -165,6 +165,7 @@ machine-$(CONFIG_ARCH_MXS)		+= mxs
 machine-$(CONFIG_ARCH_MVEBU)		+= mvebu
 machine-$(CONFIG_ARCH_NETX)		+= netx
 machine-$(CONFIG_ARCH_NOMADIK)		+= nomadik
+machine-$(CONFIG_ARCH_NSPIRE)		+= nspire
 machine-$(CONFIG_ARCH_OMAP1)		+= omap1
 machine-$(CONFIG_ARCH_OMAP2PLUS)	+= omap2
 machine-$(CONFIG_ARCH_ORION5X)		+= orion5x
diff --git a/arch/arm/mach-nspire/Kconfig b/arch/arm/mach-nspire/Kconfig
new file mode 100644
index 0000000..da032b7
--- /dev/null
+++ b/arch/arm/mach-nspire/Kconfig
@@ -0,0 +1,36 @@
+if ARCH_NSPIRE
+
+choice
+	prompt "Early printk and boot message serial interface"
+	help
+	  Early printk output interface
+	depends on EARLY_PRINTK
+	default NSPIRE_EARLYPRINTK_CX
+
+config NSPIRE_EARLYPRINTK_CLASSIC
+	bool "Classic"
+
+config NSPIRE_EARLYPRINTK_CX
+	bool "CX model"
+endchoice
+
+
+menu "Supported models"
+
+config MACH_NSPIRECX
+	select GENERIC_CLOCKEVENTS
+	select ARM_VIC
+	select ARM_TIMER_SP804
+	bool "CX/CX CAS"
+
+config MACH_NSPIRETP
+	select GENERIC_IRQ_CHIP
+	bool "Touchpad/Touchpad CAS"
+
+config MACH_NSPIRECLP
+	select GENERIC_IRQ_CHIP
+	bool "Clickpad/Clickpad CAS"
+
+endmenu
+
+endif
diff --git a/arch/arm/mach-nspire/Makefile b/arch/arm/mach-nspire/Makefile
new file mode 100644
index 0000000..f7108fe
--- /dev/null
+++ b/arch/arm/mach-nspire/Makefile
@@ -0,0 +1,16 @@
+obj-y				:=
+
+obj-y				+= common.o
+obj-y				+= clock.o
+obj-y				+= sram.o
+obj-y				+= keypad.o
+
+obj-$(CONFIG_MACH_NSPIRECX)	+= nspire_cx.o
+obj-$(CONFIG_MACH_NSPIRECX)	+= touchpad.o
+
+obj-$(CONFIG_MACH_NSPIRECLP)	+= nspire_clp.o
+obj-$(CONFIG_MACH_NSPIRECLP)	+= classic.o
+
+obj-$(CONFIG_MACH_NSPIRETP)	+= nspire_tp.o
+obj-$(CONFIG_MACH_NSPIRETP)	+= classic.o
+obj-$(CONFIG_MACH_NSPIRETP)	+= touchpad.o
diff --git a/arch/arm/mach-nspire/Makefile.boot b/arch/arm/mach-nspire/Makefile.boot
new file mode 100644
index 0000000..7db966b
--- /dev/null
+++ b/arch/arm/mach-nspire/Makefile.boot
@@ -0,0 +1 @@
+zreladdr-y	:= 0x10008000
diff --git a/arch/arm/mach-nspire/classic.c b/arch/arm/mach-nspire/classic.c
new file mode 100644
index 0000000..b1eddf3
--- /dev/null
+++ b/arch/arm/mach-nspire/classic.c
@@ -0,0 +1,363 @@
+/*
+ *	linux/arch/arm/mach-nspire/classic.c
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/cpumask.h>
+#include <linux/serial_8250.h>
+#include <linux/platform_device.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/clcd.h>
+#include <linux/dma-mapping.h>
+
+#include <asm/mach/time.h>
+#include <asm/exception.h>
+
+#include <mach/nspire_mmio.h>
+#include <mach/nspire_clock.h>
+#include <mach/clkdev.h>
+#include <mach/keypad.h>
+#include <mach/irqs.h>
+
+#include "common.h"
+
+/* Clock */
+
+union reg_clk_speed {
+	unsigned long raw;
+	struct {
+		unsigned long __padding0:1;
+		unsigned long base_cpu_ratio:7;
+		unsigned long is_base_27mhz:1;
+		unsigned long __padding1:3;
+		unsigned long cpu_ahb_ratio:3;
+		unsigned long __padding2:1;
+		unsigned long base_val:5;
+	} val;
+};
+
+static struct nspire_clk_speeds classic_io_to_clocks(unsigned long val)
+{
+	struct nspire_clk_speeds clks;
+	union reg_clk_speed reg;
+
+	reg.raw = val;
+	reg.val.base_cpu_ratio *= 2;
+	reg.val.cpu_ahb_ratio++;
+
+	BUG_ON(reg.val.base_cpu_ratio == 0);
+
+	clks.base = reg.val.is_base_27mhz ? 27 : (300 - (6*reg.val.base_val));
+	clks.base *= 1000000; /* Convert to Hz */
+
+	clks.div.base_cpu = reg.val.base_cpu_ratio;
+	clks.div.cpu_ahb = reg.val.cpu_ahb_ratio;
+
+	return clks;
+}
+
+static unsigned long classic_clocks_to_io(struct nspire_clk_speeds *clks)
+{
+	union reg_clk_speed reg;
+
+	BUG_ON(clks->div.base_cpu < 2);
+	BUG_ON(clks->div.cpu_ahb < 1);
+
+	reg.raw = 0;
+	reg.val.base_cpu_ratio = clks->div.base_cpu / 2;
+	reg.val.cpu_ahb_ratio = clks->div.cpu_ahb - 1;
+	reg.val.is_base_27mhz = (clks->base <= 27000000);
+	reg.val.base_val = (300 - (clks->base / 1000000)) / 6;
+
+	return reg.raw;
+}
+
+/* Interrupt handling */
+
+static inline int check_interrupt(void __iomem *base, struct pt_regs *regs)
+{
+	if (readl(base + 0x0)) {
+		int irqnr = readl(base + 0x24);
+		unsigned prev_priority;
+		handle_IRQ(irqnr, regs);
+
+		/* Reset priorities */
+		prev_priority = readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));
+		writel(prev_priority, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x2c));
+		return 1;
+	}
+	return 0;
+}
+
+asmlinkage void __exception_irq_entry
+	nspire_classic_handle_irq(struct pt_regs *regs)
+{
+	int serviced;
+
+	do {
+		void __iomem *reg_base = IOMEM(NSPIRE_INTERRUPT_VIRT_BASE);
+		serviced = 0;
+
+		/* IRQ */
+		serviced += check_interrupt(reg_base, regs);
+		/* FIQ */
+		serviced += check_interrupt(reg_base + 0x100, regs);
+	} while (serviced > 0);
+}
+
+static void classic_irq_ack(struct irq_data *d)
+{
+	readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));
+}
+
+static void __init classic_allocate_gc(void)
+{
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
+
+	gc = irq_alloc_generic_chip("NINT", 1, 0,
+		IOMEM(NSPIRE_INTERRUPT_VIRT_BASE), handle_level_irq);
+
+	ct = gc->chip_types;
+	ct->chip.irq_ack = classic_irq_ack;
+	ct->chip.irq_mask = irq_gc_mask_disable_reg;
+	ct->chip.irq_unmask = irq_gc_unmask_enable_reg;
+
+	ct->regs.mask = 0x8;
+	ct->regs.enable = 0x8;
+	ct->regs.disable = 0xc;
+
+	irq_setup_generic_chip(gc, IRQ_MSK(NR_IRQS), IRQ_GC_INIT_MASK_CACHE,
+		IRQ_NOREQUEST, 0);
+}
+
+void __init nspire_classic_init_irq(void)
+{
+	/* No stickies */
+	writel(0, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x204));
+
+	/* Disable all interrupts */
+	writel(~0, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0xc));
+	writel(~0, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x10c));
+
+	/* Set all priorities to 0 */
+	memset_io(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x300), 0, 0x7f);
+
+	/* Accept interrupts of all priorities */
+	writel(0xf, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x2c));
+	writel(0xf, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x12c));
+
+	/* Clear existing interrupts */
+	readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));
+	readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x128));
+
+	/* Add chip */
+	classic_allocate_gc();
+}
+
+
+/* Timer */
+
+static int classic_timer_set_event(unsigned long delta,
+				struct clock_event_device *dev)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	writel(delta, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2));
+	writel(1, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x8));
+	writel(0, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x18));
+	local_irq_restore(flags);
+
+	return 0;
+}
+static void classic_timer_set_mode(enum clock_event_mode mode,
+				 struct clock_event_device *evt)
+{
+	evt->mode = mode;
+}
+
+static struct clock_event_device nspire_clkevt = {
+	.name		= "clockevent",
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 32,
+	.rating		= 400,
+	.set_next_event = classic_timer_set_event,
+	.set_mode	= classic_timer_set_mode,
+	.cpumask		= cpu_all_mask,
+};
+
+static irqreturn_t classic_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *c = dev_id;
+
+	/* Acknowledge */
+	writel((1<<0), NSPIRE_APB_VIRTIO(NSPIRE_APB_MISC + 0x20));
+
+	if (c->mode != CLOCK_EVT_FEAT_PERIODIC)
+		writel((1<<4) | 1, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x08));
+
+	if (c->event_handler)
+		c->event_handler(c);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction classic_timer_irq = {
+	.name			= "timer2",
+	.flags			= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.handler		= classic_timer_interrupt,
+	.dev_id			= &nspire_clkevt,
+};
+
+
+void __init nspire_classic_timer_init(void)
+{
+	struct clk *timer_clk;
+
+	/* Count down from 1 */
+	writel(1, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2));
+
+	/* Divider is zero */
+	writel(0, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x4));
+
+	/* Decreasing timer and interrupt */
+	writel(1, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x8));
+
+	/* Interrupt on timer value reaching 0 */
+	writel(0, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x18));
+
+	/* Acknowledge existing interrupts */
+	writel(~0, NSPIRE_APB_VIRTIO(NSPIRE_APB_MISC + 0x20));
+
+	/* Set interrupt masks */
+	writel((1<<0), NSPIRE_APB_VIRTIO(NSPIRE_APB_MISC + 0x24));
+
+	setup_irq(NSPIRE_IRQ_TIMER2, &classic_timer_irq);
+
+	timer_clk = clk_get(NULL, "timer2");
+	clk_enable(timer_clk);
+
+	/* Set clocksource to zero */
+	writel(0, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0xc));
+
+	/* Divider is zero */
+	writel(0, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x10));
+
+	/* Ever increasing timer */
+	writel((1<<3) | 7, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x14));
+
+	clocksource_mmio_init(NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0xc),
+		"clocksource", clk_get_rate(timer_clk), 200, 16,
+		clocksource_mmio_readw_up);
+
+	clockevents_config_and_register(&nspire_clkevt,
+		clk_get_rate(timer_clk), 0x0001, 0xfffe);
+}
+
+
+/* Serial */
+static struct plat_serial8250_port classic_serial_platform_data[] = {
+	{
+		.mapbase	= NSPIRE_APB_PHYS(NSPIRE_APB_UART),
+		.irq		= NSPIRE_IRQ_UART,
+		.uartclk	= 29491200,
+		.iotype		= UPIO_MEM,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST |
+				UPF_IOREMAP,
+		.regshift	= 2
+	},
+	{ }
+};
+
+struct platform_device nspire_classic_serial_device = {
+	.name		= "serial8250",
+	.id			= PLAT8250_DEV_PLATFORM,
+	.dev = {
+		.platform_data = &classic_serial_platform_data
+	}
+};
+
+/* Framebuffer */
+static struct clcd_panel classic_lcd_panel = {
+	.mode		= {
+		.name		= "grayscale lcd",
+		.refresh	= 60,
+		.xres		= 320,
+		.yres		= 240,
+		.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.pixclock	= 1,
+		.hsync_len	= 6,
+		.vsync_len	= 1,
+		.right_margin	= 6,
+		.left_margin	= 6,
+	},
+	.width		= 71, /* 7.11cm */
+	.height		= 53, /* 5.33cm */
+	.tim2		= 0x80007d0,
+	.cntl		= CNTL_LCDBPP8 | CNTL_LCDMONO8,
+	.bpp		= 8,
+	.grayscale	= 1
+};
+#define PANEL_SIZE (19 * SZ_4K)
+
+static int classic_clcd_setup(struct clcd_fb *fb)
+{
+	return nspire_clcd_setup(fb, PANEL_SIZE, &classic_lcd_panel);
+}
+
+static struct clcd_board classic_clcd_data = {
+	.name		= "lcd controller",
+	.check		= clcdfb_check,
+	.decode		= clcdfb_decode,
+	.setup		= classic_clcd_setup,
+	.mmap		= nspire_clcd_mmap,
+	.remove		= nspire_clcd_remove,
+};
+
+AMBA_AHB_DEVICE(fb, "fb", 0, NSPIRE_LCD_PHYS_BASE,
+	{ NSPIRE_IRQ_LCD }, &classic_clcd_data);
+
+/* Init */
+void __init nspire_classic_init_early(void)
+{
+	nspire_io_to_clocks = classic_io_to_clocks;
+	nspire_clocks_to_io = classic_clocks_to_io;
+
+	nspire_init_early();
+}
+
+void __init nspire_classic_init(void)
+{
+	/*
+	 * Temporarily disable NAND writes on classics to prevent
+	 * accidental bricking.
+	 */
+	writel((1<<7), NSPIRE_APB_VIRTIO(NSPIRE_APB_POWER + 0x18));
+
+	nspire_keypad_data.active_low = 1;
+
+	amba_device_register(&fb_device, &iomem_resource);
+	platform_device_register(&nspire_keypad_device);
+	platform_device_register(&nspire_classic_serial_device);
+
+	nspire_init();
+}
+
+void __init nspire_classic_init_late(void)
+{
+	nspire_init_late();
+}
diff --git a/arch/arm/mach-nspire/classic.h b/arch/arm/mach-nspire/classic.h
new file mode 100644
index 0000000..c440ebc
--- /dev/null
+++ b/arch/arm/mach-nspire/classic.h
@@ -0,0 +1,23 @@
+/*
+ *	linux/arch/arm/mach-nspire/classic.h
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <asm/exception.h>
+
+void __init nspire_classic_init_irq(void);
+void __init nspire_classic_init_early(void);
+void __init nspire_classic_init(void);
+void __init nspire_classic_init_late(void);
+asmlinkage void __exception_irq_entry
+	nspire_classic_handle_irq(struct pt_regs *regs);
+
+void __init nspire_classic_timer_init(void);
+
+extern struct irq_chip nspire_classic_irq_chip;
diff --git a/arch/arm/mach-nspire/clock.c b/arch/arm/mach-nspire/clock.c
new file mode 100644
index 0000000..c679449
--- /dev/null
+++ b/arch/arm/mach-nspire/clock.c
@@ -0,0 +1,39 @@
+/*
+ *  linux/arch/arm/mach-nspire/clock.c
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <asm-generic/errno.h>
+
+#include <mach/clkdev.h>
+
+void clk_disable(struct clk *clk)
+{
+}
+
+int clk_enable(struct clk *clk)
+{
+	return 0;
+}
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	if (clk->get_rate)
+		clk->get_rate(clk);
+
+	return clk->rate;
+}
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	if (clk->set_rate)
+		return clk->set_rate(clk, rate);
+
+	return -ENOSYS;
+}
diff --git a/arch/arm/mach-nspire/clock.h b/arch/arm/mach-nspire/clock.h
new file mode 100644
index 0000000..43e99bd
--- /dev/null
+++ b/arch/arm/mach-nspire/clock.h
@@ -0,0 +1,10 @@
+/*
+ *  linux/arch/arm/mach-nspire/clock.h
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
diff --git a/arch/arm/mach-nspire/common.c b/arch/arm/mach-nspire/common.c
new file mode 100644
index 0000000..a7abc68
--- /dev/null
+++ b/arch/arm/mach-nspire/common.c
@@ -0,0 +1,311 @@
+/*
+ *	linux/arch/arm/mach-nspire/common.c
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/clkdev.h>
+#include <linux/platform_device.h>
+#include <linux/usb/ehci_pdriver.h>
+#include <linux/usb/chipidea.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/clcd.h>
+#include <linux/dma-mapping.h>
+
+#include <mach/nspire_mmio.h>
+#include <mach/nspire_clock.h>
+#include <mach/irqs.h>
+#include <mach/clkdev.h>
+#include <mach/keypad.h>
+#include <mach/sram.h>
+
+#include <asm/mach/time.h>
+#include <asm/mach-types.h>
+#include <asm/mach/map.h>
+
+#include "common.h"
+#include "clock.h"
+
+/* Clocks */
+
+struct nspire_clk_speeds (*nspire_io_to_clocks)(unsigned long);
+unsigned long (*nspire_clocks_to_io)(struct nspire_clk_speeds *);
+
+/* AHB clock */
+static void ahb_get_rate(struct clk *clk)
+{
+	struct nspire_clk_speeds speeds = nspire_get_clocks();
+	clk->rate = CLK_GET_AHB(&speeds);
+}
+
+static struct clk ahb_clk = {
+	.get_rate = ahb_get_rate,
+};
+
+/* APB clock */
+
+static void apb_get_rate(struct clk *clk)
+{
+	clk->rate = clk_get_rate(&ahb_clk) / 2;
+}
+
+static struct clk apb_clk = {
+	.get_rate = apb_get_rate
+};
+
+/* Misc */
+
+static struct clk systimer_clk = {
+	.rate	= 32768,
+};
+
+static struct clk uart_clk = {
+	.rate	= 12000000,
+};
+
+#ifdef CONFIG_MACH_NSPIRECX
+static struct clk i2c_clk = {
+	/* Doesn't matter, we set it manually */
+	.rate	= 250000,
+};
+#endif
+
+static struct clk_lookup nspire_clk_lookup[] = {
+	{
+		.dev_id = "uart",
+		.clk = &uart_clk
+	},
+	{
+		.dev_id = "fb",
+		.clk = &ahb_clk
+	},
+	{
+		.con_id = "ahb",
+		.clk = &ahb_clk
+	},
+	{
+		.dev_id = "watchdog",
+		.clk = &apb_clk
+	},
+	{
+		.dev_id = "nspire-keypad.0",
+		.clk = &apb_clk
+	},
+#ifdef CONFIG_MACH_NSPIRECX
+	{
+		.dev_id = "sp804",
+		.con_id = "timer2",
+		.clk = &systimer_clk
+	},
+	{
+		.dev_id = "i2c_designware.0",
+		.clk = &i2c_clk
+	},
+#endif
+#if defined(CONFIG_MACH_NSPIRECLP) || defined(CONFIG_MACH_NSPIRETP)
+	{
+		.dev_id = NULL,
+		.con_id = "timer2",
+		.clk = &systimer_clk
+	},
+#endif
+};
+
+/* Keypad */
+static struct resource nspire_keypad_resources[] = {
+	{
+		.start	= NSPIRE_APB_PHYS(NSPIRE_APB_KEYPAD),
+		.end	= NSPIRE_APB_PHYS(NSPIRE_APB_KEYPAD + SZ_4K - 1),
+		.flags	= IORESOURCE_MEM,
+	},
+	RESOURCE_ENTRY_IRQ(KEYPAD)
+};
+
+struct nspire_keypad_data nspire_keypad_data = {
+	.scan_interval	= 1000,
+	.row_delay	= 200
+};
+
+struct platform_device nspire_keypad_device = {
+	.name		= "nspire-keypad",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(nspire_keypad_resources),
+	.resource	= nspire_keypad_resources,
+	.dev = {
+		.platform_data = &nspire_keypad_data
+	}
+};
+
+
+/* GPIO */
+static struct resource nspire_gpio_resources[] = {
+	{
+		.start	= NSPIRE_APB_PHYS(NSPIRE_APB_GPIO),
+		.end	= NSPIRE_APB_PHYS(NSPIRE_APB_GPIO + SZ_4K - 1),
+		.flags	= IORESOURCE_MEM,
+	},
+	RESOURCE_ENTRY_IRQ(GPIO)
+};
+
+static struct platform_device nspire_gpio_device = {
+	.name		= "gpio-nspire",
+	.resource	= nspire_gpio_resources,
+	.num_resources	= ARRAY_SIZE(nspire_gpio_resources),
+};
+
+/* ADC */
+static struct resource nspire_adc_resources[] = {
+	RESOURCE_ENTRY_MEM(ADC),
+	RESOURCE_ENTRY_IRQ(ADC)
+};
+
+static struct platform_device nspire_adc_device = {
+	.name		= "nspire-adc",
+	.resource	= nspire_adc_resources,
+	.num_resources	= ARRAY_SIZE(nspire_adc_resources)
+};
+
+/* Framebuffer */
+int nspire_clcd_setup(struct clcd_fb *fb, unsigned panel_size,
+	struct clcd_panel *panel)
+{
+	dma_addr_t dma;
+
+	fb->fb.screen_base = dma_alloc_writecombine(&fb->dev->dev,
+		panel_size, &dma, GFP_KERNEL);
+	if (!fb->fb.screen_base) {
+		pr_err("CLCD: unable to map framebuffer\n");
+		return -ENOMEM;
+	}
+
+	fb->fb.fix.smem_start = dma;
+	fb->fb.fix.smem_len = panel_size;
+	fb->panel = panel;
+
+	return 0;
+}
+
+int nspire_clcd_mmap(struct clcd_fb *fb, struct vm_area_struct *vma)
+{
+	return dma_mmap_writecombine(&fb->dev->dev, vma,
+		fb->fb.screen_base, fb->fb.fix.smem_start,
+		fb->fb.fix.smem_len);
+}
+
+void nspire_clcd_remove(struct clcd_fb *fb)
+{
+	dma_free_writecombine(&fb->dev->dev, fb->fb.fix.smem_len,
+		fb->fb.screen_base, fb->fb.fix.smem_start);
+}
+
+/* Watchdog */
+
+AMBA_APB_DEVICE(watchdog, "watchdog", 0, NSPIRE_APB_PHYS(NSPIRE_APB_WATCHDOG),
+	{ NSPIRE_IRQ_WATCHDOG }, NULL);
+
+/* Generic OTG */
+
+u64 nspire_usb_dma_mask = ~(u32)0;
+
+static struct resource otg_resources[] = {
+	RESOURCE_ENTRY_MEM(OTG),
+	RESOURCE_ENTRY_IRQ(OTG)
+};
+
+static struct ci13xxx_platform_data otg_pdata = {
+	.name = "nspire_usb",
+	.capoffset = 0x100,
+	.flags = CI13XXX_REGS_SHARED,
+};
+
+
+struct platform_device nspire_otg_device = {
+	.name		= "ci_hdrc",
+	.id		= 0,
+	.dev = {
+		.platform_data = &otg_pdata,
+		.coherent_dma_mask = ~0,
+		.dma_mask = &nspire_usb_dma_mask
+	},
+	.resource = otg_resources,
+	.num_resources = ARRAY_SIZE(otg_resources)
+};
+
+struct platform_device nspire_usb_nop_xceiver = {
+	.name		= "nop_usb_xceiv",
+};
+
+/* RTC */
+static struct resource nspire_rtc_resources[] = {
+	{
+		.start	= NSPIRE_APB_PHYS(NSPIRE_APB_RTC),
+		.end	= NSPIRE_APB_PHYS(NSPIRE_APB_RTC + SZ_4K - 1),
+		.flags	= IORESOURCE_MEM,
+	},
+	RESOURCE_ENTRY_IRQ(RTC)
+};
+
+static struct platform_device nspire_rtc_device = {
+	.name		= "nspire-rtc",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(nspire_rtc_resources),
+	.resource	= nspire_rtc_resources,
+};
+
+/* Memory mapped IO */
+struct map_desc nspire_io_regs[] __initdata = {
+	IOTABLE_ENTRY(ADC),
+	IOTABLE_ENTRY(APB),
+	IOTABLE_ENTRY(INTERRUPT),
+};
+
+void __init nspire_map_io(void)
+{
+	iotable_init(nspire_io_regs, ARRAY_SIZE(nspire_io_regs));
+}
+
+/* Clocks */
+void __init nspire_init_early(void)
+{
+	clkdev_add_table(nspire_clk_lookup, ARRAY_SIZE(nspire_clk_lookup));
+
+	/* Renable bus access to everything in case the OS disabled them */
+	writel(0, NSPIRE_APB_VIRTIO(NSPIRE_APB_POWER + 0x18));
+	writel(0, NSPIRE_APB_VIRTIO(NSPIRE_APB_POWER + 0x20));
+
+	/*
+	 * Ack some non-maskable clock speed change interrupts before cpufreq
+	 * driver is brought up to avoid a race condition between an interrupt
+	 * happening and driver init.
+	 */
+
+	writel(3, NSPIRE_APB_VIRTIO(NSPIRE_APB_POWER + 0x14));
+}
+
+/* Common init */
+void __init nspire_init(void)
+{
+	sram_init(NSPIRE_SRAM_PHYS_BASE, NSPIRE_SRAM_SIZE);
+	amba_device_register(&watchdog_device, &iomem_resource);
+
+	platform_device_register(&nspire_gpio_device);
+	platform_device_register(&nspire_rtc_device);
+	platform_device_register(&nspire_adc_device);
+
+}
+
+void __init nspire_init_late(void)
+{
+}
+
+/* Restart */
+void nspire_restart(char mode, const char *cmd)
+{
+	writel(2, NSPIRE_APB_VIRTIO(NSPIRE_APB_MISC + 0x8));
+}
diff --git a/arch/arm/mach-nspire/common.h b/arch/arm/mach-nspire/common.h
new file mode 100644
index 0000000..27e81b6
--- /dev/null
+++ b/arch/arm/mach-nspire/common.h
@@ -0,0 +1,52 @@
+/*
+ *	linux/arch/arm/mach-nspire/common.h
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+
+#define IOTABLE_ENTRY(t) \
+	{ \
+		.virtual	= NSPIRE_##t##_VIRT_BASE, \
+		.pfn		= __phys_to_pfn(NSPIRE_##t##_PHYS_BASE), \
+		.length		= NSPIRE_##t##_SIZE, \
+		.type		= MT_DEVICE \
+	}
+
+#define RESOURCE_ENTRY_IRQ(t) \
+	{ \
+		.start	= NSPIRE_IRQ_##t, \
+		.end	= NSPIRE_IRQ_##t, \
+		.flags	= IORESOURCE_IRQ \
+	}
+
+#define RESOURCE_ENTRY_MEM(t) \
+	{ \
+		.start	= NSPIRE_##t##_PHYS_BASE, \
+		.end	= NSPIRE_##t##_PHYS_BASE + NSPIRE_##t##_SIZE - 1, \
+		.flags	= IORESOURCE_MEM \
+	}
+
+extern struct platform_device nspire_keypad_device;
+extern struct platform_device nspire_otg_device;
+extern struct platform_device nspire_usb_nop_xceiver;
+extern struct nspire_keypad_data nspire_keypad_data;
+
+extern u64 nspire_usb_dma_mask;
+
+void __init nspire_map_io(void);
+void __init nspire_init_early(void);
+void __init nspire_init(void);
+void __init nspire_init_late(void);
+
+void nspire_restart(char mode, const char *cmd);
+
+int nspire_clcd_mmap(struct clcd_fb *fb, struct vm_area_struct *vma);
+void nspire_clcd_remove(struct clcd_fb *fb);
+int nspire_clcd_setup(struct clcd_fb *fb, unsigned panel_size,
+	struct clcd_panel *panel);
diff --git a/arch/arm/mach-nspire/include/mach/clkdev.h b/arch/arm/mach-nspire/include/mach/clkdev.h
new file mode 100644
index 0000000..b4afe65
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/clkdev.h
@@ -0,0 +1,24 @@
+/*
+ *  linux/arch/arm/mach-nspire/include/mach/clkdev.h
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef NSPIRE_CLKDEV_H
+#define NSPIRE_CLKDEV_H
+
+struct clk {
+	void (*get_rate)(struct clk *clk);
+	int (*set_rate)(struct clk *clk, unsigned long rate);
+	unsigned long rate;
+};
+
+#define __clk_get(clk) ({ 1; })
+#define __clk_put(clk) do { } while (0)
+
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/debug-macro.S b/arch/arm/mach-nspire/include/mach/debug-macro.S
new file mode 100644
index 0000000..b71daa4
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/debug-macro.S
@@ -0,0 +1,28 @@
+/*
+ *	linux/arch/arm/mach-nspire/include/mach/debug-macro.S
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define NSPIRE_EARLY_UART_PHYS_BASE	   0x90020000
+#define NSPIRE_EARLY_UART_VIRT_BASE	   0xfee20000
+
+.macro	addruart, rp, rv, tmp
+	ldr \rp, =(NSPIRE_EARLY_UART_PHYS_BASE)		@ physical base address
+	ldr \rv, =(NSPIRE_EARLY_UART_VIRT_BASE)		@ virtual base address
+.endm
+
+
+#ifdef CONFIG_NSPIRE_EARLYPRINTK_CX
+#include <asm/hardware/debug-pl01x.S>
+#endif
+
+#ifdef CONFIG_NSPIRE_EARLYPRINTK_CLASSIC
+#define UART_SHIFT 2
+#include <asm/hardware/debug-8250.S>
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/hardware.h b/arch/arm/mach-nspire/include/mach/hardware.h
new file mode 100644
index 0000000..7c9c3b6
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/hardware.h
@@ -0,0 +1,15 @@
+/*
+ *  linux/arch/arm/mach-nspire/include/mach/hardware.h
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef NSPIRE_HARDWARE_H
+#define NSPIRE_HARDWARE_H
+
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/irqs.h b/arch/arm/mach-nspire/include/mach/irqs.h
new file mode 100644
index 0000000..70be120
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/irqs.h
@@ -0,0 +1,34 @@
+/*
+ *  linux/arch/arm/mach-nspire/include/mach/irqs.h
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef NSPIRE_IRQS_H
+#define NSPIRE_IRQS_H
+
+#define NSPIRE_IRQ_MASK         0x007FEB9A
+
+enum {
+	NSPIRE_IRQ_UART = 1,
+	NSPIRE_IRQ_WATCHDOG = 3,
+	NSPIRE_IRQ_RTC = 4,
+	NSPIRE_IRQ_GPIO = 7,
+	NSPIRE_IRQ_OTG = 8,
+	NSPIRE_IRQ_HOSTUSB = 9,
+	NSPIRE_IRQ_ADC = 11,
+	NSPIRE_IRQ_PWR = 15,
+	NSPIRE_IRQ_KEYPAD = 16,
+	NSPIRE_IRQ_TIMER2 = 19,
+	NSPIRE_IRQ_I2C = 20,
+	NSPIRE_IRQ_LCD = 21
+};
+
+#define NR_IRQS 32
+
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/keypad.h b/arch/arm/mach-nspire/include/mach/keypad.h
new file mode 100644
index 0000000..18cf3fd
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/keypad.h
@@ -0,0 +1,31 @@
+/*
+ *  linux/arch/arm/mach-nspire/include/mach/keypad.h
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef NSPIRE_KEYPAD_H
+#define NSPIRE_KEYPAD_H
+
+#define KEYPAD_BITMASK_COLS	11
+#define KEYPAD_BITMASK_ROWS	8
+
+struct nspire_keypad_data {
+	unsigned int (*evtcodes)[KEYPAD_BITMASK_COLS];
+
+	/* Maximum delay estimated assuming 33MHz APB */
+	unsigned short scan_interval;	/* In microseconds (~2000us max) */
+	unsigned short row_delay;	/* In microseconds (~500us max) */
+
+	bool active_low;
+};
+
+extern unsigned int nspire_touchpad_evtcode_map[][KEYPAD_BITMASK_COLS];
+extern unsigned int nspire_clickpad_evtcode_map[][KEYPAD_BITMASK_COLS];
+
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/memory.h b/arch/arm/mach-nspire/include/mach/memory.h
new file mode 100644
index 0000000..eec3f36
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/memory.h
@@ -0,0 +1,17 @@
+/*
+ *  linux/arch/arm/mach-nspire/include/mach/memory.h
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef NSPIRE_MEMORY_H
+#define NSPIRE_MEMORY_H
+
+#define PLAT_PHYS_OFFSET 0x10000000
+
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/nspire_clock.h b/arch/arm/mach-nspire/include/mach/nspire_clock.h
new file mode 100644
index 0000000..a96b089
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/nspire_clock.h
@@ -0,0 +1,52 @@
+/*
+ *	linux/arch/arm/mach-nspire/include/mach/nspire_clock.h
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef NSPIRE_CLOCK_H
+#define NSPIRE_CLOCK_H
+
+#include <linux/io.h>
+
+#include <mach/nspire_mmio.h>
+
+struct nspire_clk_divider {
+	unsigned char base_cpu, cpu_ahb;
+};
+
+struct nspire_clk_speeds {
+	unsigned long base;
+	struct nspire_clk_divider div;
+};
+
+#define CLK_GET_CPU(cs) ((cs)->base / (cs)->div.base_cpu)
+#define CLK_GET_AHB(cs) (CLK_GET_CPU(cs) / (cs)->div.cpu_ahb)
+
+extern struct nspire_clk_speeds (*nspire_io_to_clocks)(unsigned long);
+extern unsigned long (*nspire_clocks_to_io)(struct nspire_clk_speeds *);
+
+static inline struct nspire_clk_speeds nspire_get_clocks(void)
+{
+	unsigned long val = readl(NSPIRE_APB_VIRTIO(NSPIRE_APB_POWER + 0x00));
+	BUG_ON(!nspire_io_to_clocks);
+	return nspire_io_to_clocks(val);
+}
+
+static inline void nspire_set_clocks(struct nspire_clk_speeds *clks)
+{
+	unsigned long val;
+	BUG_ON(!nspire_io_to_clocks);
+
+	val = nspire_clocks_to_io(clks);
+
+	writel(val, NSPIRE_APB_VIRTIO(NSPIRE_APB_POWER + 0x00));
+	writel(4,   NSPIRE_APB_VIRTIO(NSPIRE_APB_POWER + 0x0c));
+}
+
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/nspire_mmio.h b/arch/arm/mach-nspire/include/mach/nspire_mmio.h
new file mode 100644
index 0000000..eaeb100
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/nspire_mmio.h
@@ -0,0 +1,67 @@
+/*
+ *	linux/arch/arm/mach-nspire/include/mach/nspire_mmio.h
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef NSPIRE_MMIO_H
+#define NSPIRE_MMIO_H
+
+#include <asm-generic/sizes.h>
+
+/*
+	Memory map:
+	0xFEE00000 - 0xFF000000		0x90000000 - 0x90200000		(APB)
+	0xFEDFF000 - 0xFEE00000		0xDC000000 - 0xDC001000		(Interrupt Controller)
+	0xFED7F000 - 0xFEDFF000		0x00000000 - 0x00080000		(Boot1 ROM)
+	0xFED7E000 - 0xFED7F000		0xC4000000 - 0xC4001000		(ADC)
+*/
+#define NSPIRE_APB_PHYS_BASE		0x90000000
+#define NSPIRE_APB_SIZE			SZ_2M
+#define NSPIRE_APB_VIRT_BASE		0xFEE00000
+
+#define NSPIRE_APB_PHYS(x)		((NSPIRE_APB_PHYS_BASE) + (x))
+#define NSPIRE_APB_VIRT(x)		((NSPIRE_APB_VIRT_BASE) + (x))
+#define NSPIRE_APB_VIRTIO(x)		IOMEM(NSPIRE_APB_VIRT(x))
+
+
+#define NSPIRE_INTERRUPT_PHYS_BASE	0xDC000000
+#define NSPIRE_INTERRUPT_SIZE		SZ_4K
+#define NSPIRE_INTERRUPT_VIRT_BASE	0xFEDFF000
+
+#define NSPIRE_LCD_PHYS_BASE		0xC0000000
+
+#define NSPIRE_OTG_PHYS_BASE		0xB0000000
+#define NSPIRE_OTG_SIZE			SZ_8K
+
+#define NSPIRE_NAND_PHYS_BASE		0x81000000
+#define NSPIRE_NAND_SIZE		SZ_16M
+
+#define NSPIRE_BOOT1_PHYS_BASE		0x00000000
+#define NSPIRE_BOOT1_SIZE		0x00080000
+#define NSPIRE_BOOT1_VIRT_BASE		0xFED7F000
+
+#define NSPIRE_APB_GPIO			0x00000
+#define NSPIRE_APB_UART			0x20000
+#define NSPIRE_APB_I2C			0x50000
+#define NSPIRE_APB_WATCHDOG		0x60000
+#define NSPIRE_APB_RTC			0x90000
+#define NSPIRE_APB_MISC			0xA0000
+#define NSPIRE_APB_POWER		0xB0000
+#define NSPIRE_APB_TIMER2		0xD0000
+#define NSPIRE_APB_KEYPAD		0xE0000
+#define NSPIRE_APB_CONTRAST		0xF0000
+
+#define NSPIRE_SRAM_PHYS_BASE		0xA4000000
+#define NSPIRE_SRAM_SIZE		0x00020000
+
+#define NSPIRE_ADC_PHYS_BASE		0xC4000000
+#define NSPIRE_ADC_SIZE			SZ_4K
+#define NSPIRE_ADC_VIRT_BASE		0xFED7E000
+
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/sram.h b/arch/arm/mach-nspire/include/mach/sram.h
new file mode 100644
index 0000000..2f652f3
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/sram.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA 02110-1301, USA.
+ */
+#ifndef NSPIRE_SRAM_H
+#define NSPIRE_SRAM_H
+
+void *sram_alloc(unsigned int size, dma_addr_t *dma_addr);
+void sram_free(dma_addr_t addr, unsigned int size);
+int __init sram_init(unsigned long base, unsigned long size);
+
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/timex.h b/arch/arm/mach-nspire/include/mach/timex.h
new file mode 100644
index 0000000..2d4449e
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/timex.h
@@ -0,0 +1,15 @@
+/*
+ *  linux/arch/arm/mach-nspire/include/mach/timex.h
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef NSPIRE_TIMEX_H
+#define NSPIRE_TIMEX_H
+
+#endif
diff --git a/arch/arm/mach-nspire/include/mach/uncompress.h b/arch/arm/mach-nspire/include/mach/uncompress.h
new file mode 100644
index 0000000..7be9d06
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/uncompress.h
@@ -0,0 +1,42 @@
+/*
+ *	linux/arch/arm/mach-nspire/include/mach/uncompress.h
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *	Copyright (C) 2013 Lionel Debroux <lionel_debroux@yahoo.fr>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef NSPIRE_UNCOMPRESS_H
+#define NSPIRE_UNCOMPRESS_H
+
+#include <mach/nspire_mmio.h>
+
+#define OFFSET_VAL(var, offset) ((var)[(offset)>>2])
+static inline void putc(int c)
+{
+	volatile unsigned __attribute__((unused)) *serial_base =
+		(volatile unsigned *) NSPIRE_APB_PHYS(NSPIRE_APB_UART);
+
+#ifdef CONFIG_NSPIRE_EARLYPRINTK_CLASSIC
+	OFFSET_VAL(serial_base, 0x00) = (unsigned char)c;
+	while (!(OFFSET_VAL(serial_base, 0x14) & (1<<5)))
+		barrier();
+#endif
+
+#ifdef CONFIG_NSPIRE_EARLYPRINTK_CX
+	OFFSET_VAL(serial_base, 0x00) = (unsigned char)c;
+	while (OFFSET_VAL(serial_base, 0x18) & (1<<5))
+		barrier();
+#endif
+
+}
+#undef OFFSET_VAL
+
+#define arch_decomp_setup()
+#define flush()
+
+#endif
diff --git a/arch/arm/mach-nspire/keypad.c b/arch/arm/mach-nspire/keypad.c
new file mode 100644
index 0000000..5cd9344
--- /dev/null
+++ b/arch/arm/mach-nspire/keypad.c
@@ -0,0 +1,100 @@
+/*
+ *	linux/arch/arm/mach-nspire/keypad.c
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/input.h>
+
+#include <mach/keypad.h>
+
+unsigned int nspire_touchpad_evtcode_map[][KEYPAD_BITMASK_COLS] = {
+	{
+		KEY_ENTER,	KEY_ENTER,	0,		0,
+		KEY_SPACE,	KEY_Z,		KEY_Y,		KEY_0,
+		KEY_TAB,	0,		0,
+	},
+	{
+		KEY_X,		KEY_W,		KEY_V,		KEY_3,
+		KEY_U,		KEY_T,		KEY_S,		KEY_1,
+		0,		0,		KEY_RIGHT
+	},
+	{
+		KEY_R,		KEY_Q,		KEY_P,		KEY_6,
+		KEY_O,		KEY_N,		KEY_M,		KEY_4,
+		KEY_APOSTROPHE, KEY_DOWN,	0
+	},
+	{
+		KEY_L,		KEY_K,		KEY_J,		KEY_9,
+		KEY_I,		KEY_H,		KEY_G,		KEY_7,
+		KEY_SLASH,	KEY_LEFT,	0
+	},
+	{
+		KEY_F,		KEY_E,		KEY_D,		0,
+		KEY_C,		KEY_B,		KEY_A,		KEY_EQUAL,
+		KEY_KPASTERISK, KEY_UP,		0
+	},
+	{
+		0,		KEY_LEFTALT,	KEY_MINUS,	KEY_RIGHTBRACE,
+		KEY_DOT,	KEY_LEFTBRACE,	KEY_5,		0,
+		KEY_SEMICOLON,	KEY_BACKSPACE,	KEY_DELETE
+	},
+	{
+		KEY_BACKSLASH,	0,		KEY_KPPLUS,	KEY_PAGEUP,
+		KEY_2,		KEY_PAGEDOWN,	KEY_8,		KEY_ESC,
+		0,		KEY_TAB,	0
+	},
+	{
+		0,		0,		0,		0,
+		0,		0,		0,		0,
+		KEY_LEFTSHIFT,	KEY_LEFTCTRL,	KEY_COMMA
+	},
+};
+
+unsigned int nspire_clickpad_evtcode_map[][KEYPAD_BITMASK_COLS] = {
+	{
+		KEY_ENTER,	KEY_ENTER,	KEY_SPACE,	0,
+		KEY_Z,		KEY_DOT,	KEY_Y,		KEY_0,
+		KEY_X,		0,		0,
+	},
+	{
+		KEY_COMMA,	KEY_KPPLUS,	KEY_W,		KEY_3,
+		KEY_V,		KEY_2,		KEY_U,		KEY_1,
+		KEY_T,		0,		0
+	},
+	{
+		KEY_KPSLASH,	KEY_MINUS,	KEY_S,		KEY_6,
+		KEY_R,		KEY_5,		KEY_Q,		KEY_4,
+		KEY_P,		0,		0
+	},
+	{
+		KEY_SEMICOLON,	KEY_KPASTERISK, KEY_O,		KEY_9,
+		KEY_N,		KEY_8,		KEY_M,		KEY_7,
+		KEY_L,		0,		0
+	},
+	{
+		KEY_APOSTROPHE, KEY_SLASH,	KEY_K,		0,
+		KEY_J,		0,		KEY_I,		0,
+		KEY_H,		0,		0
+	},
+	{
+		KEY_APOSTROPHE, 0,		KEY_G,		KEY_RIGHTBRACE,
+		KEY_F,		KEY_LEFTBRACE,	KEY_E,		KEY_DELETE,
+		KEY_D,		KEY_LEFTSHIFT,	0
+	},
+	{
+		0,		KEY_ENTER,	KEY_C,		KEY_PAGEUP,
+		KEY_B,		KEY_PAGEDOWN,	KEY_A,		KEY_ESC,
+		KEY_BACKSLASH,	KEY_TAB,	0
+	},
+	{
+		KEY_UP,		0,		KEY_RIGHT,	0,
+		KEY_DOWN,	0,		KEY_LEFT,	KEY_BACKSPACE,
+		KEY_LEFTCTRL,	0,		KEY_EQUAL
+	},
+};
diff --git a/arch/arm/mach-nspire/nspire_clp.c b/arch/arm/mach-nspire/nspire_clp.c
new file mode 100644
index 0000000..945ab5d
--- /dev/null
+++ b/arch/arm/mach-nspire/nspire_clp.c
@@ -0,0 +1,57 @@
+/*
+ *	linux/arch/arm/mach-nspire/nspire_clp.c
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/clkdev.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/clcd.h>
+#include <linux/input.h>
+#include <linux/usb/ehci_pdriver.h>
+#include <linux/mtd/nand.h>
+
+#include <mach/nspire_mmio.h>
+#include <mach/irqs.h>
+#include <mach/clkdev.h>
+#include <mach/sram.h>
+#include <mach/keypad.h>
+
+#include <asm/mach/time.h>
+#include <asm/mach/map.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+#include "common.h"
+#include "classic.h"
+
+static void __init clp_init(void)
+{
+	nspire_keypad_data.evtcodes = nspire_clickpad_evtcode_map;
+	platform_device_register(&nspire_otg_device);
+	platform_device_register(&nspire_usb_nop_xceiver);
+
+	nspire_classic_init();
+}
+
+MACHINE_START(NSPIRECLP, "TI-NSPIRE Clickpad Calculator")
+	.map_io		= nspire_map_io,
+	.init_irq	= nspire_classic_init_irq,
+	.handle_irq	= nspire_classic_handle_irq,
+	.init_time	= nspire_classic_timer_init,
+	.init_early	= nspire_classic_init_early,
+	.init_machine	= clp_init,
+	.init_late	= nspire_classic_init_late,
+	.restart	= nspire_restart,
+MACHINE_END
diff --git a/arch/arm/mach-nspire/nspire_cx.c b/arch/arm/mach-nspire/nspire_cx.c
new file mode 100644
index 0000000..81bbbf8
--- /dev/null
+++ b/arch/arm/mach-nspire/nspire_cx.c
@@ -0,0 +1,316 @@
+/*
+ *	linux/arch/arm/mach-nspire/nspire_cx.c
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/clkdev.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/clcd.h>
+#include <linux/input.h>
+#include <linux/usb/ehci_pdriver.h>
+#include <linux/mtd/nand.h>
+#include <linux/irqchip/arm-vic.h>
+
+#include <mach/nspire_mmio.h>
+#include <mach/nspire_clock.h>
+#include <mach/irqs.h>
+#include <mach/clkdev.h>
+#include <mach/sram.h>
+#include <mach/keypad.h>
+
+#include <asm/mach/time.h>
+#include <asm/hardware/timer-sp.h>
+#include <asm/mach/map.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+#include "common.h"
+#include "touchpad.h"
+
+/* Clock */
+
+union reg_clk_speed {
+	unsigned long raw;
+	struct {
+		unsigned long __padding0:1;
+		unsigned long base_cpu_ratio:7;
+		unsigned long is_base_48mhz:1;
+		unsigned long __padding1:3;
+		unsigned long cpu_ahb_ratio:3;
+		unsigned long base_val:6;
+		unsigned long unknown:2;
+	} val;
+};
+
+static struct nspire_clk_speeds cx_io_to_clocks(unsigned long val)
+{
+	struct nspire_clk_speeds clks;
+	union reg_clk_speed reg;
+
+	reg.raw = val;
+	reg.val.base_cpu_ratio *= reg.val.unknown;
+	reg.val.cpu_ahb_ratio++;
+
+	BUG_ON(reg.val.base_cpu_ratio == 0);
+
+	clks.base = reg.val.is_base_48mhz ? 48 : 6*reg.val.base_val;
+	clks.base *= 1000000; /* Convert to Hz */
+
+	clks.div.base_cpu = reg.val.base_cpu_ratio;
+	clks.div.cpu_ahb = reg.val.cpu_ahb_ratio;
+
+	return clks;
+}
+
+static unsigned long cx_clocks_to_io(struct nspire_clk_speeds *clks)
+{
+	union reg_clk_speed reg;
+
+	BUG_ON(clks->div.base_cpu < 1);
+	BUG_ON(clks->div.cpu_ahb < 1);
+
+	reg.raw = 0;
+	reg.val.unknown = (clks->div.base_cpu & 0x1) ? 0b01 : 0b10;
+	reg.val.base_cpu_ratio = clks->div.base_cpu / reg.val.unknown;
+	reg.val.cpu_ahb_ratio = clks->div.cpu_ahb - 1;
+	reg.val.is_base_48mhz = (clks->base <= 48000000);
+	reg.val.base_val = (clks->base / 6000000);
+
+	return reg.raw;
+}
+
+/* IRQ */
+static void __init cx_init_irq(void)
+{
+	vic_init(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE), 0, NSPIRE_IRQ_MASK, 0);
+}
+
+/* UART */
+
+static AMBA_APB_DEVICE(uart, "uart", 0, NSPIRE_APB_PHYS(NSPIRE_APB_UART),
+	{ NSPIRE_IRQ_UART }, NULL);
+
+/* TIMER */
+
+void __init cx_timer_init(void)
+{
+	sp804_clockevents_init(NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2),
+		NSPIRE_IRQ_TIMER2, "timer2");
+}
+
+/* FRAMEBUFFER */
+static struct clcd_panel cx_lcd_panel = {
+	.mode		= {
+		.name		= "color lcd",
+		.refresh	= 60,
+		.xres		= 320,
+		.yres		= 240,
+		.sync		= 0,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.pixclock	= 1,
+		.hsync_len	= 6,
+		.vsync_len	= 1,
+		.right_margin	= 50,
+		.left_margin	= 38,
+		.lower_margin	= 3,
+		.upper_margin	= 17,
+	},
+	.width		= 65, /* ~6.50 cm */
+	.height		= 49, /* ~4.87 cm */
+	.tim2		= TIM2_IPC,
+	.cntl		= (CNTL_BGR | CNTL_LCDTFT | CNTL_LCDVCOMP(1) |
+				CNTL_LCDBPP16_565),
+	.bpp		= 16,
+};
+#define PANEL_SIZE (38 * SZ_4K)
+
+static int cx_clcd_setup(struct clcd_fb *fb)
+{
+	return nspire_clcd_setup(fb, PANEL_SIZE, &cx_lcd_panel);
+}
+
+static struct clcd_board cx_clcd_data = {
+	.name		= "lcd controller",
+	.check		= clcdfb_check,
+	.decode		= clcdfb_decode,
+	.setup		= cx_clcd_setup,
+	.mmap		= nspire_clcd_mmap,
+	.remove		= nspire_clcd_remove,
+};
+
+static AMBA_AHB_DEVICE(fb, "fb", 0, NSPIRE_LCD_PHYS_BASE,
+	{ NSPIRE_IRQ_LCD }, &cx_clcd_data);
+
+/* USB HOST */
+
+static struct usb_ehci_pdata cxusbhost_pdata = {
+	.has_tt = 1,
+	.caps_offset = 0x100
+};
+
+static struct resource cxusbhost_resources_pdata[] = {
+	RESOURCE_ENTRY_MEM(OTG),
+	RESOURCE_ENTRY_IRQ(OTG)
+};
+
+static struct platform_device usbhost_device = {
+	.name		= "ehci-platform",
+	.id		= 0,
+	.dev = {
+		.platform_data = &cxusbhost_pdata,
+		.coherent_dma_mask = ~0,
+		.dma_mask = &nspire_usb_dma_mask
+	},
+	.resource = cxusbhost_resources_pdata,
+	.num_resources = ARRAY_SIZE(cxusbhost_resources_pdata)
+};
+
+
+static __init int cx_usb_init(void)
+{
+	int err = 0;
+	unsigned val;
+	void __iomem *hostusb_addr =
+		ioremap(NSPIRE_OTG_PHYS_BASE, NSPIRE_OTG_SIZE);
+
+	if (!hostusb_addr) {
+		pr_warn("Could not allocate enough memory to initialize NSPIRE host USB\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* Disable OTG interrupts */
+	pr_info("Disable OTG interrupts\n");
+	val	 = readl(hostusb_addr + 0x1a4);
+	val &= ~(0x7f<<24);
+	writel(val, hostusb_addr + 0x1a4);
+
+	iounmap(hostusb_addr);
+
+	pr_info("Adding USB controller as platform device\n");
+	err = platform_device_register(&usbhost_device);
+out:
+
+	return err;
+}
+
+static __init int cx_usb_workaround(void)
+{
+	int err = 0;
+	unsigned val;
+	void __iomem *hostusb_addr =
+		ioremap(NSPIRE_OTG_PHYS_BASE, NSPIRE_OTG_SIZE);
+
+	if (!hostusb_addr) {
+		pr_warn("Could not do USB workaround\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	pr_info("Temporary USB hack to force USB to connect as fullspeed\n");
+	val	 = readl(hostusb_addr + 0x184);
+	val |= (1<<24);
+	writel(val, hostusb_addr + 0x184);
+
+	iounmap(hostusb_addr);
+out:
+
+	return err;
+}
+
+/* Backlight driver */
+
+#define CX_BACKLIGHT_UPPER	0x1d0
+#define CX_BACKLIGHT_LOWER	0x100 /* Should be (around about) off */
+
+static void cx_set_backlight(int val)
+{
+	val += CX_BACKLIGHT_LOWER;
+
+	if (val <= CX_BACKLIGHT_UPPER)
+		writel(val, NSPIRE_APB_VIRTIO(NSPIRE_APB_CONTRAST + 0x20));
+}
+
+static struct generic_bl_info cx_bl = {
+	.name		= "nspire_backlight",
+	.max_intensity	= CX_BACKLIGHT_UPPER - CX_BACKLIGHT_LOWER,
+	.default_intensity = (CX_BACKLIGHT_UPPER - CX_BACKLIGHT_LOWER) / 2,
+	.set_bl_intensity = cx_set_backlight
+};
+
+static struct platform_device bl_device = {
+	.name		= "generic-bl",
+	.id		= 0,
+	.dev = {
+		.platform_data = &cx_bl,
+	}
+};
+
+/* Init */
+
+bool cx_use_otg;
+static int __init set_cx_otg(char *dummy __attribute__((unused)))
+{
+	cx_use_otg = 1;
+	return 0;
+}
+early_param("cx_use_otg", set_cx_otg);
+
+static void __init cx_early_init(void)
+{
+	nspire_io_to_clocks = cx_io_to_clocks;
+	nspire_clocks_to_io = cx_clocks_to_io;
+
+	nspire_init_early();
+}
+
+static void __init cx_init(void)
+{
+	nspire_init();
+	amba_device_register(&fb_device, &iomem_resource);
+	amba_device_register(&uart_device, &iomem_resource);
+
+	nspire_keypad_data.evtcodes = nspire_touchpad_evtcode_map;
+	platform_device_register(&nspire_keypad_device);
+	platform_device_register(&bl_device);
+	nspire_touchpad_init();
+
+	if (!cx_use_otg) {
+		pr_info("Selecting USB host only driver for CX\n");
+		cx_usb_init();
+	} else {
+		pr_info("Selecting USB OTG driver for CX\n");
+		platform_device_register(&nspire_otg_device);
+		platform_device_register(&nspire_usb_nop_xceiver);
+	}
+}
+
+static void __init cx_init_late(void)
+{
+	if (!cx_use_otg)
+		cx_usb_workaround();
+	nspire_init_late();
+}
+
+MACHINE_START(NSPIRECX, "TI-NSPIRE CX Calculator")
+	.nr_irqs	= NR_IRQS,
+	.map_io		= nspire_map_io,
+	.init_irq	= cx_init_irq,
+	.init_time	= cx_timer_init,
+	.init_early	= cx_early_init,
+	.init_machine	= cx_init,
+	.init_late	= cx_init_late,
+	.restart	= nspire_restart,
+MACHINE_END
diff --git a/arch/arm/mach-nspire/nspire_tp.c b/arch/arm/mach-nspire/nspire_tp.c
new file mode 100644
index 0000000..cec05b6
--- /dev/null
+++ b/arch/arm/mach-nspire/nspire_tp.c
@@ -0,0 +1,80 @@
+/*
+ *	linux/arch/arm/mach-nspire/nspire_clp.c
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/clkdev.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/clcd.h>
+#include <linux/input.h>
+#include <linux/usb/ehci_pdriver.h>
+#include <linux/mtd/nand.h>
+#include <linux/irq.h>
+#include <linux/i2c-gpio.h>
+
+#include <mach/nspire_mmio.h>
+#include <mach/irqs.h>
+#include <mach/clkdev.h>
+#include <mach/sram.h>
+#include <mach/keypad.h>
+
+#include <asm/mach/time.h>
+#include <asm/mach/map.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+#include "common.h"
+#include "classic.h"
+#include "touchpad.h"
+
+/* I2C GPIO (touchpad) */
+
+static struct i2c_gpio_platform_data i2c_pdata = {
+	.sda_pin	= 3,
+	.scl_pin	= 1,
+	.udelay		= 1,
+	.timeout	= 1000,
+};
+
+static struct platform_device i2c_device = {
+	.name		= "i2c-gpio",
+	.id		= 0,
+	.dev = {
+		.platform_data = &i2c_pdata,
+	}
+};
+
+static void __init tp_init(void)
+{
+	nspire_keypad_data.evtcodes = nspire_touchpad_evtcode_map;
+	platform_device_register(&i2c_device);
+
+	platform_device_register(&nspire_otg_device);
+	platform_device_register(&nspire_usb_nop_xceiver);
+
+	nspire_classic_init();
+	nspire_touchpad_init();
+}
+
+MACHINE_START(NSPIRETP, "TI-NSPIRE Touchpad Calculator")
+	.map_io		= nspire_map_io,
+	.init_irq	= nspire_classic_init_irq,
+	.handle_irq	= nspire_classic_handle_irq,
+	.init_time	= nspire_classic_timer_init,
+	.init_early	= nspire_classic_init_early,
+	.init_machine	= tp_init,
+	.init_late	= nspire_classic_init_late,
+	.restart	= nspire_restart,
+MACHINE_END
diff --git a/arch/arm/mach-nspire/sram.c b/arch/arm/mach-nspire/sram.c
new file mode 100644
index 0000000..52b8e5c
--- /dev/null
+++ b/arch/arm/mach-nspire/sram.c
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA 02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/genalloc.h>
+
+static unsigned long sram_phys_base;
+static __iomem void *sram_virt_base;
+static struct gen_pool *sram_pool;
+
+#define sram_phys_to_virt(p) (sram_virt_base + ((p) - sram_phys_base))
+
+void *sram_alloc(unsigned int size, dma_addr_t *dma_addr)
+{
+	if (!sram_pool)
+		return NULL;
+
+	*dma_addr = gen_pool_alloc(sram_pool, size);
+	pr_info("sram alloc - %dB@0x%p\n", size, (void *)*dma_addr);
+	return sram_phys_to_virt(*dma_addr);
+}
+EXPORT_SYMBOL(sram_alloc);
+
+void sram_free(dma_addr_t addr, unsigned int size)
+{
+	if (!sram_pool)
+		return;
+
+	gen_pool_free(sram_pool, addr, size);
+}
+EXPORT_SYMBOL(sram_free);
+
+int __init sram_init(unsigned long base, unsigned long size)
+{
+	sram_phys_base = base;
+
+	sram_pool = gen_pool_create(10, -1);
+	if (!sram_pool) {
+		pr_warn("Cannot create sram pool!\n");
+		return -ENOMEM;
+	}
+	gen_pool_add(sram_pool, base, size, -1);
+	sram_virt_base = ioremap(sram_phys_base, size);
+
+	pr_info("sram pool: %ld KB@0x%p\n", size / 1024, sram_virt_base);
+	return 0;
+}
diff --git a/arch/arm/mach-nspire/touchpad.c b/arch/arm/mach-nspire/touchpad.c
new file mode 100644
index 0000000..2330451
--- /dev/null
+++ b/arch/arm/mach-nspire/touchpad.c
@@ -0,0 +1,30 @@
+/*
+ *	linux/arch/arm/mach-nspire/touchpad.c
+ *
+ *	Copyright (C) 2012 Fabian Vogt <fabian@ritter-vogt.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/i2c.h>
+
+#include "touchpad.h"
+
+#if defined(CONFIG_MOUSE_SYNAPTICS_I2C) || \
+	defined(CONFIG_MOUSE_SYNAPTICS_I2C_MODULE)
+static struct i2c_board_info synaptics_i2c = {
+	I2C_BOARD_INFO("synaptics_i2c", 0x20),
+	.irq    = 0,
+};
+
+void __init nspire_touchpad_init()
+{
+	i2c_register_board_info(0, &synaptics_i2c, 1);
+}
+
+#else
+inline void nspire_touchpad_init() {}
+#endif
diff --git a/arch/arm/mach-nspire/touchpad.h b/arch/arm/mach-nspire/touchpad.h
new file mode 100644
index 0000000..9222572
--- /dev/null
+++ b/arch/arm/mach-nspire/touchpad.h
@@ -0,0 +1,17 @@
+/*
+ *	linux/arch/arm/mach-nspire/touchpad.c
+ *
+ *	Copyright (C) 2012 Fabian Vogt <fabian@ritter-vogt.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef TOUCHPAD_H
+#define TOUCHPAD_H
+
+void __init nspire_touchpad_init(void);
+
+#endif
diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 831e1fd..e76c16b 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -1204,3 +1204,6 @@ baileys			MACH_BAILEYS		BAILEYS			4169
 familybox		MACH_FAMILYBOX		FAMILYBOX		4170
 ensemble_mx35		MACH_ENSEMBLE_MX35	ENSEMBLE_MX35		4171
 sc_sps_1		MACH_SC_SPS_1		SC_SPS_1		4172
+nspireclp		MACH_NSPIRECLP		NSPIRECLP		4441
+nspiretp		MACH_NSPIRETP		NSPIRETP		4442
+nspirecx		MACH_NSPIRECX		NSPIRECX		4443
--
1.7.9.6 (Apple Git-31.1)


