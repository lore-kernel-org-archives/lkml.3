Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3LPMwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:52:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55531 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3LPMwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:52:38 -0500
X-AuditID: cbfee61b-b7fbf6d0000051a3-b0-52aef7943faf
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kishon@ti.com, t.figa@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, matt.porter@linaro.org, k.debski@samsung.com
Subject: [PATCH v3 1/2] phy: core: Add an exported of_phy_get function
Date: Mon, 16 Dec 2013 13:52:17 +0100
Message-id: <1387198338-10556-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xoO7U7+uCDNZOYbGYf+Qcq0XblYPs
	Fj9eX2CzuPC0h83i8q45bBYzzu9jsli0rJXZYu2Ru+wWE5umsVusn/GaxYHL4861PWwefVtW
	MXocv7GdyePzJrkAligum5TUnMyy1CJ9uwSujC/v17MWPJSr6P/SztjA+E2ii5GTQ0LARKLt
	wG02CFtM4sK99UA2F4eQwHRGid9TX0E5HUwSfTfOMXcxcnCwCWhKrLrnAdIgIlAjMeXWFXYQ
	m1mgk1Hicls1iC0s4Caxq/E1C4jNIqAqcWLrYbAaXgEXiccNn1lAxkgIKEjMmWQzgZF7ASPD
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgsHkmvYNxVYPFIUYBDkYlHl4Fy3VBQqyJZcWV
	uYcYJTiYlUR4648DhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgsky
	cXBKNTB6Rhya7Dxtc5Vr+CKFQxc0o7kXnew4Mfu8Dv9Ung2GivvENyqVf8h4cPZBz9czRXyW
	Xqci+LL0Z81/c7Qn4GL8c5HkO9wCudM0HTLyti79N0N889bi7ynna47rX9mQME2g7NDJyRpn
	MngkVt+ZdH5mkE++B/8uyxyj/uqLOUpT472EBKeUPzqmxFKckWioxVxUnAgAZON84BcCAAA=
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
 include/linux/phy/phy.h |    1 +
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..0107f71 100644
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
@@ -283,6 +280,36 @@ err0:
 }
 
 /**
+ * of_phy_get() - lookup and obtain a reference to a phy using a device_node.
+ * @np: device_node for which to get the phy
+ * @con_id: name of the phy from device's point of view
+ *
+ * Returns the phy driver, after getting a refcount to it; or
+ * -ENODEV if there is no such phy.  The caller is responsible for
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
@@ -370,7 +397,7 @@ struct phy *phy_get(struct device *dev, const char *string)
 	if (dev->of_node) {
 		index = of_property_match_string(dev->of_node, "phy-names",
 			string);
-		phy = of_phy_get(dev, index);
+		phy = _of_phy_get(dev->of_node, index);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "unable to find phy\n");
 			return phy;
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 6d72269..bcb6274 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -131,6 +131,7 @@ struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
+struct phy *of_phy_get(struct device_node *np, const char *con_id);
 struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args);
 struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
-- 
1.7.9.5

