Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab3KRSxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:53:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3KRSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:41:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Martin MOKREJS <mmokrejs@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.11 24/25] usbcore: set lpm_capable field for LPM capable root hubs
Date: Mon, 18 Nov 2013 10:40:53 -0800
Message-Id: <20131118184039.591635230@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xenia Ragiadakou <burzalodowa@gmail.com>

commit 9df89d85b407690afa46ddfbccc80bec6869971d upstream.

This patch sets the lpm_capable field for root hubs with LPM capabilities.

Signed-off-by: Xenia Ragiadakou <burzalodowa@gmail.com>
Reported-by: Martin MOKREJS <mmokrejs@gmail.com>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hcd.c |    1 +
 drivers/usb/core/hub.c |    7 ++++++-
 drivers/usb/core/usb.h |    1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1035,6 +1035,7 @@ static int register_root_hub(struct usb_
 					dev_name(&usb_dev->dev), retval);
 			return retval;
 		}
+		usb_dev->lpm_capable = usb_device_supports_lpm(usb_dev);
 	}
 
 	retval = usb_new_device (usb_dev);
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -135,7 +135,7 @@ struct usb_hub *usb_hub_to_struct_hub(st
 	return usb_get_intfdata(hdev->actconfig->interface[0]);
 }
 
-static int usb_device_supports_lpm(struct usb_device *udev)
+int usb_device_supports_lpm(struct usb_device *udev)
 {
 	/* USB 2.1 (and greater) devices indicate LPM support through
 	 * their USB 2.0 Extended Capabilities BOS descriptor.
@@ -156,6 +156,11 @@ static int usb_device_supports_lpm(struc
 				"Power management will be impacted.\n");
 		return 0;
 	}
+
+	/* udev is root hub */
+	if (!udev->parent)
+		return 1;
+
 	if (udev->parent->lpm_capable)
 		return 1;
 
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -35,6 +35,7 @@ extern int usb_get_device_descriptor(str
 		unsigned int size);
 extern int usb_get_bos_descriptor(struct usb_device *dev);
 extern void usb_release_bos_descriptor(struct usb_device *dev);
+extern int usb_device_supports_lpm(struct usb_device *udev);
 extern char *usb_cache_string(struct usb_device *udev, int index);
 extern int usb_set_configuration(struct usb_device *dev, int configuration);
 extern int usb_choose_configuration(struct usb_device *udev);


