Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab3BVSMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:12:52 -0500
Received: from [89.21.227.133] ([89.21.227.133]:12194 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759069Ab3BVSIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:36 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 15/40] Input: atmel_mxt_ts - Improve touch reporting for T9
Date: Fri, 22 Feb 2013 17:58:02 +0000
Message-Id: <1361555907-19840-16-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle multiple touch statuses in one report
Rename defines to add T9
Rename pressure to amplitude to match device spec

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   85 ++++++++++++++++++------------
 1 file changed, 51 insertions(+), 34 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 3994564..335fa1b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -108,13 +108,23 @@ struct t7_config {
 #define MXT_T9_ORIENT		9
 #define MXT_T9_RANGE		18
 
+/* MXT_TOUCH_MULTI_T9 status */
+#define MXT_T9_UNGRIP		(1 << 0)
+#define MXT_T9_SUPPRESS		(1 << 1)
+#define MXT_T9_AMP		(1 << 2)
+#define MXT_T9_VECTOR		(1 << 3)
+#define MXT_T9_MOVE		(1 << 4)
+#define MXT_T9_RELEASE		(1 << 5)
+#define MXT_T9_PRESS		(1 << 6)
+#define MXT_T9_DETECT		(1 << 7)
+
 struct t9_range {
 	u16 x;
 	u16 y;
 } __packed;
 
-/* Touch orient bits */
-#define MXT_XY_SWITCH		(1 << 0)
+/* MXT_TOUCH_MULTI_T9 orient */
+#define MXT_T9_ORIENT_SWITCH	(1 << 0)
 
 /* MXT_PROCI_GRIPFACE_T20 field */
 #define MXT_GRIPFACE_CTRL	0
@@ -187,16 +197,6 @@ struct t9_range {
 #define MXT_BOOT_EXTENDED_ID	(1 << 5)
 #define MXT_BOOT_ID_MASK	0x1f
 
-/* Touch status */
-#define MXT_UNGRIP		(1 << 0)
-#define MXT_SUPPRESS		(1 << 1)
-#define MXT_AMP			(1 << 2)
-#define MXT_VECTOR		(1 << 3)
-#define MXT_MOVE		(1 << 4)
-#define MXT_RELEASE		(1 << 5)
-#define MXT_PRESS		(1 << 6)
-#define MXT_DETECT		(1 << 7)
-
 /* Touchscreen absolute values */
 #define MXT_MAX_AREA		0xff
 
@@ -580,6 +580,12 @@ static int mxt_read_message(struct mxt_data *data,
 			sizeof(struct mxt_message), message);
 }
 
+static void mxt_input_sync(struct input_dev *input_dev)
+{
+	input_mt_report_pointer_emulation(input_dev, false);
+	input_sync(input_dev);
+}
+
 static void mxt_input_touchevent(struct mxt_data *data,
 				      struct mxt_message *message, int id)
 {
@@ -589,7 +595,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int x;
 	int y;
 	int area;
-	int pressure;
+	int amplitude;
 
 	/* do not report events if input device not yet registered */
 	if (!input_dev)
@@ -597,36 +603,49 @@ static void mxt_input_touchevent(struct mxt_data *data,
 
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
 	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
+
 	if (data->max_x < 1024)
-		x = x >> 2;
+		x >>= 2;
 	if (data->max_y < 1024)
-		y = y >> 2;
+		y >>= 2;
 
 	area = message->message[4];
-	pressure = message->message[5];
+	amplitude = message->message[5];
 
 	dev_dbg(dev,
 		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u\n",
 		id,
-		(status & MXT_DETECT) ? 'D' : '.',
-		(status & MXT_PRESS) ? 'P' : '.',
-		(status & MXT_RELEASE) ? 'R' : '.',
-		(status & MXT_MOVE) ? 'M' : '.',
-		(status & MXT_VECTOR) ? 'V' : '.',
-		(status & MXT_AMP) ? 'A' : '.',
-		(status & MXT_SUPPRESS) ? 'S' : '.',
-		(status & MXT_UNGRIP) ? 'U' : '.',
-		x, y, area, pressure);
+		(status & MXT_T9_DETECT) ? 'D' : '.',
+		(status & MXT_T9_PRESS) ? 'P' : '.',
+		(status & MXT_T9_RELEASE) ? 'R' : '.',
+		(status & MXT_T9_MOVE) ? 'M' : '.',
+		(status & MXT_T9_VECTOR) ? 'V' : '.',
+		(status & MXT_T9_AMP) ? 'A' : '.',
+		(status & MXT_T9_SUPPRESS) ? 'S' : '.',
+		(status & MXT_T9_UNGRIP) ? 'U' : '.',
+		x, y, area, amplitude);
 
 	input_mt_slot(input_dev, id);
-	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
-				   status & MXT_DETECT);
 
-	if (status & MXT_DETECT) {
+	if (status & MXT_T9_DETECT) {
+		/* Multiple bits may be set if the host is slow to read the
+		 * status messages, indicating all the events that have
+		 * happened */
+		if (status & MXT_T9_RELEASE) {
+			input_mt_report_slot_state(input_dev,
+						   MT_TOOL_FINGER, 0);
+			mxt_input_sync(input_dev);
+		}
+
+		/* Touch active */
+		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 1);
 		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
 		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
-		input_report_abs(input_dev, ABS_MT_PRESSURE, pressure);
+		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
 		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
+	} else {
+		/* Touch no longer active, close out slot */
+		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
 	}
 }
 
@@ -676,10 +695,8 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 			mxt_dump_message(dev, &message);
 	} while (reportid != MXT_RPTID_NOMSG);
 
-	if (update_input) {
-		input_mt_report_pointer_emulation(data->input_dev, false);
-		input_sync(data->input_dev);
-	}
+	if (update_input)
+		mxt_input_sync(data->input_dev);
 
 	return IRQ_HANDLED;
 }
@@ -1238,7 +1255,7 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 	if (range.y == 0)
 		range.y = 1023;
 
-	if (orient & MXT_XY_SWITCH) {
+	if (orient & MXT_T9_ORIENT_SWITCH) {
 		data->max_x = range.y;
 		data->max_y = range.x;
 	} else {
-- 
1.7.10.4

