Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaK1Nxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:53:31 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:47558 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaK1NvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:20 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/17] net2280: Merge abort_dma for 228x and 338x
Date: Fri, 28 Nov 2014 14:50:55 +0100
Message-Id: <1417182662-7405-11-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use the same function for both families of chips and also remove
the ep_stop_dma() function.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 5ba5132..46b66b3 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -836,12 +836,6 @@ static inline void resume_dma(struct net2280_ep *ep)
 	writel(readl(&ep->dma->dmactl) | BIT(DMA_ENABLE), &ep->dma->dmactl);
 }
 
-static inline void ep_stop_dma(struct net2280_ep *ep)
-{
-	writel(readl(&ep->dma->dmactl) & ~BIT(DMA_ENABLE), &ep->dma->dmactl);
-	spin_stop_dma(ep->dma);
-}
-
 static inline void
 queue_dma(struct net2280_ep *ep, struct net2280_request *req, int valid)
 {
@@ -1115,7 +1109,7 @@ static void restart_dma(struct net2280_ep *ep)
 	start_dma(ep, req);
 }
 
-static void abort_dma_228x(struct net2280_ep *ep)
+static void abort_dma(struct net2280_ep *ep)
 {
 	/* abort the current transfer */
 	if (likely(!list_empty(&ep->queue))) {
@@ -1127,19 +1121,6 @@ static void abort_dma_228x(struct net2280_ep *ep)
 	scan_dma_completions(ep);
 }
 
-static void abort_dma_338x(struct net2280_ep *ep)
-{
-	writel(BIT(DMA_ABORT), &ep->dma->dmastat);
-	spin_stop_dma(ep->dma);
-}
-
-static void abort_dma(struct net2280_ep *ep)
-{
-	if (ep->dev->quirks & PLX_LEGACY)
-		return abort_dma_228x(ep);
-	return abort_dma_338x(ep);
-}
-
 /* dequeue ALL requests */
 static void nuke(struct net2280_ep *ep)
 {
@@ -2813,7 +2794,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 				ep->dev->protocol_stall = 1;
 			else {
 				if (ep->dma)
-					ep_stop_dma(ep);
+					abort_dma(ep);
 				set_halt(ep);
 			}
 			allow_status_338x(ep);
-- 
2.1.3

