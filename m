Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaAMOZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:25:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51153 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaAMOZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Engelmayer <christian.engelmayer@frequentis.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 03/96] Input: usbtouchscreen - separate report and transmit buffer size handling
Date: Mon, 13 Jan 2014 14:23:26 +0000
Message-Id: <1389623099-18783-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Engelmayer <christian.engelmayer@frequentis.com>

commit 4ef38351d770cc421f4a0c7a849fd13207fc5741 upstream.

This patch supports the separate handling of the USB transfer buffer length
and the length of the buffer used for multi packet support. For devices
supporting multiple report or diagnostic packets, the USB transfer size is now
limited to the USB endpoints wMaxPacketSize - otherwise it defaults to the
configured report packet size as before.

This fixes an issue where event reporting can be delayed for an arbitrary
time for multi packet devices. For instance the report size for eGalax devices
is defined to the 16 byte maximum diagnostic packet size as opposed to the 5
byte report packet size. In case the driver requests 16 byte from the USB
interrupt endpoint, the USB host controller driver needs to split up the
request into 2 accesses according to the endpoints wMaxPacketSize of 8 byte.
When the first transfer is answered by the eGalax device with not less than
the full 8 byte requested, the host controller has got no way of knowing
whether the touch controller has got additional data queued and will issue
the second transfer. If per example a liftoff event finishes at such a
wMaxPacketSize boundary, the data will not be available to the usbtouch driver
until a further event is triggered and transfered to the host. From user
perspective the BTN_TOUCH release event in this case is stuck until the next
touch down event.

Signed-off-by: Christian Engelmayer <christian.engelmayer@frequentis.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/touchscreen/usbtouchscreen.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index e32709e..da159bc 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -106,6 +106,7 @@ struct usbtouch_device_info {
 struct usbtouch_usb {
 	unsigned char *data;
 	dma_addr_t data_dma;
+	int data_size;
 	unsigned char *buffer;
 	int buf_len;
 	struct urb *irq;
@@ -1483,7 +1484,7 @@ static int usbtouch_reset_resume(struct usb_interface *intf)
 static void usbtouch_free_buffers(struct usb_device *udev,
 				  struct usbtouch_usb *usbtouch)
 {
-	usb_free_coherent(udev, usbtouch->type->rept_size,
+	usb_free_coherent(udev, usbtouch->data_size,
 			  usbtouch->data, usbtouch->data_dma);
 	kfree(usbtouch->buffer);
 }
@@ -1528,7 +1529,20 @@ static int usbtouch_probe(struct usb_interface *intf,
 	if (!type->process_pkt)
 		type->process_pkt = usbtouch_process_pkt;
 
-	usbtouch->data = usb_alloc_coherent(udev, type->rept_size,
+	usbtouch->data_size = type->rept_size;
+	if (type->get_pkt_len) {
+		/*
+		 * When dealing with variable-length packets we should
+		 * not request more than wMaxPacketSize bytes at once
+		 * as we do not know if there is more data coming or
+		 * we filled exactly wMaxPacketSize bytes and there is
+		 * nothing else.
+		 */
+		usbtouch->data_size = min(usbtouch->data_size,
+					  usb_endpoint_maxp(endpoint));
+	}
+
+	usbtouch->data = usb_alloc_coherent(udev, usbtouch->data_size,
 					    GFP_KERNEL, &usbtouch->data_dma);
 	if (!usbtouch->data)
 		goto out_free;
@@ -1588,12 +1602,12 @@ static int usbtouch_probe(struct usb_interface *intf,
 	if (usb_endpoint_type(endpoint) == USB_ENDPOINT_XFER_INT)
 		usb_fill_int_urb(usbtouch->irq, udev,
 			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),
-			 usbtouch->data, type->rept_size,
+			 usbtouch->data, usbtouch->data_size,
 			 usbtouch_irq, usbtouch, endpoint->bInterval);
 	else
 		usb_fill_bulk_urb(usbtouch->irq, udev,
 			 usb_rcvbulkpipe(udev, endpoint->bEndpointAddress),
-			 usbtouch->data, type->rept_size,
+			 usbtouch->data, usbtouch->data_size,
 			 usbtouch_irq, usbtouch);
 
 	usbtouch->irq->dev = udev;
-- 
1.8.3.2

