Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3BOXgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:36:38 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13348 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3BOXgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:36:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 15 Feb 2013 15:35:24 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [RFC 3/3] power: power_supply: add support for getting supplied-nodes from dt
Date: Fri, 15 Feb 2013 18:36:56 -0500
Message-ID: <1360971416-30717-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360971416-30717-1-git-send-email-rklein@nvidia.com>
References: <1360971416-30717-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of the device_nodes to use similar to how
supplied_to works, add a helper function which will parse out the
phandles for the supplied-nodes directly from the node. This
implmentation requires the property name to be "supplied-nodes".

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/power_supply_core.c |   57 +++++++++++++++++++++++++++++++++++++
 include/linux/power_supply.h      |    6 ++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 9e42702..4bc682b 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -84,6 +84,63 @@ void power_supply_changed(struct power_supply *psy)
 }
 EXPORT_SYMBOL_GPL(power_supply_changed);
 
+#ifdef CONFIG_OF
+#include <linux/of.h>
+
+static int __power_supply_get_supplied_nodes(struct device *dev,
+					     struct device_node *np,
+					     struct device_node **supplicants,
+					     int *count)
+{
+	int i = 0;
+	int num_nodes = 0;
+	struct device_node *node;
+
+	do {
+		node = of_parse_phandle(np, "power-supply,supplied-nodes", i++);
+		if (node)
+			num_nodes++;
+	} while (node);
+
+	if (!num_nodes) {
+		dev_warn(dev, "No supplicant phandles found.\n");
+		return -EINVAL;
+	}
+
+	*supplicants = devm_kzalloc(dev, sizeof(struct device_node *) *
+				    num_nodes, GFP_KERNEL);
+
+	if (!*supplicants) {
+		dev_err(dev, "Failed allocation for memory for supplicants\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < num_nodes; i++)
+		supplicants[i] = of_parse_phandle(np,
+					"power-supply,supplied-nodes", i);
+
+	*count = num_nodes;
+
+	return 0;
+}
+
+int power_supply_get_supplied_nodes(struct device *dev,
+				    struct device_node *np,
+				    struct device_node **supplicants,
+				    int *count)
+{
+	int error;
+
+	if (!np || !supplicants)
+		return -EINVAL;
+
+	error = __power_supply_get_supplied_nodes(dev, np, supplicants, count);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(power_supply_get_supplied_nodes);
+#endif
+
 static int __power_supply_am_i_supplied(struct device *dev, void *data)
 {
 	union power_supply_propval ret = {0,};
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 8c8693b..359335a 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -230,6 +230,12 @@ struct power_supply_info {
 
 extern struct power_supply *power_supply_get_by_name(char *name);
 extern void power_supply_changed(struct power_supply *psy);
+#ifdef CONFIG_OF
+extern int power_supply_get_supplied_nodes(struct device *dev,
+					   struct device_node *np,
+					   struct device_node **supplicants,
+					   int *count);
+#endif
 extern int power_supply_am_i_supplied(struct power_supply *psy);
 extern int power_supply_set_battery_charged(struct power_supply *psy);
 
-- 
1.7.9.5

