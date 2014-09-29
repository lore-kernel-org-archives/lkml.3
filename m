Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaI2JPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:15:42 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33622 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaI2JPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:15:39 -0400
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
Subject: [PATCH 4/4] ARM: DT: apq8064: Add SATA controller support.
Date: Mon, 29 Sep 2014 10:15:34 +0100
Message-Id: <1411982134-8090-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds AHCI based SATA controller support to APQ8064.
Tested on IFC6410 board.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 40 +++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 38d3efa..fa057b7 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -274,6 +274,17 @@
 				regulator-always-on;
 			};
 
+			pm8921_s4: pm8921-s4 {
+				compatible	= "qcom,rpm-pm8921-smps";
+				reg		= <QCOM_RPM_PM8921_SMPS4>;
+
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				qcom,boot-load 		= <200000>;
+				qcom,switch-mode-frequency = <3200000>;
+				regulator-always-on;
+			};
+
 			pm8921_l3: pm8921-l3 {
 				compatible	= "qcom,rpm-pm8921-pldo";
 				reg		= <QCOM_RPM_PM8921_LDO3>;
@@ -396,6 +407,35 @@
 			usb-phy		= <&usb4_phy>;
 		};
 
+		sata_phy0:sata-phy@1b400000{
+			compatible	= "qcom,apq8064-sata-phy";
+			reg		= <0x1b400000 0x200>;
+			reg-names	= "phy_mem";
+			clocks		= <&gcc SATA_PHY_CFG_CLK>;
+			clock-names = "cfg";
+			#phy-cells = <0>;
+		};
+
+		sata0: sata@29000000 {
+			compatible	= "generic-ahci";
+			reg		= <0x29000000 0x180>;
+			interrupts	= <0 209 0>;
+			clocks = <&gcc SFAB_SATA_S_H_CLK>, <&gcc SATA_H_CLK>,
+				 <&gcc SATA_A_CLK>, <&gcc SATA_RXOOB_CLK>,
+				 <&gcc SATA_PMALIVE_CLK>;
+
+			clock-names = "slave_iface", "iface",
+				      "bus", "rxoob",
+				      "core_pmalive";
+			assigned-clocks = <&gcc SATA_RXOOB_CLK>,
+						<&gcc SATA_PMALIVE_CLK>;
+			assigned-clock-rates = <100000000>, <100000000>;
+
+			phys  = <&sata_phy0>;
+			phy-names = "sata-phy";
+			target-supply = <&pm8921_s4>;
+		};
+
 		/* Temporary fixed regulator */
 		vsdcc_fixed: vsdcc-regulator {
 			compatible = "regulator-fixed";
-- 
1.9.1

