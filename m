Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaCGNKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:10:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55871 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbaCGNKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:10:00 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH 7/8] ARM: dts: dra7: Add USB related nodes
Date: Fri, 7 Mar 2014 15:09:10 +0200
Message-ID: <1394197751-28984-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394197751-28984-1-git-send-email-rogerq@ti.com>
References: <1394197751-28984-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for the Super Speed USB controllers, omap-control-usb,
USB2 PHY and USB3 PHY devices.

Remove ocp2scp1 address space from hwmod data as it is
now provided via device tree.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi               | 110 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |  10 ---
 2 files changed, 110 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 597979b..1e73900 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -811,6 +811,116 @@
 			clocks = <&sata_ref_clk>;
 			ti,hwmods = "sata";
 		};
+
+		omap_control_usb2phy1: control-phy@4a002300 {
+			compatible = "ti,control-phy-usb2";
+			reg = <0x4a002300 0x4>;
+			reg-names = "power";
+		};
+
+		omap_control_usb3phy1: control-phy@4a002370 {
+			compatible = "ti,control-phy-pipe3";
+			reg = <0x4a002370 0x4>;
+			reg-names = "power";
+		};
+
+		omap_control_usb2phy2: control-phy@0x4a002e74 {
+			compatible = "ti,control-phy-usb2-dra7";
+			reg = <0x4a002e74 0x4>;
+			reg-names = "power";
+		};
+
+		/* OCP2SCP1 */
+		ocp2scp@4a080000 {
+			compatible = "ti,omap-ocp2scp";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			reg = <0x4a080000 0x20>;
+			ti,hwmods = "ocp2scp1";
+
+			usb2_phy1: phy@4a084000 {
+				compatible = "ti,omap-usb2";
+				reg = <0x4a084000 0x400>;
+				ctrl-module = <&omap_control_usb2phy1>;
+				clocks = <&usb_phy1_always_on_clk32k>,
+					 <&usb_otg_ss1_refclk960m>;
+				clock-names =	"wkupclk",
+						"refclk";
+				#phy-cells = <0>;
+			};
+
+			usb2_phy2: phy@4a085000 {
+				compatible = "ti,omap-usb2";
+				reg = <0x4a085000 0x400>;
+				ctrl-module = <&omap_control_usb2phy2>;
+				clocks = <&usb_phy2_always_on_clk32k>,
+					 <&usb_otg_ss2_refclk960m>;
+				clock-names =	"wkupclk",
+						"refclk";
+				#phy-cells = <0>;
+			};
+
+			usb3_phy1: phy@4a084400 {
+				compatible = "ti,omap-usb3";
+				reg = <0x4a084400 0x80>,
+				      <0x4a084800 0x64>,
+				      <0x4a084c00 0x40>;
+				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
+				ctrl-module = <&omap_control_usb3phy1>;
+				clocks = <&usb_phy3_always_on_clk32k>,
+					 <&sys_clkin1>,
+					 <&usb_otg_ss1_refclk960m>,
+					 <&dpll_core_h13x2_ck>;
+				clock-names =	"wkupclk",
+						"sysclk",
+						"refclk",
+						"optclk";
+				#phy-cells = <0>;
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
+			usb1: usb@48890000 {
+				compatible = "snps,dwc3";
+				reg = <0x48890000 0x17000>;
+				interrupts = <0 76 4>;
+				phys = <&usb2_phy1>, <&usb3_phy1>;
+				phy-names = "usb2-phy", "usb3-phy";
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
+			usb2: usb@488d0000 {
+				compatible = "snps,dwc3";
+				reg = <0x488d0000 0x17000>;
+				interrupts = <0 78 4>;
+				phys = <&usb2_phy2>;
+				phy-names = "usb2-phy";
+				tx-fifo-resize;
+				maximum-speed = "high-speed";
+				dr_mode = "otg";
+			};
+		};
 	};
 };
 
diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index cca24ad..403ba02 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -2351,21 +2351,11 @@ static struct omap_hwmod_ocp_if dra7xx_l4_cfg__mpu = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
-static struct omap_hwmod_addr_space dra7xx_ocp2scp1_addrs[] = {
-	{
-		.pa_start	= 0x4a080000,
-		.pa_end		= 0x4a08001f,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
 /* l4_cfg -> ocp2scp1 */
 static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp1 = {
 	.master		= &dra7xx_l4_cfg_hwmod,
 	.slave		= &dra7xx_ocp2scp1_hwmod,
 	.clk		= "l4_root_clk_div",
-	.addr		= dra7xx_ocp2scp1_addrs,
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
-- 
1.8.3.2

