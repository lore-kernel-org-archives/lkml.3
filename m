Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab3BVSQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:16:11 -0500
Received: from [89.21.227.133] ([89.21.227.133]:61778 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759026Ab3BVSId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:33 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 24/40] Input: atmel_mxt_ts - Implement vector/orientation support
Date: Fri, 22 Feb 2013 17:58:11 +0000
Message-Id: <1361555907-19840-25-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel touch messages contain orientation information as a byte in a packed
format which can be passed straight on to Android if the input device
configuration is correct, see
http://source.android.com/tech/input/touch-devices.html#touchorientationcalibration

This requires vector reports to be enabled in maXTouch config (zero DISVECT
bit in T9 CTRL field)

Android converts the format in frameworks/base/services/input/Input.cpp,
search for ORIENTATION_CALIBRATION_VECTOR.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index b1fdc36..6ab7ef6 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -621,6 +621,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	int y;
 	int area;
 	int amplitude;
+	u8 vector;
 
 	/* do not report events if input device not yet registered */
 	if (!input_dev)
@@ -638,9 +639,10 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 
 	area = message[5];
 	amplitude = message[6];
+	vector = message[7];
 
 	dev_dbg(dev,
-		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u\n",
+		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u vector: %02X\n",
 		id,
 		(status & MXT_T9_DETECT) ? 'D' : '.',
 		(status & MXT_T9_PRESS) ? 'P' : '.',
@@ -650,7 +652,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 		(status & MXT_T9_AMP) ? 'A' : '.',
 		(status & MXT_T9_SUPPRESS) ? 'S' : '.',
 		(status & MXT_T9_UNGRIP) ? 'U' : '.',
-		x, y, area, amplitude);
+		x, y, area, amplitude, vector);
 
 	input_mt_slot(input_dev, id);
 
@@ -670,6 +672,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
 		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
 		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
+		input_report_abs(input_dev, ABS_MT_ORIENTATION, vector);
 	} else {
 		/* Touch no longer active, close out slot */
 		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
@@ -1945,6 +1948,8 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
 			     0, data->max_y, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_PRESSURE,
 			     0, 255, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_ORIENTATION,
+			     0, 255, 0, 0);
 
 	input_set_drvdata(input_dev, data);
 
-- 
1.7.10.4

