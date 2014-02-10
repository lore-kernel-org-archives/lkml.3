Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaBJSB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:01:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaBJR7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:13 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] HID: sony: remove hid_output_raw_report calls
Date: Mon, 10 Feb 2014 12:58:56 -0500
Message-Id: <1392055139-19631-12-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can not directly change the underlying struct hid_ll_driver here
as we did for hdev->hid_output_raw_report.
So allocate a struct ll_driver, and replace the old one when removing
the device.
To get a fully functional driver, we must also split the function
sixaxis_usb_output_raw_report() in 2, one regarding output_report, and
the other for raw_request.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-sony.c | 75 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 23 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index d980943..dbbcd0c8 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -507,6 +507,8 @@ struct sony_sc {
 	struct work_struct state_worker;
 	struct power_supply battery;
 
+	struct hid_ll_driver *prev_ll_driver;
+
 #ifdef CONFIG_SONY_FF
 	__u8 left;
 	__u8 right;
@@ -760,38 +762,52 @@ static int sony_mapping(struct hid_device *hdev, struct hid_input *hi,
 
 /*
  * The Sony Sixaxis does not handle HID Output Reports on the Interrupt EP
- * like it should according to usbhid/hid-core.c::usbhid_output_raw_report()
+ * like it should according to usbhid/hid-core.c::usbhid_output_report()
  * so we need to override that forcing HID Output Reports on the Control EP.
- *
- * There is also another issue about HID Output Reports via USB, the Sixaxis
- * does not want the report_id as part of the data packet, so we have to
- * discard buf[0] when sending the actual control message, even for numbered
- * reports, humpf!
  */
-static int sixaxis_usb_output_raw_report(struct hid_device *hid, __u8 *buf,
-		size_t count, unsigned char report_type)
+static int sixaxis_usb_output_report(struct hid_device *hid, __u8 *buf,
+		size_t count)
+{
+	return hid_hw_raw_request(hid, buf[0], buf, count, HID_OUTPUT_REPORT,
+		HID_REQ_SET_REPORT);
+}
+
+/*
+ * There is also another issue about the SET_REPORT command via USB,
+ * the Sixaxis does not want the report_id as part of the data packet, so
+ * we have to discard buf[0] when sending the actual control message, even
+ * for numbered reports, humpf!
+ */
+static int sixaxis_usb_raw_request(struct hid_device *hid,
+				   unsigned char reportnum, __u8 *buf,
+				   size_t len, unsigned char rtype, int reqtype)
 {
 	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct usb_host_interface *interface = intf->cur_altsetting;
-	int report_id = buf[0];
 	int ret;
+	u8 usb_dir;
+	unsigned int usb_pipe;
 
-	if (report_type == HID_OUTPUT_REPORT) {
+	if (reqtype == HID_REQ_SET_REPORT) {
 		/* Don't send the Report ID */
 		buf++;
-		count--;
+		len--;
+		usb_dir = USB_DIR_OUT;
+		usb_pipe = usb_sndctrlpipe(dev, 0);
+	} else {
+		usb_dir = USB_DIR_IN;
+		usb_pipe = usb_rcvctrlpipe(dev, 0);
 	}
 
-	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-		HID_REQ_SET_REPORT,
-		USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		((report_type + 1) << 8) | report_id,
-		interface->desc.bInterfaceNumber, buf, count,
+	ret = usb_control_msg(dev, usb_pipe, reqtype,
+		usb_dir | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+		((rtype + 1) << 8) | reportnum,
+		interface->desc.bInterfaceNumber, buf, len,
 		USB_CTRL_SET_TIMEOUT);
 
-	/* Count also the Report ID, in case of an Output report. */
-	if (ret > 0 && report_type == HID_OUTPUT_REPORT)
+	/* Count also the Report ID. */
+	if (ret > 0 && reqtype == HID_REQ_SET_REPORT)
 		ret++;
 
 	return ret;
@@ -1047,7 +1063,7 @@ static void sixaxis_state_worker(struct work_struct *work)
 	buf[10] |= sc->led_state[2] << 3;
 	buf[10] |= sc->led_state[3] << 4;
 
-	hid_output_raw_report(sc->hdev, buf, sizeof(buf), HID_OUTPUT_REPORT);
+	hid_hw_output_report(sc->hdev, buf, sizeof(buf));
 }
 
 static void dualshock4_state_worker(struct work_struct *work)
@@ -1254,6 +1270,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	unsigned long quirks = id->driver_data;
 	struct sony_sc *sc;
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
+	struct hid_ll_driver *ll_driver;
 
 	sc = devm_kzalloc(&hdev->dev, sizeof(*sc), GFP_KERNEL);
 	if (sc == NULL) {
@@ -1285,13 +1302,20 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	if (sc->quirks & SIXAXIS_CONTROLLER_USB) {
-		hdev->hid_output_raw_report = sixaxis_usb_output_raw_report;
+		ll_driver = devm_kzalloc(&hdev->dev, sizeof(*ll_driver),
+					     GFP_KERNEL);
+		if (ll_driver == NULL)
+			return -ENOMEM;
+		sc->prev_ll_driver = hdev->ll_driver;
+		*ll_driver = *hdev->ll_driver;
+		hdev->ll_driver = ll_driver;
+		ll_driver->output_report = sixaxis_usb_output_report;
+		ll_driver->raw_request = sixaxis_usb_raw_request;
 		ret = sixaxis_set_operational_usb(hdev);
 		INIT_WORK(&sc->state_worker, sixaxis_state_worker);
-	}
-	else if (sc->quirks & SIXAXIS_CONTROLLER_BT)
+	} else if (sc->quirks & SIXAXIS_CONTROLLER_BT) {
 		ret = sixaxis_set_operational_bt(hdev);
-	else if (sc->quirks & DUALSHOCK4_CONTROLLER_USB) {
+	} else if (sc->quirks & DUALSHOCK4_CONTROLLER_USB) {
 		/* Report 5 (31 bytes) is used to send data to the controller via USB */
 		ret = sony_set_output_report(sc, 0x05, 248);
 		if (ret < 0)
@@ -1339,6 +1363,8 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 err_close:
 	hid_hw_close(hdev);
 err_stop:
+	if (sc->prev_ll_driver)
+		hdev->ll_driver = sc->prev_ll_driver;
 	if (sc->quirks & SONY_LED_SUPPORT)
 		sony_leds_remove(hdev);
 	if (sc->quirks & SONY_BATTERY_SUPPORT)
@@ -1351,6 +1377,9 @@ static void sony_remove(struct hid_device *hdev)
 {
 	struct sony_sc *sc = hid_get_drvdata(hdev);
 
+	if (sc->prev_ll_driver)
+		hdev->ll_driver = sc->prev_ll_driver;
+
 	if (sc->quirks & SONY_LED_SUPPORT)
 		sony_leds_remove(hdev);
 
-- 
1.8.3.1

