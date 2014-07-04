Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbaGDPI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 11:08:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38598 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbaGDPIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 11:08:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <lee.jones@linaro.org>,
        <sergei.shtylyov@cogentembedded.com>,
        <antoine.tenart@free-electrons.com>
CC: <kgene.kim@samsung.com>, <maxime.ripard@free-electrons.com>
Subject: [RFC PATCH 2/2] phy: core: the node pointer of PHY need not be the same as that of PHY provider
Date: Fri, 4 Jul 2014 20:37:54 +0530
Message-ID: <1404486474-28312-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404486474-28312-1-git-send-email-kishon@ti.com>
References: <1404486474-28312-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of multi-phy PHY providers, each PHY should be modeled as a sub
node of the PHY provider. Then each PHY will have a different node pointer
(node pointer of sub node) than that of PHY provider. Added this provision
in the PHY core.
Also fixed all drivers to use the updated API.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/phy.txt               |   10 ++++++----
 drivers/phy/phy-bcm-kona-usb2.c     |    2 +-
 drivers/phy/phy-core.c              |   25 ++++++++++++++++++-------
 drivers/phy/phy-exynos-dp-video.c   |    2 +-
 drivers/phy/phy-exynos-mipi-video.c |    2 +-
 drivers/phy/phy-exynos5-usbdrd.c    |    3 ++-
 drivers/phy/phy-exynos5250-sata.c   |    2 +-
 drivers/phy/phy-mvebu-sata.c        |    2 +-
 drivers/phy/phy-omap-usb2.c         |    2 +-
 drivers/phy/phy-samsung-usb2.c      |    3 ++-
 drivers/phy/phy-sun4i-usb.c         |    2 +-
 drivers/phy/phy-ti-pipe3.c          |    2 +-
 drivers/phy/phy-twl4030-usb.c       |    2 +-
 drivers/phy/phy-xgene.c             |    2 +-
 include/linux/phy/phy.h             |   15 ++++++++++-----
 15 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/Documentation/phy.txt b/Documentation/phy.txt
index ebff6ee..c6594af 100644
--- a/Documentation/phy.txt
+++ b/Documentation/phy.txt
@@ -53,10 +53,12 @@ unregister the PHY.
 The PHY driver should create the PHY in order for other peripheral controllers
 to make use of it. The PHY framework provides 2 APIs to create the PHY.
 
-struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
-        struct phy_init_data *init_data);
-struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops,
-	struct phy_init_data *init_data);
+struct phy *phy_create(struct device *dev, struct device_node *node,
+		       const struct phy_ops *ops,
+		       struct phy_init_data *init_data);
+struct phy *devm_phy_create(struct device *dev, struct device_node *node,
+			    const struct phy_ops *ops,
+			    struct phy_init_data *init_data);
 
 The PHY drivers can use one of the above 2 APIs to create the PHY by passing
 the device pointer, phy ops and init_data.
diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
index e94f5a6..894fe74 100644
--- a/drivers/phy/phy-bcm-kona-usb2.c
+++ b/drivers/phy/phy-bcm-kona-usb2.c
@@ -117,7 +117,7 @@ static int bcm_kona_usb2_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, phy);
 
-	gphy = devm_phy_create(dev, &ops, NULL);
+	gphy = devm_phy_create(dev, NULL, &ops, NULL);
 	if (IS_ERR(gphy))
 		return PTR_ERR(gphy);
 
diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index a4a1f783..9ad6691 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -406,13 +406,20 @@ struct phy *of_phy_simple_xlate(struct device *dev, struct of_phandle_args
 	struct phy *phy;
 	struct class_dev_iter iter;
 	struct device_node *node = dev->of_node;
+	struct device_node *child;
 
 	class_dev_iter_init(&iter, phy_class, NULL, NULL);
 	while ((dev = class_dev_iter_next(&iter))) {
 		phy = to_phy(dev);
-		if (node != phy->dev.of_node)
+		if (node != phy->dev.of_node) {
+			for_each_child_of_node(node, child) {
+				if (child == phy->dev.of_node)
+					goto phy_found;
+			}
 			continue;
+		}
 
+phy_found:
 		class_dev_iter_exit(&iter);
 		return phy;
 	}
@@ -570,13 +577,15 @@ EXPORT_SYMBOL_GPL(devm_of_phy_get);
 /**
  * phy_create() - create a new phy
  * @dev: device that is creating the new phy
+ * @node: device node of the phy
  * @ops: function pointers for performing phy operations
  * @init_data: contains the list of PHY consumers or NULL
  *
  * Called to create a phy using phy framework.
  */
-struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
-	struct phy_init_data *init_data)
+struct phy *phy_create(struct device *dev, struct device_node *node,
+		       const struct phy_ops *ops,
+		       struct phy_init_data *init_data)
 {
 	int ret;
 	int id;
@@ -601,7 +610,7 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 
 	phy->dev.class = phy_class;
 	phy->dev.parent = dev;
-	phy->dev.of_node = dev->of_node;
+	phy->dev.of_node = node?node:dev->of_node;
 	phy->id = id;
 	phy->ops = ops;
 	phy->init_data = init_data;
@@ -633,6 +642,7 @@ EXPORT_SYMBOL_GPL(phy_create);
 /**
  * devm_phy_create() - create a new phy
  * @dev: device that is creating the new phy
+ * @node: device node of the phy
  * @ops: function pointers for performing phy operations
  * @init_data: contains the list of PHY consumers or NULL
  *
@@ -641,8 +651,9 @@ EXPORT_SYMBOL_GPL(phy_create);
  * On driver detach, release function is invoked on the devres data,
  * then, devres data is freed.
  */
-struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops,
-	struct phy_init_data *init_data)
+struct phy *devm_phy_create(struct device *dev, struct device_node *node,
+			    const struct phy_ops *ops,
+			    struct phy_init_data *init_data)
 {
 	struct phy **ptr, *phy;
 
@@ -650,7 +661,7 @@ struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops,
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	phy = phy_create(dev, ops, init_data);
+	phy = phy_create(dev, node, ops, init_data);
 	if (!IS_ERR(phy)) {
 		*ptr = phy;
 		devres_add(dev, ptr);
diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
index 0786fef..94fc0d1 100644
--- a/drivers/phy/phy-exynos-dp-video.c
+++ b/drivers/phy/phy-exynos-dp-video.c
@@ -76,7 +76,7 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(state->regs))
 		return PTR_ERR(state->regs);
 
-	phy = devm_phy_create(dev, &exynos_dp_video_phy_ops, NULL);
+	phy = devm_phy_create(dev, NULL, &exynos_dp_video_phy_ops, NULL);
 	if (IS_ERR(phy)) {
 		dev_err(dev, "failed to create Display Port PHY\n");
 		return PTR_ERR(phy);
diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index ff02668..e29a100 100644
--- a/drivers/phy/phy-exynos-mipi-video.c
+++ b/drivers/phy/phy-exynos-mipi-video.c
@@ -135,7 +135,7 @@ static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
 	spin_lock_init(&state->slock);
 
 	for (i = 0; i < EXYNOS_MIPI_PHYS_NUM; i++) {
-		struct phy *phy = devm_phy_create(dev,
+		struct phy *phy = devm_phy_create(dev, NULL,
 					&exynos_mipi_video_phy_ops, NULL);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "failed to create PHY %d\n", i);
diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index 76d862b..950532f 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -635,7 +635,8 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 	dev_vdbg(dev, "Creating usbdrd_phy phy\n");
 
 	for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
-		struct phy *phy = devm_phy_create(dev, &exynos5_usbdrd_phy_ops,
+		struct phy *phy = devm_phy_create(dev, NULL,
+						  &exynos5_usbdrd_phy_ops,
 						  NULL);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "Failed to create usbdrd_phy phy\n");
diff --git a/drivers/phy/phy-exynos5250-sata.c b/drivers/phy/phy-exynos5250-sata.c
index 0568945..19a679a 100644
--- a/drivers/phy/phy-exynos5250-sata.c
+++ b/drivers/phy/phy-exynos5250-sata.c
@@ -210,7 +210,7 @@ static int exynos_sata_phy_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	sata_phy->phy = devm_phy_create(dev, &exynos_sata_phy_ops, NULL);
+	sata_phy->phy = devm_phy_create(dev, NULL, &exynos_sata_phy_ops, NULL);
 	if (IS_ERR(sata_phy->phy)) {
 		clk_disable_unprepare(sata_phy->phyclk);
 		dev_err(dev, "failed to create PHY\n");
diff --git a/drivers/phy/phy-mvebu-sata.c b/drivers/phy/phy-mvebu-sata.c
index d70ecd6..cc3c0e1 100644
--- a/drivers/phy/phy-mvebu-sata.c
+++ b/drivers/phy/phy-mvebu-sata.c
@@ -99,7 +99,7 @@ static int phy_mvebu_sata_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
 
-	phy = devm_phy_create(&pdev->dev, &phy_mvebu_sata_ops, NULL);
+	phy = devm_phy_create(&pdev->dev, NULL, &phy_mvebu_sata_ops, NULL);
 	if (IS_ERR(phy))
 		return PTR_ERR(phy);
 
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 7007c11..fb17533 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -264,7 +264,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, phy);
 	pm_runtime_enable(phy->dev);
 
-	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
+	generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
 	if (IS_ERR(generic_phy))
 		return PTR_ERR(generic_phy);
 
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 8a8c6bc..8c75add 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -189,7 +189,8 @@ static int samsung_usb2_phy_probe(struct platform_device *pdev)
 		struct samsung_usb2_phy_instance *p = &drv->instances[i];
 
 		dev_dbg(dev, "Creating phy \"%s\"\n", label);
-		p->phy = devm_phy_create(dev, &samsung_usb2_phy_ops, NULL);
+		p->phy = devm_phy_create(dev, NULL, &samsung_usb2_phy_ops,
+					 NULL);
 		if (IS_ERR(p->phy)) {
 			dev_err(drv->dev, "Failed to create usb2_phy \"%s\"\n",
 				label);
diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index 115d8d5..60e11ff 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -294,7 +294,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 				return PTR_ERR(phy->pmu);
 		}
 
-		phy->phy = devm_phy_create(dev, &sun4i_usb_phy_ops, NULL);
+		phy->phy = devm_phy_create(dev, NULL, &sun4i_usb_phy_ops, NULL);
 		if (IS_ERR(phy->phy)) {
 			dev_err(dev, "failed to create PHY %d\n", i);
 			return PTR_ERR(phy->phy);
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 93bcd67..b964aa9 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -400,7 +400,7 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, phy);
 	pm_runtime_enable(phy->dev);
 
-	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
+	generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
 	if (IS_ERR(generic_phy))
 		return PTR_ERR(generic_phy);
 
diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 2e0e9b3..e1a6623 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -695,7 +695,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	otg->set_host		= twl4030_set_host;
 	otg->set_peripheral	= twl4030_set_peripheral;
 
-	phy = devm_phy_create(twl->dev, &ops, init_data);
+	phy = devm_phy_create(twl->dev, NULL, &ops, init_data);
 	if (IS_ERR(phy)) {
 		dev_dbg(&pdev->dev, "Failed to create PHY\n");
 		return PTR_ERR(phy);
diff --git a/drivers/phy/phy-xgene.c b/drivers/phy/phy-xgene.c
index 4aa1ccd..db809b9 100644
--- a/drivers/phy/phy-xgene.c
+++ b/drivers/phy/phy-xgene.c
@@ -1707,7 +1707,7 @@ static int xgene_phy_probe(struct platform_device *pdev)
 	ctx->dev = &pdev->dev;
 	platform_set_drvdata(pdev, ctx);
 
-	ctx->phy = devm_phy_create(ctx->dev, &xgene_phy_ops, NULL);
+	ctx->phy = devm_phy_create(ctx->dev, NULL, &xgene_phy_ops, NULL);
 	if (IS_ERR(ctx->phy)) {
 		dev_dbg(&pdev->dev, "Failed to create PHY\n");
 		rc = PTR_ERR(ctx->phy);
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 2760744..cfb878f 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -156,9 +156,10 @@ void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_get(struct device_node *np, const char *con_id);
 struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args);
-struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
-	struct phy_init_data *init_data);
-struct phy *devm_phy_create(struct device *dev,
+struct phy *phy_create(struct device *dev, struct device_node *node,
+		       const struct phy_ops *ops,
+		       struct phy_init_data *init_data);
+struct phy *devm_phy_create(struct device *dev, struct device_node *node,
 	const struct phy_ops *ops, struct phy_init_data *init_data);
 void phy_destroy(struct phy *phy);
 void devm_phy_destroy(struct device *dev, struct phy *phy);
@@ -297,13 +298,17 @@ static inline struct phy *of_phy_simple_xlate(struct device *dev,
 }
 
 static inline struct phy *phy_create(struct device *dev,
-	const struct phy_ops *ops, struct phy_init_data *init_data)
+				     struct device_node *node,
+				     const struct phy_ops *ops,
+				     struct phy_init_data *init_data)
 {
 	return ERR_PTR(-ENOSYS);
 }
 
 static inline struct phy *devm_phy_create(struct device *dev,
-	const struct phy_ops *ops, struct phy_init_data *init_data)
+					  struct device_node *node,
+					  const struct phy_ops *ops,
+					  struct phy_init_data *init_data)
 {
 	return ERR_PTR(-ENOSYS);
 }
-- 
1.7.9.5

