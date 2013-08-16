Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3HPWW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:22:27 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50322 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3HPWWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:22:23 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC v1 4/5] ARM: mvebu: add Armada 1500 and Sony NSZ-GS7 device tree files
Date: Fri, 16 Aug 2013 21:41:37 +0200
Message-Id: <1376682098-10580-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds very basic device tree files for the Marvell Armada 1500 SoC
and the Sony NSZ-GS7 GoogleTV board. Currently, SoC only has nodes for
cpus, some clocks, l2 cache controller, local timer, apb timers, uart,
and interrupt controllers.

The clocks are fixed-clock placeholders until a real DT clock provider
is available. Cache controller node may be wrong and was just guessed
out of Armada 370 and GPL'd 1500 source. Timers except clocksource have
not really been tested.

The separation into soc/apb and soc/sm-apb may be removed, but it looks
like Armada 1500 has a separate peripheral bus for the System Manager
core that can also been accessed by CPUs. (If you look closely on GTV
boot logs, you can see SM and CPU fighting for UART ;) )

The Sony NSZ-GS7 is a GoogleTV consumer device comprising the SoC above.
Since last week or so, there is a way to install a custom u-boot and
boot stock, unsigned kernels easily. Just ask Google about it, if you
are willing to void your warranty.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/Makefile                     |    3 +-
 arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts |   29 +++
 arch/arm/boot/dts/armada-1500.dtsi             |  225 ++++++++++++++++++++++++
 3 files changed, 256 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts
 create mode 100644 arch/arm/boot/dts/armada-1500.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 641b3c9..3186904 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -103,7 +103,8 @@ dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
 	armada-370-rd.dtb \
 	armada-xp-db.dtb \
 	armada-xp-gp.dtb \
-	armada-xp-openblocks-ax3-4.dtb
+	armada-xp-openblocks-ax3-4.dtb \
+	armada-1500-sony-nsz-gs7.dtb
 dtb-$(CONFIG_ARCH_MXC) += \
 	imx25-karo-tx25.dtb \
 	imx25-pdk.dtb \
diff --git a/arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts b/arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts
new file mode 100644
index 0000000..b76c4b8
--- /dev/null
+++ b/arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts
@@ -0,0 +1,29 @@
+/*
+ * Device Tree file for Sony NSZ-GS7
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+/dts-v1/;
+
+#include "armada-1500.dtsi"
+
+/ {
+	model = "Sony NSZ-GS7";
+	compatible = "sony,nsz-gs7", "marvell,armada-1500";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 earlyprintk verbose debug";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>; /* 1 GB */
+	};
+};
+
+&uart0 { status = "okay"; };
diff --git a/arch/arm/boot/dts/armada-1500.dtsi b/arch/arm/boot/dts/armada-1500.dtsi
new file mode 100644
index 0000000..51e0420
--- /dev/null
+++ b/arch/arm/boot/dts/armada-1500.dtsi
@@ -0,0 +1,225 @@
+/*
+ * Device Tree Include file for Marvell Armada 1500 SoC
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include "skeleton.dtsi"
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+
+/ {
+	model = "Marvell Armada 1500 SoC";
+	compatible = "marvell,armada-1500";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "marvell,sheeva-v7";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "marvell,sheeva-v7";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <1>;
+		};
+	};
+
+	clocks {
+		/* 25MHz reference crystal */
+		ref25: oscillator {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <25000000>;
+		};
+
+		cpu0clk: cpu0-clock {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <1200000000>;
+		};
+
+		cfgclk: cfg-clock {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <100000000>;
+		};
+	};
+
+	soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		interrupt-parent = <&gic>;
+
+		ranges = <0 0xf6000000 0x3000000>;
+
+		l2: l2-cache-controller@1ac0000 {
+			compatible = "marvell,aurora-outer-cache";
+			reg = <0x1ac0000 0x1000>;
+			cache-level = <2>;
+		};
+
+		gic: interrupt-controller@1ad0000 {
+			compatible = "arm,cortex-a9-gic";
+			reg = <0x1ad1000 0x1000
+			       0x1ad0100 0x0100>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+		};
+
+		local-timer@1ad0600 {
+			compatible = "arm,cortex-a9-twd-timer";
+			reg = <0x1ad0600 0x20>;
+			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpu0clk>;
+		};
+
+		apb {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			ranges = <0 0x1e80000 0x10000>;
+			interrupt-parent = <&aic>;
+
+			timer0: timer@2c00 {
+				compatible = "snps,dw-apb-timer-osc";
+				reg = <0x2c00 0x14>;
+				interrupts = <8>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer1: timer@2c14 {
+				compatible = "snps,dw-apb-timer-osc";
+				reg = <0x2c14 0x14>;
+				interrupts = <9>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer2: timer@2c28 {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c28 0x14>;
+				interrupts = <10>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer3: timer@2c3c {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c3c 0x14>;
+				interrupts = <11>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer4: timer@2c50 {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c50 0x14>;
+				interrupts = <12>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer5: timer@2c64 {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c64 0x14>;
+				interrupts = <13>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer6: timer@2c78 {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c78 0x14>;
+				interrupts = <14>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer7: timer@2c8c {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c8c 0x14>;
+				interrupts = <15>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			aic: interrupt-controller@3000 {
+				compatible = "marvell,armada-1500-apb-intc";
+				reg = <0x3000 0xc00>;
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
+			};
+		};
+
+		sm-apb {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			ranges = <0 0x1fc0000 0x10000>;
+			interrupt-parent = <&sic>;
+
+			sic: interrupt-controller@e000 {
+				compatible = "marvell,armada-1500-apb-intc";
+				reg = <0xe000 0x400>;
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+			};
+
+			uart0: serial@9000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0x9000 0x100>;
+				reg-shift = <2>;
+				reg-io-width = <1>;
+				interrupts = <8>;
+				clock-frequency = <25000000>;
+				status = "disabled";
+			};
+
+			uart1: serial@a000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0xa000 0x100>;
+				reg-shift = <2>;
+				reg-io-width = <1>;
+				interrupts = <9>;
+				clock-frequency = <25000000>;
+				status = "disabled";
+			};
+
+			uart2: serial@b000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0xb000 0x100>;
+				reg-shift = <2>;
+				reg-io-width = <1>;
+				interrupts = <10>;
+				clock-frequency = <25000000>;
+				status = "disabled";
+			};
+		};
+	};
+ };
-- 
1.7.10.4

