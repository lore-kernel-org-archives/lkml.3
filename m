Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab3BVSIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:08:37 -0500
Received: from [89.21.227.133] ([89.21.227.133]:52065 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758755Ab3BVSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:30 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 36/40] Input: atmel_mxt_ts - Handle reports from T47 Stylus object
Date: Fri, 22 Feb 2013 17:58:23 +0000
Message-Id: <1361555907-19840-37-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 267b5d8..79fe3ba 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -130,6 +130,9 @@ static unsigned long mxt_t15_keystatus;
 /* Define for MXT_PROCI_TOUCHSUPPRESSION_T42 */
 #define MXT_T42_MSG_TCHSUP	(1 << 0)
 
+/* T47 Stylus */
+#define MXT_TOUCH_MAJOR_T47_STYLUS	1
+
 /* T63 Stylus */
 #define MXT_STYLUS_PRESS	(1 << 0)
 #define MXT_STYLUS_RELEASE	(1 << 1)
@@ -625,6 +628,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	int area;
 	int amplitude;
 	u8 vector;
+	int tool;
 
 	/* do not report events if input device not yet registered */
 	if (!input_dev)
@@ -641,6 +645,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 		y >>= 2;
 
 	area = message[5];
+
 	amplitude = message[6];
 	vector = message[7];
 
@@ -664,13 +669,21 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 		 * status messages, indicating all the events that have
 		 * happened */
 		if (status & MXT_T9_RELEASE) {
-			input_mt_report_slot_state(input_dev,
-						   MT_TOOL_FINGER, 0);
+			input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
 			mxt_input_sync(input_dev);
 		}
 
+		/* A reported size of zero indicates that the reported touch
+		 * is a stylus from a linked Stylus T47 object. */
+		if (area == 0) {
+			area = MXT_TOUCH_MAJOR_T47_STYLUS;
+			tool = MT_TOOL_PEN;
+		} else {
+			tool = MT_TOOL_FINGER;
+		}
+
 		/* Touch active */
-		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 1);
+		input_mt_report_slot_state(input_dev, tool, 1);
 		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
 		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
 		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
-- 
1.7.10.4

