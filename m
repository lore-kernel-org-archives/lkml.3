Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbaD3Mg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:36:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54702 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624AbaD3Mgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:36:55 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 5/7] Input: pixcir_i2c_ts: support upto 5 fingers and hardware provided tracking IDs
Date: Wed, 30 Apr 2014 15:36:30 +0300
Message-ID: <1398861392-8959-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398861392-8959-1-git-send-email-rogerq@ti.com>
References: <1398861392-8959-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some variants of the Pixcir touch controller support upto 5
simultaneous fingers and hardware tracking IDs. Prepare the driver
for that.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/input/touchscreen/pixcir_i2c_ts.c | 74 ++++++++++++++++++++++++-------
 include/linux/input/pixcir_ts.h           | 12 +++++
 2 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 6127606..b3ff62c 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -27,18 +27,20 @@
 #include <linux/input/pixcir_ts.h>
 #include <linux/gpio.h>
 
-#define PIXCIR_MAX_SLOTS       2
+#define PIXCIR_MAX_SLOTS       5 /* Max fingers supported by driver */
 
 struct pixcir_i2c_ts_data {
 	struct i2c_client *client;
 	struct input_dev *input;
-	const struct pixcir_ts_platform_data *chip;
+	const struct pixcir_ts_platform_data *pdata;
 	bool exiting;
+	int max_fingers;	/* Max fingers supported in this instance */
 };
 
 struct pixcir_touch {
 	int x;
 	int y;
+	int id;
 };
 
 struct pixcir_report_data {
@@ -49,13 +51,21 @@ struct pixcir_report_data {
 static void pixcir_ts_parse(struct pixcir_i2c_ts_data *tsdata,
 			    struct pixcir_report_data *report)
 {
-	u8 rdbuf[10], wrbuf[1] = { 0 };
+	u8 rdbuf[2 + PIXCIR_MAX_SLOTS * 5];
+	u8 wrbuf[1] = { 0 };
 	u8 *bufptr;
 	u8 touch;
 	int ret, i;
+	int readsize;
+	const struct pixcir_i2c_chip_data *chip = &tsdata->pdata->chip;
 
 	memset(report, 0, sizeof(struct pixcir_report_data));
 
+	i = chip->has_hw_ids ? 1 : 0;
+	readsize = 2 + tsdata->max_fingers * (4 + i);
+	if (readsize > sizeof(rdbuf))
+		readsize = sizeof(rdbuf);
+
 	ret = i2c_master_send(tsdata->client, wrbuf, sizeof(wrbuf));
 	if (ret != sizeof(wrbuf)) {
 		dev_err(&tsdata->client->dev,
@@ -64,7 +74,7 @@ static void pixcir_ts_parse(struct pixcir_i2c_ts_data *tsdata,
 		return;
 	}
 
-	ret = i2c_master_recv(tsdata->client, rdbuf, sizeof(rdbuf));
+	ret = i2c_master_recv(tsdata->client, rdbuf, readsize);
 	if (ret != sizeof(rdbuf)) {
 		dev_err(&tsdata->client->dev,
 			"%s: i2c_master_recv failed(), ret=%d\n",
@@ -73,8 +83,8 @@ static void pixcir_ts_parse(struct pixcir_i2c_ts_data *tsdata,
 	}
 
 	touch = rdbuf[0] & 0x7;
-	if (touch > PIXCIR_MAX_SLOTS)
-		touch = PIXCIR_MAX_SLOTS;
+	if (touch > tsdata->max_fingers)
+		touch = tsdata->max_fingers;
 
 	report->num_touches = touch;
 	bufptr = &rdbuf[2];
@@ -83,7 +93,12 @@ static void pixcir_ts_parse(struct pixcir_i2c_ts_data *tsdata,
 		report->touches[i].x = (bufptr[1] << 8) | bufptr[0];
 		report->touches[i].y = (bufptr[3] << 8) | bufptr[2];
 
-		bufptr = &bufptr[4];
+		if (chip->has_hw_ids) {
+			report->touches[i].id = bufptr[4];
+			bufptr = &bufptr[5];
+		} else {
+			bufptr = &bufptr[4];
+		}
 	}
 }
 
@@ -95,22 +110,35 @@ static void pixcir_ts_report(struct pixcir_i2c_ts_data *ts,
 	struct pixcir_touch *touch;
 	int n, i, slot;
 	struct device *dev = &ts->client->dev;
+	const struct pixcir_i2c_chip_data *chip = &ts->pdata->chip;
 
 	n = report->num_touches;
 	if (n > PIXCIR_MAX_SLOTS)
 		n = PIXCIR_MAX_SLOTS;
 
-	for (i = 0; i < n; i++) {
-		touch = &report->touches[i];
-		pos[i].x = touch->x;
-		pos[i].y = touch->y;
-	}
+	if (!chip->has_hw_ids) {
+		for (i = 0; i < n; i++) {
+			touch = &report->touches[i];
+			pos[i].x = touch->x;
+			pos[i].y = touch->y;
+		}
 
-	input_mt_assign_slots(ts->input, slots, pos, n);
+		input_mt_assign_slots(ts->input, slots, pos, n);
+	}
 
 	for (i = 0; i < n; i++) {
 		touch = &report->touches[i];
-		slot = slots[i];
+
+		if (chip->has_hw_ids) {
+			slot = input_mt_get_slot_by_key(ts->input, touch->id);
+			if (slot < 0) {
+				dev_dbg(dev, "no free slot for id 0x%x\n",
+					touch->id);
+				continue;
+			}
+		} else {
+			slot = slots[i];
+		}
 
 		input_mt_slot(ts->input, slot);
 		input_mt_report_slot_state(ts->input,
@@ -130,7 +158,7 @@ static void pixcir_ts_report(struct pixcir_i2c_ts_data *ts,
 static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
 {
 	struct pixcir_i2c_ts_data *tsdata = dev_id;
-	const struct pixcir_ts_platform_data *pdata = tsdata->chip;
+	const struct pixcir_ts_platform_data *pdata = tsdata->pdata;
 	struct pixcir_report_data report;
 
 	while (!tsdata->exiting) {
@@ -363,6 +391,11 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 			dev_err(dev, "Invalid gpio_attb in pdata\n");
 			return -EINVAL;
 		}
+
+		if (pdata->chip.max_fingers <= 0) {
+			dev_err(dev, "Invalid max_fingers in pdata\n");
+			return -EINVAL;
+		}
 	}
 
 	tsdata = devm_kzalloc(dev, sizeof(*tsdata), GFP_KERNEL);
@@ -377,7 +410,7 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 
 	tsdata->client = client;
 	tsdata->input = input;
-	tsdata->chip = pdata;
+	tsdata->pdata = pdata;
 
 	input->name = client->name;
 	input->id.bustype = BUS_I2C;
@@ -393,7 +426,14 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 	input_set_abs_params(input, ABS_MT_POSITION_X, 0, pdata->x_max, 0, 0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, pdata->y_max, 0, 0);
 
-	error = input_mt_init_slots(input, PIXCIR_MAX_SLOTS,
+	tsdata->max_fingers = tsdata->pdata->chip.max_fingers;
+	if (tsdata->max_fingers > PIXCIR_MAX_SLOTS) {
+		tsdata->max_fingers = PIXCIR_MAX_SLOTS;
+		dev_info(dev, "Limiting maximum fingers to %d\n",
+			 tsdata->max_fingers);
+	}
+
+	error = input_mt_init_slots(input, tsdata->max_fingers,
 				    INPUT_MT_DIRECT | INPUT_MT_DROP_UNUSED);
 	if (error) {
 		dev_err(dev, "Error initializing Multi-Touch slots\n");
diff --git a/include/linux/input/pixcir_ts.h b/include/linux/input/pixcir_ts.h
index 160cf35..7bae83b 100644
--- a/include/linux/input/pixcir_ts.h
+++ b/include/linux/input/pixcir_ts.h
@@ -43,10 +43,22 @@ enum pixcir_int_mode {
 #define PIXCIR_INT_ENABLE	(1UL << 3)
 #define PIXCIR_INT_POL_HIGH	(1UL << 2)
 
+/**
+ * struct pixcir_irc_chip_data - chip related data
+ * @max_fingers:	Max number of fingers reported simultaneously by h/w
+ * @has_hw_ids:		Hardware supports finger tracking IDs
+ *
+ */
+struct pixcir_i2c_chip_data {
+	u8 max_fingers;
+	bool has_hw_ids;
+};
+
 struct pixcir_ts_platform_data {
 	int x_max;
 	int y_max;
 	int gpio_attb;		/* GPIO connected to ATTB line */
+	struct pixcir_i2c_chip_data chip;
 };
 
 #endif
-- 
1.8.3.2

