Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967388AbaLLG7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:59:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51721 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758602AbaLLGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.886806629@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 017/164] USB: Add device quirk for ASUS T100 Base
 Station keyboard
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit ddbe1fca0bcb87ca8c199ea873a456ca8a948567 upstream.

This full-speed USB device generates spurious remote wakeup event
as soon as USB_DEVICE_REMOTE_WAKEUP feature is set. As the result,
Linux can't enter system suspend and S0ix power saving modes once
this keyboard is used.

This patch tries to introduce USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk.
With this quirk set, wakeup capability will be ignored during
device configure.

This patch could be back-ported to kernels as old as 2.6.39.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c     | 6 ++++--
 drivers/usb/core/quirks.c  | 4 ++++
 include/linux/usb/quirks.h | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1633,8 +1633,10 @@ void usb_set_device_state(struct usb_dev
 					|| new_state == USB_STATE_SUSPENDED)
 				;	/* No change to wakeup settings */
 			else if (new_state == USB_STATE_CONFIGURED)
-				wakeup = udev->actconfig->desc.bmAttributes
-					 & USB_CONFIG_ATT_WAKEUP;
+				wakeup = (udev->quirks &
+					USB_QUIRK_IGNORE_REMOTE_WAKEUP) ? 0 :
+					udev->actconfig->desc.bmAttributes &
+					USB_CONFIG_ATT_WAKEUP;
 			else
 				wakeup = 0;
 		}
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -157,6 +157,10 @@ static const struct usb_device_id usb_qu
 	/* USB3503 */
 	{ USB_DEVICE(0x0424, 0x3503), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* ASUS Base Station(T100) */
+	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
+			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
+
 	{ }  /* terminating entry must be last */
 };
 
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -30,4 +30,7 @@
    descriptor */
 #define USB_QUIRK_DELAY_INIT		0x00000040
 
+/* device generates spurious wakeup, ignore remote wakeup capability */
+#define USB_QUIRK_IGNORE_REMOTE_WAKEUP	0x00000200
+
 #endif /* __LINUX_USB_QUIRKS_H */

