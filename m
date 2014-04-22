Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaDVJXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:23:05 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53581 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbaDVJVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:21:46 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Manu Gautam <mgautam@codeaurora.org>
Subject: [PATCH v6 13/19] usb: phy: msm: Add support for secondary PHY control
Date: Tue, 22 Apr 2014 12:20:32 +0300
Message-Id: <1398158438-21579-14-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
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
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |  6 ++++++
 drivers/usb/phy/phy-msm-usb.c                      | 24 ++++++++++++++++++++--
 include/linux/usb/msm_hsusb.h                      |  1 +
 include/linux/usb/msm_hsusb_hw.h                   |  1 +
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
index ee4123d..0669667 100644
--- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -59,6 +59,12 @@ Optional properties:
                 For example: qcom,phy-init-sequence = < -1 0x63 >;
                 Will update only value at address ULPI_EXT_VENDOR_SPECIFIC + 1.

+- qcom,phy-num: Select number of pyco-phy to use, can be one of
+                0 - PHY one, default
+                1 - Second PHY
+                Some platforms may have configuration to allow USB
+                controller work with any of the two HSPHYs present.
+
 Example HSUSB OTG controller device node:

     usb@f9a55000 {
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index d47d940..b03d7f1 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -314,6 +314,9 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 	if (!retries)
 		return -ETIMEDOUT;

+	if (motg->phy_number)
+		writel(readl(USB_PHY_CTRL2) | BIT(16), USB_PHY_CTRL2);
+
 	dev_info(motg->phy.dev, "phy_reset: success\n");
 	return 0;
 }
@@ -368,6 +371,9 @@ static int msm_otg_reset(struct usb_phy *phy)
 		ulpi_write(phy, ulpi_val, ULPI_USB_INT_EN_FALL);
 	}

+	if (motg->phy_number)
+		writel(readl(USB_PHY_CTRL2) | BIT(16), USB_PHY_CTRL2);
+
 	return 0;
 }

@@ -404,6 +410,7 @@ static int msm_otg_suspend(struct msm_otg *motg)
 	struct usb_phy *phy = &motg->phy;
 	struct usb_bus *bus = phy->otg->host;
 	struct msm_otg_platform_data *pdata = motg->pdata;
+	void __iomem *addr;
 	int cnt = 0;

 	if (atomic_read(&motg->in_lpm))
@@ -463,9 +470,13 @@ static int msm_otg_suspend(struct msm_otg *motg)
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
@@ -495,6 +506,7 @@ static int msm_otg_resume(struct msm_otg *motg)
 {
 	struct usb_phy *phy = &motg->phy;
 	struct usb_bus *bus = phy->otg->host;
+	void __iomem *addr;
 	int cnt = 0;
 	unsigned temp;

@@ -508,9 +520,14 @@ static int msm_otg_resume(struct msm_otg *motg)

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
@@ -1396,6 +1413,9 @@ static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
 		if (val == OTG_PMIC_CONTROL)
 			pdata->otg_control = val;

+	if (!of_property_read_u32(node, "qcom,phy-num", &val) && val < 2)
+		motg->phy_number = val;
+
 	prop = of_find_property(node, "qcom,phy-init-sequence", &len);
 	if (!prop || !len)
 		return 0;
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 4e5d916..4628f1a 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -158,6 +158,7 @@ struct msm_otg {
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
1.8.3.2

