Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaLZR1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 12:27:15 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45951 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751295AbaLZR1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 12:27:06 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, linux-ide@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 2/2] regulator: core: Add the device tree version to the regulator_get family
Date: Fri, 26 Dec 2014 18:26:39 +0100
Message-Id: <1419614799-5770-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419614799-5770-1-git-send-email-gregory.clement@free-electrons.com>
References: <1419614799-5770-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree version (of_) for each member of the
regulator_get family: normal, exclusive, optional and all of the
manageable version.

The of_regulator_get* functions allow using a device node to get the
regulator instead using the device object. It is needed for the
regulator associated to a child node which is not a device, it is the
case of the SATA ports of an ahci controller for instance.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/regulator/core.c           | 114 +++++++++++++++++++++++++++++++++----
 drivers/regulator/devres.c         |  70 ++++++++++++++++++++---
 include/linux/regulator/consumer.h |  20 +++++++
 3 files changed, 187 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index de29399b5430..74167b98797a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -127,26 +127,37 @@ static bool have_full_constraints(void)
 
 /**
  * of_get_regulator - get a regulator device node based on supply name
+ * and on device node if provided
+ *
  * @dev: Device pointer for the consumer (of regulator) device
+ * @np: Device tree node pointer on the node containing the regulator
  * @supply: regulator supply name
  *
  * Extract the regulator device node corresponding to the supply name.
  * returns the device node corresponding to the regulator if found, else
  * returns NULL.
  */
-static struct device_node *of_get_regulator(struct device *dev, const char *supply)
+static struct device_node *of_get_regulator_by_node(struct device *dev,
+						    const char *supply,
+						    struct device_node *np)
 {
 	struct device_node *regnode = NULL;
 	char prop_name[32]; /* 32 is max size of property name */
+	struct device_node *node;
+
+	if (np)
+		node = np;
+	else
+		node = dev->of_node;
 
 	dev_dbg(dev, "Looking up %s-supply from device tree\n", supply);
 
 	snprintf(prop_name, 32, "%s-supply", supply);
-	regnode = of_parse_phandle(dev->of_node, prop_name, 0);
+	regnode = of_parse_phandle(node, prop_name, 0);
 
 	if (!regnode) {
 		dev_dbg(dev, "Looking up %s property in node %s failed",
-				prop_name, dev->of_node->full_name);
+				prop_name, node->full_name);
 		return NULL;
 	}
 	return regnode;
@@ -1268,6 +1279,7 @@ static void regulator_supply_alias(struct device **dev, const char **supply)
 
 static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 						  const char *supply,
+						  struct device_node *np,
 						  int *ret)
 {
 	struct regulator_dev *r;
@@ -1278,8 +1290,8 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 	regulator_supply_alias(&dev, &supply);
 
 	/* first do a dt based lookup */
-	if (dev && dev->of_node) {
-		node = of_get_regulator(dev, supply);
+	if ((dev && dev->of_node) || np) {
+		node = of_get_regulator_by_node(dev, supply, np);
 		if (node) {
 			list_for_each_entry(r, &regulator_list, list)
 				if (r->dev.parent &&
@@ -1322,6 +1334,7 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 
 /* Internal regulator request function */
 static struct regulator *_regulator_get(struct device *dev, const char *id,
+					struct device_node *node,
 					bool exclusive, bool allow_dummy)
 {
 	struct regulator_dev *rdev;
@@ -1344,7 +1357,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 
 	mutex_lock(&regulator_list_mutex);
 
-	rdev = regulator_dev_lookup(dev, id, &ret);
+	rdev = regulator_dev_lookup(dev, id, node, &ret);
 	if (rdev)
 		goto found;
 
@@ -1431,7 +1444,7 @@ out:
  */
 struct regulator *regulator_get(struct device *dev, const char *id)
 {
-	return _regulator_get(dev, id, false, true);
+	return _regulator_get(dev, id, NULL, false, true);
 }
 EXPORT_SYMBOL_GPL(regulator_get);
 
@@ -1458,7 +1471,7 @@ EXPORT_SYMBOL_GPL(regulator_get);
  */
 struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
 {
-	return _regulator_get(dev, id, true, false);
+	return _regulator_get(dev, id, NULL, true, false);
 }
 EXPORT_SYMBOL_GPL(regulator_get_exclusive);
 
@@ -1484,10 +1497,91 @@ EXPORT_SYMBOL_GPL(regulator_get_exclusive);
  */
 struct regulator *regulator_get_optional(struct device *dev, const char *id)
 {
-	return _regulator_get(dev, id, false, false);
+	return _regulator_get(dev, id, NULL, false, false);
 }
 EXPORT_SYMBOL_GPL(regulator_get_optional);
 
+/**
+ * of_regulator_get - lookup and obtain a reference to a regulator.
+ * @dev: device for regulator "consumer"
+ * @node: device node for which to get the regulator
+ * @id: Supply name or regulator ID.
+ *
+ * Returns a struct regulator corresponding to the regulator producer,
+ * or IS_ERR() condition containing errno.
+ *
+ * Use of supply names configured via regulator_set_device_supply() is
+ * strongly encouraged.  It is recommended that the supply name used
+ * should match the name used for the supply and/or the relevant
+ * device pins in the datasheet.
+ */
+struct regulator *of_regulator_get(struct device *dev,
+				   const char *id,
+				struct device_node *node)
+{
+	return _regulator_get(dev, id, node, false, true);
+}
+EXPORT_SYMBOL_GPL(of_regulator_get);
+
+/**
+ * of_regulator_get_exclusive - obtain exclusive access to a regulator.
+ * @dev: device for regulator "consumer"
+ * @node: device node for which to get the regulator
+ * @id: Supply name or regulator ID.
+ *
+ * Returns a struct regulator corresponding to the regulator producer,
+ * or IS_ERR() condition containing errno.  Other consumers will be
+ * unable to obtain this regulator while this reference is held and the
+ * use count for the regulator will be initialised to reflect the current
+ * state of the regulator.
+ *
+ * This is intended for use by consumers which cannot tolerate shared
+ * use of the regulator such as those which need to force the
+ * regulator off for correct operation of the hardware they are
+ * controlling.
+ *
+ * Use of supply names configured via regulator_set_device_supply() is
+ * strongly encouraged.  It is recommended that the supply name used
+ * should match the name used for the supply and/or the relevant
+ * device pins in the datasheet.
+ */
+struct regulator *of_regulator_get_exclusive(struct device *dev,
+					     const char *id,
+					     struct device_node *node)
+{
+	return _regulator_get(dev, id, node, true, false);
+}
+EXPORT_SYMBOL_GPL(of_regulator_get_exclusive);
+
+/**
+ * of_regulator_get_optional - obtain optional access to a regulator.
+ * @dev: device for regulator "consumer"
+ * @node: device node for which to get the regulator
+ * @id: Supply name or regulator ID.
+ *
+ * Returns a struct regulator corresponding to the regulator producer,
+ * or IS_ERR() condition containing errno.
+ *
+ * This is intended for use by consumers for devices which can have
+ * some supplies unconnected in normal use, such as some MMC devices.
+ * It can allow the regulator core to provide stub supplies for other
+ * supplies requested using normal regulator_get() calls without
+ * disrupting the operation of drivers that can handle absent
+ * supplies.
+ *
+ * Use of supply names configured via regulator_set_device_supply() is
+ * strongly encouraged.  It is recommended that the supply name used
+ * should match the name used for the supply and/or the relevant
+ * device pins in the datasheet.
+ */
+struct regulator *of_regulator_get_optional(struct device *dev,
+					    const char *id,
+					    struct device_node *node)
+{
+	return _regulator_get(dev, id, node, false, false);
+}
+EXPORT_SYMBOL_GPL(of_regulator_get_optional);
+
 /* Locks held by regulator_put() */
 static void _regulator_put(struct regulator *regulator)
 {
@@ -3714,7 +3808,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	if (supply) {
 		struct regulator_dev *r;
 
-		r = regulator_dev_lookup(dev, supply, &ret);
+		r = regulator_dev_lookup(dev, supply, NULL, &ret);
 
 		if (ret == -ENODEV) {
 			/*
diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
index 8f785bc9e510..755fc07ebc33 100644
--- a/drivers/regulator/devres.c
+++ b/drivers/regulator/devres.c
@@ -30,7 +30,9 @@ static void devm_regulator_release(struct device *dev, void *res)
 	regulator_put(*(struct regulator **)res);
 }
 
-static struct regulator *_devm_regulator_get(struct device *dev, const char *id,
+static struct regulator *_devm_regulator_get(struct device *dev,
+					     const char *id,
+					     struct device_node *node,
 					     int get_type)
 {
 	struct regulator **ptr, *regulator;
@@ -41,13 +43,13 @@ static struct regulator *_devm_regulator_get(struct device *dev, const char *id,
 
 	switch (get_type) {
 	case NORMAL_GET:
-		regulator = regulator_get(dev, id);
+		regulator = of_regulator_get(dev, id, node);
 		break;
 	case EXCLUSIVE_GET:
-		regulator = regulator_get_exclusive(dev, id);
+		regulator = of_regulator_get_exclusive(dev, id, node);
 		break;
 	case OPTIONAL_GET:
-		regulator = regulator_get_optional(dev, id);
+		regulator = of_regulator_get_optional(dev, id, node);
 		break;
 	default:
 		regulator = ERR_PTR(-EINVAL);
@@ -74,7 +76,7 @@ static struct regulator *_devm_regulator_get(struct device *dev, const char *id,
  */
 struct regulator *devm_regulator_get(struct device *dev, const char *id)
 {
-	return _devm_regulator_get(dev, id, NORMAL_GET);
+	return _devm_regulator_get(dev, id, NULL, NORMAL_GET);
 }
 EXPORT_SYMBOL_GPL(devm_regulator_get);
 
@@ -90,7 +92,7 @@ EXPORT_SYMBOL_GPL(devm_regulator_get);
 struct regulator *devm_regulator_get_exclusive(struct device *dev,
 					       const char *id)
 {
-	return _devm_regulator_get(dev, id, EXCLUSIVE_GET);
+	return _devm_regulator_get(dev, id, NULL, EXCLUSIVE_GET);
 }
 EXPORT_SYMBOL_GPL(devm_regulator_get_exclusive);
 
@@ -106,10 +108,64 @@ EXPORT_SYMBOL_GPL(devm_regulator_get_exclusive);
 struct regulator *devm_regulator_get_optional(struct device *dev,
 					      const char *id)
 {
-	return _devm_regulator_get(dev, id, OPTIONAL_GET);
+	return _devm_regulator_get(dev, id, NULL, OPTIONAL_GET);
 }
 EXPORT_SYMBOL_GPL(devm_regulator_get_optional);
 
+/**
+ * devm_regulator_get - Resource managed regulator_get()
+ * @dev: device for regulator "consumer"
+ * @node: device node for which to get the regulator
+ * @id: Supply name or regulator ID.
+ *
+ * Managed regulator_get(). Regulators returned from this function are
+ * automatically regulator_put() on driver detach. See regulator_get()
+ * for more information.
+ */
+struct regulator *devm_of_regulator_get(struct device *dev,
+					const char *id,
+					struct device_node *node)
+{
+	return _devm_regulator_get(dev, id, node, NORMAL_GET);
+}
+EXPORT_SYMBOL_GPL(devm_of_regulator_get);
+
+/**
+ * devm_regulator_get_exclusive - Resource managed regulator_get_exclusive()
+ * @dev: device for regulator "consumer"
+ * @node: device node for which to get the regulator
+ * @id: Supply name or regulator ID.
+ *
+ * Managed regulator_get_exclusive(). Regulators returned from this
+ * function are automatically regulator_put() on driver detach. See
+ * regulator_get_exclusive() for more information.
+ */
+struct regulator *devm_of_regulator_get_exclusive(struct device *dev,
+						 const char *id,
+						 struct device_node *node)
+{
+	return _devm_regulator_get(dev, id, node, EXCLUSIVE_GET);
+}
+EXPORT_SYMBOL_GPL(devm_of_regulator_get_exclusive);
+
+/**
+ * devm_regulator_get_optional - Resource managed regulator_get_optional()
+ * @dev: device for regulator "consumer"
+ * @node: device node for which to get the regulator
+ * @id: Supply name or regulator ID.
+ *
+ * Managed regulator_get_optional(). Regulators returned from this
+ * function are automatically regulator_put() on driver detach. See
+ * regulator_get_optional() for more information.
+ */
+struct regulator *devm_of_regulator_get_optional(struct device *dev,
+						 const char *id,
+						 struct device_node *node)
+{
+	return _devm_regulator_get(dev, id, node, OPTIONAL_GET);
+}
+EXPORT_SYMBOL_GPL(devm_of_regulator_get_optional);
+
 static int devm_regulator_match(struct device *dev, void *res, void *data)
 {
 	struct regulator **r = res;
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index d17e1ff7ad01..1c88ce1aaa3f 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -40,6 +40,7 @@
 struct device;
 struct notifier_block;
 struct regmap;
+struct device_node;
 
 /*
  * Regulator operating modes.
@@ -162,14 +163,33 @@ struct regulator *__must_check regulator_get(struct device *dev,
 					     const char *id);
 struct regulator *__must_check devm_regulator_get(struct device *dev,
 					     const char *id);
+struct regulator *__must_check of_regulator_get(struct device *dev,
+						const char *id,
+						struct device_node *node);
+struct regulator *__must_check devm_of_regulator_get(struct device *dev,
+						const char *id,
+						struct device_node *node);
 struct regulator *__must_check regulator_get_exclusive(struct device *dev,
 						       const char *id);
 struct regulator *__must_check devm_regulator_get_exclusive(struct device *dev,
 							const char *id);
+struct regulator *__must_check of_regulator_get_exclusive(struct device *dev,
+						      const char *id,
+						      struct device_node *node);
+struct regulator *__must_check devm_of_regulator_get_exclusive(struct device *dev,
+						      const char *id,
+						      struct device_node *node);
 struct regulator *__must_check regulator_get_optional(struct device *dev,
 						      const char *id);
 struct regulator *__must_check devm_regulator_get_optional(struct device *dev,
 							   const char *id);
+struct regulator *__must_check of_regulator_get_optional(struct device *dev,
+						      const char *id,
+						      struct device_node *node);
+struct regulator *__must_check devm_of_regulator_get_optional(struct device *dev,
+						      const char *id,
+						      struct device_node *node);
+
 void regulator_put(struct regulator *regulator);
 void devm_regulator_put(struct regulator *regulator);
 
-- 
1.9.1

