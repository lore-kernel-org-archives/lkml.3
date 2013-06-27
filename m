Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3F0NBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:01:31 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:36964 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753479Ab3F0Muo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:44 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 25/51] Input: atmel_mxt_ts - Handle multiple input reports in one message
Date: Thu, 27 Jun 2013 13:49:00 +0100
Message-Id: <1372337366-9286-26-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   34 +++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 5a16383..8632133 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -628,6 +628,12 @@ static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
 	}
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
@@ -645,10 +651,12 @@ static void mxt_input_touchevent(struct mxt_data *data,
 
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
 	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
+
+	/* Handle 10/12 bit switching */
 	if (data->max_x < 1024)
-		x = x >> 2;
+		x >>= 2;
 	if (data->max_y < 1024)
-		y = y >> 2;
+		y >>= 2;
 
 	area = message->message[4];
 	amplitude = message->message[5];
@@ -667,14 +675,26 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		x, y, area, amplitude);
 
 	input_mt_slot(input_dev, id);
-	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
-				   status & MXT_T9_DETECT);
 
 	if (status & MXT_T9_DETECT) {
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
 		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
 		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
+	} else {
+		/* Touch no longer active, close out slot */
+		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
 	}
 }
 
@@ -732,10 +752,8 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 		}
 	} while (reportid != 0xff);
 
-	if (data->enable_reporting && update_input) {
-		input_mt_report_pointer_emulation(data->input_dev, false);
-		input_sync(data->input_dev);
-	}
+	if (data->enable_reporting && update_input)
+		mxt_input_sync(data->input_dev);
 
 	return IRQ_HANDLED;
 }
-- 
1.7.10.4

