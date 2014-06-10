Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaFJLOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:14:52 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51945 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaFJLOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:14:49 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] of: Add NVIDIA Tegra XUSB pad controller binding
Date: Tue, 10 Jun 2014 13:11:45 +0200
Message-Id: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This patch adds the device tree binding documentation for the XUSB pad
controller found on NVIDIA Tegra SoCs. It exposes both pinmuxing and PHY
capabilities.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- move header file to this patch and refer to it in the binding
- update example to match the latest binding

 .../pinctrl/nvidia,tegra124-xusb-padctl.txt        | 131 +++++++++++++++++++++
 include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h   |   7 ++
 2 files changed, 138 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h

diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
new file mode 100644
index 000000000000..9a6b04d9ff92
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
@@ -0,0 +1,131 @@
+Device tree binding for NVIDIA Tegra XUSB pad controller
+========================================================
+
+The Tegra XUSB pad controller manages a set of lanes, each of which can be
+assigned to one out of a set of different pads. Some of these pads have an
+associated PHY that must be powered up before the pad can be used.
+
+This document defines the device-specific binding for the XUSB pad controller.
+
+Refer to pinctrl-bindings.txt in this directory for generic information about
+pin controller device tree bindings and ../phy/phy-bindings.txt for details on
+how to describe and reference PHYs in device trees.
+
+Required properties:
+--------------------
+- compatible: should be "nvidia,tegra124-xusb-padctl"
+- reg: Physical base address and length of the controller's registers.
+- resets: Must contain an entry for each entry in reset-names.
+  See ../reset/reset.txt for details.
+- reset-names: Must include the following entries:
+  - padctl
+- #address-cells: Should be 0.
+- #size-cells: Should be 0.
+- #phy-cells: Should be 1. The specifier is the index of the PHY to reference.
+  See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the list of valid values.
+
+Lane muxing:
+------------
+
+Child nodes contain the pinmux configurations following the conventions from
+the pinctrl-bindings.txt document. Typically a single, static configuration is
+given and applied at boot time.
+
+Each subnode describes groups of lanes along with parameters and pads that
+they should be assigned to. The name of these subnodes is not important. All
+subnodes should be parsed solely based on their content.
+
+Each subnode only applies the parameters that are explicitly listed. In other
+words, if a subnode that lists a function but no pin configuration parameters
+implies no information about any pin configuration parameters. Similarly, a
+subnode that describes only an IDDQ parameter implies no information about
+what function the pins are assigned to. For this reason even seemingly boolean
+values are actually tristates in this binding: unspecified, off or on.
+Unspecified is represented as an absent property, and off/on are represented
+as integer values 0 and 1.
+
+Required properties:
+- nvidia,lanes: An array of strings. Each string is the name of a lane.
+
+Optional properties:
+- nvidia,function: A string that is the name of the function (pad) that the
+  pin or group should be assigned to. Valid values for function names are
+  listed below.
+- nvidia,iddq: Enables IDDQ mode of the lane. (0: no, 1: yes)
+
+Note that not all of these properties are valid for all lanes. Lanes can be
+divided into three groups:
+
+  - otg-0, otg-1, otg-2:
+
+    Valid functions for this group are: "snps", "xusb", "uart", "rsvd".
+
+    The nvidia,iddq property does not apply to this group.
+
+  - ulpi-0, hsic-0, hsic-1:
+
+    Valid functions for this group are: "snps", "xusb".
+
+    The nvidia,iddq property does not apply to this group.
+
+  - pcie-0, pcie-1, pcie-2, pcie-3, pcie-4, sata-0:
+
+    Valid functions for this group are: "pcie", "usb3", "sata", "rsvd".
+
+
+Example:
+========
+
+SoC file extract:
+-----------------
+
+	padctl@0,7009f000 {
+		compatible = "nvidia,tegra124-xusb-padctl";
+		reg = <0x0 0x7009f000 0x0 0x1000>;
+		resets = <&tegra_car 142>;
+		reset-names = "padctl";
+
+		#address-cells = <0>;
+		#size-cells = <0>;
+		#phy-cells = <1>;
+	};
+
+Board file extract:
+-------------------
+
+	pcie-controller@0,01003000 {
+		...
+
+		phys = <&padctl 0>;
+		phy-names = "pcie";
+
+		...
+	};
+
+	...
+
+	padctl: padctl@0,7009f000 {
+		pinctrl-0 = <&padctl_default>;
+		pinctrl-names = "default";
+
+		padctl_default: pinmux {
+			usb3 {
+				nvidia,lanes = "pcie-0", "pcie-1";
+				nvidia,function = "usb3";
+				nvidia,iddq = <0>;
+			};
+
+			pcie {
+				nvidia,lanes = "pcie-2", "pcie-3",
+					       "pcie-4";
+				nvidia,function = "pcie";
+				nvidia,iddq = <0>;
+			};
+
+			sata {
+				nvidia,lanes = "sata-0";
+				nvidia,function = "sata";
+				nvidia,iddq = <0>;
+			};
+		};
+	};
diff --git a/include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h b/include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h
new file mode 100644
index 000000000000..914d56da9324
--- /dev/null
+++ b/include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h
@@ -0,0 +1,7 @@
+#ifndef _DT_BINDINGS_PINCTRL_TEGRA_XUSB_H
+#define _DT_BINDINGS_PINCTRL_TEGRA_XUSB_H 1
+
+#define TEGRA_XUSB_PADCTL_PCIE 0
+#define TEGRA_XUSB_PADCTL_SATA 1
+
+#endif /* _DT_BINDINGS_PINCTRL_TEGRA_XUSB_H */
-- 
1.9.2

