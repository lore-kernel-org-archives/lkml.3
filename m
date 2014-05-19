Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaESVWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:22:06 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:58206 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaESVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:21:05 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 9/9 v2] usb: gadget: net2280: Use pr_* function
Date: Mon, 19 May 2014 23:20:36 +0200
Message-Id: <1400534436-10913-10-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400534436-10913-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400534436-10913-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver was using custom functions WARNING, ERROR, DEBUG, instead of
 pr_err, pr_dgb...

New ep_* macros have been created that use standard pr_* functions.

v2: Comment by Joe Perches and Alan Stern
  -Use ep_* instead of custom DETDEV macro

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 121 +++++++++++++++++++++----------------------
 drivers/usb/gadget/net2280.h |  36 +++++--------
 2 files changed, 71 insertions(+), 86 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 17bf30d..a5857b9 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -42,9 +42,6 @@
  * (at your option) any later version.
  */
 
-#undef	DEBUG		/* messages on error and most fault paths */
-#undef	VERBOSE		/* extra debug messages (success too) */
-
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
@@ -210,7 +207,7 @@ static int net2280_enable(struct usb_ep *_ep,
 	 * use it instead of troublesome (non-bulk) multi-packet DMA.
 	 */
 	if (ep->dma && (max % 4) != 0 && use_dma_chaining) {
-		DEBUG(ep->dev, "%s, no dma for maxpacket %d\n",
+		ep_dbg(ep->dev, "%s, no dma for maxpacket %d\n",
 			ep->ep.name, ep->ep.maxpacket);
 		ep->dma = NULL;
 	}
@@ -303,7 +300,7 @@ static int net2280_enable(struct usb_ep *_ep,
 	}
 
 	tmp = desc->bEndpointAddress;
-	DEBUG(dev, "enabled %s (ep%d%s-%s) %s max %04x\n",
+	ep_dbg(dev, "enabled %s (ep%d%s-%s) %s max %04x\n",
 		_ep->name, tmp & 0x0f, DIR_STRING(tmp),
 		type_string(desc->bmAttributes),
 		ep->dma ? "dma" : "pio", max);
@@ -431,7 +428,7 @@ static void ep_reset_338x(struct net2280_regs __iomem *regs,
 
 		dmastat = readl(&ep->dma->dmastat);
 		if (dmastat == 0x5002) {
-			WARNING(ep->dev, "The dmastat return = %x!!\n",
+			ep_warn(ep->dev, "The dmastat return = %x!!\n",
 			       dmastat);
 			writel(0x5a, &ep->dma->dmastat);
 		}
@@ -476,7 +473,7 @@ static int net2280_disable(struct usb_ep *_ep)
 	else
 		ep_reset_228x(ep->dev->regs, ep);
 
-	VDEBUG(ep->dev, "disabled %s %s\n",
+	ep_vdbg(ep->dev, "disabled %s %s\n",
 			ep->dma ? "dma" : "pio", _ep->name);
 
 	/* synch memory views with the device */
@@ -572,7 +569,7 @@ static void write_fifo(struct net2280_ep *ep, struct usb_request *req)
 	if (count > total)	/* min() cannot be used on a bitfield */
 		count = total;
 
-	VDEBUG(ep->dev, "write %s fifo (IN) %d bytes%s req %p\n",
+	ep_vdbg(ep->dev, "write %s fifo (IN) %d bytes%s req %p\n",
 			ep->ep.name, count,
 			(count != ep->ep.maxpacket) ? " (short)" : "",
 			req);
@@ -684,7 +681,7 @@ static int read_fifo(struct net2280_ep *ep, struct net2280_request *req)
 	if (count > tmp) {
 		/* as with DMA, data overflow gets flushed */
 		if ((tmp % ep->ep.maxpacket) != 0) {
-			ERROR(ep->dev,
+			ep_err(ep->dev,
 				"%s out fifo %d bytes, expected %d\n",
 				ep->ep.name, count, tmp);
 			req->req.status = -EOVERFLOW;
@@ -699,7 +696,7 @@ static int read_fifo(struct net2280_ep *ep, struct net2280_request *req)
 
 	is_short = (count == 0) || ((count % ep->ep.maxpacket) != 0);
 
-	VDEBUG(ep->dev, "read %s fifo (OUT) %d bytes%s%s%s req %p %d/%d\n",
+	ep_vdbg(ep->dev, "read %s fifo (OUT) %d bytes%s%s%s req %p %d/%d\n",
 			ep->ep.name, count, is_short ? " (short)" : "",
 			cleanup ? " flush" : "", prevent ? " nak" : "",
 			req, req->req.actual, req->req.length);
@@ -925,7 +922,7 @@ static void done(struct net2280_ep *ep,
 		usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
 
 	if (status && status != -ESHUTDOWN)
-		VDEBUG(dev, "complete %s req %p stat %d len %u/%u\n",
+		ep_vdbg(dev, "complete %s req %p stat %d len %u/%u\n",
 			ep->ep.name, &req->req, status,
 			req->req.actual, req->req.length);
 
@@ -978,7 +975,7 @@ static int net2280_queue(struct usb_ep *_ep,
 	}
 
 #if 0
-	VDEBUG(dev, "%s queue req %p, len %d buf %p\n",
+	ep_vdbg(dev, "%s queue req %p, len %d buf %p\n",
 			_ep->name, _req, _req->length, _req->buf);
 #endif
 
@@ -1012,7 +1009,7 @@ static int net2280_queue(struct usb_ep *_ep,
 			if (ep->num == 0 && _req->length == 0) {
 				allow_status(ep);
 				done(ep, req, 0);
-				VDEBUG(dev, "%s status ack\n", ep->ep.name);
+				ep_vdbg(dev, "%s status ack\n", ep->ep.name);
 				goto done;
 			}
 
@@ -1130,7 +1127,7 @@ static void scan_dma_completions(struct net2280_ep *ep)
 			 * 0122, and 0124; not all cases trigger the warning.
 			 */
 			if ((tmp & BIT(NAK_OUT_PACKETS)) == 0) {
-				WARNING(ep->dev, "%s lost packet sync!\n",
+				ep_warn(ep->dev, "%s lost packet sync!\n",
 						ep->ep.name);
 				req->req.status = -EOVERFLOW;
 			} else {
@@ -1138,7 +1135,7 @@ static void scan_dma_completions(struct net2280_ep *ep)
 				if (tmp) {
 					/* fifo gets flushed later */
 					ep->out_overflow = 1;
-					DEBUG(ep->dev,
+					ep_dbg(ep->dev,
 						"%s dma, discard %d len %d\n",
 						ep->ep.name, tmp,
 						req->req.length);
@@ -1174,7 +1171,7 @@ static void restart_dma(struct net2280_ep *ep)
 		struct net2280_request	*entry, *prev = NULL;
 		int			reqmode, done = 0;
 
-		DEBUG(ep->dev, "%s dma hiccup td %p\n", ep->ep.name, req->td);
+		ep_dbg(ep->dev, "%s dma hiccup td %p\n", ep->ep.name, req->td);
 		ep->in_fifo_validate = likely(req->req.zero ||
 				(req->req.length % ep->ep.maxpacket) != 0);
 		if (ep->in_fifo_validate)
@@ -1294,7 +1291,7 @@ static int net2280_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 	/* queue head may be partially complete. */
 	if (ep->queue.next == &req->queue) {
 		if (ep->dma) {
-			DEBUG(ep->dev, "unlink (%s) dma\n", _ep->name);
+			ep_dbg(ep->dev, "unlink (%s) dma\n", _ep->name);
 			_req->status = -ECONNRESET;
 			abort_dma(ep);
 			if (likely(ep->queue.next == &req->queue)) {
@@ -1305,7 +1302,7 @@ static int net2280_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 					-ECONNRESET);
 			}
 		} else {
-			DEBUG(ep->dev, "unlink (%s) pio\n", _ep->name);
+			ep_dbg(ep->dev, "unlink (%s) pio\n", _ep->name);
 			done(ep, req, -ECONNRESET);
 		}
 		req = NULL;
@@ -1378,7 +1375,7 @@ static int net2280_set_halt_and_wedge(struct usb_ep *_ep,
 	else if (ep->is_in && value && net2280_fifo_status(_ep) != 0)
 		retval = -EAGAIN;
 	else {
-		VDEBUG(ep->dev, "%s %s %s\n", _ep->name,
+		ep_vdbg(ep->dev, "%s %s %s\n", _ep->name,
 				value ? "set" : "clear",
 				wedged ? "wedge" : "halt");
 		/* set/clear, then synch memory views with the device */
@@ -1565,7 +1562,7 @@ static const struct usb_gadget_ops net2280_ops = {
 
 /*-------------------------------------------------------------------------*/
 
-#ifdef	CONFIG_USB_GADGET_DEBUG_FILES
+#ifdef	CONFIG_USB_GADGET_PDEBUG_FILES
 
 /* FIXME move these into procfs, and use seq_file.
  * Sysfs _still_ doesn't behave for arbitrarily sized files,
@@ -1927,8 +1924,8 @@ static void defect7374_enable_data_eps_zero(struct net2280 *dev)
 
 	/*See if firmware needs to set up for workaround*/
 	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ) {
-		WARNING(dev, "Operate Defect 7374 workaround soft this time");
-		WARNING(dev, "It will operate on cold-reboot and SS connect");
+		ep_warn(dev, "Operate Defect 7374 workaround soft this time");
+		ep_warn(dev, "It will operate on cold-reboot and SS connect");
 
 		/*GPEPs:*/
 		tmp = ((0 << ENDPOINT_NUMBER) | BIT(ENDPOINT_DIRECTION) |
@@ -1984,8 +1981,8 @@ static void defect7374_enable_data_eps_zero(struct net2280 *dev)
 		set_idx_reg(dev->regs, SCRATCH, scratch);
 
 	} else{
-		WARNING(dev, "Defect 7374 workaround soft will NOT operate");
-		WARNING(dev, "It will operate on cold-reboot and SS connect");
+		ep_warn(dev, "Defect 7374 workaround soft will NOT operate");
+		ep_warn(dev, "It will operate on cold-reboot and SS connect");
 	}
 }
 
@@ -2049,7 +2046,7 @@ static void usb_reset_338x(struct net2280 *dev)
 
 	/* See if firmware needs to set up for workaround: */
 	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ) {
-		INFO(dev, "%s: Defect 7374 FsmValue 0x%08x\n", __func__,
+		ep_info(dev, "%s: Defect 7374 FsmValue 0x%08x\n", __func__,
 		     fsmvalue);
 	} else {
 		/* disable automatic responses, and irqs */
@@ -2186,7 +2183,7 @@ static void usb_reinit_338x(struct net2280 *dev)
 
 	/* See if driver needs to set up for workaround: */
 	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ)
-		INFO(dev, "%s: Defect 7374 FsmValue %08x\n",
+		ep_info(dev, "%s: Defect 7374 FsmValue %08x\n",
 						__func__, fsmvalue);
 	else {
 		tmp = readl(&dev->usb_ext->usbctl2) &
@@ -2301,7 +2298,7 @@ static void ep0_start_338x(struct net2280 *dev)
 			(0xf << DEFECT7374_FSM_FIELD);
 
 	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ)
-		INFO(dev, "%s: Defect 7374 FsmValue %08x\n", __func__,
+		ep_info(dev, "%s: Defect 7374 FsmValue %08x\n", __func__,
 		     fsmvalue);
 	else
 		writel(BIT(CLEAR_NAK_OUT_PACKETS_MODE) |
@@ -2400,7 +2397,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 
 	ep0_start(dev);
 
-	DEBUG(dev, "%s ready, usbctl %08x stdrsp %08x\n",
+	ep_dbg(dev, "%s ready, usbctl %08x stdrsp %08x\n",
 			driver->driver.name,
 			readl(&dev->usb->usbctl),
 			readl(&dev->usb->stdrsp));
@@ -2463,7 +2460,7 @@ static int net2280_stop(struct usb_gadget *_gadget,
 	device_remove_file(&dev->pdev->dev, &dev_attr_function);
 	device_remove_file(&dev->pdev->dev, &dev_attr_queues);
 
-	DEBUG(dev, "unregistered driver '%s'\n",
+	ep_dbg(dev, "unregistered driver '%s'\n",
 			driver ? driver->driver.name : "");
 
 	return 0;
@@ -2492,7 +2489,7 @@ static void handle_ep_small(struct net2280_ep *ep)
 	t = readl(&ep->regs->ep_stat);
 	ep->irqs++;
 #if 0
-	VDEBUG(ep->dev, "%s ack ep_stat %08x, req %p\n",
+	ep_vdbg(ep->dev, "%s ack ep_stat %08x, req %p\n",
 			ep->ep.name, t, req ? &req->req : 0);
 #endif
 	if (!ep->is_in || ep->dev->pdev->device == 0x2280)
@@ -2623,7 +2620,7 @@ static void handle_ep_small(struct net2280_ep *ep)
 			if (!list_empty(&ep->queue))
 				restart_dma(ep);
 		} else
-			DEBUG(ep->dev, "%s dma ep_stat %08x ??\n",
+			ep_dbg(ep->dev, "%s dma ep_stat %08x ??\n",
 					ep->ep.name, t);
 		return;
 
@@ -2757,12 +2754,12 @@ static void defect7374_workaround(struct net2280 *dev, struct usb_ctrlrequest r)
 
 
 	if (ack_wait_timeout >= DEFECT_7374_NUMBEROF_MAX_WAIT_LOOPS) {
-		ERROR(dev, "FAIL: Defect 7374 workaround waited but failed "
+		ep_err(dev, "FAIL: Defect 7374 workaround waited but failed "
 		"to detect SS host's data phase ACK.");
-		ERROR(dev, "PL_EP_STATUS_1(23:16):.Expected from 0x11 to 0x16"
+		ep_err(dev, "PL_EP_STATUS_1(23:16):.Expected from 0x11 to 0x16"
 		"got 0x%2.2x.\n", state >> STATE);
 	} else {
-		WARNING(dev, "INFO: Defect 7374 workaround waited about\n"
+		ep_warn(dev, "INFO: Defect 7374 workaround waited about\n"
 		"%duSec for Control Read Data Phase ACK\n",
 			DEFECT_7374_PROCESSOR_WAIT_TIME * ack_wait_timeout);
 	}
@@ -2952,7 +2949,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 				goto do_stall3;
 			if (w_value != USB_ENDPOINT_HALT)
 				goto do_stall3;
-			VDEBUG(dev, "%s clear halt\n", e->ep.name);
+			ep_vdbg(dev, "%s clear halt\n", e->ep.name);
 			ep_stall(e, false);
 			if (!list_empty(&e->queue) && e->td_dma)
 				restart_dma(e);
@@ -3023,7 +3020,7 @@ static void handle_stat0_irqs_superspeed(struct net2280 *dev,
 	default:
 
 usb3_delegate:
-		VDEBUG(dev, "setup %02x.%02x v%04x i%04x l%04x ep_cfg %08x\n",
+		ep_vdbg(dev, "setup %02x.%02x v%04x i%04x l%04x ep_cfg %08x\n",
 				r.bRequestType, r.bRequest,
 				w_value, w_index, w_length,
 				readl(&ep->cfg->ep_cfg));
@@ -3035,7 +3032,7 @@ usb3_delegate:
 	}
 do_stall3:
 	if (tmp < 0) {
-		VDEBUG(dev, "req %02x.%02x protocol STALL; stat %d\n",
+		ep_vdbg(dev, "req %02x.%02x protocol STALL; stat %d\n",
 				r.bRequestType, r.bRequest, tmp);
 		dev->protocol_stall = 1;
 		/* TD 9.9 Halt Endpoint test. TD 9.22 Set feature test */
@@ -3060,7 +3057,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 	stat &= ~BIT(INTA_ASSERTED);
 	if (!stat)
 		return;
-	/* DEBUG(dev, "irqstat0 %04x\n", stat); */
+	/* ep_dbg(dev, "irqstat0 %04x\n", stat); */
 
 	/* starting a control request? */
 	if (unlikely(stat & BIT(SETUP_PACKET_INTERRUPT))) {
@@ -3087,7 +3084,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 						EP0_HS_MAX_PACKET_SIZE);
 			}
 			net2280_led_speed(dev, dev->gadget.speed);
-			DEBUG(dev, "%s\n",
+			ep_dbg(dev, "%s\n",
 					usb_speed_string(dev->gadget.speed));
 		}
 
@@ -3195,7 +3192,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 			set_fifo_bytecount(ep, w_length);
 			writel((__force u32)status, &dev->epregs[0].ep_data);
 			allow_status(ep);
-			VDEBUG(dev, "%s stat %02x\n", ep->ep.name, status);
+			ep_vdbg(dev, "%s stat %02x\n", ep->ep.name, status);
 			goto next_endpoints;
 			}
 			break;
@@ -3211,10 +3208,10 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 			if (!e)
 				goto do_stall;
 			if (e->wedged) {
-				VDEBUG(dev, "%s wedged, halt not cleared\n",
+				ep_vdbg(dev, "%s wedged, halt not cleared\n",
 						ep->ep.name);
 			} else {
-				VDEBUG(dev, "%s clear halt\n", e->ep.name);
+				ep_vdbg(dev, "%s clear halt\n", e->ep.name);
 				clear_halt(e);
 				if (ep->dev->pdev->vendor ==
 						PCI_VENDOR_ID_PLX &&
@@ -3242,13 +3239,13 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 			if (dev->pdev->vendor == PCI_VENDOR_ID_PLX && e->dma)
 				abort_dma(e);
 			allow_status(ep);
-			VDEBUG(dev, "%s set halt\n", ep->ep.name);
+			ep_vdbg(dev, "%s set halt\n", ep->ep.name);
 			goto next_endpoints;
 			}
 			break;
 		default:
 delegate:
-			VDEBUG(dev, "setup %02x.%02x v%04x i%04x l%04x "
+			ep_vdbg(dev, "setup %02x.%02x v%04x i%04x l%04x "
 				"ep_cfg %08x\n",
 				u.r.bRequestType, u.r.bRequest,
 				w_value, w_index, w_length,
@@ -3262,7 +3259,7 @@ delegate:
 		/* stall ep0 on error */
 		if (tmp < 0) {
 do_stall:
-			VDEBUG(dev, "req %02x.%02x protocol STALL; stat %d\n",
+			ep_vdbg(dev, "req %02x.%02x protocol STALL; stat %d\n",
 					u.r.bRequestType, u.r.bRequest, tmp);
 			dev->protocol_stall = 1;
 		}
@@ -3295,7 +3292,7 @@ next_endpoints:
 	}
 
 	if (stat)
-		DEBUG(dev, "unhandled irqstat0 %08x\n", stat);
+		ep_dbg(dev, "unhandled irqstat0 %08x\n", stat);
 }
 
 #define DMA_INTERRUPTS (BIT(DMA_D_INTERRUPT) | \
@@ -3328,7 +3325,7 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 				((readl(&dev->usb->usbctl) &
 					BIT(VBUS_PIN)) == 0)) &&
 				(dev->gadget.speed != USB_SPEED_UNKNOWN)) {
-			DEBUG(dev, "disconnect %s\n",
+			ep_dbg(dev, "disconnect %s\n",
 					dev->driver->driver.name);
 			stop_activity(dev, dev->driver);
 			ep0_start(dev);
@@ -3380,7 +3377,7 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 
 	if (!stat)
 		return;
-	/* DEBUG(dev, "irqstat1 %08x\n", stat);*/
+	/* ep_dbg(dev, "irqstat1 %08x\n", stat);*/
 
 	/* DMA status, for ep-{a,b,c,d} */
 	scratch = stat & DMA_INTERRUPTS;
@@ -3417,7 +3414,7 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 		 */
 		if (!use_dma_chaining) {
 			if (!(tmp & BIT(DMA_TRANSACTION_DONE_INTERRUPT))) {
-				DEBUG(ep->dev, "%s no xact done? %08x\n",
+				ep_dbg(ep->dev, "%s no xact done? %08x\n",
 					ep->ep.name, tmp);
 				continue;
 			}
@@ -3469,7 +3466,7 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 	 * if they appear very often, here's where to try recovering.
 	 */
 	if (stat & PCI_ERROR_INTERRUPTS) {
-		ERROR(dev, "pci dma error; stat %08x\n", stat);
+		ep_err(dev, "pci dma error; stat %08x\n", stat);
 		stat &= ~PCI_ERROR_INTERRUPTS;
 		/* these are fatal errors, but "maybe" they won't
 		 * happen again ...
@@ -3480,7 +3477,7 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 	}
 
 	if (stat)
-		DEBUG(dev, "unhandled irqstat1 %08x\n", stat);
+		ep_dbg(dev, "unhandled irqstat1 %08x\n", stat);
 }
 
 static irqreturn_t net2280_irq(int irq, void *_dev)
@@ -3556,7 +3553,7 @@ static void net2280_remove(struct pci_dev *pdev)
 		pci_disable_device(pdev);
 	device_remove_file(&pdev->dev, &dev_attr_registers);
 
-	INFO(dev, "unbind\n");
+	ep_info(dev, "unbind\n");
 }
 
 /* wrap this driver around the specified device, but
@@ -3604,7 +3601,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	resource = pci_resource_start(pdev, 0);
 	len = pci_resource_len(pdev, 0);
 	if (!request_mem_region(resource, len, driver_name)) {
-		DEBUG(dev, "controller already in use\n");
+		ep_dbg(dev, "controller already in use\n");
 		retval = -EBUSY;
 		goto done;
 	}
@@ -3616,7 +3613,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	base = ioremap_nocache(resource, len);
 	if (base == NULL) {
-		DEBUG(dev, "can't map memory\n");
+		ep_dbg(dev, "can't map memory\n");
 		retval = -EFAULT;
 		goto done;
 	}
@@ -3665,18 +3662,18 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* irq setup after old hardware is cleaned up */
 	if (!pdev->irq) {
-		ERROR(dev, "No IRQ.  Check PCI setup!\n");
+		ep_err(dev, "No IRQ.  Check PCI setup!\n");
 		retval = -ENODEV;
 		goto done;
 	}
 
 	if (use_msi && dev->pdev->vendor == PCI_VENDOR_ID_PLX)
 		if (pci_enable_msi(pdev))
-			ERROR(dev, "Failed to enable MSI mode\n");
+			ep_err(dev, "Failed to enable MSI mode\n");
 
 	if (request_irq(pdev->irq, net2280_irq, IRQF_SHARED,
 							driver_name, dev)) {
-		ERROR(dev, "request interrupt %d failed\n", pdev->irq);
+		ep_err(dev, "request interrupt %d failed\n", pdev->irq);
 		retval = -EBUSY;
 		goto done;
 	}
@@ -3689,7 +3686,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		0 /* no alignment requirements */,
 		0 /* or page-crossing issues */);
 	if (!dev->requests) {
-		DEBUG(dev, "can't get request pool\n");
+		ep_dbg(dev, "can't get request pool\n");
 		retval = -ENOMEM;
 		goto done;
 	}
@@ -3699,7 +3696,7 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		td = pci_pool_alloc(dev->requests, GFP_KERNEL,
 				&dev->ep[i].td_dma);
 		if (!td) {
-			DEBUG(dev, "can't get dummy %d\n", i);
+			ep_dbg(dev, "can't get dummy %d\n", i);
 			retval = -ENOMEM;
 			goto done;
 		}
@@ -3726,10 +3723,10 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->chiprev = get_idx_reg(dev->regs, REG_CHIPREV) & 0xffff;
 
 	/* done */
-	INFO(dev, "%s\n", driver_desc);
-	INFO(dev, "irq %d, pci mem %p, chip rev %04x\n",
+	ep_info(dev, "%s\n", driver_desc);
+	ep_info(dev, "irq %d, pci mem %p, chip rev %04x\n",
 			pdev->irq, base, dev->chiprev);
-	INFO(dev, "version: " DRIVER_VERSION "; dma %s %s\n",
+	ep_info(dev, "version: " DRIVER_VERSION "; dma %s %s\n",
 		use_dma	? (use_dma_chaining ? "chaining" : "enabled")
 			: "disabled",
 		dev->enhanced_mode ? "enhanced mode" : "legacy mode");
diff --git a/drivers/usb/gadget/net2280.h b/drivers/usb/gadget/net2280.h
index 106624a..9f3a901 100644
--- a/drivers/usb/gadget/net2280.h
+++ b/drivers/usb/gadget/net2280.h
@@ -314,32 +314,20 @@ static inline void net2280_led_shutdown(struct net2280 *dev)
 
 /*-------------------------------------------------------------------------*/
 
-#define xprintk(dev, level, fmt, args...) \
-	printk(level "%s %s: " fmt, driver_name, \
-			pci_name(dev->pdev), ## args)
+#define ep_dbg(ndev, fmt, args...) \
+	dev_dbg((&((ndev)->pdev->dev)), fmt, ##args)
 
-#ifdef DEBUG
-#undef DEBUG
-#define DEBUG(dev, fmt, args...) \
-	xprintk(dev, KERN_DEBUG, fmt, ## args)
-#else
-#define DEBUG(dev, fmt, args...) \
-	do { } while (0)
-#endif /* DEBUG*/
+#define ep_vdbg(ndev, fmt, args...) \
+	dev_vdbg((&((ndev)->pdev->dev)), fmt, ##args)
 
-#ifdef VERBOSE
-#define VDEBUG DEBUG
-#else
-#define VDEBUG(dev, fmt, args...) \
-	do { } while (0)
-#endif	/* VERBOSE */
+#define ep_info(ndev, fmt, args...) \
+	dev_info((&((ndev)->pdev->dev)), fmt, ##args)
+
+#define ep_warn(ndev, fmt, args...) \
+	dev_warn((&((ndev)->pdev->dev)), fmt, ##args)
 
-#define ERROR(dev, fmt, args...) \
-	xprintk(dev, KERN_ERR, fmt, ## args)
-#define WARNING(dev, fmt, args...) \
-	xprintk(dev, KERN_WARNING, fmt, ## args)
-#define INFO(dev, fmt, args...) \
-	xprintk(dev, KERN_INFO, fmt, ## args)
+#define ep_err(ndev, fmt, args...) \
+	dev_err((&((ndev)->pdev->dev)), fmt, ##args)
 
 /*-------------------------------------------------------------------------*/
 
@@ -368,7 +356,7 @@ static inline void assert_out_naking(struct net2280_ep *ep, const char *where)
 	u32	tmp = readl(&ep->regs->ep_stat);
 
 	if ((tmp & BIT(NAK_OUT_PACKETS)) == 0) {
-		DEBUG(ep->dev, "%s %s %08x !NAK\n",
+		ep_dbg(ep->dev, "%s %s %08x !NAK\n",
 				ep->ep.name, where, tmp);
 		writel(BIT(SET_NAK_OUT_PACKETS),
 			&ep->regs->ep_rsp);
-- 
2.0.0.rc2

