Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab3CDULp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:11:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10212 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab3CDULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:11:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Mar 2013 12:11:17 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Anton Vorontsov <cbou@mail.ru>
CC: David Woodhouse <dwmw2@infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [Patch v1 3/3] power: power_supply_core: Add support for supplied_from
Date: Mon, 4 Mar 2013 15:11:58 -0500
Message-ID: <1362427918-14504-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362427918-14504-1-git-send-email-rklein@nvidia.com>
References: <1362427918-14504-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for supplied_from char * array. This is meant to store the
list of suppliers for a given supply, i.e. chargers for a battery. This
list can be populated through devicetree readily as well as passed
directly from the driver.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v1:
 - Changed from RFC v2 -> patch v1
 - removed list logic, added logic to first verify all supplies are
   present and defer probe until they are.
 - after all devices are registered, populate the char ** supplied_from
   array which simulates the case of dt not being used.
 - added of_node element to struct power_supply

v2 (RFC):
  - Simplified and renamed the logic to parse dt for the charger list.
  - Tied the dt parsing directly to power_supply_register to make fewer
    changes required for converting existing chargers/supplies.

 drivers/power/power_supply_core.c |  138 +++++++++++++++++++++++++++++++++++++
 include/linux/power_supply.h      |    3 +
 2 files changed, 141 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index dd675ae..c16666c 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -90,6 +90,133 @@ void power_supply_changed(struct power_supply *psy)
 }
 EXPORT_SYMBOL_GPL(power_supply_changed);
 
+#ifdef CONFIG_OF
+#include <linux/of.h>
+
+static int __power_supply_populate_supplied_from(struct device *dev,
+						 void *data)
+{
+	struct power_supply *psy = (struct power_supply *)data;
+	struct power_supply *epsy = dev_get_drvdata(dev);
+	struct device_node *np;
+	int i = 0;
+
+	do {
+		np = of_parse_phandle(psy->of_node, "power-supplies", i++);
+		if (!np)
+			continue;
+
+		if (np == epsy->of_node) {
+			dev_info(psy->dev, "%s: Found supply : %s\n",
+				psy->name, epsy->name);
+			psy->supplied_from[i-1] = (char *)epsy->name;
+			psy->num_supplies++;
+			break;
+		}
+	} while (np);
+
+	return 0;
+}
+
+int power_supply_populate_supplied_from(struct power_supply *psy)
+{
+	int error;
+
+	error = class_for_each_device(power_supply_class, NULL, psy,
+				      __power_supply_populate_supplied_from);
+
+	dev_dbg(psy->dev, "%s %d\n", __func__, error);
+
+	return error;
+}
+
+static int  __power_supply_find_supply_from_node(struct device *dev,
+						 void *data)
+{
+	struct device_node *np = (struct device_node *)data;
+	struct power_supply *epsy = dev_get_drvdata(dev);
+
+	/* return error breaks out of class_for_each_device loop */
+	if (epsy->of_node == np)
+		return -EINVAL;
+
+	return 0;
+}
+
+int power_supply_find_supply_from_node(struct device_node *supply_node)
+{
+	int error;
+	struct device *dev;
+	struct class_dev_iter iter;
+
+	/* Use iterator to see if any other device is registered.
+	 * This is required since class_for_each_device returns 0
+	 * if there are no devices registered.
+	 */
+	class_dev_iter_init(&iter, power_supply_class, NULL, NULL);
+	dev = class_dev_iter_next(&iter);
+
+	if (!dev)
+		return -EPROBE_DEFER;
+
+	/* we have to treat the return value as inverted, because if
+	 * we return error on not found, then it won't continue looking.
+	 * So we trick it by returning error on success to stop looking
+	 * once the matching device is found.
+	 */
+	error = class_for_each_device(power_supply_class, NULL, supply_node,
+				       __power_supply_find_supply_from_node);
+
+	return error ? 0 : -EPROBE_DEFER;
+}
+
+int power_supply_check_supplies(struct power_supply *psy)
+{
+	struct device_node *np;
+	int cnt = 0;
+	int ret = 0;
+
+	/* If there is already a list honor it */
+	if (psy->supplied_from && psy->num_supplies > 0)
+		return 0;
+
+	/* No device node found, nothing to do */
+	if (!psy->of_node)
+		return 0;
+
+	do {
+		np = of_parse_phandle(psy->of_node, "power-supplies", cnt++);
+		if (!np)
+			continue;
+
+		ret = power_supply_find_supply_from_node(np);
+		if (ret) {
+			dev_dbg(psy->dev, "Failed to find supply, defer!\n");
+			return -EPROBE_DEFER;
+		}
+	} while (np);
+
+	/* All supplies found, allocate char ** array for filling */
+	psy->supplied_from = devm_kzalloc(psy->dev, sizeof(psy->supplied_from),
+					  GFP_KERNEL);
+	if (!psy->supplied_from) {
+		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
+		return -ENOMEM;
+	}
+
+	*psy->supplied_from = devm_kzalloc(psy->dev, sizeof(char *) * cnt,
+					   GFP_KERNEL);
+	if (!*psy->supplied_from) {
+		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
+		return -ENOMEM;
+	}
+
+	ret = power_supply_populate_supplied_from(psy);
+
+	return ret;
+}
+#endif
+
 static int __power_supply_am_i_supplied(struct device *dev, void *data)
 {
 	union power_supply_propval ret = {0,};
@@ -359,6 +486,14 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 
 	INIT_WORK(&psy->changed_work, power_supply_changed_work);
 
+#ifdef CONFIG_OF
+	rc = power_supply_check_supplies(psy);
+	if (rc) {
+		dev_info(dev, "Not all required supplies found, defer probe\n");
+		goto check_supplies_failed;
+	}
+#endif
+
 	rc = kobject_set_name(&dev->kobj, "%s", psy->name);
 	if (rc)
 		goto kobject_set_name_failed;
@@ -391,6 +526,9 @@ register_thermal_failed:
 	device_del(dev);
 kobject_set_name_failed:
 device_add_failed:
+#ifdef CONFIG_OF
+check_supplies_failed:
+#endif
 	put_device(dev);
 success:
 	return rc;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index c1cbd5e..3828cef 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -173,6 +173,9 @@ struct power_supply {
 
 	char **supplied_from;
 	size_t num_supplies;
+#ifdef CONFIG_OF
+	struct device_node *of_node;
+#endif
 
 	int (*get_property)(struct power_supply *psy,
 			    enum power_supply_property psp,
-- 
1.7.9.5

