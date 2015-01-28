Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971AbbA1F3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:29:00 -0500
Received: from mail.kernel.org ([198.145.29.136]:37027 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759870AbbA1EOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:31 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 014/177] USB: Add device quirk for ASUS T100 Base Station keyboard
Date: Wed, 28 Jan 2015 12:06:34 +0800
Message-Id: <1422418236-12852-27-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/core/hub.c     | 6 ++++--
 drivers/usb/core/quirks.c  | 4 ++++
 include/linux/usb/quirks.h | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 62a9e44..2d5177a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1638,8 +1638,10 @@ void usb_set_device_state(struct usb_device *udev,
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
index bcde6f6..a95a5de 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -158,6 +158,10 @@ static const struct usb_device_id usb_interface_quirk_list[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x046d, USB_CLASS_VIDEO, 1, 0),
 	  .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* ASUS Base Station(T100) */
+	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
+			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
+
 	{ }  /* terminating entry must be last */
 };
 
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index 3e93de7..8eeeb87 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -30,4 +30,7 @@
    descriptor */
 #define USB_QUIRK_DELAY_INIT		0x00000040
 
+/* device generates spurious wakeup, ignore remote wakeup capability */
+#define USB_QUIRK_IGNORE_REMOTE_WAKEUP	0x00000200
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
1.9.1

