Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaESVVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:21:08 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44504 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaESVVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:21:01 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 7/9 v2] usb: gadget: net2280: Pass checkpacth.pl test
Date: Mon, 19 May 2014 23:20:34 +0200
Message-Id: <1400534436-10913-8-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400534436-10913-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400534436-10913-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix Code Style using checkpatch.pl criteria

v2: Comments by Alan Stern
	-Remove unneeded !!
	-Fix typos on comment

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 1132 +++++++++++++++++++++---------------------
 drivers/usb/gadget/net2280.h |   92 ++--
 2 files changed, 609 insertions(+), 615 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index c3205ec..f993372 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -62,9 +62,9 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 #include <linux/prefetch.h>
+#include <linux/io.h>
 
 #include <asm/byteorder.h>
-#include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/unaligned.h>
 
@@ -76,12 +76,12 @@
 #define USE_RDK_LEDS		/* GPIO pins control three LEDs */
 
 
-static const char driver_name [] = "net2280";
-static const char driver_desc [] = DRIVER_DESC;
+static const char driver_name[] = "net2280";
+static const char driver_desc[] = DRIVER_DESC;
 
 static const u32 ep_bit[9] = { 0, 17, 2, 19, 4, 1, 18, 3, 20 };
-static const char ep0name [] = "ep0";
-static const char *const ep_name [] = {
+static const char ep0name[] = "ep0";
+static const char *const ep_name[] = {
 	ep0name,
 	"ep-a", "ep-b", "ep-c", "ep-d",
 	"ep-e", "ep-f", "ep-g", "ep-h",
@@ -100,15 +100,15 @@ static bool use_dma_chaining;
 static bool use_msi = true;
 
 /* "modprobe net2280 use_dma=n" etc */
-module_param (use_dma, bool, S_IRUGO);
-module_param (use_dma_chaining, bool, S_IRUGO);
+module_param(use_dma, bool, S_IRUGO);
+module_param(use_dma_chaining, bool, S_IRUGO);
 module_param(use_msi, bool, S_IRUGO);
 
 /* mode 0 == ep-{a,b,c,d} 1K fifo each
  * mode 1 == ep-{a,b} 2K fifo each, ep-{c,d} unavailable
  * mode 2 == ep-a 2K fifo, ep-{b,c} 1K each, ep-d unavailable
  */
-static ushort fifo_mode = 0;
+static ushort fifo_mode;
 
 /* "modprobe net2280 fifo_mode=1" etc */
 module_param (fifo_mode, ushort, 0644);
@@ -121,7 +121,7 @@ module_param (fifo_mode, ushort, 0644);
 static bool enable_suspend;
 
 /* "modprobe net2280 enable_suspend=1" etc */
-module_param (enable_suspend, bool, S_IRUGO);
+module_param(enable_suspend, bool, S_IRUGO);
 
 /* force full-speed operation */
 static bool full_speed;
@@ -130,8 +130,7 @@ MODULE_PARM_DESC(full_speed, "force full-speed mode -- for testing only!");
 
 #define	DIR_STRING(bAddress) (((bAddress) & USB_DIR_IN) ? "in" : "out")
 
-#if defined(CONFIG_USB_GADGET_DEBUG_FILES) || defined (DEBUG)
-static char *type_string (u8 bmAttributes)
+static char *type_string(u8 bmAttributes)
 {
 	switch ((bmAttributes) & USB_ENDPOINT_XFERTYPE_MASK) {
 	case USB_ENDPOINT_XFER_BULK:	return "bulk";
@@ -140,7 +139,6 @@ static char *type_string (u8 bmAttributes)
 	}
 	return "control";
 }
-#endif
 
 #include "net2280.h"
 
@@ -161,8 +159,8 @@ static inline void enable_pciirqenb(struct net2280_ep *ep)
 	return;
 }
 
-static int
-net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
+static int net2280_enable(struct usb_ep *_ep,
+		const struct usb_endpoint_descriptor *desc)
 {
 	struct net2280		*dev;
 	struct net2280_ep	*ep;
@@ -170,7 +168,7 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	unsigned long		flags;
 	static const u32 ep_key[9] = { 1, 0, 1, 0, 1, 1, 0, 1, 0 };
 
-	ep = container_of (_ep, struct net2280_ep, ep);
+	ep = container_of(_ep, struct net2280_ep, ep);
 	if (!_ep || !desc || ep->desc || _ep->name == ep0name
 			|| desc->bDescriptorType != USB_DT_ENDPOINT)
 		return -EINVAL;
@@ -191,12 +189,12 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	}
 
 	/* sanity check ep-e/ep-f since their fifos are small */
-	max = usb_endpoint_maxp (desc) & 0x1fff;
+	max = usb_endpoint_maxp(desc) & 0x1fff;
 	if (ep->num > 4 && max > 64 &&
 			(dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY))
 		return -ERANGE;
 
-	spin_lock_irqsave (&dev->lock, flags);
+	spin_lock_irqsave(&dev->lock, flags);
 	_ep->maxpacket = max & 0x7ff;
 	ep->desc = desc;
 
@@ -212,7 +210,7 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	 * use it instead of troublesome (non-bulk) multi-packet DMA.
 	 */
 	if (ep->dma && (max % 4) != 0 && use_dma_chaining) {
-		DEBUG (ep->dev, "%s, no dma for maxpacket %d\n",
+		DEBUG(ep->dev, "%s, no dma for maxpacket %d\n",
 			ep->ep.name, ep->ep.maxpacket);
 		ep->dma = NULL;
 	}
@@ -236,7 +234,7 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			return -ERANGE;
 		}
 	}
-	ep->is_iso = (tmp == USB_ENDPOINT_XFER_ISOC) ? 1 : 0;
+	ep->is_iso = (tmp == USB_ENDPOINT_XFER_ISOC);
 	/* Enable this endpoint */
 	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY) {
 		tmp <<= ENDPOINT_TYPE;
@@ -285,12 +283,12 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 		tmp = BIT(DATA_PACKET_RECEIVED_INTERRUPT_ENABLE) |
 			BIT(DATA_PACKET_TRANSMITTED_INTERRUPT_ENABLE);
 		if (dev->pdev->device == 0x2280)
-			tmp |= readl (&ep->regs->ep_irqenb);
-		writel (tmp, &ep->regs->ep_irqenb);
+			tmp |= readl(&ep->regs->ep_irqenb);
+		writel(tmp, &ep->regs->ep_irqenb);
 	} else {				/* dma, per-request */
 		tmp = BIT((8 + ep->num));	/* completion */
-		tmp |= readl (&dev->regs->pciirqenb1);
-		writel (tmp, &dev->regs->pciirqenb1);
+		tmp |= readl(&dev->regs->pciirqenb1);
+		writel(tmp, &dev->regs->pciirqenb1);
 
 		/* for short OUT transfers, dma completions can't
 		 * advance the queue; do it pio-style, by hand.
@@ -298,35 +296,35 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 		 */
 		if ((desc->bEndpointAddress & USB_DIR_IN) == 0) {
 			tmp = BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT_ENABLE);
-			writel (tmp, &ep->regs->ep_irqenb);
+			writel(tmp, &ep->regs->ep_irqenb);
 
 			enable_pciirqenb(ep);
 		}
 	}
 
 	tmp = desc->bEndpointAddress;
-	DEBUG (dev, "enabled %s (ep%d%s-%s) %s max %04x\n",
-		_ep->name, tmp & 0x0f, DIR_STRING (tmp),
-		type_string (desc->bmAttributes),
+	DEBUG(dev, "enabled %s (ep%d%s-%s) %s max %04x\n",
+		_ep->name, tmp & 0x0f, DIR_STRING(tmp),
+		type_string(desc->bmAttributes),
 		ep->dma ? "dma" : "pio", max);
 
 	/* pci writes may still be posted */
-	spin_unlock_irqrestore (&dev->lock, flags);
+	spin_unlock_irqrestore(&dev->lock, flags);
 	return 0;
 }
 
-static int handshake (u32 __iomem *ptr, u32 mask, u32 done, int usec)
+static int handshake(u32 __iomem *ptr, u32 mask, u32 done, int usec)
 {
 	u32	result;
 
 	do {
-		result = readl (ptr);
+		result = readl(ptr);
 		if (result == ~(u32)0)		/* "device unplugged" */
 			return -ENODEV;
 		result &= mask;
 		if (result == done)
 			return 0;
-		udelay (1);
+		udelay(1);
 		usec--;
 	} while (usec > 0);
 	return -ETIMEDOUT;
@@ -340,28 +338,28 @@ static void ep_reset_228x(struct net2280_regs __iomem *regs,
 	u32		tmp;
 
 	ep->desc = NULL;
-	INIT_LIST_HEAD (&ep->queue);
+	INIT_LIST_HEAD(&ep->queue);
 
 	usb_ep_set_maxpacket_limit(&ep->ep, ~0);
 	ep->ep.ops = &net2280_ep_ops;
 
 	/* disable the dma, irqs, endpoint... */
 	if (ep->dma) {
-		writel (0, &ep->dma->dmactl);
+		writel(0, &ep->dma->dmactl);
 		writel(BIT(DMA_SCATTER_GATHER_DONE_INTERRUPT) |
 			BIT(DMA_TRANSACTION_DONE_INTERRUPT) |
 			BIT(DMA_ABORT),
 			&ep->dma->dmastat);
 
-		tmp = readl (&regs->pciirqenb0);
+		tmp = readl(&regs->pciirqenb0);
 		tmp &= ~BIT(ep->num);
-		writel (tmp, &regs->pciirqenb0);
+		writel(tmp, &regs->pciirqenb0);
 	} else {
-		tmp = readl (&regs->pciirqenb1);
+		tmp = readl(&regs->pciirqenb1);
 		tmp &= ~BIT((8 + ep->num));	/* completion */
-		writel (tmp, &regs->pciirqenb1);
+		writel(tmp, &regs->pciirqenb1);
 	}
-	writel (0, &ep->regs->ep_irqenb);
+	writel(0, &ep->regs->ep_irqenb);
 
 	/* init to our chosen defaults, notably so that we NAK OUT
 	 * packets until the driver queues a read (+note erratum 0112)
@@ -383,7 +381,7 @@ static void ep_reset_228x(struct net2280_regs __iomem *regs,
 		tmp |= BIT(CLEAR_ENDPOINT_TOGGLE) |
 			BIT(CLEAR_ENDPOINT_HALT);
 	}
-	writel (tmp, &ep->regs->ep_rsp);
+	writel(tmp, &ep->regs->ep_rsp);
 
 	/* scrub most status bits, and flush any fifo state */
 	if (ep->dev->pdev->device == 0x2280)
@@ -459,64 +457,64 @@ static void ep_reset_338x(struct net2280_regs __iomem *regs,
 	       BIT(DATA_IN_TOKEN_INTERRUPT), &ep->regs->ep_stat);
 }
 
-static void nuke (struct net2280_ep *);
+static void nuke(struct net2280_ep *);
 
-static int net2280_disable (struct usb_ep *_ep)
+static int net2280_disable(struct usb_ep *_ep)
 {
 	struct net2280_ep	*ep;
 	unsigned long		flags;
 
-	ep = container_of (_ep, struct net2280_ep, ep);
+	ep = container_of(_ep, struct net2280_ep, ep);
 	if (!_ep || !ep->desc || _ep->name == ep0name)
 		return -EINVAL;
 
-	spin_lock_irqsave (&ep->dev->lock, flags);
-	nuke (ep);
+	spin_lock_irqsave(&ep->dev->lock, flags);
+	nuke(ep);
 
 	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		ep_reset_338x(ep->dev->regs, ep);
 	else
 		ep_reset_228x(ep->dev->regs, ep);
 
-	VDEBUG (ep->dev, "disabled %s %s\n",
+	VDEBUG(ep->dev, "disabled %s %s\n",
 			ep->dma ? "dma" : "pio", _ep->name);
 
 	/* synch memory views with the device */
 	(void)readl(&ep->cfg->ep_cfg);
 
 	if (use_dma && !ep->dma && ep->num >= 1 && ep->num <= 4)
-		ep->dma = &ep->dev->dma [ep->num - 1];
+		ep->dma = &ep->dev->dma[ep->num - 1];
 
-	spin_unlock_irqrestore (&ep->dev->lock, flags);
+	spin_unlock_irqrestore(&ep->dev->lock, flags);
 	return 0;
 }
 
 /*-------------------------------------------------------------------------*/
 
-static struct usb_request *
-net2280_alloc_request (struct usb_ep *_ep, gfp_t gfp_flags)
+static struct usb_request *net2280_alloc_request(struct usb_ep *_ep,
+							gfp_t gfp_flags)
 {
 	struct net2280_ep	*ep;
 	struct net2280_request	*req;
 
 	if (!_ep)
 		return NULL;
-	ep = container_of (_ep, struct net2280_ep, ep);
+	ep = container_of(_ep, struct net2280_ep, ep);
 
 	req = kzalloc(sizeof(*req), gfp_flags);
 	if (!req)
 		return NULL;
 
-	INIT_LIST_HEAD (&req->queue);
+	INIT_LIST_HEAD(&req->queue);
 
 	/* this dma descriptor may be swapped with the previous dummy */
 	if (ep->dma) {
 		struct net2280_dma	*td;
 
-		td = pci_pool_alloc (ep->dev->requests, gfp_flags,
+		td = pci_pool_alloc(ep->dev->requests, gfp_flags,
 				&req->td_dma);
 		if (!td) {
-			kfree (req);
+			kfree(req);
 			return NULL;
 		}
 		td->dmacount = 0;	/* not VALID */
@@ -526,21 +524,20 @@ net2280_alloc_request (struct usb_ep *_ep, gfp_t gfp_flags)
 	return &req->req;
 }
 
-static void
-net2280_free_request (struct usb_ep *_ep, struct usb_request *_req)
+static void net2280_free_request(struct usb_ep *_ep, struct usb_request *_req)
 {
 	struct net2280_ep	*ep;
 	struct net2280_request	*req;
 
-	ep = container_of (_ep, struct net2280_ep, ep);
+	ep = container_of(_ep, struct net2280_ep, ep);
 	if (!_ep || !_req)
 		return;
 
-	req = container_of (_req, struct net2280_request, req);
-	WARN_ON (!list_empty (&req->queue));
+	req = container_of(_req, struct net2280_request, req);
+	WARN_ON(!list_empty(&req->queue));
 	if (req->td)
-		pci_pool_free (ep->dev->requests, req->td, req->td_dma);
-	kfree (req);
+		pci_pool_free(ep->dev->requests, req->td, req->td_dma);
+	kfree(req);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -552,8 +549,7 @@ net2280_free_request (struct usb_ep *_ep, struct usb_request *_req)
  * at a time, but this code is simpler because it knows it only writes
  * one packet.  ep-a..ep-d should use dma instead.
  */
-static void
-write_fifo (struct net2280_ep *ep, struct usb_request *req)
+static void write_fifo(struct net2280_ep *ep, struct usb_request *req)
 {
 	struct net2280_ep_regs	__iomem *regs = ep->regs;
 	u8			*buf;
@@ -564,7 +560,7 @@ write_fifo (struct net2280_ep *ep, struct usb_request *req)
 
 	if (req) {
 		buf = req->buf + req->actual;
-		prefetch (buf);
+		prefetch(buf);
 		total = req->length - req->actual;
 	} else {
 		total = 0;
@@ -576,7 +572,7 @@ write_fifo (struct net2280_ep *ep, struct usb_request *req)
 	if (count > total)	/* min() cannot be used on a bitfield */
 		count = total;
 
-	VDEBUG (ep->dev, "write %s fifo (IN) %d bytes%s req %p\n",
+	VDEBUG(ep->dev, "write %s fifo (IN) %d bytes%s req %p\n",
 			ep->ep.name, count,
 			(count != ep->ep.maxpacket) ? " (short)" : "",
 			req);
@@ -585,9 +581,9 @@ write_fifo (struct net2280_ep *ep, struct usb_request *req)
 		 * should normally be full (4 bytes) and successive partial
 		 * lines are ok only in certain cases.
 		 */
-		tmp = get_unaligned ((u32 *)buf);
-		cpu_to_le32s (&tmp);
-		writel (tmp, &regs->ep_data);
+		tmp = get_unaligned((u32 *)buf);
+		cpu_to_le32s(&tmp);
+		writel(tmp, &regs->ep_data);
 		buf += 4;
 		count -= 4;
 	}
@@ -597,10 +593,10 @@ write_fifo (struct net2280_ep *ep, struct usb_request *req)
 	 * when maxpacket is not a multiple of 4 bytes.
 	 */
 	if (count || total < ep->ep.maxpacket) {
-		tmp = count ? get_unaligned ((u32 *)buf) : count;
-		cpu_to_le32s (&tmp);
-		set_fifo_bytecount (ep, count & 0x03);
-		writel (tmp, &regs->ep_data);
+		tmp = count ? get_unaligned((u32 *)buf) : count;
+		cpu_to_le32s(&tmp);
+		set_fifo_bytecount(ep, count & 0x03);
+		writel(tmp, &regs->ep_data);
 	}
 
 	/* pci writes may still be posted */
@@ -613,20 +609,21 @@ write_fifo (struct net2280_ep *ep, struct usb_request *req)
  * NOTE:  also used in cases where that erratum doesn't apply:
  * where the host wrote "too much" data to us.
  */
-static void out_flush (struct net2280_ep *ep)
+static void out_flush(struct net2280_ep *ep)
 {
 	u32	__iomem *statp;
 	u32	tmp;
 
-	ASSERT_OUT_NAKING (ep);
+	ASSERT_OUT_NAKING(ep);
 
 	statp = &ep->regs->ep_stat;
 	writel(BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
 		BIT(DATA_PACKET_RECEIVED_INTERRUPT)
 		, statp);
 	writel(BIT(FIFO_FLUSH), statp);
-	mb ();
-	tmp = readl (statp);
+	/* Make sure that stap is written */
+	mb();
+	tmp = readl(statp);
 	if (tmp & BIT(DATA_OUT_PING_TOKEN_INTERRUPT)
 			/* high speed did bulk NYET; fifo isn't filling */
 			&& ep->dev->gadget.speed == USB_SPEED_FULL) {
@@ -646,8 +643,7 @@ static void out_flush (struct net2280_ep *ep)
  * for ep-a..ep-d this will read multiple packets out when they
  * have been accepted.
  */
-static int
-read_fifo (struct net2280_ep *ep, struct net2280_request *req)
+static int read_fifo(struct net2280_ep *ep, struct net2280_request *req)
 {
 	struct net2280_ep_regs	__iomem *regs = ep->regs;
 	u8			*buf = req->req.buf + req->req.actual;
@@ -659,12 +655,12 @@ read_fifo (struct net2280_ep *ep, struct net2280_request *req)
 	 */
 	if (ep->dev->chiprev == 0x0100
 			&& ep->dev->gadget.speed == USB_SPEED_FULL) {
-		udelay (1);
-		tmp = readl (&ep->regs->ep_stat);
+		udelay(1);
+		tmp = readl(&ep->regs->ep_stat);
 		if ((tmp & BIT(NAK_OUT_PACKETS)))
 			cleanup = 1;
 		else if ((tmp & BIT(FIFO_FULL))) {
-			start_out_naking (ep);
+			start_out_naking(ep);
 			prevent = 1;
 		}
 		/* else: hope we don't see the problem */
@@ -673,12 +669,12 @@ read_fifo (struct net2280_ep *ep, struct net2280_request *req)
 	/* never overflow the rx buffer. the fifo reads packets until
 	 * it sees a short one; we might not be ready for them all.
 	 */
-	prefetchw (buf);
-	count = readl (&regs->ep_avail);
-	if (unlikely (count == 0)) {
-		udelay (1);
-		tmp = readl (&ep->regs->ep_stat);
-		count = readl (&regs->ep_avail);
+	prefetchw(buf);
+	count = readl(&regs->ep_avail);
+	if (unlikely(count == 0)) {
+		udelay(1);
+		tmp = readl(&ep->regs->ep_stat);
+		count = readl(&regs->ep_avail);
 		/* handled that data already? */
 		if (count == 0 && (tmp & BIT(NAK_OUT_PACKETS)) == 0)
 			return 0;
@@ -688,7 +684,7 @@ read_fifo (struct net2280_ep *ep, struct net2280_request *req)
 	if (count > tmp) {
 		/* as with DMA, data overflow gets flushed */
 		if ((tmp % ep->ep.maxpacket) != 0) {
-			ERROR (ep->dev,
+			ERROR(ep->dev,
 				"%s out fifo %d bytes, expected %d\n",
 				ep->ep.name, count, tmp);
 			req->req.status = -EOVERFLOW;
@@ -703,20 +699,20 @@ read_fifo (struct net2280_ep *ep, struct net2280_request *req)
 
 	is_short = (count == 0) || ((count % ep->ep.maxpacket) != 0);
 
-	VDEBUG (ep->dev, "read %s fifo (OUT) %d bytes%s%s%s req %p %d/%d\n",
+	VDEBUG(ep->dev, "read %s fifo (OUT) %d bytes%s%s%s req %p %d/%d\n",
 			ep->ep.name, count, is_short ? " (short)" : "",
 			cleanup ? " flush" : "", prevent ? " nak" : "",
 			req, req->req.actual, req->req.length);
 
 	while (count >= 4) {
-		tmp = readl (&regs->ep_data);
-		cpu_to_le32s (&tmp);
-		put_unaligned (tmp, (u32 *)buf);
+		tmp = readl(&regs->ep_data);
+		cpu_to_le32s(&tmp);
+		put_unaligned(tmp, (u32 *)buf);
 		buf += 4;
 		count -= 4;
 	}
 	if (count) {
-		tmp = readl (&regs->ep_data);
+		tmp = readl(&regs->ep_data);
 		/* LE conversion is implicit here: */
 		do {
 			*buf++ = (u8) tmp;
@@ -724,10 +720,10 @@ read_fifo (struct net2280_ep *ep, struct net2280_request *req)
 		} while (--count);
 	}
 	if (cleanup)
-		out_flush (ep);
+		out_flush(ep);
 	if (prevent) {
 		writel(BIT(CLEAR_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
-		(void) readl (&ep->regs->ep_rsp);
+		(void) readl(&ep->regs->ep_rsp);
 	}
 
 	return is_short || ((req->req.actual == req->req.length)
@@ -735,8 +731,8 @@ read_fifo (struct net2280_ep *ep, struct net2280_request *req)
 }
 
 /* fill out dma descriptor to match a given request */
-static void
-fill_dma_desc (struct net2280_ep *ep, struct net2280_request *req, int valid)
+static void fill_dma_desc(struct net2280_ep *ep,
+					struct net2280_request *req, int valid)
 {
 	struct net2280_dma	*td = req->td;
 	u32			dmacount = req->req.length;
@@ -762,7 +758,7 @@ fill_dma_desc (struct net2280_ep *ep, struct net2280_request *req, int valid)
 	td->dmaaddr = cpu_to_le32 (req->req.dma);
 
 	/* 2280 may be polling VALID_BIT through ep->dma->dmadesc */
-	wmb ();
+	wmb();
 	td->dmacount = cpu_to_le32(dmacount);
 }
 
@@ -777,18 +773,18 @@ static const u32 dmactl_default =
 		/* erratum 0116 workaround part 2 (no AUTOSTART) */
 		BIT(DMA_ENABLE);
 
-static inline void spin_stop_dma (struct net2280_dma_regs __iomem *dma)
+static inline void spin_stop_dma(struct net2280_dma_regs __iomem *dma)
 {
 	handshake(&dma->dmactl, BIT(DMA_ENABLE), 0, 50);
 }
 
-static inline void stop_dma (struct net2280_dma_regs __iomem *dma)
+static inline void stop_dma(struct net2280_dma_regs __iomem *dma)
 {
 	writel(readl(&dma->dmactl) & ~BIT(DMA_ENABLE), &dma->dmactl);
-	spin_stop_dma (dma);
+	spin_stop_dma(dma);
 }
 
-static void start_queue (struct net2280_ep *ep, u32 dmactl, u32 td_dma)
+static void start_queue(struct net2280_ep *ep, u32 dmactl, u32 td_dma)
 {
 	struct net2280_dma_regs	__iomem *dma = ep->dma;
 	unsigned int tmp = BIT(VALID_BIT) | (ep->is_in << DMA_DIRECTION);
@@ -796,24 +792,24 @@ static void start_queue (struct net2280_ep *ep, u32 dmactl, u32 td_dma)
 	if (ep->dev->pdev->device != 0x2280)
 		tmp |= BIT(END_OF_CHAIN);
 
-	writel (tmp, &dma->dmacount);
-	writel (readl (&dma->dmastat), &dma->dmastat);
+	writel(tmp, &dma->dmacount);
+	writel(readl(&dma->dmastat), &dma->dmastat);
 
-	writel (td_dma, &dma->dmadesc);
+	writel(td_dma, &dma->dmadesc);
 	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		dmactl |= BIT(DMA_REQUEST_OUTSTANDING);
-	writel (dmactl, &dma->dmactl);
+	writel(dmactl, &dma->dmactl);
 
 	/* erratum 0116 workaround part 3:  pci arbiter away from net2280 */
-	(void) readl (&ep->dev->pci->pcimstctl);
+	(void) readl(&ep->dev->pci->pcimstctl);
 
 	writel(BIT(DMA_START), &dma->dmastat);
 
 	if (!ep->is_in)
-		stop_out_naking (ep);
+		stop_out_naking(ep);
 }
 
-static void start_dma (struct net2280_ep *ep, struct net2280_request *req)
+static void start_dma(struct net2280_ep *ep, struct net2280_request *req)
 {
 	u32			tmp;
 	struct net2280_dma_regs	__iomem *dma = ep->dma;
@@ -822,24 +818,24 @@ static void start_dma (struct net2280_ep *ep, struct net2280_request *req)
 
 	/* on this path we "know" there's no dma active (yet) */
 	WARN_ON(readl(&dma->dmactl) & BIT(DMA_ENABLE));
-	writel (0, &ep->dma->dmactl);
+	writel(0, &ep->dma->dmactl);
 
 	/* previous OUT packet might have been short */
-	if (!ep->is_in && ((tmp = readl (&ep->regs->ep_stat))
-				& BIT(NAK_OUT_PACKETS)) != 0) {
+	if (!ep->is_in && (readl(&ep->regs->ep_stat) &
+				BIT(NAK_OUT_PACKETS))) {
 		writel(BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT),
 			&ep->regs->ep_stat);
 
-		tmp = readl (&ep->regs->ep_avail);
+		tmp = readl(&ep->regs->ep_avail);
 		if (tmp) {
-			writel (readl (&dma->dmastat), &dma->dmastat);
+			writel(readl(&dma->dmastat), &dma->dmastat);
 
 			/* transfer all/some fifo data */
-			writel (req->req.dma, &dma->dmaaddr);
-			tmp = min (tmp, req->req.length);
+			writel(req->req.dma, &dma->dmaaddr);
+			tmp = min(tmp, req->req.length);
 
 			/* dma irq, faking scatterlist status */
-			req->td->dmacount = cpu_to_le32 (req->req.length - tmp);
+			req->td->dmacount = cpu_to_le32(req->req.length - tmp);
 			writel(BIT(DMA_DONE_INTERRUPT_ENABLE)
 				| tmp, &dma->dmacount);
 			req->td->dmadesc = 0;
@@ -858,8 +854,8 @@ static void start_dma (struct net2280_ep *ep, struct net2280_request *req)
 	 * (zero length) unless the driver explicitly said to do that.
 	 */
 	if (ep->is_in) {
-		if (likely ((req->req.length % ep->ep.maxpacket) != 0
-				|| req->req.zero)) {
+		if (likely((req->req.length % ep->ep.maxpacket) ||
+							req->req.zero)){
 			tmp |= BIT(DMA_FIFO_VALIDATE);
 			ep->in_fifo_validate = 1;
 		} else
@@ -868,12 +864,12 @@ static void start_dma (struct net2280_ep *ep, struct net2280_request *req)
 
 	/* init req->td, pointing to the current dummy */
 	req->td->dmadesc = cpu_to_le32 (ep->td_dma);
-	fill_dma_desc (ep, req, 1);
+	fill_dma_desc(ep, req, 1);
 
 	if (!use_dma_chaining)
 		req->td->dmacount |= cpu_to_le32(BIT(END_OF_CHAIN));
 
-	start_queue (ep, tmp, req->td_dma);
+	start_queue(ep, tmp, req->td_dma);
 }
 
 static inline void resume_dma(struct net2280_ep *ep)
@@ -891,8 +887,8 @@ static inline void ep_stop_dma(struct net2280_ep *ep)
 	ep->dma_started = false;
 }
 
-static inline void
-queue_dma (struct net2280_ep *ep, struct net2280_request *req, int valid)
+static inline void queue_dma(struct net2280_ep *ep,
+		struct net2280_request *req, int valid)
 {
 	struct net2280_dma	*end;
 	dma_addr_t		tmp;
@@ -908,16 +904,16 @@ queue_dma (struct net2280_ep *ep, struct net2280_request *req, int valid)
 
 	end->dmadesc = cpu_to_le32 (ep->td_dma);
 
-	fill_dma_desc (ep, req, valid);
+	fill_dma_desc(ep, req, valid);
 }
 
-static void
-done (struct net2280_ep *ep, struct net2280_request *req, int status)
+static void done(struct net2280_ep *ep,
+				struct net2280_request *req, int status)
 {
 	struct net2280		*dev;
 	unsigned		stopped = ep->stopped;
 
-	list_del_init (&req->queue);
+	list_del_init(&req->queue);
 
 	if (req->req.status == -EINPROGRESS)
 		req->req.status = status;
@@ -929,22 +925,22 @@ done (struct net2280_ep *ep, struct net2280_request *req, int status)
 		usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
 
 	if (status && status != -ESHUTDOWN)
-		VDEBUG (dev, "complete %s req %p stat %d len %u/%u\n",
+		VDEBUG(dev, "complete %s req %p stat %d len %u/%u\n",
 			ep->ep.name, &req->req, status,
 			req->req.actual, req->req.length);
 
 	/* don't modify queue heads during completion callback */
 	ep->stopped = 1;
-	spin_unlock (&dev->lock);
-	req->req.complete (&ep->ep, &req->req);
-	spin_lock (&dev->lock);
+	spin_unlock(&dev->lock);
+	req->req.complete(&ep->ep, &req->req);
+	spin_lock(&dev->lock);
 	ep->stopped = stopped;
 }
 
 /*-------------------------------------------------------------------------*/
 
-static int
-net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
+static int net2280_queue(struct usb_ep *_ep,
+				struct usb_request *_req, gfp_t gfp_flags)
 {
 	struct net2280_request	*req;
 	struct net2280_ep	*ep;
@@ -954,13 +950,13 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 	/* we always require a cpu-view buffer, so that we can
 	 * always use pio (as fallback or whatever).
 	 */
-	req = container_of (_req, struct net2280_request, req);
-	if (!_req || !_req->complete || !_req->buf
-			|| !list_empty (&req->queue))
+	req = container_of(_req, struct net2280_request, req);
+	if (!_req || !_req->complete || !_req->buf ||
+				!list_empty(&req->queue))
 		return -EINVAL;
 	if (_req->length > (~0 & DMA_BYTE_COUNT_MASK))
 		return -EDOM;
-	ep = container_of (_ep, struct net2280_ep, ep);
+	ep = container_of(_ep, struct net2280_ep, ep);
 	if (!_ep || (!ep->desc && ep->num != 0))
 		return -EINVAL;
 	dev = ep->dev;
@@ -982,17 +978,17 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 	}
 
 #if 0
-	VDEBUG (dev, "%s queue req %p, len %d buf %p\n",
+	VDEBUG(dev, "%s queue req %p, len %d buf %p\n",
 			_ep->name, _req, _req->length, _req->buf);
 #endif
 
-	spin_lock_irqsave (&dev->lock, flags);
+	spin_lock_irqsave(&dev->lock, flags);
 
 	_req->status = -EINPROGRESS;
 	_req->actual = 0;
 
 	/* kickstart this i/o queue? */
-	if (list_empty (&ep->queue) && !ep->stopped) {
+	if (list_empty(&ep->queue) && !ep->stopped) {
 		/* DMA request while EP halted */
 		if (ep->dma &&
 		    (readl(&ep->regs->ep_rsp) & BIT(CLEAR_ENDPOINT_HALT)) &&
@@ -1010,24 +1006,24 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 		}
 		/* use DMA if the endpoint supports it, else pio */
 		else if (ep->dma)
-			start_dma (ep, req);
+			start_dma(ep, req);
 		else {
 			/* maybe there's no control data, just status ack */
 			if (ep->num == 0 && _req->length == 0) {
-				allow_status (ep);
-				done (ep, req, 0);
-				VDEBUG (dev, "%s status ack\n", ep->ep.name);
+				allow_status(ep);
+				done(ep, req, 0);
+				VDEBUG(dev, "%s status ack\n", ep->ep.name);
 				goto done;
 			}
 
 			/* PIO ... stuff the fifo, or unblock it.  */
 			if (ep->is_in)
-				write_fifo (ep, _req);
-			else if (list_empty (&ep->queue)) {
+				write_fifo(ep, _req);
+			else if (list_empty(&ep->queue)) {
 				u32	s;
 
 				/* OUT FIFO might have packet(s) buffered */
-				s = readl (&ep->regs->ep_stat);
+				s = readl(&ep->regs->ep_stat);
 				if ((s & BIT(FIFO_EMPTY)) == 0) {
 					/* note:  _req->short_not_ok is
 					 * ignored here since PIO _always_
@@ -1035,14 +1031,18 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 					 * _req->status doesn't change for
 					 * short reads (only _req->actual)
 					 */
-					if (read_fifo (ep, req)) {
-						done (ep, req, 0);
-						if (ep->num == 0)
-							allow_status (ep);
+					if (read_fifo(ep, req) &&
+							ep->num == 0) {
+						done(ep, req, 0);
+						allow_status(ep);
 						/* don't queue it */
 						req = NULL;
+					} else if (read_fifo(ep, req) &&
+							ep->num != 0) {
+						done(ep, req, 0);
+						req = NULL;
 					} else
-						s = readl (&ep->regs->ep_stat);
+						s = readl(&ep->regs->ep_stat);
 				}
 
 				/* don't NAK, let the fifo fill */
@@ -1061,54 +1061,49 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 			/* preventing magic zlps is per-engine state, not
 			 * per-transfer; irq logic must recover hiccups.
 			 */
-			expect = likely (req->req.zero
-				|| (req->req.length % ep->ep.maxpacket) != 0);
+			expect = likely(req->req.zero ||
+				(req->req.length % ep->ep.maxpacket));
 			if (expect != ep->in_fifo_validate)
 				valid = 0;
 		}
-		queue_dma (ep, req, valid);
+		queue_dma(ep, req, valid);
 
 	} /* else the irq handler advances the queue. */
 
 	ep->responded = 1;
 	if (req)
-		list_add_tail (&req->queue, &ep->queue);
+		list_add_tail(&req->queue, &ep->queue);
 done:
-	spin_unlock_irqrestore (&dev->lock, flags);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	/* pci writes may still be posted */
 	return 0;
 }
 
-static inline void
-dma_done (
-	struct net2280_ep *ep,
-	struct net2280_request *req,
-	u32 dmacount,
-	int status
-)
+static inline void dma_done(struct net2280_ep *ep,
+			struct net2280_request *req, u32 dmacount, int status)
 {
 	req->req.actual = req->req.length - (DMA_BYTE_COUNT_MASK & dmacount);
-	done (ep, req, status);
+	done(ep, req, status);
 }
 
-static void restart_dma (struct net2280_ep *ep);
+static void restart_dma(struct net2280_ep *ep);
 
-static void scan_dma_completions (struct net2280_ep *ep)
+static void scan_dma_completions(struct net2280_ep *ep)
 {
 	/* only look at descriptors that were "naturally" retired,
 	 * so fifo and list head state won't matter
 	 */
-	while (!list_empty (&ep->queue)) {
+	while (!list_empty(&ep->queue)) {
 		struct net2280_request	*req;
 		u32			tmp;
 
-		req = list_entry (ep->queue.next,
+		req = list_entry(ep->queue.next,
 				struct net2280_request, queue);
 		if (!req->valid)
 			break;
-		rmb ();
-		tmp = le32_to_cpup (&req->td->dmacount);
+		rmb();
+		tmp = le32_to_cpup(&req->td->dmacount);
 		if ((tmp & BIT(VALID_BIT)) != 0)
 			break;
 
@@ -1116,17 +1111,17 @@ static void scan_dma_completions (struct net2280_ep *ep)
 		 * cases where DMA must be aborted; this code handles
 		 * all non-abort DMA completions.
 		 */
-		if (unlikely (req->td->dmadesc == 0)) {
+		if (unlikely(req->td->dmadesc == 0)) {
 			/* paranoia */
-			tmp = readl (&ep->dma->dmacount);
+			tmp = readl(&ep->dma->dmacount);
 			if (tmp & DMA_BYTE_COUNT_MASK)
 				break;
 			/* single transfer mode */
-			dma_done (ep, req, tmp, 0);
+			dma_done(ep, req, tmp, 0);
 			break;
 		} else if (!ep->is_in
 				&& (req->req.length % ep->ep.maxpacket) != 0) {
-			tmp = readl (&ep->regs->ep_stat);
+			tmp = readl(&ep->regs->ep_stat);
 			if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 				return dma_done(ep, req, tmp, 0);
 
@@ -1135,33 +1130,37 @@ static void scan_dma_completions (struct net2280_ep *ep)
 			 * 0122, and 0124; not all cases trigger the warning.
 			 */
 			if ((tmp & BIT(NAK_OUT_PACKETS)) == 0) {
-				WARNING (ep->dev, "%s lost packet sync!\n",
+				WARNING(ep->dev, "%s lost packet sync!\n",
 						ep->ep.name);
 				req->req.status = -EOVERFLOW;
-			} else if ((tmp = readl (&ep->regs->ep_avail)) != 0) {
-				/* fifo gets flushed later */
-				ep->out_overflow = 1;
-				DEBUG (ep->dev, "%s dma, discard %d len %d\n",
+			} else {
+				tmp = readl(&ep->regs->ep_avail);
+				if (tmp) {
+					/* fifo gets flushed later */
+					ep->out_overflow = 1;
+					DEBUG(ep->dev,
+						"%s dma, discard %d len %d\n",
 						ep->ep.name, tmp,
 						req->req.length);
-				req->req.status = -EOVERFLOW;
+					req->req.status = -EOVERFLOW;
+				}
 			}
 		}
-		dma_done (ep, req, tmp, 0);
+		dma_done(ep, req, tmp, 0);
 	}
 }
 
-static void restart_dma (struct net2280_ep *ep)
+static void restart_dma(struct net2280_ep *ep)
 {
 	struct net2280_request	*req;
 	u32			dmactl = dmactl_default;
 
 	if (ep->stopped)
 		return;
-	req = list_entry (ep->queue.next, struct net2280_request, queue);
+	req = list_entry(ep->queue.next, struct net2280_request, queue);
 
 	if (!use_dma_chaining) {
-		start_dma (ep, req);
+		start_dma(ep, req);
 		return;
 	}
 
@@ -1175,21 +1174,20 @@ static void restart_dma (struct net2280_ep *ep)
 		struct net2280_request	*entry, *prev = NULL;
 		int			reqmode, done = 0;
 
-		DEBUG (ep->dev, "%s dma hiccup td %p\n", ep->ep.name, req->td);
-		ep->in_fifo_validate = likely (req->req.zero
-			|| (req->req.length % ep->ep.maxpacket) != 0);
+		DEBUG(ep->dev, "%s dma hiccup td %p\n", ep->ep.name, req->td);
+		ep->in_fifo_validate = likely(req->req.zero ||
+				(req->req.length % ep->ep.maxpacket) != 0);
 		if (ep->in_fifo_validate)
 			dmactl |= BIT(DMA_FIFO_VALIDATE);
-		list_for_each_entry (entry, &ep->queue, queue) {
+		list_for_each_entry(entry, &ep->queue, queue) {
 			__le32		dmacount;
 
 			if (entry == req)
 				continue;
 			dmacount = entry->td->dmacount;
 			if (!done) {
-				reqmode = likely (entry->req.zero
-					|| (entry->req.length
-						% ep->ep.maxpacket) != 0);
+				reqmode = likely(entry->req.zero ||
+				   (entry->req.length % ep->ep.maxpacket));
 				if (reqmode == ep->in_fifo_validate) {
 					entry->valid = 1;
 					dmacount |= valid_bit;
@@ -1211,20 +1209,20 @@ static void restart_dma (struct net2280_ep *ep)
 		}
 	}
 
-	writel (0, &ep->dma->dmactl);
-	start_queue (ep, dmactl, req->td_dma);
+	writel(0, &ep->dma->dmactl);
+	start_queue(ep, dmactl, req->td_dma);
 }
 
 static void abort_dma_228x(struct net2280_ep *ep)
 {
 	/* abort the current transfer */
-	if (likely (!list_empty (&ep->queue))) {
+	if (likely(!list_empty(&ep->queue))) {
 		/* FIXME work around errata 0121, 0122, 0124 */
 		writel(BIT(DMA_ABORT), &ep->dma->dmastat);
-		spin_stop_dma (ep->dma);
+		spin_stop_dma(ep->dma);
 	} else
-		stop_dma (ep->dma);
-	scan_dma_completions (ep);
+		stop_dma(ep->dma);
+	scan_dma_completions(ep);
 }
 
 static void abort_dma_338x(struct net2280_ep *ep)
@@ -1241,24 +1239,24 @@ static void abort_dma(struct net2280_ep *ep)
 }
 
 /* dequeue ALL requests */
-static void nuke (struct net2280_ep *ep)
+static void nuke(struct net2280_ep *ep)
 {
 	struct net2280_request	*req;
 
 	/* called with spinlock held */
 	ep->stopped = 1;
 	if (ep->dma)
-		abort_dma (ep);
-	while (!list_empty (&ep->queue)) {
-		req = list_entry (ep->queue.next,
+		abort_dma(ep);
+	while (!list_empty(&ep->queue)) {
+		req = list_entry(ep->queue.next,
 				struct net2280_request,
 				queue);
-		done (ep, req, -ESHUTDOWN);
+		done(ep, req, -ESHUTDOWN);
 	}
 }
 
 /* dequeue JUST ONE request */
-static int net2280_dequeue (struct usb_ep *_ep, struct usb_request *_req)
+static int net2280_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 {
 	struct net2280_ep	*ep;
 	struct net2280_request	*req;
@@ -1266,65 +1264,65 @@ static int net2280_dequeue (struct usb_ep *_ep, struct usb_request *_req)
 	u32			dmactl;
 	int			stopped;
 
-	ep = container_of (_ep, struct net2280_ep, ep);
+	ep = container_of(_ep, struct net2280_ep, ep);
 	if (!_ep || (!ep->desc && ep->num != 0) || !_req)
 		return -EINVAL;
 
-	spin_lock_irqsave (&ep->dev->lock, flags);
+	spin_lock_irqsave(&ep->dev->lock, flags);
 	stopped = ep->stopped;
 
 	/* quiesce dma while we patch the queue */
 	dmactl = 0;
 	ep->stopped = 1;
 	if (ep->dma) {
-		dmactl = readl (&ep->dma->dmactl);
+		dmactl = readl(&ep->dma->dmactl);
 		/* WARNING erratum 0127 may kick in ... */
-		stop_dma (ep->dma);
-		scan_dma_completions (ep);
+		stop_dma(ep->dma);
+		scan_dma_completions(ep);
 	}
 
 	/* make sure it's still queued on this endpoint */
-	list_for_each_entry (req, &ep->queue, queue) {
+	list_for_each_entry(req, &ep->queue, queue) {
 		if (&req->req == _req)
 			break;
 	}
 	if (&req->req != _req) {
-		spin_unlock_irqrestore (&ep->dev->lock, flags);
+		spin_unlock_irqrestore(&ep->dev->lock, flags);
 		return -EINVAL;
 	}
 
 	/* queue head may be partially complete. */
 	if (ep->queue.next == &req->queue) {
 		if (ep->dma) {
-			DEBUG (ep->dev, "unlink (%s) dma\n", _ep->name);
+			DEBUG(ep->dev, "unlink (%s) dma\n", _ep->name);
 			_req->status = -ECONNRESET;
-			abort_dma (ep);
-			if (likely (ep->queue.next == &req->queue)) {
-				// NOTE: misreports single-transfer mode
+			abort_dma(ep);
+			if (likely(ep->queue.next == &req->queue)) {
+				/* NOTE: misreports single-transfer mode*/
 				req->td->dmacount = 0;	/* invalidate */
-				dma_done (ep, req,
-					readl (&ep->dma->dmacount),
+				dma_done(ep, req,
+					readl(&ep->dma->dmacount),
 					-ECONNRESET);
 			}
 		} else {
-			DEBUG (ep->dev, "unlink (%s) pio\n", _ep->name);
-			done (ep, req, -ECONNRESET);
+			DEBUG(ep->dev, "unlink (%s) pio\n", _ep->name);
+			done(ep, req, -ECONNRESET);
 		}
 		req = NULL;
 
 	/* patch up hardware chaining data */
 	} else if (ep->dma && use_dma_chaining) {
 		if (req->queue.prev == ep->queue.next) {
-			writel (le32_to_cpu (req->td->dmadesc),
+			writel(le32_to_cpu(req->td->dmadesc),
 				&ep->dma->dmadesc);
 			if (req->td->dmacount & dma_done_ie)
-				writel (readl (&ep->dma->dmacount)
+				writel(readl(&ep->dma->dmacount)
 						| le32_to_cpu(dma_done_ie),
 					&ep->dma->dmacount);
 		} else {
 			struct net2280_request	*prev;
 
-			prev = list_entry (req->queue.prev,
+			prev = list_entry(req->queue.prev,
 				struct net2280_request, queue);
 			prev->td->dmadesc = req->td->dmadesc;
 			if (req->td->dmacount & dma_done_ie)
@@ -1333,39 +1331,39 @@ static int net2280_dequeue (struct usb_ep *_ep, struct usb_request *_req)
 	}
 
 	if (req)
-		done (ep, req, -ECONNRESET);
+		done(ep, req, -ECONNRESET);
 	ep->stopped = stopped;
 
 	if (ep->dma) {
 		/* turn off dma on inactive queues */
-		if (list_empty (&ep->queue))
-			stop_dma (ep->dma);
+		if (list_empty(&ep->queue))
+			stop_dma(ep->dma);
 		else if (!ep->stopped) {
 			/* resume current request, or start new one */
 			if (req)
-				writel (dmactl, &ep->dma->dmactl);
+				writel(dmactl, &ep->dma->dmactl);
 			else
-				start_dma (ep, list_entry (ep->queue.next,
+				start_dma(ep, list_entry(ep->queue.next,
 					struct net2280_request, queue));
 		}
 	}
 
-	spin_unlock_irqrestore (&ep->dev->lock, flags);
+	spin_unlock_irqrestore(&ep->dev->lock, flags);
 	return 0;
 }
 
 /*-------------------------------------------------------------------------*/
 
-static int net2280_fifo_status (struct usb_ep *_ep);
+static int net2280_fifo_status(struct usb_ep *_ep);
 
-static int
-net2280_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedged)
+static int net2280_set_halt_and_wedge(struct usb_ep *_ep,
+						int value, int wedged)
 {
 	struct net2280_ep	*ep;
 	unsigned long		flags;
 	int			retval = 0;
 
-	ep = container_of (_ep, struct net2280_ep, ep);
+	ep = container_of(_ep, struct net2280_ep, ep);
 	if (!_ep || (!ep->desc && ep->num != 0))
 		return -EINVAL;
 	if (!ep->dev->driver || ep->dev->gadget.speed == USB_SPEED_UNKNOWN)
@@ -1374,13 +1372,13 @@ net2280_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedged)
 						== USB_ENDPOINT_XFER_ISOC)
 		return -EINVAL;
 
-	spin_lock_irqsave (&ep->dev->lock, flags);
-	if (!list_empty (&ep->queue))
+	spin_lock_irqsave(&ep->dev->lock, flags);
+	if (!list_empty(&ep->queue))
 		retval = -EAGAIN;
-	else if (ep->is_in && value && net2280_fifo_status (_ep) != 0)
+	else if (ep->is_in && value && net2280_fifo_status(_ep) != 0)
 		retval = -EAGAIN;
 	else {
-		VDEBUG (ep->dev, "%s %s %s\n", _ep->name,
+		VDEBUG(ep->dev, "%s %s %s\n", _ep->name,
 				value ? "set" : "clear",
 				wedged ? "wedge" : "halt");
 		/* set/clear, then synch memory views with the device */
@@ -1388,44 +1386,41 @@ net2280_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedged)
 			if (ep->num == 0)
 				ep->dev->protocol_stall = 1;
 			else
-				set_halt (ep);
+				set_halt(ep);
 			if (wedged)
 				ep->wedged = 1;
 		} else {
-			clear_halt (ep);
+			clear_halt(ep);
 			if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX &&
 				!list_empty(&ep->queue) && ep->td_dma)
 					restart_dma(ep);
 			ep->wedged = 0;
 		}
-		(void) readl (&ep->regs->ep_rsp);
+		(void) readl(&ep->regs->ep_rsp);
 	}
-	spin_unlock_irqrestore (&ep->dev->lock, flags);
+	spin_unlock_irqrestore(&ep->dev->lock, flags);
 
 	return retval;
 }
 
-static int
-net2280_set_halt(struct usb_ep *_ep, int value)
+static int net2280_set_halt(struct usb_ep *_ep, int value)
 {
 	return net2280_set_halt_and_wedge(_ep, value, 0);
 }
 
-static int
-net2280_set_wedge(struct usb_ep *_ep)
+static int net2280_set_wedge(struct usb_ep *_ep)
 {
 	if (!_ep || _ep->name == ep0name)
 		return -EINVAL;
 	return net2280_set_halt_and_wedge(_ep, 1, 1);
 }
 
-static int
-net2280_fifo_status (struct usb_ep *_ep)
+static int net2280_fifo_status(struct usb_ep *_ep)
 {
 	struct net2280_ep	*ep;
 	u32			avail;
 
-	ep = container_of (_ep, struct net2280_ep, ep);
+	ep = container_of(_ep, struct net2280_ep, ep);
 	if (!_ep || (!ep->desc && ep->num != 0))
 		return -ENODEV;
 	if (!ep->dev->driver || ep->dev->gadget.speed == USB_SPEED_UNKNOWN)
@@ -1439,19 +1434,18 @@ net2280_fifo_status (struct usb_ep *_ep)
 	return avail;
 }
 
-static void
-net2280_fifo_flush (struct usb_ep *_ep)
+static void net2280_fifo_flush(struct usb_ep *_ep)
 {
 	struct net2280_ep	*ep;
 
-	ep = container_of (_ep, struct net2280_ep, ep);
+	ep = container_of(_ep, struct net2280_ep, ep);
 	if (!_ep || (!ep->desc && ep->num != 0))
 		return;
 	if (!ep->dev->driver || ep->dev->gadget.speed == USB_SPEED_UNKNOWN)
 		return;
 
 	writel(BIT(FIFO_FLUSH), &ep->regs->ep_stat);
-	(void) readl (&ep->regs->ep_rsp);
+	(void) readl(&ep->regs->ep_rsp);
 }
 
 static const struct usb_ep_ops net2280_ep_ops = {
@@ -1472,7 +1466,7 @@ static const struct usb_ep_ops net2280_ep_ops = {
 
 /*-------------------------------------------------------------------------*/
 
-static int net2280_get_frame (struct usb_gadget *_gadget)
+static int net2280_get_frame(struct usb_gadget *_gadget)
 {
 	struct net2280		*dev;
 	unsigned long		flags;
@@ -1480,14 +1474,14 @@ static int net2280_get_frame (struct usb_gadget *_gadget)
 
 	if (!_gadget)
 		return -ENODEV;
-	dev = container_of (_gadget, struct net2280, gadget);
-	spin_lock_irqsave (&dev->lock, flags);
-	retval = get_idx_reg (dev->regs, REG_FRAME) & 0x03ff;
-	spin_unlock_irqrestore (&dev->lock, flags);
+	dev = container_of(_gadget, struct net2280, gadget);
+	spin_lock_irqsave(&dev->lock, flags);
+	retval = get_idx_reg(dev->regs, REG_FRAME) & 0x03ff;
+	spin_unlock_irqrestore(&dev->lock, flags);
 	return retval;
 }
 
-static int net2280_wakeup (struct usb_gadget *_gadget)
+static int net2280_wakeup(struct usb_gadget *_gadget)
 {
 	struct net2280		*dev;
 	u32			tmp;
@@ -1495,19 +1489,19 @@ static int net2280_wakeup (struct usb_gadget *_gadget)
 
 	if (!_gadget)
 		return 0;
-	dev = container_of (_gadget, struct net2280, gadget);
+	dev = container_of(_gadget, struct net2280, gadget);
 
-	spin_lock_irqsave (&dev->lock, flags);
-	tmp = readl (&dev->usb->usbctl);
+	spin_lock_irqsave(&dev->lock, flags);
+	tmp = readl(&dev->usb->usbctl);
 	if (tmp & BIT(DEVICE_REMOTE_WAKEUP_ENABLE))
 		writel(BIT(GENERATE_RESUME), &dev->usb->usbstat);
-	spin_unlock_irqrestore (&dev->lock, flags);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	/* pci writes may still be posted */
 	return 0;
 }
 
-static int net2280_set_selfpowered (struct usb_gadget *_gadget, int value)
+static int net2280_set_selfpowered(struct usb_gadget *_gadget, int value)
 {
 	struct net2280		*dev;
 	u32			tmp;
@@ -1515,10 +1509,10 @@ static int net2280_set_selfpowered (struct usb_gadget *_gadget, int value)
 
 	if (!_gadget)
 		return 0;
-	dev = container_of (_gadget, struct net2280, gadget);
+	dev = container_of(_gadget, struct net2280, gadget);
 
-	spin_lock_irqsave (&dev->lock, flags);
-	tmp = readl (&dev->usb->usbctl);
+	spin_lock_irqsave(&dev->lock, flags);
+	tmp = readl(&dev->usb->usbctl);
 	if (value) {
 		tmp |= BIT(SELF_POWERED_STATUS);
 		dev->selfpowered = 1;
@@ -1526,8 +1520,8 @@ static int net2280_set_selfpowered (struct usb_gadget *_gadget, int value)
 		tmp &= ~BIT(SELF_POWERED_STATUS);
 		dev->selfpowered = 0;
 	}
-	writel (tmp, &dev->usb->usbctl);
-	spin_unlock_irqrestore (&dev->lock, flags);
+	writel(tmp, &dev->usb->usbctl);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	return 0;
 }
@@ -1540,17 +1534,17 @@ static int net2280_pullup(struct usb_gadget *_gadget, int is_on)
 
 	if (!_gadget)
 		return -ENODEV;
-	dev = container_of (_gadget, struct net2280, gadget);
+	dev = container_of(_gadget, struct net2280, gadget);
 
-	spin_lock_irqsave (&dev->lock, flags);
-	tmp = readl (&dev->usb->usbctl);
+	spin_lock_irqsave(&dev->lock, flags);
+	tmp = readl(&dev->usb->usbctl);
 	dev->softconnect = (is_on != 0);
 	if (is_on)
 		tmp |= BIT(USB_DETECT_ENABLE);
 	else
 		tmp &= ~BIT(USB_DETECT_ENABLE);
-	writel (tmp, &dev->usb->usbctl);
-	spin_unlock_irqrestore (&dev->lock, flags);
+	writel(tmp, &dev->usb->usbctl);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	return 0;
 }
@@ -1582,13 +1576,12 @@ static const struct usb_gadget_ops net2280_ops = {
 static ssize_t function_show(struct device *_dev, struct device_attribute *attr,
 			     char *buf)
 {
-	struct net2280	*dev = dev_get_drvdata (_dev);
+	struct net2280	*dev = dev_get_drvdata(_dev);
 
-	if (!dev->driver
-			|| !dev->driver->function
-			|| strlen (dev->driver->function) > PAGE_SIZE)
+	if (!dev->driver || !dev->driver->function ||
+			strlen(dev->driver->function) > PAGE_SIZE)
 		return 0;
-	return scnprintf (buf, PAGE_SIZE, "%s\n", dev->driver->function);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", dev->driver->function);
 }
 static DEVICE_ATTR_RO(function);
 
@@ -1603,10 +1596,10 @@ static ssize_t registers_show(struct device *_dev,
 	u32			t1, t2;
 	const char		*s;
 
-	dev = dev_get_drvdata (_dev);
+	dev = dev_get_drvdata(_dev);
 	next = buf;
 	size = PAGE_SIZE;
-	spin_lock_irqsave (&dev->lock, flags);
+	spin_lock_irqsave(&dev->lock, flags);
 
 	if (dev->driver)
 		s = dev->driver->driver.name;
@@ -1614,7 +1607,7 @@ static ssize_t registers_show(struct device *_dev,
 		s = "(none)";
 
 	/* Main Control Registers */
-	t = scnprintf (next, size, "%s version " DRIVER_VERSION
+	t = scnprintf(next, size, "%s version " DRIVER_VERSION
 			", chiprev %04x, dma %s\n\n"
 			"devinit %03x fifoctl %08x gadget '%s'\n"
 			"pci irqenb0 %02x irqenb1 %08x "
@@ -1623,19 +1616,19 @@ static ssize_t registers_show(struct device *_dev,
 			use_dma
 				? (use_dma_chaining ? "chaining" : "enabled")
 				: "disabled",
-			readl (&dev->regs->devinit),
-			readl (&dev->regs->fifoctl),
+			readl(&dev->regs->devinit),
+			readl(&dev->regs->fifoctl),
 			s,
-			readl (&dev->regs->pciirqenb0),
-			readl (&dev->regs->pciirqenb1),
-			readl (&dev->regs->irqstat0),
-			readl (&dev->regs->irqstat1));
+			readl(&dev->regs->pciirqenb0),
+			readl(&dev->regs->pciirqenb1),
+			readl(&dev->regs->irqstat0),
+			readl(&dev->regs->irqstat1));
 	size -= t;
 	next += t;
 
 	/* USB Control Registers */
-	t1 = readl (&dev->usb->usbctl);
-	t2 = readl (&dev->usb->usbstat);
+	t1 = readl(&dev->usb->usbctl);
+	t2 = readl(&dev->usb->usbstat);
 	if (t1 & BIT(VBUS_PIN)) {
 		if (t2 & BIT(HIGH_SPEED))
 			s = "high speed";
@@ -1646,11 +1639,11 @@ static ssize_t registers_show(struct device *_dev,
 		/* full speed bit (6) not working?? */
 	} else
 			s = "not attached";
-	t = scnprintf (next, size,
+	t = scnprintf(next, size,
 			"stdrsp %08x usbctl %08x usbstat %08x "
 				"addr 0x%02x (%s)\n",
-			readl (&dev->usb->stdrsp), t1, t2,
-			readl (&dev->usb->ouraddr), s);
+			readl(&dev->usb->stdrsp), t1, t2,
+			readl(&dev->usb->ouraddr), s);
 	size -= t;
 	next += t;
 
@@ -1662,13 +1655,13 @@ static ssize_t registers_show(struct device *_dev,
 	for (i = 0; i < dev->n_ep; i++) {
 		struct net2280_ep	*ep;
 
-		ep = &dev->ep [i];
+		ep = &dev->ep[i];
 		if (i && !ep->desc)
 			continue;
 
 		t1 = readl(&ep->cfg->ep_cfg);
-		t2 = readl (&ep->regs->ep_rsp) & 0xff;
-		t = scnprintf (next, size,
+		t2 = readl(&ep->regs->ep_rsp) & 0xff;
+		t = scnprintf(next, size,
 				"\n%s\tcfg %05x rsp (%02x) %s%s%s%s%s%s%s%s"
 					"irqenb %02x\n",
 				ep->ep.name, t1, t2,
@@ -1688,17 +1681,17 @@ static ssize_t registers_show(struct device *_dev,
 					? "DATA1 " : "DATA0 ",
 				(t2 & BIT(CLEAR_ENDPOINT_HALT))
 					? "HALT " : "",
-				readl (&ep->regs->ep_irqenb));
+				readl(&ep->regs->ep_irqenb));
 		size -= t;
 		next += t;
 
-		t = scnprintf (next, size,
+		t = scnprintf(next, size,
 				"\tstat %08x avail %04x "
 				"(ep%d%s-%s)%s\n",
-				readl (&ep->regs->ep_stat),
-				readl (&ep->regs->ep_avail),
-				t1 & 0x0f, DIR_STRING (t1),
-				type_string (t1 >> 8),
+				readl(&ep->regs->ep_stat),
+				readl(&ep->regs->ep_avail),
+				t1 & 0x0f, DIR_STRING(t1),
+				type_string(t1 >> 8),
 				ep->stopped ? "*" : "");
 		size -= t;
 		next += t;
@@ -1706,42 +1699,41 @@ static ssize_t registers_show(struct device *_dev,
 		if (!ep->dma)
 			continue;
 
-		t = scnprintf (next, size,
+		t = scnprintf(next, size,
 				"  dma\tctl %08x stat %08x count %08x\n"
 				"\taddr %08x desc %08x\n",
-				readl (&ep->dma->dmactl),
-				readl (&ep->dma->dmastat),
-				readl (&ep->dma->dmacount),
-				readl (&ep->dma->dmaaddr),
-				readl (&ep->dma->dmadesc));
+				readl(&ep->dma->dmactl),
+				readl(&ep->dma->dmastat),
+				readl(&ep->dma->dmacount),
+				readl(&ep->dma->dmaaddr),
+				readl(&ep->dma->dmadesc));
 		size -= t;
 		next += t;
 
 	}
 
-	/* Indexed Registers */
-		// none yet
+	/* Indexed Registers (none yet) */
 
 	/* Statistics */
-	t = scnprintf (next, size, "\nirqs:  ");
+	t = scnprintf(next, size, "\nirqs:  ");
 	size -= t;
 	next += t;
 	for (i = 0; i < dev->n_ep; i++) {
 		struct net2280_ep	*ep;
 
-		ep = &dev->ep [i];
+		ep = &dev->ep[i];
 		if (i && !ep->irqs)
 			continue;
-		t = scnprintf (next, size, " %s/%lu", ep->ep.name, ep->irqs);
+		t = scnprintf(next, size, " %s/%lu", ep->ep.name, ep->irqs);
 		size -= t;
 		next += t;
 
 	}
-	t = scnprintf (next, size, "\n");
+	t = scnprintf(next, size, "\n");
 	size -= t;
 	next += t;
 
-	spin_unlock_irqrestore (&dev->lock, flags);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	return PAGE_SIZE - size;
 }
@@ -1756,13 +1748,13 @@ static ssize_t queues_show(struct device *_dev, struct device_attribute *attr,
 	unsigned long		flags;
 	int			i;
 
-	dev = dev_get_drvdata (_dev);
+	dev = dev_get_drvdata(_dev);
 	next = buf;
 	size = PAGE_SIZE;
-	spin_lock_irqsave (&dev->lock, flags);
+	spin_lock_irqsave(&dev->lock, flags);
 
 	for (i = 0; i < dev->n_ep; i++) {
-		struct net2280_ep		*ep = &dev->ep [i];
+		struct net2280_ep		*ep = &dev->ep[i];
 		struct net2280_request		*req;
 		int				t;
 
@@ -1773,40 +1765,40 @@ static ssize_t queues_show(struct device *_dev, struct device_attribute *attr,
 			if (!d)
 				continue;
 			t = d->bEndpointAddress;
-			t = scnprintf (next, size,
+			t = scnprintf(next, size,
 				"\n%s (ep%d%s-%s) max %04x %s fifo %d\n",
 				ep->ep.name, t & USB_ENDPOINT_NUMBER_MASK,
 				(t & USB_DIR_IN) ? "in" : "out",
 				type_string(d->bmAttributes),
-				usb_endpoint_maxp (d) & 0x1fff,
+				usb_endpoint_maxp(d) & 0x1fff,
 				ep->dma ? "dma" : "pio", ep->fifo_size
 				);
 		} else /* ep0 should only have one transfer queued */
-			t = scnprintf (next, size, "ep0 max 64 pio %s\n",
+			t = scnprintf(next, size, "ep0 max 64 pio %s\n",
 					ep->is_in ? "in" : "out");
 		if (t <= 0 || t > size)
 			goto done;
 		size -= t;
 		next += t;
 
-		if (list_empty (&ep->queue)) {
-			t = scnprintf (next, size, "\t(nothing queued)\n");
+		if (list_empty(&ep->queue)) {
+			t = scnprintf(next, size, "\t(nothing queued)\n");
 			if (t <= 0 || t > size)
 				goto done;
 			size -= t;
 			next += t;
 			continue;
 		}
-		list_for_each_entry (req, &ep->queue, queue) {
-			if (ep->dma && req->td_dma == readl (&ep->dma->dmadesc))
-				t = scnprintf (next, size,
+		list_for_each_entry(req, &ep->queue, queue) {
+			if (ep->dma && req->td_dma == readl(&ep->dma->dmadesc))
+				t = scnprintf(next, size,
 					"\treq %p len %d/%d "
 					"buf %p (dmacount %08x)\n",
 					&req->req, req->req.actual,
 					req->req.length, req->req.buf,
-					readl (&ep->dma->dmacount));
+					readl(&ep->dma->dmacount));
 			else
-				t = scnprintf (next, size,
+				t = scnprintf(next, size,
 					"\treq %p len %d/%d buf %p\n",
 					&req->req, req->req.actual,
 					req->req.length, req->req.buf);
@@ -1819,12 +1811,12 @@ static ssize_t queues_show(struct device *_dev, struct device_attribute *attr,
 				struct net2280_dma	*td;
 
 				td = req->td;
-				t = scnprintf (next, size, "\t    td %08x "
+				t = scnprintf(next, size, "\t    td %08x "
 					" count %08x buf %08x desc %08x\n",
 					(u32) req->td_dma,
-					le32_to_cpu (td->dmacount),
-					le32_to_cpu (td->dmaaddr),
-					le32_to_cpu (td->dmadesc));
+					le32_to_cpu(td->dmacount),
+					le32_to_cpu(td->dmaaddr),
+					le32_to_cpu(td->dmadesc));
 				if (t <= 0 || t > size)
 					goto done;
 				size -= t;
@@ -1834,7 +1826,7 @@ static ssize_t queues_show(struct device *_dev, struct device_attribute *attr,
 	}
 
 done:
-	spin_unlock_irqrestore (&dev->lock, flags);
+	spin_unlock_irqrestore(&dev->lock, flags);
 	return PAGE_SIZE - size;
 }
 static DEVICE_ATTR_RO(queues);
@@ -1842,8 +1834,8 @@ static DEVICE_ATTR_RO(queues);
 
 #else
 
-#define device_create_file(a,b)	(0)
-#define device_remove_file(a,b)	do { } while (0)
+#define device_create_file(a, b)	(0)
+#define device_remove_file(a, b)	do { } while (0)
 
 #endif
 
@@ -1853,33 +1845,33 @@ static DEVICE_ATTR_RO(queues);
  * to/from another device fifo instead of to/from memory.
  */
 
-static void set_fifo_mode (struct net2280 *dev, int mode)
+static void set_fifo_mode(struct net2280 *dev, int mode)
 {
 	/* keeping high bits preserves BAR2 */
-	writel ((0xffff << PCI_BASE2_RANGE) | mode, &dev->regs->fifoctl);
+	writel((0xffff << PCI_BASE2_RANGE) | mode, &dev->regs->fifoctl);
 
 	/* always ep-{a,b,e,f} ... maybe not ep-c or ep-d */
-	INIT_LIST_HEAD (&dev->gadget.ep_list);
-	list_add_tail (&dev->ep [1].ep.ep_list, &dev->gadget.ep_list);
-	list_add_tail (&dev->ep [2].ep.ep_list, &dev->gadget.ep_list);
+	INIT_LIST_HEAD(&dev->gadget.ep_list);
+	list_add_tail(&dev->ep[1].ep.ep_list, &dev->gadget.ep_list);
+	list_add_tail(&dev->ep[2].ep.ep_list, &dev->gadget.ep_list);
 	switch (mode) {
 	case 0:
-		list_add_tail (&dev->ep [3].ep.ep_list, &dev->gadget.ep_list);
-		list_add_tail (&dev->ep [4].ep.ep_list, &dev->gadget.ep_list);
-		dev->ep [1].fifo_size = dev->ep [2].fifo_size = 1024;
+		list_add_tail(&dev->ep[3].ep.ep_list, &dev->gadget.ep_list);
+		list_add_tail(&dev->ep[4].ep.ep_list, &dev->gadget.ep_list);
+		dev->ep[1].fifo_size = dev->ep[2].fifo_size = 1024;
 		break;
 	case 1:
-		dev->ep [1].fifo_size = dev->ep [2].fifo_size = 2048;
+		dev->ep[1].fifo_size = dev->ep[2].fifo_size = 2048;
 		break;
 	case 2:
-		list_add_tail (&dev->ep [3].ep.ep_list, &dev->gadget.ep_list);
-		dev->ep [1].fifo_size = 2048;
-		dev->ep [2].fifo_size = 1024;
+		list_add_tail(&dev->ep[3].ep.ep_list, &dev->gadget.ep_list);
+		dev->ep[1].fifo_size = 2048;
+		dev->ep[2].fifo_size = 1024;
 		break;
 	}
 	/* fifo sizes for ep0, ep-c, ep-d, ep-e, and ep-f never change */
-	list_add_tail (&dev->ep [5].ep.ep_list, &dev->gadget.ep_list);
-	list_add_tail (&dev->ep [6].ep.ep_list, &dev->gadget.ep_list);
+	list_add_tail(&dev->ep[5].ep.ep_list, &dev->gadget.ep_list);
+	list_add_tail(&dev->ep[6].ep.ep_list, &dev->gadget.ep_list);
 }
 
 static void defect7374_disable_data_eps(struct net2280 *dev)
@@ -2011,14 +2003,14 @@ static void usb_reset_228x(struct net2280 *dev)
 	u32	tmp;
 
 	dev->gadget.speed = USB_SPEED_UNKNOWN;
-	(void) readl (&dev->usb->usbctl);
+	(void) readl(&dev->usb->usbctl);
 
-	net2280_led_init (dev);
+	net2280_led_init(dev);
 
 	/* disable automatic responses, and irqs */
-	writel (0, &dev->usb->stdrsp);
-	writel (0, &dev->regs->pciirqenb0);
-	writel (0, &dev->regs->pciirqenb1);
+	writel(0, &dev->usb->stdrsp);
+	writel(0, &dev->regs->pciirqenb0);
+	writel(0, &dev->regs->pciirqenb1);
 
 	/* clear old dma and irq state */
 	for (tmp = 0; tmp < 4; tmp++) {
@@ -2027,7 +2019,7 @@ static void usb_reset_228x(struct net2280 *dev)
 			abort_dma(ep);
 	}
 
-	writel (~0, &dev->regs->irqstat0),
+	writel(~0, &dev->regs->irqstat0),
 	writel(~(u32)BIT(SUSPEND_REQUEST_INTERRUPT), &dev->regs->irqstat1),
 
 	/* reset, and enable pci */
@@ -2036,10 +2028,10 @@ static void usb_reset_228x(struct net2280 *dev)
 		BIT(FIFO_SOFT_RESET) |
 		BIT(USB_SOFT_RESET) |
 		BIT(M8051_RESET);
-	writel (tmp, &dev->regs->devinit);
+	writel(tmp, &dev->regs->devinit);
 
 	/* standard fifo and endpoint allocations */
-	set_fifo_mode (dev, (fifo_mode <= 2) ? fifo_mode : 0);
+	set_fifo_mode(dev, (fifo_mode <= 2) ? fifo_mode : 0);
 }
 
 static void usb_reset_338x(struct net2280 *dev)
@@ -2112,35 +2104,35 @@ static void usb_reinit_228x(struct net2280 *dev)
 
 	/* basic endpoint init */
 	for (tmp = 0; tmp < 7; tmp++) {
-		struct net2280_ep	*ep = &dev->ep [tmp];
+		struct net2280_ep	*ep = &dev->ep[tmp];
 
-		ep->ep.name = ep_name [tmp];
+		ep->ep.name = ep_name[tmp];
 		ep->dev = dev;
 		ep->num = tmp;
 
 		if (tmp > 0 && tmp <= 4) {
 			ep->fifo_size = 1024;
 			if (init_dma)
-				ep->dma = &dev->dma [tmp - 1];
+				ep->dma = &dev->dma[tmp - 1];
 		} else
 			ep->fifo_size = 64;
-		ep->regs = &dev->epregs [tmp];
+		ep->regs = &dev->epregs[tmp];
 		ep->cfg = &dev->epregs[tmp];
 		ep_reset_228x(dev->regs, ep);
 	}
-	usb_ep_set_maxpacket_limit(&dev->ep [0].ep, 64);
-	usb_ep_set_maxpacket_limit(&dev->ep [5].ep, 64);
-	usb_ep_set_maxpacket_limit(&dev->ep [6].ep, 64);
+	usb_ep_set_maxpacket_limit(&dev->ep[0].ep, 64);
+	usb_ep_set_maxpacket_limit(&dev->ep[5].ep, 64);
+	usb_ep_set_maxpacket_limit(&dev->ep[6].ep, 64);
 
-	dev->gadget.ep0 = &dev->ep [0].ep;
-	dev->ep [0].stopped = 0;
-	INIT_LIST_HEAD (&dev->gadget.ep0->ep_list);
+	dev->gadget.ep0 = &dev->ep[0].ep;
+	dev->ep[0].stopped = 0;
+	INIT_LIST_HEAD(&dev->gadget.ep0->ep_list);
 
 	/* we want to prevent lowlevel/insecure access from the USB host,
 	 * but erratum 0119 means this enable bit is ignored
 	 */
 	for (tmp = 0; tmp < 5; tmp++)
-		writel (EP_DONTUSE, &dev->dep [tmp].dep_cfg);
+		writel(EP_DONTUSE, &dev->dep[tmp].dep_cfg);
 }
 
 static void usb_reinit_338x(struct net2280 *dev)
@@ -2263,7 +2255,7 @@ static void ep0_start_228x(struct net2280 *dev)
 	writel(BIT(CLEAR_EP_HIDE_STATUS_PHASE) |
 		BIT(CLEAR_NAK_OUT_PACKETS) |
 		BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE)
-		, &dev->epregs [0].ep_rsp);
+		, &dev->epregs[0].ep_rsp);
 
 	/*
 	 * hardware optionally handles a bunch of standard requests
@@ -2298,7 +2290,7 @@ static void ep0_start_228x(struct net2280 *dev)
 		&dev->regs->pciirqenb1);
 
 	/* don't leave any writes posted */
-	(void) readl (&dev->usb->usbctl);
+	(void) readl(&dev->usb->usbctl);
 }
 
 static void ep0_start_338x(struct net2280 *dev)
@@ -2377,20 +2369,22 @@ static int net2280_start(struct usb_gadget *_gadget,
 			|| !driver->setup)
 		return -EINVAL;
 
-	dev = container_of (_gadget, struct net2280, gadget);
+	dev = container_of(_gadget, struct net2280, gadget);
 
 	for (i = 0; i < dev->n_ep; i++)
-		dev->ep [i].irqs = 0;
+		dev->ep[i].irqs = 0;
 
 	/* hook up the driver ... */
 	dev->softconnect = 1;
 	driver->driver.bus = NULL;
 	dev->driver = driver;
 
-	retval = device_create_file (&dev->pdev->dev, &dev_attr_function);
-	if (retval) goto err_unbind;
-	retval = device_create_file (&dev->pdev->dev, &dev_attr_queues);
-	if (retval) goto err_func;
+	retval = device_create_file(&dev->pdev->dev, &dev_attr_function);
+	if (retval)
+		goto err_unbind;
+	retval = device_create_file(&dev->pdev->dev, &dev_attr_queues);
+	if (retval)
+		goto err_func;
 
 	/* Enable force-full-speed testing mode, if desired */
 	if (full_speed && dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
@@ -2399,30 +2393,29 @@ static int net2280_start(struct usb_gadget *_gadget,
 	/* ... then enable host detection and ep0; and we're ready
 	 * for set_configuration as well as eventual disconnect.
 	 */
-	net2280_led_active (dev, 1);
+	net2280_led_active(dev, 1);
 
 	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		defect7374_enable_data_eps_zero(dev);
 
-	ep0_start (dev);
+	ep0_start(dev);
 
-	DEBUG (dev, "%s ready, usbctl %08x stdrsp %08x\n",
+	DEBUG(dev, "%s ready, usbctl %08x stdrsp %08x\n",
 			driver->driver.name,
-			readl (&dev->usb->usbctl),
-			readl (&dev->usb->stdrsp));
+			readl(&dev->usb->usbctl),
+			readl(&dev->usb->stdrsp));
 
 	/* pci writes may still be posted */
 	return 0;
 
 err_func:
-	device_remove_file (&dev->pdev->dev, &dev_attr_function);
+	device_remove_file(&dev->pdev->dev, &dev_attr_function);
 err_unbind:
 	dev->driver = NULL;
 	return retval;
 }
 
-static void
-stop_activity (struct net2280 *dev, struct usb_gadget_driver *driver)
+static void stop_activity(struct net2280 *dev, struct usb_gadget_driver *driver)
 {
 	int			i;
 
@@ -2433,9 +2426,9 @@ stop_activity (struct net2280 *dev, struct usb_gadget_driver *driver)
 	/* stop hardware; prevent new request submissions;
 	 * and kill any outstanding requests.
 	 */
-	usb_reset (dev);
+	usb_reset(dev);
 	for (i = 0; i < dev->n_ep; i++)
-		nuke (&dev->ep [i]);
+		nuke(&dev->ep[i]);
 
 	/* report disconnect; the driver is already quiesced */
 	if (driver) {
@@ -2444,7 +2437,7 @@ stop_activity (struct net2280 *dev, struct usb_gadget_driver *driver)
 		spin_lock(&dev->lock);
 	}
 
-	usb_reinit (dev);
+	usb_reinit(dev);
 }
 
 static int net2280_stop(struct usb_gadget *_gadget,
@@ -2453,22 +2446,22 @@ static int net2280_stop(struct usb_gadget *_gadget,
 	struct net2280	*dev;
 	unsigned long	flags;
 
-	dev = container_of (_gadget, struct net2280, gadget);
+	dev = container_of(_gadget, struct net2280, gadget);
 
-	spin_lock_irqsave (&dev->lock, flags);
-	stop_activity (dev, driver);
-	spin_unlock_irqrestore (&dev->lock, flags);
+	spin_lock_irqsave(&dev->lock, flags);
+	stop_activity(dev, driver);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	dev->driver = NULL;
 
-	net2280_led_active (dev, 0);
+	net2280_led_active(dev, 0);
 
 	/* Disable full-speed test mode */
 	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		writel(0, &dev->usb->xcvrdiag);
 
-	device_remove_file (&dev->pdev->dev, &dev_attr_function);
-	device_remove_file (&dev->pdev->dev, &dev_attr_queues);
+	device_remove_file(&dev->pdev->dev, &dev_attr_function);
+	device_remove_file(&dev->pdev->dev, &dev_attr_queues);
 
 	DEBUG(dev, "unregistered driver '%s'\n",
 			driver ? driver->driver.name : "");
@@ -2482,31 +2475,31 @@ static int net2280_stop(struct usb_gadget *_gadget,
  * also works for dma-capable endpoints, in pio mode or just
  * to manually advance the queue after short OUT transfers.
  */
-static void handle_ep_small (struct net2280_ep *ep)
+static void handle_ep_small(struct net2280_ep *ep)
 {
 	struct net2280_request	*req;
 	u32			t;
 	/* 0 error, 1 mid-data, 2 done */
 	int			mode = 1;
 
-	if (!list_empty (&ep->queue))
-		req = list_entry (ep->queue.next,
+	if (!list_empty(&ep->queue))
+		req = list_entry(ep->queue.next,
 			struct net2280_request, queue);
 	else
 		req = NULL;
 
 	/* ack all, and handle what we care about */
-	t = readl (&ep->regs->ep_stat);
+	t = readl(&ep->regs->ep_stat);
 	ep->irqs++;
 #if 0
-	VDEBUG (ep->dev, "%s ack ep_stat %08x, req %p\n",
+	VDEBUG(ep->dev, "%s ack ep_stat %08x, req %p\n",
 			ep->ep.name, t, req ? &req->req : 0);
 #endif
 	if (!ep->is_in || ep->dev->pdev->device == 0x2280)
 		writel(t & ~BIT(NAK_OUT_PACKETS), &ep->regs->ep_stat);
 	else
 		/* Added for 2282 */
-		writel (t, &ep->regs->ep_stat);
+		writel(t, &ep->regs->ep_stat);
 
 	/* for ep0, monitor token irqs to catch data stage length errors
 	 * and to synchronize on status.
@@ -2518,33 +2511,33 @@ static void handle_ep_small (struct net2280_ep *ep)
 	 * control requests could be slightly faster without token synch for
 	 * status, but status can jam up that way.
 	 */
-	if (unlikely (ep->num == 0)) {
+	if (unlikely(ep->num == 0)) {
 		if (ep->is_in) {
 			/* status; stop NAKing */
 			if (t & BIT(DATA_OUT_PING_TOKEN_INTERRUPT)) {
 				if (ep->dev->protocol_stall) {
 					ep->stopped = 1;
-					set_halt (ep);
+					set_halt(ep);
 				}
 				if (!req)
-					allow_status (ep);
+					allow_status(ep);
 				mode = 2;
 			/* reply to extra IN data tokens with a zlp */
 			} else if (t & BIT(DATA_IN_TOKEN_INTERRUPT)) {
 				if (ep->dev->protocol_stall) {
 					ep->stopped = 1;
-					set_halt (ep);
+					set_halt(ep);
 					mode = 2;
 				} else if (ep->responded &&
 						!req && !ep->stopped)
-					write_fifo (ep, NULL);
+					write_fifo(ep, NULL);
 			}
 		} else {
 			/* status; stop NAKing */
 			if (t & BIT(DATA_IN_TOKEN_INTERRUPT)) {
 				if (ep->dev->protocol_stall) {
 					ep->stopped = 1;
-					set_halt (ep);
+					set_halt(ep);
 				}
 				mode = 2;
 			/* an extra OUT token is an error */
@@ -2553,20 +2546,20 @@ static void handle_ep_small (struct net2280_ep *ep)
 					&& req->req.actual == req->req.length)
 					|| (ep->responded && !req)) {
 				ep->dev->protocol_stall = 1;
-				set_halt (ep);
+				set_halt(ep);
 				ep->stopped = 1;
 				if (req)
-					done (ep, req, -EOVERFLOW);
+					done(ep, req, -EOVERFLOW);
 				req = NULL;
 			}
 		}
 	}
 
-	if (unlikely (!req))
+	if (unlikely(!req))
 		return;
 
 	/* manual DMA queue advance after short OUT */
-	if (likely (ep->dma)) {
+	if (likely(ep->dma)) {
 		if (t & BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT)) {
 			u32	count;
 			int	stopped = ep->stopped;
@@ -2576,27 +2569,27 @@ static void handle_ep_small (struct net2280_ep *ep)
 			 * iff (M < N) we won't ever see a DMA interrupt.
 			 */
 			ep->stopped = 1;
-			for (count = 0; ; t = readl (&ep->regs->ep_stat)) {
+			for (count = 0; ; t = readl(&ep->regs->ep_stat)) {
 
 				/* any preceding dma transfers must finish.
 				 * dma handles (M >= N), may empty the queue
 				 */
-				scan_dma_completions (ep);
-				if (unlikely (list_empty (&ep->queue)
+				scan_dma_completions(ep);
+				if (unlikely(list_empty(&ep->queue)
 						|| ep->out_overflow)) {
 					req = NULL;
 					break;
 				}
-				req = list_entry (ep->queue.next,
+				req = list_entry(ep->queue.next,
 					struct net2280_request, queue);
 
 				/* here either (M < N), a "real" short rx;
 				 * or (M == N) and the queue didn't empty
 				 */
 				if (likely(t & BIT(FIFO_EMPTY))) {
-					count = readl (&ep->dma->dmacount);
+					count = readl(&ep->dma->dmacount);
 					count &= DMA_BYTE_COUNT_MASK;
-					if (readl (&ep->dma->dmadesc)
+					if (readl(&ep->dma->dmadesc)
 							!= req->td_dma)
 						req = NULL;
 					break;
@@ -2606,37 +2599,37 @@ static void handle_ep_small (struct net2280_ep *ep)
 
 			/* stop DMA, leave ep NAKing */
 			writel(BIT(DMA_ABORT), &ep->dma->dmastat);
-			spin_stop_dma (ep->dma);
+			spin_stop_dma(ep->dma);
 
-			if (likely (req)) {
+			if (likely(req)) {
 				req->td->dmacount = 0;
-				t = readl (&ep->regs->ep_avail);
-				dma_done (ep, req, count,
+				t = readl(&ep->regs->ep_avail);
+				dma_done(ep, req, count,
 					(ep->out_overflow || t)
 						? -EOVERFLOW : 0);
 			}
 
 			/* also flush to prevent erratum 0106 trouble */
-			if (unlikely (ep->out_overflow
+			if (unlikely(ep->out_overflow
 					|| (ep->dev->chiprev == 0x0100
 						&& ep->dev->gadget.speed
 							== USB_SPEED_FULL))) {
-				out_flush (ep);
+				out_flush(ep);
 				ep->out_overflow = 0;
 			}
 
 			/* (re)start dma if needed, stop NAKing */
 			ep->stopped = stopped;
-			if (!list_empty (&ep->queue))
-				restart_dma (ep);
+			if (!list_empty(&ep->queue))
+				restart_dma(ep);
 		} else
-			DEBUG (ep->dev, "%s dma ep_stat %08x ??\n",
+			DEBUG(ep->dev, "%s dma ep_stat %08x ??\n",
 					ep->ep.name, t);
 		return;
 
 	/* data packet(s) received (in the fifo, OUT) */
 	} else if (t & BIT(DATA_PACKET_RECEIVED_INTERRUPT)) {
-		if (read_fifo (ep, req) && ep->num != 0)
+		if (read_fifo(ep, req) && ep->num != 0)
 			mode = 2;
 
 	/* data packet(s) transmitted (IN) */
@@ -2649,12 +2642,10 @@ static void handle_ep_small (struct net2280_ep *ep)
 		req->req.actual += len;
 
 		/* if we wrote it all, we're usually done */
-		if (req->req.actual == req->req.length) {
-			if (ep->num == 0) {
-				/* send zlps until the status stage */
-			} else if (!req->req.zero || len != ep->ep.maxpacket)
+		/* send zlps until the status stage */
+		if ((req->req.actual == req->req.length) &&
+			(!req->req.zero || len != ep->ep.maxpacket) && ep->num)
 				mode = 2;
-		}
 
 	/* there was nothing to do ...  */
 	} else if (mode == 1)
@@ -2663,7 +2654,7 @@ static void handle_ep_small (struct net2280_ep *ep)
 	/* done */
 	if (mode == 2) {
 		/* stream endpoints often resubmit/unlink in completion */
-		done (ep, req, 0);
+		done(ep, req, 0);
 
 		/* maybe advance queue to next request */
 		if (ep->num == 0) {
@@ -2672,16 +2663,16 @@ static void handle_ep_small (struct net2280_ep *ep)
 			 * them control that, the api doesn't (yet) allow it.
 			 */
 			if (!ep->stopped)
-				allow_status (ep);
+				allow_status(ep);
 			req = NULL;
 		} else {
-			if (!list_empty (&ep->queue) && !ep->stopped)
-				req = list_entry (ep->queue.next,
+			if (!list_empty(&ep->queue) && !ep->stopped)
+				req = list_entry(ep->queue.next,
 					struct net2280_request, queue);
 			else
 				req = NULL;
 			if (req && !ep->is_in)
-				stop_out_naking (ep);
+				stop_out_naking(ep);
 		}
 	}
 
@@ -2692,18 +2683,17 @@ static void handle_ep_small (struct net2280_ep *ep)
 
 		/* load IN fifo with next packet (may be zlp) */
 		if (t & BIT(DATA_PACKET_TRANSMITTED_INTERRUPT))
-			write_fifo (ep, &req->req);
+			write_fifo(ep, &req->req);
 	}
 }
 
-static struct net2280_ep *
-get_ep_by_addr (struct net2280 *dev, u16 wIndex)
+static struct net2280_ep *get_ep_by_addr(struct net2280 *dev, u16 wIndex)
 {
 	struct net2280_ep	*ep;
 
 	if ((wIndex & USB_ENDPOINT_NUMBER_MASK) == 0)
-		return &dev->ep [0];
-	list_for_each_entry (ep, &dev->gadget.ep_list, ep.ep_list) {
+		return &dev->ep[0];
+	list_for_each_entry(ep, &dev->gadget.ep_list, ep.ep_list) {
 		u8	bEndpointAddress;
 
 		if (!ep->desc)
@@ -3061,7 +3051,7 @@ next_endpoints3:
 	return;
 }
 
-static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
+static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 {
 	struct net2280_ep	*ep;
 	u32			num, scratch;
@@ -3070,12 +3060,12 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 	stat &= ~BIT(INTA_ASSERTED);
 	if (!stat)
 		return;
-	// DEBUG (dev, "irqstat0 %04x\n", stat);
+	/* DEBUG(dev, "irqstat0 %04x\n", stat); */
 
 	/* starting a control request? */
 	if (unlikely(stat & BIT(SETUP_PACKET_INTERRUPT))) {
 		union {
-			u32			raw [2];
+			u32			raw[2];
 			struct usb_ctrlrequest	r;
 		} u;
 		int				tmp;
@@ -3096,19 +3086,20 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 				usb_ep_set_maxpacket_limit(&dev->ep[0].ep,
 						EP0_HS_MAX_PACKET_SIZE);
 			}
-			net2280_led_speed (dev, dev->gadget.speed);
-			DEBUG(dev, "%s\n", usb_speed_string(dev->gadget.speed));
+			net2280_led_speed(dev, dev->gadget.speed);
+			DEBUG(dev, "%s\n",
+					usb_speed_string(dev->gadget.speed));
 		}
 
-		ep = &dev->ep [0];
+		ep = &dev->ep[0];
 		ep->irqs++;
 
 		/* make sure any leftover request state is cleared */
 		stat &= ~BIT(ENDPOINT_0_INTERRUPT);
-		while (!list_empty (&ep->queue)) {
-			req = list_entry (ep->queue.next,
+		while (!list_empty(&ep->queue)) {
+			req = list_entry(ep->queue.next,
 					struct net2280_request, queue);
-			done (ep, req, (req->req.actual == req->req.length)
+			done(ep, req, (req->req.actual == req->req.length)
 						? 0 : -EPROTO);
 		}
 		ep->stopped = 0;
@@ -3139,8 +3130,8 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 		u.raw[0] = readl(&dev->usb->setup0123);
 		u.raw[1] = readl(&dev->usb->setup4567);
 
-		cpu_to_le32s (&u.raw [0]);
-		cpu_to_le32s (&u.raw [1]);
+		cpu_to_le32s(&u.raw[0]);
+		cpu_to_le32s(&u.raw[1]);
 
 		if (dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 			defect7374_workaround(dev, u.r);
@@ -3165,12 +3156,12 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			scratch = BIT(DATA_PACKET_TRANSMITTED_INTERRUPT) |
 				BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
 				BIT(DATA_IN_TOKEN_INTERRUPT);
-			stop_out_naking (ep);
+			stop_out_naking(ep);
 		} else
 			scratch = BIT(DATA_PACKET_RECEIVED_INTERRUPT) |
 				BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
 				BIT(DATA_IN_TOKEN_INTERRUPT);
-		writel (scratch, &dev->epregs [0].ep_irqenb);
+		writel(scratch, &dev->epregs[0].ep_irqenb);
 
 		/* we made the hardware handle most lowlevel requests;
 		 * everything else goes uplevel to the gadget code.
@@ -3190,21 +3181,21 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			/* hw handles device and interface status */
 			if (u.r.bRequestType != (USB_DIR_IN|USB_RECIP_ENDPOINT))
 				goto delegate;
-			if ((e = get_ep_by_addr (dev, w_index)) == NULL
-					|| w_length > 2)
+			e = get_ep_by_addr(dev, w_index);
+			if (!e || w_length > 2)
 				goto do_stall;
 
 			if (readl(&e->regs->ep_rsp) & BIT(SET_ENDPOINT_HALT))
-				status = cpu_to_le32 (1);
+				status = cpu_to_le32(1);
 			else
-				status = cpu_to_le32 (0);
+				status = cpu_to_le32(0);
 
 			/* don't bother with a request object! */
-			writel (0, &dev->epregs [0].ep_irqenb);
-			set_fifo_bytecount (ep, w_length);
-			writel ((__force u32)status, &dev->epregs [0].ep_data);
-			allow_status (ep);
-			VDEBUG (dev, "%s stat %02x\n", ep->ep.name, status);
+			writel(0, &dev->epregs[0].ep_irqenb);
+			set_fifo_bytecount(ep, w_length);
+			writel((__force u32)status, &dev->epregs[0].ep_data);
+			allow_status(ep);
+			VDEBUG(dev, "%s stat %02x\n", ep->ep.name, status);
 			goto next_endpoints;
 			}
 			break;
@@ -3217,7 +3208,8 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			if (w_value != USB_ENDPOINT_HALT
 					|| w_length != 0)
 				goto do_stall;
-			if ((e = get_ep_by_addr (dev, w_index)) == NULL)
+			e = get_ep_by_addr(dev, w_index);
+			if (!e)
 				goto do_stall;
 			if (e->wedged) {
 				VDEBUG(dev, "%s wedged, halt not cleared\n",
@@ -3230,7 +3222,7 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 					!list_empty(&e->queue) && e->td_dma)
 						restart_dma(e);
 			}
-			allow_status (ep);
+			allow_status(ep);
 			goto next_endpoints;
 			}
 			break;
@@ -3243,35 +3235,36 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			if (w_value != USB_ENDPOINT_HALT
 					|| w_length != 0)
 				goto do_stall;
-			if ((e = get_ep_by_addr (dev, w_index)) == NULL)
+			e = get_ep_by_addr(dev, w_index);
+			if (!e)
 				goto do_stall;
 			if (e->ep.name == ep0name)
 				goto do_stall;
-			set_halt (e);
+			set_halt(e);
 			if (dev->pdev->vendor == PCI_VENDOR_ID_PLX && e->dma)
 				abort_dma(e);
-			allow_status (ep);
-			VDEBUG (dev, "%s set halt\n", ep->ep.name);
+			allow_status(ep);
+			VDEBUG(dev, "%s set halt\n", ep->ep.name);
 			goto next_endpoints;
 			}
 			break;
 		default:
 delegate:
-			VDEBUG (dev, "setup %02x.%02x v%04x i%04x l%04x "
+			VDEBUG(dev, "setup %02x.%02x v%04x i%04x l%04x "
 				"ep_cfg %08x\n",
 				u.r.bRequestType, u.r.bRequest,
 				w_value, w_index, w_length,
 				readl(&ep->cfg->ep_cfg));
 			ep->responded = 0;
-			spin_unlock (&dev->lock);
-			tmp = dev->driver->setup (&dev->gadget, &u.r);
-			spin_lock (&dev->lock);
+			spin_unlock(&dev->lock);
+			tmp = dev->driver->setup(&dev->gadget, &u.r);
+			spin_lock(&dev->lock);
 		}
 
 		/* stall ep0 on error */
 		if (tmp < 0) {
 do_stall:
-			VDEBUG (dev, "req %02x.%02x protocol STALL; stat %d\n",
+			VDEBUG(dev, "req %02x.%02x protocol STALL; stat %d\n",
 					u.r.bRequestType, u.r.bRequest, tmp);
 			dev->protocol_stall = 1;
 		}
@@ -3299,12 +3292,12 @@ next_endpoints:
 			continue;
 		scratch ^= t;
 
-		ep = &dev->ep [num];
-		handle_ep_small (ep);
+		ep = &dev->ep[num];
+		handle_ep_small(ep);
 	}
 
 	if (stat)
-		DEBUG (dev, "unhandled irqstat0 %08x\n", stat);
+		DEBUG(dev, "unhandled irqstat0 %08x\n", stat);
 }
 
 #define DMA_INTERRUPTS (BIT(DMA_D_INTERRUPT) | \
@@ -3316,7 +3309,7 @@ next_endpoints:
 		BIT(PCI_TARGET_ABORT_RECEIVED_INTERRUPT) | \
 		BIT(PCI_RETRY_ABORT_INTERRUPT))
 
-static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
+static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 {
 	struct net2280_ep	*ep;
 	u32			tmp, num, mask, scratch;
@@ -3331,17 +3324,17 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 	 * only indicates a change in the reset state).
 	 */
 	if (stat & tmp) {
-		writel (tmp, &dev->regs->irqstat1);
+		writel(tmp, &dev->regs->irqstat1);
 		if ((((stat & BIT(ROOT_PORT_RESET_INTERRUPT))
-					&& ((readl (&dev->usb->usbstat) & mask)
+					&& ((readl(&dev->usb->usbstat) & mask)
 							== 0))
-				|| ((readl (&dev->usb->usbctl)
+				|| ((readl(&dev->usb->usbctl)
 					& BIT(VBUS_PIN)) == 0)
-			    ) && ( dev->gadget.speed != USB_SPEED_UNKNOWN)) {
-			DEBUG (dev, "disconnect %s\n",
+			    ) && (dev->gadget.speed != USB_SPEED_UNKNOWN)) {
+			DEBUG(dev, "disconnect %s\n",
 					dev->driver->driver.name);
-			stop_activity (dev, dev->driver);
-			ep0_start (dev);
+			stop_activity(dev, dev->driver);
+			ep0_start(dev);
 			return;
 		}
 		stat &= ~tmp;
@@ -3358,15 +3351,15 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 	 */
 	tmp = BIT(SUSPEND_REQUEST_CHANGE_INTERRUPT);
 	if (stat & tmp) {
-		writel (tmp, &dev->regs->irqstat1);
+		writel(tmp, &dev->regs->irqstat1);
 		if (stat & BIT(SUSPEND_REQUEST_INTERRUPT)) {
 			if (dev->driver->suspend)
-				dev->driver->suspend (&dev->gadget);
+				dev->driver->suspend(&dev->gadget);
 			if (!enable_suspend)
 				stat &= ~BIT(SUSPEND_REQUEST_INTERRUPT);
 		} else {
 			if (dev->driver->resume)
-				dev->driver->resume (&dev->gadget);
+				dev->driver->resume(&dev->gadget);
 			/* at high speed, note erratum 0133 */
 		}
 		stat &= ~tmp;
@@ -3374,7 +3367,7 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 
 	/* clear any other status/irqs */
 	if (stat)
-		writel (stat, &dev->regs->irqstat1);
+		writel(stat, &dev->regs->irqstat1);
 
 	/* some status we can just ignore */
 	if (dev->pdev->device == 0x2280)
@@ -3390,7 +3383,7 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 
 	if (!stat)
 		return;
-	// DEBUG (dev, "irqstat1 %08x\n", stat);
+	/* DEBUG(dev, "irqstat1 %08x\n", stat);*/
 
 	/* DMA status, for ep-{a,b,c,d} */
 	scratch = stat & DMA_INTERRUPTS;
@@ -3404,15 +3397,15 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 			continue;
 		scratch ^= tmp;
 
-		ep = &dev->ep [num + 1];
+		ep = &dev->ep[num + 1];
 		dma = ep->dma;
 
 		if (!dma)
 			continue;
 
 		/* clear ep's dma status */
-		tmp = readl (&dma->dmastat);
-		writel (tmp, &dma->dmastat);
+		tmp = readl(&dma->dmastat);
+		writel(tmp, &dma->dmastat);
 
 		/* dma sync*/
 		if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
@@ -3427,11 +3420,11 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 		 */
 		if (!use_dma_chaining) {
 			if (!(tmp & BIT(DMA_TRANSACTION_DONE_INTERRUPT))) {
-				DEBUG (ep->dev, "%s no xact done? %08x\n",
+				DEBUG(ep->dev, "%s no xact done? %08x\n",
 					ep->ep.name, tmp);
 				continue;
 			}
-			stop_dma (ep->dma);
+			stop_dma(ep->dma);
 		}
 
 		/* OUT transfers terminate when the data from the
@@ -3444,16 +3437,16 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 		 * long time ... we ignore that for now, accounting
 		 * precisely (like PIO does) needs per-packet irqs
 		 */
-		scan_dma_completions (ep);
+		scan_dma_completions(ep);
 
 		/* disable dma on inactive queues; else maybe restart */
-		if (list_empty (&ep->queue)) {
+		if (list_empty(&ep->queue)) {
 			if (use_dma_chaining)
-				stop_dma (ep->dma);
+				stop_dma(ep->dma);
 		} else {
-			tmp = readl (&dma->dmactl);
+			tmp = readl(&dma->dmactl);
 			if (!use_dma_chaining || (tmp & BIT(DMA_ENABLE)) == 0)
-				restart_dma (ep);
+				restart_dma(ep);
 			else if (ep->is_in && use_dma_chaining) {
 				struct net2280_request	*req;
 				__le32			dmacount;
@@ -3463,13 +3456,13 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 				 * used to trigger changing DMA_FIFO_VALIDATE
 				 * (affects automagic zlp writes).
 				 */
-				req = list_entry (ep->queue.next,
+				req = list_entry(ep->queue.next,
 						struct net2280_request, queue);
 				dmacount = req->td->dmacount;
 				dmacount &= cpu_to_le32(BIT(VALID_BIT) |
 						DMA_BYTE_COUNT_MASK);
 				if (dmacount && (dmacount & valid_bit) == 0)
-					restart_dma (ep);
+					restart_dma(ep);
 			}
 		}
 		ep->irqs++;
@@ -3479,21 +3472,21 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 	 * if they appear very often, here's where to try recovering.
 	 */
 	if (stat & PCI_ERROR_INTERRUPTS) {
-		ERROR (dev, "pci dma error; stat %08x\n", stat);
+		ERROR(dev, "pci dma error; stat %08x\n", stat);
 		stat &= ~PCI_ERROR_INTERRUPTS;
 		/* these are fatal errors, but "maybe" they won't
 		 * happen again ...
 		 */
-		stop_activity (dev, dev->driver);
-		ep0_start (dev);
+		stop_activity(dev, dev->driver);
+		ep0_start(dev);
 		stat = 0;
 	}
 
 	if (stat)
-		DEBUG (dev, "unhandled irqstat1 %08x\n", stat);
+		DEBUG(dev, "unhandled irqstat1 %08x\n", stat);
 }
 
-static irqreturn_t net2280_irq (int irq, void *_dev)
+static irqreturn_t net2280_irq(int irq, void *_dev)
 {
 	struct net2280		*dev = _dev;
 
@@ -3502,13 +3495,13 @@ static irqreturn_t net2280_irq (int irq, void *_dev)
 		(!(readl(&dev->regs->irqstat0) & BIT(INTA_ASSERTED))))
 		return IRQ_NONE;
 
-	spin_lock (&dev->lock);
+	spin_lock(&dev->lock);
 
 	/* handle disconnect, dma, and more */
-	handle_stat1_irqs (dev, readl (&dev->regs->irqstat1));
+	handle_stat1_irqs(dev, readl(&dev->regs->irqstat1));
 
 	/* control requests and PIO */
-	handle_stat0_irqs (dev, readl (&dev->regs->irqstat0));
+	handle_stat0_irqs(dev, readl(&dev->regs->irqstat0));
 
 	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
 		/* re-enable interrupt to trigger any possible new interrupt */
@@ -3517,54 +3510,54 @@ static irqreturn_t net2280_irq (int irq, void *_dev)
 		writel(pciirqenb1, &dev->regs->pciirqenb1);
 	}
 
-	spin_unlock (&dev->lock);
+	spin_unlock(&dev->lock);
 
 	return IRQ_HANDLED;
 }
 
 /*-------------------------------------------------------------------------*/
 
-static void gadget_release (struct device *_dev)
+static void gadget_release(struct device *_dev)
 {
-	struct net2280	*dev = dev_get_drvdata (_dev);
+	struct net2280	*dev = dev_get_drvdata(_dev);
 
-	kfree (dev);
+	kfree(dev);
 }
 
 /* tear down the binding between this driver and the pci device */
 
-static void net2280_remove (struct pci_dev *pdev)
+static void net2280_remove(struct pci_dev *pdev)
 {
-	struct net2280		*dev = pci_get_drvdata (pdev);
+	struct net2280		*dev = pci_get_drvdata(pdev);
 
 	usb_del_gadget_udc(&dev->gadget);
 
 	BUG_ON(dev->driver);
 
 	/* then clean up the resources we allocated during probe() */
-	net2280_led_shutdown (dev);
+	net2280_led_shutdown(dev);
 	if (dev->requests) {
 		int		i;
 		for (i = 1; i < 5; i++) {
-			if (!dev->ep [i].dummy)
+			if (!dev->ep[i].dummy)
 				continue;
-			pci_pool_free (dev->requests, dev->ep [i].dummy,
-					dev->ep [i].td_dma);
+			pci_pool_free(dev->requests, dev->ep[i].dummy,
+					dev->ep[i].td_dma);
 		}
-		pci_pool_destroy (dev->requests);
+		pci_pool_destroy(dev->requests);
 	}
 	if (dev->got_irq)
-		free_irq (pdev->irq, dev);
+		free_irq(pdev->irq, dev);
 	if (use_msi && dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		pci_disable_msi(pdev);
 	if (dev->regs)
-		iounmap (dev->regs);
+		iounmap(dev->regs);
 	if (dev->region)
-		release_mem_region (pci_resource_start (pdev, 0),
-				pci_resource_len (pdev, 0));
+		release_mem_region(pci_resource_start(pdev, 0),
+				pci_resource_len(pdev, 0));
 	if (dev->enabled)
-		pci_disable_device (pdev);
-	device_remove_file (&pdev->dev, &dev_attr_registers);
+		pci_disable_device(pdev);
+	device_remove_file(&pdev->dev, &dev_attr_registers);
 
 	INFO (dev, "unbind\n");
 }
@@ -3573,7 +3566,7 @@ static void net2280_remove (struct pci_dev *pdev)
  * don't respond over USB until a gadget driver binds to us.
  */
 
-static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
+static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct net2280		*dev;
 	unsigned long		resource, len;
@@ -3584,14 +3577,14 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 		use_dma_chaining = 0;
 
 	/* alloc, and start init */
-	dev = kzalloc (sizeof *dev, GFP_KERNEL);
-	if (dev == NULL){
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
 		retval = -ENOMEM;
 		goto done;
 	}
 
-	pci_set_drvdata (pdev, dev);
-	spin_lock_init (&dev->lock);
+	pci_set_drvdata(pdev, dev);
+	spin_lock_init(&dev->lock);
 	dev->pdev = pdev;
 	dev->gadget.ops = &net2280_ops;
 	dev->gadget.max_speed = (dev->pdev->vendor == PCI_VENDOR_ID_PLX) ?
@@ -3601,8 +3594,8 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->gadget.name = driver_name;
 
 	/* now all the pci goodies ... */
-	if (pci_enable_device (pdev) < 0) {
-	        retval = -ENODEV;
+	if (pci_enable_device(pdev) < 0) {
+		retval = -ENODEV;
 		goto done;
 	}
 	dev->enabled = 1;
@@ -3611,10 +3604,10 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	 * BAR 1 is 8051 memory; unused here (note erratum 0103)
 	 * BAR 2 is fifo memory; unused here
 	 */
-	resource = pci_resource_start (pdev, 0);
-	len = pci_resource_len (pdev, 0);
-	if (!request_mem_region (resource, len, driver_name)) {
-		DEBUG (dev, "controller already in use\n");
+	resource = pci_resource_start(pdev, 0);
+	len = pci_resource_len(pdev, 0);
+	if (!request_mem_region(resource, len, driver_name)) {
+		DEBUG(dev, "controller already in use\n");
 		retval = -EBUSY;
 		goto done;
 	}
@@ -3624,9 +3617,9 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	 * 8051 code into the chip, e.g. to turn on PCI PM.
 	 */
 
-	base = ioremap_nocache (resource, len);
+	base = ioremap_nocache(resource, len);
 	if (base == NULL) {
-		DEBUG (dev, "can't map memory\n");
+		DEBUG(dev, "can't map memory\n");
 		retval = -EFAULT;
 		goto done;
 	}
@@ -3655,7 +3648,7 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 		dev->plregs = (struct usb338x_pl_regs __iomem *)
 							(base + 0x0800);
 		usbstat = readl(&dev->usb->usbstat);
-		dev->enhanced_mode = (usbstat & BIT(11)) ? 1 : 0;
+		dev->enhanced_mode = !!(usbstat & BIT(11));
 		dev->n_ep = (dev->enhanced_mode) ? 9 : 5;
 		/* put into initial config, link up all endpoints */
 		fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
@@ -3670,12 +3663,12 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 		writel(0, &dev->usb->usbctl);
 	}
 
-	usb_reset (dev);
-	usb_reinit (dev);
+	usb_reset(dev);
+	usb_reinit(dev);
 
 	/* irq setup after old hardware is cleaned up */
 	if (!pdev->irq) {
-		ERROR (dev, "No IRQ.  Check PCI setup!\n");
+		ERROR(dev, "No IRQ.  Check PCI setup!\n");
 		retval = -ENODEV;
 		goto done;
 	}
@@ -3684,9 +3677,9 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 		if (pci_enable_msi(pdev))
 			ERROR(dev, "Failed to enable MSI mode\n");
 
-	if (request_irq (pdev->irq, net2280_irq, IRQF_SHARED, driver_name, dev)
-			!= 0) {
-		ERROR (dev, "request interrupt %d failed\n", pdev->irq);
+	if (request_irq(pdev->irq, net2280_irq, IRQF_SHARED,
+							driver_name, dev)) {
+		ERROR(dev, "request interrupt %d failed\n", pdev->irq);
 		retval = -EBUSY;
 		goto done;
 	}
@@ -3694,28 +3687,28 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* DMA setup */
 	/* NOTE:  we know only the 32 LSBs of dma addresses may be nonzero */
-	dev->requests = pci_pool_create ("requests", pdev,
-		sizeof (struct net2280_dma),
+	dev->requests = pci_pool_create("requests", pdev,
+		sizeof(struct net2280_dma),
 		0 /* no alignment requirements */,
 		0 /* or page-crossing issues */);
 	if (!dev->requests) {
-		DEBUG (dev, "can't get request pool\n");
+		DEBUG(dev, "can't get request pool\n");
 		retval = -ENOMEM;
 		goto done;
 	}
 	for (i = 1; i < 5; i++) {
 		struct net2280_dma	*td;
 
-		td = pci_pool_alloc (dev->requests, GFP_KERNEL,
-				&dev->ep [i].td_dma);
+		td = pci_pool_alloc(dev->requests, GFP_KERNEL,
+				&dev->ep[i].td_dma);
 		if (!td) {
-			DEBUG (dev, "can't get dummy %d\n", i);
+			DEBUG(dev, "can't get dummy %d\n", i);
 			retval = -ENOMEM;
 			goto done;
 		}
 		td->dmacount = 0;	/* not VALID */
 		td->dmadesc = td->dmaaddr;
-		dev->ep [i].dummy = td;
+		dev->ep[i].dummy = td;
 	}
 
 	/* enable lower-overhead pci memory bursts during DMA */
@@ -3729,22 +3722,23 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 			BIT(DMA_READ_LINE_ENABLE),
 			&dev->pci->pcimstctl);
 	/* erratum 0115 shouldn't appear: Linux inits PCI_LATENCY_TIMER */
-	pci_set_master (pdev);
-	pci_try_set_mwi (pdev);
+	pci_set_master(pdev);
+	pci_try_set_mwi(pdev);
 
 	/* ... also flushes any posted pci writes */
-	dev->chiprev = get_idx_reg (dev->regs, REG_CHIPREV) & 0xffff;
+	dev->chiprev = get_idx_reg(dev->regs, REG_CHIPREV) & 0xffff;
 
 	/* done */
-	INFO (dev, "%s\n", driver_desc);
-	INFO (dev, "irq %d, pci mem %p, chip rev %04x\n",
+	INFO(dev, "%s\n", driver_desc);
+	INFO(dev, "irq %d, pci mem %p, chip rev %04x\n",
 			pdev->irq, base, dev->chiprev);
 	INFO(dev, "version: " DRIVER_VERSION "; dma %s %s\n",
 		use_dma	? (use_dma_chaining ? "chaining" : "enabled")
 			: "disabled",
 		dev->enhanced_mode ? "enhanced mode" : "legacy mode");
-	retval = device_create_file (&pdev->dev, &dev_attr_registers);
-	if (retval) goto done;
+	retval = device_create_file(&pdev->dev, &dev_attr_registers);
+	if (retval)
+		goto done;
 
 	retval = usb_add_gadget_udc_release(&pdev->dev, &dev->gadget,
 			gadget_release);
@@ -3754,7 +3748,7 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 
 done:
 	if (dev)
-		net2280_remove (pdev);
+		net2280_remove(pdev);
 	return retval;
 }
 
@@ -3762,16 +3756,16 @@ done:
  * generating IRQs across the upcoming reboot.
  */
 
-static void net2280_shutdown (struct pci_dev *pdev)
+static void net2280_shutdown(struct pci_dev *pdev)
 {
-	struct net2280		*dev = pci_get_drvdata (pdev);
+	struct net2280		*dev = pci_get_drvdata(pdev);
 
 	/* disable IRQs */
-	writel (0, &dev->regs->pciirqenb0);
-	writel (0, &dev->regs->pciirqenb1);
+	writel(0, &dev->regs->pciirqenb0);
+	writel(0, &dev->regs->pciirqenb1);
 
 	/* disable the pullup so the host will think we're gone */
-	writel (0, &dev->usb->usbctl);
+	writel(0, &dev->usb->usbctl);
 
 	/* Disable full-speed test mode */
 	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
@@ -3781,7 +3775,7 @@ static void net2280_shutdown (struct pci_dev *pdev)
 
 /*-------------------------------------------------------------------------*/
 
-static const struct pci_device_id pci_ids [] = { {
+static const struct pci_device_id pci_ids[] = { {
 	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
 	.class_mask =	~0,
 	.vendor =	PCI_VENDOR_ID_PLX_LEGACY,
@@ -3814,7 +3808,7 @@ static const struct pci_device_id pci_ids [] = { {
 	 },
 { /* end: all zeroes */ }
 };
-MODULE_DEVICE_TABLE (pci, pci_ids);
+MODULE_DEVICE_TABLE(pci, pci_ids);
 
 /* pci driver glue; this is a "new style" PCI driver module */
 static struct pci_driver net2280_pci_driver = {
@@ -3830,6 +3824,6 @@ static struct pci_driver net2280_pci_driver = {
 
 module_pci_driver(net2280_pci_driver);
 
-MODULE_DESCRIPTION (DRIVER_DESC);
-MODULE_AUTHOR ("David Brownell");
-MODULE_LICENSE ("GPL");
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("David Brownell");
+MODULE_LICENSE("GPL");
diff --git a/drivers/usb/gadget/net2280.h b/drivers/usb/gadget/net2280.h
index e1c5d1a..683b6fc 100644
--- a/drivers/usb/gadget/net2280.h
+++ b/drivers/usb/gadget/net2280.h
@@ -25,19 +25,18 @@
  * caller must own the device lock.
  */
 
-static inline u32
-get_idx_reg (struct net2280_regs __iomem *regs, u32 index)
+static inline u32 get_idx_reg(struct net2280_regs __iomem *regs, u32 index)
 {
-	writel (index, &regs->idxaddr);
+	writel(index, &regs->idxaddr);
 	/* NOTE:  synchs device/cpu memory views */
-	return readl (&regs->idxdata);
+	return readl(&regs->idxdata);
 }
 
-static inline void
-set_idx_reg (struct net2280_regs __iomem *regs, u32 index, u32 value)
+static inline void set_idx_reg(struct net2280_regs __iomem *regs,
+							u32 index, u32 value)
 {
-	writel (index, &regs->idxaddr);
-	writel (value, &regs->idxdata);
+	writel(index, &regs->idxaddr);
+	writel(value, &regs->idxdata);
 	/* posted, may not be visible yet */
 }
 
@@ -81,7 +80,7 @@ struct net2280_dma {
 	__le32		dmaaddr;		/* the buffer */
 	__le32		dmadesc;		/* next dma descriptor */
 	__le32		_reserved;
-} __attribute__ ((aligned (16)));
+} __aligned(16);
 
 /*-------------------------------------------------------------------------*/
 
@@ -113,7 +112,7 @@ struct net2280_ep {
 						responded : 1;
 };
 
-static inline void allow_status (struct net2280_ep *ep)
+static inline void allow_status(struct net2280_ep *ep)
 {
 	/* ep0 only */
 	writel(BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE) |
@@ -152,7 +151,7 @@ struct net2280 {
 	struct usb_gadget		gadget;
 	spinlock_t			lock;
 	struct net2280_ep		ep[9];
-	struct usb_gadget_driver 	*driver;
+	struct usb_gadget_driver	*driver;
 	unsigned			enabled : 1,
 					protocol_stall : 1,
 					softconnect : 1,
@@ -185,10 +184,10 @@ struct net2280 {
 	struct usb338x_pl_regs		__iomem *plregs;
 
 	struct pci_pool			*requests;
-	// statistics...
+	/* statistics...*/
 };
 
-static inline void set_halt (struct net2280_ep *ep)
+static inline void set_halt(struct net2280_ep *ep)
 {
 	/* ep0 and bulk/intr endpoints */
 	writel(BIT(CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE) |
@@ -198,7 +197,7 @@ static inline void set_halt (struct net2280_ep *ep)
 		&ep->regs->ep_rsp);
 }
 
-static inline void clear_halt (struct net2280_ep *ep)
+static inline void clear_halt(struct net2280_ep *ep)
 {
 	/* ep0 and bulk/intr endpoints */
 	writel(BIT(CLEAR_ENDPOINT_HALT) |
@@ -250,7 +249,7 @@ static inline void clear_halt (struct net2280_ep *ep)
 
 #ifdef USE_RDK_LEDS
 
-static inline void net2280_led_init (struct net2280 *dev)
+static inline void net2280_led_init(struct net2280 *dev)
 {
 	/* LED3 (green) is on during USB activity. note erratum 0113. */
 	writel(BIT(GPIO3_LED_SELECT) |
@@ -263,9 +262,9 @@ static inline void net2280_led_init (struct net2280 *dev)
 
 /* indicate speed with bi-color LED 0/1 */
 static inline
-void net2280_led_speed (struct net2280 *dev, enum usb_device_speed speed)
+void net2280_led_speed(struct net2280 *dev, enum usb_device_speed speed)
 {
-	u32	val = readl (&dev->regs->gpioctl);
+	u32	val = readl(&dev->regs->gpioctl);
 	switch (speed) {
 	case USB_SPEED_SUPER:		/* green + red */
 		val |= BIT(GPIO0_DATA) | BIT(GPIO1_DATA);
@@ -282,25 +281,26 @@ void net2280_led_speed (struct net2280 *dev, enum usb_device_speed speed)
 		val &= ~(BIT(GPIO1_DATA) | BIT(GPIO0_DATA));
 		break;
 	}
-	writel (val, &dev->regs->gpioctl);
+	writel(val, &dev->regs->gpioctl);
 }
 
 /* indicate power with LED 2 */
-static inline void net2280_led_active (struct net2280 *dev, int is_active)
+static inline void net2280_led_active(struct net2280 *dev, int is_active)
 {
-	u32	val = readl (&dev->regs->gpioctl);
+	u32	val = readl(&dev->regs->gpioctl);
 
-	// FIXME this LED never seems to turn on.
+	/* FIXME this LED never seems to turn on.*/
 	if (is_active)
 		val |= GPIO2_DATA;
 	else
 		val &= ~GPIO2_DATA;
-	writel (val, &dev->regs->gpioctl);
+	writel(val, &dev->regs->gpioctl);
 }
-static inline void net2280_led_shutdown (struct net2280 *dev)
+
+static inline void net2280_led_shutdown(struct net2280 *dev)
 {
 	/* turn off all four GPIO*_DATA bits */
-	writel (readl (&dev->regs->gpioctl) & ~0x0f,
+	writel(readl(&dev->regs->gpioctl) & ~0x0f,
 			&dev->regs->gpioctl);
 }
 
@@ -314,32 +314,32 @@ static inline void net2280_led_shutdown (struct net2280 *dev)
 
 /*-------------------------------------------------------------------------*/
 
-#define xprintk(dev,level,fmt,args...) \
-	printk(level "%s %s: " fmt , driver_name , \
-			pci_name(dev->pdev) , ## args)
+#define xprintk(dev, level, fmt, args...) \
+	printk(level "%s %s: " fmt, driver_name, \
+			pci_name(dev->pdev), ## args)
 
 #ifdef DEBUG
 #undef DEBUG
-#define DEBUG(dev,fmt,args...) \
-	xprintk(dev , KERN_DEBUG , fmt , ## args)
+#define DEBUG(dev, fmt, args...) \
+	xprintk(dev, KERN_DEBUG, fmt, ## args)
 #else
-#define DEBUG(dev,fmt,args...) \
+#define DEBUG(dev, fmt, args...) \
 	do { } while (0)
-#endif /* DEBUG */
+#endif /* DEBUG*/
 
 #ifdef VERBOSE
 #define VDEBUG DEBUG
 #else
-#define VDEBUG(dev,fmt,args...) \
+#define VDEBUG(dev, fmt, args...) \
 	do { } while (0)
 #endif	/* VERBOSE */
 
-#define ERROR(dev,fmt,args...) \
-	xprintk(dev , KERN_ERR , fmt , ## args)
-#define WARNING(dev,fmt,args...) \
-	xprintk(dev , KERN_WARNING , fmt , ## args)
-#define INFO(dev,fmt,args...) \
-	xprintk(dev , KERN_INFO , fmt , ## args)
+#define ERROR(dev, fmt, args...) \
+	xprintk(dev, KERN_ERR, fmt, ## args)
+#define WARNING(dev, fmt, args...) \
+	xprintk(dev, KERN_WARNING, fmt, ## args)
+#define INFO(dev, fmt, args...) \
+	xprintk(dev, KERN_INFO, fmt, ## args)
 
 /*-------------------------------------------------------------------------*/
 
@@ -354,36 +354,36 @@ static inline void set_fifo_bytecount(struct net2280_ep *ep, unsigned count)
 	}
 }
 
-static inline void start_out_naking (struct net2280_ep *ep)
+static inline void start_out_naking(struct net2280_ep *ep)
 {
 	/* NOTE:  hardware races lurk here, and PING protocol issues */
 	writel(BIT(SET_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
 	/* synch with device */
-	readl (&ep->regs->ep_rsp);
+	readl(&ep->regs->ep_rsp);
 }
 
 #ifdef DEBUG
-static inline void assert_out_naking (struct net2280_ep *ep, const char *where)
+static inline void assert_out_naking(struct net2280_ep *ep, const char *where)
 {
-	u32	tmp = readl (&ep->regs->ep_stat);
+	u32	tmp = readl(&ep->regs->ep_stat);
 
 	if ((tmp & BIT(NAK_OUT_PACKETS)) == 0) {
-		DEBUG (ep->dev, "%s %s %08x !NAK\n",
+		DEBUG(ep->dev, "%s %s %08x !NAK\n",
 				ep->ep.name, where, tmp);
 		writel(BIT(SET_NAK_OUT_PACKETS),
 			&ep->regs->ep_rsp);
 	}
 }
-#define ASSERT_OUT_NAKING(ep) assert_out_naking(ep,__func__)
+#define ASSERT_OUT_NAKING(ep) assert_out_naking(ep, __func__)
 #else
 #define ASSERT_OUT_NAKING(ep) do {} while (0)
 #endif
 
-static inline void stop_out_naking (struct net2280_ep *ep)
+static inline void stop_out_naking(struct net2280_ep *ep)
 {
 	u32	tmp;
 
-	tmp = readl (&ep->regs->ep_stat);
+	tmp = readl(&ep->regs->ep_stat);
 	if ((tmp & BIT(NAK_OUT_PACKETS)) != 0)
 		writel(BIT(CLEAR_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
 }
-- 
2.0.0.rc2

