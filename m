Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab3JOTX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:23:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41391 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933482Ab3JOTX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:23:56 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, lee.jones@linaro.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3 v2] regulator: core: Add ability to create a lookup alias for supply
Date: Tue, 15 Oct 2013 20:14:20 +0100
Message-Id: <1381864462-26167-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add the ability to create an alternative device on which
a lookup for a certain supply should be conducted.

A common use-case for this would be devices that are logically
represented as a collection of drivers within Linux but are are
presented as a single device from device tree. It this case it is
necessary for each sub device to locate their supply data on the main
device.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |  170 ++++++++++++++++++++++++++++++++++++
 drivers/regulator/devres.c         |  163 ++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |   79 +++++++++++++++++
 3 files changed, 412 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 13263d1..6382f0a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -53,6 +53,7 @@ static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
 static LIST_HEAD(regulator_ena_gpio_list);
+static LIST_HEAD(regulator_supply_alias_list);
 static bool has_full_constraints;
 
 static struct dentry *debugfs_root;
@@ -82,6 +83,19 @@ struct regulator_enable_gpio {
 	unsigned int ena_gpio_invert:1;
 };
 
+/*
+ * struct regulator_supply_alias
+ *
+ * Used to map lookups for a supply onto an alternative device.
+ */
+struct regulator_supply_alias {
+	struct list_head list;
+	struct device *src_dev;
+	const char *src_supply;
+	struct device *alias_dev;
+	const char *alias_supply;
+};
+
 static int _regulator_is_enabled(struct regulator_dev *rdev);
 static int _regulator_disable(struct regulator_dev *rdev);
 static int _regulator_get_voltage(struct regulator_dev *rdev);
@@ -1208,6 +1222,32 @@ static int _regulator_get_enable_time(struct regulator_dev *rdev)
 	return rdev->desc->ops->enable_time(rdev);
 }
 
+static struct regulator_supply_alias *regulator_find_supply_alias(
+		struct device *dev, const char *supply)
+{
+	struct regulator_supply_alias *map;
+
+	list_for_each_entry(map, &regulator_supply_alias_list, list)
+		if (map->src_dev == dev && strcmp(map->src_supply, supply) == 0)
+			return map;
+
+	return NULL;
+}
+
+static void regulator_supply_alias(struct device **dev, const char **supply)
+{
+	struct regulator_supply_alias *map;
+
+	map = regulator_find_supply_alias(*dev, *supply);
+	if (map) {
+		dev_dbg(*dev, "Mapping supply %s to %s,%s\n",
+				*supply, map->alias_supply,
+				dev_name(map->alias_dev));
+		*dev = map->alias_dev;
+		*supply = map->alias_supply;
+	}
+}
+
 static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 						  const char *supply,
 						  int *ret)
@@ -1217,6 +1257,8 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 	struct regulator_map *map;
 	const char *devname = NULL;
 
+	regulator_supply_alias(&dev, &supply);
+
 	/* first do a dt based lookup */
 	if (dev && dev->of_node) {
 		node = of_get_regulator(dev, supply);
@@ -1465,6 +1507,134 @@ void regulator_put(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(regulator_put);
 
+/**
+ * regulator_register_supply_alias - Provide device alias for supply lookup
+ *
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: Supply name or regulator ID
+ * @alias_dev: device that should be used to lookup the supply
+ * @alias_id: Supply name or regulator ID that should be used to lookup the
+ * supply
+ *
+ * All lookups for id on dev will instead be conducted for alias_id on
+ * alias_dev.
+ */
+int regulator_register_supply_alias(struct device *dev, const char *id,
+				    struct device *alias_dev,
+				    const char *alias_id)
+{
+	struct regulator_supply_alias *map;
+
+	map = regulator_find_supply_alias(dev, id);
+	if (map)
+		return -EEXIST;
+
+	map = kzalloc(sizeof(struct regulator_supply_alias), GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+
+	map->src_dev = dev;
+	map->src_supply = id;
+	map->alias_dev = alias_dev;
+	map->alias_supply = alias_id;
+
+	list_add(&map->list, &regulator_supply_alias_list);
+
+	pr_info("Adding alias for supply %s,%s -> %s,%s\n",
+		id, dev_name(dev), alias_id, dev_name(alias_dev));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_register_supply_alias);
+
+/**
+ * regulator_unregister_supply_alias - Remove device alias
+ *
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: Supply name or regulator ID
+ *
+ * Remove a lookup alias if one exists for id on dev.
+ */
+void regulator_unregister_supply_alias(struct device *dev, const char *id)
+{
+	struct regulator_supply_alias *map;
+
+	map = regulator_find_supply_alias(dev, id);
+	if (map) {
+		list_del(&map->list);
+		kfree(map);
+	}
+}
+EXPORT_SYMBOL_GPL(regulator_unregister_supply_alias);
+
+/**
+ * regulator_bulk_register_supply_alias - register multiple aliases
+ *
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: List of supply names or regulator IDs
+ * @alias_dev: device that should be used to lookup the supply
+ * @alias_id: List of supply names or regulator IDs that should be used to
+ * lookup the supply
+ * @num_id: Number of aliases to register
+ *
+ * @return 0 on success, an errno on failure.
+ *
+ * This helper function allows drivers to register several supply
+ * aliases in one operation.  If any of the aliases cannot be
+ * registered any aliases that were registered will be removed
+ * before returning to the caller.
+ */
+int regulator_bulk_register_supply_alias(struct device *dev, const char **id,
+					 struct device *alias_dev,
+					 const char **alias_id,
+					 int num_id)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < num_id; ++i) {
+		ret = regulator_register_supply_alias(dev, id[i], alias_dev,
+						      alias_id[i]);
+		if (ret < 0)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	dev_err(dev,
+		"Failed to create supply alias %s,%s -> %s,%s\n",
+		id[i], dev_name(dev), alias_id[i], dev_name(alias_dev));
+
+	while (--i >= 0)
+		regulator_unregister_supply_alias(dev, id[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_bulk_register_supply_alias);
+
+/**
+ * regulator_bulk_unregister_supply_alias - unregister multiple aliases
+ *
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: List of supply names or regulator IDs
+ * @num_id: Number of aliases to unregister
+ *
+ * This helper function allows drivers to unregister several supply
+ * aliases in one operation.
+ */
+void regulator_bulk_unregister_supply_alias(struct device *dev,
+					    const char **id,
+					    int num_id)
+{
+	int i;
+
+	for (i = 0; i < num_id; ++i)
+		regulator_unregister_supply_alias(dev, id[i]);
+}
+EXPORT_SYMBOL_GPL(regulator_bulk_unregister_supply_alias);
+
+
 /* Manage enable GPIO list. Same GPIO pin can be shared among regulators */
 static int regulator_ena_gpio_request(struct regulator_dev *rdev,
 				const struct regulator_config *config)
diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
index 2672a02..fb7dd17 100644
--- a/drivers/regulator/devres.c
+++ b/drivers/regulator/devres.c
@@ -250,3 +250,166 @@ void devm_regulator_unregister(struct device *dev, struct regulator_dev *rdev)
 		WARN_ON(rc);
 }
 EXPORT_SYMBOL_GPL(devm_regulator_unregister);
+
+struct regulator_supply_alias_match {
+	struct device *dev;
+	const char *id;
+};
+
+static int devm_regulator_match_supply_alias(struct device *dev, void *res,
+					     void *data)
+{
+	struct regulator_supply_alias_match *match = res;
+	struct regulator_supply_alias_match *target = data;
+
+	return match->dev == target->dev && strcmp(match->id, target->id) == 0;
+}
+
+static void devm_regulator_destroy_supply_alias(struct device *dev, void *res)
+{
+	struct regulator_supply_alias_match *match = res;
+
+	regulator_unregister_supply_alias(match->dev, match->id);
+}
+
+/**
+ * devm_regulator_register_supply_alias - Resource managed
+ * regulator_register_supply_alias()
+ *
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: Supply name or regulator ID
+ * @alias_dev: device that should be used to lookup the supply
+ * @alias_id: Supply name or regulator ID that should be used to lookup the
+ * supply
+ *
+ * The supply alias will automatically be unregistered when the source
+ * device is unbound.
+ */
+int devm_regulator_register_supply_alias(struct device *dev, const char *id,
+					 struct device *alias_dev,
+					 const char *alias_id)
+{
+	struct regulator_supply_alias_match *match;
+	int ret;
+
+	match = devres_alloc(devm_regulator_destroy_supply_alias,
+			   sizeof(struct regulator_supply_alias_match),
+			   GFP_KERNEL);
+	if (!match)
+		return -ENOMEM;
+
+	match->dev = dev;
+	match->id = id;
+
+	ret = regulator_register_supply_alias(dev, id, alias_dev, alias_id);
+	if (ret < 0) {
+		devres_free(match);
+		return ret;
+	}
+
+	devres_add(dev, match);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_register_supply_alias);
+
+/**
+ * devm_regulator_unregister_supply_alias - Resource managed
+ * regulator_unregister_supply_alias()
+ *
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: Supply name or regulator ID
+ *
+ * Unregister an alias registered with
+ * devm_regulator_register_supply_alias(). Normally this function
+ * will not need to be called and the resource management code
+ * will ensure that the resource is freed.
+ */
+void devm_regulator_unregister_supply_alias(struct device *dev, const char *id)
+{
+	struct regulator_supply_alias_match match;
+	int rc;
+
+	match.dev = dev;
+	match.id = id;
+
+	rc = devres_release(dev, devm_regulator_destroy_supply_alias,
+			    devm_regulator_match_supply_alias, &match);
+	if (rc != 0)
+		WARN_ON(rc);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_unregister_supply_alias);
+
+/**
+ * devm_regulator_bulk_register_supply_alias - Managed register
+ * multiple aliases
+ *
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: List of supply names or regulator IDs
+ * @alias_dev: device that should be used to lookup the supply
+ * @alias_id: List of supply names or regulator IDs that should be used to
+ * lookup the supply
+ * @num_id: Number of aliases to register
+ *
+ * @return 0 on success, an errno on failure.
+ *
+ * This helper function allows drivers to register several supply
+ * aliases in one operation, the aliases will be automatically
+ * unregisters when the source device is unbound.  If any of the
+ * aliases cannot be registered any aliases that were registered
+ * will be removed before returning to the caller.
+ */
+int devm_regulator_bulk_register_supply_alias(struct device *dev,
+					      const char **id,
+					      struct device *alias_dev,
+					      const char **alias_id,
+					      int num_id)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < num_id; ++i) {
+		ret = devm_regulator_register_supply_alias(dev, id[i],
+							   alias_dev,
+							   alias_id[i]);
+		if (ret < 0)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	dev_err(dev,
+		"Failed to create supply alias %s,%s -> %s,%s\n",
+		id[i], dev_name(dev), alias_id[i], dev_name(alias_dev));
+
+	while (--i >= 0)
+		devm_regulator_unregister_supply_alias(dev, id[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_bulk_register_supply_alias);
+
+/**
+ * devm_regulator_bulk_unregister_supply_alias - Managed unregister
+ * multiple aliases
+ *
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: List of supply names or regulator IDs
+ * @num_id: Number of aliases to unregister
+ *
+ * Unregister aliases registered with
+ * devm_regulator_bulk_register_supply_alias(). Normally this function
+ * will not need to be called and the resource management code
+ * will ensure that the resource is freed.
+ */
+void devm_regulator_bulk_unregister_supply_alias(struct device *dev,
+						 const char **id,
+						 int num_id)
+{
+	int i;
+
+	for (i = 0; i < num_id; ++i)
+		devm_regulator_unregister_supply_alias(dev, id[i]);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_bulk_unregister_supply_alias);
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 27be915..e530681 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -146,6 +146,32 @@ struct regulator *__must_check devm_regulator_get_optional(struct device *dev,
 void regulator_put(struct regulator *regulator);
 void devm_regulator_put(struct regulator *regulator);
 
+int regulator_register_supply_alias(struct device *dev, const char *id,
+				    struct device *alias_dev,
+				    const char *alias_id);
+void regulator_unregister_supply_alias(struct device *dev, const char *id);
+
+int regulator_bulk_register_supply_alias(struct device *dev, const char **id,
+					 struct device *alias_dev,
+					 const char **alias_id, int num_id);
+void regulator_bulk_unregister_supply_alias(struct device *dev,
+					    const char **id, int num_id);
+
+int devm_regulator_register_supply_alias(struct device *dev, const char *id,
+					 struct device *alias_dev,
+					 const char *alias_id);
+void devm_regulator_unregister_supply_alias(struct device *dev,
+					    const char *id);
+
+int devm_regulator_bulk_register_supply_alias(struct device *dev,
+					      const char **id,
+					      struct device *alias_dev,
+					      const char **alias_id,
+					      int num_id);
+void devm_regulator_bulk_unregister_supply_alias(struct device *dev,
+						 const char **id,
+						 int num_id);
+
 /* regulator output control and status */
 int __must_check regulator_enable(struct regulator *regulator);
 int regulator_disable(struct regulator *regulator);
@@ -250,6 +276,59 @@ static inline void devm_regulator_put(struct regulator *regulator)
 {
 }
 
+static inline int regulator_register_supply_alias(struct device *dev,
+						  const char *id,
+						  struct device *alias_dev,
+						  const char *alias_id)
+{
+	return 0;
+}
+
+static inline void regulator_unregister_supply_alias(struct device *dev,
+						    const char *id)
+{
+}
+
+static inline int regulator_bulk_register_supply_alias(struct device *dev,
+						       const char **id,
+						       struct device *alias_dev,
+						       const char **alias_id,
+						       int num_id)
+{
+	return 0;
+}
+
+static inline void regulator_bulk_unregister_supply_alias(struct device *dev,
+							  const char **id,
+							  int num_id)
+{
+}
+
+static inline int devm_regulator_register_supply_alias(struct device *dev,
+						       const char *id,
+						       struct device *alias_dev,
+						       const char *alias_id)
+{
+	return 0;
+}
+
+static inline void devm_regulator_unregister_supply_alias(struct device *dev,
+							  const char *id)
+{
+}
+
+static inline int devm_regulator_bulk_register_supply_alias(
+		struct device *dev, const char **id, struct device *alias_dev,
+		const char **alias_id, int num_id)
+{
+	return 0;
+}
+
+static inline void devm_regulator_bulk_unregister_supply_alias(
+		struct device *dev, const char **id, int num_id)
+{
+}
+
 static inline int regulator_enable(struct regulator *regulator)
 {
 	return 0;
-- 
1.7.2.5

