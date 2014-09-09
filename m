Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaIIWYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:24:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59860 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaIIWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:24:10 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Tue,  9 Sep 2014 23:23:54 +0100
Message-Id: <1410301435-554-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] regulator: of: Provide simplified DT parsing method
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Currently regulator drivers which support DT all repeat very similar code
to supply a list of known regulator identifiers to be matched with DT,
convert that to platform data which is then matched up with the regulators
as they are registered. This is both fiddly to get right and for devices
which can use the standard helpers to provide their operations is the main
source of code in the driver.

Since this code is essentially identical for most drivers we can factor it
out into the core, moving the identifiers in the match table into the
regulator descriptors and also allowing drivers to pass in the name of the
subnode to search. When a driver provides an of_match string for the
regulator the core will attempt to use that to obtain init_data, allowing
the driver to remove all explicit code for DT parsing and simply provide
data instead.

The current code leaks the phandles for the child nodes, this will be
addressed incrementally and makes no practical difference for FDT anyway
as the DT data structures are never freed.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c         | 10 +++++---
 drivers/regulator/internal.h     |  4 ++++
 drivers/regulator/of_regulator.c | 51 ++++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |  4 ++++
 4 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b31d706..cd87c0c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3602,12 +3602,17 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		return ERR_PTR(-EINVAL);
 	}
 
-	init_data = config->init_data;
-
 	rdev = kzalloc(sizeof(struct regulator_dev), GFP_KERNEL);
 	if (rdev == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	init_data = regulator_of_get_init_data(dev, regulator_desc,
+					       &rdev->dev.of_node);
+	if (!init_data) {
+		init_data = config->init_data;
+		rdev->dev.of_node = of_node_get(config->of_node);
+	}
+
 	mutex_lock(&regulator_list_mutex);
 
 	mutex_init(&rdev->mutex);
@@ -3634,7 +3639,6 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
-	rdev->dev.of_node = of_node_get(config->of_node);
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%d",
 		     atomic_inc_return(&regulator_no) - 1);
diff --git a/drivers/regulator/internal.h b/drivers/regulator/internal.h
index 84bbda1..a6043ad 100644
--- a/drivers/regulator/internal.h
+++ b/drivers/regulator/internal.h
@@ -35,4 +35,8 @@ struct regulator {
 	struct dentry *debugfs;
 };
 
+struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
+			         const struct regulator_desc *desc,
+				 struct device_node **node);
+
 #endif
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index ee5e67b..7a51814 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -14,8 +14,11 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
 
+#include "internal.h"
+
 static void of_get_regulation_constraints(struct device_node *np,
 					struct regulator_init_data **init_data)
 {
@@ -189,3 +192,51 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 	return count;
 }
 EXPORT_SYMBOL_GPL(of_regulator_match);
+
+struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
+					    const struct regulator_desc *desc,
+					    struct device_node **node)
+{
+	struct device_node *search, *child;
+	struct regulator_init_data *init_data = NULL;
+	const char *name;
+
+	if (!dev->of_node || !desc->of_match)
+		return NULL;
+
+	if (desc->regulators_node)
+		search = of_get_child_by_name(dev->of_node,
+					      desc->regulators_node);
+	else
+		search = dev->of_node;
+
+	if (!search) {
+		dev_err(dev, "Failed to find regulator container node\n");
+		return NULL;
+	}
+
+	for_each_child_of_node(search, child) {
+		name = of_get_property(child, "regulator-compatible", NULL);
+		if (!name)
+			name = child->name;
+
+		if (strcmp(desc->of_match, name))
+			continue;
+
+		init_data = of_get_regulator_init_data(dev, child);
+		if (!init_data) {
+			dev_err(dev,
+				"failed to parse DT for regulator %s\n",
+				child->name);
+			break;
+		}
+
+		of_node_get(child);
+		*node = child;
+		break;
+	}
+
+	of_node_put(search);
+
+	return init_data;
+}
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 38b2f1a..fc0ee0c 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -203,6 +203,8 @@ enum regulator_type {
  *
  * @name: Identifying name for the regulator.
  * @supply_name: Identifying the regulator supply
+ * @of_match: Name used to identify regulator in DT.
+ * @regulators_node: Name of node containing regulator definitions in DT.
  * @id: Numerical identifier for the regulator.
  * @ops: Regulator operations table.
  * @irq: Interrupt number for the regulator.
@@ -245,6 +247,8 @@ enum regulator_type {
 struct regulator_desc {
 	const char *name;
 	const char *supply_name;
+	const char *of_match;
+	const char *regulators_node;
 	int id;
 	bool continuous_voltage_range;
 	unsigned n_voltages;
-- 
2.1.0

