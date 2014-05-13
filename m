Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbaEMJib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:38:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60909 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760111AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 099/182] usb: musb: avoid NULL pointer dereference
Date: Tue, 13 May 2014 11:27:31 +0200
Message-Id: <0ec874bf187165bfba2611ccc2d97d1543b0925c.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit eee3f15d5f1f4f0c283dd4db67dc1b874a2852d1 upstream.

instead of relying on the otg pointer, which
can be NULL in certain cases, we can use the
gadget and host pointers we already hold inside
struct musb.

Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/musb/musb_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index f7dca0b92bfb..2cca870d9762 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -439,7 +439,6 @@ void musb_hnp_stop(struct musb *musb)
 static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				u8 devctl)
 {
-	struct usb_otg *otg = musb->xceiv->otg;
 	irqreturn_t handled = IRQ_NONE;
 
 	dev_dbg(musb->controller, "<== DevCtl=%02x, int_usb=0x%x\n", devctl,
@@ -654,7 +653,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				break;
 		case OTG_STATE_B_PERIPHERAL:
 			musb_g_suspend(musb);
-			musb->is_active = otg->gadget->b_hnp_enable;
+			musb->is_active = musb->g.b_hnp_enable;
 			if (musb->is_active) {
 				musb->xceiv->state = OTG_STATE_B_WAIT_ACON;
 				dev_dbg(musb->controller, "HNP: Setting timer for b_ase0_brst\n");
@@ -670,7 +669,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 			break;
 		case OTG_STATE_A_HOST:
 			musb->xceiv->state = OTG_STATE_A_SUSPEND;
-			musb->is_active = otg->host->b_hnp_enable;
+			musb->is_active = musb->hcd->self.b_hnp_enable;
 			break;
 		case OTG_STATE_B_HOST:
 			/* Transition to B_PERIPHERAL, see 6.8.2.6 p 44 */
-- 
1.9.3

