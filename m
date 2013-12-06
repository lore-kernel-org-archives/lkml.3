Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161169Ab3LFSKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:10:36 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:38809 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194Ab3LFSHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:07:05 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 03/10] net: stmmac: Use platform data tied with compatible strings
Date: Sat,  7 Dec 2013 01:29:36 +0800
Message-Id: <1386350983-13281-4-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386350983-13281-1-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  | 29 ++++++++++++++--------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 74c7aef..df3fd1c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -26,8 +26,19 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
+#include <linux/of_device.h>
 #include "stmmac.h"
 
+static const struct of_device_id stmmac_dt_ids[] = {
+	{ .compatible = "st,spear600-gmac"},
+	{ .compatible = "snps,dwmac-3.610"},
+	{ .compatible = "snps,dwmac-3.70a"},
+	{ .compatible = "snps,dwmac-3.710"},
+	{ .compatible = "snps,dwmac"},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, stmmac_dt_ids);
+
 #ifdef CONFIG_OF
 static int stmmac_probe_config_dt(struct platform_device *pdev,
 				  struct plat_stmmacenet_data *plat,
@@ -35,10 +46,18 @@ static int stmmac_probe_config_dt(struct platform_device *pdev,
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct stmmac_dma_cfg *dma_cfg;
+	const struct of_device_id *device;
 
 	if (!np)
 		return -ENODEV;
 
+	device = of_match_device(stmmac_dt_ids, &pdev->dev);
+	if (!device)
+		return -ENODEV;
+
+	if (device->data)
+	    memcpy(plat, device->data, sizeof(*plat));
+
 	*mac = of_get_mac_address(np);
 	plat->interface = of_get_phy_mode(np);
 
@@ -257,16 +276,6 @@ static const struct dev_pm_ops stmmac_pltfr_pm_ops = {
 static const struct dev_pm_ops stmmac_pltfr_pm_ops;
 #endif /* CONFIG_PM */
 
-static const struct of_device_id stmmac_dt_ids[] = {
-	{ .compatible = "st,spear600-gmac"},
-	{ .compatible = "snps,dwmac-3.610"},
-	{ .compatible = "snps,dwmac-3.70a"},
-	{ .compatible = "snps,dwmac-3.710"},
-	{ .compatible = "snps,dwmac"},
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, stmmac_dt_ids);
-
 struct platform_driver stmmac_pltfr_driver = {
 	.probe = stmmac_pltfr_probe,
 	.remove = stmmac_pltfr_remove,
-- 
1.8.5.1

