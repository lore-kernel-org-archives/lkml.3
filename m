Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbaKMURI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:17:08 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40846 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbaKMURF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:17:05 -0500
From: Benson Leung <bleung@chromium.org>
To: johan@kernel.org, jkosina@suse.cz, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: snanda@chromium.org, Benson Leung <bleung@chromium.org>
Subject: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
Date: Thu, 13 Nov 2014 12:16:46 -0800
Message-Id: <1415909806-23848-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbhid->intf->needs_remote_wakeup is set when a device is
opened, and is cleared when a device is closed.

When a usbhid device that does not support remote wake
( i.e. !device_can_wakeup() ) is closed, we fail out of
autosuspend_check() because the autosuspend check is called
before the flag is cleared as a result of usb_kill_urb(usbhid->urbin);

The result is that a device that may otherwise autosuspend will
fail to enter suspend again after all handles to it are closed.

In usbhid_open, usb_autopm_get_interface is called
before setting the needs_remote_wakeup flag, and
usb_autopm_put_interface is called after hid_start_in.

However, when the device is closed in usbhid_close, the same
protection isn't there when clearing needs_remote_wakeup. This will
add that to usbhid_close as well as usbhid_stop.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/hid/usbhid/hid-core.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 04e34b9..2a0b91d 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -734,8 +734,15 @@ void usbhid_close(struct hid_device *hid)
 		spin_unlock_irq(&usbhid->lock);
 		hid_cancel_delayed_stuff(usbhid);
 		if (!(hid->quirks & HID_QUIRK_ALWAYS_POLL)) {
+			int autopm_error;
+
+			autopm_error = usb_autopm_get_interface(usbhid->intf);
+
 			usb_kill_urb(usbhid->urbin);
 			usbhid->intf->needs_remote_wakeup = 0;
+
+			if (!autopm_error)
+				usb_autopm_put_interface(usbhid->intf);
 		}
 	} else {
 		spin_unlock_irq(&usbhid->lock);
@@ -1179,9 +1186,17 @@ static void usbhid_stop(struct hid_device *hid)
 	if (WARN_ON(!usbhid))
 		return;
 
-	if (hid->quirks & HID_QUIRK_ALWAYS_POLL)
+	if (hid->quirks & HID_QUIRK_ALWAYS_POLL) {
+		int autopm_error;
+
+		autopm_error = usb_autopm_get_interface(usbhid->intf);
+
 		usbhid->intf->needs_remote_wakeup = 0;
 
+		if (!autopm_error)
+			usb_autopm_put_interface(usbhid->intf);
+	}
+
 	clear_bit(HID_STARTED, &usbhid->iofl);
 	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
-- 
2.1.0.rc2.206.gedb03e5

