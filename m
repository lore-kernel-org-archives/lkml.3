Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3F1Vio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:38:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13542 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3F1ViC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:38:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 28 Jun 2013 14:35:51 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 2/9] usb: host: tegra: Remove leftover code
Date: Sat, 29 Jun 2013 00:37:00 +0300
Message-ID: <1372455427-20898-3-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ehci-tegra calls devm_usb_get_phy, which will never succeed since the Tegra
PHY does not register itself with the PHY subsystem. It is also completely
redundant since the code has already located a PHY via an internal API.

Call otg_set_host unconditionally to simplify the code since it should
be safe to do so.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 14c1f35..06e8feb 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -58,7 +58,6 @@ static int (*orig_hub_control)(struct usb_hcd *hcd,
 struct tegra_ehci_hcd {
 	struct tegra_usb_phy *phy;
 	struct clk *clk;
-	struct usb_phy *transceiver;
 	int port_resuming;
 	bool needs_double_reset;
 	enum tegra_usb_phy_port_speed port_speed;
@@ -436,26 +435,18 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		goto cleanup_phy;
 	}
 
-	if (pdata->operating_mode == TEGRA_USB_OTG) {
-		tegra->transceiver =
-			devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
-		if (!IS_ERR(tegra->transceiver))
-			otg_set_host(tegra->transceiver->otg, &hcd->self);
-	} else {
-		tegra->transceiver = ERR_PTR(-ENODEV);
-	}
+	otg_set_host(u_phy->otg, &hcd->self);
 
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to add USB HCD\n");
-		goto cleanup_transceiver;
+		goto cleanup_otg_set_host;
 	}
 
 	return err;
 
-cleanup_transceiver:
-	if (!IS_ERR(tegra->transceiver))
-		otg_set_host(tegra->transceiver->otg, NULL);
+cleanup_otg_set_host:
+	otg_set_host(u_phy->otg, NULL);
 cleanup_phy:
 	usb_phy_shutdown(hcd->phy);
 cleanup_clk_en:
@@ -473,8 +464,7 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 	struct tegra_ehci_hcd *tegra =
 		(struct tegra_ehci_hcd *)hcd_to_ehci(hcd)->priv;
 
-	if (!IS_ERR(tegra->transceiver))
-		otg_set_host(tegra->transceiver->otg, NULL);
+	otg_set_host(hcd->phy->otg, NULL);
 
 	usb_phy_shutdown(hcd->phy);
 	usb_remove_hcd(hcd);
-- 
1.8.1.5

