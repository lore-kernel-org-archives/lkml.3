Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaCEKRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:17:07 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54710 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbaCEKPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:15:16 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>, Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mayank Rana <mrana@codeaurora.org>
Subject: [PATCH v5 14/14] usb: phy: msm: Vote for corner of VDD CX instead of voltage of VDD CX
Date: Wed,  5 Mar 2014 12:13:50 +0200
Message-Id: <1394014430-26485-15-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com>
References: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

New platform uses RBCPR hardware feature, with that voting for
absolute voltage of VDD CX is not required. Hence vote for corner of
VDD CX which uses nominal corner voltage on VDD CX.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: Mayank Rana <mrana@codeaurora.org>
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |    5 +++
 drivers/usb/phy/phy-msm-usb.c                      |   35 +++++++++++++++-----
 include/linux/usb/msm_hsusb.h                      |    1 +
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
index 0669667..2826f2a 100644
--- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -65,6 +65,10 @@ Optional properties:
                 Some platforms may have configuration to allow USB
                 controller work with any of the two HSPHYs present.

+- qcom,vdd-levels: This property must be a list of three integer values
+                (no, min, max) where each value represents either a voltage
+                in microvolts or a value corresponding to voltage corner.
+
 Example HSUSB OTG controller device node:

     usb@f9a55000 {
@@ -87,4 +91,5 @@ Example HSUSB OTG controller device node:

         qcom,otg-control = <1>;
         qcom,phy-init-sequence = < -1 0x63 >;
+        qcom,vdd-levels = <1 5 7>;
 	};
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index f1e74a7..574f560 100644
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
@@ -435,17 +442,16 @@ static int msm_phy_init(struct usb_phy *phy)

 #ifdef CONFIG_PM

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
@@ -1438,7 +1444,7 @@ static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
 	struct device_node *node = pdev->dev.of_node;
 	struct property *prop;
 	int len, ret;
-	u32 val;
+	u32 val, tmp[3];

 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -1469,6 +1475,19 @@ static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
 	if (!of_property_read_u32(node, "qcom,phy-num", &val) && val < 2)
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
 	prop = of_find_property(node, "qcom,phy-init-sequence", &len);
 	if (!prop || !len)
 		return 0;
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 4628f1a..b0a3924 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -169,6 +169,7 @@ struct msm_otg {

 	struct reset_control *phy_rst;
 	struct reset_control *link_rst;
+	int vdd_levels[3];
 };

 #endif
--
1.7.9.5

