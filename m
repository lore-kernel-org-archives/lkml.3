Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaEHRgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:36:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbaEHRgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:36:46 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-56-536bc0ad9a2a
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH V2 3/4] exynos4-is: Remove requirement for "simple-bus"
 compatible
Date: Thu, 08 May 2014 19:36:23 +0200
Message-id: <1399570583-29824-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAd21B7KDDT5sFrSYf+Qcq8XZpjfs
	FpseX2O1uLxrDptFz4atrBZLr19ksmjde4Td4vCbdlYHDo8189Ywemxa1cnmsXlJvUffllWM
	Hp83yQWwRnHZpKTmZJalFunbJXBlrPnfyFzwUK/i9LGwBsb7al2MnBwSAiYSq2c0sEHYYhIX
	7q0Hsrk4hAQWMUpsaD3PDOF0MEm8nvWPGaSKTcBQovdoHyOILSIgL/Gk9wZYB7PADUaJNS1/
	mUASwgIhEj9P/gAbyyKgKvHx4V2wZl4BN4nL2yaydDFyAK1TkJgzyWYCI/cCRoZVjKKpBckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGMHB8kxqB+PKBotDjAIcjEo8vC+mZAcLsSaWFVfmHmKU4GBW
	EuF9sQwoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgZE5
	z//12pknw63jZpVc/sMVUPWq2iH9km7lAkm3mgnT7jrcK/20aenlk7sM+vpa9taur8isvMzW
	frN9q6DfJpG2A48n5TKty7BV0op8M+NxxIZJcsKKiUuUsxOXvwnWkHktN3/9VIaT+16sc7Cf
	zr38U262p2hH0EezqW8uCH0yWPl74YYMd0slluKMREMt5qLiRADlMtsuEgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the driver instantiating its child devices itself,
rather than relying on an OS to instantiate devices as children
of "simple-bus". This removes an incorrect usage of "simple-bus"
compatible.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This patch addresses Mark's review comments:
https://patchwork.linuxtv.org/patch/23008/
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    6 +++---
 drivers/media/platform/exynos4-is/fimc-is.c        |   16 +++++++++++++--
 drivers/media/platform/exynos4-is/media-dev.c      |   21 ++++++++++++++++----
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 922d6f8..8ce5984 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -15,9 +15,9 @@ Common 'camera' node
 
 Required properties:
 
-- compatible: must be "samsung,fimc", "simple-bus"
+- compatible: should be "samsung,fimc",
 - clocks: list of clock specifiers, corresponding to entries in
-  the clock-names property;
+  the clock-names property,
 - clock-names : must contain "sclk_cam0", "sclk_cam1", "pxl_async0",
   "pxl_async1" entries, matching entries in the clocks property.
 
@@ -157,7 +157,7 @@ Example:
 	};
 
 	camera {
-		compatible = "samsung,fimc", "simple-bus";
+		compatible = "samsung,fimc";
 		clocks = <&clock 132>, <&clock 133>, <&clock 351>,
 			 <&clock 352>;
 		clock-names = "sclk_cam0", "sclk_cam1", "pxl_async0",
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 6bbb6ca..4be3dd8 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -24,6 +24,7 @@
 #include <linux/i2c.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
+#include <linux/of_device.h>
 #include <linux/of_graph.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
@@ -221,10 +222,9 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 	return 0;
 }
 
-static int fimc_is_unregister_subdevs(struct fimc_is *is)
+static void fimc_is_unregister_subdevs(struct fimc_is *is)
 {
 	fimc_isp_subdev_destroy(&is->isp);
-	return 0;
 }
 
 static int fimc_is_load_setfile(struct fimc_is *is, char *file_name)
@@ -774,6 +774,8 @@ static int fimc_is_runtime_suspend(struct device *dev);
 static int fimc_is_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	bool create_children = !of_device_is_compatible(dev->of_node,
+						       "simple-bus");
 	struct fimc_is *is;
 	struct resource res;
 	struct device_node *node;
@@ -801,6 +803,12 @@ static int fimc_is_probe(struct platform_device *pdev)
 	if (!node)
 		return -ENODEV;
 
+	if (create_children) {
+		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+		if (ret < 0)
+			return ret;
+	}
+
 	is->pmu_regs = of_iomap(node, 0);
 	if (!is->pmu_regs)
 		return -ENOMEM;
@@ -868,6 +876,9 @@ err_irq:
 	free_irq(is->irq, is);
 err_clk:
 	fimc_is_put_clocks(is);
+	if (create_children)
+		of_device_destroy_children(dev);
+
 	return ret;
 }
 
@@ -928,6 +939,7 @@ static int fimc_is_remove(struct platform_device *pdev)
 		release_firmware(is->fw.f_w);
 	fimc_is_free_cpu_memory(is);
 
+	of_device_destroy_children(dev);
 	return 0;
 }
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 344718d..f6d89ac 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -622,13 +622,13 @@ dev_unlock:
 }
 
 /* Register FIMC, FIMC-LITE and CSIS media entities */
-static int fimc_md_register_platform_entities(struct fimc_md *fmd,
-					      struct device_node *parent)
+static int fimc_md_register_platform_entities(struct fimc_md *fmd)
 {
+	struct device *parent = &fmd->pdev->dev;
 	struct device_node *node;
 	int ret = 0;
 
-	for_each_available_child_of_node(parent, node) {
+	for_each_available_child_of_node(parent->of_node, node) {
 		struct platform_device *pdev;
 		int plat_entity = -1;
 
@@ -651,6 +651,7 @@ static int fimc_md_register_platform_entities(struct fimc_md *fmd,
 			ret = fimc_md_register_platform_entity(fmd, pdev,
 							plat_entity);
 		put_device(&pdev->dev);
+
 		if (ret < 0)
 			break;
 	}
@@ -1318,6 +1319,8 @@ unlock:
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	bool create_children = !of_device_is_compatible(dev->of_node,
+						       "simple-bus");
 	struct v4l2_device *v4l2_dev;
 	struct fimc_md *fmd;
 	int ret;
@@ -1343,6 +1346,14 @@ static int fimc_md_probe(struct platform_device *pdev)
 	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
 	fmd->user_subdev_api = true;
 
+	if (create_children) {
+		ret = of_platform_populate(dev->of_node,
+					   of_default_bus_match_table,
+					   NULL, dev);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
@@ -1371,7 +1382,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
-	ret = fimc_md_register_platform_entities(fmd, dev->of_node);
+	ret = fimc_md_register_platform_entities(fmd);
 	if (ret) {
 		mutex_unlock(&fmd->media_dev.graph_mutex);
 		goto err_clk;
@@ -1426,6 +1437,8 @@ err_md:
 	media_device_unregister(&fmd->media_dev);
 err_v4l2_dev:
 	v4l2_device_unregister(&fmd->v4l2_dev);
+	if (create_children)
+		of_device_destroy_children(dev);
 	return ret;
 }
 
-- 
1.7.9.5

