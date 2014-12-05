Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaLEXT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:19:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaLEW4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 50/73] Input: xpad - use proper endpoint type
Date: Fri,  5 Dec 2014 14:44:56 -0800
Message-Id: <20141205224435.435156795@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit a1f9a4072655843fc03186acbad65990cc05dd2d upstream.

The xpad wireless endpoint is not a bulk endpoint on my devices, but
rather an interrupt one, so the USB core complains when it is submitted.
I'm guessing that the author really did mean that this should be an
interrupt urb, but as there are a zillion different xpad devices out
there, let's cover out bases and handle both bulk and interrupt
endpoints just as easily.

Signed-off-by: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/joystick/xpad.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -1003,9 +1003,19 @@ static int xpad_probe(struct usb_interfa
 		}
 
 		ep_irq_in = &intf->cur_altsetting->endpoint[1].desc;
-		usb_fill_bulk_urb(xpad->bulk_out, udev,
-				usb_sndbulkpipe(udev, ep_irq_in->bEndpointAddress),
-				xpad->bdata, XPAD_PKT_LEN, xpad_bulk_out, xpad);
+		if (usb_endpoint_is_bulk_out(ep_irq_in)) {
+			usb_fill_bulk_urb(xpad->bulk_out, udev,
+					  usb_sndbulkpipe(udev,
+							  ep_irq_in->bEndpointAddress),
+					  xpad->bdata, XPAD_PKT_LEN,
+					  xpad_bulk_out, xpad);
+		} else {
+			usb_fill_int_urb(xpad->bulk_out, udev,
+					 usb_sndintpipe(udev,
+							ep_irq_in->bEndpointAddress),
+					 xpad->bdata, XPAD_PKT_LEN,
+					 xpad_bulk_out, xpad, 0);
+		}
 
 		/*
 		 * Submit the int URB immediately rather than waiting for open


