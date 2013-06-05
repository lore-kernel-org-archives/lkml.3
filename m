Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab3FERv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:51:26 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:44043 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757180Ab3FERsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:18 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 34/53] Input: atmel_mxt_ts - Decode T6 status messages
Date: Wed,  5 Jun 2013 18:37:27 +0100
Message-Id: <1370453866-16534-35-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By storing the previous T6 status byte we can detect reset completion more
correctly, and multiple debug output of the same status can be suppressed (for
example CFGERR).

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   60 ++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 76ad308..39a20fd 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -91,6 +91,11 @@
 
 /* Define for T6 status byte */
 #define MXT_T6_STATUS_RESET	(1 << 7)
+#define MXT_T6_STATUS_OFL	(1 << 6)
+#define MXT_T6_STATUS_SIGERR	(1 << 5)
+#define MXT_T6_STATUS_CAL	(1 << 4)
+#define MXT_T6_STATUS_CFGERR	(1 << 3)
+#define MXT_T6_STATUS_COMSERR	(1 << 2)
 
 /* MXT_GEN_POWER_T7 field */
 struct t7_config {
@@ -248,6 +253,7 @@ struct mxt_data {
 	u8 bootloader_addr;
 	struct t7_config t7_cfg;
 	u8 *msg_buf;
+	u8 t6_status;
 
 	/* Cached parameters from object table */
 	u8 T5_msg_size;
@@ -631,6 +637,39 @@ mxt_get_object(struct mxt_data *data, u8 type)
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
+		complete(&data->crc_completion);
+	}
+
+	/* Detect transition out of reset */
+	if ((data->t6_status & MXT_T6_STATUS_RESET) &&
+	    !(status & MXT_T6_STATUS_RESET))
+		complete(&data->reset_completion);
+
+	/* Output debug if status has changed */
+	if (status != data->t6_status)
+		dev_dbg(dev, "T6 Status 0x%02X%s%s%s%s%s%s%s\n",
+			status,
+			(status == 0) ? " OK" : "",
+			(status & MXT_T6_STATUS_RESET) ? " RESET" : "",
+			(status & MXT_T6_STATUS_OFL) ? " OFL" : "",
+			(status & MXT_T6_STATUS_SIGERR) ? " SIGERR" : "",
+			(status & MXT_T6_STATUS_CAL) ? " CAL" : "",
+			(status & MXT_T6_STATUS_CFGERR) ? " CFGERR" : "",
+			(status & MXT_T6_STATUS_COMSERR) ? " COMSERR" : "");
+
+	/* Save current status */
+	data->t6_status = status;
+}
+
 static int mxt_read_message(struct mxt_data *data, u8 *message)
 {
 	struct mxt_object *object;
@@ -737,11 +776,6 @@ static void mxt_input_touchevent(struct mxt_data *data, u8 *message)
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
@@ -751,12 +785,10 @@ static bool mxt_is_T9_message(struct mxt_data *data, u8 *msg)
 static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 {
 	u8 *message = &data->msg_buf[0];
-	const u8 *payload = &data->msg_buf[1];
 	struct device *dev = &data->client->dev;
 	u8 reportid;
 	bool update_input = false;
 	bool dump;
-	u32 crc;
 
 	do {
 		if (mxt_read_message(data, message)) {
@@ -768,19 +800,7 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 		dump = data->debug_enabled;
 
 		if (reportid == data->T6_reportid) {
-			u8 status = payload[0];
-
-			crc = mxt_extract_T6_csum(&payload[1]);
-			if (crc != data->config_crc) {
-				data->config_crc = crc;
-				complete(&data->crc_completion);
-			}
-
-			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
-				status, data->config_crc);
-
-			if (status & MXT_T6_STATUS_RESET)
-				complete(&data->reset_completion);
+			mxt_proc_t6_messages(data, message);
 		} else if (mxt_is_T9_message(data, message)) {
 			mxt_input_touchevent(data, message);
 			update_input = true;
-- 
1.7.10.4

