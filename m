Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab3DAVpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:45:46 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16202 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3DAVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:45:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 01 Apr 2013 14:45:03 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, Grant Likely <grant.likely@secretlab.ca>
CC: David Woodhouse <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH V2 2/3] power: power_supply: Add core support for supplied_from
Date: Mon, 1 Apr 2013 17:45:54 -0400
Message-ID: <1364852755-17425-3-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364852755-17425-1-git-send-email-rklein@nvidia.com>
References: <1364852755-17425-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for supplies to register a list of char *'s
which represent the list of supplies which supply them. This is the
opposite as the supplied_to list.

This change maintains support for supplied_to until all drivers which
make use of it already are converted.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v2:
 - changed __power_supply_is_supplied_by to a boolean function
 - fixed up return paths with correct return values
 - moved loop invariant checks outside of loops

v1:
 - changed from RFC v2 -> patch v1
 - removed list logic and instead added supplied_from char ** array and
   num_supplies field

v2 (RFC):
 - changed from struct device_node * contained in suppliers to a list
   stored in the supplies.
 - changed logic for the is_supplied_by check to handle the entire loop
   as the array structure is difference between the 2 paths.

 drivers/power/power_supply_core.c |   47 +++++++++++++++++++++++++++----------
 include/linux/power_supply.h      |    3 +++
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 5deac43..d843cc9 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -26,17 +26,42 @@ EXPORT_SYMBOL_GPL(power_supply_class);
 
 static struct device_type power_supply_dev_type;
 
+static bool __power_supply_is_supplied_by(struct power_supply *supplier,
+					 struct power_supply *supply)
+{
+	int i;
+
+	if (!supply->supplied_from && !supplier->supplied_to)
+		return false;
+
+	/* Support both supplied_to and supplied_from modes */
+	if (supply->supplied_from) {
+		if (!supplier->name)
+			return false;
+		for (i = 0; i < supply->num_supplies; i++)
+			if (!strcmp(supplier->name, supply->supplied_from[i]))
+				return true;
+	} else {
+		if (!supply->name)
+			return false;
+		for (i = 0; i < supplier->num_supplicants; i++)
+			if (!strcmp(supplier->supplied_to[i], supply->name))
+				return true;
+	}
+
+	return false;
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
+
 	return 0;
 }
 
@@ -68,17 +93,13 @@ static int __power_supply_am_i_supplied(struct device *dev, void *data)
 	union power_supply_propval ret = {0,};
 	struct power_supply *psy = (struct power_supply *)data;
 	struct power_supply *epsy = dev_get_drvdata(dev);
-	int i;
 
-	for (i = 0; i < epsy->num_supplicants; i++) {
-		if (!strcmp(epsy->supplied_to[i], psy->name)) {
-			if (epsy->get_property(epsy,
-				  POWER_SUPPLY_PROP_ONLINE, &ret))
-				continue;
+	if (__power_supply_is_supplied_by(epsy, psy))
+		if (!epsy->get_property(epsy, POWER_SUPPLY_PROP_ONLINE, &ret)) {
 			if (ret.intval)
 				return ret.intval;
 		}
-	}
+
 	return 0;
 }
 
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 002a99f..c1cbd5e 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -171,6 +171,9 @@ struct power_supply {
 	char **supplied_to;
 	size_t num_supplicants;
 
+	char **supplied_from;
+	size_t num_supplies;
+
 	int (*get_property)(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val);
-- 
1.7.9.5

