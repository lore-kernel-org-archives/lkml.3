Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaI3S2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaI3S2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:28:33 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Hans de Goede <hdegoede@redhat.com>
Cc: Bastien Nocera <hadess@hadess.net>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH] HID: usbhid: prevent unwanted events to be sent when re-opening the device
Date: Tue, 30 Sep 2014 14:28:22 -0400
Message-Id: <1412101702-2752-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When events occurs while no one is listening to the node (hid->open == 0
and usb_kill_urb() called) some events are still stacked somewhere in
the USB (kernel or device?) stack. When the node gets reopened, these
events are drained, and this results in spurious touch down/up, or mouse
button clicks.

The problem was spotted with touchscreens in fdo bug #81781 [1], but it
actually occurs with any mouse using hid-generic or touchscreen.

A way to reproduce it is to call:

$ xinput disable 9 ; sleep 5 ; xinput enable 9

With 9 being the device ID for the touchscreen/mouse. During the "sleep",
produce some touch events or click events. When "xinput enable" is called,
at least one click is generated.

This patch tries to fix this by draining the queue for 50 msec and
during this time frame, not forwarding these old events to the hid layer.

Hans completed the explanation:
"""
Devices like mice (basically any hid device) will have a fifo
on the device side, when we stop submitting urbs to get hid reports from
it, that fifo will fill up, and when we resume we will get whatever
is there in that fifo.
"""

[1] https://bugs.freedesktop.org/show_bug.cgi?id=81781

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

OK, I know this is uggly, but I could not find a better way :(

Cheers,
Benjamin

 drivers/hid/usbhid/hid-core.c | 36 ++++++++++++++++++++++++------------
 drivers/hid/usbhid/usbhid.h   |  1 +
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index ca6849a..04e34b9 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -278,18 +278,20 @@ static void hid_irq_in(struct urb *urb)
 		usbhid->retry_delay = 0;
 		if ((hid->quirks & HID_QUIRK_ALWAYS_POLL) && !hid->open)
 			break;
-		hid_input_report(urb->context, HID_INPUT_REPORT,
-				 urb->transfer_buffer,
-				 urb->actual_length, 1);
-		/*
-		 * autosuspend refused while keys are pressed
-		 * because most keyboards don't wake up when
-		 * a key is released
-		 */
-		if (hid_check_keys_pressed(hid))
-			set_bit(HID_KEYS_PRESSED, &usbhid->iofl);
-		else
-			clear_bit(HID_KEYS_PRESSED, &usbhid->iofl);
+		if (!test_bit(HID_RESUME_RUNNING, &usbhid->iofl)) {
+			hid_input_report(urb->context, HID_INPUT_REPORT,
+					 urb->transfer_buffer,
+					 urb->actual_length, 1);
+			/*
+			 * autosuspend refused while keys are pressed
+			 * because most keyboards don't wake up when
+			 * a key is released
+			 */
+			if (hid_check_keys_pressed(hid))
+				set_bit(HID_KEYS_PRESSED, &usbhid->iofl);
+			else
+				clear_bit(HID_KEYS_PRESSED, &usbhid->iofl);
+		}
 		break;
 	case -EPIPE:		/* stall */
 		usbhid_mark_busy(usbhid);
@@ -688,6 +690,7 @@ int usbhid_open(struct hid_device *hid)
 			goto done;
 		}
 		usbhid->intf->needs_remote_wakeup = 1;
+		set_bit(HID_RESUME_RUNNING, &usbhid->iofl);
 		res = hid_start_in(hid);
 		if (res) {
 			if (res != -ENOSPC) {
@@ -701,6 +704,15 @@ int usbhid_open(struct hid_device *hid)
 			}
 		}
 		usb_autopm_put_interface(usbhid->intf);
+
+		/*
+		 * In case events are generated while nobody was listening,
+		 * some are released when the device is re-opened.
+		 * Wait 50 msec for the queue to empty before allowing events
+		 * to go through hid.
+		 */
+		msleep(50);
+		clear_bit(HID_RESUME_RUNNING, &usbhid->iofl);
 	}
 done:
 	mutex_unlock(&hid_open_mut);
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index f633c24..807922b 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -52,6 +52,7 @@ struct usb_interface *usbhid_find_interface(int minor);
 #define HID_STARTED		8
 #define HID_KEYS_PRESSED	10
 #define HID_NO_BANDWIDTH	11
+#define HID_RESUME_RUNNING	12
 
 /*
  * USB-specific HID struct, to be pointed to
-- 
2.1.0

