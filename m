Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab3LIPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:09:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:35255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291Ab3LIPJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:09:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,858,1378882800"; 
   d="scan'208";a="441039643"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH] phy: remove the old lookup method
Date: Mon,  9 Dec 2013 17:08:57 +0200
Message-Id: <1386601737-8735-6-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The users of the old method are now converted to the new one.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 Documentation/phy.txt               | 100 ++++++++++++++++++++++--------------
 drivers/phy/phy-core.c              |  46 ++---------------
 drivers/phy/phy-exynos-dp-video.c   |   2 +-
 drivers/phy/phy-exynos-mipi-video.c |   2 +-
 drivers/phy/phy-omap-usb2.c         |   2 +-
 drivers/phy/phy-twl4030-usb.c       |   4 +-
 include/linux/phy/phy.h             |  36 ++-----------
 7 files changed, 73 insertions(+), 119 deletions(-)

diff --git a/Documentation/phy.txt b/Documentation/phy.txt
index 0103e4b..cfff1a2 100644
--- a/Documentation/phy.txt
+++ b/Documentation/phy.txt
@@ -53,17 +53,13 @@ unregister the PHY.
 The PHY driver should create the PHY in order for other peripheral controllers
 to make use of it. The PHY framework provides 2 APIs to create the PHY.
 
-struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
-        struct phy_init_data *init_data);
-struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops,
-	struct phy_init_data *init_data);
+struct phy *phy_create(struct device *dev, const struct phy_ops *ops);
+struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops);
 
 The PHY drivers can use one of the above 2 APIs to create the PHY by passing
-the device pointer, phy ops and init_data.
+the device pointer, phy ops.
 phy_ops is a set of function pointers for performing PHY operations such as
-init, exit, power_on and power_off. *init_data* is mandatory to get a reference
-to the PHY in the case of non-dt boot. See section *Board File Initialization*
-on how init_data should be used.
+init, exit, power_on and power_off.
 
 Inorder to dereference the private data (in phy_ops), the phy provider driver
 can use phy_set_drvdata() after creating the PHY and use phy_get_drvdata() in
@@ -74,16 +70,21 @@ phy_ops to get back the private data.
 Before the controller can make use of the PHY, it has to get a reference to
 it. This framework provides the following APIs to get a reference to the PHY.
 
-struct phy *phy_get(struct device *dev, const char *string);
-struct phy *devm_phy_get(struct device *dev, const char *string);
+struct phy *phy_get(struct device *dev, const char *con_id);
+struct phy *devm_phy_get(struct device *dev, const char *con_id);
 
 phy_get and devm_phy_get can be used to get the PHY. In the case of dt boot,
-the string arguments should contain the phy name as given in the dt data and
+the con_id arguments should contain the phy name as given in the dt data and
 in the case of non-dt boot, it should contain the label of the PHY.
 The only difference between the two APIs is that devm_phy_get associates the
 device with the PHY using devres on successful PHY get. On driver detach,
 release function is invoked on the the devres data and devres data is freed.
 
+Indexed lookup is also possible when device has multiple PHYs attached to it.
+The framework provides variants for phy_get() functions called phy_get_index()
+and devm_phy_get_index(). They take the same parameters as do the normal
+phy_get() plus the index number of the PHY as the last parameter.
+
 5. Releasing a reference to the PHY
 
 When the controller no longer needs the PHY, it has to release the reference
@@ -123,42 +124,63 @@ There are exported APIs like phy_pm_runtime_get, phy_pm_runtime_get_sync,
 phy_pm_runtime_put, phy_pm_runtime_put_sync, phy_pm_runtime_allow and
 phy_pm_runtime_forbid for performing PM operations.
 
-8. Board File Initialization
+8. Platform Data binding
 
-Certain board file initialization is necessary in order to get a reference
-to the PHY in the case of non-dt boot.
-Say we have a single device that implements 3 PHYs that of USB, SATA and PCIe,
-then in the board file the following initialization should be done.
+PHY's are mapped by the means of tables of lookups, containing instances of the
+phy_lookup structure. Two macros are defined to help declaring such mappings:
 
-struct phy_consumer consumers[] = {
-	PHY_CONSUMER("dwc3.0", "usb"),
-	PHY_CONSUMER("pcie.0", "pcie"),
-	PHY_CONSUMER("sata.0", "sata"),
-};
-PHY_CONSUMER takes 2 parameters, first is the device name of the controller
-(PHY consumer) and second is the port name.
+	PHY_LOOKUP(phy_name, con_id)
+	PHY_LOOKUP_IDX(phy_name, con_id, idx)
+
+where
 
-struct phy_init_data init_data = {
-	.consumers = consumers,
-	.num_consumers = ARRAY_SIZE(consumers),
+  - phy_name identifiers of the phy device
+  - con_id is the name of the PHY from the device point of view. It can be NULL.
+  - idx is the index of the PHY within the function.
+
+A lookup table can then be defined as follows, with an empty entry defining its
+end:
+
+struct phy_lookup_table phys_table = {
+       .dev_id = "usb_controller.0",
+       .table = {
+               PHY_LOOKUP_IDX("phy-usb2phy.0", "usb2-phy", 0),
+               PHY_LOOKUP_IDX("phy-usb3phy.0", "usb3-phy", 1),
+               { },
+       },
 };
 
-static const struct platform_device pipe3_phy_dev = {
-	.name = "pipe3-phy",
-	.id = -1,
-	.dev = {
-		.platform_data = {
-			.init_data = &init_data,
-		},
-	},
+or when there is only single PHY:
+
+struct phy_lookup_table phy_table = {
+       .dev_id = "foo.0",
+       .table = PHY_LOOKUP("phy.0", NULL),
 };
 
-then, while doing phy_create, the PHY driver should pass this init_data
-	phy_create(dev, ops, pdata->init_data);
+And the table can be added by the board code as follows:
+
+	phy_add_table(&phys_table);
+and
+	phy_add_table(&phy_table);
+
+The driver controlling "usb_controller.0" will then be able to obtain its PHYs
+as follows:
+
+	struct phy *usb2_phy, usb3_phy;
+
+	usb2_phy = phy_get(dev, "usb2-phy");
+	usb3_phy = phy_get(dev, "usb3-phy");
+or
+	usb2_phy = phy_get_index(dev, "usb2-phy", 0);
+	usb3_phy = phy_get_index(dev, "usb3-phy", 1);
+
+The driver controlling "foo.0" can obtain its PHY as follows:
+
+	struct phy *phy;
 
-and the controller driver (phy consumer) should pass the port name along with
-the device to get a reference to the PHY
-	phy_get(dev, "pcie");
+	phy = phy_get(dev, NULL);
+or
+	phy = phy_get_index(dev, NULL, 0);
 
 9. DeviceTree Binding
 
diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 05792d0..26f19ee 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -54,38 +54,6 @@ static int devm_phy_match(struct device *dev, void *res, void *match_data)
 	return res == match_data;
 }
 
-static struct phy *phy_lookup(struct device *device, const char *con_id,
-			      unsigned int idx)
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
-		count = phy->init_data->num_consumers;
-		consumers = phy->init_data->consumers;
-		while (count--) {
-			/* index must always match exactly */
-			if (!con_id)
-				if (idx != count)
-					continue;
-			if (!strcmp(consumers->dev_name, dev_name(device)) &&
-					!strcmp(consumers->port, con_id)) {
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
  * phy_add_table() - register PHY/device association to the lookup list
  * @table: association to register
@@ -150,8 +118,7 @@ static struct phy *phy_find(struct device *dev, const char *con_id,
 
 	table = phy_get_lookup_table(dev);
 	if (!table)
-		/* fall-back to the old lookup method for now */
-		return phy_lookup(dev, con_id, idx);
+		return ERR_PTR(-ENODEV);
 
 	for (p = &table->table[0]; p->phy_name; p++) {
 		/* index must always match exactly */
@@ -557,12 +524,10 @@ EXPORT_SYMBOL_GPL(devm_phy_get);
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
@@ -595,7 +560,6 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 	phy->dev.of_node = dev->of_node;
 	phy->id = id;
 	phy->ops = ops;
-	phy->init_data = init_data;
 
 	ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
 	if (ret)
@@ -626,15 +590,13 @@ EXPORT_SYMBOL_GPL(phy_create);
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
 
@@ -642,7 +604,7 @@ struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops,
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	phy = phy_create(dev, ops, init_data);
+	phy = phy_create(dev, ops);
 	if (!IS_ERR(phy)) {
 		*ptr = phy;
 		devres_add(dev, ptr);
diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
index 1dbe6ce..e6c5065 100644
--- a/drivers/phy/phy-exynos-dp-video.c
+++ b/drivers/phy/phy-exynos-dp-video.c
@@ -80,7 +80,7 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider))
 		return PTR_ERR(phy_provider);
 
-	phy = devm_phy_create(dev, &exynos_dp_video_phy_ops, NULL);
+	phy = devm_phy_create(dev, &exynos_dp_video_phy_ops);
 	if (IS_ERR(phy)) {
 		dev_err(dev, "failed to create Display Port PHY\n");
 		return PTR_ERR(phy);
diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index 0c5efab..900a14d 100644
--- a/drivers/phy/phy-exynos-mipi-video.c
+++ b/drivers/phy/phy-exynos-mipi-video.c
@@ -141,7 +141,7 @@ static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
 
 	for (i = 0; i < EXYNOS_MIPI_PHYS_NUM; i++) {
 		struct phy *phy = devm_phy_create(dev,
-					&exynos_mipi_video_phy_ops, NULL);
+						  &exynos_mipi_video_phy_ops);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "failed to create PHY %d\n", i);
 			return PTR_ERR(phy);
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index bfc5c33..87c9d8b 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -208,7 +208,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, phy);
 	pm_runtime_enable(phy->dev);
 
-	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
+	generic_phy = devm_phy_create(phy->dev, &ops);
 	if (IS_ERR(generic_phy))
 		return PTR_ERR(generic_phy);
 
diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index daf65e6..bcc2f7d 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -659,7 +659,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	struct usb_otg		*otg;
 	struct device_node	*np = pdev->dev.of_node;
 	struct phy_provider	*phy_provider;
-	struct phy_init_data	*init_data = NULL;
 
 	twl = devm_kzalloc(&pdev->dev, sizeof *twl, GFP_KERNEL);
 	if (!twl)
@@ -670,7 +669,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 				(enum twl4030_usb_mode *)&twl->usb_mode);
 	else if (pdata) {
 		twl->usb_mode = pdata->usb_mode;
-		init_data = pdata->init_data;
 	} else {
 		dev_err(&pdev->dev, "twl4030 initialized without pdata\n");
 		return -EINVAL;
@@ -700,7 +698,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider))
 		return PTR_ERR(phy_provider);
 
-	phy = devm_phy_create(twl->dev, &ops, init_data);
+	phy = devm_phy_create(twl->dev, &ops);
 	if (IS_ERR(phy)) {
 		dev_dbg(&pdev->dev, "Failed to create PHY\n");
 		return PTR_ERR(phy);
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index cca363a..a0fd30f 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -73,32 +73,6 @@ struct phy_provider {
 };
 
 /**
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
-/**
  * struct phy_lookup - Lookup entry for associating PHYs
  * @phy_name: device name of the PHY
  * @con_id: name of the PHY from device's point of view
@@ -183,10 +157,8 @@ void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
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
@@ -286,13 +258,13 @@ static inline struct phy *of_phy_simple_xlate(struct device *dev,
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
1.8.5.1

