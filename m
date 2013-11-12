Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3KLOy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:54:58 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51848 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab3KLOyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:25 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Mayank Rana <mrana@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 15/15] usb: phy: msm: Vote for corner of VDD CX instead of voltage of VDD CX
Date: Tue, 12 Nov 2013 16:51:50 +0200
Message-Id: <1384267910-32066-16-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

New platform uses RBCPR hardware feature, with that voting for
absolute voltage of VDD CX is not required. Hence vote for corner of
VDD CX which uses nominal corner voltage on VDD CX.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: Mayank Rana <mrana@codeaurora.org>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |    6 ++++
 drivers/usb/phy/phy-msm-usb.c                      |   35 +++++++++++++++-----
 include/linux/usb/msm_hsusb.h                      |    1 +
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
index d105ba9..7b46395 100644
--- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -78,6 +78,11 @@ Optional properties:
 				Some platforms may have configuration to allow USB
 				controller work with any of the two HSPHYs present.
 
+- qcom,vdd-levels: This property must be a list of three integer
+				values (no, min, max) where each value represents
+				either a voltage in microvolts or a value corresponding
+				to voltage corner.
+
 Example HSUSB OTG controller device node:
 
 	usb@f9a55000 {
@@ -100,4 +105,5 @@ Example HSUSB OTG controller device node:
 
 		qcom,otg-control = <1>;
 		qcom,phy-init-sequence = <0x01 0x90 0xffffffff>;
+		qcom,vdd-levels = <1 5 7>;
 	};
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 970f96b..b6e18b6 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -62,6 +62,13 @@
 
 #define USB_PHY_VDD_DIG_VOL_MIN	1000000 /* uV */
 #define USB_PHY_VDD_DIG_VOL_MAX	1320000 /* uV */
+#define USB_PHY_SUSP_DIG_VOL	500000  /* uV */
+
+enum vdd_levels {
+	VDD_LEVEL_NONE = 0,
+	VDD_LEVEL_MIN,
+	VDD_LEVEL_MAX,
+};
 
 static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 {
@@ -69,8 +76,8 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 
 	if (init) {
 		ret = regulator_set_voltage(motg->vddcx,
-				USB_PHY_VDD_DIG_VOL_MIN,
-				USB_PHY_VDD_DIG_VOL_MAX);
+				motg->vdd_levels[VDD_LEVEL_MIN],
+				motg->vdd_levels[VDD_LEVEL_MAX]);
 		if (ret) {
 			dev_err(motg->phy.dev, "Cannot set vddcx voltage\n");
 			return ret;
@@ -81,7 +88,7 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 			dev_err(motg->phy.dev, "unable to enable hsusb vddcx\n");
 	} else {
 		ret = regulator_set_voltage(motg->vddcx, 0,
-			USB_PHY_VDD_DIG_VOL_MAX);
+				motg->vdd_levels[VDD_LEVEL_MAX]);
 		if (ret)
 			dev_err(motg->phy.dev, "Cannot set vddcx voltage\n");
 		ret = regulator_disable(motg->vddcx);
@@ -131,17 +138,16 @@ exit:
 }
 
 #ifdef CONFIG_PM_SLEEP
-#define USB_PHY_SUSP_DIG_VOL  500000
 static int msm_hsusb_config_vddcx(struct msm_otg *motg, int high)
 {
-	int max_vol = USB_PHY_VDD_DIG_VOL_MAX;
+	int max_vol = motg->vdd_levels[VDD_LEVEL_MAX];
 	int min_vol;
 	int ret;
 
 	if (high)
-		min_vol = USB_PHY_VDD_DIG_VOL_MIN;
+		min_vol = motg->vdd_levels[VDD_LEVEL_MIN];
 	else
-		min_vol = USB_PHY_SUSP_DIG_VOL;
+		min_vol = motg->vdd_levels[VDD_LEVEL_NONE];
 
 	ret = regulator_set_voltage(motg->vddcx, min_vol, max_vol);
 	if (ret) {
@@ -1437,7 +1443,7 @@ static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
 	const struct of_device_id *id;
 	struct device_node *node = pdev->dev.of_node;
 	int len = 0;
-	u32 val;
+	u32 val, tmp[3];
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -1467,6 +1473,19 @@ static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
 	if (!of_property_read_u32(node, "qcom,phy-num", &val))
 		motg->phy_number = val;
 
+	motg->vdd_levels[VDD_LEVEL_NONE] = USB_PHY_SUSP_DIG_VOL;
+	motg->vdd_levels[VDD_LEVEL_MIN] = USB_PHY_VDD_DIG_VOL_MIN;
+	motg->vdd_levels[VDD_LEVEL_MAX] = USB_PHY_VDD_DIG_VOL_MAX;
+
+	if (of_get_property(node, "qcom,vdd-levels", &len) &&
+	    len == sizeof(tmp)) {
+		of_property_read_u32_array(node, "qcom,vdd-levels",
+					   tmp, len / sizeof(*tmp));
+		motg->vdd_levels[VDD_LEVEL_NONE] = tmp[VDD_LEVEL_NONE];
+		motg->vdd_levels[VDD_LEVEL_MIN] = tmp[VDD_LEVEL_MIN];
+		motg->vdd_levels[VDD_LEVEL_MAX] = tmp[VDD_LEVEL_MAX];
+	}
+
 	if (!of_get_property(node, "qcom,phy-init-sequence", &len) || !len)
 		return 0;
 
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index da3a974..f612cb9 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -167,6 +167,7 @@ struct msm_otg {
 
 	struct reset_control *phy_rst;
 	struct reset_control *link_rst;
+	int vdd_levels[3];
 };
 
 #endif
-- 
1.7.9.5

