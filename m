Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaIXTF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:05:58 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:45623 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaIXTFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:05:55 -0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        Peter.Chen@freescale.com, stern@rowland.harvard.edu,
        swarren@wwwdotorg.org, thierry.reding@gmail.com, balbi@ti.com,
        linux-tegra@vger.kernel.org, linux-omap@vger.kernel.org
Cc: linux-sh@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com,
        linux-kernel@vger.kernel.org, antoine.tenart@free-electrons.com
Subject: [PATCH v6 1/2] usb: rename phy to usb_phy in HCD
Date: Wed, 24 Sep 2014 23:05:50 +0400
Message-ID: <2300651.HNvMzB0aUB@wasted.cogentembedded.com>
Organization: Cogent Embedded Inc.
User-Agent: KMail/4.13.3 (Linux/3.15.10-201.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <37148636.BU5lT4M4eC@wasted.cogentembedded.com>
References: <37148636.BU5lT4M4eC@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>

The USB PHY member of the HCD structure is renamed to 'usb_phy' and
modifications are done in all drivers accessing it.
This is in preparation to adding the generic PHY support.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
[Sergei: added missing 'drivers/usb/misc/lvstest.c' file, resolved rejects,
updated changelog.]
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>

---
Changes in version 6:
- resolved reject, refreshed the patch.

Changes in version 5:
- imported the patch from Antoine Tenart's series;
- added missing 'drivers/usb/misc/lvstest.c' file;
- resolved rejects caused by patch reordering;
- refreshed patch;
- updated changelog.

 drivers/usb/chipidea/host.c   |    2 +-
 drivers/usb/core/hcd.c        |   20 ++++++++++----------
 drivers/usb/core/hub.c        |    8 ++++----
 drivers/usb/host/ehci-fsl.c   |   16 ++++++++--------
 drivers/usb/host/ehci-hub.c   |    2 +-
 drivers/usb/host/ehci-msm.c   |    4 ++--
 drivers/usb/host/ehci-tegra.c |   16 ++++++++--------
 drivers/usb/host/ohci-omap.c  |   20 ++++++++++----------
 drivers/usb/misc/lvstest.c    |    8 ++++----
 include/linux/usb/hcd.h       |    2 +-
 10 files changed, 49 insertions(+), 49 deletions(-)

Index: usb/drivers/usb/chipidea/host.c
===================================================================
--- usb.orig/drivers/usb/chipidea/host.c
+++ usb/drivers/usb/chipidea/host.c
@@ -59,7 +59,7 @@ static int host_start(struct ci_hdrc *ci
 	hcd->has_tt = 1;
 
 	hcd->power_budget = ci->platdata->power_budget;
-	hcd->phy = ci->transceiver;
+	hcd->usb_phy = ci->transceiver;
 	hcd->tpl_support = ci->platdata->tpl_support;
 
 	ehci = hcd_to_ehci(hcd);
Index: usb/drivers/usb/core/hcd.c
===================================================================
--- usb.orig/drivers/usb/core/hcd.c
+++ usb/drivers/usb/core/hcd.c
@@ -2627,7 +2627,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	int retval;
 	struct usb_device *rhdev;
 
-	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy) {
+	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->usb_phy) {
 		struct usb_phy *phy = usb_get_phy_dev(hcd->self.controller, 0);
 
 		if (IS_ERR(phy)) {
@@ -2640,7 +2640,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 				usb_put_phy(phy);
 				return retval;
 			}
-			hcd->phy = phy;
+			hcd->usb_phy = phy;
 			hcd->remove_phy = 1;
 		}
 	}
@@ -2788,10 +2788,10 @@ err_allocate_root_hub:
 err_register_bus:
 	hcd_buffer_destroy(hcd);
 err_remove_phy:
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
@@ -2864,10 +2864,10 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 
 	usb_deregister_bus(&hcd->self);
 	hcd_buffer_destroy(hcd);
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
Index: usb/drivers/usb/core/hub.c
===================================================================
--- usb.orig/drivers/usb/core/hub.c
+++ usb/drivers/usb/core/hub.c
@@ -4467,8 +4467,8 @@ hub_port_init (struct usb_hub *hub, stru
 	if (retval)
 		goto fail;
 
-	if (hcd->phy && !hdev->parent)
-		usb_phy_notify_connect(hcd->phy, udev->speed);
+	if (hcd->usb_phy && !hdev->parent)
+		usb_phy_notify_connect(hcd->usb_phy, udev->speed);
 
 	/*
 	 * Some superspeed devices have finished the link training process
@@ -4626,9 +4626,9 @@ static void hub_port_connect(struct usb_
 
 	/* Disconnect any existing devices under this port */
 	if (udev) {
-		if (hcd->phy && !hdev->parent &&
+		if (hcd->usb_phy && !hdev->parent &&
 				!(portstatus & USB_PORT_STAT_CONNECTION))
-			usb_phy_notify_disconnect(hcd->phy, udev->speed);
+			usb_phy_notify_disconnect(hcd->usb_phy, udev->speed);
 		usb_disconnect(&port_dev->child);
 	}
 
Index: usb/drivers/usb/host/ehci-fsl.c
===================================================================
--- usb.orig/drivers/usb/host/ehci-fsl.c
+++ usb/drivers/usb/host/ehci-fsl.c
@@ -136,15 +136,15 @@ static int usb_hcd_fsl_probe(const struc
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
@@ -181,9 +181,9 @@ static void usb_hcd_fsl_remove(struct us
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
Index: usb/drivers/usb/host/ehci-hub.c
===================================================================
--- usb.orig/drivers/usb/host/ehci-hub.c
+++ usb/drivers/usb/host/ehci-hub.c
@@ -922,7 +922,7 @@ int ehci_hub_control(
 #ifdef CONFIG_USB_OTG
 			if ((hcd->self.otg_port == (wIndex + 1))
 			    && hcd->self.b_hnp_enable) {
-				otg_start_hnp(hcd->phy->otg);
+				otg_start_hnp(hcd->usb_phy->otg);
 				break;
 			}
 #endif
Index: usb/drivers/usb/host/ehci-msm.c
===================================================================
--- usb.orig/drivers/usb/host/ehci-msm.c
+++ usb/drivers/usb/host/ehci-msm.c
@@ -124,7 +124,7 @@ static int ehci_msm_probe(struct platfor
 		goto put_hcd;
 	}
 
-	hcd->phy = phy;
+	hcd->usb_phy = phy;
 	device_init_wakeup(&pdev->dev, 1);
 	/*
 	 * OTG device parent of HCD takes care of putting
@@ -151,7 +151,7 @@ static int ehci_msm_remove(struct platfo
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
-	otg_set_host(hcd->phy->otg, NULL);
+	otg_set_host(hcd->usb_phy->otg, NULL);
 
 	/* FIXME: need to call usb_remove_hcd() here? */
 
Index: usb/drivers/usb/host/ehci-tegra.c
===================================================================
--- usb.orig/drivers/usb/host/ehci-tegra.c
+++ usb/drivers/usb/host/ehci-tegra.c
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
 
@@ -454,7 +454,7 @@ static int tegra_ehci_probe(struct platf
 		err = PTR_ERR(u_phy);
 		goto cleanup_clk_en;
 	}
-	hcd->phy = u_phy;
+	hcd->usb_phy = u_phy;
 
 	tegra->needs_double_reset = of_property_read_bool(pdev->dev.of_node,
 		"nvidia,needs-double-reset");
@@ -475,7 +475,7 @@ static int tegra_ehci_probe(struct platf
 	ehci->caps = hcd->regs + 0x100;
 	ehci->has_hostpc = soc_config->has_hostpc;
 
-	err = usb_phy_init(hcd->phy);
+	err = usb_phy_init(hcd->usb_phy);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to initialize phy\n");
 		goto cleanup_clk_en;
@@ -490,7 +490,7 @@ static int tegra_ehci_probe(struct platf
 	}
 	u_phy->otg->host = hcd_to_bus(hcd);
 
-	err = usb_phy_set_suspend(hcd->phy, 0);
+	err = usb_phy_set_suspend(hcd->usb_phy, 0);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to power on the phy\n");
 		goto cleanup_phy;
@@ -517,7 +517,7 @@ static int tegra_ehci_probe(struct platf
 cleanup_otg_set_host:
 	otg_set_host(u_phy->otg, NULL);
 cleanup_phy:
-	usb_phy_shutdown(hcd->phy);
+	usb_phy_shutdown(hcd->usb_phy);
 cleanup_clk_en:
 	clk_disable_unprepare(tegra->clk);
 cleanup_hcd_create:
@@ -531,9 +531,9 @@ static int tegra_ehci_remove(struct plat
 	struct tegra_ehci_hcd *tegra =
 		(struct tegra_ehci_hcd *)hcd_to_ehci(hcd)->priv;
 
-	otg_set_host(hcd->phy->otg, NULL);
+	otg_set_host(hcd->usb_phy->otg, NULL);
 
-	usb_phy_shutdown(hcd->phy);
+	usb_phy_shutdown(hcd->usb_phy);
 	usb_remove_hcd(hcd);
 
 	clk_disable_unprepare(tegra->clk);
Index: usb/drivers/usb/host/ohci-omap.c
===================================================================
--- usb.orig/drivers/usb/host/ohci-omap.c
+++ usb/drivers/usb/host/ohci-omap.c
@@ -180,10 +180,10 @@ static void start_hnp(struct ohci_hcd *o
 	unsigned long	flags;
 	u32 l;
 
-	otg_start_hnp(hcd->phy->otg);
+	otg_start_hnp(hcd->usb_phy->otg);
 
 	local_irq_save(flags);
-	hcd->phy->state = OTG_STATE_A_SUSPEND;
+	hcd->usb_phy->state = OTG_STATE_A_SUSPEND;
 	writel (RH_PS_PSS, &ohci->regs->roothub.portstatus [port]);
 	l = omap_readl(OTG_CTRL);
 	l &= ~OTG_A_BUSREQ;
@@ -220,14 +220,14 @@ static int ohci_omap_reset(struct usb_hc
 
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
@@ -399,9 +399,9 @@ usb_hcd_omap_remove (struct usb_hcd *hcd
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
Index: usb/drivers/usb/misc/lvstest.c
===================================================================
--- usb.orig/drivers/usb/misc/lvstest.c
+++ usb/drivers/usb/misc/lvstest.c
@@ -333,13 +333,13 @@ static void lvs_rh_work(struct work_stru
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
Index: usb/include/linux/usb/hcd.h
===================================================================
--- usb.orig/include/linux/usb/hcd.h
+++ usb/include/linux/usb/hcd.h
@@ -106,7 +106,7 @@ struct usb_hcd {
 	 * OTG and some Host controllers need software interaction with phys;
 	 * other external phys should be software-transparent
 	 */
-	struct usb_phy	*phy;
+	struct usb_phy		*usb_phy;
 
 	/* Flags that need to be manipulated atomically because they can
 	 * change while the host controller is running.  Always use

