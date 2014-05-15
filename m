Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaEOH1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:27:15 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37584 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaEOH1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:27:13 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3] usb: gadget: net2280: Add support for PLX USB338X
Date: Thu, 15 May 2014 09:27:05 +0200
Message-Id: <1400138825-25982-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the PLX USB3380 and USB3382.

This driver is based on the driver from the manufacturer.

Since USB338X is register compatible with NET2280, I thought that it
would be better to include this hardware into net2280 driver.

Manufacturer's driver only supported the USB33X, did not follow the
Kernel Style and contain some trivial errors. This patch has tried to
address this issues.

This patch has only been tested on USB338x hardware, but the merge has
been done trying to not affect the behaviour of NET2280.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
v3:  -Fix Double parenthesis
     -Comments by Joe Perches:
     	- declare ep_bit as global const
	- logical continuations at end of line
	- fix multiline comment

v2:
	-use usb_ep_set_maxpacket_limit
	-usb338x: Fix support for high speed

 drivers/usb/gadget/Kconfig   |   10 +-
 drivers/usb/gadget/net2280.c | 1115 ++++++++++++++++++++++++++++++++++++++----
 drivers/usb/gadget/net2280.h |   97 +++-
 include/linux/usb/usb338x.h  |  199 ++++++++
 4 files changed, 1330 insertions(+), 91 deletions(-)
 create mode 100644 include/linux/usb/usb338x.h

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 3557c7e..831af8f 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -415,7 +415,7 @@ config USB_NET2272_DMA
 	  If unsure, say "N" here.  The driver works fine in PIO mode.
 
 config USB_NET2280
-	tristate "NetChip 228x"
+	tristate "NetChip 228x / PLX USB338x"
 	depends on PCI
 	help
 	   NetChip 2280 / 2282 is a PCI based USB peripheral controller which
@@ -425,6 +425,14 @@ config USB_NET2280
 	   (for control transfers) and several endpoints with dedicated
 	   functions.
 
+	   PLX 3380 / 3382 is a PCIe based USB peripheral controller which
+	   supports full, high speed USB 2.0 and super speed USB 3.0
+	   data transfers.
+
+	   It has eight configurable endpoints, as well as endpoint zero
+	   (for control transfers) and several endpoints with dedicated
+	   functions.
+
 	   Say "y" to link the driver statically, or "m" to build a
 	   dynamically linked module called "net2280" and force all
 	   gadget drivers to also be dynamically linked.
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 4978e63..1b55799 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -18,6 +18,9 @@
  * hint to completely eliminate some IRQs, if a later IRQ is guaranteed
  * and DMA chaining is enabled.
  *
+ * MSI is enabled by default.  The legacy IRQ is used if MSI couldn't
+ * be enabled.
+ *
  * Note that almost all the errata workarounds here are only needed for
  * rev1 chips.  Rev1a silicon (0110) fixes almost all of them.
  */
@@ -25,10 +28,14 @@
 /*
  * Copyright (C) 2003 David Brownell
  * Copyright (C) 2003-2005 PLX Technology, Inc.
+ * Copyright (C) 2014 Ricardo Ribalda - Qtechnology/AS
  *
  * Modified Seth Levy 2005 PLX Technology, Inc. to provide compatibility
  *	with 2282 chip
  *
+ * Modified Ricardo Ribalda Qtechnology AS  to provide compatibility
+ *	with usb 338x chip. Based on PLX driver
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -61,9 +68,8 @@
 #include <asm/irq.h>
 #include <asm/unaligned.h>
 
-
-#define	DRIVER_DESC		"PLX NET228x USB Peripheral Controller"
-#define	DRIVER_VERSION		"2005 Sept 27"
+#define	DRIVER_DESC		"PLX NET228x/USB338x USB Peripheral Controller"
+#define	DRIVER_VERSION		"2005 Sept 27/v3.0"
 
 #define	EP_DONTUSE		13	/* nonzero */
 
@@ -73,11 +79,12 @@
 static const char driver_name [] = "net2280";
 static const char driver_desc [] = DRIVER_DESC;
 
+static const u32 ep_bit[9] = { 0, 17, 2, 19, 4, 1, 18, 3, 20 };
 static const char ep0name [] = "ep0";
 static const char *const ep_name [] = {
 	ep0name,
 	"ep-a", "ep-b", "ep-c", "ep-d",
-	"ep-e", "ep-f",
+	"ep-e", "ep-f", "ep-g", "ep-h",
 };
 
 /* use_dma -- general goodness, fewer interrupts, less cpu load (vs PIO)
@@ -90,11 +97,12 @@ static const char *const ep_name [] = {
  */
 static bool use_dma = 1;
 static bool use_dma_chaining = 0;
+static bool use_msi = 1;
 
 /* "modprobe net2280 use_dma=n" etc */
 module_param (use_dma, bool, S_IRUGO);
 module_param (use_dma_chaining, bool, S_IRUGO);
-
+module_param(use_msi, bool, S_IRUGO);
 
 /* mode 0 == ep-{a,b,c,d} 1K fifo each
  * mode 1 == ep-{a,b} 2K fifo each, ep-{c,d} unavailable
@@ -148,6 +156,9 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	struct net2280_ep	*ep;
 	u32			max, tmp;
 	unsigned long		flags;
+	static const u32 ep_key[9] = { 1, 0, 1, 0, 1, 1, 0, 1, 0 };
+	static const u32 ep_enhanced[9] = { 0x10, 0x60, 0x30, 0x80,
+					  0x50, 0x20, 0x70, 0x40, 0x90 };
 
 	ep = container_of (_ep, struct net2280_ep, ep);
 	if (!_ep || !desc || ep->desc || _ep->name == ep0name
@@ -161,11 +172,20 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	if ((desc->bEndpointAddress & 0x0f) == EP_DONTUSE)
 		return -EDOM;
 
+	if (dev->pdev->vendor == 0x10b5) {
+		if ((desc->bEndpointAddress & 0x0f) >= 0x0c)
+			return -EDOM;
+		ep->is_in = !!usb_endpoint_dir_in(desc);
+		if (dev->enhanced_mode && ep->is_in && ep_key[ep->num])
+			return -EINVAL;
+	}
+
 	/* sanity check ep-e/ep-f since their fifos are small */
 	max = usb_endpoint_maxp (desc) & 0x1fff;
-	if (ep->num > 4 && max > 64)
+	if (ep->num > 4 && max > 64 && (dev->pdev->vendor == 0x17cc))
 		return -ERANGE;
 
+
 	spin_lock_irqsave (&dev->lock, flags);
 	_ep->maxpacket = max & 0x7ff;
 	ep->desc = desc;
@@ -176,7 +196,8 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	ep->out_overflow = 0;
 
 	/* set speed-dependent max packet; may kick in high bandwidth */
-	set_idx_reg (dev->regs, REG_EP_MAXPKT (dev, ep->num), max);
+	set_idx_reg(dev->regs, (dev->enhanced_mode) ? ep_enhanced[ep->num]
+					: REG_EP_MAXPKT(dev, ep->num), max);
 
 	/* FIFO lines can't go to different packets.  PIO is ok, so
 	 * use it instead of troublesome (non-bulk) multi-packet DMA.
@@ -199,23 +220,43 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 				&ep->regs->ep_rsp);
 	} else if (tmp == USB_ENDPOINT_XFER_BULK) {
 		/* catch some particularly blatant driver bugs */
-		if ((dev->gadget.speed == USB_SPEED_HIGH
-					&& max != 512)
-				|| (dev->gadget.speed == USB_SPEED_FULL
-					&& max > 64)) {
-			spin_unlock_irqrestore (&dev->lock, flags);
+		if ((dev->gadget.speed == USB_SPEED_SUPER && max != 1024) ||
+		    (dev->gadget.speed == USB_SPEED_HIGH && max != 512) ||
+		    (dev->gadget.speed == USB_SPEED_FULL && max > 64)) {
+			spin_unlock_irqrestore(&dev->lock, flags);
 			return -ERANGE;
 		}
 	}
 	ep->is_iso = (tmp == USB_ENDPOINT_XFER_ISOC) ? 1 : 0;
-	tmp <<= ENDPOINT_TYPE;
-	tmp |= desc->bEndpointAddress;
-	tmp |= (4 << ENDPOINT_BYTE_COUNT);	/* default full fifo lines */
-	tmp |= 1 << ENDPOINT_ENABLE;
-	wmb ();
+	/* Enable this endpoint */
+	if (dev->pdev->vendor == 0x17cc) {
+		tmp <<= ENDPOINT_TYPE;
+		tmp |= desc->bEndpointAddress;
+		/* default full fifo lines */
+		tmp |= (4 << ENDPOINT_BYTE_COUNT);
+		tmp |= 1 << ENDPOINT_ENABLE;
+		ep->is_in = (tmp & USB_DIR_IN) != 0;
+	} else {
+		/* In Legacy mode, only OUT endpoints are used */
+		if (dev->enhanced_mode && ep->is_in) {
+			tmp <<= IN_ENDPOINT_TYPE;
+			tmp |= (1 << IN_ENDPOINT_ENABLE);
+			/* Not applicable to Legacy */
+			tmp |= (1 << ENDPOINT_DIRECTION);
+		} else {
+			tmp <<= OUT_ENDPOINT_TYPE;
+			tmp |= (1 << OUT_ENDPOINT_ENABLE);
+			tmp |= (ep->is_in << ENDPOINT_DIRECTION);
+		}
+
+		tmp |= usb_endpoint_num(desc);
+		tmp |= (ep->ep.maxburst << MAX_BURST_SIZE);
+	}
+
+	/* Make sure all the registers are written before ep_rsp*/
+	wmb();
 
 	/* for OUT transfers, block the rx fifo until a read is posted */
-	ep->is_in = (tmp & USB_DIR_IN) != 0;
 	if (!ep->is_in)
 		writel ((1 << SET_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
 	else if (dev->pdev->device != 0x2280) {
@@ -226,11 +267,13 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			| (1 << CLEAR_NAK_OUT_PACKETS_MODE), &ep->regs->ep_rsp);
 	}
 
-	writel (tmp, &ep->regs->ep_cfg);
+	writel(tmp, &ep->cfg->ep_cfg);
 
 	/* enable irqs */
 	if (!ep->dma) {				/* pio, per-packet */
-		tmp = (1 << ep->num) | readl (&dev->regs->pciirqenb0);
+		tmp = (dev->pdev->vendor == 0x17cc)?(1 << ep->num)
+						   : (1 << ep_bit[ep->num]);
+		tmp |= readl(&dev->regs->pciirqenb0);
 		writel (tmp, &dev->regs->pciirqenb0);
 
 		tmp = (1 << DATA_PACKET_RECEIVED_INTERRUPT_ENABLE)
@@ -251,8 +294,10 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 			tmp = (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT_ENABLE);
 			writel (tmp, &ep->regs->ep_irqenb);
 
-			tmp = (1 << ep->num) | readl (&dev->regs->pciirqenb0);
-			writel (tmp, &dev->regs->pciirqenb0);
+			tmp = (dev->pdev->vendor == 0x17cc)?(1 << ep->num)
+						: (1 << ep_bit[ep->num]);
+			tmp |= readl(&dev->regs->pciirqenb0);
+			writel(tmp, &dev->regs->pciirqenb0);
 		}
 	}
 
@@ -286,7 +331,8 @@ static int handshake (u32 __iomem *ptr, u32 mask, u32 done, int usec)
 
 static const struct usb_ep_ops net2280_ep_ops;
 
-static void ep_reset (struct net2280_regs __iomem *regs, struct net2280_ep *ep)
+static void ep_reset_228x(struct net2280_regs __iomem *regs,
+			  struct net2280_ep *ep)
 {
 	u32		tmp;
 
@@ -361,6 +407,55 @@ static void ep_reset (struct net2280_regs __iomem *regs, struct net2280_ep *ep)
 	/* fifo size is handled separately */
 }
 
+static void ep_reset_338x(struct net2280_regs __iomem *regs,
+					struct net2280_ep *ep)
+{
+	u32 tmp, dmastat;
+
+	ep->desc = NULL;
+	INIT_LIST_HEAD(&ep->queue);
+
+	usb_ep_set_maxpacket_limit(&ep->ep, ~0);
+	ep->ep.ops = &net2280_ep_ops;
+
+	/* disable the dma, irqs, endpoint... */
+	if (ep->dma) {
+		writel(0, &ep->dma->dmactl);
+		writel((1 << DMA_ABORT_DONE_INTERRUPT) |
+		       (1 << DMA_PAUSE_DONE_INTERRUPT) |
+		       (1 << DMA_SCATTER_GATHER_DONE_INTERRUPT) |
+		       (1 << DMA_TRANSACTION_DONE_INTERRUPT)
+		       /* | (1 << DMA_ABORT) */
+		       , &ep->dma->dmastat);
+
+		dmastat = readl(&ep->dma->dmastat);
+		if (dmastat == 0x5002) {
+			WARNING(ep->dev, "The dmastat return = %x!!\n",
+			       dmastat);
+			writel(0x5a, &ep->dma->dmastat);
+		}
+
+		tmp = readl(&regs->pciirqenb0);
+		tmp &= ~(1 << ep_bit[ep->num]);
+		writel(tmp, &regs->pciirqenb0);
+	} else {
+		if (ep->num < 5) {
+			tmp = readl(&regs->pciirqenb1);
+			tmp &= ~(1 << (8 + ep->num));	/* completion */
+			writel(tmp, &regs->pciirqenb1);
+		}
+	}
+	writel(0, &ep->regs->ep_irqenb);
+
+	writel((1 << SHORT_PACKET_OUT_DONE_INTERRUPT) |
+	       (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT) |
+	       (1 << FIFO_OVERFLOW) |
+	       (1 << DATA_PACKET_RECEIVED_INTERRUPT) |
+	       (1 << DATA_PACKET_TRANSMITTED_INTERRUPT) |
+	       (1 << DATA_OUT_PING_TOKEN_INTERRUPT) |
+	       (1 << DATA_IN_TOKEN_INTERRUPT), &ep->regs->ep_stat);
+}
+
 static void nuke (struct net2280_ep *);
 
 static int net2280_disable (struct usb_ep *_ep)
@@ -374,13 +469,17 @@ static int net2280_disable (struct usb_ep *_ep)
 
 	spin_lock_irqsave (&ep->dev->lock, flags);
 	nuke (ep);
-	ep_reset (ep->dev->regs, ep);
+
+	if (ep->dev->pdev->vendor == 0x10b5)
+		ep_reset_338x(ep->dev->regs, ep);
+	else
+		ep_reset_228x(ep->dev->regs, ep);
 
 	VDEBUG (ep->dev, "disabled %s %s\n",
 			ep->dma ? "dma" : "pio", _ep->name);
 
 	/* synch memory views with the device */
-	(void) readl (&ep->regs->ep_cfg);
+	(void)readl(&ep->cfg->ep_cfg);
 
 	if (use_dma && !ep->dma && ep->num >= 1 && ep->num <= 4)
 		ep->dma = &ep->dev->dma [ep->num - 1];
@@ -698,6 +797,8 @@ static void start_queue (struct net2280_ep *ep, u32 dmactl, u32 td_dma)
 	writel (readl (&dma->dmastat), &dma->dmastat);
 
 	writel (td_dma, &dma->dmadesc);
+	if (ep->dev->pdev->vendor == 0x10b5)
+		dmactl |= (0x01 << DMA_REQUEST_OUTSTANDING);
 	writel (dmactl, &dma->dmactl);
 
 	/* erratum 0116 workaround part 3:  pci arbiter away from net2280 */
@@ -772,6 +873,21 @@ static void start_dma (struct net2280_ep *ep, struct net2280_request *req)
 	start_queue (ep, tmp, req->td_dma);
 }
 
+static inline void resume_dma(struct net2280_ep *ep)
+{
+	writel(readl(&ep->dma->dmactl) | (1 << DMA_ENABLE), &ep->dma->dmactl);
+
+	ep->dma_started = true;
+}
+
+static inline void ep_stop_dma(struct net2280_ep *ep)
+{
+	writel(readl(&ep->dma->dmactl) & ~(1 << DMA_ENABLE), &ep->dma->dmactl);
+	spin_stop_dma(ep->dma);
+
+	ep->dma_started = false;
+}
+
 static inline void
 queue_dma (struct net2280_ep *ep, struct net2280_request *req, int valid)
 {
@@ -874,8 +990,23 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 
 	/* kickstart this i/o queue? */
 	if (list_empty (&ep->queue) && !ep->stopped) {
+		/* DMA request while EP halted */
+		if (ep->dma &&
+		    (readl(&ep->regs->ep_rsp) & (1 << CLEAR_ENDPOINT_HALT)) &&
+			(dev->pdev->vendor == 0x10b5)) {
+			int valid = 1;
+			if (ep->is_in) {
+				int expect;
+				expect = likely(req->req.zero ||
+						((req->req.length %
+						  ep->ep.maxpacket) != 0));
+				if (expect != ep->in_fifo_validate)
+					valid = 0;
+			}
+			queue_dma(ep, req, valid);
+		}
 		/* use DMA if the endpoint supports it, else pio */
-		if (ep->dma)
+		else if (ep->dma)
 			start_dma (ep, req);
 		else {
 			/* maybe there's no control data, just status ack */
@@ -993,6 +1124,8 @@ static void scan_dma_completions (struct net2280_ep *ep)
 		} else if (!ep->is_in
 				&& (req->req.length % ep->ep.maxpacket) != 0) {
 			tmp = readl (&ep->regs->ep_stat);
+			if (ep->dev->pdev->vendor == 0x10b5)
+				return dma_done(ep, req, tmp, 0);
 
 			/* AVOID TROUBLE HERE by not issuing short reads from
 			 * your gadget driver.  That helps avoids errata 0121,
@@ -1079,7 +1212,7 @@ static void restart_dma (struct net2280_ep *ep)
 	start_queue (ep, dmactl, req->td_dma);
 }
 
-static void abort_dma (struct net2280_ep *ep)
+static void abort_dma_228x(struct net2280_ep *ep)
 {
 	/* abort the current transfer */
 	if (likely (!list_empty (&ep->queue))) {
@@ -1091,6 +1224,19 @@ static void abort_dma (struct net2280_ep *ep)
 	scan_dma_completions (ep);
 }
 
+static void abort_dma_338x(struct net2280_ep *ep)
+{
+	writel((1 << DMA_ABORT), &ep->dma->dmastat);
+	spin_stop_dma(ep->dma);
+}
+
+static void abort_dma(struct net2280_ep *ep)
+{
+	if (ep->dev->pdev->vendor == 0x17cc)
+		return abort_dma_228x(ep);
+	return abort_dma_338x(ep);
+}
+
 /* dequeue ALL requests */
 static void nuke (struct net2280_ep *ep)
 {
@@ -1244,6 +1390,9 @@ net2280_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedged)
 				ep->wedged = 1;
 		} else {
 			clear_halt (ep);
+			if (ep->dev->pdev->vendor == 0x10b5 &&
+				!list_empty(&ep->queue) && ep->td_dma)
+					restart_dma(ep);
 			ep->wedged = 0;
 		}
 		(void) readl (&ep->regs->ep_rsp);
@@ -1367,10 +1516,13 @@ static int net2280_set_selfpowered (struct usb_gadget *_gadget, int value)
 
 	spin_lock_irqsave (&dev->lock, flags);
 	tmp = readl (&dev->usb->usbctl);
-	if (value)
+	if (value) {
 		tmp |= (1 << SELF_POWERED_STATUS);
-	else
+		dev->selfpowered = 1;
+	} else {
 		tmp &= ~(1 << SELF_POWERED_STATUS);
+		dev->selfpowered = 0;
+	}
 	writel (tmp, &dev->usb->usbctl);
 	spin_unlock_irqrestore (&dev->lock, flags);
 
@@ -1504,14 +1656,14 @@ static ssize_t registers_show(struct device *_dev,
 	/* DMA Control Registers */
 
 	/* Configurable EP Control Registers */
-	for (i = 0; i < 7; i++) {
+	for (i = 0; i < dev->n_ep; i++) {
 		struct net2280_ep	*ep;
 
 		ep = &dev->ep [i];
 		if (i && !ep->desc)
 			continue;
 
-		t1 = readl (&ep->regs->ep_cfg);
+		t1 = readl(&ep->cfg->ep_cfg);
 		t2 = readl (&ep->regs->ep_rsp) & 0xff;
 		t = scnprintf (next, size,
 				"\n%s\tcfg %05x rsp (%02x) %s%s%s%s%s%s%s%s"
@@ -1571,7 +1723,7 @@ static ssize_t registers_show(struct device *_dev,
 	t = scnprintf (next, size, "\nirqs:  ");
 	size -= t;
 	next += t;
-	for (i = 0; i < 7; i++) {
+	for (i = 0; i < dev->n_ep; i++) {
 		struct net2280_ep	*ep;
 
 		ep = &dev->ep [i];
@@ -1606,7 +1758,7 @@ static ssize_t queues_show(struct device *_dev, struct device_attribute *attr,
 	size = PAGE_SIZE;
 	spin_lock_irqsave (&dev->lock, flags);
 
-	for (i = 0; i < 7; i++) {
+	for (i = 0; i < dev->n_ep; i++) {
 		struct net2280_ep		*ep = &dev->ep [i];
 		struct net2280_request		*req;
 		int				t;
@@ -1735,6 +1887,121 @@ static void set_fifo_mode (struct net2280 *dev, int mode)
 	list_add_tail (&dev->ep [6].ep.ep_list, &dev->gadget.ep_list);
 }
 
+static void defect7374_disable_data_eps(struct net2280 *dev)
+{
+	/*
+	 * For Defect 7374, disable data EPs (and more):
+	 *  - This phase undoes the earlier phase of the Defect 7374 workaround,
+	 *    returing ep regs back to normal.
+	 */
+	struct net2280_ep *ep;
+	int i;
+	unsigned char ep_sel;
+	u32 tmp_reg;
+
+	for (i = 1; i < 5; i++) {
+		ep = &dev->ep[i];
+		writel(0, &ep->cfg->ep_cfg);
+	}
+
+	/* CSROUT, CSRIN, PCIOUT, PCIIN, STATIN, RCIN */
+	for (i = 0; i < 6; i++)
+		writel(0, &dev->dep[i].dep_cfg);
+
+	for (ep_sel = 0; ep_sel <= 21; ep_sel++) {
+		/* Select an endpoint for subsequent operations: */
+		tmp_reg = readl(&dev->plregs->pl_ep_ctrl);
+		writel(((tmp_reg & ~0x1f) | ep_sel), &dev->plregs->pl_ep_ctrl);
+
+		if (ep_sel < 2 || (ep_sel > 9 && ep_sel < 14) ||
+					ep_sel == 18 || ep_sel == 20)
+			continue;
+
+		/* Change settings on some selected endpoints */
+		tmp_reg = readl(&dev->plregs->pl_ep_cfg_4);
+		tmp_reg &= ~(1 << NON_CTRL_IN_TOLERATE_BAD_DIR);
+		writel(tmp_reg, &dev->plregs->pl_ep_cfg_4);
+		tmp_reg = readl(&dev->plregs->pl_ep_ctrl);
+		tmp_reg |= (1 << EP_INITIALIZED);
+		writel(tmp_reg, &dev->plregs->pl_ep_ctrl);
+	}
+}
+
+static void defect7374_enable_data_eps_zero(struct net2280 *dev)
+{
+	u32 tmp = 0, tmp_reg;
+	u32 fsmvalue, scratch;
+	int i;
+	unsigned char ep_sel;
+
+	scratch = get_idx_reg(dev->regs, SCRATCH);
+	fsmvalue = scratch & (0xf << DEFECT7374_FSM_FIELD);
+	scratch &= ~(0xf << DEFECT7374_FSM_FIELD);
+
+	/*See if firmware needs to set up for workaround*/
+	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ) {
+		WARNING(dev, "Operate Defect 7374 workaround soft this time");
+		WARNING(dev, "It will operate on cold-reboot and SS connect");
+
+		/*GPEPs:*/
+		tmp = ((0 << ENDPOINT_NUMBER) | (1 << ENDPOINT_DIRECTION) |
+		       (2 << OUT_ENDPOINT_TYPE) | (2 << IN_ENDPOINT_TYPE) |
+		       ((dev->enhanced_mode) ?
+			1 << OUT_ENDPOINT_ENABLE : 1 << ENDPOINT_ENABLE) |
+		       (1 << IN_ENDPOINT_ENABLE));
+
+		for (i = 1; i < 5; i++)
+			writel(tmp, &dev->ep[i].cfg->ep_cfg);
+
+		/* CSRIN, PCIIN, STATIN, RCIN*/
+		tmp = ((0 << ENDPOINT_NUMBER) | (1 << ENDPOINT_ENABLE));
+		writel(tmp, &dev->dep[1].dep_cfg);
+		writel(tmp, &dev->dep[3].dep_cfg);
+		writel(tmp, &dev->dep[4].dep_cfg);
+		writel(tmp, &dev->dep[5].dep_cfg);
+
+		/*Implemented for development and debug.
+		 * Can be refined/tuned later.*/
+		for (ep_sel = 0; ep_sel <= 21; ep_sel++) {
+			/* Select an endpoint for subsequent operations: */
+			tmp_reg = readl(&dev->plregs->pl_ep_ctrl);
+			writel(((tmp_reg & ~0x1f) | ep_sel),
+			       &dev->plregs->pl_ep_ctrl);
+
+			if (ep_sel == 1) {
+				tmp =
+				    (readl(&dev->plregs->pl_ep_ctrl) |
+				     (1 << CLEAR_ACK_ERROR_CODE) | 0);
+				writel(tmp, &dev->plregs->pl_ep_ctrl);
+				continue;
+			}
+
+			if (ep_sel == 0 || (ep_sel > 9 && ep_sel < 14) ||
+					ep_sel == 18  || ep_sel == 20)
+				continue;
+
+			tmp = (readl(&dev->plregs->pl_ep_cfg_4) |
+				 (1 << NON_CTRL_IN_TOLERATE_BAD_DIR) | 0);
+			writel(tmp, &dev->plregs->pl_ep_cfg_4);
+
+			tmp = readl(&dev->plregs->pl_ep_ctrl) &
+				~(1 << EP_INITIALIZED);
+			writel(tmp, &dev->plregs->pl_ep_ctrl);
+
+		}
+
+		/* Set FSM to focus on the first Control Read:
+		 * - Tip: Connection speed is known upon the first
+		 * setup request.*/
+		scratch |= DEFECT7374_FSM_WAITING_FOR_CONTROL_READ;
+		set_idx_reg(dev->regs, SCRATCH, scratch);
+
+	} else{
+		WARNING(dev, "Defect 7374 workaround soft will NOT operate");
+		WARNING(dev, "It will operate on cold-reboot and SS connect");
+	}
+}
+
 /* keeping it simple:
  * - one bus driver, initted first;
  * - one function driver, initted second
@@ -1744,7 +2011,7 @@ static void set_fifo_mode (struct net2280 *dev, int mode)
  * perhaps to bind specific drivers to specific devices.
  */
 
-static void usb_reset (struct net2280 *dev)
+static void usb_reset_228x(struct net2280 *dev)
 {
 	u32	tmp;
 
@@ -1760,11 +2027,11 @@ static void usb_reset (struct net2280 *dev)
 
 	/* clear old dma and irq state */
 	for (tmp = 0; tmp < 4; tmp++) {
-		struct net2280_ep	*ep = &dev->ep [tmp + 1];
-
+		struct net2280_ep       *ep = &dev->ep[tmp + 1];
 		if (ep->dma)
-			abort_dma (ep);
+			abort_dma(ep);
 	}
+
 	writel (~0, &dev->regs->irqstat0),
 	writel (~(1 << SUSPEND_REQUEST_INTERRUPT), &dev->regs->irqstat1),
 
@@ -1780,7 +2047,67 @@ static void usb_reset (struct net2280 *dev)
 	set_fifo_mode (dev, (fifo_mode <= 2) ? fifo_mode : 0);
 }
 
-static void usb_reinit (struct net2280 *dev)
+static void usb_reset_338x(struct net2280 *dev)
+{
+	u32 tmp;
+	u32 fsmvalue;
+
+	dev->gadget.speed = USB_SPEED_UNKNOWN;
+	(void)readl(&dev->usb->usbctl);
+
+	net2280_led_init(dev);
+
+	fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
+			(0xf << DEFECT7374_FSM_FIELD);
+
+	/* See if firmware needs to set up for workaround: */
+	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ) {
+		INFO(dev, "%s: Defect 7374 FsmValue 0x%08X\n", __func__,
+		     fsmvalue);
+	} else {
+		/* disable automatic responses, and irqs */
+		writel(0, &dev->usb->stdrsp);
+		writel(0, &dev->regs->pciirqenb0);
+		writel(0, &dev->regs->pciirqenb1);
+	}
+
+	/* clear old dma and irq state */
+	for (tmp = 0; tmp < 4; tmp++) {
+		struct net2280_ep *ep = &dev->ep[tmp + 1];
+
+		if (ep->dma)
+			abort_dma(ep);
+	}
+
+	writel(~0, &dev->regs->irqstat0), writel(~0, &dev->regs->irqstat1);
+
+	if (fsmvalue == DEFECT7374_FSM_SS_CONTROL_READ) {
+		/* reset, and enable pci */
+		tmp = readl(&dev->regs->devinit) |
+		    (1 << PCI_ENABLE) |
+		    (1 << FIFO_SOFT_RESET) |
+		    (1 << USB_SOFT_RESET) |
+		    (1 << M8051_RESET);
+
+		writel(tmp, &dev->regs->devinit);
+	}
+
+	/* always ep-{1,2,3,4} ... maybe not ep-3 or ep-4 */
+	INIT_LIST_HEAD(&dev->gadget.ep_list);
+
+	for (tmp = 1; tmp < dev->n_ep; tmp++)
+		list_add_tail(&dev->ep[tmp].ep.ep_list, &dev->gadget.ep_list);
+
+}
+
+static void usb_reset(struct net2280 *dev)
+{
+	if (dev->pdev->vendor == 0x17cc)
+		return usb_reset_228x(dev);
+	return usb_reset_338x(dev);
+}
+
+static void usb_reinit_228x(struct net2280 *dev)
 {
 	u32	tmp;
 	int	init_dma;
@@ -1803,7 +2130,8 @@ static void usb_reinit (struct net2280 *dev)
 		} else
 			ep->fifo_size = 64;
 		ep->regs = &dev->epregs [tmp];
-		ep_reset (dev->regs, ep);
+		ep->cfg = &dev->epregs[tmp];
+		ep_reset_228x(dev->regs, ep);
 	}
 	usb_ep_set_maxpacket_limit(&dev->ep [0].ep, 64);
 	usb_ep_set_maxpacket_limit(&dev->ep [5].ep, 64);
@@ -1820,7 +2148,122 @@ static void usb_reinit (struct net2280 *dev)
 		writel (EP_DONTUSE, &dev->dep [tmp].dep_cfg);
 }
 
-static void ep0_start (struct net2280 *dev)
+static void usb_reinit_338x(struct net2280 *dev)
+{
+	int init_dma;
+	int i;
+	u32 tmp, val;
+	u32 fsmvalue;
+	static const u32 ne[9] = { 0, 1, 2, 3, 4, 1, 2, 3, 4 };
+	static const u32 ep_reg_addr[9] = { 0x00, 0xC0, 0x00, 0xC0, 0x00,
+						0x00, 0xC0, 0x00, 0xC0 };
+
+	/* use_dma changes are ignored till next device re-init */
+	init_dma = use_dma;
+
+	/* basic endpoint init */
+	for (i = 0; i < dev->n_ep; i++) {
+		struct net2280_ep *ep = &dev->ep[i];
+
+		ep->ep.name = ep_name[i];
+		ep->dev = dev;
+		ep->num = i;
+
+		if (i > 0 && i <= 4 && init_dma)
+			ep->dma = &dev->dma[i - 1];
+
+		if (dev->enhanced_mode) {
+			ep->cfg = &dev->epregs[ne[i]];
+			ep->regs = (struct net2280_ep_regs __iomem *)
+				(((void *)&dev->epregs[ne[i]]) +
+				ep_reg_addr[i]);
+			ep->fiforegs = &dev->fiforegs[i];
+		} else {
+			ep->cfg = &dev->epregs[i];
+			ep->regs = &dev->epregs[i];
+			ep->fiforegs = &dev->fiforegs[i];
+		}
+
+		ep->fifo_size = (i != 0) ? 2048 : 512;
+
+		ep_reset_338x(dev->regs, ep);
+	}
+	usb_ep_set_maxpacket_limit(&ep->ep, 512);
+
+	dev->gadget.ep0 = &dev->ep[0].ep;
+	dev->ep[0].stopped = 0;
+
+	/* Link layer set up */
+	fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
+				(0xf << DEFECT7374_FSM_FIELD);
+
+	/* See if driver needs to set up for workaround: */
+	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ)
+		INFO(dev, "%s: Defect 7374 FsmValue %08x\n",
+						__func__, fsmvalue);
+	else {
+		tmp = readl(&dev->usb_ext->usbctl2) &
+		    ~((1 << U1_ENABLE) | (1 << U2_ENABLE) | (1 << LTM_ENABLE));
+		writel(tmp, &dev->usb_ext->usbctl2);
+	}
+
+	/* Hardware Defect and Workaround */
+	val = readl(&dev->ll_lfps_regs->ll_lfps_5);
+	val &= ~(0xf << TIMER_LFPS_6US);
+	val |= 0x5 << TIMER_LFPS_6US;
+	writel(val, &dev->ll_lfps_regs->ll_lfps_5);
+
+	val = readl(&dev->ll_lfps_regs->ll_lfps_6);
+	val &= ~(0xffff << TIMER_LFPS_80US);
+	val |= 0x0100 << TIMER_LFPS_80US;
+	writel(val, &dev->ll_lfps_regs->ll_lfps_6);
+
+	/*
+	 * AA_AB Errata. Issue 4. Workaround for SuperSpeed USB
+	 * Hot Reset Exit Handshake may Fail in Specific Case using
+	 * Default Register Settings. Workaround for Enumeration test.
+	 */
+	val = readl(&dev->ll_tsn_regs->ll_tsn_counters_2);
+	val &= ~(0x1f << HOT_TX_NORESET_TS2);
+	val |= 0x10 << HOT_TX_NORESET_TS2;
+	writel(val, &dev->ll_tsn_regs->ll_tsn_counters_2);
+
+	val = readl(&dev->ll_tsn_regs->ll_tsn_counters_3);
+	val &= ~(0x1f << HOT_RX_RESET_TS2);
+	val |= 0x3 << HOT_RX_RESET_TS2;
+	writel(val, &dev->ll_tsn_regs->ll_tsn_counters_3);
+
+	/*
+	 * Set Recovery Idle to Recover bit:
+	 * - On SS connections, setting Recovery Idle to Recover Fmw improves
+	 *   link robustness with various hosts and hubs.
+	 * - It is safe to set for all connection speeds; all chip revisions.
+	 * - R-M-W to leave other bits undisturbed.
+	 * - Reference PLX TT-7372
+	*/
+	val = readl(&dev->ll_chicken_reg->ll_tsn_chicken_bit);
+	val |= (1 << RECOVERY_IDLE_TO_RECOVER_FMW);
+	writel(val, &dev->ll_chicken_reg->ll_tsn_chicken_bit);
+
+	INIT_LIST_HEAD(&dev->gadget.ep0->ep_list);
+
+	/* disable dedicated endpoints */
+	writel(0x0D, &dev->dep[0].dep_cfg);
+	writel(0x0D, &dev->dep[1].dep_cfg);
+	writel(0x0E, &dev->dep[2].dep_cfg);
+	writel(0x0E, &dev->dep[3].dep_cfg);
+	writel(0x0F, &dev->dep[4].dep_cfg);
+	writel(0x0C, &dev->dep[5].dep_cfg);
+}
+
+static void usb_reinit(struct net2280 *dev)
+{
+	if (dev->pdev->vendor == 0x17cc)
+		return usb_reinit_228x(dev);
+	return usb_reinit_338x(dev);
+}
+
+static void ep0_start_228x(struct net2280 *dev)
 {
 	writel (  (1 << CLEAR_EP_HIDE_STATUS_PHASE)
 		| (1 << CLEAR_NAK_OUT_PACKETS)
@@ -1863,6 +2306,61 @@ static void ep0_start (struct net2280 *dev)
 	(void) readl (&dev->usb->usbctl);
 }
 
+static void ep0_start_338x(struct net2280 *dev)
+{
+	u32 fsmvalue;
+
+	fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
+			(0xf << DEFECT7374_FSM_FIELD);
+
+	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ)
+		INFO(dev, "%s: Defect 7374 FsmValue %08x\n", __func__,
+		     fsmvalue);
+	else
+		writel((1 << CLEAR_NAK_OUT_PACKETS_MODE) |
+		       (1 << SET_EP_HIDE_STATUS_PHASE),
+		       &dev->epregs[0].ep_rsp);
+
+	/*
+	 * hardware optionally handles a bunch of standard requests
+	 * that the API hides from drivers anyway.  have it do so.
+	 * endpoint status/features are handled in software, to
+	 * help pass tests for some dubious behavior.
+	 */
+	writel((1 << SET_ISOCHRONOUS_DELAY) |
+	       (1 << SET_SEL) |
+	       (1 << SET_TEST_MODE) |
+	       (1 << SET_ADDRESS) |
+	       (1 << GET_INTERFACE_STATUS) |
+	       (1 << GET_DEVICE_STATUS),
+		&dev->usb->stdrsp);
+	dev->wakeup_enable = 1;
+	writel((1 << USB_ROOT_PORT_WAKEUP_ENABLE) |
+	       (dev->softconnect << USB_DETECT_ENABLE) |
+	       (1 << DEVICE_REMOTE_WAKEUP_ENABLE),
+	       &dev->usb->usbctl);
+
+	/* enable irqs so we can see ep0 and general operation  */
+	writel((1 << SETUP_PACKET_INTERRUPT_ENABLE) |
+	       (1 << ENDPOINT_0_INTERRUPT_ENABLE)
+	       , &dev->regs->pciirqenb0);
+	writel((1 << PCI_INTERRUPT_ENABLE) |
+	       (1 << ROOT_PORT_RESET_INTERRUPT_ENABLE) |
+	       (1 << SUSPEND_REQUEST_CHANGE_INTERRUPT_ENABLE) |
+	       (1 << VBUS_INTERRUPT_ENABLE),
+	       &dev->regs->pciirqenb1);
+
+	/* don't leave any writes posted */
+	(void)readl(&dev->usb->usbctl);
+}
+
+static void ep0_start(struct net2280 *dev)
+{
+	if (dev->pdev->vendor == 0x17cc)
+		return ep0_start_228x(dev);
+	return ep0_start_338x(dev);
+}
+
 /* when a driver is successfully registered, it will receive
  * control requests including set_configuration(), which enables
  * non-control requests.  then usb traffic follows until a
@@ -1886,7 +2384,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 
 	dev = container_of (_gadget, struct net2280, gadget);
 
-	for (i = 0; i < 7; i++)
+	for (i = 0; i < dev->n_ep; i++)
 		dev->ep [i].irqs = 0;
 
 	/* hook up the driver ... */
@@ -1900,13 +2398,17 @@ static int net2280_start(struct usb_gadget *_gadget,
 	if (retval) goto err_func;
 
 	/* Enable force-full-speed testing mode, if desired */
-	if (full_speed)
+	if (full_speed && dev->pdev->vendor == 0x17cc)
 		writel(1 << FORCE_FULL_SPEED_MODE, &dev->usb->xcvrdiag);
 
 	/* ... then enable host detection and ep0; and we're ready
 	 * for set_configuration as well as eventual disconnect.
 	 */
 	net2280_led_active (dev, 1);
+
+	if (dev->pdev->vendor == 0x10b5)
+		defect7374_enable_data_eps_zero(dev);
+
 	ep0_start (dev);
 
 	DEBUG (dev, "%s ready, usbctl %08x stdrsp %08x\n",
@@ -1937,7 +2439,7 @@ stop_activity (struct net2280 *dev, struct usb_gadget_driver *driver)
 	 * and kill any outstanding requests.
 	 */
 	usb_reset (dev);
-	for (i = 0; i < 7; i++)
+	for (i = 0; i < dev->n_ep; i++)
 		nuke (&dev->ep [i]);
 
 	/* report disconnect; the driver is already quiesced */
@@ -1967,7 +2469,8 @@ static int net2280_stop(struct usb_gadget *_gadget,
 	net2280_led_active (dev, 0);
 
 	/* Disable full-speed test mode */
-	writel(0, &dev->usb->xcvrdiag);
+	if (dev->pdev->vendor == 0x17cc)
+		writel(0, &dev->usb->xcvrdiag);
 
 	device_remove_file (&dev->pdev->dev, &dev_attr_function);
 	device_remove_file (&dev->pdev->dev, &dev_attr_queues);
@@ -2219,6 +2722,350 @@ get_ep_by_addr (struct net2280 *dev, u16 wIndex)
 	return NULL;
 }
 
+static void defect7374_workaround(struct net2280 *dev, struct usb_ctrlrequest r)
+{
+	u32 scratch, fsmvalue;
+	u32 ack_wait_timeout, state;
+
+	/* Workaround for Defect 7374 (U1/U2 erroneously rejected): */
+	scratch = get_idx_reg(dev->regs, SCRATCH);
+	fsmvalue = scratch & (0xf << DEFECT7374_FSM_FIELD);
+	scratch &= ~(0xf << DEFECT7374_FSM_FIELD);
+
+	if (!((fsmvalue == DEFECT7374_FSM_WAITING_FOR_CONTROL_READ) &&
+				(r.bRequestType & USB_DIR_IN)))
+		return;
+
+	/* This is the first Control Read for this connection: */
+	if (!(readl(&dev->usb->usbstat) & (1 << SUPER_SPEED_MODE))) {
+		/*
+		 * Connection is NOT SS:
+		 * - Connection must be FS or HS.
+		 * - This FSM state should allow workaround software to
+		 * run after the next USB connection.
+		 */
+		scratch |= DEFECT7374_FSM_NON_SS_CONTROL_READ;
+		goto restore_data_eps;
+	}
+
+	/* Connection is SS: */
+	for (ack_wait_timeout = 0;
+			ack_wait_timeout < DEFECT_7374_NUMBEROF_MAX_WAIT_LOOPS;
+			ack_wait_timeout++) {
+
+		state =	readl(&dev->plregs->pl_ep_status_1)
+			& (0xff << STATE);
+		if ((state >= (ACK_GOOD_NORMAL << STATE)) &&
+			(state <= (ACK_GOOD_MORE_ACKS_TO_COME << STATE))) {
+			scratch |= DEFECT7374_FSM_SS_CONTROL_READ;
+			break;
+		}
+
+		/*
+		 * We have not yet received host's Data Phase ACK
+		 * - Wait and try again.
+		 */
+		udelay(DEFECT_7374_PROCESSOR_WAIT_TIME);
+
+		continue;
+	}
+
+
+	if (ack_wait_timeout >= DEFECT_7374_NUMBEROF_MAX_WAIT_LOOPS) {
+		ERROR(dev, "FAIL: Defect 7374 workaround waited but failed");
+		ERROR(dev, "to detect SS host's data phase ACK.");
+		ERROR(dev, "PL_EP_STATUS_1(23:16):.Expected from 0x11 to 0x16");
+		ERROR(dev, "got 0x%2.2x.\n", state >> STATE);
+	} else {
+		WARNING(dev, "INFO: Defect 7374 workaround waited about\n");
+		WARNING(dev, "%duSec for Control Read Data Phase ACK\n",
+			DEFECT_7374_PROCESSOR_WAIT_TIME * ack_wait_timeout);
+	}
+
+restore_data_eps:
+	/*
+	 * Restore data EPs to their pre-workaround settings (disabled,
+	 * initialized, and other details).
+	 */
+	defect7374_disable_data_eps(dev);
+
+	set_idx_reg(dev->regs, SCRATCH, scratch);
+
+	return;
+}
+
+static void ep_stall(struct net2280_ep *ep, int stall)
+{
+	struct net2280 *dev = ep->dev;
+	u32 val;
+	static const u32 ep_pl[9] = { 0, 3, 4, 7, 8, 2, 5, 6, 9 };
+
+	if (stall) {
+		writel((1 << SET_ENDPOINT_HALT) |
+		       /* (1 << SET_NAK_PACKETS) | */
+		       (1 << CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE),
+		       &ep->regs->ep_rsp);
+		ep->is_halt = 1;
+	} else {
+		if (dev->gadget.speed == USB_SPEED_SUPER) {
+			/*
+			 * Workaround for SS SeqNum not cleared via
+			 * Endpoint Halt (Clear) bit. select endpoint
+			 */
+			val = readl(&dev->plregs->pl_ep_ctrl);
+			val = (val & ~0x1f) | ep_pl[ep->num];
+			writel(val, &dev->plregs->pl_ep_ctrl);
+
+			val |= (1 << SEQUENCE_NUMBER_RESET);
+			writel(val, &dev->plregs->pl_ep_ctrl);
+		}
+		val = readl(&ep->regs->ep_rsp);
+		val |= (1 << CLEAR_ENDPOINT_HALT) |
+			(1 << CLEAR_ENDPOINT_TOGGLE);
+		writel(val
+		       /* | (1 << CLEAR_NAK_PACKETS)*/
+		       , &ep->regs->ep_rsp);
+		ep->is_halt = 0;
+		val = readl(&ep->regs->ep_rsp);
+	}
+}
+
+static void ep_stdrsp(struct net2280_ep *ep, int value, int wedged)
+{
+	/* set/clear, then synch memory views with the device */
+	if (value) {
+		ep->stopped = 1;
+		if (ep->num == 0)
+			ep->dev->protocol_stall = 1;
+		else {
+			if (ep->dma)
+				ep_stop_dma(ep);
+			ep_stall(ep, true);
+		}
+
+		if (wedged)
+			ep->wedged = 1;
+	} else {
+		ep->stopped = 0;
+		ep->wedged = 0;
+
+		ep_stall(ep, false);
+
+		/* Flush the queue */
+		if (!list_empty(&ep->queue)) {
+			struct net2280_request *req =
+			    list_entry(ep->queue.next, struct net2280_request,
+				       queue);
+			if (ep->dma)
+				resume_dma(ep);
+			else {
+				if (ep->is_in)
+					write_fifo(ep, &req->req);
+				else {
+					if (read_fifo(ep, req))
+						done(ep, req, 0);
+				}
+			}
+		}
+	}
+}
+
+static void handle_stat0_irqs_superspeed(struct net2280 *dev,
+		struct net2280_ep *ep, struct usb_ctrlrequest r)
+{
+	int tmp = 0;
+
+#define	w_value		le16_to_cpu(r.wValue)
+#define	w_index		le16_to_cpu(r.wIndex)
+#define	w_length	le16_to_cpu(r.wLength)
+
+	switch (r.bRequest) {
+		struct net2280_ep *e;
+		u16 status;
+
+	case USB_REQ_SET_CONFIGURATION:
+		dev->addressed_state = !w_value;
+		goto usb3_delegate;
+
+	case USB_REQ_GET_STATUS:
+		switch (r.bRequestType) {
+		case (USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE):
+			status = dev->wakeup_enable ? 0x02 : 0x00;
+			if (dev->selfpowered)
+				status |= 1 << 0;
+			status |= (dev->u1_enable << 2 | dev->u2_enable << 3 |
+							dev->ltm_enable << 4);
+			writel(0, &dev->epregs[0].ep_irqenb);
+			set_fifo_bytecount(ep, sizeof(status));
+			writel((__force u32) status, &dev->epregs[0].ep_data);
+			allow_status_338x(ep);
+			break;
+
+		case (USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_ENDPOINT):
+			e = get_ep_by_addr(dev, w_index);
+			if (!e)
+				goto do_stall3;
+			status = readl(&e->regs->ep_rsp) &
+						(1 << CLEAR_ENDPOINT_HALT);
+			writel(0, &dev->epregs[0].ep_irqenb);
+			set_fifo_bytecount(ep, sizeof(status));
+			writel((__force u32) status, &dev->epregs[0].ep_data);
+			allow_status_338x(ep);
+			break;
+
+		default:
+			goto usb3_delegate;
+		}
+		break;
+
+	case USB_REQ_CLEAR_FEATURE:
+		switch (r.bRequestType) {
+		case (USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE):
+			if (!dev->addressed_state) {
+				switch (w_value) {
+				case USB_DEVICE_U1_ENABLE:
+					dev->u1_enable = 0;
+					writel(readl(&dev->usb_ext->usbctl2) &
+						~(1 << U1_ENABLE),
+						&dev->usb_ext->usbctl2);
+					allow_status_338x(ep);
+					goto next_endpoints3;
+
+				case USB_DEVICE_U2_ENABLE:
+					dev->u2_enable = 0;
+					writel(readl(&dev->usb_ext->usbctl2) &
+						~(1 << U2_ENABLE),
+						&dev->usb_ext->usbctl2);
+					allow_status_338x(ep);
+					goto next_endpoints3;
+
+				case USB_DEVICE_LTM_ENABLE:
+					dev->ltm_enable = 0;
+					writel(readl(&dev->usb_ext->usbctl2) &
+						~(1 << LTM_ENABLE),
+						&dev->usb_ext->usbctl2);
+					allow_status_338x(ep);
+					goto next_endpoints3;
+
+				default:
+					break;
+				}
+			}
+			if (w_value == USB_DEVICE_REMOTE_WAKEUP) {
+				dev->wakeup_enable = 0;
+				writel(readl(&dev->usb->usbctl) &
+					~(1 << DEVICE_REMOTE_WAKEUP_ENABLE),
+					&dev->usb->usbctl);
+				allow_status_338x(ep);
+				break;
+			}
+			goto usb3_delegate;
+
+		case (USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_ENDPOINT):
+			e = get_ep_by_addr(dev,	w_index);
+			if (!e)
+				goto do_stall3;
+			if (w_value != USB_ENDPOINT_HALT)
+				goto do_stall3;
+			VDEBUG(dev, "%s clear halt\n", e->ep.name);
+			ep_stall(e, false);
+			if (!list_empty(&e->queue) && e->td_dma)
+				restart_dma(e);
+			allow_status(ep);
+			ep->stopped = 1;
+			break;
+
+		default:
+			goto usb3_delegate;
+		}
+		break;
+	case USB_REQ_SET_FEATURE:
+		switch (r.bRequestType) {
+		case (USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE):
+			if (!dev->addressed_state) {
+				switch (w_value) {
+				case USB_DEVICE_U1_ENABLE:
+					dev->u1_enable = 1;
+					writel(readl(&dev->usb_ext->usbctl2) |
+						(1 << U1_ENABLE),
+						&dev->usb_ext->usbctl2);
+					allow_status_338x(ep);
+					goto next_endpoints3;
+
+				case USB_DEVICE_U2_ENABLE:
+					dev->u2_enable = 1;
+					writel(readl(&dev->usb_ext->usbctl2) |
+						(1 << U2_ENABLE),
+						&dev->usb_ext->usbctl2);
+					allow_status_338x(ep);
+					goto next_endpoints3;
+
+				case USB_DEVICE_LTM_ENABLE:
+					dev->ltm_enable = 1;
+					writel(readl(&dev->usb_ext->usbctl2) |
+						(1 << LTM_ENABLE),
+						&dev->usb_ext->usbctl2);
+					allow_status_338x(ep);
+					goto next_endpoints3;
+				default:
+					break;
+				}
+			}
+
+			if (w_value == USB_DEVICE_REMOTE_WAKEUP) {
+				dev->wakeup_enable = 1;
+				writel(readl(&dev->usb->usbctl) |
+					(1 << DEVICE_REMOTE_WAKEUP_ENABLE),
+					&dev->usb->usbctl);
+				allow_status_338x(ep);
+				break;
+			}
+			goto usb3_delegate;
+
+		case (USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_ENDPOINT):
+			e = get_ep_by_addr(dev,	w_index);
+			if (!e || (w_value != USB_ENDPOINT_HALT))
+				goto do_stall3;
+			ep_stdrsp(e, true, false);
+			allow_status_338x(ep);
+			break;
+
+		default:
+			goto usb3_delegate;
+		}
+
+		break;
+	default:
+
+usb3_delegate:
+		VDEBUG(dev, "setup %02x.%02x v%04x i%04x l%04x ep_cfg %08x\n",
+				r.bRequestType, r.bRequest,
+				w_value, w_index, w_length,
+				readl(&ep->cfg->ep_cfg));
+
+		ep->responded = 0;
+		spin_unlock(&dev->lock);
+		tmp = dev->driver->setup(&dev->gadget, &r);
+		spin_lock(&dev->lock);
+	}
+do_stall3:
+	if (tmp < 0) {
+		VDEBUG(dev, "req %02x.%02x protocol STALL; stat %d\n",
+				r.bRequestType, r.bRequest, tmp);
+		dev->protocol_stall = 1;
+		/* TD 9.9 Halt Endpoint test. TD 9.22 Set feature test */
+		ep_stall(ep, true);
+	}
+
+next_endpoints3:
+
+#undef	w_value
+#undef	w_index
+#undef	w_length
+
+	return;
+}
+
 static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 {
 	struct net2280_ep	*ep;
@@ -2240,10 +3087,20 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 		struct net2280_request		*req;
 
 		if (dev->gadget.speed == USB_SPEED_UNKNOWN) {
-			if (readl (&dev->usb->usbstat) & (1 << HIGH_SPEED))
+			u32 val = readl(&dev->usb->usbstat);
+			if (val & (1 << SUPER_SPEED)) {
+				dev->gadget.speed = USB_SPEED_SUPER;
+				usb_ep_set_maxpacket_limit(&dev->ep[0].ep,
+						EP0_SS_MAX_PACKET_SIZE);
+			} else if (val & (1 << HIGH_SPEED)) {
 				dev->gadget.speed = USB_SPEED_HIGH;
-			else
+				usb_ep_set_maxpacket_limit(&dev->ep[0].ep,
+						EP0_HS_MAX_PACKET_SIZE);
+			} else {
 				dev->gadget.speed = USB_SPEED_FULL;
+				usb_ep_set_maxpacket_limit(&dev->ep[0].ep,
+						EP0_HS_MAX_PACKET_SIZE);
+			}
 			net2280_led_speed (dev, dev->gadget.speed);
 			DEBUG(dev, "%s\n", usb_speed_string(dev->gadget.speed));
 		}
@@ -2261,32 +3118,38 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 		}
 		ep->stopped = 0;
 		dev->protocol_stall = 0;
-
-		if (ep->dev->pdev->device == 0x2280)
-			tmp = (1 << FIFO_OVERFLOW)
-				| (1 << FIFO_UNDERFLOW);
-		else
-			tmp = 0;
-
-		writel (tmp | (1 << TIMEOUT)
-			| (1 << USB_STALL_SENT)
-			| (1 << USB_IN_NAK_SENT)
-			| (1 << USB_IN_ACK_RCVD)
-			| (1 << USB_OUT_PING_NAK_SENT)
-			| (1 << USB_OUT_ACK_SENT)
-			| (1 << SHORT_PACKET_OUT_DONE_INTERRUPT)
-			| (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT)
-			| (1 << DATA_PACKET_RECEIVED_INTERRUPT)
-			| (1 << DATA_PACKET_TRANSMITTED_INTERRUPT)
-			| (1 << DATA_OUT_PING_TOKEN_INTERRUPT)
-			| (1 << DATA_IN_TOKEN_INTERRUPT)
-			, &ep->regs->ep_stat);
-		u.raw [0] = readl (&dev->usb->setup0123);
-		u.raw [1] = readl (&dev->usb->setup4567);
+		if (dev->pdev->vendor == 0x10b5)
+			ep->is_halt = 0;
+		else{
+			if (ep->dev->pdev->device == 0x2280)
+				tmp = (1 << FIFO_OVERFLOW) |
+				    (1 << FIFO_UNDERFLOW);
+			else
+				tmp = 0;
+
+			writel(tmp | (1 << TIMEOUT) |
+				   (1 << USB_STALL_SENT) |
+				   (1 << USB_IN_NAK_SENT) |
+				   (1 << USB_IN_ACK_RCVD) |
+				   (1 << USB_OUT_PING_NAK_SENT) |
+				   (1 << USB_OUT_ACK_SENT) |
+				   (1 << SHORT_PACKET_OUT_DONE_INTERRUPT) |
+				   (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT) |
+				   (1 << DATA_PACKET_RECEIVED_INTERRUPT) |
+				   (1 << DATA_PACKET_TRANSMITTED_INTERRUPT) |
+				   (1 << DATA_OUT_PING_TOKEN_INTERRUPT) |
+				   (1 << DATA_IN_TOKEN_INTERRUPT)
+				   , &ep->regs->ep_stat);
+		}
+		u.raw[0] = readl(&dev->usb->setup0123);
+		u.raw[1] = readl(&dev->usb->setup4567);
 
 		cpu_to_le32s (&u.raw [0]);
 		cpu_to_le32s (&u.raw [1]);
 
+		if (dev->pdev->vendor == 0x10b5)
+			defect7374_workaround(dev, u.r);
+
 		tmp = 0;
 
 #define	w_value		le16_to_cpu(u.r.wValue)
@@ -2318,6 +3181,12 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 		 * everything else goes uplevel to the gadget code.
 		 */
 		ep->responded = 1;
+
+		if (dev->gadget.speed == USB_SPEED_SUPER) {
+			handle_stat0_irqs_superspeed(dev, ep, u.r);
+			goto next_endpoints;
+		}
+
 		switch (u.r.bRequest) {
 		case USB_REQ_GET_STATUS: {
 			struct net2280_ep	*e;
@@ -2360,8 +3229,11 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 				VDEBUG(dev, "%s wedged, halt not cleared\n",
 						ep->ep.name);
 			} else {
-				VDEBUG(dev, "%s clear halt\n", ep->ep.name);
+				VDEBUG(dev, "%s clear halt\n", e->ep.name);
 				clear_halt(e);
+				if (ep->dev->pdev->vendor == 0x10b5 &&
+					!list_empty(&e->queue) && e->td_dma)
+						restart_dma(e);
 			}
 			allow_status (ep);
 			goto next_endpoints;
@@ -2381,6 +3253,8 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			if (e->ep.name == ep0name)
 				goto do_stall;
 			set_halt (e);
+			if (dev->pdev->vendor == 0x10b5 && e->dma)
+				abort_dma(e);
 			allow_status (ep);
 			VDEBUG (dev, "%s set halt\n", ep->ep.name);
 			goto next_endpoints;
@@ -2392,7 +3266,7 @@ delegate:
 				"ep_cfg %08x\n",
 				u.r.bRequestType, u.r.bRequest,
 				w_value, w_index, w_length,
-				readl (&ep->regs->ep_cfg));
+				readl(&ep->cfg->ep_cfg));
 			ep->responded = 0;
 			spin_unlock (&dev->lock);
 			tmp = dev->driver->setup (&dev->gadget, &u.r);
@@ -2455,7 +3329,7 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 
 	/* after disconnect there's nothing else to do! */
 	tmp = (1 << VBUS_INTERRUPT) | (1 << ROOT_PORT_RESET_INTERRUPT);
-	mask = (1 << HIGH_SPEED) | (1 << FULL_SPEED);
+	mask = (1 << SUPER_SPEED) | (1 << HIGH_SPEED) | (1 << FULL_SPEED);
 
 	/* VBUS disconnect is indicated by VBUS_PIN and VBUS_INTERRUPT set.
 	 * Root Port Reset is indicated by ROOT_PORT_RESET_INTERRUPT set and
@@ -2546,12 +3420,19 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 		tmp = readl (&dma->dmastat);
 		writel (tmp, &dma->dmastat);
 
+		/* dma sync*/
+		if (dev->pdev->vendor == 0x10b5) {
+			u32 r_dmacount = readl(&dma->dmacount);
+			if (!ep->is_in &&  (r_dmacount & 0x00FFFFFF) &&
+			    (tmp & (1 << DMA_TRANSACTION_DONE_INTERRUPT)))
+				continue;
+		}
+
 		/* chaining should stop on abort, short OUT from fifo,
 		 * or (stat0 codepath) short OUT transfer.
 		 */
 		if (!use_dma_chaining) {
-			if ((tmp & (1 << DMA_TRANSACTION_DONE_INTERRUPT))
-					== 0) {
+			if (!(tmp & (1 << DMA_TRANSACTION_DONE_INTERRUPT))) {
 				DEBUG (ep->dev, "%s no xact done? %08x\n",
 					ep->ep.name, tmp);
 				continue;
@@ -2625,7 +3506,8 @@ static irqreturn_t net2280_irq (int irq, void *_dev)
 	struct net2280		*dev = _dev;
 
 	/* shared interrupt, not ours */
-	if (!(readl(&dev->regs->irqstat0) & (1 << INTA_ASSERTED)))
+	if (dev->pdev->vendor == 0x17cc &&
+		(!(readl(&dev->regs->irqstat0) & (1 << INTA_ASSERTED))))
 		return IRQ_NONE;
 
 	spin_lock (&dev->lock);
@@ -2636,6 +3518,13 @@ static irqreturn_t net2280_irq (int irq, void *_dev)
 	/* control requests and PIO */
 	handle_stat0_irqs (dev, readl (&dev->regs->irqstat0));
 
+	if (dev->pdev->vendor == 0x10b5) {
+		/* re-enable interrupt to trigger any possible new interrupt */
+		u32 pciirqenb1 = readl(&dev->regs->pciirqenb1);
+		writel(pciirqenb1 & 0x7FFFFFFF, &dev->regs->pciirqenb1);
+		writel(pciirqenb1, &dev->regs->pciirqenb1);
+	}
+
 	spin_unlock (&dev->lock);
 
 	return IRQ_HANDLED;
@@ -2674,6 +3563,8 @@ static void net2280_remove (struct pci_dev *pdev)
 	}
 	if (dev->got_irq)
 		free_irq (pdev->irq, dev);
+	if (use_msi && dev->pdev->vendor == 0x10b5)
+		pci_disable_msi(pdev);
 	if (dev->regs)
 		iounmap (dev->regs);
 	if (dev->region)
@@ -2708,7 +3599,8 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init (&dev->lock);
 	dev->pdev = pdev;
 	dev->gadget.ops = &net2280_ops;
-	dev->gadget.max_speed = USB_SPEED_HIGH;
+	dev->gadget.max_speed = (dev->pdev->vendor == 0x10b5) ?
+				USB_SPEED_SUPER : USB_SPEED_HIGH;
 
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev->gadget.name = driver_name;
@@ -2750,8 +3642,39 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->dep = (struct net2280_dep_regs __iomem *) (base + 0x0200);
 	dev->epregs = (struct net2280_ep_regs __iomem *) (base + 0x0300);
 
-	/* put into initial config, link up all endpoints */
-	writel (0, &dev->usb->usbctl);
+	if (dev->pdev->vendor == 0x10b5) {
+		u32 fsmvalue;
+		u32 usbstat;
+		dev->usb_ext = (struct usb338x_usb_ext_regs __iomem *)
+							(base + 0x00b4);
+		dev->fiforegs = (struct usb338x_fifo_regs __iomem *)
+							(base + 0x0500);
+		dev->llregs = (struct usb338x_ll_regs __iomem *)
+							(base + 0x0700);
+		dev->ll_lfps_regs = (struct usb338x_ll_lfps_regs __iomem *)
+							(base + 0x0748);
+		dev->ll_tsn_regs = (struct usb338x_ll_tsn_regs __iomem *)
+							(base + 0x077c);
+		dev->ll_chicken_reg = (struct usb338x_ll_chi_regs __iomem *)
+							(base + 0x079c);
+		dev->plregs = (struct usb338x_pl_regs __iomem *)
+							(base + 0x0800);
+		usbstat = readl(&dev->usb->usbstat);
+		dev->enhanced_mode = (usbstat & (1 << 11)) ? 1 : 0;
+		dev->n_ep = (dev->enhanced_mode) ? 9 : 5;
+		/* put into initial config, link up all endpoints */
+		fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
+					(0xf << DEFECT7374_FSM_FIELD);
+		/* See if firmware needs to set up for workaround: */
+		if (fsmvalue == DEFECT7374_FSM_SS_CONTROL_READ)
+			writel(0, &dev->usb->usbctl);
+	} else{
+		dev->enhanced_mode = 0;
+		dev->n_ep = 7;
+		/* put into initial config, link up all endpoints */
+		writel(0, &dev->usb->usbctl);
+	}
+
 	usb_reset (dev);
 	usb_reinit (dev);
 
@@ -2762,6 +3685,10 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 		goto done;
 	}
 
+	if (use_msi && dev->pdev->vendor == 0x10b5)
+		if (pci_enable_msi(pdev))
+			ERROR(dev, "Failed to enable MSI mode\n");
+
 	if (request_irq (pdev->irq, net2280_irq, IRQF_SHARED, driver_name, dev)
 			!= 0) {
 		ERROR (dev, "request interrupt %d failed\n", pdev->irq);
@@ -2797,7 +3724,8 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* enable lower-overhead pci memory bursts during DMA */
-	writel ( (1 << DMA_MEMORY_WRITE_AND_INVALIDATE_ENABLE)
+	if (dev->pdev->vendor == 0x17cc)
+		writel((1 << DMA_MEMORY_WRITE_AND_INVALIDATE_ENABLE)
 			// 256 write retries may not be enough...
 			// | (1 << PCI_RETRY_ABORT_ENABLE)
 			| (1 << DMA_READ_MULTIPLE_ENABLE)
@@ -2814,10 +3742,10 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	INFO (dev, "%s\n", driver_desc);
 	INFO (dev, "irq %d, pci mem %p, chip rev %04x\n",
 			pdev->irq, base, dev->chiprev);
-	INFO (dev, "version: " DRIVER_VERSION "; dma %s\n",
-			use_dma
-				? (use_dma_chaining ? "chaining" : "enabled")
-				: "disabled");
+	INFO(dev, "version: " DRIVER_VERSION "; dma %s %s\n",
+		use_dma	? (use_dma_chaining ? "chaining" : "enabled")
+			: "disabled",
+		dev->enhanced_mode ? "enhanced mode" : "legacy mode");
 	retval = device_create_file (&pdev->dev, &dev_attr_registers);
 	if (retval) goto done;
 
@@ -2849,7 +3777,8 @@ static void net2280_shutdown (struct pci_dev *pdev)
 	writel (0, &dev->usb->usbctl);
 
 	/* Disable full-speed test mode */
-	writel(0, &dev->usb->xcvrdiag);
+	if (dev->pdev->vendor == 0x17cc)
+		writel(0, &dev->usb->xcvrdiag);
 }
 
 
@@ -2869,8 +3798,24 @@ static const struct pci_device_id pci_ids [] = { {
 	.device =	0x2282,
 	.subvendor =	PCI_ANY_ID,
 	.subdevice =	PCI_ANY_ID,
-
-}, { /* end: all zeroes */ }
+},
+	{
+	 .class = ((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
+	 .class_mask = ~0,
+	 .vendor = 0x10b5,
+	 .device = 0x3380,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	 },
+	{
+	 .class = ((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
+	 .class_mask = ~0,
+	 .vendor = 0x10b5,
+	 .device = 0x3382,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	 },
+{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE (pci, pci_ids);
 
diff --git a/drivers/usb/gadget/net2280.h b/drivers/usb/gadget/net2280.h
index a844be0..f32c274 100644
--- a/drivers/usb/gadget/net2280.h
+++ b/drivers/usb/gadget/net2280.h
@@ -6,6 +6,7 @@
 /*
  * Copyright (C) 2002 NetChip Technology, Inc. (http://www.netchip.com)
  * Copyright (C) 2003 David Brownell
+ * Copyright (C) 2014 Ricardo Ribalda - Qtechnology/AS
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -14,6 +15,7 @@
  */
 
 #include <linux/usb/net2280.h>
+#include <linux/usb/usb338x.h>
 
 /*-------------------------------------------------------------------------*/
 
@@ -59,6 +61,13 @@ set_idx_reg (struct net2280_regs __iomem *regs, u32 index, u32 value)
 #define	CHIPREV_1	0x0100
 #define	CHIPREV_1A	0x0110
 
+/* DEFECT 7374 */
+#define DEFECT_7374_NUMBEROF_MAX_WAIT_LOOPS         200
+#define DEFECT_7374_PROCESSOR_WAIT_TIME             10
+
+/* ep0 max packet size */
+#define EP0_SS_MAX_PACKET_SIZE  0x200
+#define EP0_HS_MAX_PACKET_SIZE  0x40
 #ifdef	__KERNEL__
 
 /* ep a-f highspeed and fullspeed maxpacket, addresses
@@ -85,12 +94,15 @@ struct net2280_dma {
 
 struct net2280_ep {
 	struct usb_ep				ep;
+	struct net2280_ep_regs __iomem *cfg;
 	struct net2280_ep_regs			__iomem *regs;
 	struct net2280_dma_regs			__iomem *dma;
 	struct net2280_dma			*dummy;
+	struct usb338x_fifo_regs __iomem *fiforegs;
 	dma_addr_t				td_dma;	/* of dummy */
 	struct net2280				*dev;
 	unsigned long				irqs;
+	unsigned is_halt:1, dma_started:1;
 
 	/* analogous to a host-side qh */
 	struct list_head			queue;
@@ -116,10 +128,19 @@ static inline void allow_status (struct net2280_ep *ep)
 	ep->stopped = 1;
 }
 
-/* count (<= 4) bytes in the next fifo write will be valid */
-static inline void set_fifo_bytecount (struct net2280_ep *ep, unsigned count)
+static void allow_status_338x(struct net2280_ep *ep)
 {
-	writeb (count, 2 + (u8 __iomem *) &ep->regs->ep_cfg);
+	/*
+	 * Control Status Phase Handshake was set by the chip when the setup
+	 * packet arrived. While set, the chip automatically NAKs the host's
+	 * Status Phase tokens.
+	 */
+	writel(1 << CLEAR_CONTROL_STATUS_PHASE_HANDSHAKE, &ep->regs->ep_rsp);
+
+	ep->stopped = 1;
+
+	/* TD 9.9 Halt Endpoint test.  TD 9.22 set feature test. */
+	ep->responded = 0;
 }
 
 struct net2280_request {
@@ -135,23 +156,38 @@ struct net2280 {
 	/* each pci device provides one gadget, several endpoints */
 	struct usb_gadget		gadget;
 	spinlock_t			lock;
-	struct net2280_ep		ep [7];
+	struct net2280_ep		ep[9];
 	struct usb_gadget_driver 	*driver;
 	unsigned			enabled : 1,
 					protocol_stall : 1,
 					softconnect : 1,
 					got_irq : 1,
-					region : 1;
+					region:1,
+					u1_enable:1,
+					u2_enable:1,
+					ltm_enable:1,
+					wakeup_enable:1,
+					selfpowered:1,
+					addressed_state:1;
 	u16				chiprev;
+	int enhanced_mode;
+	int n_ep;
 
 	/* pci state used to access those endpoints */
 	struct pci_dev			*pdev;
 	struct net2280_regs		__iomem *regs;
 	struct net2280_usb_regs		__iomem *usb;
+	struct usb338x_usb_ext_regs	__iomem *usb_ext;
 	struct net2280_pci_regs		__iomem *pci;
 	struct net2280_dma_regs		__iomem *dma;
 	struct net2280_dep_regs		__iomem *dep;
 	struct net2280_ep_regs		__iomem *epregs;
+	struct usb338x_fifo_regs	__iomem *fiforegs;
+	struct usb338x_ll_regs		__iomem *llregs;
+	struct usb338x_ll_lfps_regs	__iomem *ll_lfps_regs;
+	struct usb338x_ll_tsn_regs	__iomem *ll_tsn_regs;
+	struct usb338x_ll_chi_regs	__iomem *ll_chicken_reg;
+	struct usb338x_pl_regs		__iomem *plregs;
 
 	struct pci_pool			*requests;
 	// statistics...
@@ -179,6 +215,43 @@ static inline void clear_halt (struct net2280_ep *ep)
 		, &ep->regs->ep_rsp);
 }
 
+/*
+ * FSM value for Defect 7374 (U1U2 Test) is managed in
+ * chip's SCRATCH register:
+ */
+#define DEFECT7374_FSM_FIELD    28
+
+/* Waiting for Control Read:
+ *  - A transition to this state indicates a fresh USB connection,
+ *    before the first Setup Packet. The connection speed is not
+ *    known. Firmware is waiting for the first Control Read.
+ *  - Starting state: This state can be thought of as the FSM's typical
+ *    starting state.
+ *  - Tip: Upon the first SS Control Read the FSM never
+ *    returns to this state.
+ */
+#define DEFECT7374_FSM_WAITING_FOR_CONTROL_READ (1 << DEFECT7374_FSM_FIELD)
+
+/* Non-SS Control Read:
+ *  - A transition to this state indicates detection of the first HS
+ *    or FS Control Read.
+ *  - Tip: Upon the first SS Control Read the FSM never
+ *    returns to this state.
+ */
+#define	DEFECT7374_FSM_NON_SS_CONTROL_READ (2 << DEFECT7374_FSM_FIELD)
+
+/* SS Control Read:
+ *  - A transition to this state indicates detection of the
+ *    first SS Control Read.
+ *  - This state indicates workaround completion. Workarounds no longer
+ *    need to be applied (as long as the chip remains powered up).
+ *  - Tip: Once in this state the FSM state does not change (until
+ *    the chip's power is lost and restored).
+ *  - This can be thought of as the final state of the FSM;
+ *    the FSM 'locks-up' in this state until the chip loses power.
+ */
+#define DEFECT7374_FSM_SS_CONTROL_READ (3 << DEFECT7374_FSM_FIELD)
+
 #ifdef USE_RDK_LEDS
 
 static inline void net2280_led_init (struct net2280 *dev)
@@ -198,6 +271,9 @@ void net2280_led_speed (struct net2280 *dev, enum usb_device_speed speed)
 {
 	u32	val = readl (&dev->regs->gpioctl);
 	switch (speed) {
+	case USB_SPEED_SUPER:		/* green + red */
+		val |= (1 << GPIO0_DATA) | (1 << GPIO1_DATA);
+		break;
 	case USB_SPEED_HIGH:		/* green */
 		val &= ~(1 << GPIO0_DATA);
 		val |= (1 << GPIO1_DATA);
@@ -271,6 +347,17 @@ static inline void net2280_led_shutdown (struct net2280 *dev)
 
 /*-------------------------------------------------------------------------*/
 
+static inline void set_fifo_bytecount(struct net2280_ep *ep, unsigned count)
+{
+	if (ep->dev->pdev->vendor == 0x17cc)
+		writeb(count, 2 + (u8 __iomem *) &ep->regs->ep_cfg);
+	else{
+		u32 tmp = readl(&ep->cfg->ep_cfg) &
+					(~(0x07 << EP_FIFO_BYTE_COUNT));
+		writel(tmp | (count << EP_FIFO_BYTE_COUNT), &ep->cfg->ep_cfg);
+	}
+}
+
 static inline void start_out_naking (struct net2280_ep *ep)
 {
 	/* NOTE:  hardware races lurk here, and PING protocol issues */
diff --git a/include/linux/usb/usb338x.h b/include/linux/usb/usb338x.h
new file mode 100644
index 0000000..f92eb63
--- /dev/null
+++ b/include/linux/usb/usb338x.h
@@ -0,0 +1,199 @@
+/*
+ * USB 338x super/high/full speed USB device controller.
+ * Unlike many such controllers, this one talks PCI.
+ *
+ * Copyright (C) 2002 NetChip Technology, Inc. (http://www.netchip.com)
+ * Copyright (C) 2003 David Brownell
+ * Copyright (C) 2014 Ricardo Ribalda - Qtechnology/AS
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __LINUX_USB_USB338X_H
+#define __LINUX_USB_USB338X_H
+
+#include <linux/usb/net2280.h>
+
+/*
+ * Extra defined bits for net2280 registers
+ */
+#define     SCRATCH			      0x0b
+
+#define     DEFECT7374_FSM_FIELD                28
+#define     SUPER_SPEED				 8
+#define     DMA_REQUEST_OUTSTANDING              5
+#define     DMA_PAUSE_DONE_INTERRUPT            26
+#define     SET_ISOCHRONOUS_DELAY               24
+#define     SET_SEL                             22
+#define     SUPER_SPEED_MODE                     8
+
+/*ep_cfg*/
+#define     MAX_BURST_SIZE                      24
+#define     EP_FIFO_BYTE_COUNT                  16
+#define     IN_ENDPOINT_ENABLE                  14
+#define     IN_ENDPOINT_TYPE                    12
+#define     OUT_ENDPOINT_ENABLE                 10
+#define     OUT_ENDPOINT_TYPE                    8
+
+struct usb338x_usb_ext_regs {
+	u32     usbclass;
+#define     DEVICE_PROTOCOL                     16
+#define     DEVICE_SUB_CLASS                     8
+#define     DEVICE_CLASS                         0
+	u32     ss_sel;
+#define     U2_SYSTEM_EXIT_LATENCY               8
+#define     U1_SYSTEM_EXIT_LATENCY               0
+	u32     ss_del;
+#define     U2_DEVICE_EXIT_LATENCY               8
+#define     U1_DEVICE_EXIT_LATENCY               0
+	u32     usb2lpm;
+#define     USB_L1_LPM_HIRD                      2
+#define     USB_L1_LPM_REMOTE_WAKE               1
+#define     USB_L1_LPM_SUPPORT                   0
+	u32     usb3belt;
+#define     BELT_MULTIPLIER                     10
+#define     BEST_EFFORT_LATENCY_TOLERANCE        0
+	u32     usbctl2;
+#define     LTM_ENABLE                           7
+#define     U2_ENABLE                            6
+#define     U1_ENABLE                            5
+#define     FUNCTION_SUSPEND                     4
+#define     USB3_CORE_ENABLE                     3
+#define     USB2_CORE_ENABLE                     2
+#define     SERIAL_NUMBER_STRING_ENABLE          0
+	u32     in_timeout;
+#define     GPEP3_TIMEOUT                       19
+#define     GPEP2_TIMEOUT                       18
+#define     GPEP1_TIMEOUT                       17
+#define     GPEP0_TIMEOUT                       16
+#define     GPEP3_TIMEOUT_VALUE                 13
+#define     GPEP3_TIMEOUT_ENABLE                12
+#define     GPEP2_TIMEOUT_VALUE                  9
+#define     GPEP2_TIMEOUT_ENABLE                 8
+#define     GPEP1_TIMEOUT_VALUE                  5
+#define     GPEP1_TIMEOUT_ENABLE                 4
+#define     GPEP0_TIMEOUT_VALUE                  1
+#define     GPEP0_TIMEOUT_ENABLE                 0
+	u32     isodelay;
+#define     ISOCHRONOUS_DELAY                    0
+} __packed;
+
+struct usb338x_fifo_regs {
+	/* offset 0x0500, 0x0520, 0x0540, 0x0560, 0x0580 */
+	u32     ep_fifo_size_base;
+#define     IN_FIFO_BASE_ADDRESS                                22
+#define     IN_FIFO_SIZE                                        16
+#define     OUT_FIFO_BASE_ADDRESS                               6
+#define     OUT_FIFO_SIZE                                       0
+	u32     ep_fifo_out_wrptr;
+	u32     ep_fifo_out_rdptr;
+	u32     ep_fifo_in_wrptr;
+	u32     ep_fifo_in_rdptr;
+	u32     unused[3];
+} __packed;
+
+
+/* Link layer */
+struct usb338x_ll_regs {
+	/* offset 0x700 */
+	u32   ll_ltssm_ctrl1;
+	u32   ll_ltssm_ctrl2;
+	u32   ll_ltssm_ctrl3;
+	u32   unused[2];
+	u32   ll_general_ctrl0;
+	u32   ll_general_ctrl1;
+#define     PM_U3_AUTO_EXIT                                     29
+#define     PM_U2_AUTO_EXIT                                     28
+#define     PM_U1_AUTO_EXIT                                     27
+#define     PM_FORCE_U2_ENTRY                                   26
+#define     PM_FORCE_U1_ENTRY                                   25
+#define     PM_LGO_COLLISION_SEND_LAU                           24
+#define     PM_DIR_LINK_REJECT                                  23
+#define     PM_FORCE_LINK_ACCEPT                                22
+#define     PM_DIR_ENTRY_U3                                     20
+#define     PM_DIR_ENTRY_U2                                     19
+#define     PM_DIR_ENTRY_U1                                     18
+#define     PM_U2_ENABLE                                        17
+#define     PM_U1_ENABLE                                        16
+#define     SKP_THRESHOLD_ADJUST_FMW                            8
+#define     RESEND_DPP_ON_LRTY_FMW                              7
+#define     DL_BIT_VALUE_FMW                                    6
+#define     FORCE_DL_BIT                                        5
+	u32   ll_general_ctrl2;
+#define     SELECT_INVERT_LANE_POLARITY                         7
+#define     FORCE_INVERT_LANE_POLARITY                          6
+	u32   ll_general_ctrl3;
+	u32   ll_general_ctrl4;
+	u32   ll_error_gen;
+} __packed;
+
+struct usb338x_ll_lfps_regs {
+	/* offset 0x748 */
+	u32   ll_lfps_5;
+#define     TIMER_LFPS_6US                                      16
+	u32   ll_lfps_6;
+#define     TIMER_LFPS_80US                                     0
+} __packed;
+
+struct usb338x_ll_tsn_regs {
+	/* offset 0x77C */
+	u32   ll_tsn_counters_2;
+#define     HOT_TX_NORESET_TS2                                  24
+	u32   ll_tsn_counters_3;
+#define     HOT_RX_RESET_TS2                                    0
+} __packed;
+
+struct usb338x_ll_chi_regs {
+	/* offset 0x79C */
+	u32   ll_tsn_chicken_bit;
+#define     RECOVERY_IDLE_TO_RECOVER_FMW                        3
+} __packed;
+
+/* protocol layer */
+struct usb338x_pl_regs {
+	/* offset 0x800 */
+	u32   pl_reg_1;
+	u32   pl_reg_2;
+	u32   pl_reg_3;
+	u32   pl_reg_4;
+	u32   pl_ep_ctrl;
+	/* Protocol Layer Endpoint Control*/
+#define     PL_EP_CTRL                                  0x810
+#define     ENDPOINT_SELECT                             0
+	/* [4:0] */
+#define     EP_INITIALIZED                              16
+#define     SEQUENCE_NUMBER_RESET                       17
+#define     CLEAR_ACK_ERROR_CODE                        20
+	u32   pl_reg_6;
+	u32   pl_reg_7;
+	u32   pl_reg_8;
+	u32   pl_ep_status_1;
+	/* Protocol Layer Endpoint Status 1*/
+#define     PL_EP_STATUS_1                              0x820
+#define     STATE                                       16
+#define     ACK_GOOD_NORMAL                             0x11
+#define     ACK_GOOD_MORE_ACKS_TO_COME                  0x16
+	u32   pl_ep_status_2;
+	u32   pl_ep_status_3;
+	/* Protocol Layer Endpoint Status 3*/
+#define     PL_EP_STATUS_3                              0x828
+#define     SEQUENCE_NUMBER                             0
+	u32   pl_ep_status_4;
+	/* Protocol Layer Endpoint Status 4*/
+#define     PL_EP_STATUS_4                              0x82c
+	u32   pl_ep_cfg_4;
+	/* Protocol Layer Endpoint Configuration 4*/
+#define     PL_EP_CFG_4                                 0x830
+#define     NON_CTRL_IN_TOLERATE_BAD_DIR                6
+} __packed;
+
+#endif /* __LINUX_USB_USB338X_H */
-- 
2.0.0.rc0

