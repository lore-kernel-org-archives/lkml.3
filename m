Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3AXK0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:26:47 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13260 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab3AXK0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:26:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 24 Jan 2013 02:25:02 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v2] usb: host: tegra: make use of PHY pointer of HCD
Date: Thu, 24 Jan 2013 15:57:03 +0530
Message-ID: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointer to PHY structure can be stored in struct usb_hcd
making use of it, to call Tegra PHY APIs.

Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(),
so that to avoid dereferencing of hcd after its freed up.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
First version of patch can be found at
http://marc.info/?l=linux-kernel&m=135581479020213&w=2. As it was not
yet applied, sending v2 of the patch.

delta from v1:
Modified all Tegra PHY APIs to use standard 'structu usb_phy *' as
their parameter instead of proprietary parameter of type 'struct tegra_usb_phy *'.



 drivers/usb/host/ehci-tegra.c     |   27 +++++++++++++--------------
 drivers/usb/phy/tegra_usb_phy.c   |   16 ++++++++++++----
 include/linux/usb/tegra_usb_phy.h |    8 ++++----
 3 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index b02622a..568aecc 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -56,7 +56,7 @@ static void tegra_ehci_power_up(struct usb_hcd *hcd)
 	struct tegra_ehci_hcd *tegra = dev_get_drvdata(hcd->self.controller);
 
 	clk_prepare_enable(tegra->clk);
-	usb_phy_set_suspend(&tegra->phy->u_phy, 0);
+	usb_phy_set_suspend(hcd->phy, 0);
 	tegra->host_resumed = 1;
 }
 
@@ -65,7 +65,7 @@ static void tegra_ehci_power_down(struct usb_hcd *hcd)
 	struct tegra_ehci_hcd *tegra = dev_get_drvdata(hcd->self.controller);
 
 	tegra->host_resumed = 0;
-	usb_phy_set_suspend(&tegra->phy->u_phy, 1);
+	usb_phy_set_suspend(hcd->phy, 1);
 	clk_disable_unprepare(tegra->clk);
 }
 
@@ -159,7 +159,7 @@ static int tegra_ehci_hub_control(
 		if (tegra->port_resuming && !(temp & PORT_SUSPEND)) {
 			/* Resume completed, re-enable disconnect detection */
 			tegra->port_resuming = 0;
-			tegra_usb_phy_postresume(tegra->phy);
+			tegra_usb_phy_postresume(hcd->phy);
 		}
 	}
 
@@ -212,7 +212,7 @@ static int tegra_ehci_hub_control(
 			goto done;
 
 		/* Disable disconnect detection during port resume */
-		tegra_usb_phy_preresume(tegra->phy);
+		tegra_usb_phy_preresume(hcd->phy);
 
 		ehci->reset_done[wIndex-1] = jiffies + msecs_to_jiffies(25);
 
@@ -476,7 +476,7 @@ static int controller_resume(struct device *dev)
 	}
 
 	/* Force the phy to keep data lines in suspend state */
-	tegra_ehci_phy_restore_start(tegra->phy, tegra->port_speed);
+	tegra_ehci_phy_restore_start(hcd->phy, tegra->port_speed);
 
 	/* Enable host mode */
 	tdi_reset(ehci);
@@ -543,17 +543,17 @@ static int controller_resume(struct device *dev)
 		}
 	}
 
-	tegra_ehci_phy_restore_end(tegra->phy);
+	tegra_ehci_phy_restore_end(hcd->phy);
 	goto done;
 
  restart:
 	if (tegra->port_speed <= TEGRA_USB_PHY_PORT_SPEED_HIGH)
-		tegra_ehci_phy_restore_end(tegra->phy);
+		tegra_ehci_phy_restore_end(hcd->phy);
 
 	tegra_ehci_restart(hcd);
 
  done:
-	tegra_usb_phy_preresume(tegra->phy);
+	tegra_usb_phy_preresume(hcd->phy);
 	tegra->port_resuming = 1;
 	return 0;
 }
@@ -740,9 +740,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		goto fail_io;
 	}
 
-	usb_phy_init(&tegra->phy->u_phy);
-
 	hcd->phy = u_phy = &tegra->phy->u_phy;
+	usb_phy_init(hcd->phy);
+
 	u_phy->otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
 			     GFP_KERNEL);
 	if (!u_phy->otg) {
@@ -752,7 +752,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	}
 	u_phy->otg->host = hcd_to_bus(hcd);
 
-	err = usb_phy_set_suspend(&tegra->phy->u_phy, 0);
+	err = usb_phy_set_suspend(hcd->phy, 0);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to power on the phy\n");
 		goto fail;
@@ -798,7 +798,7 @@ fail:
 	if (!IS_ERR_OR_NULL(tegra->transceiver))
 		otg_set_host(tegra->transceiver->otg, NULL);
 #endif
-	usb_phy_shutdown(&tegra->phy->u_phy);
+	usb_phy_shutdown(hcd->phy);
 fail_io:
 	clk_disable_unprepare(tegra->clk);
 fail_clk:
@@ -820,11 +820,10 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 		otg_set_host(tegra->transceiver->otg, NULL);
 #endif
 
+	usb_phy_shutdown(hcd->phy);
 	usb_remove_hcd(hcd);
 	usb_put_hcd(hcd);
 
-	usb_phy_shutdown(&tegra->phy->u_phy);
-
 	clk_disable_unprepare(tegra->clk);
 
 	return 0;
diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index d465704..5487d38 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -759,30 +759,38 @@ err0:
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
 
-void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
+void tegra_usb_phy_preresume(struct usb_phy *x)
 {
+	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
+
 	if (!phy->is_ulpi_phy)
 		utmi_phy_preresume(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_preresume);
 
-void tegra_usb_phy_postresume(struct tegra_usb_phy *phy)
+void tegra_usb_phy_postresume(struct usb_phy *x)
 {
+	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
+
 	if (!phy->is_ulpi_phy)
 		utmi_phy_postresume(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
 
-void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
+void tegra_ehci_phy_restore_start(struct usb_phy *x,
 				 enum tegra_usb_phy_port_speed port_speed)
 {
+	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
+
 	if (!phy->is_ulpi_phy)
 		utmi_phy_restore_start(phy, port_speed);
 }
 EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_start);
 
-void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
+void tegra_ehci_phy_restore_end(struct usb_phy *x)
 {
+	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
+
 	if (!phy->is_ulpi_phy)
 		utmi_phy_restore_end(phy);
 }
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 9259d46..9ebebe9 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -66,14 +66,14 @@ struct tegra_usb_phy {
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode);
 
-void tegra_usb_phy_preresume(struct tegra_usb_phy *phy);
+void tegra_usb_phy_preresume(struct usb_phy *phy);
 
-void tegra_usb_phy_postresume(struct tegra_usb_phy *phy);
+void tegra_usb_phy_postresume(struct usb_phy *phy);
 
-void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
+void tegra_ehci_phy_restore_start(struct usb_phy *phy,
 				 enum tegra_usb_phy_port_speed port_speed);
 
-void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy);
+void tegra_ehci_phy_restore_end(struct usb_phy *phy);
 
 void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val);
 
-- 
1.7.0.4

