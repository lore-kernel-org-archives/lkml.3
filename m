Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaJGXTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:19:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbaJGXTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.16 17/26] uas: Only complain about missing sg if all other checks succeed
Date: Tue,  7 Oct 2014 16:19:33 -0700
Message-Id: <20141007231848.998176269@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit cc4deafc86f75f4e716b37fb4ea3572eb1e49e50 upstream.

Don't complain about controllers without sg support if there are other
reasons why uas cannot be used anyways.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas-detect.h |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -9,32 +9,15 @@ static int uas_is_interface(struct usb_h
 		intf->desc.bInterfaceProtocol == USB_PR_UAS);
 }
 
-static int uas_isnt_supported(struct usb_device *udev)
-{
-	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
-
-	dev_warn(&udev->dev, "The driver for the USB controller %s does not "
-			"support scatter-gather which is\n",
-			hcd->driver->description);
-	dev_warn(&udev->dev, "required by the UAS driver. Please try an"
-			"alternative USB controller if you wish to use UAS.\n");
-	return -ENODEV;
-}
-
 static int uas_find_uas_alt_setting(struct usb_interface *intf)
 {
 	int i;
-	struct usb_device *udev = interface_to_usbdev(intf);
-	int sg_supported = udev->bus->sg_tablesize != 0;
 
 	for (i = 0; i < intf->num_altsetting; i++) {
 		struct usb_host_interface *alt = &intf->altsetting[i];
 
-		if (uas_is_interface(alt)) {
-			if (!sg_supported)
-				return uas_isnt_supported(udev);
+		if (uas_is_interface(alt))
 			return alt->desc.bAlternateSetting;
-		}
 	}
 
 	return -ENODEV;
@@ -92,5 +75,14 @@ static int uas_use_uas_driver(struct usb
 	if (r < 0)
 		return 0;
 
+	if (udev->bus->sg_tablesize == 0) {
+		dev_warn(&udev->dev,
+			"The driver for the USB controller %s does not support scatter-gather which is\n",
+			hcd->driver->description);
+		dev_warn(&udev->dev,
+			"required by the UAS driver. Please try an other USB controller if you wish to use UAS.\n");
+		return 0;
+	}
+
 	return 1;
 }


