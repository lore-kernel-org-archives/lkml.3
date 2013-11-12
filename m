Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3KLO5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:57:24 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51878 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab3KLOyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:22 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 10/15] usb: phy: msm: Add device tree support and binding information
Date: Tue, 12 Nov 2013 16:51:45 +0200
Message-Id: <1384267910-32066-11-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Allows MSM OTG controller to be specified via device tree.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |   57 +++++++++++++-
 drivers/usb/phy/phy-msm-usb.c                      |   79 +++++++++++++++++---
 2 files changed, 124 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
index 0a85eba..f1045e3 100644
--- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -30,4 +30,59 @@ Required properties:
 		dr_mode = "peripheral";
 		interrupts = <0 134 0>;
 		usb-phy = <&usb_otg>;
-	};
\ No newline at end of file
+	};
+
+USB PHY with optional OTG:
+
+Required properties:
+- compatible:	should contain "qcom,usb-otg-ci" for chipsets with
+				Chipidea 45nm PHY or "qcom,usb-otg-snps" for chipsets
+				with Synopsys 28nm PHY
+- regs:			offset and length of the register set in the memory map
+- interrupts:	interrupt-specifier for the OTG interrupt.
+
+- clocks:		A list of phandle + clock-specifier pairs for the
+				clocks listed in clock-names
+- clock-names:	Should contain the following:
+  "phy"			USB PHY reference clock
+  "core"		Protocol engine clock
+  "iface"		Interface bus clock
+  "alt_core"	Optional: Protocol engine clock for targets with asynchronous
+				reset methodology.
+
+- dr_mode:		One of "host", "peripheral" or "otg". Defaults to "otg"
+
+- vdccx-supply:	phandle to the regulator for the vdd supply for
+				digital circuit operation.
+- v1p8-supply:	phandle to the regulator for the 1.8V supply
+- v3p3-supply:	phandle to the regulator for the 3.3V supply
+
+- qcom,otg-control: OTG control (VBUS and ID notifications) can be one of
+				1 - PHY control
+				2 - PMIC control
+				3 - User control (via debugfs)
+
+Optional properties:
+- qcom,phy-init-sequence: PHY configuration sequence. val, reg pairs
+				terminate with -1
+
+Example HSUSB OTG controller device node:
+
+	usb@f9a55000 {
+		compatible = "qcom,usb-otg-snps";
+		reg = <0xf9a55000 0x400>;
+		interrupts = <0 134 0>;;
+		dr_mode = "peripheral";
+
+		clocks = <&gcc GCC_XO_CLK>, <&gcc GCC_USB_HS_SYSTEM_CLK>,
+				<&gcc GCC_USB_HS_AHB_CLK>;
+
+		clock-names = "phy", "core", "iface";
+
+		vddcx-supply = <&pm8841_s2_corner>;
+		v1p8-supply = <&pm8941_l6>;
+		v3p3-supply = <&pm8941_l24>;
+
+		qcom,otg-control = <1>;
+		qcom,phy-init-sequence = <0x01 0x90 0xffffffff>;
+	};
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index fa8e672d..cc230c8 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -30,9 +30,12 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <linux/usb.h>
 #include <linux/usb/otg.h>
+#include <linux/usb/of.h>
 #include <linux/usb/ulpi.h>
 #include <linux/usb/gadget.h>
 #include <linux/usb/hcd.h>
@@ -1343,25 +1346,75 @@ static void msm_otg_debugfs_cleanup(void)
 	debugfs_remove(msm_otg_dbg_root);
 }
 
+static struct of_device_id msm_otg_dt_match[] = {
+	{
+		.compatible = "qcom,usb-otg-ci",
+		.data = (void *) CI_45NM_INTEGRATED_PHY
+	}, {
+		.compatible = "qcom,usb-otg-snps",
+		.data = (void *) SNPS_28NM_INTEGRATED_PHY
+	}, {}
+};
+
+static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
+{
+	struct msm_otg_platform_data *pdata;
+	const struct of_device_id *id;
+	struct device_node *node = pdev->dev.of_node;
+	int len = 0;
+	u32 val;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	motg->pdata = pdata;
+
+	id = of_match_device(msm_otg_dt_match, &pdev->dev);
+	pdata->phy_type = (int) id->data;
+
+	pdata->mode = of_usb_get_dr_mode(node);
+	if (pdata->mode == USB_DR_MODE_UNKNOWN)
+		pdata->mode = USB_DR_MODE_OTG;
+
+	pdata->otg_control = OTG_PHY_CONTROL;
+	if (!of_property_read_u32(node, "qcom,otg-control", &val))
+		pdata->otg_control = val;
+
+	if (!of_get_property(node, "qcom,phy-init-sequence", &len) || !len)
+		return 0;
+
+	pdata->phy_init_seq = devm_kzalloc(&pdev->dev, len, GFP_KERNEL);
+	if (!pdata->phy_init_seq)
+		return 0;
+
+	of_property_read_u32_array(node, "qcom,phy-init-sequence",
+				   pdata->phy_init_seq,
+				   len / sizeof(*pdata->phy_init_seq));
+	return 0;
+}
+
 static int __init msm_otg_probe(struct platform_device *pdev)
 {
 	int ret = 0;
+	struct device_node *np = pdev->dev.of_node;
+	struct msm_otg_platform_data *pdata;
 	struct resource *res;
 	struct msm_otg *motg;
 	struct usb_phy *phy;
 
-	dev_info(&pdev->dev, "msm_otg probe\n");
-	if (!dev_get_platdata(&pdev->dev)) {
-		dev_err(&pdev->dev, "No platform data given. Bailing out\n");
-		return -ENODEV;
-	}
-
 	motg = devm_kzalloc(&pdev->dev, sizeof(struct msm_otg), GFP_KERNEL);
 	if (!motg) {
 		dev_err(&pdev->dev, "unable to allocate msm_otg\n");
 		return -ENOMEM;
 	}
 
+	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata)
+		ret = msm_otg_read_dt(pdev, motg);
+		if (ret)
+			return ret;
+
 	motg->phy.otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
 				     GFP_KERNEL);
 	if (!motg->phy.otg) {
@@ -1369,17 +1422,17 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	motg->pdata = dev_get_platdata(&pdev->dev);
 	phy = &motg->phy;
 	phy->dev = &pdev->dev;
 
-	motg->phy_reset_clk = devm_clk_get(&pdev->dev, "usb_phy_clk");
+	motg->phy_reset_clk = devm_clk_get(&pdev->dev,
+					   np ? "phy" : "usb_phy_clk");
 	if (IS_ERR(motg->phy_reset_clk)) {
 		dev_err(&pdev->dev, "failed to get usb_phy_clk\n");
 		return PTR_ERR(motg->phy_reset_clk);
 	}
 
-	motg->clk = devm_clk_get(&pdev->dev, "usb_hs_clk");
+	motg->clk = devm_clk_get(&pdev->dev, np ? "core" : "usb_hs_clk");
 	if (IS_ERR(motg->clk)) {
 		dev_err(&pdev->dev, "failed to get usb_hs_clk\n");
 		return PTR_ERR(motg->clk);
@@ -1391,7 +1444,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	 * operation and USB core cannot tolerate frequency changes on
 	 * CORE CLK.
 	 */
-	motg->pclk = devm_clk_get(&pdev->dev, "usb_hs_pclk");
+	motg->pclk = devm_clk_get(&pdev->dev, np ? "iface" : "usb_hs_pclk");
 	if (IS_ERR(motg->pclk)) {
 		dev_err(&pdev->dev, "failed to get usb_hs_pclk\n");
 		return PTR_ERR(motg->pclk);
@@ -1402,7 +1455,8 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	 * clock is introduced to remove the dependency on AXI
 	 * bus frequency.
 	 */
-	motg->core_clk = devm_clk_get(&pdev->dev, "usb_hs_core_clk");
+	motg->core_clk = devm_clk_get(&pdev->dev,
+				      np ? "alt_core" : "usb_hs_core_clk");
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	motg->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
@@ -1639,6 +1693,8 @@ static const struct dev_pm_ops msm_otg_dev_pm_ops = {
 };
 #endif
 
+MODULE_DEVICE_TABLE(of, msm_otg_dt_match);
+
 static struct platform_driver msm_otg_driver = {
 	.probe = msm_otg_probe,
 	.remove = msm_otg_remove,
@@ -1648,6 +1704,7 @@ static struct platform_driver msm_otg_driver = {
 #ifdef CONFIG_PM
 		.pm = &msm_otg_dev_pm_ops,
 #endif
+		.of_match_table = msm_otg_dt_match,
 	},
 };
 
-- 
1.7.9.5

