Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaIOKdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:33:20 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:33897 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752688AbaIOKdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:33:19 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, software@gaisler.com
Subject: [PATCH] usb: gadget: gr_udc: Add bounce buffer to handle odd sized OUT requests
Date: Mon, 15 Sep 2014 12:32:54 +0200
Message-Id: <1410777174-27053-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a bounce buffer that handles the end of OUT requests where
req.length is not divisible by ep->ep.maxpacket.

Before this, such requests were rejected as the DMA engine cannot
restrict itself to buffers that are smaller than ep->ep.maxpacket.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/usb/gadget/udc/gr_udc.c |   81 +++++++++++++++++++++++++++++----------
 drivers/usb/gadget/udc/gr_udc.h |    7 ++++
 2 files changed, 67 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/gadget/udc/gr_udc.c b/drivers/usb/gadget/udc/gr_udc.c
index 08df5c4..ecd10b5 100644
--- a/drivers/usb/gadget/udc/gr_udc.c
+++ b/drivers/usb/gadget/udc/gr_udc.c
@@ -318,8 +318,26 @@ static void gr_finish_request(struct gr_ep *ep, struct gr_request *req,
 	usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
 	gr_free_dma_desc_chain(dev, req);
 
-	if (ep->is_in) /* For OUT, actual gets updated bit by bit */
+	if (ep->is_in) { /* For OUT, req->req.actual gets updated bit by bit */
 		req->req.actual = req->req.length;
+	} else if (req->oddlen && req->req.actual > req->evenlen) {
+		/*
+		 * Copy to user buffer in this case where length was not evenly
+		 * divisible by ep->ep.maxpacket and the last descriptor was
+		 * actually used.
+		 */
+		char *buftail = ((char *)req->req.buf + req->evenlen);
+
+		memcpy(buftail, ep->tailbuf, req->oddlen);
+
+		if (req->req.actual > req->req.length) {
+			/* We got more data than was requested */
+			dev_dbg(ep->dev->dev, "Overflow for ep %s\n",
+				ep->ep.name);
+			gr_dbgprint_request("OVFL", ep, req);
+			req->req.status = -EOVERFLOW;
+		}
+	}
 
 	if (!status) {
 		if (ep->is_in)
@@ -379,6 +397,15 @@ static void gr_start_dma(struct gr_ep *ep)
 	/* A descriptor should already have been allocated */
 	BUG_ON(!req->curr_desc);
 
+	/*
+	 * The DMA controller can not handle smaller OUT buffers than
+	 * ep->ep.maxpacket. It could lead to buffer overruns if an unexpectedly
+	 * long packet are received. Therefore an internal bounce buffer gets
+	 * used when such a request gets enabled.
+	 */
+	if (!ep->is_in && req->oddlen)
+		req->last_desc->data = ep->tailbuf_paddr;
+
 	wmb(); /* Make sure all is settled before handing it over to DMA */
 
 	/* Set the descriptor pointer in the hardware */
@@ -480,11 +507,11 @@ static int gr_setup_out_desc_list(struct gr_ep *ep, struct gr_request *req,
 		dma_addr_t start = req->req.dma + bytes_used;
 		u16 size = min(bytes_left, ep->bytes_per_buffer);
 
-		/* Should not happen however - gr_queue stops such lengths */
-		if (size < ep->bytes_per_buffer)
-			dev_warn(ep->dev->dev,
-				 "Buffer overrun risk: %u < %u bytes/buffer\n",
-				 size, ep->bytes_per_buffer);
+		if (size < ep->bytes_per_buffer) {
+			/* Prepare using bounce buffer */
+			req->evenlen = req->req.length - bytes_left;
+			req->oddlen = size;
+		}
 
 		ret = gr_add_dma_desc(ep, req, start, size, gfp_flags);
 		if (ret)
@@ -584,18 +611,6 @@ static int gr_queue(struct gr_ep *ep, struct gr_request *req, gfp_t gfp_flags)
 		return -EINVAL;
 	}
 
-	/*
-	 * The DMA controller can not handle smaller OUT buffers than
-	 * maxpacket. It could lead to buffer overruns if unexpectedly long
-	 * packet are received.
-	 */
-	if (!ep->is_in && (req->req.length % ep->ep.maxpacket) != 0) {
-		dev_err(dev->dev,
-			"OUT request length %d is not multiple of maxpacket\n",
-			req->req.length);
-		return -EMSGSIZE;
-	}
-
 	if (unlikely(!dev->driver || dev->gadget.speed == USB_SPEED_UNKNOWN)) {
 		dev_err(dev->dev, "-ESHUTDOWN");
 		return -ESHUTDOWN;
@@ -1286,8 +1301,8 @@ static int gr_handle_out_ep(struct gr_ep *ep)
 	if (ctrl & GR_DESC_OUT_CTRL_SE)
 		req->setup = 1;
 
-	if (len < ep->ep.maxpacket || req->req.actual == req->req.length) {
-		/* Short packet or the expected size - we are done */
+	if (len < ep->ep.maxpacket || req->req.actual >= req->req.length) {
+		/* Short packet or >= expected size - we are done */
 
 		if ((ep == &dev->epo[0]) && (dev->ep0state == GR_EP0_OSTATUS)) {
 			/*
@@ -2015,6 +2030,11 @@ static int gr_ep_init(struct gr_udc *dev, int num, int is_in, u32 maxplimit)
 	}
 	list_add_tail(&ep->ep_list, &dev->ep_list);
 
+	ep->tailbuf = dma_alloc_coherent(dev->dev, ep->ep.maxpacket_limit,
+					 &ep->tailbuf_paddr, GFP_ATOMIC);
+	if (!ep->tailbuf)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -2067,9 +2087,24 @@ static int gr_udc_init(struct gr_udc *dev)
 	return 0;
 }
 
+static void gr_ep_remove(struct gr_udc *dev, int num, int is_in)
+{
+	struct gr_ep *ep;
+
+	if (is_in)
+		ep = &dev->epi[num];
+	else
+		ep = &dev->epo[num];
+
+	if (ep->tailbuf)
+		dma_free_coherent(dev->dev, ep->ep.maxpacket_limit,
+				  ep->tailbuf, ep->tailbuf_paddr);
+}
+
 static int gr_remove(struct platform_device *pdev)
 {
 	struct gr_udc *dev = platform_get_drvdata(pdev);
+	int i;
 
 	if (dev->added)
 		usb_del_gadget_udc(&dev->gadget); /* Shuts everything down */
@@ -2084,6 +2119,11 @@ static int gr_remove(struct platform_device *pdev)
 	gr_free_request(&dev->epi[0].ep, &dev->ep0reqi->req);
 	gr_free_request(&dev->epo[0].ep, &dev->ep0reqo->req);
 
+	for (i = 0; i < dev->nepo; i++)
+		gr_ep_remove(dev, i, 0);
+	for (i = 0; i < dev->nepi; i++)
+		gr_ep_remove(dev, i, 1);
+
 	return 0;
 }
 static int gr_request_irq(struct gr_udc *dev, int irq)
@@ -2131,7 +2171,6 @@ static int gr_probe(struct platform_device *pdev)
 	dev->gadget.name = driver_name;
 	dev->gadget.max_speed = USB_SPEED_HIGH;
 	dev->gadget.ops = &gr_ops;
-	dev->gadget.quirk_ep_out_aligned_size = true;
 
 	spin_lock_init(&dev->lock);
 	dev->regs = regs;
diff --git a/drivers/usb/gadget/udc/gr_udc.h b/drivers/usb/gadget/udc/gr_udc.h
index 8388897..4297c4e 100644
--- a/drivers/usb/gadget/udc/gr_udc.h
+++ b/drivers/usb/gadget/udc/gr_udc.h
@@ -156,6 +156,10 @@ struct gr_ep {
 	struct list_head queue;
 
 	struct list_head ep_list;
+
+	/* Bounce buffer for end of "odd" sized OUT requests */
+	void *tailbuf;
+	dma_addr_t tailbuf_paddr;
 };
 
 struct gr_request {
@@ -167,6 +171,9 @@ struct gr_request {
 	struct gr_dma_desc *curr_desc; /* Current descriptor */
 	struct gr_dma_desc *last_desc; /* Last in the chain */
 
+	u16 evenlen; /* Size of even length head (if oddlen != 0) */
+	u16 oddlen; /* Size of odd length tail if buffer length is "odd" */
+
 	u8 setup; /* Setup packet */
 };
 
-- 
1.7.10.4

