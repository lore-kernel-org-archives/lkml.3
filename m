Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab3EOMFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:05:33 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:45358 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3EOMF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:05:28 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Avinash Kumar <avinash.kumar@stericsson.com>
Subject: [PATCH 09/10] usb: phy: ab8500-usb: add ab8540 support
Date: Wed, 15 May 2013 14:03:32 +0200
Message-Id: <1368619413-24647-10-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the ab8540 variant of the ab8500 family.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Avinash Kumar <avinash.kumar@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 297 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 294 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 4591698..869ca26 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -1,10 +1,11 @@
 /*
  * drivers/usb/otg/ab8500_usb.c
  *
- * USB transceiver driver for AB8500 chip
+ * USB transceiver driver for AB8500 family chips
  *
- * Copyright (C) 2010 ST-Ericsson AB
+ * Copyright (C) 2010-2013 ST-Ericsson AB
  * Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
+ * Avinash Kumar <avinash.kumar@stericsson.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -43,21 +44,33 @@
 /* Bank AB8500_USB */
 #define AB8500_USB_LINE_STAT_REG 0x80
 #define AB8505_USB_LINE_STAT_REG 0x94
+#define AB8540_USB_LINK_STAT_REG 0x94
+#define AB8540_USB_OTG_CTL_REG 0x87
 #define AB8500_USB_PHY_CTRL_REG 0x8A
+#define AB8540_VBUS_CTRL_REG 0x82
 
 /* Bank AB8500_DEVELOPMENT */
 #define AB8500_BANK12_ACCESS 0x00
 
 /* Bank AB8500_DEBUG */
+#define AB8540_DEBUG 0x32
 #define AB8500_USB_PHY_TUNE1 0x05
 #define AB8500_USB_PHY_TUNE2 0x06
 #define AB8500_USB_PHY_TUNE3 0x07
 
+/* Bank AB8500_INTERRUPT */
+#define AB8500_IT_SOURCE2_REG 0x01
+
 #define AB8500_BIT_OTG_STAT_ID (1 << 0)
 #define AB8500_BIT_PHY_CTRL_HOST_EN (1 << 0)
 #define AB8500_BIT_PHY_CTRL_DEVICE_EN (1 << 1)
 #define AB8500_BIT_WD_CTRL_ENABLE (1 << 0)
 #define AB8500_BIT_WD_CTRL_KICK (1 << 1)
+#define AB8500_BIT_SOURCE2_VBUSDET (1 << 7)
+#define AB8540_BIT_OTG_CTL_VBUS_VALID_ENA (1 << 0)
+#define AB8540_BIT_OTG_CTL_ID_HOST_ENA (1 << 1)
+#define AB8540_BIT_OTG_CTL_ID_DEV_ENA (1 << 5)
+#define AB8540_BIT_VBUS_CTRL_CHARG_DET_ENA (1 << 0)
 
 #define AB8500_WD_KICK_DELAY_US 100 /* usec */
 #define AB8500_WD_V11_DISABLE_DELAY_US 100 /* usec */
@@ -114,6 +127,37 @@ enum ab8505_usb_link_status {
 	USB_LINK_MOTOROLA_FACTORY_CBL_PHY_EN_8505,
 };
 
+enum ab8540_usb_link_status {
+	USB_LINK_NOT_CONFIGURED_8540 = 0,
+	USB_LINK_STD_HOST_NC_8540,
+	USB_LINK_STD_HOST_C_NS_8540,
+	USB_LINK_STD_HOST_C_S_8540,
+	USB_LINK_CDP_8540,
+	USB_LINK_RESERVED0_8540,
+	USB_LINK_RESERVED1_8540,
+	USB_LINK_DEDICATED_CHG_8540,
+	USB_LINK_ACA_RID_A_8540,
+	USB_LINK_ACA_RID_B_8540,
+	USB_LINK_ACA_RID_C_NM_8540,
+	USB_LINK_RESERVED2_8540,
+	USB_LINK_RESERVED3_8540,
+	USB_LINK_HM_IDGND_8540,
+	USB_LINK_CHARGERPORT_NOT_OK_8540,
+	USB_LINK_CHARGER_DM_HIGH_8540,
+	USB_LINK_PHYEN_NO_VBUS_NO_IDGND_8540,
+	USB_LINK_STD_UPSTREAM_NO_IDGNG_VBUS_8540,
+	USB_LINK_STD_UPSTREAM_8540,
+	USB_LINK_CHARGER_SE1_8540,
+	USB_LINK_CARKIT_CHGR_1_8540,
+	USB_LINK_CARKIT_CHGR_2_8540,
+	USB_LINK_ACA_DOCK_CHGR_8540,
+	USB_LINK_SAMSUNG_BOOT_CBL_PHY_EN_8540,
+	USB_LINK_SAMSUNG_BOOT_CBL_PHY_DISB_8540,
+	USB_LINK_SAMSUNG_UART_CBL_PHY_EN_8540,
+	USB_LINK_SAMSUNG_UART_CBL_PHY_DISB_8540,
+	USB_LINK_MOTOROLA_FACTORY_CBL_PHY_EN_8540
+};
+
 enum ab8500_usb_mode {
 	USB_IDLE = 0,
 	USB_PERIPHERAL,
@@ -131,6 +175,10 @@ enum ab8500_usb_mode {
 #define AB8500_USB_FLAG_USE_AB_IDDET		(1 << 3)
 /* Enable setting regulators voltage */
 #define AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE	(1 << 4)
+/* Enable the check_vbus_status workaround */
+#define AB8500_USB_FLAG_USE_CHECK_VBUS_STATUS	(1 << 5)
+/* Enable the vbus host workaround */
+#define AB8500_USB_FLAG_USE_VBUS_HOST_QUIRK	(1 << 6)
 
 struct ab8500_usb {
 	struct usb_phy phy;
@@ -138,6 +186,7 @@ struct ab8500_usb {
 	struct ab8500 *ab8500;
 	unsigned vbus_draw;
 	struct work_struct phy_dis_work;
+	struct work_struct vbus_event_work;
 	enum ab8500_usb_mode mode;
 	struct clk *sysclk;
 	struct regulator *v_ape;
@@ -147,6 +196,7 @@ struct ab8500_usb {
 	int previous_link_status_state;
 	struct pinctrl *pinctrl;
 	struct pinctrl_state *pins_sleep;
+	bool enabled_charging_detection;
 	unsigned int flags;
 };
 
@@ -275,6 +325,15 @@ static void ab8500_usb_phy_enable(struct ab8500_usb *ab, bool sel_host)
 	abx500_mask_and_set_register_interruptible(ab->dev,
 			AB8500_USB, AB8500_USB_PHY_CTRL_REG,
 			bit, bit);
+
+	if (ab->flags & AB8500_USB_FLAG_USE_VBUS_HOST_QUIRK) {
+		if (sel_host)
+			abx500_set_register_interruptible(ab->dev,
+					AB8500_USB, AB8540_USB_OTG_CTL_REG,
+					AB8540_BIT_OTG_CTL_VBUS_VALID_ENA |
+					AB8540_BIT_OTG_CTL_ID_HOST_ENA |
+					AB8540_BIT_OTG_CTL_ID_DEV_ENA);
+	}
 }
 
 static void ab8500_usb_phy_disable(struct ab8500_usb *ab, bool sel_host)
@@ -319,6 +378,128 @@ static void ab8500_usb_phy_disable(struct ab8500_usb *ab, bool sel_host)
 #define ab8500_usb_peri_phy_en(ab)	ab8500_usb_phy_enable(ab, false)
 #define ab8500_usb_peri_phy_dis(ab)	ab8500_usb_phy_disable(ab, false)
 
+static int ab8540_usb_link_status_update(struct ab8500_usb *ab,
+		enum ab8540_usb_link_status lsts)
+{
+	enum ux500_musb_vbus_id_status event = 0;
+
+	dev_dbg(ab->dev, "ab8540_usb_link_status_update %d\n", lsts);
+
+	if (ab->enabled_charging_detection) {
+		/* Disable USB Charger detection */
+		abx500_mask_and_set_register_interruptible(ab->dev,
+				AB8500_USB, AB8540_VBUS_CTRL_REG,
+				AB8540_BIT_VBUS_CTRL_CHARG_DET_ENA, 0x00);
+		ab->enabled_charging_detection = false;
+	}
+
+	/*
+	 * Spurious link_status interrupts are seen in case of a
+	 * disconnection of a device in IDGND and RIDA stage
+	 */
+	if (ab->previous_link_status_state == USB_LINK_HM_IDGND_8540 &&
+			(lsts == USB_LINK_STD_HOST_C_NS_8540 ||
+			 lsts == USB_LINK_STD_HOST_NC_8540))
+		return 0;
+
+	if (ab->previous_link_status_state == USB_LINK_ACA_RID_A_8540 &&
+			(lsts == USB_LINK_STD_HOST_NC_8540))
+		return 0;
+
+	ab->previous_link_status_state = lsts;
+
+	switch (lsts) {
+	case USB_LINK_ACA_RID_B_8540:
+		event = UX500_MUSB_RIDB;
+	case USB_LINK_NOT_CONFIGURED_8540:
+	case USB_LINK_RESERVED0_8540:
+	case USB_LINK_RESERVED1_8540:
+	case USB_LINK_RESERVED2_8540:
+	case USB_LINK_RESERVED3_8540:
+		ab->mode = USB_IDLE;
+		ab->phy.otg->default_a = false;
+		ab->vbus_draw = 0;
+		if (event != UX500_MUSB_RIDB)
+			event = UX500_MUSB_NONE;
+		/*
+		 * Fallback to default B_IDLE as nothing
+		 * is connected
+		 */
+		ab->phy.state = OTG_STATE_B_IDLE;
+		break;
+
+	case USB_LINK_ACA_RID_C_NM_8540:
+		event = UX500_MUSB_RIDC;
+	case USB_LINK_STD_HOST_NC_8540:
+	case USB_LINK_STD_HOST_C_NS_8540:
+	case USB_LINK_STD_HOST_C_S_8540:
+	case USB_LINK_CDP_8540:
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
+	case USB_LINK_ACA_RID_A_8540:
+	case USB_LINK_ACA_DOCK_CHGR_8540:
+		event = UX500_MUSB_RIDA;
+	case USB_LINK_HM_IDGND_8540:
+	case USB_LINK_STD_UPSTREAM_8540:
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
+	case USB_LINK_DEDICATED_CHG_8540:
+		ab->mode = USB_DEDICATED_CHG;
+		event = UX500_MUSB_CHARGER;
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				event, &ab->vbus_draw);
+		break;
+
+	case USB_LINK_PHYEN_NO_VBUS_NO_IDGND_8540:
+	case USB_LINK_STD_UPSTREAM_NO_IDGNG_VBUS_8540:
+		event = UX500_MUSB_NONE;
+		if (ab->mode == USB_HOST) {
+			ab->phy.otg->default_a = false;
+			ab->vbus_draw = 0;
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					event, &ab->vbus_draw);
+			ab8500_usb_host_phy_dis(ab);
+			ab->mode = USB_IDLE;
+		}
+		if (ab->mode == USB_PERIPHERAL) {
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					event, &ab->vbus_draw);
+			ab8500_usb_peri_phy_dis(ab);
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					UX500_MUSB_CLEAN, &ab->vbus_draw);
+			ab->mode = USB_IDLE;
+			ab->phy.otg->default_a = false;
+			ab->vbus_draw = 0;
+		}
+		break;
+
+	default:
+		event = UX500_MUSB_NONE;
+		break;
+	}
+
+	return 0;
+}
+
 static int ab8505_usb_link_status_update(struct ab8500_usb *ab,
 		enum ab8505_usb_link_status lsts)
 {
@@ -519,6 +700,13 @@ static int abx500_usb_link_status_update(struct ab8500_usb *ab)
 				AB8500_USB, AB8505_USB_LINE_STAT_REG, &reg);
 		lsts = (reg >> 3) & 0x1F;
 		ret = ab8505_usb_link_status_update(ab, lsts);
+	} else if (is_ab8540(ab->ab8500)) {
+		enum ab8540_usb_link_status lsts;
+
+		abx500_get_register_interruptible(ab->dev,
+				AB8500_USB, AB8540_USB_LINK_STAT_REG, &reg);
+		lsts = (reg >> 3) & 0xFF;
+		ret = ab8540_usb_link_status_update(ab, lsts);
 	}
 
 	return ret;
@@ -593,6 +781,69 @@ static void ab8500_usb_phy_disable_work(struct work_struct *work)
 		ab8500_usb_peri_phy_dis(ab);
 }
 
+/* Check if VBUS is set and linkstatus has not detected a cable. */
+static bool ab8500_usb_check_vbus_status(struct ab8500_usb *ab)
+{
+	u8 isource2;
+	u8 reg;
+	enum ab8540_usb_link_status lsts;
+
+	abx500_get_register_interruptible(ab->dev,
+			AB8500_INTERRUPT, AB8500_IT_SOURCE2_REG,
+			&isource2);
+
+	/* If Vbus is below 3.6V abort */
+	if (!(isource2 & AB8500_BIT_SOURCE2_VBUSDET))
+		return false;
+
+	abx500_get_register_interruptible(ab->dev,
+			AB8500_USB, AB8540_USB_LINK_STAT_REG,
+			&reg);
+
+	lsts = (reg >> 3) & 0xFF;
+
+	/* Check if linkstatus has detected a cable */
+	if (lsts)
+		return false;
+
+	return true;
+}
+
+/* re-trigger charger detection again with watchdog re-kick. */
+static void ab8500_usb_vbus_turn_on_event_work(struct work_struct *work)
+{
+	struct ab8500_usb *ab = container_of(work, struct ab8500_usb,
+			vbus_event_work);
+
+	if (ab->mode != USB_IDLE)
+		return;
+
+	abx500_set_register_interruptible(ab->dev,
+			AB8500_SYS_CTRL2_BLOCK, AB8500_MAIN_WD_CTRL_REG,
+			AB8500_BIT_WD_CTRL_ENABLE);
+
+	udelay(100);
+
+	abx500_set_register_interruptible(ab->dev,
+			AB8500_SYS_CTRL2_BLOCK, AB8500_MAIN_WD_CTRL_REG,
+			AB8500_BIT_WD_CTRL_ENABLE | AB8500_BIT_WD_CTRL_KICK);
+
+	udelay(100);
+
+	/* Disable Main watchdog */
+	abx500_set_register_interruptible(ab->dev,
+			AB8500_SYS_CTRL2_BLOCK, AB8500_MAIN_WD_CTRL_REG,
+			0x0);
+
+	/* Enable USB Charger detection */
+	abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_USB, AB8540_VBUS_CTRL_REG,
+			AB8540_BIT_VBUS_CTRL_CHARG_DET_ENA,
+			AB8540_BIT_VBUS_CTRL_CHARG_DET_ENA);
+
+	ab->enabled_charging_detection = true;
+}
+
 static unsigned ab8500_eyediagram_workaroud(struct ab8500_usb *ab, unsigned mA)
 {
 	/*
@@ -872,6 +1123,29 @@ static void ab8500_usb_set_ab8505_tuning_values(struct ab8500_usb *ab)
 				err);
 }
 
+static void ab8500_usb_set_ab8540_tuning_values(struct ab8500_usb *ab)
+{
+	int err;
+
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8540_DEBUG, AB8500_USB_PHY_TUNE1, 0xCC);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE1 register ret=%d\n",
+				err);
+
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8540_DEBUG, AB8500_USB_PHY_TUNE2, 0x60);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE2 register ret=%d\n",
+				err);
+
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8540_DEBUG, AB8500_USB_PHY_TUNE3, 0x90);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE3 regester ret=%d\n",
+				err);
+}
+
 static int ab8500_usb_probe(struct platform_device *pdev)
 {
 	struct ab8500_usb	*ab;
@@ -919,6 +1193,11 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 			AB8500_USB_FLAG_USE_ID_WAKEUP_IRQ |
 			AB8500_USB_FLAG_USE_VBUS_DET_IRQ |
 			AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE;
+	} else if (is_ab8540(ab->ab8500)) {
+		ab->flags |= AB8500_USB_FLAG_USE_LINK_STATUS_IRQ |
+			AB8500_USB_FLAG_USE_CHECK_VBUS_STATUS |
+			AB8500_USB_FLAG_USE_VBUS_HOST_QUIRK |
+			AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE;
 	}
 
 	/* Disable regulator voltage setting for AB8500 <= v2.0 */
@@ -932,6 +1211,8 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	/* all: Disable phy when called from set_host and set_peripheral */
 	INIT_WORK(&ab->phy_dis_work, ab8500_usb_phy_disable_work);
 
+	INIT_WORK(&ab->vbus_event_work, ab8500_usb_vbus_turn_on_event_work);
+
 	err = ab8500_usb_regulator_get(ab);
 	if (err)
 		return err;
@@ -958,6 +1239,9 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	else if (is_ab8505(ab->ab8500))
 		/* Phy tuning values for AB8505 */
 		ab8500_usb_set_ab8505_tuning_values(ab);
+	else if (is_ab8540(ab->ab8500))
+		/* Phy tuning values for AB8540 */
+		ab8500_usb_set_ab8540_tuning_values(ab);
 
 	/* Needed to enable ID detection. */
 	ab8500_usb_wd_workaround(ab);
@@ -968,6 +1252,11 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	 */
 	ab8500_usb_restart_phy(ab);
 
+	if (ab->flags & AB8500_USB_FLAG_USE_CHECK_VBUS_STATUS) {
+		if (ab8500_usb_check_vbus_status(ab))
+			schedule_work(&ab->vbus_event_work);
+	}
+
 	abx500_usb_link_status_update(ab);
 
 	dev_info(&pdev->dev, "revision 0x%2x driver initialized\n", rev);
@@ -980,6 +1269,7 @@ static int ab8500_usb_remove(struct platform_device *pdev)
 	struct ab8500_usb *ab = platform_get_drvdata(pdev);
 
 	cancel_work_sync(&ab->phy_dis_work);
+	cancel_work_sync(&ab->vbus_event_work);
 
 	usb_remove_phy(&ab->phy);
 
@@ -995,6 +1285,7 @@ static int ab8500_usb_remove(struct platform_device *pdev)
 
 static struct platform_device_id ab8500_usb_devtype[] = {
 	{ .name = "ab8500-usb", },
+	{ .name = "ab8540-usb", },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(platform, ab8500_usb_devtype);
@@ -1022,5 +1313,5 @@ static void __exit ab8500_usb_exit(void)
 module_exit(ab8500_usb_exit);
 
 MODULE_AUTHOR("ST-Ericsson AB");
-MODULE_DESCRIPTION("AB8500 usb transceiver driver");
+MODULE_DESCRIPTION("AB8500 family usb transceiver driver");
 MODULE_LICENSE("GPL");
-- 
1.8.2

