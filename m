Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab3CHC1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:27:48 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:60037 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933614Ab3CHC1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:27:44 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2 5/5] usb: otg: ab8500-usb: update irq handling code
Date: Fri,  8 Mar 2013 10:27:09 +0800
Message-Id: <1362709629-27238-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362709629-27238-1-git-send-email-fabio.baltieri@linaro.org>
References: <1362709629-27238-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update irq handling code to notify all possible link status changes of
AB8500 and AB8505 to the ux500-musb glue driver.  The additional event
codes will be used for pm-runtime implementation, and are defined in a
separate ux500-specific header.

This also modify the irq registration code to use devm_* helpers and
drop all non necessary fail path code.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/musb/ux500.c       |   7 +-
 drivers/usb/otg/ab8500-usb.c   | 440 ++++++++++++++++++++++++++++++++---------
 include/linux/usb/musb-ux500.h |  31 +++
 3 files changed, 382 insertions(+), 96 deletions(-)
 create mode 100644 include/linux/usb/musb-ux500.h

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 55f24c6..e882d27 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -26,6 +26,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/usb/musb-ux500.h>
 
 #include "musb_core.h"
 
@@ -107,15 +108,15 @@ static int musb_otg_notifications(struct notifier_block *nb,
 			event, otg_state_string(musb->xceiv->state));
 
 	switch (event) {
-	case USB_EVENT_ID:
+	case UX500_MUSB_ID:
 		dev_dbg(musb->controller, "ID GND\n");
 		ux500_musb_set_vbus(musb, 1);
 		break;
-	case USB_EVENT_VBUS:
+	case UX500_MUSB_VBUS:
 		dev_dbg(musb->controller, "VBUS Connect\n");
 		ux500_musb_set_vbus(musb, 0);
 		break;
-	case USB_EVENT_NONE:
+	case UX500_MUSB_NONE:
 		dev_dbg(musb->controller, "VBUS Disconnect\n");
 		if (is_host_active(musb))
 			ux500_musb_set_vbus(musb, 0);
diff --git a/drivers/usb/otg/ab8500-usb.c b/drivers/usb/otg/ab8500-usb.c
index 9f5e0e4..351b036 100644
--- a/drivers/usb/otg/ab8500-usb.c
+++ b/drivers/usb/otg/ab8500-usb.c
@@ -31,9 +31,11 @@
 #include <linux/delay.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
+#include <linux/usb/musb-ux500.h>
 
 #define AB8500_MAIN_WD_CTRL_REG 0x01
 #define AB8500_USB_LINE_STAT_REG 0x80
+#define AB8505_USB_LINE_STAT_REG 0x94
 #define AB8500_USB_PHY_CTRL_REG 0x8A
 
 #define AB8500_BIT_OTG_STAT_ID (1 << 0)
@@ -44,36 +46,76 @@
 
 #define AB8500_WD_KICK_DELAY_US 100 /* usec */
 #define AB8500_WD_V11_DISABLE_DELAY_US 100 /* usec */
+#define AB8500_V20_31952_DISABLE_DELAY_US 100 /* usec */
 
 /* Usb line status register */
 enum ab8500_usb_link_status {
-	USB_LINK_NOT_CONFIGURED = 0,
-	USB_LINK_STD_HOST_NC,
-	USB_LINK_STD_HOST_C_NS,
-	USB_LINK_STD_HOST_C_S,
-	USB_LINK_HOST_CHG_NM,
-	USB_LINK_HOST_CHG_HS,
-	USB_LINK_HOST_CHG_HS_CHIRP,
-	USB_LINK_DEDICATED_CHG,
-	USB_LINK_ACA_RID_A,
-	USB_LINK_ACA_RID_B,
-	USB_LINK_ACA_RID_C_NM,
-	USB_LINK_ACA_RID_C_HS,
-	USB_LINK_ACA_RID_C_HS_CHIRP,
-	USB_LINK_HM_IDGND,
-	USB_LINK_RESERVED,
-	USB_LINK_NOT_VALID_LINK
+	USB_LINK_NOT_CONFIGURED_8500 = 0,
+	USB_LINK_STD_HOST_NC_8500,
+	USB_LINK_STD_HOST_C_NS_8500,
+	USB_LINK_STD_HOST_C_S_8500,
+	USB_LINK_HOST_CHG_NM_8500,
+	USB_LINK_HOST_CHG_HS_8500,
+	USB_LINK_HOST_CHG_HS_CHIRP_8500,
+	USB_LINK_DEDICATED_CHG_8500,
+	USB_LINK_ACA_RID_A_8500,
+	USB_LINK_ACA_RID_B_8500,
+	USB_LINK_ACA_RID_C_NM_8500,
+	USB_LINK_ACA_RID_C_HS_8500,
+	USB_LINK_ACA_RID_C_HS_CHIRP_8500,
+	USB_LINK_HM_IDGND_8500,
+	USB_LINK_RESERVED_8500,
+	USB_LINK_NOT_VALID_LINK_8500,
+};
+
+enum ab8505_usb_link_status {
+	USB_LINK_NOT_CONFIGURED_8505 = 0,
+	USB_LINK_STD_HOST_NC_8505,
+	USB_LINK_STD_HOST_C_NS_8505,
+	USB_LINK_STD_HOST_C_S_8505,
+	USB_LINK_CDP_8505,
+	USB_LINK_RESERVED0_8505,
+	USB_LINK_RESERVED1_8505,
+	USB_LINK_DEDICATED_CHG_8505,
+	USB_LINK_ACA_RID_A_8505,
+	USB_LINK_ACA_RID_B_8505,
+	USB_LINK_ACA_RID_C_NM_8505,
+	USB_LINK_RESERVED2_8505,
+	USB_LINK_RESERVED3_8505,
+	USB_LINK_HM_IDGND_8505,
+	USB_LINK_CHARGERPORT_NOT_OK_8505,
+	USB_LINK_CHARGER_DM_HIGH_8505,
+	USB_LINK_PHYEN_NO_VBUS_NO_IDGND_8505,
+	USB_LINK_STD_UPSTREAM_NO_IDGNG_NO_VBUS_8505,
+	USB_LINK_STD_UPSTREAM_8505,
+	USB_LINK_CHARGER_SE1_8505,
+	USB_LINK_CARKIT_CHGR_1_8505,
+	USB_LINK_CARKIT_CHGR_2_8505,
+	USB_LINK_ACA_DOCK_CHGR_8505,
+	USB_LINK_SAMSUNG_BOOT_CBL_PHY_EN_8505,
+	USB_LINK_SAMSUNG_BOOT_CBL_PHY_DISB_8505,
+	USB_LINK_SAMSUNG_UART_CBL_PHY_EN_8505,
+	USB_LINK_SAMSUNG_UART_CBL_PHY_DISB_8505,
+	USB_LINK_MOTOROLA_FACTORY_CBL_PHY_EN_8505,
+};
+
+enum ab8500_usb_mode {
+	USB_IDLE = 0,
+	USB_PERIPHERAL,
+	USB_HOST,
+	USB_DEDICATED_CHG
 };
 
 struct ab8500_usb {
 	struct usb_phy phy;
 	struct device *dev;
 	struct ab8500 *ab8500;
-	int irq_num_link_status;
 	unsigned vbus_draw;
 	struct delayed_work dwork;
 	struct work_struct phy_dis_work;
 	unsigned long link_status_wait;
+	enum ab8500_usb_mode mode;
+	int previous_link_status_state;
 };
 
 static inline struct ab8500_usb *phy_to_ab(struct usb_phy *x)
@@ -104,6 +146,17 @@ static void ab8500_usb_wd_workaround(struct ab8500_usb *ab)
 		0);
 }
 
+static void ab8500_usb_wd_linkstatus(struct ab8500_usb *ab, u8 bit)
+{
+	/* Workaround for v2.0 bug # 31952 */
+	if (is_ab8500_2p0(ab->ab8500)) {
+		abx500_mask_and_set_register_interruptible(ab->dev,
+				AB8500_USB, AB8500_USB_PHY_CTRL_REG,
+				bit, bit);
+		udelay(AB8500_V20_31952_DISABLE_DELAY_US);
+	}
+}
+
 static void ab8500_usb_phy_ctrl(struct ab8500_usb *ab, bool sel_host,
 					bool enable)
 {
@@ -139,92 +192,276 @@ static void ab8500_usb_phy_ctrl(struct ab8500_usb *ab, bool sel_host,
 #define ab8500_usb_peri_phy_en(ab)	ab8500_usb_phy_ctrl(ab, false, true)
 #define ab8500_usb_peri_phy_dis(ab)	ab8500_usb_phy_ctrl(ab, false, false)
 
-static int ab8500_usb_link_status_update(struct ab8500_usb *ab)
+static int ab8505_usb_link_status_update(struct ab8500_usb *ab,
+		enum ab8505_usb_link_status lsts)
 {
-	u8 reg;
-	enum ab8500_usb_link_status lsts;
-	void *v = NULL;
-	enum usb_phy_events event;
+	enum ux500_musb_vbus_id_status event = 0;
 
-	abx500_get_register_interruptible(ab->dev,
-			AB8500_USB,
-			AB8500_USB_LINE_STAT_REG,
-			&reg);
+	dev_dbg(ab->dev, "ab8505_usb_link_status_update %d\n", lsts);
 
-	lsts = (reg >> 3) & 0x0F;
+	/*
+	 * Spurious link_status interrupts are seen at the time of
+	 * disconnection of a device in RIDA state
+	 */
+	if (ab->previous_link_status_state == USB_LINK_ACA_RID_A_8505 &&
+			(lsts == USB_LINK_STD_HOST_NC_8505))
+		return 0;
+
+	ab->previous_link_status_state = lsts;
 
 	switch (lsts) {
-	case USB_LINK_NOT_CONFIGURED:
-	case USB_LINK_RESERVED:
-	case USB_LINK_NOT_VALID_LINK:
-		/* TODO: Disable regulators. */
-		ab8500_usb_host_phy_dis(ab);
-		ab8500_usb_peri_phy_dis(ab);
-		ab->phy.state = OTG_STATE_B_IDLE;
+	case USB_LINK_ACA_RID_B_8505:
+		event = UX500_MUSB_RIDB;
+	case USB_LINK_NOT_CONFIGURED_8505:
+	case USB_LINK_RESERVED0_8505:
+	case USB_LINK_RESERVED1_8505:
+	case USB_LINK_RESERVED2_8505:
+	case USB_LINK_RESERVED3_8505:
+		ab->mode = USB_IDLE;
 		ab->phy.otg->default_a = false;
 		ab->vbus_draw = 0;
-		event = USB_EVENT_NONE;
+		if (event != UX500_MUSB_RIDB)
+			event = UX500_MUSB_NONE;
+		/*
+		 * Fallback to default B_IDLE as nothing
+		 * is connected
+		 */
+		ab->phy.state = OTG_STATE_B_IDLE;
 		break;
 
-	case USB_LINK_STD_HOST_NC:
-	case USB_LINK_STD_HOST_C_NS:
-	case USB_LINK_STD_HOST_C_S:
-	case USB_LINK_HOST_CHG_NM:
-	case USB_LINK_HOST_CHG_HS:
-	case USB_LINK_HOST_CHG_HS_CHIRP:
-		if (ab->phy.otg->gadget) {
-			/* TODO: Enable regulators. */
+	case USB_LINK_ACA_RID_C_NM_8505:
+		event = UX500_MUSB_RIDC;
+	case USB_LINK_STD_HOST_NC_8505:
+	case USB_LINK_STD_HOST_C_NS_8505:
+	case USB_LINK_STD_HOST_C_S_8505:
+	case USB_LINK_CDP_8505:
+		if (ab->mode == USB_IDLE) {
+			ab->mode = USB_PERIPHERAL;
 			ab8500_usb_peri_phy_en(ab);
-			v = ab->phy.otg->gadget;
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					UX500_MUSB_PREPARE, &ab->vbus_draw);
 		}
-		event = USB_EVENT_VBUS;
+		if (event != UX500_MUSB_RIDC)
+			event = UX500_MUSB_VBUS;
 		break;
 
-	case USB_LINK_HM_IDGND:
-		if (ab->phy.otg->host) {
-			/* TODO: Enable regulators. */
+	case USB_LINK_ACA_RID_A_8505:
+	case USB_LINK_ACA_DOCK_CHGR_8505:
+		event = UX500_MUSB_RIDA;
+	case USB_LINK_HM_IDGND_8505:
+		if (ab->mode == USB_IDLE) {
+			ab->mode = USB_HOST;
 			ab8500_usb_host_phy_en(ab);
-			v = ab->phy.otg->host;
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					UX500_MUSB_PREPARE, &ab->vbus_draw);
 		}
-		ab->phy.state = OTG_STATE_A_IDLE;
 		ab->phy.otg->default_a = true;
-		event = USB_EVENT_ID;
+		if (event != UX500_MUSB_RIDA)
+			event = UX500_MUSB_ID;
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				event, &ab->vbus_draw);
 		break;
 
-	case USB_LINK_ACA_RID_A:
-	case USB_LINK_ACA_RID_B:
-		/* TODO */
-	case USB_LINK_ACA_RID_C_NM:
-	case USB_LINK_ACA_RID_C_HS:
-	case USB_LINK_ACA_RID_C_HS_CHIRP:
-	case USB_LINK_DEDICATED_CHG:
-		/* TODO: vbus_draw */
-		event = USB_EVENT_CHARGER;
+	case USB_LINK_DEDICATED_CHG_8505:
+		ab->mode = USB_DEDICATED_CHG;
+		event = UX500_MUSB_CHARGER;
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				event, &ab->vbus_draw);
+		break;
+
+	default:
 		break;
 	}
 
-	atomic_notifier_call_chain(&ab->phy.notifier, event, v);
+	return 0;
+}
+
+static int ab8500_usb_link_status_update(struct ab8500_usb *ab,
+		enum ab8500_usb_link_status lsts)
+{
+	enum ux500_musb_vbus_id_status event = 0;
+
+	dev_dbg(ab->dev, "ab8500_usb_link_status_update %d\n", lsts);
+
+	/*
+	 * Spurious link_status interrupts are seen in case of a
+	 * disconnection of a device in IDGND and RIDA stage
+	 */
+	if (ab->previous_link_status_state == USB_LINK_HM_IDGND_8500 &&
+			(lsts == USB_LINK_STD_HOST_C_NS_8500 ||
+			 lsts == USB_LINK_STD_HOST_NC_8500))
+		return 0;
+
+	if (ab->previous_link_status_state == USB_LINK_ACA_RID_A_8500 &&
+			lsts == USB_LINK_STD_HOST_NC_8500)
+		return 0;
+
+	ab->previous_link_status_state = lsts;
+
+	switch (lsts) {
+	case USB_LINK_ACA_RID_B_8500:
+		event = UX500_MUSB_RIDB;
+	case USB_LINK_NOT_CONFIGURED_8500:
+	case USB_LINK_NOT_VALID_LINK_8500:
+		ab->mode = USB_IDLE;
+		ab->phy.otg->default_a = false;
+		ab->vbus_draw = 0;
+		if (event != UX500_MUSB_RIDB)
+			event = UX500_MUSB_NONE;
+		/* Fallback to default B_IDLE as nothing is connected */
+		ab->phy.state = OTG_STATE_B_IDLE;
+		break;
+
+	case USB_LINK_ACA_RID_C_NM_8500:
+	case USB_LINK_ACA_RID_C_HS_8500:
+	case USB_LINK_ACA_RID_C_HS_CHIRP_8500:
+		event = UX500_MUSB_RIDC;
+	case USB_LINK_STD_HOST_NC_8500:
+	case USB_LINK_STD_HOST_C_NS_8500:
+	case USB_LINK_STD_HOST_C_S_8500:
+	case USB_LINK_HOST_CHG_NM_8500:
+	case USB_LINK_HOST_CHG_HS_8500:
+	case USB_LINK_HOST_CHG_HS_CHIRP_8500:
+		if (ab->mode == USB_IDLE) {
+			ab->mode = USB_PERIPHERAL;
+			ab8500_usb_peri_phy_en(ab);
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					UX500_MUSB_PREPARE, &ab->vbus_draw);
+		}
+		if (event != UX500_MUSB_RIDC)
+			event = UX500_MUSB_VBUS;
+		break;
+
+	case USB_LINK_ACA_RID_A_8500:
+		event = UX500_MUSB_RIDA;
+	case USB_LINK_HM_IDGND_8500:
+		if (ab->mode == USB_IDLE) {
+			ab->mode = USB_HOST;
+			ab8500_usb_host_phy_en(ab);
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					UX500_MUSB_PREPARE, &ab->vbus_draw);
+		}
+		ab->phy.otg->default_a = true;
+		if (event != UX500_MUSB_RIDA)
+			event = UX500_MUSB_ID;
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				event, &ab->vbus_draw);
+		break;
+
+	case USB_LINK_DEDICATED_CHG_8500:
+		ab->mode = USB_DEDICATED_CHG;
+		event = UX500_MUSB_CHARGER;
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				event, &ab->vbus_draw);
+		break;
+
+	case USB_LINK_RESERVED_8500:
+		break;
+	}
 
 	return 0;
 }
 
-static void ab8500_usb_delayed_work(struct work_struct *work)
+/*
+ * Connection Sequence:
+ *   1. Link Status Interrupt
+ *   2. Enable AB clock
+ *   3. Enable AB regulators
+ *   4. Enable USB phy
+ *   5. Reset the musb controller
+ *   6. Switch the ULPI GPIO pins to fucntion mode
+ *   7. Enable the musb Peripheral5 clock
+ *   8. Restore MUSB context
+ */
+static int abx500_usb_link_status_update(struct ab8500_usb *ab)
 {
-	struct ab8500_usb *ab = container_of(work, struct ab8500_usb,
-						dwork.work);
+	u8 reg;
+	int ret = 0;
+
+	if (is_ab8500(ab->ab8500)) {
+		enum ab8500_usb_link_status lsts;
+
+		abx500_get_register_interruptible(ab->dev,
+				AB8500_USB, AB8500_USB_LINE_STAT_REG, &reg);
+		lsts = (reg >> 3) & 0x0F;
+		ret = ab8500_usb_link_status_update(ab, lsts);
+	} else if (is_ab8505(ab->ab8500)) {
+		enum ab8505_usb_link_status lsts;
+
+		abx500_get_register_interruptible(ab->dev,
+				AB8500_USB, AB8505_USB_LINE_STAT_REG, &reg);
+		lsts = (reg >> 3) & 0x1F;
+		ret = ab8505_usb_link_status_update(ab, lsts);
+	}
+
+	return ret;
+}
+
+/*
+ * Disconnection Sequence:
+ *   1. Disconect Interrupt
+ *   2. Disable regulators
+ *   3. Disable AB clock
+ *   4. Disable the Phy
+ *   5. Link Status Interrupt
+ *   6. Disable Musb Clock
+ */
+static irqreturn_t ab8500_usb_disconnect_irq(int irq, void *data)
+{
+	struct ab8500_usb *ab = (struct ab8500_usb *) data;
+	enum usb_phy_events event = UX500_MUSB_NONE;
+
+	/* Link status will not be updated till phy is disabled. */
+	if (ab->mode == USB_HOST) {
+		ab->phy.otg->default_a = false;
+		ab->vbus_draw = 0;
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				event, &ab->vbus_draw);
+		ab8500_usb_host_phy_dis(ab);
+		ab->mode = USB_IDLE;
+	}
+
+	if (ab->mode == USB_PERIPHERAL) {
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				event, &ab->vbus_draw);
+		ab8500_usb_peri_phy_dis(ab);
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				UX500_MUSB_CLEAN, &ab->vbus_draw);
+		ab->mode = USB_IDLE;
+		ab->phy.otg->default_a = false;
+		ab->vbus_draw = 0;
+	}
+
+	if (is_ab8500_2p0(ab->ab8500)) {
+		if (ab->mode == USB_DEDICATED_CHG) {
+			ab8500_usb_wd_linkstatus(ab,
+					AB8500_BIT_PHY_CTRL_DEVICE_EN);
+			abx500_mask_and_set_register_interruptible(ab->dev,
+					AB8500_USB, AB8500_USB_PHY_CTRL_REG,
+					AB8500_BIT_PHY_CTRL_DEVICE_EN, 0);
+		}
+	}
 
-	ab8500_usb_link_status_update(ab);
+	return IRQ_HANDLED;
 }
 
-static irqreturn_t ab8500_usb_v20_irq(int irq, void *data)
+static irqreturn_t ab8500_usb_link_status_irq(int irq, void *data)
 {
 	struct ab8500_usb *ab = (struct ab8500_usb *) data;
 
-	ab8500_usb_link_status_update(ab);
+	abx500_usb_link_status_update(ab);
 
 	return IRQ_HANDLED;
 }
 
+static void ab8500_usb_delayed_work(struct work_struct *work)
+{
+	struct ab8500_usb *ab = container_of(work, struct ab8500_usb,
+						dwork.work);
+
+	abx500_usb_link_status_update(ab);
+}
+
 static void ab8500_usb_phy_disable_work(struct work_struct *work)
 {
 	struct ab8500_usb *ab = container_of(work, struct ab8500_usb,
@@ -250,7 +487,7 @@ static int ab8500_usb_set_power(struct usb_phy *phy, unsigned mA)
 
 	if (mA)
 		atomic_notifier_call_chain(&ab->phy.notifier,
-				USB_EVENT_ENUMERATED, ab->phy.otg->gadget);
+				UX500_MUSB_ENUMERATED, ab->phy.otg->gadget);
 	return 0;
 }
 
@@ -327,30 +564,48 @@ static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
-static void ab8500_usb_irq_free(struct ab8500_usb *ab)
-{
-	free_irq(ab->irq_num_link_status, ab);
-}
-
-static int ab8500_usb_v2_res_setup(struct platform_device *pdev,
-				struct ab8500_usb *ab)
+static int ab8500_usb_irq_setup(struct platform_device *pdev,
+		struct ab8500_usb *ab)
 {
 	int err;
+	int irq;
 
-	ab->irq_num_link_status = platform_get_irq_byname(pdev,
-						"USB_LINK_STATUS");
-	if (ab->irq_num_link_status < 0) {
+	irq = platform_get_irq_byname(pdev, "USB_LINK_STATUS");
+	if (irq < 0) {
 		dev_err(&pdev->dev, "Link status irq not found\n");
-		return ab->irq_num_link_status;
+		return irq;
+	}
+	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+			ab8500_usb_link_status_irq,
+			IRQF_NO_SUSPEND | IRQF_SHARED, "usb-link-status", ab);
+	if (err < 0) {
+		dev_err(ab->dev, "request_irq failed for link status irq\n");
+		return err;
 	}
 
-	err = request_threaded_irq(ab->irq_num_link_status, NULL,
-		ab8500_usb_v20_irq,
-		IRQF_NO_SUSPEND | IRQF_SHARED,
-		"usb-link-status", ab);
+	irq = platform_get_irq_byname(pdev, "ID_WAKEUP_F");
+	if (irq < 0) {
+		dev_err(&pdev->dev, "ID fall irq not found\n");
+		return irq;
+	}
+	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+			ab8500_usb_disconnect_irq,
+			IRQF_NO_SUSPEND | IRQF_SHARED, "usb-id-fall", ab);
 	if (err < 0) {
-		dev_err(ab->dev,
-			"request_irq failed for link status irq\n");
+		dev_err(ab->dev, "request_irq failed for ID fall irq\n");
+		return err;
+	}
+
+	irq = platform_get_irq_byname(pdev, "VBUS_DET_F");
+	if (irq < 0) {
+		dev_err(&pdev->dev, "VBUS fall irq not found\n");
+		return irq;
+	}
+	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+			ab8500_usb_disconnect_irq,
+			IRQF_NO_SUSPEND | IRQF_SHARED, "usb-vbus-fall", ab);
+	if (err < 0) {
+		dev_err(ab->dev, "request_irq failed for Vbus fall irq\n");
 		return err;
 	}
 
@@ -408,22 +663,23 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	/* all: Disable phy when called from set_host and set_peripheral */
 	INIT_WORK(&ab->phy_dis_work, ab8500_usb_phy_disable_work);
 
-	err = ab8500_usb_v2_res_setup(pdev, ab);
+	err = ab8500_usb_irq_setup(pdev, ab);
 	if (err < 0)
-		goto fail0;
+		goto fail;
 
 	err = usb_add_phy(&ab->phy, USB_PHY_TYPE_USB2);
 	if (err) {
 		dev_err(&pdev->dev, "Can't register transceiver\n");
-		goto fail1;
+		goto fail;
 	}
 
+	/* Needed to enable ID detection. */
+	ab8500_usb_wd_workaround(ab);
+
 	dev_info(&pdev->dev, "revision 0x%2x driver initialized\n", rev);
 
 	return 0;
-fail1:
-	ab8500_usb_irq_free(ab);
-fail0:
+fail:
 	kfree(otg);
 	kfree(ab);
 	return err;
@@ -433,8 +689,6 @@ static int ab8500_usb_remove(struct platform_device *pdev)
 {
 	struct ab8500_usb *ab = platform_get_drvdata(pdev);
 
-	ab8500_usb_irq_free(ab);
-
 	cancel_delayed_work_sync(&ab->dwork);
 
 	cancel_work_sync(&ab->phy_dis_work);
diff --git a/include/linux/usb/musb-ux500.h b/include/linux/usb/musb-ux500.h
new file mode 100644
index 0000000..1e2c713
--- /dev/null
+++ b/include/linux/usb/musb-ux500.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2013 ST-Ericsson AB
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MUSB_UX500_H__
+#define __MUSB_UX500_H__
+
+enum ux500_musb_vbus_id_status {
+	UX500_MUSB_NONE = 0,
+	UX500_MUSB_VBUS,
+	UX500_MUSB_ID,
+	UX500_MUSB_CHARGER,
+	UX500_MUSB_ENUMERATED,
+	UX500_MUSB_RIDA,
+	UX500_MUSB_RIDB,
+	UX500_MUSB_RIDC,
+	UX500_MUSB_PREPARE,
+	UX500_MUSB_CLEAN,
+};
+
+#endif	/* __MUSB_UX500_H__ */
-- 
1.8.1.3

