Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485AbaDITrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:47:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41863 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaDITqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:46:09 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de, matthias.bgg@gmail.com,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/4] arm: add basic support for Mediatek MT6589 boards
Date: Wed,  9 Apr 2014 21:45:35 +0200
Message-Id: <1397072736-10793-4-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic devicetree board file and a dtsi for boards
based on the MT6589 SoCs from Mediatek.

Apart from the generic parts (gic, clocks) the only component
currently supported are the timers.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/Kconfig                                   |    2 +
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/mtk6589.dtsi                     |  105 ++++++++++++++++++++
 arch/arm/mach-mediatek/Kconfig                     |   14 +++
 arch/arm/mach-mediatek/Makefile                    |    1 +
 arch/arm/mach-mediatek/mediatek.c                  |   40 ++++++++
 7 files changed, 164 insertions(+)
 create mode 100644 arch/arm/boot/dts/mtk6589.dtsi
 create mode 100644 arch/arm/mach-mediatek/Kconfig
 create mode 100644 arch/arm/mach-mediatek/Makefile
 create mode 100644 arch/arm/mach-mediatek/mediatek.c

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 0f01c9b..af48801 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -67,6 +67,7 @@ linux	Linux-specific binding
 lsi	LSI Corp. (LSI Logic)
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
+mediatek	MediaTek Inc.
 microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
 moxa	Moxa
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5db05f6a..04d46ec 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -995,6 +995,8 @@ source "arch/arm/mach-mv78xx0/Kconfig"
 
 source "arch/arm/mach-imx/Kconfig"
 
+source "arch/arm/mach-mediatek/Kconfig"
+
 source "arch/arm/mach-mxs/Kconfig"
 
 source "arch/arm/mach-netx/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 41c1931..8ce9774 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -170,6 +170,7 @@ machine-$(CONFIG_ARCH_MSM)		+= msm
 machine-$(CONFIG_ARCH_MV78XX0)		+= mv78xx0
 machine-$(CONFIG_ARCH_MVEBU)		+= mvebu
 machine-$(CONFIG_ARCH_MXC)		+= imx
+machine-$(CONFIG_ARCH_MEDIATEK)		+= mediatek
 machine-$(CONFIG_ARCH_MXS)		+= mxs
 machine-$(CONFIG_ARCH_NETX)		+= netx
 machine-$(CONFIG_ARCH_NOMADIK)		+= nomadik
diff --git a/arch/arm/boot/dts/mtk6589.dtsi b/arch/arm/boot/dts/mtk6589.dtsi
new file mode 100644
index 0000000..6dbb74f
--- /dev/null
+++ b/arch/arm/boot/dts/mtk6589.dtsi
@@ -0,0 +1,105 @@
+/*
+ * Copyright (c) 2014 MundoReader S.L.
+ * Author: Matthias Brugger <matthias.bgg@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include "skeleton.dtsi"
+
+/ {
+	compatible = "mediatek,mt6589";
+	interrupt-parent = <&gic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			next-level-cache = <&L2>;
+			reg = <0x0>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			next-level-cache = <&L2>;
+			reg = <0x1>;
+		};
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			next-level-cache = <&L2>;
+			reg = <0x2>;
+		};
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			next-level-cache = <&L2>;
+			reg = <0x3>;
+		};
+
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		system_clk: system_clk {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+			clock-output-names = "system_clk";
+		};
+
+		rtc_clk: rtc_clk {
+			compatible = "fixed-clock";
+			clock-frequency = <32000>;
+			#clock-cells = <0>;
+			clock-output-names = "rtc_clk";
+		};
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		clock-ranges;
+		ranges;
+
+		gic: interrupt-controller@10212000 {
+			compatible = "arm,cortex-a9-gic";
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			reg = <0x10211000 0x1000>,
+			      <0x10212000 0x1000>;
+		};
+
+		L2: l2-cache-controller@1020e000 {
+			compatible = "arm,pl310-cache";
+			reg = <0x1020e000 0x1000>;
+			cache-unified;
+			cache-level = <2>;
+		};
+
+		timer: timer@10008000 {
+			compatible = "mediatek,mtk6589-timer";
+			reg = <0x10008000 0x80>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&system_clk>, <&rtc_clk>;
+			clock-names = "sys_clk", "rtc_clk";
+		};
+	};
+};
diff --git a/arch/arm/mach-mediatek/Kconfig b/arch/arm/mach-mediatek/Kconfig
new file mode 100644
index 0000000..c0139ca
--- /dev/null
+++ b/arch/arm/mach-mediatek/Kconfig
@@ -0,0 +1,14 @@
+config ARCH_MEDIATEK
+	bool "Mediatek MT6589 SoC" if ARCH_MULTI_V7
+	select ARCH_REQUIRE_GPIOLIB
+	select ARM_GIC
+	select CACHE_L2X0
+	select HAVE_ARM_TWD if LOCAL_TIMERS
+	select HAVE_SMP
+	select LOCAL_TIMERS if SMP
+	select COMMON_CLK
+	select GENERIC_CLOCKEVENTS
+	select MTK_TIMER
+	select CLKSRC_MMIO
+	help
+	  Support for Mediatek Cortex-A7 Quad-Core-SoC MT6589.
diff --git a/arch/arm/mach-mediatek/Makefile b/arch/arm/mach-mediatek/Makefile
new file mode 100644
index 0000000..43e619f
--- /dev/null
+++ b/arch/arm/mach-mediatek/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ARCH_MEDIATEK) += mediatek.o
diff --git a/arch/arm/mach-mediatek/mediatek.c b/arch/arm/mach-mediatek/mediatek.c
new file mode 100644
index 0000000..f630403
--- /dev/null
+++ b/arch/arm/mach-mediatek/mediatek.c
@@ -0,0 +1,40 @@
+/*
+ * Device Tree support for Mediatek SoCs
+ *
+ * Copyright (c) 2014 MundoReader S.L.
+ * Author: Matthias Brugger <matthias.bgg@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/of_platform.h>
+#include <linux/irqchip.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/hardware/cache-l2x0.h>
+
+static void __init mediatek_dt_init(void)
+{
+	l2x0_of_init(0, ~0);
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char * const mediatek_board_dt_compat[] = {
+	"mediatek,mt6589",
+	NULL,
+};
+
+DT_MACHINE_START(MEDIATEK_DT, "Mediatek Cortex-A7 (Device Tree)")
+	.init_machine	= mediatek_dt_init,
+	.dt_compat	= mediatek_board_dt_compat,
+MACHINE_END
-- 
1.7.9.5

