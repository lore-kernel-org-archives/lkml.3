Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaIOKfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:35:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36850 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753393AbaIOKfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:35:17 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/9] usb: rename phy to usb_phy in HCD
Date: Mon, 15 Sep 2014 12:35:04 +0200
Message-Id: <1410777309-12552-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB PHY member of the HCD structure is renamed to 'usb_phy' and
modifications are done in all drivers accessing it.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/chipidea/host.c   |  2 +-
 drivers/usb/core/hcd.c        | 20 ++++++++++----------
 drivers/usb/core/hub.c        |  8 ++++----
 drivers/usb/host/ehci-fsl.c   | 16 ++++++++--------
 drivers/usb/host/ehci-hub.c   |  2 +-
 drivers/usb/host/ehci-msm.c   |  4 ++--
 drivers/usb/host/ehci-tegra.c | 16 ++++++++--------
 drivers/usb/host/ohci-omap.c  | 20 ++++++++++----------
 drivers/usb/misc/lvstest.c    |  8 ++++----
 include/linux/usb/hcd.h       |  2 +-
 10 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index a93d950e9468..fc7541c906a2 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -59,7 +59,7 @@ static int host_start(struct ci_hdrc *ci)
 	hcd->has_tt = 1;
 
 	hcd->power_budget = ci->platdata->power_budget;
-	hcd->phy = ci->transceiver;
+	hcd->usb_phy = ci->transceiver;
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = ci->hw_bank.cap;
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index c4ed66cb9ff3..86fdce55ae16 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2628,7 +2628,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	int retval;
 	struct usb_device *rhdev;
 
-	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy) {
+	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->usb_phy) {
 		struct usb_phy *phy = usb_get_phy_dev(hcd->self.controller, 0);
 
 		if (IS_ERR(phy)) {
@@ -2641,7 +2641,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 				usb_put_phy(phy);
 				return retval;
 			}
-			hcd->phy = phy;
+			hcd->usb_phy = phy;
 			hcd->remove_phy = 1;
 		}
 	}
@@ -2819,10 +2819,10 @@ err_create_buf:
 		hcd->gen_phy = NULL;
 	}
 err_phy:
-	if (hcd->remove_phy && hcd->phy) {
-		usb_phy_shutdown(hcd->phy);
-		usb_put_phy(hcd->phy);
-		hcd->phy = NULL;
+	if (hcd->remove_phy && hcd->usb_phy) {
+		usb_phy_shutdown(hcd->usb_phy);
+		usb_put_phy(hcd->usb_phy);
+		hcd->usb_phy = NULL;
 	}
 	return retval;
 }
@@ -2902,10 +2902,10 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 		phy_put(hcd->gen_phy);
 		hcd->gen_phy = NULL;
 	}
-	if (hcd->remove_phy && hcd->phy) {
-		usb_phy_shutdown(hcd->phy);
-		usb_put_phy(hcd->phy);
-		hcd->phy = NULL;
+	if (hcd->remove_phy && hcd->usb_phy) {
+		usb_phy_shutdown(hcd->usb_phy);
+		usb_put_phy(hcd->usb_phy);
+		hcd->usb_phy = NULL;
 	}
 
 	usb_put_invalidate_rhdev(hcd);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 46f5161c7891..bf023b3d0366 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4461,8 +4461,8 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 	if (retval)
 		goto fail;
 
-	if (hcd->phy && !hdev->parent)
-		usb_phy_notify_connect(hcd->phy, udev->speed);
+	if (hcd->usb_phy && !hdev->parent)
+		usb_phy_notify_connect(hcd->usb_phy, udev->speed);
 
 	/*
 	 * Some superspeed devices have finished the link training process
@@ -4617,9 +4617,9 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 
 	/* Disconnect any existing devices under this port */
 	if (udev) {
-		if (hcd->phy && !hdev->parent &&
+		if (hcd->usb_phy && !hdev->parent &&
 				!(portstatus & USB_PORT_STAT_CONNECTION))
-			usb_phy_notify_disconnect(hcd->phy, udev->speed);
+			usb_phy_notify_disconnect(hcd->usb_phy, udev->speed);
 		usb_disconnect(&port_dev->child);
 	}
 
diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index cf2734b532a7..4bdcd3439d47 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -136,15 +136,15 @@ static int usb_hcd_fsl_probe(const struct hc_driver *driver,
 	if (pdata->operating_mode == FSL_USB2_DR_OTG) {
 		struct ehci_hcd *ehci = hcd_to_ehci(hcd);
 
-		hcd->phy = usb_get_phy(USB_PHY_TYPE_USB2);
+		hcd->usb_phy = usb_get_phy(USB_PHY_TYPE_USB2);
 		dev_dbg(&pdev->dev, "hcd=0x%p  ehci=0x%p, phy=0x%p\n",
-			hcd, ehci, hcd->phy);
+			hcd, ehci, hcd->usb_phy);
 
-		if (!IS_ERR_OR_NULL(hcd->phy)) {
-			retval = otg_set_host(hcd->phy->otg,
+		if (!IS_ERR_OR_NULL(hcd->usb_phy)) {
+			retval = otg_set_host(hcd->usb_phy->otg,
 					      &ehci_to_hcd(ehci)->self);
 			if (retval) {
-				usb_put_phy(hcd->phy);
+				usb_put_phy(hcd->usb_phy);
 				goto err2;
 			}
 		} else {
@@ -181,9 +181,9 @@ static void usb_hcd_fsl_remove(struct usb_hcd *hcd,
 {
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
-	if (!IS_ERR_OR_NULL(hcd->phy)) {
-		otg_set_host(hcd->phy->otg, NULL);
-		usb_put_phy(hcd->phy);
+	if (!IS_ERR_OR_NULL(hcd->usb_phy)) {
+		otg_set_host(hcd->usb_phy->otg, NULL);
+		usb_put_phy(hcd->usb_phy);
 	}
 
 	usb_remove_hcd(hcd);
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 6130b7574908..61e10089e527 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -922,7 +922,7 @@ int ehci_hub_control(
 #ifdef CONFIG_USB_OTG
 			if ((hcd->self.otg_port == (wIndex + 1))
 			    && hcd->self.b_hnp_enable) {
-				otg_start_hnp(hcd->phy->otg);
+				otg_start_hnp(hcd->usb_phy->otg);
 				break;
 			}
 #endif
diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 934b39d5e44a..9dc2118ae808 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -124,7 +124,7 @@ static int ehci_msm_probe(struct platform_device *pdev)
 		goto put_hcd;
 	}
 
-	hcd->phy = phy;
+	hcd->usb_phy = phy;
 	device_init_wakeup(&pdev->dev, 1);
 	/*
 	 * OTG device parent of HCD takes care of putting
@@ -151,7 +151,7 @@ static int ehci_msm_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
-	otg_set_host(hcd->phy->otg, NULL);
+	otg_set_host(hcd->usb_phy->otg, NULL);
 
 	/* FIXME: need to call usb_remove_hcd() here? */
 
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 7aafb05e7a40..aaa01971efe9 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -206,7 +206,7 @@ static int tegra_ehci_hub_control(
 		if (tegra->port_resuming && !(temp & PORT_SUSPEND)) {
 			/* Resume completed, re-enable disconnect detection */
 			tegra->port_resuming = 0;
-			tegra_usb_phy_postresume(hcd->phy);
+			tegra_usb_phy_postresume(hcd->usb_phy);
 		}
 	}
 
@@ -259,7 +259,7 @@ static int tegra_ehci_hub_control(
 			goto done;
 
 		/* Disable disconnect detection during port resume */
-		tegra_usb_phy_preresume(hcd->phy);
+		tegra_usb_phy_preresume(hcd->usb_phy);
 
 		ehci->reset_done[wIndex-1] = jiffies + msecs_to_jiffies(25);
 
@@ -454,7 +454,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		err = PTR_ERR(u_phy);
 		goto cleanup_clk_en;
 	}
-	hcd->phy = u_phy;
+	hcd->usb_phy = u_phy;
 
 	tegra->needs_double_reset = of_property_read_bool(pdev->dev.of_node,
 		"nvidia,needs-double-reset");
@@ -475,7 +475,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	ehci->caps = hcd->regs + 0x100;
 	ehci->has_hostpc = soc_config->has_hostpc;
 
-	err = usb_phy_init(hcd->phy);
+	err = usb_phy_init(hcd->usb_phy);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to initialize phy\n");
 		goto cleanup_clk_en;
@@ -490,7 +490,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	}
 	u_phy->otg->host = hcd_to_bus(hcd);
 
-	err = usb_phy_set_suspend(hcd->phy, 0);
+	err = usb_phy_set_suspend(hcd->usb_phy, 0);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to power on the phy\n");
 		goto cleanup_phy;
@@ -517,7 +517,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 cleanup_otg_set_host:
 	otg_set_host(u_phy->otg, NULL);
 cleanup_phy:
-	usb_phy_shutdown(hcd->phy);
+	usb_phy_shutdown(hcd->usb_phy);
 cleanup_clk_en:
 	clk_disable_unprepare(tegra->clk);
 cleanup_hcd_create:
@@ -531,9 +531,9 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 	struct tegra_ehci_hcd *tegra =
 		(struct tegra_ehci_hcd *)hcd_to_ehci(hcd)->priv;
 
-	otg_set_host(hcd->phy->otg, NULL);
+	otg_set_host(hcd->usb_phy->otg, NULL);
 
-	usb_phy_shutdown(hcd->phy);
+	usb_phy_shutdown(hcd->usb_phy);
 	usb_remove_hcd(hcd);
 
 	clk_disable_unprepare(tegra->clk);
diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
index 61967405b56d..4629dd7db728 100644
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -180,10 +180,10 @@ static void start_hnp(struct ohci_hcd *ohci)
 	unsigned long	flags;
 	u32 l;
 
-	otg_start_hnp(hcd->phy->otg);
+	otg_start_hnp(hcd->usb_phy->otg);
 
 	local_irq_save(flags);
-	hcd->phy->otg.state = OTG_STATE_A_SUSPEND;
+	hcd->usb_phy->otg.state = OTG_STATE_A_SUSPEND;
 	writel (RH_PS_PSS, &ohci->regs->roothub.portstatus [port]);
 	l = omap_readl(OTG_CTRL);
 	l &= ~OTG_A_BUSREQ;
@@ -220,14 +220,14 @@ static int ohci_omap_reset(struct usb_hcd *hcd)
 
 #ifdef	CONFIG_USB_OTG
 	if (need_transceiver) {
-		hcd->phy = usb_get_phy(USB_PHY_TYPE_USB2);
-		if (!IS_ERR_OR_NULL(hcd->phy)) {
-			int	status = otg_set_host(hcd->phy->otg,
+		hcd->usb_phy = usb_get_phy(USB_PHY_TYPE_USB2);
+		if (!IS_ERR_OR_NULL(hcd->usb_phy)) {
+			int	status = otg_set_host(hcd->usb_phy->otg,
 						&ohci_to_hcd(ohci)->self);
 			dev_dbg(hcd->self.controller, "init %s phy, status %d\n",
-					hcd->phy->label, status);
+					hcd->usb_phy->label, status);
 			if (status) {
-				usb_put_phy(hcd->phy);
+				usb_put_phy(hcd->usb_phy);
 				return status;
 			}
 		} else {
@@ -399,9 +399,9 @@ usb_hcd_omap_remove (struct usb_hcd *hcd, struct platform_device *pdev)
 	dev_dbg(hcd->self.controller, "stopping USB Controller\n");
 	usb_remove_hcd(hcd);
 	omap_ohci_clock_power(0);
-	if (!IS_ERR_OR_NULL(hcd->phy)) {
-		(void) otg_set_host(hcd->phy->otg, 0);
-		usb_put_phy(hcd->phy);
+	if (!IS_ERR_OR_NULL(hcd->usb_phy)) {
+		(void) otg_set_host(hcd->usb_phy->otg, 0);
+		usb_put_phy(hcd->usb_phy);
 	}
 	if (machine_is_omap_osk())
 		gpio_free(9);
diff --git a/drivers/usb/misc/lvstest.c b/drivers/usb/misc/lvstest.c
index 7d589c156fb1..62cb8cd08403 100644
--- a/drivers/usb/misc/lvstest.c
+++ b/drivers/usb/misc/lvstest.c
@@ -333,13 +333,13 @@ static void lvs_rh_work(struct work_struct *work)
 					USB_PORT_STAT_CONNECTION) {
 				lvs->present = true;
 				lvs->portnum = i;
-				if (hcd->phy)
-					usb_phy_notify_connect(hcd->phy,
+				if (hcd->usb_phy)
+					usb_phy_notify_connect(hcd->usb_phy,
 							USB_SPEED_SUPER);
 			} else {
 				lvs->present = false;
-				if (hcd->phy)
-					usb_phy_notify_disconnect(hcd->phy,
+				if (hcd->usb_phy)
+					usb_phy_notify_disconnect(hcd->usb_phy,
 							USB_SPEED_SUPER);
 			}
 			break;
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 2aefbcc83b22..604d2e6e0c1c 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -106,7 +106,7 @@ struct usb_hcd {
 	 * OTG and some Host controllers need software interaction with phys;
 	 * other external phys should be software-transparent
 	 */
-	struct usb_phy		*phy;
+	struct usb_phy		*usb_phy;
 	struct phy		*gen_phy;
 
 	/* Flags that need to be manipulated atomically because they can
-- 
1.9.1

