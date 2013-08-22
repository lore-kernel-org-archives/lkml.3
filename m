Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3HVMwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:52:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab3HVMvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:51:36 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] HID: do not init input reports for Win 8 multitouch devices
Date: Thu, 22 Aug 2013 14:51:09 +0200
Message-Id: <1377175869-5336-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1377175869-5336-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1377175869-5336-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some multitouch screens do not like to be polled for input reports.
However, the Win8 spec says that all touches should be sent during
each report, making the initialization of reports unnecessary.
The Win7 spec is less precise, so do not use this for those devices.

Add the quirk HID_QUIRK_NO_INIT_INPUT_REPORTS so that we do not have to
introduce a quirk for each problematic device. This quirk makes the driver
behave the same way the Win 8 does. It actually retrieves the features,
but not the inputs.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

no changes in v3
no changes in v2

 drivers/hid/hid-multitouch.c  | 12 ++++++++++++
 drivers/hid/usbhid/hid-core.c | 11 ++++++++---
 include/linux/hid.h           |  1 +
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c28ef86..ac28f08 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -951,6 +951,18 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	hdev->quirks |= HID_QUIRK_MULTI_INPUT;
 	hdev->quirks |= HID_QUIRK_NO_EMPTY_INPUT;
 
+	/*
+	 * Handle special quirks for Windows 8 certified devices.
+	 */
+	if (id->group == HID_GROUP_MULTITOUCH_WIN_8)
+		/*
+		 * Some multitouch screens do not like to be polled for input
+		 * reports. Fortunately, the Win8 spec says that all touches
+		 * should be sent during each report, making the initialization
+		 * of input reports unnecessary.
+		 */
+		hdev->quirks |= HID_QUIRK_NO_INIT_INPUT_REPORTS;
+
 	td = devm_kzalloc(&hdev->dev, sizeof(struct mt_device), GFP_KERNEL);
 	if (!td) {
 		dev_err(&hdev->dev, "cannot allocate multitouch data\n");
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index bd38cdf..44df131 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -750,12 +750,17 @@ void usbhid_init_reports(struct hid_device *hid)
 {
 	struct hid_report *report;
 	struct usbhid_device *usbhid = hid->driver_data;
+	struct hid_report_enum *report_enum;
 	int err, ret;
 
-	list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].report_list, list)
-		usbhid_submit_report(hid, report, USB_DIR_IN);
+	if (!(hid->quirks & HID_QUIRK_NO_INIT_INPUT_REPORTS)) {
+		report_enum = &hid->report_enum[HID_INPUT_REPORT];
+		list_for_each_entry(report, &report_enum->report_list, list)
+			usbhid_submit_report(hid, report, USB_DIR_IN);
+	}
 
-	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
+	report_enum = &hid->report_enum[HID_FEATURE_REPORT];
+	list_for_each_entry(report, &report_enum->report_list, list)
 		usbhid_submit_report(hid, report, USB_DIR_IN);
 
 	err = 0;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 24f1197..d421848 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -283,6 +283,7 @@ struct hid_item {
 #define HID_QUIRK_MULTI_INPUT			0x00000040
 #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
 #define HID_QUIRK_NO_EMPTY_INPUT		0x00000100
+#define HID_QUIRK_NO_INIT_INPUT_REPORTS		0x00000200
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
-- 
1.8.3.1

