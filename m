Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaIABIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 21:08:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:52825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaIABIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 21:08:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,438,1406617200"; 
   d="scan'208";a="592611632"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 1/1] USB: Add device quirk for ASUS T100 Base Station keyboard
Date: Mon,  1 Sep 2014 09:02:16 +0800
Message-Id: <1409533336-68450-1-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This full-speed USB device generates spurious remote wakeup event
as soon as USB_DEVICE_REMOTE_WAKEUP feature is set. As the result,
Linux can't enter system suspend and S0ix power saving modes once
this keyboard is used.

This patch tries to introduce USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk.
With this quirk set, wakeup capability will be ignored during
device configure.

This patch could be back-ported to kernels as old as 2.6.39.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/usb/core/hub.c     | 6 ++++--
 drivers/usb/core/quirks.c  | 4 ++++
 include/linux/usb/quirks.h | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8a4dcbc..5df1457 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1977,8 +1977,10 @@ void usb_set_device_state(struct usb_device *udev,
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
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index bae636e..e7d1e3c 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -159,6 +159,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* USB3503 */
 	{ USB_DEVICE(0x0424, 0x3503), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* ASUS Base Station(T100) */
+	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
+			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
+
 	{ }  /* terminating entry must be last */
 };
 
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index 55a17b1..0f784c3 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -41,4 +41,7 @@
  */
 #define USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL	0x00000080
 
+/* device generates spurious wakeup, ignore remote wakeup capability */
+#define USB_QUIRK_IGNORE_REMOTE_WAKEUP	0x00000100
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
1.9.1

