Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3F0Mz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:55:29 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:62414 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753645Ab3F0Muv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:51 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 40/51] Input: atmel_mxt_ts - Implement support for T15 Key Array
Date: Thu, 27 Jun 2013 13:49:15 +0100
Message-Id: <1372337366-9286-41-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a key array object in many maXTouch chips which allows some X/Y lines
to be used as a key array. This patch maps them to a series of keys which may
be configured in a platform data array.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   57 ++++++++++++++++++++++++++++++
 include/linux/i2c/atmel_mxt_ts.h         |    2 ++
 2 files changed, 59 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 2e6118a..2eaa9d3 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -275,6 +275,7 @@ struct mxt_data {
 	u8 last_message_count;
 	u8 num_touchids;
 	u8 num_stylusids;
+	unsigned long t15_keystatus;
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -284,6 +285,8 @@ struct mxt_data {
 	u16 T7_address;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
+	u8 T15_reportid_min;
+	u8 T15_reportid_max;
 	u8 T19_reportid;
 	u8 T42_reportid_min;
 	u8 T42_reportid_max;
@@ -809,6 +812,42 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	data->update_input = true;
 }
 
+static void mxt_proc_t15_messages(struct mxt_data *data, u8 *msg)
+{
+	struct input_dev *input_dev = data->input_dev;
+	struct device *dev = &data->client->dev;
+	int key;
+	bool curr_state, new_state;
+	bool sync = false;
+	unsigned long keystates = le32_to_cpu(msg[2]);
+
+	/* do not report events if input device not yet registered */
+	if (!data->enable_reporting)
+		return;
+
+	for (key = 0; key < data->pdata->t15_num_keys; key++) {
+		curr_state = test_bit(key, &data->t15_keystatus);
+		new_state = test_bit(key, &keystates);
+
+		if (!curr_state && new_state) {
+			dev_dbg(dev, "T15 key press: %u\n", key);
+			__set_bit(key, &data->t15_keystatus);
+			input_event(input_dev, EV_KEY,
+				    data->pdata->t15_keymap[key], 1);
+			sync = true;
+		} else if (curr_state && !new_state) {
+			dev_dbg(dev, "T15 key release: %u\n", key);
+			__clear_bit(key, &data->t15_keystatus);
+			input_event(input_dev, EV_KEY,
+				    data->pdata->t15_keymap[key], 0);
+			sync = true;
+		}
+	}
+
+	if (sync)
+		input_sync(input_dev);
+}
+
 static void mxt_proc_t42_messages(struct mxt_data *data, u8 *msg)
 {
 	struct device *dev = &data->client->dev;
@@ -920,6 +959,9 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 		mxt_proc_t42_messages(data, message);
 	} else if (report_id == data->T48_reportid) {
 		mxt_proc_t48_messages(data, message);
+	} else if (report_id >= data->T15_reportid_min
+		   && report_id <= data->T15_reportid_max) {
+		mxt_proc_t15_messages(data, message);
 	} else {
 		mxt_dump_message(data, message);
 	}
@@ -1555,6 +1597,8 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T7_address = 0;
 	data->T9_reportid_min = 0;
 	data->T9_reportid_max = 0;
+	data->T15_reportid_min = 0;
+	data->T15_reportid_max = 0;
 	data->T19_reportid = 0;
 	data->T42_reportid_min = 0;
 	data->T42_reportid_max = 0;
@@ -1629,6 +1673,10 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->num_touchids = object->num_report_ids
 						* mxt_obj_instances(object);
 			break;
+		case MXT_TOUCH_KEYARRAY_T15:
+			data->T15_reportid_min = min_id;
+			data->T15_reportid_max = max_id;
+			break;
 		case MXT_PROCI_TOUCHSUPPRESSION_T42:
 			data->T42_reportid_min = min_id;
 			data->T42_reportid_max = max_id;
@@ -2214,6 +2262,15 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
 			0, MT_TOOL_MAX, 0, 0);
 	}
 
+	/* For T15 key array */
+	if (data->T15_reportid_min) {
+		data->t15_keystatus = 0;
+
+		for (i = 0; i < data->pdata->t15_num_keys; i++)
+			input_set_capability(input_dev, EV_KEY,
+					     data->pdata->t15_keymap[i]);
+	}
+
 	input_set_drvdata(input_dev, data);
 
 	error = input_register_device(input_dev);
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index 02bf6ea..b7d2092 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -20,6 +20,8 @@ struct mxt_platform_data {
 	unsigned long irqflags;
 	u8 t19_num_keys;
 	const unsigned int *t19_keymap;
+	int t15_num_keys;
+	const unsigned int *t15_keymap;
 };
 
 #endif /* __LINUX_ATMEL_MXT_TS_H */
-- 
1.7.10.4

