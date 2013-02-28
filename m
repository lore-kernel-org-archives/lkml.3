Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3B1Kjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:39:41 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37777 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3B1Kji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:39:38 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/5] usb: musb: ux500: add otg notifier support
Date: Thu, 28 Feb 2013 11:38:52 +0100
Message-Id: <1362047934-22337-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362047934-22337-1-git-send-email-fabio.baltieri@linaro.org>
References: <1362047934-22337-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add transceiver notifier event handling to the ux500 driver to set vbus
on specific transceiver events.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/musb/ux500.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 5b742ba..b20326bb 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -98,6 +98,36 @@ static void ux500_musb_set_vbus(struct musb *musb, int is_on)
 		musb_readb(musb->mregs, MUSB_DEVCTL));
 }
 
+static int musb_otg_notifications(struct notifier_block *nb,
+		unsigned long event, void *unused)
+{
+	struct musb *musb = container_of(nb, struct musb, nb);
+
+	dev_dbg(musb->controller, "musb_otg_notifications %ld %s\n",
+			event, otg_state_string(musb->xceiv->state));
+
+	switch (event) {
+	case USB_EVENT_ID:
+		dev_dbg(musb->controller, "ID GND\n");
+		ux500_musb_set_vbus(musb, 1);
+		break;
+	case USB_EVENT_VBUS:
+		dev_dbg(musb->controller, "VBUS Connect\n");
+		break;
+	case USB_EVENT_NONE:
+		dev_dbg(musb->controller, "VBUS Disconnect\n");
+		if (is_host_active(musb))
+			ux500_musb_set_vbus(musb, 0);
+		else
+			musb->xceiv->state = OTG_STATE_B_IDLE;
+		break;
+	default:
+		dev_dbg(musb->controller, "ID float\n");
+		return NOTIFY_DONE;
+	}
+	return NOTIFY_OK;
+}
+
 static irqreturn_t ux500_musb_interrupt(int irq, void *__hci)
 {
 	unsigned long   flags;
@@ -120,12 +150,21 @@ static irqreturn_t ux500_musb_interrupt(int irq, void *__hci)
 
 static int ux500_musb_init(struct musb *musb)
 {
+	int status;
+
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(musb->xceiv)) {
 		pr_err("HS USB OTG: no transceiver configured\n");
 		return -EPROBE_DEFER;
 	}
 
+	musb->nb.notifier_call = musb_otg_notifications;
+	status = usb_register_notifier(musb->xceiv, &musb->nb);
+	if (status < 0) {
+		dev_dbg(musb->controller, "notification register failed\n");
+		return status;
+	}
+
 	musb->isr = ux500_musb_interrupt;
 
 	return 0;
@@ -133,6 +172,8 @@ static int ux500_musb_init(struct musb *musb)
 
 static int ux500_musb_exit(struct musb *musb)
 {
+	usb_unregister_notifier(musb->xceiv, &musb->nb);
+
 	usb_put_phy(musb->xceiv);
 
 	return 0;
-- 
1.8.1.3

