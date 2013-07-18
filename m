Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935Ab3GRGt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:49:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34740 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264Ab3GRGsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:48:39 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <kishon@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <arnd@arndb.de>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: [PATCH 14/15] video: exynos_dp: remove non-DT support for Exynos Display Port
Date: Thu, 18 Jul 2013 12:16:23 +0530
Message-ID: <1374129984-765-15-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374129984-765-1-git-send-email-kishon@ti.com>
References: <1374129984-765-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jingoo Han <jg1.han@samsung.com>

Exynos Display Port can be used only for Exynos SoCs. In addition,
non-DT for EXYNOS SoCs is not supported from v3.11; thus, there is
no need to support non-DT for Exynos Display Port.

The 'include/video/exynos_dp.h' file has been used for non-DT
support and the content of file include/video/exynos_dp.h is moved
to drivers/video/exynos/exynos_dp_core.h. Thus, the 'exynos_dp.h'
file is removed. Also, 'struct exynos_dp_platdata' is removed,
because it is not used any more.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/video/exynos/Kconfig          |    2 +-
 drivers/video/exynos/exynos_dp_core.c |  116 +++++++----------------------
 drivers/video/exynos/exynos_dp_core.h |  109 +++++++++++++++++++++++++++
 drivers/video/exynos/exynos_dp_reg.c  |    2 -
 include/video/exynos_dp.h             |  131 ---------------------------------
 5 files changed, 135 insertions(+), 225 deletions(-)
 delete mode 100644 include/video/exynos_dp.h

diff --git a/drivers/video/exynos/Kconfig b/drivers/video/exynos/Kconfig
index 1b035b2..fab9019 100644
--- a/drivers/video/exynos/Kconfig
+++ b/drivers/video/exynos/Kconfig
@@ -29,7 +29,7 @@ config EXYNOS_LCD_S6E8AX0
 
 config EXYNOS_DP
 	bool "EXYNOS DP driver support"
-	depends on ARCH_EXYNOS
+	depends on OF && ARCH_EXYNOS
 	default n
 	help
 	  This enables support for DP device.
diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index 12bbede..05fed7d 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -20,8 +20,6 @@
 #include <linux/delay.h>
 #include <linux/of.h>
 
-#include <video/exynos_dp.h>
-
 #include "exynos_dp_core.h"
 
 static int exynos_dp_init_dp(struct exynos_dp_device *dp)
@@ -894,26 +892,17 @@ static void exynos_dp_hotplug(struct work_struct *work)
 		dev_err(dp->dev, "unable to config video\n");
 }
 
-#ifdef CONFIG_OF
-static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
+static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
 {
 	struct device_node *dp_node = dev->of_node;
-	struct exynos_dp_platdata *pd;
 	struct video_info *dp_video_config;
 
-	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "memory allocation for pdata failed\n");
-		return ERR_PTR(-ENOMEM);
-	}
 	dp_video_config = devm_kzalloc(dev,
 				sizeof(*dp_video_config), GFP_KERNEL);
-
 	if (!dp_video_config) {
 		dev_err(dev, "memory allocation for video config failed\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	pd->video_info = dp_video_config;
 
 	dp_video_config->h_sync_polarity =
 		of_property_read_bool(dp_node, "hsync-active-high");
@@ -960,7 +949,7 @@ static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	return pd;
+	return dp_video_config;
 }
 
 static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
@@ -1003,48 +992,30 @@ err:
 
 static void exynos_dp_phy_init(struct exynos_dp_device *dp)
 {
-	u32 reg;
+	if (dp->phy_addr) {
+		u32 reg;
 
-	reg = __raw_readl(dp->phy_addr);
-	reg |= dp->enable_mask;
-	__raw_writel(reg, dp->phy_addr);
+		reg = __raw_readl(dp->phy_addr);
+		reg |= dp->enable_mask;
+		__raw_writel(reg, dp->phy_addr);
+	}
 }
 
 static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
 {
-	u32 reg;
-
-	reg = __raw_readl(dp->phy_addr);
-	reg &= ~(dp->enable_mask);
-	__raw_writel(reg, dp->phy_addr);
-}
-#else
-static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
-{
-	return NULL;
-}
-
-static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
-{
-	return -EINVAL;
-}
-
-static void exynos_dp_phy_init(struct exynos_dp_device *dp)
-{
-	return;
-}
+	if (dp->phy_addr) {
+		u32 reg;
 
-static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
-{
-	return;
+		reg = __raw_readl(dp->phy_addr);
+		reg &= ~(dp->enable_mask);
+		__raw_writel(reg, dp->phy_addr);
+	}
 }
-#endif /* CONFIG_OF */
 
 static int exynos_dp_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct exynos_dp_device *dp;
-	struct exynos_dp_platdata *pdata;
 
 	int ret = 0;
 
@@ -1057,21 +1028,13 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 	dp->dev = &pdev->dev;
 
-	if (pdev->dev.of_node) {
-		pdata = exynos_dp_dt_parse_pdata(&pdev->dev);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
+	dp->video_info = exynos_dp_dt_parse_pdata(&pdev->dev);
+	if (IS_ERR(dp->video_info))
+		return PTR_ERR(dp->video_info);
 
-		ret = exynos_dp_dt_parse_phydata(dp);
-		if (ret)
-			return ret;
-	} else {
-		pdata = pdev->dev.platform_data;
-		if (!pdata) {
-			dev_err(&pdev->dev, "no platform data\n");
-			return -EINVAL;
-		}
-	}
+	ret = exynos_dp_dt_parse_phydata(dp);
+	if (ret)
+		return ret;
 
 	dp->clock = devm_clk_get(&pdev->dev, "dp");
 	if (IS_ERR(dp->clock)) {
@@ -1095,15 +1058,7 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 	INIT_WORK(&dp->hotplug_work, exynos_dp_hotplug);
 
-	dp->video_info = pdata->video_info;
-
-	if (pdev->dev.of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_init(dp);
-	} else {
-		if (pdata->phy_init)
-			pdata->phy_init();
-	}
+	exynos_dp_phy_init(dp);
 
 	exynos_dp_init_dp(dp);
 
@@ -1121,18 +1076,11 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 static int exynos_dp_remove(struct platform_device *pdev)
 {
-	struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
 
 	flush_work(&dp->hotplug_work);
 
-	if (pdev->dev.of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_exit(dp);
-	} else {
-		if (pdata->phy_exit)
-			pdata->phy_exit();
-	}
+	exynos_dp_phy_exit(dp);
 
 	clk_disable_unprepare(dp->clock);
 
@@ -1143,20 +1091,13 @@ static int exynos_dp_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int exynos_dp_suspend(struct device *dev)
 {
-	struct exynos_dp_platdata *pdata = dev->platform_data;
 	struct exynos_dp_device *dp = dev_get_drvdata(dev);
 
 	disable_irq(dp->irq);
 
 	flush_work(&dp->hotplug_work);
 
-	if (dev->of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_exit(dp);
-	} else {
-		if (pdata->phy_exit)
-			pdata->phy_exit();
-	}
+	exynos_dp_phy_exit(dp);
 
 	clk_disable_unprepare(dp->clock);
 
@@ -1165,16 +1106,9 @@ static int exynos_dp_suspend(struct device *dev)
 
 static int exynos_dp_resume(struct device *dev)
 {
-	struct exynos_dp_platdata *pdata = dev->platform_data;
 	struct exynos_dp_device *dp = dev_get_drvdata(dev);
 
-	if (dev->of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_init(dp);
-	} else {
-		if (pdata->phy_init)
-			pdata->phy_init();
-	}
+	exynos_dp_phy_init(dp);
 
 	clk_prepare_enable(dp->clock);
 
@@ -1203,7 +1137,7 @@ static struct platform_driver exynos_dp_driver = {
 		.name	= "exynos-dp",
 		.owner	= THIS_MODULE,
 		.pm	= &exynos_dp_pm_ops,
-		.of_match_table = of_match_ptr(exynos_dp_match),
+		.of_match_table = exynos_dp_match,
 	},
 };
 
diff --git a/drivers/video/exynos/exynos_dp_core.h b/drivers/video/exynos/exynos_dp_core.h
index 6c567bbf..56cfec8 100644
--- a/drivers/video/exynos/exynos_dp_core.h
+++ b/drivers/video/exynos/exynos_dp_core.h
@@ -13,6 +13,99 @@
 #ifndef _EXYNOS_DP_CORE_H
 #define _EXYNOS_DP_CORE_H
 
+#define DP_TIMEOUT_LOOP_COUNT 100
+#define MAX_CR_LOOP 5
+#define MAX_EQ_LOOP 5
+
+enum link_rate_type {
+	LINK_RATE_1_62GBPS = 0x06,
+	LINK_RATE_2_70GBPS = 0x0a
+};
+
+enum link_lane_count_type {
+	LANE_COUNT1 = 1,
+	LANE_COUNT2 = 2,
+	LANE_COUNT4 = 4
+};
+
+enum link_training_state {
+	START,
+	CLOCK_RECOVERY,
+	EQUALIZER_TRAINING,
+	FINISHED,
+	FAILED
+};
+
+enum voltage_swing_level {
+	VOLTAGE_LEVEL_0,
+	VOLTAGE_LEVEL_1,
+	VOLTAGE_LEVEL_2,
+	VOLTAGE_LEVEL_3,
+};
+
+enum pre_emphasis_level {
+	PRE_EMPHASIS_LEVEL_0,
+	PRE_EMPHASIS_LEVEL_1,
+	PRE_EMPHASIS_LEVEL_2,
+	PRE_EMPHASIS_LEVEL_3,
+};
+
+enum pattern_set {
+	PRBS7,
+	D10_2,
+	TRAINING_PTN1,
+	TRAINING_PTN2,
+	DP_NONE
+};
+
+enum color_space {
+	COLOR_RGB,
+	COLOR_YCBCR422,
+	COLOR_YCBCR444
+};
+
+enum color_depth {
+	COLOR_6,
+	COLOR_8,
+	COLOR_10,
+	COLOR_12
+};
+
+enum color_coefficient {
+	COLOR_YCBCR601,
+	COLOR_YCBCR709
+};
+
+enum dynamic_range {
+	VESA,
+	CEA
+};
+
+enum pll_status {
+	PLL_UNLOCKED,
+	PLL_LOCKED
+};
+
+enum clock_recovery_m_value_type {
+	CALCULATED_M,
+	REGISTER_M
+};
+
+enum video_timing_recognition_type {
+	VIDEO_TIMING_FROM_CAPTURE,
+	VIDEO_TIMING_FROM_REGISTER
+};
+
+enum analog_power_block {
+	AUX_BLOCK,
+	CH0_BLOCK,
+	CH1_BLOCK,
+	CH2_BLOCK,
+	CH3_BLOCK,
+	ANALOG_TOTAL,
+	POWER_ALL
+};
+
 enum dp_irq_type {
 	DP_IRQ_TYPE_HP_CABLE_IN,
 	DP_IRQ_TYPE_HP_CABLE_OUT,
@@ -20,6 +113,22 @@ enum dp_irq_type {
 	DP_IRQ_TYPE_UNKNOWN,
 };
 
+struct video_info {
+	char *name;
+
+	bool h_sync_polarity;
+	bool v_sync_polarity;
+	bool interlaced;
+
+	enum color_space color_space;
+	enum dynamic_range dynamic_range;
+	enum color_coefficient ycbcr_coeff;
+	enum color_depth color_depth;
+
+	enum link_rate_type link_rate;
+	enum link_lane_count_type lane_count;
+};
+
 struct link_train {
 	int eq_loop;
 	int cr_loop[4];
diff --git a/drivers/video/exynos/exynos_dp_reg.c b/drivers/video/exynos/exynos_dp_reg.c
index 29d9d03..b70da50 100644
--- a/drivers/video/exynos/exynos_dp_reg.c
+++ b/drivers/video/exynos/exynos_dp_reg.c
@@ -14,8 +14,6 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
-#include <video/exynos_dp.h>
-
 #include "exynos_dp_core.h"
 #include "exynos_dp_reg.h"
 
diff --git a/include/video/exynos_dp.h b/include/video/exynos_dp.h
deleted file mode 100644
index bd8cabd..0000000
--- a/include/video/exynos_dp.h
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * Samsung SoC DP device support
- *
- * Copyright (C) 2012 Samsung Electronics Co., Ltd.
- * Author: Jingoo Han <jg1.han@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _EXYNOS_DP_H
-#define _EXYNOS_DP_H
-
-#define DP_TIMEOUT_LOOP_COUNT 100
-#define MAX_CR_LOOP 5
-#define MAX_EQ_LOOP 5
-
-enum link_rate_type {
-	LINK_RATE_1_62GBPS = 0x06,
-	LINK_RATE_2_70GBPS = 0x0a
-};
-
-enum link_lane_count_type {
-	LANE_COUNT1 = 1,
-	LANE_COUNT2 = 2,
-	LANE_COUNT4 = 4
-};
-
-enum link_training_state {
-	START,
-	CLOCK_RECOVERY,
-	EQUALIZER_TRAINING,
-	FINISHED,
-	FAILED
-};
-
-enum voltage_swing_level {
-	VOLTAGE_LEVEL_0,
-	VOLTAGE_LEVEL_1,
-	VOLTAGE_LEVEL_2,
-	VOLTAGE_LEVEL_3,
-};
-
-enum pre_emphasis_level {
-	PRE_EMPHASIS_LEVEL_0,
-	PRE_EMPHASIS_LEVEL_1,
-	PRE_EMPHASIS_LEVEL_2,
-	PRE_EMPHASIS_LEVEL_3,
-};
-
-enum pattern_set {
-	PRBS7,
-	D10_2,
-	TRAINING_PTN1,
-	TRAINING_PTN2,
-	DP_NONE
-};
-
-enum color_space {
-	COLOR_RGB,
-	COLOR_YCBCR422,
-	COLOR_YCBCR444
-};
-
-enum color_depth {
-	COLOR_6,
-	COLOR_8,
-	COLOR_10,
-	COLOR_12
-};
-
-enum color_coefficient {
-	COLOR_YCBCR601,
-	COLOR_YCBCR709
-};
-
-enum dynamic_range {
-	VESA,
-	CEA
-};
-
-enum pll_status {
-	PLL_UNLOCKED,
-	PLL_LOCKED
-};
-
-enum clock_recovery_m_value_type {
-	CALCULATED_M,
-	REGISTER_M
-};
-
-enum video_timing_recognition_type {
-	VIDEO_TIMING_FROM_CAPTURE,
-	VIDEO_TIMING_FROM_REGISTER
-};
-
-enum analog_power_block {
-	AUX_BLOCK,
-	CH0_BLOCK,
-	CH1_BLOCK,
-	CH2_BLOCK,
-	CH3_BLOCK,
-	ANALOG_TOTAL,
-	POWER_ALL
-};
-
-struct video_info {
-	char *name;
-
-	bool h_sync_polarity;
-	bool v_sync_polarity;
-	bool interlaced;
-
-	enum color_space color_space;
-	enum dynamic_range dynamic_range;
-	enum color_coefficient ycbcr_coeff;
-	enum color_depth color_depth;
-
-	enum link_rate_type link_rate;
-	enum link_lane_count_type lane_count;
-};
-
-struct exynos_dp_platdata {
-	struct video_info *video_info;
-
-	void (*phy_init)(void);
-	void (*phy_exit)(void);
-};
-
-#endif /* _EXYNOS_DP_H */
-- 
1.7.10.4

