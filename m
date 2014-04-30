Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713AbaD3Mgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:36:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52563 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624AbaD3Mgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:36:52 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 4/7] Input: pixcir_i2c_ts: Use Type-B Multi-Touch protocol
Date: Wed, 30 Apr 2014 15:36:29 +0300
Message-ID: <1398861392-8959-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398861392-8959-1-git-send-email-rogerq@ti.com>
References: <1398861392-8959-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using the Type-B Multi-Touch protocol.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/input/touchscreen/pixcir_i2c_ts.c | 125 ++++++++++++++++++++++--------
 1 file changed, 94 insertions(+), 31 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 106096f..6127606 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -23,9 +23,12 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
+#include <linux/input/mt.h>
 #include <linux/input/pixcir_ts.h>
 #include <linux/gpio.h>
 
+#define PIXCIR_MAX_SLOTS       2
+
 struct pixcir_i2c_ts_data {
 	struct i2c_client *client;
 	struct input_dev *input;
@@ -33,12 +36,25 @@ struct pixcir_i2c_ts_data {
 	bool exiting;
 };
 
-static void pixcir_ts_poscheck(struct pixcir_i2c_ts_data *data)
+struct pixcir_touch {
+	int x;
+	int y;
+};
+
+struct pixcir_report_data {
+	int num_touches;
+	struct pixcir_touch touches[PIXCIR_MAX_SLOTS];
+};
+
+static void pixcir_ts_parse(struct pixcir_i2c_ts_data *tsdata,
+			    struct pixcir_report_data *report)
 {
-	struct pixcir_i2c_ts_data *tsdata = data;
 	u8 rdbuf[10], wrbuf[1] = { 0 };
+	u8 *bufptr;
 	u8 touch;
-	int ret;
+	int ret, i;
+
+	memset(report, 0, sizeof(struct pixcir_report_data));
 
 	ret = i2c_master_send(tsdata->client, wrbuf, sizeof(wrbuf));
 	if (ret != sizeof(wrbuf)) {
@@ -56,45 +72,85 @@ static void pixcir_ts_poscheck(struct pixcir_i2c_ts_data *data)
 		return;
 	}
 
-	touch = rdbuf[0];
-	if (touch) {
-		u16 posx1 = (rdbuf[3] << 8) | rdbuf[2];
-		u16 posy1 = (rdbuf[5] << 8) | rdbuf[4];
-		u16 posx2 = (rdbuf[7] << 8) | rdbuf[6];
-		u16 posy2 = (rdbuf[9] << 8) | rdbuf[8];
-
-		input_report_key(tsdata->input, BTN_TOUCH, 1);
-		input_report_abs(tsdata->input, ABS_X, posx1);
-		input_report_abs(tsdata->input, ABS_Y, posy1);
-
-		input_report_abs(tsdata->input, ABS_MT_POSITION_X, posx1);
-		input_report_abs(tsdata->input, ABS_MT_POSITION_Y, posy1);
-		input_mt_sync(tsdata->input);
-
-		if (touch == 2) {
-			input_report_abs(tsdata->input,
-					 ABS_MT_POSITION_X, posx2);
-			input_report_abs(tsdata->input,
-					 ABS_MT_POSITION_Y, posy2);
-			input_mt_sync(tsdata->input);
-		}
-	} else {
-		input_report_key(tsdata->input, BTN_TOUCH, 0);
+	touch = rdbuf[0] & 0x7;
+	if (touch > PIXCIR_MAX_SLOTS)
+		touch = PIXCIR_MAX_SLOTS;
+
+	report->num_touches = touch;
+	bufptr = &rdbuf[2];
+
+	for (i = 0; i < touch; i++) {
+		report->touches[i].x = (bufptr[1] << 8) | bufptr[0];
+		report->touches[i].y = (bufptr[3] << 8) | bufptr[2];
+
+		bufptr = &bufptr[4];
 	}
+}
+
+static void pixcir_ts_report(struct pixcir_i2c_ts_data *ts,
+			     struct pixcir_report_data *report)
+{
+	struct input_mt_pos pos[PIXCIR_MAX_SLOTS];
+	int slots[PIXCIR_MAX_SLOTS];
+	struct pixcir_touch *touch;
+	int n, i, slot;
+	struct device *dev = &ts->client->dev;
 
-	input_sync(tsdata->input);
+	n = report->num_touches;
+	if (n > PIXCIR_MAX_SLOTS)
+		n = PIXCIR_MAX_SLOTS;
+
+	for (i = 0; i < n; i++) {
+		touch = &report->touches[i];
+		pos[i].x = touch->x;
+		pos[i].y = touch->y;
+	}
+
+	input_mt_assign_slots(ts->input, slots, pos, n);
+
+	for (i = 0; i < n; i++) {
+		touch = &report->touches[i];
+		slot = slots[i];
+
+		input_mt_slot(ts->input, slot);
+		input_mt_report_slot_state(ts->input,
+					   MT_TOOL_FINGER, true);
+
+		input_event(ts->input, EV_ABS, ABS_MT_POSITION_X, touch->x);
+		input_event(ts->input, EV_ABS, ABS_MT_POSITION_Y, touch->y);
+
+		dev_dbg(dev, "%d: slot %d, x %d, y %d\n",
+			i, slot, touch->x, touch->y);
+	}
+
+	input_mt_sync_frame(ts->input);
+	input_sync(ts->input);
 }
 
 static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
 {
 	struct pixcir_i2c_ts_data *tsdata = dev_id;
 	const struct pixcir_ts_platform_data *pdata = tsdata->chip;
+	struct pixcir_report_data report;
 
 	while (!tsdata->exiting) {
-		pixcir_ts_poscheck(tsdata);
-
-		if (gpio_get_value(pdata->gpio_attb))
+		/* parse packet */
+		pixcir_ts_parse(tsdata, &report);
+
+		/* report it */
+		pixcir_ts_report(tsdata, &report);
+
+		if (gpio_get_value(pdata->gpio_attb)) {
+			if (report.num_touches) {
+				/*
+				 * Last report with no finger up?
+				 * Do it now then.
+				 */
+				input_mt_sync_frame(tsdata->input);
+				input_sync(tsdata->input);
+			}
 			break;
+		}
 
 		msleep(20);
 	}
@@ -337,6 +393,13 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 	input_set_abs_params(input, ABS_MT_POSITION_X, 0, pdata->x_max, 0, 0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, pdata->y_max, 0, 0);
 
+	error = input_mt_init_slots(input, PIXCIR_MAX_SLOTS,
+				    INPUT_MT_DIRECT | INPUT_MT_DROP_UNUSED);
+	if (error) {
+		dev_err(dev, "Error initializing Multi-Touch slots\n");
+		return error;
+	}
+
 	input_set_drvdata(input, tsdata);
 
 	error = devm_gpio_request_one(dev, pdata->gpio_attb,
-- 
1.8.3.2

