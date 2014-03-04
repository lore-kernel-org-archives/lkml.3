Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbaCDPZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:25:25 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41414 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188AbaCDPZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:25:21 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-2c-5315f05ff2ef
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu
Subject: [PATCH v7 1/4] phy: core: Add an exported of_phy_get function
Date: Tue, 04 Mar 2014 16:23:33 +0100
Message-id: <1393946616-20062-2-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393946616-20062-1-git-send-email-k.debski@samsung.com>
References: <1393946616-20062-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jAd34D6LBBpd7rCyW7L7BajH/yDlW
	i/43C1kt2q4cZLe4vPASq8WP1xfYLC487WGzONv0Bii2aw6bxYzz+5gsFi1rZbZYe+Quu8XZ
	/ttsFhObprFbnN/SyWRx+E07q8WE30Bt62e8ZrFoW/2B1aLj7EF2BxGPy329TB47Z91l97hz
	bQ+bx79j7B6z7/5g9OjbsorR4/iN7UwenzfJBXBEcdmkpOZklqUW6dslcGV8+DmFuWCtYsWC
	o6/ZGxi7pLsYOTkkBEwk/sx+zAhhi0lcuLeerYuRi0NIYBGjRMeaWywQTgeTxOWDr9i7GDk4
	2AQ0JVbd8wBpEBGokZhy6wo7SA2zQBezxIRtp9lAEsICbhI7f3exgtgsAqoSN1r3s4PYvAIu
	En8mrGUEmSMhoCAxZ5INSJhTwFVi7pfdYK1CQCWXPq1incDIu4CRYRWjaGpBckFxUnquoV5x
	Ym5xaV66XnJ+7iZGcMg/k9rBuLLB4hCjAAejEg/vjGkiwUKsiWXFlbmHGCU4mJVEeE1fiAYL
	8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYMxuLmg/+Wrq
	yRz1T/5vt/399CX2dubdTt+sgNTAu4x6z498L73rwqAjOVHV+6mP0IUN9y0eLcwwXfLt/rPn
	+oyLmBRirZ7xHpTMf7IoYC2zxbRLla+Tjf8pXNnZ7p6lY7JLt7h35jkLn5Plkhuv/nlfx277
	9Nv07J4VgScOq91cFzr58A+HjlNKLMUZiYZazEXFiQCfUZZpdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the of_phy_get function took a struct device * and
was declared static. It was impossible to call it from
another driver and thus it was impossible to get phy defined
for a given node. The old function was renamed to _of_phy_get
and was left for internal use. of_phy_get function was added
and it was exported. The function enables to get a phy for
a given device tree node.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/phy/phy-core.c  |   45 ++++++++++++++++++++++++++++++++++++---------
 include/linux/phy/phy.h |    6 ++++++
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 6c73837..7c1b0e1 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -274,8 +274,8 @@ int phy_power_off(struct phy *phy)
 EXPORT_SYMBOL_GPL(phy_power_off);
 
 /**
- * of_phy_get() - lookup and obtain a reference to a phy by phandle
- * @dev: device that requests this phy
+ * _of_phy_get() - lookup and obtain a reference to a phy by phandle
+ * @np: device_node for which to get the phy
  * @index: the index of the phy
  *
  * Returns the phy associated with the given phandle value,
@@ -284,20 +284,17 @@ EXPORT_SYMBOL_GPL(phy_power_off);
  * not yet loaded. This function uses of_xlate call back function provided
  * while registering the phy_provider to find the phy instance.
  */
-static struct phy *of_phy_get(struct device *dev, int index)
+static struct phy *_of_phy_get(struct device_node *np, int index)
 {
 	int ret;
 	struct phy_provider *phy_provider;
 	struct phy *phy = NULL;
 	struct of_phandle_args args;
 
-	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
+	ret = of_parse_phandle_with_args(np, "phys", "#phy-cells",
 		index, &args);
-	if (ret) {
-		dev_dbg(dev, "failed to get phy in %s node\n",
-			dev->of_node->full_name);
+	if (ret)
 		return ERR_PTR(-ENODEV);
-	}
 
 	mutex_lock(&phy_provider_mutex);
 	phy_provider = of_phy_provider_lookup(args.np);
@@ -317,6 +314,36 @@ err0:
 }
 
 /**
+ * of_phy_get() - lookup and obtain a reference to a phy using a device_node.
+ * @np: device_node for which to get the phy
+ * @con_id: name of the phy from device's point of view
+ *
+ * Returns the phy driver, after getting a refcount to it; or
+ * -ENODEV if there is no such phy. The caller is responsible for
+ * calling phy_put() to release that count.
+ */
+struct phy *of_phy_get(struct device_node *np, const char *con_id)
+{
+	struct phy *phy = NULL;
+	int index = 0;
+
+	if (con_id)
+		index = of_property_match_string(np, "phy-names", con_id);
+
+	phy = _of_phy_get(np, index);
+	if (IS_ERR(phy))
+		return phy;
+
+	if (!try_module_get(phy->ops->owner))
+		return ERR_PTR(-EPROBE_DEFER);
+
+	get_device(&phy->dev);
+
+	return phy;
+}
+EXPORT_SYMBOL_GPL(of_phy_get);
+
+/**
  * phy_put() - release the PHY
  * @phy: the phy returned by phy_get()
  *
@@ -407,7 +434,7 @@ struct phy *phy_get(struct device *dev, const char *string)
 	if (dev->of_node) {
 		index = of_property_match_string(dev->of_node, "phy-names",
 			string);
-		phy = of_phy_get(dev, index);
+		phy = _of_phy_get(dev->of_node, index);
 	} else {
 		phy = phy_lookup(dev, string);
 	}
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 3f83459..2fe3194 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -151,6 +151,7 @@ struct phy *devm_phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_optional_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
+struct phy *of_phy_get(struct device_node *np, const char *con_id);
 struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args);
 struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
@@ -259,6 +260,11 @@ static inline void devm_phy_put(struct device *dev, struct phy *phy)
 {
 }
 
+struct phy *of_phy_get(struct device_node *np, const char *con_id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args)
 {
-- 
1.7.9.5

