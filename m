Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbaGOSqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:46:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900AbaGOSpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:45:55 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 05/23] Input - wacom: split out the pad device for Bamboos
Date: Tue, 15 Jul 2014 14:45:28 -0400
Message-Id: <1405449946-11515-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We rely on the return code of wacom_bpt*() to do the input_sync().
wacom_wac_irq() then properly sync the input devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Ping Cheng <pingc@wacom.com>
Reviewed-by: Jason Gerecke <killertofu@gmail.com>
---

no changes in v2

 drivers/input/tablet/wacom_wac.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 0be2c73..4a40381 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1143,6 +1143,7 @@ static int wacom_bpt_touch(struct wacom_wac *wacom)
 {
 	struct wacom_features *features = &wacom->features;
 	struct input_dev *input = wacom->input;
+	struct input_dev *pad_input = wacom->pad_input;
 	unsigned char *data = wacom->data;
 	int i;
 
@@ -1177,14 +1178,12 @@ static int wacom_bpt_touch(struct wacom_wac *wacom)
 
 	input_mt_report_pointer_emulation(input, true);
 
-	input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
-	input_report_key(input, BTN_FORWARD, (data[1] & 0x04) != 0);
-	input_report_key(input, BTN_BACK, (data[1] & 0x02) != 0);
-	input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
-
-	input_sync(input);
+	input_report_key(pad_input, BTN_LEFT, (data[1] & 0x08) != 0);
+	input_report_key(pad_input, BTN_FORWARD, (data[1] & 0x04) != 0);
+	input_report_key(pad_input, BTN_BACK, (data[1] & 0x02) != 0);
+	input_report_key(pad_input, BTN_RIGHT, (data[1] & 0x01) != 0);
 
-	return 0;
+	return 1;
 }
 
 static void wacom_bpt3_touch_msg(struct wacom_wac *wacom, unsigned char *data)
@@ -1232,7 +1231,7 @@ static void wacom_bpt3_touch_msg(struct wacom_wac *wacom, unsigned char *data)
 
 static void wacom_bpt3_button_msg(struct wacom_wac *wacom, unsigned char *data)
 {
-	struct input_dev *input = wacom->input;
+	struct input_dev *input = wacom->pad_input;
 	struct wacom_features *features = &wacom->features;
 
 	if (features->type == INTUOSHT) {
@@ -1269,9 +1268,7 @@ static int wacom_bpt3_touch(struct wacom_wac *wacom)
 	}
 	input_mt_report_pointer_emulation(input, true);
 
-	input_sync(input);
-
-	return 0;
+	return 1;
 }
 
 static int wacom_bpt_pen(struct wacom_wac *wacom)
@@ -1800,11 +1797,6 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 
 		if (features->device_type == BTN_TOOL_FINGER) {
 
-			__set_bit(BTN_LEFT, input_dev->keybit);
-			__set_bit(BTN_FORWARD, input_dev->keybit);
-			__set_bit(BTN_BACK, input_dev->keybit);
-			__set_bit(BTN_RIGHT, input_dev->keybit);
-
 			if (features->touch_max) {
 				if (features->pktlen == WACOM_PKGLEN_BBTOUCH3) {
 					input_set_abs_params(input_dev,
@@ -1979,6 +1971,21 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 
 		break;
 
+	case INTUOSHT:
+	case BAMBOO_PT:
+		/* pad device is on the touch interface */
+		if (features->device_type != BTN_TOOL_FINGER)
+			return 1;
+
+		__clear_bit(ABS_MISC, input_dev->absbit);
+
+		__set_bit(BTN_LEFT, input_dev->keybit);
+		__set_bit(BTN_FORWARD, input_dev->keybit);
+		__set_bit(BTN_BACK, input_dev->keybit);
+		__set_bit(BTN_RIGHT, input_dev->keybit);
+
+		break;
+
 	default:
 		/* no pad supported */
 		return 1;
-- 
2.0.0

