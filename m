Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbaGCPIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:08:19 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:26730 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758298AbaGCPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:08:13 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 13/15] Input: atmel_mxt_ts - decode T6 status messages
Date: Thu,  3 Jul 2014 16:01:35 +0100
Message-Id: <1404399697-26484-14-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

By storing the previous T6 status byte multiple debug output of the same
status can be suppressed (for example CFGERR).

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 60 +++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index e4520c9..c409753 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -92,6 +92,11 @@
 
 /* Define for T6 status byte */
 #define MXT_T6_STATUS_RESET	(1 << 7)
+#define MXT_T6_STATUS_OFL	(1 << 6)
+#define MXT_T6_STATUS_SIGERR	(1 << 5)
+#define MXT_T6_STATUS_CAL	(1 << 4)
+#define MXT_T6_STATUS_CFGERR	(1 << 3)
+#define MXT_T6_STATUS_COMSERR	(1 << 2)
 
 /* MXT_GEN_POWER_T7 field */
 struct t7_config {
@@ -247,6 +252,7 @@ struct mxt_data {
 	u8 bootloader_addr;
 	struct t7_config t7_cfg;
 	u8 *msg_buf;
+	u8 t6_status;
 
 	/* Cached parameters from object table */
 	u8 T5_msg_size;
@@ -627,6 +633,39 @@ mxt_get_object(struct mxt_data *data, u8 type)
 	return NULL;
 }
 
+static void mxt_proc_t6_messages(struct mxt_data *data, u8 *msg)
+{
+	struct device *dev = &data->client->dev;
+	u8 status = msg[1];
+	u32 crc = msg[2] | (msg[3] << 8) | (msg[4] << 16);
+
+	complete(&data->crc_completion);
+
+	if (crc != data->config_crc) {
+		data->config_crc = crc;
+		dev_dbg(dev, "T6 Config Checksum: 0x%06X\n", crc);
+	}
+
+	/* Detect reset */
+	if (status & MXT_T6_STATUS_RESET)
+		complete(&data->reset_completion);
+
+	/* Output debug if status has changed */
+	if (status != data->t6_status)
+		dev_dbg(dev, "T6 Status 0x%02X%s%s%s%s%s%s%s\n",
+			status,
+			status == 0 ? " OK" : "",
+			status & MXT_T6_STATUS_RESET ? " RESET" : "",
+			status & MXT_T6_STATUS_OFL ? " OFL" : "",
+			status & MXT_T6_STATUS_SIGERR ? " SIGERR" : "",
+			status & MXT_T6_STATUS_CAL ? " CAL" : "",
+			status & MXT_T6_STATUS_CFGERR ? " CFGERR" : "",
+			status & MXT_T6_STATUS_COMSERR ? " COMSERR" : "");
+
+	/* Save current status */
+	data->t6_status = status;
+}
+
 static int mxt_read_message(struct mxt_data *data, u8 *message)
 {
 	struct mxt_object *object;
@@ -728,11 +767,6 @@ static void mxt_input_touchevent(struct mxt_data *data, u8 *message)
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
@@ -742,11 +776,9 @@ static bool mxt_is_T9_message(struct mxt_data *data, u8 *msg)
 static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 {
 	u8 *message = &data->msg_buf[0];
-	const u8 *payload = &data->msg_buf[1];
 	struct device *dev = &data->client->dev;
 	u8 reportid;
 	bool update_input = false;
-	u32 crc;
 
 	do {
 		if (mxt_read_message(data, message)) {
@@ -757,19 +789,7 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 		reportid = message[0];
 
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
 		} else if (!data->input_dev) {
 			/*
 			 * do not report events if input device
-- 
2.0.1

