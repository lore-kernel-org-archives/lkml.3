Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab3LIPJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:09:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:35255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933656Ab3LIPJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:09:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,858,1378882800"; 
   d="scan'208";a="441039601"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 3/5] phy: improved lookup method
Date: Mon,  9 Dec 2013 17:08:55 +0200
Message-Id: <1386601737-8735-4-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the need for the phys to be aware of their users
even when not using DT. The method is copied from gpiolib.c.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/phy/phy-core.c  | 91 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/phy/phy.h | 48 ++++++++++++++++++++++++++
 2 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 99dc046..05792d0 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -25,6 +25,7 @@
 static struct class *phy_class;
 static DEFINE_MUTEX(phy_provider_mutex);
 static LIST_HEAD(phy_provider_list);
+static LIST_HEAD(phy_lookup_list);
 static DEFINE_IDA(phy_ida);
 
 static void devm_phy_release(struct device *dev, void *res)
@@ -85,6 +86,94 @@ static struct phy *phy_lookup(struct device *device, const char *con_id,
 	return ERR_PTR(-ENODEV);
 }
 
+/**
+ * phy_add_table() - register PHY/device association to the lookup list
+ * @table: association to register
+ */
+void phy_add_lookup_table(struct phy_lookup_table *table)
+{
+	mutex_lock(&phy_provider_mutex);
+	list_add_tail(&table->list, &phy_lookup_list);
+	mutex_unlock(&phy_provider_mutex);
+}
+
+/**
+ * phy_add_table() - remove PHY/device association from the lookup list
+ * @table: association to be removed
+ */
+void phy_del_lookup_table(struct phy_lookup_table *table)
+{
+	mutex_lock(&phy_provider_mutex);
+	list_del(&table->list);
+	mutex_unlock(&phy_provider_mutex);
+}
+
+static struct phy *find_phy_by_name(const char *name)
+{
+	struct class_dev_iter iter;
+	struct phy *phy = NULL;
+	struct device *dev;
+
+	class_dev_iter_init(&iter, phy_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(&iter))) {
+		if (!strcmp(dev_name(dev), name)) {
+			phy = to_phy(dev);
+			break;
+		}
+	}
+	class_dev_iter_exit(&iter);
+
+	return phy;
+}
+
+static struct phy_lookup_table *phy_get_lookup_table(struct device *dev)
+{
+	const char *dev_id = dev ? dev_name(dev) : NULL;
+	struct phy_lookup_table *table;
+
+	mutex_lock(&phy_provider_mutex);
+	list_for_each_entry(table, &phy_lookup_list, list)
+		if (!strcmp(table->dev_id, dev_id))
+			goto out;
+	table = NULL;
+out:
+	mutex_unlock(&phy_provider_mutex);
+	return table;
+}
+
+static struct phy *phy_find(struct device *dev, const char *con_id,
+			    unsigned int idx)
+{
+	struct phy_lookup_table *table;
+	struct phy_lookup *p;
+	struct phy *phy;
+
+	table = phy_get_lookup_table(dev);
+	if (!table)
+		/* fall-back to the old lookup method for now */
+		return phy_lookup(dev, con_id, idx);
+
+	for (p = &table->table[0]; p->phy_name; p++) {
+		/* index must always match exactly */
+		if (idx != p->idx)
+			continue;
+
+		/* If the lookup entry has a con_id, require exact match */
+		if (p->con_id && (!con_id || strcmp(p->con_id, con_id)))
+			continue;
+
+		phy = find_phy_by_name(p->phy_name);
+		if (!phy) {
+			dev_warn(dev, "no PHY by the name %s\n", p->phy_name);
+			return ERR_PTR(-ENODEV);
+		}
+
+		return phy;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
 static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
 {
 	struct phy_provider *phy_provider;
@@ -386,7 +475,7 @@ struct phy *phy_get_index(struct device *dev, const char *con_id,
 	 */
 	if (!phy || IS_ERR(phy)) {
 		dev_dbg(dev, "using lookup tables for PHY lookup");
-		phy = phy_lookup(dev, con_id, idx);
+		phy = phy_find(dev, con_id, idx);
 	}
 
 	if (IS_ERR(phy)) {
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 43d1a23..cca363a 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -98,6 +98,54 @@ struct phy_init_data {
 	.port		= _port,				\
 }
 
+/**
+ * struct phy_lookup - Lookup entry for associating PHYs
+ * @phy_name: device name of the PHY
+ * @con_id: name of the PHY from device's point of view
+ * @idx: index of the PHY when name is not used
+ */
+struct phy_lookup {
+	const char *phy_name;
+	const char *con_id;
+	unsigned int idx;
+};
+
+/**
+ * struct phy_lookup_table - association of PHYs to specific device
+ * @list: entry in the lookup list
+ * @dev_id: the name of the device
+ * @table: table of PHYs attached to this device
+ */
+struct phy_lookup_table {
+	struct list_head list;
+	const char *dev_id;
+	struct phy_lookup table[];
+};
+
+/**
+ * Simple definition of a single PHY under a consumer
+ */
+#define PHY_LOOKUP(_phy_name, _con_id)		\
+{						\
+	PHY_LOOKUP_IDX(_phy_name, _con_id, 0),	\
+	{ },					\
+}
+
+/**
+ * Use this macro if you need to have several PHYs under the same con_id.
+ * Each PHY needs to use a different index and can be accessed using
+ * phy_get_index()
+ */
+#define PHY_LOOKUP_IDX(_phy_name, _con_id, _idx)	\
+{							\
+	.phy_name = _phy_name,				\
+	.con_id = _con_id,				\
+	.idx = _idx,					\
+}
+
+void phy_add_lookup_table(struct phy_lookup_table *);
+void phy_del_lookup_table(struct phy_lookup_table *);
+
 #define	to_phy(dev)	(container_of((dev), struct phy, dev))
 
 #define	of_phy_provider_register(dev, xlate)	\
-- 
1.8.5.1

