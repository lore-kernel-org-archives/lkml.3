Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaK1NvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:51:18 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:49338 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaK1NvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:14 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/17] net2280: Code cleanout remove ep_stdrsp function
Date: Fri, 28 Nov 2014 14:50:52 +0100
Message-Id: <1417182662-7405-8-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep_stdrsp was only called by handle_stat0_irqs_superspeed and with
always the same flags.

Remove the function and replace the call by the code inside the
function, since it is very simple once the dead code is removed.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 49 +++++++---------------------------------
 1 file changed, 8 insertions(+), 41 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index e8c36db..653a8a2 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -2668,46 +2668,6 @@ static void ep_stall(struct net2280_ep *ep, int stall)
 	}
 }
 
-static void ep_stdrsp(struct net2280_ep *ep, int value, int wedged)
-{
-	/* set/clear, then synch memory views with the device */
-	if (value) {
-		ep->stopped = 1;
-		if (ep->num == 0)
-			ep->dev->protocol_stall = 1;
-		else {
-			if (ep->dma)
-				ep_stop_dma(ep);
-			ep_stall(ep, true);
-		}
-
-		if (wedged)
-			ep->wedged = 1;
-	} else {
-		ep->stopped = 0;
-		ep->wedged = 0;
-
-		ep_stall(ep, false);
-
-		/* Flush the queue */
-		if (!list_empty(&ep->queue)) {
-			struct net2280_request *req =
-			    list_entry(ep->queue.next, struct net2280_request,
-				       queue);
-			if (ep->dma)
-				resume_dma(ep);
-			else {
-				if (ep->is_in)
-					write_fifo(ep, &req->req);
-				else {
-					if (read_fifo(ep, req))
-						done(ep, req, 0);
-				}
-			}
-		}
-	}
-}
-
 static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 		struct net2280_ep *ep, struct usb_ctrlrequest r)
 {
@@ -2864,7 +2824,14 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 			e = get_ep_by_addr(dev,	w_index);
 			if (!e || (w_value != USB_ENDPOINT_HALT))
 				goto do_stall3;
-			ep_stdrsp(e, true, false);
+			ep->stopped = 1;
+			if (ep->num == 0)
+				ep->dev->protocol_stall = 1;
+			else {
+				if (ep->dma)
+					ep_stop_dma(ep);
+				ep_stall(ep, true);
+			}
 			allow_status_338x(ep);
 			break;
 
-- 
2.1.3

