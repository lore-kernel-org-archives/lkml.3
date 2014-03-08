Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaCHJfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:35:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42988 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbaCHJ3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:29:53 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/28] phy: core: Add devm_of_phy_get to phy-core
Date: Sat, 8 Mar 2014 14:59:14 +0530
Message-ID: <1394270969-11851-14-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamil Debski <k.debski@samsung.com>

Adding devm_of_phy_get will allow to get phys by supplying a
pointer to the struct device_node instead of struct device.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |    9 +++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 7c1b0e1..623b71c 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -526,6 +526,37 @@ struct phy *devm_phy_optional_get(struct device *dev, const char *string)
 EXPORT_SYMBOL_GPL(devm_phy_optional_get);
 
 /**
+ * devm_of_phy_get() - lookup and obtain a reference to a phy.
+ * @dev: device that requests this phy
+ * @np: node containing the phy
+ * @con_id: name of the phy from device's point of view
+ *
+ * Gets the phy using of_phy_get(), and associates a device with it using
+ * devres. On driver detach, release function is invoked on the devres data,
+ * then, devres data is freed.
+ */
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+			    const char *con_id)
+{
+	struct phy **ptr, *phy;
+
+	ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	phy = of_phy_get(np, con_id);
+	if (!IS_ERR(phy)) {
+		*ptr = phy;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return phy;
+}
+EXPORT_SYMBOL_GPL(devm_of_phy_get);
+
+/**
  * phy_create() - create a new phy
  * @dev: device that is creating the new phy
  * @ops: function pointers for performing phy operations
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 50c7629..e2f5ca9 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -149,6 +149,8 @@ struct phy *phy_get(struct device *dev, const char *string);
 struct phy *phy_optional_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_optional_get(struct device *dev, const char *string);
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+			    const char *con_id);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_get(struct device_node *np, const char *con_id);
@@ -252,6 +254,13 @@ static inline struct phy *devm_phy_optional_get(struct device *dev,
 	return ERR_PTR(-ENOSYS);
 }
 
+static inline struct phy *devm_of_phy_get(struct device *dev,
+					  struct device_node *np,
+					  const char *con_id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline void phy_put(struct phy *phy)
 {
 }
-- 
1.7.9.5

