Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaK1Nwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:52:34 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:37792 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaK1NvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:24 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/17] net2280: Simplify scan_dma_completions
Date: Fri, 28 Nov 2014 14:51:00 +0100
Message-Id: <1417182662-7405-16-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After fix superspeed dma_done was applied we can simplify the code by
removing the duplicated dma_done and letting the function check if there
are more completed dma transactions.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index cc76181..a978e6e 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -1051,9 +1051,8 @@ static void scan_dma_completions(struct net2280_ep *ep)
 			dma_done(ep, req, tmp, 0);
 			break;
 		} else if (!ep->is_in &&
-				(req->req.length % ep->ep.maxpacket) != 0) {
-			if (ep->dev->quirks & PLX_SUPERSPEED)
-				return dma_done(ep, req, tmp, 0);
+			   (req->req.length % ep->ep.maxpacket) &&
+			   !(ep->dev->quirks & PLX_SUPERSPEED)) {
 
 			tmp = readl(&ep->regs->ep_stat);
 			/* AVOID TROUBLE HERE by not issuing short reads from
-- 
2.1.3

