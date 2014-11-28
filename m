Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaK1NxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:53:12 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34452 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaK1NvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:20 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/17] net2280: Clean function net2280_queue
Date: Fri, 28 Nov 2014 14:50:56 +0100
Message-Id: <1417182662-7405-12-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not duplicate the code for the else branch of the condition.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 46b66b3..ade4693 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -937,24 +937,12 @@ net2280_queue(struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 	_req->actual = 0;
 
 	/* kickstart this i/o queue? */
-	if (list_empty(&ep->queue) && !ep->stopped) {
-		/* DMA request while EP halted */
-		if (ep->dma &&
-		    (readl(&ep->regs->ep_rsp) & BIT(CLEAR_ENDPOINT_HALT)) &&
-			(dev->quirks & PLX_SUPERSPEED)) {
-			int valid = 1;
-			if (ep->is_in) {
-				int expect;
-				expect = likely(req->req.zero ||
-						((req->req.length %
-						  ep->ep.maxpacket) != 0));
-				if (expect != ep->in_fifo_validate)
-					valid = 0;
-			}
-			queue_dma(ep, req, valid);
-		}
+	if  (list_empty(&ep->queue) && !ep->stopped &&
+		!((dev->quirks & PLX_SUPERSPEED) && ep->dma &&
+		  (readl(&ep->regs->ep_rsp) & BIT(CLEAR_ENDPOINT_HALT)))) {
+
 		/* use DMA if the endpoint supports it, else pio */
-		else if (ep->dma)
+		if (ep->dma)
 			start_dma(ep, req);
 		else {
 			/* maybe there's no control data, just status ack */
-- 
2.1.3

