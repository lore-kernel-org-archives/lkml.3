Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab3GVSNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:13:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:41814 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab3GVSKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:10:18 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
Date: Mon, 22 Jul 2013 20:09:57 +0200
Message-Id: <1374516607-2705-7-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the type struct from ti81xx_driver_data to
am33xx_driver_data since it is not used for ti81xx anymore. The EOI
member is also removed since the am33xx SoC does not have such register.
The interrupt is acknowledged by writting into the stat register.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_dsps.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 37ebcbc..2e45723 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -74,7 +74,6 @@ struct dsps_musb_wrapper {
 	u16	revision;
 	u16	control;
 	u16	status;
-	u16	eoi;
 	u16	epintr_set;
 	u16	epintr_clear;
 	u16	epintr_status;
@@ -160,7 +159,6 @@ static void dsps_musb_disable(struct musb *musb)
 	dsps_writel(reg_base, wrp->epintr_clear,
 			 wrp->txep_bitmap | wrp->rxep_bitmap);
 	dsps_writeb(musb->mregs, MUSB_DEVCTL, 0);
-	dsps_writel(reg_base, wrp->eoi, 0);
 }
 
 static void otg_timer(unsigned long _musb)
@@ -271,7 +269,7 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
 	/* Get usb core interrupts */
 	usbintr = dsps_readl(reg_base, wrp->coreintr_status);
 	if (!usbintr && !epintr)
-		goto eoi;
+		goto out;
 
 	musb->int_usb =	(usbintr & wrp->usb_bitmap) >> wrp->usb_shift;
 	if (usbintr)
@@ -339,15 +337,11 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
 	if (musb->int_tx || musb->int_rx || musb->int_usb)
 		ret |= musb_interrupt(musb);
 
- eoi:
-	/* EOI needs to be written for the IRQ to be re-asserted. */
-	if (ret == IRQ_HANDLED || epintr || usbintr)
-		dsps_writel(reg_base, wrp->eoi, 1);
-
 	/* Poll for ID change */
 	if (musb->xceiv->state == OTG_STATE_B_IDLE)
 		mod_timer(&glue->timer, jiffies + wrp->poll_seconds * HZ);
 
+out:
 	spin_unlock_irqrestore(&musb->lock, flags);
 
 	return ret;
@@ -395,9 +389,6 @@ static int dsps_musb_init(struct musb *musb)
 	val &= ~(1 << wrp->otg_disable);
 	dsps_writel(musb->ctrl_base, wrp->phy_utmi, val);
 
-	/* clear level interrupt */
-	dsps_writel(reg_base, wrp->eoi, 0);
-
 	return 0;
 }
 
@@ -579,11 +570,10 @@ static int dsps_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct dsps_musb_wrapper ti81xx_driver_data = {
+static const struct dsps_musb_wrapper am33xx_driver_data = {
 	.revision		= 0x00,
 	.control		= 0x14,
 	.status			= 0x18,
-	.eoi			= 0x24,
 	.epintr_set		= 0x38,
 	.epintr_clear		= 0x40,
 	.epintr_status		= 0x30,
@@ -610,7 +600,7 @@ static const struct dsps_musb_wrapper ti81xx_driver_data = {
 
 static const struct of_device_id musb_dsps_of_match[] = {
 	{ .compatible = "ti,musb-am33xx",
-		.data = (void *) &ti81xx_driver_data, },
+		.data = (void *) &am33xx_driver_data, },
 	{  },
 };
 MODULE_DEVICE_TABLE(of, musb_dsps_of_match);
-- 
1.8.3.2

