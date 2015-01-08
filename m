Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbbAHWxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:53:45 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:25579 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754706AbbAHWxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:53:43 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 08 Jan 2015 15:21:11 -0800
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH v2 2/3] HID: rmi: Support touchpads with external buttons
Date: Thu, 8 Jan 2015 14:51:34 -0800
Message-ID: <1420757496-3955-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.4.10.98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The external buttons on HID touchpads are connected as pass through devices and
button events are not reported in the rmi registers. As a result on these
devices we need to allow the HID generic desktop button events to be processed
by hid-input. Unfortunately, there is no way to query the touchpad to determine
that it has pass through buttons so the RMI_DEVICE_HAS_PHYS_BUTTONS should be
set manually when adding the device to rmi_id[].

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
Here is the second version of the remaining patches in this patch series from
last month. The most significant changes are setting the HAS_PHYS_BUTTONS flags
in driver_data and avoiding reset being called with every button press.

 drivers/hid/hid-rmi.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 018f80f..290f8f7 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -35,6 +35,7 @@
 
 /* device flags */
 #define RMI_DEVICE			BIT(0)
+#define RMI_DEVICE_HAS_PHYS_BUTTONS	BIT(1)
 
 enum rmi_mode_type {
 	RMI_MODE_OFF			= 0,
@@ -472,6 +473,15 @@ static int rmi_event(struct hid_device *hdev, struct hid_field *field,
 	if ((data->device_flags & RMI_DEVICE) &&
 	    (field->application == HID_GD_POINTER ||
 	    field->application == HID_GD_MOUSE)) {
+		if (data->device_flags & RMI_DEVICE_HAS_PHYS_BUTTONS) {
+			if ((usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON)
+				return 0;
+
+			if ((usage->hid == HID_GD_X || usage->hid == HID_GD_Y)
+			    && !value)
+				return 1;
+		}
+
 		rmi_schedule_reset(hdev);
 		return 1;
 	}
@@ -942,8 +952,13 @@ static int rmi_input_mapping(struct hid_device *hdev,
 	 * we want to make HID ignore the advertised HID collection
 	 * for RMI deivces
 	 */
-	if (data->device_flags & RMI_DEVICE)
+	if (data->device_flags & RMI_DEVICE) {
+		if ((data->device_flags & RMI_DEVICE_HAS_PHYS_BUTTONS) &&
+		    ((usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON))
+			return 0;
+
 		return -1;
+	}
 
 	return 0;
 }
@@ -991,6 +1006,9 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return ret;
 	}
 
+	if (id->driver_data)
+		data->device_flags = id->driver_data;
+
 	/*
 	 * Check for the RMI specific report ids. If they are misisng
 	 * simply return and let the events be processed by hid-input
-- 
2.1.0

