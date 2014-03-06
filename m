Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaCFOji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:39:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58851 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaCFOjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:39:35 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Subject: [PATCH v2 04/13] phy: ti-pipe3: cleanup clock handling
Date: Thu, 6 Mar 2014 16:38:40 +0200
Message-ID: <1394116729-28811-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394116729-28811-1-git-send-email-rogerq@ti.com>
References: <1394116729-28811-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this driver is no longer USB specific, use generic clock names.
- Use 'wkupclk', 'sysclk' and 'refclk' clock-names. Update DT binding info.
- Fix PLL_SD_SHIFT from 9 to 10
- Don't separate prepare/unprepare clock from enable/disable. This
ensures optimal power savings.

Update omap5 usb3_phy device tree node.

CC: Benoît Cousson <bcousson@baylibre.com>
CC: Tony Lindgren <tony@atomide.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy.txt | 12 ++++++
 arch/arm/boot/dts/omap5.dtsi                     |  7 ++-
 drivers/phy/phy-ti-pipe3.c                       | 55 ++++++++++++------------
 3 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
index 28e674b..8d13349 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -59,6 +59,12 @@ Required properties:
    filled in "reg".
  - #phy-cells: determine the number of cells that should be given in the
    phandle while referencing this phy.
+ - clocks: a list of phandles and clock-specifier pairs, one for each entry in
+   clock-names.
+ - clock-names: should include:
+   * "wkupclk" - wakup clock.
+   * "sysclk" - system clock.
+   * "refclk" - reference clock.
 
 Optional properties:
  - ctrl-module : phandle of the control module used by PHY driver to power on
@@ -74,4 +80,10 @@ usb3phy@4a084400 {
 	reg-names = "phy_rx", "phy_tx", "pll_ctrl";
 	ctrl-module = <&omap_control_usb>;
 	#phy-cells = <0>;
+	clocks = <&usb_phy_cm_clk32k>,
+		 <&sys_clkin>,
+		 <&usb_otg_ss_refclk960m>;
+	clock-names =	"wkupclk",
+			"sysclk",
+			"refclk";
 };
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 859a800..e47601a 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -778,7 +778,12 @@
 				      <0x4a084800 0x64>,
 				      <0x4a084c00 0x40>;
 				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
-				ctrl-module = <&omap_control_usb3phy>;
+				clocks = <&usb_phy_cm_clk32k>,
+					 <&sys_clkin>,
+					 <&usb_otg_ss_refclk960m>;
+				clock-names =	"wkupclk",
+						"sysclk",
+						"refclk";
 				#phy-cells = <0>;
 			};
 		};
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index fd029b1..211703c 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -45,7 +45,7 @@
 #define	PLL_SELFREQDCO_MASK	0x0000000E
 #define	PLL_SELFREQDCO_SHIFT	0x1
 #define	PLL_SD_MASK		0x0003FC00
-#define	PLL_SD_SHIFT		0x9
+#define	PLL_SD_SHIFT		10
 #define	SET_PLL_GO		0x1
 #define	PLL_TICOPWDN		0x10000
 #define	PLL_LOCK		0x2
@@ -72,7 +72,7 @@ struct ti_pipe3 {
 	struct device		*control_dev;
 	struct clk		*wkupclk;
 	struct clk		*sys_clk;
-	struct clk		*optclk;
+	struct clk		*refclk;
 };
 
 struct pipe3_dpll_map {
@@ -270,23 +270,21 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 
 	phy->dev		= &pdev->dev;
 
-	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
+	phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
 	if (IS_ERR(phy->wkupclk)) {
-		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
+		dev_err(&pdev->dev, "unable to get wkupclk\n");
 		return PTR_ERR(phy->wkupclk);
 	}
-	clk_prepare(phy->wkupclk);
 
-	phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
-	if (IS_ERR(phy->optclk)) {
-		dev_err(&pdev->dev, "unable to get usb_otg_ss_refclk960m\n");
-		return PTR_ERR(phy->optclk);
+	phy->refclk = devm_clk_get(phy->dev, "refclk");
+	if (IS_ERR(phy->refclk)) {
+		dev_err(&pdev->dev, "unable to get refclk\n");
+		return PTR_ERR(phy->refclk);
 	}
-	clk_prepare(phy->optclk);
 
-	phy->sys_clk = devm_clk_get(phy->dev, "sys_clkin");
+	phy->sys_clk = devm_clk_get(phy->dev, "sysclk");
 	if (IS_ERR(phy->sys_clk)) {
-		pr_err("%s: unable to get sys_clkin\n", __func__);
+		dev_err(&pdev->dev, "unable to get sysclk\n");
 		return -EINVAL;
 	}
 
@@ -326,10 +324,6 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 
 static int ti_pipe3_remove(struct platform_device *pdev)
 {
-	struct ti_pipe3 *phy = platform_get_drvdata(pdev);
-
-	clk_unprepare(phy->wkupclk);
-	clk_unprepare(phy->optclk);
 	if (!pm_runtime_suspended(&pdev->dev))
 		pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -343,8 +337,10 @@ static int ti_pipe3_runtime_suspend(struct device *dev)
 {
 	struct ti_pipe3	*phy = dev_get_drvdata(dev);
 
-	clk_disable(phy->wkupclk);
-	clk_disable(phy->optclk);
+	if (!IS_ERR(phy->wkupclk))
+		clk_disable_unprepare(phy->wkupclk);
+	if (!IS_ERR(phy->refclk))
+		clk_disable_unprepare(phy->refclk);
 
 	return 0;
 }
@@ -354,22 +350,27 @@ static int ti_pipe3_runtime_resume(struct device *dev)
 	u32 ret = 0;
 	struct ti_pipe3	*phy = dev_get_drvdata(dev);
 
-	ret = clk_enable(phy->optclk);
-	if (ret) {
-		dev_err(phy->dev, "Failed to enable optclk %d\n", ret);
-		goto err1;
+	if (!IS_ERR(phy->refclk)) {
+		ret = clk_prepare_enable(phy->refclk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable refclk %d\n", ret);
+			goto err1;
+		}
 	}
 
-	ret = clk_enable(phy->wkupclk);
-	if (ret) {
-		dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
-		goto err2;
+	if (!IS_ERR(phy->wkupclk)) {
+		ret = clk_prepare_enable(phy->wkupclk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
+			goto err2;
+		}
 	}
 
 	return 0;
 
 err2:
-	clk_disable(phy->optclk);
+	if (!IS_ERR(phy->refclk))
+		clk_disable_unprepare(phy->refclk);
 
 err1:
 	return ret;
-- 
1.8.3.2

