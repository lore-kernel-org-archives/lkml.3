Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaJ2AbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:31:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:53054 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbaJ2AbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:31:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="407565438"
From: jagadish.krishnamoorthy@intel.com
To: dmitry.torokhov@gmail.com, bleung@chromium.org, dusonlin@emc.com.tw
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jagadish Krishnamoorthy <jagadish.krishnamoorthy@intel.com>
Subject: [PATCH] input: add gpio based irq support to Elan touchpad
Date: Tue, 28 Oct 2014 17:27:24 -0700
Message-Id: <1414542444-27184-1-git-send-email-jagadish.krishnamoorthy@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jagadish Krishnamoorthy <jagadish.krishnamoorthy@intel.com>

Adding new member 'irq' in main device structure.
On some of the platforms, gpio is passed in platform data
instead of irq. Convert the gpio to irq and store it in the
driver data.

Signed-off-by: Jagadish Krishnamoorthy <jagadish.krishnamoorthy@intel.com>
---
 drivers/input/mouse/elan_i2c.h       |    3 ++-
 drivers/input/mouse/elan_i2c_core.c  |   44 ++++++++++++++++++++++++----------
 drivers/input/mouse/elan_i2c_i2c.c   |    7 +++---
 drivers/input/mouse/elan_i2c_smbus.c |    3 ++-
 4 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/input/mouse/elan_i2c.h b/drivers/input/mouse/elan_i2c.h
index 2e83862..bb94a96 100644
--- a/drivers/input/mouse/elan_i2c.h
+++ b/drivers/input/mouse/elan_i2c.h
@@ -76,7 +76,8 @@ struct elan_transport_ops {
 	int (*write_fw_block)(struct i2c_client *client,
 			      const u8 *page, u16 checksum, int idx);
 	int (*finish_fw_update)(struct i2c_client *client,
-				struct completion *reset_done);
+				struct completion *reset_done,
+				unsigned int irq);
 
 	int (*get_report)(struct i2c_client *client, u8 *report);
 };
diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index 0cb2be4..9c5c5d3 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -35,6 +35,7 @@
 #include <linux/completion.h>
 #include <linux/of.h>
 #include <linux/regulator/consumer.h>
+#include <linux/gpio.h>
 #include <asm/unaligned.h>
 
 #include "elan_i2c.h"
@@ -75,6 +76,7 @@ struct elan_tp_data {
 	unsigned int		width_y;
 	unsigned int		x_res;
 	unsigned int		y_res;
+	unsigned int		irq;
 
 	u8			product_id;
 	u8			fw_version;
@@ -331,7 +333,8 @@ static int __elan_update_firmware(struct elan_tp_data *data,
 	/* Wait WDT reset and power on reset */
 	msleep(600);
 
-	error = data->ops->finish_fw_update(client, &data->fw_completion);
+	error = data->ops->finish_fw_update(client, &data->fw_completion,
+					    data->irq);
 	if (error)
 		return error;
 
@@ -356,7 +359,7 @@ static int elan_update_firmware(struct elan_tp_data *data,
 
 	dev_dbg(&client->dev, "Starting firmware update....\n");
 
-	disable_irq(client->irq);
+	disable_irq(data->irq);
 	data->in_fw_update = true;
 
 	retval = __elan_update_firmware(data, fw);
@@ -370,7 +373,7 @@ static int elan_update_firmware(struct elan_tp_data *data,
 	}
 
 	data->in_fw_update = false;
-	enable_irq(client->irq);
+	enable_irq(data->irq);
 
 	return retval;
 }
@@ -482,7 +485,7 @@ static ssize_t calibrate_store(struct device *dev,
 	if (retval)
 		return retval;
 
-	disable_irq(client->irq);
+	disable_irq(data->irq);
 
 	data->mode |= ETP_ENABLE_CALIBRATE;
 	retval = data->ops->set_mode(client, data->mode);
@@ -528,7 +531,7 @@ out_disable_calibrate:
 			retval = error;
 	}
 out:
-	enable_irq(client->irq);
+	enable_irq(data->irq);
 	mutex_unlock(&data->sysfs_mutex);
 	return retval ?: count;
 }
@@ -594,7 +597,7 @@ static ssize_t acquire_store(struct device *dev, struct device_attribute *attr,
 	if (retval)
 		return retval;
 
-	disable_irq(client->irq);
+	disable_irq(data->irq);
 
 	data->baseline_ready = false;
 
@@ -636,7 +639,7 @@ out_disable_calibrate:
 			retval = error;
 	}
 out:
-	enable_irq(client->irq);
+	enable_irq(data->irq);
 	mutex_unlock(&data->sysfs_mutex);
 	return retval ?: count;
 }
@@ -900,6 +903,7 @@ static int elan_probe(struct i2c_client *client,
 	const struct elan_transport_ops *transport_ops;
 	struct device *dev = &client->dev;
 	struct elan_tp_data *data;
+	struct gpio_desc *desc;
 	unsigned long irqflags;
 	int error;
 
@@ -992,17 +996,31 @@ static int elan_probe(struct i2c_client *client,
 		return error;
 
 	/*
+	 * Check for the irq number in platform data.
+	 * If that fails check for gpio based irq.
+	 */
+	if (client->irq >= 0) {
+		data->irq = client->irq;
+	} else {
+		desc = devm_gpiod_get_index(&client->dev, "ELAN_GPIO_IRQ", 0);
+		if (IS_ERR(desc) || gpiod_direction_input(desc)) {
+			dev_err(&client->dev, "failed to initialize gpio\n");
+			return error;
+		}
+		data->irq = gpiod_to_irq(desc);
+	}
+	/*
 	 * Systems using device tree should set up interrupt via DTS,
 	 * the rest will use the default falling edge interrupts.
 	 */
 	irqflags = client->dev.of_node ? 0 : IRQF_TRIGGER_FALLING;
 
-	error = devm_request_threaded_irq(&client->dev, client->irq,
+	error = devm_request_threaded_irq(&client->dev, data->irq,
 					  NULL, elan_isr,
 					  irqflags | IRQF_ONESHOT,
 					  client->name, data);
 	if (error) {
-		dev_err(&client->dev, "cannot register irq=%d\n", client->irq);
+		dev_err(&client->dev, "cannot register irq=%d\n", data->irq);
 		return error;
 	}
 
@@ -1055,12 +1073,12 @@ static int __maybe_unused elan_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
-	disable_irq(client->irq);
+	disable_irq(data->irq);
 
 	if (device_may_wakeup(dev)) {
 		ret = elan_sleep(data);
 		/* Enable wake from IRQ */
-		data->irq_wake = (enable_irq_wake(client->irq) == 0);
+		data->irq_wake = (enable_irq_wake(data->irq) == 0);
 	} else {
 		ret = elan_disable_power(data);
 	}
@@ -1076,7 +1094,7 @@ static int __maybe_unused elan_resume(struct device *dev)
 	int error;
 
 	if (device_may_wakeup(dev) && data->irq_wake) {
-		disable_irq_wake(client->irq);
+		disable_irq_wake(data->irq);
 		data->irq_wake = false;
 	}
 
@@ -1088,7 +1106,7 @@ static int __maybe_unused elan_resume(struct device *dev)
 	if (error)
 		dev_err(dev, "initialize when resuming failed: %d\n", error);
 
-	enable_irq(data->client->irq);
+	enable_irq(data->irq);
 
 	return 0;
 }
diff --git a/drivers/input/mouse/elan_i2c_i2c.c b/drivers/input/mouse/elan_i2c_i2c.c
index 97d4937..5e897cd 100644
--- a/drivers/input/mouse/elan_i2c_i2c.c
+++ b/drivers/input/mouse/elan_i2c_i2c.c
@@ -520,7 +520,8 @@ static int elan_i2c_write_fw_block(struct i2c_client *client,
 }
 
 static int elan_i2c_finish_fw_update(struct i2c_client *client,
-				     struct completion *completion)
+				     struct completion *completion,
+				     unsigned int irq)
 {
 	struct device *dev = &client->dev;
 	long ret;
@@ -529,13 +530,13 @@ static int elan_i2c_finish_fw_update(struct i2c_client *client,
 	u8 buffer[ETP_I2C_INF_LENGTH];
 
 	reinit_completion(completion);
-	enable_irq(client->irq);
+	enable_irq(irq);
 
 	error = elan_i2c_write_cmd(client, ETP_I2C_STAND_CMD, ETP_I2C_RESET);
 	if (!error)
 		ret = wait_for_completion_interruptible_timeout(completion,
 							msecs_to_jiffies(300));
-	disable_irq(client->irq);
+	disable_irq(irq);
 
 	if (error) {
 		dev_err(dev, "device reset failed: %d\n", error);
diff --git a/drivers/input/mouse/elan_i2c_smbus.c b/drivers/input/mouse/elan_i2c_smbus.c
index 359bf85..a81b8fb 100644
--- a/drivers/input/mouse/elan_i2c_smbus.c
+++ b/drivers/input/mouse/elan_i2c_smbus.c
@@ -477,7 +477,8 @@ static int elan_smbus_get_report(struct i2c_client *client, u8 *report)
 }
 
 static int elan_smbus_finish_fw_update(struct i2c_client *client,
-				       struct completion *fw_completion)
+				       struct completion *fw_completion,
+				       unsigned int irq)
 {
 	/* No special handling unlike I2C transport */
 	return 0;
-- 
1.7.9.5

