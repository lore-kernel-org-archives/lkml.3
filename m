Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab3GRGsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:48:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34338 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947Ab3GRGss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:48:48 -0400
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
Subject: [PATCH 15/15] video: exynos_dp: Use the generic PHY driver
Date: Thu, 18 Jul 2013 12:16:24 +0530
Message-ID: <1374129984-765-16-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374129984-765-1-git-send-email-kishon@ti.com>
References: <1374129984-765-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jingoo Han <jg1.han@samsung.com>

Use the generic PHY API to control the DP PHY.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/video/exynos_dp.txt          |   18 +++++++++---------
 drivers/video/exynos/exynos_dp_core.c                |   16 ++++++++++++----
 drivers/video/exynos/exynos_dp_core.h                |    1 +
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt b/Documentation/devicetree/bindings/video/exynos_dp.txt
index 84f10c1..2f56376 100644
--- a/Documentation/devicetree/bindings/video/exynos_dp.txt
+++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
@@ -6,10 +6,10 @@ We use two nodes:
 	-dptx-phy node(defined inside dp-controller node)
 
 For the DP-PHY initialization, we use the dptx-phy node.
-Required properties for dptx-phy:
-	-reg:
+Required properties for dptx-phy: deprecated, use phys and phy-names
+	-reg: deprecated
 		Base address of DP PHY register.
-	-samsung,enable-mask:
+	-samsung,enable-mask: deprecated
 		The bit-mask used to enable/disable DP PHY.
 
 For the Panel initialization, we read data from dp-controller node.
@@ -25,6 +25,10 @@ Required properties for dp-controller:
 		from common clock binding: handle to dp clock.
 	-clock-names:
 		from common clock binding: Shall be "dp".
+	-phys:
+		from general PHY binding: the phandle for the PHY device.
+	-phy-names:
+		from general PHY binding: Should be "dp".
 	-interrupt-parent:
 		phandle to Interrupt combiner node.
 	-samsung,color-space:
@@ -67,12 +71,8 @@ SOC specific portion:
 		interrupt-parent = <&combiner>;
 		clocks = <&clock 342>;
 		clock-names = "dp";
-
-		dptx-phy {
-			reg = <0x10040720>;
-			samsung,enable-mask = <1>;
-		};
-
+		phys = <&dp_phy>;
+		phy-names = "dp";
 	};
 
 Board Specific portion:
diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index 05fed7d..5e1a715 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/of.h>
+#include <linux/phy/phy.h>
 
 #include "exynos_dp_core.h"
 
@@ -960,8 +961,11 @@ static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
 
 	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
 	if (!dp_phy_node) {
-		dev_err(dp->dev, "could not find dptx-phy node\n");
-		return -ENODEV;
+		dp->phy = devm_phy_get(dp->dev, "dp");
+		if (IS_ERR(dp->phy))
+			return PTR_ERR(dp->phy);
+		else
+			return 0;
 	}
 
 	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
@@ -992,7 +996,9 @@ err:
 
 static void exynos_dp_phy_init(struct exynos_dp_device *dp)
 {
-	if (dp->phy_addr) {
+	if (dp->phy) {
+		phy_power_on(dp->phy);
+	} else if (dp->phy_addr) {
 		u32 reg;
 
 		reg = __raw_readl(dp->phy_addr);
@@ -1003,7 +1009,9 @@ static void exynos_dp_phy_init(struct exynos_dp_device *dp)
 
 static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
 {
-	if (dp->phy_addr) {
+	if (dp->phy) {
+		phy_power_off(dp->phy);
+	} else if (dp->phy_addr) {
 		u32 reg;
 
 		reg = __raw_readl(dp->phy_addr);
diff --git a/drivers/video/exynos/exynos_dp_core.h b/drivers/video/exynos/exynos_dp_core.h
index 56cfec8..607e36d 100644
--- a/drivers/video/exynos/exynos_dp_core.h
+++ b/drivers/video/exynos/exynos_dp_core.h
@@ -151,6 +151,7 @@ struct exynos_dp_device {
 	struct video_info	*video_info;
 	struct link_train	link_train;
 	struct work_struct	hotplug_work;
+	struct phy		*phy;
 };
 
 /* exynos_dp_reg.c */
-- 
1.7.10.4

