Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbaD1Nge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:36:34 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58347 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbaD1NfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:35:23 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Subject: [PATCH v8 17/20] usb: phy: msm: Select secondary PHY via TCSR
Date: Mon, 28 Apr 2014 16:34:20 +0300
Message-Id: <1398692063-11372-18-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Bird <tbird20d@gmail.com>

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
index db8d963..9437bcf 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1489,6 +1489,7 @@ static int msm_otg_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct msm_otg *motg;
 	struct usb_phy *phy;
+	void __iomem *phy_select;

 	motg = devm_kzalloc(&pdev->dev, sizeof(struct msm_otg), GFP_KERNEL);
 	if (!motg) {
@@ -1553,6 +1554,19 @@ static int msm_otg_probe(struct platform_device *pdev)
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
index 98d3dd8..a29f603 100644
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
1.8.3.2

