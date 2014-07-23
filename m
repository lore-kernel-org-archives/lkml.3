Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaGWK7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:59:08 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:38097 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaGWKyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:19 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/25] clocksource: sh_tmu: Add DT support
Date: Wed, 23 Jul 2014 12:53:51 +0200
Message-Id: <1406112847-26275-9-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Document DT bindings and parse them in the TMU driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Simon Horman <horms+renesas@verge.net.au>
---
 .../devicetree/bindings/timer/renesas,tmu.txt      |   39 +++++++++++++++
 drivers/clocksource/sh_tmu.c                       |   51 ++++++++++++++++----
 2 files changed, 80 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/renesas,tmu.txt

diff --git a/Documentation/devicetree/bindings/timer/renesas,tmu.txt b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
new file mode 100644
index 0000000..425d0c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
@@ -0,0 +1,39 @@
+* Renesas R-Car Timer Unit (TMU)
+
+The TMU is a 32-bit timer/counter with configurable clock inputs and
+programmable compare match.
+
+Channels share hardware resources but their counter and compare match value
+are independent. The TMU hardware supports up to three channels.
+
+Required Properties:
+
+  - compatible: must contain "renesas,tmu"
+
+  - reg: base address and length of the registers block for the timer module.
+
+  - interrupts: interrupt-specifier for the timer, one per channel.
+
+  - clocks: a list of phandle + clock-specifier pairs, one for each entry
+    in clock-names.
+  - clock-names: must contain "fck" for the functional clock.
+
+Optional Properties:
+
+  - #renesas,channels: number of channels implemented by the timer, must be 2
+    or 3 (if not specified the value defaults to 3).
+
+
+Example: R8A7779 (R-Car H1) TMU0 node
+
+	tmu0: timer@ffd80000 {
+		compatible = "renesas,tmu";
+		reg = <0xffd80000 0x30>;
+		interrupts = <0 32 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 33 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 34 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp0_clks R8A7779_CLK_TMU0>;
+		clock-names = "fck";
+
+		#renesas,channels = <3>;
+	};
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 560a31a..0f665b8 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
@@ -509,23 +510,48 @@ static int sh_tmu_map_memory(struct sh_tmu_device *tmu)
 	return 0;
 }
 
+static int sh_tmu_parse_dt(struct sh_tmu_device *tmu)
+{
+	struct device_node *np = tmu->pdev->dev.of_node;
+
+	tmu->model = SH_TMU;
+	tmu->num_channels = 3;
+
+	of_property_read_u32(np, "#renesas,channels", &tmu->num_channels);
+
+	if (tmu->num_channels != 2 && tmu->num_channels != 3) {
+		dev_err(&tmu->pdev->dev, "invalid number of channels %u\n",
+			tmu->num_channels);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 {
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	const struct platform_device_id *id = pdev->id_entry;
 	unsigned int i;
 	int ret;
 
-	if (!cfg) {
-		dev_err(&tmu->pdev->dev, "missing platform data\n");
-		return -ENXIO;
-	}
-
 	tmu->pdev = pdev;
-	tmu->model = id->driver_data;
 
 	raw_spin_lock_init(&tmu->lock);
 
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
+		ret = sh_tmu_parse_dt(tmu);
+		if (ret < 0)
+			return ret;
+	} else if (pdev->dev.platform_data) {
+		const struct platform_device_id *id = pdev->id_entry;
+		struct sh_timer_config *cfg = pdev->dev.platform_data;
+
+		tmu->model = id->driver_data;
+		tmu->num_channels = hweight8(cfg->channels_mask);
+	} else {
+		dev_err(&tmu->pdev->dev, "missing platform data\n");
+		return -ENXIO;
+	}
+
 	/* Get hold of clock. */
 	tmu->clk = clk_get(&tmu->pdev->dev, "fck");
 	if (IS_ERR(tmu->clk)) {
@@ -545,8 +571,6 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 	}
 
 	/* Allocate and setup the channels. */
-	tmu->num_channels = hweight8(cfg->channels_mask);
-
 	tmu->channels = kzalloc(sizeof(*tmu->channels) * tmu->num_channels,
 				GFP_KERNEL);
 	if (tmu->channels == NULL) {
@@ -628,11 +652,18 @@ static const struct platform_device_id sh_tmu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(platform, sh_tmu_id_table);
 
+static const struct of_device_id sh_tmu_of_table[] __maybe_unused = {
+	{ .compatible = "renesas,tmu" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sh_tmu_of_table);
+
 static struct platform_driver sh_tmu_device_driver = {
 	.probe		= sh_tmu_probe,
 	.remove		= sh_tmu_remove,
 	.driver		= {
 		.name	= "sh_tmu",
+		.of_match_table = of_match_ptr(sh_tmu_of_table),
 	},
 	.id_table	= sh_tmu_id_table,
 };
-- 
1.7.9.5

