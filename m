Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbaGCPIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:08:20 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:45721 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758183AbaGCPIN (ORCPT
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
Subject: [PATCH 07/15] Input: atmel_mxt_ts - use deep sleep mode when stopped
Date: Thu,  3 Jul 2014 16:01:29 +0100
Message-Id: <1404399697-26484-8-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

By writing zero to both the active and idle cycle times the maXTouch device
is put into a deep sleep mode when it consumes minimal power. It is
unnecessary to change the configuration of any other objects (for example
to disable T9 touchscreen).

It is counterproductive to reset the chip on resume, it will result in a
long delay. However it is necessary to issue a calibrate command after the
chip has spent any time in deep sleep.

This patch also deals with the situation where the power configuration is
zero on probe, which would mean that the device never wakes up to execute
commands.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 99 +++++++++++++++++++++++---------
 1 file changed, 73 insertions(+), 26 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 90c2c4b..9b0cccd 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -91,9 +91,13 @@
 #define MXT_T6_STATUS_RESET	(1 << 7)
 
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
@@ -105,7 +109,6 @@
 #define MXT_ACQUIRE_ATCHCALSTHR	7
 
 /* MXT_TOUCH_MULTI_T9 field */
-#define MXT_TOUCH_CTRL		0
 #define MXT_T9_ORIENT		9
 #define MXT_T9_RANGE		18
 
@@ -244,6 +247,7 @@ struct mxt_data {
 	u32 config_crc;
 	u32 info_crc;
 	u8 bootloader_addr;
+	struct t7_config t7_cfg;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
@@ -602,20 +606,6 @@ static int mxt_read_message(struct mxt_data *data,
 			sizeof(struct mxt_message), message);
 }
 
-static int mxt_write_object(struct mxt_data *data,
-				 u8 type, u8 offset, u8 val)
-{
-	struct mxt_object *object;
-	u16 reg;
-
-	object = mxt_get_object(data, type);
-	if (!object || offset >= mxt_obj_size(object))
-		return -EINVAL;
-
-	reg = object->start_address;
-	return mxt_write_reg(data->client, reg + offset, val);
-}
-
 static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
 {
 	struct input_dev *input = data->input_dev;
@@ -1153,6 +1143,60 @@ release:
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
+				sizeof(data->t7_cfg), new_config);
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
+			dev_dbg(dev, "T7 cfg zero, resetting\n");
+			mxt_soft_reset(data);
+			retry = true;
+			goto recheck;
+		} else {
+			dev_dbg(dev, "T7 cfg zero after reset, overriding\n");
+			data->t7_cfg.active = 20;
+			data->t7_cfg.idle = 100;
+			return mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
+		}
+	}
+
+	dev_dbg(dev, "Initialized power cfg: ACTV %d, IDLE %d\n",
+		data->t7_cfg.active, data->t7_cfg.idle);
+	return 0;
+}
+
 static int mxt_make_highchg(struct mxt_data *data)
 {
 	struct device *dev = &data->client->dev;
@@ -1489,6 +1533,12 @@ static int mxt_configure_objects(struct mxt_data *data,
 			dev_warn(dev, "Error %d updating config\n", error);
 	}
 
+	error = mxt_init_t7_power_cfg(data);
+	if (error) {
+		dev_err(dev, "Failed to initialize power cfg\n");
+		return error;
+	}
+
 	error = mxt_initialize_t9_input_device(data);
 	if (error)
 		return error;
@@ -1752,16 +1802,15 @@ static const struct attribute_group mxt_attr_group = {
 
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
@@ -1916,8 +1965,6 @@ static int mxt_resume(struct device *dev)
 	struct mxt_data *data = i2c_get_clientdata(client);
 	struct input_dev *input_dev = data->input_dev;
 
-	mxt_soft_reset(data);
-
 	mutex_lock(&input_dev->mutex);
 
 	if (input_dev->users)
-- 
2.0.1

