Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab3GRGs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:48:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49303 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662Ab3GRGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:48:21 -0400
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
Subject: [PATCH 11/15] exynos4-is: Use the generic MIPI CSIS PHY driver
Date: Thu, 18 Jul 2013 12:16:20 +0530
Message-ID: <1374129984-765-12-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374129984-765-1-git-send-email-kishon@ti.com>
References: <1374129984-765-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Use the generic PHY API instead of the platform callback to control
the MIPI CSIS DPHY. The 'phy_label' field is added to the platform
data structure to allow PHY lookup on non-dt platforms

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/media/platform/exynos4-is/mipi-csis.c |   16 +++++++++++++---
 include/linux/platform_data/mipi-csis.h       |   11 ++---------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 0914230..94028ce 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -20,6 +20,7 @@
 #include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_data/mipi-csis.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -180,6 +181,7 @@ struct csis_drvdata {
  * @sd: v4l2_subdev associated with CSIS device instance
  * @index: the hardware instance index
  * @pdev: CSIS platform device
+ * @phy: pointer to the CSIS generic PHY
  * @regs: mmaped I/O registers memory
  * @supplies: CSIS regulator supplies
  * @clock: CSIS clocks
@@ -203,6 +205,8 @@ struct csis_state {
 	struct v4l2_subdev sd;
 	u8 index;
 	struct platform_device *pdev;
+	struct phy *phy;
+	const char *phy_label;
 	void __iomem *regs;
 	struct regulator_bulk_data supplies[CSIS_NUM_SUPPLIES];
 	struct clk *clock[NUM_CSIS_CLOCKS];
@@ -742,6 +746,7 @@ static int s5pcsis_get_platform_data(struct platform_device *pdev,
 	state->index = max(0, pdev->id);
 	state->max_num_lanes = state->index ? CSIS1_MAX_LANES :
 					      CSIS0_MAX_LANES;
+	state->phy_label = pdata->phy_label;
 	return 0;
 }
 
@@ -779,8 +784,9 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 					"samsung,csis-wclk");
 
 	state->num_lanes = endpoint.bus.mipi_csi2.num_data_lanes;
-
 	of_node_put(node);
+
+	state->phy_label = "csis";
 	return 0;
 }
 #else
@@ -829,6 +835,10 @@ static int s5pcsis_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	state->phy = devm_phy_get(dev, state->phy_label);
+	if (IS_ERR(state->phy))
+		return PTR_ERR(state->phy);
+
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	state->regs = devm_ioremap_resource(dev, mem_res);
 	if (IS_ERR(state->regs))
@@ -922,7 +932,7 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 	mutex_lock(&state->lock);
 	if (state->flags & ST_POWERED) {
 		s5pcsis_stop_stream(state);
-		ret = s5p_csis_phy_enable(state->index, false);
+		ret = phy_power_off(state->phy);
 		if (ret)
 			goto unlock;
 		ret = regulator_bulk_disable(CSIS_NUM_SUPPLIES,
@@ -958,7 +968,7 @@ static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 					    state->supplies);
 		if (ret)
 			goto unlock;
-		ret = s5p_csis_phy_enable(state->index, true);
+		ret = phy_power_on(state->phy);
 		if (!ret) {
 			state->flags |= ST_POWERED;
 		} else {
diff --git a/include/linux/platform_data/mipi-csis.h b/include/linux/platform_data/mipi-csis.h
index bf34e17..9214317 100644
--- a/include/linux/platform_data/mipi-csis.h
+++ b/include/linux/platform_data/mipi-csis.h
@@ -17,21 +17,14 @@
  * @wclk_source: CSI wrapper clock selection: 0 - bus clock, 1 - ext. SCLK_CAM
  * @lanes:       number of data lanes used
  * @hs_settle:   HS-RX settle time
+ * @phy_label:	 the generic PHY label
  */
 struct s5p_platform_mipi_csis {
 	unsigned long clk_rate;
 	u8 wclk_source;
 	u8 lanes;
 	u8 hs_settle;
+	const char *phy_label;
 };
 
-/**
- * s5p_csis_phy_enable - global MIPI-CSI receiver D-PHY control
- * @id:     MIPI-CSIS harware instance index (0...1)
- * @on:     true to enable D-PHY and deassert its reset
- *          false to disable D-PHY
- * @return: 0 on success, or negative error code on failure
- */
-int s5p_csis_phy_enable(int id, bool on);
-
 #endif /* __PLAT_SAMSUNG_MIPI_CSIS_H_ */
-- 
1.7.10.4

