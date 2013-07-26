Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab3GZJMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:12:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:35354 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993Ab3GZJMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:12:13 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Bin Liu <binmlist@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 06/16 => 2/2] usb: musb: dsps: remove EOI access
Date: Fri, 26 Jul 2013 11:11:38 +0200
Message-Id: <1374829898-3635-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374829898-3635-1-git-send-email-bigeasy@linutronix.de>
References: <20130725161120.GC31835@radagast>
 <1374829898-3635-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EOI register is not present in the AM335x memory space according to
the TRM and thus removed.
Should any platform using the EOI register get merged then it may be
used again if the register address is not zero.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_dsps.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 28ed497..36634e9 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -73,7 +73,6 @@ struct dsps_musb_wrapper {
 	u16	revision;
 	u16	control;
 	u16	status;
-	u16	eoi;
 	u16	epintr_set;
 	u16	epintr_clear;
 	u16	epintr_status;
@@ -202,7 +201,6 @@ static void dsps_musb_disable(struct musb *musb)
 	dsps_writel(reg_base, wrp->epintr_clear,
 			 wrp->txep_bitmap | wrp->rxep_bitmap);
 	dsps_writeb(musb->mregs, MUSB_DEVCTL, 0);
-	dsps_writel(reg_base, wrp->eoi, 0);
 }
 
 static void otg_timer(unsigned long _musb)
@@ -316,7 +314,7 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
 	/* Get usb core interrupts */
 	usbintr = dsps_readl(reg_base, wrp->coreintr_status);
 	if (!usbintr && !epintr)
-		goto eoi;
+		goto out;
 
 	musb->int_usb =	(usbintr & wrp->usb_bitmap) >> wrp->usb_shift;
 	if (usbintr)
@@ -384,16 +382,11 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
 	if (musb->int_tx || musb->int_rx || musb->int_usb)
 		ret |= musb_interrupt(musb);
 
- eoi:
-	/* EOI needs to be written for the IRQ to be re-asserted. */
-	if (ret == IRQ_HANDLED || epintr || usbintr)
-		dsps_writel(reg_base, wrp->eoi, 1);
-
 	/* Poll for ID change */
 	if (musb->xceiv->state == OTG_STATE_B_IDLE)
 		mod_timer(&glue->timer[pdev->id],
 			 jiffies + wrp->poll_seconds * HZ);
-
+out:
 	spin_unlock_irqrestore(&musb->lock, flags);
 
 	return ret;
@@ -447,9 +440,6 @@ static int dsps_musb_init(struct musb *musb)
 	val &= ~(1 << wrp->otg_disable);
 	dsps_writel(musb->ctrl_base, wrp->phy_utmi, val);
 
-	/* clear level interrupt */
-	dsps_writel(reg_base, wrp->eoi, 0);
-
 	return 0;
 err0:
 	usb_put_phy(musb->xceiv);
@@ -746,7 +736,6 @@ static const struct dsps_musb_wrapper am33xx_driver_data = {
 	.revision		= 0x00,
 	.control		= 0x14,
 	.status			= 0x18,
-	.eoi			= 0x24,
 	.epintr_set		= 0x38,
 	.epintr_clear		= 0x40,
 	.epintr_status		= 0x30,
-- 
1.8.3.2

