Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab3LIPJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:09:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:35255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291Ab3LIPJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:09:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,858,1378882800"; 
   d="scan'208";a="441039590"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 2/5] phy: add support for indexed lookup
Date: Mon,  9 Dec 2013 17:08:54 +0200
Message-Id: <1386601737-8735-3-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the need for the consumer drivers requesting the
phys to provide name for the phy. This should ease the use
of the framework considerable when using only one phy, which
is usually the case when except with USB, but it can also
be useful with multiple phys.

This will also reduce noise from the framework when there is
no phy by changing warnings to debug messages.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/phy/phy-core.c  | 106 ++++++++++++++++++++++++++++++++++--------------
 include/linux/phy/phy.h |  14 +++++++
 2 files changed, 89 insertions(+), 31 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 1102aef..99dc046 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -53,7 +53,8 @@ static int devm_phy_match(struct device *dev, void *res, void *match_data)
 	return res == match_data;
 }
 
-static struct phy *phy_lookup(struct device *device, const char *con_id)
+static struct phy *phy_lookup(struct device *device, const char *con_id,
+			      unsigned int idx)
 {
 	unsigned int count;
 	struct phy *phy;
@@ -67,6 +68,10 @@ static struct phy *phy_lookup(struct device *device, const char *con_id)
 		count = phy->init_data->num_consumers;
 		consumers = phy->init_data->consumers;
 		while (count--) {
+			/* index must always match exactly */
+			if (!con_id)
+				if (idx != count)
+					continue;
 			if (!strcmp(consumers->dev_name, dev_name(device)) &&
 					!strcmp(consumers->port, con_id)) {
 				class_dev_iter_exit(&iter);
@@ -242,7 +247,8 @@ EXPORT_SYMBOL_GPL(phy_power_off);
 /**
  * of_phy_get() - lookup and obtain a reference to a phy by phandle
  * @dev: device that requests this phy
- * @index: the index of the phy
+ * @con_id: name of the phy from device's point of view
+ * @idx: the index of the phy if name is not used
  *
  * Returns the phy associated with the given phandle value,
  * after getting a refcount to it or -ENODEV if there is no such phy or
@@ -250,12 +256,20 @@ EXPORT_SYMBOL_GPL(phy_power_off);
  * not yet loaded. This function uses of_xlate call back function provided
  * while registering the phy_provider to find the phy instance.
  */
-static struct phy *of_phy_get(struct device *dev, int index)
+static struct phy *of_phy_get(struct device *dev, const char *con_id,
+			      unsigned int idx)
 {
 	int ret;
 	struct phy_provider *phy_provider;
 	struct phy *phy = NULL;
 	struct of_phandle_args args;
+	int index;
+
+	if (!con_id)
+		index = idx;
+	else
+		index = of_property_match_string(dev->of_node, "phy-names",
+						 con_id);
 
 	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
 		index, &args);
@@ -348,38 +362,36 @@ struct phy *of_phy_simple_xlate(struct device *dev, struct of_phandle_args
 EXPORT_SYMBOL_GPL(of_phy_simple_xlate);
 
 /**
- * phy_get() - lookup and obtain a reference to a phy.
+ * phy_get_index() - obtain a phy based on index
  * @dev: device that requests this phy
  * @con_id: name of the phy from device's point of view
+ * @idx: index of the phy to obtain in the consumer
  *
- * Returns the phy driver, after getting a refcount to it; or
- * -ENODEV if there is no such phy.  The caller is responsible for
- * calling phy_put() to release that count.
+ * This variant of phy_get() allows to access PHYs other than the first
+ * defined one for functions that define several PHYs.
  */
-struct phy *phy_get(struct device *dev, const char *con_id)
+struct phy *phy_get_index(struct device *dev, const char *con_id,
+			  unsigned int idx)
 {
-	int index = 0;
 	struct phy *phy = NULL;
 
-	if (con_id == NULL) {
-		dev_WARN(dev, "missing string\n");
-		return ERR_PTR(-EINVAL);
+	if (dev->of_node) {
+		dev_dbg(dev, "using device tree for PHY lookup\n");
+		phy = of_phy_get(dev, con_id, idx);
 	}
 
-	if (dev->of_node) {
-		index = of_property_match_string(dev->of_node, "phy-names",
-						 con_id);
-		phy = of_phy_get(dev, index);
-		if (IS_ERR(phy)) {
-			dev_err(dev, "unable to find phy\n");
-			return phy;
-		}
-	} else {
-		phy = phy_lookup(dev, con_id);
-		if (IS_ERR(phy)) {
-			dev_err(dev, "unable to find phy\n");
-			return phy;
-		}
+	/**
+	 * Either we are not using DT, or their lookup did not return
+	 * a result. In that case, use platform lookup as a fallback.
+	 */
+	if (!phy || IS_ERR(phy)) {
+		dev_dbg(dev, "using lookup tables for PHY lookup");
+		phy = phy_lookup(dev, con_id, idx);
+	}
+
+	if (IS_ERR(phy)) {
+		dev_dbg(dev, "unable to find phy\n");
+		return phy;
 	}
 
 	if (!try_module_get(phy->ops->owner))
@@ -389,18 +401,20 @@ struct phy *phy_get(struct device *dev, const char *con_id)
 
 	return phy;
 }
-EXPORT_SYMBOL_GPL(phy_get);
+EXPORT_SYMBOL_GPL(phy_get_index);
 
 /**
- * devm_phy_get() - lookup and obtain a reference to a phy.
+ * devm_phy_get_index() - obtain a phy based on index
  * @dev: device that requests this phy
  * @con_id: name of the phy from device's point of view
+ * @idx: index of the phy to obtain in the consumer
  *
- * Gets the phy using phy_get(), and associates a device with it using
+ * Gets the phy using phy_get_index(), and associates a device with it using
  * devres. On driver detach, release function is invoked on the devres data,
  * then, devres data is freed.
  */
-struct phy *devm_phy_get(struct device *dev, const char *con_id)
+struct phy *devm_phy_get_index(struct device *dev, const char *con_id,
+			       unsigned int idx)
 {
 	struct phy **ptr, *phy;
 
@@ -408,7 +422,7 @@ struct phy *devm_phy_get(struct device *dev, const char *con_id)
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	phy = phy_get(dev, con_id);
+	phy = phy_get_index(dev, con_id, idx);
 	if (!IS_ERR(phy)) {
 		*ptr = phy;
 		devres_add(dev, ptr);
@@ -418,6 +432,36 @@ struct phy *devm_phy_get(struct device *dev, const char *con_id)
 
 	return phy;
 }
+EXPORT_SYMBOL_GPL(devm_phy_get_index);
+
+/**
+ * phy_get() - lookup and obtain a reference to a phy.
+ * @dev: device that requests this phy
+ * @con_id: name of the phy from device's point of view
+ *
+ * Returns the phy driver, after getting a refcount to it; or
+ * -ENODEV if there is no such phy.  The caller is responsible for
+ * calling phy_put() to release that count.
+ */
+struct phy *phy_get(struct device *dev, const char *con_id)
+{
+	return phy_get_index(dev, con_id, 0);
+}
+EXPORT_SYMBOL_GPL(phy_get);
+
+/**
+ * devm_phy_get() - lookup and obtain a reference to a phy.
+ * @dev: device that requests this phy
+ * @con_id: name of the phy from device's point of view
+ *
+ * Gets the phy using phy_get_index(), and associates a device with it using
+ * devres. On driver detach, release function is invoked on the devres data,
+ * then, devres data is freed.
+ */
+struct phy *devm_phy_get(struct device *dev, const char *con_id)
+{
+	return devm_phy_get_index(dev, con_id, 0);
+}
 EXPORT_SYMBOL_GPL(devm_phy_get);
 
 /**
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index d67dcbf..43d1a23 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -127,6 +127,8 @@ int phy_init(struct phy *phy);
 int phy_exit(struct phy *phy);
 int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
+struct phy *phy_get_index(struct device *, const char *, unsigned int);
+struct phy *devm_phy_get_index(struct device *, const char *, unsigned int);
 struct phy *phy_get(struct device *dev, const char *con_id);
 struct phy *devm_phy_get(struct device *dev, const char *con_id);
 void phy_put(struct phy *phy);
@@ -199,6 +201,18 @@ static inline int phy_power_off(struct phy *phy)
 	return -ENOSYS;
 }
 
+static inline struct phy *phy_get_index(struct device *dev, const char *id,
+					unsigned int idx)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct phy *devm_phy_get_index(struct device *dev,
+					     const char *id, unsigned int idx)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline struct phy *phy_get(struct device *dev, const char *con_id)
 {
 	return ERR_PTR(-ENOSYS);
-- 
1.8.5.1

