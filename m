Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaEDQCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:02:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaEDPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.10 72/86] usb: musb: avoid NULL pointer dereference
Date: Sun,  4 May 2014 11:41:47 -0400
Message-Id: <20140504154150.252593566@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit eee3f15d5f1f4f0c283dd4db67dc1b874a2852d1 upstream.

instead of relying on the otg pointer, which
can be NULL in certain cases, we can use the
gadget and host pointers we already hold inside
struct musb.

Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -440,7 +440,6 @@ void musb_hnp_stop(struct musb *musb)
 static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				u8 devctl)
 {
-	struct usb_otg *otg = musb->xceiv->otg;
 	irqreturn_t handled = IRQ_NONE;
 
 	dev_dbg(musb->controller, "<== DevCtl=%02x, int_usb=0x%x\n", devctl,
@@ -655,7 +654,7 @@ static irqreturn_t musb_stage0_irq(struc
 				break;
 		case OTG_STATE_B_PERIPHERAL:
 			musb_g_suspend(musb);
-			musb->is_active = otg->gadget->b_hnp_enable;
+			musb->is_active = musb->g.b_hnp_enable;
 			if (musb->is_active) {
 				musb->xceiv->state = OTG_STATE_B_WAIT_ACON;
 				dev_dbg(musb->controller, "HNP: Setting timer for b_ase0_brst\n");
@@ -671,7 +670,7 @@ static irqreturn_t musb_stage0_irq(struc
 			break;
 		case OTG_STATE_A_HOST:
 			musb->xceiv->state = OTG_STATE_A_SUSPEND;
-			musb->is_active = otg->host->b_hnp_enable;
+			musb->is_active = musb->hcd->self.b_hnp_enable;
 			break;
 		case OTG_STATE_B_HOST:
 			/* Transition to B_PERIPHERAL, see 6.8.2.6 p 44 */


