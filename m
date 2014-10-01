Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaJAJG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:06:59 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35430 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaJAJGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:06:54 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Cc: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@sonymobile.com,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 3/4] ARM: dts: apq8064: Add USB OTG support
Date: Wed,  1 Oct 2014 10:06:49 +0100
Message-Id: <1412154409-2828-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412154355-2639-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1412154355-2639-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds USB OTG support on USB1 of APQ8064 SOC.
Tested on IFC6410 with ethernet gadget.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts | 22 ++++++++++++++++++++
 arch/arm/boot/dts/qcom-apq8064.dtsi        | 32 ++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
index 96c7b2c..3e2c777 100644
--- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
+++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
@@ -52,12 +52,25 @@
 				regulator-max-microvolt = <3300000>;
 			};
 
+			pm8921_l4: pm8921-l4 {
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
 			pm8921_l23: pm8921-l23 {
 				regulator-min-microvolt = <1700000>;
 				regulator-max-microvolt = <1900000>;
 			};
 		};
 
+		/* OTG */
+		usb1_phy: phy@12500000 {
+			status		= "okay";
+			vddcx-supply	= <&pm8921_s3>;
+			v3p3-supply	= <&pm8921_l3>;
+			v1p8-supply	= <&pm8921_l4>;
+		};
+
 		usb3_phy: phy@12520000 {
 			status		= "okay";
 			vddcx-supply	= <&pm8921_s3>;
@@ -72,6 +85,15 @@
 			v1p8-supply	= <&pm8921_l23>;
 		};
 
+		gadget1: gadget@12500000 {
+			status = "okay";
+		};
+
+		/* OTG */
+		usb1: usb@12500000 {
+			status = "okay";
+		};
+
 		usb3: usb@12520000 {
 			status = "okay";
 		};
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index e33eb03..c251c72 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -488,6 +488,21 @@
 			};
 		};
 
+		usb1_phy: phy@12500000 {
+			compatible	= "qcom,usb-otg-ci";
+			reg		= <0x12500000 0x400>;
+			interrupts	= <0 100 IRQ_TYPE_NONE>;
+			status		= "disabled";
+			dr_mode		= "host";
+
+			clocks		= <&gcc USB_HS1_XCVR_CLK>,
+					  <&gcc USB_HS1_H_CLK>;
+			clock-names	= "core", "iface";
+
+			resets		= <&gcc USB_HS1_RESET>;
+			reset-names	= "link";
+		};
+
 		usb3_phy: phy@12520000 {
 			compatible	= "qcom,usb-otg-ci";
 			reg		= <0x12520000 0x400>;
@@ -518,6 +533,23 @@
 			reset-names	= "link";
 		};
 
+		gadget1: gadget@12500000 {
+			compatible	= "qcom,ci-hdrc";
+			reg		= <0x12500000 0x400>;
+			status		= "disabled";
+			dr_mode		= "peripheral";
+			interrupts	= <0 100 IRQ_TYPE_NONE>;
+			usb-phy		= <&usb1_phy>;
+		};
+
+		usb1: usb@12500000 {
+			compatible	= "qcom,ehci-host";
+			reg		= <0x12500000 0x400>;
+			interrupts	= <0 100 IRQ_TYPE_NONE>;
+			status		= "disabled";
+			usb-phy		= <&usb1_phy>;
+		};
+
 		usb3: usb@12520000 {
 			compatible	= "qcom,ehci-host";
 			reg		= <0x12520000 0x400>;
-- 
1.9.1

