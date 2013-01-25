Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161012Ab3AYDNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:13:07 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35885 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab3AYDMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:12:52 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <sameo@linux.intel.com>, <gg@slimlogic.co.uk>, <s-guiriec@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v1 6/8] usb: otg: palmas-usb: call regulator enable/disable only on valid regulator
Date: Fri, 25 Jan 2013 08:42:29 +0530
Message-ID: <1359083551-8524-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359083551-8524-1-git-send-email-kishon@ti.com>
References: <1359083551-8524-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The calls to regulator enable/disable was done unconditionally which
might result in warn dumps if *no_control_vbus* is set. So always call
regulator enable/disable on valid regulator.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/otg/palmas-usb.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/otg/palmas-usb.c b/drivers/usb/otg/palmas-usb.c
index 2377836..442f09c 100644
--- a/drivers/usb/otg/palmas-usb.c
+++ b/drivers/usb/otg/palmas-usb.c
@@ -119,11 +119,13 @@ static irqreturn_t palmas_vbus_wakeup_irq(int irq, void *_palmas_usb)
 	regmap_read(palmas_usb->palmas->regmap[slave], addr, &vbus_line_state);
 
 	if (vbus_line_state & PALMAS_INT3_LINE_STATE_VBUS) {
-		regulator_enable(palmas_usb->vbus_reg);
+		if (!IS_ERR_OR_NULL(palmas_usb->vbus_reg))
+			regulator_enable(palmas_usb->vbus_reg);
 		status = OMAP_DWC3_VBUS_VALID;
 	} else {
 		status = OMAP_DWC3_VBUS_OFF;
-		regulator_disable(palmas_usb->vbus_reg);
+		if (!IS_ERR_OR_NULL(palmas_usb->vbus_reg))
+			regulator_disable(palmas_usb->vbus_reg);
 	}
 
 	palmas_usb->linkstat = status;
@@ -144,7 +146,8 @@ static irqreturn_t palmas_id_wakeup_irq(int irq, void *_palmas_usb)
 	palmas_usb_read(palmas_usb->palmas, PALMAS_USB_ID_INT_LATCH_SET, &set);
 
 	if (set & PALMAS_USB_ID_INT_SRC_ID_GND) {
-		regulator_enable(palmas_usb->vbus_reg);
+		if (!IS_ERR_OR_NULL(palmas_usb->vbus_reg))
+			regulator_enable(palmas_usb->vbus_reg);
 		palmas_usb_write(palmas_usb->palmas,
 					PALMAS_USB_ID_INT_EN_HI_SET,
 					PALMAS_USB_ID_INT_EN_HI_SET_ID_FLOAT);
@@ -159,7 +162,8 @@ static irqreturn_t palmas_id_wakeup_irq(int irq, void *_palmas_usb)
 		palmas_usb_write(palmas_usb->palmas,
 					PALMAS_USB_ID_INT_EN_HI_CLR,
 					PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
-		regulator_disable(palmas_usb->vbus_reg);
+		if (!IS_ERR_OR_NULL(palmas_usb->vbus_reg))
+			regulator_disable(palmas_usb->vbus_reg);
 		status = OMAP_DWC3_ID_FLOAT;
 	}
 
@@ -191,6 +195,11 @@ static void palmas_set_vbus_work(struct work_struct *data)
 	struct palmas_usb *palmas_usb = container_of(data, struct palmas_usb,
 								set_vbus_work);
 
+	if (IS_ERR_OR_NULL(palmas_usb->vbus_reg)) {
+		dev_err(palmas_usb->dev, "invalid regulator\n");
+		return;
+	}
+
 	/*
 	 * Start driving VBUS. Set OPA_MODE bit in CHARGERUSB_CTRL1
 	 * register. This enables boost mode.
-- 
1.7.9.5

