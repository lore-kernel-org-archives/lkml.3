Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaF3QEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:04:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51412 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbaF3QEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:04:13 -0400
From: Andy Gross <agross@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, jackp@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [Patch v7 3/3] usb: dwc3: qcom: Add device tree binding
Date: Mon, 30 Jun 2014 11:03:53 -0500
Message-Id: <1404144233-17222-4-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

QCOM USB3.0 core wrapper consist of USB3.0 IP from Synopsys
(SNPS) and HS, SS PHY's control and configuration registers.

It could operate in device mode (SS, HS, FS) and host
mode (SS, HS, FS, LS).

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/usb/qcom,dwc3.txt          |  104 ++++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/qcom,dwc3.txt

diff --git a/Documentation/devicetree/bindings/usb/qcom,dwc3.txt b/Documentation/devicetree/bindings/usb/qcom,dwc3.txt
new file mode 100644
index 0000000..105b6b7
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/qcom,dwc3.txt
@@ -0,0 +1,104 @@
+Qualcomm SuperSpeed DWC3 USB SoC controller
+
+
+QCOM DWC3 Highspeed USB PHY
+========================
+Required properities:
+- compatible:	should contain "qcom,dwc3-hsphy";
+- reg:			offset and length of the register set in the memory map
+- clocks:		A list of phandle + clock-specifier pairs for the
+				clocks listed in clock-names
+- clock-names:	Should contain the following:
+  "utmi"		UTMI clock
+- v1p8-supply:	phandle to the regulator for the 1.8v supply to HSPHY.
+- v3p3-supply:	phandle to the regulator for the 3.3v supply to HSPHY.
+- vbus-supply:	phandle to the regulator for the vbus supply for host
+		mode.
+- vddcx-supply: phandle to the regulator for the vdd supply for HSPHY
+                digital circuit operation.
+
+Optional clocks:
+  "xo"			External reference clock
+
+
+QCOM DWC3 Superspeed USB PHY
+=========================
+Required properities:
+- compatible:	should contain "qcom,dwc3-ssphy";
+- reg:			offset and length of the register set in the memory map
+- clocks:		A list of phandle + clock-specifier pairs for the
+				clocks listed in clock-names
+- clock-names:	Should contain the following:
+  "ref"			Reference clock used in host mode.
+- v1p8-supply:	phandle to the regulator for the 1.8v supply to HSPHY.
+- vddcx-supply: phandle to the regulator for the vdd supply for HSPHY
+                digital circuit operation.
+
+Optional clocks:
+  "xo"			External reference clock
+
+QCOM DWC3 controller wrapper
+===========================
+Required properties:
+- compatible:	should contain "qcom,dwc3"
+- clocks:		A list of phandle + clock-specifier pairs for the
+				clocks listed in clock-names
+- clock-names:	Should contain the following:
+  "core"		Master/Core clock, have to be >= 125 MHz for SS
+				operation and >= 60MHz for HS operation
+
+Optional clocks:
+  "iface"		System bus AXI clock.  Not present on all platforms
+  "sleep"		Sleep clock, used when USB3 core goes into low
+				power mode (U3).
+
+Optional regulator:
+- gdsc-supply:	phandle to the regulator from globally distributed
+				switch controller
+
+Required child node:
+A child node must exist to represent the core DWC3 IP block. The name of
+the node is not important. The content of the node is defined in dwc3.txt.
+
+Example device nodes:
+
+		hs_phy_0: phy@110f8800 {
+			compatible = "qcom,dwc3-hsphy";
+			reg = <0x110f8800 0x30>;
+			clocks = <&gcc USB30_0_UTMI_CLK>;
+			clock-names = "utmi";
+
+			status = "disabled";
+		};
+
+		ss_phy_0: phy@110f8830 {
+			compatible = "qcom,dwc3-ssphy";
+			reg = <0x110f8830 0x30>;
+
+			clocks = <&gcc USB30_0_MASTER_CLK>;
+			clock-names = "ref";
+
+			status = "disabled";
+		};
+
+		usb3_0: usb30@0 {
+			compatible = "qcom,dwc3";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			clocks = <&gcc USB30_0_MASTER_CLK>;
+			clock-names = "core";
+
+			ranges;
+
+			status = "disabled";
+
+			dwc3@11000000 {
+				compatible = "snps,dwc3";
+				reg = <0x11000000 0xcd00>;
+				interrupts = <0 110 0x4>;
+				usb-phy = <&hs_phy_0>, <&ss_phy_0>;
+				phy-names = "usb2-phy", "usb3-phy";
+				tx-fifo-resize;
+				dr_mode = "host";
+			};
+		};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

