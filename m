Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbaITSGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:06:43 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:48562 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaITSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:06:39 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/5] PCI: mvebu: Amend PCIe controler node documentation
Date: Sat, 20 Sep 2014 20:06:27 +0200
Message-Id: <1411236391-422-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1411236391-422-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1411236391-422-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PCIe controllers found on Armada XP SoCs can be configured as
either four single-lane x1 or one quad-lane x4 PCIe. The current
binding documentation is a bit unclear about it, so amend the
property description of "marvell,pcie-lane" to allow multiple lanes
to be passed. Also, rework the binding example to not only show x1
configuration but both x4 and x1. While at it, correct misnumbered
PCIe port nodes to reflect pcie@<port>,<lane> numbering scheme.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 .../devicetree/bindings/pci/mvebu-pci.txt          | 93 ++++++++--------------
 1 file changed, 31 insertions(+), 62 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/mvebu-pci.txt b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
index 08c716b2c6b6..0f09c933e025 100644
--- a/Documentation/devicetree/bindings/pci/mvebu-pci.txt
+++ b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
@@ -74,14 +74,29 @@ PCIe interface, having the following mandatory properties:
   define the mapping of the PCIe interface to interrupt numbers.
 
 and the following optional properties:
-- marvell,pcie-lane: the physical PCIe lane number, for ports having
-  multiple lanes. If this property is not found, we assume that the
-  value is 0.
+- marvell,pcie-lane: array of physical PCIe lanes. If this property is
+  not found, we assume that the value is 0, i.e. x1 PCIe on lane 0.
 - reset-gpios: optional gpio to PERST#
 - reset-delay-us: delay in us to wait after reset de-assertion
 
 Example:
 
+/*
+ * Armada XP has two 4x1/1x4 PCIe controllers on Port 0 and 1 that can
+ * be configured either as four single-lane x1 or one quad-lane x4 PCIe.
+ * Ports 2 and 3 are single-lane x1 only.
+ *
+ * The pcie-controller node below describes Armada XP PCIe configured as
+ *
+ * - Quad PCIe x4 on Port 0, Lanes 0-3
+ * - Single PCIe x1 on Port 1, Lane 0
+ * - Single PCIe x1 on Port 1, Lane 1
+ * - Single PCIe x1 on Port 1, Lane 2
+ * - Single PCIe x1 on Port 1, Lane 3
+ * - Single PCIe x1 on Port 2
+ * - Single PCIe x1 on Port 3
+ */
+
 pcie-controller {
 	compatible = "marvell,armada-xp-pcie";
 	status = "disabled";
@@ -128,7 +143,7 @@ pcie-controller {
 		0x82000000 0xa 0     MBUS_ID(0x08, 0xf8) 0 1 0 /* Port 3.0 MEM */
 		0x81000000 0xa 0     MBUS_ID(0x08, 0xf0) 0 1 0 /* Port 3.0 IO  */>;
 
-	pcie@1,0 {
+	pcie@0,0 {
 		device_type = "pci";
 		assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
 		reg = <0x0800 0 0 0 0>;
@@ -139,8 +154,9 @@ pcie-controller {
 			  0x81000000 0 0 0x81000000 0x1 0 1 0>;
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0 0 0 0 &mpic 58>;
+		/* Quad lane PCIe x4 on Port 0, Lanes 0-3 */
 		marvell,pcie-port = <0>;
-		marvell,pcie-lane = <0>;
+		marvell,pcie-lane = <0 1 2 3>;
 		/* low-active PERST# reset on GPIO 25 */
 		reset-gpios = <&gpio0 25 1>;
 		/* wait 20ms for device settle after reset deassertion */
@@ -149,58 +165,7 @@ pcie-controller {
 		status = "disabled";
 	};
 
-	pcie@2,0 {
-		device_type = "pci";
-		assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
-		reg = <0x1000 0 0 0 0>;
-		#address-cells = <3>;
-		#size-cells = <2>;
-		#interrupt-cells = <1>;
-		ranges = <0x82000000 0 0 0x82000000 0x2 0 1 0
-			  0x81000000 0 0 0x81000000 0x2 0 1 0>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &mpic 59>;
-		marvell,pcie-port = <0>;
-		marvell,pcie-lane = <1>;
-		clocks = <&gateclk 6>;
-		status = "disabled";
-	};
-
-	pcie@3,0 {
-		device_type = "pci";
-		assigned-addresses = <0x82001800 0 0x48000 0 0x2000>;
-		reg = <0x1800 0 0 0 0>;
-		#address-cells = <3>;
-		#size-cells = <2>;
-		#interrupt-cells = <1>;
-		ranges = <0x82000000 0 0 0x82000000 0x3 0 1 0
-			  0x81000000 0 0 0x81000000 0x3 0 1 0>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &mpic 60>;
-		marvell,pcie-port = <0>;
-		marvell,pcie-lane = <2>;
-		clocks = <&gateclk 7>;
-		status = "disabled";
-	};
-
-	pcie@4,0 {
-		device_type = "pci";
-		assigned-addresses = <0x82002000 0 0x4c000 0 0x2000>;
-		reg = <0x2000 0 0 0 0>;
-		#address-cells = <3>;
-		#size-cells = <2>;
-		#interrupt-cells = <1>;
-		ranges = <0x82000000 0 0 0x82000000 0x4 0 1 0
-			  0x81000000 0 0 0x81000000 0x4 0 1 0>;
-		interrupt-map-mask = <0 0 0 0>;
-		interrupt-map = <0 0 0 0 &mpic 61>;
-		marvell,pcie-port = <0>;
-		marvell,pcie-lane = <3>;
-		clocks = <&gateclk 8>;
-		status = "disabled";
-	};
-
-	pcie@5,0 {
+	pcie@1,0 {
 		device_type = "pci";
 		assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
 		reg = <0x2800 0 0 0 0>;
@@ -211,13 +176,14 @@ pcie-controller {
 			  0x81000000 0 0 0x81000000 0x5 0 1 0>;
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0 0 0 0 &mpic 62>;
+		/* Single lane PCIe x1 on Port 1, Lane 0 */
 		marvell,pcie-port = <1>;
 		marvell,pcie-lane = <0>;
 		clocks = <&gateclk 9>;
 		status = "disabled";
 	};
 
-	pcie@6,0 {
+	pcie@1,1 {
 		device_type = "pci";
 		assigned-addresses = <0x82003000 0 0x84000 0 0x2000>;
 		reg = <0x3000 0 0 0 0>;
@@ -228,13 +194,14 @@ pcie-controller {
 			  0x81000000 0 0 0x81000000 0x6 0 1 0>;
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0 0 0 0 &mpic 63>;
+		/* Single lane PCIe x1 on Port 1, Lane 1 */
 		marvell,pcie-port = <1>;
 		marvell,pcie-lane = <1>;
 		clocks = <&gateclk 10>;
 		status = "disabled";
 	};
 
-	pcie@7,0 {
+	pcie@1,2 {
 		device_type = "pci";
 		assigned-addresses = <0x82003800 0 0x88000 0 0x2000>;
 		reg = <0x3800 0 0 0 0>;
@@ -245,13 +212,14 @@ pcie-controller {
 			  0x81000000 0 0 0x81000000 0x7 0 1 0>;
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0 0 0 0 &mpic 64>;
+		/* Single lane PCIe x1 on Port 1, Lane 2 */
 		marvell,pcie-port = <1>;
 		marvell,pcie-lane = <2>;
 		clocks = <&gateclk 11>;
 		status = "disabled";
 	};
 
-	pcie@8,0 {
+	pcie@1,3 {
 		device_type = "pci";
 		assigned-addresses = <0x82004000 0 0x8c000 0 0x2000>;
 		reg = <0x4000 0 0 0 0>;
@@ -262,13 +230,14 @@ pcie-controller {
 			  0x81000000 0 0 0x81000000 0x8 0 1 0>;
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0 0 0 0 &mpic 65>;
+		/* Single lane PCIe x1 on Port 1, Lane 3 */
 		marvell,pcie-port = <1>;
 		marvell,pcie-lane = <3>;
 		clocks = <&gateclk 12>;
 		status = "disabled";
 	};
 
-	pcie@9,0 {
+	pcie@2,0 {
 		device_type = "pci";
 		assigned-addresses = <0x82004800 0 0x42000 0 0x2000>;
 		reg = <0x4800 0 0 0 0>;
@@ -285,7 +254,7 @@ pcie-controller {
 		status = "disabled";
 	};
 
-	pcie@10,0 {
+	pcie@3,0 {
 		device_type = "pci";
 		assigned-addresses = <0x82005000 0 0x82000 0 0x2000>;
 		reg = <0x5000 0 0 0 0>;
-- 
2.0.0

