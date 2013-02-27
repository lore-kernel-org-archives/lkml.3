Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab3B0PjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:39:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760015Ab3B0PjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:39:15 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 2/2] HID: multitouch: remove last usb dependency
Date: Wed, 27 Feb 2013 16:38:18 +0100
Message-Id: <1361979498-24446-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1361979498-24446-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1361979498-24446-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid-multitouch used to direclty call for a set_idle in the .resume()
callback. With the new hid_hw_idle(), this can be dropped and
hid-multitouch is now freed from its transport layer.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 51d8938..1f544a4 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -896,26 +896,11 @@ static int mt_reset_resume(struct hid_device *hdev)
 
 static int mt_resume(struct hid_device *hdev)
 {
-	struct usb_interface *intf;
-	struct usb_host_interface *interface;
-	struct usb_device *dev;
-
-	if (hdev->bus != BUS_USB)
-		return 0;
-
-	intf = to_usb_interface(hdev->dev.parent);
-	interface = intf->cur_altsetting;
-	dev = interface_to_usbdev(intf);
-
 	/* Some Elan legacy devices require SET_IDLE to be set on resume.
 	 * It should be safe to send it to other devices too.
 	 * Tested on 3M, Stantum, Cypress, Zytronic, eGalax, and Elan panels. */
 
-	usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-			HID_REQ_SET_IDLE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			0, interface->desc.bInterfaceNumber,
-			NULL, 0, USB_CTRL_SET_TIMEOUT);
+	hid_hw_idle(hdev, 0, 0, HID_REQ_SET_IDLE);
 
 	return 0;
 }
-- 
1.8.1.2

