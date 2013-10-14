Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab3JNP0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:26:34 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49846 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982Ab3JNP0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:26:08 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, jackp@codeaurora.org, mgautam@codeaurora.org,
        dsegal@codeaurora.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v3 13/13] usb: phy: msm: Add device tree support and binding information
Date: Mon, 14 Oct 2013 18:24:40 +0300
Message-Id: <1381764280-28420-14-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Allows MSM OTG controller to be specified via device tree.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |   58 +++++++++++++++++++
 drivers/usb/phy/phy-msm-usb.c                      |   59 ++++++++++++++++++--
 2 files changed, 112 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
index 5ea26c6..4ed8d1a 100644
--- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -15,3 +15,61 @@ Example EHCI controller device node:
 		usb-phy = <&usb_otg>;
 	};
 
+
+OTG:
+
+Required properties:
+- compatible:	should contain "qcom,hsusb-otg"
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
+- qcom,phy-type: PHY type can be one of
+				1 - Chipidea 45nm PHY
+				2 - Synopsis 28nm PHY
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
+		compatible = "qcom,hsusb-otg";
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
+		qcom,phy-type = <2>;
+		qcom,phy-init-sequence = <0x01 0x90 0xffffffff>;
+	};
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index f34c8a9..1ecea6f 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -30,9 +30,11 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
 
 #include <linux/usb.h>
 #include <linux/usb/otg.h>
+#include <linux/usb/of.h>
 #include <linux/usb/ulpi.h>
 #include <linux/usb/gadget.h>
 #include <linux/usb/hcd.h>
@@ -1342,17 +1344,57 @@ static void msm_otg_debugfs_cleanup(void)
 	debugfs_remove(msm_otg_dbg_root);
 }
 
+struct msm_otg_platform_data *msm_otg_dt_to_pdata(struct platform_device *pdev)
+{
+	struct msm_otg_platform_data *pdata;
+	struct device_node *node = pdev->dev.of_node;
+	int len = 0;
+	u32 val;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&pdev->dev, "unable to allocate platform data\n");
+		return NULL;
+	}
+
+	pdata->mode = of_usb_get_dr_mode(node);
+	if (pdata->mode == USB_DR_MODE_UNKNOWN)
+		pdata->mode = USB_DR_MODE_OTG;
+
+	pdata->otg_control = OTG_PHY_CONTROL;
+	if (!of_property_read_u32(node, "qcom,otg-control", &val))
+		pdata->otg_control = val;
+
+	pdata->phy_type = CI_45NM_INTEGRATED_PHY;
+	if (!of_property_read_u32(node, "qcom,phy-type", &val))
+		pdata->phy_type = val;
+
+	if (!of_get_property(node, "qcom,phy-init-sequence", &len) || !len)
+		return pdata;
+
+	pdata->phy_init_seq = devm_kzalloc(&pdev->dev, len, GFP_KERNEL);
+	if (!pdata->phy_init_seq)
+		return pdata;
+
+	of_property_read_u32_array(node, "qcom,phy-init-sequence",
+				   pdata->phy_init_seq,
+				   len / sizeof(*pdata->phy_init_seq));
+	return pdata;
+}
+
 static int __init msm_otg_probe(struct platform_device *pdev)
 {
 	int ret = 0;
+	struct msm_otg_platform_data *pdata;
 	struct resource *res;
 	struct msm_otg *motg;
 	struct usb_phy *phy;
 
-	dev_info(&pdev->dev, "msm_otg probe\n");
-	if (!dev_get_platdata(&pdev->dev)) {
-		dev_err(&pdev->dev, "No platform data given. Bailing out\n");
-		return -ENODEV;
+	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata) {
+		pdata = msm_otg_dt_to_pdata(pdev);
+		if (!pdata)
+			return -ENOMEM;
 	}
 
 	motg = devm_kzalloc(&pdev->dev, sizeof(struct msm_otg), GFP_KERNEL);
@@ -1368,7 +1410,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	motg->pdata = dev_get_platdata(&pdev->dev);
+	motg->pdata = pdata;
 	phy = &motg->phy;
 	phy->dev = &pdev->dev;
 
@@ -1643,6 +1685,12 @@ static const struct dev_pm_ops msm_otg_dev_pm_ops = {
 };
 #endif
 
+static struct of_device_id msm_otg_dt_match[] = {
+	{ .compatible = "qcom,hsusb-otg", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, msm_otg_dt_match);
+
 static struct platform_driver msm_otg_driver = {
 	.probe = msm_otg_probe,
 	.remove = msm_otg_remove,
@@ -1652,6 +1700,7 @@ static struct platform_driver msm_otg_driver = {
 #ifdef CONFIG_PM
 		.pm = &msm_otg_dev_pm_ops,
 #endif
+		.of_match_table = msm_otg_dt_match,
 	},
 };
 
-- 
1.7.9.5

