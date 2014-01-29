Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaA2RaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:30:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54945 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaA2R3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:29:55 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-92-52e93a92271c
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
Subject: [PATCH v6 1/8] phy: core: Add an exported of_phy_get function
Date: Wed, 29 Jan 2014 18:29:27 +0100
Message-id: <1391016574-25237-2-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
References: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9jAd1JVi+DDKZ2CFgs2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJv4Ha1s94zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7nHn
	2h42j3/H2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst0rdL4MqYedCqYJ9iReeb
	XWwNjFOluxg5OCQETCR+zrXpYuQEMsUkLtxbz9bFyMUhJLCIUaLtxGVWkISQQAeTxLNJCSD1
	bAKaEqvueYCERQRqJKbcusIOUs8s0MUsMWHbaTaQhLCAm8TLRT9ZQGwWAVWJqR9amEFsXgEX
	ifaP25gg9ipIzJkEtpdTwFWiY8ZFNohVLhKre9awTWDkXcDIsIpRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjONifSe1gXNlgcYhRgINRiYd3xcXnQUKsiWXFlbmHGCU4mJVEeKMMXwYJ8aYk
	VlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYJTr9FvVzb8h9uSy
	Wf5fuT9ZND6c1W51d+Pudf8fFbAHak9ieLrM1jRBVOb67Dg2j3W8gdcSLvZ5S+kVcAs5P/g9
	JcKdQUHCZ8tC/lOcv6YtvCkdvzogUH7bxfUbky+wHXt8Jl8w/ITqIzHnhtM6a22ueIhs7tpz
	IiV5s+/R2XzKDe/ruPYEvldiKc5INNRiLipOBACpuTi0cgIAAA==
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
index 645c867..a1d4387 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -258,8 +258,8 @@ int phy_power_off(struct phy *phy)
 EXPORT_SYMBOL_GPL(phy_power_off);
 
 /**
- * of_phy_get() - lookup and obtain a reference to a phy by phandle
- * @dev: device that requests this phy
+ * _of_phy_get() - lookup and obtain a reference to a phy by phandle
+ * @np: device_node for which to get the phy
  * @index: the index of the phy
  *
  * Returns the phy associated with the given phandle value,
@@ -268,20 +268,17 @@ EXPORT_SYMBOL_GPL(phy_power_off);
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
@@ -301,6 +298,36 @@ err0:
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
@@ -388,7 +415,7 @@ struct phy *phy_get(struct device *dev, const char *string)
 	if (dev->of_node) {
 		index = of_property_match_string(dev->of_node, "phy-names",
 			string);
-		phy = of_phy_get(dev, index);
+		phy = _of_phy_get(dev->of_node, index);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "unable to find phy\n");
 			return phy;
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index e273e5a..5cffc69 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -149,6 +149,7 @@ struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
+struct phy *of_phy_get(struct device_node *np, const char *con_id);
 struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args);
 struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
@@ -245,6 +246,11 @@ static inline void devm_phy_put(struct device *dev, struct phy *phy)
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

