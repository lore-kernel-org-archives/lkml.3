Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3APNab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:30:31 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12887 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3APNa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:30:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Jan 2013 05:29:41 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 1/4] arm: tegra: Add DT nodes for Tegra USB PHY
Date: Wed, 16 Jan 2013 19:00:19 +0530
Message-ID: <1358343022-28919-2-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com>
References: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT nodes for Tegra USB PHY along with related documentation.
Also added a phandle property to controller DT node, for referring
to connected PHY instance.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 .../bindings/usb/nvidia,tegra20-ehci.txt           |    1 +
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   14 ++++++++++++
 arch/arm/boot/dts/tegra20.dtsi                     |   22 ++++++++++++++++++++
 3 files changed, 37 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt

diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
index 6ea765a..34c9528 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
@@ -11,6 +11,7 @@ Required properties :
  - phy_type : Should be one of "ulpi" or "utmi".
  - nvidia,vbus-gpio : If present, specifies a gpio that needs to be
    activated for the bus to be powered.
+ - nvidia,phy : phandle of the PHY instance, the controller is connected to.
 
 Required properties for phy_type == ulpi:
   - nvidia,phy-reset-gpio : The GPIO used to reset the PHY.
diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
new file mode 100644
index 0000000..84a4c12
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
@@ -0,0 +1,14 @@
+Tegra SOC USB PHY
+
+The device node for Tegra SOC USB PHY:
+
+Required properties :
+ - compatible : Should be "nvidia,tegra20-usb-phy".
+ - reg : Address and length of the register set for the USB PHY interface.
+ - phy_type : Should be one of "ulpi" or "utmi".
+
+Optional properties:
+  - nvidia,has-legacy-mode : boolean indicates whether this controller can
+    operate in legacy mode (as APX 2500 / 2600). In legacy mode some
+    registers are accessed through the APB_MISC base address instead of
+    the USB controller.
\ No newline at end of file
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index b4c13b6..96251b0 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -394,6 +394,25 @@
 		#size-cells = <0>;
 	};
 
+	phy1: usb-phy@c5000400 {
+		compatible = "nvidia,tegra20-usb-phy";
+		reg = <0xc5000400 0x3c00>;
+		phy_type = "utmi";
+		nvidia,has-legacy-mode;
+	};
+
+	phy2: usb-phy@c5004400 {
+		compatible = "nvidia,tegra20-usb-phy";
+		reg = <0xc5004400 0x3c00>;
+		phy_type = "ulpi";
+	};
+
+	phy3: usb-phy@c5008400 {
+		compatible = "nvidia,tegra20-usb-phy";
+		reg = <0xc5008400 0x3C00>;
+		phy_type = "utmi";
+	};
+
 	usb@c5000000 {
 		compatible = "nvidia,tegra20-ehci", "usb-ehci";
 		reg = <0xc5000000 0x4000>;
@@ -402,6 +421,7 @@
 		nvidia,has-legacy-mode;
 		status = "disabled";
 		nvidia,needs-double-reset;
+		nvidia,phy = <&phy1>;
 	};
 
 	usb@c5004000 {
@@ -410,6 +430,7 @@
 		interrupts = <0 21 0x04>;
 		phy_type = "ulpi";
 		status = "disabled";
+		nvidia,phy = <&phy2>;
 	};
 
 	usb@c5008000 {
@@ -418,6 +439,7 @@
 		interrupts = <0 97 0x04>;
 		phy_type = "utmi";
 		status = "disabled";
+		nvidia,phy = <&phy3>;
 	};
 
 	sdhci@c8000000 {
-- 
1.7.0.4

