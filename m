Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3HLSsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:48:02 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:52490 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3HLSrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:47:07 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 8/9] ARM: dove: add initial DT file for Globalscale D3Plug
Date: Mon, 12 Aug 2013 20:46:54 +0200
Message-Id: <1376333215-12885-9-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an initial DT file for the Globalscale D3Plug with Dove SoC.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/boot/dts/Makefile        |    1 +
 arch/arm/boot/dts/dove-d3plug.dts |  103 +++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)
 create mode 100644 arch/arm/boot/dts/dove-d3plug.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 984a997..ffb361c 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -48,6 +48,7 @@ dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
 	dove-cubox.dtb \
 	dove-d2plug.dtb \
+	dove-d3plug.dtb \
 	dove-dove-db.dtb
 dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 	exynos4210-smdkv310.dtb \
diff --git a/arch/arm/boot/dts/dove-d3plug.dts b/arch/arm/boot/dts/dove-d3plug.dts
new file mode 100644
index 0000000..ead90eb
--- /dev/null
+++ b/arch/arm/boot/dts/dove-d3plug.dts
@@ -0,0 +1,103 @@
+/dts-v1/;
+
+#include "dove.dtsi"
+
+/ {
+	model = "Globalscale D3Plug";
+	compatible = "globalscale,d3plug", "marvell,dove";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 earlyprintk root=/dev/mmcblk0p2 rw rootwait";
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		pinctrl-0 = <&pmx_gpio_0 &pmx_gpio_1 &pmx_gpio_2>;
+		pinctrl-names = "default";
+
+		wlan-act {
+			label = "wlan-act";
+			gpios = <&gpio0 0 1>;
+		};
+
+		wlan-ap {
+			label = "wlan-ap";
+			gpios = <&gpio0 1 1>;
+		};
+
+		status {
+			label = "status";
+			gpios = <&gpio0 2 1>;
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		usb_power: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "USB Power";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			regulator-always-on;
+			regulator-boot-on;
+			gpio = <&gpio0 8 0>;
+			pinctrl-0 = <&pmx_gpio_8>;
+			pinctrl-names = "default";
+		};
+	};
+};
+
+&uart0 { status = "okay"; };
+&sata0 { status = "okay"; };
+&i2c0 { status = "okay"; };
+
+/* Samsung M8G2F eMMC */
+&sdio0 {
+	status = "okay";
+	non-removable;
+	bus-width = <4>;
+};
+
+/* Marvell SD8787 WLAN/BT */
+&sdio1 {
+	status = "okay";
+	non-removable;
+};
+
+&spi0 {
+	status = "okay";
+
+	/* spi0.0: 2M Flash Macronix MX25L1605D */
+	spi-flash@0 {
+		compatible = "st,m25l1605d";
+		spi-max-frequency = <86000000>;
+		reg = <0>;
+	};
+};
+
+&pcie {
+	status = "okay";
+	/* Fresco Logic USB3.0 xHCI controller */
+	pcie-port@0 {
+		status = "okay";
+		reset-gpios = <&gpio0 26 1>;
+		reset-delay-ms = <20>;
+		pinctrl-0 = <&pmx_camera_gpio>;
+		pinctrl-names = "default";
+	};
+	/* Mini-PCIe slot */
+	pcie-port@1 {
+		status = "okay";
+		reset-gpios = <&gpio0 25 1>;
+	};
+};
-- 
1.7.10.4

