Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab3BVSMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:12:55 -0500
Received: from [89.21.227.133] ([89.21.227.133]:53942 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759068Ab3BVSIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:36 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 39/40] Input: atmel_mxt_ts - Add regulator control support
Date: Fri, 22 Feb 2013 17:58:26 +0000
Message-Id: <1361555907-19840-40-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the driver to optionally manage enabling/disable power to the touch
controller itself. If the regulators are not present then use the deep sleep
power mode instead.

For a correct power on sequence, it is required that we have control over the
RESET line.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   95 +++++++++++++++++++++++++++---
 include/linux/i2c/atmel_mxt_ts.h         |    1 +
 2 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 1c878fb..24c262c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -21,6 +21,8 @@
 #include <linux/input/mt.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/regulator/consumer.h>
+#include <linux/gpio.h>
 
 /* Firmware files */
 #define MXT_FW_NAME		"maxtouch.fw"
@@ -152,6 +154,8 @@ static unsigned long mxt_t15_keystatus;
 #define MXT_RESET_NOCHGREAD	200	/* msec */
 #define MXT_FWRESET_TIME	1000	/* msec */
 #define MXT_WAKEUP_TIME		25	/* msec */
+#define MXT_REGULATOR_DELAY	150	/* msec */
+#define MXT_POWERON_DELAY	150	/* msec */
 
 /* Command to unlock bootloader */
 #define MXT_UNLOCK_CMD_MSB	0xaa
@@ -221,6 +225,10 @@ struct mxt_data {
 	u8 num_touchids;
 	u8 num_stylusids;
 	u8(*read_chg) (void);
+	bool use_regulator;
+	unsigned long gpio_reset;
+	struct regulator *reg_vdd;
+	struct regulator *reg_avdd;
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -1657,12 +1665,71 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 	return 0;
 }
 
+static void mxt_regulator_enable(struct mxt_data *data)
+{
+	gpio_set_value(data->gpio_reset, 0);
+	regulator_enable(data->reg_vdd);
+	regulator_enable(data->reg_avdd);
+	msleep(MXT_REGULATOR_DELAY);
+	gpio_set_value(data->gpio_reset, 1);
+	mxt_wait_for_chg(data, MXT_POWERON_DELAY);
+}
+
+static void mxt_regulator_disable(struct mxt_data *data)
+{
+	regulator_disable(data->reg_vdd);
+	regulator_disable(data->reg_avdd);
+}
+
+static void mxt_probe_regulators(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	int error;
+
+	/* According to maXTouch power sequencing specification, RESET line
+	 * must be kept low until some time after regulators come up to
+	 * voltage */
+	if (!data->gpio_reset) {
+		dev_warn(dev, "Must have reset GPIO to use regulator support\n");
+		goto fail;
+	}
+
+	data->reg_vdd = regulator_get(dev, "vdd");
+	if (IS_ERR(data->reg_vdd)) {
+		error = PTR_ERR(data->reg_vdd);
+		dev_err(dev, "Error %d getting vdd regulator\n", error);
+		goto fail;
+	}
+
+	data->reg_avdd = regulator_get(dev, "avdd");
+	if (IS_ERR(data->reg_vdd)) {
+		error = PTR_ERR(data->reg_vdd);
+		dev_err(dev, "Error %d getting avdd regulator\n", error);
+		goto fail_release;
+	}
+
+	data->use_regulator = true;
+	mxt_regulator_enable(data);
+
+	dev_dbg(dev, "Initialised regulators\n");
+	return;
+
+fail_release:
+	regulator_put(data->reg_vdd);
+fail:
+	data->reg_vdd = NULL;
+	data->reg_avdd = NULL;
+	data->use_regulator = false;
+}
+
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
 	int error;
 	u8 retry_count = 0;
 
+	mxt_probe_regulators(data);
+
 retry_probe:
 	error = mxt_read_info_block(data);
 	if (error) {
@@ -2067,27 +2134,34 @@ static void mxt_reset_slots(struct mxt_data *data)
 
 static void mxt_start(struct mxt_data *data)
 {
-	/* Discard any messages still in message buffer from before chip went
-	 * to sleep */
-	mxt_process_messages_until_invalid(data);
+	if (data->use_regulator) {
+		mxt_regulator_enable(data);
+	} else {
+		/* Discard any messages still in message buffer from before chip went
+		 * to sleep */
+		mxt_process_messages_until_invalid(data);
+
+		mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
 
-	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
+		/* Recalibrate since chip has been in deep sleep */
+		mxt_t6_command(data, MXT_COMMAND_CALIBRATE, 1, false);
+	}
 
 	if (data->state != APPMODE) {
 		enable_irq(data->irq);
 		data->state = APPMODE;
 	}
-
-	/* Recalibrate since chip has been in deep sleep */
-	mxt_t6_command(data, MXT_COMMAND_CALIBRATE, 1, false);
 }
 
 static void mxt_stop(struct mxt_data *data)
 {
-	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_DEEPSLEEP);
-
 	disable_irq(data->irq);
 
+	if (data->use_regulator)
+		mxt_regulator_disable(data);
+	else
+		mxt_set_t7_power_cfg(data, MXT_POWER_CFG_DEEPSLEEP);
+
 	data->state = SUSPEND;
 
 	mxt_reset_slots(data);
@@ -2223,6 +2297,7 @@ static int mxt_probe(struct i2c_client *client,
 	data->client = client;
 	data->pdata = pdata;
 	data->read_chg = pdata->read_chg;
+	data->gpio_reset = pdata->gpio_reset;
 	data->irq = client->irq;
 	i2c_set_clientdata(client, data);
 
@@ -2289,6 +2364,8 @@ static int mxt_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
+	regulator_put(data->reg_avdd);
+	regulator_put(data->reg_vdd);
 	mxt_free_object_table(data);
 	kfree(data);
 
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index b96b265..a952cbe 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -20,6 +20,7 @@ struct mxt_platform_data {
 	unsigned long irqflags;
 	u8(*read_chg) (void);
 	const char *input_name;
+	unsigned long gpio_reset;
 };
 
 #endif /* __LINUX_ATMEL_MXT_TS_H */
-- 
1.7.10.4

