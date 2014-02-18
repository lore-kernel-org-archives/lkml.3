Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaBRXSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:18:04 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52532 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbaBRXR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:17:29 -0500
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
Subject: [PATCH v2 5/5] ARM: dts: add bcm590xx pmu support and enable for bcm28155-ap
Date: Tue, 18 Feb 2014 18:17:12 -0500
Message-Id: <1392765432-9111-6-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392765432-9111-1-git-send-email-mporter@linaro.org>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
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
 arch/arm/boot/dts/bcm28155-ap.dts |  43 +++++++++-
 arch/arm/boot/dts/bcm59056.dtsi   | 162 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 204 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/bcm59056.dtsi

diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 5ff2382..28fe731 100644
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
 
@@ -74,3 +84,34 @@
 		status = "okay";
 	};
 };
+
+#include "bcm59056.dtsi"
+
+&pmu {
+	interrupts = <GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH>;
+	regs {
+		regulators {
+			camldo1_reg: regulator@1 {
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			sdldo_reg: regulator@5 {
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+			};
+
+			usbldo_reg: regulator@11 {
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+			};
+
+			iosr1_reg: regulator@14 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/bcm59056.dtsi b/arch/arm/boot/dts/bcm59056.dtsi
new file mode 100644
index 0000000..b04940b
--- /dev/null
+++ b/arch/arm/boot/dts/bcm59056.dtsi
@@ -0,0 +1,162 @@
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
+
+	regs {
+		compatible = "brcm,bcm59056-regs";
+
+		regulators {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			rfldo_reg: regulator@0 {
+				reg = <0>;
+				regulator-compatible = "rfldo";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			camldo1_reg: regulator@1 {
+				reg = <1>;
+				regulator-compatible = "camldo1";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			camldo2_reg: regulator@2 {
+				reg = <2>;
+				regulator-compatible = "camldo2";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			simldo1_reg: regulator@3 {
+				reg = <3>;
+				regulator-compatible = "simldo1";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			simldo2_reg: regulator@4 {
+				reg = <4>;
+				regulator-compatible = "simldo2";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			sdldo_reg: regulator@5 {
+				reg = <5>;
+				regulator-compatible = "sdldo";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			sdxldo_reg: regulator@6 {
+				reg = <6>;
+				regulator-compatible = "sdxldo";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			mmcldo1_reg: regulator@7 {
+				reg = <7>;
+				regulator-compatible = "mmcldo1";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			mmcldo2_reg: regulator@8 {
+				reg = <8>;
+				regulator-compatible = "mmcldo2";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			audldo_reg: regulator@9 {
+				reg = <9>;
+				regulator-compatible = "audldo";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			micldo_reg: regulator@10 {
+				reg = <10>;
+				regulator-compatible = "micldo";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			usbldo_reg: regulator@11 {
+				reg = <11>;
+				regulator-compatible = "usbldo";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			vibldo_reg: regulator@12 {
+				reg = <12>;
+				regulator-compatible = "vibldo";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			csr_reg: regulator@13 {
+				reg = <13>;
+				regulator-compatible = "csr";
+				regulator-min-microvolt = <860000>;
+				regulator-max-microvolt = <1440000>;
+			};
+
+			iosr1_reg: regulator@14 {
+				reg = <14>;
+				regulator-compatible = "iosr1";
+				regulator-min-microvolt = <860000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			iosr2_reg: regulator@15 {
+				reg = <15>;
+				regulator-compatible = "iosr2";
+				regulator-min-microvolt = <860000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			msr_reg: regulator@16 {
+				reg = <16>;
+				regulator-compatible = "msr";
+				regulator-min-microvolt = <860000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			sdsr1_reg: regulator@17 {
+				reg = <17>;
+				regulator-compatible = "sdsr1";
+				regulator-min-microvolt = <860000>;
+				regulator-max-microvolt = <1340000>;
+			};
+
+			sdsr2_reg: regulator@18 {
+				reg = <18>;
+				regulator-compatible = "sdsr2";
+				regulator-min-microvolt = <860000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			vsr_reg: regulator@19 {
+				reg = <19>;
+				regulator-compatible = "vsr";
+				regulator-min-microvolt = <860000>;
+				regulator-max-microvolt = <1800000>;
+			};
+		};
+	};
+};
-- 
1.8.4

