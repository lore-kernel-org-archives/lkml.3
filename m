Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762883Ab3DCIzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:55:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10018 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3DCIqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:46:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 03 Apr 2013 01:45:58 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <linux-tegra@vger.kernel.org>, <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v2 3/7] usb: phy: tegra: Get PHY mode using DT
Date: Wed, 3 Apr 2013 14:11:38 +0530
Message-ID: <1364978502-22887-4-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com>
References: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com>
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
delta from v1:
replaced gadget with peripheral.

 drivers/usb/host/ehci-tegra.c     |    3 +--
 drivers/usb/phy/phy-tegra-usb.c   |   13 +++++++++++--
 include/linux/usb/tegra_usb_phy.h |    3 ++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 1d2488c..afe9629 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -732,8 +732,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	}
 
 	tegra->phy = tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
-					pdata->phy_config,
-					TEGRA_USB_PHY_MODE_HOST);
+					pdata->phy_config);
 	if (IS_ERR(tegra->phy)) {
 		dev_err(&pdev->dev, "Failed to open USB phy\n");
 		err = -ENXIO;
diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 5487d38..91b6e29 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -688,7 +688,7 @@ static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
 }
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode)
+	void __iomem *regs, void *config)
 {
 	struct tegra_usb_phy *phy;
 	unsigned long parent_rate;
@@ -703,7 +703,6 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	phy->instance = instance;
 	phy->regs = regs;
 	phy->config = config;
-	phy->mode = phy_mode;
 	phy->dev = dev;
 	phy->is_legacy_phy =
 		of_property_read_bool(np, "nvidia,has-legacy-mode");
@@ -713,6 +712,16 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
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
index 9ebebe9..a7af923 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -42,6 +42,7 @@ enum tegra_usb_phy_port_speed {
 enum tegra_usb_phy_mode {
 	TEGRA_USB_PHY_MODE_DEVICE,
 	TEGRA_USB_PHY_MODE_HOST,
+	TEGRA_USB_PHY_MODE_OTG,
 };
 
 struct tegra_xtal_freq;
@@ -64,7 +65,7 @@ struct tegra_usb_phy {
 };
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode);
+	void __iomem *regs, void *config);
 
 void tegra_usb_phy_preresume(struct usb_phy *phy);
 
-- 
1.7.0.4

