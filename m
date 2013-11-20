Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab3KTVcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:32:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab3KTVcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:32:42 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Antonio Ospite <ospite@studenti.unina.it>, simon@mungewell.org,
        case@corpsmoderne.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] input: Introduce INPUT_PROP_MT
Date: Wed, 20 Nov 2013 16:32:20 -0500
Message-Id: <1384983141-31019-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be a clash with devices presenting a lot of absolute axis
(like the PS3 Sixaxis) and true multitouch devices. Both those kinds
of devices may present some ABS_MT_* capabilities, so setting this
property ensures user-space knows what to do with the input device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 Documentation/input/event-codes.txt          | 7 +++++++
 Documentation/input/multi-touch-protocol.txt | 5 +++++
 drivers/hid/hid-ntrig.c                      | 1 +
 drivers/input/input-mt.c                     | 2 ++
 drivers/input/touchscreen/auo-pixcir-ts.c    | 1 +
 drivers/input/touchscreen/bu21013_ts.c       | 1 +
 drivers/input/touchscreen/pixcir_i2c_ts.c    | 1 +
 drivers/input/touchscreen/st1232.c           | 1 +
 include/uapi/linux/input.h                   | 1 +
 9 files changed, 20 insertions(+)

diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
index f1ea2c6..b54feb3 100644
--- a/Documentation/input/event-codes.txt
+++ b/Documentation/input/event-codes.txt
@@ -281,6 +281,13 @@ gestures can normally be extracted from it.
 If INPUT_PROP_SEMI_MT is not set, the device is assumed to be a true MT
 device.
 
+INPUT_PROP_MT:
+-------------
+There may be a clash with devices presenting a lot of absolute axis (like the
+PS3 Sixaxis) and true multitouch devices. Both those kinds of devices may
+present some ABS_MT_* capabilities, so setting this property ensures user-space
+knows what to do with the input device.
+
 Guidelines:
 ==========
 The guidelines below ensure proper single-touch and multi-finger functionality.
diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index de139b1..420444f 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -54,6 +54,11 @@ enumeration of the full set of anonymous contacts currently on the
 surface. The order in which the packets appear in the event stream is not
 important.  Event filtering and finger tracking is left to user space [3].
 
+Note that type A device are requested to manually set the property
+INPUT_PROP_MT.
+Type B devices does not need to set INPUT_PROP_MT manually, as this is done
+by calling input_mt_init_slot().
+
 For type B devices, the kernel driver should associate a slot with each
 identified contact, and use that slot to propagate changes for the contact.
 Creation, replacement and destruction of contacts is achieved by modifying
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 600f207..6dedc64 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -879,6 +879,7 @@ static void ntrig_input_configured(struct hid_device *hid,
 		__clear_bit(BTN_TOOL_FINGER, input->keybit);
 		__clear_bit(BTN_0, input->keybit);
 		__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
+		__set_bit(INPUT_PROP_MT, input->propbit);
 		/*
 		 * The physical touchscreen (single touch)
 		 * input has a value for physical, whereas
diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index d398f13..f9b70e7 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -58,6 +58,8 @@ int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
 	input_set_abs_params(dev, ABS_MT_SLOT, 0, num_slots - 1, 0, 0);
 	input_set_abs_params(dev, ABS_MT_TRACKING_ID, 0, TRKID_MAX, 0, 0);
 
+	__set_bit(INPUT_PROP_MT, dev->propbit);
+
 	if (flags & (INPUT_MT_POINTER | INPUT_MT_DIRECT)) {
 		__set_bit(EV_KEY, dev->evbit);
 		__set_bit(BTN_TOUCH, dev->keybit);
diff --git a/drivers/input/touchscreen/auo-pixcir-ts.c b/drivers/input/touchscreen/auo-pixcir-ts.c
index d3f9f6b..70836cd 100644
--- a/drivers/input/touchscreen/auo-pixcir-ts.c
+++ b/drivers/input/touchscreen/auo-pixcir-ts.c
@@ -594,6 +594,7 @@ static int auo_pixcir_probe(struct i2c_client *client,
 	input_set_abs_params(input_dev, ABS_Y, 0, pdata->y_max, 0, 0);
 
 	/* For multi touch */
+	__set_bit(INPUT_PROP_MT, input_dev->propbit);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_X, 0,
 			     pdata->x_max, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_Y, 0,
diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
index b9b5dda..4ce6220 100644
--- a/drivers/input/touchscreen/bu21013_ts.c
+++ b/drivers/input/touchscreen/bu21013_ts.c
@@ -573,6 +573,7 @@ static int bu21013_probe(struct i2c_client *client,
 	__set_bit(EV_SYN, in_dev->evbit);
 	__set_bit(EV_KEY, in_dev->evbit);
 	__set_bit(EV_ABS, in_dev->evbit);
+	__set_bit(INPUT_PROP_MT, in_dev->propbit);
 
 	input_set_abs_params(in_dev, ABS_MT_POSITION_X, 0,
 						pdata->touch_x_max, 0, 0);
diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 6cc6b36..72154e4 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -157,6 +157,7 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 	__set_bit(EV_KEY, input->evbit);
 	__set_bit(EV_ABS, input->evbit);
 	__set_bit(BTN_TOUCH, input->keybit);
+	__set_bit(INPUT_PROP_MT, input->propbit);
 	input_set_abs_params(input, ABS_X, 0, pdata->x_max, 0, 0);
 	input_set_abs_params(input, ABS_Y, 0, pdata->y_max, 0, 0);
 	input_set_abs_params(input, ABS_MT_POSITION_X, 0, pdata->x_max, 0, 0);
diff --git a/drivers/input/touchscreen/st1232.c b/drivers/input/touchscreen/st1232.c
index 2f03b2f..2f17045 100644
--- a/drivers/input/touchscreen/st1232.c
+++ b/drivers/input/touchscreen/st1232.c
@@ -205,6 +205,7 @@ static int st1232_ts_probe(struct i2c_client *client,
 	__set_bit(EV_SYN, input_dev->evbit);
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(EV_ABS, input_dev->evbit);
+	__set_bit(INPUT_PROP_MT, input_dev->propbit);
 
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR, 0, MAX_AREA, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_X, MIN_X, MAX_X, 0, 0);
diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index a372627..b469cae 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -164,6 +164,7 @@ struct input_keymap_entry {
 #define INPUT_PROP_DIRECT		0x01	/* direct input devices */
 #define INPUT_PROP_BUTTONPAD		0x02	/* has button(s) under pad */
 #define INPUT_PROP_SEMI_MT		0x03	/* touch rectangle only */
+#define INPUT_PROP_MT			0x04	/* multitouch devices */
 
 #define INPUT_PROP_MAX			0x1f
 #define INPUT_PROP_CNT			(INPUT_PROP_MAX + 1)
-- 
1.8.3.1

