Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3F0Mxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:53:39 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:36964 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753691Ab3F0Mux (ORCPT
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
Subject: [PATCH 45/51] Input: atmel_mxt_ts - Release touch state during suspend
Date: Thu, 27 Jun 2013 13:49:20 +0100
Message-Id: <1372337366-9286-46-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
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
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   46 ++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index ceb090a..b4ecd1d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -249,6 +249,9 @@ struct mxt_data {
 
 	/* Enable reporting of input events */
 	bool enable_reporting;
+
+	/* Indicates whether device is in suspend */
+	bool suspended;
 };
 
 static inline size_t mxt_obj_size(const struct mxt_object *obj)
@@ -2025,6 +2028,11 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	if (ret)
 		goto release_firmware;
 
+	if (data->suspended) {
+		enable_irq(data->irq);
+		data->suspended = false;
+	}
+
 	if (!data->in_bootloader) {
 		/* Change to the bootloader mode */
 		data->in_bootloader = true;
@@ -2137,6 +2145,8 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	} else {
 		dev_info(dev, "The firmware update succeeded\n");
 
+		data->suspended = false;
+
 		error = mxt_initialize(data);
 		if (error)
 			return error;
@@ -2162,17 +2172,53 @@ static const struct attribute_group mxt_attr_group = {
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
+	if (!data->suspended || data->in_bootloader)
+		return;
+
+	/* Discard any touch messages still in message buffer from before chip
+	 * went to sleep */
+	mxt_process_messages_until_invalid(data);
+
 	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
 
 	/* Recalibrate since chip has been in deep sleep */
 	mxt_t6_command(data, MXT_COMMAND_CALIBRATE, 1, false);
+
+	mxt_acquire_irq(data);
+	data->enable_reporting = true;
+	data->suspended = false;
 }
 
 static void mxt_stop(struct mxt_data *data)
 {
+	if (data->suspended || data->in_bootloader)
+		return;
+
+	data->enable_reporting = false;
+	disable_irq(data->irq);
+
 	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_DEEPSLEEP);
+
+	mxt_reset_slots(data);
+	data->suspended = true;
 }
 
 static int mxt_input_open(struct input_dev *dev)
-- 
1.7.10.4

