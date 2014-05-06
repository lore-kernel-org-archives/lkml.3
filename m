Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbaEFNev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:34:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44169 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbaEFNer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:34:47 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 01/17] phy: phy-omap-pipe3: Add support for PCIe PHY
Date: Tue, 6 May 2014 19:03:47 +0530
Message-ID: <1399383244-14556-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCIe PHY uses an external pll instead of the internal pll used by SATA
and USB3. So added support in pipe3 PHY to use external pll.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy.txt |    8 +-
 drivers/phy/phy-ti-pipe3.c                       |   99 +++++++++++++++++-----
 2 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
index 9ce458f..cf3de7e 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -56,8 +56,8 @@ usb2phy@4a0ad080 {
 TI PIPE3 PHY
 
 Required properties:
- - compatible: Should be "ti,phy-usb3" or "ti,phy-pipe3-sata".
-   "ti,omap-usb3" is deprecated.
+ - compatible: Should be "ti,phy-usb3", "ti,phy-pipe3-sata" or
+   "ti,phy-pipe3-pcie. "ti,omap-usb3" is deprecated.
  - reg : Address and length of the register set for the device.
  - reg-names: The names of the register addresses corresponding to the registers
    filled in "reg".
@@ -69,6 +69,10 @@ Required properties:
    * "wkupclk" - wakeup clock.
    * "sysclk" - system clock.
    * "refclk" - reference clock.
+   * "dpll_ref" - external dpll ref clk
+   * "dpll_ref_m2" - external dpll ref clk
+   * "phy-div" - divider for apll
+   * "div-clk" - apll clock
 
 Optional properties:
  - ctrl-module : phandle of the control module used by PHY driver to power on
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 5913676..d43019d 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -80,6 +80,7 @@ struct ti_pipe3 {
 	struct clk		*wkupclk;
 	struct clk		*sys_clk;
 	struct clk		*refclk;
+	struct clk		*div_clk;
 	struct pipe3_dpll_map	*dpll_map;
 };
 
@@ -215,6 +216,9 @@ static int ti_pipe3_init(struct phy *x)
 	u32 val;
 	int ret = 0;
 
+	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-pcie"))
+		return 0;
+
 	/* Bring it out of IDLE if it is IDLE */
 	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
 	if (val & PLL_IDLE) {
@@ -238,8 +242,11 @@ static int ti_pipe3_exit(struct phy *x)
 	u32 val;
 	unsigned long timeout;
 
-	/* SATA DPLL can't be powered down due to Errata i783 */
-	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-sata"))
+	/* SATA DPLL can't be powered down due to Errata i783 and PCIe
+	 * does not have internal DPLL
+	 */
+	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-sata") ||
+	    of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-pcie"))
 		return 0;
 
 	/* Put DPLL in IDLE mode */
@@ -286,32 +293,41 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 	struct device_node *control_node;
 	struct platform_device *control_pdev;
 	const struct of_device_id *match;
-
-	match = of_match_device(of_match_ptr(ti_pipe3_id_table), &pdev->dev);
-	if (!match)
-		return -EINVAL;
+	struct clk *clk;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy) {
 		dev_err(&pdev->dev, "unable to alloc mem for TI PIPE3 PHY\n");
 		return -ENOMEM;
 	}
+	phy->dev		= &pdev->dev;
 
-	phy->dpll_map = (struct pipe3_dpll_map *)match->data;
-	if (!phy->dpll_map) {
-		dev_err(&pdev->dev, "no DPLL data\n");
-		return -EINVAL;
-	}
+	if (!of_device_is_compatible(node, "ti,phy-pipe3-pcie")) {
+		match = of_match_device(of_match_ptr(ti_pipe3_id_table),
+					&pdev->dev);
+		if (!match)
+			return -EINVAL;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pll_ctrl");
-	phy->pll_ctrl_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(phy->pll_ctrl_base))
-		return PTR_ERR(phy->pll_ctrl_base);
+		phy->dpll_map = (struct pipe3_dpll_map *)match->data;
+		if (!phy->dpll_map) {
+			dev_err(&pdev->dev, "no DPLL data\n");
+			return -EINVAL;
+		}
 
-	phy->dev		= &pdev->dev;
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   "pll_ctrl");
+		phy->pll_ctrl_base = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(phy->pll_ctrl_base))
+			return PTR_ERR(phy->pll_ctrl_base);
 
-	if (!of_device_is_compatible(node, "ti,phy-pipe3-sata")) {
+		phy->sys_clk = devm_clk_get(phy->dev, "sysclk");
+		if (IS_ERR(phy->sys_clk)) {
+			dev_err(&pdev->dev, "unable to get sysclk\n");
+			return -EINVAL;
+		}
+	}
 
+	if (!of_device_is_compatible(node, "ti,phy-pipe3-sata")) {
 		phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
 		if (IS_ERR(phy->wkupclk)) {
 			dev_err(&pdev->dev, "unable to get wkupclk\n");
@@ -328,10 +344,35 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 		phy->refclk = ERR_PTR(-ENODEV);
 	}
 
-	phy->sys_clk = devm_clk_get(phy->dev, "sysclk");
-	if (IS_ERR(phy->sys_clk)) {
-		dev_err(&pdev->dev, "unable to get sysclk\n");
-		return -EINVAL;
+	if (of_device_is_compatible(node, "ti,phy-pipe3-pcie")) {
+		clk = devm_clk_get(phy->dev, "dpll_ref");
+		if (IS_ERR(clk)) {
+			dev_err(&pdev->dev, "unable to get dpll ref clk\n");
+			return PTR_ERR(clk);
+		}
+		clk_set_rate(clk, 1500000000);
+
+		clk = devm_clk_get(phy->dev, "dpll_ref_m2");
+		if (IS_ERR(clk)) {
+			dev_err(&pdev->dev, "unable to get dpll ref m2 clk\n");
+			return PTR_ERR(clk);
+		}
+		clk_set_rate(clk, 100000000);
+
+		clk = devm_clk_get(phy->dev, "phy-div");
+		if (IS_ERR(clk)) {
+			dev_err(&pdev->dev, "unable to get phy-div clk\n");
+			return PTR_ERR(clk);
+		}
+		clk_set_rate(clk, 100000000);
+
+		phy->div_clk = devm_clk_get(phy->dev, "div-clk");
+		if (IS_ERR(phy->div_clk)) {
+			dev_err(&pdev->dev, "unable to get div-clk\n");
+			return PTR_ERR(phy->div_clk);
+		}
+	} else {
+		phy->div_clk = ERR_PTR(-ENODEV);
 	}
 
 	control_node = of_parse_phandle(node, "ctrl-module", 0);
@@ -387,6 +428,8 @@ static int ti_pipe3_runtime_suspend(struct device *dev)
 		clk_disable_unprepare(phy->wkupclk);
 	if (!IS_ERR(phy->refclk))
 		clk_disable_unprepare(phy->refclk);
+	if (!IS_ERR(phy->div_clk))
+		clk_disable_unprepare(phy->div_clk);
 
 	return 0;
 }
@@ -412,8 +455,19 @@ static int ti_pipe3_runtime_resume(struct device *dev)
 		}
 	}
 
+	if (!IS_ERR(phy->div_clk)) {
+		ret = clk_prepare_enable(phy->div_clk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable div_clk %d\n", ret);
+			goto err3;
+		}
+	}
 	return 0;
 
+err3:
+	if (!IS_ERR(phy->wkupclk))
+		clk_disable_unprepare(phy->wkupclk);
+
 err2:
 	if (!IS_ERR(phy->refclk))
 		clk_disable_unprepare(phy->refclk);
@@ -446,6 +500,9 @@ static const struct of_device_id ti_pipe3_id_table[] = {
 		.compatible = "ti,phy-pipe3-sata",
 		.data = dpll_map_sata,
 	},
+	{
+		.compatible = "ti,phy-pipe3-pcie",
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, ti_pipe3_id_table);
-- 
1.7.9.5

