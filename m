Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaJMCcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:32:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaJMCax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.17 22/25] USB: Add device quirk for ASUS T100 Base Station keyboard
Date: Mon, 13 Oct 2014 04:25:15 +0200
Message-Id: <20141013022455.233999089@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/core/hub.c     |    6 ++++--
 drivers/usb/core/quirks.c  |    4 ++++
 include/linux/usb/quirks.h |    3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1983,8 +1983,10 @@ void usb_set_device_state(struct usb_dev
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
@@ -159,6 +159,10 @@ static const struct usb_device_id usb_qu
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
@@ -41,4 +41,7 @@
  */
 #define USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL	0x00000080
 
+/* device generates spurious wakeup, ignore remote wakeup capability */
+#define USB_QUIRK_IGNORE_REMOTE_WAKEUP	0x00000200
+
 #endif /* __LINUX_USB_QUIRKS_H */


