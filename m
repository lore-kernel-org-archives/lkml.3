Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaETQbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:31:04 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:47827 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaETQal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:30:41 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 10/10] usb: gadget: net2280: Use quirks instead of pci id
Date: Tue, 20 May 2014 18:30:12 +0200
Message-Id: <1400603412-19406-11-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of quirks improve readability and will be easier to add new devices
to this driver.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 83 +++++++++++++++++++++++---------------------
 drivers/usb/gadget/net2280.h |  6 ++++
 2 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 9ced9ff..ce8bc86 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -147,7 +147,7 @@ static inline void enable_pciirqenb(struct net2280_ep *ep)
 {
 	u32 tmp = readl(&ep->dev->regs->pciirqenb0);
 
-	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
+	if (ep->dev->quirks & PLX_LEGACY)
 		tmp |= BIT(ep->num);
 	else
 		tmp |= BIT(ep_bit[ep->num]);
@@ -177,7 +177,7 @@ net2280_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	if ((desc->bEndpointAddress & 0x0f) == EP_DONTUSE)
 		return -EDOM;
 
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
+	if (dev->quirks & PLX_SUPERSPEED) {
 		if ((desc->bEndpointAddress & 0x0f) >= 0x0c)
 			return -EDOM;
 		ep->is_in = !!usb_endpoint_dir_in(desc);
@@ -187,8 +187,7 @@ net2280_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 
 	/* sanity check ep-e/ep-f since their fifos are small */
 	max = usb_endpoint_maxp(desc) & 0x1fff;
-	if (ep->num > 4 && max > 64 &&
-			(dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY))
+	if (ep->num > 4 && max > 64 && (dev->quirks & PLX_LEGACY))
 		return -ERANGE;
 
 	spin_lock_irqsave(&dev->lock, flags);
@@ -233,7 +232,7 @@ net2280_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	}
 	ep->is_iso = (tmp == USB_ENDPOINT_XFER_ISOC);
 	/* Enable this endpoint */
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY) {
+	if (dev->quirks & PLX_LEGACY) {
 		tmp <<= ENDPOINT_TYPE;
 		tmp |= desc->bEndpointAddress;
 		/* default full fifo lines */
@@ -263,7 +262,7 @@ net2280_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	/* for OUT transfers, block the rx fifo until a read is posted */
 	if (!ep->is_in)
 		writel(BIT(SET_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
-	else if (dev->pdev->device != 0x2280) {
+	else if (!(dev->quirks & PLX_2280)) {
 		/* Added for 2282, Don't use nak packets on an in endpoint,
 		 * this was ignored on 2280
 		 */
@@ -279,7 +278,7 @@ net2280_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 
 		tmp = BIT(DATA_PACKET_RECEIVED_INTERRUPT_ENABLE) |
 			BIT(DATA_PACKET_TRANSMITTED_INTERRUPT_ENABLE);
-		if (dev->pdev->device == 0x2280)
+		if (dev->quirks & PLX_2280)
 			tmp |= readl(&ep->regs->ep_irqenb);
 		writel(tmp, &ep->regs->ep_irqenb);
 	} else {				/* dma, per-request */
@@ -361,7 +360,7 @@ static void ep_reset_228x(struct net2280_regs __iomem *regs,
 	/* init to our chosen defaults, notably so that we NAK OUT
 	 * packets until the driver queues a read (+note erratum 0112)
 	 */
-	if (!ep->is_in || ep->dev->pdev->device == 0x2280) {
+	if (!ep->is_in || (ep->dev->quirks & PLX_2280)) {
 		tmp = BIT(SET_NAK_OUT_PACKETS_MODE) |
 		BIT(SET_NAK_OUT_PACKETS) |
 		BIT(CLEAR_EP_HIDE_STATUS_PHASE) |
@@ -381,7 +380,7 @@ static void ep_reset_228x(struct net2280_regs __iomem *regs,
 	writel(tmp, &ep->regs->ep_rsp);
 
 	/* scrub most status bits, and flush any fifo state */
-	if (ep->dev->pdev->device == 0x2280)
+	if (ep->dev->quirks & PLX_2280)
 		tmp = BIT(FIFO_OVERFLOW) |
 			BIT(FIFO_UNDERFLOW);
 	else
@@ -468,7 +467,7 @@ static int net2280_disable(struct usb_ep *_ep)
 	spin_lock_irqsave(&ep->dev->lock, flags);
 	nuke(ep);
 
-	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
+	if (ep->dev->quirks & PLX_SUPERSPEED)
 		ep_reset_338x(ep->dev->regs, ep);
 	else
 		ep_reset_228x(ep->dev->regs, ep);
@@ -742,7 +741,7 @@ static void fill_dma_desc(struct net2280_ep *ep,
 	if (ep->is_in)
 		dmacount |= BIT(DMA_DIRECTION);
 	if ((!ep->is_in && (dmacount % ep->ep.maxpacket) != 0) ||
-					ep->dev->pdev->device != 0x2280)
+					!(ep->dev->quirks & PLX_2280))
 		dmacount |= BIT(END_OF_CHAIN);
 
 	req->valid = valid;
@@ -786,14 +785,14 @@ static void start_queue(struct net2280_ep *ep, u32 dmactl, u32 td_dma)
 	struct net2280_dma_regs	__iomem *dma = ep->dma;
 	unsigned int tmp = BIT(VALID_BIT) | (ep->is_in << DMA_DIRECTION);
 
-	if (ep->dev->pdev->device != 0x2280)
+	if (!(ep->dev->quirks & PLX_2280))
 		tmp |= BIT(END_OF_CHAIN);
 
 	writel(tmp, &dma->dmacount);
 	writel(readl(&dma->dmastat), &dma->dmastat);
 
 	writel(td_dma, &dma->dmadesc);
-	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
+	if (ep->dev->quirks & PLX_SUPERSPEED)
 		dmactl |= BIT(DMA_REQUEST_OUTSTANDING);
 	writel(dmactl, &dma->dmactl);
 
@@ -989,7 +988,7 @@ net2280_queue(struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 		/* DMA request while EP halted */
 		if (ep->dma &&
 		    (readl(&ep->regs->ep_rsp) & BIT(CLEAR_ENDPOINT_HALT)) &&
-			(dev->pdev->vendor == PCI_VENDOR_ID_PLX)) {
+			(dev->quirks & PLX_SUPERSPEED)) {
 			int valid = 1;
 			if (ep->is_in) {
 				int expect;
@@ -1120,7 +1119,7 @@ static void scan_dma_completions(struct net2280_ep *ep)
 		} else if (!ep->is_in &&
 				(req->req.length % ep->ep.maxpacket) != 0) {
 			tmp = readl(&ep->regs->ep_stat);
-			if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX)
+			if (ep->dev->quirks & PLX_SUPERSPEED)
 				return dma_done(ep, req, tmp, 0);
 
 			/* AVOID TROUBLE HERE by not issuing short reads from
@@ -1231,7 +1230,7 @@ static void abort_dma_338x(struct net2280_ep *ep)
 
 static void abort_dma(struct net2280_ep *ep)
 {
-	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
+	if (ep->dev->quirks & PLX_LEGACY)
 		return abort_dma_228x(ep);
 	return abort_dma_338x(ep);
 }
@@ -1389,7 +1388,7 @@ net2280_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedged)
 				ep->wedged = 1;
 		} else {
 			clear_halt(ep);
-			if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX &&
+			if (ep->dev->quirks & PLX_SUPERSPEED &&
 				!list_empty(&ep->queue) && ep->td_dma)
 					restart_dma(ep);
 			ep->wedged = 0;
@@ -2087,7 +2086,7 @@ static void usb_reset_338x(struct net2280 *dev)
 
 static void usb_reset(struct net2280 *dev)
 {
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
+	if (dev->quirks & PLX_LEGACY)
 		return usb_reset_228x(dev);
 	return usb_reset_338x(dev);
 }
@@ -2243,7 +2242,7 @@ static void usb_reinit_338x(struct net2280 *dev)
 
 static void usb_reinit(struct net2280 *dev)
 {
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
+	if (dev->quirks & PLX_LEGACY)
 		return usb_reinit_228x(dev);
 	return usb_reinit_338x(dev);
 }
@@ -2341,7 +2340,7 @@ static void ep0_start_338x(struct net2280 *dev)
 
 static void ep0_start(struct net2280 *dev)
 {
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
+	if (dev->quirks & PLX_LEGACY)
 		return ep0_start_228x(dev);
 	return ep0_start_338x(dev);
 }
@@ -2385,7 +2384,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 		goto err_func;
 
 	/* Enable force-full-speed testing mode, if desired */
-	if (full_speed && dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
+	if (full_speed && (dev->quirks & PLX_LEGACY))
 		writel(BIT(FORCE_FULL_SPEED_MODE), &dev->usb->xcvrdiag);
 
 	/* ... then enable host detection and ep0; and we're ready
@@ -2393,7 +2392,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 	 */
 	net2280_led_active(dev, 1);
 
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX)
+	if (dev->quirks & PLX_SUPERSPEED)
 		defect7374_enable_data_eps_zero(dev);
 
 	ep0_start(dev);
@@ -2455,7 +2454,7 @@ static int net2280_stop(struct usb_gadget *_gadget,
 	net2280_led_active(dev, 0);
 
 	/* Disable full-speed test mode */
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
+	if (dev->quirks & PLX_LEGACY)
 		writel(0, &dev->usb->xcvrdiag);
 
 	device_remove_file(&dev->pdev->dev, &dev_attr_function);
@@ -2493,7 +2492,7 @@ static void handle_ep_small(struct net2280_ep *ep)
 	ep_vdbg(ep->dev, "%s ack ep_stat %08x, req %p\n",
 			ep->ep.name, t, req ? &req->req : 0);
 #endif
-	if (!ep->is_in || ep->dev->pdev->device == 0x2280)
+	if (!ep->is_in || (ep->dev->quirks & PLX_2280))
 		writel(t & ~BIT(NAK_OUT_PACKETS), &ep->regs->ep_stat);
 	else
 		/* Added for 2282 */
@@ -3102,10 +3101,10 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 		}
 		ep->stopped = 0;
 		dev->protocol_stall = 0;
-		if (dev->pdev->vendor == PCI_VENDOR_ID_PLX)
+		if (dev->quirks & PLX_SUPERSPEED)
 			ep->is_halt = 0;
 		else{
-			if (ep->dev->pdev->device == 0x2280)
+			if (ep->dev->quirks & PLX_2280)
 				tmp = BIT(FIFO_OVERFLOW) |
 				    BIT(FIFO_UNDERFLOW);
 			else
@@ -3131,7 +3130,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 		cpu_to_le32s(&u.raw[0]);
 		cpu_to_le32s(&u.raw[1]);
 
-		if (dev->pdev->vendor == PCI_VENDOR_ID_PLX)
+		if (dev->quirks & PLX_SUPERSPEED)
 			defect7374_workaround(dev, u.r);
 
 		tmp = 0;
@@ -3214,8 +3213,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 			} else {
 				ep_vdbg(dev, "%s clear halt\n", e->ep.name);
 				clear_halt(e);
-				if (ep->dev->pdev->vendor ==
-						PCI_VENDOR_ID_PLX &&
+				if ((ep->dev->quirks & PLX_SUPERSPEED) &&
 					!list_empty(&e->queue) && e->td_dma)
 						restart_dma(e);
 			}
@@ -3237,7 +3235,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 			if (e->ep.name == ep0name)
 				goto do_stall;
 			set_halt(e);
-			if (dev->pdev->vendor == PCI_VENDOR_ID_PLX && e->dma)
+			if ((dev->quirks & PLX_SUPERSPEED) && e->dma)
 				abort_dma(e);
 			allow_status(ep);
 			ep_vdbg(dev, "%s set halt\n", ep->ep.name);
@@ -3365,7 +3363,7 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 		writel(stat, &dev->regs->irqstat1);
 
 	/* some status we can just ignore */
-	if (dev->pdev->device == 0x2280)
+	if (dev->quirks & PLX_2280)
 		stat &= ~(BIT(CONTROL_STATUS_INTERRUPT) |
 			  BIT(SUSPEND_REQUEST_INTERRUPT) |
 			  BIT(RESUME_INTERRUPT) |
@@ -3403,7 +3401,7 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 		writel(tmp, &dma->dmastat);
 
 		/* dma sync*/
-		if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
+		if (dev->quirks & PLX_SUPERSPEED) {
 			u32 r_dmacount = readl(&dma->dmacount);
 			if (!ep->is_in &&  (r_dmacount & 0x00FFFFFF) &&
 			    (tmp & BIT(DMA_TRANSACTION_DONE_INTERRUPT)))
@@ -3486,7 +3484,7 @@ static irqreturn_t net2280_irq(int irq, void *_dev)
 	struct net2280		*dev = _dev;
 
 	/* shared interrupt, not ours */
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY &&
+	if ((dev->quirks & PLX_LEGACY) &&
 		(!(readl(&dev->regs->irqstat0) & BIT(INTA_ASSERTED))))
 		return IRQ_NONE;
 
@@ -3498,7 +3496,7 @@ static irqreturn_t net2280_irq(int irq, void *_dev)
 	/* control requests and PIO */
 	handle_stat0_irqs(dev, readl(&dev->regs->irqstat0));
 
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
+	if (dev->quirks & PLX_SUPERSPEED) {
 		/* re-enable interrupt to trigger any possible new interrupt */
 		u32 pciirqenb1 = readl(&dev->regs->pciirqenb1);
 		writel(pciirqenb1 & 0x7FFFFFFF, &dev->regs->pciirqenb1);
@@ -3543,7 +3541,7 @@ static void net2280_remove(struct pci_dev *pdev)
 	}
 	if (dev->got_irq)
 		free_irq(pdev->irq, dev);
-	if (use_msi && dev->pdev->vendor == PCI_VENDOR_ID_PLX)
+	if (use_msi && dev->quirks & PLX_SUPERSPEED)
 		pci_disable_msi(pdev);
 	if (dev->regs)
 		iounmap(dev->regs);
@@ -3580,9 +3578,10 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, dev);
 	spin_lock_init(&dev->lock);
+	dev->quirks = id->driver_data;
 	dev->pdev = pdev;
 	dev->gadget.ops = &net2280_ops;
-	dev->gadget.max_speed = (dev->pdev->vendor == PCI_VENDOR_ID_PLX) ?
+	dev->gadget.max_speed = (dev->quirks & PLX_SUPERSPEED) ?
 				USB_SPEED_SUPER : USB_SPEED_HIGH;
 
 	/* the "gadget" abstracts/virtualizes the controller */
@@ -3625,7 +3624,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->dep = (struct net2280_dep_regs __iomem *) (base + 0x0200);
 	dev->epregs = (struct net2280_ep_regs __iomem *) (base + 0x0300);
 
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX) {
+	if (dev->quirks & PLX_SUPERSPEED) {
 		u32 fsmvalue;
 		u32 usbstat;
 		dev->usb_ext = (struct usb338x_usb_ext_regs __iomem *)
@@ -3668,7 +3667,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto done;
 	}
 
-	if (use_msi && dev->pdev->vendor == PCI_VENDOR_ID_PLX)
+	if (use_msi && (dev->quirks & PLX_SUPERSPEED))
 		if (pci_enable_msi(pdev))
 			ep_err(dev, "Failed to enable MSI mode\n");
 
@@ -3707,7 +3706,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* enable lower-overhead pci memory bursts during DMA */
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
+	if (dev->quirks & PLX_LEGACY)
 		writel(BIT(DMA_MEMORY_WRITE_AND_INVALIDATE_ENABLE) |
 			/*
 			 * 256 write retries may not be enough...
@@ -3763,7 +3762,7 @@ static void net2280_shutdown(struct pci_dev *pdev)
 	writel(0, &dev->usb->usbctl);
 
 	/* Disable full-speed test mode */
-	if (dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
+	if (dev->quirks & PLX_LEGACY)
 		writel(0, &dev->usb->xcvrdiag);
 }
 
@@ -3777,6 +3776,7 @@ static const struct pci_device_id pci_ids[] = { {
 	.device =	0x2280,
 	.subvendor =	PCI_ANY_ID,
 	.subdevice =	PCI_ANY_ID,
+	.driver_data =	PLX_LEGACY | PLX_2280,
 	}, {
 	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
 	.class_mask =	~0,
@@ -3784,6 +3784,7 @@ static const struct pci_device_id pci_ids[] = { {
 	.device =	0x2282,
 	.subvendor =	PCI_ANY_ID,
 	.subdevice =	PCI_ANY_ID,
+	.driver_data =	PLX_LEGACY,
 	},
 	{
 	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
@@ -3792,6 +3793,7 @@ static const struct pci_device_id pci_ids[] = { {
 	.device =	0x3380,
 	.subvendor =	PCI_ANY_ID,
 	.subdevice =	PCI_ANY_ID,
+	.driver_data =	PLX_SUPERSPEED,
 	 },
 	{
 	.class =	((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
@@ -3800,6 +3802,7 @@ static const struct pci_device_id pci_ids[] = { {
 	.device =	0x3382,
 	.subvendor =	PCI_ANY_ID,
 	.subdevice =	PCI_ANY_ID,
+	.driver_data =	PLX_SUPERSPEED,
 	 },
 { /* end: all zeroes */ }
 };
diff --git a/drivers/usb/gadget/net2280.h b/drivers/usb/gadget/net2280.h
index dc9ca1d..03f1524 100644
--- a/drivers/usb/gadget/net2280.h
+++ b/drivers/usb/gadget/net2280.h
@@ -44,6 +44,10 @@ set_idx_reg(struct net2280_regs __iomem *regs, u32 index, u32 value)
 
 #define PCI_VENDOR_ID_PLX_LEGACY 0x17cc
 
+#define PLX_LEGACY		BIT(0)
+#define PLX_2280		BIT(1)
+#define PLX_SUPERSPEED		BIT(2)
+
 #define REG_DIAG		0x0
 #define     RETRY_COUNTER                                       16
 #define     FORCE_PCI_SERR                                      11
@@ -166,6 +170,8 @@ struct net2280 {
 	u16				chiprev;
 	int enhanced_mode;
 	int n_ep;
+	kernel_ulong_t			quirks;
+
 
 	/* pci state used to access those endpoints */
 	struct pci_dev			*pdev;
-- 
2.0.0.rc2

