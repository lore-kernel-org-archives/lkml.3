Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaKROKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:10:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbaKROKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 163/206] HID: usbhid: add always-poll quirk
Date: Tue, 18 Nov 2014 15:08:38 +0100
Message-Id: <972b69a50ed38071d5340999089046a9ec04b0e8.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0b750b3baa2d64f1b77aecc10f20deeb28efe60d upstream.

Add quirk to make sure that a device is always polled for input events
even if it hasn't been opened.

This is needed for devices that disconnects from the bus unless the
interrupt endpoint has been polled at least once or when not responding
to an input event (e.g. after having shut down X).

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/usbhid/hid-core.c | 26 +++++++++++++++++++++++---
 include/linux/hid.h           |  1 +
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 63a2bb96e5cd..bcc3193d297c 100644
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
@@ -735,8 +737,10 @@ void usbhid_close(struct hid_device *hid)
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
@@ -1120,6 +1124,19 @@ static int usbhid_start(struct hid_device *hid)
 
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
@@ -1152,6 +1169,9 @@ static void usbhid_stop(struct hid_device *hid)
 	if (WARN_ON(!usbhid))
 		return;
 
+	if (hid->quirks & HID_QUIRK_ALWAYS_POLL)
+		usbhid->intf->needs_remote_wakeup = 0;
+
 	clear_bit(HID_STARTED, &usbhid->iofl);
 	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 31b9d299ef6c..00c88fccd162 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -286,6 +286,7 @@ struct hid_item {
 #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
 #define HID_QUIRK_NO_EMPTY_INPUT		0x00000100
 #define HID_QUIRK_NO_INIT_INPUT_REPORTS		0x00000200
+#define HID_QUIRK_ALWAYS_POLL			0x00000400
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
-- 
2.1.3

