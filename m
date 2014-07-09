Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaGIKTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:19:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45256 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755184AbaGIKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:19:50 -0400
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
Subject: [PATCH 2/4] usb: add support to the PHY framework for OTG
Date: Wed,  9 Jul 2014 12:17:14 +0200
Message-Id: <1404901036-27682-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support to PHY framework in OTG code, and keeps the
USB PHY compatibility. This is done in two steps: renaming 'phy' into
'usb_phy' and adding a new 'phy' member into the usb_otg structure.
These modifications are done in all drivers accessing the OTG PHY.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/phy/phy-omap-usb2.c         |  6 ++--
 drivers/usb/chipidea/otg_fsm.c      |  2 +-
 drivers/usb/phy/phy-ab8500-usb.c    |  6 ++--
 drivers/usb/phy/phy-fsl-usb.c       | 12 ++++----
 drivers/usb/phy/phy-generic.c       |  2 +-
 drivers/usb/phy/phy-gpio-vbus-usb.c |  2 +-
 drivers/usb/phy/phy-isp1301-omap.c  | 10 +++----
 drivers/usb/phy/phy-msm-usb.c       | 59 +++++++++++++++++++------------------
 drivers/usb/phy/phy-mv-usb.c        |  4 +--
 drivers/usb/phy/phy-samsung-usb2.c  |  2 +-
 drivers/usb/phy/phy-tahvo.c         |  8 +++--
 drivers/usb/phy/phy-ulpi.c          |  6 ++--
 include/linux/usb/otg.h             |  5 +++-
 13 files changed, 65 insertions(+), 59 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 1f444f91ed7d..13d3e36e208b 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -60,7 +60,7 @@ EXPORT_SYMBOL_GPL(omap_usb2_set_comparator);
 
 static int omap_usb_set_vbus(struct usb_otg *otg, bool enabled)
 {
-	struct omap_usb *phy = phy_to_omapusb(otg->phy);
+	struct omap_usb *phy = phy_to_omapusb(otg->usb_phy);
 
 	if (!phy->comparator)
 		return -ENODEV;
@@ -70,7 +70,7 @@ static int omap_usb_set_vbus(struct usb_otg *otg, bool enabled)
 
 static int omap_usb_start_srp(struct usb_otg *otg)
 {
-	struct omap_usb *phy = phy_to_omapusb(otg->phy);
+	struct omap_usb *phy = phy_to_omapusb(otg->usb_phy);
 
 	if (!phy->comparator)
 		return -ENODEV;
@@ -255,7 +255,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 		otg->set_vbus		= omap_usb_set_vbus;
 	if (phy_data->flags & OMAP_USB2_HAS_START_SRP)
 		otg->start_srp		= omap_usb_start_srp;
-	otg->phy		= &phy->phy;
+	otg->usb_phy		= &phy->phy;
 
 	platform_set_drvdata(pdev, phy);
 	pm_runtime_enable(phy->dev);
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index 8cb2508a6b71..d8490e758a74 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -788,7 +788,7 @@ int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
 		return -ENOMEM;
 	}
 
-	otg->phy = ci->transceiver;
+	otg->usb_phy = ci->transceiver;
 	otg->gadget = &ci->gadget;
 	ci->fsm.otg = otg;
 	ci->transceiver->otg = ci->fsm.otg;
diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 2d5250143ce1..3a802fa7dae2 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -1056,7 +1056,7 @@ static int ab8500_usb_set_peripheral(struct usb_otg *otg,
 	if (!otg)
 		return -ENODEV;
 
-	ab = phy_to_ab(otg->phy);
+	ab = phy_to_ab(otg->usb_phy);
 
 	ab->phy.otg->gadget = gadget;
 
@@ -1080,7 +1080,7 @@ static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 	if (!otg)
 		return -ENODEV;
 
-	ab = phy_to_ab(otg->phy);
+	ab = phy_to_ab(otg->usb_phy);
 
 	ab->phy.otg->host = host;
 
@@ -1382,7 +1382,7 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	ab->phy.set_power	= ab8500_usb_set_power;
 	ab->phy.otg->state	= OTG_STATE_UNDEFINED;
 
-	otg->phy		= &ab->phy;
+	otg->usb_phy		= &ab->phy;
 	otg->set_host		= ab8500_usb_set_host;
 	otg->set_peripheral	= ab8500_usb_set_peripheral;
 
diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index a22f88fb8176..548bbc4a89d9 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -499,7 +499,7 @@ int fsl_otg_start_host(struct otg_fsm *fsm, int on)
 {
 	struct usb_otg *otg = fsm->otg;
 	struct device *dev;
-	struct fsl_otg *otg_dev = container_of(otg->phy, struct fsl_otg, phy);
+	struct fsl_otg *otg_dev = container_of(otg->usb_phy, struct fsl_otg, phy);
 	u32 retval = 0;
 
 	if (!otg->host)
@@ -594,7 +594,7 @@ static int fsl_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 	if (!otg)
 		return -ENODEV;
 
-	otg_dev = container_of(otg->phy, struct fsl_otg, phy);
+	otg_dev = container_of(otg->usb_phy, struct fsl_otg, phy);
 	if (otg_dev != fsl_otg_dev)
 		return -ENODEV;
 
@@ -644,7 +644,7 @@ static int fsl_otg_set_peripheral(struct usb_otg *otg,
 	if (!otg)
 		return -ENODEV;
 
-	otg_dev = container_of(otg->phy, struct fsl_otg, phy);
+	otg_dev = container_of(otg->usb_phy, struct fsl_otg, phy);
 	VDBG("otg_dev 0x%x\n", (int)otg_dev);
 	VDBG("fsl_otg_dev 0x%x\n", (int)fsl_otg_dev);
 	if (otg_dev != fsl_otg_dev)
@@ -717,7 +717,7 @@ static int fsl_otg_start_srp(struct usb_otg *otg)
 	if (!otg || otg.state != OTG_STATE_B_IDLE)
 		return -ENODEV;
 
-	otg_dev = container_of(otg->phy, struct fsl_otg, phy);
+	otg_dev = container_of(otg->usb_phy, struct fsl_otg, phy);
 	if (otg_dev != fsl_otg_dev)
 		return -ENODEV;
 
@@ -735,7 +735,7 @@ static int fsl_otg_start_hnp(struct usb_otg *otg)
 	if (!otg)
 		return -ENODEV;
 
-	otg_dev = container_of(otg->phy, struct fsl_otg, phy);
+	otg_dev = container_of(otg->usb_phy, struct fsl_otg, phy);
 	if (otg_dev != fsl_otg_dev)
 		return -ENODEV;
 
@@ -857,7 +857,7 @@ static int fsl_otg_conf(struct platform_device *pdev)
 	fsl_otg_tc->phy.dev = &pdev->dev;
 	fsl_otg_tc->phy.set_power = fsl_otg_set_power;
 
-	fsl_otg_tc->phy.otg->phy = &fsl_otg_tc->phy;
+	fsl_otg_tc->phy.otg->usb_phy = &fsl_otg_tc->phy;
 	fsl_otg_tc->phy.otg->set_host = fsl_otg_set_host;
 	fsl_otg_tc->phy.otg->set_peripheral = fsl_otg_set_peripheral;
 	fsl_otg_tc->phy.otg->start_hnp = fsl_otg_start_hnp;
diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index 280a3458ff6b..0c01bd12cabc 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -228,7 +228,7 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop,
 	nop->phy.type		= type;
 
 	nop->phy.otg->state		= OTG_STATE_UNDEFINED;
-	nop->phy.otg->phy		= &nop->phy;
+	nop->phy.otg->usb_phy		= &nop->phy;
 	nop->phy.otg->set_host		= nop_set_host;
 	nop->phy.otg->set_peripheral	= nop_set_peripheral;
 
diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio-vbus-usb.c
index a4e88a28199a..0ca42bb2e661 100644
--- a/drivers/usb/phy/phy-gpio-vbus-usb.c
+++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
@@ -271,7 +271,7 @@ static int gpio_vbus_probe(struct platform_device *pdev)
 	gpio_vbus->phy.set_suspend = gpio_vbus_set_suspend;
 
 	gpio_vbus->phy.otg->state = OTG_STATE_UNDEFINED;
-	gpio_vbus->phy.otg->phy = &gpio_vbus->phy;
+	gpio_vbus->phy.otg->usb_phy = &gpio_vbus->phy;
 	gpio_vbus->phy.otg->set_peripheral = gpio_vbus_set_peripheral;
 
 	err = gpio_request(gpio, "vbus_detect");
diff --git a/drivers/usb/phy/phy-isp1301-omap.c b/drivers/usb/phy/phy-isp1301-omap.c
index 69e49be8866b..cf0bd694ed1c 100644
--- a/drivers/usb/phy/phy-isp1301-omap.c
+++ b/drivers/usb/phy/phy-isp1301-omap.c
@@ -1275,7 +1275,7 @@ static int isp1301_otg_enable(struct isp1301 *isp)
 static int
 isp1301_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct isp1301	*isp = container_of(otg->phy, struct isp1301, phy);
+	struct isp1301	*isp = container_of(otg->usb_phy, struct isp1301, phy);
 
 	if (isp != the_transceiver)
 		return -ENODEV;
@@ -1331,7 +1331,7 @@ isp1301_set_host(struct usb_otg *otg, struct usb_bus *host)
 static int
 isp1301_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
 {
-	struct isp1301	*isp = container_of(otg->phy, struct isp1301, phy);
+	struct isp1301	*isp = container_of(otg->usb_phy, struct isp1301, phy);
 
 	if (isp != the_transceiver)
 		return -ENODEV;
@@ -1411,7 +1411,7 @@ isp1301_set_power(struct usb_phy *dev, unsigned mA)
 static int
 isp1301_start_srp(struct usb_otg *otg)
 {
-	struct isp1301	*isp = container_of(otg->phy, struct isp1301, phy);
+	struct isp1301	*isp = container_of(otg->usb_phy, struct isp1301, phy);
 	u32		otg_ctrl;
 
 	if (isp != the_transceiver || isp->phy.state != OTG_STATE_B_IDLE)
@@ -1438,7 +1438,7 @@ static int
 isp1301_start_hnp(struct usb_otg *otg)
 {
 #ifdef	CONFIG_USB_OTG
-	struct isp1301	*isp = container_of(otg->phy, struct isp1301, phy);
+	struct isp1301	*isp = container_of(otg->usb_phy, struct isp1301, phy);
 	u32 l;
 
 	if (isp != the_transceiver)
@@ -1583,7 +1583,7 @@ isp1301_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	isp->phy.label = DRIVER_NAME;
 	isp->phy.set_power = isp1301_set_power,
 
-	isp->phy.otg->phy = &isp->phy;
+	isp->phy.otg->usb_phy = &isp->phy;
 	isp->phy.otg->set_host = isp1301_set_host,
 	isp->phy.otg->set_peripheral = isp1301_set_peripheral,
 	isp->phy.otg->start_srp = isp1301_start_srp,
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 4394397b1370..11e877964173 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -708,7 +708,7 @@ static void msm_otg_start_host(struct usb_phy *phy, int on)
 
 static int msm_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct msm_otg *motg = container_of(otg->phy, struct msm_otg, phy);
+	struct msm_otg *motg = container_of(otg->usb_phy, struct msm_otg, phy);
 	struct usb_hcd *hcd;
 
 	/*
@@ -716,14 +716,14 @@ static int msm_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 	 * only peripheral configuration.
 	 */
 	if (motg->pdata->mode == USB_DR_MODE_PERIPHERAL) {
-		dev_info(otg->phy->dev, "Host mode is not supported\n");
+		dev_info(otg->usb_phy->dev, "Host mode is not supported\n");
 		return -ENODEV;
 	}
 
 	if (!host) {
 		if (otg->state == OTG_STATE_A_HOST) {
-			pm_runtime_get_sync(otg->phy->dev);
-			msm_otg_start_host(otg->phy, 0);
+			pm_runtime_get_sync(otg->usb_phy->dev);
+			msm_otg_start_host(otg->usb_phy, 0);
 			otg->host = NULL;
 			otg->state = OTG_STATE_UNDEFINED;
 			schedule_work(&motg->sm_work);
@@ -738,14 +738,14 @@ static int msm_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 	hcd->power_budget = motg->pdata->power_budget;
 
 	otg->host = host;
-	dev_dbg(otg->phy->dev, "host driver registered w/ tranceiver\n");
+	dev_dbg(otg->usb_phy->dev, "host driver registered w/ tranceiver\n");
 
 	/*
 	 * Kick the state machine work, if peripheral is not supported
 	 * or peripheral is already registered with us.
 	 */
 	if (motg->pdata->mode == USB_DR_MODE_HOST || otg->gadget) {
-		pm_runtime_get_sync(otg->phy->dev);
+		pm_runtime_get_sync(otg->usb_phy->dev);
 		schedule_work(&motg->sm_work);
 	}
 
@@ -782,21 +782,21 @@ static void msm_otg_start_peripheral(struct usb_phy *phy, int on)
 static int msm_otg_set_peripheral(struct usb_otg *otg,
 					struct usb_gadget *gadget)
 {
-	struct msm_otg *motg = container_of(otg->phy, struct msm_otg, phy);
+	struct msm_otg *motg = container_of(otg->usb_phy, struct msm_otg, phy);
 
 	/*
 	 * Fail peripheral registration if this board can support
 	 * only host configuration.
 	 */
 	if (motg->pdata->mode == USB_DR_MODE_HOST) {
-		dev_info(otg->phy->dev, "Peripheral mode is not supported\n");
+		dev_info(otg->usb_phy->dev, "Peripheral mode is not supported\n");
 		return -ENODEV;
 	}
 
 	if (!gadget) {
 		if (otg->state == OTG_STATE_B_PERIPHERAL) {
-			pm_runtime_get_sync(otg->phy->dev);
-			msm_otg_start_peripheral(otg->phy, 0);
+			pm_runtime_get_sync(otg->usb_phy->dev);
+			msm_otg_start_peripheral(otg->usb_phy, 0);
 			otg->gadget = NULL;
 			otg->state = OTG_STATE_UNDEFINED;
 			schedule_work(&motg->sm_work);
@@ -807,14 +807,15 @@ static int msm_otg_set_peripheral(struct usb_otg *otg,
 		return 0;
 	}
 	otg->gadget = gadget;
-	dev_dbg(otg->phy->dev, "peripheral driver registered w/ tranceiver\n");
+	dev_dbg(otg->usb_phy->dev,
+		"peripheral driver registered w/ tranceiver\n");
 
 	/*
 	 * Kick the state machine work, if host is not supported
 	 * or host is already registered with us.
 	 */
 	if (motg->pdata->mode == USB_DR_MODE_PERIPHERAL || otg->host) {
-		pm_runtime_get_sync(otg->phy->dev);
+		pm_runtime_get_sync(otg->usb_phy->dev);
 		schedule_work(&motg->sm_work);
 	}
 
@@ -1172,17 +1173,17 @@ static void msm_otg_sm_work(struct work_struct *w)
 
 	switch (otg->state) {
 	case OTG_STATE_UNDEFINED:
-		dev_dbg(otg->phy->dev, "OTG_STATE_UNDEFINED state\n");
-		msm_otg_reset(otg->phy);
+		dev_dbg(otg->usb_phy->dev, "OTG_STATE_UNDEFINED state\n");
+		msm_otg_reset(otg->usb_phy);
 		msm_otg_init_sm(motg);
 		otg->state = OTG_STATE_B_IDLE;
 		/* FALL THROUGH */
 	case OTG_STATE_B_IDLE:
-		dev_dbg(otg->phy->dev, "OTG_STATE_B_IDLE state\n");
+		dev_dbg(otg->usb_phy->dev, "OTG_STATE_B_IDLE state\n");
 		if (!test_bit(ID, &motg->inputs) && otg->host) {
 			/* disable BSV bit */
 			writel(readl(USB_OTGSC) & ~OTGSC_BSVIE, USB_OTGSC);
-			msm_otg_start_host(otg->phy, 1);
+			msm_otg_start_host(otg->usb_phy, 1);
 			otg->state = OTG_STATE_A_HOST;
 		} else if (test_bit(B_SESS_VLD, &motg->inputs)) {
 			switch (motg->chg_state) {
@@ -1198,13 +1199,13 @@ static void msm_otg_sm_work(struct work_struct *w)
 				case USB_CDP_CHARGER:
 					msm_otg_notify_charger(motg,
 							IDEV_CHG_MAX);
-					msm_otg_start_peripheral(otg->phy, 1);
+					msm_otg_start_peripheral(otg->usb_phy, 1);
 					otg->state
 						= OTG_STATE_B_PERIPHERAL;
 					break;
 				case USB_SDP_CHARGER:
 					msm_otg_notify_charger(motg, IUNIT);
-					msm_otg_start_peripheral(otg->phy, 1);
+					msm_otg_start_peripheral(otg->usb_phy, 1);
 					otg->state
 						= OTG_STATE_B_PERIPHERAL;
 					break;
@@ -1222,8 +1223,8 @@ static void msm_otg_sm_work(struct work_struct *w)
 			 * is incremented in charger detection work.
 			 */
 			if (cancel_delayed_work_sync(&motg->chg_work)) {
-				pm_runtime_put_sync(otg->phy->dev);
-				msm_otg_reset(otg->phy);
+				pm_runtime_put_sync(otg->usb_phy->dev);
+				msm_otg_reset(otg->usb_phy);
 			}
 			msm_otg_notify_charger(motg, 0);
 			motg->chg_state = USB_CHG_STATE_UNDEFINED;
@@ -1231,27 +1232,27 @@ static void msm_otg_sm_work(struct work_struct *w)
 		}
 
 		if (otg->state == OTG_STATE_B_IDLE)
-			pm_runtime_put_sync(otg->phy->dev);
+			pm_runtime_put_sync(otg->usb_phy->dev);
 		break;
 	case OTG_STATE_B_PERIPHERAL:
-		dev_dbg(otg->phy->dev, "OTG_STATE_B_PERIPHERAL state\n");
+		dev_dbg(otg->usb_phy->dev, "OTG_STATE_B_PERIPHERAL state\n");
 		if (!test_bit(B_SESS_VLD, &motg->inputs) ||
 				!test_bit(ID, &motg->inputs)) {
 			msm_otg_notify_charger(motg, 0);
-			msm_otg_start_peripheral(otg->phy, 0);
+			msm_otg_start_peripheral(otg->usb_phy, 0);
 			motg->chg_state = USB_CHG_STATE_UNDEFINED;
 			motg->chg_type = USB_INVALID_CHARGER;
 			otg->state = OTG_STATE_B_IDLE;
-			msm_otg_reset(otg->phy);
+			msm_otg_reset(otg->usb_phy);
 			schedule_work(w);
 		}
 		break;
 	case OTG_STATE_A_HOST:
-		dev_dbg(otg->phy->dev, "OTG_STATE_A_HOST state\n");
+		dev_dbg(otg->usb_phy->dev, "OTG_STATE_A_HOST state\n");
 		if (test_bit(ID, &motg->inputs)) {
-			msm_otg_start_host(otg->phy, 0);
+			msm_otg_start_host(otg->usb_phy, 0);
 			otg->state = OTG_STATE_B_IDLE;
-			msm_otg_reset(otg->phy);
+			msm_otg_reset(otg->usb_phy);
 			schedule_work(w);
 		}
 		break;
@@ -1388,7 +1389,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 		goto out;
 	}
 
-	pm_runtime_get_sync(otg->phy->dev);
+	pm_runtime_get_sync(otg->usb_phy->dev);
 	schedule_work(&motg->sm_work);
 out:
 	return status;
@@ -1671,7 +1672,7 @@ static int msm_otg_probe(struct platform_device *pdev)
 
 	phy->io_ops = &msm_otg_io_ops;
 
-	phy->otg->phy = &motg->phy;
+	phy->otg->usb_phy = &motg->phy;
 	phy->otg->set_host = msm_otg_set_host;
 	phy->otg->set_peripheral = msm_otg_set_peripheral;
 
diff --git a/drivers/usb/phy/phy-mv-usb.c b/drivers/usb/phy/phy-mv-usb.c
index d6b3c473f068..d948275d55e5 100644
--- a/drivers/usb/phy/phy-mv-usb.c
+++ b/drivers/usb/phy/phy-mv-usb.c
@@ -56,7 +56,7 @@ static char *state_string[] = {
 
 static int mv_otg_set_vbus(struct usb_otg *otg, bool on)
 {
-	struct mv_otg *mvotg = container_of(otg->phy, struct mv_otg, phy);
+	struct mv_otg *mvotg = container_of(otg->usb_phy, struct mv_otg, phy);
 	if (mvotg->pdata->set_vbus == NULL)
 		return -ENODEV;
 
@@ -718,8 +718,8 @@ static int mv_otg_probe(struct platform_device *pdev)
 	mvotg->phy.otg = otg;
 	mvotg->phy.label = driver_name;
 
-	otg->phy = &mvotg->phy;
 	otg->state = OTG_STATE_UNDEFINED;
+	otg->usb_phy = &mvotg->phy;
 	otg->set_host = mv_otg_set_host;
 	otg->set_peripheral = mv_otg_set_peripheral;
 	otg->set_vbus = mv_otg_set_vbus;
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index b3ba86627b72..2a6d8cfa8839 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -420,7 +420,7 @@ static int samsung_usb2phy_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	sphy->phy.otg		= otg;
-	sphy->phy.otg->phy	= &sphy->phy;
+	sphy->phy.otg->usb_phy	= &sphy->phy;
 	sphy->phy.otg->set_host = samsung_usbphy_set_host;
 
 	spin_lock_init(&sphy->lock);
diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index cc61ee44b911..402e6af29c65 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -196,7 +196,8 @@ static int tahvo_usb_set_suspend(struct usb_phy *dev, int suspend)
 
 static int tahvo_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct tahvo_usb *tu = container_of(otg->phy, struct tahvo_usb, phy);
+	struct tahvo_usb *tu = container_of(otg->usb_phy, struct tahvo_usb,
+					    phy);
 
 	dev_dbg(&tu->pt_dev->dev, "%s %p\n", __func__, host);
 
@@ -225,7 +226,8 @@ static int tahvo_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 static int tahvo_usb_set_peripheral(struct usb_otg *otg,
 				    struct usb_gadget *gadget)
 {
-	struct tahvo_usb *tu = container_of(otg->phy, struct tahvo_usb, phy);
+	struct tahvo_usb *tu = container_of(otg->usb_phy, struct tahvo_usb,
+					    phy);
 
 	dev_dbg(&tu->pt_dev->dev, "%s %p\n", __func__, gadget);
 
@@ -383,7 +385,7 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 	tu->phy.label = DRIVER_NAME;
 	tu->phy.set_suspend = tahvo_usb_set_suspend;
 
-	tu->phy.otg->phy = &tu->phy;
+	tu->phy.otg->usb_phy = &tu->phy;
 	tu->phy.otg->set_host = tahvo_usb_set_host;
 	tu->phy.otg->set_peripheral = tahvo_usb_set_peripheral;
 
diff --git a/drivers/usb/phy/phy-ulpi.c b/drivers/usb/phy/phy-ulpi.c
index 4e3877c329f2..f48a7a21e3c2 100644
--- a/drivers/usb/phy/phy-ulpi.c
+++ b/drivers/usb/phy/phy-ulpi.c
@@ -211,7 +211,7 @@ static int ulpi_init(struct usb_phy *phy)
 
 static int ulpi_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct usb_phy *phy = otg->phy;
+	struct usb_phy *phy = otg->usb_phy;
 	unsigned int flags = usb_phy_io_read(phy, ULPI_IFC_CTRL);
 
 	if (!host) {
@@ -237,7 +237,7 @@ static int ulpi_set_host(struct usb_otg *otg, struct usb_bus *host)
 
 static int ulpi_set_vbus(struct usb_otg *otg, bool on)
 {
-	struct usb_phy *phy = otg->phy;
+	struct usb_phy *phy = otg->usb_phy;
 	unsigned int flags = usb_phy_io_read(phy, ULPI_OTG_CTRL);
 
 	flags &= ~(ULPI_OTG_CTRL_DRVVBUS | ULPI_OTG_CTRL_DRVVBUS_EXT);
@@ -276,7 +276,7 @@ otg_ulpi_create(struct usb_phy_io_ops *ops,
 	phy->otg	= otg;
 	phy->init	= ulpi_init;
 
-	otg->phy	= phy;
+	otg->usb_phy	= phy;
 	otg->set_host	= ulpi_set_host;
 	otg->set_vbus	= ulpi_set_vbus;
 
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 33d3480c9cda..52661c5da690 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -9,12 +9,15 @@
 #ifndef __LINUX_USB_OTG_H
 #define __LINUX_USB_OTG_H
 
+#include <linux/phy/phy.h>
 #include <linux/usb/phy.h>
 
 struct usb_otg {
 	u8			default_a;
 
-	struct usb_phy		*phy;
+	struct phy		*phy;
+	/* old usb_phy interface */
+	struct usb_phy		*usb_phy;
 	struct usb_bus		*host;
 	struct usb_gadget	*gadget;
 
-- 
1.9.1

