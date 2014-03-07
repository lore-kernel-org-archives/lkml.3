Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaCGNB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:01:58 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:59413 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752762AbaCGNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:01:48 -0500
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH 5/5] rcar_vin: add devicetree support
Date: Fri,  7 Mar 2014 13:01:39 +0000
Message-Id: <1394197299-17528-6-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for devicetree probe for the rcar-vin
driver.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 .../devicetree/bindings/media/rcar_vin.txt         | 79 ++++++++++++++++++++++
 drivers/media/platform/soc_camera/rcar_vin.c       | 67 ++++++++++++++++--
 2 files changed, 140 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/rcar_vin.txt

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
new file mode 100644
index 0000000..105b8de
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -0,0 +1,79 @@
+Renesas RCar Video Input driver (rcar_vin)
+------------------------------------------
+
+The rcar_vin device provides video input capabilities for the Renesas R-Car
+family of devices. The current blocks are always slaves and suppot one input
+channel which can be either RGB, YUYV or BT656.
+
+ - compatible: Must be one of the following
+   - "renesas,vin-r8a7791" for the R8A7791 device
+   - "renesas,vin-r8a7790" for the R8A7790 device
+   - "renesas,vin-r8a7779" for the R8A7779 device
+   - "renesas,vin-r8a7778" for the R8A7778 device
+ - reg: the register base and size for the device registers
+ - interrupts: the interrupt for the device
+ - clocks: Reference to the parent clock
+
+The per-board settings:
+ - port sub-node describing a single endpoint connected to the vin
+   as described in video-interfaces.txt[1]. Only the first one will
+   be considered as each vin interface has one input port.
+
+   These settings are used to work out video input format and widths
+   into the system.
+
+
+Device node example
+-------------------
+
+        vin0: vin@0xe6ef0000 {
+                compatible = "renesas,vin-r8a7790";
+                clocks = <&mstp8_clks R8A7790_CLK_VIN0>;
+                reg = <0 0xe6ef0000 0 0x1000>;
+                interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
+                status = "disabled";
+        };
+
+Board setup example (vin1 composite video input)
+------------------------------------------------
+
+&i2c2   {
+        status = "ok";
+        pinctrl-0 = <&i2c2_pins>;
+        pinctrl-names = "default";
+
+        adv7180: adv7180@0x20 {
+                compatible = "adi,adv7180";
+                reg = <0x20>;
+                remote = <&vin1>;
+
+                port {
+                        adv7180_1: endpoint {
+                                bus-width = <8>;
+                                remote-endpoint = <&vin1ep0>;
+                        };
+                };
+        };
+};
+
+/* composite video input */
+&vin1 {
+        pinctrl-0 = <&vin1_pins>;
+        pinctrl-names = "default";
+
+        status = "ok";
+
+        port {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                vin1ep0: endpoint {
+                        remote-endpoint = <&adv7180_1>;
+                        bus-width = <8>;
+                };
+        };
+};
+
+
+
+[1] video-interfaces.txt common video media interface
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 47516df..73c56c7 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -24,6 +24,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
@@ -32,6 +34,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "soc_scale_crop.h"
@@ -1392,6 +1395,17 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
 	.init_videobuf2	= rcar_vin_init_videobuf2,
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id rcar_vin_of_table[] = {
+	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
+	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
+#endif
+
 static struct platform_device_id rcar_vin_id_table[] = {
 	{ "r8a7791-vin",  RCAR_GEN2 },
 	{ "r8a7790-vin",  RCAR_GEN2 },
@@ -1404,15 +1418,50 @@ MODULE_DEVICE_TABLE(platform, rcar_vin_id_table);
 
 static int rcar_vin_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *match = NULL;
 	struct rcar_vin_priv *priv;
 	struct resource *mem;
 	struct rcar_vin_platform_data *pdata;
+	unsigned int pdata_flags;
 	int irq, ret;
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata || !pdata->flags) {
-		dev_err(&pdev->dev, "platform data not set\n");
-		return -EINVAL;
+	if (pdev->dev.of_node) {
+		struct v4l2_of_endpoint ep;
+		struct device_node *np;
+
+		match = of_match_device(of_match_ptr(rcar_vin_of_table),
+					&pdev->dev);
+
+		np = v4l2_of_get_next_endpoint(pdev->dev.of_node, NULL);
+		if (!np) {
+			dev_err(&pdev->dev, "could not find endpoint\n");
+			return -EINVAL;
+		}
+
+		ret = v4l2_of_parse_endpoint(np, &ep);
+		if (ret) {
+			dev_err(&pdev->dev, "could not parse endpoint\n");
+			return ret;
+		}
+
+		if (ep.bus_type == V4L2_MBUS_BT656)
+			pdata_flags = RCAR_VIN_BT656;
+		else {
+			pdata_flags = 0;
+			if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+				pdata_flags |= RCAR_VIN_HSYNC_ACTIVE_LOW;
+			if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+				pdata_flags |= RCAR_VIN_VSYNC_ACTIVE_LOW;
+		}
+
+		dev_dbg(&pdev->dev, "pdata_flags = %08x\n", pdata_flags);
+	} else {
+		pdata = pdev->dev.platform_data;
+		if (!pdata || !pdata->flags) {
+			dev_err(&pdev->dev, "platform data not set\n");
+			return -EINVAL;
+		}
+		pdata_flags = pdata->flags;
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1447,8 +1496,13 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	priv->ici.drv_name = dev_name(&pdev->dev);
 	priv->ici.ops = &rcar_vin_host_ops;
 
-	priv->pdata_flags = pdata->flags;
-	priv->chip = pdev->id_entry->driver_data;
+	priv->pdata_flags = pdata_flags;
+	if (!match)
+		priv->chip = pdev->id_entry->driver_data;
+	else
+		priv->chip = (enum chip_id)match->data;
+
+
 	spin_lock_init(&priv->lock);
 	INIT_LIST_HEAD(&priv->capture);
 
@@ -1489,6 +1543,7 @@ static struct platform_driver rcar_vin_driver = {
 	.driver		= {
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
+		.of_match_table	= of_match_ptr(rcar_vin_of_table),
 	},
 	.id_table	= rcar_vin_id_table,
 };
-- 
1.9.0

