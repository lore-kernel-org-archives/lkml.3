Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab3LEMaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:30:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:65433 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3LEMaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:30:02 -0500
X-AuditID: cbfee61a-b7f796d000004313-54-52a071c811f9
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/9] phy: core: Change the way of_phy_get is called
Date: Thu, 05 Dec 2013 13:29:31 +0100
Message-id: <1386246579-25141-2-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd0ThQuCDG62WVss2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2Vov1M16zWHScPcjuIORxua+XyWPnrLvsHneu7WHz6NuyitHj
	+I3tTB6fN8kFsEVx2aSk5mSWpRbp2yVwZfRv+8RY8Fy44m7POZYGxhUCXYwcHBICJhIXvkp0
	MXICmWISF+6tZ+ti5OIQEpjOKLH0zh8WCKeDSeL6jAPsIA1sApoSq+55gDSICNRITLl1hR3E
	Zha4yySxeqMWiC0s4CzRPfkmE4jNIqAq8WHnQzYQm1fAReL8wX5WiL0KEnMm2YCEOQVcJVZO
	PMwGEhYCKllzRXMCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFh/ExqB+PKBotD
	jAIcjEo8vC8S5wcJsSaWFVfmHmKU4GBWEuEVzlkQJMSbklhZlVqUH19UmpNafIhRmoNFSZz3
	QKt1oJBAemJJanZqakFqEUyWiYNTqoFxaYHm3zNFmxv/XbEqmej2fo6npNZPrtI/ZqvPzKwM
	XPvlzj9Nbt6XkjmiOoKnFA7seMd9+apkscWya18Zj+7vmOBaGVJ1bcWSb1uXKcV9Oqq1YXNs
	cPMVJqks01n2Tm8ra+c7Znisfe/MsKM86qKokwr/64t7BVq9vz5xWjijMtr8oPvFqMZSJZbi
	jERDLeai4kQA6eq5dF8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the of_phy_get function took a struct device * and
was declared static. It was impossible to call it from
another driver and thus it was impossible to get phy defined
for a given node.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/phy/phy-core.c  |   12 +++++-------
 include/linux/phy/phy.h |    1 +
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..7fb3474 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -250,20 +250,17 @@ EXPORT_SYMBOL_GPL(phy_power_off);
  * not yet loaded. This function uses of_xlate call back function provided
  * while registering the phy_provider to find the phy instance.
  */
-static struct phy *of_phy_get(struct device *dev, int index)
+struct phy *of_phy_get(struct device_node *np, int index)
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
@@ -281,6 +278,7 @@ err0:
 
 	return phy;
 }
+EXPORT_SYMBOL_GPL(of_phy_get);
 
 /**
  * phy_put() - release the PHY
@@ -370,7 +368,7 @@ struct phy *phy_get(struct device *dev, const char *string)
 	if (dev->of_node) {
 		index = of_property_match_string(dev->of_node, "phy-names",
 			string);
-		phy = of_phy_get(dev, index);
+		phy = of_phy_get(dev->of_node, index);
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

