Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaHRRIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:08:45 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55161 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaHRRIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:08:35 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 7/9] ARM: tegra: Add Tegra124 XUSB mailbox and xHCI controller
Date: Mon, 18 Aug 2014 10:08:23 -0700
Message-Id: <1408381705-3623-8-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for the Tegra XUSB mailbox and Tegra xHCI controller and
add the PHY mailbox channel to the XUSB padctl node.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v1:
 - Updated to use common mailbox bindings.
 - Added remaining clocks/resets.
---
 arch/arm/boot/dts/tegra124.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 03916ef..98b8340 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -3,6 +3,7 @@
 #include <dt-bindings/pinctrl/pinctrl-tegra.h>
 #include <dt-bindings/pinctrl/pinctrl-tegra-xusb.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/mailbox/tegra-xusb-mailbox.h>
 
 #include "skeleton.dtsi"
 
@@ -495,11 +496,50 @@
 		status = "disabled";
 	};
 
+	usb@0,70090000 {
+		compatible = "nvidia,tegra124-xhci";
+		reg = <0x0 0x70090000 0x0 0x8000>,
+		      <0x0 0x70098000 0x0 0x1000>,
+		      <0x0 0x70099000 0x0 0x1000>;
+		interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA124_CLK_XUSB_HOST>,
+			 <&tegra_car TEGRA124_CLK_XUSB_HOST_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_DEV>,
+			 <&tegra_car TEGRA124_CLK_XUSB_DEV_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_FALCON_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_SS>,
+			 <&tegra_car TEGRA124_CLK_XUSB_SS_DIV2>,
+			 <&tegra_car TEGRA124_CLK_XUSB_SS_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_HS_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_FS_SRC>,
+			 <&tegra_car TEGRA124_CLK_PLL_U_480M>,
+			 <&tegra_car TEGRA124_CLK_CLK_M>,
+			 <&tegra_car TEGRA124_CLK_PLL_E>;
+		clock-names = "xusb_host", "xusb_host_src", "xusb_dev",
+			      "xusb_dev_src", "xusb_falcon_src", "xusb_ss",
+			      "xusb_ss_div2", "xusb_ss_src", "xusb_hs_src",
+			      "xusb_fs_src", "pll_u_480m", "clk_m", "pll_e";
+		resets = <&tegra_car 89>, <&tegra_car 95>, <&tegra_car 156>,
+			 <&tegra_car 143>;
+		reset-names = "xusb_host", "xusb_dev", "xusb_ss", "xusb";
+		mboxes = <&mbox TEGRA_XUSB_MBOX_CHAN_HOST>;
+		status = "disabled";
+	};
+
+	mbox: mailbox@0,70098000 {
+		compatible = "nvidia,tegra124-xusb-mbox";
+		reg = <0x0 0x70098000 0x0 0x1000>;
+		interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
+
+		#mbox-cells = <1>;
+	};
+
 	padctl: padctl@0,7009f000 {
 		compatible = "nvidia,tegra124-xusb-padctl";
 		reg = <0x0 0x7009f000 0x0 0x1000>;
 		resets = <&tegra_car 142>;
 		reset-names = "padctl";
+		mboxes = <&mbox TEGRA_XUSB_MBOX_CHAN_PHY>;
 
 		#phy-cells = <1>;
 	};
-- 
2.1.0.rc2.206.gedb03e5

