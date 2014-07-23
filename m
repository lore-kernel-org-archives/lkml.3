Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbaGWK6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:58:33 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59095 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbaGWKyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:20 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/25] clocksource: sh_mtu2: Add DT support
Date: Wed, 23 Jul 2014 12:53:52 +0200
Message-Id: <1406112847-26275-10-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Document DT bindings and parse them in the MTU2 driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 .../devicetree/bindings/timer/renesas,mtu2.txt     |   39 ++++++++++++++++++++
 drivers/clocksource/sh_mtu2.c                      |    8 ++++
 2 files changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/renesas,mtu2.txt

diff --git a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
new file mode 100644
index 0000000..917453f
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
@@ -0,0 +1,39 @@
+* Renesas R-Car Multi-Function Timer Pulse Unit 2 (MTU2)
+
+The MTU2 is a multi-purpose, multi-channel timer/counter with configurable
+clock inputs and programmable compare match.
+
+Channels share hardware resources but their counter and compare match value
+are independent. The MTU2 hardware supports five channels indexed from 0 to 4.
+
+Required Properties:
+
+  - compatible: must contain "renesas,mtu2"
+
+  - reg: base address and length of the registers block for the timer module.
+
+  - interrupts: interrupt specifiers for the timer, one for each entry in
+    interrupt-names.
+  - interrupt-names: must contain one entry named "tgi?a" for each enabled
+    channel, where "?" is the channel index expressed as one digit from "0" to
+    "4".
+
+  - clocks: a list of phandle + clock-specifier pairs, one for each entry
+    in clock-names.
+  - clock-names: must contain "fck" for the functional clock.
+
+
+Example: R7S72100 (RZ/A1H) MTU2 node
+
+	mtu2: timer@fcff0000 {
+		compatible = "renesas,mtu2";
+		reg = <0xfcff0000 0x400>;
+		interrupts = <0 139 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 146 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 150 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 154 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 159 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "tgi0a", "tgi1a", "tgi2a", "tgi3a", "tgi4a";
+		clocks = <&mstp3_clks R7S72100_CLK_MTU2>;
+		clock-names = "fck";
+	};
diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index b0c229f..3d88698 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -23,6 +23,7 @@
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
@@ -500,11 +501,18 @@ static const struct platform_device_id sh_mtu2_id_table[] = {
 };
 MODULE_DEVICE_TABLE(platform, sh_mtu2_id_table);
 
+static const struct of_device_id sh_mtu2_of_table[] __maybe_unused = {
+	{ .compatible = "renesas,mtu2" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sh_mtu2_of_table);
+
 static struct platform_driver sh_mtu2_device_driver = {
 	.probe		= sh_mtu2_probe,
 	.remove		= sh_mtu2_remove,
 	.driver		= {
 		.name	= "sh_mtu2",
+		.of_match_table = of_match_ptr(sh_mtu2_of_table),
 	},
 	.id_table	= sh_mtu2_id_table,
 };
-- 
1.7.9.5

