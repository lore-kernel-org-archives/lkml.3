Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab3EOMFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:05:43 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57804 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3EOMFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:05:37 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Avinash Kumar <avinash.kumar@stericsson.com>,
        Thirupathi Chippakurthy <thirupathi.chippakurthy@stericsson.com>
Subject: [PATCH 10/10] usb: phy: ab8500-usb: add ab9540 support
Date: Wed, 15 May 2013 14:03:33 +0200
Message-Id: <1368619413-24647-11-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the ab9540 variant of the ab8500 family.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Avinash Kumar <avinash.kumar@stericsson.com>
Cc: Thirupathi Chippakurthy <thirupathi.chippakurthy@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 213 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 213 insertions(+)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 869ca26..7fd19bb 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2010-2013 ST-Ericsson AB
  * Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
  * Avinash Kumar <avinash.kumar@stericsson.com>
+ * Thirupathi Chippakurthy <thirupathi.chippakurthy@stericsson.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -45,6 +46,7 @@
 #define AB8500_USB_LINE_STAT_REG 0x80
 #define AB8505_USB_LINE_STAT_REG 0x94
 #define AB8540_USB_LINK_STAT_REG 0x94
+#define AB9540_USB_LINK_STAT_REG 0x94
 #define AB8540_USB_OTG_CTL_REG 0x87
 #define AB8500_USB_PHY_CTRL_REG 0x8A
 #define AB8540_VBUS_CTRL_REG 0x82
@@ -158,6 +160,37 @@ enum ab8540_usb_link_status {
 	USB_LINK_MOTOROLA_FACTORY_CBL_PHY_EN_8540
 };
 
+enum ab9540_usb_link_status {
+	USB_LINK_NOT_CONFIGURED_9540 = 0,
+	USB_LINK_STD_HOST_NC_9540,
+	USB_LINK_STD_HOST_C_NS_9540,
+	USB_LINK_STD_HOST_C_S_9540,
+	USB_LINK_CDP_9540,
+	USB_LINK_RESERVED0_9540,
+	USB_LINK_RESERVED1_9540,
+	USB_LINK_DEDICATED_CHG_9540,
+	USB_LINK_ACA_RID_A_9540,
+	USB_LINK_ACA_RID_B_9540,
+	USB_LINK_ACA_RID_C_NM_9540,
+	USB_LINK_RESERVED2_9540,
+	USB_LINK_RESERVED3_9540,
+	USB_LINK_HM_IDGND_9540,
+	USB_LINK_CHARGERPORT_NOT_OK_9540,
+	USB_LINK_CHARGER_DM_HIGH_9540,
+	USB_LINK_PHYEN_NO_VBUS_NO_IDGND_9540,
+	USB_LINK_STD_UPSTREAM_NO_IDGNG_VBUS_9540,
+	USB_LINK_STD_UPSTREAM_9540,
+	USB_LINK_CHARGER_SE1_9540,
+	USB_LINK_CARKIT_CHGR_1_9540,
+	USB_LINK_CARKIT_CHGR_2_9540,
+	USB_LINK_ACA_DOCK_CHGR_9540,
+	USB_LINK_SAMSUNG_BOOT_CBL_PHY_EN_9540,
+	USB_LINK_SAMSUNG_BOOT_CBL_PHY_DISB_9540,
+	USB_LINK_SAMSUNG_UART_CBL_PHY_EN_9540,
+	USB_LINK_SAMSUNG_UART_CBL_PHY_DISB_9540,
+	USB_LINK_MOTOROLA_FACTORY_CBL_PHY_EN_9540
+};
+
 enum ab8500_usb_mode {
 	USB_IDLE = 0,
 	USB_PERIPHERAL,
@@ -378,6 +411,132 @@ static void ab8500_usb_phy_disable(struct ab8500_usb *ab, bool sel_host)
 #define ab8500_usb_peri_phy_en(ab)	ab8500_usb_phy_enable(ab, false)
 #define ab8500_usb_peri_phy_dis(ab)	ab8500_usb_phy_disable(ab, false)
 
+static int ab9540_usb_link_status_update(struct ab8500_usb *ab,
+		enum ab9540_usb_link_status lsts)
+{
+	enum ux500_musb_vbus_id_status event = 0;
+
+	dev_dbg(ab->dev, "ab9540_usb_link_status_update %d\n", lsts);
+
+	if (ab->previous_link_status_state == USB_LINK_HM_IDGND_9540 &&
+			(lsts == USB_LINK_STD_HOST_C_NS_9540 ||
+			 lsts == USB_LINK_STD_HOST_NC_9540))
+		return 0;
+
+	if (ab->previous_link_status_state == USB_LINK_ACA_RID_A_9540 &&
+			(lsts == USB_LINK_STD_HOST_NC_9540))
+		return 0;
+
+	ab->previous_link_status_state = lsts;
+
+	switch (lsts) {
+	case USB_LINK_ACA_RID_B_9540:
+		event = UX500_MUSB_RIDB;
+	case USB_LINK_NOT_CONFIGURED_9540:
+	case USB_LINK_RESERVED0_9540:
+	case USB_LINK_RESERVED1_9540:
+	case USB_LINK_RESERVED2_9540:
+	case USB_LINK_RESERVED3_9540:
+		if (ab->mode == USB_PERIPHERAL)
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					UX500_MUSB_CLEAN, &ab->vbus_draw);
+		ab->mode = USB_IDLE;
+		ab->phy.otg->default_a = false;
+		ab->vbus_draw = 0;
+		if (event != UX500_MUSB_RIDB)
+			event = UX500_MUSB_NONE;
+		/* Fallback to default B_IDLE as nothing is connected. */
+		ab->phy.state = OTG_STATE_B_IDLE;
+		break;
+
+	case USB_LINK_ACA_RID_C_NM_9540:
+		event = UX500_MUSB_RIDC;
+	case USB_LINK_STD_HOST_NC_9540:
+	case USB_LINK_STD_HOST_C_NS_9540:
+	case USB_LINK_STD_HOST_C_S_9540:
+	case USB_LINK_CDP_9540:
+		if (ab->mode == USB_HOST) {
+			ab->mode = USB_PERIPHERAL;
+			ab8500_usb_host_phy_dis(ab);
+			ab8500_usb_peri_phy_en(ab);
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					UX500_MUSB_PREPARE, &ab->vbus_draw);
+		}
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
+	case USB_LINK_ACA_RID_A_9540:
+		event = UX500_MUSB_RIDA;
+	case USB_LINK_HM_IDGND_9540:
+	case USB_LINK_STD_UPSTREAM_9540:
+		if (ab->mode == USB_PERIPHERAL) {
+			ab->mode = USB_HOST;
+			ab8500_usb_peri_phy_dis(ab);
+			ab8500_usb_host_phy_en(ab);
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					UX500_MUSB_PREPARE, &ab->vbus_draw);
+		}
+		if (ab->mode == USB_IDLE) {
+			ab->mode = USB_HOST;
+			ab8500_usb_host_phy_en(ab);
+			atomic_notifier_call_chain(&ab->phy.notifier,
+					UX500_MUSB_PREPARE, &ab->vbus_draw);
+		}
+		ab->phy.otg->default_a = true;
+		if (event != UX500_MUSB_RIDA)
+			event = UX500_MUSB_ID;
+
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				event, &ab->vbus_draw);
+		break;
+
+	case USB_LINK_DEDICATED_CHG_9540:
+		ab->mode = USB_DEDICATED_CHG;
+		event = UX500_MUSB_CHARGER;
+		atomic_notifier_call_chain(&ab->phy.notifier,
+				event, &ab->vbus_draw);
+		break;
+
+	case USB_LINK_PHYEN_NO_VBUS_NO_IDGND_9540:
+	case USB_LINK_STD_UPSTREAM_NO_IDGNG_VBUS_9540:
+		if (!(is_ab9540_2p0_or_earlier(ab->ab8500))) {
+			event = UX500_MUSB_NONE;
+			if (ab->mode == USB_HOST) {
+				ab->phy.otg->default_a = false;
+				ab->vbus_draw = 0;
+				atomic_notifier_call_chain(&ab->phy.notifier,
+						event, &ab->vbus_draw);
+				ab8500_usb_host_phy_dis(ab);
+				ab->mode = USB_IDLE;
+			}
+			if (ab->mode == USB_PERIPHERAL) {
+				atomic_notifier_call_chain(&ab->phy.notifier,
+						event, &ab->vbus_draw);
+				ab8500_usb_peri_phy_dis(ab);
+				atomic_notifier_call_chain(&ab->phy.notifier,
+						UX500_MUSB_CLEAN,
+						&ab->vbus_draw);
+				ab->mode = USB_IDLE;
+				ab->phy.otg->default_a = false;
+				ab->vbus_draw = 0;
+			}
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static int ab8540_usb_link_status_update(struct ab8500_usb *ab,
 		enum ab8540_usb_link_status lsts)
 {
@@ -707,6 +866,13 @@ static int abx500_usb_link_status_update(struct ab8500_usb *ab)
 				AB8500_USB, AB8540_USB_LINK_STAT_REG, &reg);
 		lsts = (reg >> 3) & 0xFF;
 		ret = ab8540_usb_link_status_update(ab, lsts);
+	} else if (is_ab9540(ab->ab8500)) {
+		enum ab9540_usb_link_status lsts;
+
+		abx500_get_register_interruptible(ab->dev,
+				AB8500_USB, AB9540_USB_LINK_STAT_REG, &reg);
+		lsts = (reg >> 3) & 0xFF;
+		ret = ab9540_usb_link_status_update(ab, lsts);
 	}
 
 	return ret;
@@ -1146,6 +1312,43 @@ static void ab8500_usb_set_ab8540_tuning_values(struct ab8500_usb *ab)
 				err);
 }
 
+static void ab8500_usb_set_ab9540_tuning_values(struct ab8500_usb *ab)
+{
+	int err;
+
+	/* Enable the PBT/Bank 0x12 access */
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS, 0x01);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to enable bank12 access err=%d\n",
+				err);
+
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEBUG, AB8500_USB_PHY_TUNE1, 0xC8);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE1 register err=%d\n",
+				err);
+
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEBUG, AB8500_USB_PHY_TUNE2, 0x60);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE2 register err=%d\n",
+				err);
+
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEBUG, AB8500_USB_PHY_TUNE3, 0x80);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE3 regester err=%d\n",
+				err);
+
+	/* Switch to normal mode/disable Bank 0x12 access */
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS, 0x00);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to switch bank12 access err=%d\n",
+				err);
+}
+
 static int ab8500_usb_probe(struct platform_device *pdev)
 {
 	struct ab8500_usb	*ab;
@@ -1198,6 +1401,12 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 			AB8500_USB_FLAG_USE_CHECK_VBUS_STATUS |
 			AB8500_USB_FLAG_USE_VBUS_HOST_QUIRK |
 			AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE;
+	} else if (is_ab9540(ab->ab8500)) {
+		ab->flags |= AB8500_USB_FLAG_USE_LINK_STATUS_IRQ |
+			AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE;
+		if (is_ab9540_2p0_or_earlier(ab->ab8500))
+			ab->flags |= AB8500_USB_FLAG_USE_ID_WAKEUP_IRQ |
+				AB8500_USB_FLAG_USE_VBUS_DET_IRQ;
 	}
 
 	/* Disable regulator voltage setting for AB8500 <= v2.0 */
@@ -1242,6 +1451,9 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	else if (is_ab8540(ab->ab8500))
 		/* Phy tuning values for AB8540 */
 		ab8500_usb_set_ab8540_tuning_values(ab);
+	else if (is_ab9540(ab->ab8500))
+		/* Phy tuning values for AB9540 */
+		ab8500_usb_set_ab9540_tuning_values(ab);
 
 	/* Needed to enable ID detection. */
 	ab8500_usb_wd_workaround(ab);
@@ -1286,6 +1498,7 @@ static int ab8500_usb_remove(struct platform_device *pdev)
 static struct platform_device_id ab8500_usb_devtype[] = {
 	{ .name = "ab8500-usb", },
 	{ .name = "ab8540-usb", },
+	{ .name = "ab9540-usb", },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(platform, ab8500_usb_devtype);
-- 
1.8.2

