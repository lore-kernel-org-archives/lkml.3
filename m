Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbaKSPbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:31:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:1978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbaKSP2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:28:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="639756147"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, andrew.kim@intel.com
Subject: [PATCHv5 2/7] phy: improved lookup method
Date: Wed, 19 Nov 2014 17:28:18 +0200
Message-Id: <1416410903-162369-3-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separates registration of the phy and the lookup. The method
is copied from clkdev.c,

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 Documentation/phy.txt   | 60 ++++++++++-------------------------
 drivers/phy/phy-core.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/phy/phy.h | 16 ++++++++++
 3 files changed, 115 insertions(+), 45 deletions(-)

diff --git a/Documentation/phy.txt b/Documentation/phy.txt
index c6594af..371361c 100644
--- a/Documentation/phy.txt
+++ b/Documentation/phy.txt
@@ -54,18 +54,14 @@ The PHY driver should create the PHY in order for other peripheral controllers
 to make use of it. The PHY framework provides 2 APIs to create the PHY.
 
 struct phy *phy_create(struct device *dev, struct device_node *node,
-		       const struct phy_ops *ops,
-		       struct phy_init_data *init_data);
+		       const struct phy_ops *ops);
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
-			    const struct phy_ops *ops,
-			    struct phy_init_data *init_data);
+			    const struct phy_ops *ops);
 
 The PHY drivers can use one of the above 2 APIs to create the PHY by passing
-the device pointer, phy ops and init_data.
+the device pointer and phy ops.
 phy_ops is a set of function pointers for performing PHY operations such as
-init, exit, power_on and power_off. *init_data* is mandatory to get a reference
-to the PHY in the case of non-dt boot. See section *Board File Initialization*
-on how init_data should be used.
+init, exit, power_on and power_off.
 
 Inorder to dereference the private data (in phy_ops), the phy provider driver
 can use phy_set_drvdata() after creating the PHY and use phy_get_drvdata() in
@@ -137,42 +133,18 @@ There are exported APIs like phy_pm_runtime_get, phy_pm_runtime_get_sync,
 phy_pm_runtime_put, phy_pm_runtime_put_sync, phy_pm_runtime_allow and
 phy_pm_runtime_forbid for performing PM operations.
 
-8. Board File Initialization
-
-Certain board file initialization is necessary in order to get a reference
-to the PHY in the case of non-dt boot.
-Say we have a single device that implements 3 PHYs that of USB, SATA and PCIe,
-then in the board file the following initialization should be done.
-
-struct phy_consumer consumers[] = {
-	PHY_CONSUMER("dwc3.0", "usb"),
-	PHY_CONSUMER("pcie.0", "pcie"),
-	PHY_CONSUMER("sata.0", "sata"),
-};
-PHY_CONSUMER takes 2 parameters, first is the device name of the controller
-(PHY consumer) and second is the port name.
-
-struct phy_init_data init_data = {
-	.consumers = consumers,
-	.num_consumers = ARRAY_SIZE(consumers),
-};
-
-static const struct platform_device pipe3_phy_dev = {
-	.name = "pipe3-phy",
-	.id = -1,
-	.dev = {
-		.platform_data = {
-			.init_data = &init_data,
-		},
-	},
-};
-
-then, while doing phy_create, the PHY driver should pass this init_data
-	phy_create(dev, ops, pdata->init_data);
-
-and the controller driver (phy consumer) should pass the port name along with
-the device to get a reference to the PHY
-	phy_get(dev, "pcie");
+8. PHY Mappings
+
+In order to get reference to a PHY without help from DeviceTree, the framework
+offers lookups which can be compared to clkdev that allow clk structures to be
+bound to devices. A lookup can be made be made during runtime when a handle to
+the struct phy already exists.
+
+The framework offers the following API for registering and unregistering the
+lookups.
+
+int phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id);
+void phy_remove_lookup(struct phy *phy, const char *con_id, const char *dev_id);
 
 9. DeviceTree Binding
 
diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index ff5eec5..9c3f0dc 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -26,6 +26,7 @@
 static struct class *phy_class;
 static DEFINE_MUTEX(phy_provider_mutex);
 static LIST_HEAD(phy_provider_list);
+static LIST_HEAD(phys);
 static DEFINE_IDA(phy_ida);
 
 static void devm_phy_release(struct device *dev, void *res)
@@ -84,6 +85,87 @@ static struct phy *phy_lookup(struct device *device, const char *port)
 	return ERR_PTR(-ENODEV);
 }
 
+/**
+ * phy_create_lookup() - allocate and register PHY/device association
+ * @phy: the phy of the association
+ * @con_id: connection ID string on device
+ * @dev_id: the device of the association
+ *
+ * Creates and registers phy_lookup entry.
+ */
+int phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id)
+{
+	struct phy_lookup *pl;
+
+	if (!phy || !dev_id || !con_id)
+		return -EINVAL;
+
+	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
+	if (!pl)
+		return -ENOMEM;
+
+	pl->dev_id = dev_id;
+	pl->con_id = con_id;
+	pl->phy = phy;
+
+	mutex_lock(&phy_provider_mutex);
+	list_add_tail(&pl->node, &phys);
+	mutex_unlock(&phy_provider_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phy_create_lookup);
+
+/**
+ * phy_remove_lookup() - find and remove PHY/device association
+ * @phy: the phy of the association
+ * @con_id: connection ID string on device
+ * @dev_id: the device of the association
+ *
+ * Finds and unregisters phy_lookup entry that was created with
+ * phy_create_lookup().
+ */
+void phy_remove_lookup(struct phy *phy, const char *con_id, const char *dev_id)
+{
+	struct phy_lookup *pl;
+
+	if (!phy || !dev_id || !con_id)
+		return;
+
+	mutex_lock(&phy_provider_mutex);
+	list_for_each_entry(pl, &phys, node)
+		if (pl->phy == phy && !strcmp(pl->dev_id, dev_id) &&
+		    !strcmp(pl->con_id, con_id)) {
+			list_del(&pl->node);
+			kfree(pl);
+			break;
+		}
+	mutex_unlock(&phy_provider_mutex);
+}
+EXPORT_SYMBOL_GPL(phy_remove_lookup);
+
+static struct phy *phy_find(struct device *dev, const char *con_id)
+{
+	const char *dev_id = dev_name(dev);
+	struct phy_lookup *p, *pl = NULL;
+	struct phy *phy;
+
+	mutex_lock(&phy_provider_mutex);
+	list_for_each_entry(p, &phys, node)
+		if (!strcmp(p->dev_id, dev_id) && !strcmp(p->con_id, con_id)) {
+			pl = p;
+			break;
+		}
+	mutex_unlock(&phy_provider_mutex);
+
+	phy = pl ? pl->phy : ERR_PTR(-ENODEV);
+
+	/* fall-back to the old lookup method for now */
+	if (IS_ERR(phy))
+		phy = phy_lookup(dev, con_id);
+	return phy;
+}
+
 static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
 {
 	struct phy_provider *phy_provider;
@@ -463,7 +545,7 @@ struct phy *phy_get(struct device *dev, const char *string)
 			string);
 		phy = _of_phy_get(dev->of_node, index);
 	} else {
-		phy = phy_lookup(dev, string);
+		phy = phy_find(dev, string);
 	}
 	if (IS_ERR(phy))
 		return phy;
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 9fda683..849284e 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -110,6 +110,13 @@ struct phy_init_data {
 	.port		= _port,				\
 }
 
+struct phy_lookup {
+	struct list_head node;
+	const char *dev_id;
+	const char *con_id;
+	struct phy *phy;
+};
+
 #define	to_phy(a)	(container_of((a), struct phy, dev))
 
 #define	of_phy_provider_register(dev, xlate)	\
@@ -174,6 +181,8 @@ struct phy_provider *__devm_of_phy_provider_register(struct device *dev,
 void of_phy_provider_unregister(struct phy_provider *phy_provider);
 void devm_of_phy_provider_unregister(struct device *dev,
 	struct phy_provider *phy_provider);
+int phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id);
+void phy_remove_lookup(struct phy *phy, const char *con_id, const char *dev_id);
 #else
 static inline int phy_pm_runtime_get(struct phy *phy)
 {
@@ -345,6 +354,13 @@ static inline void devm_of_phy_provider_unregister(struct device *dev,
 	struct phy_provider *phy_provider)
 {
 }
+static inline int
+phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id)
+{
+	return 0;
+}
+static inline void phy_remove_lookup(struct phy *phy, const char *con_id,
+				     const char *dev_id) { }
 #endif
 
 #endif /* __DRIVERS_PHY_H */
-- 
2.1.3

