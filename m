Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaISXu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:50:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34249 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaISXuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:50:55 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 1/2] ARM: DT: msm8660: Add sdcc nodes
Date: Fri, 19 Sep 2014 16:50:50 -0700
Message-Id: <1411170651-28855-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the sdcc nodes to support the SD card controller using pl180
mmci driver. We also add a temporary fixed regulator until the
regulator driver is mainlined.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8660-surf.dts | 12 ++++++++
 arch/arm/boot/dts/qcom-msm8660.dtsi     | 51 +++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8660-surf.dts b/arch/arm/boot/dts/qcom-msm8660-surf.dts
index ff7c53f58a06..e0883c376248 100644
--- a/arch/arm/boot/dts/qcom-msm8660-surf.dts
+++ b/arch/arm/boot/dts/qcom-msm8660-surf.dts
@@ -14,6 +14,18 @@
 				status = "ok";
 			};
 		};
+
+		amba {
+			/* eMMC */
+			sdcc1: sdcc@12400000 {
+				status = "okay";
+			};
+
+			/* External micro SD card */
+			sdcc3: sdcc@12180000 {
+				status = "okay";
+			};
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/qcom-msm8660.dtsi b/arch/arm/boot/dts/qcom-msm8660.dtsi
index a3fd26b8139f..0affd6193f56 100644
--- a/arch/arm/boot/dts/qcom-msm8660.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8660.dtsi
@@ -2,6 +2,7 @@
 
 /include/ "skeleton.dtsi"
 
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/clock/qcom,gcc-msm8660.h>
 #include <dt-bindings/soc/qcom,gsbi.h>
 
@@ -146,5 +147,55 @@
 				};
 			};
 		};
+
+		/* Temporary fixed regulator */
+		vsdcc_fixed: vsdcc-regulator {
+			compatible = "regulator-fixed";
+			regulator-name = "SDCC Power";
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+			regulator-always-on;
+		};
+
+		amba {
+			compatible = "arm,amba-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			sdcc1: sdcc@12400000 {
+				status		= "disabled";
+				compatible	= "arm,pl18x", "arm,primecell";
+				arm,primecell-periphid = <0x00051180>;
+				reg		= <0x12400000 0x8000>;
+				interrupts	= <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names	= "cmd_irq";
+				clocks		= <&gcc SDC1_CLK>, <&gcc SDC1_H_CLK>;
+				clock-names	= "mclk", "apb_pclk";
+				bus-width	= <8>;
+				max-frequency	= <48000000>;
+				non-removable;
+				cap-sd-highspeed;
+				cap-mmc-highspeed;
+				vmmc-supply = <&vsdcc_fixed>;
+			};
+
+			sdcc3: sdcc@12180000 {
+				compatible	= "arm,pl18x", "arm,primecell";
+				arm,primecell-periphid = <0x00051180>;
+				status		= "disabled";
+				reg		= <0x12180000 0x8000>;
+				interrupts	= <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names	= "cmd_irq";
+				clocks		= <&gcc SDC3_CLK>, <&gcc SDC3_H_CLK>;
+				clock-names	= "mclk", "apb_pclk";
+				bus-width	= <4>;
+				cap-sd-highspeed;
+				cap-mmc-highspeed;
+				max-frequency	= <48000000>;
+				no-1-8-v;
+				vmmc-supply = <&vsdcc_fixed>;
+			};
+		};
 	};
+
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

