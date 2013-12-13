Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3LMODP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:03:15 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30523 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3LMODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:03:13 -0500
X-AuditID: cbfee61a-b7f7e6d000005936-e6-52ab13a0f27c
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kishon@ti.com, t.figa@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, matt.porter@linaro.org, k.debski@samsung.com
Subject: [PATCH RESEND v2 1/2] phy: core: Add an exported of_phy_get function
Date: Fri, 13 Dec 2013 15:02:59 +0100
Message-id: <1386943380-28596-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e+xoO4C4dVBBm9+G1rMP3KO1aLtykF2
	ix+vL7BZXHjaw2ZxedccNosZ5/cxWSxa1spssfbIXXaLiU3T2C3Wz3jN4sDlcefaHjaPvi2r
	GD2O39jO5PF5k1wASxSXTUpqTmZZapG+XQJXxpEb75kKbstVtG2+xNrA+E6ii5GTQ0LARKL3
	4nl2CFtM4sK99WxdjFwcQgLTGSWWLDkG5XQwSSx5voKli5GDg01AU2LVPQ+QBhGBGokpt66A
	NTMLdDJKXG6rBrGFBXwlfm/cyAhiswioSrxY0soO0sor4CLxZpMxiCkhoCAxZ5LNBEbuBYwM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCg+aZ1A7GlQ0WhxgFOBiVeHg9elcFCbEmlhVX
	5h5ilOBgVhLh9eJbHSTEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFM
	lomDU6qBMUllwYxLK9hvVCu0Ge8RMzHluqqo+32Drdt0vgMOJ88WK7J+7jpe+34Kq3jth0Nf
	VOR5zSuMX5l2zL7IOMun2WFS6cbT7V6/+psX7uHWlDohP836lNVno/5UlyaDaJ47/4uiqqr2
	ZjIu+NDiZh+rcu1Ir0Tpctkwo40BKVsvtqVPblectthXiaU4I9FQi7moOBEAvN4y6BYCAAA=
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
It seems that my git send-email is playing up and sent the previous emails
without from. This is a resend. Sorry for any confusion.
---
 drivers/phy/phy-core.c  |   41 ++++++++++++++++++++++++++++++++---------
 include/linux/phy/phy.h |    1 +
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..f0dbd42 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -240,8 +240,8 @@ out:
 EXPORT_SYMBOL_GPL(phy_power_off);
 
 /**
- * of_phy_get() - lookup and obtain a reference to a phy by phandle
- * @dev: device that requests this phy
+ * _of_phy_get() - lookup and obtain a reference to a phy by phandle
+ * @np: device_node for which to get the phy
  * @index: the index of the phy
  *
  * Returns the phy associated with the given phandle value,
@@ -250,20 +250,17 @@ EXPORT_SYMBOL_GPL(phy_power_off);
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
@@ -283,6 +280,32 @@ err0:
 }
 
 /**
+ * of_phy_get() - lookup and obtain a reference to a phy using a device_node.
+ * @np: device_node for which to get the phy
+ * @index: the index of the phy
+ *
+ * Returns the phy driver, after getting a refcount to it; or
+ * -ENODEV if there is no such phy.  The caller is responsible for
+ * calling phy_put() to release that count.
+ */
+struct phy *of_phy_get(struct device_node *np, int index)
+{
+	struct phy *phy = NULL;
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
@@ -370,7 +393,7 @@ struct phy *phy_get(struct device *dev, const char *string)
 	if (dev->of_node) {
 		index = of_property_match_string(dev->of_node, "phy-names",
 			string);
-		phy = of_phy_get(dev, index);
+		phy = _of_phy_get(dev->of_node, index);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "unable to find phy\n");
 			return phy;
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 6d72269..169f572 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -131,6 +131,7 @@ struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
+struct phy *of_phy_get(struct device_node *np, int index);
 struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args);
 struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
-- 
1.7.9.5

