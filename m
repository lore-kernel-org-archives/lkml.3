Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3BOXgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:36:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1319 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3BOXge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:36:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 15 Feb 2013 15:36:29 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [RFC 2/3] power: power_supply: Add core support for supplied_nodes
Date: Fri, 15 Feb 2013 18:36:55 -0500
Message-ID: <1360971416-30717-3-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360971416-30717-1-git-send-email-rklein@nvidia.com>
References: <1360971416-30717-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the growing support for dt, it make sense to try to make sure of
dt features as to make the general code cleaner. This patch is an
attempt to commonize how chargers receive their "supplied_to" list
of supplicants. This was previously done via passing an array of
strings.

Currently, charger drivers that make use of the supplicant list, do
so using custom private dt mechanisms, this will should make a common
implementation that all can use.

With device tree, it is much cleaner to instead use a list of phandles
in the device tree to point directly to the supplicants thus ensuring
a proper reference without having to hard code in names.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/power_supply_core.c |   25 +++++++++++++++++++++++--
 include/linux/power_supply.h      |    4 ++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 8a7cfb3..9e42702 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -26,6 +26,27 @@ EXPORT_SYMBOL_GPL(power_supply_class);
 
 static struct device_type power_supply_dev_type;
 
+static int __power_supply_is_supplied_by(struct power_supply *psy1,
+					 struct power_supply *psy2,
+					 int supply_idx)
+{
+
+	if (supply_idx < 0)
+		return -EINVAL;
+
+#ifdef CONFIG_OF
+	if (psy2->node && psy1->supplied_nodes)
+		if (psy1->supplied_nodes[supply_idx] == psy2->node)
+			return 0;
+#endif
+
+	if (psy2->name && psy1->supplied_to)
+		if (!strcmp(psy1->supplied_to[supply_idx], psy2->name))
+			return 0;
+
+	return -EINVAL;
+}
+
 static int __power_supply_changed_work(struct device *dev, void *data)
 {
 	struct power_supply *psy = (struct power_supply *)data;
@@ -33,7 +54,7 @@ static int __power_supply_changed_work(struct device *dev, void *data)
 	int i;
 
 	for (i = 0; i < psy->num_supplicants; i++)
-		if (!strcmp(psy->supplied_to[i], pst->name)) {
+		if (__power_supply_is_supplied_by(psy, pst, i)) {
 			if (pst->external_power_changed)
 				pst->external_power_changed(pst);
 		}
@@ -71,7 +92,7 @@ static int __power_supply_am_i_supplied(struct device *dev, void *data)
 	int i;
 
 	for (i = 0; i < epsy->num_supplicants; i++) {
-		if (!strcmp(epsy->supplied_to[i], psy->name)) {
+		if (__power_supply_is_supplied_by(epsy, psy, i)) {
 			if (epsy->get_property(epsy,
 				  POWER_SUPPLY_PROP_ONLINE, &ret))
 				continue;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 1f0ab90..8c8693b 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -166,6 +166,10 @@ struct power_supply {
 	enum power_supply_property *properties;
 	size_t num_properties;
 
+#ifdef CONFIG_OF
+	struct device_node *node;
+	struct device_node **supplied_nodes;
+#endif
 	char **supplied_to;
 	size_t num_supplicants;
 
-- 
1.7.9.5

