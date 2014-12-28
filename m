Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaL1Kq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 05:46:59 -0500
Received: from h1943130.stratoserver.net ([81.169.133.216]:39636 "EHLO
	studio-punkt.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaL1Kq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 05:46:57 -0500
Date: Sun, 28 Dec 2014 11:46:54 +0100
From: Evgeni Dobrev <evgeni@studio-punkt.com>
To: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 1/1] add support for Seagate BlackArmor NAS220
Message-ID: <20141228104654.GA11638@anne>
References: <20141215203855.GA28940@anne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215203855.GA28940@anne>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Seagate BlackArmor NAS220.

The Seagate BlackArmor NAS 220 is a NAS system based on Marvell 88f6192. It has
32MB NAND and 128MB DRAM. It has two SATA slots, one Gigabit Ethernet port, two
USB 2.0 ports, two buttons and three LEDs. There is a serial port available on
the CN5 connector on the board (1 - TX, 4 - RX, 6 - GND).

The only functionality still not implemented is the bi-color led on the front
panel (status). Pins mpp22 and mpp23 control this led. Setting mpp22 to high and
mpp23 to low results in orange color. Setting mpp22 to low and mpp23 to high
results in blue color.

The third led is wired to show the SATA activity on the two drives.

Signed-off-by: Evgeni Dobrev <evgeni@studio-punkt.com>
---
 arch/arm/boot/dts/Makefile                       |    1 +
 arch/arm/boot/dts/kirkwood-blackarmor-nas220.dts |  172 ++++++++++++++++++++++
 2 files changed, 173 insertions(+)
 create mode 100644 arch/arm/boot/dts/kirkwood-blackarmor-nas220.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 38c89ca..780bf29 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -100,6 +100,7 @@ dtb-$(CONFIG_ARCH_KEYSTONE) += k2hk-evm.dtb \
 	k2l-evm.dtb \
 	k2e-evm.dtb
 dtb-$(CONFIG_MACH_KIRKWOOD) += kirkwood-b3.dtb \
+	kirkwood-blackarmor-nas220.dtb \
 	kirkwood-cloudbox.dtb \
 	kirkwood-d2net.dtb \
 	kirkwood-db-88f6281.dtb \
diff --git a/arch/arm/boot/dts/kirkwood-blackarmor-nas220.dts b/arch/arm/boot/dts/kirkwood-blackarmor-nas220.dts
new file mode 100644
index 0000000..27fe2f9
--- /dev/null
+++ b/arch/arm/boot/dts/kirkwood-blackarmor-nas220.dts
@@ -0,0 +1,172 @@
+/*
+ * Device Tree file for Seagate Blackarmor NAS220
+ *
+ * Copyright (C) 2014 Evgeni Dobrev <evgeni@studio-punkt.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+/dts-v1/;
+
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
+#include "kirkwood.dtsi"
+#include "kirkwood-6192.dtsi"
+
+/ {
+	model = "Seagate Blackarmor NAS220";
+	compatible = "seagate,blackarmor-nas220","marvell,kirkwood-88f6192","marvell,kirkwood";
+
+	memory { /* 128 MB */
+		device_type = "memory";
+		reg = <0x00000000 0x8000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8";
+		stdout-path = &uart0;
+	};
+
+	gpio_poweroff {
+		compatible = "gpio-poweroff";
+		gpios = <&gpio0 14 GPIO_ACTIVE_LOW>;
+	};
+
+	gpio_keys {
+		compatible = "gpio-keys";
+
+		button@1{
+			label = "Reset";
+			linux,code = <KEY_POWER>;
+			gpios = <&gpio0 29 GPIO_ACTIVE_HIGH>;
+		};
+
+		button@2{
+			label = "Power";
+			linux,code = <KEY_SLEEP>;
+			gpios = <&gpio0 26 GPIO_ACTIVE_LOW>;
+		};
+	};
+
+	gpio-leds {
+		compatible = "gpio-leds";
+
+		blue-power {
+			label = "nas220:blue:power";
+			gpios = <&gpio0 12 GPIO_ACTIVE_HIGH>;
+			linux,default-trigger = "default-on";
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-0 = <&pmx_power_sata0 &pmx_power_sata1>;
+		pinctrl-names = "default";
+
+		sata0_power: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "SATA0 Power";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			regulator-always-on;
+			regulator-boot-on;
+			gpio = <&gpio0 24 GPIO_ACTIVE_LOW>;
+		};
+
+		sata1_power: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "SATA1 Power";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			regulator-always-on;
+			regulator-boot-on;
+			gpio = <&gpio0 28 GPIO_ACTIVE_LOW>;
+		};
+	};
+};
+
+/*
+ * Serial port routed to connector CN5
+ *
+ * pin 1 - TX (CPU's TX)
+ * pin 4 - RX (CPU's RX)
+ * pin 6 - GND
+ */
+&uart0 {
+	status = "okay";
+};
+
+&pinctrl {
+	pinctrl-0 = <&pmx_button_reset &pmx_button_power>;
+	pinctrl-names = "default";
+
+	pmx_act_sata0: pmx-act-sata0 {
+		marvell,pins = "mpp15";
+		marvell,function = "sata0";
+	};
+
+	pmx_act_sata1: pmx-act-sata1 {
+		marvell,pins = "mpp16";
+		marvell,function = "sata1";
+	};
+
+	pmx_power_sata0: pmx-power-sata0 {
+		marvell,pins = "mpp24";
+		marvell,function = "gpio";
+	};
+
+	pmx_power_sata1: pmx-power-sata1 {
+		marvell,pins = "mpp28";
+		marvell,function = "gpio";
+	};
+
+	pmx_button_reset: pmx-button-reset {
+		marvell,pins = "mpp29";
+		marvell,function = "gpio";
+	};
+
+	pmx_button_power: pmx-button-power {
+		marvell,pins = "mpp26";
+		marvell,function = "gpio";
+	};
+};
+
+&sata {
+	status = "okay";
+	nr-ports = <2>;
+};
+		
+&i2c0 {
+	status = "okay";
+
+	adt7476: thermal@2e {
+		compatible = "adi,adt7476";
+		reg = <0x2e>;
+	};
+};
+
+&nand {
+	status = "okay";
+};
+
+&mdio {
+	status = "okay";
+
+	ethphy0: ethernet-phy@8 {
+		 reg = <8>;
+	};
+};
+
+&eth0 {
+	status = "okay";
+
+	ethernet0-port@0 {
+		phy-handle = <&ethphy0>;
+	};
+};
-- 
1.7.10.4

