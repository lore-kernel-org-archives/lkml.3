Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbbALK6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:58:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52614 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149AbbALK6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:58:06 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 5/5] usb: gadget: atmel_usba: Cache INT_ENB register value
Date: Mon, 12 Jan 2015 11:57:58 +0100
Message-Id: <1421060278-27329-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421060278-27329-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1421060278-27329-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache INT_ENB register value in order to avoid uncached iomem access, and
thus improve access time to INT_ENB value.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/usb/gadget/udc/atmel_usba_udc.c | 52 ++++++++++++++++++---------------
 drivers/usb/gadget/udc/atmel_usba_udc.h |  2 ++
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
index bc3a532..6dfe17b 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -316,6 +316,17 @@ static inline void usba_cleanup_debugfs(struct usba_udc *udc)
 }
 #endif
 
+static inline u32 usba_int_enb_get(struct usba_udc *udc)
+{
+	return udc->int_enb_cache;
+}
+
+static inline void usba_int_enb_set(struct usba_udc *udc, u32 val)
+{
+	usba_writel(udc, INT_ENB, val);
+	udc->int_enb_cache = val;
+}
+
 static int vbus_is_present(struct usba_udc *udc)
 {
 	if (gpio_is_valid(udc->vbus_pin))
@@ -597,16 +608,14 @@ usba_ep_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	if (ep->can_dma) {
 		u32 ctrl;
 
-		usba_writel(udc, INT_ENB,
-				(usba_readl(udc, INT_ENB)
-					| USBA_BF(EPT_INT, 1 << ep->index)
-					| USBA_BF(DMA_INT, 1 << ep->index)));
+		usba_int_enb_set(udc, usba_int_enb_get(udc) |
+				      USBA_BF(EPT_INT, 1 << ep->index) |
+				      USBA_BF(DMA_INT, 1 << ep->index));
 		ctrl = USBA_AUTO_VALID | USBA_INTDIS_DMA;
 		usba_ep_writel(ep, CTL_ENB, ctrl);
 	} else {
-		usba_writel(udc, INT_ENB,
-				(usba_readl(udc, INT_ENB)
-					| USBA_BF(EPT_INT, 1 << ep->index)));
+		usba_int_enb_set(udc, usba_int_enb_get(udc) |
+				      USBA_BF(EPT_INT, 1 << ep->index));
 	}
 
 	spin_unlock_irqrestore(&udc->lock, flags);
@@ -614,7 +623,7 @@ usba_ep_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 	DBG(DBG_HW, "EPT_CFG%d after init: %#08lx\n", ep->index,
 			(unsigned long)usba_ep_readl(ep, CFG));
 	DBG(DBG_HW, "INT_ENB after init: %#08lx\n",
-			(unsigned long)usba_readl(udc, INT_ENB));
+			(unsigned long)usba_int_enb_get(udc));
 
 	return 0;
 }
@@ -650,9 +659,8 @@ static int usba_ep_disable(struct usb_ep *_ep)
 		usba_dma_readl(ep, STATUS);
 	}
 	usba_ep_writel(ep, CTL_DIS, USBA_EPT_ENABLE);
-	usba_writel(udc, INT_ENB,
-			usba_readl(udc, INT_ENB)
-			& ~USBA_BF(EPT_INT, 1 << ep->index));
+	usba_int_enb_set(udc, usba_int_enb_get(udc) &
+			      ~USBA_BF(EPT_INT, 1 << ep->index));
 
 	request_complete_list(ep, &req_list, -ESHUTDOWN);
 
@@ -1606,20 +1614,20 @@ static void usba_dma_irq(struct usba_udc *udc, struct usba_ep *ep)
 static irqreturn_t usba_udc_irq(int irq, void *devid)
 {
 	struct usba_udc *udc = devid;
-	u32 status;
+	u32 status, int_enb;
 	u32 dma_status;
 	u32 ep_status;
 
 	spin_lock(&udc->lock);
 
-	status = usba_readl(udc, INT_STA) & usba_readl(udc, INT_ENB);
+	int_enb = usba_int_enb_get(udc);
+	status = usba_readl(udc, INT_STA) & int_enb;
 	DBG(DBG_INT, "irq, status=%#08x\n", status);
 
 	if (status & USBA_DET_SUSPEND) {
 		toggle_bias(udc, 0);
 		usba_writel(udc, INT_CLR, USBA_DET_SUSPEND);
-		usba_writel(udc, INT_ENB,
-			    usba_readl(udc, INT_ENB) | USBA_WAKE_UP);
+		usba_int_enb_set(udc, int_enb | USBA_WAKE_UP);
 		udc->bias_pulse_needed = true;
 		DBG(DBG_BUS, "Suspend detected\n");
 		if (udc->gadget.speed != USB_SPEED_UNKNOWN
@@ -1633,8 +1641,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 	if (status & USBA_WAKE_UP) {
 		toggle_bias(udc, 1);
 		usba_writel(udc, INT_CLR, USBA_WAKE_UP);
-		usba_writel(udc, INT_ENB,
-			    usba_readl(udc, INT_ENB) & ~USBA_WAKE_UP);
+		usba_int_enb_set(udc, int_enb & ~USBA_WAKE_UP);
 		DBG(DBG_BUS, "Wake Up CPU detected\n");
 	}
 
@@ -1702,11 +1709,8 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 				| USBA_BF(BK_NUMBER, USBA_BK_NUMBER_ONE)));
 		usba_ep_writel(ep0, CTL_ENB,
 				USBA_EPT_ENABLE | USBA_RX_SETUP);
-		usba_writel(udc, INT_ENB,
-				(usba_readl(udc, INT_ENB)
-				| USBA_BF(EPT_INT, 1)
-				| USBA_DET_SUSPEND
-				| USBA_END_OF_RESUME));
+		usba_int_enb_set(udc, int_enb | USBA_BF(EPT_INT, 1) |
+				      USBA_DET_SUSPEND | USBA_END_OF_RESUME);
 
 		/*
 		 * Unclear why we hit this irregularly, e.g. in usbtest,
@@ -1741,7 +1745,7 @@ static irqreturn_t usba_vbus_irq(int irq, void *devid)
 		if (vbus) {
 			toggle_bias(udc, 1);
 			usba_writel(udc, CTRL, USBA_ENABLE_MASK);
-			usba_writel(udc, INT_ENB, USBA_END_OF_RESET);
+			usba_int_enb_set(udc, USBA_END_OF_RESET);
 		} else {
 			udc->gadget.speed = USB_SPEED_UNKNOWN;
 			reset_all_endpoints(udc);
@@ -1793,7 +1797,7 @@ static int atmel_usba_start(struct usb_gadget *gadget,
 	if (vbus_is_present(udc) && udc->vbus_prev == 0) {
 		toggle_bias(udc, 1);
 		usba_writel(udc, CTRL, USBA_ENABLE_MASK);
-		usba_writel(udc, INT_ENB, USBA_END_OF_RESET);
+		usba_int_enb_set(udc, USBA_END_OF_RESET);
 	}
 	spin_unlock_irqrestore(&udc->lock, flags);
 
diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.h b/drivers/usb/gadget/udc/atmel_usba_udc.h
index 72b3537..497cd18 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.h
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.h
@@ -334,6 +334,8 @@ struct usba_udc {
 	u16 test_mode;
 	int vbus_prev;
 
+	u32 int_enb_cache;
+
 #ifdef CONFIG_USB_GADGET_DEBUG_FS
 	struct dentry *debugfs_root;
 	struct dentry *debugfs_regs;
-- 
1.9.1

