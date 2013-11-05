Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3KETzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:55:50 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3653 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab3KETzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:55:46 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Wendy Ng" <wendy.ng@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Eduardo Valentin" <eduardo.valentin@ti.com>,
        "Kumar Gala" <galak@codeaurora.org>
cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Tim Kryger" <tim.kryger@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Wendy Ng" <wendy.ng@broadcom.com>
Subject: [PATCH V2 3/3] ARM: dts: Add TMON driver support to bcm281xx
Date: Tue, 5 Nov 2013 11:54:44 -0800
Message-ID: <1383681284-17643-4-git-send-email-wendy.ng@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383681284-17643-1-git-send-email-wendy.ng@broadcom.com>
References: <1383681284-17643-1-git-send-email-wendy.ng@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E6792974RS5021675-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the support of Temperature Monitor (TMON) driver for
Broadcom bcm281xx SoCs to the DT node. This also adds the
thermal framework device-tree binding such that TMON driver
can be used within the thermal framework.

Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: Christian Daudt <csd@broadcom.com>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Acked-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/boot/dts/bcm11351-brt.dts |    4 ++++
 arch/arm/boot/dts/bcm11351.dtsi    |   29 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/bcm28155-ap.dts  |    4 ++++
 3 files changed, 37 insertions(+)

diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
index 5a269c7..c24fd12 100644
--- a/arch/arm/boot/dts/bcm11351-brt.dts
+++ b/arch/arm/boot/dts/bcm11351-brt.dts
@@ -43,6 +43,10 @@
 		status = "okay";
 	};
 
+	tmon: tmon@34008000 {
+		status = "okay";
+	};
+
 	usbotg@3f120000 {
 		status = "okay";
 	};
diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 29987e2..0f17beb 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -13,6 +13,7 @@
 
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/thermal/thermal.h>
 
 #include "skeleton.dtsi"
 
@@ -25,6 +26,24 @@
 		bootargs = "console=ttyS0,115200n8";
 	};
 
+	thermal-zones {
+		cpu_thermal: cpu_thermal {
+			polling-delay-passive = <250>; /* msec */
+			polling-delay = <1000>; /* msec */
+
+					   /* sensor */
+			thermal-sensors = <&tmon>;
+
+			trips {
+				cpu_crit: cpu_crit {
+				        temperature = <105000>; /* mCelsius */
+				        hysteresis = <2000>; /* mCelsius */
+				        type = THERMAL_TRIP_CRITICAL;
+				};
+			};
+		};
+	};
+
 	gic: interrupt-controller@3ff00100 {
 		compatible = "arm,cortex-a9-gic";
 		#interrupt-cells = <3>;
@@ -285,6 +304,15 @@
 		};
 	};
 
+	tmon: tmon@34008000 {
+		compatible = "brcm,bcm11351-tmon", "brcm,kona-tmon";
+		reg = <0x34008000 0x0024>;
+		clocks = <&tmon_1m_clk>;
+		interrupts = <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>;
+		#thermal-sensor-cells = <0>;
+		status = "disabled";
+	};
+
 	usbotg: usbotg@3f120000 {
 		compatible = "snps,dwc2";
 		reg = <0x3f120000 0x10000>;
@@ -305,4 +333,5 @@
 		compatible = "brcm,kona-usb2";
 		status = "disabled";
 	};
+
 };
diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 02ebaaf..7151c25 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -63,6 +63,10 @@
 		status = "okay";
 	};
 
+	tmon: tmon@34008000 {
+		status = "okay";
+	};
+
 	usbotg@3f120000 {
 		status = "okay";
 	};
-- 
1.7.9.5


