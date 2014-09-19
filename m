Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbaISXu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:50:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34256 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaISXuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:50:55 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 2/2] ARM: DT: msm8960: Add sdcc nodes
Date: Fri, 19 Sep 2014 16:50:51 -0700
Message-Id: <1411170651-28855-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1411170651-28855-1-git-send-email-sboyd@codeaurora.org>
References: <1411170651-28855-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the sdcc nodes to support the SD card controller using pl180
mmci driver. We also add a temporary fixed regulator until the
regulator driver is mainlined.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8960-cdp.dts | 12 ++++++++
 arch/arm/boot/dts/qcom-msm8960.dtsi    | 50 ++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
index 8b10812c0cda..7f70fae90959 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
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
 
diff --git a/arch/arm/boot/dts/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom-msm8960.dtsi
index 2f677247744d..e1b0d5cd9e3c 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -2,6 +2,7 @@
 
 /include/ "skeleton.dtsi"
 
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/clock/qcom,gcc-msm8960.h>
 #include <dt-bindings/soc/qcom,gsbi.h>
 
@@ -188,5 +189,54 @@
 			clocks = <&gcc PRNG_CLK>;
 			clock-names = "core";
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
+				max-frequency	= <96000000>;
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
+				max-frequency	= <192000000>;
+				no-1-8-v;
+				vmmc-supply = <&vsdcc_fixed>;
+			};
+		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

