Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab3BVSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:09:27 -0500
Received: from [89.21.227.133] ([89.21.227.133]:55429 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759111Ab3BVSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:37 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 37/40] Input: atmel_mxt_ts - Release touch state during suspend
Date: Fri, 22 Feb 2013 17:58:24 +0000
Message-Id: <1361555907-19840-38-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fingers are down as the MXT chip goes into suspend it does not send a lift
message. In addition, it may not complete its final measurement cycle
immediately, which means touch messages may be received by the interrupt
handler after mxt_stop() has completed.

So:
- disable irq during suspend
- flush any messages created after suspend
- tell app layer that slots were released at suspend

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   36 +++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 79fe3ba..870ad65 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -192,7 +192,7 @@ struct mxt_object {
 	u8 num_report_ids;
 } __packed;
 
-enum mxt_device_state { INIT, APPMODE, BOOTLOADER, FAILED, SHUTDOWN };
+enum mxt_device_state { INIT, APPMODE, BOOTLOADER, FAILED, SHUTDOWN, SUSPEND };
 
 /* Each client has this additional data */
 struct mxt_data {
@@ -817,6 +817,9 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	u8 report_id = message[0];
 	bool handled = false;
 
+	if (data->state != APPMODE)
+		return 0;
+
 	if (report_id == MXT_RPTID_NOMSG)
 		return 0;
 
@@ -2043,10 +2046,35 @@ static const struct attribute_group mxt_attr_group = {
 	.attrs = mxt_attrs,
 };
 
+static void mxt_reset_slots(struct mxt_data *data)
+{
+	struct input_dev *input_dev = data->input_dev;
+	unsigned int num_mt_slots;
+	int id;
+
+	num_mt_slots = data->num_touchids + data->num_stylusids;
+
+	for (id = 0; id < num_mt_slots; id++) {
+		input_mt_slot(input_dev, id);
+		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
+	}
+
+	mxt_input_sync(input_dev);
+}
+
 static void mxt_start(struct mxt_data *data)
 {
+	/* Discard any messages still in message buffer from before chip went
+	 * to sleep */
+	mxt_process_messages_until_invalid(data);
+
 	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
 
+	if (data->state != APPMODE) {
+		enable_irq(data->irq);
+		data->state = APPMODE;
+	}
+
 	/* Recalibrate since chip has been in deep sleep */
 	mxt_t6_command(data, MXT_COMMAND_CALIBRATE, 1, false);
 }
@@ -2054,6 +2082,12 @@ static void mxt_start(struct mxt_data *data)
 static void mxt_stop(struct mxt_data *data)
 {
 	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_DEEPSLEEP);
+
+	disable_irq(data->irq);
+
+	data->state = SUSPEND;
+
+	mxt_reset_slots(data);
 }
 
 static int mxt_input_open(struct input_dev *dev)
-- 
1.7.10.4

