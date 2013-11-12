Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3KLO45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:56:57 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51908 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066Ab3KLOyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:24 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Manu Gautam <mgautam@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 12/15] usb: phy: msm: Add support for secondary PHY control
Date: Tue, 12 Nov 2013 16:51:47 +0200
Message-Id: <1384267910-32066-13-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Allow support to use 2nd HSPHY with USB2 Core.
Some platforms may have configuration to allow USB controller
work with any of the two HSPHYs present. By default driver
configures USB core to use primary HSPHY. Add support to allow
user select 2nd HSPHY using DT parameter.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: Manu Gautam <mgautam@codeaurora.org>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |    6 +++++
 drivers/usb/phy/phy-msm-usb.c                      |   24 ++++++++++++++++++--
 include/linux/usb/msm_hsusb.h                      |    1 +
 include/linux/usb/msm_hsusb_hw.h                   |    1 +
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
index 3f21204..d105ba9 100644
--- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -72,6 +72,12 @@ Optional properties:
 - qcom,phy-init-sequence: PHY configuration sequence. val, reg pairs
 				terminate with -1
 
+- qcom,phy-num:	Select number of pyco-phy to use, can be one of
+				0 - PHY one, default
+				1 - Second PHY
+				Some platforms may have configuration to allow USB
+				controller work with any of the two HSPHYs present.
+
 Example HSUSB OTG controller device node:
 
 	usb@f9a55000 {
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 53fc645..01b571ff 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -340,6 +340,9 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 	if (!retries)
 		return -ETIMEDOUT;
 
+	if (motg->phy_number)
+		writel(readl(USB_PHY_CTRL2) | BIT(16), USB_PHY_CTRL2);
+
 	dev_info(motg->phy.dev, "phy_reset: success\n");
 	return 0;
 }
@@ -394,6 +397,9 @@ static int msm_otg_reset(struct usb_phy *phy)
 		ulpi_write(phy, ulpi_val, ULPI_USB_INT_EN_FALL);
 	}
 
+	if (motg->phy_number)
+		writel(readl(USB_PHY_CTRL2) | BIT(16), USB_PHY_CTRL2);
+
 	return 0;
 }
 
@@ -406,6 +412,7 @@ static int msm_otg_suspend(struct msm_otg *motg)
 	struct usb_phy *phy = &motg->phy;
 	struct usb_bus *bus = phy->otg->host;
 	struct msm_otg_platform_data *pdata = motg->pdata;
+	void __iomem *addr;
 	int cnt = 0;
 
 	if (atomic_read(&motg->in_lpm))
@@ -465,9 +472,13 @@ static int msm_otg_suspend(struct msm_otg *motg)
 	 */
 	writel(readl(USB_USBCMD) | ASYNC_INTR_CTRL | ULPI_STP_CTRL, USB_USBCMD);
 
+	addr = USB_PHY_CTRL;
+	if (motg->phy_number)
+		addr = USB_PHY_CTRL2;
+
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
 			motg->pdata->otg_control == OTG_PMIC_CONTROL)
-		writel(readl(USB_PHY_CTRL) | PHY_RETEN, USB_PHY_CTRL);
+		writel(readl(addr) | PHY_RETEN, addr);
 
 	clk_disable_unprepare(motg->pclk);
 	clk_disable_unprepare(motg->clk);
@@ -497,6 +508,7 @@ static int msm_otg_resume(struct msm_otg *motg)
 {
 	struct usb_phy *phy = &motg->phy;
 	struct usb_bus *bus = phy->otg->host;
+	void __iomem *addr;
 	int cnt = 0;
 	unsigned temp;
 
@@ -510,9 +522,14 @@ static int msm_otg_resume(struct msm_otg *motg)
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
 			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
+
+		addr = USB_PHY_CTRL;
+		if (motg->phy_number)
+			addr = USB_PHY_CTRL2;
+
 		msm_hsusb_ldo_set_mode(motg, 1);
 		msm_hsusb_config_vddcx(motg, 1);
-		writel(readl(USB_PHY_CTRL) & ~PHY_RETEN, USB_PHY_CTRL);
+		writel(readl(addr) & ~PHY_RETEN, addr);
 	}
 
 	temp = readl(USB_USBCMD);
@@ -1395,6 +1412,9 @@ static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
 	if (!of_property_read_u32(node, "qcom,otg-control", &val))
 		pdata->otg_control = val;
 
+	if (!of_property_read_u32(node, "qcom,phy-num", &val))
+		motg->phy_number = val;
+
 	if (!of_get_property(node, "qcom,phy-init-sequence", &len) || !len)
 		return 0;
 
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 9bf8943..da3a974 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -156,6 +156,7 @@ struct msm_otg {
 	atomic_t in_lpm;
 	int async_int;
 	unsigned cur_power;
+	int phy_number;
 	struct delayed_work chg_work;
 	enum usb_chg_state chg_state;
 	enum usb_chg_type chg_type;
diff --git a/include/linux/usb/msm_hsusb_hw.h b/include/linux/usb/msm_hsusb_hw.h
index 6e97a2d..e6d7035 100644
--- a/include/linux/usb/msm_hsusb_hw.h
+++ b/include/linux/usb/msm_hsusb_hw.h
@@ -25,6 +25,7 @@
 #define USB_OTGSC            (MSM_USB_BASE + 0x01A4)
 #define USB_USBMODE          (MSM_USB_BASE + 0x01A8)
 #define USB_PHY_CTRL         (MSM_USB_BASE + 0x0240)
+#define USB_PHY_CTRL2        (MSM_USB_BASE + 0x0278)
 
 #define USBCMD_RESET   2
 #define USB_USBINTR          (MSM_USB_BASE + 0x0148)
-- 
1.7.9.5

