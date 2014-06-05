Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaFEMyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:54:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:20239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaFEMx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:53:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,981,1392192000"; 
   d="scan'208";a="441253833"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCHv2 4/6] phy: remove the old lookup method
Date: Thu,  5 Jun 2014 15:52:56 +0300
Message-Id: <1401972778-5880-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The users of the old method are now converted to the new one.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/phy/phy-bcm-kona-usb2.c     |  2 +-
 drivers/phy/phy-core.c              | 45 +++----------------------------------
 drivers/phy/phy-exynos-dp-video.c   |  2 +-
 drivers/phy/phy-exynos-mipi-video.c |  2 +-
 drivers/phy/phy-exynos5-usbdrd.c    |  3 +--
 drivers/phy/phy-exynos5250-sata.c   |  2 +-
 drivers/phy/phy-mvebu-sata.c        |  2 +-
 drivers/phy/phy-omap-usb2.c         |  2 +-
 drivers/phy/phy-samsung-usb2.c      |  2 +-
 drivers/phy/phy-sun4i-usb.c         |  2 +-
 drivers/phy/phy-ti-pipe3.c          |  2 +-
 drivers/phy/phy-twl4030-usb.c       |  4 +---
 drivers/phy/phy-xgene.c             |  2 +-
 include/linux/phy/phy.h             | 37 ++++--------------------------
 14 files changed, 19 insertions(+), 90 deletions(-)

diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
index e94f5a6..47d810f 100644
--- a/drivers/phy/phy-bcm-kona-usb2.c
+++ b/drivers/phy/phy-bcm-kona-usb2.c
@@ -117,7 +117,7 @@ static int bcm_kona_usb2_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, phy);
 
-	gphy = devm_phy_create(dev, &ops, NULL);
+	gphy = devm_phy_create(dev, &ops);
 	if (IS_ERR(gphy))
 		return PTR_ERR(gphy);
 
diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 38034fd..74d4346 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -54,36 +54,6 @@ static int devm_phy_match(struct device *dev, void *res, void *match_data)
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
@@ -209,10 +179,6 @@ static struct phy *phy_find(struct device *dev, const char *con_id)
 		}
 		class_dev_iter_exit(&iter);
 	}
-
-	/* fall-back to the old lookup method for now */
-	if (IS_ERR(phy))
-		phy = phy_lookup(dev, con_id);
 	return phy;
 }
 
@@ -696,12 +662,10 @@ EXPORT_SYMBOL_GPL(devm_of_phy_get);
  * phy_create() - create a new phy
  * @dev: device that is creating the new phy
  * @ops: function pointers for performing phy operations
- * @init_data: contains the list of PHY consumers or NULL
  *
  * Called to create a phy using phy framework.
  */
-struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
-	struct phy_init_data *init_data)
+struct phy *phy_create(struct device *dev, const struct phy_ops *ops)
 {
 	int ret;
 	int id;
@@ -729,7 +693,6 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 	phy->dev.of_node = dev->of_node;
 	phy->id = id;
 	phy->ops = ops;
-	phy->init_data = init_data;
 
 	ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
 	if (ret)
@@ -759,15 +722,13 @@ EXPORT_SYMBOL_GPL(phy_create);
  * devm_phy_create() - create a new phy
  * @dev: device that is creating the new phy
  * @ops: function pointers for performing phy operations
- * @init_data: contains the list of PHY consumers or NULL
  *
  * Creates a new PHY device adding it to the PHY class.
  * While at that, it also associates the device with the phy using devres.
  * On driver detach, release function is invoked on the devres data,
  * then, devres data is freed.
  */
-struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops,
-	struct phy_init_data *init_data)
+struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops)
 {
 	struct phy **ptr, *phy;
 
@@ -775,7 +736,7 @@ struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops,
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	phy = phy_create(dev, ops, init_data);
+	phy = phy_create(dev, ops);
 	if (!IS_ERR(phy)) {
 		*ptr = phy;
 		devres_add(dev, ptr);
diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
index 0786fef..1236a03 100644
--- a/drivers/phy/phy-exynos-dp-video.c
+++ b/drivers/phy/phy-exynos-dp-video.c
@@ -76,7 +76,7 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(state->regs))
 		return PTR_ERR(state->regs);
 
-	phy = devm_phy_create(dev, &exynos_dp_video_phy_ops, NULL);
+	phy = devm_phy_create(dev, &exynos_dp_video_phy_ops);
 	if (IS_ERR(phy)) {
 		dev_err(dev, "failed to create Display Port PHY\n");
 		return PTR_ERR(phy);
diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index ff02668..a96415e 100644
--- a/drivers/phy/phy-exynos-mipi-video.c
+++ b/drivers/phy/phy-exynos-mipi-video.c
@@ -136,7 +136,7 @@ static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
 
 	for (i = 0; i < EXYNOS_MIPI_PHYS_NUM; i++) {
 		struct phy *phy = devm_phy_create(dev,
-					&exynos_mipi_video_phy_ops, NULL);
+						  &exynos_mipi_video_phy_ops);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "failed to create PHY %d\n", i);
 			return PTR_ERR(phy);
diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index 76d862b..56285af 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -635,8 +635,7 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 	dev_vdbg(dev, "Creating usbdrd_phy phy\n");
 
 	for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
-		struct phy *phy = devm_phy_create(dev, &exynos5_usbdrd_phy_ops,
-						  NULL);
+		struct phy *phy = devm_phy_create(dev, &exynos5_usbdrd_phy_ops);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "Failed to create usbdrd_phy phy\n");
 			return PTR_ERR(phy);
diff --git a/drivers/phy/phy-exynos5250-sata.c b/drivers/phy/phy-exynos5250-sata.c
index 0568945..938d1ce 100644
--- a/drivers/phy/phy-exynos5250-sata.c
+++ b/drivers/phy/phy-exynos5250-sata.c
@@ -210,7 +210,7 @@ static int exynos_sata_phy_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	sata_phy->phy = devm_phy_create(dev, &exynos_sata_phy_ops, NULL);
+	sata_phy->phy = devm_phy_create(dev, &exynos_sata_phy_ops);
 	if (IS_ERR(sata_phy->phy)) {
 		clk_disable_unprepare(sata_phy->phyclk);
 		dev_err(dev, "failed to create PHY\n");
diff --git a/drivers/phy/phy-mvebu-sata.c b/drivers/phy/phy-mvebu-sata.c
index d70ecd6..294d0a0 100644
--- a/drivers/phy/phy-mvebu-sata.c
+++ b/drivers/phy/phy-mvebu-sata.c
@@ -99,7 +99,7 @@ static int phy_mvebu_sata_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
 
-	phy = devm_phy_create(&pdev->dev, &phy_mvebu_sata_ops, NULL);
+	phy = devm_phy_create(&pdev->dev, &phy_mvebu_sata_ops);
 	if (IS_ERR(phy))
 		return PTR_ERR(phy);
 
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 7007c11..e84c24f 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -264,7 +264,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, phy);
 	pm_runtime_enable(phy->dev);
 
-	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
+	generic_phy = devm_phy_create(phy->dev, &ops);
 	if (IS_ERR(generic_phy))
 		return PTR_ERR(generic_phy);
 
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 8a8c6bc..2e9be37 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -189,7 +189,7 @@ static int samsung_usb2_phy_probe(struct platform_device *pdev)
 		struct samsung_usb2_phy_instance *p = &drv->instances[i];
 
 		dev_dbg(dev, "Creating phy \"%s\"\n", label);
-		p->phy = devm_phy_create(dev, &samsung_usb2_phy_ops, NULL);
+		p->phy = devm_phy_create(dev, &samsung_usb2_phy_ops);
 		if (IS_ERR(p->phy)) {
 			dev_err(drv->dev, "Failed to create usb2_phy \"%s\"\n",
 				label);
diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index 115d8d5..40de1f2 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -294,7 +294,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 				return PTR_ERR(phy->pmu);
 		}
 
-		phy->phy = devm_phy_create(dev, &sun4i_usb_phy_ops, NULL);
+		phy->phy = devm_phy_create(dev, &sun4i_usb_phy_ops);
 		if (IS_ERR(phy->phy)) {
 			dev_err(dev, "failed to create PHY %d\n", i);
 			return PTR_ERR(phy->phy);
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 5913676..5e01da7 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -353,7 +353,7 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, phy);
 	pm_runtime_enable(phy->dev);
 
-	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
+	generic_phy = devm_phy_create(phy->dev, &ops);
 	if (IS_ERR(generic_phy))
 		return PTR_ERR(generic_phy);
 
diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 2e0e9b3..803c536 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -659,7 +659,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	struct usb_otg		*otg;
 	struct device_node	*np = pdev->dev.of_node;
 	struct phy_provider	*phy_provider;
-	struct phy_init_data	*init_data = NULL;
 
 	twl = devm_kzalloc(&pdev->dev, sizeof(*twl), GFP_KERNEL);
 	if (!twl)
@@ -670,7 +669,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 				(enum twl4030_usb_mode *)&twl->usb_mode);
 	else if (pdata) {
 		twl->usb_mode = pdata->usb_mode;
-		init_data = pdata->init_data;
 	} else {
 		dev_err(&pdev->dev, "twl4030 initialized without pdata\n");
 		return -EINVAL;
@@ -695,7 +693,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	otg->set_host		= twl4030_set_host;
 	otg->set_peripheral	= twl4030_set_peripheral;
 
-	phy = devm_phy_create(twl->dev, &ops, init_data);
+	phy = devm_phy_create(twl->dev, &ops);
 	if (IS_ERR(phy)) {
 		dev_dbg(&pdev->dev, "Failed to create PHY\n");
 		return PTR_ERR(phy);
diff --git a/drivers/phy/phy-xgene.c b/drivers/phy/phy-xgene.c
index 4aa1ccd..57fc42c 100644
--- a/drivers/phy/phy-xgene.c
+++ b/drivers/phy/phy-xgene.c
@@ -1707,7 +1707,7 @@ static int xgene_phy_probe(struct platform_device *pdev)
 	ctx->dev = &pdev->dev;
 	platform_set_drvdata(pdev, ctx);
 
-	ctx->phy = devm_phy_create(ctx->dev, &xgene_phy_ops, NULL);
+	ctx->phy = devm_phy_create(ctx->dev, &xgene_phy_ops);
 	if (IS_ERR(ctx->phy)) {
 		dev_dbg(&pdev->dev, "Failed to create PHY\n");
 		rc = PTR_ERR(ctx->phy);
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 09348a7..5a537a5 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -60,7 +60,6 @@ struct phy {
 	struct device		dev;
 	int			id;
 	const struct phy_ops	*ops;
-	struct phy_init_data	*init_data;
 	struct mutex		mutex;
 	int			init_count;
 	int			power_count;
@@ -82,32 +81,6 @@ struct phy_provider {
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
@@ -170,10 +143,8 @@ void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_get(struct device_node *np, const char *con_id);
 struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args);
-struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
-	struct phy_init_data *init_data);
-struct phy *devm_phy_create(struct device *dev,
-	const struct phy_ops *ops, struct phy_init_data *init_data);
+struct phy *phy_create(struct device *dev, const struct phy_ops *ops);
+struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops);
 void phy_destroy(struct phy *phy);
 void devm_phy_destroy(struct device *dev, struct phy *phy);
 struct phy_provider *__of_phy_provider_register(struct device *dev,
@@ -315,13 +286,13 @@ static inline struct phy *of_phy_simple_xlate(struct device *dev,
 }
 
 static inline struct phy *phy_create(struct device *dev,
-	const struct phy_ops *ops, struct phy_init_data *init_data)
+				     const struct phy_ops *ops)
 {
 	return ERR_PTR(-ENOSYS);
 }
 
 static inline struct phy *devm_phy_create(struct device *dev,
-	const struct phy_ops *ops, struct phy_init_data *init_data)
+					  const struct phy_ops *ops)
 {
 	return ERR_PTR(-ENOSYS);
 }
-- 
2.0.0.rc4

