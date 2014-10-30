Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbaJ3NYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:24:12 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34324 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbaJ3NYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:24:10 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@google.com, ajaykumar.rs@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Inki Dae <inki.dae@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH v2 1/2] drm/exynos: dp: Remove support for unused dptx-phy
Date: Thu, 30 Oct 2014 18:54:01 +0530
Message-Id: <1414675442-3471-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have moved to generic phy based bindings,
we don't need to have any code related to older dptx-phy.
Nobody is using this dptx-phy anymore, so removing the
same.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
---

Changes from V1:
 - Reworked error handling in exynos_dp_dt_parse_phydata() as commented
   by Inki.

 drivers/gpu/drm/exynos/exynos_dp_core.c |   67 ++++++++-----------------------
 drivers/gpu/drm/exynos/exynos_dp_core.h |    2 -
 2 files changed, 17 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
index cd50ece..206163b 100644
--- a/drivers/gpu/drm/exynos/exynos_dp_core.c
+++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
@@ -1052,28 +1052,14 @@ static int exynos_dp_create_connector(struct exynos_drm_display *display,
 
 static void exynos_dp_phy_init(struct exynos_dp_device *dp)
 {
-	if (dp->phy) {
+	if (dp->phy)
 		phy_power_on(dp->phy);
-	} else if (dp->phy_addr) {
-		u32 reg;
-
-		reg = __raw_readl(dp->phy_addr);
-		reg |= dp->enable_mask;
-		__raw_writel(reg, dp->phy_addr);
-	}
 }
 
 static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
 {
-	if (dp->phy) {
+	if (dp->phy)
 		phy_power_off(dp->phy);
-	} else if (dp->phy_addr) {
-		u32 reg;
-
-		reg = __raw_readl(dp->phy_addr);
-		reg &= ~(dp->enable_mask);
-		__raw_writel(reg, dp->phy_addr);
-	}
 }
 
 static void exynos_dp_poweron(struct exynos_drm_display *display)
@@ -1212,40 +1198,13 @@ static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
 
 static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
 {
-	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
-	u32 phy_base;
-	int ret = 0;
-
-	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
-	if (!dp_phy_node) {
-		dp->phy = devm_phy_get(dp->dev, "dp");
-		return PTR_ERR_OR_ZERO(dp->phy);
-	}
-
-	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
-		dev_err(dp->dev, "failed to get reg for dptx-phy\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
-				&dp->enable_mask)) {
-		dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	dp->phy_addr = ioremap(phy_base, SZ_4);
-	if (!dp->phy_addr) {
-		dev_err(dp->dev, "failed to ioremap dp-phy\n");
-		ret = -ENOMEM;
-		goto err;
+	dp->phy = devm_phy_get(dp->dev, "dp");
+	if (IS_ERR(dp->phy)) {
+		dev_err(dp->dev, "no DP phy configured\n");
+		return PTR_ERR(dp->phy);
 	}
 
-err:
-	of_node_put(dp_phy_node);
-
-	return ret;
+	return 0;
 }
 
 static int exynos_dp_dt_parse_panel(struct exynos_dp_device *dp)
@@ -1278,8 +1237,16 @@ static int exynos_dp_bind(struct device *dev, struct device *master, void *data)
 		return PTR_ERR(dp->video_info);
 
 	ret = exynos_dp_dt_parse_phydata(dp);
-	if (ret)
-		return ret;
+	if (ret) {
+		/*
+		 * phy itself is not enabled, so we can move forward
+		 * assigning NULL to phy pointer.
+		 */
+		if (ret == -ENOSYS || ret == -ENODEV)
+			dp->phy = NULL;
+		else
+			return ret;
+	}
 
 	if (!dp->panel) {
 		ret = exynos_dp_dt_parse_panel(dp);
diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.h b/drivers/gpu/drm/exynos/exynos_dp_core.h
index a1aee69..6426201 100644
--- a/drivers/gpu/drm/exynos/exynos_dp_core.h
+++ b/drivers/gpu/drm/exynos/exynos_dp_core.h
@@ -153,8 +153,6 @@ struct exynos_dp_device {
 	struct clk		*clock;
 	unsigned int		irq;
 	void __iomem		*reg_base;
-	void __iomem		*phy_addr;
-	unsigned int		enable_mask;
 
 	struct video_info	*video_info;
 	struct link_train	link_train;
-- 
1.7.10.4

