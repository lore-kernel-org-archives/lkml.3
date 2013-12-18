Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab3LRJWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:22:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51617 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab3LRJWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:22:25 -0500
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <jcbian@pixcir.com.cn>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 3/9] Input: pixcir_i2c_ts: Initialize interrupt mode and power mode
Date: Wed, 18 Dec 2013 14:51:14 +0530
Message-ID: <1387358480-8313-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387358480-8313-1-git-send-email-rogerq@ti.com>
References: <1387358480-8313-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper functions to configure power and interrupt
registers. Default to IDLE mode on probe as device supports
auto wakeup to ACVIE mode on detecting finger touch.

Configure interrupt mode and polarity on start up.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 drivers/input/touchscreen/pixcir_i2c_ts.c | 168 ++++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 3a447c9..ce8abcd 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -104,6 +104,160 @@ static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int pixcir_set_power_mode(struct pixcir_i2c_ts_data *ts,
+						enum pixcir_power_mode mode)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(ts->client, PIXCIR_REG_POWER_MODE);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't read reg 0x%x : %d\n",
+					__func__, PIXCIR_REG_POWER_MODE, ret);
+		return ret;
+	}
+
+	ret &= ~PIXCIR_POWER_MODE_MASK;
+	ret |= mode;
+
+	/* Always AUTO_IDLE */
+	ret |= PIXCIR_POWER_ALLOW_IDLE;
+
+	ret = i2c_smbus_write_byte_data(ts->client, PIXCIR_REG_POWER_MODE, ret);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't write reg 0x%x : %d\n",
+					__func__, PIXCIR_REG_POWER_MODE, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Set the interrupt mode for the device i.e. ATTB line behaviour
+ *
+ * @polarity : 1 for active high, 0 for active low.
+ */
+static int pixcir_set_int_mode(struct pixcir_i2c_ts_data *ts,
+						enum pixcir_int_mode mode,
+					bool polarity)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(ts->client, PIXCIR_REG_INT_MODE);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't read reg 0x%x : %d\n",
+					__func__, PIXCIR_REG_INT_MODE, ret);
+		return ret;
+	}
+
+	ret &= ~PIXCIR_INT_MODE_MASK;
+	ret |= mode;
+
+	if (polarity)
+		ret |= PIXCIR_INT_POL_HIGH;
+	else
+		ret &= ~PIXCIR_INT_POL_HIGH;
+
+	ret = i2c_smbus_write_byte_data(ts->client, PIXCIR_REG_INT_MODE, ret);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't write reg 0x%x : %d\n",
+					__func__, PIXCIR_REG_INT_MODE, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Enable/disable interrupt generation
+ */
+static int pixcir_int_enable(struct pixcir_i2c_ts_data *ts, bool enable)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(ts->client, PIXCIR_REG_INT_MODE);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't read reg 0x%x : %d\n",
+					__func__, PIXCIR_REG_INT_MODE, ret);
+		return ret;
+	}
+
+	if (enable)
+		ret |= PIXCIR_INT_ENABLE;
+	else
+		ret &= ~PIXCIR_INT_ENABLE;
+
+	ret = i2c_smbus_write_byte_data(ts->client, PIXCIR_REG_INT_MODE, ret);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't write reg 0x%x : %d\n",
+					__func__, PIXCIR_REG_INT_MODE, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int pixcir_start(struct pixcir_i2c_ts_data *ts)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	/* LEVEL_TOUCH interrupt with active low polarity */
+	ret = pixcir_set_int_mode(ts, PIXCIR_INT_LEVEL_TOUCH, 0);
+	if (ret) {
+		dev_err(dev, "Failed to set interrupt mode\n");
+		return ret;
+	}
+
+	enable_irq(ts->client->irq);
+
+	/* enable interrupt generation */
+	ret = pixcir_int_enable(ts, 1);
+	if (ret) {
+		dev_err(dev, "Failed to enable interrupt generation\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int pixcir_stop(struct pixcir_i2c_ts_data *ts)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	/* disable interrupt generation */
+	ret = pixcir_int_enable(ts, 0);
+	if (ret) {
+		dev_err(dev, "Failed to disable interrupt generation\n");
+		return ret;
+	}
+
+	disable_irq(ts->client->irq);
+
+	return 0;
+}
+
+static int pixcir_input_open(struct input_dev *dev)
+{
+	struct pixcir_i2c_ts_data *ts = input_get_drvdata(dev);
+
+	return pixcir_start(ts);
+}
+
+static void pixcir_input_close(struct input_dev *dev)
+{
+	struct pixcir_i2c_ts_data *ts = input_get_drvdata(dev);
+
+	pixcir_stop(ts);
+
+	return;
+}
+
+
 #ifdef CONFIG_PM_SLEEP
 static int pixcir_i2c_ts_suspend(struct device *dev)
 {
@@ -207,6 +361,8 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 	input->name = client->name;
 	input->id.bustype = BUS_I2C;
 	input->dev.parent = &client->dev;
+	input->open = pixcir_input_open;
+	input->close = pixcir_input_close;
 
 	__set_bit(EV_KEY, input->evbit);
 	__set_bit(EV_ABS, input->evbit);
@@ -230,6 +386,18 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 		goto err_free_mem;
 	}
 
+	/* Always be in IDLE mode to save power, device supports auto wake */
+	error = pixcir_set_power_mode(tsdata, PIXCIR_POWER_IDLE);
+	if (error) {
+		dev_err(dev, "Failed to set IDLE mode\n");
+		return error;
+	}
+
+	/* Stop device till opened */
+	error = pixcir_stop(tsdata);
+	if (error)
+		goto err_free_irq;
+
 	error = input_register_device(input);
 	if (error)
 		goto err_free_irq;
-- 
1.8.3.2

