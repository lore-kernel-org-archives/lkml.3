Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab3FESBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:01:08 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:20962 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757057Ab3FERsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:10 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 49/53] Input: atmel_mxt_ts - Add regulator control support
Date: Wed,  5 Jun 2013 18:37:42 +0100
Message-Id: <1370453866-16534-50-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the driver to optionally manage enabling/disable power to the touch
controller itself. If the regulators are not present then use the deep sleep
power mode instead.

For a correct power on sequence, it is required that we have control over the
RESET line.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   95 +++++++++++++++++++++++++++---
 include/linux/i2c/atmel_mxt_ts.h         |    1 +
 2 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 8e19ab1..ce676a1 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -24,6 +24,8 @@
 #include <linux/input/mt.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/regulator/consumer.h>
+#include <linux/gpio.h>
 
 /* Firmware files */
 #define MXT_FW_NAME		"maxtouch.fw"
@@ -152,6 +154,8 @@ struct t9_range {
 #define MXT_FW_RESET_TIME	3000	/* msec */
 #define MXT_FW_CHG_TIMEOUT	300	/* msec */
 #define MXT_WAKEUP_TIME		25	/* msec */
+#define MXT_REGULATOR_DELAY	150	/* msec */
+#define MXT_POWERON_DELAY	150	/* msec */
 
 /* Command to unlock bootloader */
 #define MXT_UNLOCK_CMD_MSB	0xaa
@@ -220,6 +224,9 @@ struct mxt_data {
 	u8 num_stylusids;
 	unsigned long t15_keystatus;
 	bool use_retrigen_workaround;
+	bool use_regulator;
+	struct regulator *reg_vdd;
+	struct regulator *reg_avdd;
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -1843,6 +1850,66 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 	return 0;
 }
 
+static void mxt_regulator_enable(struct mxt_data *data)
+{
+	gpio_set_value(data->pdata->gpio_reset, 0);
+
+	regulator_enable(data->reg_vdd);
+	regulator_enable(data->reg_avdd);
+	msleep(MXT_REGULATOR_DELAY);
+
+	INIT_COMPLETION(data->bl_completion);
+	gpio_set_value(data->pdata->gpio_reset, 1);
+	mxt_wait_for_completion(data, &data->bl_completion, MXT_POWERON_DELAY);
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
+	if (!data->pdata->gpio_reset) {
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
@@ -2037,6 +2104,9 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		goto release_firmware;
 
 	if (data->suspended) {
+		if (data->use_regulator)
+			mxt_regulator_enable(data);
+
 		enable_irq(data->irq);
 		data->suspended = false;
 	}
@@ -2281,14 +2351,18 @@ static void mxt_start(struct mxt_data *data)
 	if (!data->suspended || data->in_bootloader)
 		return;
 
-	/* Discard any touch messages still in message buffer from before chip
-	 * went to sleep */
-	mxt_process_messages_until_invalid(data);
+	if (data->use_regulator) {
+		mxt_regulator_enable(data);
+	} else {
+		/* Discard any messages still in message buffer from before
+		 * chip went to sleep */
+		mxt_process_messages_until_invalid(data);
 
-	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
+		mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
 
-	/* Recalibrate since chip has been in deep sleep */
-	mxt_t6_command(data, MXT_COMMAND_CALIBRATE, 1, false);
+		/* Recalibrate since chip has been in deep sleep */
+		mxt_t6_command(data, MXT_COMMAND_CALIBRATE, 1, false);
+	}
 
 	mxt_acquire_irq(data);
 	data->enable_reporting = true;
@@ -2303,7 +2377,10 @@ static void mxt_stop(struct mxt_data *data)
 	data->enable_reporting = false;
 	disable_irq(data->irq);
 
-	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_DEEPSLEEP);
+	if (data->use_regulator)
+		mxt_regulator_disable(data);
+	else
+		mxt_set_t7_power_cfg(data, MXT_POWER_CFG_DEEPSLEEP);
 
 	mxt_reset_slots(data);
 	data->suspended = true;
@@ -2491,6 +2568,8 @@ static int mxt_probe(struct i2c_client *client,
 		goto err_free_pdata;
 	}
 
+	mxt_probe_regulators(data);
+
 	disable_irq(data->irq);
 
 	error = mxt_initialize(data);
@@ -2554,6 +2633,8 @@ static int mxt_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
+	regulator_put(data->reg_avdd);
+	regulator_put(data->reg_vdd);
 	mxt_free_object_table(data);
 	if (!dev_get_platdata(&data->client->dev))
 		kfree(data->pdata);
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index b7d2092..a01f2e8 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -22,6 +22,7 @@ struct mxt_platform_data {
 	const unsigned int *t19_keymap;
 	int t15_num_keys;
 	const unsigned int *t15_keymap;
+	unsigned long gpio_reset;
 };
 
 #endif /* __LINUX_ATMEL_MXT_TS_H */
-- 
1.7.10.4

