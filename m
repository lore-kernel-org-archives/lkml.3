Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaHOQVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:21:22 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52077 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaHOQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:21:21 -0400
Date: Fri, 15 Aug 2014 21:51:15 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] radio-si470x-usb: use USB API functions rather than constants
Message-ID: <20140815162114.GA7091@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of the function usb_endpoint_is_int_in.

The Coccinelle semantic patch that makes these changes is as follows:

@@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
-  \(USB_DIR_IN\|0x80\))
+ usb_endpoint_dir_in(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
- \(USB_ENDPOINT_XFER_INT\|3\))
+ usb_endpoint_xfer_int(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_xfer_int(epd) && usb_endpoint_dir_in(epd))
+ usb_endpoint_is_int_in(epd)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/media/radio/si470x/radio-si470x-usb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 494fac0..57f0bc3 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -607,9 +607,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	/* Set up interrupt endpoint information. */
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
-		if (((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK) ==
-		 USB_DIR_IN) && ((endpoint->bmAttributes &
-		 USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT))
+		if (usb_endpoint_is_int_in(endpoint))
 			radio->int_in_endpoint = endpoint;
 	}
 	if (!radio->int_in_endpoint) {
-- 
1.9.1

