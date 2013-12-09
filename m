Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881Ab3LIPKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:10:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:35255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab3LIPJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:09:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,858,1378882800"; 
   d="scan'208";a="441039572"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 1/5] phy: unify the phy name parameters
Date: Mon,  9 Dec 2013 17:08:53 +0200
Message-Id: <1386601737-8735-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace "string" and "port" that are used as phy name
parameter for various functions with "con_id" which is
commonly used in other frameworks.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/phy/phy-core.c  | 22 ++++++++++------------
 include/linux/phy/phy.h |  8 ++++----
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..1102aef 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -53,7 +53,7 @@ static int devm_phy_match(struct device *dev, void *res, void *match_data)
 	return res == match_data;
 }
 
-static struct phy *phy_lookup(struct device *device, const char *port)
+static struct phy *phy_lookup(struct device *device, const char *con_id)
 {
 	unsigned int count;
 	struct phy *phy;
@@ -68,7 +68,7 @@ static struct phy *phy_lookup(struct device *device, const char *port)
 		consumers = phy->init_data->consumers;
 		while (count--) {
 			if (!strcmp(consumers->dev_name, dev_name(device)) &&
-					!strcmp(consumers->port, port)) {
+					!strcmp(consumers->port, con_id)) {
 				class_dev_iter_exit(&iter);
 				return phy;
 			}
@@ -350,33 +350,32 @@ EXPORT_SYMBOL_GPL(of_phy_simple_xlate);
 /**
  * phy_get() - lookup and obtain a reference to a phy.
  * @dev: device that requests this phy
- * @string: the phy name as given in the dt data or the name of the controller
- * port for non-dt case
+ * @con_id: name of the phy from device's point of view
  *
  * Returns the phy driver, after getting a refcount to it; or
  * -ENODEV if there is no such phy.  The caller is responsible for
  * calling phy_put() to release that count.
  */
-struct phy *phy_get(struct device *dev, const char *string)
+struct phy *phy_get(struct device *dev, const char *con_id)
 {
 	int index = 0;
 	struct phy *phy = NULL;
 
-	if (string == NULL) {
+	if (con_id == NULL) {
 		dev_WARN(dev, "missing string\n");
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (dev->of_node) {
 		index = of_property_match_string(dev->of_node, "phy-names",
-			string);
+						 con_id);
 		phy = of_phy_get(dev, index);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "unable to find phy\n");
 			return phy;
 		}
 	} else {
-		phy = phy_lookup(dev, string);
+		phy = phy_lookup(dev, con_id);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "unable to find phy\n");
 			return phy;
@@ -395,14 +394,13 @@ EXPORT_SYMBOL_GPL(phy_get);
 /**
  * devm_phy_get() - lookup and obtain a reference to a phy.
  * @dev: device that requests this phy
- * @string: the phy name as given in the dt data or phy device name
- * for non-dt case
+ * @con_id: name of the phy from device's point of view
  *
  * Gets the phy using phy_get(), and associates a device with it using
  * devres. On driver detach, release function is invoked on the devres data,
  * then, devres data is freed.
  */
-struct phy *devm_phy_get(struct device *dev, const char *string)
+struct phy *devm_phy_get(struct device *dev, const char *con_id)
 {
 	struct phy **ptr, *phy;
 
@@ -410,7 +408,7 @@ struct phy *devm_phy_get(struct device *dev, const char *string)
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	phy = phy_get(dev, string);
+	phy = phy_get(dev, con_id);
 	if (!IS_ERR(phy)) {
 		*ptr = phy;
 		devres_add(dev, ptr);
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 6d72269..d67dcbf 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -127,8 +127,8 @@ int phy_init(struct phy *phy);
 int phy_exit(struct phy *phy);
 int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
-struct phy *phy_get(struct device *dev, const char *string);
-struct phy *devm_phy_get(struct device *dev, const char *string);
+struct phy *phy_get(struct device *dev, const char *con_id);
+struct phy *devm_phy_get(struct device *dev, const char *con_id);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_simple_xlate(struct device *dev,
@@ -199,12 +199,12 @@ static inline int phy_power_off(struct phy *phy)
 	return -ENOSYS;
 }
 
-static inline struct phy *phy_get(struct device *dev, const char *string)
+static inline struct phy *phy_get(struct device *dev, const char *con_id)
 {
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline struct phy *devm_phy_get(struct device *dev, const char *string)
+static inline struct phy *devm_phy_get(struct device *dev, const char *con_id)
 {
 	return ERR_PTR(-ENOSYS);
 }
-- 
1.8.5.1

