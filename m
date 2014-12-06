Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaLFPUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:38 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47692 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752051AbaLFPIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.12 49/66] Input: xpad - use proper endpoint type
Date: Sat,  6 Dec 2014 16:07:41 +0100
Message-Id: <52c0674a23d9309d07cca0ca50403b304faf83c4.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a1f9a4072655843fc03186acbad65990cc05dd2d upstream.

The xpad wireless endpoint is not a bulk endpoint on my devices, but
rather an interrupt one, so the USB core complains when it is submitted.
I'm guessing that the author really did mean that this should be an
interrupt urb, but as there are a zillion different xpad devices out
there, let's cover out bases and handle both bulk and interrupt
endpoints just as easily.

Signed-off-by: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/joystick/xpad.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 7b717d8b6897..90c7f97ea0ad 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -1039,9 +1039,19 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
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
-- 
2.1.3

