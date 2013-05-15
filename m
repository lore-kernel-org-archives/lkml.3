Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3EOLUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:20:32 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:42396 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab3EOLUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <201303181503.49491.arnd@arndb.de>
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com>
	<201303151125.53999.arnd@arndb.de>
	<CACmBeS3aXs9vhc5ZYPbz5bjsYsSa6EzM12H4uPv706x0zU_5iw@mail.gmail.com>
	<201303181503.49491.arnd@arndb.de>
Date: Wed, 15 May 2013 13:20:29 +0200
Message-ID: <CACmBeS1empYyoaKidgTrYwUFCw447OKndxZjT98TvYfKVWB00A@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Mack <zonque@gmail.com>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

.. it's been a while ..

This is now rebased for 3.10 and DT thanks to help from #armlinux on
Freenode. It should tick the boxes in the list from Arnd.

I'm only posting changes in arch/arm/* and will continue submitting
drivers separately as requested, this applies to next-20130515.

The full repository is available @
https://code.google.com/p/linux-3-9-rc3-moxart/source/list

Note: no boot without clocksource and irqchip drivers (I'll submit
these separately to the correct maintainers).

Also it won't boot without reverting the following commit:
e651eab0af88aa7a281fe9e8c36c0846552aa7fc - "ARM: 7677/1: LPAE: Fix
mapping in alloc_init_section for unaligned addresses"

Best regards,
Jonas


Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---
 arch/arm/Kconfig                           |    2 +
 arch/arm/Kconfig.debug                     |   10 +++
 arch/arm/Makefile                          |    1 +
 arch/arm/boot/dts/Makefile                 |    1 +
 arch/arm/boot/dts/moxart-uc7112lx.dts      |   90 ++++++++++++++++++++++
 arch/arm/boot/dts/moxart.dtsi              |   71 +++++++++++++++++
 arch/arm/configs/moxart_uc7112lx_defconfig |  113 ++++++++++++++++++++++++++++
 arch/arm/include/debug/moxart.S            |   14 ++++
 arch/arm/mach-moxart/Kconfig               |   34 ++++++++
 arch/arm/mach-moxart/Makefile              |   12 +++
 arch/arm/mach-moxart/Makefile.boot         |    3 +
 arch/arm/mach-moxart/idle.c                |   31 ++++++++
 arch/arm/mach-moxart/moxart.c              |   42 ++++++++++
 arch/arm/mach-moxart/moxart.h              |   11 +++
 14 files changed, 435 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7b7ab65..eba7935 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -938,6 +938,8 @@ source "arch/arm/mach-footbridge/Kconfig"

 source "arch/arm/mach-gemini/Kconfig"

+source "arch/arm/mach-moxart/Kconfig"
+
 source "arch/arm/mach-highbank/Kconfig"

 source "arch/arm/mach-integrator/Kconfig"
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 29f7623..d534fce 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -429,6 +429,15 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on Allwinner A1X based platforms on the UART1.

+	config DEBUG_MOXART_UART0
+        bool "Kernel low-level debugging messages via MOXART UART0"
+        depends on ARCH_MOXART
+        help
+          Say Y here if you want kernel low-level debugging support
+          on MOXART based platforms on the UART0.
+          select this to make sure "putc" in arch/arm/boot/compressed/debug.S
+          uses arch/arm/include/debug/moxart.S:s "addruart" macro
+
 	config DEBUG_TEGRA_UART
 		depends on ARCH_TEGRA
 		bool "Use Tegra UART for low-level debug"
@@ -651,6 +660,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
 	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
 	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
+	default "debug/moxart.S" if DEBUG_MOXART_UART0
 	default "debug/tegra.S" if DEBUG_TEGRA_UART
 	default "debug/ux500.S" if DEBUG_UX500_UART
 	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT || \
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 3380c4f..2e964a9 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -148,6 +148,7 @@ machine-$(CONFIG_ARCH_DOVE)		+= dove
 machine-$(CONFIG_ARCH_EBSA110)		+= ebsa110
 machine-$(CONFIG_ARCH_EP93XX)		+= ep93xx
 machine-$(CONFIG_ARCH_GEMINI)		+= gemini
+machine-$(CONFIG_ARCH_MOXART)       += moxart
 machine-$(CONFIG_ARCH_HIGHBANK)		+= highbank
 machine-$(CONFIG_ARCH_INTEGRATOR)	+= integrator
 machine-$(CONFIG_ARCH_IOP13XX)		+= iop13xx
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 87e603c..8fbd32d 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -210,6 +210,7 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8650-mid.dtb \
 	wm8850-w70v2.dtb
 dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
+dtb-$(CONFIG_ARCH_MOXART) += moxart-uc7112lx.dtb

 targets += dtbs
 targets += $(dtb-y)
diff --git a/arch/arm/boot/dts/moxart-uc7112lx.dts
b/arch/arm/boot/dts/moxart-uc7112lx.dts
new file mode 100644
index 0000000..44d4e33
--- /dev/null
+++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
@@ -0,0 +1,90 @@
+/* moxart-uc7112lx.dts - Device Tree file for MOXA UC-7112-LX
+ *
+ * Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * Licensed under GPLv2 or later. */
+
+/dts-v1/;
+/include/ "moxart.dtsi"
+
+/ {
+	model = "MOXA UC-7112-LX";
+	compatible = "moxart,moxart-uc-7112-lx";
+
+	memory {
+		reg = <0x00000000 0x02000000>;
+	};
+
+	flash@80000000,0 {
+		/* JS28F128 J3D75 A9087684 - Numonyx™ Embedded Flash Memory (J3 v. D) */
+		compatible = "numonyx,js28f128", "cfi-flash";
+		reg = <0x80000000 0x01000000>;
+		bank-width = <2>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		partition@0 {
+			label = "bootloader";
+			reg = <0x00000000 0x00040000>;
+		};
+		partition@40000 {
+			label = "linux kernel";
+			reg = <0x00040000 0x001C0000>;
+		};
+		partition@200000 {
+			label = "root filesystem";
+			reg = <0x00200000 0x00800000>;
+		};
+		partition@a00000 {
+			label = "user filesystem";
+			reg = <0x00a00000 0x00600000>;
+		};
+	};
+
+	mmc@98e00000 {
+		compatible = "moxart,moxart-mmc";
+		reg =	<0x98e00000 0x00001000>,
+				<0x98100000 0x1000>;		/* PMU */
+		interrupts = <5 0>;
+	};
+
+	mxser@98200040 {
+		compatible = "moxart,moxart-mxser";
+		reg =	<0x98200040 0x00000080>,	/* UART "3" base */
+				<0x982000e4 0x00000080>,	/* UART mode base */
+				<0x982000c0 0x00000020>;	/* UART interrupt vector */
+		interrupts = <31 1>;
+	};
+
+	mac0: mac@90900000 {
+		compatible = "moxart,moxart-mac0";
+		reg =   <0x90900000 0x1000>,
+				<0x80000000 0x01000000>;	/* MAC address stored on flash */
+		interrupts = <25 0>;
+		flash-offset = <0x50>;
+	};
+
+	mac1: mac@92000000 {
+		compatible = "moxart,moxart-mac1";
+		reg =   <0x92000000 0x1000>,
+				<0x80000000 0x01000000>;	/* MAC address stored on flash */
+		interrupts = <27 0>;
+		flash-offset = <0x56>;
+	};
+
+	uart0: uart@98200000 {
+		compatible = "ns16550a";
+		reg = <0x98200000 0x20>;
+		interrupts = <31 0>;
+		reg-shift = <2>;
+		reg-io-width = <4>;
+		clock-frequency = <14745600>;
+		status = "okay";
+	};
+
+	chosen {
+		/* uncomment to use on board flash root
+		bootargs = "console=ttyS0,115200n8 root=/dev/mtdblock2 rootfstype=jffs2 rw";
+		*/
+		bootargs = "console=ttyS0,115200n8 root=/dev/mmcblk0p1 rw rootwait";
+	};
+};
diff --git a/arch/arm/boot/dts/moxart.dtsi b/arch/arm/boot/dts/moxart.dtsi
new file mode 100644
index 0000000..56743bc
--- /dev/null
+++ b/arch/arm/boot/dts/moxart.dtsi
@@ -0,0 +1,71 @@
+/* moxart.dtsi - Device Tree Include file for MOXA ART family SoC
+ *
+ * Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * Licensed under GPLv2 or later. */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	interrupt-parent = <&intc>;
+
+	cpus {
+		cpu@0 {
+			compatible = "faraday,fa526";
+		};
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		osc: oscillator {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
+		};
+	};
+
+	soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x90000000 0x10000000>;
+		ranges;
+
+		intc: interrupt-controller@98800000 {
+			compatible = "moxart,moxart-interrupt-controller";
+			reg = <0x98800000 0x38>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			interrupt-mask = <0x00080000>;		/* single register vector,
interrupts 0-31, 1s signify edge */
+		};
+
+		timer0: timer@98400000 {
+			compatible = "moxart,moxart-timer0";
+			reg = <0x98400000 0x10>;
+			interrupts = <19 1>;
+		};
+
+		gpio: gpio@98700000 {
+			compatible = "moxart,moxart-gpio";
+			reg =	<0x98700000 0x1000>,
+					<0x98100000 0x1000>;		/* PMU */
+		};
+
+		rtc: rtc {
+			compatible = "moxart,moxart-rtc";
+		};
+
+		dma: dma@90500000 {
+			compatible = "moxart,moxart-dma";
+			reg = <0x90500000 0x1000>;
+			interrupts = <24 0>;
+		};
+
+		watchdog: watchdog@98500000 {
+			compatible = "moxart,moxart-watchdog";
+			reg = <0x98500000 0x1000>;
+		};
+	};
+};
diff --git a/arch/arm/configs/moxart_uc7112lx_defconfig
b/arch/arm/configs/moxart_uc7112lx_defconfig
new file mode 100644
index 0000000..7c40502
--- /dev/null
+++ b/arch/arm/configs/moxart_uc7112lx_defconfig
@@ -0,0 +1,113 @@
+# CONFIG_LOCALVERSION_AUTO is not set
+# CONFIG_SWAP is not set
+CONFIG_SYSVIPC=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_ELF_CORE is not set
+# CONFIG_BASE_FULL is not set
+# CONFIG_SIGNALFD is not set
+# CONFIG_TIMERFD is not set
+# CONFIG_EVENTFD is not set
+# CONFIG_AIO is not set
+CONFIG_EMBEDDED=y
+# CONFIG_VM_EVENT_COUNTERS is not set
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_COMPAT_BRK is not set
+# CONFIG_LBDAF is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_ARCH_MULTI_V4=y
+# CONFIG_ARCH_MULTI_V7 is not set
+CONFIG_ARCH_MOXART=y
+CONFIG_MACH_UC7112LX=y
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+# CONFIG_OABI_COMPAT is not set
+# CONFIG_ATAGS is not set
+CONFIG_ARM_APPENDED_DTB=y
+CONFIG_NET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_WIRELESS is not set
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+# CONFIG_FW_LOADER is not set
+CONFIG_MTD=y
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_CFI_ADV_OPTIONS=y
+CONFIG_MTD_CFI_GEOMETRY=y
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+CONFIG_MTD_PHYSMAP=y
+CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_PROC_DEVICETREE=y
+CONFIG_NETDEVICES=y
+# CONFIG_NET_CADENCE is not set
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_CIRRUS is not set
+# CONFIG_NET_VENDOR_FARADAY is not set
+# CONFIG_NET_VENDOR_INTEL is not set
+# CONFIG_NET_VENDOR_MARVELL is not set
+# CONFIG_NET_VENDOR_MICREL is not set
+# CONFIG_NET_VENDOR_NATSEMI is not set
+# CONFIG_NET_VENDOR_SEEQ is not set
+# CONFIG_NET_VENDOR_SMSC is not set
+# CONFIG_NET_VENDOR_STMICRO is not set
+# CONFIG_NET_VENDOR_WIZNET is not set
+CONFIG_ARM_MOXART_ETHER=y
+# CONFIG_WLAN is not set
+# CONFIG_INPUT is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_LEGACY_PTYS is not set
+CONFIG_MOXA_SMARTIO=y
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_NR_UARTS=1
+CONFIG_SERIAL_8250_RUNTIME_UARTS=1
+CONFIG_SERIAL_8250_EXTENDED=y
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+CONFIG_SERIAL_OF_PLATFORM=y
+# CONFIG_HW_RANDOM is not set
+CONFIG_GPIO_MOXART=y
+# CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+CONFIG_MOXART_WDT=y
+# CONFIG_USB_SUPPORT is not set
+CONFIG_MMC=y
+CONFIG_MMC_SDHCI_MOXART=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_MOXART=y
+CONFIG_DMADEVICES=y
+CONFIG_MOXART_DMA=y
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_EXT3_FS=y
+CONFIG_TMPFS=y
+CONFIG_JFFS2_FS=y
+CONFIG_PRINTK_TIME=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_SHIRQ=y
+CONFIG_DETECT_HUNG_TASK=y
+# CONFIG_SCHED_DEBUG is not set
+# CONFIG_DEBUG_PREEMPT is not set
+CONFIG_PROVE_LOCKING=y
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_MEMORY_INIT=y
+# CONFIG_FTRACE is not set
+CONFIG_DEBUG_LL=y
+CONFIG_EARLY_PRINTK=y
+CONFIG_KEYS=y
diff --git a/arch/arm/include/debug/moxart.S b/arch/arm/include/debug/moxart.S
new file mode 100644
index 0000000..01e2aee
--- /dev/null
+++ b/arch/arm/include/debug/moxart.S
@@ -0,0 +1,14 @@
+/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version. */
+
+#define MOXART_UART_DEBUG_PHYS_BASE		0x98200000
+
+.macro	addruart, rp, rv, tmp
+	ldr	\rp, =MOXART_UART_DEBUG_PHYS_BASE	@ physical
+.endm
+
+#define UART_SHIFT	2
+#include <asm/hardware/debug-8250.S>
diff --git a/arch/arm/mach-moxart/Kconfig b/arch/arm/mach-moxart/Kconfig
new file mode 100644
index 0000000..e19934c
--- /dev/null
+++ b/arch/arm/mach-moxart/Kconfig
@@ -0,0 +1,34 @@
+config ARCH_MOXART
+	bool "MOXA ART SoC" if (ARCH_MULTI_V4)
+	select ARCH_REQUIRE_GPIOLIB
+	select USE_OF
+	help
+	  Say Y here if you want to run your kernel on hardware
+	  with a MOXA ART SoC.
+	  These are DIN-rail / wall-mountable embedded PCs sold by MOXA.
+	  http://www.moxa.com/product/Embedded_Computers.htm
+
+config SOC_MOXART
+	bool "MOXART support"
+	depends on ARCH_MOXART
+	default y
+	select CPU_FA526
+	select ARM_DMA_MEM_BUFFERABLE
+	help
+	  Support for the MOXA ART SoC. This is a Faraday FA526 ARMv4 32-bit
192 MHz processor with MMU and 16KB/8KB D/I-cache (UC-7112-LX)
+	  This perticular SoC is used on models UC-7101, UC-7112/UC-7110,
IA240/IA241, IA3341.
+	  These are DIN-rail / wall-mountable embedded PCs sold by MOXA (
http://www.moxa.com/product/Embedded_Computers.htm ).
+
+if ARCH_MOXART
+
+menu "MOXA ART SoC Implementation"
+
+config MACH_UC7112LX
+	bool "MOXA UC-7112-LX"
+	depends on ARCH_MOXART && SOC_MOXART
+	help
+	  Say Y here if you intend to run this kernel on a MOXA UC-7112-LX
embedded computer.
+
+endmenu
+
+endif
diff --git a/arch/arm/mach-moxart/Makefile b/arch/arm/mach-moxart/Makefile
new file mode 100644
index 0000000..b4a1923
--- /dev/null
+++ b/arch/arm/mach-moxart/Makefile
@@ -0,0 +1,12 @@
+#
+# Makefile for the linux kernel.
+#
+
+ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
+
+# Object file lists.
+
+obj-y          := idle.o
+
+obj-$(CONFIG_MACH_UC7112LX)	+= moxart.o
+
diff --git a/arch/arm/mach-moxart/Makefile.boot
b/arch/arm/mach-moxart/Makefile.boot
new file mode 100644
index 0000000..760a0ef
--- /dev/null
+++ b/arch/arm/mach-moxart/Makefile.boot
@@ -0,0 +1,3 @@
+   zreladdr-y	+= 0x00008000
+params_phys-y	:= 0x00000100
+initrd_phys-y	:= 0x00800000
diff --git a/arch/arm/mach-moxart/idle.c b/arch/arm/mach-moxart/idle.c
new file mode 100644
index 0000000..5970c27
--- /dev/null
+++ b/arch/arm/mach-moxart/idle.c
@@ -0,0 +1,31 @@
+/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version. */
+
+#include <linux/init.h>
+#include <asm/system.h>
+#include <asm/proc-fns.h>
+
+static void moxart_idle(void)
+{
+	/*
+	 * Because of broken hardware we have to enable interrupts or the CPU
+	 * will never wakeup... Acctualy it is not very good to enable
+	 * interrupts first since scheduler can miss a tick, but there is
+	 * no other way around this. Platforms that needs it for power saving
+	 * should call enable_hlt() in init code, since by default it is
+	 * disabled.
+	 */
+/*	local_irq_enable();
+	cpu_do_idle();*/
+}
+
+static int __init moxart_idle_init(void)
+{
+	arm_pm_idle = moxart_idle;
+	return 0;
+}
+
+arch_initcall(moxart_idle_init);
diff --git a/arch/arm/mach-moxart/moxart.c b/arch/arm/mach-moxart/moxart.c
new file mode 100644
index 0000000..4c89a21
--- /dev/null
+++ b/arch/arm/mach-moxart/moxart.c
@@ -0,0 +1,42 @@
+/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version. */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+
+#include "moxart.h"
+
+static void __init moxart_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+void moxart_restart(char mode, const char *cmd)
+{
+	writel(1, reg_wdt + 4);
+	writel(0x5ab9, reg_wdt + 8);
+	writel(0x03, reg_wdt + 12);
+}
+
+static const char * const moxart_board_dt_compat[] = {
+	"moxart,moxart-uc-7112-lx",
+	NULL,
+};
+
+DT_MACHINE_START(MOXART, "MOXA UC-7112-LX")
+	.init_irq		= moxart_init_irq,
+	.init_time		= moxart_timer_init,
+	.init_machine	= moxart_init,
+	.handle_irq		= moxart_handle_irq,
+	.restart        = moxart_restart,
+	.dt_compat		= moxart_board_dt_compat,
+	.nr_irqs		= 32,
+MACHINE_END
+
diff --git a/arch/arm/mach-moxart/moxart.h b/arch/arm/mach-moxart/moxart.h
new file mode 100644
index 0000000..255ad85
--- /dev/null
+++ b/arch/arm/mach-moxart/moxart.h
@@ -0,0 +1,11 @@
+/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version. */
+
+extern __iomem void *reg_wdt;
+extern void moxart_timer_init(void);
+extern void moxart_init_irq(void);
+extern void moxart_handle_irq(struct pt_regs *regs);
+
