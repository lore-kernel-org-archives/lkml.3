Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaIOKmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:42:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36832 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753437AbaIOKfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:35:19 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 7/9] usb: rename transceiver and phy to usb_phy in ChipIdea
Date: Mon, 15 Sep 2014 12:35:07 +0200
Message-Id: <1410777309-12552-8-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares the introduction of the generic PHY support in the
USB ChipIdea common functions. The USB PHY member of the ChipIdea
structure ('transceiver') is renamed to 'usb_phy', the 'phy' member of
the ChipIdea pdata structure is renamed to 'usb_phy' and modifications
are done in all drivers accessing it. Renaming this pointer will allow
to keep the compatibility for USB PHY drivers.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/ci.h          |  4 ++--
 drivers/usb/chipidea/ci_hdrc_imx.c |  2 +-
 drivers/usb/chipidea/ci_hdrc_msm.c |  8 ++++----
 drivers/usb/chipidea/core.c        | 20 ++++++++++----------
 drivers/usb/chipidea/debug.c       |  2 +-
 drivers/usb/chipidea/host.c        |  4 ++--
 drivers/usb/chipidea/otg_fsm.c     |  4 ++--
 drivers/usb/chipidea/udc.c         |  4 ++--
 include/linux/usb/chipidea.h       |  2 +-
 9 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 9563cb56d564..b2caa1772712 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -161,7 +161,7 @@ struct hw_bank {
  * @test_mode: the selected test mode
  * @platdata: platform specific information supplied by parent device
  * @vbus_active: is VBUS active
- * @transceiver: pointer to USB PHY, if any
+ * @usb_phy: pointer to USB PHY, if any
  * @hcd: pointer to usb_hcd for ehci host driver
  * @debugfs: root dentry for this controller in debugfs
  * @id_event: indicates there is an id event, and handled at ci_otg_work
@@ -201,7 +201,7 @@ struct ci_hdrc {
 
 	struct ci_hdrc_platform_data	*platdata;
 	int				vbus_active;
-	struct usb_phy			*transceiver;
+	struct usb_phy			*usb_phy;
 	struct usb_hcd			*hcd;
 	struct dentry			*debugfs;
 	bool				id_event;
diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index a7ab0f15926e..6f8b1b1045b5 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -147,7 +147,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	pdata.phy = data->phy;
+	pdata.usb_phy = data->phy;
 
 	if (imx_platform_flag->flags & CI_HDRC_IMX_IMX28_WRITE_FIX)
 		pdata.flags |= CI_HDRC_IMX28_WRITE_FIX;
diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index 4935ac38fd00..3edf969ed797 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -26,15 +26,15 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_RESET_EVENT received\n");
 		writel(0, USB_AHBBURST);
 		writel(0, USB_AHBMODE);
-		usb_phy_init(ci->transceiver);
+		usb_phy_init(ci->usb_phy);
 		break;
 	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");
 		/*
-		 * Put the transceiver in non-driving mode. Otherwise host
+		 * Put the phy in non-driving mode. Otherwise host
 		 * may not detect soft-disconnection.
 		 */
-		usb_phy_notify_disconnect(ci->transceiver, USB_SPEED_UNKNOWN);
+		usb_phy_notify_disconnect(ci->usb_phy, USB_SPEED_UNKNOWN);
 		break;
 	default:
 		dev_dbg(dev, "unknown ci_hdrc event\n");
@@ -68,7 +68,7 @@ static int ci_hdrc_msm_probe(struct platform_device *pdev)
 	if (IS_ERR(phy))
 		return PTR_ERR(phy);
 
-	ci_hdrc_msm_platdata.phy = phy;
+	ci_hdrc_msm_platdata.usb_phy = phy;
 
 	plat_ci = ci_hdrc_add_device(&pdev->dev,
 				pdev->resource, pdev->num_resources,
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 579b3538cb27..ee96b0696a7b 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -306,7 +306,7 @@ static int ci_usb_phy_init(struct ci_hdrc *ci)
 	case USBPHY_INTERFACE_MODE_UTMI:
 	case USBPHY_INTERFACE_MODE_UTMIW:
 	case USBPHY_INTERFACE_MODE_HSIC:
-		ret = usb_phy_init(ci->transceiver);
+		ret = usb_phy_init(ci->usb_phy);
 		if (ret)
 			return ret;
 		hw_phymode_configure(ci);
@@ -314,12 +314,12 @@ static int ci_usb_phy_init(struct ci_hdrc *ci)
 	case USBPHY_INTERFACE_MODE_ULPI:
 	case USBPHY_INTERFACE_MODE_SERIAL:
 		hw_phymode_configure(ci);
-		ret = usb_phy_init(ci->transceiver);
+		ret = usb_phy_init(ci->usb_phy);
 		if (ret)
 			return ret;
 		break;
 	default:
-		ret = usb_phy_init(ci->transceiver);
+		ret = usb_phy_init(ci->usb_phy);
 	}
 
 	return ret;
@@ -595,13 +595,13 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (ci->platdata->phy)
-		ci->transceiver = ci->platdata->phy;
+	if (ci->platdata->usb_phy)
+		ci->usb_phy = ci->platdata->usb_phy;
 	else
-		ci->transceiver = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
 
-	if (IS_ERR(ci->transceiver)) {
-		ret = PTR_ERR(ci->transceiver);
+	if (IS_ERR(ci->usb_phy)) {
+		ret = PTR_ERR(ci->usb_phy);
 		/*
 		 * if -ENXIO is returned, it means PHY layer wasn't
 		 * enabled, so it makes no sense to return -EPROBE_DEFER
@@ -718,7 +718,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 stop:
 	ci_role_destroy(ci);
 deinit_phy:
-	usb_phy_shutdown(ci->transceiver);
+	usb_phy_shutdown(ci->usb_phy);
 
 	return ret;
 }
@@ -731,7 +731,7 @@ static int ci_hdrc_remove(struct platform_device *pdev)
 	free_irq(ci->irq, ci);
 	ci_role_destroy(ci);
 	ci_hdrc_enter_lpm(ci, true);
-	usb_phy_shutdown(ci->transceiver);
+	usb_phy_shutdown(ci->usb_phy);
 	kfree(ci->hw_bank.regmap);
 
 	return 0;
diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
index 8878eea38d44..8f437e1512fa 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -220,7 +220,7 @@ static int ci_otg_show(struct seq_file *s, void *unused)
 
 	/* ------ State ----- */
 	seq_printf(s, "OTG state: %s\n\n",
-		usb_otg_state_string(ci->transceiver->otg.state));
+		usb_otg_state_string(ci->usb_phy->otg.state));
 
 	/* ------ State Machine Variables ----- */
 	seq_printf(s, "a_bus_drop: %d\n", fsm->a_bus_drop);
diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index fc7541c906a2..0b67d78dd953 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -59,7 +59,7 @@ static int host_start(struct ci_hdrc *ci)
 	hcd->has_tt = 1;
 
 	hcd->power_budget = ci->platdata->power_budget;
-	hcd->usb_phy = ci->transceiver;
+	hcd->usb_phy = ci->usb_phy;
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = ci->hw_bank.cap;
@@ -85,7 +85,7 @@ static int host_start(struct ci_hdrc *ci)
 	if (ret) {
 		goto disable_reg;
 	} else {
-		struct usb_otg *otg = ci->transceiver->otg;
+		struct usb_otg *otg = ci->usb_phy->otg;
 
 		ci->hcd = hcd;
 		if (otg) {
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index d8490e758a74..8a64ce87364e 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -788,10 +788,10 @@ int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
 		return -ENOMEM;
 	}
 
-	otg->usb_phy = ci->transceiver;
+	otg->usb_phy = ci->usb_phy;
 	otg->gadget = &ci->gadget;
 	ci->fsm.otg = otg;
-	ci->transceiver->otg = ci->fsm.otg;
+	ci->usb_phy->otg = ci->fsm.otg;
 	ci->fsm.power_up = 1;
 	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
 	ci->fsm.otg->state = OTG_STATE_UNDEFINED;
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index b8125aa64ad8..ce8b4d72fe28 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1519,8 +1519,8 @@ static int ci_udc_vbus_draw(struct usb_gadget *_gadget, unsigned ma)
 {
 	struct ci_hdrc *ci = container_of(_gadget, struct ci_hdrc, gadget);
 
-	if (ci->transceiver)
-		return usb_phy_set_power(ci->transceiver, ma);
+	if (ci->usb_phy)
+		return usb_phy_set_power(ci->usb_phy, ma);
 	return -ENOTSUPP;
 }
 
diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
index bbe779f640be..57d757a1aa83 100644
--- a/include/linux/usb/chipidea.h
+++ b/include/linux/usb/chipidea.h
@@ -13,7 +13,7 @@ struct ci_hdrc_platform_data {
 	/* offset of the capability registers */
 	uintptr_t	 capoffset;
 	unsigned	 power_budget;
-	struct usb_phy	*phy;
+	struct usb_phy	*usb_phy;
 	enum usb_phy_interface phy_mode;
 	unsigned long	 flags;
 #define CI_HDRC_REGS_SHARED		BIT(0)
-- 
1.9.1

