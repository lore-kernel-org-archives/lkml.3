Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaI2JPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:15:09 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:39898 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaI2JPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:15:06 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Cc: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 2/4] ARM: DT: apq8064: Add usb host support.
Date: Mon, 29 Sep 2014 10:15:00 +0100
Message-Id: <1411982100-7964-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree nodes to support two usb hosts on APQ8064
SOC.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts | 16 ++++++
 arch/arm/boot/dts/qcom-apq8064.dtsi        | 85 ++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
index b396c83..d6036b8 100644
--- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
+++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
@@ -40,6 +40,22 @@
 			};
 		};
 
+		usb3_phy:phy@12520000 {
+			status = "ok";
+		};
+
+		usb4_phy:phy@12530000 {
+			status = "ok";
+		};
+
+		usb3: usb@12520000 {
+			status = "ok";
+		};
+
+		usb4: usb@12530000 {
+			status = "ok";
+		};
+
 		amba {
 			/* eMMC */
 			sdcc1: sdcc@12400000 {
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 9c2c8e6..491a136 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -263,6 +263,91 @@
 			#address-cells	= <1>;
 			#size-cells	= <0>;
 
+			pm8921_s3: pm8921-s3 {
+				compatible	= "qcom,rpm-pm8921-smps";
+				reg		= <QCOM_RPM_PM8921_SMPS3>;
+
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1400000>;
+				qcom,boot-load 		= <49360>;
+				qcom,switch-mode-frequency = <3200000>;
+				regulator-always-on;
+			};
+
+			pm8921_l3: pm8921-l3 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO3>;
+
+				regulator-min-microvolt = <3050000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+				qcom,boot-load = <50000>;
+			};
+
+			pm8921_l23: pm8921-l23 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO23>;
+
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1800000>;
+				qcom,boot-load = <50000>;
+				regulator-always-on;
+			};
+
+		};
+
+		usb3_phy:phy@12520000 {
+			compatible	= "qcom,usb-otg-ci";
+			reg		= <0x12520000 0x400>;
+			interrupts	= <0 188 0>;
+			status		= "disabled";
+			dr_mode		= "host";
+
+			clocks		= <&gcc USB_HS3_XCVR_CLK>,
+					  <&gcc USB_HS3_H_CLK>;
+			clock-names	= "core", "iface";
+
+			vddcx-supply	= <&pm8921_s3>;
+			v3p3-supply	= <&pm8921_l3>;
+			v1p8-supply	= <&pm8921_l23>;
+
+			resets		= <&gcc USB_HS3_RESET>;
+			reset-names	= "link";
+		};
+
+		usb4_phy:phy@12530000 {
+			compatible	= "qcom,usb-otg-ci";
+			reg		= <0x12530000 0x400>;
+			interrupts	= <0 215 0>;
+			status		= "disabled";
+			dr_mode		= "host";
+
+			clocks		= <&gcc USB_HS4_XCVR_CLK>,
+					  <&gcc USB_HS4_H_CLK>;
+			clock-names	= "core", "iface";
+
+			vddcx-supply	= <&pm8921_s3>;
+			v3p3-supply	= <&pm8921_l3>;
+			v1p8-supply	= <&pm8921_l23>;
+
+			resets		= <&gcc USB_HS4_RESET>;
+			reset-names	= "link";
+		};
+
+		usb3: usb@12520000 {
+			compatible	= "qcom,ehci-host";
+			reg		= <0x12520000 0x400>;
+			interrupts	= <0 188 0>;
+			status		= "disabled";
+			usb-phy		= <&usb3_phy>;
+		};
+
+		usb4: usb@12530000 {
+			compatible	= "qcom,ehci-host";
+			reg		= <0x12530000 0x400>;
+			interrupts	= <0 215 0>;
+			status		= "disabled";
+			usb-phy		= <&usb4_phy>;
 		};
 
 		/* Temporary fixed regulator */
-- 
1.9.1

