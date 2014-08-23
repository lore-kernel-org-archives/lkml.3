Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaHWXvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 19:51:25 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48806 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaHWXvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 19:51:23 -0400
Date: Sun, 24 Aug 2014 05:21:16 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] usb: gadget: udc: use USB API functions rather than constants
Message-ID: <20140823235116.GA6392@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of the functions usb_endpoint_type and
usb_endpoint_num.

The Coccinelle semantic patch that makes these changes is as follows:

@@ struct usb_endpoint_descriptor *epd; @@

- (epd->bEndpointAddress & \(USB_ENDPOINT_NUMBER_MASK\|0x0f\))
+ usb_endpoint_num(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\))
+ usb_endpoint_type(epd)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/usb/gadget/udc/r8a66597-udc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/udc/r8a66597-udc.c
index 4600842..22a5880 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -430,7 +430,7 @@ static void r8a66597_ep_setting(struct r8a66597 *r8a66597,
 	ep->pipenum = pipenum;
 	ep->ep.maxpacket = usb_endpoint_maxp(desc);
 	r8a66597->pipenum2ep[pipenum] = ep;
-	r8a66597->epaddr2ep[desc->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK]
+	r8a66597->epaddr2ep[usb_endpoint_num(desc)]
 		= ep;
 	INIT_LIST_HEAD(&ep->queue);
 }
@@ -464,7 +464,7 @@ static int alloc_pipe_config(struct r8a66597_ep *ep,
 	if (ep->pipenum)	/* already allocated pipe  */
 		return 0;
 
-	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
+	switch (usb_endpoint_type(desc)) {
 	case USB_ENDPOINT_XFER_BULK:
 		if (r8a66597->bulk >= R8A66597_MAX_NUM_BULK) {
 			if (r8a66597->isochronous >= R8A66597_MAX_NUM_ISOC) {
@@ -509,7 +509,7 @@ static int alloc_pipe_config(struct r8a66597_ep *ep,
 	}
 	ep->type = info.type;
 
-	info.epnum = desc->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
+	info.epnum = usb_endpoint_num(desc);
 	info.maxpacket = usb_endpoint_maxp(desc);
 	info.interval = desc->bInterval;
 	if (desc->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
-- 
1.9.1

