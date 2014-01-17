Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaAQTVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:21:55 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:54270 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaAQTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:20:03 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v4 6/8] ARM: brcmstb: add misc. DT bindings for brcmstb
Date: Fri, 17 Jan 2014 11:19:25 -0800
Message-Id: <1389986367-4010-7-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1389986367-4010-1-git-send-email-marc.ceeeee@gmail.com>
References: <1389986367-4010-1-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the bindings that the Broadcom STB platform needs
for proper bootup.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/arm/brcm-brcmstb.txt       |   95 ++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt

diff --git a/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt b/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
new file mode 100644
index 0000000..3c436cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
@@ -0,0 +1,95 @@
+ARM Broadcom STB platforms Device Tree Bindings
+-----------------------------------------------
+Boards with Broadcom Brahma15 ARM-based BCMxxxx (generally BCM7xxx variants)
+SoC shall have the following DT organization:
+
+Required root node properties:
+    - compatible: "brcm,bcm<chip_id>", "brcm,brcmstb"
+
+example:
+/ {
+    #address-cells = <2>;
+    #size-cells = <2>;
+    model = "Broadcom STB (bcm7445)";
+    compatible = "brcm,bcm7445", "brcm,brcmstb";
+
+Further, syscon nodes that map platform-specific registers used for general
+system control is required:
+
+    - compatible: "brcm,bcm<chip_id>-sun-top-ctrl", "syscon"
+    - compatible: "brcm,bcm<chip_id>-hif-cpubiuctrl", "syscon"
+    - compatible: "brcm,bcm<chip_id>-hif-continuation", "syscon"
+
+example:
+    rdb {
+        #address-cells = <1>;
+        #size-cells = <1>;
+        compatible = "simple-bus";
+        ranges = <0 0x00 0xf0000000 0x1000000>;
+
+        sun_top_ctrl: syscon@404000 {
+            compatible = "brcm,bcm7445-sun-top-ctrl", "syscon";
+            reg = <0x404000 0x51c>;
+        };
+
+        hif_cpubiuctrl: syscon@3e2400 {
+            compatible = "brcm,bcm7445-hif-cpubiuctrl", "syscon";
+            reg = <0x3e2400 0x5b4>;
+        };
+
+        hif_continuation: syscon@452000 {
+            compatible = "brcm,bcm7445-hif-continuation", "syscon";
+            reg = <0x452000 0x100>;
+        };
+    };
+
+Lastly, nodes that allow for support of SMP initialization and reboot are
+required:
+
+smpboot
+-------
+Required properties:
+
+    - compatible
+        The string "brcm,brcmstb-smpboot".
+
+    - syscon-cpu
+        A phandle / integer array property which lets the BSP know the location
+        of certain CPU power-on registers.
+
+        The layout of the property is as follows:
+            o a phandle to the "hif_cpubiuctrl" syscon node
+            o offset to the base CPU power zone register
+            o offset to the base CPU reset register
+
+    - syscon-cont
+        A phandle pointing to the syscon node which describes the CPU boot
+        continuation registers.
+            o a phandle to the "hif_continuation" syscon node
+
+example:
+    smpboot {
+        compatible = "brcm,brcmstb-smpboot";
+        syscon-cpu = <&hif_cpubiuctrl 0x88 0x178>;
+        syscon-cont = <&hif_continuation>;
+    };
+
+reboot
+-------
+Required properties
+
+    - compatible
+        The string property "brcm,brcmstb-reboot".
+
+    - syscon
+        A phandle / integer array that points to the syscon node which describes
+        the general system reset registers.
+            o a phandle to "sun_top_ctrl"
+            o offset to the "reset source enable" register
+            o offset to the "software master reset" register
+
+example:
+    reboot {
+        compatible = "brcm,brcmstb-reboot";
+        syscon = <&sun_top_ctrl 0x304 0x308>;
+    };
-- 
1.7.1

