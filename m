Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab3BVSJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:09:38 -0500
Received: from [89.21.227.133] ([89.21.227.133]:15194 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759079Ab3BVSIh (ORCPT
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
Subject: [PATCH 13/40] Input: atmel_mxt_ts - Use deep sleep mode when stopped
Date: Fri, 22 Feb 2013 17:58:00 +0000
Message-Id: <1361555907-19840-14-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By writing zero to both the active and idle cycle times the maXTouch device is
put into a deep sleep mode when it consumes no power.

It is counterproductive to reset the chip on resume, it will result in a long
delay. The power consumption in deep sleep mode is minimal.  However it is
necessary to issue a calibrate command after the chip has spent any time in
deep sleep.

This patch also deals with the situation where the power configuration is zero
on probe, which would mean that the device never wakes up to execute commands.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  107 +++++++++++++++++++++---------
 1 file changed, 77 insertions(+), 30 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index e1f2bd3..bbe9aff 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -87,9 +87,13 @@
 #define MXT_COMMAND_DIAGNOSTIC	5
 
 /* MXT_GEN_POWER_T7 field */
-#define MXT_POWER_IDLEACQINT	0
-#define MXT_POWER_ACTVACQINT	1
-#define MXT_POWER_ACTV2IDLETO	2
+struct t7_config {
+	u8 idle;
+	u8 active;
+} __packed;
+
+#define MXT_POWER_CFG_RUN		0
+#define MXT_POWER_CFG_DEEPSLEEP		1
 
 /* MXT_GEN_ACQUIRE_T8 field */
 #define MXT_ACQUIRE_CHRGTIME	0
@@ -101,7 +105,6 @@
 #define MXT_ACQUIRE_ATCHCALSTHR	7
 
 /* MXT_TOUCH_MULTI_T9 field */
-#define MXT_TOUCH_CTRL		0
 #define MXT_T9_ORIENT		9
 #define MXT_T9_RANGE		18
 
@@ -243,6 +246,7 @@ struct mxt_data {
 	u32 config_crc;
 	u32 info_crc;
 	u8 bootloader_addr;
+	struct t7_config t7_cfg;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
@@ -576,20 +580,6 @@ static int mxt_read_message(struct mxt_data *data,
 			sizeof(struct mxt_message), message);
 }
 
-static int mxt_write_object(struct mxt_data *data,
-				 u8 type, u8 offset, u8 val)
-{
-	struct mxt_object *object;
-	u16 reg;
-
-	object = mxt_get_object(data, type);
-	if (!object || offset >= OBP_SIZE(object))
-		return -EINVAL;
-
-	reg = object->start_address;
-	return mxt_write_reg(data->client, reg + offset, val);
-}
-
 static void mxt_input_touchevent(struct mxt_data *data,
 				      struct mxt_message *message, int id)
 {
@@ -1042,6 +1032,64 @@ release:
 	return ret;
 }
 
+static int mxt_set_t7_power_cfg(struct mxt_data *data, u8 sleep)
+{
+	struct device *dev = &data->client->dev;
+	int error;
+	struct t7_config *new_config;
+	struct t7_config deepsleep = { .active = 0, .idle = 0 };
+
+	if (sleep == MXT_POWER_CFG_DEEPSLEEP)
+		new_config = &deepsleep;
+	else
+		new_config = &data->t7_cfg;
+
+	error = __mxt_write_reg(data->client, data->T7_address,
+			sizeof(data->t7_cfg),
+			new_config);
+	if (error)
+		return error;
+
+	dev_dbg(dev, "Set T7 ACTV:%d IDLE:%d\n",
+		new_config->active, new_config->idle);
+
+	return 0;
+}
+
+static int mxt_init_t7_power_cfg(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	int error;
+	bool retry = false;
+
+recheck:
+	error = __mxt_read_reg(data->client, data->T7_address,
+				sizeof(data->t7_cfg), &data->t7_cfg);
+	if (error)
+		return error;
+
+	if (data->t7_cfg.active == 0 || data->t7_cfg.idle == 0) {
+		if (!retry) {
+			dev_info(dev, "T7 cfg zero, resetting\n");
+			error = mxt_soft_reset(data, MXT_RESET_VALUE);
+			if (error)
+				return error;
+
+			retry = true;
+			goto recheck;
+		} else {
+		    dev_dbg(dev, "T7 cfg zero after reset, overriding\n");
+		    data->t7_cfg.active = 20;
+		    data->t7_cfg.idle = 100;
+		    return mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
+		}
+	} else {
+		dev_info(dev, "Initialised power cfg: ACTV %d, IDLE %d\n",
+				data->t7_cfg.active, data->t7_cfg.idle);
+		return 0;
+	}
+}
+
 static int mxt_make_highchg(struct mxt_data *data)
 {
 	struct device *dev = &data->client->dev;
@@ -1249,6 +1297,12 @@ static int mxt_initialize(struct mxt_data *data)
 		return error;
 	}
 
+	error = mxt_init_t7_power_cfg(data);
+	if (error) {
+		dev_err(&client->dev, "Failed to initialize power cfg\n");
+		return error;
+	}
+
 	error = mxt_read_t9_resolution(data);
 	if (error)
 		dev_warn(&client->dev, "Failed to initialize T9 resolution\n");
@@ -1583,16 +1637,15 @@ static const struct attribute_group mxt_attr_group = {
 
 static void mxt_start(struct mxt_data *data)
 {
-	/* Touch enable */
-	mxt_write_object(data,
-			MXT_TOUCH_MULTI_T9, MXT_TOUCH_CTRL, 0x83);
+	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
+
+	/* Recalibrate since chip has been in deep sleep */
+	mxt_t6_command(data, MXT_COMMAND_CALIBRATE, 1, false);
 }
 
 static void mxt_stop(struct mxt_data *data)
 {
-	/* Touch disable */
-	mxt_write_object(data,
-			MXT_TOUCH_MULTI_T9, MXT_TOUCH_CTRL, 0);
+	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_DEEPSLEEP);
 }
 
 static int mxt_input_open(struct input_dev *dev)
@@ -1776,12 +1829,6 @@ static int mxt_resume(struct device *dev)
 	struct mxt_data *data = i2c_get_clientdata(client);
 	struct input_dev *input_dev = data->input_dev;
 
-	/* Soft reset */
-	mxt_write_object(data, MXT_GEN_COMMAND_T6,
-			MXT_COMMAND_RESET, 1);
-
-	msleep(MXT_RESET_TIME);
-
 	mutex_lock(&input_dev->mutex);
 
 	if (input_dev->users)
-- 
1.7.10.4

