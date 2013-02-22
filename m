Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab3BVSOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:14:40 -0500
Received: from [89.21.227.133] ([89.21.227.133]:26704 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759031Ab3BVSId (ORCPT
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
Subject: [PATCH 19/40] Input: atmel_mxt_ts - Decode T6 status messages
Date: Fri, 22 Feb 2013 17:58:06 +0000
Message-Id: <1361555907-19840-20-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   41 ++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c879778..bdf7555 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -86,6 +86,14 @@
 #define MXT_COMMAND_REPORTALL	3
 #define MXT_COMMAND_DIAGNOSTIC	5
 
+/* Define for T6 status byte */
+#define MXT_T6_STATUS_RESET	(1 << 7)
+#define MXT_T6_STATUS_OFL	(1 << 6)
+#define MXT_T6_STATUS_SIGERR	(1 << 5)
+#define MXT_T6_STATUS_CAL	(1 << 4)
+#define MXT_T6_STATUS_CFGERR	(1 << 3)
+#define MXT_T6_STATUS_COMSERR	(1 << 2)
+
 /* MXT_GEN_POWER_T7 field */
 struct t7_config {
 	u8 idle;
@@ -562,6 +570,28 @@ mxt_get_object(struct mxt_data *data, u8 type)
 	return NULL;
 }
 
+static void mxt_proc_t6_messages(struct mxt_data *data, u8 *msg)
+{
+	struct device *dev = &data->client->dev;
+	u8 status = msg[1];
+	u32 crc = msg[2] | (msg[3] << 8) | (msg[4] << 16);
+
+	if (crc != data->config_crc) {
+		data->config_crc = crc;
+		dev_dbg(dev, "T6 Config Checksum: 0x%06X\n", crc);
+	}
+
+	if (status)
+		dev_dbg(dev, "T6 Status 0x%02X%s%s%s%s%s%s\n",
+				status,
+				(status & MXT_T6_STATUS_RESET) ? " RESET" : "",
+				(status & MXT_T6_STATUS_OFL) ? " OFL" : "",
+				(status & MXT_T6_STATUS_SIGERR) ? " SIGERR" : "",
+				(status & MXT_T6_STATUS_CAL) ? " CAL" : "",
+				(status & MXT_T6_STATUS_CFGERR) ? " CFGERR" : "",
+				(status & MXT_T6_STATUS_COMSERR) ? " COMSERR" : "");
+}
+
 static int mxt_read_message(struct mxt_data *data, u8 *message)
 {
 	struct mxt_object *object;
@@ -647,11 +677,6 @@ static void mxt_input_touchevent(struct mxt_data *data, u8 *message)
 	}
 }
 
-static u16 mxt_extract_T6_csum(const u8 *csum)
-{
-	return csum[0] | (csum[1] << 8) | (csum[2] << 16);
-}
-
 static bool mxt_is_T9_message(struct mxt_data *data, u8 *msg)
 {
 	u8 id = msg[0];
@@ -661,7 +686,6 @@ static bool mxt_is_T9_message(struct mxt_data *data, u8 *msg)
 static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 {
 	u8 *message = &data->msg_buf[0];
-	const u8 *payload = &data->msg_buf[1];
 	struct device *dev = &data->client->dev;
 	u8 reportid;
 	bool update_input = false;
@@ -677,10 +701,7 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 		handled = false;
 
 		if (reportid == data->T6_reportid) {
-			u8 status = payload[0];
-			data->config_crc = mxt_extract_T6_csum(&payload[1]);
-			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
-				status, data->config_crc);
+			mxt_proc_t6_messages(data, message);
 			handled = true;
 		} else if (mxt_is_T9_message(data, message)) {
 			mxt_input_touchevent(data, message);
-- 
1.7.10.4

