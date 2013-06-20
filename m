Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030326Ab3FTOKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:10:22 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:46003 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030286Ab3FTOKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:10:15 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 04/10] ARM:stixxxx: Add STiH415 SOC support
Date: Thu, 20 Jun 2013 15:05:54 +0100
Message-Id: <1371737154-9386-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STiH415 is the next generation of HD, AVC set-top box processors for
satellite, cable, terrestrial and IP-STB markets. It is an ARM Cortex-A9
1.0 GHz, dual-core CPU.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Stephen Gallimore <stephen.gallimore@st.com>
CC: Stuart Menefy <stuart.menefy@st.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/arm/stixxxx/overview.txt         |   33 +++
 Documentation/arm/stixxxx/stih415-overview.txt |   12 +
 MAINTAINERS                                    |   11 +
 arch/arm/Kconfig                               |    2 +
 arch/arm/Makefile                              |    1 +
 arch/arm/boot/dts/st-pincfg.h                  |   71 +++++++
 arch/arm/boot/dts/stih415-clock.dtsi           |   38 ++++
 arch/arm/boot/dts/stih415-pinctrl.dtsi         |  268 ++++++++++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi                 |   87 ++++++++
 arch/arm/boot/dts/stih41x.dtsi                 |   38 ++++
 arch/arm/mach-stixxxx/Kconfig                  |   36 ++++
 arch/arm/mach-stixxxx/Makefile                 |    2 +
 arch/arm/mach-stixxxx/board-dt.c               |   47 ++++
 arch/arm/mach-stixxxx/headsmp.S                |   44 ++++
 arch/arm/mach-stixxxx/platsmp.c                |  117 ++++++++++
 arch/arm/mach-stixxxx/smp.h                    |   17 ++
 16 files changed, 824 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/arm/stixxxx/overview.txt
 create mode 100644 Documentation/arm/stixxxx/stih415-overview.txt
 create mode 100644 arch/arm/boot/dts/st-pincfg.h
 create mode 100644 arch/arm/boot/dts/stih415-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih415-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih415.dtsi
 create mode 100644 arch/arm/boot/dts/stih41x.dtsi
 create mode 100644 arch/arm/mach-stixxxx/Kconfig
 create mode 100644 arch/arm/mach-stixxxx/Makefile
 create mode 100644 arch/arm/mach-stixxxx/board-dt.c
 create mode 100644 arch/arm/mach-stixxxx/headsmp.S
 create mode 100644 arch/arm/mach-stixxxx/platsmp.c
 create mode 100644 arch/arm/mach-stixxxx/smp.h

diff --git a/Documentation/arm/stixxxx/overview.txt b/Documentation/arm/stixxxx/overview.txt
new file mode 100644
index 0000000..a2f6390
--- /dev/null
+++ b/Documentation/arm/stixxxx/overview.txt
@@ -0,0 +1,33 @@
+			STixxxx ARM Linux Overview
+			==========================
+
+Introduction
+------------
+
+  The ST Microelectronics Multimedia and Application Processors range of
+  CortexA9 System-on-Chip are supported by the 'STixxxx' platform of
+  ARM Linux. Currently STiH415, STiH416 SOCs are supported with both
+  B2000 and B2020 Reference boards.
+
+
+  configuration
+  -------------
+
+  A generic configuration is provided for both STiH415/416, and can be used as the
+  default by
+	make stih41x_defconfig
+
+  Layout
+  ------
+  All the files for multiple machine families (STiH415, STiH416, and STiG125)
+  are located in the platform code contained in arch/arm/mach-stixxxx
+
+  There is a generic board board-dt.c in the mach folder which support
+  Flattened Device Tree, which means, It works with any compatible board with
+  Device Trees.
+
+
+  Document Author
+  ---------------
+
+  Srinivas Kandagatla <srinivas.kandagatla@st.com>, (c) 2013 ST Microelectronics
diff --git a/Documentation/arm/stixxxx/stih415-overview.txt b/Documentation/arm/stixxxx/stih415-overview.txt
new file mode 100644
index 0000000..1383e33
--- /dev/null
+++ b/Documentation/arm/stixxxx/stih415-overview.txt
@@ -0,0 +1,12 @@
+			STiH415 Overview
+			================
+
+Introduction
+------------
+
+    The STiH415 is the next generation of HD, AVC set-top box processors
+    for satellite, cable, terrestrial and IP-STB markets.
+
+    Features
+    - ARM Cortex-A9 1.0 GHz, dual-core CPU
+    - SATA2x2,USB 2.0x3, PCIe, Gbit Ethernet MACx2
diff --git a/MAINTAINERS b/MAINTAINERS
index 5be702c..c12ab85 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1201,6 +1201,17 @@ M:	Dinh Nguyen <dinguyen@altera.com>
 S:	Maintained
 F:	drivers/clk/socfpga/
 
+ARM/STIXXXX ARCHITECTURE
+M:	Srinivas Kandagatla <srinivas.kandagatla@st.com>
+M:	Stuart Menefy <stuart.menefy@st.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	kernel@stlinux.com
+W:	http://www.stlinux.com
+S:	Maintained
+F:	arch/arm/mach-stixxxx/
+F:	drivers/pinctrl/pinctrl-stixxxx*
+F:	drivers/clocksource/arm_global_timer.c
+
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 49d993c..790e321 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -989,6 +989,8 @@ source "arch/arm/mach-socfpga/Kconfig"
 
 source "arch/arm/mach-spear/Kconfig"
 
+source "arch/arm/mach-stixxxx/Kconfig"
+
 source "arch/arm/mach-s3c24xx/Kconfig"
 
 if ARCH_S3C64XX
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 1ba358b..c876e0a 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -191,6 +191,7 @@ machine-$(CONFIG_ARCH_W90X900)		+= w90x900
 machine-$(CONFIG_FOOTBRIDGE)		+= footbridge
 machine-$(CONFIG_ARCH_SOCFPGA)		+= socfpga
 machine-$(CONFIG_PLAT_SPEAR)		+= spear
+machine-$(CONFIG_ARCH_STIXXXX)		+= stixxxx
 machine-$(CONFIG_ARCH_VIRT)		+= virt
 machine-$(CONFIG_ARCH_ZYNQ)		+= zynq
 machine-$(CONFIG_ARCH_SUNXI)		+= sunxi
diff --git a/arch/arm/boot/dts/st-pincfg.h b/arch/arm/boot/dts/st-pincfg.h
new file mode 100644
index 0000000..8c45d85
--- /dev/null
+++ b/arch/arm/boot/dts/st-pincfg.h
@@ -0,0 +1,71 @@
+#ifndef _ST_PINCFG_H_
+#define _ST_PINCFG_H_
+
+/* Alternate functions */
+#define ALT1	1
+#define ALT2	2
+#define ALT3	3
+#define ALT4	4
+#define ALT5	5
+#define ALT6	6
+#define ALT7	7
+
+/* Output enable */
+#define OE			(1 << 27)
+/* Pull Up */
+#define PU			(1 << 26)
+/* Open Drain */
+#define OD			(1 << 26)
+#define RT			(1 << 23)
+#define INVERTCLK		(1 << 22)
+#define CLKNOTDATA		(1 << 21)
+#define DOUBLE_EDGE		(1 << 20)
+#define CLK_A			(0 << 18)
+#define CLK_B			(1 << 18)
+#define CLK_C			(2 << 18)
+#define CLK_D			(3 << 18)
+
+/* User-frendly defines for Pin Direction */
+		/* oe = 0, pu = 0, od = 0 */
+#define IN			(0)
+		/* oe = 0, pu = 1, od = 0 */
+#define IN_PU			(PU)
+		/* oe = 1, pu = 0, od = 0 */
+#define OUT			(OE)
+		/* oe = 1, pu = 0, od = 1 */
+#define BIDIR			(OE | OD)
+		/* oe = 1, pu = 1, od = 1 */
+#define BIDIR_PU		(OE | PU | OD)
+
+/* RETIME_TYPE */
+/*
+ * B Mode
+ * Bypass retime with optional delay parameter
+ */
+#define BYPASS		(0)
+/*
+ * R0, R1, R0D, R1D modes
+ * single-edge data non inverted clock, retime data with clk
+ */
+#define SE_NICLK_IO	(RT)
+/*
+ * RIV0, RIV1, RIV0D, RIV1D modes
+ * single-edge data inverted clock, retime data with clk
+ */
+#define SE_ICLK_IO	(RT | INVERTCLK)
+/*
+ * R0E, R1E, R0ED, R1ED modes
+ * double-edge data, retime data with clk
+ */
+#define DE_IO		(RT | DOUBLE_EDGE)
+/*
+ * CIV0, CIV1 modes with inverted clock
+ * Retiming the clk pins will park clock & reduce the noise within the core.
+ */
+#define ICLK		(RT | CLKNOTDATA | INVERTCLK)
+/*
+ * CLK0, CLK1 modes with non-inverted clock
+ * Retiming the clk pins will park clock & reduce the noise within the core.
+ */
+#define NICLK		(RT | CLKNOTDATA)
+#endif /* _ST_PINCFG_H_ */
diff --git a/arch/arm/boot/dts/stih415-clock.dtsi b/arch/arm/boot/dts/stih415-clock.dtsi
new file mode 100644
index 0000000..174c799
--- /dev/null
+++ b/arch/arm/boot/dts/stih415-clock.dtsi
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/ {
+	clocks {
+		/*
+		 * Fixed 30MHz oscillator input to SoC
+		 */
+		CLK_SYSIN: CLK_SYSIN {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <30000000>;
+		};
+
+		/*
+		 * ARM Peripheral clock for timers
+		 */
+		arm_periph_clk: arm_periph_clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <500000000>;
+		};
+
+		/*
+		 * Bootloader initialized system infrastructure clock for
+		 * serial devices.
+		 */
+		CLKS_ICN_REG_0: CLKS_ICN_REG_0 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <100000000>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih415-pinctrl.dtsi b/arch/arm/boot/dts/stih415-pinctrl.dtsi
new file mode 100644
index 0000000..1d322b2
--- /dev/null
+++ b/arch/arm/boot/dts/stih415-pinctrl.dtsi
@@ -0,0 +1,268 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "st-pincfg.h"
+/ {
+
+	aliases {
+		gpio0	= &PIO0;
+		gpio1	= &PIO1;
+		gpio2	= &PIO2;
+		gpio3	= &PIO3;
+		gpio4	= &PIO4;
+		gpio5	= &PIO5;
+		gpio6	= &PIO6;
+		gpio7	= &PIO7;
+		gpio8	= &PIO8;
+		gpio9	= &PIO9;
+		gpio10	= &PIO10;
+		gpio11	= &PIO11;
+		gpio12	= &PIO12;
+		gpio13	= &PIO13;
+		gpio14	= &PIO14;
+		gpio15	= &PIO15;
+		gpio16	= &PIO16;
+		gpio17	= &PIO17;
+		gpio18	= &PIO18;
+		gpio19	= &PIO100;
+		gpio20	= &PIO101;
+		gpio21	= &PIO102;
+		gpio22	= &PIO103;
+		gpio23	= &PIO104;
+		gpio24	= &PIO105;
+		gpio25	= &PIO106;
+		gpio26	= &PIO107;
+	};
+
+	soc {
+		pin-controller-sbc {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih415-sbc-pinctrl";
+			st,syscfg	= <&syscfg_sbc>;
+			ranges 		= <0 0xfe610000 0x5000>;
+
+			PIO0: gpio@fe610000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0 0x100>;
+				st,bank-name	= "PIO0";
+			};
+			PIO1: gpio@fe611000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x1000 0x100>;
+				st,bank-name	= "PIO1";
+			};
+			PIO2: gpio@fe612000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x2000 0x100>;
+				st,bank-name	= "PIO2";
+			};
+			PIO3: gpio@fe613000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x3000 0x100>;
+				st,bank-name	= "PIO3";
+			};
+			PIO4: gpio@fe614000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x4000 0x100>;
+				st,bank-name	= "PIO4";
+			};
+
+			sbc_serial1 {
+				pinctrl_sbc_serial1:sbc_serial1 {
+					st,pins {
+						tx	= <&PIO2 6 ALT3 OUT>;
+						rx	= <&PIO2 7 ALT3 IN>;
+					};
+				};
+			};
+		};
+
+		pin-controller-front {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih415-front-pinctrl";
+			st,syscfg	= <&syscfg_front>;
+			ranges		= <0 0xfee00000 0x8000>;
+
+			PIO5: gpio@fee00000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0 0x100>;
+				st,bank-name	= "PIO5";
+			};
+			PIO6: gpio@fee01000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x1000 0x100>;
+				st,bank-name	= "PIO6";
+			};
+			PIO7: gpio@fee02000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x2000 0x100>;
+				st,bank-name	= "PIO7";
+			};
+			PIO8: gpio@fee03000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x3000 0x100>;
+				st,bank-name	= "PIO8";
+			};
+			PIO9: gpio@fee04000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x4000 0x100>;
+				st,bank-name	= "PIO9";
+			};
+			PIO10: gpio@fee05000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x5000 0x100>;
+				st,bank-name	= "PIO10";
+			};
+			PIO11: gpio@fee06000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x6000 0x100>;
+				st,bank-name	= "PIO11";
+			};
+			PIO12: gpio@fee07000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x7000 0x100>;
+				st,bank-name	= "PIO12";
+			};
+		};
+
+		pin-controller-rear {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih415-rear-pinctrl";
+			st,syscfg	= <&syscfg_rear>;
+			ranges		= <0 0xfe820000 0x8000>;
+
+			PIO13: gpio@fe820000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0 0x100>;
+				st,bank-name	= "PIO13";
+			};
+			PIO14: gpio@fe821000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x1000 0x100>;
+				st,bank-name	= "PIO14";
+			};
+			PIO15: gpio@fe822000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x2000 0x100>;
+				st,bank-name	= "PIO15";
+			};
+			PIO16: gpio@fe823000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x3000 0x100>;
+				st,bank-name	= "PIO16";
+			};
+			PIO17: gpio@fe824000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x4000 0x100>;
+				st,bank-name	= "PIO17";
+			};
+			PIO18: gpio@fe825000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x5000 0x100>;
+				st,bank-name	= "PIO18";
+			};
+
+			serial2 {
+				pinctrl_serial2: serial2-0 {
+					st,pins {
+						tx	= <&PIO17 4 ALT2 OUT>;
+						rx	= <&PIO17 5 ALT2 IN>;
+					};
+				};
+			};
+		};
+
+		pin-controller-left {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih415-left-pinctrl";
+			st,syscfg	= <&syscfg_left>;
+			ranges		= <0 0xfd6b0000 0x3000>;
+
+			PIO100: gpio@fd6b0000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0 0x100>;
+				st,bank-name	= "PIO100";
+			};
+			PIO101: gpio@fd6b1000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x1000 0x100>;
+				st,bank-name	= "PIO101";
+			};
+			PIO102: gpio@fd6b2000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x2000 0x100>;
+				st,bank-name	= "PIO102";
+			};
+		};
+
+		pin-controller-right {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih415-right-pinctrl";
+			st,syscfg	= <&syscfg_right>;
+			ranges		= <0 0xfd330000 0x5000>;
+
+			PIO103: gpio@fd330000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0 0x100>;
+				st,bank-name	= "PIO103";
+			};
+			PIO104: gpio@fd331000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x1000 0x100>;
+				st,bank-name	= "PIO104";
+			};
+			PIO105: gpio@fd332000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x2000 0x100>;
+				st,bank-name	= "PIO105";
+			};
+			PIO106: gpio@fd333000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x3000 0x100>;
+				st,bank-name	= "PIO106";
+			};
+			PIO107: gpio@fd334000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x4000 0x100>;
+				st,bank-name	= "PIO107";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
new file mode 100644
index 0000000..74ab8de
--- /dev/null
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -0,0 +1,87 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "stih41x.dtsi"
+#include "stih415-clock.dtsi"
+#include "stih415-pinctrl.dtsi"
+/ {
+
+	L2: cache-controller {
+		compatible = "arm,pl310-cache";
+		reg = <0xfffe2000 0x1000>;
+		arm,data-latency = <3 2 2>;
+		arm,tag-latency = <1 1 1>;
+		cache-unified;
+		cache-level = <2>;
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		interrupt-parent = <&intc>;
+		ranges;
+		compatible	= "simple-bus";
+
+		syscfg_sbc: sbc-syscfg@fe600000{
+			compatible      = "st,stih415-sbc-syscfg", "syscon";
+			reg		= <0xfe600000 0xb4>;
+		};
+
+		syscfg_front: front-syscfg@fee10000{
+			compatible      = "st,stih415-front-syscfg", "syscon";
+			reg		= <0xfee10000 0x194>;
+		};
+
+		syscfg_rear: rear-syscfg@fe830000{
+			compatible      = "st,stih415-rear-syscfg", "syscon";
+			reg		= <0xfe830000 0x190>;
+		};
+
+		/* MPE syscfgs */
+		syscfg_left: left-syscfg@fd690000{
+			compatible      = "st,stih415-left-syscfg", "syscon";
+			reg		= <0xfd690000 0x78>;
+		};
+
+		syscfg_right: right-syscfg@fd320000{
+			compatible      = "st,stih415-right-syscfg", "syscon";
+			reg		= <0xfd320000 0x180>;
+		};
+
+		syscfg_system: system-syscfg@fdde0000  {
+			compatible      = "st,stih415-system-syscfg", "syscon";
+			reg		= <0xfdde0000 0x15c>;
+		};
+
+		syscfg_lpm: lpm-syscfg@fe4b5100{
+			compatible      = "st,stih415-lpm-syscfg", "syscon";
+			reg		= <0xfe4b5100 0x08>;
+		};
+
+		serial2: serial@fed32000 {
+			compatible	= "st,asc";
+			status 		= "disabled";
+			reg		= <0xfed32000 0x2c>;
+			interrupts	= <0 197 0>;
+			pinctrl-names 	= "default";
+			pinctrl-0 	= <&pinctrl_serial2>;
+			clocks		= <&CLKS_ICN_REG_0>;
+		};
+
+		/* SBC comms block ASCs in SASG1 */
+		sbc_serial1: serial@fe531000 {
+			compatible	= "st,asc";
+			status 		= "disabled";
+			reg		= <0xfe531000 0x2c>;
+			interrupts	= <0 210 0>;
+			clocks		= <&CLK_SYSIN>;
+			pinctrl-names 	= "default";
+			pinctrl-0	= <&pinctrl_sbc_serial1>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih41x.dtsi b/arch/arm/boot/dts/stih41x.dtsi
new file mode 100644
index 0000000..7321403
--- /dev/null
+++ b/arch/arm/boot/dts/stih41x.dtsi
@@ -0,0 +1,38 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		cpu@0 {
+			compatible = "arm,cortex-a9";
+			reg = <0>;
+		};
+		cpu@1 {
+			compatible = "arm,cortex-a9";
+			reg = <1>;
+		};
+	};
+
+	intc: interrupt-controller@fffe1000 {
+		compatible = "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		reg = <0xfffe1000 0x1000>,
+		      <0xfffe0100 0x100>;
+	};
+
+	scu@fffe0000 {
+		compatible = "arm,cortex-a9-scu";
+		reg = <0xfffe0000 0x1000>;
+	};
+
+	timer@fffe0200 {
+		interrupt-parent = <&intc>;
+		compatible = "arm,cortex-a9-global-timer";
+		reg = <0xfffe0200 0x100>;
+		interrupts = <1 11 0x04>;
+		clocks = <&arm_periph_clk>;
+	};
+};
diff --git a/arch/arm/mach-stixxxx/Kconfig b/arch/arm/mach-stixxxx/Kconfig
new file mode 100644
index 0000000..df0aff2
--- /dev/null
+++ b/arch/arm/mach-stixxxx/Kconfig
@@ -0,0 +1,36 @@
+menuconfig ARCH_STIXXXX
+	bool "STMicroelectronics Consumer Electronics SOCs with Device Trees" if ARCH_MULTI_V7
+	select GENERIC_CLOCKEVENTS
+	select CLKDEV_LOOKUP
+	select ARM_GIC
+	select ARM_GLOBAL_TIMER
+	select PINCTRL
+	select PINCTRL_ST
+	select MFD_SYSCON
+	select MIGHT_HAVE_CACHE_L2X0
+	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select ARCH_REQUIRE_GPIOLIB
+	select ARM_ERRATA_720789
+	select ARM_ERRATA_754322
+	select PL310_ERRATA_753970
+	select PL310_ERRATA_769419
+	help
+	  Include support for STiH41x SOCs like STiH415/416 using the device tree
+	  for discovery
+	  More information at Documentation/arm/STiH41x and
+	  at Documentation/devicetree
+
+
+if ARCH_STIXXXX
+
+config SOC_STIH415
+	bool "STiH415 STMicroelectronics Consumer Electronics family"
+	default y
+	help
+	  This enables support for STMicroelectronics Digital Consumer
+	  Electronics family StiH415 parts, primarily targetted at set-top-box
+	  and other digital audio/video applications using Flattned Device
+	  Trees.
+
+endif
diff --git a/arch/arm/mach-stixxxx/Makefile b/arch/arm/mach-stixxxx/Makefile
new file mode 100644
index 0000000..50bf128
--- /dev/null
+++ b/arch/arm/mach-stixxxx/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
+obj-$(CONFIG_ARCH_STIXXXX) 		+= board-dt.o
diff --git a/arch/arm/mach-stixxxx/board-dt.c b/arch/arm/mach-stixxxx/board-dt.c
new file mode 100644
index 0000000..9c5addd
--- /dev/null
+++ b/arch/arm/mach-stixxxx/board-dt.c
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ * Author(s): Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clocksource.h>
+#include <linux/irq.h>
+#include <asm/hardware/cache-l2x0.h>
+#include <asm/mach/arch.h>
+
+#include "smp.h"
+
+void __init stih41x_l2x0_init(void)
+{
+	u32 way_size = 0x4;
+	u32 aux_ctrl;
+	/* may be this can be encoded in macros like BIT*() */
+	aux_ctrl = (0x1 << L2X0_AUX_CTRL_SHARE_OVERRIDE_SHIFT) |
+		(0x1 << L2X0_AUX_CTRL_DATA_PREFETCH_SHIFT) |
+		(0x1 << L2X0_AUX_CTRL_INSTR_PREFETCH_SHIFT) |
+		(way_size << L2X0_AUX_CTRL_WAY_SIZE_SHIFT);
+
+	l2x0_of_init(aux_ctrl, L2X0_AUX_CTRL_MASK);
+}
+
+static void __init stih41x_timer_init(void)
+{
+	of_clk_init(NULL);
+	clocksource_of_init();
+	stih41x_l2x0_init();
+}
+
+static const char *stih41x_dt_match[] __initdata = {
+	"st,stih415",
+	NULL
+};
+
+DT_MACHINE_START(STM, "STiH415 SoC with Flattened Device Tree")
+	.init_time	= stih41x_timer_init,
+	.smp		= smp_ops(stixxxx_smp_ops),
+	.dt_compat	= stih41x_dt_match,
+MACHINE_END
diff --git a/arch/arm/mach-stixxxx/headsmp.S b/arch/arm/mach-stixxxx/headsmp.S
new file mode 100644
index 0000000..146cf4f
--- /dev/null
+++ b/arch/arm/mach-stixxxx/headsmp.S
@@ -0,0 +1,44 @@
+/*
+ *  arch/arm/mach-stixxxx/headsmp.S
+ *
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ *		http://www.st.com
+ *
+ * Cloned from linux/arch/arm/mach-vexpress/headsmp.S
+ *
+ *  Copyright (c) 2003 ARM Limited
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+	__INIT
+
+/*
+ * ST specific entry point for secondary CPUs.  This provides
+ * a "holding pen" into which all secondary cores are held until we're
+ * ready for them to initialise.
+ */
+ENTRY(stixxxx_secondary_startup)
+	mrc	p15, 0, r0, c0, c0, 5
+	and	r0, r0, #15
+	adr	r4, 1f
+	ldmia	r4, {r5, r6}
+	sub	r4, r4, r5
+	add	r6, r6, r4
+pen:	ldr	r7, [r6]
+	cmp	r7, r0
+	bne	pen
+
+	/*
+	 * we've been released from the holding pen: secondary_stack
+	 * should now contain the SVC stack for this core
+	 */
+	b	secondary_startup
+
+1:	.long	.
+	.long	pen_release
diff --git a/arch/arm/mach-stixxxx/platsmp.c b/arch/arm/mach-stixxxx/platsmp.c
new file mode 100644
index 0000000..0df91df
--- /dev/null
+++ b/arch/arm/mach-stixxxx/platsmp.c
@@ -0,0 +1,117 @@
+/*
+ *  arch/arm/mach-stixxxx/platsmp.c
+ *
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ *		http://www.st.com
+ *
+ * Cloned from linux/arch/arm/mach-vexpress/platsmp.c
+ *
+ *  Copyright (C) 2002 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include <asm/cacheflush.h>
+#include <asm/smp_plat.h>
+#include <asm/smp_scu.h>
+
+#include "smp.h"
+
+static void __cpuinit write_pen_release(int val)
+{
+	pen_release = val;
+	smp_wmb();
+	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
+	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
+}
+
+static DEFINE_SPINLOCK(boot_lock);
+
+void __cpuinit stixxxx_secondary_init(unsigned int cpu)
+{
+	trace_hardirqs_off();
+
+	/*
+	 * let the primary processor know we're out of the
+	 * pen, then head off into the C entry point
+	 */
+	write_pen_release(-1);
+
+	/*
+	 * Synchronise with the boot thread.
+	 */
+	spin_lock(&boot_lock);
+	spin_unlock(&boot_lock);
+}
+
+int __cpuinit stixxxx_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long timeout;
+
+	/*
+	 * set synchronisation state between this boot processor
+	 * and the secondary one
+	 */
+	spin_lock(&boot_lock);
+
+	/*
+	 * The secondary processor is waiting to be released from
+	 * the holding pen - release it, then wait for it to flag
+	 * that it has been released by resetting pen_release.
+	 *
+	 * Note that "pen_release" is the hardware CPU ID, whereas
+	 * "cpu" is Linux's internal ID.
+	 */
+	write_pen_release(cpu_logical_map(cpu));
+
+	/*
+	 * Send the secondary CPU a soft interrupt, thereby causing
+	 * it to jump to the secondary entrypoint.
+	 */
+	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
+
+	timeout = jiffies + (1 * HZ);
+	while (time_before(jiffies, timeout)) {
+		smp_rmb();
+		if (pen_release == -1)
+			break;
+
+		udelay(10);
+	}
+
+	/*
+	 * now the secondary core is starting up let it run its
+	 * calibrations, then wait for it to finish
+	 */
+	spin_unlock(&boot_lock);
+
+	return pen_release != -1 ? -ENOSYS : 0;
+}
+
+void __init stixxxx_smp_prepare_cpus(unsigned int max_cpus)
+{
+	void __iomem *scu_base = NULL;
+	struct device_node *np = of_find_compatible_node(
+					NULL, NULL, "arm,cortex-a9-scu");
+	if (np) {
+		scu_base = of_iomap(np, 0);
+		scu_enable(scu_base);
+		of_node_put(np);
+	}
+}
+
+struct smp_operations __initdata stixxxx_smp_ops = {
+	.smp_prepare_cpus	= stixxxx_smp_prepare_cpus,
+	.smp_secondary_init	= stixxxx_secondary_init,
+	.smp_boot_secondary	= stixxxx_boot_secondary,
+};
diff --git a/arch/arm/mach-stixxxx/smp.h b/arch/arm/mach-stixxxx/smp.h
new file mode 100644
index 0000000..97c3689
--- /dev/null
+++ b/arch/arm/mach-stixxxx/smp.h
@@ -0,0 +1,17 @@
+/*
+ *  arch/arm/mach-stixxxx/smp.h
+ *
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ *		http://www.st.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_STIXXXX_SMP_H
+#define __MACH_STIXXXX_SMP_H
+
+extern struct smp_operations	stixxxx_smp_ops;
+
+#endif
-- 
1.7.6.5

