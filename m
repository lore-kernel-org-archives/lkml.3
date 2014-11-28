Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaK1NyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:54:07 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:61033 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaK1NvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:17 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/17] net2280: Remove function ep_stall
Date: Fri, 28 Nov 2014 14:50:54 +0100
Message-Id: <1417182662-7405-10-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irqs_superspeed calls ep_stall instead of set/clear_halt, due to a
workaround for SS seqnum. Create a function with the workaround and
call set/clear_halt instead.

This way we can compare the code of super/normal speed and it is easier
to follow the code.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 44 ++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 48e8d82..5ba5132 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -2632,38 +2632,19 @@ restore_data_eps:
 	return;
 }
 
-static void ep_stall(struct net2280_ep *ep, int stall)
+static void ep_clear_seqnum(struct net2280_ep *ep)
 {
 	struct net2280 *dev = ep->dev;
 	u32 val;
 	static const u32 ep_pl[9] = { 0, 3, 4, 7, 8, 2, 5, 6, 9 };
 
-	if (stall) {
-		writel(BIT(SET_ENDPOINT_HALT) |
-		       /* BIT(SET_NAK_PACKETS) | */
-		       BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE),
-		       &ep->regs->ep_rsp);
-	} else {
-		if (dev->gadget.speed == USB_SPEED_SUPER) {
-			/*
-			 * Workaround for SS SeqNum not cleared via
-			 * Endpoint Halt (Clear) bit. select endpoint
-			 */
-			val = readl(&dev->plregs->pl_ep_ctrl);
-			val = (val & ~0x1f) | ep_pl[ep->num];
-			writel(val, &dev->plregs->pl_ep_ctrl);
+	val = readl(&dev->plregs->pl_ep_ctrl) & ~0x1f;
+	val |= ep_pl[ep->num];
+	writel(val, &dev->plregs->pl_ep_ctrl);
+	val |= BIT(SEQUENCE_NUMBER_RESET);
+	writel(val, &dev->plregs->pl_ep_ctrl);
 
-			val |= BIT(SEQUENCE_NUMBER_RESET);
-			writel(val, &dev->plregs->pl_ep_ctrl);
-		}
-		val = readl(&ep->regs->ep_rsp);
-		val |= BIT(CLEAR_ENDPOINT_HALT) |
-			BIT(CLEAR_ENDPOINT_TOGGLE);
-		writel(val,
-		       /* | BIT(CLEAR_NAK_PACKETS),*/
-		       &ep->regs->ep_rsp);
-		val = readl(&ep->regs->ep_rsp);
-	}
+	return;
 }
 
 static void handle_stat0_irqs_superspeed(struct net2280 *dev,
@@ -2764,7 +2745,12 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 			if (w_value != USB_ENDPOINT_HALT)
 				goto do_stall3;
 			ep_vdbg(dev, "%s clear halt\n", e->ep.name);
-			ep_stall(e, false);
+			/*
+			 * Workaround for SS SeqNum not cleared via
+			 * Endpoint Halt (Clear) bit. select endpoint
+			 */
+			ep_clear_seqnum(e);
+			clear_halt(e);
 			if (!list_empty(&e->queue) && e->td_dma)
 				restart_dma(e);
 			allow_status(ep);
@@ -2828,7 +2814,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 			else {
 				if (ep->dma)
 					ep_stop_dma(ep);
-				ep_stall(ep, true);
+				set_halt(ep);
 			}
 			allow_status_338x(ep);
 			break;
@@ -2857,7 +2843,7 @@ do_stall3:
 				r.bRequestType, r.bRequest, tmp);
 		dev->protocol_stall = 1;
 		/* TD 9.9 Halt Endpoint test. TD 9.22 Set feature test */
-		ep_stall(ep, true);
+		set_halt(ep);
 	}
 
 next_endpoints3:
-- 
2.1.3

