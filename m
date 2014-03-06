Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaCFOYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:24:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58159 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaCFOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:24:04 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.comg>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 05/13] phy: ti-pipe3: Add SATA DPLL support
Date: Thu, 6 Mar 2014 16:22:57 +0200
Message-ID: <1394115785-28301-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394115785-28301-1-git-send-email-rogerq@ti.com>
References: <1394115785-28301-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB and SATA DPLLs need different settings. Provide
the SATA DPLL settings and use the proper DPLL settings
based on device tree node's compatible_id.

Update the DT binding information.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy.txt |  3 +-
 drivers/phy/phy-ti-pipe3.c                       | 76 +++++++++++++++++-------
 2 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
index 8d13349..2c2d66a 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -53,7 +53,8 @@ usb2phy@4a0ad080 {
 TI PIPE3 PHY
 
 Required properties:
- - compatible: Should be "ti,phy-usb3". "ti,omap-usb3" is deprecated.
+ - compatible: Should be "ti,phy-usb3" or "ti,phy-pipe3-sata".
+   "ti,omap-usb3" is deprecated.
  - reg : Address and length of the register set for the device.
  - reg-names: The names of the register addresses corresponding to the registers
    filled in "reg".
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 211703c..f141237 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -66,6 +66,11 @@ struct pipe3_dpll_params {
 	u32	mf;
 };
 
+struct pipe3_dpll_map {
+	unsigned long rate;
+	struct pipe3_dpll_params params;
+};
+
 struct ti_pipe3 {
 	void __iomem		*pll_ctrl_base;
 	struct device		*dev;
@@ -73,20 +78,27 @@ struct ti_pipe3 {
 	struct clk		*wkupclk;
 	struct clk		*sys_clk;
 	struct clk		*refclk;
+	struct pipe3_dpll_map	*dpll_map;
 };
 
-struct pipe3_dpll_map {
-	unsigned long rate;
-	struct pipe3_dpll_params params;
-};
-
-static struct pipe3_dpll_map dpll_map[] = {
+static struct pipe3_dpll_map dpll_map_usb[] = {
 	{12000000, {1250, 5, 4, 20, 0} },	/* 12 MHz */
 	{16800000, {3125, 20, 4, 20, 0} },	/* 16.8 MHz */
 	{19200000, {1172, 8, 4, 20, 65537} },	/* 19.2 MHz */
 	{20000000, {1000, 7, 4, 10, 0} },	/* 20 MHz */
 	{26000000, {1250, 12, 4, 20, 0} },	/* 26 MHz */
 	{38400000, {3125, 47, 4, 20, 92843} },	/* 38.4 MHz */
+	{ },					/* Terminator */
+};
+
+static struct pipe3_dpll_map dpll_map_sata[] = {
+	{12000000, {1000, 7, 4, 6, 0} },	/* 12 MHz */
+	{16800000, {714, 7, 4, 6, 0} },		/* 16.8 MHz */
+	{19200000, {625, 7, 4, 6, 0} },		/* 19.2 MHz */
+	{20000000, {600, 7, 4, 6, 0} },		/* 20 MHz */
+	{26000000, {461, 7, 4, 6, 0} },		/* 26 MHz */
+	{38400000, {312, 7, 4, 6, 0} },		/* 38.4 MHz */
+	{ },					/* Terminator */
 };
 
 static inline u32 ti_pipe3_readl(void __iomem *addr, unsigned offset)
@@ -100,15 +112,20 @@ static inline void ti_pipe3_writel(void __iomem *addr, unsigned offset,
 	__raw_writel(data, addr + offset);
 }
 
-static struct pipe3_dpll_params *ti_pipe3_get_dpll_params(unsigned long rate)
+static struct pipe3_dpll_params *ti_pipe3_get_dpll_params(struct ti_pipe3 *phy)
 {
-	int i;
+	unsigned long rate;
+	struct pipe3_dpll_map *dpll_map = phy->dpll_map;
 
-	for (i = 0; i < ARRAY_SIZE(dpll_map); i++) {
-		if (rate == dpll_map[i].rate)
-			return &dpll_map[i].params;
+	rate = clk_get_rate(phy->sys_clk);
+
+	for (; dpll_map->rate; dpll_map++) {
+		if (rate == dpll_map->rate)
+			return &dpll_map->params;
 	}
 
+	dev_err(phy->dev, "No DPLL configuration for %lu Hz SYS CLK\n", rate);
+
 	return NULL;
 }
 
@@ -182,16 +199,11 @@ static void ti_pipe3_dpll_relock(struct ti_pipe3 *phy)
 static int ti_pipe3_dpll_lock(struct ti_pipe3 *phy)
 {
 	u32			val;
-	unsigned long		rate;
 	struct pipe3_dpll_params *dpll_params;
 
-	rate = clk_get_rate(phy->sys_clk);
-	dpll_params = ti_pipe3_get_dpll_params(rate);
-	if (!dpll_params) {
-		dev_err(phy->dev,
-			  "No DPLL configuration for %lu Hz SYS CLK\n", rate);
+	dpll_params = ti_pipe3_get_dpll_params(phy);
+	if (!dpll_params)
 		return -EINVAL;
-	}
 
 	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
 	val &= ~PLL_REGN_MASK;
@@ -244,6 +256,10 @@ static struct phy_ops ops = {
 	.owner		= THIS_MODULE,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id ti_pipe3_id_table[];
+#endif
+
 static int ti_pipe3_probe(struct platform_device *pdev)
 {
 	struct ti_pipe3 *phy;
@@ -253,8 +269,10 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 	struct device_node *control_node;
 	struct platform_device *control_pdev;
+	const struct of_device_id *match;
 
-	if (!node)
+	match = of_match_device(of_match_ptr(ti_pipe3_id_table), &pdev->dev);
+	if (!match)
 		return -EINVAL;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
@@ -263,6 +281,12 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	phy->dpll_map = (struct pipe3_dpll_map *)match->data;
+	if (!phy->dpll_map) {
+		dev_err(&pdev->dev, "no DPLL data\n");
+		return -EINVAL;
+	}
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pll_ctrl");
 	phy->pll_ctrl_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(phy->pll_ctrl_base))
@@ -388,8 +412,18 @@ static const struct dev_pm_ops ti_pipe3_pm_ops = {
 
 #ifdef CONFIG_OF
 static const struct of_device_id ti_pipe3_id_table[] = {
-	{ .compatible = "ti,phy-usb3" },
-	{ .compatible = "ti,omap-usb3" },
+	{
+		.compatible = "ti,phy-usb3",
+		.data = dpll_map_usb,
+	},
+	{
+		.compatible = "ti,omap-usb3",
+		.data = dpll_map_usb,
+	},
+	{
+		.compatible = "ti,phy-pipe3-sata",
+		.data = dpll_map_sata,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, ti_pipe3_id_table);
-- 
1.8.3.2

