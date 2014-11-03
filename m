Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaKCTvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:51:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbaKCTvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:51:03 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] HID: logitech-hidpp: fix negated returns
Date: Mon,  3 Nov 2014 14:50:52 -0500
Message-Id: <1415044253-18734-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by Dan Carpenter:

drivers/hid/hid-logitech-hidpp.c:359 hidpp_root_get_protocol_version() warn: should this return really be negated?
drivers/hid/hid-logitech-hidpp.c:398 hidpp_devicenametype_get_count() warn: should this return really be negated?
drivers/hid/hid-logitech-hidpp.c:417 hidpp_devicenametype_get_device_name() warn: should this return really be negated?
drivers/hid/hid-logitech-hidpp.c:524 hidpp_touchpad_get_raw_info() warn: should this return really be negated?

The problem lies in hidpp_send_message_sync() which can return 2 types of
errors depending of their sign. Adding a comment there to clarify what is
happening.

To solve that, print an error in case of a protocol problem, and raise
-EPROTO instead.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-hidpp.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 8d2d54b..4793d4b 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -151,6 +151,14 @@ static int __hidpp_send_report(struct hid_device *hdev,
 	return ret == fields_count ? 0 : -1;
 }
 
+/**
+ * hidpp_send_message_sync() returns 0 in case of success, and something else
+ * in case of a failure.
+ * - If ' something else' is positive, that means that an error has been raised
+ *   by the protocol itself.
+ * - If ' something else' is negative, that means that we had a classic error
+ *   (-ENOMEM, -EPIPE, etc...)
+ */
 static int hidpp_send_message_sync(struct hidpp_device *hidpp,
 	struct hidpp_report *message,
 	struct hidpp_report *response)
@@ -359,8 +367,11 @@ static int hidpp_root_get_protocol_version(struct hidpp_device *hidpp)
 		return 0;
 	}
 
-	if (ret)
-		return -ret;
+	if (ret > 0) {
+		hid_err(hidpp->hid_dev, "%s: received protocol error 0x%02x\n",
+			__func__, ret);
+		return -EPROTO;
+	}
 
 	hidpp->protocol_major = response.fap.params[0];
 	hidpp->protocol_minor = response.fap.params[1];
@@ -398,8 +409,11 @@ static int hidpp_devicenametype_get_count(struct hidpp_device *hidpp,
 	ret = hidpp_send_fap_command_sync(hidpp, feature_index,
 		CMD_GET_DEVICE_NAME_TYPE_GET_COUNT, NULL, 0, &response);
 
-	if (ret)
-		return -ret;
+	if (ret > 0) {
+		hid_err(hidpp->hid_dev, "%s: received protocol error 0x%02x\n",
+			__func__, ret);
+		return -EPROTO;
+	}
 
 	*nameLength = response.fap.params[0];
 
@@ -417,8 +431,11 @@ static int hidpp_devicenametype_get_device_name(struct hidpp_device *hidpp,
 		CMD_GET_DEVICE_NAME_TYPE_GET_DEVICE_NAME, &char_index, 1,
 		&response);
 
-	if (ret)
-		return -ret;
+	if (ret > 0) {
+		hid_err(hidpp->hid_dev, "%s: received protocol error 0x%02x\n",
+			__func__, ret);
+		return -EPROTO;
+	}
 
 	if (response.report_id == REPORT_ID_HIDPP_LONG)
 		count = HIDPP_REPORT_LONG_LENGTH - 4;
@@ -524,8 +541,11 @@ static int hidpp_touchpad_get_raw_info(struct hidpp_device *hidpp,
 	ret = hidpp_send_fap_command_sync(hidpp, feature_index,
 		CMD_TOUCHPAD_GET_RAW_INFO, NULL, 0, &response);
 
-	if (ret)
-		return -ret;
+	if (ret > 0) {
+		hid_err(hidpp->hid_dev, "%s: received protocol error 0x%02x\n",
+			__func__, ret);
+		return -EPROTO;
+	}
 
 	raw_info->x_size = get_unaligned_be16(&params[0]);
 	raw_info->y_size = get_unaligned_be16(&params[2]);
-- 
2.1.0

