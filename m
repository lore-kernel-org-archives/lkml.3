Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaGIKT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:19:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45262 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753137AbaGIKTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:19:51 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] usb: add support to the PHY framework for HCD
Date: Wed,  9 Jul 2014 12:17:15 +0200
Message-Id: <1404901036-27682-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support to PHY framework in HCD code while keeping
the USB PHY compatibility. Changes are done in both the HCD common code
and in the drivers accessing its PHY. This is done in two steps:
renaming 'phy' into 'usb_phy' and adding a new 'phy' member into the
usb_hcd structure.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/host.c   |  2 +-
 drivers/usb/core/hcd.c        | 61 +++++++++++++++++++++++++++++++------------
 drivers/usb/core/hub.c        |  8 +++---
 drivers/usb/host/ehci-fsl.c   | 16 ++++++------
 drivers/usb/host/ehci-hub.c   |  2 +-
 drivers/usb/host/ehci-msm.c   |  4 +--
 drivers/usb/host/ehci-tegra.c | 16 ++++++------
 drivers/usb/host/ohci-omap.c  | 20 +++++++-------
 include/linux/usb/hcd.h       |  5 +++-
 9 files changed, 82 insertions(+), 52 deletions(-)

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
index bec31e2efb88..b985af5b167c 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -42,6 +42,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 
+#include <linux/phy/phy.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
 #include <linux/usb/phy.h>
@@ -2631,21 +2632,35 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	int retval;
 	struct usb_device *rhdev;
 
-	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy) {
-		struct usb_phy *phy = usb_get_phy_dev(hcd->self.controller, 0);
+	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy && !hcd->usb_phy) {
+		struct phy *phy = of_phy_get(hcd->self.controller->of_node, 0);
 
-		if (IS_ERR(phy)) {
-			retval = PTR_ERR(phy);
-			if (retval == -EPROBE_DEFER)
-				return retval;
-		} else {
-			retval = usb_phy_init(phy);
+		if (!IS_ERR(phy)) {
+			retval = phy_init(hcd->phy);
 			if (retval) {
-				usb_put_phy(phy);
+				phy_exit(hcd->phy);
 				return retval;
 			}
+			retval = phy_power_on(hcd->phy);
 			hcd->phy = phy;
 			hcd->remove_phy = 1;
+		} else {
+			struct usb_phy *phy =
+				usb_get_phy_dev(hcd->self.controller, 0);
+
+			if (IS_ERR(phy)) {
+				retval = PTR_ERR(phy);
+				if (retval == -EPROBE_DEFER)
+					return retval;
+			} else {
+				retval = usb_phy_init(phy);
+				if (retval) {
+					usb_put_phy(phy);
+					return retval;
+				}
+				hcd->usb_phy = phy;
+				hcd->remove_phy = 1;
+			}
 		}
 	}
 
@@ -2792,10 +2807,16 @@ err_allocate_root_hub:
 err_register_bus:
 	hcd_buffer_destroy(hcd);
 err_remove_phy:
-	if (hcd->remove_phy && hcd->phy) {
-		usb_phy_shutdown(hcd->phy);
-		usb_put_phy(hcd->phy);
-		hcd->phy = NULL;
+	if (hcd->remove_phy) {
+		if (hcd->phy) {
+			phy_power_off(hcd->phy);
+			phy_exit(hcd->phy);
+			hcd->phy = NULL;
+		} else if (hcd->usb_phy) {
+			usb_phy_shutdown(hcd->usb_phy);
+			usb_put_phy(hcd->usb_phy);
+			hcd->usb_phy = NULL;
+		}
 	}
 	return retval;
 }
@@ -2868,10 +2889,16 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 
 	usb_deregister_bus(&hcd->self);
 	hcd_buffer_destroy(hcd);
-	if (hcd->remove_phy && hcd->phy) {
-		usb_phy_shutdown(hcd->phy);
-		usb_put_phy(hcd->phy);
-		hcd->phy = NULL;
+	if (hcd->remove_phy) {
+		if (hcd->phy) {
+			phy_power_off(hcd->phy);
+			phy_exit(hcd->phy);
+			hcd->phy = NULL;
+		} else if (hcd->usb_phy) {
+			usb_phy_shutdown(hcd->usb_phy);
+			usb_put_phy(hcd->usb_phy);
+			hcd->usb_phy = NULL;
+		}
 	}
 
 	usb_put_invalidate_rhdev(hcd);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 21b99b4b4082..cf49c03b74a9 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4379,8 +4379,8 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 	if (retval)
 		goto fail;
 
-	if (hcd->phy && !hdev->parent)
-		usb_phy_notify_connect(hcd->phy, udev->speed);
+	if (hcd->usb_phy && !hdev->parent)
+		usb_phy_notify_connect(hcd->usb_phy, udev->speed);
 
 	/*
 	 * Some superspeed devices have finished the link training process
@@ -4534,9 +4534,9 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 
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
index cc305c71ac3d..619d2e051e8c 100644
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
index 982c09bebe0f..df474aa2acb6 100644
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
index 6fdcb8ad2296..a134eac561c2 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -150,7 +150,7 @@ static int tegra_ehci_hub_control(
 		if (tegra->port_resuming && !(temp & PORT_SUSPEND)) {
 			/* Resume completed, re-enable disconnect detection */
 			tegra->port_resuming = 0;
-			tegra_usb_phy_postresume(hcd->phy);
+			tegra_usb_phy_postresume(hcd->usb_phy);
 		}
 	}
 
@@ -203,7 +203,7 @@ static int tegra_ehci_hub_control(
 			goto done;
 
 		/* Disable disconnect detection during port resume */
-		tegra_usb_phy_preresume(hcd->phy);
+		tegra_usb_phy_preresume(hcd->usb_phy);
 
 		ehci->reset_done[wIndex-1] = jiffies + msecs_to_jiffies(25);
 
@@ -398,7 +398,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		err = PTR_ERR(u_phy);
 		goto cleanup_clk_en;
 	}
-	hcd->phy = u_phy;
+	hcd->usb_phy = u_phy;
 
 	tegra->needs_double_reset = of_property_read_bool(pdev->dev.of_node,
 		"nvidia,needs-double-reset");
@@ -419,7 +419,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	ehci->caps = hcd->regs + 0x100;
 	ehci->has_hostpc = soc_config->has_hostpc;
 
-	err = usb_phy_init(hcd->phy);
+	err = usb_phy_init(hcd->usb_phy);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to initialize phy\n");
 		goto cleanup_clk_en;
@@ -434,7 +434,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	}
 	u_phy->otg->host = hcd_to_bus(hcd);
 
-	err = usb_phy_set_suspend(hcd->phy, 0);
+	err = usb_phy_set_suspend(hcd->usb_phy, 0);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to power on the phy\n");
 		goto cleanup_phy;
@@ -461,7 +461,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 cleanup_otg_set_host:
 	otg_set_host(u_phy->otg, NULL);
 cleanup_phy:
-	usb_phy_shutdown(hcd->phy);
+	usb_phy_shutdown(hcd->usb_phy);
 cleanup_clk_en:
 	clk_disable_unprepare(tegra->clk);
 cleanup_hcd_create:
@@ -475,9 +475,9 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 	struct tegra_ehci_hcd *tegra =
 		(struct tegra_ehci_hcd *)hcd_to_ehci(hcd)->priv;
 
-	otg_set_host(hcd->phy->otg, NULL);
+	otg_set_host(hcd->usb_phy->otg, NULL);
 
-	usb_phy_shutdown(hcd->phy);
+	usb_phy_shutdown(hcd->usb_phy);
 	usb_remove_hcd(hcd);
 	usb_put_hcd(hcd);
 
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
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 485cd5e2100c..99aaa8644074 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -105,8 +105,11 @@ struct usb_hcd {
 	/*
 	 * OTG and some Host controllers need software interaction with phys;
 	 * other external phys should be software-transparent
+	 *
+	 * Keep the usb_phy for compatibility reasons, for now
 	 */
-	struct usb_phy	*phy;
+	struct phy		*phy;
+	struct usb_phy		*usb_phy;
 
 	/* Flags that need to be manipulated atomically because they can
 	 * change while the host controller is running.  Always use
-- 
1.9.1

