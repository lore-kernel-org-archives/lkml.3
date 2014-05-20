Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaETQab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:30:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53389 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbaETQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:30:24 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 02/10] usb: gadget: net2280: Dont use magic numbers
Date: Tue, 20 May 2014 18:30:04 +0200
Message-Id: <1400603412-19406-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using magic numbers use #defines

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 68 +++++++++++++++++++++++---------------------
 drivers/usb/gadget/net2280.h |  1 +
 2 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 8112d91..ba1fdd8 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -152,7 +152,7 @@ static inline void enable_pciirqenb(struct net2280_ep *ep)
 {
 	u32 tmp = readl(&ep->dev->regs->pciirqenb0);
 
-	if (ep->dev->pdev->vendor == 0x17cc)
+	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		tmp |= 1 << ep->num;
 	else
 		tmp |= 1 << ep_bit[ep->num];
@@ -182,7 +182,7 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	if ((desc->bEndpointAddress & 0x0f) == EP_DONTUSE)
 		return -EDOM;
 
-	if (dev->pdev->vendor == 0x10b5) {
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
 		if ((desc->bEndpointAddress & 0x0f) >= 0x0c)
 			return -EDOM;
 		ep->is_in = !!usb_endpoint_dir_in(desc);
@@ -192,7 +192,8 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 
 	/* sanity check ep-e/ep-f since their fifos are small */
 	max = usb_endpoint_maxp (desc) & 0x1fff;
-	if (ep->num > 4 && max > 64 && (dev->pdev->vendor == 0x17cc))
+	if (ep->num > 4 && max > 64 &&
+			(dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY))
 		return -ERANGE;
 
 	spin_lock_irqsave (&dev->lock, flags);
@@ -237,7 +238,7 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	}
 	ep->is_iso = (tmp == USB_ENDPOINT_XFER_ISOC) ? 1 : 0;
 	/* Enable this endpoint */
-	if (dev->pdev->vendor == 0x17cc) {
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY) {
 		tmp <<= ENDPOINT_TYPE;
 		tmp |= desc->bEndpointAddress;
 		/* default full fifo lines */
@@ -472,7 +473,7 @@ static int net2280_disable (struct usb_ep *_ep)
 	spin_lock_irqsave (&ep->dev->lock, flags);
 	nuke (ep);
 
-	if (ep->dev->pdev->vendor == 0x10b5)
+	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		ep_reset_338x(ep->dev->regs, ep);
 	else
 		ep_reset_228x(ep->dev->regs, ep);
@@ -799,7 +800,7 @@ static void start_queue (struct net2280_ep *ep, u32 dmactl, u32 td_dma)
 	writel (readl (&dma->dmastat), &dma->dmastat);
 
 	writel (td_dma, &dma->dmadesc);
-	if (ep->dev->pdev->vendor == 0x10b5)
+	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		dmactl |= (0x01 << DMA_REQUEST_OUTSTANDING);
 	writel (dmactl, &dma->dmactl);
 
@@ -995,7 +996,7 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 		/* DMA request while EP halted */
 		if (ep->dma &&
 		    (readl(&ep->regs->ep_rsp) & (1 << CLEAR_ENDPOINT_HALT)) &&
-			(dev->pdev->vendor == 0x10b5)) {
+			(dev->pdev->vendor == PCI_VENDOR_ID_PLX)) {
 			int valid = 1;
 			if (ep->is_in) {
 				int expect;
@@ -1126,7 +1127,7 @@ static void scan_dma_completions (struct net2280_ep *ep)
 		} else if (!ep->is_in
 				&& (req->req.length % ep->ep.maxpacket) != 0) {
 			tmp = readl (&ep->regs->ep_stat);
-			if (ep->dev->pdev->vendor == 0x10b5)
+			if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 				return dma_done(ep, req, tmp, 0);
 
 			/* AVOID TROUBLE HERE by not issuing short reads from
@@ -1234,7 +1235,7 @@ static void abort_dma_338x(struct net2280_ep *ep)
 
 static void abort_dma(struct net2280_ep *ep)
 {
-	if (ep->dev->pdev->vendor == 0x17cc)
+	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		return abort_dma_228x(ep);
 	return abort_dma_338x(ep);
 }
@@ -1392,7 +1393,7 @@ net2280_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedged)
 				ep->wedged = 1;
 		} else {
 			clear_halt (ep);
-			if (ep->dev->pdev->vendor == 0x10b5 &&
+			if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX &&
 				!list_empty(&ep->queue) && ep->td_dma)
 					restart_dma(ep);
 			ep->wedged = 0;
@@ -2104,7 +2105,7 @@ static void usb_reset_338x(struct net2280 *dev)
 
 static void usb_reset(struct net2280 *dev)
 {
-	if (dev->pdev->vendor == 0x17cc)
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		return usb_reset_228x(dev);
 	return usb_reset_338x(dev);
 }
@@ -2260,7 +2261,7 @@ static void usb_reinit_338x(struct net2280 *dev)
 
 static void usb_reinit(struct net2280 *dev)
 {
-	if (dev->pdev->vendor == 0x17cc)
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		return usb_reinit_228x(dev);
 	return usb_reinit_338x(dev);
 }
@@ -2358,7 +2359,7 @@ static void ep0_start_338x(struct net2280 *dev)
 
 static void ep0_start(struct net2280 *dev)
 {
-	if (dev->pdev->vendor == 0x17cc)
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		return ep0_start_228x(dev);
 	return ep0_start_338x(dev);
 }
@@ -2400,7 +2401,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 	if (retval) goto err_func;
 
 	/* Enable force-full-speed testing mode, if desired */
-	if (full_speed && dev->pdev->vendor == 0x17cc)
+	if (full_speed && dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		writel(1 << FORCE_FULL_SPEED_MODE, &dev->usb->xcvrdiag);
 
 	/* ... then enable host detection and ep0; and we're ready
@@ -2408,7 +2409,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 	 */
 	net2280_led_active (dev, 1);
 
-	if (dev->pdev->vendor == 0x10b5)
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		defect7374_enable_data_eps_zero(dev);
 
 	ep0_start (dev);
@@ -2471,7 +2472,7 @@ static int net2280_stop(struct usb_gadget *_gadget,
 	net2280_led_active (dev, 0);
 
 	/* Disable full-speed test mode */
-	if (dev->pdev->vendor == 0x17cc)
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		writel(0, &dev->usb->xcvrdiag);
 
 	device_remove_file (&dev->pdev->dev, &dev_attr_function);
@@ -3120,7 +3121,7 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 		}
 		ep->stopped = 0;
 		dev->protocol_stall = 0;
-		if (dev->pdev->vendor == 0x10b5)
+		if (dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 			ep->is_halt = 0;
 		else{
 			if (ep->dev->pdev->device == 0x2280)
@@ -3149,7 +3150,7 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 		cpu_to_le32s (&u.raw [0]);
 		cpu_to_le32s (&u.raw [1]);
 
-		if (dev->pdev->vendor == 0x10b5)
+		if (dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 			defect7374_workaround(dev, u.r);
 
 		tmp = 0;
@@ -3233,7 +3234,8 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			} else {
 				VDEBUG(dev, "%s clear halt\n", e->ep.name);
 				clear_halt(e);
-				if (ep->dev->pdev->vendor == 0x10b5 &&
+				if (ep->dev->pdev->vendor ==
+						PCI_VENDOR_ID_PLX &&
 					!list_empty(&e->queue) && e->td_dma)
 						restart_dma(e);
 			}
@@ -3255,7 +3257,7 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			if (e->ep.name == ep0name)
 				goto do_stall;
 			set_halt (e);
-			if (dev->pdev->vendor == 0x10b5 && e->dma)
+			if (dev->pdev->vendor == PCI_VENDOR_ID_PLX && e->dma)
 				abort_dma(e);
 			allow_status (ep);
 			VDEBUG (dev, "%s set halt\n", ep->ep.name);
@@ -3423,7 +3425,7 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 		writel (tmp, &dma->dmastat);
 
 		/* dma sync*/
-		if (dev->pdev->vendor == 0x10b5) {
+		if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
 			u32 r_dmacount = readl(&dma->dmacount);
 			if (!ep->is_in &&  (r_dmacount & 0x00FFFFFF) &&
 			    (tmp & (1 << DMA_TRANSACTION_DONE_INTERRUPT)))
@@ -3508,7 +3510,7 @@ static irqreturn_t net2280_irq (int irq, void *_dev)
 	struct net2280		*dev = _dev;
 
 	/* shared interrupt, not ours */
-	if (dev->pdev->vendor == 0x17cc &&
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY &&
 		(!(readl(&dev->regs->irqstat0) & (1 << INTA_ASSERTED))))
 		return IRQ_NONE;
 
@@ -3520,7 +3522,7 @@ static irqreturn_t net2280_irq (int irq, void *_dev)
 	/* control requests and PIO */
 	handle_stat0_irqs (dev, readl (&dev->regs->irqstat0));
 
-	if (dev->pdev->vendor == 0x10b5) {
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
 		/* re-enable interrupt to trigger any possible new interrupt */
 		u32 pciirqenb1 = readl(&dev->regs->pciirqenb1);
 		writel(pciirqenb1 & 0x7FFFFFFF, &dev->regs->pciirqenb1);
@@ -3565,7 +3567,7 @@ static void net2280_remove (struct pci_dev *pdev)
 	}
 	if (dev->got_irq)
 		free_irq (pdev->irq, dev);
-	if (use_msi && dev->pdev->vendor == 0x10b5)
+	if (use_msi && dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		pci_disable_msi(pdev);
 	if (dev->regs)
 		iounmap (dev->regs);
@@ -3601,7 +3603,7 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init (&dev->lock);
 	dev->pdev = pdev;
 	dev->gadget.ops = &net2280_ops;
-	dev->gadget.max_speed = (dev->pdev->vendor == 0x10b5) ?
+	dev->gadget.max_speed = (dev->pdev->vendor == PCI_VENDOR_ID_PLX) ?
 				USB_SPEED_SUPER : USB_SPEED_HIGH;
 
 	/* the "gadget" abstracts/virtualizes the controller */
@@ -3644,7 +3646,7 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->dep = (struct net2280_dep_regs __iomem *) (base + 0x0200);
 	dev->epregs = (struct net2280_ep_regs __iomem *) (base + 0x0300);
 
-	if (dev->pdev->vendor == 0x10b5) {
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
 		u32 fsmvalue;
 		u32 usbstat;
 		dev->usb_ext = (struct usb338x_usb_ext_regs __iomem *)
@@ -3687,7 +3689,7 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 		goto done;
 	}
 
-	if (use_msi && dev->pdev->vendor == 0x10b5)
+	if (use_msi && dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		if (pci_enable_msi(pdev))
 			ERROR(dev, "Failed to enable MSI mode\n");
 
@@ -3726,7 +3728,7 @@ static int net2280_probe (struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* enable lower-overhead pci memory bursts during DMA */
-	if (dev->pdev->vendor == 0x17cc)
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		writel((1 << DMA_MEMORY_WRITE_AND_INVALIDATE_ENABLE)
 			// 256 write retries may not be enough...
 			// | (1 << PCI_RETRY_ABORT_ENABLE)
@@ -3779,7 +3781,7 @@ static void net2280_shutdown (struct pci_dev *pdev)
 	writel (0, &dev->usb->usbctl);
 
 	/* Disable full-speed test mode */
-	if (dev->pdev->vendor == 0x17cc)
+	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
 		writel(0, &dev->usb->xcvrdiag);
 }
 
@@ -3789,14 +3791,14 @@ static void net2280_shutdown (struct pci_dev *pdev)
 static const struct pci_device_id pci_ids [] = { {
 	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
 	.class_mask =	~0,
-	.vendor =	0x17cc,
+	.vendor =	PCI_VENDOR_ID_PLX_LEGACY,
 	.device =	0x2280,
 	.subvendor =	PCI_ANY_ID,
 	.subdevice =	PCI_ANY_ID,
 }, {
 	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
 	.class_mask =	~0,
-	.vendor =	0x17cc,
+	.vendor =	PCI_VENDOR_ID_PLX_LEGACY,
 	.device =	0x2282,
 	.subvendor =	PCI_ANY_ID,
 	.subdevice =	PCI_ANY_ID,
@@ -3804,7 +3806,7 @@ static const struct pci_device_id pci_ids [] = { {
 	{
 	 .class = ((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
 	 .class_mask = ~0,
-	 .vendor = 0x10b5,
+	 .vendor = PCI_VENDOR_ID_PLX,
 	 .device = 0x3380,
 	 .subvendor = PCI_ANY_ID,
 	 .subdevice = PCI_ANY_ID,
@@ -3812,7 +3814,7 @@ static const struct pci_device_id pci_ids [] = { {
 	{
 	 .class = ((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
 	 .class_mask = ~0,
-	 .vendor = 0x10b5,
+	 .vendor = PCI_VENDOR_ID_PLX,
 	 .device = 0x3382,
 	 .subvendor = PCI_ANY_ID,
 	 .subdevice = PCI_ANY_ID,
diff --git a/drivers/usb/gadget/net2280.h b/drivers/usb/gadget/net2280.h
index a257516..30478c8 100644
--- a/drivers/usb/gadget/net2280.h
+++ b/drivers/usb/gadget/net2280.h
@@ -43,6 +43,7 @@ set_idx_reg (struct net2280_regs __iomem *regs, u32 index, u32 value)
 
 #endif	/* __KERNEL__ */
 
+#define PCI_VENDOR_ID_PLX_LEGACY 0x17cc
 
 #define REG_DIAG		0x0
 #define     RETRY_COUNTER                                       16
-- 
2.0.0.rc2

