Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaKYKmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaKYKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 137/254] HID: usbhid: add always-poll quirk
Date: Tue, 25 Nov 2014 10:38:07 +0000
Message-Id: <1416912004-5928-138-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 0b750b3baa2d64f1b77aecc10f20deeb28efe60d upstream.

Add quirk to make sure that a device is always polled for input events
even if it hasn't been opened.

This is needed for devices that disconnects from the bus unless the
interrupt endpoint has been polled at least once or when not responding
to an input event (e.g. after having shut down X).

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/usbhid/hid-core.c | 26 +++++++++++++++++++++++---
 include/linux/hid.h           |  1 +
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 7b88f4cb9902..d8b69764d5a9 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -82,7 +82,7 @@ static int hid_start_in(struct hid_device *hid)
 	struct usbhid_device *usbhid = hid->driver_data;
 
 	spin_lock_irqsave(&usbhid->lock, flags);
-	if (hid->open > 0 &&
+	if ((hid->open > 0 || hid->quirks & HID_QUIRK_ALWAYS_POLL) &&
 			!test_bit(HID_DISCONNECTED, &usbhid->iofl) &&
 			!test_bit(HID_SUSPENDED, &usbhid->iofl) &&
 			!test_and_set_bit(HID_IN_RUNNING, &usbhid->iofl)) {
@@ -292,6 +292,8 @@ static void hid_irq_in(struct urb *urb)
 	case 0:			/* success */
 		usbhid_mark_busy(usbhid);
 		usbhid->retry_delay = 0;
+		if ((hid->quirks & HID_QUIRK_ALWAYS_POLL) && !hid->open)
+			break;
 		hid_input_report(urb->context, HID_INPUT_REPORT,
 				 urb->transfer_buffer,
 				 urb->actual_length, 1);
@@ -734,8 +736,10 @@ void usbhid_close(struct hid_device *hid)
 	if (!--hid->open) {
 		spin_unlock_irq(&usbhid->lock);
 		hid_cancel_delayed_stuff(usbhid);
-		usb_kill_urb(usbhid->urbin);
-		usbhid->intf->needs_remote_wakeup = 0;
+		if (!(hid->quirks & HID_QUIRK_ALWAYS_POLL)) {
+			usb_kill_urb(usbhid->urbin);
+			usbhid->intf->needs_remote_wakeup = 0;
+		}
 	} else {
 		spin_unlock_irq(&usbhid->lock);
 	}
@@ -1133,6 +1137,19 @@ static int usbhid_start(struct hid_device *hid)
 
 	set_bit(HID_STARTED, &usbhid->iofl);
 
+	if (hid->quirks & HID_QUIRK_ALWAYS_POLL) {
+		ret = usb_autopm_get_interface(usbhid->intf);
+		if (ret)
+			goto fail;
+		usbhid->intf->needs_remote_wakeup = 1;
+		ret = hid_start_in(hid);
+		if (ret) {
+			dev_err(&hid->dev,
+				"failed to start in urb: %d\n", ret);
+		}
+		usb_autopm_put_interface(usbhid->intf);
+	}
+
 	/* Some keyboards don't work until their LEDs have been set.
 	 * Since BIOSes do set the LEDs, it must be safe for any device
 	 * that supports the keyboard boot protocol.
@@ -1165,6 +1182,9 @@ static void usbhid_stop(struct hid_device *hid)
 	if (WARN_ON(!usbhid))
 		return;
 
+	if (hid->quirks & HID_QUIRK_ALWAYS_POLL)
+		usbhid->intf->needs_remote_wakeup = 0;
+
 	clear_bit(HID_STARTED, &usbhid->iofl);
 	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 77632cf159c0..05eb71003b52 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -286,6 +286,7 @@ struct hid_item {
 #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
 #define HID_QUIRK_NO_EMPTY_INPUT		0x00000100
 #define HID_QUIRK_NO_INIT_INPUT_REPORTS		0x00000200
+#define HID_QUIRK_ALWAYS_POLL			0x00000400
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_SKIP_OUTPUT_REPORT_ID		0x00020000
 #define HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP	0x00040000
-- 
2.1.0

