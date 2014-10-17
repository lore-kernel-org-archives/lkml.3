Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaJQOjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:39:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:59879 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaJQOj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:39:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,739,1406617200"; 
   d="scan'208";a="590940656"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, andrew.kim@intel.com
Subject: [PATCHv4 4/6] phy: remove the old lookup method
Date: Fri, 17 Oct 2014 17:39:14 +0300
Message-Id: <1413556756-5050-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The users of the old method are now converted to the new one.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/phy-bcm-kona-usb2.c      |  2 +-
 drivers/phy/phy-berlin-sata.c        |  2 +-
 drivers/phy/phy-core.c               | 45 +++---------------------------------
 drivers/phy/phy-exynos-dp-video.c    |  2 +-
 drivers/phy/phy-exynos-mipi-video.c  |  2 +-
 drivers/phy/phy-exynos5-usbdrd.c     |  3 +--
 drivers/phy/phy-exynos5250-sata.c    |  2 +-
 drivers/phy/phy-hix5hd2-sata.c       |  2 +-
 drivers/phy/phy-miphy365x.c          |  2 +-
 drivers/phy/phy-mvebu-sata.c         |  2 +-
 drivers/phy/phy-omap-usb2.c          |  2 +-
 drivers/phy/phy-qcom-apq8064-sata.c  |  3 +--
 drivers/phy/phy-qcom-ipq806x-sata.c  |  3 +--
 drivers/phy/phy-rcar-gen2.c          |  2 +-
 drivers/phy/phy-samsung-usb2.c       |  3 +--
 drivers/phy/phy-spear1310-miphy.c    |  2 +-
 drivers/phy/phy-spear1340-miphy.c    |  2 +-
 drivers/phy/phy-stih407-usb.c        |  2 +-
 drivers/phy/phy-stih41x-usb.c        |  2 +-
 drivers/phy/phy-sun4i-usb.c          |  2 +-
 drivers/phy/phy-ti-pipe3.c           |  2 +-
 drivers/phy/phy-twl4030-usb.c        |  4 +---
 drivers/phy/phy-xgene.c              |  2 +-
 drivers/pinctrl/pinctrl-tegra-xusb.c |  4 ++--
 include/linux/phy/phy.h              | 38 ++++--------------------------
 25 files changed, 31 insertions(+), 106 deletions(-)

diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
index c1e0ca3..ef2dc1a 100644
--- a/drivers/phy/phy-bcm-kona-usb2.c
+++ b/drivers/phy/phy-bcm-kona-usb2.c
@@ -117,7 +117,7 @@ static int bcm_kona_usb2_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, phy);
 
-	gphy = devm_phy_create(dev, NULL, &ops, NULL);
+	gphy = devm_phy_create(dev, NULL, &ops);
 	if (IS_ERR(gphy))
 		return PTR_ERR(gphy);
 
diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
index 69ced52..99bbf91 100644
--- a/drivers/phy/phy-berlin-sata.c
+++ b/drivers/phy/phy-berlin-sata.c
@@ -239,7 +239,7 @@ static int phy_berlin_sata_probe(struct platform_device *pdev)
 		if (!phy_desc)
 			return -ENOMEM;
 
-		phy = devm_phy_create(dev, NULL, &phy_berlin_sata_ops, NULL);
+		phy = devm_phy_create(dev, NULL, &phy_berlin_sata_ops);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "failed to create PHY %d\n", phy_id);
 			return PTR_ERR(phy);
diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index c8d0f66..0b279d3 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -55,36 +55,6 @@ static int devm_phy_match(struct device *dev, void *res, void *match_data)
 	return res == match_data;
 }
 
-static struct phy *phy_lookup(struct device *device, const char *port)
-{
-	unsigned int count;
-	struct phy *phy;
-	struct device *dev;
-	struct phy_consumer *consumers;
-	struct class_dev_iter iter;
-
-	class_dev_iter_init(&iter, phy_class, NULL, NULL);
-	while ((dev = class_dev_iter_next(&iter))) {
-		phy = to_phy(dev);
-
-		if (!phy->init_data)
-			continue;
-		count = phy->init_data->num_consumers;
-		consumers = phy->init_data->consumers;
-		while (count--) {
-			if (!strcmp(consumers->dev_name, dev_name(device)) &&
-					!strcmp(consumers->port, port)) {
-				class_dev_iter_exit(&iter);
-				return phy;
-			}
-			consumers++;
-		}
-	}
-
-	class_dev_iter_exit(&iter);
-	return ERR_PTR(-ENODEV);
-}
-
 /**
  * phy_register_lookup() - register PHY/device association
  * @pl: association to register
@@ -210,10 +180,6 @@ static struct phy *phy_find(struct device *dev, const char *con_id)
 		}
 		class_dev_iter_exit(&iter);
 	}
-
-	/* fall-back to the old lookup method for now */
-	if (IS_ERR(phy))
-		phy = phy_lookup(dev, con_id);
 	return phy;
 }
 
@@ -721,13 +687,11 @@ EXPORT_SYMBOL_GPL(devm_of_phy_get);
  * @dev: device that is creating the new phy
  * @node: device node of the phy
  * @ops: function pointers for performing phy operations
- * @init_data: contains the list of PHY consumers or NULL
  *
  * Called to create a phy using phy framework.
  */
 struct phy *phy_create(struct device *dev, struct device_node *node,
-		       const struct phy_ops *ops,
-		       struct phy_init_data *init_data)
+		       const struct phy_ops *ops)
 {
 	int ret;
 	int id;
@@ -765,7 +729,6 @@ struct phy *phy_create(struct device *dev, struct device_node *node,
 	phy->dev.of_node = node ?: dev->of_node;
 	phy->id = id;
 	phy->ops = ops;
-	phy->init_data = init_data;
 
 	ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
 	if (ret)
@@ -800,7 +763,6 @@ EXPORT_SYMBOL_GPL(phy_create);
  * @dev: device that is creating the new phy
  * @node: device node of the phy
  * @ops: function pointers for performing phy operations
- * @init_data: contains the list of PHY consumers or NULL
  *
  * Creates a new PHY device adding it to the PHY class.
  * While at that, it also associates the device with the phy using devres.
@@ -808,8 +770,7 @@ EXPORT_SYMBOL_GPL(phy_create);
  * then, devres data is freed.
  */
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
-			    const struct phy_ops *ops,
-			    struct phy_init_data *init_data)
+			    const struct phy_ops *ops)
 {
 	struct phy **ptr, *phy;
 
@@ -817,7 +778,7 @@ struct phy *devm_phy_create(struct device *dev, struct device_node *node,
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	phy = phy_create(dev, node, ops, init_data);
+	phy = phy_create(dev, node, ops);
 	if (!IS_ERR(phy)) {
 		*ptr = phy;
 		devres_add(dev, ptr);
diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
index 84f49e5..f86cbe6 100644
--- a/drivers/phy/phy-exynos-dp-video.c
+++ b/drivers/phy/phy-exynos-dp-video.c
@@ -112,7 +112,7 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
 	match = of_match_node(exynos_dp_video_phy_of_match, dev->of_node);
 	state->drvdata = match->data;
 
-	phy = devm_phy_create(dev, NULL, &exynos_dp_video_phy_ops, NULL);
+	phy = devm_phy_create(dev, NULL, &exynos_dp_video_phy_ops);
 	if (IS_ERR(phy)) {
 		dev_err(dev, "failed to create Display Port PHY\n");
 		return PTR_ERR(phy);
diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index 6a9bef1..943e0f8 100644
--- a/drivers/phy/phy-exynos-mipi-video.c
+++ b/drivers/phy/phy-exynos-mipi-video.c
@@ -137,7 +137,7 @@ static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
 
 	for (i = 0; i < EXYNOS_MIPI_PHYS_NUM; i++) {
 		struct phy *phy = devm_phy_create(dev, NULL,
-					&exynos_mipi_video_phy_ops, NULL);
+						  &exynos_mipi_video_phy_ops);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "failed to create PHY %d\n", i);
 			return PTR_ERR(phy);
diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index f756aca..b3ca3bc 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -637,8 +637,7 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 
 	for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
 		struct phy *phy = devm_phy_create(dev, NULL,
-						  &exynos5_usbdrd_phy_ops,
-						  NULL);
+						  &exynos5_usbdrd_phy_ops);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "Failed to create usbdrd_phy phy\n");
 			return PTR_ERR(phy);
diff --git a/drivers/phy/phy-exynos5250-sata.c b/drivers/phy/phy-exynos5250-sata.c
index 54cf4ae..bc858cc 100644
--- a/drivers/phy/phy-exynos5250-sata.c
+++ b/drivers/phy/phy-exynos5250-sata.c
@@ -210,7 +210,7 @@ static int exynos_sata_phy_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	sata_phy->phy = devm_phy_create(dev, NULL, &exynos_sata_phy_ops, NULL);
+	sata_phy->phy = devm_phy_create(dev, NULL, &exynos_sata_phy_ops);
 	if (IS_ERR(sata_phy->phy)) {
 		clk_disable_unprepare(sata_phy->phyclk);
 		dev_err(dev, "failed to create PHY\n");
diff --git a/drivers/phy/phy-hix5hd2-sata.c b/drivers/phy/phy-hix5hd2-sata.c
index d5d9780..a80ff9d 100644
--- a/drivers/phy/phy-hix5hd2-sata.c
+++ b/drivers/phy/phy-hix5hd2-sata.c
@@ -156,7 +156,7 @@ static int hix5hd2_sata_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->peri_ctrl))
 		priv->peri_ctrl = NULL;
 
-	phy = devm_phy_create(dev, NULL, &hix5hd2_sata_phy_ops, NULL);
+	phy = devm_phy_create(dev, NULL, &hix5hd2_sata_phy_ops);
 	if (IS_ERR(phy)) {
 		dev_err(dev, "failed to create PHY\n");
 		return PTR_ERR(phy);
diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
index 801afaf..239930e 100644
--- a/drivers/phy/phy-miphy365x.c
+++ b/drivers/phy/phy-miphy365x.c
@@ -593,7 +593,7 @@ static int miphy365x_probe(struct platform_device *pdev)
 
 		miphy_dev->phys[port] = miphy_phy;
 
-		phy = devm_phy_create(&pdev->dev, child, &miphy365x_ops, NULL);
+		phy = devm_phy_create(&pdev->dev, child, &miphy365x_ops);
 		if (IS_ERR(phy)) {
 			dev_err(&pdev->dev, "failed to create PHY\n");
 			return PTR_ERR(phy);
diff --git a/drivers/phy/phy-mvebu-sata.c b/drivers/phy/phy-mvebu-sata.c
index d395558..03b94f9 100644
--- a/drivers/phy/phy-mvebu-sata.c
+++ b/drivers/phy/phy-mvebu-sata.c
@@ -101,7 +101,7 @@ static int phy_mvebu_sata_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
 
-	phy = devm_phy_create(&pdev->dev, NULL, &phy_mvebu_sata_ops, NULL);
+	phy = devm_phy_create(&pdev->dev, NULL, &phy_mvebu_sata_ops);
 	if (IS_ERR(phy))
 		return PTR_ERR(phy);
 
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 8c84298..3fcc420 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -259,7 +259,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, phy);
 
-	generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
+	generic_phy = devm_phy_create(phy->dev, NULL, &ops);
 	if (IS_ERR(generic_phy))
 		return PTR_ERR(generic_phy);
 
diff --git a/drivers/phy/phy-qcom-apq8064-sata.c b/drivers/phy/phy-qcom-apq8064-sata.c
index 7b3ddfb..4b243f7 100644
--- a/drivers/phy/phy-qcom-apq8064-sata.c
+++ b/drivers/phy/phy-qcom-apq8064-sata.c
@@ -228,8 +228,7 @@ static int qcom_apq8064_sata_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(phy->mmio))
 		return PTR_ERR(phy->mmio);
 
-	generic_phy = devm_phy_create(dev, NULL, &qcom_apq8064_sata_phy_ops,
-				      NULL);
+	generic_phy = devm_phy_create(dev, NULL, &qcom_apq8064_sata_phy_ops);
 	if (IS_ERR(generic_phy)) {
 		dev_err(dev, "%s: failed to create phy\n", __func__);
 		return PTR_ERR(generic_phy);
diff --git a/drivers/phy/phy-qcom-ipq806x-sata.c b/drivers/phy/phy-qcom-ipq806x-sata.c
index 759b0bf..6f2fe26 100644
--- a/drivers/phy/phy-qcom-ipq806x-sata.c
+++ b/drivers/phy/phy-qcom-ipq806x-sata.c
@@ -150,8 +150,7 @@ static int qcom_ipq806x_sata_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(phy->mmio))
 		return PTR_ERR(phy->mmio);
 
-	generic_phy = devm_phy_create(dev, NULL, &qcom_ipq806x_sata_phy_ops,
-				      NULL);
+	generic_phy = devm_phy_create(dev, NULL, &qcom_ipq806x_sata_phy_ops);
 	if (IS_ERR(generic_phy)) {
 		dev_err(dev, "%s: failed to create phy\n", __func__);
 		return PTR_ERR(generic_phy);
diff --git a/drivers/phy/phy-rcar-gen2.c b/drivers/phy/phy-rcar-gen2.c
index 2793af1..778276a 100644
--- a/drivers/phy/phy-rcar-gen2.c
+++ b/drivers/phy/phy-rcar-gen2.c
@@ -304,7 +304,7 @@ static int rcar_gen2_phy_probe(struct platform_device *pdev)
 			phy->select_value = select_value[channel_num][n];
 
 			phy->phy = devm_phy_create(dev, NULL,
-						   &rcar_gen2_phy_ops, NULL);
+						   &rcar_gen2_phy_ops);
 			if (IS_ERR(phy->phy)) {
 				dev_err(dev, "Failed to create PHY\n");
 				return PTR_ERR(phy->phy);
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 908949d..4a12f66 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -202,8 +202,7 @@ static int samsung_usb2_phy_probe(struct platform_device *pdev)
 		struct samsung_usb2_phy_instance *p = &drv->instances[i];
 
 		dev_dbg(dev, "Creating phy \"%s\"\n", label);
-		p->phy = devm_phy_create(dev, NULL, &samsung_usb2_phy_ops,
-					 NULL);
+		p->phy = devm_phy_create(dev, NULL, &samsung_usb2_phy_ops);
 		if (IS_ERR(p->phy)) {
 			dev_err(drv->dev, "Failed to create usb2_phy \"%s\"\n",
 				label);
diff --git a/drivers/phy/phy-spear1310-miphy.c b/drivers/phy/phy-spear1310-miphy.c
index 5f4c586..9f47fae 100644
--- a/drivers/phy/phy-spear1310-miphy.c
+++ b/drivers/phy/phy-spear1310-miphy.c
@@ -227,7 +227,7 @@ static int spear1310_miphy_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	priv->phy = devm_phy_create(dev, NULL, &spear1310_miphy_ops, NULL);
+	priv->phy = devm_phy_create(dev, NULL, &spear1310_miphy_ops);
 	if (IS_ERR(priv->phy)) {
 		dev_err(dev, "failed to create SATA PCIe PHY\n");
 		return PTR_ERR(priv->phy);
diff --git a/drivers/phy/phy-spear1340-miphy.c b/drivers/phy/phy-spear1340-miphy.c
index 1ecd094..e42bc20 100644
--- a/drivers/phy/phy-spear1340-miphy.c
+++ b/drivers/phy/phy-spear1340-miphy.c
@@ -259,7 +259,7 @@ static int spear1340_miphy_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->misc);
 	}
 
-	priv->phy = devm_phy_create(dev, NULL, &spear1340_miphy_ops, NULL);
+	priv->phy = devm_phy_create(dev, NULL, &spear1340_miphy_ops);
 	if (IS_ERR(priv->phy)) {
 		dev_err(dev, "failed to create SATA PCIe PHY\n");
 		return PTR_ERR(priv->phy);
diff --git a/drivers/phy/phy-stih407-usb.c b/drivers/phy/phy-stih407-usb.c
index 42428d4..74f0fab 100644
--- a/drivers/phy/phy-stih407-usb.c
+++ b/drivers/phy/phy-stih407-usb.c
@@ -137,7 +137,7 @@ static int stih407_usb2_picophy_probe(struct platform_device *pdev)
 	}
 	phy_dev->param = res->start;
 
-	phy = devm_phy_create(dev, NULL, &stih407_usb2_picophy_data, NULL);
+	phy = devm_phy_create(dev, NULL, &stih407_usb2_picophy_data);
 	if (IS_ERR(phy)) {
 		dev_err(dev, "failed to create Display Port PHY\n");
 		return PTR_ERR(phy);
diff --git a/drivers/phy/phy-stih41x-usb.c b/drivers/phy/phy-stih41x-usb.c
index 9f16cb8..4ab581e 100644
--- a/drivers/phy/phy-stih41x-usb.c
+++ b/drivers/phy/phy-stih41x-usb.c
@@ -148,7 +148,7 @@ static int stih41x_usb_phy_probe(struct platform_device *pdev)
 		return PTR_ERR(phy_dev->clk);
 	}
 
-	phy = devm_phy_create(dev, NULL, &stih41x_usb_phy_ops, NULL);
+	phy = devm_phy_create(dev, NULL, &stih41x_usb_phy_ops);
 
 	if (IS_ERR(phy)) {
 		dev_err(dev, "failed to create phy\n");
diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index 0baf5ef..28df50d 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -295,7 +295,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 				return PTR_ERR(phy->pmu);
 		}
 
-		phy->phy = devm_phy_create(dev, NULL, &sun4i_usb_phy_ops, NULL);
+		phy->phy = devm_phy_create(dev, NULL, &sun4i_usb_phy_ops);
 		if (IS_ERR(phy->phy)) {
 			dev_err(dev, "failed to create PHY %d\n", i);
 			return PTR_ERR(phy->phy);
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index ab1e22d..c297b7a 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -399,7 +399,7 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, phy);
 	pm_runtime_enable(phy->dev);
 
-	generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
+	generic_phy = devm_phy_create(phy->dev, NULL, &ops);
 	if (IS_ERR(generic_phy))
 		return PTR_ERR(generic_phy);
 
diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 7b04bef..d658d8c 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -644,7 +644,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	struct usb_otg		*otg;
 	struct device_node	*np = pdev->dev.of_node;
 	struct phy_provider	*phy_provider;
-	struct phy_init_data	*init_data = NULL;
 
 	twl = devm_kzalloc(&pdev->dev, sizeof(*twl), GFP_KERNEL);
 	if (!twl)
@@ -655,7 +654,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 				(enum twl4030_usb_mode *)&twl->usb_mode);
 	else if (pdata) {
 		twl->usb_mode = pdata->usb_mode;
-		init_data = pdata->init_data;
 	} else {
 		dev_err(&pdev->dev, "twl4030 initialized without pdata\n");
 		return -EINVAL;
@@ -680,7 +678,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	otg->set_host		= twl4030_set_host;
 	otg->set_peripheral	= twl4030_set_peripheral;
 
-	phy = devm_phy_create(twl->dev, NULL, &ops, init_data);
+	phy = devm_phy_create(twl->dev, NULL, &ops);
 	if (IS_ERR(phy)) {
 		dev_dbg(&pdev->dev, "Failed to create PHY\n");
 		return PTR_ERR(phy);
diff --git a/drivers/phy/phy-xgene.c b/drivers/phy/phy-xgene.c
index f8a51b1..29214a3 100644
--- a/drivers/phy/phy-xgene.c
+++ b/drivers/phy/phy-xgene.c
@@ -1707,7 +1707,7 @@ static int xgene_phy_probe(struct platform_device *pdev)
 	ctx->dev = &pdev->dev;
 	platform_set_drvdata(pdev, ctx);
 
-	ctx->phy = devm_phy_create(ctx->dev, NULL, &xgene_phy_ops, NULL);
+	ctx->phy = devm_phy_create(ctx->dev, NULL, &xgene_phy_ops);
 	if (IS_ERR(ctx->phy)) {
 		dev_dbg(&pdev->dev, "Failed to create PHY\n");
 		rc = PTR_ERR(ctx->phy);
diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl/pinctrl-tegra-xusb.c
index 1631ec9..a84299b 100644
--- a/drivers/pinctrl/pinctrl-tegra-xusb.c
+++ b/drivers/pinctrl/pinctrl-tegra-xusb.c
@@ -910,7 +910,7 @@ static int tegra_xusb_padctl_probe(struct platform_device *pdev)
 		goto reset;
 	}
 
-	phy = devm_phy_create(&pdev->dev, NULL, &pcie_phy_ops, NULL);
+	phy = devm_phy_create(&pdev->dev, NULL, &pcie_phy_ops);
 	if (IS_ERR(phy)) {
 		err = PTR_ERR(phy);
 		goto unregister;
@@ -919,7 +919,7 @@ static int tegra_xusb_padctl_probe(struct platform_device *pdev)
 	padctl->phys[TEGRA_XUSB_PADCTL_PCIE] = phy;
 	phy_set_drvdata(phy, padctl);
 
-	phy = devm_phy_create(&pdev->dev, NULL, &sata_phy_ops, NULL);
+	phy = devm_phy_create(&pdev->dev, NULL, &sata_phy_ops);
 	if (IS_ERR(phy)) {
 		err = PTR_ERR(phy);
 		goto unregister;
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 2696b95..d983051 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -61,7 +61,6 @@ struct phy {
 	struct device		dev;
 	int			id;
 	const struct phy_ops	*ops;
-	struct phy_init_data	*init_data;
 	struct mutex		mutex;
 	int			init_count;
 	int			power_count;
@@ -84,32 +83,6 @@ struct phy_provider {
 		struct of_phandle_args *args);
 };
 
-/**
- * struct phy_consumer - represents the phy consumer
- * @dev_name: the device name of the controller that will use this PHY device
- * @port: name given to the consumer port
- */
-struct phy_consumer {
-	const char *dev_name;
-	const char *port;
-};
-
-/**
- * struct phy_init_data - contains the list of PHY consumers
- * @num_consumers: number of consumers for this PHY device
- * @consumers: list of PHY consumers
- */
-struct phy_init_data {
-	unsigned int num_consumers;
-	struct phy_consumer *consumers;
-};
-
-#define PHY_CONSUMER(_dev_name, _port)				\
-{								\
-	.dev_name	= _dev_name,				\
-	.port		= _port,				\
-}
-
 struct phy_lookup {
 	struct list_head node;
 	const char *phy_name;
@@ -173,10 +146,9 @@ struct phy *of_phy_get(struct device_node *np, const char *con_id);
 struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args);
 struct phy *phy_create(struct device *dev, struct device_node *node,
-		       const struct phy_ops *ops,
-		       struct phy_init_data *init_data);
+		       const struct phy_ops *ops);
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
-	const struct phy_ops *ops, struct phy_init_data *init_data);
+			    const struct phy_ops *ops);
 void phy_destroy(struct phy *phy);
 void devm_phy_destroy(struct device *dev, struct phy *phy);
 struct phy_provider *__of_phy_provider_register(struct device *dev,
@@ -319,16 +291,14 @@ static inline struct phy *of_phy_simple_xlate(struct device *dev,
 
 static inline struct phy *phy_create(struct device *dev,
 				     struct device_node *node,
-				     const struct phy_ops *ops,
-				     struct phy_init_data *init_data)
+				     const struct phy_ops *ops)
 {
 	return ERR_PTR(-ENOSYS);
 }
 
 static inline struct phy *devm_phy_create(struct device *dev,
 					  struct device_node *node,
-					  const struct phy_ops *ops,
-					  struct phy_init_data *init_data)
+					  const struct phy_ops *ops)
 {
 	return ERR_PTR(-ENOSYS);
 }
-- 
2.1.1

