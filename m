Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3FESD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:03:26 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:21426 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756983Ab3FERsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:08 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 45/53] Input: atmel_mxt_ts - Use T18 RETRIGEN to handle IRQF_TRIGGER_LOW
Date: Wed,  5 Jun 2013 18:37:38 +0100
Message-Id: <1370453866-16534-46-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The workaround of reading all messages until an invalid is received is a way
of forcing the CHG line high, which means that when using edge-triggered
interrupts the interrupt can be acquired.

With level-triggered interrupts this is unnecessary.

Also, most recent maXTouch chips have a feature called RETRIGEN which, when
enabled, reasserts the interrupt line every cycle if there are messages
waiting. This also makes the workaround unnecessary.

Note: the RETRIGEN feature is only in some firmware versions/chips, it's not
valid simply to enable the bit.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   48 ++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index e0ff017..6631ef1 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -118,6 +118,7 @@ struct t9_range {
 /* MXT_SPT_COMMSCONFIG_T18 */
 #define MXT_COMMS_CTRL		0
 #define MXT_COMMS_CMD		1
+#define MXT_COMMS_RETRIGEN      (1 << 6)
 
 /* Define for MXT_GEN_COMMAND_T6 */
 #define MXT_BOOT_VALUE		0xa5
@@ -215,6 +216,7 @@ struct mxt_data {
 	u8 num_touchids;
 	u8 num_stylusids;
 	unsigned long t15_keystatus;
+	bool use_retrigen_workaround;
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -226,6 +228,7 @@ struct mxt_data {
 	u8 T9_reportid_max;
 	u8 T15_reportid_min;
 	u8 T15_reportid_max;
+	u16 T18_address;
 	u8 T19_reportid;
 	u8 T42_reportid_min;
 	u8 T42_reportid_max;
@@ -1185,6 +1188,31 @@ static u32 mxt_calculate_crc(u8 *base, off_t start_off, off_t end_off)
 	return crc;
 }
 
+static int mxt_check_retrigen(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	int error;
+	int val;
+
+	if (data->pdata->irqflags & IRQF_TRIGGER_LOW)
+		return 0;
+
+	if (data->T18_address) {
+		error = __mxt_read_reg(client,
+				       data->T18_address + MXT_COMMS_CTRL,
+				       1, &val);
+		if (error)
+			return error;
+
+		if (val & MXT_COMMS_RETRIGEN)
+			return 0;
+	}
+
+	dev_warn(&client->dev, "Enabling RETRIGEN workaround\n");
+	data->use_retrigen_workaround = true;
+	return 0;
+}
+
 /*
  * mxt_check_reg_init - download configuration to chip
  *
@@ -1434,6 +1462,10 @@ static int mxt_check_reg_init(struct mxt_data *data)
 
 	mxt_update_crc(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE);
 
+	ret = mxt_check_retrigen(data);
+	if (ret)
+		goto release_mem;
+
 	ret = mxt_soft_reset(data);
 	if (ret)
 		goto release_mem;
@@ -1508,9 +1540,11 @@ static int mxt_acquire_irq(struct mxt_data *data)
 
 	enable_irq(data->irq);
 
-	error = mxt_process_messages_until_invalid(data);
-	if (error)
-		return error;
+	if (data->use_retrigen_workaround) {
+		error = mxt_process_messages_until_invalid(data);
+		if (error)
+			return error;
+	}
 
 	return 0;
 }
@@ -1532,6 +1566,7 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T9_reportid_max = 0;
 	data->T15_reportid_min = 0;
 	data->T15_reportid_max = 0;
+	data->T18_address = 0;
 	data->T19_reportid = 0;
 	data->T42_reportid_min = 0;
 	data->T42_reportid_max = 0;
@@ -1602,6 +1637,9 @@ static int mxt_parse_object_table(struct mxt_data *data)
 			data->T15_reportid_min = min_id;
 			data->T15_reportid_max = max_id;
 			break;
+		case MXT_SPT_COMMSCONFIG_T18:
+			data->T18_address = object->start_address;
+			break;
 		case MXT_PROCI_TOUCHSUPPRESSION_T42:
 			data->T42_reportid_min = min_id;
 			data->T42_reportid_max = max_id;
@@ -1823,6 +1861,10 @@ retry_bootloader:
 		}
 	}
 
+	error = mxt_check_retrigen(data);
+	if (error)
+		goto err_free_object_table;
+
 	error = mxt_acquire_irq(data);
 	if (error)
 		goto err_free_object_table;
-- 
1.7.10.4

