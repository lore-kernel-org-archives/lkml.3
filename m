Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaDXLtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:49:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46346 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbaDXIwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 026/182] usb: musb: avoid NULL pointer dereference
Date: Thu, 24 Apr 2014 09:49:11 +0100
Message-Id: <1398329507-5911-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit eee3f15d5f1f4f0c283dd4db67dc1b874a2852d1 upstream.

instead of relying on the otg pointer, which
can be NULL in certain cases, we can use the
gadget and host pointers we already hold inside
struct musb.

Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/musb/musb_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index d3fcb9b..a09ba73 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -440,7 +440,6 @@ void musb_hnp_stop(struct musb *musb)
 static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				u8 devctl)
 {
-	struct usb_otg *otg = musb->xceiv->otg;
 	irqreturn_t handled = IRQ_NONE;
 
 	dev_dbg(musb->controller, "<== DevCtl=%02x, int_usb=0x%x\n", devctl,
@@ -655,7 +654,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				break;
 		case OTG_STATE_B_PERIPHERAL:
 			musb_g_suspend(musb);
-			musb->is_active = otg->gadget->b_hnp_enable;
+			musb->is_active = musb->g.b_hnp_enable;
 			if (musb->is_active) {
 				musb->xceiv->state = OTG_STATE_B_WAIT_ACON;
 				dev_dbg(musb->controller, "HNP: Setting timer for b_ase0_brst\n");
@@ -671,7 +670,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 			break;
 		case OTG_STATE_A_HOST:
 			musb->xceiv->state = OTG_STATE_A_SUSPEND;
-			musb->is_active = otg->host->b_hnp_enable;
+			musb->is_active = musb->hcd->self.b_hnp_enable;
 			break;
 		case OTG_STATE_B_HOST:
 			/* Transition to B_PERIPHERAL, see 6.8.2.6 p 44 */
-- 
1.9.1

