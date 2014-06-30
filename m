Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbaF3VaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:30:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbaF3V0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:47 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 05/15] Input - wacom: compute the HID report size to get the actual packet size
Date: Mon, 30 Jun 2014 17:26:16 -0400
Message-Id: <1404163586-29582-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes an USB dependency and is more accurate: the computed pktlen
is the actual maximum size of the reports forwarded by the device.

Given that the pktlen is correctly computed/validated, we can store it now
in the features struct instead of having a special handling in the rest of
the code.

Likewise, this information is not mandatory anymore in the description
of devices in wacom_wac.c. They will be removed in a separate patch.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 58 ++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index cd3d936..3f1cee6 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -149,7 +149,6 @@ static int wacom_parse_logical_collection(unsigned char *report,
 	if (features->type == BAMBOO_PT) {
 
 		/* Logical collection is only used by 3rd gen Bamboo Touch */
-		features->pktlen = WACOM_PKGLEN_BBTOUCH3;
 		features->device_type = BTN_TOOL_FINGER;
 
 		features->x_max = features->y_max =
@@ -240,29 +239,6 @@ static int wacom_parse_hid(struct hid_device *hdev,
 					features->device_type = BTN_TOOL_FINGER;
 					/* touch device at least supports one touch point */
 					touch_max = 1;
-					switch (features->type) {
-					case TABLETPC2FG:
-						features->pktlen = WACOM_PKGLEN_TPC2FG;
-						break;
-
-					case MTSCREEN:
-					case WACOM_24HDT:
-						features->pktlen = WACOM_PKGLEN_MTOUCH;
-						break;
-
-					case MTTPC:
-					case MTTPC_B:
-						features->pktlen = WACOM_PKGLEN_MTTPC;
-						break;
-
-					case BAMBOO_PT:
-						features->pktlen = WACOM_PKGLEN_BBTOUCH;
-						break;
-
-					default:
-						features->pktlen = WACOM_PKGLEN_GRAPHIRE;
-						break;
-					}
 
 					switch (features->type) {
 					case BAMBOO_PT:
@@ -305,8 +281,6 @@ static int wacom_parse_hid(struct hid_device *hdev,
 					}
 				} else if (pen) {
 					/* penabled only accepts exact bytes of data */
-					if (features->type >= TABLETPC)
-						features->pktlen = WACOM_PKGLEN_GRAPHIRE;
 					features->device_type = BTN_TOOL_PEN;
 					features->x_max =
 						get_unaligned_le16(&report[i + 3]);
@@ -1227,12 +1201,34 @@ static void wacom_calculate_res(struct wacom_features *features)
 						    features->unitExpo);
 }
 
+static int wacom_hid_report_len(struct hid_report *report)
+{
+	/* equivalent to DIV_ROUND_UP(report->size, 8) + !!(report->id > 0) */
+	return ((report->size - 1) >> 3) + 1 + (report->id > 0);
+}
+
+static size_t wacom_compute_pktlen(struct hid_device *hdev)
+{
+	struct hid_report_enum *report_enum;
+	struct hid_report *report;
+	size_t size = 0;
+
+	report_enum = hdev->report_enum + HID_INPUT_REPORT;
+
+	list_for_each_entry(report, &report_enum->report_list, list) {
+		size_t report_size = wacom_hid_report_len(report);
+		if (report_size > size)
+			size = report_size;
+	}
+
+	return size;
+}
+
 static int wacom_probe(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
 	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
 	struct usb_device *dev = interface_to_usbdev(intf);
-	struct usb_endpoint_descriptor *endpoint;
 	struct wacom *wacom;
 	struct wacom_wac *wacom_wac;
 	struct wacom_features *features;
@@ -1258,6 +1254,7 @@ static int wacom_probe(struct hid_device *hdev,
 	wacom_wac = &wacom->wacom_wac;
 	wacom_wac->features = *((struct wacom_features *)id->driver_data);
 	features = &wacom_wac->features;
+	features->pktlen = wacom_compute_pktlen(hdev);
 	if (features->pktlen > WACOM_PKGLEN_MAX) {
 		error = -EINVAL;
 		goto fail1;
@@ -1275,8 +1272,6 @@ static int wacom_probe(struct hid_device *hdev,
 	usb_make_path(dev, wacom->phys, sizeof(wacom->phys));
 	strlcat(wacom->phys, "/input0", sizeof(wacom->phys));
 
-	endpoint = &intf->cur_altsetting->endpoint[0].desc;
-
 	/* set the default size in case we do not get them from hid */
 	wacom_set_default_phy(features);
 
@@ -1287,13 +1282,12 @@ static int wacom_probe(struct hid_device *hdev,
 
 	/*
 	 * Intuos5 has no useful data about its touch interface in its
-	 * HID descriptor. If this is the touch interface (wMaxPacketSize
+	 * HID descriptor. If this is the touch interface (PacketSize
 	 * of WACOM_PKGLEN_BBTOUCH3), override the table values.
 	 */
 	if (features->type >= INTUOS5S && features->type <= INTUOSHT) {
-		if (endpoint->wMaxPacketSize == WACOM_PKGLEN_BBTOUCH3) {
+		if (features->pktlen == WACOM_PKGLEN_BBTOUCH3) {
 			features->device_type = BTN_TOOL_FINGER;
-			features->pktlen = WACOM_PKGLEN_BBTOUCH3;
 
 			features->x_max = 4096;
 			features->y_max = 4096;
-- 
2.0.0

