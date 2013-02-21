Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab3BUXLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:11:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9647 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab3BUXKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:10:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 21 Feb 2013 15:09:12 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: <linux-tegra@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [RFC v2 3/3] power: power_supply: add support for getting supplied-nodes from dt
Date: Thu, 21 Feb 2013 18:11:12 -0500
Message-ID: <1361488272-21010-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361488272-21010-1-git-send-email-rklein@nvidia.com>
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of the device_nodes to use to link suppliers and
supplicants, its useful to add logic to handle the creation of
the list in a common place so as to be common for all drivers.

As of now, as long as the supply's device_node is supplied, the core
will attempt to parse the list of supplies and store it in the
power_supply structure. In this way, it shouldn't break existing
drivers, but allow for transition cleanly.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v2:
  - Simplified and renamed the logic to parse dt for the charger list.
  - Tied the dt parsing directly to power_supply_register to make fewer
    changes required for converting existing chargers/supplies.

 drivers/power/power_supply_core.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index a87c5b8..05e2031 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -86,6 +86,39 @@ void power_supply_changed(struct power_supply *psy)
 }
 EXPORT_SYMBOL_GPL(power_supply_changed);
 
+#ifdef CONFIG_OF
+#include <linux/of.h>
+
+int power_supply_register_supplicant(struct power_supply *psy)
+{
+	struct device_node *np;
+	int i = 0;
+
+	if (!psy->supplies.node)
+		return -EINVAL;
+
+	do {
+		struct power_supply_supplies *lst;
+
+		np = of_parse_phandle(psy->supplies.node, "power-supply", i++);
+		if (!np)
+			continue;
+
+		lst = devm_kzalloc(psy->dev->parent, sizeof(*lst), GFP_KERNEL);
+		if (!lst) {
+			dev_warn(psy->dev->parent,
+				 "Failed to alloc mem for supplies list\n");
+			return -ENOMEM;
+		}
+
+		lst->node = np;
+		list_add(&(lst->list), &(psy->supplies.list));
+	} while (np);
+
+	return 0;
+}
+#endif
+
 static int __power_supply_am_i_supplied(struct device *dev, void *data)
 {
 	union power_supply_propval ret = {0,};
@@ -355,6 +388,8 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 
 #ifdef CONFIG_OF
 	INIT_LIST_HEAD(&psy->supplies.list);
+
+	power_supply_register_supplicant(psy);
 #endif
 	INIT_WORK(&psy->changed_work, power_supply_changed_work);
 
-- 
1.7.9.5

