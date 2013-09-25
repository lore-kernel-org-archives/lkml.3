Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3IYR67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:58:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37317 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab3IYR65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:58:57 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: devicetree@vger.kernel.org, broonie@kernel.org
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [RFC PATCH] mfd: arizona: Update device tree regulator bindings
Date: Wed, 25 Sep 2013 18:47:52 +0100
Message-Id: <1380131272-16982-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current binding will not be able to locate the regulators DBVDD2,
DBVDD3, CPVDD, SPKVDDL and SPKVDDR as they are required to be present on
the CODEC driver of_node but presently are attached to the MFD of_node.

This patch creates a sub-node for the codec and attaches the required
regulators here using the of_compatible field on the mfd_cell.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
Hi,

Another issue with the Arizona bindings, I am not sure
exactly what the best approach is this patch seems like the
"correct" fix, but it does require a change to the binding,
although the current binding is non-functional.

Alternatively I could simply set the codec of_node to match
the mfd one manually in the codec driver which wouldn't need
the binding changing but feels a bit like a work around.

Any thoughts would be greatly appreciated?

Thanks,
Charles


 Documentation/devicetree/bindings/mfd/arizona.txt |   28 ++++++++++++++++++--
 drivers/mfd/arizona-core.c                        |   15 +++++++++--
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index aa609a6..49592b2 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -3,7 +3,7 @@ Wolfson Arizona class audio SoCs
 These devices are audio SoCs with extensive digital capabilites and a range
 of analogue I/O.
 
-Required properties:
+Required properties, nodes:
 
   - compatible : one of the following chip-specific strings:
 	"wlf,wm5102"
@@ -26,10 +26,19 @@ Required properties:
   - #gpio-cells : Must be 2. The first cell is the pin number and the
     second cell is used to specify optional parameters (currently unused).
 
-  - AVDD1-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
-    SPKVDDL-supply, SPKVDDR-supply : power supplies for the device, as covered
+  - AVDD-supply, DBVDD1-supply : power supplies for the device, as covered
     in Documentation/devicetree/bindings/regulator/regulator.txt
 
+  - codec {} : Represents the audio part of the chip
+      - compatible : one of the following chip-specific strings:
+          "wlf,wm5102-codec"
+          "wlf,wm5110-codec"
+          "wlf,wm8997-codec"
+
+      - DBVDD2-supply, DBVDD3-supply, CPVDD-supply, SPKVDDL-supply,
+        SPKVDDR-supply : power supplies for the codec, as covered in
+        Documentation/devicetree/bindings/regulator/regulator.txt
+
 Optional properties:
 
   - wlf,reset : GPIO specifier for the GPIO controlling /RESET
@@ -60,4 +69,17 @@ codec: wm5102@1a {
 		0xffffffff,
 		0xffffffff,
 	>;
+
+	AVDD-supply = <&example_reg>;
+	DBVDD1-supply = <&example_reg>;
+
+	codec {
+		compatible = "wlf,wm5102-codec";
+
+		DBVDD2-supply = <&example_reg>;
+		DBVDD3-supply = <&example_reg>;
+		CPVDD-supply = <&example_reg>;
+		SPKVDDL-supply = <&example_reg>;
+		SPKVDDR-supply = <&example_reg>;
+	};
 };
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 5ac3aa4..10f8ab7 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -575,7 +575,10 @@ static struct mfd_cell wm5102_devs[] = {
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
 	{ .name = "arizona-pwm" },
-	{ .name = "wm5102-codec" },
+	{
+		.name = "wm5102-codec",
+		.of_compatible = "wlf,wm5102-codec",
+	},
 };
 
 static struct mfd_cell wm5110_devs[] = {
@@ -584,7 +587,10 @@ static struct mfd_cell wm5110_devs[] = {
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
 	{ .name = "arizona-pwm" },
-	{ .name = "wm5110-codec" },
+	{
+		.name = "wm5110-codec",
+		.of_compatible = "wlf,wm5110-codec",
+	};
 };
 
 static struct mfd_cell wm8997_devs[] = {
@@ -593,7 +599,10 @@ static struct mfd_cell wm8997_devs[] = {
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
 	{ .name = "arizona-pwm" },
-	{ .name = "wm8997-codec" },
+	{
+		.name = "wm8997-codec",
+		.of_compatible = "wlf,wm8997-codec",
+	},
 };
 
 int arizona_dev_init(struct arizona *arizona)
-- 
1.7.2.5

