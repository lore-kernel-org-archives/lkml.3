Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaK1N42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:56:28 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:40543 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaK1NvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:09 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/17] net2280: Remove obsolete module param use_dma_chaining
Date: Fri, 28 Nov 2014 14:50:46 +0100
Message-Id: <1417182662-7405-2-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use_dma_chaining module parameter was designed to avoid creating one irq
per package on a group of packages (with the help of the driver's flag
no_interrupt).

Unfortunately, when this parameter is enabled, the driver fails to work
on both net2280 and 3380 chips.

This patch removes this parameter, which was disabled by default.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 147 ++++-----------------------------------
 1 file changed, 13 insertions(+), 134 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index d6411e0..08c16ee 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -12,11 +12,7 @@
  * the Mass Storage, Serial, and Ethernet/RNDIS gadget drivers
  * as well as Gadget Zero and Gadgetfs.
  *
- * DMA is enabled by default.  Drivers using transfer queues might use
- * DMA chaining to remove IRQ latencies between transfers.  (Except when
- * short OUT transfers happen.)  Drivers can use the req->no_interrupt
- * hint to completely eliminate some IRQs, if a later IRQ is guaranteed
- * and DMA chaining is enabled.
+ * DMA is enabled by default.
  *
  * MSI is enabled by default.  The legacy IRQ is used if MSI couldn't
  * be enabled.
@@ -85,7 +81,6 @@ static const char *const ep_name[] = {
 };
 
 /* use_dma -- general goodness, fewer interrupts, less cpu load (vs PIO)
- * use_dma_chaining -- dma descriptor queueing gives even more irq reduction
  *
  * The net2280 DMA engines are not tightly integrated with their FIFOs;
  * not all cases are (yet) handled well in this driver or the silicon.
@@ -93,12 +88,10 @@ static const char *const ep_name[] = {
  * These two parameters let you use PIO or more aggressive DMA.
  */
 static bool use_dma = true;
-static bool use_dma_chaining;
 static bool use_msi = true;
 
 /* "modprobe net2280 use_dma=n" etc */
 module_param(use_dma, bool, 0444);
-module_param(use_dma_chaining, bool, 0444);
 module_param(use_msi, bool, 0444);
 
 /* mode 0 == ep-{a,b,c,d} 1K fifo each
@@ -202,15 +195,6 @@ net2280_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	/* set speed-dependent max packet; may kick in high bandwidth */
 	set_max_speed(ep, max);
 
-	/* FIFO lines can't go to different packets.  PIO is ok, so
-	 * use it instead of troublesome (non-bulk) multi-packet DMA.
-	 */
-	if (ep->dma && (max % 4) != 0 && use_dma_chaining) {
-		ep_dbg(ep->dev, "%s, no dma for maxpacket %d\n",
-			ep->ep.name, ep->ep.maxpacket);
-		ep->dma = NULL;
-	}
-
 	/* set type, direction, address; reset fifo counters */
 	writel(BIT(FIFO_FLUSH), &ep->regs->ep_stat);
 	tmp = (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK);
@@ -747,8 +731,7 @@ static void fill_dma_desc(struct net2280_ep *ep,
 	req->valid = valid;
 	if (valid)
 		dmacount |= BIT(VALID_BIT);
-	if (likely(!req->req.no_interrupt || !use_dma_chaining))
-		dmacount |= BIT(DMA_DONE_INTERRUPT_ENABLE);
+	dmacount |= BIT(DMA_DONE_INTERRUPT_ENABLE);
 
 	/* td->dmadesc = previously set by caller */
 	td->dmaaddr = cpu_to_le32 (req->req.dma);
@@ -862,8 +845,7 @@ static void start_dma(struct net2280_ep *ep, struct net2280_request *req)
 	req->td->dmadesc = cpu_to_le32 (ep->td_dma);
 	fill_dma_desc(ep, req, 1);
 
-	if (!use_dma_chaining)
-		req->td->dmacount |= cpu_to_le32(BIT(END_OF_CHAIN));
+	req->td->dmacount |= cpu_to_le32(BIT(END_OF_CHAIN));
 
 	start_queue(ep, tmp, req->td_dma);
 }
@@ -1150,64 +1132,12 @@ static void scan_dma_completions(struct net2280_ep *ep)
 static void restart_dma(struct net2280_ep *ep)
 {
 	struct net2280_request	*req;
-	u32			dmactl = dmactl_default;
 
 	if (ep->stopped)
 		return;
 	req = list_entry(ep->queue.next, struct net2280_request, queue);
 
-	if (!use_dma_chaining) {
-		start_dma(ep, req);
-		return;
-	}
-
-	/* the 2280 will be processing the queue unless queue hiccups after
-	 * the previous transfer:
-	 *  IN:   wanted automagic zlp, head doesn't (or vice versa)
-	 *        DMA_FIFO_VALIDATE doesn't init from dma descriptors.
-	 *  OUT:  was "usb-short", we must restart.
-	 */
-	if (ep->is_in && !req->valid) {
-		struct net2280_request	*entry, *prev = NULL;
-		int			reqmode, done = 0;
-
-		ep_dbg(ep->dev, "%s dma hiccup td %p\n", ep->ep.name, req->td);
-		ep->in_fifo_validate = likely(req->req.zero ||
-				(req->req.length % ep->ep.maxpacket) != 0);
-		if (ep->in_fifo_validate)
-			dmactl |= BIT(DMA_FIFO_VALIDATE);
-		list_for_each_entry(entry, &ep->queue, queue) {
-			__le32		dmacount;
-
-			if (entry == req)
-				continue;
-			dmacount = entry->td->dmacount;
-			if (!done) {
-				reqmode = likely(entry->req.zero ||
-				   (entry->req.length % ep->ep.maxpacket));
-				if (reqmode == ep->in_fifo_validate) {
-					entry->valid = 1;
-					dmacount |= valid_bit;
-					entry->td->dmacount = dmacount;
-					prev = entry;
-					continue;
-				} else {
-					/* force a hiccup */
-					prev->td->dmacount |= dma_done_ie;
-					done = 1;
-				}
-			}
-
-			/* walk the rest of the queue so unlinks behave */
-			entry->valid = 0;
-			dmacount &= ~valid_bit;
-			entry->td->dmacount = dmacount;
-			prev = entry;
-		}
-	}
-
-	writel(0, &ep->dma->dmactl);
-	start_queue(ep, dmactl, req->td_dma);
+	start_dma(ep, req);
 }
 
 static void abort_dma_228x(struct net2280_ep *ep)
@@ -1306,25 +1236,6 @@ static int net2280_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 			done(ep, req, -ECONNRESET);
 		}
 		req = NULL;
-
-	/* patch up hardware chaining data */
-	} else if (ep->dma && use_dma_chaining) {
-		if (req->queue.prev == ep->queue.next) {
-			writel(le32_to_cpu(req->td->dmadesc),
-				&ep->dma->dmadesc);
-			if (req->td->dmacount & dma_done_ie)
-				writel(readl(&ep->dma->dmacount) |
-						le32_to_cpu(dma_done_ie),
-					&ep->dma->dmacount);
-		} else {
-			struct net2280_request	*prev;
-
-			prev = list_entry(req->queue.prev,
-				struct net2280_request, queue);
-			prev->td->dmadesc = req->td->dmadesc;
-			if (req->td->dmacount & dma_done_ie)
-				prev->td->dmacount |= dma_done_ie;
-		}
 	}
 
 	if (req)
@@ -1609,9 +1520,7 @@ static ssize_t registers_show(struct device *_dev,
 			"pci irqenb0 %02x irqenb1 %08x "
 			"irqstat0 %04x irqstat1 %08x\n",
 			driver_name, dev->chiprev,
-			use_dma
-				? (use_dma_chaining ? "chaining" : "enabled")
-				: "disabled",
+			use_dma ? "enabled" : "disabled",
 			readl(&dev->regs->devinit),
 			readl(&dev->regs->fifoctl),
 			s,
@@ -3423,17 +3332,12 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 				continue;
 		}
 
-		/* chaining should stop on abort, short OUT from fifo,
-		 * or (stat0 codepath) short OUT transfer.
-		 */
-		if (!use_dma_chaining) {
-			if (!(tmp & BIT(DMA_TRANSACTION_DONE_INTERRUPT))) {
-				ep_dbg(ep->dev, "%s no xact done? %08x\n",
-					ep->ep.name, tmp);
-				continue;
-			}
-			stop_dma(ep->dma);
+		if (!(tmp & BIT(DMA_TRANSACTION_DONE_INTERRUPT))) {
+			ep_dbg(ep->dev, "%s no xact done? %08x\n",
+				ep->ep.name, tmp);
+			continue;
 		}
+		stop_dma(ep->dma);
 
 		/* OUT transfers terminate when the data from the
 		 * host is in our memory.  Process whatever's done.
@@ -3448,30 +3352,9 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 		scan_dma_completions(ep);
 
 		/* disable dma on inactive queues; else maybe restart */
-		if (list_empty(&ep->queue)) {
-			if (use_dma_chaining)
-				stop_dma(ep->dma);
-		} else {
+		if (!list_empty(&ep->queue)) {
 			tmp = readl(&dma->dmactl);
-			if (!use_dma_chaining || (tmp & BIT(DMA_ENABLE)) == 0)
-				restart_dma(ep);
-			else if (ep->is_in && use_dma_chaining) {
-				struct net2280_request	*req;
-				__le32			dmacount;
-
-				/* the descriptor at the head of the chain
-				 * may still have VALID_BIT clear; that's
-				 * used to trigger changing DMA_FIFO_VALIDATE
-				 * (affects automagic zlp writes).
-				 */
-				req = list_entry(ep->queue.next,
-						struct net2280_request, queue);
-				dmacount = req->td->dmacount;
-				dmacount &= cpu_to_le32(BIT(VALID_BIT) |
-						DMA_BYTE_COUNT_MASK);
-				if (dmacount && (dmacount & valid_bit) == 0)
-					restart_dma(ep);
-			}
+			restart_dma(ep);
 		}
 		ep->irqs++;
 	}
@@ -3581,9 +3464,6 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	void			__iomem *base = NULL;
 	int			retval, i;
 
-	if (!use_dma)
-		use_dma_chaining = 0;
-
 	/* alloc, and start init */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
@@ -3742,8 +3622,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ep_info(dev, "irq %d, pci mem %p, chip rev %04x\n",
 			pdev->irq, base, dev->chiprev);
 	ep_info(dev, "version: " DRIVER_VERSION "; dma %s %s\n",
-		use_dma	? (use_dma_chaining ? "chaining" : "enabled")
-			: "disabled",
+		use_dma	? "enabled" : "disabled",
 		dev->enhanced_mode ? "enhanced mode" : "legacy mode");
 	retval = device_create_file(&pdev->dev, &dev_attr_registers);
 	if (retval)
-- 
2.1.3

