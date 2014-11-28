Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaK1NvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:51:14 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:63324 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaK1NvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:11 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/17] net2280: Remove use_dma module parameter
Date: Fri, 28 Nov 2014 14:50:49 +0100
Message-Id: <1417182662-7405-5-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use_dma parameter was designed to enable the dma on the chip. It was
enabled by default.

It comes from the time when the dma was not reliable. Now it has been
working ok in production.

This patch removes this parameter.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index fc5c0a2..230b8d4 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -80,18 +80,6 @@ static const char *const ep_name[] = {
 	"ep-e", "ep-f", "ep-g", "ep-h",
 };
 
-/* use_dma -- general goodness, fewer interrupts, less cpu load (vs PIO)
- *
- * The net2280 DMA engines are not tightly integrated with their FIFOs;
- * not all cases are (yet) handled well in this driver or the silicon.
- * Some gadget drivers work better with the dma support here than others.
- * These two parameters let you use PIO or more aggressive DMA.
- */
-static bool use_dma = true;
-
-/* "modprobe net2280 use_dma=n" etc */
-module_param(use_dma, bool, 0444);
-
 /* mode 0 == ep-{a,b,c,d} 1K fifo each
  * mode 1 == ep-{a,b} 2K fifo each, ep-{c,d} unavailable
  * mode 2 == ep-a 2K fifo, ep-{b,c} 1K each, ep-d unavailable
@@ -455,7 +443,7 @@ static int net2280_disable(struct usb_ep *_ep)
 	/* synch memory views with the device */
 	(void)readl(&ep->cfg->ep_cfg);
 
-	if (use_dma && !ep->dma && ep->num >= 1 && ep->num <= 4)
+	if (!ep->dma && ep->num >= 1 && ep->num <= 4)
 		ep->dma = &ep->dev->dma[ep->num - 1];
 
 	spin_unlock_irqrestore(&ep->dev->lock, flags);
@@ -1508,12 +1496,11 @@ static ssize_t registers_show(struct device *_dev,
 
 	/* Main Control Registers */
 	t = scnprintf(next, size, "%s version " DRIVER_VERSION
-			", chiprev %04x, dma %s\n\n"
+			", chiprev %04x\n\n"
 			"devinit %03x fifoctl %08x gadget '%s'\n"
 			"pci irqenb0 %02x irqenb1 %08x "
 			"irqstat0 %04x irqstat1 %08x\n",
 			driver_name, dev->chiprev,
-			use_dma ? "enabled" : "disabled",
 			readl(&dev->regs->devinit),
 			readl(&dev->regs->fifoctl),
 			s,
@@ -1995,10 +1982,6 @@ static void usb_reset(struct net2280 *dev)
 static void usb_reinit_228x(struct net2280 *dev)
 {
 	u32	tmp;
-	int	init_dma;
-
-	/* use_dma changes are ignored till next device re-init */
-	init_dma = use_dma;
 
 	/* basic endpoint init */
 	for (tmp = 0; tmp < 7; tmp++) {
@@ -2010,8 +1993,7 @@ static void usb_reinit_228x(struct net2280 *dev)
 
 		if (tmp > 0 && tmp <= 4) {
 			ep->fifo_size = 1024;
-			if (init_dma)
-				ep->dma = &dev->dma[tmp - 1];
+			ep->dma = &dev->dma[tmp - 1];
 		} else
 			ep->fifo_size = 64;
 		ep->regs = &dev->epregs[tmp];
@@ -2035,7 +2017,6 @@ static void usb_reinit_228x(struct net2280 *dev)
 
 static void usb_reinit_338x(struct net2280 *dev)
 {
-	int init_dma;
 	int i;
 	u32 tmp, val;
 	u32 fsmvalue;
@@ -2043,9 +2024,6 @@ static void usb_reinit_338x(struct net2280 *dev)
 	static const u32 ep_reg_addr[9] = { 0x00, 0xC0, 0x00, 0xC0, 0x00,
 						0x00, 0xC0, 0x00, 0xC0 };
 
-	/* use_dma changes are ignored till next device re-init */
-	init_dma = use_dma;
-
 	/* basic endpoint init */
 	for (i = 0; i < dev->n_ep; i++) {
 		struct net2280_ep *ep = &dev->ep[i];
@@ -2054,7 +2032,7 @@ static void usb_reinit_338x(struct net2280 *dev)
 		ep->dev = dev;
 		ep->num = i;
 
-		if (i > 0 && i <= 4 && init_dma)
+		if (i > 0 && i <= 4)
 			ep->dma = &dev->dma[i - 1];
 
 		if (dev->enhanced_mode) {
@@ -3606,8 +3584,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ep_info(dev, "%s\n", driver_desc);
 	ep_info(dev, "irq %d, pci mem %p, chip rev %04x\n",
 			pdev->irq, base, dev->chiprev);
-	ep_info(dev, "version: " DRIVER_VERSION "; dma %s %s\n",
-		use_dma	? "enabled" : "disabled",
+	ep_info(dev, "version: " DRIVER_VERSION "; %s\n",
 		dev->enhanced_mode ? "enhanced mode" : "legacy mode");
 	retval = device_create_file(&pdev->dev, &dev_attr_registers);
 	if (retval)
-- 
2.1.3

