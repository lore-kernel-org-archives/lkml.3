Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab3BVSIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:08:41 -0500
Received: from [89.21.227.133] ([89.21.227.133]:62904 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753717Ab3BVSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:30 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2013 13:08:30 EST
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 31/40] Input: atmel_mxt_ts - Implement T15 Key Array support
Date: Fri, 22 Feb 2013 17:58:18 +0000
Message-Id: <1361555907-19840-32-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   52 ++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 02fce62..8794353 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -166,6 +166,11 @@ struct t9_range {
 #define MXT_NOISE_FREQ4		15
 #define MXT_NOISE_IDLEGCAFVALID	16
 
+/* T15 Key array */
+int mxt_t15_keys[] = { };
+
+static unsigned long mxt_t15_keystatus;
+
 /* MXT_SPT_COMMSCONFIG_T18 */
 #define MXT_COMMS_CTRL		0
 #define MXT_COMMS_CMD		1
@@ -284,6 +289,8 @@ struct mxt_data {
 	u16 T7_address;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
+	u8 T15_reportid_min;
+	u8 T15_reportid_max;
 	u8 T42_reportid_min;
 	u8 T42_reportid_max;
 	u16 T44_address;
@@ -740,6 +747,36 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	data->update_input = true;
 }
 
+static void mxt_proc_t15_messages(struct mxt_data *data, u8 *msg)
+{
+	struct input_dev *input_dev = data->input_dev;
+	struct device *dev = &data->client->dev;
+	u8 key;
+	bool curr_state, new_state;
+	bool sync = false;
+	unsigned long keystates = le32_to_cpu(msg[2]);
+
+	for (key = 0; key < ARRAY_SIZE(mxt_t15_keys); key++) {
+		curr_state = test_bit(key, &mxt_t15_keystatus);
+		new_state = test_bit(key, &keystates);
+
+		if (!curr_state && new_state) {
+			dev_dbg(dev, "T15 key press: %u\n", key);
+			__set_bit(key, &mxt_t15_keystatus);
+			input_event(input_dev, EV_KEY, mxt_t15_keys[key], 1);
+			sync = true;
+		} else if (curr_state && !new_state) {
+			dev_dbg(dev, "T15 key release: %u\n", key);
+			__clear_bit(key, &mxt_t15_keystatus);
+			input_event(input_dev, EV_KEY, mxt_t15_keys[key], 0);
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
@@ -851,6 +888,9 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	} else if (report_id == data->T48_reportid) {
 		mxt_proc_t48_messages(data, message);
 		handled = true;
+	} else if (report_id >= data->T15_reportid_min
+		   && report_id <= data->T15_reportid_max) {
+		mxt_proc_t15_messages(data, message);
 	}
 
 	if (!handled || data->debug_enabled)
@@ -1497,6 +1537,10 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->num_touchids =
 				object->num_report_ids * OBP_INSTANCES(object);
 			break;
+		case MXT_TOUCH_KEYARRAY_T15:
+			data->T15_reportid_min = min_id;
+			data->T15_reportid_max = max_id;
+			break;
 		case MXT_PROCI_TOUCHSUPPRESSION_T42:
 			data->T42_reportid_min = min_id;
 			data->T42_reportid_max = max_id;
@@ -2060,6 +2104,7 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
 	struct input_dev *input_dev;
 	int error;
 	unsigned int num_mt_slots;
+	int key;
 
 	input_dev = input_allocate_device();
 	if (!input_dev) {
@@ -2117,6 +2162,13 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
 			0, MT_TOOL_MAX, 0, 0);
 	}
 
+	/* For T15 key array */
+	if (data->T15_reportid_min) {
+		mxt_t15_keystatus = 0;
+		for (key = 0; key < ARRAY_SIZE(mxt_t15_keys); key++)
+			input_set_capability(input_dev, EV_KEY, mxt_t15_keys[key]);
+	}
+
 	input_set_drvdata(input_dev, data);
 
 	error = input_register_device(input_dev);
-- 
1.7.10.4

