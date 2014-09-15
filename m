Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaIONNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:13:32 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34983 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbaIONNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:13:30 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: inki.dae@samsung.com, seanpaul@google.com, kishon@ti.com,
        ajaykumar.rs@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/3] drm/exynos: dp: Remove support for unused dptx-phy
Date: Mon, 15 Sep 2014 18:43:04 +0530
Message-Id: <1410786785-9838-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410786785-9838-1-git-send-email-gautam.vivek@samsung.com>
References: <1410786785-9838-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have moved to generic phy based bindings,
we don't need to have any code related to older dptx-phy.
Nobody is using this dptx-phy anymore, so removing the
same.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_dp_core.c |   58 +++++++------------------------
 drivers/gpu/drm/exynos/exynos_dp_core.h |    2 --
 2 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
index 4f3c7eb..5ffc1b2 100644
--- a/drivers/gpu/drm/exynos/exynos_dp_core.c
+++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
@@ -1050,28 +1050,14 @@ static int exynos_dp_create_connector(struct exynos_drm_display *display,
 
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
@@ -1210,39 +1196,21 @@ static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
 
 static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
 {
-	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
-	u32 phy_base;
 	int ret = 0;
 
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
+		ret = PTR_ERR(dp->phy);
+		if (ret == -ENOSYS || ret == -ENODEV) {
+			dp->phy = NULL;
+		} else if (ret == -EPROBE_DEFER) {
+			return ret;
+		} else {
+			dev_err(dp->dev, "no DP phy configured\n");
+			return ret;
+		}
 	}
 
-err:
-	of_node_put(dp_phy_node);
-
 	return ret;
 }
 
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

