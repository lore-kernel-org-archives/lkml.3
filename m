Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3F0M4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:56:42 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:40495 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753607Ab3F0Mut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:49 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 35/51] Input: atmel_mxt_ts - Output status from T48 Noise Supression
Date: Thu, 27 Jun 2013 13:49:10 +0100
Message-Id: <1372337366-9286-36-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 5d51133..d7ce38d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -267,6 +267,7 @@ struct mxt_data {
 	u8 T9_reportid_max;
 	u8 T19_reportid;
 	u16 T44_address;
+	u8 T48_reportid;
 
 	/* for fw update in bootloader */
 	struct completion bl_completion;
@@ -768,6 +769,26 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	data->update_input = true;
 }
 
+static int mxt_proc_t48_messages(struct mxt_data *data, u8 *msg)
+{
+	struct device *dev = &data->client->dev;
+	u8 status, state;
+
+	status = msg[1];
+	state  = msg[4];
+
+	dev_dbg(dev, "T48 state %d status %02X %s%s%s%s%s\n",
+			state,
+			status,
+			(status & 0x01) ? "FREQCHG " : "",
+			(status & 0x02) ? "APXCHG " : "",
+			(status & 0x04) ? "ALGOERR " : "",
+			(status & 0x10) ? "STATCHG " : "",
+			(status & 0x20) ? "NLVLCHG " : "");
+
+	return 0;
+}
+
 static int mxt_proc_message(struct mxt_data *data, u8 *message)
 {
 	u8 report_id = message[0];
@@ -783,6 +804,8 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	} else if (report_id == data->T19_reportid) {
 		mxt_input_button(data, message);
 		data->update_input = true;
+	} else if (report_id == data->T48_reportid) {
+		mxt_proc_t48_messages(data, message);
 	} else {
 		mxt_dump_message(data, message);
 	}
@@ -1420,6 +1443,7 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T9_reportid_max = 0;
 	data->T19_reportid = 0;
 	data->T44_address = 0;
+	data->T48_reportid = 0;
 	data->max_reportid = 0;
 }
 
@@ -1493,6 +1517,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 		case MXT_SPT_GPIOPWM_T19:
 			data->T19_reportid = min_id;
 			break;
+		case MXT_PROCG_NOISESUPPRESSION_T48:
+			data->T48_reportid = min_id;
+			break;
 		}
 
 		end_address = object->start_address
-- 
1.7.10.4

