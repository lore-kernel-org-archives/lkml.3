Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaGIKV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:21:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45249 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754412AbaGIKTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:19:48 -0400
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
Subject: [PATCH 4/4] usb: chipidea: add support to the PHY framework for ChipIdea
Date: Wed,  9 Jul 2014 12:17:16 +0200
Message-Id: <1404901036-27682-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support to the PHY framework for ChipIdea drivers
while keeping the USB PHY compatibility. Changes are done in both the
ChipIdea common code and in the drivers accessing the PHY. This is done
by renaming 'phy' into 'usb_phy' and adding a new 'phy' member into the
ci_hdrc structre.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/ci.h          |  4 ++-
 drivers/usb/chipidea/ci_hdrc_imx.c |  2 +-
 drivers/usb/chipidea/ci_hdrc_msm.c |  6 ++--
 drivers/usb/chipidea/core.c        | 67 +++++++++++++++++++++++++++++++-------
 drivers/usb/chipidea/debug.c       |  4 ++-
 drivers/usb/chipidea/host.c        | 17 ++++++----
 drivers/usb/chipidea/otg_fsm.c     |  6 ++--
 drivers/usb/chipidea/udc.c         |  4 +--
 include/linux/usb/chipidea.h       |  4 ++-
 9 files changed, 86 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 9563cb56d564..139589c8ab90 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -201,7 +201,9 @@ struct ci_hdrc {
 
 	struct ci_hdrc_platform_data	*platdata;
 	int				vbus_active;
-	struct usb_phy			*transceiver;
+	struct phy			*transceiver;
+	/* old usb_phy interface */
+	struct usb_phy			*usb_transceiver;
 	struct usb_hcd			*hcd;
 	struct dentry			*debugfs;
 	bool				id_event;
diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 2e58f8dfd311..33b982dddac5 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -136,7 +136,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	pdata.phy = data->phy;
+	pdata.usb_phy = data->phy;
 
 	if (imx_platform_flag->flags & CI_HDRC_IMX_IMX28_WRITE_FIX)
 		pdata.flags |= CI_HDRC_IMX28_WRITE_FIX;
diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index d72b9d2de2c5..07b85674d208 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -34,10 +34,10 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 		 * Put the transceiver in non-driving mode. Otherwise host
 		 * may not detect soft-disconnection.
 		 */
-		val = usb_phy_io_read(ci->transceiver, ULPI_FUNC_CTRL);
+		val = usb_phy_io_read(ci->usb_transceiver, ULPI_FUNC_CTRL);
 		val &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
 		val |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
-		usb_phy_io_write(ci->transceiver, val, ULPI_FUNC_CTRL);
+		usb_phy_io_write(ci->usb_transceiver, val, ULPI_FUNC_CTRL);
 		break;
 	default:
 		dev_dbg(dev, "unknown ci_hdrc event\n");
@@ -71,7 +71,7 @@ static int ci_hdrc_msm_probe(struct platform_device *pdev)
 	if (IS_ERR(phy))
 		return PTR_ERR(phy);
 
-	ci_hdrc_msm_platdata.phy = phy;
+	ci_hdrc_msm_platdata.usb_phy = phy;
 
 	plat_ci = ci_hdrc_add_device(&pdev->dev,
 				pdev->resource, pdev->num_resources,
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 619d13e29995..4b93e2d6fe89 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -47,6 +47,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/idr.h>
@@ -293,6 +294,46 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
 }
 
 /**
+ * _ci_usb_phy_init: initialize phy taking in account both phy and usb_phy
+ * interfaces
+ * @ci: the controller
+ *
+ * This function returns an error code if the phy failed to init
+ */
+static int _ci_usb_phy_init(struct ci_hdrc *ci)
+{
+	int ret;
+
+	if (ci->transceiver) {
+		ret = phy_init(ci->transceiver);
+		if (ret) {
+			phy_exit(ci->transceiver);
+			return ret;
+		}
+		ret = phy_power_on(ci->transceiver);
+	} else {
+		ret = usb_phy_init(ci->usb_transceiver);
+	}
+
+	return ret;
+}
+
+/**
+ * _ci_usb_phy_exit: deinitialize phy taking in account both phy and usb_phy
+ * interfaces
+ * @ci: the controller
+ */
+static void ci_usb_phy_exit(struct ci_hdrc *ci)
+{
+	if (ci->transceiver) {
+		phy_power_off(ci->transceiver);
+		phy_exit(ci->transceiver);
+	} else {
+		usb_phy_shutdown(ci->usb_transceiver);
+	}
+}
+
+/**
  * ci_usb_phy_init: initialize phy according to different phy type
  * @ci: the controller
   *
@@ -306,7 +347,7 @@ static int ci_usb_phy_init(struct ci_hdrc *ci)
 	case USBPHY_INTERFACE_MODE_UTMI:
 	case USBPHY_INTERFACE_MODE_UTMIW:
 	case USBPHY_INTERFACE_MODE_HSIC:
-		ret = usb_phy_init(ci->transceiver);
+		ret = _ci_usb_phy_init(ci);
 		if (ret)
 			return ret;
 		hw_phymode_configure(ci);
@@ -314,12 +355,12 @@ static int ci_usb_phy_init(struct ci_hdrc *ci)
 	case USBPHY_INTERFACE_MODE_ULPI:
 	case USBPHY_INTERFACE_MODE_SERIAL:
 		hw_phymode_configure(ci);
-		ret = usb_phy_init(ci->transceiver);
+		ret = _ci_usb_phy_init(ci);
 		if (ret)
 			return ret;
 		break;
 	default:
-		ret = usb_phy_init(ci->transceiver);
+		ret = _ci_usb_phy_init(ci);
 	}
 
 	return ret;
@@ -597,21 +638,25 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 
 	if (ci->platdata->phy)
 		ci->transceiver = ci->platdata->phy;
+	else if (ci->platdata->usb_phy)
+		ci->usb_transceiver = ci->platdata->usb_phy;
 	else
-		ci->transceiver = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+		ci->transceiver = of_phy_get(dev->of_node, 0);
 
 	if (IS_ERR(ci->transceiver)) {
-		ret = PTR_ERR(ci->transceiver);
 		/*
 		 * if -ENXIO is returned, it means PHY layer wasn't
 		 * enabled, so it makes no sense to return -EPROBE_DEFER
 		 * in that case, since no PHY driver will ever probe.
 		 */
-		if (ret == -ENXIO)
-			return ret;
+		if (PTR_ERR(ci->transceiver) == -ENXIO)
+			return -ENXIO;
 
-		dev_err(dev, "no usb2 phy configured\n");
-		return -EPROBE_DEFER;
+		ci->usb_transceiver = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+		if (IS_ERR(ci->usb_transceiver)) {
+			dev_err(dev, "no usb2 phy configured\n");
+			return -EPROBE_DEFER;
+		}
 	}
 
 	ret = ci_usb_phy_init(ci);
@@ -718,7 +763,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 stop:
 	ci_role_destroy(ci);
 deinit_phy:
-	usb_phy_shutdown(ci->transceiver);
+	ci_usb_phy_exit(ci);
 
 	return ret;
 }
@@ -731,7 +776,7 @@ static int ci_hdrc_remove(struct platform_device *pdev)
 	free_irq(ci->irq, ci);
 	ci_role_destroy(ci);
 	ci_hdrc_enter_lpm(ci, true);
-	usb_phy_shutdown(ci->transceiver);
+	ci_usb_phy_exit(ci);
 	kfree(ci->hw_bank.regmap);
 
 	return 0;
diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
index 9a9702773e43..23b3deed34ba 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -219,7 +219,9 @@ int ci_otg_show(struct seq_file *s, void *unused)
 	fsm = &ci->fsm;
 
 	/* ------ State ----- */
-		usb_otg_state_string(ci->transceiver->otg.state));
+	if (ci->usb_transceiver)
+		seq_printf(s, "OTG state: %s\n\n",
+			usb_otg_state_string(ci->usb_transceiver->otg->state));
 
 	/* ------ State Machine Variables ----- */
 	seq_printf(s, "a_bus_drop: %d\n", fsm->a_bus_drop);
diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index fc7541c906a2..29fc4a3ba5a8 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -59,7 +59,10 @@ static int host_start(struct ci_hdrc *ci)
 	hcd->has_tt = 1;
 
 	hcd->power_budget = ci->platdata->power_budget;
-	hcd->usb_phy = ci->transceiver;
+	if (ci->transceiver)
+		hcd->phy = ci->transceiver;
+	else
+		hcd->usb_phy = ci->usb_transceiver;
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = ci->hw_bank.cap;
@@ -85,13 +88,15 @@ static int host_start(struct ci_hdrc *ci)
 	if (ret) {
 		goto disable_reg;
 	} else {
-		struct usb_otg *otg = ci->transceiver->otg;
+		if (ci->usb_transceiver) {
+			struct usb_otg *otg = ci->usb_transceiver->otg;
+			if (otg) {
+				otg->host = &hcd->self;
+				hcd->self.otg_port = 1;
+			}
+		}
 
 		ci->hcd = hcd;
-		if (otg) {
-			otg->host = &hcd->self;
-			hcd->self.otg_port = 1;
-		}
 	}
 
 	if (ci->platdata->flags & CI_HDRC_DISABLE_STREAMING)
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index d8490e758a74..ebf48ed55ac5 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -788,10 +788,12 @@ int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
 		return -ENOMEM;
 	}
 
-	otg->usb_phy = ci->transceiver;
+	if (ci->transceiver)
+		otg->phy = ci->transceiver;
+	else
+		otg->usb_phy = ci->usb_transceiver;
 	otg->gadget = &ci->gadget;
 	ci->fsm.otg = otg;
-	ci->transceiver->otg = ci->fsm.otg;
 	ci->fsm.power_up = 1;
 	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
 	ci->fsm.otg->state = OTG_STATE_UNDEFINED;
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 9d2b673f90e3..a67c58117e42 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1519,8 +1519,8 @@ static int ci_udc_vbus_draw(struct usb_gadget *_gadget, unsigned ma)
 {
 	struct ci_hdrc *ci = container_of(_gadget, struct ci_hdrc, gadget);
 
-	if (ci->transceiver)
-		return usb_phy_set_power(ci->transceiver, ma);
+	if (ci->usb_transceiver)
+		return usb_phy_set_power(ci->usb_transceiver, ma);
 	return -ENOTSUPP;
 }
 
diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
index bbe779f640be..a0285623b9c1 100644
--- a/include/linux/usb/chipidea.h
+++ b/include/linux/usb/chipidea.h
@@ -13,7 +13,9 @@ struct ci_hdrc_platform_data {
 	/* offset of the capability registers */
 	uintptr_t	 capoffset;
 	unsigned	 power_budget;
-	struct usb_phy	*phy;
+	struct phy	*phy;
+	/* old usb_phy interface */
+	struct usb_phy	*usb_phy;
 	enum usb_phy_interface phy_mode;
 	unsigned long	 flags;
 #define CI_HDRC_REGS_SHARED		BIT(0)
-- 
1.9.1

