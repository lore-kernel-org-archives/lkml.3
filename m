Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3F0Muz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:50:55 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:62414 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753680Ab3F0Mux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:53 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 44/51] Input: atmel_mxt_ts - Handle reports from T47 Stylus object
Date: Thu, 27 Jun 2013 13:49:19 +0100
Message-Id: <1372337366-9286-45-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index ee39683..ceb090a 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -128,6 +128,9 @@ struct t9_range {
 /* Define for MXT_PROCI_TOUCHSUPPRESSION_T42 */
 #define MXT_T42_MSG_TCHSUP	(1 << 0)
 
+/* T47 Stylus */
+#define MXT_TOUCH_MAJOR_T47_STYLUS	1
+
 /* T63 Stylus */
 #define MXT_T63_STYLUS_PRESS	(1 << 0)
 #define MXT_T63_STYLUS_RELEASE	(1 << 1)
@@ -696,6 +699,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	int area;
 	int amplitude;
 	u8 vector;
+	int tool;
 
 	/* do not report events if input device not yet registered */
 	if (!data->enable_reporting)
@@ -713,6 +717,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 		y >>= 2;
 
 	area = message[5];
+
 	amplitude = message[6];
 	vector = message[7];
 
@@ -741,8 +746,17 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
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

