Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaIBViW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:38:22 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:47518 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbaIBVfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:35:06 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
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
        linux-usb@vger.kernel.org
Subject: [PATCH v3 3/9] of: Update Tegra XUSB pad controller binding for USB
Date: Tue,  2 Sep 2014 14:34:55 -0700
Message-Id: <1409693701-16520-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new bindings used for USB support by the Tegra XUSB pad controller.
This includes additional PHY types, USB-specific pinconfig properties, etc.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v2:
 - Added nvidia,otg-hs-curr-level-offset property.
 - Dropped "-otg" from VBUS supplies.
 - Added mbox-names property.
 - Removed extra whitespace.
Changes from v1:
 - Updated to use common mailbox bindings.
 - Made USB3 port-to-lane mappins a top-level binding rather than a pinconfig
   binding.
 - Add #defines for the padctl lanes.
---
 .../pinctrl/nvidia,tegra124-xusb-padctl.txt        | 56 ++++++++++++++++++++--
 include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h   | 20 ++++++++
 2 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
index 2f9c0bd..4a1b9475 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
@@ -21,6 +21,18 @@ Required properties:
   - padctl
 - #phy-cells: Should be 1. The specifier is the index of the PHY to reference.
   See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the list of valid values.
+- mboxes: Must contain an entry for the XUSB mailbox channel.
+  See ../mailbox/mailbox.txt for details.
+- mbox-names: Must include the following entries:
+  - xusb
+
+Optional properties:
+-------------------
+- vbus-{0,1,2}-supply: VBUS regulator for the corresponding UTMI pad.
+- vddio-hsic-supply: VDDIO regulator for the HSIC pads.
+- nvidia,usb3-port-{0,1}-lane: PCIe/SATA lane to which the corresponding USB3
+  port is mapped.  See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the list
+  of valid values.
 
 Lane muxing:
 ------------
@@ -50,6 +62,17 @@ Optional properties:
   pin or group should be assigned to. Valid values for function names are
   listed below.
 - nvidia,iddq: Enables IDDQ mode of the lane. (0: no, 1: yes)
+- nvidia,usb2-port-num: USB2 port (0, 1, or 2) to which the lane is mapped.
+- nvidia,hsic-strobe-trim: HSIC strobe trimmer value.
+- nvidia,hsic-rx-strobe-trim: HSIC RX strobe trimmer value.
+- nvidia,hsic-rx-data-trim: HSIC RX data trimmer value.
+- nvidia,hsic-tx-rtune-n: HSIC TX RTUNEN value.
+- nvidia,hsic-tx-rtune-p: HSIC TX RTUNEP value.
+- nvidia,hsic-tx-slew-n: HSIC TX SLEWN value.
+- nvidia,hsic-tx-slew-p: HSIC TX SLEWP value.
+- nvidia,hsic-auto-term: Enables HSIC AUTO_TERM. (0: no, 1: yes)
+- nvidia,otg-hs-curr-level-offset: Offset to be applied to the pad's fused
+  HS_CURR_LEVEL value.
 
 Note that not all of these properties are valid for all lanes. Lanes can be
 divided into three groups:
@@ -58,18 +81,21 @@ divided into three groups:
 
     Valid functions for this group are: "snps", "xusb", "uart", "rsvd".
 
-    The nvidia,iddq property does not apply to this group.
+    The nvidia,otg-hs-curr-level-offset property only applies.
 
   - ulpi-0, hsic-0, hsic-1:
 
     Valid functions for this group are: "snps", "xusb".
 
-    The nvidia,iddq property does not apply to this group.
+    The nvidia,hsic-* properties apply only to the pins hsic-{0,1} when
+    the function is xusb.
 
   - pcie-0, pcie-1, pcie-2, pcie-3, pcie-4, sata-0:
 
     Valid functions for this group are: "pcie", "usb3", "sata", "rsvd".
 
+    The nvidia,usb2-port-num property only applies and is required when
+    the function is usb3.
 
 Example:
 ========
@@ -82,6 +108,8 @@ SoC file extract:
 		reg = <0x0 0x7009f000 0x0 0x1000>;
 		resets = <&tegra_car 142>;
 		reset-names = "padctl";
+		mboxes = <&xusb_mbox>;
+		mbox-names = "xusb";
 
 		#phy-cells = <1>;
 	};
@@ -100,15 +128,35 @@ Board file extract:
 
 	...
 
+	usb@0,70090000 {
+		...
+
+		phys = <&padctl 5>, <&padctl 6>, <&padctl 7>;
+		phy-names = "utmi-1", "utmi-2", "usb3-0";
+
+		...
+	}
+
+	...
+
 	padctl: padctl@0,7009f000 {
 		pinctrl-0 = <&padctl_default>;
 		pinctrl-names = "default";
 
+		nvidia,usb3-port-0-lane = <TEGRA_XUSB_PADCTL_PIN_PCIE_0>;
+		vbus-2-supply = <&vdd_usb3_vbus>;
+
 		padctl_default: pinmux {
-			usb3 {
-				nvidia,lanes = "pcie-0", "pcie-1";
+			otg {
+				nvidia,lanes = "otg-1", "otg-2";
+				nvidia,function = "xusb";
+			};
+
+			usb3p0 {
+				nvidia,lanes = "pcie-0";
 				nvidia,function = "usb3";
 				nvidia,iddq = <0>;
+				nvidia,usb2-port-num = <2>;
 			};
 
 			pcie {
diff --git a/include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h b/include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h
index 914d56d..17b1aab 100644
--- a/include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h
+++ b/include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h
@@ -3,5 +3,25 @@
 
 #define TEGRA_XUSB_PADCTL_PCIE 0
 #define TEGRA_XUSB_PADCTL_SATA 1
+#define TEGRA_XUSB_PADCTL_USB3_P0 2
+#define TEGRA_XUSB_PADCTL_USB3_P1 3
+#define TEGRA_XUSB_PADCTL_UTMI_P0 4
+#define TEGRA_XUSB_PADCTL_UTMI_P1 5
+#define TEGRA_XUSB_PADCTL_UTMI_P2 6
+#define TEGRA_XUSB_PADCTL_HSIC_P0 7
+#define TEGRA_XUSB_PADCTL_HSIC_P1 8
+
+#define TEGRA_XUSB_PADCTL_PIN_OTG_0   0
+#define TEGRA_XUSB_PADCTL_PIN_OTG_1   1
+#define TEGRA_XUSB_PADCTL_PIN_OTG_2   2
+#define TEGRA_XUSB_PADCTL_PIN_ULPI_0  3
+#define TEGRA_XUSB_PADCTL_PIN_HSIC_0  4
+#define TEGRA_XUSB_PADCTL_PIN_HSIC_1  5
+#define TEGRA_XUSB_PADCTL_PIN_PCIE_0  6
+#define TEGRA_XUSB_PADCTL_PIN_PCIE_1  7
+#define TEGRA_XUSB_PADCTL_PIN_PCIE_2  8
+#define TEGRA_XUSB_PADCTL_PIN_PCIE_3  9
+#define TEGRA_XUSB_PADCTL_PIN_PCIE_4 10
+#define TEGRA_XUSB_PADCTL_PIN_SATA_0 11
 
 #endif /* _DT_BINDINGS_PINCTRL_TEGRA_XUSB_H */
-- 
2.1.0.rc2.206.gedb03e5

