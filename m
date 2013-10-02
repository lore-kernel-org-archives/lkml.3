Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3JBM2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:28:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41468 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539Ab3JBM2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:28:17 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [RFC PATCH] regulator: core: Add ability to create a lookup alias for supply
Date: Wed,  2 Oct 2013 13:16:59 +0100
Message-Id: <1380716219-32039-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
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

Hi Mark,

Following our discussions around the Arizona regulator
bindings here is an effort at putting a mechanism into the
regulator core to alias registering of a supply from one
device to another.

I have a couple of patches that update the Arizona driver to
use this that I will send in if you think this looks along
the lines of what you were suggesting.

Thanks,
Charles

 drivers/regulator/core.c           |   93 ++++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |   17 +++++++
 2 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6333080..e9f11f0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -53,6 +53,7 @@ static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
 static LIST_HEAD(regulator_ena_gpio_list);
+static LIST_HEAD(regulator_supply_alias_list);
 static bool has_full_constraints;
 
 static struct dentry *debugfs_root;
@@ -82,6 +83,18 @@ struct regulator_enable_gpio {
 	unsigned int ena_gpio_invert:1;
 };
 
+/*
+ * struct regulator_supply_alias
+ *
+ * Used to map lookups for a supply onto an alternative device.
+ */
+struct regulator_supply_alias {
+	struct list_head list;
+	struct device *dev;
+	const char *supply;
+	struct device *alias;
+};
+
 static int _regulator_is_enabled(struct regulator_dev *rdev);
 static int _regulator_disable(struct regulator_dev *rdev);
 static int _regulator_get_voltage(struct regulator_dev *rdev);
@@ -1208,6 +1221,28 @@ static int _regulator_get_enable_time(struct regulator_dev *rdev)
 	return rdev->desc->ops->enable_time(rdev);
 }
 
+static inline int regulator_supply_alias_match(struct device *dev,
+					       const char *supply,
+					       struct regulator_supply_alias *map)
+{
+	return map->dev == dev && strcmp(map->supply, supply) == 0;
+}
+
+static struct device *regulator_supply_alias(struct device *dev,
+					     const char *supply)
+{
+	struct regulator_supply_alias *map;
+
+	list_for_each_entry(map, &regulator_supply_alias_list, list)
+		if (regulator_supply_alias_match(dev, supply, map)) {
+			dev_dbg(dev, "Mapping supply %s to %s\n",
+				supply, dev_name(map->alias));
+			return map->alias;
+		}
+
+	return dev;
+}
+
 static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 						  const char *supply,
 						  int *ret)
@@ -1217,6 +1252,8 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 	struct regulator_map *map;
 	const char *devname = NULL;
 
+	dev = regulator_supply_alias(dev, supply);
+
 	/* first do a dt based lookup */
 	if (dev && dev->of_node) {
 		node = of_get_regulator(dev, supply);
@@ -1470,6 +1507,62 @@ void regulator_put(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(regulator_put);
 
+/**
+ * regulator_register_supply_alias - Provide device alias for supply lookup
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: Supply name or regulator ID.
+ * @alias: device that should be used to lookup the supply
+ *
+ * All lookups for id on dev will instead be conducted on for id on alias.
+ */
+int regulator_register_supply_alias(struct device *dev, const char *id,
+				    struct device *alias)
+{
+	struct regulator_supply_alias *map;
+
+	list_for_each_entry(map, &regulator_supply_alias_list, list)
+		if (regulator_supply_alias_match(dev, id, map))
+			return -EEXIST;
+
+	map = kzalloc(sizeof(struct regulator_supply_alias), GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+
+	map->dev = dev;
+	map->supply = id;
+	map->alias = alias;
+
+	list_add(&map->list, &regulator_supply_alias_list);
+
+	pr_info("Adding alias for supply %s: %s -> %s\n",
+		id, dev_name(dev), dev_name(alias));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_register_supply_alias);
+
+/**
+ * regulator_unregister_supply_alias - Remove device alias
+ * @dev: device that will be given as the regulator "consumer"
+ * @id: Supply name or regulator ID.
+ *
+ * Remove a lookup alias if one exists for id on dev.
+ */
+int regulator_unregister_supply_alias(struct device *dev, const char *id)
+{
+	struct regulator_supply_alias *map;
+
+	list_for_each_entry(map, &regulator_supply_alias_list, list)
+		if (regulator_supply_alias_match(dev, id, map)) {
+			list_del(&map->list);
+			kfree(map);
+			return 0;
+		}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regulator_unregister_supply_alias);
+
 /* Manage enable GPIO list. Same GPIO pin can be shared among regulators */
 static int regulator_ena_gpio_request(struct regulator_dev *rdev,
 				const struct regulator_config *config)
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 27be915..622d81e 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -146,6 +146,10 @@ struct regulator *__must_check devm_regulator_get_optional(struct device *dev,
 void regulator_put(struct regulator *regulator);
 void devm_regulator_put(struct regulator *regulator);
 
+int regulator_register_supply_alias(struct device *dev, const char *id,
+				    struct device *alias);
+int regulator_unregister_supply_alias(struct device *dev, const char *id);
+
 /* regulator output control and status */
 int __must_check regulator_enable(struct regulator *regulator);
 int regulator_disable(struct regulator *regulator);
@@ -250,6 +254,19 @@ static inline void devm_regulator_put(struct regulator *regulator)
 {
 }
 
+static inline int regulator_register_supply_alias(struct device *dev,
+						  const char *id,
+						  struct device *alias)
+{
+	return 0;
+}
+
+static inline int regulator_unregister_supply_alias(struct device *dev,
+						    const char *id)
+{
+	return 0;
+}
+
 static inline int regulator_enable(struct regulator *regulator)
 {
 	return 0;
-- 
1.7.2.5

