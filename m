Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbaFWU5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873AbaFWU5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:57:33 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 3/5] Input - wacom: split out the pad device for Bamboos
Date: Mon, 23 Jun 2014 16:57:17 -0400
Message-Id: <1403557039-1487-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We rely on the return code of wacom_bpt*() to do the input_sync().
wacom_wac_irq() then properly sync the input devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_wac.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 8807ab5..5aaa3d2 100644
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
@@ -1806,11 +1803,6 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 
 		if (features->device_type == BTN_TOOL_FINGER) {
 
-			__set_bit(BTN_LEFT, input_dev->keybit);
-			__set_bit(BTN_FORWARD, input_dev->keybit);
-			__set_bit(BTN_BACK, input_dev->keybit);
-			__set_bit(BTN_RIGHT, input_dev->keybit);
-
 			if (features->touch_max) {
 				/* touch interface */
 				unsigned int flags = INPUT_MT_POINTER;
@@ -1993,6 +1985,21 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 
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
1.9.0

