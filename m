Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaDDWSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:18:33 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61118 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaDDWS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:18:28 -0400
From: Tim Bird <tbird20d@gmail.com>
To: iivanov@mm-sol.com
Cc: linux-arm-msm@vger.kernel.org, galak@codeaurora.org, balbi@ti.com,
        davidb@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Subject: [PATCH] usb: phy: msm: Select secondary PHY via TCSR
Date: Fri,  4 Apr 2014 15:18:11 -0700
Message-Id: <1396649891-2880-1-git-send-email-tim.bird@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select the secondary PHY using the TCSR register, if phy-num=1
in the DTS (or phy_number is set in the platform data).  The
SOC has 2 PHYs which can be used with the OTG port, and this
code allows configuring the correct one.

Note: This resolves the problem I was seeing where I couldn't
get the USB driver working at all on a dragonboard, from cold
boot.  This patch depends on patch 5/14 from Ivan's msm USB
patch set.  It does not use DT for the register address, as
there's no evidence that this address changes between SoC
versions.

Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
---
 drivers/usb/phy/phy-msm-usb.c    | 14 ++++++++++++++
 include/linux/usb/msm_hsusb_hw.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index c4820e6..0272489 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1518,6 +1518,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct msm_otg *motg;
 	struct usb_phy *phy;
+	void __iomem *phy_select;
 
 	motg = devm_kzalloc(&pdev->dev, sizeof(struct msm_otg), GFP_KERNEL);
 	if (!motg) {
@@ -1580,6 +1581,19 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	if (IS_ERR(motg->regs))
 		return PTR_ERR(motg->regs);
 
+	/*
+	 * NOTE: The PHYs can be multiplexed between the chipidea controller
+	 * and the dwc3 controller, using a single bit. It is important that
+	 * the dwc3 driver does not set this bit in an incompatible way.
+	 */
+	if (motg->phy_number) {
+		phy_select = devm_ioremap_nocache(&pdev->dev, USB2_PHY_SEL, 4);
+		if (IS_ERR(phy_select))
+			return PTR_ERR(phy_select);
+		/* Enable second PHY with the OTG port */
+		writel_relaxed(0x1, phy_select);
+	}
+
 	dev_info(&pdev->dev, "OTG regs = %p\n", motg->regs);
 
 	motg->irq = platform_get_irq(pdev, 0);
diff --git a/include/linux/usb/msm_hsusb_hw.h b/include/linux/usb/msm_hsusb_hw.h
index 575c743..10bf692 100644
--- a/include/linux/usb/msm_hsusb_hw.h
+++ b/include/linux/usb/msm_hsusb_hw.h
@@ -16,6 +16,9 @@
 #ifndef __LINUX_USB_GADGET_MSM72K_UDC_H__
 #define __LINUX_USB_GADGET_MSM72K_UDC_H__
 
+/* USB phy selector - in TCSR address range */
+#define USB2_PHY_SEL         0xfd4ab000
+
 #define USB_AHBBURST         (MSM_USB_BASE + 0x0090)
 #define USB_AHBMODE          (MSM_USB_BASE + 0x0098)
 #define USB_CAPLENGTH        (MSM_USB_BASE + 0x0100) /* 8 bit */
-- 
1.8.2.2

