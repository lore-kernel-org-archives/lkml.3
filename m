Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaHOQXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:23:31 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40072 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaHOQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:23:30 -0400
Date: Fri, 15 Aug 2014 21:53:24 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] orinoco_usb: use USB API functions rather than constants
Message-ID: <20140815162324.GA7162@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of the functions
usb_endpoint_is_bulk_in(epd) and usb_endpoint_is_bulk_out(epd).

The semantic patch that makes these changes is as follows:

@@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
- \(USB_ENDPOINT_XFER_BULK\|2\))
+ usb_endpoint_xfer_bulk(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
-  \(USB_DIR_IN\|0x80\))
+ usb_endpoint_dir_in(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
-  \(USB_DIR_OUT\|0\))
+ usb_endpoint_dir_out(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_xfer_bulk(epd) && usb_endpoint_dir_in(epd))
+ usb_endpoint_is_bulk_in(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_xfer_bulk(epd) && usb_endpoint_dir_out(epd))
+ usb_endpoint_is_bulk_out(epd)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/net/wireless/orinoco/orinoco_usb.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index d3cf7c3..f4b784f 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1605,10 +1605,7 @@ static int ezusb_probe(struct usb_interface *interface,
 	for (i = 0; i < iface_desc->bNumEndpoints; ++i) {
 		ep = &interface->altsetting[0].endpoint[i].desc;
 
-		if (((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
-		     == USB_DIR_IN) &&
-		    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-		     == USB_ENDPOINT_XFER_BULK)) {
+		if (usb_endpoint_is_bulk_in(ep)) {
 			/* we found a bulk in endpoint */
 			if (upriv->read_urb != NULL) {
 				pr_warning("Found a second bulk in ep, ignored");
@@ -1636,10 +1633,7 @@ static int ezusb_probe(struct usb_interface *interface,
 			}
 		}
 
-		if (((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
-		     == USB_DIR_OUT) &&
-		    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-		     == USB_ENDPOINT_XFER_BULK)) {
+		if (usb_endpoint_is_bulk_out(ep)) {
 			/* we found a bulk out endpoint */
 			if (upriv->bap_buf != NULL) {
 				pr_warning("Found a second bulk out ep, ignored");
-- 
1.9.1

