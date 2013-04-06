Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163338Ab3DFMA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 08:00:27 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37990 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163327Ab3DFMAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 08:00:25 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201304061351.00889.arnd@arndb.de>
Date: Sat, 6 Apr 2013 23:00:15 +1100
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        fabian@ritter-vogt.de, Lionel Debroux <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <F832F4F9-8162-43B8-B9E0-D5D8C8B8C77A@gmail.com>
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <201304041112.25780.arnd@arndb.de> <8FB21B56-58BC-4530-8C7A-71A32856210D@gmail.com> <201304061351.00889.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On 06/04/2013, at 10:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> Ok, whichever way you prefer. If you have questions while working on this,
> feel free to join #armlinux on irc.freenode.net, there are usually other
> people working on the same things.
> 

Cheers.

We already have something basic that boots successfully using device trees. 

Some comments before we continue would be greatly appreciated.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 arch/arm/Kconfig                                |   13 ++
 arch/arm/Makefile                               |    3 +-
 arch/arm/boot/dts/nspire-cx.dts                 |   85 +++++++++++++
 arch/arm/boot/dts/nspire.dtsi                   |  154 +++++++++++++++++++++++
 arch/arm/mach-nspire/Makefile                   |    3 +
 arch/arm/mach-nspire/include/mach/debug-macro.S |   25 ++++
 arch/arm/mach-nspire/include/mach/timex.h       |   15 +++
 arch/arm/mach-nspire/include/mach/uncompress.h  |   25 ++++
 arch/arm/mach-nspire/mmio.h                     |   13 ++
 arch/arm/mach-nspire/nspire.c                   |  107 ++++++++++++++++
 10 files changed, 442 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/nspire-cx.dts
 create mode 100644 arch/arm/boot/dts/nspire.dtsi
 create mode 100644 arch/arm/mach-nspire/Makefile
 create mode 100644 arch/arm/mach-nspire/Makefile.boot
 create mode 100644 arch/arm/mach-nspire/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-nspire/include/mach/timex.h
 create mode 100644 arch/arm/mach-nspire/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-nspire/mmio.h
 create mode 100644 arch/arm/mach-nspire/nspire.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1cacda4..e8ce316 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -980,6 +980,19 @@ config ARCH_OMAP1
 	help
 	  Support for older TI OMAP1 (omap7xx, omap15xx or omap16xx)
 
+config ARCH_NSPIRE
+	bool "TI-NSPIRE based"
+	depends on MMU
+	select CPU_ARM926T
+	select COMMON_CLK
+	select GENERIC_CLOCKEVENTS
+	select SPARSE_IRQ
+	select ARM_AMBA
+	select ARM_VIC
+	select ARM_TIMER_SP804
+	help
+	  This enables support for systems using the TI-NSPIRE CPU
+
 endchoice
 
 menu "Multiple platform selection"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index ee4605f..f47a8a7 100644
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
@@ -313,7 +314,7 @@ define archhelp
   echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
   echo  '* xipImage      - XIP kernel image, if configured (arch/$(ARCH)/boot/xipImage)'
   echo  '  uImage        - U-Boot wrapped zImage'
-  echo  '  bootpImage    - Combined zImage and initial RAM disk' 
+  echo  '  bootpImage    - Combined zImage and initial RAM disk'
   echo  '                  (supply initrd image via make variable INITRD=<path>)'
   echo  '* dtbs          - Build device tree blobs for enabled boards'
   echo  '  install       - Install uncompressed kernel'
diff --git a/arch/arm/boot/dts/nspire-cx.dts b/arch/arm/boot/dts/nspire-cx.dts
new file mode 100644
index 0000000..6ab3c00
--- /dev/null
+++ b/arch/arm/boot/dts/nspire-cx.dts
@@ -0,0 +1,85 @@
+/*
+ *  linux/arch/arm/boot/nspire-cx.dts
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+/dts-v1/;
+
+/include/ "nspire.dtsi"
+
+/ {
+	model = "TI-NSPIRE CX";
+	compatible = "arm,nspire-cx";
+
+	memory {
+		device_type = "memory";
+		reg = <0x10000000 0x4000000>; /* 64 MB */
+	};
+
+	aliases {
+		uart0 = &uart0;
+		timer0 = &timer0;
+		timer1 = &timer1;
+		fast_timer = &fast_timer;
+	};
+
+	uart_clk: uart_clk {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <12000000>;
+	};
+
+	/* Not really a fixed clock but we'll fix this later */
+	apb_pclk: apb_pclk {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <33000000>;
+	};
+
+	ahb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		intc: interrupt-controller@DC000000 {
+			compatible = "arm,pl190-vic";
+			interrupt-controller;
+			reg = <0xDC000000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+		apb@90000000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			i2c@90050000 {
+				compatible = "snps,designware-i2c";
+				reg = <0x90050000 0x1000>;
+				interrupts = <20>;
+			};
+
+			fast_timer: timer@90010000 {
+				compatible = "arm,sp804", "arm,primecell";
+			};
+
+			uart0: uart@90020000 {
+				compatible = "arm,pl011", "arm,primecell";
+			};
+
+			timer0: timer0@900C0000 {
+				compatible = "arm,sp804", "arm,primecell";
+			};
+
+			timer1: timer1@900D0000 {
+				compatible = "arm,sp804", "arm,primecell";
+			};
+		};
+	};
+	chosen {
+		bootargs = "debug earlyprintk console=ttyAMA0,115200n8";
+	};
+};
diff --git a/arch/arm/boot/dts/nspire.dtsi b/arch/arm/boot/dts/nspire.dtsi
new file mode 100644
index 0000000..db7584a
--- /dev/null
+++ b/arch/arm/boot/dts/nspire.dtsi
@@ -0,0 +1,154 @@
+/*
+ *  linux/arch/arm/boot/nspire.dtsi
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	cpus {
+		cpu@0 {
+			compatible = "arm,arm926";
+		};
+	};
+
+	bootrom: bootrom@00000000 {
+		reg = <0x00000000 0x80000>;
+	};
+
+	sram: sram@A4000000 {
+		device = "memory";
+		reg = <0xA4000000 0x20000>;
+	};
+
+	timer_clk: timer_clk {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <32768>;
+	};
+
+	ahb {
+		compatible = "arm,amba-bus", "simple-bus";
+		interrupt-parent = <&intc>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		spi: spi@A9000000 {
+			reg = <0xA9000000 0x1000>;
+		};
+
+		usb0: usb@B0000000 {
+			reg = <0xB0000000 0x1000>;
+			interrupts = <8>;
+		};
+
+		usb1: usb@B4000000 {
+			reg = <0xB4000000 0x1000>;
+			interrupts = <9>;
+			status = "disabled";
+		};
+
+		lcd: lcd@C0000000 {
+			compatible = "arm,amba-primecell";
+			reg = <0xC0000000 0x1000>;
+			interrupts = <21>;
+		};
+
+		adc: adc@C4000000 {
+			reg = <0xC4000000 0x1000>;
+			interrupts = <11>;
+		};
+
+		tdes: tdes@C8010000 {
+			reg = <0xC8010000 0x1000>;
+		};
+
+		sha256: sha256@CC000000 {
+			reg = <0xCC000000 0x1000>;
+		};
+
+		apb@90000000 {
+			compatible = "arm,amba-bus", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			clocks = <&apb_pclk>;
+			clock-names = "apb_pclk";
+			clock-ranges;
+			ranges;
+
+			gpio: gpio@90000000 {
+				reg = <0x90000000 0x1000>;
+				interrupts = <7>;
+			};
+
+			fast_timer: timer@90010000 {
+				reg = <0x90010000 0x1000>;
+				interrupts = <17>;
+			};
+
+			uart: uart@90020000 {
+				reg = <0x90020000 0x1000>;
+				interrupts = <1>;
+
+				clocks = <&uart_clk>;
+				clock-names = "uart_clk";
+			};
+
+			timer0: timer0@900C0000 {
+				reg = <0x900C0000 0x1000>;
+				interrupts = <18>;
+
+				clocks = <&timer_clk>;
+				clock-names = "timer_clk";
+			};
+
+			timer1: timer1@900D0000 {
+				reg = <0x900D0000 0x1000>;
+				interrupts = <19>;
+
+				clocks = <&timer_clk>;
+				clock-names = "timer_clk";
+			};
+
+			watchdog: watchdog@90060000 {
+				compatible = "arm,amba-primecell";
+				reg = <0x90060000 0x1000>;
+				interrupts = <3>;
+			};
+
+			rtc: rtc@90090000 {
+				reg = <0x90090000 0x1000>;
+				interrupts = <4>;
+			};
+
+			misc: misc@900A0000 {
+				reg = <0x900A0000 0x1000>;
+			};
+
+			pwr: pwr@900B0000 {
+				reg = <0x900B0000 0x1000>;
+				interrupts = <15>;
+			};
+
+			keypad: input@900E0000 {
+				reg = <0x900E0000 0x1000>;
+				interrupts = <16>;
+			};
+
+			contrast: contrast@900F0000 {
+				reg = <0x900F0000 0x1000>;
+			};
+
+			led: led@90110000 {
+				reg = <0x90110000 0x1000>;
+			};
+		};
+	};
+};
diff --git a/arch/arm/mach-nspire/Makefile b/arch/arm/mach-nspire/Makefile
new file mode 100644
index 0000000..62b9baa
--- /dev/null
+++ b/arch/arm/mach-nspire/Makefile
@@ -0,0 +1,3 @@
+obj-y				:=
+
+obj-y				+= nspire.o
diff --git a/arch/arm/mach-nspire/Makefile.boot b/arch/arm/mach-nspire/Makefile.boot
new file mode 100644
index 0000000..e69de29
diff --git a/arch/arm/mach-nspire/include/mach/debug-macro.S b/arch/arm/mach-nspire/include/mach/debug-macro.S
new file mode 100644
index 0000000..d583485
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/debug-macro.S
@@ -0,0 +1,25 @@
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
+#include "../../mmio.h"
+
+.macro	addruart, rp, rv, tmp
+	ldr \rp, =(NSPIRE_EARLY_UART_PHYS_BASE)		@ physical base address
+	ldr \rv, =(NSPIRE_EARLY_UART_VIRT_BASE)		@ virtual base address
+.endm
+
+#include <asm/hardware/debug-pl01x.S>
+
+
+/*
+#define UART_SHIFT 2
+#include <asm/hardware/debug-8250.S>
+*/
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
index 0000000..d957214
--- /dev/null
+++ b/arch/arm/mach-nspire/include/mach/uncompress.h
@@ -0,0 +1,25 @@
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
+#define OFFSET_VAL(var, offset) ((var)[(offset)>>2])
+static inline void putc(int c)
+{
+}
+#undef OFFSET_VAL
+
+#define arch_decomp_setup()
+#define flush()
+
+#endif
diff --git a/arch/arm/mach-nspire/mmio.h b/arch/arm/mach-nspire/mmio.h
new file mode 100644
index 0000000..6e2fe95
--- /dev/null
+++ b/arch/arm/mach-nspire/mmio.h
@@ -0,0 +1,13 @@
+/*
+ *	linux/arch/arm/mach-nspire/mmio.h
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
diff --git a/arch/arm/mach-nspire/nspire.c b/arch/arm/mach-nspire/nspire.c
new file mode 100644
index 0000000..ec7734a
--- /dev/null
+++ b/arch/arm/mach-nspire/nspire.c
@@ -0,0 +1,107 @@
+/*
+ *	linux/arch/arm/mach-nspire/nspire.c
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/init.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/irqchip.h>
+#include <linux/irqchip/arm-vic.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach-types.h>
+#include <asm/mach/map.h>
+
+#include <asm/hardware/timer-sp.h>
+
+#include "mmio.h"
+
+static const char *nspire_dt_match[] __initconst = {
+	"arm,nspire",
+	"arm,nspire-cx",
+	"arm,nspire-tp",
+	"arm,nspire-clp",
+	NULL,
+};
+
+static struct map_desc nspire_io_desc[] __initdata = {
+	{
+		.virtual	=  NSPIRE_EARLY_UART_VIRT_BASE,
+		.pfn		= __phys_to_pfn(NSPIRE_EARLY_UART_PHYS_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE
+	}
+};
+
+static void __init nspire_init_timer(void)
+{
+	struct device_node *timer;
+	void __iomem *base;
+	const char *path;
+	struct clk *clk;
+	int irq, err;
+
+	of_clk_init(NULL);
+
+	err = of_property_read_string(of_aliases, "timer0", &path);
+	if (WARN_ON(err))
+		return;
+
+	timer = of_find_node_by_path(path);
+	base = of_iomap(timer, 0);
+	if (WARN_ON(!base))
+		return;
+
+	clk = of_clk_get_by_name(timer, NULL);
+	clk_register_clkdev(clk, timer->name, "sp804");
+
+	sp804_clocksource_init(base, timer->name);
+
+	err = of_property_read_string(of_aliases, "timer1", &path);
+	if (WARN_ON(err))
+		return;
+
+	timer = of_find_node_by_path(path);
+	base = of_iomap(timer, 0);
+	if (WARN_ON(!base))
+		return;
+
+	clk = of_clk_get_by_name(timer, NULL);
+	clk_register_clkdev(clk, timer->name, "sp804");
+
+	irq = irq_of_parse_and_map(timer, 0);
+	sp804_clockevents_init(base, irq, timer->name);
+}
+
+static void __init nspire_map_io(void)
+{
+	iotable_init(nspire_io_desc, ARRAY_SIZE(nspire_io_desc));
+}
+
+static void __init nspire_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table,
+			NULL, NULL);
+}
+
+static void nspire_restart(char mode, const char *cmd)
+{
+}
+
+DT_MACHINE_START(NSPIRE, "TI-NSPIRE")
+	.map_io		= nspire_map_io,
+	.init_irq	= irqchip_init,
+	.init_time	= nspire_init_timer,
+	.init_machine	= nspire_init,
+	.dt_compat	= nspire_dt_match,
+	.restart	= nspire_restart,
+MACHINE_END
-- 
1.7.9.6 (Apple Git-31.1)


