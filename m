Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbaCEVUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:20:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbaCEVTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:19:07 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, Antonio Ospite <ao2@ao2.it>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] HID: sony: do not rely on hid_output_raw_report
Date: Wed,  5 Mar 2014 16:18:53 -0500
Message-Id: <1394054334-20438-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1394054334-20438-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1394054334-20438-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid_out_raw_report is going to be obsoleted as it is not part of the
unified HID low level transport documentation
(Documentation/hid/hid-transport.txt)

To do so, we need to introduce two new quirks:
* HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP: this quirks prevents the
  transport driver to use the interrupt channel to send output report
  (and thus force to use HID_REQ_SET_REPORT command)
* HID_QUIRK_SKIP_OUTPUT_REPORT_ID: this one forces usbhid to not
  include the report ID in the buffer it sends to the device through
  HID_REQ_SET_REPORT in case of an output report

This also fixes a regression introduced in commit 3a75b24949a8
(HID: hidraw: replace hid_output_raw_report() calls by appropriates ones).
The hidraw API was not able to communicate with the PS3 SixAxis
controllers in USB mode.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

changes since v1:
- removed usb.h include
- renamed HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP
- fix typo

 drivers/hid/hid-sony.c        | 60 ++++++++++---------------------------------
 drivers/hid/hidraw.c          |  3 ++-
 drivers/hid/usbhid/hid-core.c |  7 ++++-
 include/linux/hid.h           |  2 ++
 4 files changed, 24 insertions(+), 48 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index b5fe65e..4884bb5 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -29,7 +29,6 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 #include <linux/leds.h>
 #include <linux/power_supply.h>
 #include <linux/spinlock.h>
@@ -1007,45 +1006,6 @@ static int sony_mapping(struct hid_device *hdev, struct hid_input *hi,
 }
 
 /*
- * The Sony Sixaxis does not handle HID Output Reports on the Interrupt EP
- * like it should according to usbhid/hid-core.c::usbhid_output_raw_report()
- * so we need to override that forcing HID Output Reports on the Control EP.
- *
- * There is also another issue about HID Output Reports via USB, the Sixaxis
- * does not want the report_id as part of the data packet, so we have to
- * discard buf[0] when sending the actual control message, even for numbered
- * reports, humpf!
- */
-static int sixaxis_usb_output_raw_report(struct hid_device *hid, __u8 *buf,
-		size_t count, unsigned char report_type)
-{
-	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
-	struct usb_device *dev = interface_to_usbdev(intf);
-	struct usb_host_interface *interface = intf->cur_altsetting;
-	int report_id = buf[0];
-	int ret;
-
-	if (report_type == HID_OUTPUT_REPORT) {
-		/* Don't send the Report ID */
-		buf++;
-		count--;
-	}
-
-	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-		HID_REQ_SET_REPORT,
-		USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		((report_type + 1) << 8) | report_id,
-		interface->desc.bInterfaceNumber, buf, count,
-		USB_CTRL_SET_TIMEOUT);
-
-	/* Count also the Report ID, in case of an Output report. */
-	if (ret > 0 && report_type == HID_OUTPUT_REPORT)
-		ret++;
-
-	return ret;
-}
-
-/*
  * Sending HID_REQ_GET_REPORT changes the operation mode of the ps3 controller
  * to "operational".  Without this, the ps3 controller will not report any
  * events.
@@ -1305,11 +1265,8 @@ static void sixaxis_state_worker(struct work_struct *work)
 	buf[10] |= sc->led_state[2] << 3;
 	buf[10] |= sc->led_state[3] << 4;
 
-	if (sc->quirks & SIXAXIS_CONTROLLER_USB)
-		hid_output_raw_report(sc->hdev, buf, sizeof(buf), HID_OUTPUT_REPORT);
-	else
-		hid_hw_raw_request(sc->hdev, 0x01, buf, sizeof(buf),
-				HID_OUTPUT_REPORT, HID_REQ_SET_REPORT);
+	hid_hw_raw_request(sc->hdev, 0x01, buf, sizeof(buf), HID_OUTPUT_REPORT,
+			HID_REQ_SET_REPORT);
 }
 
 static void dualshock4_state_worker(struct work_struct *work)
@@ -1659,7 +1616,18 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	if (sc->quirks & SIXAXIS_CONTROLLER_USB) {
-		hdev->hid_output_raw_report = sixaxis_usb_output_raw_report;
+		/*
+		 * The Sony Sixaxis does not handle HID Output Reports on the
+		 * Interrupt EP like it could, so we need to force HID Output
+		 * Reports to use HID_REQ_SET_REPORT on the Control EP.
+		 *
+		 * There is also another issue about HID Output Reports via USB,
+		 * the Sixaxis does not want the report_id as part of the data
+		 * packet, so we have to discard buf[0] when sending the actual
+		 * control message, even for numbered reports, humpf!
+		 */
+		hdev->quirks |= HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP;
+		hdev->quirks |= HID_QUIRK_SKIP_OUTPUT_REPORT_ID;
 		ret = sixaxis_set_operational_usb(hdev);
 		sc->worker_initialized = 1;
 		INIT_WORK(&sc->state_worker, sixaxis_state_worker);
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 2cc484c..ffa648c 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -149,7 +149,8 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
 		goto out_free;
 	}
 
-	if (report_type == HID_OUTPUT_REPORT) {
+	if ((report_type == HID_OUTPUT_REPORT) &&
+	    !(dev->quirks & HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP)) {
 		ret = hid_hw_output_report(dev, buf, count);
 		/*
 		 * compatibility with old implementation of USB-HID and I2C-HID:
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 0d1d875..3bc7cad 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -894,7 +894,12 @@ static int usbhid_set_raw_report(struct hid_device *hid, unsigned int reportnum,
 	int ret, skipped_report_id = 0;
 
 	/* Byte 0 is the report number. Report data starts at byte 1.*/
-	buf[0] = reportnum;
+	if ((rtype == HID_OUTPUT_REPORT) &&
+	    (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORT_ID))
+		buf[0] = 0;
+	else
+		buf[0] = reportnum;
+
 	if (buf[0] == 0x0) {
 		/* Don't send the Report ID */
 		buf++;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index e224516..2cd7174 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -290,6 +290,8 @@ struct hid_item {
 #define HID_QUIRK_NO_EMPTY_INPUT		0x00000100
 #define HID_QUIRK_NO_INIT_INPUT_REPORTS		0x00000200
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
+#define HID_QUIRK_SKIP_OUTPUT_REPORT_ID		0x00020000
+#define HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP	0x00040000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
 #define HID_QUIRK_NO_IGNORE			0x40000000
-- 
1.8.5.3

