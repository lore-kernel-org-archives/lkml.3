Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaHVPus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:50:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55545 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932323AbaHVPub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:50:31 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 9/9] usb: chipidea: add support to the generic PHY framework in ChipIdea
Date: Fri, 22 Aug 2014 17:50:20 +0200
Message-Id: <1408722621-3635-10-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support of the PHY framework for ChipIdea drivers.
Changes are done in both the ChipIdea common code and in the drivers
accessing the PHY. This is done by adding a new PHY member in
ChipIdea's structures and by taking care of it in the code.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/ci.h      |  5 ++-
 drivers/usb/chipidea/core.c    | 71 ++++++++++++++++++++++++++++++++++--------
 drivers/usb/chipidea/debug.c   |  4 ++-
 drivers/usb/chipidea/host.c    |  5 ++-
 drivers/usb/chipidea/otg_fsm.c |  6 +++-
 include/linux/usb/chipidea.h   |  2 ++
 6 files changed, 76 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index dac5ab6adfa2..7e9e8223672a 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -161,7 +161,8 @@ struct hw_bank {
  * @test_mode: the selected test mode
  * @platdata: platform specific information supplied by parent device
  * @vbus_active: is VBUS active
- * @usb_phy: pointer to USB PHY, if any
+ * @phy: pointer to PHY, if any
+ * @usb_phy: pointer to USB PHY, if any and if using the USB PHY framework
  * @hcd: pointer to usb_hcd for ehci host driver
  * @debugfs: root dentry for this controller in debugfs
  * @id_event: indicates there is an id event, and handled at ci_otg_work
@@ -202,6 +203,8 @@ struct ci_hdrc {
 
 	struct ci_hdrc_platform_data	*platdata;
 	int				vbus_active;
+	struct phy			*phy;
+	/* old usb_phy interface */
 	struct usb_phy			*usb_phy;
 	struct usb_hcd			*hcd;
 	struct dentry			*debugfs;
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index a8cd35fd8175..0041f5b5eafc 100644
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
+	if (ci->phy) {
+		ret = phy_init(ci->phy);
+		if (ret) {
+			phy_exit(ci->phy);
+			return ret;
+		}
+		ret = phy_power_on(ci->phy);
+	} else {
+		ret = usb_phy_init(ci->usb_phy);
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
+	if (ci->phy) {
+		phy_power_off(ci->phy);
+		phy_exit(ci->phy);
+	} else {
+		usb_phy_shutdown(ci->usb_phy);
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
-		ret = usb_phy_init(ci->usb_phy);
+		ret = _ci_usb_phy_init(ci);
 		if (ret)
 			return ret;
 		hw_phymode_configure(ci);
@@ -314,12 +355,12 @@ static int ci_usb_phy_init(struct ci_hdrc *ci)
 	case USBPHY_INTERFACE_MODE_ULPI:
 	case USBPHY_INTERFACE_MODE_SERIAL:
 		hw_phymode_configure(ci);
-		ret = usb_phy_init(ci->usb_phy);
+		ret = _ci_usb_phy_init(ci);
 		if (ret)
 			return ret;
 		break;
 	default:
-		ret = usb_phy_init(ci->usb_phy);
+		ret = _ci_usb_phy_init(ci);
 	}
 
 	return ret;
@@ -595,23 +636,27 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (ci->platdata->usb_phy)
+	if (ci->platdata->phy)
+		ci->phy = ci->platdata->phy;
+	else if (ci->platdata->usb_phy)
 		ci->usb_phy = ci->platdata->usb_phy;
 	else
-		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+		ci->phy = devm_phy_get(dev, "usb-phy");
 
-	if (IS_ERR(ci->usb_phy)) {
-		ret = PTR_ERR(ci->usb_phy);
+	if (IS_ERR(ci->phy)) {
 		/*
 		 * if -ENXIO is returned, it means PHY layer wasn't
 		 * enabled, so it makes no sense to return -EPROBE_DEFER
 		 * in that case, since no PHY driver will ever probe.
 		 */
-		if (ret == -ENXIO)
-			return ret;
+		if (PTR_ERR(ci->phy) == -ENXIO)
+			return -ENXIO;
 
-		dev_err(dev, "no usb2 phy configured\n");
-		return -EPROBE_DEFER;
+		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+		if (IS_ERR(ci->usb_phy)) {
+			dev_err(dev, "no usb2 phy configured\n");
+			return -EPROBE_DEFER;
+		}
 	}
 
 	ret = ci_usb_phy_init(ci);
@@ -718,7 +763,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 stop:
 	ci_role_destroy(ci);
 deinit_phy:
-	usb_phy_shutdown(ci->usb_phy);
+	ci_usb_phy_exit(ci);
 
 	return ret;
 }
@@ -731,7 +776,7 @@ static int ci_hdrc_remove(struct platform_device *pdev)
 	free_irq(ci->irq, ci);
 	ci_role_destroy(ci);
 	ci_hdrc_enter_lpm(ci, true);
-	usb_phy_shutdown(ci->usb_phy);
+	ci_usb_phy_exit(ci);
 	kfree(ci->hw_bank.regmap);
 
 	return 0;
diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
index 5a7ea93011dd..9e9da190a144 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -219,7 +219,9 @@ static int ci_otg_show(struct seq_file *s, void *unused)
 	fsm = &ci->fsm;
 
 	/* ------ State ----- */
-		usb_otg_state_string(ci->usb_phy->otg.state));
+	if (ci->usb_phy)
+		seq_printf(s, "OTG state: %s\n\n",
+			usb_otg_state_string(ci->usb_phy->otg->state));
 
 	/* ------ State Machine Variables ----- */
 	seq_printf(s, "a_bus_drop: %d\n", fsm->a_bus_drop);
diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index 0952d4adfa4c..0465578bf805 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -59,7 +59,10 @@ static int host_start(struct ci_hdrc *ci)
 	hcd->has_tt = 1;
 
 	hcd->power_budget = ci->platdata->power_budget;
-	hcd->usb_phy = ci->usb_phy;
+	if (ci->phy)
+		hcd->phy = ci->phy;
+	else
+		hcd->usb_phy = ci->usb_phy;
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = ci->hw_bank.cap;
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index 7eb86863fb3c..164cd2fff39b 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -779,7 +779,11 @@ int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
 {
 	int retval = 0;
 
-	ci->otg.usb_phy = ci->usb_phy;
+	if (ci->phy)
+		ci->otg.phy = ci->phy;
+	else
+		ci->otg.usb_phy = ci->usb_phy;
+
 	ci->fsm.otg = &ci->otg;
 	ci->fsm.power_up = 1;
 	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
index 57d757a1aa83..a0285623b9c1 100644
--- a/include/linux/usb/chipidea.h
+++ b/include/linux/usb/chipidea.h
@@ -13,6 +13,8 @@ struct ci_hdrc_platform_data {
 	/* offset of the capability registers */
 	uintptr_t	 capoffset;
 	unsigned	 power_budget;
+	struct phy	*phy;
+	/* old usb_phy interface */
 	struct usb_phy	*usb_phy;
 	enum usb_phy_interface phy_mode;
 	unsigned long	 flags;
-- 
1.9.1

