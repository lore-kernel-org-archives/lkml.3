Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3BUXKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:10:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9644 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3BUXKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:10:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Feb 2013 15:05:50 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: <linux-tegra@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [RFC v2 2/3] power: power_supply: Add core support for supplied_nodes
Date: Thu, 21 Feb 2013 18:11:11 -0500
Message-ID: <1361488272-21010-3-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361488272-21010-1-git-send-email-rklein@nvidia.com>
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the growing support for dt, it make sense to try to make use of
dt features to make the general code cleaner. This patch is an
attempt to commonize how chargers and their supplies are linked.

Following common dt convention, the "supplied-to" char** list is
replaced with phandle lists defined in the supplies which contain
phandles of their suppliers.

This has the effect however of introducing an inversion in the internal
mechanics of how this information is stored. In the case of non-dt,
the char** list of supplies is stored in the charger. In the dt case,
a device_node * list is stored in the supplies of their chargers,
however this seems to be the only way to support this.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v2:
  - Changed from struct device_node* contained in suppliers to a list stored
    in the supplies.
  - changed logic for the is_supplied_by check to handle the entire loop
    as the array structure is different between the 2 paths.

 drivers/power/power_supply_core.c |   46 +++++++++++++++++++++++++++----------
 include/linux/power_supply.h      |    9 ++++++++
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 8a7cfb3..a87c5b8 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -26,17 +26,40 @@ EXPORT_SYMBOL_GPL(power_supply_class);
 
 static struct device_type power_supply_dev_type;
 
+static int __power_supply_is_supplied_by(struct power_supply *supplier,
+					 struct power_supply *supply)
+{
+	int i;
+#ifdef CONFIG_OF
+	struct power_supply_supplies *pss;
+#endif
+
+#ifdef CONFIG_OF
+	list_for_each_entry(pss, &supply->supplies.list, list) {
+		if (supplier->supplies.node == pss->node)
+			return 0;
+	}
+#endif
+
+	for (i = 0; i < supplier->num_supplicants; i++) {
+		if (!supply->name || !supplier->supplied_to)
+			continue;
+		if (!strcmp(supplier->supplied_to[i], supply->name))
+			return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int __power_supply_changed_work(struct device *dev, void *data)
 {
 	struct power_supply *psy = (struct power_supply *)data;
 	struct power_supply *pst = dev_get_drvdata(dev);
-	int i;
 
-	for (i = 0; i < psy->num_supplicants; i++)
-		if (!strcmp(psy->supplied_to[i], pst->name)) {
-			if (pst->external_power_changed)
-				pst->external_power_changed(pst);
-		}
+	if (__power_supply_is_supplied_by(psy, pst)) {
+		if (pst->external_power_changed)
+			pst->external_power_changed(pst);
+	}
 	return 0;
 }
 
@@ -68,13 +91,9 @@ static int __power_supply_am_i_supplied(struct device *dev, void *data)
 	union power_supply_propval ret = {0,};
 	struct power_supply *psy = (struct power_supply *)data;
 	struct power_supply *epsy = dev_get_drvdata(dev);
-	int i;
 
-	for (i = 0; i < epsy->num_supplicants; i++) {
-		if (!strcmp(epsy->supplied_to[i], psy->name)) {
-			if (epsy->get_property(epsy,
-				  POWER_SUPPLY_PROP_ONLINE, &ret))
-				continue;
+	if (__power_supply_is_supplied_by(epsy, psy)) {
+		if (!epsy->get_property(epsy, POWER_SUPPLY_PROP_ONLINE, &ret)) {
 			if (ret.intval)
 				return ret.intval;
 		}
@@ -334,6 +353,9 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	dev_set_drvdata(dev, psy);
 	psy->dev = dev;
 
+#ifdef CONFIG_OF
+	INIT_LIST_HEAD(&psy->supplies.list);
+#endif
 	INIT_WORK(&psy->changed_work, power_supply_changed_work);
 
 	rc = kobject_set_name(&dev->kobj, "%s", psy->name);
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 1f0ab90..d16f6ab 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -15,6 +15,7 @@
 
 #include <linux/workqueue.h>
 #include <linux/leds.h>
+#include <linux/list.h>
 
 struct device;
 
@@ -160,12 +161,20 @@ union power_supply_propval {
 	const char *strval;
 };
 
+struct power_supply_supplies {
+	struct device_node *node;
+	struct list_head list;
+};
+
 struct power_supply {
 	const char *name;
 	enum power_supply_type type;
 	enum power_supply_property *properties;
 	size_t num_properties;
 
+#ifdef CONFIG_OF
+	struct power_supply_supplies supplies;
+#endif
 	char **supplied_to;
 	size_t num_supplicants;
 
-- 
1.7.9.5

