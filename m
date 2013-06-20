Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342Ab3FTOKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:10:34 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:57722 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030286Ab3FTOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:10:28 -0400
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
Subject: [PATCH v3 05/10] ARM:stixxxx: Add STiH416 SOC support
Date: Thu, 20 Jun 2013 15:06:07 +0100
Message-Id: <1371737167-9430-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STiH416 is advanced HD AVC processor with 3D graphics acceleration
and 1.2-GHz ARM Cortex-A9 SMP CPU.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Stephen Gallimore <stephen.gallimore@st.com>
CC: Stuart Menefy <stuart.menefy@st.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/arm/stixxxx/stih416-overview.txt |   12 +
 arch/arm/boot/dts/stih416-clock.dtsi           |   41 ++++
 arch/arm/boot/dts/stih416-pinctrl.dtsi         |  295 ++++++++++++++++++++++++
 arch/arm/boot/dts/stih416.dtsi                 |   96 ++++++++
 arch/arm/mach-stixxxx/Kconfig                  |    9 +
 arch/arm/mach-stixxxx/board-dt.c               |    3 +-
 6 files changed, 455 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/arm/stixxxx/stih416-overview.txt
 create mode 100644 arch/arm/boot/dts/stih416-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih416-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih416.dtsi

diff --git a/Documentation/arm/stixxxx/stih416-overview.txt b/Documentation/arm/stixxxx/stih416-overview.txt
new file mode 100644
index 0000000..558444c
--- /dev/null
+++ b/Documentation/arm/stixxxx/stih416-overview.txt
@@ -0,0 +1,12 @@
+			STiH416 Overview
+			================
+
+Introduction
+------------
+
+    The STiH416 is the next generation of HD, AVC set-top box processors
+    for satellite, cable, terrestrial and IP-STB markets.
+
+    Features
+    - ARM Cortex-A9 1.2 GHz dual core CPU
+    - SATA2x2,USB 2.0x3, PCIe, Gbit Ethernet MACx2
diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
new file mode 100644
index 0000000..7026bf1
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-clock.dtsi
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics R&D Limited
+ * <stlinux-devel@stlinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/ {
+	clocks {
+		/*
+		 * Fixed 30MHz oscillator inputs to SoC
+		 */
+		CLK_SYSIN: CLK_SYSIN {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <30000000>;
+			clock-output-names = "CLK_SYSIN";
+		};
+
+		/*
+		 * ARM Peripheral clock for timers
+		 */
+		arm_periph_clk: arm_periph_clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <600000000>;
+		};
+
+		/*
+		 * Bootloader initialized system infrastructure clock for
+		 * serial devices.
+		 */
+		CLK_S_ICN_REG_0: clockgenA0@4 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <100000000>;
+			clock-output-names = "CLK_S_ICN_REG_0";
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
new file mode 100644
index 0000000..957b21a
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -0,0 +1,295 @@
+
+/*
+ * Copyright (C) 2013 STMicroelectronics Limited.
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
+		gpio5	= &PIO40;
+		gpio6	= &PIO5;
+		gpio7	= &PIO6;
+		gpio8	= &PIO7;
+		gpio9	= &PIO8;
+		gpio10	= &PIO9;
+		gpio11	= &PIO10;
+		gpio12	= &PIO11;
+		gpio13	= &PIO12;
+		gpio14	= &PIO30;
+		gpio15	= &PIO31;
+		gpio16	= &PIO13;
+		gpio17	= &PIO14;
+		gpio18	= &PIO15;
+		gpio19	= &PIO16;
+		gpio20	= &PIO17;
+		gpio21	= &PIO18;
+		gpio22	= &PIO100;
+		gpio23	= &PIO101;
+		gpio24	= &PIO102;
+		gpio25	= &PIO103;
+		gpio26	= &PIO104;
+		gpio27	= &PIO105;
+		gpio28	= &PIO106;
+		gpio29	= &PIO107;
+	};
+
+	soc {
+		pin-controller-sbc {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih416-sbc-pinctrl";
+			st,syscfg	= <&syscfg_sbc>;
+			ranges		= <0 0xfe610000 0x6000>;
+
+			PIO0: gpio@fe610000 {
+				gpio-controller;
+				#gpio-cells = <1>;
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
+			PIO40: gpio@fe615000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x5000 0x100>;
+				st,bank-name	= "PIO40";
+				st,retime-pin-mask = <0x7f>;
+			};
+
+			sbc_serial1 {
+				pinctrl_sbc_serial1: sbc_serial1 {
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
+			compatible	= "st,stih416-front-pinctrl";
+			st,syscfg	= <&syscfg_front>;
+			ranges		= <0 0xfee00000 0x10000>;
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
+			PIO30: gpio@fee08000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x8000 0x100>;
+				st,bank-name	= "PIO30";
+			};
+			PIO31: gpio@fee09000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x9000 0x100>;
+				st,bank-name	= "PIO31";
+			};
+		};
+
+		pin-controller-rear {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih416-rear-pinctrl";
+			st,syscfg	= <&syscfg_rear>;
+			ranges 		= <0 0xfe820000 0x6000>;
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
+				st,retime-pin-mask = <0xf>;
+			};
+
+			serial2 {
+				pinctrl_serial2: serial2-0 {
+					st,pins {
+						tx	= <&PIO17 4 ALT2 OUT>;
+						rx	= <&PIO17 5 ALT2 IN>;
+						output-enable	= <&PIO11 3 ALT2 OUT>;
+					};
+				};
+			};
+		};
+
+		pin-controller-fvdp-fe {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih416-fvdp-fe-pinctrl";
+			st,syscfg	= <&syscfg_fvdp_fe>;
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
+		pin-controller-fvdp-lite {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih416-fvdp-lite-pinctrl";
+			st,syscfg		= <&syscfg_fvdp_lite>;
+			ranges			= <0 0xfd330000 0x5000>;
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
+
+			PIO107: gpio@fd334000 {
+				gpio-controller;
+				#gpio-cells	= <1>;
+				reg		= <0x4000 0x100>;
+				st,bank-name	= "PIO107";
+				st,retime-pin-mask = <0xf>;
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
new file mode 100644
index 0000000..3cecd96
--- /dev/null
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -0,0 +1,96 @@
+/*
+ * Copyright (C) 2012 STMicroelectronics Limited.
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "stih41x.dtsi"
+#include "stih416-clock.dtsi"
+#include "stih416-pinctrl.dtsi"
+/ {
+	L2: cache-controller {
+		compatible = "arm,pl310-cache";
+		reg = <0xfffe2000 0x1000>;
+		arm,data-latency = <3 3 3>;
+		arm,tag-latency = <2 2 2>;
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
+		syscfg_sbc:sbc-syscfg@fe600000{
+			compatible	= "st,stih416-sbc-syscfg", "syscon";
+			reg		= <0xfe600000 0x1000>;
+		};
+
+		syscfg_front:front-syscfg@fee10000{
+			compatible	= "st,stih416-front-syscfg", "syscon";
+			reg		= <0xfee10000 0x1000>;
+		};
+
+		syscfg_rear:rear-syscfg@fe830000{
+			compatible	= "st,stih416-rear-syscfg", "syscon";
+			reg		= <0xfe830000 0x1000>;
+		};
+
+		/* MPE */
+		syscfg_fvdp_fe:fvdp-fe-syscfg@fddf0000{
+			compatible	= "st,stih416-fvdp-fe-syscfg", "syscon";
+			reg		= <0xfddf0000 0x1000>;
+		};
+
+		syscfg_fvdp_lite:fvdp-lite-syscfg@fd6a0000{
+			compatible	= "st,stih416-fvdp-lite-syscfg", "syscon";
+			reg		= <0xfd6a0000 0x1000>;
+		};
+
+		syscfg_cpu:cpu-syscfg@fdde0000{
+			compatible	= "st,stih416-cpu-syscfg", "syscon";
+			reg		= <0xfdde0000 0x1000>;
+		};
+
+		syscfg_compo:compo-syscfg@fd320000{
+			compatible	= "st,stih416-compo-syscfg", "syscon";
+			reg		= <0xfd320000 0x1000>;
+		};
+
+		syscfg_transport:transport-syscfg@fd690000{
+			compatible	= "st,stih416-transport-syscfg", "syscon";
+			reg		= <0xfd690000 0x1000>;
+		};
+
+		syscfg_lpm:lpm-syscfg@fe4b5100{
+			compatible	= "st,stih416-lpm-syscfg", "syscon";
+			reg		= <0xfe4b5100 0x8>;
+		};
+
+		serial2: serial@fed32000{
+			compatible	= "st,asc";
+			status 		= "disabled";
+			reg		= <0xfed32000 0x2c>;
+			interrupts	= <0 197 0>;
+			clocks          = <&CLK_S_ICN_REG_0>;
+			pinctrl-names 	= "default";
+			pinctrl-0 	= <&pinctrl_serial2>;
+		};
+
+		/* SBC_UART1 */
+		sbc_serial1: serial@fe531000 {
+			compatible	= "st,asc";
+			status 		= "disabled";
+			reg		= <0xfe531000 0x2c>;
+			interrupts	= <0 210 0>;
+			pinctrl-names 	= "default";
+			pinctrl-0 	= <&pinctrl_sbc_serial1>;
+			clocks          = <&CLK_SYSIN>;
+		};
+	};
+};
diff --git a/arch/arm/mach-stixxxx/Kconfig b/arch/arm/mach-stixxxx/Kconfig
index df0aff2..3e93711 100644
--- a/arch/arm/mach-stixxxx/Kconfig
+++ b/arch/arm/mach-stixxxx/Kconfig
@@ -33,4 +33,13 @@ config SOC_STIH415
 	  and other digital audio/video applications using Flattned Device
 	  Trees.
 
+config SOC_STIH416
+	bool "STiH416 STMicroelectronics Consumer Electronics family"
+	default y
+	help
+	  This enables support for STMicroelectronics Digital Consumer
+	  Electronics family StiH416 parts, primarily targetted at set-top-box
+	  and other digital audio/video applications using Flattened Device
+	  Trees.
+
 endif
diff --git a/arch/arm/mach-stixxxx/board-dt.c b/arch/arm/mach-stixxxx/board-dt.c
index 9c5addd..6487a12 100644
--- a/arch/arm/mach-stixxxx/board-dt.c
+++ b/arch/arm/mach-stixxxx/board-dt.c
@@ -37,10 +37,11 @@ static void __init stih41x_timer_init(void)
 
 static const char *stih41x_dt_match[] __initdata = {
 	"st,stih415",
+	"st,stih416",
 	NULL
 };
 
-DT_MACHINE_START(STM, "STiH415 SoC with Flattened Device Tree")
+DT_MACHINE_START(STM, "STiH415/416 SoC with Flattened Device Tree")
 	.init_time	= stih41x_timer_init,
 	.smp		= smp_ops(stixxxx_smp_ops),
 	.dt_compat	= stih41x_dt_match,
-- 
1.7.6.5

