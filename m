Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3DKLwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:52:04 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41604 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3DKLv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:51:59 -0400
From: Daniel Tang <dt.tangr@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [RFC PATCHv2 arm: initial TI-Nspire support]
Date: Thu, 11 Apr 2013 21:51:43 +1000
Message-Id: <8E071E2D-4FF3-487E-A53B-B6A7C427E421@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux@arm.linux.org.uk
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another updated patch for Linux on TI-Nspire support. 

Apologies for previously posting updated patches as replies to the first thread. I'll send updated patches in new threads from now to avoid confusion.

Changes between http://archive.arm.linux.org.uk/lurker/message/20130408.113343.585af217.en.html and v2:
* Added new drivers to support the irqchip and timers on older models.
* Added new device trees to support the other models.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 arch/arm/Kconfig                            |   2 +
 arch/arm/Kconfig.debug                      |  16 ++
 arch/arm/Makefile                           |   1 +
 arch/arm/boot/dts/Makefile                  |   3 +
 arch/arm/boot/dts/nspire-classic.dtsi       |  68 ++++++
 arch/arm/boot/dts/nspire-clp.dts            |  45 ++++
 arch/arm/boot/dts/nspire-cx.dts             | 115 ++++++++++
 arch/arm/boot/dts/nspire-tp.dts             |  44 ++++
 arch/arm/boot/dts/nspire.dtsi               | 159 ++++++++++++++
 arch/arm/include/debug/nspire.S             |  28 +++
 arch/arm/mach-nspire/Kconfig                |  15 ++
 arch/arm/mach-nspire/Makefile               |   2 +
 arch/arm/mach-nspire/Makefile.boot          |   0
 arch/arm/mach-nspire/clcd.c                 | 118 +++++++++++
 arch/arm/mach-nspire/clcd.h                 |  14 ++
 arch/arm/mach-nspire/mmio.h                 |  15 ++
 arch/arm/mach-nspire/nspire.c               | 142 +++++++++++++
 drivers/clocksource/Makefile                |   1 +
 drivers/clocksource/nspire-classic-timer.c  | 216 +++++++++++++++++++
 drivers/input/keyboard/Kconfig              |  10 +
 drivers/input/keyboard/Makefile             |   1 +
 drivers/input/keyboard/nspire-keypad.c      | 316 ++++++++++++++++++++++++++++
 drivers/irqchip/Makefile                    |   1 +
 drivers/irqchip/irq-nspire-classic.c        | 177 ++++++++++++++++
 include/clocksource/nspire_classic_timer.h  |  16 ++
 include/linux/platform_data/nspire-keypad.h |  28 +++
 26 files changed, 1553 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1cacda4..3f0cd8c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1081,6 +1081,8 @@ source "arch/arm/mach-netx/Kconfig"
 
 source "arch/arm/mach-nomadik/Kconfig"
 
+source "arch/arm/mach-nspire/Kconfig"
+
 source "arch/arm/plat-omap/Kconfig"
 
 source "arch/arm/mach-omap1/Kconfig"
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 9b31f43..5da3a50 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -298,6 +298,20 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on MVEBU based platforms.
 
+	config DEBUG_NSPIRE_CLASSIC_UART
+		bool "Kernel low-level debugging via TI-NSPIRE 8250 UART"
+		depends on ARCH_NSPIRE
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on TI-NSPIRE classic models.
+
+	config DEBUG_NSPIRE_CX_UART
+		bool "Kernel low-level debugging via TI-NSPIRE PL011 UART"
+		depends on ARCH_NSPIRE
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on TI-NSPIRE CX models.
+
 	config DEBUG_OMAP2PLUS_UART
 		bool "Kernel low-level debugging messages via OMAP2PLUS UART"
 		depends on ARCH_OMAP2PLUS
@@ -591,6 +605,8 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX6Q_UART
 	default "debug/highbank.S" if DEBUG_HIGHBANK_UART
 	default "debug/mvebu.S" if DEBUG_MVEBU_UART
+	default "debug/nspire.S" if 	DEBUG_NSPIRE_CX_UART || \
+					DEBUG_NSPIRE_CLASSIC_UART
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 	default "debug/picoxcell.S" if DEBUG_PICOXCELL_UART
 	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
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
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 9c62558..21d161b 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -114,6 +114,9 @@ dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
 	imx28-sps1.dtb \
 	imx28-tx28.dtb
 dtb-$(CONFIG_ARCH_NOMADIK) += ste-nomadik-s8815.dtb
+dtb-$(CONFIG_ARCH_NSPIRE) += nspire-cx.dtb \
+	nspire-tp.dtb \
+	nspire-clp.dtb
 dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	omap3-beagle.dtb \
 	omap3-beagle-xm.dtb \
diff --git a/arch/arm/boot/dts/nspire-classic.dtsi b/arch/arm/boot/dts/nspire-classic.dtsi
new file mode 100644
index 0000000..56f5e39
--- /dev/null
+++ b/arch/arm/boot/dts/nspire-classic.dtsi
@@ -0,0 +1,68 @@
+/*
+ *  linux/arch/arm/boot/nspire-classic.dts
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+/include/ "nspire.dtsi"
+
+&lcd {
+	lcd-type = "classic";
+};
+
+&fast_timer {
+	/* compatible = "nspire-classic-timer"; */
+	reg = <0x90010000 0x1000>, <0x900A0010 0x8>;
+};
+
+&uart {
+	compatible = "ns16550";
+	reg-shift = <2>;
+	reg-io-width = <4>;
+	clock-frequency = <29491200>;
+	no-loopback-test;
+};
+
+&timer0 {
+	compatible = "nspire-classic-timer";
+	reg = <0x900C0000 0x1000>, <0x900A0018 0x8>;
+};
+
+&timer1 {
+	compatible = "nspire-classic-timer";
+	reg = <0x900D0000 0x1000>, <0x900A0020 0x8>;
+};
+
+/ {
+	memory {
+		device_type = "memory";
+		reg = <0x10000000 0x2000000>; /* 32 MB */
+	};
+
+	/* Not really a fixed clock but we'll fix this later */
+	apb_pclk: apb_pclk {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <30000000>;
+	};
+
+	ahb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		intc: interrupt-controller@DC000000 {
+			compatible = "nspire-classic-intc";
+			interrupt-controller;
+			reg = <0xDC000000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+	};
+	chosen {
+		bootargs = "debug earlyprintk console=tty0 console=ttyS0,115200n8 root=/dev/ram0";
+	};
+};
diff --git a/arch/arm/boot/dts/nspire-clp.dts b/arch/arm/boot/dts/nspire-clp.dts
new file mode 100644
index 0000000..7f25f44
--- /dev/null
+++ b/arch/arm/boot/dts/nspire-clp.dts
@@ -0,0 +1,45 @@
+/*
+ *  linux/arch/arm/boot/nspire-clp.dts
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+/dts-v1/;
+
+/include/ "nspire-classic.dtsi"
+
+&keypad {
+	keymap = <
+	0x0000001c 	0x0001001c 	0x00020039
+	0x0004002c 	0x00050034 	0x00060015
+	0x0007000b 	0x0008002d 	0x01000033
+	0x0101004e 	0x01020011 	0x01030004
+	0x0104002f 	0x01050003 	0x01060016
+	0x01070002 	0x01080014 	0x02000062
+	0x0201000c 	0x0202001f 	0x02030007
+	0x02040013 	0x02050006 	0x02060010
+	0x02070005 	0x02080019 	0x03000027
+	0x03010037 	0x03020018 	0x0303000a
+	0x03040031 	0x03050009 	0x03060032
+	0x03070008 	0x03080026 	0x04000028
+	0x04010035 	0x04020025 	0x04040024
+	0x04060017 	0x04080023 	0x05000028
+	0x05020022 	0x0503001b 	0x05040021
+	0x0505001a 	0x05060012 	0x0507006f
+	0x05080020 	0x0509002a 	0x0601001c
+	0x0602002e 	0x06030068 	0x06040030
+	0x0605006d 	0x0606001e 	0x06070001
+	0x0608002b 	0x0609000f 	0x07000067
+	0x0702006a 	0x0704006c 	0x07060069
+	0x0707000e 	0x0708001d 	0x070a000d
+	>;
+};
+
+/ {
+	model = "TI-NSPIRE Clickpad";
+	compatible = "arm,nspire-clp";
+};
diff --git a/arch/arm/boot/dts/nspire-cx.dts b/arch/arm/boot/dts/nspire-cx.dts
new file mode 100644
index 0000000..890dd98
--- /dev/null
+++ b/arch/arm/boot/dts/nspire-cx.dts
@@ -0,0 +1,115 @@
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
+&lcd {
+	lcd-type = "cx";
+};
+
+&fast_timer {
+	/* compatible = "arm,sp804", "arm,primecell"; */
+};
+
+&uart {
+	compatible = "arm,pl011", "arm,primecell";
+
+	clocks = <&uart_clk>, <&apb_pclk>;
+	clock-names = "uart_clk", "apb_pclk";
+};
+
+&timer0 {
+	compatible = "arm,sp804", "arm,primecell";
+};
+
+&timer1 {
+	compatible = "arm,sp804", "arm,primecell";
+};
+
+&keypad {
+	keymap = <
+	0x0000001c 	0x0001001c 	0x00040039
+	0x0005002c 	0x00060015 	0x0007000b
+	0x0008000f 	0x0100002d 	0x01010011
+	0x0102002f 	0x01030004 	0x01040016
+	0x01050014 	0x0106001f 	0x01070002
+	0x010a006a 	0x02000013 	0x02010010
+	0x02020019 	0x02030007 	0x02040018
+	0x02050031 	0x02060032 	0x02070005
+	0x02080028 	0x0209006c 	0x03000026
+	0x03010025 	0x03020024 	0x0303000a
+	0x03040017 	0x03050023 	0x03060022
+	0x03070008 	0x03080035 	0x03090069
+	0x04000021 	0x04010012 	0x04020020
+	0x0404002e 	0x04050030 	0x0406001e
+	0x0407000d 	0x04080037 	0x04090067
+	0x05010038 	0x0502000c 	0x0503001b
+	0x05040034 	0x0505001a 	0x05060006
+	0x05080027 	0x0509000e 	0x050a006f
+	0x0600002b 	0x0602004e 	0x06030068
+	0x06040003 	0x0605006d 	0x06060009
+	0x06070001 	0x0609000f 	0x0708002a
+	0x0709001d 	0x070a0033 	>;
+};
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
+		lcd: lcd@C0000000 {
+			lcd-type = "cx";
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
+		};
+	};
+	chosen {
+		bootargs = "debug earlyprintk console=tty0 console=ttyAMA0,115200n8 root=/dev/ram0";
+	};
+};
diff --git a/arch/arm/boot/dts/nspire-tp.dts b/arch/arm/boot/dts/nspire-tp.dts
new file mode 100644
index 0000000..485d0ff
--- /dev/null
+++ b/arch/arm/boot/dts/nspire-tp.dts
@@ -0,0 +1,44 @@
+/*
+ *  linux/arch/arm/boot/nspire-tp.dts
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+/dts-v1/;
+
+/include/ "nspire-classic.dtsi"
+
+&keypad {
+	keymap = <
+	0x0000001c 	0x0001001c 	0x00040039
+	0x0005002c 	0x00060015 	0x0007000b
+	0x0008000f 	0x0100002d 	0x01010011
+	0x0102002f 	0x01030004 	0x01040016
+	0x01050014 	0x0106001f 	0x01070002
+	0x010a006a 	0x02000013 	0x02010010
+	0x02020019 	0x02030007 	0x02040018
+	0x02050031 	0x02060032 	0x02070005
+	0x02080028 	0x0209006c 	0x03000026
+	0x03010025 	0x03020024 	0x0303000a
+	0x03040017 	0x03050023 	0x03060022
+	0x03070008 	0x03080035 	0x03090069
+	0x04000021 	0x04010012 	0x04020020
+	0x0404002e 	0x04050030 	0x0406001e
+	0x0407000d 	0x04080037 	0x04090067
+	0x05010038 	0x0502000c 	0x0503001b
+	0x05040034 	0x0505001a 	0x05060006
+	0x05080027 	0x0509000e 	0x050a006f
+	0x0600002b 	0x0602004e 	0x06030068
+	0x06040003 	0x0605006d 	0x06060009
+	0x06070001 	0x0609000f 	0x0708002a
+	0x0709001d 	0x070a0033 	>;
+};
+
+/ {
+	model = "TI-NSPIRE Touchpad";
+	compatible = "arm,nspire-tp";
+};
diff --git a/arch/arm/boot/dts/nspire.dtsi b/arch/arm/boot/dts/nspire.dtsi
new file mode 100644
index 0000000..31c9172
--- /dev/null
+++ b/arch/arm/boot/dts/nspire.dtsi
@@ -0,0 +1,159 @@
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
+	interrupt-parent = <&intc>;
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,arm926ejs";
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
+		compatible = "simple-bus";
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
+			compatible = "arm,pl111", "arm,primecell";
+			reg = <0xC0000000 0x1000>;
+			interrupts = <21>;
+
+			clocks = <&apb_pclk>;
+			clock-names = "apb_pclk";
+		};
+
+		adc: adc@C4000000 {
+			reg = <0xC4000000 0x1000>;
+			interrupts = <11>;
+		};
+
+		tdes: crypto@C8010000 {
+			reg = <0xC8010000 0x1000>;
+		};
+
+		sha256: crypto@CC000000 {
+			reg = <0xCC000000 0x1000>;
+		};
+
+		apb@90000000 {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
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
+			uart: serial@90020000 {
+				reg = <0x90020000 0x1000>;
+				interrupts = <1>;
+			};
+
+			timer0: timer@900C0000 {
+				reg = <0x900C0000 0x1000>;
+
+				clocks = <&timer_clk>;
+				clock-names = "timer_clk";
+			};
+
+			timer1: timer@900D0000 {
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
+				compatible = "nspire-keypad";
+				reg = <0x900E0000 0x1000>;
+				interrupts = <16>;
+
+				scan-interval = <1000>;
+				row-delay = <200>;
+
+				clocks = <&apb_pclk>;
+				clock-names = "apb_pclk";
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
diff --git a/arch/arm/include/debug/nspire.S b/arch/arm/include/debug/nspire.S
new file mode 100644
index 0000000..3a9729c
--- /dev/null
+++ b/arch/arm/include/debug/nspire.S
@@ -0,0 +1,28 @@
+/*
+ *	linux/arch/arm/include/debug/nspire.S
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
+#ifdef CONFIG_DEBUG_NSPIRE_CX_UART
+#include <asm/hardware/debug-pl01x.S>
+#endif
+
+#ifdef CONFIG_DEBUG_NSPIRE_CLASSIC_UART
+#define UART_SHIFT 2
+#include <asm/hardware/debug-8250.S>
+#endif
diff --git a/arch/arm/mach-nspire/Kconfig b/arch/arm/mach-nspire/Kconfig
new file mode 100644
index 0000000..a295b18
--- /dev/null
+++ b/arch/arm/mach-nspire/Kconfig
@@ -0,0 +1,15 @@
+config ARCH_NSPIRE
+	bool "TI-NSPIRE based"
+	depends on ARCH_MULTI_V4_V5
+	depends on MMU
+	select CPU_ARM926T
+	select COMMON_CLK
+	select GENERIC_CLOCKEVENTS
+	select SPARSE_IRQ
+	select ARM_AMBA
+	select ARM_VIC
+	select ARM_TIMER_SP804
+	select USE_OF
+	select CLKSRC_OF
+	help
+	  This enables support for systems using the TI-NSPIRE CPU
diff --git a/arch/arm/mach-nspire/Makefile b/arch/arm/mach-nspire/Makefile
new file mode 100644
index 0000000..1bec256
--- /dev/null
+++ b/arch/arm/mach-nspire/Makefile
@@ -0,0 +1,2 @@
+obj-y				+= nspire.o
+obj-y				+= clcd.o
diff --git a/arch/arm/mach-nspire/Makefile.boot b/arch/arm/mach-nspire/Makefile.boot
new file mode 100644
index 0000000..e69de29
diff --git a/arch/arm/mach-nspire/clcd.c b/arch/arm/mach-nspire/clcd.c
new file mode 100644
index 0000000..09f7dc7
--- /dev/null
+++ b/arch/arm/mach-nspire/clcd.c
@@ -0,0 +1,118 @@
+/*
+ *	linux/arch/arm/mach-nspire/clcd.c
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
+#include <linux/of.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/clcd.h>
+#include <linux/dma-mapping.h>
+
+static struct clcd_panel nspire_cx_lcd_panel = {
+	.mode		= {
+		.name		= "Color LCD",
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
+
+static struct clcd_panel nspire_classic_lcd_panel = {
+	.mode		= {
+		.name		= "Grayscale LCD",
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
+
+int nspire_clcd_setup(struct clcd_fb *fb)
+{
+	struct clcd_panel *panel;
+	size_t panel_size;
+	const char *type;
+	dma_addr_t dma;
+	int err;
+
+	BUG_ON(!fb->dev->dev.of_node);
+
+	err = of_property_read_string(fb->dev->dev.of_node, "lcd-type", &type);
+	if (err) {
+		pr_err("CLCD: Could not find lcd-type property\n");
+		return err;
+	}
+
+	if (!strcmp(type, "cx")) {
+		panel = &nspire_cx_lcd_panel;
+	} else if (!strcmp(type, "classic")) {
+		panel = &nspire_classic_lcd_panel;
+	} else {
+		pr_err("CLCD: Unknown lcd-type %s\n", type);
+		return -EINVAL;
+	}
+
+	panel_size = ((panel->mode.xres * panel->mode.yres) * panel->bpp) / 8;
+	panel_size = ALIGN(panel_size, PAGE_SIZE);
+
+	fb->fb.screen_base = dma_alloc_writecombine(&fb->dev->dev,
+		panel_size, &dma, GFP_KERNEL);
+
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
diff --git a/arch/arm/mach-nspire/clcd.h b/arch/arm/mach-nspire/clcd.h
new file mode 100644
index 0000000..7144399
--- /dev/null
+++ b/arch/arm/mach-nspire/clcd.h
@@ -0,0 +1,14 @@
+/*
+ *	linux/arch/arm/mach-nspire/clcd.h
+ *
+ *	Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+int nspire_clcd_setup(struct clcd_fb *fb);
+int nspire_clcd_mmap(struct clcd_fb *fb, struct vm_area_struct *vma);
+void nspire_clcd_remove(struct clcd_fb *fb);
diff --git a/arch/arm/mach-nspire/mmio.h b/arch/arm/mach-nspire/mmio.h
new file mode 100644
index 0000000..f0a1fa5
--- /dev/null
+++ b/arch/arm/mach-nspire/mmio.h
@@ -0,0 +1,15 @@
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
+#define NSPIRE_EARLY_UART_PHYS_BASE	0x90020000
+#define NSPIRE_EARLY_UART_VIRT_BASE	0xfee20000
+
+#define NSPIRE_LCD_PHYS_BASE		0xC0000000
diff --git a/arch/arm/mach-nspire/nspire.c b/arch/arm/mach-nspire/nspire.c
new file mode 100644
index 0000000..bb1c8b3
--- /dev/null
+++ b/arch/arm/mach-nspire/nspire.c
@@ -0,0 +1,142 @@
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
+#include <linux/amba/bus.h>
+#include <linux/amba/clcd.h>
+
+#include <clocksource/nspire_classic_timer.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach-types.h>
+#include <asm/mach/map.h>
+
+#include <asm/hardware/timer-sp.h>
+
+#include "mmio.h"
+#include "clcd.h"
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
+#define TIMER_NAME_MAXLEN 32
+static void __init nspire_add_sp804_timers(void)
+{
+	struct device_node *of_timer;
+	int clockevents_found = 0;
+
+	for_each_compatible_node(of_timer, NULL, "arm,sp804") {
+		struct resource res;
+		void __iomem *base;
+		char *name;
+		struct clk *clk;
+		int irq;
+
+		clk = of_clk_get_by_name(of_timer, NULL);
+		if (WARN_ON(!clk))
+			continue;
+
+		name = kzalloc(TIMER_NAME_MAXLEN, GFP_ATOMIC);
+		if (!name)
+			break;
+
+		base = of_iomap(of_timer, 0);
+		if (WARN_ON(!base)) {
+			kfree(name);
+			continue;
+		}
+
+		of_address_to_resource(of_timer, 0, &res);
+		scnprintf(name, TIMER_NAME_MAXLEN, "%llx.%s",
+				(unsigned long long)res.start,
+				of_timer->name);
+
+		clk_register_clkdev(clk, name, "sp804");
+		if (!clockevents_found) {
+			irq = irq_of_parse_and_map(of_timer, 0);
+			if (irq) {
+				sp804_clockevents_init(base, irq, name);
+				clockevents_found = 1;
+				continue;
+			}
+		}
+
+		sp804_clocksource_init(base, name);
+	}
+}
+
+
+static void __init nspire_init_timer(void)
+{
+	of_clk_init(NULL);
+	nspire_classic_timer_init();
+	nspire_add_sp804_timers();
+}
+
+static void __init nspire_map_io(void)
+{
+	iotable_init(nspire_io_desc, ARRAY_SIZE(nspire_io_desc));
+}
+
+static struct clcd_board nspire_clcd_data = {
+	.name		= "LCD",
+	.check		= clcdfb_check,
+	.decode		= clcdfb_decode,
+	.setup		= nspire_clcd_setup,
+	.mmap		= nspire_clcd_mmap,
+	.remove		= nspire_clcd_remove,
+};
+
+
+static struct of_dev_auxdata nspire_auxdata[] __initdata = {
+	OF_DEV_AUXDATA("arm,pl111", NSPIRE_LCD_PHYS_BASE,
+			NULL, &nspire_clcd_data),
+	{ }
+};
+
+static void __init nspire_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table,
+			nspire_auxdata, NULL);
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
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 4d8283a..0a8e6b7 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_SUNXI_TIMER)	+= sunxi_timer.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
+obj-$(CONFIG_ARCH_NSPIRE)	+= nspire-classic-timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
diff --git a/drivers/clocksource/nspire-classic-timer.c b/drivers/clocksource/nspire-classic-timer.c
new file mode 100644
index 0000000..b5aa32e
--- /dev/null
+++ b/drivers/clocksource/nspire-classic-timer.c
@@ -0,0 +1,216 @@
+/*
+ *  linux/drivers/clocksource/nspire-classic-timer.c
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/cpumask.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+
+#define DT_COMPAT	"nspire-classic-timer"
+
+#define IO_CURRENT_VAL	0x00
+#define IO_DIVIDER	0x04
+#define IO_CONTROL	0x08
+
+#define IO_TIMER1	0x00
+#define IO_TIMER2	0x0C
+
+#define IO_MATCH1	0x18
+#define IO_MATCH2	0x1C
+#define IO_MATCH3	0x20
+#define IO_MATCH4	0x24
+#define IO_MATCH5	0x28
+#define IO_MATCH6	0x2C
+
+#define IO_INTR_STS	0x00
+#define IO_INTR_ACK	0x00
+#define IO_INTR_MSK	0x04
+
+#define CNTL_STOP_TIMER	(1<<4)
+#define CNTL_RUN_TIMER	(0<<4)
+
+#define CNTL_INC	(1<<3)
+#define CNTL_DEC	(0<<3)
+
+#define CNTL_TOZERO	0
+#define CNTL_MATCH1	1
+#define CNTL_MATCH2	2
+#define CNTL_MATCH3	3
+#define CNTL_MATCH4	4
+#define CNTL_MATCH5	5
+#define CNTL_MATCH6	6
+#define CNTL_FOREVER	7
+
+struct nspire_timer {
+	void __iomem *base;
+	void __iomem *timer1, *timer2;
+	void __iomem *interrupt_regs;
+
+	int irqnr;
+
+	struct clk *clk;
+	struct clock_event_device clkevt;
+	struct irqaction clkevt_irq;
+
+	char clocksource_name[64];
+	char clockevent_name[64];
+};
+
+static int nspire_timer_set_event(unsigned long delta,
+		struct clock_event_device *dev)
+{
+	unsigned long flags;
+	struct nspire_timer *timer = container_of(dev,
+			struct nspire_timer,
+			clkevt);
+
+	local_irq_save(flags);
+
+	writel(delta, timer->timer1 + IO_CURRENT_VAL);
+	writel(CNTL_RUN_TIMER | CNTL_DEC | CNTL_MATCH1,
+			timer->timer1 + IO_CONTROL);
+
+	local_irq_restore(flags);
+
+	return 0;
+}
+static void nspire_timer_set_mode(enum clock_event_mode mode,
+		struct clock_event_device *evt)
+{
+	evt->mode = mode;
+}
+
+static irqreturn_t nspire_timer_interrupt(int irq, void *dev_id)
+{
+	struct nspire_timer *timer = dev_id;
+
+	writel((1<<0), timer->interrupt_regs + IO_INTR_ACK);
+	writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
+
+	if (timer->clkevt.event_handler)
+		timer->clkevt.event_handler(&timer->clkevt);
+
+	return IRQ_HANDLED;
+}
+
+static int __init nspire_timer_add(struct device_node *node)
+{
+	struct nspire_timer *timer;
+	struct resource res;
+	int ret;
+
+	timer = kzalloc(sizeof(*timer), GFP_ATOMIC);
+	if (!timer)
+		return -ENOMEM;
+
+	timer->base = of_iomap(node, 0);
+	if (!timer->base) {
+		ret = -EINVAL;
+		goto error_free;
+	}
+	timer->timer1 = timer->base + IO_TIMER1;
+	timer->timer2 = timer->base + IO_TIMER2;
+
+	timer->clk = of_clk_get(node, 0);
+	if (!timer->clk) {
+		ret = -EINVAL;
+		pr_err("Timer clock not found!\n");
+		goto error_unmap;
+	}
+
+	timer->interrupt_regs = of_iomap(node, 1);
+	timer->irqnr = irq_of_parse_and_map(node, 0);
+
+	of_address_to_resource(node, 0, &res);
+	scnprintf(timer->clocksource_name, sizeof(timer->clocksource_name),
+			"%llx.%s_clocksource",
+			(unsigned long long)res.start, node->name);
+
+	scnprintf(timer->clockevent_name, sizeof(timer->clockevent_name),
+			"%llx.%s_clockevent",
+			(unsigned long long)res.start, node->name);
+
+	if (timer->interrupt_regs && timer->irqnr) {
+		timer->clkevt.name	= timer->clockevent_name;
+		timer->clkevt.set_next_event = nspire_timer_set_event;
+		timer->clkevt.set_mode	= nspire_timer_set_mode;
+		timer->clkevt.rating	= 200;
+		timer->clkevt.shift	= 32;
+		timer->clkevt.cpumask	= cpu_all_mask;
+		timer->clkevt.features	=
+			CLOCK_EVT_FEAT_ONESHOT;
+
+		writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
+		writel(0, timer->timer1 + IO_DIVIDER);
+
+		/* Mask out interrupts except the one we're using */
+		writel((1<<0), timer->interrupt_regs + IO_INTR_MSK);
+		writel(0x3F, timer->interrupt_regs + IO_INTR_ACK);
+
+		/* Interrupt to occur when timer value matches 0 */
+		writel(0, timer->base + IO_MATCH1);
+
+		timer->clkevt_irq.name	= timer->clockevent_name;
+		timer->clkevt_irq.handler = nspire_timer_interrupt;
+		timer->clkevt_irq.dev_id = timer;
+		timer->clkevt_irq.flags	=
+			IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL;
+
+		setup_irq(timer->irqnr, &timer->clkevt_irq);
+
+		clockevents_config_and_register(&timer->clkevt,
+				clk_get_rate(timer->clk), 0x0001, 0xfffe);
+		pr_info("Added %s as clockevent\n", timer->clockevent_name);
+	}
+
+	writel(CNTL_RUN_TIMER | CNTL_FOREVER | CNTL_INC,
+			timer->timer2 + IO_CONTROL);
+
+	clocksource_mmio_init(timer->timer2 + IO_CURRENT_VAL,
+			timer->clocksource_name,
+			clk_get_rate(timer->clk),
+			200, 16,
+			clocksource_mmio_readw_up);
+
+	pr_info("Added %s as clocksource\n", timer->clocksource_name);
+
+	return 0;
+error_unmap:
+	iounmap(timer->base);
+error_free:
+	kfree(timer);
+	return ret;
+}
+
+bool timer_init;
+
+void __init nspire_classic_timer_init(void)
+{
+	struct device_node *node;
+
+	if (timer_init)
+		return;
+
+	for_each_compatible_node(node, NULL, DT_COMPAT) {
+		nspire_timer_add(node);
+	}
+
+	timer_init = 1;
+}
+
+CLOCKSOURCE_OF_DECLARE(nspire_classic_timer,
+		DT_COMPAT, nspire_classic_timer_init)
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index ac05006..677adba 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -418,6 +418,16 @@ config KEYBOARD_NOMADIK
 	  To compile this driver as a module, choose M here: the
 	  module will be called nmk-ske-keypad.
 
+config KEYBOARD_NSPIRE
+	tristate "TI-NSPIRE builtin keyboard"
+	depends on ARCH_NSPIRE
+	select INPUT_MATRIXKMAP
+	help
+	  Say Y here if you want to use the builtin keypad on the TI-NSPIRE.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called nspire-keypad.
+
 config KEYBOARD_TEGRA
 	tristate "NVIDIA Tegra internal matrix keyboard controller support"
 	depends on ARCH_TEGRA && OF
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 49b1645..89d997b 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_KEYBOARD_MCS)		+= mcs_touchkey.o
 obj-$(CONFIG_KEYBOARD_MPR121)		+= mpr121_touchkey.o
 obj-$(CONFIG_KEYBOARD_NEWTON)		+= newtonkbd.o
 obj-$(CONFIG_KEYBOARD_NOMADIK)		+= nomadik-ske-keypad.o
+obj-$(CONFIG_KEYBOARD_NSPIRE)		+= nspire-keypad.o
 obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
 obj-$(CONFIG_KEYBOARD_OMAP4)		+= omap4-keypad.o
 obj-$(CONFIG_KEYBOARD_OPENCORES)	+= opencores-kbd.o
diff --git a/drivers/input/keyboard/nspire-keypad.c b/drivers/input/keyboard/nspire-keypad.c
new file mode 100644
index 0000000..581dea5
--- /dev/null
+++ b/drivers/input/keyboard/nspire-keypad.c
@@ -0,0 +1,316 @@
+/*
+ *  linux/drivers/input/keyboard/nspire-keypad.c
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/input/matrix_keypad.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of.h>
+
+#include <linux/platform_data/nspire-keypad.h>
+
+#define KEYPAD_SCAN_MODE	0x00
+#define KEYPAD_CNTL		0x04
+#define KEYPAD_INT		0x08
+#define KEYPAD_INTMSK		0x0C
+
+#define KEYPAD_DATA		0x10
+#define KEYPAD_GPIO		0x30
+
+#define KEYPAD_UNKNOWN_INT	0x40
+#define KEYPAD_UNKNOWN_INT_STS	0x44
+
+
+struct nspire_keypad {
+	spinlock_t lock;
+
+	void __iomem *reg_base;
+	int irq;
+	u32 int_mask;
+
+	struct input_dev *input;
+	struct clk *clk;
+
+	struct nspire_keypad_data options;
+	int row_shift;
+};
+
+static inline void nspire_report_state(struct nspire_keypad *keypad,
+		int row, int col, unsigned int state)
+{
+	int code = MATRIX_SCAN_CODE(row, col, keypad->row_shift);
+	unsigned short *keymap = keypad->input->keycode;
+
+	state = keypad->options.active_low ? !state : !!state;
+	input_report_key(keypad->input, keymap[code], state);
+}
+
+static irqreturn_t nspire_keypad_irq(int irq, void *dev_id)
+{
+	struct nspire_keypad *keypad = dev_id;
+	u32 int_sts;
+	u16 state[8];
+	int row, col;
+
+	int_sts = readl(keypad->reg_base + KEYPAD_INT) & keypad->int_mask;
+
+	if (!int_sts)
+		return IRQ_NONE;
+
+	spin_lock(&keypad->lock);
+
+	memcpy_fromio(state, keypad->reg_base + KEYPAD_DATA, sizeof(state));
+
+	for (row = 0; row < KEYPAD_BITMASK_ROWS; row++) {
+		u16 bits = state[row];
+		for (col = 0; col < KEYPAD_BITMASK_COLS; col++)
+			nspire_report_state(keypad, row, col, bits & (1<<col));
+	}
+	input_sync(keypad->input);
+	writel(0x3, keypad->reg_base + KEYPAD_INT);
+
+	spin_unlock(&keypad->lock);
+
+	return IRQ_HANDLED;
+}
+
+static int nspire_keypad_chip_init(struct nspire_keypad *keypad)
+{
+	unsigned long val = 0, cycles_per_us, delay_cycles, row_delay_cycles;
+
+	cycles_per_us = (clk_get_rate(keypad->clk) / 1000000);
+	if (cycles_per_us == 0)
+		cycles_per_us = 1;
+
+	delay_cycles = cycles_per_us * keypad->options.scan_interval;
+	WARN_ON(delay_cycles >= (1<<16)); /* Overflow */
+	delay_cycles &= 0xffff;
+
+	row_delay_cycles = cycles_per_us * keypad->options.row_delay;
+	WARN_ON(row_delay_cycles >= (1<<14)); /* Overflow */
+	row_delay_cycles &= 0x3fff;
+
+
+	val |= (3<<0); /* Set scan mode to 3 (continuous scan) */
+	val |= (row_delay_cycles<<2); /* Delay between scanning each row */
+	val |= (delay_cycles<<16); /* Delay between scans */
+	writel(val, keypad->reg_base + KEYPAD_SCAN_MODE);
+
+	val = (KEYPAD_BITMASK_ROWS & 0xff) | (KEYPAD_BITMASK_COLS & 0xff)<<8;
+	writel(val, keypad->reg_base + KEYPAD_CNTL);
+
+	/* Enable interrupts */
+	keypad->int_mask = (1<<1);
+	writel(keypad->int_mask, keypad->reg_base + 0xc);
+
+	/* Disable GPIO interrupts to prevent hanging on touchpad */
+	/* Possibly used to detect touchpad events */
+	writel(0, keypad->reg_base + KEYPAD_UNKNOWN_INT);
+	/* Acknowledge existing interrupts */
+	writel(~0, keypad->reg_base + KEYPAD_UNKNOWN_INT_STS);
+
+	return 0;
+}
+
+static int nspire_keypad_probe(struct platform_device *pdev)
+{
+	const struct nspire_keypad_data *plat = pdev->dev.platform_data;
+	const struct device_node *of_node = pdev->dev.of_node;
+	struct nspire_keypad *keypad;
+	struct input_dev *input;
+	struct resource *res;
+	struct clk *clk;
+	int irq, error;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get keypad irq\n");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "missing platform resources\n");
+		return -EINVAL;
+	}
+
+	clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "unable to get clock\n");
+		return -EINVAL;
+	}
+
+	clk_prepare(clk);
+	error = clk_enable(clk);
+	if (error)
+		goto err_put_clk;
+
+	keypad = kzalloc(sizeof(struct nspire_keypad), GFP_KERNEL);
+	input = input_allocate_device();
+	if (!keypad || !input) {
+		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	if (plat) {
+		memcpy(&keypad->options, plat, sizeof(*plat));
+	} else {
+		/* Load values from device tree */
+
+		error = of_property_read_u32(of_node, "scan-interval",
+				&keypad->options.scan_interval);
+		if (error) {
+			dev_err(&pdev->dev, "failed to get scan-interval\n");
+			goto err_free_mem;
+		}
+
+		error = of_property_read_u32(of_node, "row-delay",
+				&keypad->options.row_delay);
+		if (error) {
+			dev_err(&pdev->dev, "failed to get row-delay\n");
+			goto err_free_mem;
+		}
+
+		keypad->options.active_low = of_property_read_bool(of_node,
+				"active-low");
+
+		keypad->options.keymap = NULL;
+	}
+
+	keypad->row_shift = get_count_order(KEYPAD_BITMASK_COLS);
+	keypad->irq = irq;
+	keypad->clk = clk;
+	keypad->input = input;
+	spin_lock_init(&keypad->lock);
+
+	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		error = -EBUSY;
+		goto err_free_mem;
+	}
+
+	keypad->reg_base = ioremap(res->start, resource_size(res));
+	if (!keypad->reg_base) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		error = -ENXIO;
+		goto err_free_mem_region;
+	}
+
+	input->id.bustype = BUS_HOST;
+	input->name = "nspire-keypad";
+	input->dev.parent = &pdev->dev;
+
+	set_bit(EV_KEY, input->evbit);
+	set_bit(EV_REP, input->evbit);
+
+	error = matrix_keypad_build_keymap(keypad->options.keymap, "keymap",
+			KEYPAD_BITMASK_ROWS, KEYPAD_BITMASK_COLS, NULL, input);
+	if (error) {
+		dev_err(&pdev->dev, "building keymap failed\n");
+		goto err_iounmap;
+	}
+
+	error = nspire_keypad_chip_init(keypad);
+	if (error) {
+		dev_err(&pdev->dev, "unable to init keypad hardware\n");
+		goto err_iounmap;
+	}
+
+	error = request_irq(keypad->irq, nspire_keypad_irq, 0,
+			"nspire_keypad", keypad);
+	if (error) {
+		dev_err(&pdev->dev, "allocate irq %d failed\n", keypad->irq);
+		goto err_iounmap;
+	}
+
+	error = input_register_device(input);
+	if (error) {
+		dev_err(&pdev->dev,
+				"unable to register input device: %d\n", error);
+		goto err_free_irq;
+	}
+
+	platform_set_drvdata(pdev, keypad);
+
+	dev_info(&pdev->dev, "TI-NSPIRE keypad at %#08x ("
+			"scan_interval=%uus,row_delay=%uus"
+			"%s)\n", res->start,
+			keypad->options.row_delay,
+			keypad->options.scan_interval,
+			keypad->options.active_low ? ",active_low" : "");
+
+	return 0;
+
+err_free_irq:
+	free_irq(keypad->irq, keypad);
+err_iounmap:
+	iounmap(keypad->reg_base);
+err_free_mem_region:
+	release_mem_region(res->start, resource_size(res));
+err_free_mem:
+	input_free_device(input);
+	kfree(keypad);
+
+	clk_disable(clk);
+err_put_clk:
+	clk_unprepare(clk);
+	clk_put(clk);
+	return error;
+}
+
+static int nspire_keypad_remove(struct platform_device *pdev)
+{
+	struct nspire_keypad *keypad = platform_get_drvdata(pdev);
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	free_irq(keypad->irq, keypad);
+
+	input_unregister_device(keypad->input);
+
+	iounmap(keypad->reg_base);
+	release_mem_region(res->start, resource_size(res));
+	kfree(keypad);
+
+	clk_disable(keypad->clk);
+	clk_unprepare(keypad->clk);
+	clk_put(keypad->clk);
+
+	return 0;
+}
+#ifdef CONFIG_OF
+static const struct of_device_id nspire_keypad_dt_match[] = {
+	{ .compatible = "nspire-keypad" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, nspire_keypad_dt_match);
+#endif
+
+static struct platform_driver nspire_keypad_driver = {
+	.driver = {
+		.name = "nspire-keypad",
+		.owner  = THIS_MODULE,
+		.of_match_table = of_match_ptr(nspire_keypad_dt_match),
+	},
+	.remove = nspire_keypad_remove,
+	.probe = nspire_keypad_probe
+};
+
+module_platform_driver(nspire_keypad_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("TI-NSPIRE Keypad Driver");
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 98e3b87..9e7f5f5 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
+obj-$(CONFIG_ARCH_NSPIRE)		+= irq-nspire-classic.o
diff --git a/drivers/irqchip/irq-nspire-classic.c b/drivers/irqchip/irq-nspire-classic.c
new file mode 100644
index 0000000..9e6413a
--- /dev/null
+++ b/drivers/irqchip/irq-nspire-classic.c
@@ -0,0 +1,177 @@
+/*
+ *  linux/drivers/irqchip/irq-nspire-classic.c
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#include <asm/mach/irq.h>
+#include <asm/exception.h>
+
+#include "irqchip.h"
+
+#define IO_STATUS	0x000
+#define IO_RAW_STATUS	0x004
+#define IO_ENABLE	0x008
+#define IO_DISABLE	0x00C
+#define IO_CURRENT	0x020
+#define IO_RESET	0x028
+#define IO_MAX_PRIOTY	0x02C
+
+#define IO_IRQ_BASE	0x000
+#define IO_FIQ_BASE	0x100
+
+#define IO_INVERT_SEL	0x200
+#define IO_STICKY_SEL	0x204
+#define IO_PRIORITY_SEL	0x300
+
+#define MAX_INTRS	32
+#define FIQ_START	MAX_INTRS
+
+
+static void __iomem *irq_io_base;
+static struct irq_domain *nspire_irq_domain;
+
+static void nspire_irq_ack(struct irq_data *irqd)
+{
+	void __iomem *base = irq_io_base;
+
+	if (irqd->hwirq < FIQ_START)
+		base += IO_IRQ_BASE;
+	else
+		base += IO_FIQ_BASE;
+
+	readl(base + IO_RESET);
+}
+
+static void nspire_irq_unmask(struct irq_data *irqd)
+{
+	void __iomem *base = irq_io_base;
+	int irqnr = irqd->hwirq;
+
+	if (irqnr < FIQ_START) {
+		base += IO_IRQ_BASE;
+	} else {
+		irqnr -= MAX_INTRS;
+		base += IO_FIQ_BASE;
+	}
+
+	writel((1<<irqnr), base + IO_ENABLE);
+}
+
+static void nspire_irq_mask(struct irq_data *irqd)
+{
+	void __iomem *base = irq_io_base;
+	int irqnr = irqd->hwirq;
+
+	if (irqnr < FIQ_START) {
+		base += IO_IRQ_BASE;
+	} else {
+		irqnr -= FIQ_START;
+		base += IO_FIQ_BASE;
+	}
+
+	writel((1<<irqnr), base + IO_DISABLE);
+}
+
+static struct irq_chip nspire_irq_chip = {
+	.name		= "nspire_irq",
+	.irq_ack	= nspire_irq_ack,
+	.irq_mask	= nspire_irq_mask,
+	.irq_unmask	= nspire_irq_unmask,
+};
+
+
+static int nspire_irq_map(struct irq_domain *dom, unsigned int virq,
+		irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(virq, &nspire_irq_chip, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static struct irq_domain_ops nspire_irq_ops = {
+	.map = nspire_irq_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
+static void init_base(void __iomem *base)
+{
+	/* Disable all interrupts */
+	writel(~0, base + IO_DISABLE);
+
+	/* Accept interrupts of all priorities */
+	writel(0xF, base + IO_MAX_PRIOTY);
+
+	/* Reset existing interrupts */
+	readl(base + IO_RESET);
+}
+
+static int process_base(void __iomem *base, struct pt_regs *regs)
+{
+	int irqnr;
+
+
+	if (!readl(base + IO_STATUS))
+		return 0;
+
+	irqnr = readl(base + IO_CURRENT);
+	irqnr = irq_find_mapping(nspire_irq_domain, irqnr);
+	handle_IRQ(irqnr, regs);
+
+	return 1;
+}
+
+asmlinkage void __exception_irq_entry nspire_handle_irq(struct pt_regs *regs)
+{
+	while (process_base(irq_io_base + IO_FIQ_BASE, regs))
+		;
+	while (process_base(irq_io_base + IO_IRQ_BASE, regs))
+		;
+}
+
+static int __init nspire_of_init(struct device_node *node,
+				struct device_node *parent)
+{
+	if (WARN_ON(irq_io_base))
+		return -EBUSY;
+
+	irq_io_base = of_iomap(node, 0);
+	BUG_ON(!irq_io_base);
+
+	/* Do not invert interrupt status bits */
+	writel(~0, irq_io_base + IO_INVERT_SEL);
+
+	/* Disable sticky interrupts */
+	writel(0, irq_io_base + IO_STICKY_SEL);
+
+	/* We don't use IRQ priorities. Set each IRQ to highest priority. */
+	memset_io(irq_io_base + IO_PRIORITY_SEL, 0, MAX_INTRS * sizeof(u32));
+
+	/* Init IRQ and FIQ */
+	init_base(irq_io_base + IO_IRQ_BASE);
+	init_base(irq_io_base + IO_FIQ_BASE);
+
+	nspire_irq_domain = irq_domain_add_linear(node, MAX_INTRS,
+						 &nspire_irq_ops, NULL);
+
+	BUG_ON(!nspire_irq_domain);
+
+	set_handle_irq(nspire_handle_irq);
+
+	pr_info("TI-NSPIRE classic IRQ controller\n");
+	return 0;
+}
+
+IRQCHIP_DECLARE(nspire_classic_irq, "nspire-classic-intc", nspire_of_init);
diff --git a/include/clocksource/nspire_classic_timer.h b/include/clocksource/nspire_classic_timer.h
new file mode 100644
index 0000000..39236f1
--- /dev/null
+++ b/include/clocksource/nspire_classic_timer.h
@@ -0,0 +1,16 @@
+/*
+ *  linux/include/clocksource/nspire_classic_timer.h
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef __CLKSOURCE_NSPIRE_CLASSIC_TIMER_H
+#define __CLKSOURCE_NSPIRE_CLASSIC_TIMER_H
+
+void __init nspire_classic_timer_init(void);
+
+#endif
diff --git a/include/linux/platform_data/nspire-keypad.h b/include/linux/platform_data/nspire-keypad.h
new file mode 100644
index 0000000..03deb64
--- /dev/null
+++ b/include/linux/platform_data/nspire-keypad.h
@@ -0,0 +1,28 @@
+/*
+ *  linux/include/linux/platform_data/nspire-keypad.h
+ *
+ *  Copyright (C) 2012 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _LINUX_NSPIRE_KEYPAD_H
+#define _LINUX_NSPIRE_KEYPAD_H
+
+#define KEYPAD_BITMASK_COLS	11
+#define KEYPAD_BITMASK_ROWS	8
+
+struct nspire_keypad_data {
+	struct matrix_keymap_data *keymap;
+
+	/* Maximum delay estimated assuming 33MHz APB */
+	u32 scan_interval;	/* In microseconds (~2000us max) */
+	u32 row_delay;		/* In microseconds (~500us max) */
+
+	bool active_low;
+};
+
+#endif

