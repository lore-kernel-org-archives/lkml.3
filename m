Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaCKXe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:34:29 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37548 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbaCKXeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:34:25 -0400
From: Matt Porter <mporter@linaro.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>
Subject: [PATCH v4 5/5] ARM: dts: add bcm590xx pmu support and enable for bcm28155-ap
Date: Tue, 11 Mar 2014 19:33:57 -0400
Message-Id: <1394580837-8331-6-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1394580837-8331-1-git-send-email-mporter@linaro.org>
References: <1394580837-8331-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dtsi to support the BCM590xx PMUs used by the BCM281xx family
of SoCs. Enable regulators for use with the dwc2 and sdhci on
bcm28155-ap.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Signed-off-by: Matt Porter <mporter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/boot/dts/bcm28155-ap.dts | 47 +++++++++++++++++++++++-
 arch/arm/boot/dts/bcm59056.dtsi   | 77 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/bcm59056.dtsi

diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 5ff2382..99ff0c1 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -46,7 +46,11 @@
 
 	i2c@3500d000 {
 		status="okay";
-		clock-frequency = <400000>;
+		clock-frequency = <100000>;
+
+		pmu: pmu@8 {
+			reg = <0x08>;
+		};
 	};
 
 	sdio1: sdio@3f180000 {
@@ -57,16 +61,22 @@
 	sdio2: sdio@3f190000 {
 		non-removable;
 		max-frequency = <48000000>;
+		vmmc-supply = <&camldo1_reg>;
+		vqmmc-supply = <&iosr1_reg>;
 		status = "okay";
 	};
 
 	sdio4: sdio@3f1b0000 {
 		max-frequency = <48000000>;
 		cd-gpios = <&gpio 14 GPIO_ACTIVE_LOW>;
+		vmmc-supply = <&sdldo_reg>;
+		vqmmc-supply = <&sdxldo_reg>;
 		status = "okay";
 	};
 
 	usbotg: usb@3f120000 {
+		vusb_d-supply = <&usbldo_reg>;
+		vusb_a-supply = <&iosr1_reg>;
 		status = "okay";
 	};
 
@@ -74,3 +84,38 @@
 		status = "okay";
 	};
 };
+
+#include "bcm59056.dtsi"
+
+&pmu {
+	compatible = "brcm,bcm59056";
+	interrupts = <GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH>;
+	regulators {
+		camldo1_reg: camldo1 {
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+		};
+
+		sdldo_reg: sdldo {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <3000000>;
+		};
+
+		sdxldo_reg: sdxldo {
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <3300000>;
+		};
+
+		usbldo_reg: usbldo {
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		iosr1_reg: iosr1 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/bcm59056.dtsi b/arch/arm/boot/dts/bcm59056.dtsi
new file mode 100644
index 0000000..0fa1577
--- /dev/null
+++ b/arch/arm/boot/dts/bcm59056.dtsi
@@ -0,0 +1,77 @@
+/*
+* Copyright 2014 Linaro Limited
+* Author: Matt Porter <mporter@linaro.org>
+*
+* This program is free software; you can redistribute it and/or modify it
+* under  the terms of the GNU General  Public License as published by the
+* Free Software Foundation;  either version 2 of the License, or (at your
+* option) any later version.
+*/
+
+&pmu {
+	compatible = "brcm,bcm59056";
+	regulators {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		rfldo_reg: rfldo {
+		};
+
+		camldo1_reg: camldo1 {
+		};
+
+		camldo2_reg: camldo2 {
+		};
+
+		simldo1_reg: simldo1 {
+		};
+
+		simldo2_reg: simldo2 {
+		};
+
+		sdldo_reg: sdldo {
+		};
+
+		sdxldo_reg: sdxldo {
+		};
+
+		mmcldo1_reg: mmcldo1 {
+		};
+
+		mmcldo2_reg: mmcldo2 {
+		};
+
+		audldo_reg: audldo {
+		};
+
+		micldo_reg: micldo {
+		};
+
+		usbldo_reg: usbldo {
+		};
+
+		vibldo_reg: vibldo {
+		};
+
+		csr_reg: csr {
+		};
+
+		iosr1_reg: iosr1 {
+		};
+
+		iosr2_reg: iosr2 {
+		};
+
+		msr_reg: msr {
+		};
+
+		sdsr1_reg: sdsr1 {
+		};
+
+		sdsr2_reg: sdsr2 {
+		};
+
+		vsr_reg: vsr {
+		};
+	};
+};
-- 
1.8.4

