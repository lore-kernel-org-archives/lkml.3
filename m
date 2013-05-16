Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3EPOWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:22:25 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2052 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3EPOWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:22:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 16 May 2013 07:18:34 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v4 5/8] usb: phy: tegra: Get PHY mode using DT
Date: Thu, 16 May 2013 19:42:59 +0530
Message-ID: <1368713582-29038-6-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new PHY mode to support OTG.
Obtained Tegra USB PHY mode using DT property.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v3 & v2:
No change

delta from v1:
replaced gadget with peripheral.


 
drivers/usb/host/ehci-tegra.c     |    1 -
 drivers/usb/phy/phy-tegra-usb.c   |   13 +++++++++++--
 include/linux/usb/tegra_usb_phy.h |    3 ++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index e3eddc3..568a6fa 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -736,7 +736,6 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 	tegra->phy = tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
 					pdata->phy_config,
-					TEGRA_USB_PHY_MODE_HOST,
 					tegra_ehci_set_pts,
 					tegra_ehci_set_phcd);
 	if (IS_ERR(tegra->phy)) {
diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 8bcc12f..0ff1f3e 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -687,7 +687,7 @@ static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
 }
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode,
+	void __iomem *regs, void *config,
 	void (*set_pts)(struct usb_phy *x, u8 pts_val),
 	void (*set_phcd)(struct usb_phy *x, bool enable))
 
@@ -705,7 +705,6 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	phy->instance = instance;
 	phy->regs = regs;
 	phy->config = config;
-	phy->mode = phy_mode;
 	phy->dev = dev;
 	phy->is_legacy_phy =
 		of_property_read_bool(np, "nvidia,has-legacy-mode");
@@ -717,6 +716,16 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	else
 		phy->is_ulpi_phy = true;
 
+	err = of_property_match_string(np, "dr_mode", "otg");
+	if (err < 0) {
+		err = of_property_match_string(np, "dr_mode", "peripheral");
+		if (err < 0)
+			phy->mode = TEGRA_USB_PHY_MODE_HOST;
+		else
+			phy->mode = TEGRA_USB_PHY_MODE_DEVICE;
+	} else
+		phy->mode = TEGRA_USB_PHY_MODE_OTG;
+
 	if (!phy->config) {
 		if (phy->is_ulpi_phy) {
 			pr_err("%s: ulpi phy configuration missing", __func__);
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 1b7519a..ff2d959 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -42,6 +42,7 @@ enum tegra_usb_phy_port_speed {
 enum tegra_usb_phy_mode {
 	TEGRA_USB_PHY_MODE_DEVICE,
 	TEGRA_USB_PHY_MODE_HOST,
+	TEGRA_USB_PHY_MODE_OTG,
 };
 
 struct tegra_xtal_freq;
@@ -66,7 +67,7 @@ struct tegra_usb_phy {
 };
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode,
+	void __iomem *regs, void *config,
 	void (*set_pts)(struct usb_phy *x, u8 pts_val),
 	void (*set_phcd)(struct usb_phy *x, bool enable));
 
-- 
1.7.0.4

