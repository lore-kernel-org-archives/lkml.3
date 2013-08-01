Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3HAO7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:59:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44642 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab3HAO7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:59:05 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <rnayak@ti.com>
CC: <benoit.cousson@linaro.org>, <balbi@ti.com>, <george.cherian@ti.com>,
        <kishon@ti.com>, <dmurphy@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/4] ARM: dts: dra7: Add USB related nodes
Date: Thu, 1 Aug 2013 17:58:52 +0300
Message-ID: <1375369134-26398-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375369134-26398-1-git-send-email-rogerq@ti.com>
References: <1375369134-26398-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for the Super Speed USB controllers, omap-control-usb,
USB2 PHY and USB3 PHY devices.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |  136 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 136 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index ce9a0f0..3a2e55e 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -484,6 +484,142 @@
 			dmas = <&sdma 70>, <&sdma 71>;
 			dma-names = "tx0", "rx0";
 		};
+
+		omap_control_usb2phy1: omap-control-usb@4a002300 {
+			compatible = "ti,omap-control-usb";
+			reg = <0x4a002300 0x4>;
+			reg-names = "power";
+			ti,type = <2>;
+		};
+
+		omap_control_usb3phy1: omap-control-usb@4a002370 {
+			compatible = "ti,omap-control-usb";
+			reg = <0x4a002370 0x4>;
+			reg-names = "power";
+			ti,type = <3>;
+		};
+
+		omap_control_usb2phy2: omap-control-usb@0x4a002e74 {
+			compatible = "ti,omap-control-usb";
+			reg = <0x4a002e74 0x4>, <0x4a0086c0 0x4>;
+			reg-names = "power", "power_aux";
+			ti,type = <4>;
+		};
+
+		ocp2scp {
+			compatible = "ti,omap-ocp2scp";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			ti,hwmods = "ocp2scp1";
+
+			usb2_phy1: usb2phy1@4a084000 {
+				compatible = "ti,omap-usb2";
+				reg = <0x4a084000 0x400>;
+				ctrl-module = <&omap_control_usb2phy1>;
+				clocks = <&usb_otg_ss1_refclk960m>, <&usb_phy1_always_on_clk32k>;
+				clock-names = "usb_otg_ss_refclk960m", "usb_phy_cm_clk32k";
+			};
+
+			usb2_phy2: usb2phy2@4a085000 {
+				compatible = "ti,omap-usb2";
+				reg = <0x4a085000 0x400>;
+				ctrl-module = <&omap_control_usb2phy2>;
+				clocks = <&usb_otg_ss2_refclk960m>, <&usb_phy2_always_on_clk32k>;
+				clock-names = "usb_otg_ss_refclk960m", "usb_phy_cm_clk32k";
+			};
+
+			usb3_phy1: usb3phy@4a084400 {
+				compatible = "ti,omap-usb3";
+				reg = <0x4a084400 0x80>,
+				      <0x4a084800 0x64>,
+				      <0x4a084c00 0x40>;
+				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
+				ctrl-module = <&omap_control_usb3phy1>;
+				clocks = <&usb_otg_ss1_refclk960m>, <&usb_phy3_always_on_clk32k>;
+				clock-names = "usb_otg_ss_refclk960m", "usb_phy_cm_clk32k";
+			};
+		};
+
+		omap_dwc3_1@48880000 {
+			compatible = "ti,dwc3";
+			ti,hwmods = "usb_otg_ss1";
+			reg = <0x48880000 0x10000>;
+			interrupts = <0 77 4>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			utmi-mode = <2>;
+			ranges;
+			dwc3_1: dwc3@48890000 {
+				compatible = "synopsys,dwc3";
+				reg = <0x48890000 0x17000>;
+				interrupts = <0 76 4>;
+				usb-phy = <&usb2_phy1>, <&usb3_phy1>;
+				tx-fifo-resize;
+				maximum-speed = "super-speed";
+				dr_mode = "otg";
+			};
+		};
+
+		omap_dwc3_2@488c0000 {
+			compatible = "ti,dwc3";
+			ti,hwmods = "usb_otg_ss2";
+			reg = <0x488c0000 0x10000>;
+			interrupts = <0 92 4>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			utmi-mode = <2>;
+			ranges;
+			dwc3_2: dwc3@488d0000 {
+				compatible = "synopsys,dwc3";
+				reg = <0x488d0000 0x17000>;
+				interrupts = <0 78 4>;
+				usb-phy = <&usb2_phy2>;
+				tx-fifo-resize;
+				maximum-speed = "high-speed";
+				dr_mode = "otg";
+			};
+		};
+
+		/* IRQ for DWC3_3 and DWC3_4 need IRQ crossbar */
+		omap_dwc3_3@48900000 {
+			compatible = "ti,dwc3";
+			ti,hwmods = "usb_otg_ss3";
+			reg = <0x48900000 0x10000>;
+		/*	interrupts = <0 TBD 4>; */
+			#address-cells = <1>;
+			#size-cells = <1>;
+			utmi-mode = <2>;
+			ranges;
+			dwc3_3: dwc3@48910000 {
+				compatible = "synopsys,dwc3";
+				reg = <0x48910000 0x17000>;
+		/*		interrupts = <0 93 4>; */
+				tx-fifo-resize;
+				maximum-speed = "high-speed";
+				dr_mode = "otg";
+			};
+		};
+
+		omap_dwc3_4@48940000 {
+			compatible = "ti,dwc3";
+			ti,hwmods = "usb_otg_ss4";
+			reg = <0x48940000 0x10000>;
+		/*	interrupts = <0 TBD 4>; */
+			#address-cells = <1>;
+			#size-cells = <1>;
+			utmi-mode = <2>;
+			ranges;
+			dwc3_4: dwc3@48950000 {
+				compatible = "synopsys,dwc3";
+				reg = <0x48950000 0x17000>;
+		/*		interrupts = <0 TBD 4>; */
+				tx-fifo-resize;
+				maximum-speed = "high-speed";
+				dr_mode = "otg";
+			};
+		};
+
 	};
 
 	clocks {
-- 
1.7.4.1

