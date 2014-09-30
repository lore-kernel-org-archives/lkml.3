Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaI3RSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:18:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbaI3RSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:50 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 08/13] HID: logitech: allow the DJ device to request the unifying name
Date: Tue, 30 Sep 2014 13:18:30 -0400
Message-Id: <1412097515-17241-9-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The names of the DJ devices are stored in the receiver. These names
can be retrieved through a HID++ command. However, the protocol says
that you have to ask the receiver for that, not the device iteself.

Introduce a special case in the DJ handling where a device can request
its unifying name, and when such a name is given, forward it also to
the corresponding device.

On the HID++ side, the receiver talks only HID++ 1.0, so we need to
implement this part of the protocol in the module.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-dj.c    | 24 ++++++++++--
 drivers/hid/hid-logitech-hidpp.c | 80 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 97 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index feddacd..9bc3942 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -667,6 +667,9 @@ static void logi_dj_ll_close(struct hid_device *hid)
 	dbg_hid("%s:%s\n", __func__, hid->phys);
 }
 
+static u8 unifying_name_query[]  = {0x10, 0xff, 0x83, 0xb5, 0x40, 0x00, 0x00};
+static u8 unifying_name_answer[] = {0x11, 0xff, 0x83, 0xb5};
+
 static int logi_dj_ll_raw_request(struct hid_device *hid,
 				  unsigned char reportnum, __u8 *buf,
 				  size_t count, unsigned char report_type,
@@ -682,7 +685,13 @@ static int logi_dj_ll_raw_request(struct hid_device *hid,
 		if (count < 2)
 			return -EINVAL;
 
-		buf[1] = djdev->device_index;
+		/* special case where we should not overwrite
+		 * the device_index */
+		if (count == 7 && !memcmp(buf, unifying_name_query,
+					  sizeof(unifying_name_query)))
+			buf[4] |= djdev->device_index - 1;
+		else
+			buf[1] = djdev->device_index;
 		return hid_hw_raw_request(djrcv_dev->hdev, reportnum, buf,
 				count, report_type, reqtype);
 	}
@@ -873,8 +882,17 @@ static int logi_dj_hidpp_event(struct hid_device *hdev,
 	unsigned long flags;
 	u8 device_index = dj_report->device_index;
 
-	if (device_index == HIDPP_RECEIVER_INDEX)
-		return false;
+	if (device_index == HIDPP_RECEIVER_INDEX) {
+		/* special case were the device wants to know its unifying
+		 * name */
+		if (size == HIDPP_REPORT_LONG_LENGTH &&
+		    !memcmp(data, unifying_name_answer,
+			    sizeof(unifying_name_answer)) &&
+		    ((data[4] & 0xF0) == 0x40))
+			device_index = (data[4] & 0x0F) + 1;
+		else
+			return false;
+	}
 
 	/*
 	 * Data is from the HID++ collection, in this case, we forward the
diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 48dec39..e748e45 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -205,6 +205,31 @@ static int hidpp_send_fap_command_sync(struct hidpp_device *hidpp,
 	return ret;
 }
 
+static int hidpp_send_rap_command_sync(struct hidpp_device *hidpp_dev,
+	u8 report_id, u8 sub_id, u8 reg_address, u8 *params, int param_count,
+	struct hidpp_report *response)
+{
+	struct hidpp_report *message = kzalloc(sizeof(struct hidpp_report),
+			GFP_KERNEL);
+	int ret;
+
+	if ((report_id != REPORT_ID_HIDPP_SHORT) &&
+	    (report_id != REPORT_ID_HIDPP_LONG))
+		return -EINVAL;
+
+	if (param_count > sizeof(message->rap.params))
+		return -EINVAL;
+
+	message->report_id = report_id;
+	message->rap.sub_id = sub_id;
+	message->rap.reg_address = reg_address;
+	memcpy(&message->rap.params, params, param_count);
+
+	ret = hidpp_send_message_sync(hidpp_dev, message, response);
+	kfree(message);
+	return ret;
+}
+
 static inline bool hidpp_match_answer(struct hidpp_report *question,
 		struct hidpp_report *answer)
 {
@@ -221,6 +246,45 @@ static inline bool hidpp_match_error(struct hidpp_report *question,
 }
 
 /* -------------------------------------------------------------------------- */
+/* HIDP++ 1.0 commands                                                        */
+/* -------------------------------------------------------------------------- */
+
+#define HIDPP_SET_REGISTER				0x80
+#define HIDPP_GET_REGISTER				0x81
+#define HIDPP_SET_LONG_REGISTER				0x82
+#define HIDPP_GET_LONG_REGISTER				0x83
+
+#define HIDPP_REG_PAIRING_INFORMATION			0xB5
+#define DEVICE_NAME					0x40
+
+static char *hidpp_get_unifying_name(struct hidpp_device *hidpp_dev)
+{
+	struct hidpp_report response;
+	int ret;
+	/* hid-logitech-dj is in charge of setting the right device index */
+	u8 params[1] = { DEVICE_NAME };
+	char *name;
+	int len;
+
+	ret = hidpp_send_rap_command_sync(hidpp_dev,
+					REPORT_ID_HIDPP_SHORT,
+					HIDPP_GET_LONG_REGISTER,
+					HIDPP_REG_PAIRING_INFORMATION,
+					params, 1, &response);
+	if (ret)
+		return NULL;
+
+	len = response.rap.params[1];
+
+	name = kzalloc(len + 1, GFP_KERNEL);
+	if (!name)
+		return NULL;
+
+	memcpy(name, &response.rap.params[2], len);
+	return name;
+}
+
+/* -------------------------------------------------------------------------- */
 /* 0x0000: Root                                                               */
 /* -------------------------------------------------------------------------- */
 
@@ -726,13 +790,21 @@ static int hidpp_raw_event(struct hid_device *hdev, struct hid_report *report,
 	return 0;
 }
 
-static void hidpp_overwrite_name(struct hid_device *hdev)
+static void hidpp_overwrite_name(struct hid_device *hdev, bool use_unifying)
 {
 	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
 	char *name;
 	u8 name_length;
 
-	name = hidpp_get_device_name(hidpp, &name_length);
+	if (use_unifying)
+		/*
+		 * the device is connected through an Unifying receiver, and
+		 * might not be already connected.
+		 * Ask the receiver for its name.
+		 */
+		name = hidpp_get_unifying_name(hidpp);
+	else
+		name = hidpp_get_device_name(hidpp, &name_length);
 
 	if (!name)
 		hid_err(hdev, "unable to retrieve the name of the device");
@@ -783,12 +855,12 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			goto hid_parse_fail;
 		}
 
-		/* the device is connected, we can ask for its name */
 		hid_info(hdev, "HID++ %u.%u device connected.\n",
 			 hidpp->protocol_major, hidpp->protocol_minor);
-		hidpp_overwrite_name(hdev);
 	}
 
+	hidpp_overwrite_name(hdev, id->group == HID_GROUP_LOGITECH_DJ_DEVICE);
+
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
 		ret = wtp_get_config(hidpp);
 		if (ret)
-- 
2.1.0

